class
	TEST_RESCUE

inherit
	TEST

create
	make

feature {NONE} -- Initialization

	make
		do
			invoke_test ("1", agent
				local
					has_failed: BOOLEAN
					l_control_flow_check: INTEGER
				do
					assert (l_control_flow_check = 0 or l_control_flow_check = 1011)
					l_control_flow_check := l_control_flow_check + 1
					assert (l_control_flow_check = 1 or l_control_flow_check = 1012)
					if not has_failed then
						l_control_flow_check := l_control_flow_check + 10
						assert (l_control_flow_check = 11)
						throw_error
						assert (false)
					else
						l_control_flow_check := l_control_flow_check + 100
						assert (l_control_flow_check = 1112)
					end
				rescue
					l_control_flow_check := l_control_flow_check + 1000
					assert (l_control_flow_check = 1011)
					has_failed := true
					retry
				end
			)
			invoke_test ("2", agent
				local
					has_failed: BOOLEAN
					l_control_flow_check: INTEGER
				do
					expects_exception := true

					assert (l_control_flow_check = 0)
					l_control_flow_check := l_control_flow_check + 1
					assert (l_control_flow_check = 1)
					if not has_failed then
						l_control_flow_check := l_control_flow_check + 10
						assert (l_control_flow_check = 11)
						throw_error
						assert (false)
					else
						assert (false)
					end
				rescue
					l_control_flow_check := l_control_flow_check + 1000
					assert (l_control_flow_check = 1011)
					has_failed := true
				end
			)
		end

feature {NONE} -- Implementation

	throw_error
		require
			false_: false
		do

		end

end
