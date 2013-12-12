note
	description: "Finite sequence."
	author: "Nadia Polikarpova"

class
	MML_SEQUENCE [G]

inherit
	ANY
		redefine
			default_create
		end

	ITERABLE [G]
		redefine
			default_create
		end

create
	default_create,
	singleton

convert
	singleton ({G})

feature

	default_create
		do
		end

feature {NONE} -- Initialization

	singleton (x: G)
			-- Create a sequence with one element `x'.
		do
		end

feature -- Properties

	has (x: G): BOOLEAN
			-- Is `x' contained?
		do
		end

	is_empty: BOOLEAN
			-- Is the sequence empty?
		do
		end

feature -- Elements

	item alias "[]" (i: INTEGER): G
			-- Value at position `i'.
		do
		end
		
feature -- Conversion

	domain: MML_SET [INTEGER]
			-- Set of indexes.
		do
		end

	range: MML_SET [G]
			-- Set of values.
		do
		end				

feature -- Measurement

	count alias "#": INTEGER
			-- Number of elements.
		do
		end

feature -- Modification

	extended alias "&" (x: G): MML_SEQUENCE [G]
			-- Current sequence extended with `x' at the end.
		do
		end

feature -- Iterable implementation

	new_cursor: ITERATION_CURSOR [G]
			-- <Precursor>
		do
		end

end

