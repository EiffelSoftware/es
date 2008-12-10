indexing
	description: "[
			Generated C code instrumentor
			]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SAT_INSTRUMENTOR

inherit
	SHARED_BYTE_CONTEXT

	BYTE_NODE_NULL_VISITOR
		export {ANY}all end

	SAT_SHARED_NAMES

	SAT_FILE_ANALYZER
		rename
			reset as config_analyzer_reset,
			sections as config_sections,
			process_record as process_config_record
		end

	SAT_INSTRUMENT_UTILITY

feature -- Status report

	should_generate_conditional_else_part: BOOLEAN is
			-- Should else part of a conditional always be generated?
		do
			Result := True
		end

	should_generate_inspect_else_part: BOOLEAN is
			-- Should else part of an inspect statement always be generated?
		do
			Result := True
		end

	is_instrument_enabled: BOOLEAN is
			-- Should instrumentation be generated?
		deferred
		end

feature -- Access

	config: LIST [SAT_INSTRUMENT_CONFIG] is
			-- List of configs deciding which classes/features are to be instrumented by Current instrumentor			
		do
			if config_internal = Void then
				create {LINKED_LIST [SAT_INSTRUMENT_CONFIG]} config_internal.make
			end
			Result := config_internal
		ensure
			result_attached: Result /= Void and then Result = config_internal
		end

	map_file_storage_action: PROCEDURE [ANY, TUPLE [STRING]]
			-- Action to store a string into map file

	summary: STRING is
			-- Summary of current instrument status
		deferred
		ensure
			result_attached: Result /= Void
		end

feature -- Setting

	set_map_file_storage_action (a_action: like map_file_storage_action) is
			-- Set `map_file_storage_action' with `a_action'.
		do
			map_file_storage_action := a_action
		ensure
			map_file_storage_action_set: map_file_storage_action = a_action
		end

feature -- Data clearing

	reset is
			-- Reset
		deferred
		end

	clear_feature_data is
			-- Clear data related to currently processing feature.
		deferred
		end

feature -- Basic operations

	log_string_in_map_file (a_string: STRING) is
			-- Store `a_string' in map file.
		require
			a_string_attached: a_string /= Void
		do
			if map_file_storage_action /= Void then
				map_file_storage_action.call ([a_string])
			end
		end

	process_summary_record (a_section_name: STRING; a_record_line: STRING) is
			-- Process instrument summary line `a_record_line' in section named `a_section_name'.
		require
			a_section_name_attached: a_section_name /= Void
			not_a_section_name_is_empty: not a_section_name.is_empty
			a_record_line_attached: a_record_line /= Void
		deferred
		end

feature -- Byte node processing

	process_rescue_entry is
			-- Process when a rescue clause is entered.
		deferred
		end

	process_feature_entry is
			-- Process when a feature is entered.			
		deferred
		end

	process_header_file_initialization is
			-- Process for possible needed C header files
		deferred
		end

	process_declaration is
			-- Process for possible function or variable declaration.
		deferred
		end

	process_initialization is
			-- Process for possible C code generation for current instrument strategy.
		deferred
		end

	process_then_part_condition_start (a_expr: EXPR_B) is
			-- Process before the evaluation of the condition `a_expr' of some `Then_part' from Conditional instruction.
		require
			a_expr_attached: a_expr /= Void
		deferred
		end

	process_then_part_condition_end (a_expr: EXPR_B) is
			-- Process after the evaluation of the condition `a_expr' of some `Then_part' from Conditional instruction.
		require
			a_expr_attached: a_expr /= Void
		deferred
		end

	process_then_part_start is
			-- Process at the beginning of a "Then_part" from a Conditional.
		deferred
		end

	process_then_part_end is
			-- Process at the end of a "Then_part" from a Conditional.
		deferred
		end

	process_if_else_part_start is
			-- Process at the beginning of a "Else_part" from a Conditional.
		deferred
		end

	process_if_else_part_end is
			-- Process at the end of a "Else_part" from a Conditional.
		deferred
		end

	process_if_b_end (a_node: IF_B) is
			-- Process after an entire "if" statement.
		require
			a_node_attached: a_node /= Void
		deferred
		end

	process_when_part_start is
			-- Process at the beginning of a "When_part" from a Multi_branch instruction.
		deferred
		end

	process_when_part_end is
			-- Process at the end of a "When_part" from a Multi_branch_instruction.
		deferred
		end

	process_inspect_else_part_start is
			-- Process at the beginning of a "Else_part" from a Multi_branch_instruction.
		deferred
		end

	process_inspect_else_part_end is
			-- Process at the end of a "Else_part" from a Multi_branch_instruction.
		deferred
		end

	process_from_part_start is
			-- Process at the beginning of a "Initialization" part from Loop instruction.
		deferred
		end

	process_from_part_end is
			-- Process at the end of a "Initialization" part from Loop instruction.
		deferred
		end

	process_loop_body_part_start is
			-- Process at the beginning of a "Loop_body" part from Loop instruction.
		deferred
		end

	process_loop_body_part_end is
			-- Process at the end of a "Loop_body" part from Loop instruction.
		deferred
		end

	process_loop_b_end (a_node: LOOP_B) is
			-- Process after all code of `a_node' has been generated.
		deferred
		end

	process_loop_stop_condition_start (a_expr: EXPR_B) is
			-- Process beofre evaluating the stop condition `a_expr' of a loop.
		require
			a_expr_attached: a_expr /= Void
		deferred
		end

	process_loop_stop_condition_end (a_expr: EXPR_B) is
			-- Process after evaluating the stop condition `a_expr' of a loop.
		require
			a_expr_attached: a_expr /= Void
		deferred
		end

	process_inspect_end (a_node: INSPECT_B) is
			-- Process when finishing `a_node'.
		require
			a_node_attached: a_node /= Void
		deferred
		end

feature{NONE} -- Implementation/Config

	config_internal: like config
			-- Implementation of `config'

	instrument_config_from_string (a_string: STRING): SAT_INSTRUMENT_CONFIG is
			-- Instrument config from string `a_string'
		require
			a_string_attached: a_string /= Void
		local
			l_data: like config_from_string
			l_class_config: SAT_INSTRUMENT_CLASS_CONFIG
			l_feature_config: SAT_INSTRUMENT_FEATURE_CONFIG
			l_ancestor: STRING
		do
			l_data := config_from_string (a_string)
			if l_data.a_feature_name.is_empty then
					-- We only have a class name.
				create l_class_config.make (l_data.a_class_name)
				l_ancestor := l_data.a_properties.item ("ancestor")
				l_class_config.set_is_ancestor_enabled (l_ancestor /= Void and then l_ancestor.is_case_insensitive_equal ("true"))
				Result := l_class_config
			else
					-- We have a class name and a feature name.
				create l_feature_config.make (l_data.a_class_name, l_data.a_feature_name)
				Result := l_feature_config
			end
		end

end

