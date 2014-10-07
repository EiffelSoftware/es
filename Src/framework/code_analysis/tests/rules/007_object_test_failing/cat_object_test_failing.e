class
	CAT_OBJECT_TEST_FAILING

feature {NONE} -- Test

	object_test
		local
			l_string: STRING
			l_int: INTEGER
			l_char: CHARACTER
		do
			if attached {CAT_EMPTY_LOOP} l_string then
			end
			if attached {STRING} l_string then
			end
			if attached {ANY} l_string then
			end
			if attached {CAT_OBJECT_TEST_FAILING} l_int then
			end
			if attached {STRING} l_char then
			end
			if attached {CAT_EMPTY_LOOP} l_char then
			end
			if attached {STRING} l_int then
			end
			if attached {CAT_SELF_ASSIGNMENT} l_int then
			end
		end

end
