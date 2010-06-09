class
	TEST
creation
	make
feature

	make
		do
			test_pointer_inline
			test_typed_pointer_inline
		end

	test_pointer_inline
		local
			p, cp, rp: POINTER
		do
			p := p.memory_alloc (pointer_size)
			{RT_CAPTURE_REPLAY}.print_string ("p: " + p.out + "%N")
			p.memory_free()

			cp := cp.memory_alloc (pointer_size)
			{RT_CAPTURE_REPLAY}.print_string ("cp: " + cp.out + "%N")
			
			rp := cp.memory_realloc (16*pointer_size)
			{RT_CAPTURE_REPLAY}.print_string ("rp: " + rp.out + "%N")
			rp.memory_free()
		end

	test_typed_pointer_inline
		local
			a,b: INTEGER
			t: TYPED_POINTER [INTEGER]
		do
			a := 100
			t := $b

			{RT_CAPTURE_REPLAY}.print_string("a: " + a.out + " b: " + b.out + "%N")

			t.memory_copy ($a, pointer_size)
			{RT_CAPTURE_REPLAY}.print_string("a: " + a.out + " b: " + b.out + "%N")

			a := -5
			t.memory_move ($a, pointer_size)
			{RT_CAPTURE_REPLAY}.print_string("a: " + a.out + " b: " + b.out + "%N")

			t.memory_set (0, pointer_size)
			{RT_CAPTURE_REPLAY}.print_string("a: " + a.out + " b: " + b.out + "%N")
		end

	test_typed_pointer_external
		local
		do
		end

feature {NONE}

	pointer_size: INTEGER = 4

end

