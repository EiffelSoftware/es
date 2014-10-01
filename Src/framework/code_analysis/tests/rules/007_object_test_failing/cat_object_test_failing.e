class
	CAT_OBJECT_TEST_FAILING

feature {NONE} -- Test

	object_test
		local
			l_string: STRING
			l_int: INTEGER
			l_char: CHARACTER
		do
			if attached {CAT_EMPTY_LOOP} l_string as fuckyou then
			end
			if attached {STRING} l_string as fuckyou then
			end
			if attached {ANY} l_string as fuckyou then
			end
			if attached {CAT_OBJECT_TEST_FAILING} l_int as fuckyou then
			end
			if attached {STRING} l_char as fuckyou then
			end
			if attached {CAT_EMPTY_LOOP} l_char as fuckyou then
			end
			if attached {STRING} l_int as fuckyou then
			end
			if attached {CAT_SELF_ASSIGNMENT} l_int as fuckyou then
			end
		end

end
