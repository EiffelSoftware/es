indexing
	description: "Summary description for {SCOOP_CLASS_NAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLASS_NAME

inherit
	SCOOP_WORKBENCH

feature -- Access

	process_class_name (l_as: ID_AS; is_set_prefix: BOOLEAN; l_context: ROUNDTRIP_CONTEXT; l_match_list: LEAF_AS_LIST) is
			-- Process 'l_as' with a class name printer
		require
			l_as_not_void: l_as /= Void
			l_context_not_void: l_context /= Void
			l_match_list_not_void: l_match_list /= Void
		do
			l_context_ref := l_context
			l_class_name_visitor.set_context (l_context_ref)
			l_class_name_visitor.setup (class_as, l_match_list, true, true)
			l_class_name_visitor.process_id (l_as, is_set_prefix)
		end

	process_class_name_str (l_class_name: STRING; is_set_prefix: BOOLEAN; l_context: ROUNDTRIP_CONTEXT; l_match_list: LEAF_AS_LIST) is
			-- Process 'l_as' with a class name printer
		require
			l_class_name_not_void: l_class_name /= Void
			l_context_not_void: l_context /= Void
			l_match_list_not_void: l_match_list /= Void
		do
			l_context_ref := l_context
			l_class_name_visitor.set_context (l_context_ref)
			l_class_name_visitor.setup (class_as, l_match_list, true, true)
			l_class_name_visitor.process_id_str (l_class_name, is_set_prefix)
		end

	process_class_name_list_with_prefix (l_as: CLASS_LIST_AS; print_both: BOOLEAN; l_context: ROUNDTRIP_CONTEXT; l_match_list: LEAF_AS_LIST) is
			-- Process 'l_as' with a class name printer
		require
			l_as_not_void: l_as /= Void
			l_context_not_void: l_context /= Void
			l_match_list_not_void: l_match_list /= Void
		do
			l_context_ref := l_context
			l_class_name_visitor.set_context (l_context_ref)
			l_class_name_visitor.setup (class_as, l_match_list, true, true)
			l_class_name_visitor.process_class_list_with_prefix (l_as, print_both)
		end

feature {NONE} -- Implementation

	l_context_ref: ROUNDTRIP_CONTEXT
			-- Reference to current processed context

	l_class_name_visitor_impl: SCOOP_CLASS_NAME_VISITOR is
			-- Creates a new class name visitor
		do
			Result := create {SCOOP_CLASS_NAME_VISITOR}.make_with_context (l_context_ref)
		end

	l_class_name_visitor: SCOOP_CLASS_NAME_VISITOR is
			-- Returns the once created visitor
		once
			Result := l_class_name_visitor_impl
		end

end
