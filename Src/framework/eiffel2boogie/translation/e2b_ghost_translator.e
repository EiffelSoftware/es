note
	description: "[
		Translator for ghost features.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_GHOST_TRANSLATOR

inherit

	E2B_ROUTINE_TRANSLATOR_BASE

feature -- Basic operations

	translate_ghost_attribute (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Translate ghost attribute `a_feature' of `a_context_type' as a ghost attribute.
		require
			is_attribute: a_feature.is_attribute
			is_ghost: helper.is_ghost (a_feature)
		local
			l_attribute_name: STRING
		do
			l_attribute_name := name_translator.boogie_name_for_feature (a_feature, a_context_type)

				-- Add field declaration
			boogie_universe.add_declaration (
				create {IV_CONSTANT}.make_unique (
					l_attribute_name,
					types.field (types.for_type_in_context (a_feature.type, a_context_type))))

				-- Mark field as a ghost field
			boogie_universe.add_declaration (
				create {IV_AXIOM}.make (
					factory.function_call ("IsGhostField", << l_attribute_name >>, types.bool)))

				-- TODO: global field properties

				-- Add translation references
			translation_pool.add_type_in_context (a_feature.type, a_context_type)
		end

	translate_ghost_function (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Translate feature `a_feature' of `a_context_type' as a ghost function.
		require
			is_routine: a_feature.is_routine
			is_function: a_feature.is_function
			is_ghost: helper.is_ghost (a_feature)
		local
			l_function: IV_FUNCTION
			l_expr_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR
		do
			set_context (a_feature, a_context_type)
			helper.set_up_byte_context (a_feature, a_context_type)

			if
				not attached Context.byte_code or else
				not attached Context.byte_code.compound or else
				not attached Context.byte_code.compound.count = 1 or else
				not attached {ASSIGN_B} Context.byte_code.compound.first as l_assign_b or else
				not attached {RESULT_B} l_assign_b.target
			then
					-- TODO: error message
				check False end
			else
					-- Create IV_FUNCTION
				create l_function.make (
					name_translator.boogie_name_for_feature (a_feature, a_context_type),
					types.for_type_in_context (a_feature.type, a_context_type))
				boogie_universe.add_declaration (l_function)

					-- Set up arguments
				l_function.add_argument ("heap", types.heap_type)
				l_function.add_argument ("current", types.ref)
				across arguments_of_current_feature as i loop
					l_function.add_argument (i.item.name, i.item.boogie_type)
				end

					-- Translate expression
				create l_expr_translator.make
				l_expr_translator.entity_mapping.set_heap (create {IV_ENTITY}.make ("heap", types.heap))
				l_expr_translator.entity_mapping.set_current (create {IV_ENTITY}.make ("current", types.ref))
				l_expr_translator.set_context (a_feature, a_context_type)
				l_assign_b.source.process (l_expr_translator)
				l_function.set_body (l_expr_translator.last_expression)
					-- TODO: check safety conditions
			end
		end

	translate_ghost_routine_signature (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Translate signature of ghost routine `a_feature' of `a_context_type'.
		require
			is_routine: a_feature.is_routine
			not_function: not a_feature.is_function
			is_ghost: helper.is_ghost (a_feature)
		do
			set_context (a_feature, a_context_type)
			set_up_boogie_procedure (name_translator.boogie_name_for_feature (a_feature, a_context_type))

				-- Set up arguments
			add_argument_with_property ("Current", a_context_type, types.ref)
			across arguments_of_current_feature as i loop
				add_argument_with_property (i.item.name, i.item.type, i.item.boogie_type)
			end

			check not current_feature.has_return_value end

				-- Set up contracts (pre/post/inv)
				-- Set up framing (modify)

			check False end
		end

	translate_ghost_routine_implementation (a_feature: FEATURE_I; a_context_type: TYPE_A)
			-- Translate signature of ghost routine `a_feature' of `a_context_type'.
		require
			is_routine: a_feature.is_routine
			not_function: not a_feature.is_function
			is_ghost: helper.is_ghost (a_feature)
		local
			l_impl: IV_IMPLEMENTATION
		do
			set_context (a_feature, a_context_type)
			set_up_boogie_procedure (name_translator.boogie_name_for_feature (a_feature, a_context_type))
			create l_impl.make (current_boogie_procedure)

				-- Add local variables
				-- Initialize local variables
				-- Translate implementation

			check False end
		end

end
