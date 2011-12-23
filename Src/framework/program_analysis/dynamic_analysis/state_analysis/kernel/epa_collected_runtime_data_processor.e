note
	description: "Summary description for {EPA_COLLECTED_RUNTIME_DATA_PROCESSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_COLLECTED_RUNTIME_DATA_PROCESSOR

create
	make

feature -- Initialization

	make (a_program_locations: like program_locations; a_post_state_map: like post_state_map; a_prgm_locs_with_exprs: like prgm_locs_with_exprs)
			--
		require
			a_program_locations_not_void: a_program_locations /= Void
			a_post_state_map_not_void: a_post_state_map /= Void
		do
			create collected_states.make (0)
			program_locations := a_program_locations
			post_state_map := a_post_state_map
			prgm_locs_with_exprs := a_prgm_locs_with_exprs
		ensure
			collected_states_not_void: collected_states /= Void
			program_locations_set: program_locations = a_program_locations
			post_state_map_set: post_state_map = a_post_state_map
			prgm_locs_with_exprs_set: prgm_locs_with_exprs = a_prgm_locs_with_exprs
		end

feature -- Access

	collected_states: ARRAYED_LIST [TUPLE [bp_slot: INTEGER; state: EPA_STATE]]
			--

	program_locations: DS_HASH_SET [INTEGER]
			--

	post_state_map: DS_HASH_TABLE [DS_HASH_SET [INTEGER], INTEGER]
			--

	prgm_locs_with_exprs: DS_HASH_TABLE [DS_HASH_SET [STRING], INTEGER]
			--

	last_data: DS_HASH_TABLE [LINKED_LIST [TUPLE [EPA_POSITIONED_VALUE, EPA_POSITIONED_VALUE]], STRING]
			--

	last_analysis_order: LINKED_LIST [TUPLE [INTEGER, INTEGER]]

feature {EPA_DYNAMIC_ANALYSIS_CMD} -- Process

	process (a_bp: BREAKPOINT; a_state: EPA_STATE)
			--
		require
			a_bp_not_void: a_bp /= Void
			a_state_not_void: a_state /= Void
		do
			collected_states.extend ([a_bp.breakable_line_number, a_state])
		end

feature -- Post processing

	post_process
			--
		require
			collected_states_not_void: collected_states /= Void
		local
			l_pre_state_bp_slot, l_post_state_bp_slot: INTEGER
			l_pre_state_value, l_post_state_value: EPA_POSITIONED_VALUE
			i, l_upper_bound: INTEGER
			l_pre_state_values, l_post_state_values: HASH_TABLE [EPA_EXPRESSION_VALUE, STRING]
			l_list: LINKED_LIST [TUPLE [EPA_POSITIONED_VALUE, EPA_POSITIONED_VALUE]]
			l_key, l_expr: STRING
			l_expressions: ARRAY [STRING]
		do
			-- Initialize `last_data' and `last_analysis_order' where the result of the post-processing
			-- will be made available.
			create last_data.make_default
			create last_analysis_order.make

			-- Iterate over collected states
			from
				i := 1
				l_upper_bound := collected_states.count - 1
			until
				i > l_upper_bound
			loop
				-- Fetch pre-state and post-state breakpoint slot values
				-- and check if they form a valid pre-state / post-state pair.
				l_pre_state_bp_slot := collected_states.i_th (i).bp_slot
				l_post_state_bp_slot := collected_states.i_th (i + 1).bp_slot
				if is_valid_pre_post_state_pair (l_pre_state_bp_slot, l_post_state_bp_slot) then
					last_analysis_order.extend ([l_pre_state_bp_slot, l_post_state_bp_slot])

					-- Fetch pre-state and post-state values
					l_pre_state_values := collected_states.i_th (i).state.to_hash_table
					l_post_state_values := collected_states.i_th (i + 1).state.to_hash_table

					-- Iterate over the collected expressions
					if prgm_locs_with_exprs /= Void then
						l_expressions := prgm_locs_with_exprs.item (l_pre_state_bp_slot).to_array
					else
						l_expressions := l_pre_state_values.current_keys
					end
					across l_expressions as l_exprs loop
						l_expr := l_exprs.item

						-- Check if `l_expr' appears both in the pre-state and post-state
						if l_pre_state_values.has (l_expr) and l_post_state_values.has (l_expr) then
							-- Create positioned pre-state and post-state values for `l_expr'
							create l_pre_state_value.make (l_pre_state_bp_slot, l_pre_state_values.item (l_expr))
							create l_post_state_value.make (l_post_state_bp_slot, l_post_state_values.item (l_expr))

							-- Check if the key already exists in `last_data'
							l_key := l_pre_state_bp_slot.out + ";" + l_expr
							if last_data.has (l_key) then
								l_list := last_data.item (l_key)
								l_list.extend ([l_pre_state_value, l_post_state_value])
							else
								create l_list.make
								l_list.extend ([l_pre_state_value, l_post_state_value])
								last_data.force_last (l_list, l_key)
							end
						end
					end
				end
				i := i + 1
			end
		ensure
			last_data_not_void: last_data /= Void
		end

feature {NONE} -- Implementation

	is_valid_pre_post_state_pair (a_pre_state_bp_slot: INTEGER; a_post_state_bp_slot: INTEGER): BOOLEAN
			--
		require
			program_locations_not_void: program_locations /= Void
			post_state_map_not_void: post_state_map /= Void
			valid_bp_slots: a_pre_state_bp_slot >= 1 and a_post_state_bp_slot >= 1
		do
			Result := program_locations.has (a_pre_state_bp_slot) and post_state_map.item (a_pre_state_bp_slot).has (a_post_state_bp_slot)
		end

end
