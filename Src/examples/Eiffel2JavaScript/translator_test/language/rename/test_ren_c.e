class
	TEST_REN_C

inherit
	TEST_REN_B
		rename foo as foo_b
		redefine bar, unk
		end

create
	make

feature -- Basic Operation

	foo
		do
			output.extend ("C.foo")
		end

	bar
		do
			Precursor
			output.extend ("C.bar")
		end

	unk
		do
			output.extend ("C.unk")
		end

end
