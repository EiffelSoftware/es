class TEST

create
	default_create,
	make

feature {NONE} -- Creation

	make
		do
			t.x.set_z_to_y
			t := t.x
		end

feature -- State

	t, x, y, z: TEST
		attribute
			create Result
		end

feature -- Modification

	set_z_to_y
			-- Set `z' to `y'.
		do
			z := y
		end

end
