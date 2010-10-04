note
	description: "Summary description for {SSA_PRINTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_PRINTER

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
	make_with_replaces (a_class: CLASS_AS; a_replaces: HASH_TABLE [LIST [SSA_REPLACE], AST_HASHWRAP])
		do
			make_with_default_context
			setup (a_class, match_list_server.item (a_class.class_id), True, True)
			replaces := a_replaces
		end

feature
	replaces: HASH_TABLE [LIST [SSA_REPLACE], AST_HASHWRAP]

	replace_asts (l_as: AST_EIFFEL)
		require
			has_as: replaces.has (wrap (l_as))
		local
			list: LIST [SSA_REPLACE]
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

	replace_ast (rep: SSA_REPLACE)
		do
			put_raw_string ("%N")
			insert_planning (rep)
			put_raw_string ("%N")
			insert_last_call (rep)

		end

	insert_planning (rep: SSA_REPLACE)
		do
			put_raw_string ("PLANNING")
			safe_process (rep.req)
		end

	insert_last_call (rep: SSA_REPLACE)
		do
			if not attached {VOID_A} rep.type and
			   attached rep.type and
			   attached rep.var then
				put_raw_string (rep.var)
				put_raw_string (" := ")
			end

			if attached rep.target then
				put_raw_string (rep.target + ".")
			end

			put_raw_string (rep.call)
		end

feature -- AST
	process_assign_as (l_as: ASSIGN_AS)
		do
			if replaces.has (wrap (l_as)) then
				replace_asts (l_as)
			else
				Precursor (l_as)
			end
		end

	process_id_as (l_as: ID_AS)
		do
			if replaces.has (wrap (l_as)) then
				replace_asts (l_as)
			else
				Precursor (l_as)
			end
		end

	process_access_id_as (l_as: ACCESS_ID_AS)
		do
			if replaces.has (wrap (l_as)) then
				replace_asts (l_as)
			else
				Precursor (l_as)
			end
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			if replaces.has (wrap (l_as)) then
				replace_asts (l_as)
			else
				Precursor (l_as)
			end
		end

	process_nested_as (l_as: NESTED_AS)
		do
			if replaces.has (wrap (l_as)) then
				replace_asts (l_as)
				-- last_index := l_as.last_token (match_list).index
			else
				Precursor (l_as)
			end
		end

feature
	put_raw_string (a_str: STRING)
		do
			put_string (wrap_str (a_str))
		end

	wrap_str (a_str: STRING): SSA_LEAF_STUB
		do
			create Result.make (a_str)
		end

	wrap (a_ast: AST_EIFFEL): AST_HASHWRAP
		do
			create Result.make (a_ast)
		end

end
