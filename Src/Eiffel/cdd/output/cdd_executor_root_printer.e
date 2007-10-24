indexing
	description: "Objects that print a root class for the CDD_TEST_EXECUTOR"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_EXECUTOR_ROOT_PRINTER

inherit

	CDD_ROOT_PRINTER

feature -- Access

	print_root_class (a_list: DS_LIST [CDD_TEST_CASE]; a_file: like output_file) is
			-- Print root class for testing 'a_test_suite'.
		require
			a_list_valid: a_list /= Void and then not a_list.is_empty
			a_file_valid: a_file /= Void and then a_file.is_open_write
		local
			l_cursor: DS_LIST_CURSOR [CDD_TEST_CASE]
		do
			output_file := a_file

			append_class_header (executor_root_class_name)
			append_text ("%Tmake is%N%T%Tlocal%N")
			append_instruction ("l_arg: STRING")
			append_text ("%T%Tdo%N")
			append_instruction ("if command_line.argument_count /= 1 then")
			append_instruction ("%Tio.put_string (%"error: exactly 1 argument required.%")")
			append_instruction ("%Tio.put_new_line")
			append_instruction ("%Tdie (-1)")
			append_instruction ("end")

			append_instruction ("l_arg := command_line.argument (1)")
			append_instruction ("if False then")
			from
				l_cursor := a_list.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				append_instruction ("elseif l_arg.is_equal (%"" + l_cursor.item.tester_class.name + "%") then")
				append_instruction ("%Trun_test (create {" + l_cursor.item.tester_class.name + "})")
				l_cursor.forth
			end
			append_instruction ("else")
			append_instruction ("%Tio.put_string (%"error: unkown test case class '%" + l_arg + %"'.%")")
			append_instruction ("%Tio.put_new_line")
			append_instruction ("%Tdie (1)")
			append_instruction ("end")
			append_text ("%T%Tend%N%N")
			append_class_footer (executor_root_class_name)

			output_file.flush
			output_file := Void
		end

feature {NONE} -- Implementation


invariant
	correct_output_file_status: output_file /= Void implies output_file.is_open_write

end
