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

	replaces: HASH_TABLE [LIST [SSA_REPLACE], AST_HASHWRAP]
	working_replace_list: ARRAYED_LIST [SSA_REPLACE]

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

	update_with_table (table: HASH_TABLE [LIST [TUPLE [STRING, STRING, STRING]], AST_HASHWRAP])
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

	update_with_list (assign_list: LIST [TUPLE [STRING, STRING, STRING]])
		local
			assgn: TUPLE [var: STRING; target: STRING; call: STRING]
		do
			from assign_list.start
			until assign_list.after
			loop
				assgn := assign_list.item
				update_env (assgn.var, assgn.target, assgn.call)
				extend_replace_list (assgn.var, assgn.target, assgn.call)

				assign_list.forth
			end
		end

	update_env (var, target, call: STRING)
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
				feat := get_type (simple_env [target]).associated_class.feature_named_32 (call)
				type := feat.type

				if attached feat.body.body.as_routine as rout then
					req := rout.precondition
				else
					req := Void
				end
			else
				if not simple_env.has (call) then
					if attached call then
						text_to_type := call
					else
						text_to_type := var
					end

					create epa_expr.make_with_text (class_, feat_, text_to_type, class_)
					type := epa_expr.type

					if attached class_.feature_named_32 (text_to_type) as f then
						if attached f.body.body.as_routine as rout then
							req := rout.precondition
						end
					end
				else
					type := get_type (simple_env [call])
				end
			end
			simple_env [var] := [req, type]
		end

	extend_replace_list (var, target, call: STRING)
		require
			attached var
		local
			tup: TUPLE [req: REQUIRE_AS; typ: TYPE_A]
			repl: SSA_REPLACE
		do
			tup := simple_env [var]

			create repl.make (tup.typ, var, target, call, tup.req)

			working_replace_list.extend (repl)
		end

	get_type (tup: TUPLE [REQUIRE_AS, TYPE_A]) : TYPE_A
		do
			Result ?= tup.at (2)
		end

end
