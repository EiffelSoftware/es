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
			process_feature_as
		end

	SHARED_SERVER

create
	make_with_feature

feature

	class_: CLASS_C
	name: STRING

	make_with_feature (a_class: CLASS_C; a_name: STRING)
		do
			make_with_default_context

			class_ := a_class
			name := a_name

			setup (class_.ast, match_list_server.item (a_class.class_id), True, True)
		end

	process
		do
			safe_process (class_.ast)
		end


feature {NONE}

	process_feature_as (l_as: FEATURE_AS)
			-- Process only the selected feature.
		local
			fixer: EXPR_FIXER
			ssa_breaker: SSA_CHAIN_BREAKER
			ssa_repl: SSA_REPLACEMENTS_CREATOR
			ssa_typer: SSA_TYPER
			ssa_printer: SSA_FEATURE_PRINTER
		do
			if l_as.feature_name.name_32.is_equal (name) then
				create ssa_breaker.make

--				io.put_string ("SSAifier running %N")
				ssa_breaker.process (l_as)
--				io.put_string (ssa_temps.replacements.count.out + " ast replacements %N")
--				io.put_string (ssa_temps.lines.count.out + " line replacements %N")

				create ssa_repl.make (class_.ast, ssa_breaker.replacements, ssa_breaker.lines)
				ssa_repl.process_replaces


				create ssa_typer.make (class_, name)
				ssa_typer.update_with_table (ssa_repl.anno_replaces)
				ssa_typer.print_env


				create ssa_printer.make_with_replaces (class_, ssa_typer.replaces, name, match_list, last_index)

				ssa_printer.process_ast_node (l_as)
				context.add_string (ssa_printer.text)

				last_index := ssa_printer.last_index
			else
				Precursor (l_as)
			end
		end

end
