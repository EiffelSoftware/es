note
	description: "Construct a table which associates a syntax node with a replacement variable, target, and call."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_REPLACEMENTS_CREATOR

inherit
	AST_ROUNDTRIP_ITERATOR
		redefine
			process_nested_as,
--			process_access_feat_as,
--			process_access_id_as,
			process_bool_as,
			process_assign_as,

			process_id_as

		end

	INTERNAL_COMPILER_STRING_EXPORTER

	SHARED_SERVER

create
	make

feature
	make (a_class: CLASS_AS; a_replacements: HASH_TABLE [STRING, AST_HASHWRAP]; a_lines: LIST [AST_EIFFEL])
		do
			setup (a_class, match_list_server.item (a_class.class_id), False, False)

			replaces := a_replacements
			replaces.compare_objects

			create anno_replaces.make (20)

			lines := a_lines
			clear_target
		end

	process_replaces
		do
			from lines.start
			until lines.after
			loop

				working_ast := lines.item
				process_ast_node (working_ast)

				is_command := True
				clear_target
				lines.forth
			end
		end

	replaces: HASH_TABLE [STRING, AST_HASHWRAP]

	anno_replaces: HASH_TABLE [LIST [TUPLE [STRING, STRING, AST_EIFFEL]], AST_HASHWRAP]
	working_ast: AST_EIFFEL

	lines: LIST [AST_EIFFEL]


--	process_access_id_as (l_as: ACCESS_ID_AS)
--		do

--		end

--	process_access_feat_as (l_as: ACCESS_FEAT_AS)
--		do
--			
--		end

	is_command : BOOLEAN

	is_first_target : BOOLEAN
		do
			Result := not attached last_target
		end

	set_target (str: STRING)
		do
			last_target := str
		end

	last_target: STRING

	clear_target
		do
			last_target := Void
		ensure
			is_first_target
		end


	process_id_as (l_as: ID_AS)
		local
			repl: STRING
			target: STRING
		do
			if not is_first_target then
				target := last_target
			end

			repl := replaces [wrap (l_as)]

			if attached repl then
				assign_extend (repl, target, l_as)
				set_target (repl)
			else
				set_target (l_as.name)
			end
		end

	process_bool_as (l_as: BOOL_AS)
		do
			set_target (l_as.is_true_keyword.out)
		end

	process_assign_as (l_as: ASSIGN_AS)
		local
			temp: STRING
		do
			is_command := False

			safe_process (l_as.source)
--			assign_extend (ast_to_string (l_as.target), Void, last_target)

			is_command := True
		end

	process_nested_as (l_as: NESTED_AS)
		local
			trg: STRING
		do
			safe_process (l_as.target)

			if attached {NESTED_AS} l_as.message as nested then
				safe_process (nested)
			elseif is_command then
				assign_extend (Void, last_target, l_as.message)
			end
		end

--	process_nested_as (l_as: NESTED_AS)
--		local
--			repl: STRING
--			clear: BOOLEAN
--		do
--			if not is_first_target then
--				clear := True
--			end

--			safe_process (l_as.target)

--			if clear implies not is_command then
--				safe_process (l_as.message)
--			end

--			if clear and is_command then
--				clear_target
--			end
--		end

	assign_extend (var, target: STRING; call: AST_EIFFEL)
		local
			list: LIST [TUPLE [STRING, STRING, AST_EIFFEL]]
		do
			list := anno_replaces [wrap (working_ast)]

			if not attached list then
				create {ARRAYED_LIST [TUPLE [STRING, STRING, AST_EIFFEL]]} list.make (20)
				anno_replaces [wrap (working_ast)] := list
			end

			list.extend ([var,target,call])
		end



feature {NONE}

	ast_to_string (l_as: AST_EIFFEL): STRING
		do
			Result := l_as.text_32 (match_list)
		end

	wrap (a_ast: AST_EIFFEL): AST_HASHWRAP
		do
			create Result.make (a_ast)
		end
end
