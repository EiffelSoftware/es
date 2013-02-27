note
	description: "Parser to process Boogie output."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_OUTPUT_PARSER

inherit

	E2B_SHARED_CONTEXT

	SHARED_ERROR_HANDLER

	COMPILER_EXPORTER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize output parser.
		do
			create last_result.make
		end

feature -- Access

	last_result: attached E2B_RESULT
			-- Last result.

feature -- Basic operations

	process (a_boogie_output: STRING)
			-- Process `a_boogie_output'.
		do
			create last_result.make
			lines := a_boogie_output.split ('%N')
			boogie_file_lines := Void
			parse
		end

feature {NONE} -- Implementation

	parse
			-- Parse `lines'.
		local
			l_line: STRING
			l_current_procedure: STRING
			l_current_error: E2B_VERIFICATION_ERROR
			l_current_error_model: E2B_ERROR_MODEL
			l_total_time: REAL
			l_current_errors: LINKED_LIST [E2B_VERIFICATION_ERROR]
			l_successful_verification: E2B_SUCCESSFUL_VERIFICATION
			l_failed_verification: E2B_FAILED_VERIFICATION
			l_has_related_location: BOOLEAN
			l_error_info: TUPLE [code: STRING; message: STRING; filename: STRING; line: INTEGER; column: INTEGER]
		do
			create l_current_errors.make
			from
				lines.start
			until
				lines.after
			loop

				l_line := lines.item
				l_line.right_adjust

				if not l_line.is_empty then

					if version_regexp.matches (l_line) then
						-- version: version_regexp.captured_substring (1)
						last_result.set_boogie_version (version_regexp.captured_substring (1))

					elseif parsing_regexp.matches (l_line) then
						-- boogie file name: parsing_regexp.captured_substring (1)
						fill_boogie_file_lines (parsing_regexp.captured_substring (1))

					elseif finished_regexp.matches (l_line) then
						-- nr verified: finished_regexp.captured_substring (1).to_integer
						-- nr failed: finished_regexp.captured_substring (2).to_integer
						last_result.set_verified_count (finished_regexp.captured_substring (1).to_integer)
						last_result.set_failed_count (finished_regexp.captured_substring (2).to_integer)

					elseif time_regexp.matches (l_line) then
						-- time in seconds: time_regexp.captured_substring (1).to_real
						l_total_time := l_total_time + time_regexp.captured_substring (1).to_real

					elseif verifying_regexp.matches (l_line) then
						-- name of procedure: verifying_regexp.captured_substring (1)
						l_current_procedure := verifying_regexp.captured_substring (1)
							-- Reset state for new result
						l_current_error := Void
						l_has_related_location := False
						l_error_info := Void
							-- Create error list without knowing if it actually is an error, but
							-- successive lines may assume that error object is already created.
						l_current_errors.wipe_out

					elseif verified_regexp.matches (l_line) then
						-- time in seconds: verified_regexp.captured_substring (1).to_real
						-- result (error/verified): verified_regexp.captured_substring (2)
						if verified_regexp.captured_substring (2).is_equal ("verified") then
							create l_successful_verification.set_procedure_name (l_current_procedure)
							l_successful_verification.set_time (verified_regexp.captured_substring (1).to_real)
							last_result.procedure_results.extend (l_successful_verification)
						else
							check
								verified_regexp.captured_substring (2).starts_with ("error") or
								verified_regexp.captured_substring (2).starts_with ("inconclusive")
							end
							check not l_current_errors.is_empty end
							if l_current_error_model /= Void then
								l_current_errors.do_all (agent {E2B_VERIFICATION_ERROR}.set_error_model (l_current_error_model))
							end
							create l_failed_verification.make (l_current_procedure)
							l_failed_verification.set_time (verified_regexp.captured_substring (1).to_real)
							l_failed_verification.errors.append (l_current_errors)
							l_current_errors.do_all (agent {E2B_VERIFICATION_ERROR}.set_procedure_result (l_failed_verification))
							last_result.procedure_results.extend (l_failed_verification)
						end
						l_total_time := l_total_time + verified_regexp.captured_substring (1).to_real
								-- Reset state (safeguard)
						l_current_errors.wipe_out
						l_current_error := Void
						l_current_procedure := Void
						l_has_related_location := False
						l_error_info := Void

					elseif error_regexp.matches (l_line) then
						-- file: error_regexp.captured_substring (1)
						-- line: error_regexp.captured_substring (2).to_integer
						-- column: error_regexp.captured_substring (3).to_integer
						-- error code: error_regexp.captured_substring (4)
						-- error message: error_regexp.captured_substring (5)
						l_has_related_location :=
							error_regexp.captured_substring (4) ~ "BP5002" or
							error_regexp.captured_substring (4) ~ "BP5003"
						if l_has_related_location then
							l_error_info := [
								error_regexp.captured_substring (4),
								error_regexp.captured_substring (5),
								error_regexp.captured_substring (1),
								error_regexp.captured_substring (2).to_integer,
								error_regexp.captured_substring (3).to_integer]
						else
							l_current_error := create_error (
								error_regexp.captured_substring (4),
								error_regexp.captured_substring (5),
								error_regexp.captured_substring (1),
								error_regexp.captured_substring (2).to_integer,
								error_regexp.captured_substring (3).to_integer)
							l_current_errors.extend (l_current_error)
						end

					elseif related_regexp.matches (l_line) then
						-- file: related_regexp.captured_substring (1)
						-- line: related_regexp.captured_substring (2).to_integer
						-- column: related_regexp.captured_substring (3).to_integer
						-- message: related_regexp.captured_substring (4)
						check l_has_related_location end
						l_current_error := create_error_with_related (
								l_error_info.code,
								l_error_info.message,
								l_error_info.filename,
								l_error_info.line,
								l_error_info.column,
								related_regexp.captured_substring (2).to_integer,
								related_regexp.captured_substring (3).to_integer)
						l_current_errors.extend (l_current_error)

					elseif syntax_error_regexp.matches (l_line) then
						-- file: syntax_error_regexp.captured_substring (1)
						-- line: syntax_error_regexp.captured_substring (2).to_integer
						-- column: syntax_error_regexp.captured_substring (3).to_integer
						-- message: syntax_error_regexp.captured_substring (4)
						last_result.execution_errors.extend (["Syntax error", l_line])

					elseif semantic_error_regexp.matches (l_line) then
						-- file: semantic_error_regexp.captured_substring (1)
						-- line: semantic_error_regexp.captured_substring (2).to_integer
						-- column: semantic_error_regexp.captured_substring (3).to_integer
						-- message: semantic_error_regexp.captured_substring (4)
						last_result.execution_errors.extend (["Semantic error", l_line])

					elseif execution_trace_regexp.matches (l_line) then
						-- file: execution_trace_regexp.captured_substring (1)
						-- line: execution_trace_regexp.captured_substring (2).to_integer
						-- column: execution_trace_regexp.captured_substring (3).to_integer
						-- label: execution_trace_regexp.captured_substring (4)
						check l_current_error /= Void end
						l_current_error.execution_trace.extend ([
							execution_trace_regexp.captured_substring (1),
							execution_trace_regexp.captured_substring (2).to_integer,
							execution_trace_regexp.captured_substring (3).to_integer,
							execution_trace_regexp.captured_substring (4)
						])

					elseif model_start_regexp.matches (l_line) then
						create l_current_error_model.make

					elseif partitions_start_regexp.matches (l_line) then
						-- nothing to do

					elseif partition_regexp.matches (l_line) then
						-- partition id: partition_regexp.captured_substring (1).to_integer
						-- value: partition_regexp.captured_substring (2)
						l_current_error_model.partitions.extend ([
							partition_regexp.captured_substring (1).to_integer,
							partition_regexp.captured_substring (2)
						])

					elseif function_interpretations_start.matches (l_line) then
						-- nothing to do

					elseif function_interpretation.matches (l_line) then
						-- function: function_interpretation.captured_substring (1)
						-- value: function_interpretation.captured_substring (2)
						l_current_error_model.function_interpretations.extend ([
							function_interpretation.captured_substring (1),
							function_interpretation.captured_substring (2)
						])

					elseif model_end_regexp.matches (l_line) then
						l_current_error_model := Void

					else
						-- Unknown line: ignored

					end

				end

				lines.forth
			end
			last_result.set_total_time (l_total_time)
			if error_handler.has_warning then
				error_handler.trace
			end
		end

feature {NONE} -- Implementation

	lines: LIST [STRING]
			-- Lines of generated output.

	boogie_file_lines: LIST [STRING]
			-- Lines of checked Boogie file.

	fill_boogie_file_lines (a_filename: STRING)
			-- Fill `boogie_file_lines' with file `a_filename'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make (a_filename)
			create {ARRAYED_LIST [STRING]} boogie_file_lines.make (10_000)
			from
				l_file.open_read
			until
				l_file.end_of_file
			loop
				l_file.read_line
				boogie_file_lines.extend (l_file.last_string.twin)
			end
			l_file.close
		end

	eiffel_instruction_location (a_line: INTEGER): TUPLE [filename: STRING; line: INTEGER]
			-- Instruction location of `a_line' (if any).
		local
			i: INTEGER
			l_line: STRING
			l_exit: BOOLEAN
		do
			from
				i := a_line - 1
			until
				l_exit or Result /= Void
			loop
				l_line := boogie_file_lines [i]
				if instruction_location_regexp.matches (l_line) then
					Result := [instruction_location_regexp.captured_substring (1), instruction_location_regexp.captured_substring (2).to_integer]
				elseif l_line.starts_with ("{") then
					l_exit := True
				else
					i := i - 1
				end
			end
		end

	eiffel_feature_context_of_boogie_line (a_line: INTEGER): FEATURE_I
			-- Eiffel feature context of Boogie line `a_line'.
		local
			i: INTEGER
			l_exit: BOOLEAN
			l_line: STRING
			l_paran: INTEGER
		do
			from
				i := a_line
			until
				i < 1 or l_exit
			loop
				l_line := boogie_file_lines [a_line]
				if l_line.starts_with ("implementation") then
					l_paran := l_line.index_of ('(', 15)
					Result := name_translator.feature_for_boogie_name (l_line.substring (16, l_paran))
					l_exit := True
				elseif l_line.starts_with ("procedure") then
					l_paran := l_line.index_of ('(', 10)
					Result := name_translator.feature_for_boogie_name (l_line.substring (11, l_paran))
					l_exit := True
				elseif l_line.starts_with ("}") then
					l_exit := True
				end
				i := i - 1
			end
		end

	create_error (a_code: STRING; a_message: STRING; a_filename: STRING; a_linenumber, a_columnnumber: INTEGER): E2B_VERIFICATION_ERROR
			-- Create error corresponding to given Boogie output.
		local
			l_is_pre, l_is_post, l_is_assert: BOOLEAN
			l_is_loop_inv_on_entry, l_is_loop_inv_maintained: BOOLEAN
			l_boogie_line: STRING
			l_loop_inv_violation: E2B_LOOP_INVARIANT_VIOLATION
		do
			check attached boogie_file_lines end

			l_is_assert := a_code ~ "BP5001"
			l_is_pre := a_code ~ "BP5002"
			l_is_post := a_code ~ "BP5003"
			l_is_loop_inv_on_entry := a_code ~ "BP5004"
			l_is_loop_inv_maintained := a_code ~ "BP5005"
			check l_is_assert or l_is_loop_inv_on_entry or l_is_loop_inv_maintained end

			if not attached boogie_file_lines then
				fill_boogie_file_lines (a_filename)
			end
			l_boogie_line := boogie_file_lines [a_linenumber]

			if l_is_assert then
					-- check, attached, loop-var
				assert_regexp.match (l_boogie_line)
				-- type: assert_regexp.captured_substring (2)
				-- tag: assert_regexp_tag (assert_regexp)
				-- line: assert_regexp_line (assert_regexp)
				check assert_regexp.has_matched end
				if assert_regexp.captured_substring (2) ~ "check" then
					create {E2B_CHECK_VIOLATION} Result.make (a_code, a_message)
				elseif assert_regexp.captured_substring (2) ~ "attached" then
					create {E2B_VIOLATION} Result.make_with_description (a_code, a_message, "Possible void call.")
				elseif assert_regexp.captured_substring (2) ~ "overflow" then
					create {E2B_VIOLATION} Result.make_with_description (a_code, a_message, "Possible overflow.")
				elseif assert_regexp.captured_substring (2) ~ "loop_var_ge" then
					create {E2B_VIOLATION} Result.make_with_description (a_code, a_message, "Loop variant might be negative.")
				elseif assert_regexp.captured_substring (2) ~ "loop_var_decr" then
					create {E2B_VIOLATION} Result.make_with_description (a_code, a_message, "Loop variant might not decrease.")
				else
					check False end
				end
				Result.set_tag (assert_regexp_tag (assert_regexp))
				Result.set_eiffel_line_number (assert_regexp_line (assert_regexp))
			elseif l_is_loop_inv_on_entry then
				assert_regexp.match (l_boogie_line)
				create l_loop_inv_violation.make (a_code, a_message)
				l_loop_inv_violation.set_on_entry
				l_loop_inv_violation.set_tag (assert_regexp_tag (assert_regexp))
				l_loop_inv_violation.set_eiffel_line_number (assert_regexp_line (assert_regexp))
				Result := l_loop_inv_violation
			elseif l_is_loop_inv_maintained then
				assert_regexp.match (l_boogie_line)
				create l_loop_inv_violation.make (a_code, a_message)
				l_loop_inv_violation.set_on_iteration
				l_loop_inv_violation.set_tag (assert_regexp_tag (assert_regexp))
				l_loop_inv_violation.set_eiffel_line_number (assert_regexp_line (assert_regexp))
				Result := l_loop_inv_violation
			else
				check False end
			end
		ensure
			result_attached: attached Result
		end

	create_error_with_related (a_code: STRING; a_message: STRING; a_filename: STRING; a_linenumber, a_columnnumber, a_related_linenumber, a_related_columnnumber: INTEGER; ): E2B_VERIFICATION_ERROR
			-- Create error corresponding to given Boogie output.
		local
			l_is_pre, l_is_post, l_is_assert: BOOLEAN
			l_is_loop_inv_on_entry, l_is_loop_inv_maintained: BOOLEAN
			l_boogie_line, l_related_boogie_line: STRING
			l_pre_violation: E2B_PRECONDITION_VIOLATION
			l_post_violation: E2B_POSTCONDITION_VIOLATION
			l_eiffel_location: TUPLE [file: STRING; line: INTEGER]
			l_called_feature: STRING
		do
			check attached boogie_file_lines end

			l_is_assert := a_code ~ "BP5001"
			l_is_pre := a_code ~ "BP5002"
			l_is_post := a_code ~ "BP5003"
			l_is_loop_inv_on_entry := a_code ~ "BP5004"
			l_is_loop_inv_maintained := a_code ~ "BP5005"
			check l_is_pre or l_is_post end

			l_boogie_line := boogie_file_lines [a_linenumber]
			l_related_boogie_line := boogie_file_lines [a_related_linenumber]

			if l_is_pre then
				create l_pre_violation.make (a_code, a_message)
				Result := l_pre_violation
					-- Line in Eiffel code
				l_eiffel_location := eiffel_instruction_location (a_linenumber)
				if attached l_eiffel_location then
					l_pre_violation.set_eiffel_file_name (l_eiffel_location.file)
					l_pre_violation.set_eiffel_line_number (l_eiffel_location.line)
				end
					-- Called routine
				proc_call_regexp.match (l_boogie_line)
				if proc_call_regexp.has_matched then
					if proc_call_regexp.match_count = 3 then
						l_called_feature := proc_call_regexp.captured_substring (2)
					elseif proc_call_regexp.match_count = 2 then
						l_called_feature := proc_call_regexp.captured_substring (1)
					end
					l_pre_violation.set_called_feature (name_translator.feature_for_boogie_name (l_called_feature))
				end
					-- pre
				assert_regexp.match (l_related_boogie_line)
				check assert_regexp.has_matched end
				if assert_regexp.captured_substring (2) ~ "pre" then
				elseif assert_regexp.captured_substring (2) ~ "attached" then
					l_pre_violation.set_is_attached_check
				elseif assert_regexp.captured_substring (2) ~ "overflow" then
					l_pre_violation.set_is_overflow_check
				else
					l_related_boogie_line.left_adjust
					l_related_boogie_line.right_adjust
					create {E2B_VIOLATION} Result.make_with_description (a_code, a_message, "Precondition may be violated: " + l_related_boogie_line)
--					check False end
				end
				Result.set_tag (assert_regexp_tag (assert_regexp))
			elseif l_is_post then
					-- post, inv, frame
				assert_regexp.match (l_related_boogie_line)
				check assert_regexp.has_matched end
				if assert_regexp.captured_substring (2) ~ "post" then
					create l_post_violation.make (a_code, a_message)
					Result := l_post_violation
				elseif assert_regexp.captured_substring (2) ~ "attached" then
					create l_post_violation.make (a_code, a_message)
					l_post_violation.set_is_attached_check
					Result := l_post_violation
				elseif assert_regexp.captured_substring (2) ~ "overflow" then
					create l_post_violation.make (a_code, a_message)
					l_post_violation.set_is_overflow_check
					Result := l_post_violation
				elseif assert_regexp.captured_substring (2) ~ "inv" then
					create {E2B_VIOLATION} Result.make_with_description (a_code, a_message, "Class invariant violated.")
				elseif assert_regexp.captured_substring (2) ~ "frame" then
					create {E2B_VIOLATION} Result.make_with_description (a_code, a_message, "Frame condition violated.")
				else
					check False end
				end
				Result.set_tag (assert_regexp_tag (assert_regexp))
				Result.set_eiffel_line_number (assert_regexp_line (assert_regexp))
			else
				check False end
			end
		ensure
			result_attached: attached Result
		end


feature {NONE} -- Implementation: regular expressions Boogie output

	version_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for version information line.
		once
			create Result.make
			Result.compile ("^Boogie program verifier version ([^,]*).*$")
		end

	parsing_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for parsing line
		once
			create Result.make
			Result.compile ("^Parsing (.*)$")
		end

	finished_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for finished line.
		once
			create Result.make
			Result.compile ("^Boogie program verifier finished with ([0-9]*) verified, ([0-9]*) errors?$")
		end

	verifying_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for verifying section.
		once
			create Result.make
			Result.compile ("^Verifying\s*([\w.$#\^]+)\s*.*$")
		end

	verified_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for verified information line.
		once
			create Result.make
			Result.compile ("^\s*\[([0-9.]*) s, [0-9]+ proof obligations?\]\s*(\w+)\s*$")
		end

	time_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for time used for abstract interpretation.
		once
			create Result.make
			Result.compile ("^\s*\[([0-9.]*)\s*s\]\s*$")
		end

	error_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for error line.
		once
			create Result.make
			Result.compile ("^(.*)\(([0-9]*),([0-9]*)\): Error (.*): (.*)$")
		end

	related_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for related information line.
		once
			create Result.make
			Result.compile ("^(.*)\(([0-9]*),([0-9]*)\): Related location: (.*)$")
		end

	syntax_error_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression syntax error line.
		once
			create Result.make
			Result.compile ("^(.*)\(([0-9]*),([0-9]*)\): syntax error: (.*)$")
		end

	semantic_error_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for error line.
		once
			create Result.make
			Result.compile ("^(.*)\(([0-9]*),([0-9]*)\): Error: (.*)$")
		end

	execution_trace_start_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for related information line.
		once
			create Result.make
			Result.compile ("^Execution trace:$")
		end

	execution_trace_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for related information line.
		once
			create Result.make
			Result.compile ("^\s+(.*)\(([0-9]*),([0-9]*)\): (.*)$")
		end

	model_start_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for start of error model.
		once
			create Result.make
			Result.compile ("^Z3 error model:$")
		end

	partitions_start_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for start of partitions in error model.
		once
			create Result.make
			Result.compile ("^partitions:$")
		end

	partition_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for partition entry.
		once
			create Result.make
			Result.compile ("^\s*\*([0-9]+):\s(.+)$")
		end

	function_interpretations_start: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for start of function interpretations.
		once
			create Result.make
			Result.compile ("^function interpretations:$")
		end

	function_interpretation: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for function interpretation.
		once
			create Result.make
			Result.compile ("^([^=]+)=([^=]+)$")
		end

	model_end_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for end of error model.
		once
			create Result.make
			Result.compile ("^The end.$")
		end

feature {NONE} -- Implementation: regular expressions Boogie code

	assert_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression assertion information in Boogie source.
		once
			create Result.make
			Result.compile ("^(.*)// (\w+)\s*((tag):(\w*))?\s*((line):(\w*))?$")
		end

	assert_regexp_tag (a_regexp: RX_PCRE_REGULAR_EXPRESSION): detachable STRING
			-- Tag part of assertion regexp (if any).
		do
			if a_regexp.match_count > 5 then
				Result := a_regexp.captured_substring (5)
			elseif a_regexp.match_count > 3 and then a_regexp.captured_substring (4) ~ "tag" then
				Result := a_regexp.captured_substring (5)
			end
		end

	assert_regexp_line (a_regexp: RX_PCRE_REGULAR_EXPRESSION): INTEGER
			-- Line part of assertion regexp (if any).
		do
			if a_regexp.match_count > 5 then
				Result := a_regexp.captured_substring (8).to_integer
			elseif a_regexp.match_count > 3 and then a_regexp.captured_substring (4) ~ "line" then
				Result := a_regexp.captured_substring (5).to_integer
			end
		end

	instruction_location_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression assertion for instruction location in Boogie source.
		once
			create Result.make
			Result.compile ("^\s*// (.*):(\d+)$")
		end

	proc_call_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression assertion for instruction location in Boogie source.
		once
			create Result.make
			Result.compile ("^\s*call([^:]+:=)?\s([^(]+).*$")
		end

end
