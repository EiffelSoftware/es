class
	TEST

creation
	make

feature

	make
		local
			l_file: RAW_FILE
		do
			(agent print_something).call (Void)

			create l_file.make ("object.txt")
			l_file.open_write
			l_file.independent_store (storable)
			l_file.close

			l_file.open_read
			if l_file.retrieved.is_deep_equal (storable) then
				{RT_CAPTURE_REPLAY}.print_string ("OK%N")
			end
			l_file.close;

			(agent print_something).call (Void)
		end

	print_something
		do
			{RT_CAPTURE_REPLAY}.print_string ("something%N")
		end

feature {NONE}

	storable: LINKED_LIST [ANY]
		do
			create Result.make

			Result.extend (create {ANY})

			Result.extend ("A string")

			Result.extend ({NATURAL_64} 5)

			Result.extend ({INTEGER_8} -1)
		end

end

