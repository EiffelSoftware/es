indexing
	description: "Summary description for {SCOOP_PROXY_TYPE_SIGNATURE_PRINTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROXY_TYPE_SIGNATURE_PRINTER

inherit
	SCOOP_PROXY_TYPE_VISITOR
		redefine
			process_class_name
		end

create
	make_with_context

feature {NONE} -- Feature implementation

	evaluate_class_type_flags (is_expanded, is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		do
			if is_expanded then
				is_print_with_prefix := false
				is_filter_detachable := false
			else
				is_print_with_prefix := true
				is_filter_detachable := true
			end
		end

	evaluate_generic_class_type_flags (is_expanded, is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		do
			if is_expanded then
				is_print_with_prefix := false
				is_filter_detachable := false
			else
				is_print_with_prefix := true
				is_filter_detachable := true
			end
		end

	evaluate_named_tuple_type_flags (is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		do
			--if is_separate then
				is_print_with_prefix := true
				is_filter_detachable := true
			--else
			--	is_print_with_prefix := false
			--	is_filter_detachable := false
			--end
		end

	evaluate_like_current_type_flags is
			-- the flags are set dependant on the situation
		do
			is_print_with_prefix := true
			is_filter_detachable := false
		end

	evaluate_like_id_type_flags (is_expanded, is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		do
			if is_expanded then
				is_print_with_prefix := false
				is_filter_detachable := false
			else
				is_print_with_prefix := true
				is_filter_detachable := true
			end
		end

feature {NONE} -- class name implementation

	process_class_name (l_as: ID_AS; is_set_prefix: BOOLEAN; l_context: ROUNDTRIP_CONTEXT; l_match_list: LEAF_AS_LIST) is
			-- adds 'SCOOP_SEPARATE__'  as prefix to class name `ANY'
		do
			if l_as.name.as_upper.is_equal ("ANY") then
				context.add_string ("SCOOP_SEPARATE__")
			end
			Precursor (l_as, is_set_prefix, l_context, l_match_list)
		end


end
