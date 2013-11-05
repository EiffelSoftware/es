class
	CAT_SELF_ASSIGNMENT
	
feature {NONE} -- Test

	self_assignment
		local
			a: INTEGER
		do
			a := 5
			a := a
			b := b
		end
		
	b: INTEGER
	
end
