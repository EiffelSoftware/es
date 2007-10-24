indexing
	description: "Objects that represent the reflection of an object of type SPECIAL"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_SPECIAL_OBJECT

inherit

	CDD_GENERIC_OBJECT
		rename
			make_generic as make_special
		redefine
			append_creation,
			append_assignment,
			add_attribute
		end

create
	make_special

feature -- Access

	append_creation (a_printer: CDD_TEST_CASE_PRINTER) is
			-- Tells `a_printer' to print a creation instruction for `Current'.
		do
			a_printer.append_special_creation (Current)
		end

	append_assignment (a_printer: CDD_TEST_CASE_PRINTER) is
			-- Tells `a_printer' to print a creation instruction for `Current'.
		do
			a_printer.append_special_assignment (Current)
		end

feature -- Element change

	add_attribute (a_name: STRING; a_value: CDD_OBJECT) is
			-- Add attribute with name `a_name' and value `a_value'.
		require else
			a_name_numeric: a_name.is_integer
			a_name_valid_value: a_name.to_integer >= 0 and
				a_name.to_integer < attributes.count
		do
			Precursor (a_name, a_value)
		end

end
