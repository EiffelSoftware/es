indexing
	description: "Summary description for {SCOOP_CLIENT_ARGUMENT_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_ARGUMENT_VISITOR

inherit
	AST_ROUNDTRIP_ITERATOR
		export
			{NONE} all
			{SCOOP_VISITOR_FACTORY} setup
		redefine
			process_type_dec_as,
			process_class_type_as,
			process_generic_class_type_as,
			process_named_tuple_type_as
		end

feature -- Access

	process_arguments (l_as: FORMAL_ARGU_DEC_LIST_AS): SCOOP_CLIENT_ARGUMENT_OBJECT is
			-- Process internal argument list.
			-- Save separate types declarations in a list.
		do
			create arguments.make
			safe_process (l_as)
			Result := arguments
		end

feature {NONE} -- Roundtrip/Token

	process_type_dec_as (l_as: TYPE_DEC_AS) is
		do
				-- reset flag
			is_current_type_separate := false

				-- evalualte separateness
			safe_process (l_as.type)

				-- save separate argument in list
			if is_current_type_separate then
				-- extend the list
				arguments.separate_arguments.extend (l_as)
			else
				arguments.non_separate_argument_list.extend (l_as)
			end
		end

	process_class_type_as (l_as: CLASS_TYPE_AS) is
		do
			if l_as.is_separate then
				is_current_type_separate := true
			end
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS) is
		do
			safe_process (l_as.internal_generics)
			if l_as.is_separate then
				is_current_type_separate := true
			end
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS) is
		do
			safe_process (l_as.parameters)
			if l_as.is_separate then
				is_current_type_separate := true
			end
		end

feature {NONE} -- Implementation

	arguments: SCOOP_CLIENT_ARGUMENT_OBJECT
		-- object collects processed arguments of processed feature

	is_current_type_separate: BOOLEAN
		-- separate state of current type declaration

end
