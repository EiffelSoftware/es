note
	description: "Summary description for {E2B_HELPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_HELPER

inherit

	E2B_SHARED_CONTEXT
		export {NONE} all end

	SHARED_WORKBENCH
		export {NONE} all end

	SHARED_BYTE_CONTEXT
		export {NONE} all end

	SHARED_SERVER
		export {NONE} all end

feature -- Routine types

	is_mml_model_query (a_feature: FEATURE_I): BOOLEAN
			-- Is `a_feature' a model query?
		local
			l_values: ARRAYED_LIST [STRING_32]
		do
			if a_feature.has_return_value then
				l_values := class_note_values (a_feature.written_class, "model")
				Result := l_values.has (a_feature.feature_name_32)
				if not Result then
					l_values := feature_note_values (a_feature, "type")
					Result := l_values.has ("model")
				end
			end
		end

	is_lemma_routine (a_feature: FEATURE_I): BOOLEAN
			-- Is `a_feature' a lemma routine?
		local
			l_values: ARRAYED_LIST [STRING_32]
		do
			if a_feature.is_routine then
				l_values := feature_note_values (a_feature, "type")
				Result := l_values.has ("lemma")
			end
		end

feature -- Note helpers

	class_note_values (a_class: CLASS_C; a_tag: STRING_32): ARRAYED_LIST [STRING_32]
			-- List of note values of tag `a_tag'.
		do
			if a_class.ast /= Void and then a_class.ast.top_indexes /= Void then
				Result := note_values (a_class.ast.top_indexes, a_tag)
			else
				create Result.make (0)
			end
		ensure
			result_attached: attached Result
		end

	feature_note_values (a_feature: FEATURE_I; a_tag: STRING_32): ARRAYED_LIST [STRING_32]
			-- List of note values of tag `a_tag'.
		do
			if a_feature.body /= Void and then a_feature.body.indexes /= Void then
				Result := note_values (a_feature.body.indexes, a_tag)
			else
				create Result.make (0)
			end
		ensure
			result_attached: attached Result
		end

	note_values (a_indexing_clause: INDEXING_CLAUSE_AS; a_tag: STRING_32): ARRAYED_LIST [STRING_32]
			-- List of note values of tag `a_tag'.
		local
			l_values: EIFFEL_LIST [ATOMIC_AS]
		do
			create Result.make (3)
			Result.compare_objects
			from
				a_indexing_clause.start
			until
				a_indexing_clause.after
			loop
				if a_indexing_clause.item.tag.name_32.is_equal (a_tag) then
					l_values := a_indexing_clause.item.index_list
					from
						l_values.start
					until
						l_values.after
					loop
						Result.extend (l_values.item.string_value_32)
						l_values.forth
					end
				end
				a_indexing_clause.forth
			end
		end

	boolean_feature_note_value (a_feature: FEATURE_I; a_tag: STRING_32): BOOLEAN
			-- Value of a boolean feature note tag, False if not present.
		local
			l_values: ARRAYED_LIST [STRING_32]
		do
			l_values := feature_note_values (a_feature, a_tag)
			if not l_values.is_empty then
				Result := l_values.i_th (1).is_case_insensitive_equal ("true")
			end
		end

	integer_feature_note_value (a_feature: FEATURE_I; a_tag: STRING_32): INTEGER
			-- Value of an integer feature note tag, -1 if not present.
		local
			l_values: ARRAYED_LIST [STRING_32]
		do
			Result := -1
			l_values := feature_note_values (a_feature, a_tag)
			if not l_values.is_empty and then l_values.i_th (1).is_integer then
				Result := l_values.i_th (1).to_integer
			end
		end

feature -- String helpers

	feature_of_type_as_string (a_feature: FEATURE_I; a_type: TYPE_A): STRING
		do
			Result := "{" + a_type.name + "}." + a_feature.feature_name_32
		end

feature -- Eiffel helpers

	is_conforming_or_non_conforming_parent_class (a_child, a_parent: CLASS_C): BOOLEAN
			-- Does `a_child' inherit conforminlgy or non-conformingly from `a_parent'?
		do
			Result := a_child.conform_to (a_parent) or else is_non_conforming_parent_class (a_child, a_parent)
		end

	is_non_conforming_parent_class (a_child, a_parent: CLASS_C): BOOLEAN
			-- Does `a_child' inherit non-conformingly from `a_parent'?
		local
			l_item: CLASS_C
		do
			if a_child.non_conforming_parents_classes /= Void then
				from
					a_child.non_conforming_parents_classes.start
				until
					a_child.non_conforming_parents_classes.after or Result
				loop
					l_item := a_child.non_conforming_parents_classes.item
					Result := l_item.class_id = a_parent.class_id or else is_conforming_or_non_conforming_parent_class (l_item, a_parent)
					a_child.non_conforming_parents_classes.forth
				end
			end
		end

	feature_for_call_access (a_node: CALL_ACCESS_B; a_target_type: TYPE_A): FEATURE_I
			-- Feature represented by `a_node'.
		do
			check is_conforming_or_non_conforming_parent_class (a_target_type.associated_class, system.class_of_id (a_node.written_in)) end
			Result := a_target_type.associated_class.feature_of_name_id (a_node.feature_name_id)
--			Result := system.class_of_id (a_node.written_in).feature_of_name_id (a_node.feature_name_id)
			if Result /= Void then
					-- Not renamed
				Result := a_target_type.associated_class.feature_of_name_id (a_node.feature_name_id)
			else
					-- Renamed
				Result := a_target_type.associated_class.feature_of_rout_id (a_node.routine_id)
			end
			Result := Result.instantiated (a_target_type)
			check Result /= Void end
		end

feature -- Byte context helpers

	set_up_byte_context (a_feature: FEATURE_I; a_type: TYPE_A)
			-- Set up byte context for `a_feature' of type `a_type'.
		local
			l_byte_code: BYTE_CODE
		do
				-- Clear byte context
			if a_feature /= Void then
				Context.clear_feature_data
			end
			Context.clear_class_type_data
			Context.inherited_assertion.wipe_out

				-- Set up class type
			if not a_type.has_associated_class_type (Void) then
				if attached {CL_TYPE_A} a_type as l_cl_type_a then
					a_type.associated_class.update_types (l_cl_type_a)
				else
					check False end
				end
			end
			check a_type.has_associated_class_type (Void) end
			Context.init (a_type.associated_class_type (Void))

				-- Set up feature data
			if a_feature /= Void then
				Context.set_current_feature (a_feature)
				if byte_server.has (a_feature.body_index) then
					l_byte_code := byte_server.item (a_feature.body_index)
					Context.set_byte_code (l_byte_code)
				end
			end
		end

	set_up_byte_context_type (a_type: TYPE_A; a_context: TYPE_A)
			-- Set up byte context.
		do
				-- Set up class type
			if not a_type.has_associated_class_type (Void) then
				if attached {CL_TYPE_A} a_type as l_cl_type_a then
					a_type.associated_class.update_types (l_cl_type_a)
				else
					check False end
				end
			end
			check a_type.has_associated_class_type (Void) end
			Context.init (a_type.associated_class_type (Void))

				-- Set up context type
			if not a_context.has_associated_class_type (Void) then
				if attached {CL_TYPE_A} a_context as l_cl_type_a then
					a_context.associated_class.update_types (l_cl_type_a)
				else
					check False end
				end
			end
			check a_context.has_associated_class_type (Void) end
			Context.change_class_type_context (
				a_type.associated_class_type (Void), a_type.associated_class_type (Void).type,
				a_context.associated_class_type (Void), a_context.associated_class_type (Void).type)
		end

feature -- IV nodes helper




feature -- Other

	is_inlining_routine (a_routine: FEATURE_I): BOOLEAN
			-- Should routine `a_routine' be inlinied?
		local
			l_contract_extractor: EPA_CONTRACT_EXTRACTOR
		do
			Result := options.is_inlining_enabled and then
				boolean_feature_note_value (a_routine, "inline_in_caller")
			if not Result and options.is_automatic_inlining_enabled then
				create l_contract_extractor
				Result := l_contract_extractor.all_postconditions (a_routine).is_empty
			end
			if not Result then
				Result := options.routines_to_inline.has (a_routine.body_index)
			end
		end

	internal_counter: CELL [INTEGER]
			-- Internal shared counter.
		once
			create Result.put (0)
		end

	unique_identifier (a_name: STRING): STRING
			-- Unique identifier with base name `a_name'.
		do
			internal_counter.put (internal_counter.item + 1)
			Result := a_name + "_" + internal_counter.item.out
		end

end
