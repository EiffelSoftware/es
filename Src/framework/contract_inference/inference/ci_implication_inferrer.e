note
	description: "Inferrer for implications using decision trees"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_IMPLICATION_INFERRER

inherit
	CI_DATA_MINING_BASED_INFERRER
		redefine
			is_arff_needed
		end

	WEKA_SHARED_EQUALITY_TESTERS

	CI_WEKA_CONSTANTS

feature -- Status report

	is_arff_needed: BOOLEAN = True
			-- Is ARFF data needed?

feature -- Basic operations

	infer (a_data: like data)
			-- Infer contracts from `a_data', which is transition data collected from
			-- executed test cases.
		local
			l_loader: WEKA_ARFF_RELATION_PARSER
		do
				-- Initialize.
			data := a_data
			setup_data_structures
--			create l_loader.make ("D:\jasonw\projects\inferrer\EIFGENs\project\Contract_inference\data\LINKED_LIST__back.arff2")
--			l_loader.parse_relation
--			arff_relation := l_loader.last_relation
			arff_relation := data.arff_relation.cloned_object
			value_sets := arff_relation.value_set

			logger.put_line_with_time ("Start inferring implications.")

			collect_premise_attributes
			collect_consequent_attributes

				-- Setup results.
			create last_preconditions.make (10)
			last_preconditions.set_equality_tester (expression_equality_tester)
			create last_postconditions.make (10)
			last_postconditions.set_equality_tester (expression_equality_tester)

			build_decision_trees

			log_inferred_implications
			setup_last_contracts
		end

feature{NONE} -- Implementation

	consequent_attributes: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]
			-- Set of attributes to be used as goal attributes

	boolean_premise_attributes: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]
			-- Set of boolean attributes to be used as premise attributes
			-- This is a subset of `premise_attributes'.

	premise_attributes: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]
			-- Set of attributes to be used as premise attributes

feature{NONE} -- Implementation

	adapted_attributes (a_old_attributes: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]; a_new_relation: WEKA_ARFF_RELATION): DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]
			-- Set of attributes with the same name as `a_old_attributes', but from `a_new_relation'
		local
			l_cursor: DS_HASH_SET_CURSOR [WEKA_ARFF_ATTRIBUTE]
		do
			create Result.make (a_old_attributes.count)
			Result.set_equality_tester (weka_arff_attribute_equality_tester)
			from
				l_cursor := a_old_attributes.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.force_last (a_new_relation.attribute_by_name (l_cursor.item.name))
				l_cursor.forth
			end
		end

	build_decision_trees
			-- Build decision trees.
		local
			l_cursor: DS_HASH_SET_CURSOR [WEKA_ARFF_ATTRIBUTE]
			l_tree_builder: RM_DECISION_TREE_BUILDER
			l_tree: RM_DECISION_TREE
			l_selected_attrs: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]
			l_attrs1, l_attrs2: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]
			l_done: BOOLEAN
			l_relation: like arff_relation
			l_cons_attrs: like consequent_attributes
			l_bool_pre_attrs: like boolean_premise_attributes
			l_pre_attrs: like premise_attributes
		do
			l_relation := arff_relation.nominalized_cloned_object
			l_bool_pre_attrs := adapted_attributes (boolean_premise_attributes, l_relation)
			l_pre_attrs := adapted_attributes (premise_attributes, l_relation)
			l_cons_attrs := adapted_attributes (consequent_attributes, l_relation)

			from
				l_cursor := consequent_attributes.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				create l_attrs1.make (l_bool_pre_attrs.count + 1)
				l_attrs1.set_equality_tester (weka_arff_attribute_equality_tester)
				l_attrs1.append (l_bool_pre_attrs)
				l_attrs1.force_last (l_cursor.item)

				create l_attrs2.make (l_pre_attrs.count + 1)
				l_attrs2.set_equality_tester (weka_arff_attribute_equality_tester)
				l_attrs2.append (l_pre_attrs)
				l_attrs2.force_last (l_cursor.item)

					-- First try to build a decision with only boolean premises.
					-- If no tree is accurate, build trees with all premise attributes.
				l_done := False
				across <<l_attrs1, l_attrs2>> as l_attrs until l_done loop
					create l_tree_builder.make_with_relation (l_relation, l_attrs.item, l_cursor.item)
					l_tree_builder.build
					l_tree := l_tree_builder.last_tree
					l_done := l_tree.is_accurate
				end
				if l_done then
					generate_implications (l_tree)
				end
				l_cursor.forth
			end

		end

	generate_implications (a_tree: RM_DECISION_TREE)
			-- Generate implications and store them in `last_postconditions'.
		do
			across a_tree.paths as l_paths loop
				last_postconditions.force_last (implication_from_path (l_paths.item))
			end
		end

	implication_from_path (a_path: LIST [RM_DECISION_TREE_PATH_NODE]): EPA_EXPRESSION
			-- Implication expression from `a_path'
		local
			l_path: LINKED_LIST [RM_DECISION_TREE_PATH_NODE]
			l_text: STRING
			l_node: RM_DECISION_TREE_PATH_NODE
			l_name: STRING
			l_operator: STRING
			l_value: STRING
			l_expr: EPA_AST_EXPRESSION
			l_slices: LIST [STRING]
			l_is_pre: BOOLEAN
		do
			create l_path.make
			a_path.do_all (agent l_path.extend)

			create l_text.make (64)
			from
				l_path.start
			until
				l_path.after
			loop
				l_node := l_path.item_for_iteration
				l_slices := string_slices (l_node.attribute_name, once "::")
				l_is_pre := l_slices.first.has_substring (once "pre")
				l_name := l_slices.last
				l_name := expression_from_anonymous_form (l_name, feature_under_test, class_under_test)
				if l_name.starts_with (once "Current.") then
					l_name.remove_head (8)
				end

				l_operator := l_node.operator_name
				l_value := l_node.value_name
				if l_value.is_double then
					l_value := l_value.to_double.floor.out
				elseif l_value ~ stay_true_value then
					l_value := once "True"
				elseif l_value ~ stay_false_value then
					l_value := once "False"
				end

				if l_path.islast then
					if l_slices.first.has_substring (once "by")	then
						l_name := l_name + once " = old " + l_name
						if l_value.is_integer then
							if l_value.to_integer < 0 then
								l_name := l_name + once " - "
							else
								l_name := l_name + once " + "
							end
						end
						l_operator := ""
					end
				else
					if l_is_pre then
						l_name.prepend (once "old ")
					end
					l_name.prepend_character ('(')
					l_name.append_character (')')
				end

				if not l_path.isfirst then
					if l_path.islast then
						l_text.append (once " implies ")

					else
						l_text.append (once " and ")
					end
				end
				l_text.append (l_name)
				l_text.append_character (' ')
				l_text.append (l_operator)
				l_text.append (l_value)
				l_path.forth
			end
			create l_expr.make_with_text_and_type (class_under_test, feature_under_test, l_text, class_under_test, boolean_type)
			Result := l_expr
		end

	expression_from_anonymous_form (a_text: STRING; a_feature: FEATURE_I; a_class: CLASS_C): STRING
			-- Expression from `a_text' with anonymous operands replaced with real operands of `a_feature' in `a_class'
		local
			l_opd_names: like operand_name_index_with_feature
		do
			l_opd_names := operand_name_index_with_feature (a_feature, a_class)
			create Result.make (a_text.count + 20)
			Result.append (a_text)
			across l_opd_names as l_names loop
				Result.replace_substring_all (curly_brace_surrounded_integer (l_names.key), l_names.item)
			end
		end

	collect_premise_attributes
			-- Collect `premise_attributes' and `boolean_premise_attributes'.
		local
			l_cursor: like value_sets.new_cursor
			l_values: DS_HASH_SET [STRING_8]
			l_attribute: WEKA_ARFF_ATTRIBUTE
			l_name: STRING
			l_ok: BOOLEAN
			l_attr_cursor: DS_HASH_SET_CURSOR [WEKA_ARFF_ATTRIBUTE]
		do
			create premise_attributes.make (arff_relation.attributes.count)
			premise_attributes.set_equality_tester (weka_arff_attribute_equality_tester)
			create boolean_premise_attributes.make (arff_relation.attributes.count)
			boolean_premise_attributes.set_equality_tester (weka_arff_attribute_equality_tester)

				-- Collect attributes as consequent attributes.
			from
				l_cursor := value_sets.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_ok := True
				l_attribute := l_cursor.key
				l_values := l_cursor.item.cloned_object
				l_name := l_attribute.name

					-- Remove attributes that do not describe a prestate property.
				if not l_name.starts_with (once "pre::") then
					l_ok := False
				end

					-- Remove attributes that only have one value.
				if l_ok and then l_values.count = 1 then
					l_ok := False
				end

					-- Remove attributes which describe inequality because
					-- they can be represented through equalities.
				if l_ok then
					l_ok := not l_name.has_substring (once "/=") and then not l_name.has_substring (once "/~")
				end

				if l_ok then
					premise_attributes.force_last (l_attribute)
					if l_attribute.is_nominal and then is_boolean_value_set (l_values) then
						boolean_premise_attributes.force_last (l_attribute)
					end

				end
				l_cursor.forth
			end

				-- Logging.
			logger.push_fine_level
			logger.put_line ("Found boolean premises:")
			from
				l_attr_cursor := boolean_premise_attributes.new_cursor
				l_attr_cursor.start
			until
				l_attr_cursor.after
			loop
				logger.put_line (once "%T" + l_attr_cursor.item.name)
				l_attr_cursor.forth
			end

			logger.put_line ("Found non-boolean premises:")
			from
				l_attr_cursor := premise_attributes.new_cursor
				l_attr_cursor.start
			until
				l_attr_cursor.after
			loop
				if not boolean_premise_attributes.has (l_attr_cursor.item) then
					logger.put_line (once "%T" + l_attr_cursor.item.name)
				end
				l_attr_cursor.forth
			end
			logger.pop_level
		end

	collect_consequent_attributes
			-- Collect `consequent_attributes' from `data'.
		local
			l_cursor: like value_sets.new_cursor
			l_values: DS_HASH_SET [STRING_8]
			l_attribute: WEKA_ARFF_ATTRIBUTE
			l_name: STRING
			l_ok: BOOLEAN
			l_attr_cursor: DS_HASH_SET_CURSOR [WEKA_ARFF_ATTRIBUTE]
		do
			create consequent_attributes.make (arff_relation.attributes.count)
			consequent_attributes.set_equality_tester (weka_arff_attribute_equality_tester)

				-- Collect attributes as consequent attributes.
			from
				l_cursor := value_sets.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_ok := True
				l_attribute := l_cursor.key
				l_values := l_cursor.item.cloned_object
				l_name := l_attribute.name

					-- Remove attributes that do not describe a change.
				if not l_name.starts_with (once "by::") and then not l_name.starts_with (once "to::") then
					l_ok := False
				end

					-- Remove attributes that describe equality or inequality in "=" or "~".
				if l_name.has ('=') or else l_name.has ('~') then
					l_ok := False
				end

					-- Remove attributes that describe a fake relative integer change.
				if l_ok and then l_name.starts_with (once "by::") and then l_values.count = 1 and then l_values.first ~ once "0" then
					l_ok := False
				end

				if l_ok and then l_name.starts_with (once "to::") and then l_values.count <= 1 then
					l_ok := False
				end

				if l_ok then
					l_ok := l_values.count > 1 and l_values.count < 4
				end

					-- Remove atributes that describe a fake boolean change.
				if l_ok then
					l_values.search (stay_true_value)
					if l_values.found then
						l_values.remove_found_item
					end
					l_values.search (stay_false_value)
					if l_values.found then
						l_values.remove_found_item
					end
					l_ok := not l_values.is_empty
				end

				if l_ok then
					consequent_attributes.force_last (l_attribute)
				end
				l_cursor.forth
			end

				-- Logging.
			logger.push_fine_level
			logger.put_line ("Found boolean consequences:")
			from
				l_attr_cursor := consequent_attributes.new_cursor
				l_attr_cursor.start
			until
				l_attr_cursor.after
			loop
				logger.put_line (once "%T" + l_attr_cursor.item.name)
				l_attr_cursor.forth
			end
			logger.pop_level
		end

	is_boolean_value_set (a_values: DS_HASH_SET [STRING]): BOOLEAN
			-- Is `a_values' a bolean value set?
		local
			l_cursor: DS_HASH_SET_CURSOR [STRING]
			l_value: STRING
		do
			Result := True
			from
				l_cursor := a_values.new_cursor
				l_cursor.start
			until
				l_cursor.after or else not Result
			loop
				l_value := l_cursor.item
				if
					l_value ~ stay_false_value or else
					l_value ~ stay_true_value or else
					l_value ~ once "True" or else
					l_value ~ once "False" or else
					l_value ~ once "?"
				then
				else
					Result := False
				end
				l_cursor.forth
			end
		end

feature{NONE} -- Logging

	log_inferred_implications
			-- Log inferred implications.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
		do
			logger.push_info_level
			logger.put_line_with_time ("Found the following implications:")
			from
				l_cursor := last_postconditions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				logger.put_line (once "%T" + l_cursor.item.text)
				l_cursor.forth
			end
			logger.pop_level
		end

end
