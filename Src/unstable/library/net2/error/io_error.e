note
	description: "Summary description for {IO_ERROR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	IO_ERROR

inherit
	ANY
		redefine
			out
		end

create
	default_create

create {IO_ERROR}
	make

feature {NONE} -- Initialization

	make (a_code: INTEGER)
		do
			code := a_code
		end

feature -- Access
	no_error: IO_ERROR
		do
		end

	file_exists: IO_ERROR
		do
			create Result.make (11)
		end

	file_not_found: IO_ERROR
		do
			create Result.make (12)
		end

	timeout: IO_ERROR
		do
			create Result.make (20)
		end

	last_character_incomplete: IO_ERROR
		do
			create Result.make (1020)
		end

	unknown: IO_ERROR
		do
			create Result.make (-1)
		end

feature -- Status report
	is_no_error: BOOLEAN
		do
			Result := Current = no_error
		end

	is_file_exists: BOOLEAN
		do
			Result := Current = file_exists
		end

	is_file_not_found: BOOLEAN
		do
			Result := Current = file_not_found
		end

	is_timeout: BOOLEAN
		do
			Result := Current = timeout
		end

	is_last_character_incomplete: BOOLEAN
		do
			Result := Current = last_character_incomplete
		end

	is_unknown: BOOLEAN
		do
			Result := Current = unknown
		end

feature -- Conversion
	from_nspr (a_nspr_error: PR_ERROR): IO_ERROR
		do
			if a_nspr_error.code = a_nspr_error.c.pr_file_exists_error then
				Result := file_exists
			elseif a_nspr_error.code = a_nspr_error.c.pr_file_not_found_error then
				Result := file_not_found
			elseif a_nspr_error.code = a_nspr_error.c.pr_connect_timeout_error then
				Result := timeout
			elseif a_nspr_error.code = a_nspr_error.c.pr_io_timeout_error then
				Result := timeout
			else
				Result := unknown
			end
		end

	out: STRING
		do
			if is_no_error then
				Result := "No error"
			elseif is_file_exists then
				Result := "File exists"
			elseif is_file_not_found then
				Result := "File not found"
			elseif is_timeout then
				Result := "Timeout"
			elseif is_last_character_incomplete then
				Result := "Last character was received incomplete"
			else
				Result := "Unknown error"
			end
		end

feature {NONE} -- Implementation
	code: INTEGER

end
