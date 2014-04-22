note
	description: "{EPATH} represents the path within a file system. Under construction."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	EPATH

create
	default_create,
	from_string

feature {NONE} -- Initialization
	from_string (a_string: ESTRING_8)
		require
			valid_path_string (a_string)
		do
			internal := a_string.replace ('\', '/')
		end

feature
	internal: ESTRING_8

	valid_path_string (a_string: ESTRING_8): BOOLEAN
		do
			-- Todo
			Result := not a_string.has (':') and not a_string.has (';')
		end

end
