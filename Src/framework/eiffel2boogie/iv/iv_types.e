note
	description: "[
		Access to basic IV types and conversion facilities.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_TYPES

inherit
	E2B_SHARED_CONTEXT

	IV_SHARED_FACTORY

feature -- Access: default types

	bool: IV_TYPE
			-- Boolean type.
		once
			create {IV_BASIC_TYPE} Result.make_boolean
		end

	int: IV_TYPE
			-- Integer type.
		once
			create {IV_BASIC_TYPE} Result.make_integer
		end

	real: IV_TYPE
			-- Integer type.
		once
			create {IV_BASIC_TYPE} Result.make_real
		end

	nullary_type (a_name: STRING): IV_USER_TYPE
			-- User-defined type from a nullary type constructor.
		do
			create {IV_USER_TYPE} Result.make (a_name, <<>>)
		end

	ref: IV_USER_TYPE
			-- Reference type.
		once
			Result := nullary_type ("ref")
			Result.set_default_value (factory.void_)
			Result.set_rank_function ("ref_rank_leq")
		end

	field (a_content_type: IV_TYPE): IV_TYPE
			-- Field type that has content of type `a_content_type'.
		do
			create {IV_USER_TYPE} Result.make ("Field", << a_content_type >>)
		end

	heap: IV_TYPE
			-- Heap type.
		local
			l_param: IV_VAR_TYPE
		once
			create l_param.make_fresh
			create {IV_MAP_TYPE} Result.make_with_synonym (<< l_param.name >>, << ref, field (l_param) >>, l_param, nullary_type ("HeapType"))
		end

	is_heap (a_type: IV_TYPE): BOOLEAN
			-- Is `a_type' a set type?
		do
			Result := attached {IV_MAP_TYPE} a_type as map_type and then
						attached map_type.synonym as s and then s.constructor ~ "HeapType"
		end

	frame: IV_TYPE
			-- Frame type.
		local
			l_param: IV_VAR_TYPE
		once
			create l_param.make_fresh
			create {IV_MAP_TYPE} Result.make_with_synonym (<< l_param.name >>, << ref, field (l_param) >>, bool, nullary_type ("Frame"))
		end

	type: IV_TYPE
			-- Type type.
		once
			Result := nullary_type ("Type")
		end

	set (a_content_type: IV_TYPE): IV_TYPE
			-- Set type that has content of type `a_content_type'.
		local
			l_synonym: IV_USER_TYPE
		once
			create l_synonym.make ("Set", << a_content_type >>)
			create {IV_MAP_TYPE} Result.make_with_synonym (<<>>, << a_content_type >>, bool, l_synonym)
			l_synonym.set_default_value (factory.function_call ("Set#Empty", <<>>, Result))
			l_synonym.set_rank_function ("Set#Subset")
		end

	is_set (a_type: IV_TYPE): BOOLEAN
			-- Is `a_type' a set type?
		do
			Result := attached {IV_MAP_TYPE} a_type as map_type and then
						attached map_type.synonym as s and then s.constructor ~ "Set"
		end

feature -- Type translation

	for_type_a (a_type: TYPE_A): IV_TYPE
			-- Boogie type for `a_type'.
		require
			a_type_attached: attached a_type
			a_type_valid: not a_type.deep_actual_type.is_like
		local
			l_type: TYPE_A
			l_class: CLASS_C
			l_user_type: IV_USER_TYPE
			l_constructor: STRING
			l_params: ARRAY [IV_TYPE]
			l_rank_functions: like helper.class_note_values
			l_default_function: STRING
		do
			l_type := a_type.deep_actual_type
			check not l_type.is_like end
			l_class := l_type.base_class

			if l_type.is_integer or l_type.is_natural or l_type.is_character or l_type.is_character_32 then
				Result := int
			elseif l_type.is_boolean then
				Result := bool
			elseif l_type.is_real_32 or else l_type.is_real_64 then
				Result := real
			elseif l_type.is_formal then
				Result := ref
			elseif helper.is_class_logical (l_class) then
					-- The class is mapped to a Boogie type
				l_constructor := helper.class_note_values (l_class, "maps_to").first
				create l_params.make (1, l_type.generics.count)
				across
					l_type.generics as g
				loop
					l_params [g.target_index] := for_type_a (g.item)
				end
				create l_user_type.make (l_constructor, l_params)

					-- Check if the type has a default value
				l_default_function := helper.string_feature_note_value (l_class.feature_named_32 ("default_create"), "maps_to")
				if not l_default_function.is_empty then
					l_user_type.set_default_value (factory.function_call (l_default_function, << >>, l_user_type))
				end

					-- Check if the type has a rank function
				l_rank_functions := helper.class_note_values (l_class, "rank")
				if not l_rank_functions.is_empty then
					l_user_type.set_rank_function (l_rank_functions.first)
				end
				Result := l_user_type

				-- ToDo: extract underlying map type from a feature mapped to "[]"?
				-- For now treat sets in a special way:
				if l_constructor ~ "Set" then
					Result := set (l_params [1])
				end
			else
				Result := ref
			end
		end

	for_type_in_context (a_type: TYPE_A; a_context_type: TYPE_A): IV_TYPE
			-- Boogie type for `a_type' in context of `a_context_type'.
		require
			a_type_attached: attached a_type
			a_type_valid: not a_type.deep_actual_type.is_like
			a_context_type_attached: attached a_context_type
		local
			l_type: TYPE_A
		do
			l_type := a_type.deep_actual_type
			l_type := l_type.instantiated_in (a_context_type)
			Result := for_type_a (l_type)
		end

	type_property (a_type: TYPE_A; a_heap, a_expr: IV_EXPRESSION): IV_EXPRESSION
			-- For an expression `a_expr' originally of Eiffel type `a_type', an expression that states its precise Eiffel type in `a_heap'.
		local
			l_boogie_type: IV_TYPE
			l_content_type: TYPE_A
			l_fname: STRING
			l_arg: IV_EXPRESSION
			l_typed_sets: like helper.class_note_values
		do
			Result := factory.true_
			l_boogie_type := for_type_a (a_type)
			if l_boogie_type ~ ref then
				l_content_type := a_type
				if attached {IV_ENTITY} a_expr as a_entity and then a_entity.name ~ "Current" then
					-- For Current the exact dynamic type is considered known
					l_fname := "attached_exact"
				elseif l_content_type.is_attached then
					l_fname := "attached"
				else
					l_fname := "detachable"
				end
				Result := factory.function_call (l_fname, << a_heap, a_expr, factory.type_value (l_content_type) >>, bool)
				-- ToDo: refactor
				if a_type.base_class.name_in_upper ~ "ARRAY" then
					Result := factory.and_clean (Result, factory.function_call ("ARRAY.inv", << a_heap, a_expr >>, bool))
				end
			elseif l_boogie_type ~ int then
				Result := numeric_property (a_type, a_expr)
			else
				l_typed_sets := helper.class_note_values (a_type.base_class, "typed_sets")
				if not l_typed_sets.is_empty then
					if l_typed_sets.count /= a_type.generics.count then
						-- ToDo: move message
						helper.add_semantic_error (a_type, "The number of typed sets does not coincide with the number of generic parameters", -1)
					else
						across
							l_typed_sets as sets
						loop
							l_content_type := a_type.generics [sets.target_index]
							if for_type_a (l_content_type) ~ ref then
								if l_content_type.is_attached then
									l_fname := "set_attached"
								else
									l_fname := "set_detachable"
								end
								if sets.item.is_empty then
									l_arg := a_expr
								else
									l_arg := factory.function_call (sets.item, << a_expr >>, set (ref))
								end
								Result := factory.and_clean (Result,
									factory.function_call (l_fname, << a_heap, l_arg, factory.type_value (l_content_type) >>, bool))
							end
						end
					end
				end
			end
		end

	numeric_property (a_type: TYPE_A; a_expr: IV_EXPRESSION): IV_EXPRESSION
			-- Property associated with argument `a_name' of type `a_type'.
		require
			numeric_property: a_type.is_numeric or a_type.is_character
		local
			l_f_name: STRING
		do
			if attached {INTEGER_A} a_type as l_int_type then
				l_f_name := "is_integer_" + l_int_type.size.out
			elseif attached {NATURAL_A} a_type as l_nat_type then
				l_f_name := "is_natural_" + l_nat_type.size.out
			elseif attached {CHARACTER_A} a_type as l_char_type then
				if l_char_type.is_character_32 then
					l_f_name := "is_natural_32"
				else
					l_f_name := "is_natural_8"
				end
			else
				check False end
			end
			Result := factory.function_call (l_f_name, << a_expr >>, bool)
		end

end
