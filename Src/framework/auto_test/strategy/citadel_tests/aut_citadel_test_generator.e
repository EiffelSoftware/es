note
	description: "Summary description for {AUT_CITADEL_TEST_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class AUT_CITADEL_TEST_GENERATOR

inherit
--	AUT_TASK

	AUT_SHARED_TYPE_FORMATTER
		export
			{NONE} all
		end

	ERL_CONSTANTS
		export
			{NONE} all
		end

	KL_SHARED_FILE_SYSTEM
		export
			{NONE} all
		end

	KL_SHARED_STREAMS
		export
			{NONE} all
		end

	ERL_G_TYPE_ROUTINES
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_result_repo: like result_repository;
	      a_interpreter: like interpreter;
	      a_error_handler: like error_handler;
	      a_system: like system;
	      a_output_dirname: like output_dirname)
		do
			result_repository := a_result_repo
			interpreter := a_interpreter
			error_handler := a_error_handler
			system := a_system
			output_dirname := a_output_dirname
		end

feature {NONE} -- Access

	interpreter: AUT_INTERPRETER_PROXY
			-- Interpreter for system under test

	result_repository: AUT_TEST_CASE_RESULT_REPOSITORY
			-- Repository storing test case results

	error_handler: AUT_ERROR_HANDLER
			-- Error handler

	system: SYSTEM_I
			-- System under test

	output_dirname: STRING
			-- Name of output directory

	cursor: DS_LINEAR_CURSOR [AUT_WITNESS]
			-- Cursor for the test case witnesses


feature {NONE}

	last_witness: AUT_WITNESS
			-- Last witness minimized

	printer: AUT_CITADEL_TEST_CASE_PRINTER
			-- Printer that outputs the test cases for CITADEL

	output_file: KL_TEXT_OUTPUT_FILE
			-- File where the test cases for CITADEL will be printed

feature -- Basic operations

	generate_tests (class_names: DS_LIST [STRING_8])
			-- <Precursor>
		local
			l_dir: KL_DIRECTORY
		do
			interpreter.set_is_logging_enabled (False)
			interpreter.set_is_in_replay_mode (False)
			create printer.make_null (system)
			create l_dir.make (file_system.nested_pathname (output_dirname, <<"citadel">>))
			if not l_dir.exists then
				l_dir.create_directory
			end
			create output_file.make (file_system.nested_pathname (output_dirname, <<"citadel", "citadel_test_case.e" >>))
			output_file.open_write
			if output_file.is_open_write then
				printer.set_output_stream (output_file)
				printer.print_class_header
				printer.set_output_stream (null_output_stream)
				output_file.close
			else
				error_handler.report_cannot_read_error (output_file.name)
			end
			from
				cursor := result_repository.witnesses.new_cursor
				cursor.start
			until
				cursor.after
			loop
				last_witness := cursor.item
				print_citadel_test_case (last_witness)
				cursor.forth
			end
			output_file.open_append
			if output_file.is_open_write then
				printer.set_output_stream (output_file)
				printer.print_root_creation_procedure
				printer.print_class_footer
				printer.set_output_stream (null_output_stream)
				output_file.close
				generate_flag_class
				save_class_names (class_names)
			else
				error_handler.report_cannot_read_error (output_file.name)
			end
		end


feature {NONE} -- Implementation

	print_citadel_test_case (a_witness: AUT_WITNESS)
			-- Print a test case for CITADEL out of witness `a_witness' to file `output_file'.
		do
			output_file.open_append
			if output_file.is_open_write then
				printer.set_output_stream (output_file)
				printer.print_test_case (a_witness.request_list, all_used_vars (a_witness.request_list))
				printer.set_output_stream (null_output_stream)
				output_file.close
			else
				error_handler.report_cannot_read_error (output_file.name)
			end
		end

--	finish_slice (a_witness: AUT_WITNESS; a_name_generator: AUT_UNIQUE_NAME_GENERATOR)
--		local
--			file: KL_TEXT_OUTPUT_FILE
--			last_all_used_vars: like all_used_vars
--			sliced_witness: AUT_WITNESS
--			response_printer: AUT_RESPONSE_LOG_PRINTER
--		do
--			timer_execution.calculate_duration
--			timer_total.calculate_duration
--			create sliced_witness.make_default (slicer.last_slice)
--			create file.make (file_system.nested_pathname (output_dirname, <<"log", a_name_generator.output_string >>))
--			if sliced_witness.is_fail and then sliced_witness.is_same_bug (a_witness) then
--				last_witness := sliced_witness
--				last_all_used_vars := all_used_vars (slicer.last_slice)
--				last_witness.set_used_vars (last_all_used_vars)
--				successfully_minimized_witnesses.force_last (last_witness)
--				file.open_write
--				if file.is_open_write then
--					create response_printer.make (file)
--					printer.set_output_stream (file)
--					printer.print_test_case (a_witness.request_list, Void)
--					a_witness.item (a_witness.count).response.process (response_printer)
--					printer.print_test_case (slicer.last_slice, last_all_used_vars)
--					if sliced_witness.item (sliced_witness.count).response /= Void then
--						sliced_witness.item (sliced_witness.count).response.process (response_printer)
--					end
--					printer.set_output_stream (null_output_stream)
--					file.close
--				else
--					error_handler.report_cannot_read_error (file.name)
--				end
--			end
--			error_handler.report_benchmark_message ("slice execution time: " + timer_execution.last_duration.second_count.out + "s, " + timer_execution.last_duration.millisecond_count.out + "ms.")
--			error_handler.report_benchmark_message ("slice minimization time total: " + timer_total.last_duration.second_count.out + "s, " + timer_total.last_duration.millisecond_count.out + "ms.")
--			error_handler.report_benchmark_message ("slice fn: " + file.name)
--			error_handler.report_benchmark_message ("slice original loc: " + a_witness.count.out)
--			error_handler.report_benchmark_message ("slice minimized loc: " + last_witness.count.out)
--			error_handler.report_benchmark_message ("slice successful: " + (sliced_witness.is_fail and then a_witness.is_same_bug (sliced_witness)).out)
--		end

	all_used_vars (a_req_list: DS_LIST [AUT_REQUEST]): DS_HASH_TABLE [TUPLE [type: detachable TYPE_A; name: detachable STRING; check_dyn_type: BOOLEAN; use_void: BOOLEAN], ITP_VARIABLE]
			-- All variables used in the request list `a_req_list' with the names of their types
		require
			a_req_list_not_void: a_req_list /= Void
		local
			all_used_vars_updater: AUT_ALL_USED_VARIABLES_UPDATER
			request: AUT_REQUEST
			i: INTEGER
			l_type_name: STRING
			l_type: TYPE_A
		do
			from
				create all_used_vars_updater.make (system)
				i := 1
			until
				i > a_req_list.count
			loop
				request := a_req_list.item (i)
				request.process (all_used_vars_updater)
				i := i + 1
			end
			Result := all_used_vars_updater.variables
			from
				Result.start
			until
				Result.after
			loop
				if Result.item_for_iteration.name = Void or Result.item_for_iteration.check_dyn_type then
					if interpreter.variable_table.is_variable_defined (Result.key_for_iteration) then
						l_type := interpreter.variable_table.variable_type (Result.key_for_iteration)
						if l_type /= Void then
							l_type_name := type_name_with_context (l_type, interpreter.interpreter_root_class, Void)
						else
							interpreter.retrieve_type_of_variable (Result.key_for_iteration)
							l_type := interpreter.variable_table.variable_type (Result.key_for_iteration)
							if l_type = Void then
								l_type := none_type
								l_type_name := none_type_name
							else
								l_type_name := type_name_with_context (l_type, interpreter.interpreter_root_class, Void)
							end
						end
					else
						l_type := none_type
						l_type_name := none_type_name
					end
					if
						Result.item_for_iteration.name /= Void and
						Result.item_for_iteration.check_dyn_type and
						l_type_name.is_equal (none_type_name)
					then
						Result.force ([l_type, l_type_name, False, True], Result.key_for_iteration)
					else
						Result.force ([l_type, l_type_name, False, False], Result.key_for_iteration)
					end
				end
				Result.forth
			end
		end

	generate_flag_class
			-- Generate source code for the class containing the assertion monitoring flag for CITADEL.
		local
			l_file: KL_TEXT_OUTPUT_FILE
		do
			create l_file.make (file_system.nested_pathname (output_dirname, <<"citadel", "citadel_global.e" >>))
			l_file.open_write
			if l_file.is_open_write then
				l_file.put_string (citadel_global_class_code)
				l_file.close
			else
				error_handler.report_cannot_read_error (l_file.name)
			end
		end

	save_class_names (class_names: DS_LIST [STRING_8])
			-- Save to a file the names of the classes under test (recorded in `class_names').
		require
			class_names_not_void: class_names /= Void
		local
			l_file: KL_TEXT_OUTPUT_FILE
		do
			create l_file.make (file_system.nested_pathname (output_dirname, <<"citadel", "classes_under_test.txt" >>))
			l_file.open_write
			if l_file.is_open_write then
				from
					class_names.start
				until
					class_names.after
				loop
					l_file.put_line (class_names.item_for_iteration)
					class_names.forth
				end
				l_file.close
			else
				error_handler.report_cannot_read_error (l_file.name)
			end
		end

	citadel_global_class_code: STRING is
"class CITADEL_GLOBAL%N%
%%N%
%feature -- Flag setting%N%
%%N%
%	enable_monitoring%N%
%			-- Enable assertion monitoring in CITADEL.%N%
%		do%N%
%			is_monitoring_cell.set_item (True)%N%
%		end%N%
%%N%
%	disable_monitoring%N%
%			-- Disable assertion monitoring in CITADEL.%N%
%		do%N%
%			is_monitoring_cell.set_item (False)%N%
%		end%N%
%%N%
%	is_monitoring: BOOLEAN%N%
%			-- Is CITADEL currently monitoring assertions?%N%
%		do%N%
%			Result := is_monitoring_cell.item%N%
%		end%N%
%%N%
%feature {NONE} -- Implementation%N%
%	is_monitoring_cell: BOOLEAN_REF is%N%
%			-- Singleton instance of the monitoring flag%N%
%		once%N%
%			create Result%N%
%		end%N%
%end"


note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
