class 
	TEST
creation
	make
feature
	
	make
		do
			{RT_CAPTURE_REPLAY}.print_string("make%N");
			(agent routine).call (Void)
			{RT_CAPTURE_REPLAY}.print_string("make%N");
		end;

	routine
		do
			{RT_CAPTURE_REPLAY}.print_string("routine%N");
		end

end

