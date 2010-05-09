note
	description: "Shared messages"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_MESSAGES

feature -- Access

	msg_contract_inference_started: STRING = "Contract inference started."

	msg_contract_inference_ended: STRING = "Contract inference ended."

	msg_test_case_execution_started: STRING = "Test case execution started."

	msg_test_class_name: STRING = "Test case: "

	msg_found_test_case: STRING = "Found test case: "

	msg_feature_under_test: STRING = "Feauture under test: "

	msg_separator: STRING = "----------------------------------------------------------------------------"

end
