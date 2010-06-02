class 
	TEST

inherit
	ISE_EXCEPTION_MANAGER

creation
	make

feature
	
	make
		local
			l_retry: BOOLEAN
			
		do
			if not l_retry then
				{RT_CAPTURE_REPLAY}.print_string("try%N")
				external_routine
			end
		rescue
			{RT_CAPTURE_REPLAY}.print_string("catch%N");
			if attached last_exception as l_ex then
				{RT_CAPTURE_REPLAY}.print_string(l_ex.generating_type);
				{RT_CAPTURE_REPLAY}.print_string("%N");
			end
			l_retry := True
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

end

