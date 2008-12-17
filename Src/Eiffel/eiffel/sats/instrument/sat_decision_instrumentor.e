indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_DECISION_INSTRUMENTOR

inherit
	SAT_INSTRUMENTOR
		redefine
			config_sections,
			process_if_b,
			process_inspect_b,
			process_elsif_b
		end

	SHARED_WORKBENCH

	PROJECT_CONTEXT

	SAT_SHARED_INSTRUMENTATION

create
	make

feature{NONE} -- Initialization

	make is
			-- Initialize.
		do
				-- Initialize `config_sections'.
			create {LINKED_LIST [STRING]} config_sections.make
			config_sections.extend (dcs_section_name)
			config_sections.extend (setting_section_name)
			create branch_index_stack.make
			create current_branch_indexes.make
			create processed_feature_table.make (50)
		end

feature -- Status report

	is_instrument_enabled: BOOLEAN is
			-- Should instrumentation be generated?
		do
			Result :=
				config.there_exists (agent {SAT_INSTRUMENT_CONFIG}.is_instrument_enabled (context)) and then
				not is_auto_test_compiling
		end

feature -- Access

	summary: STRING is
			-- Summary of current instrument status
		do
			create Result.make (64)
				-- Log slot count.
			Result.append (dcs_slot_count_name)
			Result.append_character ('=')
			Result.append (slot_index.out)
			Result.append_character ('%T')

				-- Log branch count.
			Result.append (dcs_branch_count_name)
			Result.append_character ('=')
			Result.append ((branch_index - 1).out)
		end

feature -- Data clearing

	reset is
			-- Reset
		do
			slot_index := 0
			local_slot_index := 0
			branch_index := 1
			config.wipe_out
			branch_index_stack.wipe_out
			current_branch_indexes.wipe_out
			max_slot_index := 0
			max_branch_index := 1
		ensure then
			slot_number_is_zero: slot_index = 0
			local_slot_index_is_zero: local_slot_index = 0
			decision_index_is_zero: branch_index = 1
			branch_index_stack_is_empty: branch_index_stack.is_empty
			current_branch_indexes_is_empty: current_branch_indexes.is_empty
		end

	clear_feature_data is
			-- Clear data related to currently processing feature.
		do
			local_slot_index := 0
			if slot_index > max_slot_index then
				max_slot_index := slot_index
			end
			if branch_index > max_branch_index then
				max_branch_index := branch_index
			end
		ensure then
			local_slot_index_is_zero: local_slot_index = 0
		end

feature -- Byte node processing

	process_rescue_entry is
			-- Process when a rescue clause is entered.
		do
			is_rescue_entry_slot := True
			generate_instrument_for_feature_entry_or_rescue
			is_rescue_entry_slot := False
		end

	max_slot_index: INTEGER

	max_branch_index: INTEGER

	processed_feature_table: HASH_TABLE [HASH_TABLE [TUPLE [a_slot_id: INTEGER; a_branch_id: INTEGER], STRING], CLASS_C]
			-- Table of features that are already processed.
			-- The key of the outer hash table is class name, and the value in the hash set is
			-- The key of the inner hash table is feature name, and the value of the inner hash table
			-- is the starting slot index and branch index when that feature was processed for the first time
			-- because the same slot index and brnach index are used for all generic derivation versions of the same feature.

	is_feature_processed (a_class: CLASS_C; a_feature: FEATURE_I): BOOLEAN is
			-- Is `a_feature' in `a_class' already processed?
		require
			a_class_attached: a_class /= Void
			a_feature_attached: a_feature /= Void
		local
			l_feat_table: HASH_TABLE [TUPLE [a_slot_id: INTEGER; a_branch_id: INTEGER], STRING]
		do
			l_feat_table := processed_feature_table.item (a_class)
			if l_feat_table /= Void then
				Result := l_feat_table.item (a_feature.feature_name.as_lower) /= Void
			end
		end

	mark_feature_as_processed (a_class: CLASS_C; a_feature: FEATURE_I; a_start_slot_index: INTEGER; a_start_branch_index: INTEGER) is
			-- Mark `a_feature' in `a_class' as processed.
		require
			a_class_attached: a_class /= Void
			a_feature_attached: a_feature /= Void
			a_start_slot_index_non_negative: a_start_slot_index >= 0
			a_start_branch_index_positive: a_start_branch_index > 0
		local
			l_feat_table: HASH_TABLE [TUPLE [a_slot_id: INTEGER; a_branch_id: INTEGER], STRING]
		do
			l_feat_table := processed_feature_table.item (a_class)
			if l_feat_table = Void then
				create l_feat_table.make (20)
				processed_feature_table.force (l_feat_table, a_class)
			end

			l_feat_table.force ([a_start_slot_index, a_start_branch_index], a_feature.feature_name.as_lower)
		ensure
			feature_marked_as_processed: is_feature_processed (a_class, a_feature)
		end

	is_current_feature_processed: BOOLEAN
			-- Is Current feature processed?

	process_feature_entry is
			-- Process when a feature is entered.
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_indexes: TUPLE [a_slot_id: INTEGER; a_branch_id: INTEGER]
		do
			l_class := context.associated_class
			l_feature := context.current_feature
			is_current_feature_processed := is_feature_processed (l_class, l_feature)

				-- Current feature has already been processed,
				-- it is another generic derivation.			
			if is_current_feature_processed then
				l_indexes := processed_feature_table.item (l_class).item (l_feature.feature_name.as_lower)
				slot_index := l_indexes.a_slot_id
				branch_index := l_indexes.a_branch_id
			else
				slot_index := max_slot_index
				branch_index := max_branch_index
				mark_feature_as_processed (l_class, l_feature, slot_index, branch_index)
			end
			is_feature_entry_slot := True
			generate_instrument_for_feature_entry_or_rescue
			is_feature_entry_slot := False
		end

	process_if_b (a_node: IF_B) is
			-- Process `a_node'.
		do
			if is_instrument_enabled then
				branch_index_stack.extend (create {LINKED_LIST [INTEGER]}.make)
			end
		end

	process_if_b_end (a_node: IF_B) is
			-- Process after an entire "if" statement.
		do
			if is_instrument_enabled then
				branch_index_stack.remove
			end
		end

	process_then_part_condition_start (a_expr: EXPR_B) is
			-- Process before the evaluation of the condition `a_expr' of some `Then_part' from Conditional instruction.
		do
		end

	process_then_part_condition_end (a_expr: EXPR_B) is
			-- Process after the evaluation of the condition `a_expr' of some `Then_part' from Conditional instruction.
		do
		end

	process_elsif_b (a_node: ELSIF_B) is
			-- Process `a_node'.
		do
			if is_instrument_enabled then
				process_then_part_start
			end
		end

	process_then_part_start is
			-- Process at the beginning of a "Then_part" from a Conditional.
		do
--			generate_instrument			
			generate_instrument_for_true_branch
		end

	process_then_part_end is
			-- Process at the end of a "Then_part" from a Conditional.
		do
		end

	process_if_else_part_start is
			-- Process at the beginning of a "Else_part" from a Conditional.
		do
--			generate_instrument
			generate_instrument_for_false_branch
		end

	process_if_else_part_end is
			-- Process at the end of a "Else_part" from a Conditional.
		do
		end

	process_when_part_start is
			-- Process at the beginning of a "When_part" from a Multi_branch instruction.
		do
--			generate_instrument
			generate_instrument_for_true_branch
		end

	process_when_part_end is
			-- Process at the end of a "When_part" from a Multi_branch_instruction.
		do
		end

	process_inspect_else_part_start is
			-- Process at the beginning of a "Else_part" from a Multi_branch_instruction.
		do
--			generate_instrument
			generate_instrument_for_false_branch
		end

	process_inspect_else_part_end is
			-- Process at the end of a "Else_part" from a Multi_branch_instruction.
		do
		end

	process_from_part_start is
			-- Process at the beginning of a "Initialization" part from Loop instruction.
		do
		end

	process_from_part_end is
			-- Process at the end of a "Initialization" part from Loop instruction.
		do
			if is_instrument_enabled then
				branch_index_stack.extend (create {LINKED_LIST [INTEGER]}.make)
			end
		end

	process_loop_body_part_start is
			-- Process at the beginning of a "Loop_body" part from Loop instruction.
		do
--			generate_instrument
			generate_instrument_for_true_branch
		end

	process_loop_body_part_end is
			-- Process at the end of a "Loop_body" part from Loop instruction.
		do
		end

	process_loop_b_end (a_node: LOOP_B) is
			-- Process after all code of `a_node' has been generated.
		do
--			generate_instrument			
			if is_instrument_enabled then
				generate_instrument_for_false_branch
				branch_index_stack.remove
			end

		end

	process_loop_stop_condition_start (a_expr: EXPR_B) is
			-- Process beofre evaluating the stop condition `a_expr' of a loop.
		do
		end

	process_loop_stop_condition_end (a_expr: EXPR_B) is
			-- Process after evaluating the stop condition `a_expr' of a loop.
		do
		end

	process_inspect_b (a_node: INSPECT_B) is
			-- Process `a_node'.
		do
			if is_instrument_enabled then
				branch_index_stack.extend (create {LINKED_LIST [INTEGER]}.make)
			end
		end

	process_inspect_end (a_node: INSPECT_B) is
			-- Process when finishing `a_node'.
		do
			if is_instrument_enabled then
				branch_index_stack.remove
			end
		end

	process_declaration is
			-- Process for possible function or variable declaration.
		do
			context.buffer.put_new_line
			context.buffer.put_string ("extern EIF_INTEGER sat_dcs_slot_count;")
			context.buffer.put_new_line
			context.buffer.put_string ("extern EIF_BOOLEAN sat_dcs_is_enabled;")
			context.buffer.put_new_line
		end

	process_initialization is
			-- Process for possible C code generation for current instrument strategy.
		do
			context.buffer.put_new_line
			context.buffer.put_string ("sat_dcs_slot_count = " + slot_index.out + ";")
			context.buffer.put_new_line
			context.buffer.put_string ("sat_dcs_is_enabled = EIF_TRUE;")
			context.buffer.put_new_line
		end

	process_header_file_initialization is
			-- Process for possible needed C header files
		do
			context.buffer.put_new_line
			context.buffer.put_string ("#include %"eif_main.h%"")
			context.buffer.put_new_line
		end

feature{NONE} -- Implementation

	generate_slot_hook (a_slot_index: INTEGER) is
			-- Generate branch hook for `a_slot_index'.
		local
			l_buffer: GENERATION_BUFFER
		do
			l_buffer := context.buffer
			l_buffer.indent
			l_buffer.put_new_line
			l_buffer.put_string (branch_hook_l_paran)
			l_buffer.put_string (a_slot_index.out)
			l_buffer.put_string (");")
			l_buffer.exdent
			l_buffer.put_new_line
		end

feature{NONE} -- Implementation

	branch_hook_l_paran: STRING is "SATDCS("

	branch_index: INTEGER
			-- 1-based index for branches
			-- feature entry and rescue clause entry counts for one branch,
			-- A conditional (conditional in if, elseif, inspect when, loop stop condition) counts for two branches.
			-- This index increases over different classes.

	slot_index: INTEGER
			-- 0-based slot number for branches, used to locate the position of a particular covered branch in source code.			
			-- It is 0-based because the C array used in run-time is 0-based.
			-- This index increases over different classes.

	local_slot_index: INTEGER
			-- 0-based slot for a feature
			-- For every feature, this index starts from zero.

	increase_decision_index is
			-- Increase `slot_index' by one.
		do
			slot_index := slot_index + 1
			local_slot_index := local_slot_index + 1
		ensure
			slot_index_increased: slot_index = old slot_index + 1
			local_slot_index_increased: local_slot_index = old local_slot_index + 1
		end

	increase_branch_index_by (a_number: INTEGER) is
			-- Increase `branch_index' by `a_number'.
		require
			a_number_positive: a_number > 0
		do
			branch_index := branch_index + a_number
		ensure
			branch_index_increased: branch_index = old branch_index + a_number
		end

	implicit_branch_indexes: LINKED_LIST [INTEGER] is
			-- Indexes of implicit covered branches
			-- If no implicit branch is found, return an empty list.
			-- For example, when a branch of an "elseif" part is covered,
			-- all the False branches of the previous "then" part are implicitly covered also.			
		local
			l_branches: LINKED_LIST [INTEGER]
		do
			check not branch_index_stack.is_empty end
			create Result.make
			from
				l_branches := branch_index_stack.item
				l_branches.start
			until
				l_branches.after
			loop
					-- We increase the index by 1 because it is the False branch of the corresponding
					-- branch which is been implicitly covered.
				Result.extend (l_branches.item + 1)
				l_branches.forth
			end
		ensure
			result_attached: Result /= Void
		end

	is_feature_entry_slot: BOOLEAN
			-- Is current slot a feature entry slot?

	is_rescue_entry_slot: BOOLEAN
			-- Is current slot a rescue clause entry slot?

	store_map_entry is
			-- Generate map information for mapping from branch slot number to class and feature.
		local
			l_buffer: STRING
			l_cnt: INTEGER
			l_indexes: like current_branch_indexes
		do
			if not is_current_feature_processed then
				create l_buffer.make (128)
				l_buffer.append (dcs_section_name)
				l_buffer.append_character ('%T')

					-- Log current class and feature.
				l_buffer.append (location_name)
				l_buffer.append_character ('=')
				l_buffer.append (context.associated_class.name_in_upper)
				l_buffer.append_character ('.')
				l_buffer.append (context.current_feature.feature_name)
				l_buffer.append_character ('%T')

					-- Log current slot index.
				l_buffer.append (slot_id_name)
				l_buffer.append_character ('=')
				l_buffer.append (slot_index.out)
				l_buffer.append_character ('%T')

					-- Log current local slot index.
				l_buffer.append (local_slot_id_name)
				l_buffer.append_character ('=')
				l_buffer.append (local_slot_index.out)
				l_buffer.append_character ('%T')

					-- Log branch index set corresponding to current slot index.
				l_buffer.append (dcs_branch_id_set)
				l_buffer.append_character ('=')
				from
					l_indexes := current_branch_indexes
					l_cnt := l_indexes.count
					l_indexes.start
				until
					l_indexes.after
				loop
					l_buffer.append (l_indexes.item.out)
					if l_indexes.index < l_cnt then
						l_buffer.append_character (',')
					end
					l_indexes.forth
				end

					-- Log feature entry property
				if is_feature_entry_slot then
					l_buffer.append_character ('%T')
					l_buffer.append (is_feature_entry_name)
					l_buffer.append_character ('=')
					l_buffer.append ("true")
				end

					-- Log rescue entry property
				if is_rescue_entry_slot then
					l_buffer.append_character ('%T')
					l_buffer.append (is_rescue_entry_name)
					l_buffer.append_character ('=')
					l_buffer.append ("true")
				end

				l_buffer.append_character ('%N')
				log_string_in_map_file (l_buffer)
			end
		end

	generate_instrument is
			-- Generate next branch slot instrument.
		do
			if is_instrument_enabled then
				generate_slot_hook (slot_index)
				store_map_entry
				increase_decision_index
			end
		end

	generate_instrument_for_feature_entry_or_rescue is
			-- Generate instrumentation for feature entry or rescue clause entry.
		do
			if is_instrument_enabled then
				current_branch_indexes.wipe_out
				current_branch_indexes.extend (branch_index)
				generate_instrument
				increase_branch_index_by (1)
			end
		end

	generate_instrument_for_true_branch is
			-- Generate instrumentation for True branches.
			-- True branches include "Then_part", "When_part", and "Loop" part.
		do
			if is_instrument_enabled then
				current_branch_indexes.wipe_out
				current_branch_indexes.append (implicit_branch_indexes)
				branch_index_stack.item.extend (branch_index)
				current_branch_indexes.extend (branch_index)
				generate_instrument
				increase_branch_index_by (2)
			end
		end

	generate_instrument_for_false_branch is
			-- Generate instrumentation for False branches.
			-- True branches include "Else_part", "Loop end".
		do
			if is_instrument_enabled then
				current_branch_indexes.wipe_out
				current_branch_indexes.append (implicit_branch_indexes)
				generate_instrument
			end
		end

feature{NONE} -- Implementation

	branch_index_stack: LINKED_STACK [LINKED_LIST [INTEGER]]
			-- Stack for branch indexes.
			-- Every element in the stack is a list of branch IDs corresponding to
			-- a branching statement.

	current_branch_indexes: LINKED_LIST [INTEGER]
			-- Branch indexes corresponding to current `slot_index'.

feature{NONE} -- Config file analysis

	config_analyzer_reset is
			-- Reset Current analyzer and prepare it for a new analysis.
		do
		end

	process_config_record (a_section_name: STRING; a_record_line: STRING) is
			-- Process record line text in `a_record_line'.
			-- This record line is in one of the section defined in `sections'.
		local
			l_slot_count: STRING
		do
			if a_section_name.is_case_insensitive_equal (dcs_section_name) then
					-- We are loading instrument config.
				config.extend (instrument_config_from_string (a_record_line))
			else
					-- We are loading instrument summary.
--				check is_auto_test_compiling end
				l_slot_count := property_table (a_record_line.split ('%T')).item (dcs_section_name)
				if l_slot_count /= Void and then l_slot_count.is_integer then
					slot_index := l_slot_count.to_integer
				end
			end
		end

	process_summary_record (a_section_name: STRING; a_record_line: STRING) is
			-- Process instrument summary line `a_record_line' in section named `a_section_name'.
		local
			l_slot_count: STRING
		do
			l_slot_count := property_table (a_record_line.split ('%T')).item (dcs_section_name.as_lower)
			if l_slot_count /= Void and then l_slot_count.is_integer then
				slot_index := l_slot_count.to_integer
			end
		end

	config_sections: LIST [STRING]
			-- List of name of sections that Current analyzer is interested in.
			-- Only data in sections contained in this list will be passed to Current analyzer.
			-- Section names are case-sensitive.

invariant
	config_sections_attached: config_sections /= Void
	branch_index_stack_attached: branch_index_stack /= Void
	current_branch_indexes_attached: current_branch_indexes /= Void

end
