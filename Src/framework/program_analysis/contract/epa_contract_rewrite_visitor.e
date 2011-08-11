note
	description: "Summary description for {AFX_PRECONDITION_REWRITE_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_CONTRACT_REWRITE_VISITOR

inherit
	EPA_AST_PRINTER
		redefine
			process_nested_as,
			process_current_as,
			process_access_feat_as,
			append_string,
			process_parameter_list_as
		end

	INTERNAL_COMPILER_STRING_EXPORTER

	EPA_UTILITY

feature -- Access

	assertion: STRING
			-- Assertion text rewritten by the last `rewrite'

	mentioned_actual_args: HASH_TABLE [STRING, INTEGER]
			-- Actual argument expressions that are mentioned in `assertion'
			-- Key is argument index, value is the mentioned expression at that index.

feature -- Status report

	has_error: BOOLEAN
			-- Does current processing have error?

feature -- Basic operation

	rewrite (a_assertion: AST_EIFFEL; a_feature: FEATURE_I; a_written_class: CLASS_C; a_context_class: CLASS_C; a_target_prefix: STRING; a_actual_argument_table: HASH_TABLE [STRING, INTEGER])
			-- Rewrite `a_assertion' from `a_feature' in `a_written_class' in the context of `a_context_class'.
			-- Store result in `assertion'.
		do
			set_has_error (False)
			target_prefix := a_target_prefix.twin
			if not target_prefix.is_empty and then not target_prefix.ends_with (".") then
				target_prefix.append_character ('.')
			end
			actual_argument_table := a_actual_argument_table
			current_feature := a_feature
			written_class := a_written_class
			create mentioned_actual_args.make (2)
			create nested_prefix.make (32)
			create {ROUNDTRIP_STRING_LIST_CONTEXT} context.make
			a_assertion.process (Current)
			if has_error then
				assertion := ""
			else
				assertion := context.string_representation.twin
			end
		end

feature{NONE} -- Process

	process_nested_as (l_as: NESTED_AS)
		local
			l_parts: LIST [STRING]
			l_final_name: STRING
			l_previous_nested_level: INTEGER
		do
			if not has_error then
				nested_level := nested_level + 1
				l_as.target.process (Current)
				append_string (".")
				if nested_level = 1 then
						-- We finished with all the remote part in a nested expression.
					fixme ("Does not support nested expression within another nested expressions, for example: a(b.c).foo. 13.12.2009 Jasonw")
					l_parts := nested_prefix.split ('.')
					l_final_name := final_id_name (l_parts.first)
					if not has_error then
						nested_prefix.replace_substring (l_final_name, 1, l_parts.first.count)
					end
				end
				if not has_error then
					is_processing_nested_message := True
					l_as.message.process (Current)
					is_processing_nested_message := False
					nested_level := nested_level - 1
					if nested_level = 0 then
						append_string_in_context (nested_prefix)
						create nested_prefix.make (32)
					end
				end
			end
		end

	is_processing_nested_message: BOOLEAN
			-- Is currently processing message part of a nested expression?

	process_current_as (l_as: CURRENT_AS)
		do
			if not has_error then
				if is_using_nested_prefix_buffer then
					append_string ("Current")
				else
					append_string (target_prefix)
				end
			end
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local
			l_cursor: INTEGER
			l_id_name: STRING
		do
			if not has_error then
				if not is_using_nested_prefix_buffer then -- or else (nested_level = 1 and then is_processing_nested_message) then
					l_id_name := final_id_name (l_as.access_name)
					if not has_error then
						append_string_in_context (l_id_name)
					end
				else
					append_string (l_as.access_name)
				end
				if not has_error and then attached l_as.parameters as l_para then
					append_string (" (")
					from
						l_cursor := l_para.index
						l_para.start
					until
						l_para.after
					loop
						if attached l_para.item as l_item then
							l_item.process (Current)
						else
							check
								False
							end
						end
						l_para.forth
					end
					l_para.go_i_th (l_cursor)
					append_string (")")
				end
			end
		end


	process_parameter_list_as (l_as: PARAMETER_LIST_AS)
			-- Process `l_as'.
			-- NB.: No renaming for parameters.
		local
			l_cursor: CURSOR
			l_parameter: STRING
		do
			if attached l_as.parameters as l_list then
				append_string ("(")
				l_cursor := l_list.cursor
				from
					l_list.start
				until
					l_list.after
				loop
					append_string (text_from_ast (l_list.item_for_iteration))
					if l_list.index < l_list.count then
						append_string (", ")
					end
					l_list.forth
				end
				l_list.go_to (l_cursor)
				append_string (")")
			end
		end

feature{NONE} -- Implementation

	target_prefix: STRING
			-- Prefix for all unqualified calls

	actual_argument_table: HASH_TABLE [STRING, INTEGER]
			-- Table for actual arguments.
			-- Key is 1-based argument index.
			-- Value is the actual argument expression for that index.

	current_feature: FEATURE_I
			-- Feature whose AST is being processed

	written_class: CLASS_C
			-- Class where the AST being processed is written

	nested_level: INTEGER
			-- Nested level.
			-- How deep are we in a nested expression?
			-- 0 means that we are not in a nested expression.

	nested_prefix: STRING
			-- Prefix processed so far in a nested expression

	final_id_name (a_id: STRING): STRING
			-- Final name for identifier `a_id', with possible formal arguments being replaced by actual arguments,
			-- and possible target extending.
		local
			l_arg_index: INTEGER
		do
			if a_id.is_case_insensitive_equal ("Current") then
				Result := target_prefix
			else
				l_arg_index := feature_argument_index (a_id)
				if l_arg_index > 0 then
						-- `a_id' is an argument in `current_feature'.
					Result := actual_argument_table.item (l_arg_index)
					set_has_error (Result = Void)
					if not has_error then
						mentioned_actual_args.put (Result.twin, l_arg_index)
					end
				else
						-- `a_id' is a feature call, we need to prepend it with `target_prefix'.
					if target_prefix.is_empty then
						Result := a_id.twin
					else
						Result := target_prefix + a_id
					end
				end
			end
		end

	feature_argument_index (a_id: STRING): INTEGER
			-- Index of argument named `a_id' in `current_feature'.
			-- 0 means that `a_id' is not an argument.
		local
			l_args: FEAT_ARG
			i: INTEGER
		do
			fixme ("Cannot handle argument renaming for the moment. 13.12.2009 Jasonw")
			if current_feature.argument_count > 0 then
				l_args := current_feature.arguments
				from
					i := 1
				until
					i > current_feature.argument_count or else Result > 0
				loop
					if l_args.item_name (i).is_case_insensitive_equal (a_id) then
						Result := i
					end
					i := i + 1
				end
			end
		end

	is_using_nested_prefix_buffer: BOOLEAN
			-- Should nested prefix buffer be used to store string?
		do
			Result := nested_level > 0
		end

	append_string (a_str: STRING)
			-- Append `a_str' into `context'.
		do
			if is_using_nested_prefix_buffer then
				nested_prefix.append (a_str)
			else
				context.add_string (a_str)
			end
		end

	append_string_in_context (a_str: STRING)
			-- Append `a_str' into `context'.
		do
			context.add_string (a_str)
		end

	set_has_error (b: BOOLEAN)
			-- Set `has_error' with `b'.
		do
			has_error := b
		end

end
