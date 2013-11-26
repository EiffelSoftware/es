note
	description: "Summary description for {CA_NAMES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

frozen class
	CA_NAMES

inherit {NONE}
	SHARED_LOCALE

feature -- Rules

	self_assignment_title: STRING_32
		do Result := locale.translation ("Self-assignment") end

	self_assignment_description: STRING_32
		do Result := locale.translation ("Assigning a variable to itself is a meaningless statement%
			               % due to a typing error. Most probably, one of the two%
			               % variable names was misspelled. One example among many%
			               % others: the programmer wanted to assign a local variable%
			               % to a class attribute and used one of the variable names twice.") end

	unused_argument_title: STRING_32
		do Result := locale.translation ("Unused argument") end

	unused_argument_description: STRING_32
		do Result := locale.translation ("A feature should only have arguments which are actually %
			           %needed and used in the computation.") end

	npath_title: STRING_32
		do Result := locale.translation ("High NPATH") end

	npath_description: STRING_32
		do Result := locale.translation ("The NPATH measure is high.") end

	npath_threshold_option: STRING_32
		do Result := locale.translation ("Minimum NPATH threshold") end

	empty_if_title: STRING_32
		do Result := locale.translation ("Empty if statement") end

	empty_if_description: STRING_32
		do Result := locale.translation ("An empty if statement is useless and should be removed.") end

	variable_not_read_title: STRING_32
		do Result := locale.translation ("Variable not read after assignment") end

	feature_never_called_title: STRING_32
		do Result := locale.translation ("Feature never called") end

	cq_separation_title: STRING_32
		do Result := locale.translation ("No command-query separation (possible function side effect)") end

	unneeded_ot_local_title: STRING_32
		do Result := locale.translation ("Unneeded object test local") end

	unneeded_ot_local_description: STRING_32
		do Result := locale.translation ("For local variables, feature arguments, %
			%and object test locals it is unnecessary to let the attached keyword %
			%create a new and safe local reference.") end

	unneeded_object_test_title: STRING_32
		do Result := locale.translation ("Object test typing not needed") end

	unneeded_object_test_description: STRING_32
		do Result := locale.translation ("---") end

	nested_complexity_title: STRING_32
		do Result := locale.translation ("High complexity of nested branches and loops") end

	nested_complexity_description: STRING_32
		do Result := locale.translation ("---") end

	nested_complexity_threshold_option: STRING_32
		do Result := locale.translation ("Minimum nested branches and loops threshold") end

	many_arguments_title: STRING_32
		do Result := locale.translation ("Many feature arguments") end

	many_arguments_description: STRING_32
		do Result := locale.translation ("A feature that has many arguments should be%
			% avoided since it makes the class interface complicated and it is not%
			% easy to use. The feature arguments may include options, which should be%
			% considered to be moved to separate features. Interfaces of features with%
			% a large number of arguments are complicated, in the sense for example%
			% that they are hard to remember for the programmer. Often many arguments%
			% are of the same type (such as INTEGER). So, in a call, the passed%
			% arguments are likely to get mixed up, too, without the compiler detecting%
			% it. Arguments where in most of the cases the same value is passed--the%
			% default value--are called options. As opposed to operands, which are%
			% necessary in each feature call, each option should be moved to a separate%
			% feature. The features for options can then be called before the operational%
			% feature call in order to set (or unset) certain options. If a feature for%
			% an option is not called then the class assumes the default value for this option.") end

	arguments_threshold_option: STRING_32
		do Result := locale.translation ("Minimum arguments threshold") end

	creation_proc_exported_title: STRING_32
		do Result := locale.translation ("Creation procedure is exported") end

	creation_proc_exported_description: STRING_32
		do Result := locale.translation ("If the creation procedure is exported then%
			% it may still be called by clients after the object has been created.%
			% Ususally, this is not intended and ought to be changed. A client might,%
			% for example, by accident call 'x.make' instead of 'create x.make',%
			% causing the class invariant or postconditions of make to not hold anymore.") end

feature -- Preferences

	preferences_window_title: STRING_32
		do Result := locale.translation ("Code Analysis Preferences") end

	general_category: STRING_32
		do Result := locale.translation ("General") end

	rules_category: STRING_32
		do Result := locale.translation ("Rules") end

	are_errors_enabled: STRING_32
		do Result := locale.translation ("Enable errors") end

	are_warnings_enabled: STRING_32
		do Result := locale.translation ("Enable warnings") end

	are_suggestions_enabled: STRING_32
		do Result := locale.translation ("Enable suggestions") end

	are_hints_enabled: STRING_32
		do Result := locale.translation ("Enable hints") end

	enable_rule: STRING_32
		do Result := locale.translation ("Enable rule") end

	severity_score: STRING_32
		do Result := locale.translation ("Importance score") end

feature -- GUI

	tool_errors: STRING_32
		do Result := locale.translation ("Errors") end

	tool_warnings: STRING_32
		do Result := locale.translation ("Warnings") end

	tool_suggestions: STRING_32
		do Result := locale.translation ("Suggestions") end

	tool_hints: STRING_32
		do Result := locale.translation ("Hints") end

end
