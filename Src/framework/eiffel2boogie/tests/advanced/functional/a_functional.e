class A_FUNCTIONAL

feature

	not_functional1
		note
			status: functional
		do
		end

	not_functional2: INTEGER
		note
			status: functional
		local
			a: INTEGER
		do
			a := 1
			Result := a
		end

	call_not_functional
		local
			a: INTEGER
		do
			not_functional1
			a := not_functional2
		end

	functional1: INTEGER
		note
			status: functional
		do
			Result := 7
		end

	functional2 (a: INTEGER): INTEGER
		note
			status: functional
		do
			Result := a + 4
		end

	call_functional
		do
			check functional1 = 7 end
			check functional2 (1) = 5 end
			check functional2 (2) = 6 end
		end

end
