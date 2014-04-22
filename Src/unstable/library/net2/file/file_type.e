note
	description: "{FILE_TYPE} represents the different fundamental types of files, e.g. regular files or directories."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	FILE_TYPE

create
	default_create

create {FILE_TYPE}
	make

feature {NONE} -- Initialization
	make (a_type: INTEGER)
		do
			type := a_type
		end

feature -- Types
	unknown: FILE_TYPE
			-- Unknown file type
		do
		end

	regular: FILE_TYPE
			-- Regular file
		do
			create Result.make (1)
		end

	directory: FILE_TYPE
			-- Directory
		do
			create Result.make (2)
		end

	link: FILE_TYPE
			-- Symbolic link
		do
			create Result.make (3)
		end

	block: FILE_TYPE
			-- Block device
		do
			create Result.make (4)
		end

	character: FILE_TYPE
			-- Character device
		do
			create Result.make (5)
		end

	socket: FILE_TYPE
			-- Socket
		do
			create Result.make (6)
		end

	pipe: FILE_TYPE
			-- Pipe
		do
			create Result.make (7)
		end

feature {NONE} -- Implementation
	type: INTEGER

end
