note
	description: "Summary description for {PLAN_ANNOTATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class SSAIFIER

create
	make

feature
	class_c: CLASS_C

	make (a_class: CLASS_C)
		local
			ssa_temps: SSA_TEMPS_VISITOR
			ssa_temps_printer: SSA_TEMPS_PRINTER
			ssa_typer: SSA_TYPER
			c2d: CLASS_TO_DOMAIN
			ssa_printer: SSA_PRINTER
			p: PRINTER
		do
			class_c := a_class

--			create ssa_temps.make
--			io.put_string ("SSAifier running %N")


--			ssa_temps.process (class_c.ast)

--			io.put_string (ssa_temps.replacements.count.out + " ast replacements %N")
--			io.put_string (ssa_temps.lines.count.out + " line replacements %N")

--			create ssa_temps_printer.make (class_c.ast, ssa_temps.replacements, ssa_temps.lines)
--			ssa_temps_printer.process_replaces


--			create ssa_typer.make (class_c, "foo")
--			ssa_typer.update_with_table (ssa_temps_printer.anno_replaces)
--			ssa_typer.print_env


--			create ssa_printer.make_with_replaces (class_c.ast, ssa_typer.replaces)
--			ssa_printer.process_ast_node (class_c.ast)

--			print (ssa_printer.text)
		end

	write_default_plan
		do
			write_plan_file (create {FILE_NAME}.make_from_string (class_c.name + ".plan.lisp"))
		end

	write_plan_file (file_name: FILE_NAME)
		local
			file: PLAIN_TEXT_FILE
			c2d: CLASS_TO_DOMAIN
			p: PRINTER
		do
			create file.make (file_name.string)
			create c2d.make (class_c.ast)
			create p.make

			c2d.process_ast_node (class_c.ast)
			c2d.domain.to_printer (p)

			file.create_read_write
			file.put_string (p.context)
			file.close
		end

end
