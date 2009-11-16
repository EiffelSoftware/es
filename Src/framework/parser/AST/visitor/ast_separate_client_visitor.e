indexing
	description: "Visitor to check separate keyword occurence"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	AST_SEPARATE_CLIENT_VISITOR

inherit
	AST_ITERATOR
		redefine
			process_class_type_as,
			process_generic_class_type_as,
			process_named_tuple_type_as
		end

feature -- Access

	process (a_class: CLASS_AS): BOOLEAN is
			-- checks if there is a separate keyword in the class
		require
			a_class_not_void: a_class /= Void
		do
			has_separate_keyword := false
			process_class_as (a_class)
			Result := has_separate_keyword
		end

feature {NONE} -- Implementation

	process_class_type_as (l_as: CLASS_TYPE_AS) is
		do
			if l_as.is_separate then
				has_separate_keyword := true
			end
			l_as.class_name.process (Current)
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS) is
		do
			if l_as.is_separate then
				has_separate_keyword := true
			end
			l_as.class_name.process (Current)
			l_as.internal_generics.process (Current)
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS) is
		do
			if l_as.is_separate then
				has_separate_keyword := true
			end
			l_as.class_name.process (Current)
			safe_process (l_as.parameters)
		end

	has_separate_keyword: BOOLEAN
			-- Storage for return value

end
