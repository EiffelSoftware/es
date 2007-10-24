indexing
	description: "Objects that represent reflected STRING objects"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_STRING_OBJECT

inherit
	CDD_COMPOSITE_OBJECT

create
	make_with_string

feature {NONE} -- Initialization

	make_with_string (a_type: like dynamic_type; a_string: like representation) is
			-- Create reflection of an object of type `a_type' with value `a_string'.
		require else
			class_of_type_string: a_type.name.is_equal ("STRING_8") or
				a_type.name.is_equal ("STRING_32")
		do
			make (a_type)
			representation := a_string
		ensure
			representation_set: representation = a_string
		end


feature -- Access

	representation: STRING
			-- textual representation of reflected STRING object

feature -- Output

	append_creation (a_generator: CDD_TEST_CASE_PRINTER) is
			-- tells 'a_printer' to print a creation instruction for Current
		do
			a_generator.append_string_creation (Current)
		end

	append_assignment (a_generator: CDD_TEST_CASE_PRINTER) is
			-- tells 'a_printer' to print assignment instructions for Current
		do
			a_generator.append_string_assignment (Current)
		end

invariant
	representation_not_void: representation /= Void

end
