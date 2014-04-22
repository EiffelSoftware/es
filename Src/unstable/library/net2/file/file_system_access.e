note
	description: "{FILE_SYSTEM_ACCESS} provides access to common file systems."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	FILE_SYSTEM_ACCESS

feature -- Access
	local_filesystem: separate FILE_SYSTEM
			-- Accesses the local file system
		once
			create {separate LOCAL_FILE_SYSTEM} Result
		end


end
