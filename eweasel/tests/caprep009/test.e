class
	TEST

inherit
	IDENTIFIED

creation
	make

feature


	make
		local
			str1, str2: STRING
		do
			str1 := "abc"
			str2 := "xyz"
			copy_string_content (str1, str2)

			if str1.same_string (str2) then
				{RT_CAPTURE_REPLAY}.print_string ("copy ok%N")
			end
		end

feature {NONE}

	copy_string_content (dest, src: STRING)
		external
			"C inline use %"eif_macros.h%""
		alias
			"[
				memcpy((void *) *((EIF_REFERENCE *) eif_access(arg1)), (void *) *((EIF_REFERENCE *) eif_access(arg2)), 4);
			]"
		end


end

