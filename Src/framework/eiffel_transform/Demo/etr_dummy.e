class
	ETR_DUMMY

feature
	test(a_var: INTEGER) is
			-- test
		do
			io.put_integer(1) -- goal: make this print only if a_var>0
			io.put_integer(5)
		end
		
	bslssda: INTEGER
end
