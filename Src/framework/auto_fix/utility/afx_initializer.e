note
	description: "Summary description for {AFX_INITIALIZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_INITIALIZER

inherit
	SHARED_WORKBENCH

feature -- Access

	prepare (a_config: AFX_CONFIG)
		local
			l_path: PATH
			l_file_name: FILE_NAME
			l_dir: KL_DIRECTORY
			l_folder: DIRECTORY
		do
			make_empty_directory (a_config.log_directory)
			make_empty_directory (a_config.data_directory)
			make_empty_directory (a_config.daikon_directory)
			make_empty_directory (a_config.theory_directory)
			make_empty_directory (a_config.fix_directory)
			make_empty_directory (a_config.afx_cluster_directory)
			make_empty_directory (a_config.valid_fix_directory)

			make_empty_directory (a_config.afx_test_cases_directory)
		end

	make_empty_directory (a_dir: PATH)
			-- Make the directory at `a_dir' empty.
			-- Create the directory if not exists.
		local
			l_dir: DIRECTORY
		do
			create l_dir.make_with_path (a_dir)
			if l_dir.exists then
				l_dir.delete_content
			else
				l_dir.recursive_create_dir
			end
		end


end
