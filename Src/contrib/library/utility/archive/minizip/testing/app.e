note
	description: "Summary description for {APP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	APP

create
	make

feature {NONE} -- Initialization

	make
		local
			z,d: PATH
			fut: FILE_UTILITIES
		do
			create fut
			create z.make_from_string ("minizip.zip")
			create d.make_from_string ("output")

			print ("Extract " + z.utf_8_name + " into "+ d.utf_8_name + "%N")

			if fut.file_path_exists (z) then
				{MINIZIP}.unzip_into (z, d, io.error)
			end

			if fut.directory_path_exists (d) then
				create z.make_from_string ("new_minizip.zip")
				{MINIZIP}.zip_to (d, z, io.error)
			end
		end

end
