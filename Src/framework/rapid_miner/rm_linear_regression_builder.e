note
	description: "Summary description for {RM_LR_BUILDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_LINEAR_REGRESSION_BUILDER

inherit
	RM_BUILDER	redefine
		parse_model,
		parse_performance
	end

create
	make,
	make_with_relation

feature -- Create

	make (a_arff_file_path: STRING; a_selected_attributes: LIST [STRING]; a_label_name: STRING)
			-- `a_arff_file_path' is the absolute path to the arff file which will be given to rapid miner.
			-- Use default linear regression algorithm, and default validation criterion.
		require
			selected_attributes_not_empty: not a_selected_attributes.is_empty
			a_label_attribute_valid: a_selected_attributes.has (a_label_name)
		do
			init(algorithm_linear_regression, no_validation, a_arff_file_path, a_selected_attributes, a_label_name)
		end

	make_with_relation (a_relation: WEKA_ARFF_RELATION; a_selected_attributes: DS_HASH_SET [WEKA_ARFF_ATTRIBUTE]; a_label_attribute: WEKA_ARFF_ATTRIBUTE)
			-- Initialize current with ARFF relation `a_relation'.
			-- `a_selected_attributes' is a subset of attributes in `a_relation', which will be used for the tree learning.
			-- `a_label_attribute' is the goal attribute whose values are to be classified by the learnt tree.
			-- Use default linear regression algorithm, and default validation criterion.
		require
			a_selection_attributes_valid: a_selected_attributes.is_subset (a_relation.attribute_set)
			a_label_attribute_valid: a_selected_attributes.has (a_label_attribute)
		do
			init_with_relation (algorithm_linear_regression, a_relation, a_selected_attributes, a_label_attribute)
		end

feature -- Access

	last_linear_regression: RM_LINEAR_REGRESSION

feature{RM_BUILDER} -- Implementation

	parse_model
		local
			l_model_parser: RM_LINEAR_REGRESSION_PARSER_INTERFACE
		do
			l_model_parser := parser
			l_model_parser.parse_linear_regression
			last_linear_regression := l_model_parser.last_linear_regression
			last_linear_regression.set_dependent_variable (label_name)
		end

	parse_performance
		local
			l_perf_parser: RM_PERFORMANCE_PARSER
		do
			if validation_code /= {RM_CONSTANTS}.no_validation then
				create l_perf_parser
				l_perf_parser.parse_performance
			end
		end

	parser: RM_LINEAR_REGRESSION_PARSER_INTERFACE
		-- Gives the right parser for the particular decision tree algorithm.
	do
		create {RM_LINEAR_REGRESSION_PARSER}Result.make(rm_environment.model_file_path)
	end

end
