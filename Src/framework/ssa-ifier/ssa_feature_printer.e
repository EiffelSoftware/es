note
	description: "Used to print a feature body in SSA form."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_FEATURE_PRINTER

inherit
	AST_ROUNDTRIP_PRINTER_VISITOR
		redefine
			process_nested_as,
			process_access_feat_as,
			process_access_id_as,
			process_assign_as,

			process_id_as
--			process_keyword_as,
--			process_symbol_as,
--			process_bool_as,
--			process_char_as,
--			process_typed_char_as,
--			process_result_as,
--			process_retry_as,
--			process_unique_as,
--			process_deferred_as,
--			process_void_as,
--			process_string_as,
--			process_verbatim_string_as,
--			process_current_as,
--			process_integer_as,
--			process_real_as,
--			process_break_as,
--			process_symbol_stub_as
		end

	INTERNAL_COMPILER_STRING_EXPORTER

	SHARED_SERVER

create
	make_with_replaces

feature
	make_with_replaces (a_class: CLASS_C; a_replaces: HASH_TABLE [LIST [SSA_REPLACEMENT], AST_HASHWRAP];
	                    a_feature_name: STRING
	                    a_match_list: LEAF_AS_LIST; a_index: INTEGER)
		do
			make_with_default_context

			replaces := a_replaces
			last_index := a_index
			feature_name := a_feature_name
			class_ := a_class

			setup (class_.ast, match_list_server.item (class_.ast.class_id), True, True)

		end

feature
	class_: CLASS_C
	replaces: HASH_TABLE [LIST [SSA_REPLACEMENT], AST_HASHWRAP]

	feature_name: STRING

	replace_asts (l_as: AST_EIFFEL)
		require
			has_as: replaces.has (wrap (l_as))
		local
			list: LIST [SSA_REPLACEMENT]
		do
			list := replaces [wrap (l_as)]

			from list.start
			until list.after
			loop
				replace_ast (list.item)
				list.forth
			end
			put_raw_string ("%N")
			last_index := l_as.last_token (match_list).index + 1
		end

	replace_ast (rep: SSA_REPLACEMENT)
		do
			put_raw_string ("%N")
			insert_planning (rep)
			put_raw_string ("%N")
			insert_last_call (rep)

		end

	insert_planning (rep: SSA_REPLACEMENT)
		local
			extract_state: SSA_EXTRACT_PRECOND_STATE
		do
			create extract_state.make (class_, feature_name, rep)
			put_raw_string ("-- PLANNING")
			put_raw_string (extract_state.text)
			-- safe_process (rep.req)
		end

	insert_last_call (rep: SSA_REPLACEMENT)
		do
			if not attached {VOID_A} rep.type and
			   attached rep.type and
			   attached rep.var then
				put_raw_string (rep.var)
				put_raw_string (" := ")
			end

			if attached rep.target then
				put_raw_string (rep.target) --  + ".")
			end

			safe_process (rep.call)
		end

feature -- AST
	process_assign_as (l_as: ASSIGN_AS)
		do
			if replaces.has (wrap (l_as.source)) then
				replace_asts (l_as.source)

				put_raw_string (l_as.target.access_name)
				put_raw_string (" := ")
				put_raw_string (replaces [wrap (l_as.source)].last.var)
			else
				Precursor (l_as)
			end
		end

	process_id_as (l_as: ID_AS)
		do
			put_raw_string ("Id access%N")
			if replaces.has (wrap (l_as)) then
				replace_asts (l_as)
			else
				Precursor (l_as)
			end
		end

	process_access_id_as (l_as: ACCESS_ID_AS)
		do
			put_raw_string ("Feature access id%N")
			if replaces.has (wrap (l_as)) then
				replace_asts (l_as)
			else
				Precursor (l_as)
			end
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			put_raw_string ("Feature access%N")
			if replaces.has (wrap (l_as)) then
				replace_asts (l_as)
			else
				Precursor (l_as)
			end
		end

	process_nested_as (l_as: NESTED_AS)
		do
			put_raw_string ("Nested access%N")
			if replaces.has (wrap (l_as)) then
				replace_asts (l_as)
				-- last_index := l_as.last_token (match_list).index
			else
--				if replaces.has (wrap (l_as.target)) then
--					
--				end
				Precursor (l_as)
			end
		end

feature
	put_raw_string (a_str: STRING)
		do
			context.add_string (a_str)
		end

	wrap (a_ast: AST_EIFFEL): AST_HASHWRAP
		do
			create Result.make (a_ast)
		end

end
