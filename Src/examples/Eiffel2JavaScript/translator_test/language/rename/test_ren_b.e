class
	TEST_REN_B

inherit
	TEST_REN_A
		rename foo as foo_a
		redefine bar
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create {LINKED_LIST[attached STRING]}output.make
		end

feature -- Basic Operation

	foo
		do
			output.extend ("B.foo")
		end

	bar
		do
			Precursor
			output.extend ("B.bar")
		end

	unk
		do
			output.extend ("B.unk")
		end

end
