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

	rapid_miner_xml_file_path: STRING
		do
			Result := "C:\temp\rapid_miner.xml"
		end

	rapid_miner_arff_file_path: STRING
		do
			Result := "C:\temp\rapid_miner.arff"
		end

	rapid_miner_working_directory: STRING
		do
			Result := "C:\"
		end

	rapid_miner_test_arff_path: STRING
		do
			Result := "C:\temp\rapid_miner_test.arff"
		end


end
