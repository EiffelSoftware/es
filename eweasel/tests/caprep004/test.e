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
		require
			valid: is_valid
		do
			{RT_CAPTURE_REPLAY}.print_string("routine%N");
		end

	is_valid: BOOLEAN
		do
			Result := True
		end
end

