class 
	TEST
creation
	make
feature
	
	make
		do
			{RT_CAPTURE_REPLAY}.print_string("make output #1%N");
			external_routine
			{RT_CAPTURE_REPLAY}.print_string("make output #2%N");
		end;

	external_routine
		external
			"C inline use <stdio.h>"
		alias
			"[
				printf("external_routine output\n");
			]"
		end

end

