indexing
	description: "Log of errors in BPL"
	author: "Bernd Schoeller "
	date: "$Date$"
	revision: "$Revision$"

class
	BPL_ERROR_LOG

create

	make

feature{NONE} -- Initialisation

	make is
			-- Create an empty log
		do
			create error_list.make
		ensure
			no_errors: not has_error
		end

feature -- Access

	error_count: INTEGER is
			-- Number of errors in the log
		do
			Result := error_list.count
		end

	error_list: LINKED_LIST[BPL_ERROR]

feature -- Status report

	has_error: BOOLEAN is
			-- Was an error registered?
		do
			Result := not error_list.is_empty
		end

feature -- Record errors

	extend (an_error: BPL_ERROR) is
			-- Add `an_error' to the list of reported errors.
		require
			not_void: an_error /= Void
		do
			error_list.extend (an_error)
		ensure
			error_recorded: error_count = old error_count + 1
		end

feature -- Reset

	reset is
			-- Reset the error log, cleaning all errors
		do
			error_list.wipe_out
		ensure
			no_errors: not has_error
		end

invariant
	error_list_not_void: error_list /= Void
	error_count_positive: error_count >= 0
	has_error_error_count_relation: has_error = (error_count > 0)
end
