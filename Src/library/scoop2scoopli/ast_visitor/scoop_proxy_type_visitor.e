indexing
	description: "Summary description for {SCOOP_PROXY_TYPE_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SCOOP_PROXY_TYPE_VISITOR

inherit
	SCOOP_CONTEXT_AST_PRINTER
		export
			{NONE} all
			{SCOOP_VISITOR_FACTORY} setup
		redefine
			process_class_type_as,
			process_generic_class_type_as,
			process_named_tuple_type_as,
			process_like_cur_as
		end
	SCOOP_CLASS_NAME

feature -- Initialisation

	make_with_context(a_context: ROUNDTRIP_CONTEXT)
			-- Initialise and reset flags
		require
			a_context_not_void: a_context /= Void
		do
			context := a_context

			-- Reset some values
			is_print_with_prefix := false
			is_filter_detachable := false
		end

feature -- Access

	process_type (l_as: TYPE_AS) is
			-- process 'l_as'
			-- print out the TYPE_AS as defined below
		do
			if l_as /= Void then
				last_index := l_as.start_position - 1
				safe_process (l_as)
			end
		end

	process_type_ast (l_as: AST_EIFFEL) is
			-- process 'l_as'
			-- used to print out internal generics and other types nodes
		do
			if l_as /= Void then
				last_index := l_as.start_position - 1
				safe_process (l_as)
			end
		end

feature {NONE} -- Roundtrip: process nodes

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
			process_class_name (l_as.class_name, is_print_with_prefix, context, match_list)
			if l_as.class_name /= Void then
				last_index := l_as.class_name.end_position
			end

			-- process rcurly symbol
			safe_process (l_as.rcurly_symbol (match_list))
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS) is
		local
			l_generics_visitor: SCOOP_GENERICS_VISITOR
		do
			-- get flags 'is_filter_detachable' and 'is_print_with_prefix'
			evaluate_generic_class_type_flags (l_as.is_expanded, l_as.is_separate)

			-- process lcurly symbol
			safe_process (l_as.lcurly_symbol (match_list))

			-- process attachment mark
			process_attachment_mark (l_as.has_detachable_mark, l_as.attachment_mark_index, l_as.attachment_mark (match_list))

			-- skip expanded_keyword
			if l_as.is_expanded then
				last_index := l_as.expanded_keyword_index
			end

			-- process class name
			process_class_name (l_as.class_name, is_print_with_prefix, context, match_list)
			if l_as.class_name /= Void then
				last_index := l_as.class_name.end_position
			end

			-- process internal generics			
			-- no `SCOOP_SEPARATE__' prefix, not detachable.
			l_generics_visitor := scoop_visitor_factory.new_generics_visitor (context)
			l_generics_visitor.process_type_internal_generics (l_as.internal_generics, false, false)
			if l_as.internal_generics /= Void then
				last_index := l_as.internal_generics.end_position
			end

			-- process rcurly symbol
			safe_process (l_as.rcurly_symbol (match_list))
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS) is
		do
			-- get flags 'is_filter_detachable' and 'is_print_with_prefix'
			evaluate_named_tuple_type_flags (l_as.is_separate)

			-- process lcurly symbol
			safe_process (l_as.lcurly_symbol (match_list))

			-- process attachment mark
			process_attachment_mark (l_as.has_detachable_mark, l_as.attachment_mark_index, l_as.attachment_mark (match_list))

			-- process class name
			process_class_name (l_as.class_name, is_print_with_prefix, context, match_list)
			if l_as.class_name /= Void then
				last_index := l_as.class_name.end_position
			end

			-- process parameters
			-- types of parameters will be treated like current
			safe_process (l_as.parameters)

			-- process rcurly symbol
			safe_process (l_as.rcurly_symbol (match_list))
		end

	process_like_cur_as (l_as: LIKE_CUR_AS) is
			-- process 'l_as'
			-- this feature is redefined in the locals printer
		do
			if l_as /= Void then
				-- get flags 'is_filter_detachable' and 'is_print_with_prefix'
				evaluate_like_current_type_flags

				-- process lcurly symbol
				safe_process (l_as.lcurly_symbol (match_list))

				-- process attachment mark
				process_attachment_mark (l_as.has_detachable_mark, l_as.attachment_mark_index, l_as.attachment_mark (match_list))

				-- process like keyword
				safe_process (l_as.like_keyword (match_list))

				-- process current keyword
				safe_process (l_as.current_keyword)

				-- process rcurly symbol
				safe_process (l_as.rcurly_symbol (match_list))
			end
		end

feature {NONE} -- Deferred feature implementation

	evaluate_class_type_flags (is_expanded, is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		deferred
		end

	evaluate_generic_class_type_flags (is_expanded, is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		deferred
		end

	evaluate_named_tuple_type_flags (is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		deferred
		end

	evaluate_like_current_type_flags is
			-- the flags are set dependant on the situation
		deferred
		end

	evaluate_like_id_type_flags (is_expanded, is_separate: BOOLEAN) is
			-- the flags are set dependant on the situation
		deferred
		end

feature {NONE} -- Feature implementation

	process_attachment_mark (has_detachable_mark: BOOLEAN; attachment_mark_index: INTEGER;  attachment_mark_symbol: SYMBOL_AS) is
			-- process the attachment mark
		do
			if is_filter_detachable then
				if has_detachable_mark then
					-- skip flag
					last_index := attachment_mark_index
				else
					-- process attachment mark
					safe_process (attachment_mark_symbol)
				end
			else
				-- just process attachment mark
				safe_process (attachment_mark_symbol)
			end
		end

feature {NONE} -- Implementation

	is_print_with_prefix: BOOLEAN
			-- indicates that a class name is printed with prefix 'SCOOP_SEPARATE__'
			-- is set in the 'evaluate_flags' feature

	is_filter_detachable: BOOLEAN
			-- indicates that a detachable flag should be filtered
			-- is set in the 'evaluate_flags' feature

end
