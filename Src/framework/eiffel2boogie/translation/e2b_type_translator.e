note
	description: "[
		Translation of Eiffel types to Boogie.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TYPE_TRANSLATOR

inherit

	E2B_SHARED_CONTEXT

	E2B_SHARED_BOOGIE_UNIVERSE

	IV_SHARED_TYPES

feature -- Access

	last_translation: E2B_BOOGIE_TEXT
			-- Boogie code of last translation.
		do
			Result := text
		end

	text: E2B_BOOGIE_TEXT
			-- Boogie code of last translation.

feature -- Basic operations

	translate_type (a_type: TYPE_A)
			-- Translate `a_type' to Boogie.
		require
			valid_type: a_type.is_class_valid
			no_like_type: not a_type.is_like
		local
			l_boogie_type_name: STRING
			l_constant: IV_CONSTANT
		do
			l_boogie_type_name := name_translator.boogie_name_for_type (a_type)

				-- Type definition
			create l_constant.make (l_boogie_type_name, types.type)
			l_constant.set_unique
			boogie_universe.add_declaration (l_constant)

				-- Inheritance relations
			if not a_type.has_generics then
				generate_inheritance_relations (a_type)
			end
		end

feature {NONE} -- Implementation

	generate_inheritance_relations (a_type: TYPE_A)
			-- Generate inheritance relations for type `a_type'.
		require
			not_generic: not a_type.has_generics
		local
			l_parents: FIXED_LIST [CL_TYPE_A]
			l_type_name: STRING
			l_axiom: IV_AXIOM
			l_operation: IV_BINARY_OPERATION
			l_type_value: IV_VALUE
			l_parent_value: IV_VALUE
		do
			l_type_name := name_translator.boogie_name_for_type (a_type)
			l_parents := a_type.associated_class.parents
			from
				l_parents.start
			until
				l_parents.after
			loop
				translation_pool.add_type (l_parents.item)

				create l_type_value.make (l_type_name, types.type)
				create l_parent_value.make (name_translator.boogie_name_for_type (l_parents.item), types.type)
				create l_operation.make (l_type_value, "<:", l_parent_value, types.bool)
				create l_axiom.make (l_operation)
				boogie_universe.add_declaration (l_axiom)

				l_parents.forth
			end
		end

end
