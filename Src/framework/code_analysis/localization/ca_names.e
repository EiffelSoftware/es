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
		do Result := locale.translation ("") end

	variable_not_read_title: STRING_32
		do Result := locale.translation ("Variable not read after assignment") end

end
