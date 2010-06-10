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

			{RT_CAPTURE_REPLAY}.print_string (test_memcpy.out + "%N")

			p.memory_free
		end

	test_memcpy: INTEGER
		require
			p_valid: p /= default_pointer
		do
			($Result).memory_copy (p, pointer_size)
		end

feature {NONE}

	pointer_size: INTEGER = 4

end

