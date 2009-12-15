indexing
	description: "Summary description for {SCOOP_FEATURE_NAME_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_FEATURE_NAME_VISITOR

inherit
	SCOOP_CONTEXT_AST_PRINTER
		rename
			get_context as get_feature_name
		export
			{NONE} all
			{ANY} setup, get_feature_name
		redefine
			process_infix_prefix_as,
			process_keyword_as,
			process_feat_name_id_as,
			process_feature_name_alias_as,
			process_id_as
		end

	SCOOP_INFIX_PREFIX
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
			-- create visitor with new context
		do
			context := create {ROUNDTRIP_STRING_LIST_CONTEXT}.make
		end

feature -- Access

	process_feature_name (a_feature_name: FEATURE_NAME; l_is_with_alias: BOOLEAN) is
			-- Given a FEATURE_NAME node, try to evaluate the feature name.
		require
			a_feature_name_not_void: a_feature_name /= Void
		do
			reset_visitor (a_feature_name.first_token (match_list).index)

			-- set flag
			is_with_alias := l_is_with_alias

			-- process node
			safe_process (a_feature_name)
		end

	process_original_feature_name (a_feature_name: FEATURE_NAME; l_is_with_alias: BOOLEAN) is
			-- Given a FEATURE_NAME node, try to evaluate the feature name.
		require
			a_feature_name_not_void: a_feature_name /= Void
		do
			reset_visitor (a_feature_name.first_token (match_list).index)

			-- set flag
			is_with_alias := l_is_with_alias
			is_without_infix_replacement := true

			-- process node
			safe_process (a_feature_name)

			is_without_infix_replacement := false
		end

	process_feature_declaration_name (a_feature_name: FEATURE_NAME) is
			-- If `a_feature_name' is containing a INFIX_PREFIX_AS node,
			-- return a list consisting of the non-infix and the infix version of the name.
			-- Change this to an alias notation in EiffelStudio 6.4
		require
			a_feature_name_not_void: a_feature_name /= Void
		do
			reset_visitor (a_feature_name.first_token (match_list).index)

			-- set flag
			is_with_alias := true

			-- process it as in the original code
			is_processing_declaration := true
			safe_process (a_feature_name)
			is_processing_declaration := false

			-- add now the non-infix notation
			if has_processed_infix_prefix_node then
				context.add_string (", ")
				last_index := a_feature_name.first_token (match_list).index

				-- process it now infix notation
				safe_process (a_feature_name)
			end
		end

	process_infix_prefix (l_as: INFIX_PREFIX_AS) is
			-- Given a INFIX_PREFIX_AS node, try to evaluate the non infix notation
		require
			l_as_not_void: l_as /= Void
		do
			reset_visitor (l_as.first_token (match_list).index)

			-- process node
			safe_process (l_as)
		end

	process_infix_str (l_operator: STRING) is
			-- Prints the non-infix version of the operator
		do
			context.add_string ("infix__" + non_infix_text (l_operator))
		end

	process_prefix_str (l_operator: STRING) is
			-- Prints the non-infix version of the operator
		do
			context.add_string ("prefix__" + non_infix_text (l_operator))
		end

	process_declaration_infix_prefix (l_as: INFIX_PREFIX_AS) is
			-- Remove this feature with EiffelStudio 6.4
			-- It generates for each infix / prefix feature name a list
			-- containing the infix and non-infix notation
			-- It is only used for the parent redefine, select, undefine
			-- and export clause
		require
			l_as_not_void: l_as /= Void
		do
			reset_visitor (l_as.first_token (match_list).index)

			-- set flag
			is_with_alias := true
			is_without_infix_replacement := true

			-- process node
			safe_process (l_as)
		end

	process_id_list (l_as: IDENTIFIER_LIST; a_prefix: STRING) is
			-- Print the id feature name list with a prefix
		do
			reset_visitor (l_as.id_list.first)

			-- set some flags
			if a_prefix /= Void then
				has_prefix := true
				id_prefix := a_prefix
			end
			is_with_alias := true

			-- process id list
			process_identifier_list (l_as)
		end


feature {NONE} -- Visitor implementation

	process_keyword_as (l_as: KEYWORD_AS) is
			-- Process `l_as'.
		do
			if (l_as.is_prefix_keyword or l_as.is_infix_keyword)
				and is_without_infix_replacement then
				Precursor (l_as)
			elseif l_as.is_prefix_keyword and not is_processing_declaration then
				context.add_string ("prefix__")
			elseif l_as.is_infix_keyword and not is_processing_declaration then
				context.add_string ("infix__")
			else
				Precursor (l_as)
			end
		end

	process_feat_name_id_as (l_as: FEAT_NAME_ID_AS) is
		local
			is_sep :BOOLEAN
			i: INTEGER
		do
			-- skip frozen keyword + whitespace after it.
			if l_as.is_frozen then
				last_index := l_as.frozen_keyword.index+1
				from
					i := 1
					is_sep := true
				until
					is_sep = false
				loop
					last_index := l_as.frozen_keyword.index+i
					if match_list.i_th (last_index).is_separator then
						i := i+1
						is_sep := true
					else
						last_index := last_index-1
						is_sep := false
					end

				end
			end
			safe_process (l_as.feature_name)
		end

	process_infix_prefix_as (l_as: INFIX_PREFIX_AS) is
		do
			-- skip frozen keyword
			if l_as.is_frozen then
				last_index := l_as.infix_prefix_keyword.index - 1
			end

			safe_process (l_as.infix_prefix_keyword)

			if is_processing_declaration or is_without_infix_replacement then
				-- original version
				safe_process (l_as.alias_name)
				has_processed_infix_prefix_node := true
			else
				-- non-infix/prefix notation
				context.add_string (non_infix_text (l_as.alias_name.value))
			end
		end

	process_feature_name_alias_as (l_as: FEATURE_NAME_ALIAS_AS) is
		do
			-- skip frozen keyword
			if l_as.is_frozen then
				last_index := l_as.feature_name.index
			end

			safe_process (l_as.feature_name)
			if is_with_alias and then l_as.alias_name /= Void then
				safe_process (l_as.alias_keyword (match_list))
				safe_process (l_as.alias_name)
				if l_as.has_convert_mark then
					safe_process (l_as.convert_keyword (match_list))
				end
			end
		end

	process_id_as (l_as: ID_AS) is
		do
			process_leading_leaves (l_as.index)

			-- add a prefix
			if has_prefix then
				context.add_string (id_prefix)
			end

			-- process the id
			Precursor (l_as)
		end

feature {NONE} -- Implementation

	reset_visitor (a_start_index: INTEGER) is
			-- resets the processed attributes
		do
			-- reset context
			reset_context

			-- reset some flags
			is_with_alias := false
			has_processed_infix_prefix_node := false
			is_without_infix_replacement := false
			has_prefix := false
			id_prefix := Void

			-- set start index
			last_index := a_start_index - 1
		end

feature {NONE} -- Implementation

	is_with_alias: BOOLEAN
			-- process the actual node with or without alias name

	is_without_infix_replacement: BOOLEAN
			-- process the acutal node without replaceing infix notations

	has_prefix: BOOLEAN
			-- process the feature name with adding a prefix

	id_prefix: STRING
			-- add `id_prefix' as prefix in front of a feature name

	is_processing_declaration: BOOLEAN
			-- processes the actual node as declaration to return
			-- the infix and the non-infix version of the name.

	has_processed_infix_prefix_node: BOOLEAN
			-- indicates that on processing declaration a infix or prefix node was processed

end
