class
	APPLICATION
create
	make
feature

	make is
			-- Used to test call chain in object tests
		local
			a : separate A

		do
			create a.make

			print_it(a)


		end

	print_it(l_a: attached separate A) is
			--prints

		do
			if {try: separate C} l_a.b.c then
				try.print_it
			else
				io.put_string ("FAILED")
				io.new_line
			end
		end

end
