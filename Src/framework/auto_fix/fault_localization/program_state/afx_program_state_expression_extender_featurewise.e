note
	description: "Summary description for {AFX_PROGRAM_STATE_EXPRESSION_EXTENDER_FEATUREWISE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_STATE_EXPRESSION_EXTENDER_FEATUREWISE

inherit
	AFX_PROGRAM_STATE_EXPRESSION_EXTENDER

create
	make, make_with_original_expressions

feature -- Basic operation

	extend_original_expressions
			-- <Precursor>
		local
			l_original: like original_expressions
			l_extended: like extended_expressions
			l_expression: EPA_PROGRAM_STATE_EXPRESSION
			l_expressions: DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_new_size: INTEGER
--			l_integral_expressions, l_boolean_expressions, l_object_expressions: like original_expressions
			l_boolean_expressions, l_expressions_from_integrals, l_expressions_from_objects: like original_expressions
		do
			clear_extender

			l_original := original_expressions
			if not l_original.is_empty then
				l_extended := extended_expressions
				l_boolean_expressions := boolean_expressions (l_original)
				l_expressions_from_integrals := extended_expressions_on_integrals (integral_expressions (l_original))
				l_expressions_from_objects := boolean_expressions_on_objects (object_expressions (l_original))

				l_new_size := l_extended.count + l_boolean_expressions.count + l_expressions_from_integrals.count + l_expressions_from_objects.count
				if l_new_size > l_extended.capacity then
					l_extended.resize (l_new_size)
				end

				l_extended.append (l_boolean_expressions)
				l_extended.append (l_expressions_from_integrals)
				l_extended.append (l_expressions_from_objects)

--				l_extended.append (boolean_expressions (l_original))
--				l_extended.append (extended_expressions_on_integrals (integral_expressions (l_original)))
--				l_extended.append (boolean_expressions_on_objects (object_expressions (l_original)))

				-- All expressions are not related to any particular breakpoint slot.
				set_breakpoint_slot (l_extended, 0)
			else
				-- Empty `original_expressions', do nothing.
			end
		end

end
