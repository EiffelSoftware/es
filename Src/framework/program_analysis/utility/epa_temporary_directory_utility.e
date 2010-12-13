note
	description: "Class to provide directory for temporary files"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_TEMPORARY_DIRECTORY_UTILITY

feature -- Access

	temporary_directory: STRING
			-- Temp directory from current user
		local
			l_env: EXECUTION_ENVIRONMENT
		do
			if {PLATFORM}.is_windows then
				create l_env
				Result := l_env.get ("TEMP")
				if Result = Void then
					Result := ""
				end
			else
				Result := "/tmp"
			end
		end

	file_in_temporary_directory (a_file_name: STRING): STRING
			-- Absolute path for a file named `a_file_name' in
			-- `temporary_directory'
		local
			l_file_name: FILE_NAME
		do
			create l_file_name.make_from_string (temporary_directory)
			l_file_name.set_file_name (a_file_name)
			Result := l_file_name.out
		end

end
