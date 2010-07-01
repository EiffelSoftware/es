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

feature -- Access

	linear_regression: RM_LINEAR_REGRESSION

feature{RM_BUILDER} -- implementation

	parse_model
			-- parses the model file
		local
			l_model_parser: RM_LINEAR_REGRESSION_PARSER
		do

		end

	parse_performance
			-- parses the performance file
		local
			l_perf_parser: RM_DT_PERFORMANCE_PARSER
		do
			create l_perf_parser
			l_perf_parser.parse_performance
		end

end
