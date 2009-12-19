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
			l_file_name: FILE_NAME
			l_dir: KL_DIRECTORY
		do
			create l_file_name.make_from_string (a_config.log_directory)
			create l_dir.make (l_file_name)
			l_dir.recursive_create_directory

			create l_file_name.make_from_string (a_config.data_directory)
			create l_dir.make (l_file_name)
			l_dir.recursive_create_directory

			create l_file_name.make_from_string (a_config.daikon_directory)
			create l_dir.make (l_file_name)
			l_dir.recursive_create_directory

			prepare_model_repository (a_config)
		end

	prepare_model_repository (a_config: AFX_CONFIG)
		local
			l_file_name: FILE_NAME
			l_dir: KL_DIRECTORY
		do
			create l_file_name.make_from_string (a_config.model_directory)
			create l_dir.make (l_file_name)
			l_dir.recursive_create_directory

			create l_file_name.make_from_string (a_config.forward_model_directory)
			create l_dir.make (l_file_name)
			l_dir.recursive_create_directory

			create l_file_name.make_from_string (a_config.backward_model_directory)
			create l_dir.make (l_file_name)
			l_dir.recursive_create_directory

		end

end
