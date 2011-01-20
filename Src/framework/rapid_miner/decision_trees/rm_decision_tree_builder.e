note
	description: "This class will take an arff file and different configurations and will produce the decision tree."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_DECISION_TREE_BUILDER

inherit
	RM_BUILDER
		redefine
			parse_model,
			parse_performance
		end

create
	make,
	make_with_relation

feature -- Create

	make (a_arff_file_path: STRING; a_selected_attributes: LIST [STRING]; a_label_name: STRING)
			-- creates a decision tree builder with default decision_tree algorithm and
			-- 'no_validation'
		require
			selected_attributes_not_empty: not a_selected_attributes.is_empty
			a_label_attribute_valid: a_selected_attributes.has (a_label_name)
		do
			initialize (algorithm_decision_tree, no_validation, a_arff_file_path, a_selected_attributes, a_label_name)
		end

	make_with_relation (a_relation: WEKA_ARFF_RELATION; a_selected_attributes: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]; a_label_attribute: WEKA_ARFF_ATTRIBUTE)
			-- Initialize current with ARFF relation `a_relation'.
			-- `a_selected_attributes' is a subset of attributes in `a_relation', which will be used for the tree learning.
			-- `a_label_attribute' is the goal attribute whose values are to be classified by the learnt tree.
			-- Use default decision tree algorithm, and default validation criterion.
		require
			a_selection_attributes_valid: a_selected_attributes.is_subset (a_relation.attribute_set)
			a_label_attribute_valid: a_selected_attributes.has (a_label_attribute)
		do
			initialize_with_relation (algorithm_decision_tree, a_relation, a_selected_attributes, a_label_attribute)
		end

feature -- Access

	last_tree: RM_DECISION_TREE
		-- Last tree built by `build'

feature -- Validity

	is_algorithm_valid(a_algorithm_name: STRING): BOOLEAN
		do
			Result := decision_tree_algorithms.has (a_algorithm_name)
		end

feature{RM_BUILDER} -- Implementation

	parse_model
			-- Parses the model file.
		local
			l_model_parser: RM_DECISION_TREE_PARSER_INTERFACE
		do
			l_model_parser := parsers[algorithm_name]
			l_model_parser.parse

			create last_tree.make (l_model_parser.last_node, label_name)
		end

	parse_performance
			-- Parses the performance file.
		local
			l_perf_parser: RM_PERFORMANCE_PARSER
		do
			if validation_code /= {RM_CONSTANTS}.no_validation then
				create l_perf_parser
				l_perf_parser.parse_performance
				last_tree.set_is_accurate (l_perf_parser.is_accurate)
			end
		end

	parsers: HASH_TABLE [RM_DECISION_TREE_PARSER_INTERFACE, STRING]
		-- Gives the right parser for the particular decision tree algorithm.
		local
			l_parser: RM_DECISION_TREE_PARSER
		do
			create l_parser.make (rm_environment.model_file_path)
			create Result.make (10)
			Result[algorithm_decision_tree] := l_parser
			Result[algorithm_decision_tree_chaid] := l_parser
			Result[algorithm_decision_tree_decision_stump] := l_parser
			Result[algorithm_decision_tree_id3] := l_parser
		end

end
