note
	description: "This class will take an arff file and different configurations and will produce the decision tree."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_TREE_BUILDER
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

	last_tree: RM_DECISION_TREE

feature{RM_BUILDER} -- implementation

	parse_model
			-- parses the model file
		local
			l_model_parser: RM_DECISION_TREE_PARSER
		do
			create l_model_parser.make (rm_env.model_file_path)
			l_model_parser.parse_model

			create last_tree.make (l_model_parser.tree_root)
		end

	parse_performance
			-- parses the performance file
		local
			l_perf_parser: RM_DT_PERFORMANCE_PARSER
		do
			create l_perf_parser
			l_perf_parser.parse_performance
			last_tree.set_is_accurate (l_perf_parser.is_accurate)
		end

end
