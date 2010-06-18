class
	TEST

inherit
	IDENTIFIED

creation
	make

feature


	make
		do
			{RT_CAPTURE_REPLAY}.print_string (create_external_string)
		end

feature {NONE}

	create_external_string: STRING
		external
			"C inline use %"eif_macros.h%""
		alias
			"[
				char *content = "C string\n";
				return makestr(content, strlen(content));
			]"
		end


end

