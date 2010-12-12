note
	description: "Constants for users using WINDOWS."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_ENVIRONMENT_WINDOWS

inherit
	RM_ENVIRONMENT

	EXECUTION_ENVIRONMENT

feature

	model_file_path: STRING
		do
			Result := file_in_directory ("rapid_models.res", temp_directory)
		end

	performance_file_path: STRING
		do
			Result := file_in_directory ("rapid_performance.res", temp_directory)
		end

	rapidminer_xml_file_path: STRING
		do
			Result := file_in_directory ("rapid_miner.xml", temp_directory)
		end

	rapidminer_arff_file_path: STRING
		do
			Result := file_in_directory ("rapid_miner.arff", temp_directory)
		end

	rapidminer_working_directory: STRING
		do
			Result := "C:\"
		end

	rapidminer_test_arff_path: STRING
		do
			Result := file_in_directory ("rapid_miner_test.arff", temp_directory)
		end

	rapidminer_command: STRING
		do
			Result := "cmd /C %"rapidminer.bat -f "
		end

feature{NONE} -- Implementation

	temp_directory: STRING
			-- Temp directory from current user
		do
			Result := get ("TEMP")
			if Result = Void then
				Result := ""
			end
		end

	file_in_directory (a_file_name: STRING; a_directory: STRING): STRING
			-- Path for file named `a_file_name' in `a_directory'
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (a_directory)
			l_path.set_file_name (a_file_name)
			Result := l_path.out
		end

end
