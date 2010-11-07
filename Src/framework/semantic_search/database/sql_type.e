note
	description: "Type"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQL_TYPE

inherit
	HASHABLE

	EPA_TYPE_UTILITY

create
	make,
	make_with_context_class,
	make_with_type_name,
	make_with_type_name_and_context_class

feature{NONE} -- Initialization

	make_with_type_name (a_type: STRING; a_id: INTEGER)
			-- Initialize Current.
		do
			make (type_a_from_string (a_type, workbench.system.root_type.associated_class), a_id)
		end

	make (a_type: like type; a_id: INTEGER)
			-- Initialize Current.
		do
			make_with_context_class (a_type, id, workbench.system.root_type.associated_class)
		end

	make_with_context_class (a_type: like type; a_id: INTEGER; a_context_class: like context_class)
			-- Initialize Current.
		do
			type := a_type
			id := a_id
			context_class := a_context_class
			name := a_type.name
			hash_code := name.hash_code
		end

	make_with_type_name_and_context_class (a_type: STRING; a_id: INTEGER; a_context_class: like context_class)
			-- Initialize Current.
		do
			make_with_context_class (type_a_from_string (a_type, a_context_class), a_id, a_context_class)
		end

feature -- Access

	type: TYPE_A
			-- Type wrapped in Current

	name: STRING
			-- Name of `type'

	id: INTEGER
			-- Type ID

	context_class: CLASS_C
			-- Context class used for type conformance checking

	hash_code: INTEGER
			-- Hash code value

feature -- Status report

	is_id_set: BOOLEAN
			-- Is `id' set to a real one?
		do
			Result := id > 0
		end

	is_conformant_to (a_type: like Current): BOOLEAN
			-- Is Current conformant to `a_type' in the context of `context_class'?
		do
			Result := type.conform_to (context_class, a_type.type)
		end

	has_associated_class: BOOLEAN
			-- Does `type' have associated class?
		do
			Result := type.has_associated_class
		end

	associated_class: CLASS_C
			-- Class associated with `type'
		require
			associated_class_exists: has_associated_class
		do
			Result := type.associated_class
		end

feature -- Setting

	set_id (a_id: INTEGER)
			-- Set `id' with `a_id'.
		require
			a_id_non_negative: a_id >= 0
		do
			id := a_id
		end

invariant
	id_non_negative: id >= 0

end
