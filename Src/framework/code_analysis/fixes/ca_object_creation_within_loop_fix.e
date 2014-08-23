note
	description: "Fixes violations of rule #68 ('Object creation within loop')."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_OBJECT_CREATION_WITHIN_LOOP_FIX

inherit
	CA_FIX
		redefine
			process_loop_as
		end

create
	make_with_loop_and_instruction

feature {NONE} -- Initialization
	make_with_loop_and_instruction (a_class: attached CLASS_C; a_loop: attached LOOP_AS; a_instr: attached CREATE_CREATION_AS)
			-- Initializes `Current' with class `a_class'. `a_loop' is the loop containing the creation instruction `a_instr'.
		do
			make (ca_names.object_creation_within_loop_fix, a_class)
			loop_to_change := a_loop
			instruction_to_move := a_instr
		end

feature {NONE} -- Implementation

	loop_to_change: LOOP_AS
		-- The loop to remove the creation instruction from.

	instruction_to_move: CREATE_CREATION_AS
		-- The creation instruction to be moved.

feature {NONE} -- Visitor

	process_loop_as (a_loop: LOOP_AS)
		local
			l_body: EIFFEL_LIST[INSTRUCTION_AS]
			l_new_loop: LOOP_AS
			l_printer: CA_PRETTY_PRINTER
			l_new_string: STRING_32
			l_indent: STRING_32
		do
			if a_loop.is_equivalent (loop_to_change) then
				l_body := a_loop.compound

				l_new_string := a_loop.text_32 (matchlist)

				-- Calculate the indentation of the loop. TODO Refactor.
				l_new_string := l_new_string.substring (l_new_string.substring_index (l_body.last.text_32 (matchlist), 1), l_new_string.count - 3)
				l_indent := l_new_string.substring (l_new_string.index_of ('%T', 1), l_new_string.count)

				create l_new_string.make_empty
				l_new_string.append (instruction_to_move.text_32 (matchlist) + "%N")
				instruction_to_move.replace_text ("", matchlist)
				l_new_string.append (l_indent + a_loop.text_32 (matchlist) + "%N")
				a_loop.replace_text (l_new_string, matchlist)
			end
		end

end
