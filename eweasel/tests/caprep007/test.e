class
	TEST
creation
	make
feature

	p: POINTER

	make
		local
			i: INTEGER
		do
			i := -1
			p := p.memory_alloc (pointer_size)
			p.memory_copy ($i, pointer_size)

			{RT_CAPTURE_REPLAY}.print_string (test_memcpy_result.out + "%N")

			{RT_CAPTURE_REPLAY}.print_string (test_memcpy_local.out + "%N")

			p.memory_free
		end

	test_memcpy_result: INTEGER
		require
			p_valid: p /= default_pointer
		do
			($Result).memory_copy (p, pointer_size)
		end

	test_memcpy_local: INTEGER
		require
			p_valid: p /= default_pointer
		local
			l_result: INTEGER
		do
			($l_result).memory_copy (p, pointer_size)
			Result := l_result
		end

feature {NONE}

	pointer_size: INTEGER = 4

end

