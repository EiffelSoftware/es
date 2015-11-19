expanded class
	AATH_EXPANDED

feature

	str1, str2: detachable STRING_8
	int1, int2: INTEGER_32

	set_values (a_str1, a_str2: detachable STRING_8; a_int1, a_int2: INTEGER_32)
		do
			str1 := a_str1
			str2 := a_str2
			int1 := a_int1
			int2 := a_int2
		end

end
