class
	B

create
	make

feature
	make is
			-- main
		do
			create c
			io.put_string("Creating C")
			io.put_new_line
		end

	c: C

end
