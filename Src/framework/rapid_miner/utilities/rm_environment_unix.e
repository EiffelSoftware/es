note
	description: "Constants for users using UNIX."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_ENVIRONMENT_UNIX

inherit
	RM_ENVIRONMENT

	PROCESS_HELPER

feature

	model_file_path: STRING
		do
			Result := "/tmp/rapid_result.res"
		end

	performance_file_path: STRING
		do
			Result := "/tmp/rapid_performance.res"
		end

	rapidminer_xml_file_path: STRING
		do
			Result := "/tmp/rapid_miner.xml"
		end

	rapidminer_arff_file_path: STRING
		do
			Result := "/tmp/rapid_miner.arff"
		end

	rapidminer_working_directory: STRING
		do
			Result := "/tmp"
		end

	rapidminer_test_arff_path: STRING
		do
			Result := "/tmp/rapid_miner_test.arff"
		end

	rapidminer_command: STRING
		local
			l_path: STRING
		do
			l_path := output_from_program ("which rapidminer", Void)
			if l_path.item (l_path.count) = '%N' then
				l_path.remove_tail (1)
			end
			Result := l_path + " -f "
		end

	temp_directory: STRING
			-- Temp directory from current user
		do
			Result := "/tmp"
		end

end
