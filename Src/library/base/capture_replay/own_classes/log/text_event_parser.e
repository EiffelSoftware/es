indexing
	description: "[
				Event parser for the text based capture-log of capture/replay.
				]"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	TEXT_EVENT_PARSER

inherit
	EVENT_PARSER

create
	make

feature -- Access
	event_number: INTEGER
			-- number of currently parsed event.

feature -- Creation
	make(an_input: KI_TEXT_INPUT_STREAM; a_handler: EVENT_PARSER_HANDLER)
			-- Create the Parser with handler `a_handler', which reads from
			-- `an_input'
		require
			an_input_not_void: an_input /= Void
			a_handler_not_void: a_handler /= Void
		do
			input := an_input
			handler := a_handler
			handler.set_parser(Current)
		end

feature -- Basic operations

	parse_event
			-- Parse an event and call the corresponding
			-- Handlers from `handler'
		do
			has_error := False
			input.read_line
			if not end_of_input then
				event_number := event_number + 1
				last_line := input.last_string
				position := 1
				parse_line
			end
		end

feature {NONE} -- Implementation

	last_line: STRING
		-- Content of the last line that was read from `input'

	position: INTEGER
		-- Current parsing - position in `last_line'

	last_string: STRING
		-- Last parsed STRING (could be identifier, value, ...)

	last_integer: INTEGER
		-- Last parsed INTEGER

	last_entity: ENTITY
		-- Last parsed ENTITY

	end_of_line: BOOLEAN
			--Is the end of the parsed line reached?
		require
			last_line_not_void: last_line /= Void
		do
			Result := position > last_line.count
		end

	parse_line
			-- Parse `last_line'
		require
			last_line_not_void: last_line /= Void
		do
			-- Test first for incallret/outcallret,
			-- because the have as prefix INCALL/OUTCALL
			-- which could be mistaken for incall/outcall
			if matches (Incallret_keyword) then
				parse_incallret
			elseif matches (Outcallret_keyword) then
				parse_outcallret
			elseif matches (Incall_keyword) then
				parse_incall
			elseif matches (Outcall_keyword) then
				parse_outcall
			elseif matches (Outread_keyword) then
				parse_outread
			else
					report_error ("INCALL, OUTCALL, INCALLRET or OUTCALLRET")
			end

		end

	parse_incall is
			-- Parse an INCALL event - line; call the handler
			-- when finished
		require
			matches (Incall_keyword)
		do
			consume (Incall_keyword)
			parse_call(agent handler.handle_incall_event)
		end

	parse_outcall is
			-- Parse an OUTCALL event - line; call the handler
			-- when finished
		require
			previous_keyword_ok: matches (Outcall_keyword)
		do
			consume (Outcall_keyword)

			parse_call(agent handler.handle_outcall_event)
		end

	parse_call(handler_feature: PROCEDURE [ANY, TUPLE[ENTITY, STRING, DS_LIST[ENTITY]]]) is
			-- Parse the common part of in&outcalls and call the `handler_feature'
			-- when done. Set `has_error' if an error occurred.
		require
			handler_feature_not_void: handler_feature /= Void
			last_line_read: last_line /= Void
			no_error: not has_error
		local
			target: ENTITY
			feature_name: STRING
			arguments: DS_ARRAYED_LIST[ENTITY]
		do
			parse_entity
			if not has_error then
				target := last_entity
				parse_identifier
				if not has_error then
					feature_name := last_string
					from
						create arguments.make (5) --should be enough for most cases
					until
						has_error or end_of_line
					loop
						parse_entity
						if not has_error then
							arguments.put_last (last_entity)
						end
					end
					if not has_error then
						handler_feature.call ([target, feature_name,arguments])
					end
				end
			end
		end

	parse_incallret is
			-- Parse an INCALLRET event - line; call the handler
			-- when finished or set `has_error' if an error occured.
		require
			previous_keyword_ok: matches (Incallret_keyword)
		do
			consume (Incallret_keyword)
			parse_ret (agent handler.handle_incallret_event)
		end

	parse_outcallret is
			-- Parse an OUTCALLRET event - line; call the handler
			-- when finished or set `has_error' if an error occurred.
		require
			previous_keyword_ok: matches (Outcallret_keyword)
		do
			consume (Outcallret_keyword)
			parse_ret (agent handler.handle_outcallret_event)
		end

	parse_outread is
			-- Parse an OUTREAD event - line; call the corresponding handler
			-- when finished or set `has_error' if an error occurred.
		require
			previous_keyword_ok: matches (Outread_keyword)
		local
			target: NON_BASIC_ENTITY
			attribute_name: STRING
			value: ENTITY
		do
			consume (Outread_keyword)
			parse_entity
			if not has_error then
				target ?= last_entity
				if target = Void then
					report_error ("NON_BASIC")
				else
					parse_identifier
					if not has_error then
						attribute_name := last_string
						parse_entity
						if not has_error then
							value := last_entity
							handler.handle_outread_event (target, attribute_name, value)
						end
					end
				end
			end
		end



	parse_ret(handler_feature: PROCEDURE [ANY, TUPLE[ENTITY]])
			-- Parse the common part of INCALLRET and OUTCALLRET;
			-- call `handler_feature' when done or set `has_error' if an error occurred.
		require
			handler_feature_not_void: handler_feature /= Void
			no_error: not has_error
		do
			if end_of_line then
				--no return value
				handler_feature.call([Void])
			else
				parse_entity
				if not has_error then
					handler_feature.call([last_entity])
				end
			end
		end

	parse_entity
			-- Parse an entity and provide the parsed
			-- ENTITY in `last_entity'. Set `has_error' if there is an error.
		require
			no_error: not has_error
		do
			last_entity := Void

			if item = '[' then
				consume("[")
				if matches(basic_keyword) then
					consume(basic_keyword)
					parse_basic
				elseif matches(non_basic_keyword) then
					consume(non_basic_keyword)
					parse_non_basic
				else
					report_error (basic_keyword + " or " + non_basic_keyword)
				end
			else
				report_error ("[")
			end
		ensure
			last_entity_parsed: has_error or last_entity /= Void
		end

	parse_non_basic is
			-- Parse a NON_BASIC_ENTITY and provide the
			-- Result in last_entity or set `has_error' if there is an error.
		require
			no_error: not has_error
		local
			typename: STRING
			object_id: INTEGER
		do
			last_entity := Void

			parse_type
			if not  has_error then
				typename := last_string

				parse_integer
				if not has_error then
					object_id := last_integer

					if item = ']' then
						consume("]")
					else
						report_error("]")
					end
					if not has_error then
						create {NON_BASIC_ENTITY}last_entity.make(typename,object_id)
					end
				end
			end
		ensure
			non_basic_entity_parsed: has_error or last_entity /= Void
		end

	parse_basic is
			-- Parse a BASIC_ENTITY and provide the
			-- Result in last_entity
		require
			no_error: not has_error
		local
			typename: STRING
			value: STRING
		do
			parse_type
			if not has_error then
				typename := last_string
--				if typename.has_substring (Manifest_special_prefix) then
--					parse_manifest_special(typename)
--				else
					parse_value
					if not has_error then
						value := last_string

						if item = ']' then
							consume("]")
						else
							report_error("]")
						end
						if not has_error then
							create {BASIC_ENTITY}last_entity.make (typename, value)
						end
					end
--				end
			end
		ensure
			entity_parsed: has_error or last_entity /= Void
		end

	parse_type
			-- Parse the type (according to the ECMA standard) at `position' and provide
			-- the Result in `last_string'
		require
		local
			type_name: STRING
		do
			--read typename
			parse_identifier
			type_name := last_string

				-- If the type is a generic, parse the generics type list, too
			if item = '[' then
				type_name.append (" [")
				forth
				from
					parse_type
					type_name.append (last_string)
				until
					item /= ',' or has_error
				loop
					type_name.append (", ")
					forth
					parse_type
					type_name.append (last_string)
				end
				if item = ']' then
					type_name.append ("]")
					forth
				else
					report_error ("]")
				end
			end
			last_string := type_name
		end

	parse_identifier
			-- Parse the identifier at `position' and provide
			-- the Result in `last_string'
		require
			last_line_read: last_line /= Void
			no_error: not has_error
		do
			consume_whitespaces
			parse_regex(Identifier_regex, "identifier") --\w means alphanumeric incl '_'
		ensure
			identifier_parsed: has_error or matches_regex(last_string, Identifier_regex)
		end

	parse_integer
				-- Parse the next integer or and provide the Result in
				-- `last_integer'
		require
			last_line_read: last_line /= Void
			no_error: not has_error
		do
			consume_whitespaces
			parse_regex (Integer_regex, "integer")
			if not has_error then
				last_integer := last_string.to_integer
			end
		end

	parse_value
			-- Parse the next value and provide the result in
			-- last_string
		require
			last_line_read: last_line /= Void
			no_error: not has_error
		do
			consume_whitespaces
			parse_regex (Value_regex, "value")

			if not has_error then
				-- remove the double quotes
				last_string := last_string.substring (2, last_string.count -1)
			end
		ensure
			value_parsed: has_error or matches_regex ("%""+last_string+"%"", Value_regex)
		end

	parse_regex(regex_string: STRING; expected_token: STRING)
			-- Parse for the regular expression `regex_string' and provide
			-- the result in `last_string' . If the parsing fails, state, that
			-- `expected_token' was expected.
		require
			last_line_read: last_line /= Void
			no_error: not has_error
		local
			regex: RX_PCRE_REGULAR_EXPRESSION
		do
			create regex.make
			regex.compile (regex_string)
			regex.match_substring (last_line, position, last_line.count)
			if regex.has_matched then
				last_string := regex.captured_substring(0)
				position := position + regex.captured_substring(0).count
				consume_whitespaces
			else
				report_error (expected_token)
			end
		ensure
			regex_parsed: has_error or matches_regex (last_string, regex_string)
		end

	matches_regex (a_string, regex_string: STRING): BOOLEAN is
			-- Does `a_string' match to the regular expression
			-- `regex_string'?
		require
			a_string_not_void: a_string /= Void
			regex_string_not_void: regex_string /= Void
		local
			regex: RX_PCRE_REGULAR_EXPRESSION
		do
			create regex.make
			regex.compile (regex_string)
			Result := regex.matches (a_string)
		end


	item: CHARACTER is
			-- Character at `position'
		require
			not_end_of_line: not end_of_line
		do
			Result := last_line.item (position)
		ensure
			Result_not_Void: Result /= Void
		end


	matches(a_string: STRING): BOOLEAN is
			-- Do the next characters in the line match a_string? (case is ignored)
		require
				a_string_not_void: a_string /= Void
		local
			candidate: STRING
			lower_target: STRING
		do
			if not ((position + a_string.count) > last_line.count + 1) then
				candidate := last_line.substring (position, position + a_string.count - 1)
				Result := candidate.is_case_insensitive_equal (a_string)
			else
				Result := False
			end
		end

	forth is
			-- Move the cursor one to the right.
		require
			not_end_of_line: not end_of_line
		do
			position := position + 1
		ensure
			position_moved: position = old position + 1
		end


	consume(a_string: STRING) is
			-- Move the cursor past `a_string' in `last_line and
			-- eat the following whitespaces
		require
			string_matches: matches(a_string)
		do
			position := position + a_string.count
			consume_whitespaces
		ensure
			position_shifted: position >= old position + a_string.count
			whitespaces_read: end_of_line or (item /= ' ' and item /= '%T')
		end

	consume_whitespaces is
			-- Move `position' forward until no whitespace is at `item'
		do
			from

			until
				end_of_line or ((item /= ' ') and (item /='%T'))
			loop
				forth
			end
		ensure
			whitespaces_read: end_of_line or (item /= ' ' and item /= '%T')
		end

	report_error(expected_token: STRING)
			-- Reports an error to the 'user'.
		do
			has_error := True
			error_message := "parse error on line " + event_number.out + " character " + position.out
			error_message.append (" expected '" + expected_token + "' but got '" +  last_line.substring (position, last_line.count) + "'")
		end

	Incall_keyword: STRING is "INCALL"

	Outcall_keyword: STRING is "OUTCALL"

	Incallret_keyword: STRING is "INCALLRET"

	Outcallret_keyword: STRING is "OUTCALLRET"

	Outread_keyword: STRING is "OUTREAD"

	Basic_keyword: STRING is "BASIC"

	Non_basic_keyword: STRING is "NON_BASIC"

	Integer_regex: STRING is "^[0-9]+"

	Identifier_regex: STRING is "^[A-Za-z]\w*"

	Value_regex: STRING is "^%"[^%"]*%""

	Manifest_special_prefix: STRING is "MANIFEST_SPECIAL["

invariant
	handler_not_void: handler /= Void -- Your invariant here
	input_not_void: input /= Void
	error_message_valid: has_error implies error_message /= Void
end
