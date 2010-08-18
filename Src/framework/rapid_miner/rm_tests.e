note
	description: "Summary description for {RM_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_TESTS
inherit
	RM_CONSTANTS

feature -- Interface

	test_all
			-- Executes all test cases.
		do
			test_decision_tree_with_weka_arff
			test_dt_with_relation
			test_linear_regression
		end


feature{NONE} -- Tests

	test_linear_regression
			-- Test the generation on features of linear regression.
		local
			selected_attributes: LINKED_LIST[STRING]
			arff_file_path: STRING
			l_hash: HASH_TABLE[STRING, STRING]
			l_file: PLAIN_TEXT_FILE
			lr_builder: RM_LINEAR_REGRESSION_BUILDER
			alg_params, val_params: HASH_TABLE[STRING, STRING]
			regressor_values: HASH_TABLE [DOUBLE, STRING]
			l_linear_regression: RM_LINEAR_REGRESSION
		do
			io.put_string ("Testing linear regression!")
			io.put_new_line

			create l_file.make_create_read_write (rm_environment.rapid_miner_test_arff_path)
			l_file.put_string (extend_arff)
			l_file.close

			create selected_attributes.make
			selected_attributes.compare_objects
			selected_attributes.force ("post::{0}.count")
			selected_attributes.force ("post::{0}.index")
			selected_attributes.force ("pre::{0}.count")


			create val_params.make (2)
			val_params["number_of_validations"] := "10"
			create alg_params.make (2)
			alg_params["minimal_gain"] := "0.2"
			alg_params["maximal_depth"] := "25"

			create lr_builder.make ( rm_environment.rapid_miner_test_arff_path, selected_attributes, "post::{0}.count")
			lr_builder.set_validation_parameters (val_params)
			lr_builder.set_algorithm_parameters (alg_params)

			lr_builder.build

			create regressor_values.make(10)
			regressor_values.put (2.0, "pre::{0}.count")
			l_linear_regression := lr_builder.last_linear_regression
			l_linear_regression.regress (regressor_values)

			check_test (l_linear_regression.last_regression = 3.0, "regression check")

			check_test (l_linear_regression.is_all_regressor_coefficient_integer, "check all integers")

			check_test (l_linear_regression.regressors.count = 2, "regressor count")

			check_test (l_linear_regression.regressors["pre::{0}.count"] = 1.0, "regressor coef")

			check_test (l_linear_regression.regressors[l_linear_regression.constant_regressor] = 1.0, "constant regressor coef")


		end

	test_dt_with_relation
			-- Uses the arff file for linked list and parses it with weka_relation.
		local
			l_file: PLAIN_TEXT_FILE
			l_relation: WEKA_ARFF_RELATION
			l_rel_parser: WEKA_ARFF_RELATION_PARSER
			attr_set: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]
			set: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]
			label: WEKA_ARFF_ATTRIBUTE
			l_tree: RM_DECISION_TREE
			rm_tree_builder: RM_DECISION_TREE_BUILDER
			l_children: DS_HASH_SET [STRING]
		do
			io.put_string ("Testing decision tree and make_with_relation!")
			io.put_new_line
			create l_children.make (10)

			create l_file.make_create_read_write (rm_environment.rapid_miner_test_arff_path)
			l_file.put_string (search_arff)
			l_file.close


			create l_rel_parser.make (rm_environment.rapid_miner_test_arff_path)
			l_rel_parser.parse_relation
			l_relation := l_rel_parser.last_relation

			create attr_set.make_default
			set := l_relation.attribute_set

			from set.start until set.after loop
				if set.item_for_iteration.name.starts_with ("pre::{0}") or set.item_for_iteration.name ~ "to::{0}.after" then
					attr_set.force (set.item_for_iteration)
				end
				if set.item_for_iteration.name ~ "to::{0}.after"  then
					label := set.item_for_iteration
				end
				set.forth
			end

			create rm_tree_builder.make_with_relation (l_relation, attr_set, label)
			rm_tree_builder.build

			l_tree := rm_tree_builder.last_tree

			check_test (l_tree.root.name ~ "pre::{0}.after", "root node name")

			check_test (l_tree.root.edges.count = 2, "root children count")

			check_test (l_tree.is_accurate, "accuracy test")

			create l_children.make (2)
			l_children.set_equality_tester (string_equality_tester)
			l_children.force ("STAY_TRUE")
			l_children.force ("pre::{0}.has ({1})")

			check_test(l_children.has (l_tree.root.edges[1].node.name), "child name")

			check_test(l_children.has (l_tree.root.edges[2].node.name), "child name")


			l_children.wipe_out
			l_children.force ("=False")
			l_children.force ("=True")

			check_test(l_children.has (l_tree.root.edges[1].condition), "edge condition")

			check_test(l_children.has (l_tree.root.edges[2].condition), "edge condition")

--			l_file.delete
		end

	test_decision_tree_with_weka_arff
			-- Uses on of the weka files to test the decision tree creation.
		local
			l_file: PLAIN_TEXT_FILE
			selected_attributes: LINKED_LIST[STRING]
			rm_tree_builder: RM_DECISION_TREE_BUILDER
			l_tree: RM_DECISION_TREE
			l_children: DS_HASH_SET [STRING]
		do
			io.put_string ("Testing decision tree!")
			io.put_new_line
			create l_children.make (10)

			create l_file.make_create_read_write (rm_environment.rapid_miner_test_arff_path)
			l_file.put_string (weka_arff)
			l_file.close

			create selected_attributes.make
			selected_attributes.compare_objects

			selected_attributes.force ("spectacle-prescrip") selected_attributes.force ("age")
			selected_attributes.force ("tear-prod-rate") selected_attributes.force ("contact-lenses")
			selected_attributes.force ("astigmatism")

			create rm_tree_builder.make (rm_environment.rapid_miner_test_arff_path, selected_attributes, "contact-lenses")
			rm_tree_builder.build
			l_tree := rm_tree_builder.last_tree

			check_test (not l_tree.is_accurate, "accuracy test")

			check_test (l_tree.root.name ~ "tear-prod-rate", "root node name")

			check_test (l_tree.root.edges.count = 2, "root child count")

			create l_children.make (2)
			l_children.set_equality_tester (string_equality_tester)
			l_children.force ("astigmatism")
			l_children.force ("none")

			check_test(l_children.has (l_tree.root.edges[1].node.name), "child name")

			check_test(l_children.has (l_tree.root.edges[2].node.name), "child name")

--			l_file.delete
		end


feature{RM_TESTS} -- Output helpers

	check_test(a_condition: BOOLEAN; message: STRING)
			-- If the condition it true then it prints "pass" + message
			-- else it prints "fail" + message
		do
			if a_condition then
				io.put_string ("PASS: " + message)
			else
				io.put_string ("FAIL: " + message)
			end
			io.put_new_line
		end


feature{RM_TESTS} -- arff files' sources

	extend_arff: STRING
		do
			Result := "[
			@RELATION LINKED_LIST.extend

%
%LINKED_LIST.extend
%{0}: {LINKED_LIST [ANY]}
%{1}: {ANY}
%
%
@ATTRIBUTE id	NUMERIC
@ATTRIBUTE uuid	STRING
@ATTRIBUTE "pre::{0}.empty"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.object_comparison"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.changeable_comparison_criterion"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.replaceable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.exhausted"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.writable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.is_empty"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.extendible"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.prunable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.index"	NUMERIC
@ATTRIBUTE "pre::{0}.count"	NUMERIC
@ATTRIBUTE "pre::{0}.readable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.after"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.before"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.off"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.isfirst"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.islast"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.full"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.has ({0})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.has ({1})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.occurrences ({0})"	NUMERIC
@ATTRIBUTE "pre::{0}.occurrences ({1})"	NUMERIC
@ATTRIBUTE "pre::{0}.is_inserted ({0})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.is_inserted ({1})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0} ~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0} = {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} ~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} = {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0} ~ {0}.linear_representation"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0} = {0}.linear_representation"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0} ~ {0}.cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0} = {0}.cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0} ~ {0}.new_cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0} = {0}.new_cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} ~ {0}.index_set"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} = {0}.index_set"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} ~ {0}.item_for_iteration"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} = {0}.item_for_iteration"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} ~ {0}.item"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} = {0}.item"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} ~ {0}.first"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} = {0}.first"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} ~ {0}.last"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} = {0}.last"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.index = {0}.count"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.count = {0}.index"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0} /~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} /~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0} /= {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} /= {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.linear_representation ~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0} /~ {0}.linear_representation"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.linear_representation /~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.linear_representation = {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0} /= {0}.linear_representation"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.linear_representation /= {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.cursor ~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0} /~ {0}.cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.cursor /~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.cursor = {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0} /= {0}.cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.cursor /= {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.new_cursor ~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0} /~ {0}.new_cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.new_cursor /~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.new_cursor = {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0} /= {0}.new_cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.new_cursor /= {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.index_set ~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} /~ {0}.index_set"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.index_set /~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.index_set = {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} /= {0}.index_set"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.index_set /= {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.item_for_iteration ~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} /~ {0}.item_for_iteration"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.item_for_iteration /~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.item_for_iteration = {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} /= {0}.item_for_iteration"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.item_for_iteration /= {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.item ~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} /~ {0}.item"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.item /~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.item = {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} /= {0}.item"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.item /= {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.first ~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} /~ {0}.first"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.first /~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.first = {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} /= {0}.first"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.first /= {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.last ~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} /~ {0}.last"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.last /~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.last = {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{1} /= {0}.last"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.last /= {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.index /= {0}.count"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.count /= {0}.index"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.empty"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.object_comparison"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.changeable_comparison_criterion"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.replaceable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.exhausted"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.writable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.is_empty"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.extendible"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.prunable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.index"	NUMERIC
@ATTRIBUTE "post::{0}.count"	NUMERIC
@ATTRIBUTE "post::{0}.readable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.after"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.before"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.off"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.isfirst"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.islast"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.full"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.has ({0})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.has ({1})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.occurrences ({0})"	NUMERIC
@ATTRIBUTE "post::{0}.occurrences ({1})"	NUMERIC
@ATTRIBUTE "post::{0}.is_inserted ({0})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.is_inserted ({1})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0} ~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0} = {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} ~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} = {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0} ~ {0}.linear_representation"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0} = {0}.linear_representation"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0} ~ {0}.cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0} = {0}.cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0} ~ {0}.new_cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0} = {0}.new_cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} ~ {0}.index_set"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} = {0}.index_set"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} ~ {0}.item_for_iteration"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} = {0}.item_for_iteration"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} ~ {0}.item"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} = {0}.item"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} ~ {0}.first"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} = {0}.first"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} ~ {0}.last"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} = {0}.last"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.index = {0}.count"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.count = {0}.index"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0} /~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} /~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0} /= {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} /= {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.linear_representation ~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0} /~ {0}.linear_representation"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.linear_representation /~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.linear_representation = {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0} /= {0}.linear_representation"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.linear_representation /= {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.cursor ~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0} /~ {0}.cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.cursor /~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.cursor = {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0} /= {0}.cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.cursor /= {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.new_cursor ~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0} /~ {0}.new_cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.new_cursor /~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.new_cursor = {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0} /= {0}.new_cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.new_cursor /= {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.index_set ~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} /~ {0}.index_set"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.index_set /~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.index_set = {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} /= {0}.index_set"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.index_set /= {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.item_for_iteration ~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} /~ {0}.item_for_iteration"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.item_for_iteration /~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.item_for_iteration = {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} /= {0}.item_for_iteration"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.item_for_iteration /= {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.item ~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} /~ {0}.item"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.item /~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.item = {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} /= {0}.item"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.item /= {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.first ~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} /~ {0}.first"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.first /~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.first = {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} /= {0}.first"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.first /= {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.last ~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} /~ {0}.last"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.last /~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.last = {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{1} /= {0}.last"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.last /= {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.index /= {0}.count"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.count /= {0}.index"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.empty"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.object_comparison"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.changeable_comparison_criterion"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.replaceable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.exhausted"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.writable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.is_empty"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.extendible"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.prunable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "by::{0}.index"	NUMERIC
@ATTRIBUTE "to::{0}.index"	NUMERIC
@ATTRIBUTE "by::{0}.count"	NUMERIC
@ATTRIBUTE "to::{0}.count"	NUMERIC
@ATTRIBUTE "to::{0}.readable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.after"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.before"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.off"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.isfirst"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.islast"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.full"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.has ({0})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.has ({1})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "by::{0}.occurrences ({0})"	NUMERIC
@ATTRIBUTE "to::{0}.occurrences ({0})"	NUMERIC
@ATTRIBUTE "by::{0}.occurrences ({1})"	NUMERIC
@ATTRIBUTE "to::{0}.occurrences ({1})"	NUMERIC
@ATTRIBUTE "to::{0}.is_inserted ({1})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0} ~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0} = {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} ~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} = {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0} ~ {0}.linear_representation"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0} = {0}.linear_representation"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0} ~ {0}.cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0} = {0}.cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0} ~ {0}.new_cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0} = {0}.new_cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} ~ {0}.index_set"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} = {0}.index_set"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} ~ {0}.first"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} = {0}.first"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} ~ {0}.last"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} = {0}.last"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.index = {0}.count"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.count = {0}.index"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0} /~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} /~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0} /= {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} /= {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.linear_representation ~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0} /~ {0}.linear_representation"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.linear_representation /~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.linear_representation = {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0} /= {0}.linear_representation"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.linear_representation /= {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.cursor ~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0} /~ {0}.cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.cursor /~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.cursor = {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0} /= {0}.cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.cursor /= {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.new_cursor ~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0} /~ {0}.new_cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.new_cursor /~ {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.new_cursor = {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0} /= {0}.new_cursor"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.new_cursor /= {0}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.index_set ~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} /~ {0}.index_set"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.index_set /~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.index_set = {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} /= {0}.index_set"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.index_set /= {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.first ~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} /~ {0}.first"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.first /~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.first = {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} /= {0}.first"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.first /= {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.last ~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} /~ {0}.last"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.last /~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.last = {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} /= {0}.last"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.last /= {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.index /= {0}.count"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.count /= {0}.index"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.is_inserted ({0})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} ~ {0}.item_for_iteration"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} = {0}.item_for_iteration"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} ~ {0}.item"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} = {0}.item"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.item_for_iteration ~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} /~ {0}.item_for_iteration"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.item_for_iteration /~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.item_for_iteration = {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} /= {0}.item_for_iteration"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.item_for_iteration /= {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.item ~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} /~ {0}.item"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.item /~ {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.item = {1}"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{1} /= {0}.item"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.item /= {1}"	{True, False, STAY_TRUE, STAY_FALSE}

@DATA
1,172835654,False,True,True,True,True,False,False,True,True,3,2,False,True,False,True,False,False,False,False,True,0,1,?,?,False,False,False,False,True,True,False,False,False,False,False,False,?,?,?,?,True,False,False,False,False,False,True,True,True,True,True,False,False,True,False,False,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,?,?,?,?,?,?,?,?,?,?,?,?,True,False,False,False,True,True,False,True,True,False,True,True,True,True,False,True,True,True,True,False,False,True,True,4,3,False,True,False,True,False,False,False,False,True,0,2,?,True,False,False,False,False,True,True,False,False,False,False,False,False,?,?,?,?,True,False,True,True,False,False,True,True,True,True,True,False,False,True,False,False,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,?,?,?,?,?,?,?,?,?,?,?,?,True,False,False,False,True,True,True,False,False,True,False,False,True,True,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,1,4,1,3,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,0,0,1,2,True,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_FALSE,True,True,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,True,False,False,True,False,False,STAY_TRUE,STAY_TRUE,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?
2,237323830,False,False,True,True,False,True,False,True,True,1,2,True,False,False,False,True,False,False,False,False,0,0,False,False,False,False,False,False,True,True,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,True,True,True,True,True,False,False,True,False,False,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,True,True,False,False,True,True,False,True,False,True,True,1,3,True,False,False,False,True,False,False,False,True,0,1,False,True,False,False,False,False,True,True,False,False,False,False,False,False,False,False,False,False,False,False,True,True,False,False,True,True,True,True,True,False,False,True,False,False,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,True,False,False,True,False,False,True,True,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,0,1,1,3,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,True,0,0,1,1,True,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,True,True,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,True,False,False,True,False,False,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE
3,1871784258,False,True,True,True,False,True,False,True,True,1,3,True,False,False,False,True,False,False,False,False,0,0,False,False,False,False,False,False,True,True,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,False,True,True,True,True,True,False,False,True,False,False,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,True,True,False,True,True,True,False,True,False,True,True,1,4,True,False,False,False,True,False,False,False,True,0,1,False,True,False,False,False,False,True,True,False,False,False,False,False,False,False,False,False,False,False,False,True,True,False,False,True,True,True,True,True,False,False,True,False,False,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,True,False,False,True,False,False,True,True,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,0,1,1,4,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,True,0,0,1,1,True,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,True,True,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,True,False,False,True,False,False,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE
4,1389146946,False,False,True,True,False,True,False,True,True,2,2,True,False,False,False,False,True,False,False,False,0,0,False,False,False,False,False,False,True,True,False,False,False,False,False,False,False,False,False,False,True,False,False,False,True,True,True,True,True,True,True,False,False,True,False,False,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,True,False,False,False,True,True,False,True,True,False,True,True,False,False,False,False,True,True,False,True,False,True,True,2,3,True,False,False,False,False,False,False,False,True,0,1,False,True,False,False,False,False,True,True,False,False,False,False,False,False,False,False,False,False,True,False,True,True,False,False,True,True,True,True,True,False,False,True,False,False,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,False,True,True,True,False,False,False,True,True,True,False,False,True,False,False,True,True,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,0,2,1,3,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,False,STAY_FALSE,STAY_FALSE,True,0,0,1,1,True,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_FALSE,True,True,False,False,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,True,False,False,True,False,False,True,True,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE

			]"
		end

	search_arff: STRING
		do
			Result := "[
@RELATION LINKED_LIST.search

%
%LINKED_LIST.search
%{0}: {LINKED_LIST [ANY]}
%{1}: {ANY}
%
%
@ATTRIBUTE id	NUMERIC
@ATTRIBUTE uuid	STRING
@ATTRIBUTE "pre::{0}.object_comparison"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.count"	NUMERIC
@ATTRIBUTE "pre::{0}.after"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.before"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.empty"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.changeable_comparison_criterion"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.replaceable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.exhausted"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.writable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.is_empty"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.extendible"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.prunable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.index"	NUMERIC
@ATTRIBUTE "pre::{0}.readable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.off"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.isfirst"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.islast"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.has ({0})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.has ({1})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.occurrences ({0})"	NUMERIC
@ATTRIBUTE "pre::{0}.occurrences ({1})"	NUMERIC
@ATTRIBUTE "pre::{0}.is_inserted ({0})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "pre::{0}.is_inserted ({1})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.object_comparison"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.count"	NUMERIC
@ATTRIBUTE "post::{0}.after"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.before"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.empty"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.changeable_comparison_criterion"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.replaceable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.exhausted"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.writable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.is_empty"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.extendible"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.prunable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.index"	NUMERIC
@ATTRIBUTE "post::{0}.readable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.off"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.isfirst"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.islast"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.has ({0})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.has ({1})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.occurrences ({0})"	NUMERIC
@ATTRIBUTE "post::{0}.occurrences ({1})"	NUMERIC
@ATTRIBUTE "post::{0}.is_inserted ({0})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::{0}.is_inserted ({1})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::(not {0}.exhausted and {0}.object_comparison) implies {1} ~ {0}.item"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "post::(not {0}.exhausted and not {0}.object_comparison) implies {1} = {0}.item"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.object_comparison"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "by::{0}.count"	NUMERIC
@ATTRIBUTE "to::{0}.after"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.before"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.empty"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.changeable_comparison_criterion"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.replaceable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.exhausted"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.writable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.is_empty"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.extendible"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.prunable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "by::{0}.index"	NUMERIC
@ATTRIBUTE "to::{0}.readable"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.off"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.isfirst"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.islast"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.has ({0})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.has ({1})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "by::{0}.occurrences ({0})"	NUMERIC
@ATTRIBUTE "by::{0}.occurrences ({1})"	NUMERIC
@ATTRIBUTE "to::{0}.index"	NUMERIC
@ATTRIBUTE "to::{0}.is_inserted ({0})"	{True, False, STAY_TRUE, STAY_FALSE}
@ATTRIBUTE "to::{0}.is_inserted ({1})"	{True, False, STAY_TRUE, STAY_FALSE}

@DATA
1,1923403829,True,2,True,False,False,True,True,True,False,False,True,True,3,False,True,False,False,False,True,0,1,?,?,True,2,True,False,False,True,True,True,False,False,True,True,3,False,True,False,False,False,True,0,1,?,?,True,True,STAY_TRUE,0,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,0,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,0,0,?,?,?
2,1955313464,False,2,False,False,False,True,True,False,True,False,True,True,1,True,False,True,False,False,False,0,0,False,False,False,2,True,False,False,True,True,True,False,False,True,True,3,False,True,False,False,False,False,0,0,?,?,True,True,STAY_FALSE,0,True,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,True,False,STAY_FALSE,STAY_TRUE,STAY_TRUE,2,False,True,False,STAY_FALSE,STAY_FALSE,STAY_FALSE,0,0,3,?,?
3,516878903,True,2,False,False,False,True,True,False,True,False,True,True,2,True,False,False,True,True,True,1,1,False,False,True,2,False,False,False,True,True,False,True,False,True,True,2,True,False,False,True,True,True,1,1,False,False,True,True,STAY_TRUE,0,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,0,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,0,0,?,STAY_FALSE,STAY_FALSE
4,79144772,True,3,False,False,False,True,True,False,True,False,True,True,1,True,False,True,False,False,False,0,0,False,False,True,3,True,False,False,True,True,True,False,False,True,True,4,False,True,False,False,False,False,0,0,?,?,True,True,STAY_TRUE,0,True,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,True,False,STAY_FALSE,STAY_TRUE,STAY_TRUE,3,False,True,False,STAY_FALSE,STAY_FALSE,STAY_FALSE,0,0,4,?,?
5,1830606404,False,2,False,False,False,True,True,False,True,False,True,True,2,True,False,False,True,False,False,0,0,False,False,False,2,True,False,False,True,True,True,False,False,True,True,3,False,True,False,False,False,False,0,0,?,?,True,True,STAY_FALSE,0,True,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,True,False,STAY_FALSE,STAY_TRUE,STAY_TRUE,1,False,True,STAY_FALSE,False,STAY_FALSE,STAY_FALSE,0,0,3,?,?
6,586957872,True,1,False,False,False,True,True,False,True,False,True,True,1,True,False,True,True,False,True,0,1,False,True,True,1,False,False,False,True,True,False,True,False,True,True,1,True,False,True,True,False,True,0,1,False,True,True,True,STAY_TRUE,0,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,0,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,0,0,?,STAY_FALSE,STAY_TRUE
7,1710031940,True,1,False,False,False,True,True,False,True,False,True,True,1,True,False,True,True,False,False,0,0,False,False,True,1,True,False,False,True,True,True,False,False,True,True,2,False,True,False,False,False,False,0,0,?,?,True,True,STAY_TRUE,0,True,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,True,False,STAY_FALSE,STAY_TRUE,STAY_TRUE,1,False,True,False,False,STAY_FALSE,STAY_FALSE,0,0,2,?,?
8,1951306804,False,2,False,True,False,True,True,True,False,False,True,True,0,False,True,False,False,False,True,0,1,?,?,False,2,False,False,False,True,True,False,True,False,True,True,1,True,False,True,False,False,True,0,1,False,True,True,True,STAY_FALSE,0,STAY_FALSE,False,STAY_FALSE,STAY_TRUE,STAY_TRUE,False,True,STAY_FALSE,STAY_TRUE,STAY_TRUE,1,True,False,True,STAY_FALSE,STAY_FALSE,STAY_TRUE,0,0,1,False,True
9,1004996914,False,2,False,True,False,True,True,True,False,False,True,True,0,False,True,False,False,True,False,1,0,True,?,False,2,True,False,False,True,True,True,False,False,True,True,3,False,True,False,False,True,False,1,0,True,?,True,True,STAY_FALSE,0,True,False,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,3,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_FALSE,0,0,3,STAY_TRUE,?
10,890171447,False,3,False,True,False,True,True,True,False,False,True,True,0,False,True,False,False,False,False,0,0,?,?,False,3,True,False,False,True,True,True,False,False,True,True,4,False,True,False,False,False,False,0,0,?,?,True,True,STAY_FALSE,0,True,False,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,4,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,0,0,4,?,?
11,1607463732,False,2,False,True,False,True,True,True,False,False,True,True,0,False,True,False,False,False,False,0,0,?,?,False,2,True,False,False,True,True,True,False,False,True,True,3,False,True,False,False,False,False,0,0,?,?,True,True,STAY_FALSE,0,True,False,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,3,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,0,0,3,?,?
12,1044589126,False,2,False,True,False,True,True,True,False,False,True,True,0,False,True,False,False,False,True,0,2,?,True,False,2,False,False,False,True,True,False,True,False,True,True,1,True,False,True,False,False,True,0,2,False,True,True,True,STAY_FALSE,0,STAY_FALSE,False,STAY_FALSE,STAY_TRUE,STAY_TRUE,False,True,STAY_FALSE,STAY_TRUE,STAY_TRUE,1,True,False,True,STAY_FALSE,STAY_FALSE,STAY_TRUE,0,0,1,False,STAY_TRUE
13,1254308675,False,4,False,True,False,True,True,True,False,False,True,True,0,False,True,False,False,False,False,0,0,?,?,False,4,True,False,False,True,True,True,False,False,True,True,5,False,True,False,False,False,False,0,0,?,?,True,True,STAY_FALSE,0,True,False,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,5,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,0,0,5,?,?
14,1439502137,False,0,False,True,True,True,True,True,False,True,True,True,0,False,True,False,False,False,False,0,0,False,False,False,0,False,True,True,True,True,True,False,True,True,True,0,False,True,False,False,False,False,0,0,False,False,True,True,STAY_FALSE,0,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,0,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,0,0,?,STAY_FALSE,STAY_FALSE
15,438386501,False,5,False,False,False,True,True,False,True,False,True,True,4,True,False,False,False,False,False,0,0,False,False,False,5,True,False,False,True,True,True,False,False,True,True,6,False,True,False,False,False,False,0,0,?,?,True,True,STAY_FALSE,0,True,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,True,False,STAY_FALSE,STAY_TRUE,STAY_TRUE,2,False,True,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,0,0,6,?,?
16,729058103,False,1,True,False,False,True,True,True,False,False,True,True,2,False,True,False,False,False,True,0,1,?,True,False,1,True,False,False,True,True,True,False,False,True,True,2,False,True,False,False,False,True,0,1,?,True,True,True,STAY_FALSE,0,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,0,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,0,0,?,?,STAY_TRUE
17,1173619512,False,2,True,False,False,True,True,True,False,False,True,True,3,False,True,False,False,True,False,1,0,True,?,False,2,True,False,False,True,True,True,False,False,True,True,3,False,True,False,False,True,False,1,0,True,?,True,True,STAY_FALSE,0,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,0,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_FALSE,0,0,?,STAY_TRUE,?
18,661266480,True,5,False,False,False,True,True,False,True,False,True,True,1,True,False,True,False,False,True,0,3,False,False,True,5,False,False,False,True,True,False,True,False,True,True,1,True,False,True,False,False,True,0,3,False,False,True,True,STAY_TRUE,0,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,0,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,0,0,?,STAY_FALSE,STAY_FALSE
19,2116066881,False,1,False,False,False,True,True,False,True,False,True,True,1,True,False,True,True,True,False,1,0,True,False,False,1,True,False,False,True,True,True,False,False,True,True,2,False,True,False,False,True,False,1,0,True,?,True,True,STAY_FALSE,0,True,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,True,False,STAY_FALSE,STAY_TRUE,STAY_TRUE,1,False,True,False,False,STAY_TRUE,STAY_FALSE,0,0,2,STAY_TRUE,?
20,2072966192,False,1,True,False,False,True,True,True,False,False,True,True,2,False,True,False,False,False,False,0,0,?,?,False,1,True,False,False,True,True,True,False,False,True,True,2,False,True,False,False,False,False,0,0,?,?,True,True,STAY_FALSE,0,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,0,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,0,0,?,?,?
21,1441502001,True,2,False,False,False,True,True,False,True,False,True,True,2,True,False,False,True,False,True,0,1,False,False,True,2,False,False,False,True,True,False,True,False,True,True,2,True,False,False,True,False,True,0,1,False,False,True,True,STAY_TRUE,0,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,0,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_TRUE,0,0,?,STAY_FALSE,STAY_FALSE
22,39350595,False,2,True,False,False,True,True,True,False,False,True,True,3,False,True,False,False,False,True,0,1,?,?,False,2,True,False,False,True,True,True,False,False,True,True,3,False,True,False,False,False,True,0,1,?,?,True,True,STAY_FALSE,0,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,0,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,0,0,?,?,?
23,1014812472,False,1,False,False,False,True,True,False,True,False,True,True,1,True,False,True,True,False,True,0,1,False,True,False,1,False,False,False,True,True,False,True,False,True,True,1,True,False,True,True,False,True,0,1,False,True,True,True,STAY_FALSE,0,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,0,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,0,0,?,STAY_FALSE,STAY_TRUE
24,597779265,False,2,True,False,False,True,True,True,False,False,True,True,3,False,True,False,False,False,True,0,1,?,True,False,2,True,False,False,True,True,True,False,False,True,True,3,False,True,False,False,False,True,0,1,?,True,True,True,STAY_FALSE,0,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,0,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,0,0,?,?,STAY_TRUE
25,1985315128,False,1,False,True,False,True,True,True,False,False,True,True,0,False,True,False,False,False,False,0,0,?,?,False,1,True,False,False,True,True,True,False,False,True,True,2,False,True,False,False,False,False,0,0,?,?,True,True,STAY_FALSE,0,True,False,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,2,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,0,0,2,?,?
26,1016435525,False,0,False,True,True,True,True,True,False,True,True,True,0,False,True,False,False,False,False,0,0,False,False,False,0,False,True,True,True,True,True,False,True,True,True,0,False,True,False,False,False,False,0,0,False,False,True,True,STAY_FALSE,0,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,0,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,0,0,?,STAY_FALSE,STAY_FALSE
27,1167960644,False,2,True,False,False,True,True,True,False,False,True,True,3,False,True,False,False,False,False,0,0,?,?,False,2,True,False,False,True,True,True,False,False,True,True,3,False,True,False,False,False,False,0,0,?,?,True,True,STAY_FALSE,0,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,0,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,0,0,?,?,?
28,533101126,True,2,False,True,False,True,True,True,False,False,True,True,0,False,True,False,False,False,False,0,0,?,?,True,2,True,False,False,True,True,True,False,False,True,True,3,False,True,False,False,False,False,0,0,?,?,True,True,STAY_TRUE,0,True,False,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,3,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,0,0,3,?,?
29,753684016,False,1,False,True,False,True,True,True,False,False,True,True,0,False,True,False,False,False,True,0,1,?,True,False,1,False,False,False,True,True,False,True,False,True,True,1,True,False,True,True,False,True,0,1,False,True,True,True,STAY_FALSE,0,STAY_FALSE,False,STAY_FALSE,STAY_TRUE,STAY_TRUE,False,True,STAY_FALSE,STAY_TRUE,STAY_TRUE,1,True,False,True,True,STAY_FALSE,STAY_TRUE,0,0,1,False,STAY_TRUE
30,734402865,False,3,True,False,False,True,True,True,False,False,True,True,4,False,True,False,False,False,True,0,2,?,True,False,3,True,False,False,True,True,True,False,False,True,True,4,False,True,False,False,False,True,0,2,?,True,True,True,STAY_FALSE,0,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,0,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,0,0,?,?,STAY_TRUE
31,1116875574,False,2,False,False,False,True,True,False,True,False,True,True,1,True,False,True,False,False,True,0,1,False,True,False,2,False,False,False,True,True,False,True,False,True,True,2,True,False,False,True,False,True,0,1,False,True,True,True,STAY_FALSE,0,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,1,STAY_TRUE,STAY_FALSE,False,True,STAY_FALSE,STAY_TRUE,0,0,2,STAY_FALSE,STAY_TRUE
32,1949910839,True,0,True,False,True,True,True,True,False,True,True,True,1,False,True,False,False,False,False,0,0,False,False,True,0,True,False,True,True,True,True,False,True,True,True,1,False,True,False,False,False,False,0,0,False,False,True,True,STAY_TRUE,0,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,0,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,0,0,?,STAY_FALSE,STAY_FALSE
33,651531589,True,0,False,True,True,True,True,True,False,True,True,True,0,False,True,False,False,False,False,0,0,False,False,True,0,False,True,True,True,True,True,False,True,True,True,0,False,True,False,False,False,False,0,0,False,False,True,True,STAY_TRUE,0,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,0,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,0,0,?,STAY_FALSE,STAY_FALSE
34,970225222,False,3,False,False,False,True,True,False,True,False,True,True,1,True,False,True,False,False,False,0,0,False,False,False,3,True,False,False,True,True,True,False,False,True,True,4,False,True,False,False,False,False,0,0,?,?,True,True,STAY_FALSE,0,True,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,True,False,STAY_FALSE,STAY_TRUE,STAY_TRUE,3,False,True,False,STAY_FALSE,STAY_FALSE,STAY_FALSE,0,0,4,?,?
35,710484016,False,1,False,False,False,True,True,False,True,False,True,True,1,True,False,True,True,False,False,0,0,False,False,False,1,True,False,False,True,True,True,False,False,True,True,2,False,True,False,False,False,False,0,0,?,?,True,True,STAY_FALSE,0,True,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,True,False,STAY_FALSE,STAY_TRUE,STAY_TRUE,1,False,True,False,False,STAY_FALSE,STAY_FALSE,0,0,2,?,?
36,544344886,True,1,True,False,False,True,True,True,False,False,True,True,2,False,True,False,False,False,False,0,0,?,?,True,1,True,False,False,True,True,True,False,False,True,True,2,False,True,False,False,False,False,0,0,?,?,True,True,STAY_TRUE,0,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,0,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,0,0,?,?,?
37,769171267,False,0,True,False,True,True,True,True,False,True,True,True,1,False,True,False,False,False,False,0,0,False,False,False,0,True,False,True,True,True,True,False,True,True,True,1,False,True,False,False,False,False,0,0,False,False,True,True,STAY_FALSE,0,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,0,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,0,0,?,STAY_FALSE,STAY_FALSE
38,488499012,True,1,False,True,False,True,True,True,False,False,True,True,0,False,True,False,False,False,False,0,0,?,?,True,1,True,False,False,True,True,True,False,False,True,True,2,False,True,False,False,False,False,0,0,?,?,True,True,STAY_TRUE,0,True,False,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,2,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,0,0,2,?,?
39,1935201589,False,3,True,False,False,True,True,True,False,False,True,True,4,False,True,False,False,False,False,0,0,?,?,False,3,True,False,False,True,True,True,False,False,True,True,4,False,True,False,False,False,False,0,0,?,?,True,True,STAY_FALSE,0,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_TRUE,STAY_TRUE,0,STAY_FALSE,STAY_TRUE,STAY_FALSE,STAY_FALSE,STAY_FALSE,STAY_FALSE,0,0,?,?,?
			]"

		end

	weka_arff: STRING
		do
			Result:= "[
@relation contact-lenses

@attribute age 			{young, pre-presbyopic, presbyopic}
@attribute spectacle-prescrip	{myope, hypermetrope}
@attribute astigmatism		{no, yes}
@attribute tear-prod-rate	{reduced, normal}
@attribute contact-lenses	{soft, hard, none}

@data
%
% 24 instances
%
young,myope,no,reduced,none
young,myope,no,normal,soft
young,myope,yes,reduced,none
young,myope,yes,normal,hard
young,hypermetrope,no,reduced,none
young,hypermetrope,no,normal,soft
young,hypermetrope,yes,reduced,none
young,hypermetrope,yes,normal,hard
pre-presbyopic,myope,no,reduced,none
pre-presbyopic,myope,no,normal,soft
pre-presbyopic,myope,yes,reduced,none
pre-presbyopic,myope,yes,normal,hard
pre-presbyopic,hypermetrope,no,reduced,none
pre-presbyopic,hypermetrope,no,normal,soft
pre-presbyopic,hypermetrope,yes,reduced,none
pre-presbyopic,hypermetrope,yes,normal,none
presbyopic,myope,no,reduced,none
presbyopic,myope,no,normal,none
presbyopic,myope,yes,reduced,none
presbyopic,myope,yes,normal,hard
presbyopic,hypermetrope,no,reduced,none
presbyopic,hypermetrope,no,normal,soft
presbyopic,hypermetrope,yes,reduced,none
presbyopic,hypermetrope,yes,normal,none
	]"
		end
end

