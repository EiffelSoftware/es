indexing
	description: "Objects that represent reflection of other composite objects"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_REGULAR_OBJECT

inherit

	CDD_COMPOSITE_OBJECT

create
	make_with_count

feature {NONE} -- Initialization

	make_with_count (a_type: like dynamic_type; a_count: INTEGER) is
			-- Create reflection for object of type `a_type' with `a_count' attributes.
		do
			make (a_type)
			create attributes.make (a_count)
		ensure
			correct_size: attributes.capacity >= a_count
		end

feature -- Access

	attributes: HASH_TABLE [CDD_OBJECT, STRING]
			-- Reflected attributes of class `dynamic_type'

feature -- Output

	append_creation (a_printer: CDD_TEST_CASE_PRINTER) is
			-- Tells `a_printer' to print a creation instruction for Current.
		do
			a_printer.append_regular_creation (Current)
		end

	append_assignment (a_printer: CDD_TEST_CASE_PRINTER) is
			-- Tells `a_printer' to print assignment instructions for Current.
		do
			a_printer.append_regular_assignment (Current)
		end

feature -- Element change

	add_attribute (a_name: STRING; a_value: CDD_OBJECT) is
			-- Add attribute with name `a_name' and value `a_value'.
		require
			a_name_not_empty: a_name /= Void and then not a_name.is_empty
			a_value_not_void: a_value /= Void
		do
			attributes.put (a_value, a_name)
		ensure
			attributes_set: attributes.item (a_name) = a_value
		end

invariant
	attributes_not_void: attributes /= Void

end
