note
	description: "Summary description for {RM_LR_BUILDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_LR_BUILDER

inherit
	RM_BUILDER	redefine
		parse_model,
		parse_performance
	end

create
	make

feature -- Create

	make(a_algorithm_code: INTEGER; a_validation_code: INTEGER; a_arff_file_path: STRING; a_selected_attributes: LIST[STRING]; a_label_name: STRING)
		do
			init(a_algorithm_code, a_validation_code, a_arff_file_path, a_selected_attributes, a_label_name)
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
			init_with_relation (a_relation, a_selected_attributes, a_label_attribute)
		end

feature -- Access

	last_linear_regression: RM_LINEAR_REGRESSION

feature{RM_BUILDER} -- implementation

	parse_model
			-- parses the model file
		local
			l_model_parser: RM_LINEAR_REGRESSION_PARSER
		do
			create l_model_parser.make (rm_environment.model_file_path)
			l_model_parser.parse_linear_regression
			last_linear_regression := l_model_parser.last_linear_regression
			last_linear_regression.set_dependent_variable(label_name)
		end

	parse_performance
			-- parses the performance file
		local
			l_perf_parser: RM_PERFORMANCE_PARSER
		do
			if validation_code /= {RM_CONSTANTS}.no_validation then
				create l_perf_parser
				l_perf_parser.parse_performance
			end
		end

end
