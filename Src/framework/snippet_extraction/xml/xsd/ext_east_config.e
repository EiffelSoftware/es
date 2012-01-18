note
	description: "Configuration for synthesizing Eiffel AST XML Schema."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_EAST_CONFIG

inherit
	EXT_AST_NODE_CONSTANTS

	EXT_XML_CONSTANTS

	EPA_UTILITY

	REFACTORING_HELPER

feature -- Access (Records)

	record_list: LIST [EXT_EAST_RECORD]
			-- Generate class hierarchy used in XML Schema document(s) by
			-- a) using reflection mechanisms and b) applying manual corrections.
		local
			l_dummy_ast_eiffel: AST_EIFFEL
			l_hierarchy: LIST [EXT_EAST_RECORD]
			l_processing_queue: QUEUE [CLASS_C]
			l_parent_class_c: CLASS_C
		once
				-- Process abstract syntax tree class hierarchy.
			check attached class_c_by_name ("AST_EIFFEL") as l_root_class_c then
					-- Build descendent relation.
				find_class_descendants (l_root_class_c, False, True)

					-- Create temporary result data structure.
				create {LINKED_LIST [EXT_EAST_RECORD]} l_hierarchy.make

					-- Initialize variables for recursive traversal.
				l_parent_class_c := Void

				from
					create {LINKED_QUEUE [CLASS_C]} l_processing_queue.make
					l_processing_queue.put (l_root_class_c)
				until
					l_processing_queue.is_empty
				loop
					if check_class_name (l_processing_queue.item.name) then
						if attached candidate_class_table.item (l_processing_queue.item.class_id) as l_descendant_list then
							across l_descendant_list as l_record loop
--								debug
--									io.put_string (l_processing_queue.item.name)
--									io.put_string (":")
--									io.put_string (l_record.item.name)
--									io.put_new_line
--								end

								if check_class_descendant_name_pair (l_processing_queue.item.name, l_record.item.name) then
										-- Add result set record.
									l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (l_processing_queue.item.name, l_record.item.name, l_record.item.is_deferred))

										-- Add class to processing queue.
									l_processing_queue.put (l_record.item)
								end
							end
						end
					else
--						debug
--							io.put_string ("    SKIPPING: ")
--							io.put_string (l_processing_queue.item.name)
--							io.put_new_line
--						end
					end

						-- Remove processed class.
					l_processing_queue.remove
				end
			end

				-- Add "manual" corrections to resolve diamond shaped inheritance structure.
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_binary_as, node_equality_as, False))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_equality_as, node_bin_eq_as, False))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_equality_as, node_bin_ne_as, False))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_equality_as, node_bin_tilde_as, False))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_equality_as, node_bin_not_tilde_as, False))
				-- Add "manual" corrections to resolve multiple inheritance from distanct ancestor hierarchies.
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_atomic_as, node_static_access_expr_as, False))

				-- Add configuration for generic attributes.
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_eiffel_list, node_eiffel_list_of_atomic_as, false))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_eiffel_list, node_eiffel_list_of_case_as, false))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_eiffel_list, node_eiffel_list_of_convert_feat_as, false))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_eiffel_list, node_eiffel_list_of_create_as, false))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_eiffel_list, node_eiffel_list_of_elsif_as, false))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_eiffel_list, node_eiffel_list_of_export_item_as, false))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_eiffel_list, node_eiffel_list_of_expr_as, false))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_eiffel_list, node_eiffel_list_of_feature_as, false))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_eiffel_list, node_eiffel_list_of_feature_clause_as, false))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_eiffel_list, node_eiffel_list_of_feature_name, false))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_eiffel_list, node_eiffel_list_of_formal_dec_as, false))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_eiffel_list, node_eiffel_list_of_instruction_as, false))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_eiffel_list, node_eiffel_list_of_interval_as, false))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_eiffel_list, node_eiffel_list_of_operand_as, false))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_eiffel_list, node_eiffel_list_of_parent_as, false))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_eiffel_list, node_eiffel_list_of_rename_as, false))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_eiffel_list, node_eiffel_list_of_string_as, false))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_eiffel_list, node_eiffel_list_of_tagged_as, false))
			l_hierarchy.extend (create {EXT_EAST_RECORD}.make_from_argument_list (node_eiffel_list, node_eiffel_list_of_type_dec_as, false))

				-- Attach local records
			fixme ("Currently O(n^2) processing; replace by linear variant.")
			across l_hierarchy as l_record loop

					-- Attach local records.
				across local_record_list as l_local_record loop
					if l_record.item.element_name ~ l_local_record.item.parent_node then
						l_record.item.extension_list.extend (l_local_record.item)
					end
				end

					-- Attach local generic records.
				across local_generic_list_record_list as l_local_record loop
					if l_record.item.element_name ~ l_local_record.item.parent_node then
						l_record.item.extension_list.extend (l_local_record.item)
					end
				end

					-- Attach local attributes.
				across local_attribute_list as l_local_record loop
					if l_record.item.element_name ~ l_local_record.item.parent_node then
						l_record.item.attribute_list.extend (l_local_record.item)
					end
				end
			end

			Result := l_hierarchy
		ensure
			attached Result
		end

feature {NONE} -- Implementation (Records)	

	record_map: HASH_TABLE [EXT_EAST_RECORD, STRING]
			-- Create record map (indexed by AST node name)
		once
--			debug
--				io.put_string ("%N%N%Nl_record_map%N")
--			end

			create Result.make (255)
			Result.compare_objects

			across record_list as l_record loop
				Result.put (l_record.item, l_record.item.element_name)

				check
					Result.inserted
				end
			end

--			debug
--				io.put_string ("DONE.%N")
--			end
		end

	record_ancestor_map: HASH_TABLE [LIST [STRING], STRING]
			-- Create map with list of ancestors (indexed by AST node name)
		local
			l_tmp_ancestor_name: STRING
			l_tmp_ancestor_list: LINKED_LIST [STRING]
		once
--			debug
--				io.put_string ("%N%N%Nl_ancestor_map%N")
--			end

			create Result.make (255)
			Result.compare_objects

			across record_map.current_keys as l_record_name loop
--				debug
--					io.put_string ("%Nrecord_name: ")
--					io.put_string (l_record_name.item)
--					io.put_new_line
--				end

				from
					create l_tmp_ancestor_list.make
					l_tmp_ancestor_list.compare_objects

					record_ancestor_map.put (l_tmp_ancestor_list, l_record_name.item)

					l_tmp_ancestor_name := l_record_name.item
				until
					l_tmp_ancestor_name ~ "AST_EIFFEL"
				loop
					l_tmp_ancestor_name := direct_record_ancestor_map.at (l_tmp_ancestor_name)

					if not (l_tmp_ancestor_name ~ "AST_EIFFEL") then
--						debug
--							io.put_string (l_tmp_ancestor_name)
--							io.put_string (" <- ")
--							io.put_string (l_record_name.item)
--							io.put_new_line
--						end

						l_tmp_ancestor_list.force (l_tmp_ancestor_name)
					end
				end
			end

--			debug
--				io.put_string ("DONE.%N")
--			end
		end

	direct_record_ancestor_map: HASH_TABLE [STRING, STRING]
			-- Create direct ancestor map (indexed by AST node name)
		once
--			debug
--				io.put_string ("%N%N%Nl_direct_ancestor_map%N")
--			end

			create Result.make (255)
			Result.compare_objects

			across record_list as l_record loop
				Result.put (l_record.item.substitution_group, l_record.item.element_name)

				check
					Result.inserted
				end
			end

--			debug
--				io.put_string ("DONE.%N")
--			end
		end


	check_class_name (a_class_name: STRING): BOOLEAN
			-- Checks if `a_class_name' is relevant for inclusion in the XML Schema.
		local
			l_white_list, l_black_list: DS_HASH_SET [STRING]
		do
				-- White list of names that do not have suffix "_AS".
			create l_white_list.make_equal (10)
			l_white_list.force (node_ast_eiffel)
			l_white_list.force (node_eiffel_list)
			l_white_list.force (node_feature_name)
			l_white_list.force (node_integer_constant)

				-- Black list of names that can be represented as properties
				-- an do not need to remain as as abstract syntax nodes.
			create l_black_list.make_equal (10)
			l_black_list.force (node_keyword_as)
			l_black_list.force (node_leaf_as)

			if
				l_white_list.has (a_class_name) or
				(a_class_name.ends_with ("_AS") and not l_black_list.has (a_class_name))
			then
				Result := True
			end
		end


	check_class_descendant_name_pair (a_parent_class_name, a_class_name: STRING): BOOLEAN
			-- Check if edge in inheritance hierarchy is allowed to occur in the XML Schema.
			--
		local
			l_black_list: LINKED_LIST [TUPLE [parent_class_name, class_name: STRING]]
		do
			create l_black_list.make
			l_black_list.force ([node_atomic_as, node_static_access_as])
			l_black_list.force ([node_binary_as, node_bin_eq_as])

			Result := across l_black_list as l all not (l.item.parent_class_name ~ a_parent_class_name and l.item.class_name ~ a_class_name) end
		end


	class_c_by_name (a_class_name: STRING): detachable CLASS_C
			-- Selects the classes for extraction according to `config' flags.
		local
			l_class_selector: EPA_CLASS_SELECTOR
		do
			create l_class_selector

				-- Configure selector with class name filter.
			l_class_selector.criteria.force (
				agent (ag_tested_class: CLASS_C; ag_class_name: STRING): BOOLEAN
						-- Select class if its name equals to `a_class_name'.	
					local
						l_class_name_in_upper: STRING
					do
						l_class_name_in_upper := ag_class_name.twin
						l_class_name_in_upper.to_upper

						Result := ag_tested_class.name_in_upper ~ l_class_name_in_upper
					end (?, a_class_name)
				)

			l_class_selector.select_from_target

			check l_class_selector.last_classes.count = 1 end

			Result := l_class_selector.last_classes.first
		end


feature -- Access (Local Records)

	local_record_map: HASH_TABLE [LIST [EXT_XSD_LOCAL_RECORD], STRING]
			-- Collect local records from `local_record_list' and group them
			-- by `{EXT_XSD_LOCAL_RECORD}.parent_node'
		local
			l_local_record_list: LIST [EXT_XSD_LOCAL_RECORD]
		once
			create Result.make (255)
			Result.compare_objects

			across local_record_list as l_local_record loop
				l_local_record_list := Result.at (l_local_record.item.parent_node)

					-- Create record list for current iteration item, if not present
				if not attached l_local_record_list then
					create {LINKED_LIST [EXT_XSD_LOCAL_RECORD]} l_local_record_list.make
					l_local_record_list.compare_objects
					Result.put (l_local_record_list, l_local_record.item.parent_node)
				end

				l_local_record_list.force (l_local_record.item)
			end
		end


	local_record_list: LIST [EXT_XSD_LOCAL_RECORD]
		once
			create {LINKED_LIST [EXT_XSD_LOCAL_RECORD]} Result.make
			Result.compare_objects

				-- TYPED_CHAR_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_typed_char_as, 1, "type", node_type_as, False))

				-- INTEGER_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_integer_as, 1, "constant_type", node_type_as, True))

				-- REAL_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_real_as, 1, "constant_type", node_type_as, True))

				-- CASE_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_case_as, 1, "interval", node_eiffel_list_of_interval_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_case_as, 2, "compound", node_eiffel_list_of_instruction_as, True))

				-- INTERVAL_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_interval_as, 1, "lower", node_atomic_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_interval_as, 2, "upper", node_atomic_as, True))

				-- INSPECT
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_inspect_as, 1, "switch", node_expr_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_inspect_as, 2, "case_list", node_eiffel_list_of_case_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_inspect_as, 3, "else_part", node_eiffel_list_of_instruction_as, True))

				-- INSTR_CALL_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_instr_call_as, 1, "call", node_call_as, False))

				-- ASSIGNER_CALL_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_assigner_call_as, 1, "target", node_expr_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_assigner_call_as, 2, "source", node_expr_as, False))

				-- ASSIGN_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_assign_as, 1, "target", node_access_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_assign_as, 2, "source", node_expr_as, False))

				-- CREATION_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_creation_as, 2, "type", node_type_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_creation_as, 1, "target", node_access_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_creation_as, 3, "call", node_access_inv_as, True))

				-- DEBUG_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_debug_as, 1, "internal_keys", node_eiffel_list_of_string_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_debug_as, 2, "compond", node_eiffel_list_of_instruction_as, True))

				-- CHECK_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_check_as, 1, "check_list", node_eiffel_list_of_tagged_as, True))

				-- GUARD_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_guard_as, 1, "check_list", node_eiffel_list_of_tagged_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_guard_as, 2, "compound", node_eiffel_list_of_instruction_as, True))

				-- IF_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_if_as, 1, "condition", node_expr_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_if_as, 2, "compound", node_eiffel_list_of_instruction_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_if_as, 3, "elsif_list", node_eiffel_list_of_elsif_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_if_as, 4, "else_part", node_eiffel_list_of_instruction_as, True))

				-- ELSIF_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_elsif_as, 1, "expr", node_expr_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_elsif_as, 2, "compound", node_eiffel_list_of_instruction_as, True))

				-- LOOP_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_loop_as, 6, "iteration", node_iteration_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_loop_as, 1, "from_part", node_eiffel_list_of_instruction_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_loop_as, 2, "full_invariant_list", node_eiffel_list_of_tagged_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_loop_as, 5, "variant_part", node_variant_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_loop_as, 3, "stop", node_expr_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_loop_as, 4, "compound", node_eiffel_list_of_instruction_as, True))

				-- RENAME_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_rename_as, 1, "old_name", node_feature_name, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_rename_as, 2, "new_name", node_feature_name, False))

				-- EXPORT_ITEM_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_export_item_as, 1, "clients", node_client_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_export_item_as, 2, "features", node_feature_set_as, False))

				-- PARENT_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_parent_as, 1, "type", node_class_type_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_parent_as, 2, "renaming", node_eiffel_list_of_rename_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_parent_as, 3, "exports", node_eiffel_list_of_export_item_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_parent_as, 4, "undefining", node_eiffel_list_of_feature_name, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_parent_as, 5, "redefining", node_eiffel_list_of_feature_name, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_parent_as, 6, "selecting", node_eiffel_list_of_feature_name, True))

				-- INVARIANT_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_invariant_as, 1, "full_assertion_list", node_eiffel_list_of_tagged_as, True))

				-- REQUIRE_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_require_as, 1, "full_assertion_list", node_eiffel_list_of_tagged_as, True))

				-- ENSURE_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_ensure_as, 1, "full_assertion_list", node_eiffel_list_of_tagged_as, True))

				-- BITS_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_bits_as, 1, "bits_value", node_integer_as, False))

				-- CLASS_TYPE_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_class_type_as, 1, "class_name", node_id_as, False))

				-- GENERIC_CLASS_TYPE_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_generic_class_type_as, 2, "generics", node_type_list_as, True))

				-- LOCAL_DEC_LIST_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_local_dec_list_as, 1, "locals", node_eiffel_list_of_type_dec_as, True))

				-- FORMAL_ARGU_DEC_LIST_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_formal_argu_dec_list_as, 1, "arguments", node_type_dec_list_as, False))

				-- NAMED_TUPLE_TYPE_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_named_tuple_type_as, 1, "class_name", node_id_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_named_tuple_type_as, 2, "parameters", node_formal_argu_dec_list_as, True))

				-- CONSTRAINING_TYPE_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_constraining_type_as, 1, "type", node_type_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_constraining_type_as, 2, "renaming", node_rename_clause_as, True))

				-- LIKE_ID_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_like_id_as, 1, "anchor", node_id_as, False))

				-- FORMAL_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_formal_as, 1, "name", node_id_as, False))

				-- CONVERTED_EXPR_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_converted_expr_as, 1, "expr", node_expr_as, False))

				-- ADDRESS_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_address_as, 1, "feature_name", node_feature_name, False))

				-- EXPR_CALL_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_expr_call_as, 1, "call", node_call_as, False))

				-- EXPR_ADDRESS_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_expr_address_as, 1, "expr", node_expr_as, False))

				-- TYPE_EXPR_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_type_expr_as, 1, "type", node_type_as, False))

				-- CUSTOM_ATTRIBUTE_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_custom_attribute_as, 1, "creation_expr", node_creation_expr_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_custom_attribute_as, 2, "tuple", node_tuple_as, False))

				-- ARRAY_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_array_as, 1, "expressions", node_eiffel_list_of_expr_as, False))

				-- BRACKET_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_bracket_as, 1, "target", node_expr_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_bracket_as, 2, "operands", node_eiffel_list_of_expr_as, False))

				-- NESTED_EXPR_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_nested_expr_as, 1, "target", node_expr_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_nested_expr_as, 2, "message", node_call_as, False))

				-- TUPLE_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_tuple_as, 1, "expressions", node_eiffel_list_of_expr_as, False))

				-- TAGGED_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_tagged_as, 1, "tag", node_id_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_tagged_as, 2, "expr", node_expr_as, True))

				-- PARAN_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_paran_as, 1, "expr", node_expr_as, False))

				-- BINARY_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_binary_as, 1, "left", node_expr_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_binary_as, 2, "op_name", node_id_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_binary_as, 3, "right", node_expr_as, False))

				-- UNARY_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_unary_as, 1, "operator_ast", node_id_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_unary_as, 2, "expr", node_expr_as, False))

				-- OBJECT_TEST_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_object_test_as, 1, "type", node_type_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_object_test_as, 2, "expression", node_expr_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_object_test_as, 3, "name", node_id_as, True))

				-- LOOP_EXPR_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_loop_expr_as, 1, "iteration", node_iteration_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_loop_expr_as, 2, "full_invariant_list", node_eiffel_list_of_tagged_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_loop_expr_as, 3, "exit_condition", node_expr_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_loop_expr_as, 4, "expression", node_expr_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_loop_expr_as, 5, "variant_part", node_variant_as, True))

				-- STATIC_ACCESS_EXPR_AS
			Result.extend (create {EXT_EAST_LOCAL_ANY_RECORD}.make_from_argument_list (node_static_access_expr_as))

				-- ACCESS_AS
			Result.extend (create {EXT_EAST_LOCAL_ANY_RECORD}.make_from_argument_list (node_access_as))

				-- RENAME_CLAUSE_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_rename_clause_as, 1, "content", node_eiffel_list_of_rename_as, False))

				-- EXPORT_CLAUSE_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_export_clause_as, 1, "content", node_eiffel_list_of_export_item_as, False))

				-- UNDEFINE_CLAUSE_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_undefine_clause_as, 1, "content", node_eiffel_list_of_feature_name, False))

				-- REDEFINE_CLAUSE_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_redefine_clause_as, 1, "content", node_eiffel_list_of_feature_name, False))

				-- SELECT_CLAUSE_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_select_clause_as, 1, "content", node_eiffel_list_of_feature_name, False))

				-- ITERATION_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_iteration_as, 1, "expression", node_expr_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_iteration_as, 2, "identifier", node_id_as, False))

				-- INFIX_PREFIX_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_infix_prefix_as, 1, "alias_name", node_string_as, False))

				-- FORMAL_DEC_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_formal_dec_as, 1, "formal", node_formal_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_formal_dec_as, 2, "constraints", node_constraint_list_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_formal_dec_as, 3, "creation_feature_list", node_eiffel_list_of_feature_name, True))

				-- CREATION_EXPR_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_creation_expr_as, 1, "type", node_type_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_creation_expr_as, 2, "call", node_access_inv_as, True))

				-- ROUTINE_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_routine_as, 1, "obsolete_message", node_string_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_routine_as, 2, "precondition", node_require_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_routine_as, 3, "locals", node_type_dec_list_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_routine_as, 4, "routine_body", node_rout_body_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_routine_as, 5, "postcondition", node_ensure_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_routine_as, 6, "rescue_clause", node_eiffel_list_of_instruction_as, True))

				-- CONSTANT_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_constant_as, 1, "value", node_atomic_as, False))

				-- CONVERT_FEAT_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_convert_feat_as, 1, "feature_name", node_feature_name, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_convert_feat_as, 2, "conversion_types", node_type_list_as, False))

				-- FEATURE_NAME_ID_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_feat_name_id_as, 1, "feature_name", node_id_as, False))

				-- FEATURE_NAME_ALIAS_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_feature_name_alias_as, 2, "alias_name", node_string_as, True))

				-- TYPE_DEC_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_type_dec_as, 1, "type", node_type_as, False))

				-- BODY_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_body_as, 1, "arguments", node_type_dec_list_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_body_as, 2, "type", node_type_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_body_as, 3, "assigner", node_id_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_body_as, 5, "indexing_clause", node_indexing_clause_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_body_as, 4, "content", node_content_as, True))

				-- FEATURE_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_feature_as, 1, "feature_names", node_eiffel_list_of_feature_name, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_feature_as, 2, "body", node_body_as, False))

				-- FEATURE_CLAUSE_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_feature_clause_as, 1, "clients", node_client_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_feature_clause_as, 2, "features", node_eiffel_list_of_feature_as, False))

				-- CLASS_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_class_as, 1, "top_indexes", node_indexing_clause_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_class_as, 2, "class_name", node_id_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_class_as, 3, "generics", node_formal_generic_list_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_class_as, 4, "obsolete_message", node_string_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_class_as, 5, "conforming_parents", node_parent_list_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_class_as, 6, "non_conforming_parents", node_parent_list_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_class_as, 7, "creators", node_eiffel_list_of_create_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_class_as, 8, "convertors", node_convert_feat_list_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_class_as, 9, "features", node_eiffel_list_of_feature_clause_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_class_as, 10, "invariant_part", node_invariant_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_class_as, 11, "bottom_indexes", node_indexing_clause_as, True))

				-- INDEX_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_index_as, 1, "tag", node_id_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_index_as, 2, "index_list", node_eiffel_list_of_atomic_as, False))

				-- NESTED_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_nested_as, 1, "target", node_access_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_nested_as, 2, "message", node_call_as, False))

				-- CREATE_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_create_as, 1, "clients", node_client_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_create_as, 2, "feature_list", node_eiffel_list_of_feature_name, True))

				-- CLIENT_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_client_as, 1, "clients", node_class_list_as, False))

				-- INTERNAL_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_internal_as, 1, "compound", node_eiffel_list_of_instruction_as, True))

				-- EXTERNAL_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_external_as, 1, "language_name", node_external_lang_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_external_as, 2, "alias_name_literal", node_string_as, True))

				-- EXTERNAL_LANG_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_external_lang_as, 1, "language_name", node_string_as, False))

				-- ROUTINE_CREATION_AS
			Result.extend (create {EXT_EAST_LOCAL_ANY_RECORD}.make_from_argument_list (node_routine_creation_as))

				-- OPERAND_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_operand_as, 1, "class_type", node_type_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_operand_as, 3, "target", node_access_as, True))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_operand_as, 2, "expression", node_expr_as, True))

				-- THERE_EXISTS_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_there_exists_as, 1, "variables", node_eiffel_list_of_type_dec_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_there_exists_as, 2, "expression", node_expr_as, False))

				-- FOR_ALL_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_for_all_as, 1, "variables", node_eiffel_list_of_type_dec_as, False))
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_for_all_as, 2, "expression", node_expr_as, False))

				-- FEATURE_LIST_AS
			Result.extend (create {EXT_EAST_LOCAL_RECORD}.make_from_argument_list (node_feature_list_as, 1, "features", node_eiffel_list_of_feature_name, False))
		end


	local_generic_list_record_list: LIST [EXT_EAST_LOCAL_GENERIC_LIST_RECORD]
		once
			create {LINKED_LIST [EXT_EAST_LOCAL_GENERIC_LIST_RECORD]} Result.make
			Result.compare_objects

				-- EIFFEL_LIST [INTERVAL_AS]
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_eiffel_list_of_interval_as, node_interval_as))

				-- EIFFEL_LIST [INSTRUCTION_AS]
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_eiffel_list_of_instruction_as, node_instruction_as))

				-- EIFFEL_LIST [CASE_AS]
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_eiffel_list_of_case_as, node_case_as))

				-- EIFFEL_LIST [TAGGED_AS]
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_eiffel_list_of_tagged_as, node_tagged_as))

				-- EIFFEL_LIST [ELSIF_AS]
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_eiffel_list_of_elsif_as, node_elsif_as))

				-- EIFFEL_LIST [RENAME_AS]
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_eiffel_list_of_rename_as, node_rename_as))

				-- EIFFEL_LIST [EXPORT_ITEM_AS]
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_eiffel_list_of_export_item_as, node_export_item_as))

				-- EIFFEL_LIST [TYPE_DEC_AS]
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_eiffel_list_of_type_dec_as, node_type_dec_as))

				-- EIFFEL_LIST [FEATURE_NAME]
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_eiffel_list_of_feature_name, node_feature_name))

				-- EIFFEL_LIST [EXPR_AS]
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_eiffel_list_of_expr_as, node_expr_as))

				-- EIFFEL_LIST [FEATURE_AS]
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_eiffel_list_of_feature_as, node_feature_as))

				-- EIFFEL_LIST [FORMAL_DEC_AS]
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_eiffel_list_of_formal_dec_as, node_formal_dec_as))

				-- EIFFEL_LIST [PARENT_AS]
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_eiffel_list_of_parent_as, node_parent_as))

				-- EIFFEL_LIST [OPERAND_AS]
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_eiffel_list_of_operand_as, node_operand_as))

				-- EIFFEL_LIST [ATOMIC_AS]
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_eiffel_list_of_atomic_as, node_atomic_as))

				-- EIFFEL_LIST [CREATE_AS]
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_eiffel_list_of_create_as, node_create_as))

				-- EIFFEL_LIST [CONVERT_FEAT_AS]
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_eiffel_list_of_convert_feat_as, node_convert_feat_as))

				-- EIFFEL_LIST [FEATURE_CLAUSE_AS]
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_eiffel_list_of_feature_clause_as, node_feature_clause_as))

				-- EIFFEL_LIST [STRING_AS]
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_eiffel_list_of_string_as, node_string_as))


				-- %%% ---

				-- USE_LIST_AS
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_use_list_as, node_id_as))

				-- TYPE_LIST_AS
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_type_list_as, node_type_as))

				-- TYPE_DEC_LIST_AS
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_type_dec_list_as, node_type_dec_as))

				-- PARENT_LIST_AS
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_parent_list_as, node_parent_as))

				-- INDEXING_CLAUSE_AS
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_indexing_clause_as, node_index_as))

				-- FORMAL_GENERIC_LIST_AS
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_formal_generic_list_as, node_formal_dec_as))

				-- CONVERT_FEAT_LIST_AS
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_convert_feat_list_as, node_convert_feat_as))

				-- CONSTRAINT_LIST_AS
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_constraint_list_as, node_constraining_type_as))

				-- CLASS_LIST_AS
			Result.extend (create {EXT_EAST_LOCAL_GENERIC_LIST_RECORD}.make_from_argument_list (node_class_list_as, node_id_as))
		end


	local_attribute_list: LIST [EXT_EAST_LOCAL_ATTRIBUTE]
			-- Configuration for local attributes for synthesizing group definitions.
		local
			l_access_as_name,
			l_bool_as_value,
			l_id_as_name: EXT_XSD_ATTRIBUTE
		do
			create {LINKED_LIST [EXT_EAST_LOCAL_ATTRIBUTE]} Result.make
			Result.compare_objects

				-- ACCESS_AS
			create l_access_as_name.make ("name")
			l_access_as_name.type :=  xml_ns_xsd.ns_prefix + ":string"

			Result.extend (create {EXT_EAST_LOCAL_ATTRIBUTE}.make_from_argument_list (node_access_as, l_access_as_name))

				-- BOOL_AS
			create l_bool_as_value.make ("value")
			l_bool_as_value.type := xml_ns_xsd.ns_prefix + ":boolean"
			l_bool_as_value.attribute_use := "required"

			Result.extend (create {EXT_EAST_LOCAL_ATTRIBUTE}.make_from_argument_list (node_bool_as, l_bool_as_value))

				-- ID_AS
			create l_id_as_name.make ("name")
			l_id_as_name.type := xml_ns_xsd.ns_prefix + ":string"

			Result.extend (create {EXT_EAST_LOCAL_ATTRIBUTE}.make_from_argument_list (node_id_as, l_id_as_name))
		end

end
