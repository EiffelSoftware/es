indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EIFFEL_PARSER_ERROR_REPORTER

inherit
	SHARED_ERROR_HANDLER
		export
			{NONE} all
		end
	EIFFEL_PARSER_SKELETON
		redefine
			make, reset, make_with_factory, report_error
		end


feature {NONE} -- Initialization

	make is
			-- initialize error reporter
		do
			Precursor
			make_with_max_errors (10)
		end

	make_with_factory (a_factory: AST_FACTORY) is
			-- initialize error reporter
		do
			Precursor(a_factory)
			make_with_max_errors (10)
		end

	make_with_max_errors (a_max_errors: like max_errors) is
			-- Initialize error reporter
		require
			a_max_errors_positive: a_max_errors > 0
		do
			max_errors := a_max_errors
			create leaf_list_as.make (10)
		ensure
			max_errors_set: max_errors = a_max_errors
		end

feature -- Resetting

	reset is
			-- Reset error reporter
		do
			Precursor
			error_counter := 0
		ensure then
			error_counter_reset: error_counter = 0
		end

feature -- Access

	leaf_list_as: LEAF_AS_LIST

	max_errors: INTEGER
			-- Maximum number of errors that can be reported

	error_counter: INTEGER
			-- Number of errors generated

	parser_errors: EIFFEL_PARSER_ERRORS is
			-- Parser errors
		once
			create Result
		ensure
			result_attached: Result /= Void
		end


feature -- Reporting

	report_error (a_message: STRING) is
			-- A syntax error has been detected.
			-- Print error message.
		local
--			l_error: SYNTAX_ERROR
		do
--			create l_error.make (line, column, filename, a_message, False)
--			insert_error (l_error, true)
		end

	report_warning (a_warning: STRING; a_target_as: AST_EIFFEL) is
			-- Reports a warning `a_warning' in class text.
		require
			a_warning_attached: a_warning /= Void
			not_a_warning_is_empty: not a_warning.is_empty
		local
			l_loc: LOCATION_AS
			l_line: INTEGER
			l_column: INTEGER
		do
			if has_syntax_warning then
				if a_target_as /= Void then
					l_loc := a_target_as.complete_start_location (leaf_list_as)
					l_line := l_loc.line
					l_column := l_loc.column
				else
					l_line := line
					l_column := column
				end
				error_handler.insert_warning (create {SYNTAX_WARNING}.make (l_line, l_column, filename, a_warning))
			end
		end

	report_syntax_error_message (a_message: STRING; a_target_as: AST_EIFFEL; a_fatal: BOOLEAN) is
			-- Reports a syntax error with a specified message `a_message' on AS node `a_target_as'.
		require
			a_message_attached: a_message /= Void
			not_a_message_is_empty: not a_message.is_empty
		local
			l_loc: LOCATION_AS
			l_line: INTEGER
			l_column: INTEGER
			l_error: SYNTAX_ERROR
		do
			if a_target_as /= Void then
				l_loc := a_target_as.complete_start_location (leaf_list_as)
				l_line := l_loc.line
				l_column := l_loc.column
			else
				l_line := line
				l_column := column
			end
			create l_error.make (l_line, l_column, filename, a_message, false)
			insert_error (l_error, a_fatal)
		end

	report_expected_match_error (a_opener: STRING; a_opener_as: AST_EIFFEL; a_missing: STRING; a_target_as: AST_EIFFEL; a_fatal: BOOLEAN) is
			-- Reports an unmatched closer error for `a_opener', associated with `a_opener_as'.
			-- `a_missing' is required missing closer for `a_opener' that should appear at `a_target'.
		require
			a_opener_attached: a_opener /= Void
			not_a_opener_is_empty: not a_opener.is_empty
			a_missing_attached: a_missing /= Void
			not_a_missing_is_empty: not a_missing.is_empty
		local
			l_error: SYNTAX_UNMATCHED_ERROR
			l_loc: LOCATION_AS
			l_line: INTEGER
			l_column: INTEGER
			l_opener_line: INTEGER
			l_opener_column: INTEGER
		do
			if a_target_as /= Void then
				l_loc := a_target_as.complete_start_location (leaf_list_as)
				l_line := l_loc.line
				l_column := l_loc.column
			else
				l_line := line
				l_column := column
			end
			if a_opener_as /= Void then
				l_loc := a_opener_as.complete_start_location (leaf_list_as)
				l_opener_line := l_loc.line
				l_opener_column := l_loc.column
			else
				l_opener_line := l_line
				l_opener_column := l_column
			end
			create l_error.make (l_line, l_column, l_opener_line, l_opener_column, a_opener, a_missing, void, filename)
			insert_error (l_error, a_fatal)
		end

	report_expected_error (a_expected: STRING; a_use_text: BOOLEAN; a_target_as: AST_EIFFEL; a_fatal: BOOLEAN) is
			-- Report a expected entity `a_expected', where non was found, syntax error and there is no previous
			-- context to use.
			-- `a_use_text' will retrieve found text from parser.
		require
			a_expected_attached: a_expected /= Void
			not_a_expected_is_empty: not a_expected.is_empty
		local
			l_error: SYNTAX_EXPECTED_ERROR
			l_source_loc: LOCATION_AS
			l_line: INTEGER
			l_column: INTEGER
			l_text: STRING
		do
			if a_target_as /= Void then
				l_source_loc := a_target_as.complete_start_location (leaf_list_as)
				l_line := l_source_loc.line
				l_column := l_source_loc.column
			else
				l_line := line
				l_column := column
			end
			if a_use_text then
				l_text := text
			end
			create l_error.make (l_line, l_column, a_expected, l_text, filename)
			insert_error (l_error, a_fatal)
		end

	report_unexpected_error (a_unexpected: STRING; a_target_as: AST_EIFFEL; a_fatal: BOOLEAN) is
			-- Report an unexpected text `a_unexpected' error for AS node `a_target_as'.
		require
			a_unexpected_attached: a_unexpected /= Void
			not_a_unexpected_is_empty: not a_unexpected.is_empty
		local
			l_error: SYNTAX_UNEXPECTED_ERROR
			l_loc: LOCATION_AS
			l_line: INTEGER
			l_column: INTEGER
		do
			if a_target_as /= Void then
				l_loc := a_target_as.complete_start_location (leaf_list_as)
				l_line := l_loc.line
				l_column := l_loc.column
			else
				l_line := line
				l_column := column
			end
			create l_error.make (l_line, l_column, a_unexpected, filename)
			insert_error (l_error, a_fatal)
		end

	report_expected_after_error (a_identifer: STRING; a_id: AST_EIFFEL; a_expected: STRING; a_fatal: BOOLEAN) is
			-- Report an expected text `a_expected' that should be found after `a_identifer' (associated with AS node `a_id')
		require
			a_identifer_attached: a_identifer /= Void
			not_a_identifer_is_empty: not a_identifer.is_empty
			a_expected_attached: a_expected /= Void
			not_a_expected_is_empty: not a_expected.is_empty
		local
			l_error: SYNTAX_EXPECTED_AFTER_ERROR
			l_loc: LOCATION_AS
			l_line: INTEGER
			l_column: INTEGER
		do
			if a_id /= Void then
				l_loc := a_id.complete_start_location (leaf_list_as)
				l_line := l_loc.line
				l_column := l_loc.column
			else
				l_line := line
				l_column := column
			end
			create l_error.make (l_line, l_column, a_identifer, a_expected, filename)
			insert_error (l_error, a_fatal)
		end

	report_expected_before_error (a_identifer: STRING; a_id: AST_EIFFEL; a_expected: STRING; a_fatal: BOOLEAN) is
			-- Report an expected text `a_expected' that should be found before `a_identifer' (associated with AS node `a_id')
		require
			a_identifer_attached: a_identifer /= Void
			not_a_identifer_is_empty: not a_identifer.is_empty
			a_expected_attached: a_expected /= Void
			not_a_expected_is_empty: not a_expected.is_empty
		local
			l_error: SYNTAX_EXPECTED_BEFORE_ERROR
			l_loc: LOCATION_AS
			l_line: INTEGER
			l_column: INTEGER
		do
			if a_id /= Void then
				l_loc := a_id.complete_start_location (leaf_list_as)
				l_line := l_loc.line
				l_column := l_loc.column
			else
				l_line := line
				l_column := column
			end
			create l_error.make (l_line, l_column, a_identifer, a_expected, filename)
			insert_error (l_error, a_fatal)
		end

feature {NONE} -- Implementation

	insert_error (a_error: SYNTAX_ERROR; a_fatal: BOOLEAN) is
			-- Inserts `a_error' into list of syntax errors.
			-- Use `a_fatal' to determine if error cannot be recovered
		require
			a_error_attached: a_error /= Void
		local
			l_count: like error_counter
		do
			l_count := error_counter
			if l_count < max_errors then
				error_handler.insert_error (a_error)
				error_counter := l_count + 1
			else
				abort
			end
			if a_fatal or not recoverable_parser then
				error_handler.raise_error
				abort
			end
		end


invariant
	error_counter_small_enough: error_counter <= max_errors

end -- class EIFFEL_PARSER_ERROR_REPORTER
