class
	A
create
	make

feature
	make is
			-- main
		do
			create b.make
			io.put_string("Creating B")
			io.put_new_line
		end

	b: B

end
