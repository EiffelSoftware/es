note
	description: "Summary description for {AFX_LOCAL_ACCESS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_ACCESS_LOCAL

inherit
	EPA_ACCESS
		redefine
			is_local,
			length,
			type
		end

	EPA_SHARED_EXPR_TYPE_CHECKER

	SHARED_NAMES_HEAP

create
	make

feature{NONE} -- Initialization

	make (a_class: like context_class; a_feature: like context_feature; a_written_class: like written_class; a_name: like text; a_position: INTEGER; a_type: TYPE_A)
			-- Initialize Current with the `a_index'-th argument in `a_feature'.
		do
			make_with_class_feature (a_class, a_feature, a_written_class)
			type := actual_type_from_formal_type (a_type.instantiation_in (context_class.actual_type, context_class.class_id).actual_type, a_class)
			text := a_name.twin
			index := a_position
		end

feature -- Access

	index: INTEGER
			-- 1-based local index

	type: TYPE_A
			-- Type of current access

	text: STRING
			-- Text of current access

	length: INTEGER = 1
			-- Length of current access

feature -- Status report

	is_local: BOOLEAN = True
			-- Is current access a local?


end
