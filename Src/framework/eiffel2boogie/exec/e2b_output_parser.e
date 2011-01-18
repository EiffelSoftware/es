note
	description: "Parser to process Boogie output."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_OUTPUT_PARSER

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
							-- Create error without knowing if it actually is an error, but
							-- successive lines may assume that error object is already created.
						l_current_errors.wipe_out
						l_current_error := Void

					elseif verified_regexp.matches (l_line) then
						-- time in seconds: verified_regexp.captured_substring (1).to_real
						-- result (error/verified): verified_regexp.captured_substring (2)
						if verified_regexp.captured_substring (2).is_equal ("verified") then
							last_result.verified_procedures.extend (create {E2B_PROCEDURE_RESULT})
							last_result.verified_procedures.last.set_procedure_name (l_current_procedure)
							last_result.verified_procedures.last.set_time (verified_regexp.captured_substring (1).to_real)
						else
							check verified_regexp.captured_substring (2).starts_with ("error") end
							check not l_current_errors.is_empty end
							if l_current_error_model /= Void then
								l_current_errors.do_all (agent {E2B_VERIFICATION_ERROR}.set_error_model (l_current_error_model))
							end
							l_current_errors.do_all (agent {E2B_VERIFICATION_ERROR}.set_procedure_name (l_current_procedure))
							l_current_errors.do_all (agent {E2B_VERIFICATION_ERROR}.set_time (verified_regexp.captured_substring (1).to_real))
							l_current_errors.do_all (agent {E2B_VERIFICATION_ERROR}.process)
							last_result.verification_errors.append (l_current_errors)
--							l_current_error.set_procedure_name (l_current_procedure)
--							l_current_error.set_time (verified_regexp.captured_substring (1).to_real)
--							l_current_error.process
--							last_result.verification_errors.extend (l_current_error)
						end
						l_total_time := l_total_time + verified_regexp.captured_substring (1).to_real
						l_current_errors.wipe_out
						l_current_error := Void
						l_current_procedure := Void

					elseif error_regexp.matches (l_line) then
						-- file: error_regexp.captured_substring (1)
						-- line: error_regexp.captured_substring (2).to_integer
						-- column: error_regexp.captured_substring (3).to_integer
						-- error code: error_regexp.captured_substring (4)
						-- error message: error_regexp.captured_substring (5)
						create l_current_error.make
						l_current_errors.extend (l_current_error)
						l_current_error.set_boogie_location ([
							error_regexp.captured_substring (1),
							error_regexp.captured_substring (2).to_integer,
							error_regexp.captured_substring (3).to_integer
						])
						l_current_error.set_code (error_regexp.captured_substring (4))
						l_current_error.set_message (error_regexp.captured_substring (5))

					elseif related_regexp.matches (l_line) then
						-- file: related_regexp.captured_substring (1)
						-- line: related_regexp.captured_substring (2).to_integer
						-- column: related_regexp.captured_substring (3).to_integer
						-- message: related_regexp.captured_substring (4)
						l_current_error.set_boogie_related_location ([
							related_regexp.captured_substring (1),
							related_regexp.captured_substring (2).to_integer,
							related_regexp.captured_substring (3).to_integer,
							related_regexp.captured_substring (4)
						])

					elseif syntax_error_regexp.matches (l_line) then
						-- file: syntax_error_regexp.captured_substring (1)
						-- line: syntax_error_regexp.captured_substring (2).to_integer
						-- column: syntax_error_regexp.captured_substring (3).to_integer
						-- message: syntax_error_regexp.captured_substring (4)
						last_result.syntax_errors.extend (l_line)

					elseif semantic_error_regexp.matches (l_line) then
						-- file: semantic_error_regexp.captured_substring (1)
						-- line: semantic_error_regexp.captured_substring (2).to_integer
						-- column: semantic_error_regexp.captured_substring (3).to_integer
						-- message: semantic_error_regexp.captured_substring (4)
						check False end
							-- TODO: what kind of errors are these?

					elseif execution_trace_regexp.matches (l_line) then
						-- file: execution_trace_regexp.captured_substring (1)
						-- line: execution_trace_regexp.captured_substring (2).to_integer
						-- column: execution_trace_regexp.captured_substring (3).to_integer
						-- label: execution_trace_regexp.captured_substring (4)
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
		end

feature {NONE} -- Implementation

	lines: LIST [STRING]

feature {NONE} -- Implementation: regular expressions

	version_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for version information line.
		once
			create Result.make
			Result.compile ("^Boogie program verifier version ([^,]*).*$")
		end

	finished_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for finsihed line.
		once
			create Result.make
			Result.compile ("^Boogie program verifier finished with ([0-9]*) verified, ([0-9]*) errors?$")
		end

	verifying_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for verifying section.
		once
			create Result.make
			Result.compile ("^Verifying\s*([\w.$]+)\s*.*$")
		end

	verified_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for verified information line.
		once
			create Result.make
			Result.compile ("^\s*\[([0-9.]*)\s*s\]\s*(\w+)\s*$")
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

end
