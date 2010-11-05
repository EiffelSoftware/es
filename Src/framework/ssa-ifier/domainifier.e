note
	description: "Summary description for {DOMAINIFIER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DOMAINIFIER
create
	make

feature
	class_c: CLASS_C

	make (a_class: CLASS_C)
		local
			c2d: CLASS_TO_DOMAIN
			ssa_printer: SSA_FEATURE_PRINTER
			p: PRINTER
		do
			class_c := a_class
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
