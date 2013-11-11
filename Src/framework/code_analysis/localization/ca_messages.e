note
	description: "Summary description for {CA_MESSAGES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

frozen class
	CA_MESSAGES

inherit {NONE}
	SHARED_LOCALE

feature -- Code Analyzer

	analyzing_class (a_class_name: READABLE_STRING_GENERAL): STRING_32
		do Result := locale.formatted_string (locale.translation ("Analyzing class $1 ...%N"), [a_class_name]) end


	self_assignment_violation_1: STRING_32
		do Result := locale.translation ("Variable '") end

	self_assignment_violation_2: STRING_32
		do Result := locale.translation ("' is assigned to itself. Assigning a variable to %
			                        %itself is a meaningless statement due to a typing%
			                        % error. Most probably, one of the two variable %
			                        %names was misspelled.") end

	unused_argument_violation_1: STRING_32
		do Result := locale.translation ("Arguments ") end

	unused_argument_violation_2: STRING_32
		do Result := locale.translation (" from routine '") end

	unused_argument_violation_3: STRING_32
		do Result := locale.translation ("' are not used.") end

	npath_violation_1: STRING_32
		do Result := locale.translation ("Routine '") end

	npath_violation_2: STRING_32
		do Result := locale.translation ("' has an NPATH measure of ") end

	npath_violation_3: STRING_32
		do Result := locale.translation (", which is greater than the defined maximum of ") end

	feature_never_called_violation_1: STRING_32
		do Result := locale.translation ("Feature '") end

	feature_never_called_violation_2: STRING_32
		do Result := locale.translation ("' is never called by any class.") end

	cq_separation_violation_1 : STRING_32
		do Result := locale.translation ("Function '") end

	cq_separation_violation_2: STRING_32
		do Result := locale.translation ("' contains a procedure call, assigns to an%
			% attribute, or creates an attribute. This indicates that the function%
			% changes the state of the object, which is a violation of the %
			%command-query separation principle.") end

feature -- Command Line

	cmd_class: STRING_32
		do Result := locale.translation ("%NIn class '") end

	cmd_help_message: STRING_32
		do Result := locale.translation ("Code Analysis performs static analyses on the source code and %
			           %outputs a list of issues found according to a set of rules.") end

end
