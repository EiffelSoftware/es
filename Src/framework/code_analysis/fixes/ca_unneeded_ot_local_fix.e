note
	description: "Summary description for {CA_UNNEEDED_OT_LOCAL_FIX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_UNNEEDED_OT_LOCAL_FIX

inherit
	CA_FIX
		redefine
			process_object_test_as,
			process_if_as,
			process_id_as
		end

create
	make_with_ot

feature {NONE} -- Initialization

	make_with_ot (a_class: CLASS_C; a_ot: OBJECT_TEST_AS)
		do
			make (ca_names.unneeded_ot_local_fix + a_ot.name.name_32, a_class)
			ot := a_ot
		end

feature {NONE} -- Implenentation

	ot: OBJECT_TEST_AS

	ot_local: INTEGER

	tested_expression: STRING_32

	within_ot: BOOLEAN

feature {NONE} -- Visitor

	process_object_test_as (a_ot: OBJECT_TEST_AS)
		local
			l_new_ot: like a_ot
			l_printer: CA_PRETTY_PRINTER
			l_new_string: STRING_32
		do
				-- TODO: Also change variable name within if compound.
			if ot.is_equivalent (a_ot) then
				ot_local := a_ot.name.name_id
				tested_expression := a_ot.expression.text_32 (matchlist)
					-- Let the visitor process all IDs until we have reached the end of the
					-- current if block.
				within_ot := True
					-- Getting rid of the name. Create another object test node without the
					-- object test local.
				create l_new_string.make_empty
				create l_new_ot.make (a_ot.attached_keyword (matchlist), a_ot.type, a_ot.expression, Void, Void)
				create l_printer.make (create {CA_PRETTY_PRINTER_OUTPUT_STREAM}.make_string (l_new_string), parsed_class, matchlist)
				l_printer.process_object_test_as (l_new_ot)

				a_ot.replace_text (l_new_string, matchlist)
			end
		end

	process_if_as (a_if: IF_AS)
		do
			Precursor (a_if)
				-- The object test local is now out of scope.
			within_ot := False
		end

	process_id_as (a_id: ID_AS)
		do
			if within_ot then
				if a_id.name_id = ot_local then
						-- Replace the object test local by the expression from the object test.
					a_id.replace_text (tested_expression, matchlist)
				end
			end
		end

end
