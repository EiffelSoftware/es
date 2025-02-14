note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	NEW_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test routines

	new_minizip
			-- New test routine
		note
			testing:  "MINIZIP"
		local
			exec: EXECUTION_ENVIRONMENT
			tmp: PATH
			l_archive: PATH
			dir: DIRECTORY
			fut: FILE_UTILITIES
		do
			create exec
			create tmp.make_from_string ("MINIZIP")
			if attached exec.temporary_directory_path as t then
				tmp := t.extended_path (tmp)
			end
			create dir.make_with_path (tmp)
			if not dir.exists then
				dir.recursive_create_dir
			end

			l_archive := tmp.extended ("archive.zip")
			{MINIZIP}.zip_to (exec.current_working_path, l_archive, io.output)

			assert ("archive created", fut.file_path_exists (l_archive))

			tmp := tmp.extended ("extraction")
			create dir.make_with_path (tmp)
			if dir.exists then
				dir.recursive_delete
			end
			dir.recursive_create_dir
			{MINIZIP}.unzip_into (l_archive, tmp, io.output)

		end

end


