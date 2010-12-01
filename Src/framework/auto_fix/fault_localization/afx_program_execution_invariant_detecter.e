note
	description: "Summary description for {AFX_PROGRAM_EXECUTION_INVARIANT_FINDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_EXECUTION_INVARIANT_DETECTER

inherit
	EPA_PROCESS_UTILITY

	EPA_UTILITY

	AFX_SHARED_SESSION

	AFX_PROGRAM_EXECUTION_INVARIANT_ACCESS_MODE

	AFX_SHARED_DYNAMIC_ANALYSIS_REPORT

	AFX_SHARED_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER

create
	make

feature{NONE} -- Initialization

	make
			-- Initialization.
		do

		end

feature -- Access

--	trace_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY assign set_trace_repository
--			-- Trace repository from which invariants will be inferred.

--	invariants_from_passing: DS_HASH_TABLE [EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION], DKN_PROGRAM_POINT]
--			-- Invariants inferred based on passing executions.
--		require
--			trace_repository_attached: trace_repository /= Void
--		do
--			if invariants_from_passing_cache = Void then
--				invariants_from_passing_cache := invariants_from_traces (trace_repository.passing_traces)
--			end
--			Result := invariants_from_passing_cache
--		end

--	invariants_from_failing: DS_HASH_TABLE [EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION], DKN_PROGRAM_POINT]
--			-- Invariants inferred based on failing executions.
--		require
--			trace_repository_attached: trace_repository /= Void
--		do
--			if invariants_from_failing_cache = Void then
--				invariants_from_failing_cache := invariants_from_traces (trace_repository.failing_traces)
--			end
--			Result := invariants_from_failing_cache
--		end

feature -- Basic operation

	reset_detector
			-- Reset the internal state of the object.
		do
			invariants_from_passing_cell.put (Void)
			invariants_from_failing_cell.put (Void)
		end

	detect
			-- Detect invariants based one `trace_repository'.
			-- Make the invariants available in `invariants_from_passing' and `invariants_from_failing'.
		do
			reset_detector

			invariants_from_passing_cell.put (invariants_from_traces (trace_repository.passing_traces))
			invariants_from_failing_cell.put (invariants_from_traces (trace_repository.failing_traces))
		end

--	invariants_at (a_class: CLASS_C; a_feature: FEATURE_I; a_bp_index: INTEGER; a_mode: INTEGER): EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
--			-- Invariants inferred at the breakpoint `a_bp_index' in `a_class'.`a_feature'.
--			-- `a_mode' indicates which kind of invariants to return.
--		require
--			context_attached: a_class /= Void and then a_feature /= Void
--			valid_index: a_bp_index > 0
--			valid_mode: is_valid_invariant_access_mode (a_mode)
--			trace_repository_attached: trace_repository /= Void
--		local
--			l_ppt: DKN_PROGRAM_POINT
--			l_ppt_name: STRING
--			l_invariants_from_passing, l_invariants_from_failing: DS_HASH_TABLE [EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION], DKN_PROGRAM_POINT]
--			l_invariants_p, l_invariants_f: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
--			l_invariants: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
--		do
--			l_ppt_name := a_class.name.as_upper + "." + a_feature.feature_name_32.as_lower + ":::" + a_bp_index.out
--			create l_ppt.make_with_type (l_ppt_name, {DKN_CONSTANTS}.point_program_point)

--			-- Invariants at `a_class'.`a_feature'::: `a_bp_index', from passing executions.
--			l_invariants_from_passing := invariants_from_passing
--			if l_invariants_from_passing.has (l_ppt) then
--				l_invariants_p := l_invariants_from_passing.item (l_ppt)
--			end

--			-- Invariants at `a_class'.`a_feature':::`a_bp_index', from failing executions.
--			l_invariants_from_failing := invariants_from_failing
--			if l_invariants_from_failing.has (l_ppt) then
--				l_invariants_f := l_invariants_from_failing.item (l_ppt)
--			end

--			-- Invariants.
--			inspect a_mode
--			when Invariant_passing_all then
--				l_invariants := l_invariants_p
--			when Invariant_passing_only then
--				if attached l_invariants_p and then attached l_invariants_f then
--					l_invariants := l_invariants_p.subtraction (l_invariants_f)
--				end
--			when Invariant_failing_all then
--				l_invariants := l_invariants_f
--			when Invariant_failing_only then
--				if attached l_invariants_f and then attached l_invariants_p then
--					l_invariants := l_invariants_f.subtraction (l_invariants_p)
--				end
--			end
--			Result := l_invariants

----			-- Invariants as {EPA_PROGRAM_STATE_EXPRESSIONS}.
----			create Result.make (1)
----			Result.set_equality_tester (breakpoint_unspecific_equality_tester)
----			if l_invariants /= Void then
----				Result.resize (l_invariants.count)
----				l_invariants.do_all (agent Result.force)
----			end
--		end

feature -- Status set

--	set_trace_repository (a_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY)
--			-- Set `trace_repository'.
--		require
--			repository_attached: a_repository /= Void
--		do
--			trace_repository := a_repository
--			reset_finder
--		end

--feature{NONE} -- Implementation

	invariants_from_traces (a_repository: DS_HASH_TABLE [AFX_PROGRAM_EXECUTION_TRACE, STRING]): DS_HASH_TABLE [EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION], DKN_PROGRAM_POINT]
			-- Invariants inferred based on execution traces from `a_repository'.
			-- Key: name of the program point, in the format of "class_name.feature_name@bp_index".
			-- Val: set of expressions as invariants.
		local
			l_input_file_passing, l_input_file_failing: PLAIN_TEXT_FILE
			l_declaration_file: PLAIN_TEXT_FILE
			l_trace_file: PLAIN_TEXT_FILE
			l_daikon_output: STRING
			l_parser: DKN_RESULT_PARSER
			l_invariants: DS_HASH_TABLE [DS_HASH_SET [DKN_INVARIANT], DKN_PROGRAM_POINT]
			l_concentrator: DKN_RESULT_CONCENTRATOR
			l_concentrated_results: DS_HASH_TABLE [DS_HASH_SET [EPA_AST_EXPRESSION], DKN_PROGRAM_POINT]
			l_ppt: DKN_PROGRAM_POINT
			l_ppt_name: STRING
			l_context_info: TUPLE [context_class: CLASS_C; context_feature: FEATURE_I]
			l_inv_set: DS_HASH_SET [DKN_INVARIANT]
			l_exp_set: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			l_exp_text: STRING
		do
			-- Prepare input file for Daikon.
			daikon_printer.print_trace_repository (a_repository)
			create l_declaration_file.make_create_read_write (declaration_file_name)
			l_declaration_file.put_string (daikon_printer.last_declarations.out)
			l_declaration_file.close
			create l_trace_file.make_create_read_write (trace_file_name)
			l_trace_file.put_string (daikon_printer.last_trace.out)
			l_trace_file.close

			-- Execute Daikon.
			l_daikon_output := output_from_program (daikon_command, Void)

			-- Retrieve Daikon result.
			create l_parser
			l_parser.parse_from_string (l_daikon_output, daikon_printer.last_declarations)
			l_invariants := l_parser.last_invariants

			-- Reform the Daikon result.
			create l_concentrator
			l_concentrator.set_original_results (l_invariants)
			l_concentrator.concentrate_results
			Result := l_concentrator.concentrated_results

--			create Result.make_equal (l_invariants.count)
--			from l_invariants.start
--			until l_invariants.after
--			loop
--				l_ppt := l_invariants.key_for_iteration
--				l_inv_set := l_invariants.item_for_iteration

--				l_context_info := context_info_from_program_point (l_ppt)
--				l_ppt_name := l_ppt.name

--				create l_exp_set.make (l_inv_set.count)
--				l_exp_set.set_equality_tester (Breakpoint_unspecific_equality_tester)
--				l_inv_set.do_all (
--						agent (a_inv: DKN_INVARIANT; a_class: CLASS_C; a_feature: FEATURE_I; a_exp_set: EPA_HASH_SET [EPA_PROGRAM_STATE_EXPRESSION])
--							local
--								l_exp: EPA_PROGRAM_STATE_EXPRESSION
--							do
--								create l_exp.make_with_text (a_class, a_feature, a_inv.text, a_feature.written_class, 0)
--								a_exp_set.force (l_exp)
--							end
--						(?, l_context_info.context_class, l_context_info.context_feature, l_exp_set)
--					)
--				Result.force (l_exp_set, l_ppt_name)

--				l_invariants.forth
--			end
		end

	context_info_from_program_point (a_ppt: DKN_PROGRAM_POINT): TUPLE[CLASS_C, FEATURE_I]
			-- Information about the context class and the context feature from `a_ppt'.
		local
			l_ppt_name, l_class_name, l_feature_name, l_index_text: STRING
			l_start_index, l_end_index: INTEGER
			l_class: CLASS_C
			l_feature: FEATURE_I
		do
			l_ppt_name := a_ppt.name
			l_start_index := l_ppt_name.index_of ('.', 1)
			check start_index_positive: l_start_index > 0 end
			l_class_name := l_ppt_name.substring (1, l_start_index - 1)

			l_start_index := l_start_index + 1
			l_end_index := l_ppt_name.substring_index ({DKN_CONSTANTS}.ppt_tag_separator, l_start_index)
			l_feature_name := l_ppt_name.substring (l_start_index, l_end_index - 1)

			l_index_text := l_ppt_name.substring (l_end_index + {DKN_CONSTANTS}.ppt_tag_separator.count, l_ppt_name.count)
			check valid_index: l_index_text.is_integer and then l_index_text.to_integer > 0 end

			l_class := first_class_starts_with_name (l_class_name)
			check valid_class: l_class /= Void end
			l_feature := l_class.feature_named_32 (l_feature_name)
			check valid_feature: l_feature /= Void end

			Result := [l_class, l_feature]
		end

feature{NONE} -- Implementation

	daikon_printer: AFX_PROGRAM_EXECUTION_TRACE_TO_DAIKON_PRINTER
			-- Printer that prepares the input for Daikon.
		once
			create Result.make
		end

	declaration_file_name: FILE_NAME
			-- Declaration file name for Daikon.
		do
			create Result.make_from_string (config.data_directory)
			Result.set_file_name ("daikon_input.decls")
		end

	trace_file_name: FILE_NAME
			-- Trace file name.
		do
			create Result.make_from_string (config.data_directory)
			Result.set_file_name ("daikon_input.dtrace")
		end

	daikon_command: STRING
			-- Command line option to launch daikon
		do
			create Result.make (256)
			if {PLATFORM}.is_windows then
				Result.append ("java daikon.Daikon ")
			else
				Result.append ("/usr/bin/java daikon.Daikon ")
			end
			Result.append (declaration_file_name)
			Result.append_character (' ')
			Result.append (trace_file_name)
		end

feature{NONE} -- Cache

--	invariants_from_passing_cache: like invariants_from_passing
--			-- Cache for `invariants_from_passing'.

--	invariants_from_failing_cache: like invariants_from_failing
--			-- Cache for `invariants_from_failing'.

end
