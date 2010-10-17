note
	description: "Top-level annotation of a class' feature."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class SSAIFIER

create
	make

feature
	class_c: CLASS_C

	make (a_class: CLASS_C; a_name: STRING)
			-- Process the feature `a_name' from the class `a_class'.
		local
			ssa_printer: SSA_PRINTER
			p: PRINTER
		do
			class_c := a_class
			create ssa_printer.make_with_feature (a_class, a_name)
			ssa_printer.process
			print ("Expanded Class:%N")
			print (ssa_printer.text)
		end

	write_default_instrumented
		do
			write_instrumented_file (create {FILE_NAME}.make_from_string (class_c.name + ".plan.lisp"))
		end

	write_instrumented_file (file_name: FILE_NAME)
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
