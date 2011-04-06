class
	TEST_STRING

inherit
	TEST

create
	make

feature {NONE} -- Initialization

	make
		do
			invoke_test ("1", agent
				local
					l_str: STRING
				do
					l_str := "Hello!"
					assert (l_str.as_upper.is_equal ("HELLO!"))
					assert (l_str.as_lower.is_equal ("hello!"))
					assert (l_str.at(1) = 'H')
					assert (l_str.at(2) = 'e')
					assert (l_str.at(3) = 'l')
					assert (l_str.at(4) = 'l')
					assert (l_str.at(5) = 'o')
					assert (l_str.at(6) = '!')
					assert (l_str.count = 6)
					assert (l_str.has('H'))
					assert (l_str.has('!'))
					assert (not l_str.has('h'))
					assert (l_str.has_substring("Hello!"))
					assert (l_str.has_substring("H"))
					assert (l_str.has_substring("ell"))
					assert (l_str.has_substring("!"))
					assert (not l_str.has_substring("Hello!1"))
					assert (not l_str.has_substring("lla"))
					assert (l_str.index_of ('H', 1) = 1)
					assert (l_str.index_of ('H', 2) = 0)
					assert (l_str.index_of ('e', 1) = 2)
					assert (l_str.index_of ('e', 2) = 2)
					assert (l_str.index_of ('e', 3) = 0)
					assert (l_str.index_of ('l', 1) = 3)
					assert (l_str.index_of ('l', 2) = 3)
					assert (l_str.index_of ('l', 3) = 3)
					assert (l_str.index_of ('l', 4) = 4)
					assert (l_str.index_of ('l', 5) = 0)
					assert (l_str.index_of ('o', 5) = 5)
					assert (l_str.index_of ('!', 6) = 6)
					assert (l_str.last_index_of ('!', 6) = 6)
					assert (l_str.last_index_of ('!', 5) = 0)
					assert (l_str.last_index_of ('l', 6) = 4)
					assert (l_str.last_index_of ('l', 5) = 4)
					assert (l_str.last_index_of ('l', 4) = 4)
					assert (l_str.last_index_of ('l', 3) = 3)
					assert (l_str.last_index_of ('l', 2) = 0)
					assert (l_str.substring_index("H", 1) = 1)
					assert (l_str.substring_index("H", 2) = 0)
					assert (l_str.substring_index("Hell", 1) = 1)
					assert (l_str.substring_index("Hell", 2) = 0)
					assert (l_str.substring_index("l", 1) = 3)
					assert (l_str.substring_index("ll", 1) = 3)
					assert (l_str.substring_index("ll", 3) = 3)
					assert (l_str.substring_index("1", 1) = 0)
					assert (l_str.substring_index("Hello!", 1) = 1)
				end
			)
			invoke_test ("2", agent
				local
					l_str: STRING
					l_pi1: DOUBLE
					l_pi2: REAL
				do
					l_str := "3.141592653589793238462643383279502884197169399375105820974944592"
					assert (l_str.is_double)
					assert (l_str.is_real)

					l_pi1 := l_str.to_double
					assert (l_pi1 = 3.141592653589793238462643383279502884197169399375105820974944592)

					l_pi2 := l_str.to_real
					assert (l_pi2 = 3.141592653589793238462643383279502884197169399375105820974944592)

					l_str.keep_head (1)
					assert (l_str.is_equal ("3"))
					assert (l_str.is_double)
					assert (l_str.is_real)
					assert (l_str.is_integer)
					assert (l_str.is_natural)

					l_str.keep_head (0)
					l_str.append ("true")
					assert (l_str.is_boolean)
					assert (l_str.to_boolean = true)

					l_str.append ("false")
					l_str.keep_tail (5)
					assert (l_str.is_boolean)
					assert (l_str.to_boolean = false)

					l_str.prepend ("Hello ")
					assert (l_str.is_equal ("Hello false"))

					l_str.insert_string ("world", 7)
					assert (l_str.is_equal ("Hello worldfalse"))

					l_str.insert_character ('!', 12)
					assert (l_str.is_equal ("Hello world!false"))

					l_str.remove_tail (5)
					assert (l_str.is_equal ("Hello world!"))

					assert (l_str.starts_with ("Hello world!"))
					assert (l_str.starts_with (""))
					assert (l_str.starts_with ("H"))
				end
			)
			invoke_test ("3", agent
				local
					l_str: STRING
					l_pieces: LIST[attached STRING]
				do
					l_str := "Hello World!"
					l_pieces := l_str.split (' ')
					assert (l_pieces.count = 2)
					assert (l_pieces[1].is_equal ("Hello"))
					assert (l_pieces[2].is_equal ("World!"))

					l_str := "%T%N    Hallo moto !   %T%N"
					assert (not l_str.starts_with ("Hallo"))

					l_str.left_adjust
					assert (l_str.starts_with ("Hallo"))

					l_str.right_adjust
					assert (l_str.ends_with ("moto !"))

					assert (l_str.is_equal ("Hallo moto !"))

					l_str.keep_head (6)
					assert (l_str.is_equal ("Hallo "))

					l_str.append ("world!")
					assert (l_str.is_equal ("Hallo world!"))

					l_str.keep_tail (7)
					assert (l_str.is_equal (" world!"))

					l_str.prepend ("Goodbye")
					assert (l_str.is_equal ("Goodbye world!"))
				end
			)
		end

end
