class
	ETR_DUMMY

feature
	test(a_var: INTEGER) is
			-- test
		do
			io.putint(1) -- goal: make this print only if a_var>0
			io.putint(2)
		end
		
	bslssda: INTEGER
end
