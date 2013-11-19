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
		do Result := locale.translation ("NPATH too high") end

	npath_description: STRING_32
		do Result := locale.translation ("The NPATH measure is too high.") end

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

	unneeded_object_test_title: STRING_32
		do Result := locale.translation ("Unneeded object test local") end

	unneeded_object_test_description: STRING_32
		do Result := locale.translation ("For local variables, feature arguments, %
			%and object test locals it is unnecessary to let the attached keyword %
			%create a new and safe local reference.") end

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
