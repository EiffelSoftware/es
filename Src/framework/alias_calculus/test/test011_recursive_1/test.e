class TEST

create
	make

feature {NONE} -- Creation

	make
		do
			if Current = Current then
				x := y
			else
				x := a
				make
			end
		end

feature -- State

	a, x, y: ANY
		attribute
			create Result
		end

end