indexing
	description:
		"[
		]"
	date: "$Date$"
	revision: "$Revision$"

class AFX_BOOGIE_OUTPUT_PARSER

inherit
	SHARED_WORKBENCH
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize Current.
		do
			create on_procedure_verified
		end

feature -- Actions

	on_procedure_verified: ACTION_SEQUENCE [TUPLE [a_procedure_name: STRING; a_result: STRING]]
			-- Actions to be performed when a BPL procedure named `a_procedure_name'
			-- is verified. `a_result' is the output from the prover for that particular procedure

feature -- Basic operations

	parse (a_output: STRING)
			-- Parse `a_output' and call actions in `on_procedure_verified'.
		local
			l_line: STRING
		do
			output_lines := a_output.split ('%N')

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
					elseif syntax_error_regexp.matches (l_line) then
						handle_syntax_error (
							syntax_error_regexp.captured_substring (1),
							syntax_error_regexp.captured_substring (2),
							syntax_error_regexp.captured_substring (3),
							syntax_error_regexp.captured_substring (4))
					elseif semantic_error_regexp.matches (l_line) then
						handle_syntax_error (
							semantic_error_regexp.captured_substring (1),
							semantic_error_regexp.captured_substring (2),
							semantic_error_regexp.captured_substring (3),
							semantic_error_regexp.captured_substring (4))
					else
						-- Ignored line
					end
				end

				output_lines.forth
			end
		end

feature {NONE} -- Implementation

	output_lines: LIST [STRING]
			-- Boogie output lines

	current_class_name: STRING
			-- Current class name

	current_feature_name: STRING
			-- Current feature name

feature {NONE} -- Implementation

	handle_version (a_version: STRING)
			-- Handle version information.
		do
		end

	handle_finished (a_verified, a_errors: STRING)
			-- Handle verification finished information.
		do
		end

	handle_verifying (a_type, a_class, a_feature: STRING)
			-- Handle verifying information.
		do
			current_class_name := a_class.twin
			current_feature_name := a_feature.twin
		end

	handle_verified (a_time, a_result: STRING)
			-- Handle verified information.
		local
			l_result: STRING
		do
			if a_result.is_equal ("error") or a_result.is_equal ("errors") then
				l_result := once "error"
			else
				l_result := once "verified"
			end

			on_procedure_verified.call (["proc.ANY." + current_feature_name, l_result])
		end

	handle_error (a_file, a_line, a_column, a_error, a_message: STRING)
			-- Handle error output.
		do
		end

	handle_related (a_file, a_line, a_column, a_message: STRING)
			-- Handle related information of an error.
		do
		end

	handle_syntax_error (a_file, a_line, a_column, a_message: STRING)
			-- Handle syntax error.
		do
		end

feature {NONE} -- Regular expressions

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
			Result.compile ("^Verifying\s*(\w+)\.(\w+)\.([\w$]+).*$")
		end

	verified_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression for verified information line.
		once
			create Result.make
			Result.compile ("^\s*\[([0-9.]*)\s*s\]\s*(\w+)\s*$")
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

	assert_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression assertion information in Boogie source.
		once
			create Result.make
			Result.compile ("^(.*)// (\w+) (\w+):(\w+)(\s*tag:(\w*))?$")
		end

	instruction_location_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression assertion for instruction location in Boogie source.
		once
			create Result.make
			Result.compile ("^\s*// (.*) --- (.*):(\d+)$")
		end

	procedure_name_regexp: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression assertion for instruction location in Boogie source.
		once
			create Result.make
			Result.compile ("^procedure proc\.(\w*)\.(\w*)\(.*$")
		end

end
