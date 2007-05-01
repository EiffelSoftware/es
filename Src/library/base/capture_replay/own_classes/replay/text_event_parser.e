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


feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	parse_event
			-- Parse an event and call the corresponding
			-- Handlers from `handler'
		do
			input.read_line
			last_line := input.last_string
			position := 1
			parse_line
		end

feature -- Obsolete

feature -- Inapplicable

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
			Result := position >= last_line.count
		end

	parse_line
			-- Parse `last_line'
		require
			last_line_not_void: last_line /= Void
		do
			-- Test first for incallret/outcallret,
			-- because the have as prefix INCALL/OUTCALL
			-- which could be mistaken for incall/outcall
			if matches (incallret_keyword) then
				parse_incallret
			elseif matches (outcallret_keyword) then
				parse_outcallret
			elseif matches(incall_keyword) then
				parse_incall
			elseif matches(outcall_keyword) then
				parse_outcall
			else
				report_error ("INCALL, OUTCALL, INCALLRET or OUTCALLRET")
			end

		end

	parse_incall is
			-- Parse an INCALL event - line; call the handler
			-- when finished
		require
			matches(incall_keyword)
		do
			consume(incall_keyword)
			parse_call(agent handler.handle_incall_event)
		end

	parse_outcall is
			-- Parse an OUTCALL event - line; call the handler
			-- when finished
		require
			previous_keyword_ok: matches(outcall_keyword)
		do
			consume(outcall_keyword)

			parse_call(agent handler.handle_outcall_event)
		end

	parse_call(handler_feature: PROCEDURE [ANY, TUPLE[ENTITY, STRING, LIST[ENTITY]]]) is
			-- Parse the common part of in&outcalls and call the `handler_feature'
			-- when done.
		local
			target: ENTITY
			feature_name: STRING
			arguments: ARRAYED_LIST[ENTITY]
		do
			parse_entity
			target := last_entity
			parse_identifier
			feature_name := last_string
			from
				create arguments.make (5) --should be enough for most cases
			until
				end_of_line
			loop
				parse_entity
				arguments.extend (last_entity)
			end
			handler_feature.call ([target, feature_name,arguments])
		end

	parse_incallret is
			-- Parse an INCALLRET event - line; call the handler
			-- when finished
		require
			previous_keyword_ok: matches(incallret_keyword)
		do
			consume(incallret_keyword)
			parse_ret(agent handler.handle_incallret_event)
		end

	parse_outcallret is
			-- Parse an OUTCALLRET event - line; call the handler
			-- when finished
		require
			previous_keyword_ok: matches(outcallret_keyword)
		do
			consume(outcallret_keyword)
			parse_ret(agent handler.handle_outcallret_event)
		end

	parse_ret(handler_feature: PROCEDURE [ANY, TUPLE[ENTITY]])
			-- Parse the common part of INCALLRET and OUTCALLRET;
			-- call `handler_feature' when done.
		local

		do
			if(end_of_line) then
				--no return value
				handler_feature.call([Void])
			else
				parse_entity
				handler_feature.call([last_entity])
			end
		end

	parse_entity
			-- Parse an entity and provide the parsed
			-- ENTITY in `last_entity'
		do
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
					last_entity := Void
				end
			else
				report_error ("[")
			end
		end

	parse_non_basic is
			-- Parse a NON_BASIC_ENTITY and provide the
			-- Result in last_entity
		local
			typename: STRING
			object_id: INTEGER
		do
			parse_identifier
			typename := last_string

			parse_integer
			object_id := last_integer

			if item = ']' then
				consume("]")
			else
				report_error("]")
			end

			create {NON_BASIC_ENTITY}last_entity.make(typename,object_id)
		end

	parse_basic is
			-- Parse a BASIC_ENTITY and provide the
			-- Result in last_entity
		local
			typename: STRING
			value: STRING
		do
			parse_identifier
			typename := last_string

			parse_value
			value := last_string

			if item = ']' then
				consume("]")
			else
				report_error("]")
			end

			create {BASIC_ENTITY}last_entity.make (typename, value)
		end


	parse_identifier
			-- Parse the identifier at `position' and provide
			-- the Result in `last_string'
		do
			parse_regex("^[A-Za-z]\w*", "identifier") --\w means alphanumeric incl '_'
		end

	parse_integer
				-- Parse the next integer or and provide the Result in
				-- `last_integer'
		do
			parse_regex("^[0-9]+", "integer")
			last_integer := last_string.to_integer
		end


	parse_value
			-- Parse the next value and provide the result in
			-- last_string
		do
			parse_regex("^%"[^%"]*%"", "value")

			-- remove the double quotes
			last_string := last_string.substring (2, last_string.count -1)
		end

	parse_regex(regex_string: STRING; expected_token: STRING)
			-- Parse for the regular expression `regex_string' and provide
			-- the result in `last_string' . If the parsing fails, state, that
			-- `expected_token' was expected.
		local
			regex: RX_PCRE_REGULAR_EXPRESSION
		do
			create regex.make
			regex.compile(regex_string)
			regex.match_substring(last_line, position, last_line.count)
			if regex.has_matched then
				last_string := regex.captured_substring(0)
				position := position + regex.captured_substring(0).count
				consume_whitespaces
			else
				report_error(expected_token)
			end
		end

	item: CHARACTER is
			-- character at `position'
		do
			Result := last_line.item (position)
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
		end

	report_error(expected_token: STRING)
			--reports an error to the 'user'.
		do
			exceptions.raise ("parse error. expected: '" + expected_token + "' but got '" + last_line.substring (position, last_line.count) + "'")
		end

	incall_keyword: STRING is "INCALL"

	outcall_keyword: STRING is "OUTCALL"

	incallret_keyword: STRING is "INCALLRET"

	outcallret_keyword: STRING is "OUTCALLRET"

	basic_keyword: STRING is "BASIC"

	non_basic_keyword: STRING is "NON_BASIC"


	exceptions: EXCEPTIONS is
			-- Standard EXCEPTIONS instance
		once
			create Result
		end


invariant
	handler_not_void: handler /= Void -- Your invariant here
	input_not_void: input /= Void
end
