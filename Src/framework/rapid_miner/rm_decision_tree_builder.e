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

	make(a_arff_file_path: STRING; a_selected_attributes: LIST [STRING]; a_label_name: STRING)
			-- creates a decision tree builder with default decision_tree algorithm and
			-- 'no_validation'
		do
			init(decision_tree, no_validation, a_arff_file_path, a_selected_attributes, a_label_name)
		end

	make_with_relation (a_relation: WEKA_ARFF_RELATION; a_selected_attributes: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]; a_label_attribute: WEKA_ARFF_ATTRIBUTE)
			-- Initialize current with ARFF relation `a_relation'.
			-- `a_selected_attributes' is a subset of attributes in `a_relation', which will be used for the tree learning.
			-- `a_label_attribute' is the goal attribute whose values are to be classified by the learnt tree.
			-- Use default decision tree algorithm, and default validation criterion.
		require
			a_selection_attributes_valid: a_selected_attributes.is_subset (a_relation.attribute_set)
			a_label_attribute_valid: a_selected_attributes.has (a_label_attribute)
		local
			l_arff_file: PLAIN_TEXT_FILE
			l_attr_list: LINKED_LIST[STRING]
		do
			create l_arff_file.make_create_read_write (rm_environment.rapid_miner_arff_file_path)
			a_relation.to_medium (l_arff_file)
			l_arff_file.close

			create l_attr_list.make
			from a_selected_attributes.start until a_selected_attributes.after loop
				l_attr_list.force (a_selected_attributes.item_for_iteration.name)
				a_selected_attributes.forth
			end

			init (decision_tree, no_validation, rm_environment.rapid_miner_arff_file_path, l_attr_list, a_label_attribute.name)
		end

feature -- Access

	last_tree: RM_DECISION_TREE
		-- Last tree built by `build'

feature{RM_BUILDER} -- Implementation

	parse_model
			-- Parses the model file.
		local
			l_model_parser: RM_DECISION_TREE_PARSER
		do
			create l_model_parser.make (rm_environment.model_file_path)
			l_model_parser.parse_model

			create last_tree.make (l_model_parser.tree_root, label_name)
		end

	parse_performance
			-- Parses the performance file.
		local
			l_perf_parser: RM_DECISION_TREE_PERFORMANCE_PARSER
		do
			if validation_code /= {RM_CONSTANTS}.no_validation then
				create l_perf_parser
				l_perf_parser.parse_performance
				last_tree.set_is_accurate (l_perf_parser.is_accurate)
			end
		end

end
