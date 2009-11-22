note
	description: "Summary description for {AFX_ARFF_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_ARFF_GENERATOR

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize.
		do
			create file_table.make (5)
			file_table.compare_objects
		end

feature -- Access

	on_test_case_start (a_tc_info: AFX_TEST_CASE_INFO)
			-- Action to perform when test case `a_tc_info' starts.
		do

		end

	on_test_case_breakpoint_hit (a_tc: AFX_TEST_CASE_INFO; a_state: AFX_STATE; a_bpslot: INTEGER)
			-- Action to perform when a breakpoint `a_bpslot' is hit in test case `a_tc'.
			-- `a_state' is the set of expressions with their evaluated values.
		local
			l_file_name: STRING
			l_file: PLAIN_TEXT_FILE
			l_file_path: FILE_NAME
		do
			l_file_name := output_file_name (a_tc, a_bpslot)
			if file_table.has (l_file_name) then
				l_file := file_table.item (l_file_name)
			else
				create l_file_path.make_from_string (output_folder)
				l_file_path.set_file_name (l_file_name + ".arff")
				create l_file.make_create_read_write (l_file_path)
				file_table.force (l_file, l_file_name)
				put_header (l_file, l_file_name, a_state)
			end
			put_data (l_file, a_state)
		end

	put_data (a_file: PLAIN_TEXT_FILE; a_state: AFX_STATE)
			-- Store `a_state' in `a_file'.
		local
			l_value: AFX_EXPRESSION_VALUE
			i: INTEGER
			l_count: INTEGER
		do
			from
				i := 1
				l_count := a_state.count
				a_state.start
			until
				a_state.after
			loop
				l_value := a_state.item_for_iteration.value
				if l_value.is_boolean then
					a_file.put_string (l_value.out)
					if i < l_count then
						a_file.put_character (',')
					end

				elseif l_value.is_nonsensical then
					a_file.put_character ('?')
					if i < l_count then
						a_file.put_character (',')
					end

				elseif l_value.is_integer then

				else
					check False end
				end
				i := i + 1
				a_state.forth
			end
			a_file.put_character ('%N')
			a_file.flush
		end

	put_header (a_file: PLAIN_TEXT_FILE; a_relation_name: STRING; a_state: AFX_STATE)
			-- Put header containing relation name `a_relation_name' and data declarations from `a_state'
			-- into `a_file'.
		local
			l_expr: AFX_EXPRESSION
		do
			a_file.put_string ("@RELATION " + a_relation_name + "%N")
			from
				a_state.start
			until
				a_state.after
			loop
				l_expr := a_state.item_for_iteration.expression
				if l_expr.type.is_boolean then
					a_file.put_string ("@ATTRIBUTE%T")
					a_file.put_string (l_expr.text)
					a_file.put_string ("%T")
					if l_expr.type.is_boolean then
						a_file.put_string ("{True,False}")
	--				elseif l_expr.type.is_integer then
	--					a_file.put_string ("NUMERIC")
					else
						check False end
					end
					a_file.put_string ("%N")
				end
				a_state.forth
			end

			a_file.put_string ("@DATA%N")
		end

	close_files
			-- Close files in `file_table'.
		do
			from
				file_table.start
			until
				file_table.after
			loop
				file_table.item_for_iteration.close
				file_table.forth
			end
		end

feature{NONE} -- Implementation

	output_folder: STRING = "/tmp"
			-- Folder to store all generated ARFF files.

	file_table: HASH_TABLE [PLAIN_TEXT_FILE, STRING]
			-- Table for output files
			-- Key is the test case info plus the breakpoint slot number.
			-- Value is the file used to store results.

	output_file_name (a_tc: AFX_TEST_CASE_INFO; a_bpslot: INTEGER): STRING
			-- Name of the file used to store data retrieved breakpoint `a_bpslot'
			-- in test case `a_tc'
		do
			create Result.make (64)
			Result.append (a_tc.recipient_class)
			Result.append (once "__")
			Result.append (a_tc.recipient)
			if a_tc.is_passing then
				Result.append (once "__S")
			else
				Result.append (once "__F")
			end
			Result.append (once "__c")
			Result.append (a_tc.exception_code.out)
			Result.append (once "__b")
			Result.append (a_tc.breakpoint_slot.out)
			Result.append (once "__TAG_")
			Result.append (a_tc.tag)
			Result.append ("__bp_")
			Result.append (a_bpslot.out)
		end

end
