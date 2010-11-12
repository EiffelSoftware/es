note
	description: "A value representing address of a reference"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_REFERENCE_VALUE

inherit
	EPA_EXPRESSION_VALUE
		redefine
			type,
			item,
			is_reference,
			as_reference
		end

	REFACTORING_HELPER
		undefine
			is_equal,
			out
		end

create
	make

feature{NONE} -- Initialization

	make (a_item: like item; a_type: like type)
			-- Initialize `item' with `a_item' and `type' with `a_type'.
		do
			item := a_item.twin
			type := a_type
		end

feature -- Access

	type: TYPE_A
			-- Type of current value

	item: STRING
			-- Value item in current

	as_reference: detachable EPA_REFERENCE_VALUE
			-- Current as integer
		do
			Result := Current
		end

	object_equivalent_class_id: INTEGER
			-- Object equivalent class id

feature -- Status report

	is_reference: BOOLEAN = True
			-- Is current a reference value?

feature -- Setting

	set_object_equivalent_class_id (a_id: INTEGER)
			-- Set `object_equivalent_class_id' with `a_id'.
		do
			object_equivalent_class_id := a_id
		ensure
			object_equivalent_class_id_set: object_equivalent_class_id = a_id
		end

feature -- Process

	process (a_visitor: EPA_EXPRESSION_VALUE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			fixme ("To implement. 27.2.2010 Jasonw")
		end

end
