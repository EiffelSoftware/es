class
	TEST

inherit
	ISE_EXCEPTION_MANAGER

creation
	make

feature

	make
		local
			l_retry_count: NATURAL
		do
			inspect
				l_retry_count
			when 0 then
				{RT_CAPTURE_REPLAY}.print_string("try external%N")
				external_routine
			when 1 then
				{RT_CAPTURE_REPLAY}.print_string("try eiffel%N")
				(agent eiffel_routine).call (Void)
			else
				{RT_CAPTURE_REPLAY}.print_string("try nothing%N")
				(agent do_nothing).call (Void)
			end
		rescue
			l_retry_count := l_retry_count + 1
			{RT_CAPTURE_REPLAY}.print_string("catch " + l_retry_count.out + "%N")
			retry
		end

	external_routine
		external
			"C inline use <stdio.h>"
		alias
			"[
				printf("external_routine\n");
				eraise("external_exception", EN_EXT);
			]"
		ensure
			never_returns: False
		end

	eiffel_routine
		do
			print ("eiffel_routine%N")
			(create {EXCEPTION_MANAGER}).raise (create {DEVELOPER_EXCEPTION})
		end

end

