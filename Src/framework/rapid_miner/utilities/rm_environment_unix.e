note
	description: "Constants for users using UNIX."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_ENVIRONMENT_UNIX

inherit
	RM_ENVIRONMENT

feature

	model_file_path: STRING
		do
			Result := "/tmp/rapid_result.res"
		end

	performance_file_path: STRING
		do
			Result := "/tmp/rapid_performance.res"
		end

	rapid_miner_xml_file_path: STRING
		do
			Result := "/tmp/rapid_miner.xml"
		end

	rapid_miner_arff_file_path: STRING
		do
			Result := "/tmp/rapid_miner.arff"
		end

	rapid_miner_working_directory: STRING
		do
			Result := "/home/"
		end

	rapid_miner_test_arff_path: STRING
		do
			Result := "/tmp/rapid_miner_test.arff"
		end

end
