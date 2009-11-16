indexing
	description: "Summary description for {SCOOP_PROXY_TYPE_ATTRIBUTE_WRAPPER_PRINTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROXY_TYPE_ATTRIBUTE_WRAPPER_PRINTER

inherit
	SCOOP_PROXY_TYPE_VISITOR

create
	make_with_context

feature {NONE} -- Feature implementation

	evaluate_class_type_flags (is_expanded, is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		do
			if is_expanded then
				is_print_with_prefix := false
			else
				is_print_with_prefix := true
			end
			is_filter_detachable := true
		end

	evaluate_generic_class_type_flags (is_expanded, is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		do
			if is_expanded then
				is_print_with_prefix := false
			else
				is_print_with_prefix := true
			end
			is_filter_detachable := true
		end

	evaluate_named_tuple_type_flags (is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		do
			is_print_with_prefix := false
			is_filter_detachable := true
		end

	evaluate_like_current_type_flags is
			-- the flags are set dependant on the situation
		do
			is_print_with_prefix := true
			is_filter_detachable := true
		end

	evaluate_like_id_type_flags (is_expanded, is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		do
			if is_expanded then
				is_print_with_prefix := false
			else
				is_print_with_prefix := true
			end
			is_filter_detachable := true
		end

end
