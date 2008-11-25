indexing
	description:
		"[
			Parser for Boogie output.
			TODO: It's not nice that this class adds stuff to the output panel. 
			      It should just parse it and give parsed information to someone else.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_BOOGIE_OUTPUT_PARSER

inherit {NONE}

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

	EB_SHARED_MANAGERS
		export {NONE} all end

	SHARED_WORKBENCH
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make (a_boogie_input, a_boogie_output: STRING)
			-- TODO
		require
			a_boogie_input_not_void: a_boogie_input /= Void
			a_boogie_output_not_void: a_boogie_output /= Void
		do
			input_lines := a_boogie_input.split ('%N')
			output_lines := a_boogie_output.split ('%N')
		end

feature -- Basic operations

	parse
			-- Parse Boogie output.
		local
			l_line: STRING
		do
			from
				output_lines.start
			until
				output_lines.after
			loop
				l_line := output_lines.item
				l_line.right_adjust

				if not l_line.is_empty then
					if version_regexp.matches (l_line) then
						handle_version (version_regexp.captured_substring (1))
					elseif finished_regexp.matches (l_line) then
						handle_finished (
							finished_regexp.captured_substring (1),
							finished_regexp.captured_substring (2))
					elseif verifying_regexp.matches (l_line) then
						handle_verifying (
							verifying_regexp.captured_substring (1),
							verifying_regexp.captured_substring (2),
							verifying_regexp.captured_substring (3))
					elseif verified_regexp.matches (l_line) then
						handle_verified (
							verified_regexp.captured_substring (1),
							verified_regexp.captured_substring (2))
					elseif error_regexp.matches (l_line) then
						handle_error (
							error_regexp.captured_substring (1),
							error_regexp.captured_substring (2),
							error_regexp.captured_substring (3),
							error_regexp.captured_substring (4),
							error_regexp.captured_substring (5))
					elseif related_regexp.matches (l_line) then
						handle_related (
							related_regexp.captured_substring (1),
							related_regexp.captured_substring (2),
							related_regexp.captured_substring (3),
							related_regexp.captured_substring (4))
					else
						-- Ignored line
					end
				end

				output_lines.forth
			end
		end

feature {NONE} -- Implementation

	input_lines: LIST [STRING]
			-- Boogie input lines

	output_lines: LIST [STRING]
			-- Boogie output lines

	last_error: EP_VERIFICATION_ERROR
			-- Last verification error

	current_class: CLASS_C
			-- Current class

	current_feature: FEATURE_I
			-- Current feature

	use_related_for_location: BOOLEAN
			-- Use related error information for actual error location

feature {NONE} -- Implementation

	handle_version (a_version: STRING)
			-- TODO
		do
				-- TODO: internationalization
			output_manager.add ("Boogie version " + a_version)
			output_manager.add_new_line
		end

	handle_finished (a_verified, a_errors: STRING)
			-- TODO
		do
				-- TODO: internationalization
			output_manager.add ("Boogie finished (" + a_verified + " verified, " + a_errors + " errors)")
			output_manager.add_new_line
		end

	handle_verifying (a_type, a_class, a_feature: STRING)
			-- TODO
		local
			l_class: CLASS_I
			l_feature: E_FEATURE
		do
				-- TODO: internationalization
			l_class := universe.classes_with_name (a_class).first
			l_feature := l_class.compiled_class.feature_with_name (a_feature)
			output_manager.add ("Verifying {")
			output_manager.add_class (l_class)
			output_manager.add ("}.")
			output_manager.add_feature (l_feature, a_feature)
			output_manager.add (": ")

			current_class := l_class.compiled_class
			current_feature := current_class.feature_named (a_feature)
		end

	handle_verified (a_time, a_result: STRING)
			-- TODO
		do
				-- TODO: internationalization
			if a_result.is_equal ("error") or a_result.is_equal ("errors") then
				check last_error /= Void end
				output_manager.add_error (last_error, "failed")
			else
				check a_result.is_equal ("verified") end
				output_manager.add ("successful")
			end
			output_manager.add_new_line
			last_error := Void
		end

	handle_error (a_file, a_line, a_column, a_error, a_message: STRING)
			-- TODO
		local
			l_source_line: STRING
		do
			l_source_line := input_lines.i_th (a_line.to_integer)
			if a_error.is_equal ("BP5001") then
				handle_assertion_error (l_source_line)
			elseif a_error.is_equal ("BP5002") then
				handle_precondition_error (a_line.to_integer)
			elseif a_error.is_equal ("BP5003") then
				handle_postcondition_error (a_line.to_integer)
			else
				create last_error.make ("Unknown verification error")
				errors.extend (last_error)
			end
		end

	handle_assertion_error (a_source_line: STRING)
			-- TODO
		local
			l_line_number: INTEGER
			l_type: STRING
		do
			if assert_regexp.matches (a_source_line) then
				l_type := assert_regexp.captured_substring (2)
				if l_type.is_equal ("check") then
					create last_error.make ("Check instruction violated")
					last_error.set_description ("This check instruction is violated.")
					last_error.set_class (current_class)
					last_error.set_feature (current_feature)
				elseif l_type.is_equal ("loop") then
					create last_error.make ("Loop invariant  violated")
					last_error.set_description ("This loop invariant is violated.")
					last_error.set_class (current_class)
					last_error.set_feature (current_feature)
				else
					check false end
				end
				l_line_number := assert_regexp.captured_substring (4).to_integer
				last_error.set_position (l_line_number, 0)
				if assert_regexp.match_count > 5 then
					last_error.set_tag (assert_regexp.captured_substring (6))
				end
			else
				check false end
			end

			errors.extend (last_error)
		end

	handle_precondition_error (a_source_line_number: INTEGER)
			-- TODO
		local
			l_found: BOOLEAN
			l_instruction_line: INTEGER
		do
			create last_error.make ("Precondition violated")
			last_error.set_description ("The precondition of this call is violated.")
			last_error.set_class (current_class)
			last_error.set_feature (current_feature)

			from
				input_lines.go_i_th (a_source_line_number)
			until
				l_found
			loop
				if instruction_location_regexp.matches (input_lines.item) then
					l_instruction_line := instruction_location_regexp.captured_substring (3).to_integer
					last_error.set_position (l_instruction_line, 0)
					l_found := True
				end

				input_lines.back
			end

			use_related_for_location := False
			errors.extend (last_error)
		end

	handle_postcondition_error (a_source_line_number: INTEGER)
			-- TODO
		do
			create last_error.make ("Postcondition violated")
			last_error.set_description ("The postcondition of this feature is violated.")
			last_error.set_class (current_class)
			last_error.set_feature (current_feature)

			use_related_for_location := True
			errors.extend (last_error)
		end

	handle_related (a_file, a_line, a_column, a_message: STRING)
			-- TODO
		local
			l_line_number: INTEGER
		do
			check last_error /= Void end


			if assert_regexp.matches (input_lines.i_th (a_line.to_integer)) then
				l_line_number := assert_regexp.captured_substring (4).to_integer
				if use_related_for_location then
					last_error.set_position (l_line_number, 0)
				end
				if assert_regexp.match_count > 5 then
					last_error.set_tag (assert_regexp.captured_substring (6))
				end
			else
					-- TODO: Loop invariant will also be here
				check false end
			end
		end

feature {NONE} -- Regular expressions

	version_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- TODO
		once
			create Result.make
			Result.compile ("^Boogie program verifier version ([^,]*).*$")
		end

	finished_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- TODO
		once
			create Result.make
			Result.compile ("^Boogie program verifier finished with ([0-9]*) verified, ([0-9]*) errors$")
		end

	verifying_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- TODO
		once
			create Result.make
			Result.compile ("^Verifying\s*(\w+)\.(\w+)\.(\w+).*$")
		end

	verified_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- TODO
		once
			create Result.make
			Result.compile ("^\s*\[([0-9.]*)\s*s\]\s*(\w+)\s*$")
		end

	error_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- TODO
		once
			create Result.make
			Result.compile ("^(.*)\(([0-9]*),([0-9]*)\): Error (.*): (.*)$")
		end

	related_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- TODO
		once
			create Result.make
			Result.compile ("^(.*)\(([0-9]*),([0-9]*)\): Related location: (.*)$")
		end

	assert_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- TODO
		once
			create Result.make
			Result.compile ("^(.*)// (\w+) (\w+):(\d+)(\s*tag:(\w*))?$")
		end

	instruction_location_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- TODO
		once
			create Result.make
			Result.compile ("^\s*// (.*) --- (.*):(\d+)$")
		end

end
