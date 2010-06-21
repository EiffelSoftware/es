note
	description: "Result of a Boogie run."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_RESULT

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize Boogie result.
		do
			create verified_procedures.make
			create verification_errors.make
			create syntax_errors.make
		end

feature -- Access

	boogie_version: STRING
			-- Boogie version of last run.

	verified_count: INTEGER
			-- Number of verified procedures.

	failed_count: INTEGER
			-- Number of procedures which produced an error.

	total_time: REAL
			-- Total time used for verification.

	verified_procedures: LINKED_LIST [E2B_PROCEDURE_RESULT]
			-- List of verified procedures.

	verification_errors: LINKED_LIST [E2B_VERIFICATION_ERROR]
			-- List of verification errors.

	syntax_errors: LINKED_LIST [STRING]
			-- List of syntax errors.

	boogie_file_lines: LIST [STRING]
			-- List of lines in Boogie file.

feature -- Status report

	has_syntax_errors: BOOLEAN
			-- Did syntax errors occur?
		do
			Result := not syntax_errors.is_empty
		end

	has_verification_errors: BOOLEAN
			-- Did verification errors occur?
		do
			Result := not verification_errors.is_empty
		end

	is_verification_successful: BOOLEAN
			-- Did verification succeed?
		do
			Result := not has_syntax_errors and then not has_verification_errors
		end

feature {E2B_OUTPUT_PARSER} -- Element change

	set_boogie_version (a_version: like boogie_version)
			-- Set `boogie_version' to `a_version'.
		do
			boogie_version := a_version.twin
		ensure
			boogie_version_set: boogie_version.is_equal (a_version)
		end

	set_verified_count (a_count: like verified_count)
			-- Set `verified_count' to `a_count'.
		do
			verified_count := a_count
		ensure
			verified_count_set: verified_count = a_count
		end

	set_failed_count (a_count: like failed_count)
			-- Set `failed_count' to `a_count'.
		do
			failed_count := a_count
		ensure
			failed_count_set: failed_count = a_count
		end

	set_total_time (a_time: like total_time)
			-- Set `total_time' to `a_time'.
		do
			total_time := a_time
		ensure
			total_time_set: total_time = a_time
		end

end
