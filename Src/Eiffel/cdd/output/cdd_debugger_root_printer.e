indexing
	description: "Objects that print a root class for the CDD_TEST_DEBUGGER"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_DEBUGGER_ROOT_PRINTER

inherit

	CDD_ROOT_PRINTER

feature -- Access

	print_root_class (a_tc: CDD_TEST_CASE; an_old_root_class: STRING; a_file: like output_file) is
			-- Print root class for testing 'a_test_suite'.
		require
			a_tc_valid: a_tc /= Void
			old_root_class_valid: an_old_root_class /= Void and then not an_old_root_class.is_empty
			a_file_valid: a_file /= Void and then a_file.is_open_write
		do
			output_file := a_file
			append_class_header (debugger_root_class_name)
			append_text ("%Tmake is%N%T%Tlocal%N")
			append_instruction ("l_old_root_class: " + an_old_root_class)
			append_text ("%T%Tdo%N")
			append_instruction ("l_old_root_class := Void")
			append_instruction ("%Trun_test (create {" + a_tc.tester_class.name + "})")
			append_text ("%T%Tend%N%N")
			append_class_footer (debugger_root_class_name)
			output_file.flush
			output_file := Void
		end

end
