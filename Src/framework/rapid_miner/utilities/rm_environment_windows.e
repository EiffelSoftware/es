note
	description: "Constants for users using WINDOWS."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_ENVIRONMENT_WINDOWS

inherit

	RM_ENVIRONMENT

feature

	model_file_path: STRING
		do
			Result := "C:\temp\rapid_model.res"
		end

	performance_file_path: STRING
		do
			Result := "C:\temp\rapid_performance.res"
		end

	rapidminer_xml_file_path: STRING
		do
			Result := "C:\temp\rapid_miner.xml"
		end

	rapidminer_arff_file_path: STRING
		do
			Result := "C:\temp\rapid_miner.arff"
		end

	rapidminer_working_directory: STRING
		do
			Result := "C:\"
		end

	rapidminer_test_arff_path: STRING
		do
			Result := "C:\temp\rapid_miner_test.arff"
		end

	rapidminer_command: STRING
		do
			Result := "cmd /C %"rapidminer.bat -f "
		end


end
