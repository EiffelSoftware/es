indexing
	description: "Objects that represent reflections of other composite objects"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_COMPOSITE_OBJECT

inherit

	CDD_OBJECT

	COMPARABLE
		export
			{NONE} all
		undefine
			is_equal
		end

feature {NONE} -- Initialization

	make (a_type: like dynamic_type) is
			-- Create reflection for object of type 'a_type'.
		require else
			a_type_not_void: a_type /= Void
			not_basic_type: not a_type.is_basic
		do
			dynamic_type := a_type
			create type.make_from_string (dynamic_type.name)
			create identifier.make_from_string (a_type.name)
			identifier.to_lower
			identifier.append ("_id" + counter.item.out)
			counter.set_item (counter.item + 1)
		end

feature -- Access

	identifier: STRING
			-- Identifier used for output

	dynamic_type: EIFFEL_CLASS_C
			-- Class of the reflected object

	type: STRING
			-- Full type of the reflected object

feature -- Output

	append_creation (a_printer: CDD_TEST_CASE_PRINTER) is
			-- Tells 'a_printer' to print a creation instruction for Current
		require
			a_printer_not_void: a_printer /= Void
		deferred
		end

	append_assignment (a_printer: CDD_TEST_CASE_PRINTER) is
			-- Tells 'a_printer' to print assignment instructions for Current
		require
			a_printer_not_void: a_printer /= Void
		deferred
		end

feature -- Comparision

	infix "<" (other: like Current): BOOLEAN is
			-- Is Current less than 'other'
		require else
			other_not_void: other /= Void
		do
			Result := identifier < other.identifier
		end

feature {NONE} -- Implementation

	counter: INTEGER_REF is
			-- Counter for generating unique identifiers
		once
			create Result
			Result.set_item (1)
		ensure
			not_void: Result /= Void
		end

invariant
	dynamic_class_not_void: dynamic_type /= Void
	type_not_empty: type /= Void and then not type.is_empty

end
