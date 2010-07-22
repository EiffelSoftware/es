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
			l_tree_buidler: RM_DECISION_TREE_BUILDER
		do
				-- Initialize.
			data := a_data
			setup_data_structures
			arff_relation := data.arff_relation.cloned_object
			value_sets := arff_relation.value_set

			logger.put_line_with_time_at_fine_level ("Start inferring implications.")

			collect_premise_attributes
			collect_consequent_attributes

				-- Setup results.
			create last_preconditions.make (10)
			last_preconditions.set_equality_tester (expression_equality_tester)
			create last_postconditions.make (10)
			last_postconditions.set_equality_tester (expression_equality_tester)
			setup_last_contracts

--			build_decision_trees
		end

feature{NONE} -- Implementation

	arff_relation: WEKA_ARFF_RELATION
			-- ARFF relation

	consequent_attributes: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]
			-- Set of attributes to be used as goal attributes

	boolean_premise_attributes: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]
			-- Set of boolean attributes to be used as premise attributes
			-- This is a subset of `premise_attributes'.

	premise_attributes: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]
			-- Set of attributes to be used as premise attributes

	value_sets: DS_HASH_TABLE [DS_HASH_SET [STRING_8], WEKA_ARFF_ATTRIBUTE]
			-- Table from attribute to values of that attributes in all instances
			-- Key is an attribute, value is the set of values that attribute have across all instances.

feature{NONE} -- Implementation

	build_decision_trees
			-- Build decision trees.
		local
			l_cursor: DS_HASH_SET_CURSOR [WEKA_ARFF_ATTRIBUTE]
			l_tree_builder: RM_DECISION_TREE_BUILDER
			l_tree: RM_DECISION_TREE
			l_selected_attrs: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]
			l_attrs1, l_attrs2: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]
			l_done: BOOLEAN
		do
			from
				l_cursor := consequent_attributes.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				create l_attrs1.make (boolean_premise_attributes.count + 1)
				l_attrs1.set_equality_tester (weka_arff_attribute_equality_tester)
				l_attrs1.append (boolean_premise_attributes)
				l_attrs1.force_last (l_cursor.item)

				create l_attrs2.make (premise_attributes.count + 1)
				l_attrs2.set_equality_tester (weka_arff_attribute_equality_tester)
				l_attrs2.append (premise_attributes)
				l_attrs2.force_last (l_cursor.item)

					-- First try to build a decision with only boolean premises.
					-- If no tree is accurate, build trees with all premise attributes.
				l_done := False
				across <<l_attrs1, l_attrs2>> as l_attrs until l_done loop
					create l_tree_builder.make_with_relation (arff_relation, l_attrs.item, l_cursor.item)
					l_tree_builder.build
					l_tree := l_tree_builder.last_tree
					l_done := l_tree.is_accurate
				end
				l_cursor.forth
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
				if not l_name.starts_with (once "%"pre::") then
					l_ok := False
				end

					-- Remove attributes that only have one value.
				if l_ok and then l_values.count = 1 then
					l_ok := False
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
				if not l_name.starts_with (once "%"by::") and then not l_name.starts_with (once "%"to::") then
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
				end

				if l_ok then
					l_ok := l_values.count > 1 and then l_values.count < 4
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

end
