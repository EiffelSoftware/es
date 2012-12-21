class TEST

create
	make

feature {NONE} -- Creation

	make
		do
			if Current = Current then
				x := y
			else
				make
				x := a
			end
		end

feature -- State

	a, x, y: ANY
		attribute
			create Result
		end

end