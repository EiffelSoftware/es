note
	description: "Summary description for {AFX_ACCESS_ARGUMENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_ACCESS_ARGUMENT

inherit
	EPA_ACCESS
		redefine
			is_argument,
			length,
			type,
			text
		end

create
	make

feature{NONE} -- Initialization

	make (a_class: like context_class; a_feature: like context_feature; a_written_class: like written_class; a_index: INTEGER)
			-- Initialize Current with the `a_index'-th argument in `a_feature'.
		require
			a_index_valid: a_index >= 1 and a_index <= a_feature.argument_count
		do
			make_with_class_feature (a_class, a_feature, a_written_class)
			index := a_index
			text := a_feature.arguments.item_name (index).as_lower
			type :=
				actual_type_from_formal_type (
					a_feature.arguments.i_th (index).instantiation_in (context_class.actual_type, context_class.class_id).actual_type,
					a_class)

		ensure
			index_set: index = a_index
		end

feature -- Access

	index: INTEGER
			-- 1-based argument index

	type: TYPE_A
			-- Type of current access

	text: STRING
			-- Text of current access

	length: INTEGER = 1
			-- Length of current access

feature -- Status report

	is_argument: BOOLEAN = True
			-- Is Current access an argument?

end
