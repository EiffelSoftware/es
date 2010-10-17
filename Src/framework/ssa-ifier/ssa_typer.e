note
	description: "Summary description for {SSA_TYPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_TYPER

create
	make

feature
	make (a_class: CLASS_C; feature_str: STRING)
		do
			class_ := a_class
			feat_ := class_.feature_named_32 (feature_str)

			create simple_env.make (20)
			create replaces.make (20)
		end

	class_: CLASS_C
	feat_ : FEATURE_I

	simple_env: HASH_TABLE [TUPLE [REQUIRE_AS, TYPE_A], STRING]

	replaces: HASH_TABLE [LIST [SSA_REPLACEMENT], AST_HASHWRAP]
	working_replace_list: ARRAYED_LIST [SSA_REPLACEMENT]

	print_env
		local
			t : TYPE_A
		do
			from simple_env.start
			until simple_env.after
			loop
				io.put_string (simple_env.key_for_iteration + ": ")

				t := get_type (simple_env.item_for_iteration)

				if attached t then
					io.put_string (t.name)
				else
					io.put_string ("** NO TYPE **")
				end

				io.new_line
				simple_env.forth
			end
		end

	update_with_table (table: HASH_TABLE [LIST [TUPLE [STRING, STRING, AST_EIFFEL]], AST_HASHWRAP])
		do
			from table.start
			until table.after
			loop
				create working_replace_list.make (20)

				update_with_list (table.item_for_iteration)

				replaces [table.key_for_iteration] := working_replace_list
				working_replace_list := Void

				table.forth
			end
		end

	update_with_list (assign_list: LIST [TUPLE [STRING, STRING, AST_EIFFEL]])
		local
			assgn: TUPLE [var: STRING; target: STRING; call: AST_EIFFEL]
			res: TUPLE [req: REQUIRE_AS; type: TYPE_A]
		do
			from assign_list.start
			until assign_list.after
			loop
				assgn := assign_list.item
				res := update_env (assgn.var, assgn.target, assgn.call)

				if attached assgn.var then
					add_to_simple_env (assgn.var, res.req, res.type)
				end

				extend_replace_list (assgn.var, assgn.target, assgn.call, res.req, res.type)

				assign_list.forth
			end
		end

	update_env (var, target: STRING; call: AST_EIFFEL): TUPLE [REQUIRE_AS, TYPE_A]
		require
			valid_target: attached target implies simple_env.has (target)
			has_call: attached call
		local
			epa_expr: EPA_AST_EXPRESSION
			type: TYPE_A
			feat: FEATURE_I
			req: REQUIRE_AS
			text_to_type: STRING
		do
			if attached target then
				feat := lookup_feature (get_type (simple_env [target]).associated_class, call)
				type := feat.type

				if attached feat.body.body.as_routine as rout then
					req := rout.precondition
				else
					req := Void
				end
			else
				if attached {ID_AS} call as id then
--					if attached call then
--						text_to_type := call
--					else
--						text_to_type := var
--					end

					create epa_expr.make_with_text (class_, feat_, id.name_32, class_)
					type := epa_expr.type

					if attached class_.feature_named_32 (id.name_32) as f then
						if attached f.body.body.as_routine as rout then
							req := rout.precondition
						end
					end
				else
					check False end
				end
--				if not simple_env.has (call) then
--					if attached call then
--						text_to_type := call
--					else
--						text_to_type := var
--					end

--					create epa_expr.make_with_text (class_, feat_, text_to_type, class_)
--					type := epa_expr.type

--					if attached class_.feature_named_32 (text_to_type) as f then
--						if attached f.body.body.as_routine as rout then
--							req := rout.precondition
--						end
--					end
--				else
--					type := get_type (simple_env [call])
--				end
			end
			check attached type end
--			simple_env [var] := [req, type]
			Result := [req, type]
--			add_to_simple_env (var, req, type)
		end

	lookup_feature (a_class: CLASS_C; l_as: AST_EIFFEL): FEATURE_I
		local
			fname: STRING
		do
			if attached {ACCESS_FEAT_AS} l_as as call then
				fname := call.access_name_32 -- call.text_32 (match_list)
			elseif attached {ID_AS} l_as as id then
				fname := id.name_32
			end

			Result := a_class.feature_named_32 (fname)
		end

	add_to_simple_env (var: STRING; req: REQUIRE_AS; type: TYPE_A)
		require
			some_type: attached type
		do
			simple_env [var] := [req, type]
		end

	extend_replace_list (var, target: STRING; call: AST_EIFFEL; req: REQUIRE_AS; type: TYPE_A)
		local
			repl: SSA_REPLACEMENT
		do
			create repl.make (type, var, target, call, req)
			working_replace_list.extend (repl)
		end

	get_type (tup: TUPLE [REQUIRE_AS, TYPE_A]) : TYPE_A
		do
			Result ?= tup.at (2)
		end

end
