indexing
	description: "Summary description for {SCOOP_PROXY_TYPE_SEPARATE_SIGNATURE_PRINTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROXY_TYPE_SEPARATE_SIGNATURE_PRINTER

obsolete "This class should not be in use."

inherit
	SCOOP_PROXY_TYPE_VISITOR
		redefine
			process_class_type_as
		end

create
	make_with_context

feature {NONE} -- Visitor implementation

	process_class_type_as (l_as: CLASS_TYPE_AS) is
		do
			-- get flags 'is_filter_detachable' and 'is_print_with_prefix'
			evaluate_class_type_flags (l_as.is_expanded, l_as.is_separate)

			-- process lcurly symbol
			safe_process (l_as.lcurly_symbol (match_list))

			-- process attachment mark
			process_attachment_mark (l_as.has_detachable_mark, l_as.attachment_mark_index, l_as.attachment_mark (match_list))

			-- skip expanded keyword
			if l_as.is_expanded then
				last_index := l_as.expanded_keyword_index
			end

			-- process class name
			if l_as.class_name.name.is_equal ("ANY") then
				context.add_string ("SCOOP_SEPARATE__")
			end

			process_class_name (l_as.class_name, is_print_with_prefix, context, match_list)
			if l_as.class_name /= Void then
				last_index := l_as.class_name.last_token (match_list).index
			end

			-- process rcurly symbol
			safe_process (l_as.rcurly_symbol (match_list))
		end

feature {NONE} -- Feature implementation

	evaluate_class_type_flags (is_expanded, is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		do
			is_print_with_prefix := true
			if is_separate and is_expanded then
				is_filter_detachable := true
			else
				is_filter_detachable := false
			end
		end

	evaluate_generic_class_type_flags (is_expanded, is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		do
			is_print_with_prefix := true
			if is_separate and is_expanded then
				is_filter_detachable := true
			else
				is_filter_detachable := false
			end
		end

	evaluate_named_tuple_type_flags (is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		do
			is_print_with_prefix := true
			if is_separate then
				is_filter_detachable := true
			else
				is_filter_detachable := false
			end
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
			is_print_with_prefix := true
			if is_separate and is_expanded then
				is_filter_detachable := true
			else
				is_filter_detachable := false
			end
		end

end
