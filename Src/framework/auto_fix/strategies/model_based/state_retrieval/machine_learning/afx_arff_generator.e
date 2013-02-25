note
	description: "Summary description for {AFX_ARFF_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_ARFF_GENERATOR

inherit
	AFX_TEST_CASE_EXECUTION_EVENT_LISTENER

	AFX_SHARED_SESSION

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize.
		do
			last_file_name := Void
		end

feature -- Status report

	is_test_case_new (a_tc: EPA_TEST_CASE_INFO): BOOLEAN
			-- <Precursor>
		do
			Result := True
		end

feature -- Event handler

	on_new_test_case (a_tc: EPA_TEST_CASE_INFO)
			-- <Precursor>
		do
			-- Do nothing.
		end

	on_breakpoint_hit (a_tc: EPA_TEST_CASE_INFO; a_state: EPA_STATE; a_location: AFX_PROGRAM_LOCATION)
			-- <Precursor>
		local
			l_file_name: STRING
			l_file_path: PATH
			l_tbl: HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
		do
			create l_tbl.make (1000)
			l_tbl.compare_objects

				-- Decide the file to store `a_state'.
			l_file_name := output_file_name (a_tc, a_location.breakpoint_index)
			if last_file_name = Void or else not (last_file_name ~ l_file_name) then
				last_file_name := l_file_name
				close_output_file

				create output_file.make_with_path (output_folder.extended (l_file_name + ".arff"))
				output_file.create_read_write
				output_file.open_write
				put_header (output_file, l_file_name, a_state)
			end

				-- Store data.			
			put_data (output_file, a_location.breakpoint_index, a_state)
		end

	on_application_exit
			-- <Precursor>
		do
			close_output_file
		end

feature{NONE} -- Implementation

	put_data (a_file: PLAIN_TEXT_FILE; a_bpslot: INTEGER; a_state: EPA_STATE)
			-- Store `a_state' which is retrieved at breakpoint `a_bpslot' in `a_file'.
		local
			l_value: EPA_EXPRESSION_VALUE
			i: INTEGER
			l_count: INTEGER
			l_value_ignored: BOOLEAN
		do
			a_file.put_integer (a_bpslot)
			if not a_state.is_empty then
				a_file.put_character (',')
				from
					i := 1
					l_count := a_state.count
					a_state.start
				until
					a_state.after
				loop
					l_value_ignored := False
					l_value := a_state.item_for_iteration.value
					if l_value.is_boolean or l_value.is_integer then
						a_file.put_string (l_value.out)
					elseif l_value.is_nonsensical then
						a_file.put_character ('?')
					else
						l_value_ignored := True
						check False end
					end

					if (not l_value_ignored) and then i < l_count then
						if i < l_count then
							a_file.put_character (',')
						end
					end
					i := i + 1
					a_state.forth
				end
			end
			a_file.put_character ('%N')
			a_file.flush
		end

	put_header (a_file: PLAIN_TEXT_FILE; a_relation_name: STRING; a_state: EPA_STATE)
			-- Put header containing relation name `a_relation_name' and data declarations from `a_state'
			-- into `a_file'.
		local
			l_expr: EPA_EXPRESSION
		do
			a_file.put_string ("@RELATION " + a_relation_name + "%N")
			a_file.put_string ("@ATTRIBUTE%Tbpslot%TNUMERIC%N")
			from
				a_state.start
			until
				a_state.after
			loop
				l_expr := a_state.item_for_iteration.expression
				a_file.put_string ("@ATTRIBUTE%T")
				a_file.put_string (l_expr.text)
				a_file.put_string ("%T")
				if l_expr.type.is_boolean then
					a_file.put_string ("{True,False}")
				elseif l_expr.type.is_integer then
					a_file.put_string ("NUMERIC")
				else
					check False end
				end
				a_file.put_string ("%N")
				a_state.forth
			end
			a_file.put_string ("@DATA%N")
		end

	close_output_File
			-- Close `output_file'.
		do
			if output_file /= Void and then not output_file.is_closed then
				output_file.close
			end
		end

feature{NONE} -- Implementation

	last_file_name: detachable STRING
			-- File name for the last analyzed test case

	output_file: detachable PLAIN_TEXT_FILE
			-- File used to store output

	output_folder: PATH
			-- Folder to store all generated ARFF files.
		do
			Result := config.data_directory
		end

	output_file_name (a_tc: EPA_TEST_CASE_INFO; a_bpslot: INTEGER): STRING
			-- Name of the file used to store data retrieved breakpoint `a_bpslot' for `a_tc'.
		local
			l_bp_context_feature: EPA_FEATURE_WITH_CONTEXT_CLASS
		do
			l_bp_context_feature := exception_recipient_feature
			create Result.make (64)
			Result.append (l_bp_context_feature.context_class.name)
			Result.append (once "__")
			Result.append (l_bp_context_feature.feature_.feature_name_32)
			Result.append (once "__")
			Result.append (a_tc.id)

--			if a_tc.is_passing then
--				Result.append (once "__S")
--			else
--				Result.append (once "__F")
--			end
--			Result.append (once "__c")
--			Result.append (a_tc.exception_code.out)
--			Result.append (once "__b")
--			Result.append (a_tc.breakpoint_slot.out)
--			Result.append (once "__TAG_")
--			Result.append (a_tc.tag)
		end

end
