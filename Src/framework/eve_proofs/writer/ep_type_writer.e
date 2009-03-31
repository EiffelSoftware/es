indexing
	description:
		"[
			TODO
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_TYPE_WRITER

inherit

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize writer.
		do
			create output.make
		end

feature -- Access

	output: !EP_OUTPUT_BUFFER
			-- TODO

feature

	process_type (a_type: TYPE_A)
			-- Process `a_type'.
		local
			l_name, l_parent: STRING
			l_parent_type: TYPE_A
			l_class: CLASS_C
		do
			output.reset

			l_class := a_type.associated_class
			l_name := name_generator.type_name (a_type)

			output.put_comment_line ("Type declaration for " + a_type.dump)
			output.put_line ("const unique " + l_name + ": Type;")
			output.put_new_line

			output.put_comment_line ("Inheritance relations")
			from
				l_class.conforming_parents.start
			until
				l_class.conforming_parents.after
			loop
				l_parent_type := l_class.conforming_parents.item_for_iteration
				type_list.record_type_needed (l_parent_type)
				l_parent := name_generator.type_name (l_parent_type)
				output.put_line ("axiom " + l_name + " <: " + l_parent + ";")
				l_class.conforming_parents.forth
			end

			output.put_new_line

			type_list.mark_type_as_generated (a_type)

			-- TODO: add "complete" and "unique" depending on frozen classes
		end

end
