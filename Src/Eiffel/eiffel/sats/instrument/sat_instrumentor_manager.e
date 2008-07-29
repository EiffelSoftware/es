indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_INSTRUMENTOR_MANAGER

inherit
	SAT_INSTRUMENTOR
		redefine
			is_instrument_enabled,
			process_if_b,
			process_case_b,
			process_inspect_b,
			process_loop_b
		end

	SAT_SHARED_INSTRUMENTATION

	PROJECT_CONTEXT

	SHARED_WORKBENCH

create
	make

feature{NONE} -- Initialization

	make is
			-- Initialize.
		do
			create {LINKED_LIST [SAT_INSTRUMENTOR]} instrumentors.make
		end

feature -- Access

	instrumentors: LIST [SAT_INSTRUMENTOR]
			-- List of registered instrumentors.

	log_file_path: STRING is
			-- Full path (including file name) of the log file
		local
			l_file_name: FILE_NAME
		do
			create l_file_name.make
			if context.final_mode then
				l_file_name.set_directory (project_location.final_path)
			else
				l_file_name.set_directory (project_location.workbench_path)
			end
			l_file_name.set_file_name ("sat_%%d.log")
			Result := l_file_name
		ensure
			result_attached: Result /= Void
		end

feature -- Status report

	instrumentor_count: INTEGER is
			-- Number of registered instrumentor.
		do
			Result := instrumentors.count
		ensure
			good_result: Result = instrumentors.count
		end

	is_instrument_enabled: BOOLEAN
			-- Should instrumentation be generated?
			-- This attribute indicates if there is at least one instrumentation should be generated.

	is_instrument_generation_enabled: BOOLEAN
			-- Is instrument generation enable?
			-- Sometimes, when byte nodes are processed, instrument should not be generated,
			-- For example, for the moment, we only generate instrumentation for workbench mode, but
			-- the same byte nodes will be processed during finalized code generation.

	has_instrumentor (a_instrumentor: SAT_INSTRUMENTOR): BOOLEAN is
			-- Is `a_instrumentor' registered in `instrumentor'?
		require
			a_instrumentor_attached: a_instrumentor /= Void
		do
			Result := instrumentors.has (a_instrumentor)
		ensure
			good_result: Result = instrumentors.has (a_instrumentor)
		end

feature -- Instrumentor registeration

	register_instrumentor (a_instrumentor: SAT_INSTRUMENTOR) is
			-- Register `a_instrumentor' into `instrumentors'.
		require
			a_instrumentor_attached: a_instrumentor /= Void
			not_a_instrumentor_registered: not has_instrumentor (a_instrumentor)
		do
			instrumentors.extend (a_instrumentor)
		ensure
			a_instrumentor_registered: has_instrumentor (a_instrumentor)
		end

	remove_instrumentor (a_instrumentor: SAT_INSTRUMENTOR) is
			-- Remove `a_instrumentor' from `instrumentors'.
		require
			a_instrumentor_attached: a_instrumentor /= Void
			a_instrumentor_registered: has_instrumentor (a_instrumentor)
		do
			instrumentors.start
			instrumentors.search (a_instrumentor)
			instrumentors.remove
		ensure
			a_instrumentor_removed: not has_instrumentor (a_instrumentor)
		end

feature -- Setting

	set_is_instrument_enabled (b: BOOLEAN) is
			-- Set `is_instrument_enabled' with `b'.
		do
			is_instrument_enabled := b
		ensure
			is_instrument_enabled_set: is_instrument_enabled = b
		end

	set_is_instrument_generate_enabled (b: BOOLEAN) is
			-- Set `is_instrument_generation_enabled' with `b'.
		do
			is_instrument_generation_enabled := b
		ensure
			is_instrument_enabled_set: is_instrument_generation_enabled = b
		end

feature -- Data clearing

	reset is
			-- Reset
		do
			instrumentors.do_all (agent (a_instrumentor: SAT_INSTRUMENTOR) do a_instrumentor.reset end)
		end

	clear_feature_data is
			-- Clear data related to currently processing feature.
		do
			instrumentors.do_all (agent (a_instrumentor: SAT_INSTRUMENTOR) do a_instrumentor.clear_feature_data end)
		end

feature -- Basic operations

	load_instrument_config_file (a_file_name: STRING) is
			-- Loaad instrument config file from `a_file_name'.
		require
			a_file_name_attached: a_file_name /= Void
		local
			l_loader: SAT_FILE_LOADER
		do
			create l_loader.make
			instrumentors.do_all (agent l_loader.register_analyzer ({SAT_INSTRUMENTOR}?))
			l_loader.reset_analyzers
			l_loader.load_file (a_file_name)
			instrumentors.do_all (agent l_loader.remove_analyzer ({SAT_INSTRUMENTOR}?))
		end

	prepare_before_generation is
			-- Prepare before instrument generation.
		local
			l_agent: PROCEDURE [ANY, TUPLE [STRING]]
			l_has_instrument: BOOLEAN
		do

				-- Check if any instrumentor is needed.			
			l_has_instrument := is_decision_coverage_enabled or is_feature_coverage_enabled
			set_is_instrument_enabled (l_has_instrument)

			if is_instrument_enabled then
					-- Create and register needed instrumentors.
					-- Setup decision coverage instrumentor
				if is_decision_coverage_enabled then
					setup_decision_coverage_instrumentor
				end

					-- Setup feature coverage instrumentor
				if is_feature_coverage_enabled then
					setup_feature_access_coverage_instrumentor
				end

				reset

					-- Load instrument config file.
				if not instrument_config_file_name.is_empty then
					load_instrument_config_file (instrument_config_file_name)
				end

					-- Setup map file storage action.
				l_agent := agent put_string_in_map_file
				instrumentors.do_all (agent {SAT_INSTRUMENTOR}.set_map_file_storage_action (l_agent))

				set_is_instrument_generate_enabled (True)
				open_map_file
			end
		end

	dispose_after_generation is
			-- Dispose after instrument generation.
		do
			if is_instrument_enabled then
				instrumentors.do_all (agent {SAT_INSTRUMENTOR}.set_map_file_storage_action (Void))
				instrumentors.do_all (agent remove_instrumentor)
				set_is_instrument_generate_enabled (False)
				close_map_file
			end
		end

feature -- Byte node processing

	process_rescue_entry is
			-- Process when a rescue clause is entered.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent {SAT_INSTRUMENTOR}.process_rescue_entry)
			end
		end

	process_if_b (a_node: IF_B) is
			-- Process `a_node'.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent a_node.process ({SAT_INSTRUMENTOR}?))
			end
		end

	process_then_part_condition_start (a_expr: EXPR_B) is
			-- Process before the evaluation of the condition `a_expr' of some `Then_part' from Conditional instruction.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent {SAT_INSTRUMENTOR}.process_then_part_condition_start (a_expr))
			end
		end

	process_then_part_condition_end (a_expr: EXPR_B) is
			-- Process after the evaluation of the condition `a_expr' of some `Then_part' from Conditional instruction.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent {SAT_INSTRUMENTOR}.process_then_part_condition_end (a_expr))
			end
		end

	process_then_part_start is
			-- Process at the beginning of a "Then_part" from a Conditional.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_then_part_start end)
			end
		end

	process_then_part_end is
			-- Process at the end of a "Then_part" from a Conditional.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_then_part_end end)
			end
		end

	process_if_else_part_start is
			-- Process at the beginning of a "Else_part" from a Conditional.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_if_else_part_start end)
			end
		end

	process_if_else_part_end is
			-- Process at the end of a "Else_part" from a Conditional.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_if_else_part_end end)
			end
		end

	process_when_part_start is
			-- Process at the beginning of a "When_part" from a Multi_branch instruction.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_when_part_start end)
			end
		end

	process_when_part_end is
			-- Process at the end of a "When_part" from a Multi_branch_instruction.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_when_part_end end)
			end
		end

	process_inspect_else_part_start is
			-- Process at the beginning of a "Else_part" from a Multi_branch_instruction.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_inspect_else_part_start end)
			end
		end

	process_inspect_else_part_end is
			-- Process at the end of a "Else_part" from a Multi_branch_instruction.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_inspect_else_part_end end)
			end
		end

	process_from_part_start is
			-- Process at the beginning of a "Initialization" part from Loop instruction.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_from_part_start end)
			end
		end

	process_from_part_end is
			-- Process at the end of a "Initialization" part from Loop instruction.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_from_part_end end)
			end
		end

	process_loop_body_part_start is
			-- Process at the beginning of a "Loop_body" part from Loop instruction.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_loop_body_part_start end)
			end
		end

	process_loop_body_part_end is
			-- Process at the end of a "Loop_body" part from Loop instruction.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent (a_ins: SAT_INSTRUMENTOR) do a_ins.process_loop_body_part_end end)
			end
		end

	process_loop_b (a_node: LOOP_B) is
			-- Process `a_node'.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent a_node.process ({SAT_INSTRUMENTOR}?))
			end
		end

	process_loop_b_end (a_node: LOOP_B) is
			-- Process after all code of `a_node' has been generated.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent {SAT_INSTRUMENTOR}.process_loop_b_end (a_node))
			end
		end

	process_loop_stop_condition_start (a_expr: EXPR_B) is
			-- Process beofre evaluating the stop condition `a_expr' of a loop.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent {SAT_INSTRUMENTOR}.process_loop_stop_condition_start (a_expr))
			end
		end

	process_loop_stop_condition_end (a_expr: EXPR_B) is
			-- Process after evaluating the stop condition `a_expr' of a loop.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent {SAT_INSTRUMENTOR}.process_loop_stop_condition_end (a_expr))
			end
		end

	process_inspect_b (a_node: INSPECT_B) is
			-- Process `a_node'.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent a_node.process ({SAT_INSTRUMENTOR}?))
			end
		end

	process_inspect_end (a_node: INSPECT_B) is
			-- Process when finishing `a_node'.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent a_node.process ({SAT_INSTRUMENTOR}?))
			end
		end

	process_case_b (a_node: CASE_B) is
			-- Process `a_node'.
		do
			if should_generate_instrument then
				instrumentors.do_all (agent a_node.process ({SAT_INSTRUMENTOR}?))
			end
		end

	process_header_file_initialization is
			-- Process for possible needed C header files
		do
			if should_generate_instrument then
				instrumentors.do_all (agent {SAT_INSTRUMENTOR}.process_header_file_initialization)
			end
		end

	process_initialization is
			-- Process for possible C code generation for current instrument strategy.
		do
			if should_generate_instrument then
				context.buffer.put_new_line
				context.buffer.put_string ("sat_has_instrument = EIF_TRUE;")
				context.buffer.put_new_line

					-- Uncomment the following two lines to enable instrumentor recording for ease of debugging.
					-- By default, recording is disabled, we only enable it when necessary. (Jason 2008.7.11)
--				context.buffer.put_string ("sat_enable_recording();")
--				context.buffer.put_new_line

				context.buffer.put_string ("sat_log_file_name = (char*)malloc(" + (log_file_path.count + 40).out + ");")
				context.buffer.put_new_line

				context.buffer.put_string ("sprintf(sat_log_file_name, ")
				context.buffer.put_string_literal (log_file_path)
				context.buffer.put_string(", sat_time());")
				context.buffer.put_new_line

				instrumentors.do_all (agent {SAT_INSTRUMENTOR}.process_initialization)
			end
		end

	process_declaration is
			-- Process for possible function or variable declaration.
		do
			if should_generate_instrument then
				context.buffer.put_new_line
				context.buffer.put_string ("extern EIF_BOOLEAN sat_has_instrument;")
				context.buffer.put_new_line

				context.buffer.put_string ("extern char* sat_log_file_name;")
				context.buffer.put_new_line

				instrumentors.do_all (agent {SAT_INSTRUMENTOR}.process_declaration)
			end
		end

	process_feature_entry is
			-- Process when a feature is entered.			
		do
			if should_generate_instrument then
				instrumentors.do_all (agent {SAT_INSTRUMENTOR}.process_feature_entry)
			end
		end

feature{NONE} -- Implementation

	should_generate_instrument: BOOLEAN is
			-- Should instrument be generated?
		do
			Result := is_instrument_enabled and then is_instrument_generation_enabled
		ensure
			good_result: Result = is_instrument_enabled and then is_instrument_generation_enabled
		end

feature{NONE} -- Config file analysis

	config_analyzer_reset is
			-- Reset Current analyzer and prepare it for a new analysis.
		do
		end

	process_config_record (a_section_name: STRING; a_record_line: STRING) is
			-- Process record line text in `a_record_line'.
			-- This record line is in one of the section defined in `sections'.
		do
			check Should_not_be_here: False end
		end

	config_sections: LIST [STRING] is
			-- List of name of sections that Current analyzer is interested in.
			-- Only data in sections contained in this list will be passed to Current analyzer.
			-- Section names are case-sensitive.
		do
			check Should_not_be_here: False end
		end

feature{NONE} -- Implmentation

	setup_decision_coverage_instrumentor is
			-- Setup instrumentor for decision coverage.
		do
			register_instrumentor (create {SAT_DECISION_INSTRUMENTOR}.make)
		end

	setup_feature_access_coverage_instrumentor is
			-- Setup instrumentor for feature access coverage.
		do
			register_instrumentor (create {SAT_FEATURE_ACCESS_INSTRUMENTOR}.make)
		end

	map_file: PLAIN_TEXT_FILE
			-- File to contain code instrument mappings

	put_string_in_map_file (a_string: STRING) is
			-- Store `a_string' into `map_file'.
		require
			a_string_attached: a_string /= Void
		do
			check map_file /= Void and then map_file.is_open_write end
			map_file.put_string (a_string)
		end

	open_map_file is
			-- Open map file.
		local
			l_file_name: FILE_NAME
		do
			if workbench.system.byte_context.final_mode then
				create l_file_name.make_from_string (system.project_location.final_path)
			else
				create l_file_name.make_from_string (system.project_location.workbench_path)
			end
			l_file_name.set_file_name (map_file_name)
			create map_file.make_create_read_write (l_file_name)
		end

	close_map_file is
			-- Close map file.
		do
			map_file.close
		end

	map_file_name: STRING is "sat_map.txt"
			-- Name of map file.

invariant
	instrumentors_attached: instrumentors /= Void

end
