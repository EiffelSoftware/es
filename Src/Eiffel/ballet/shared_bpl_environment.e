indexing
	description: "Ballet environment and helpful routines"
	author: "Bernd Schoeller and others"
	date: "$Date$"
	revision: "$Revision$"

class

	SHARED_BPL_ENVIRONMENT

feature -- Access

	environment: BPL_ENVIRONMENT is
			-- Ballet environement to store global variables
		once
			create Result.make
		end

feature -- Output

	bpl_out (a_string: STRING) is
			-- Adding buffering support for easy output.
		do
			environment.out_stream.put_string (a_string)
		end

	add_error (an_error: BPL_ERROR) is
			-- Record error `an_error'.
		require
			not_void: an_error /= Void
		do
			environment.error_log.extend (an_error)
		ensure
			error_recorded: environment.error_log.has_error
		end

feature -- Label handling

	last_label: STRING is
			-- Last label created by `new_label'
		do
			Result := environment.last_label
		ensure
			not_void: Result /= Void
		end

	new_label (a_prefix: STRING) is
			-- Create a new label.
		require
			not_void: a_prefix /= Void
			not_empty: a_prefix.count >= 1
		do
			environment.new_label (a_prefix)
		end

end
