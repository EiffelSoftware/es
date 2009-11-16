indexing
	description: "Summary description for {SCOOP_CONTEXT_AST_PRINTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CONTEXT_AST_PRINTER

inherit
	AST_ROUNDTRIP_ITERATOR
		redefine
			process_infix_prefix_as,
			process_keyword_as,
			process_symbol_as,
			process_bool_as,
			process_char_as,
			process_typed_char_as,
			process_result_as,
			process_retry_as,
			process_unique_as,
			process_deferred_as,
			process_void_as,
			process_string_as,
			process_verbatim_string_as,
			process_current_as,
			process_integer_as,
			process_real_as,
			process_id_as,
			process_break_as,
			process_symbol_stub_as,
			reset,
			process_none_id_as
		end
	SCOOP_WORKBENCH

feature -- Basic SCOOP changes

	process_infix_prefix_as (l_as: INFIX_PREFIX_AS) is
		local
			l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
		do
			l_feature_name_visitor := scoop_visitor_factory.new_feature_name_visitor
			last_index := l_as.start_position - 1

			-- process INFIX_PREFIX_AS node
			if l_as.frozen_keyword.index > 0 then
				safe_process (l_as.frozen_keyword)
			else
				process_leading_leaves (l_as.infix_prefix_keyword.index)
			end
			l_feature_name_visitor.process_infix_prefix (l_as)
			context.add_string (" " + l_feature_name_visitor.get_feature_name)
			last_index := l_as.alias_name.index
		end

feature -- Roundtrip: printing

	process_break_as (l_as: BREAK_AS) is
			-- Process `l_as'.
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_keyword_as (l_as: KEYWORD_AS) is
			-- Process `l_as'.
		do
			if l_as.is_separate_keyword then
				-- skip
				Precursor (l_as)
			else
				Precursor (l_as)
				put_string (l_as)
			end
		end

	process_symbol_as (l_as: SYMBOL_AS) is
			-- Process `l_as'.
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_symbol_stub_as (l_as: SYMBOL_STUB_AS) is
			-- Process `l_as'.
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_bool_as (l_as: BOOL_AS) is
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_char_as (l_as: CHAR_AS) is
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_typed_char_as (l_as: TYPED_CHAR_AS) is
			-- Process `l_as'.
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_result_as (l_as: RESULT_AS) is
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_retry_as (l_as: RETRY_AS) is
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_unique_as (l_as: UNIQUE_AS) is
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_deferred_as (l_as: DEFERRED_AS) is
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_void_as (l_as: VOID_AS) is
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_string_as (l_as: STRING_AS) is
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_verbatim_string_as (l_as: VERBATIM_STRING_AS) is
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_current_as (l_as: CURRENT_AS) is
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_integer_as (l_as: INTEGER_AS) is
		do
			Precursor (l_as)
			context.add_string (l_as.number_text (match_list))
		end

	process_real_as (l_as: REAL_AS) is
		do
			Precursor (l_as)
			context.add_string (l_as.number_text (match_list))
		end

	process_id_as (l_as: ID_AS) is
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_none_id_as (l_as: NONE_ID_AS) is
			-- Process `l_as'.
		do
			Precursor (l_as)
			context.add_string ("NONE")
		end

feature -- Context setting and getting

	reset is
			-- Reset visitor for a next visit.
		do
			Precursor
			context.clear
		end

	reset_context is
			-- Reset only context
		do
			context.clear
		end

	set_context (a_ctxt: ROUNDTRIP_CONTEXT) is
			-- Set `context' with `a_ctxt'.
		require
			a_ctxt_not_void: a_ctxt /= Void
		do
			context := a_ctxt
		ensure
			context_set: context = a_ctxt
		end

	get_context: STRING is
			-- Get `context'.
		do
			Result := context.string_representation
		end

feature{NONE} -- Context handling

	context: ROUNDTRIP_CONTEXT
			-- Context used to store generated code

	put_string (l_as: LEAF_AS) is
			-- Print text contained in `l_as' into `context'.
		require
			l_as_in_list: l_as.index >= start_index and then l_as.index <= end_index
		do
			context.add_string (l_as.text (match_list))
		end

feature -- Debug

	safe_process_debug (l_as: AST_EIFFEL): ROUNDTRIP_CONTEXT is
			-- process the ast in a testing context
		local
			original_context: ROUNDTRIP_CONTEXT
			l_last_index: INTEGER
		do
				-- create testing context
			original_context := context
			l_last_index := last_index
			context := create {ROUNDTRIP_STRING_LIST_CONTEXT}.make

				-- process the node
			last_index := l_as.start_position - 1
			safe_process (l_as)

				-- set original context
			Result := context
			last_index := l_last_index
			context := original_context
		end

invariant
	context_not_void: context /= Void

end
