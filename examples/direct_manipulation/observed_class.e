indexing
	description: "Objects that are observed"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	OBSERVED_CLASS

inherit
	OBSERVABLE

create
	make

feature -- Initialization

	make is
			-- create an observed object.
		do
			create unobserved_object.make
		end


feature -- Basic operations
	is_literal_string_correct: BOOLEAN is
			-- test a literal string received from an unobserved object.
		local
			string: STRING
		do
			string := unobserved_object.read_literal_string
			Result := string.is_equal ("literal string")
		end

	is_string_from_file_correct: BOOLEAN is
			-- test reading of a string from a file through an unobserved object.
		local
			string: STRING
		do
			string := unobserved_object.read_from_file
			Result := string.is_equal ("this is a line from the input file.")
		end


feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation
	unobserved_object: UNOBSERVED_CLASS

invariant
	invariant_clause: True -- Your invariant here

end
