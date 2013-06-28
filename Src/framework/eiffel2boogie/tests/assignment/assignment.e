class ASSIGNMENT

feature

	integer_attribute1: INTEGER
	integer_attribute2: INTEGER
	reference_attribute1: ANY
	reference_attribute2: ANY

	locals_assignment
		local
			a, b: INTEGER
			c, d: ANY
		do
			a := 1
			b := 2
			a := b
			check a = 2 end
			c := Void
			d := Current
			c := d
			check c = Current end
		end

	argument_assignment (a: INTEGER; b: ANY)
		require
			a = 3
			b = Current
		local
			c: INTEGER
			d: ANY
		do
			c := a
			check c = 3 end
			d := b
			check d = Current end
		end

	assignment_to_attribute
		do
			integer_attribute1 := 1
			integer_attribute2 := 2
			integer_attribute1 := integer_attribute2
			check integer_attribute1 = 2 end
			reference_attribute1 := Void
			reference_attribute2 := Current
			reference_attribute1 := reference_attribute2
			check reference_attribute1 = Current end
		end

end
