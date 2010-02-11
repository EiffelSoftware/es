note
	description: "[
		Constants used by interpeter
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ITP_SHARED_CONSTANTS

feature -- AutoTest socket request flags

	start_request_flag: NATURAL_8 = 1
			-- Flag for "start" request

	quit_request_flag: NATURAL_8 = 2
			-- Flag for "quit" request

	execute_request_flag: NATURAL_8 = 3
			-- Flag for "execute" request

	type_request_flag: NATURAL_8 = 4
			-- Flag for "type" request

	object_state_request_flag: NATURAL_8 = 5
			-- Flag for "state" request

	precondition_evaluation_request_flag: NATURAL_8 = 6
			-- Flag for "precondition" request

	predicate_evaluation_request_flag: NATURAL_8 = 7
			-- Flag for "predicate" request			

feature -- AutoTest socket reponse flags

	normal_response_flag: NATURAL_8 = 1
			-- Flag to indicate a normal response

	invariant_violation_on_entry_response_flag: NATURAL_8 = 2
			-- Flag to indicate that there is a class invariant
			-- violation on entry of testee feature

	internal_error_respones_flag: NATURAL_8 = 3
			-- Flag to indicate that there is an internal error
			-- in the interpreter.

	object_is_void_flag: NATURAL_8 = 4
			-- Flag to indicate that the object involed in state query is void

feature -- Index for extra data

	extra_data_index_precondition_satisfaction: INTEGER is 1
			-- Index for precondition satisfaction

	extra_data_index_test_case_serialization: INTEGER is 2
			-- Index for test case serialization on the fly

feature -- Strings

	nonsensical: STRING is "nonsensical"
			-- Nonsensical value

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
