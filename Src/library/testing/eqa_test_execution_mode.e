note
	description: "Summary description for {EQA_TEST_EXECUTION_MODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EQA_TEST_EXECUTION_MODE

create
	default_create

feature -- Constants

	Mode_default: INTEGER = 0
			-- Default test type.

	Mode_execute: INTEGER = 1
			-- Mode where the test is executed.

	Mode_monitor: INTEGER = 2
			-- Mode where the execution of the test would be monitored.

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
