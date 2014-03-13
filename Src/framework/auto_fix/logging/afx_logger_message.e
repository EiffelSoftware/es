note
	description: "Summary description for {AFX_LOGGER_MESSAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_LOGGER_MESSAGE

feature -- Constant messages

	session_started_message: STRING 							= "AutoFix session started"
	session_terminated_message: STRING 							= "AutoFix session terminated"
	session_canceled_message: STRING 							= "AutoFix session CANCELED"

	test_case_analysis_started_message: STRING 					= "Test case analysis started"
	test_case_entered_message: STRING 							= "Test case entered"
	test_case_exited_message: STRING							= "Test case exited"
	break_point_hit_message: STRING 							= "Break point hit"
	test_case_analysis_finished_message: STRING 				= "Test case analysis finished"
	test_case_execution_time_out_message: STRING		 		= "Test case execution TIME OUT"

	implementation_fix_generation_started_message: STRING 		= "Implementation fix generation started"
	implementation_fix_generation_finished_message: STRING 		= "Implementation fix generation finished"
	implementation_fix_validation_started_message: STRING 		= "Implementation fix validation started"
	one_implementation_fix_validation_started_message: STRING	= "Validation of one implementation fix started"
	one_implementation_fix_validation_finished_message: STRING 	= "Validation of one implementation fix finished"
	implementation_fix_validation_finished_message: STRING 		= "Implementation fix validation finished"

	weakest_contract_inference_started_message: STRING 			= "Weakest contract inference started"
	weakest_contract_inference_finished_message: STRING 		= "Weakest contract inference finished"
	contract_fix_generation_started_message: STRING 			= "Contract fix generation started"
	contract_fix_generation_finished_message: STRING 			= "Contract fix generation finished"
	contract_fix_validation_started_message: STRING 			= "Contract fix validation started"
	contract_fix_validation_finished_message: STRING 			= "Contract fix validation finished"

	fix_ranking_started_message: STRING							= "Fix ranking started"
	fix_ranking_finished_message: STRING 						= "Fix ranking finished"

	interpreter_started_message: STRING 						= "Interpreter started"
	interpreter_failed_to_start_message: STRING 				= "Interpreter FAILED to start"

feature -- Auxiliary strings

	section_separator: STRING 				= ": "
	Multi_line_value_start_tag: STRING_8 	= "---multi-line-value-start---"
	Multi_line_value_end_tag: STRING_8 		= "--- multi-line-value-end ---"
end
