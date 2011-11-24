note
	description: "Summary description for {AFX_STATE_TRANSITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_TRANSITOR

create
	make

feature -- Initialization

	make (a_directory: DIRECTORY)
			-- Initialization.
		require
			directory_readable: a_directory.is_readable
		do
			create model_manager.make (a_directory)
			create cached_results.make_equal (30)
		end

feature -- Access

	call_sequences: DS_ARRAYED_LIST [AFX_STATE_TRANSITION_FIX]
			-- <Precursor>

feature -- Basic operation

	construct_behavior (a_post_objects: DS_HASH_TABLE [EPA_STATE, STRING])
			-- <Precursor>	
		local
			l_object_string: STRING
			l_state_change_requirement: DS_HASH_TABLE [DS_HASH_TABLE [BOOLEAN, STRING], STRING]
			l_model: EPA_BEHAVIORAL_MODEL
		do
			l_object_string := hash_table_to_string (a_post_objects)
			if cached_results.has (l_object_string) then
				call_sequences := cached_results.item (l_object_string)
			else
				create call_sequences.make (10)
				construct_behavior_internal (a_post_objects)
				cached_results.force (call_sequences, l_object_string)
			end
		end

feature{NONE} -- Implementation

	construct_behavior_internal (a_post_objects: DS_HASH_TABLE [EPA_STATE, STRING])
			-- Construct behavior.
		local
			l_pre_expr, l_query_name: STRING
			l_state: EPA_STATE
		do
			from a_post_objects.start
			until a_post_objects.after
			loop
				l_pre_expr := a_post_objects.key_for_iteration
				l_state := a_post_objects.item_for_iteration

				transit_one_object (l_pre_expr, l_state)

				a_post_objects.forth
			end
		end

	transit_one_object (a_pre_expr: STRING; a_state: EPA_STATE)
			-- Generate transitions to change `a_pre_epxr' to `a_state'.
			-- Put the transitions into `call_sequences'.
		local
			l_model: EPA_BEHAVIORAL_MODEL
			l_table: HASH_TABLE [EPA_EXPRESSION_VALUE, STRING]
			l_requirement_table: DS_HASH_TABLE [BOOLEAN, STRING]
			l_query_name, l_command_name: STRING
			l_equation_value: EPA_EXPRESSION_VALUE
			l_value: BOOLEAN
			l_command_list: DS_ARRAYED_LIST [TUPLE [cmd_name: STRING; usefulness: REAL]]
			l_fix: AFX_STATE_TRANSITION_FIX
			l_target_str: STRING
			l_usefulness: REAL
			l_call_sequence: DS_ARRAYED_LIST [STRING]
		do
			l_model := model_manager.model_for_class (a_state.class_)
			if l_model /= Void then
					-- Generate map of desired changes.
				l_table := a_state.to_hash_table
				create l_requirement_table.make_equal (l_table.count)
				from l_table.start
				until l_table.after
				loop
					l_query_name := l_table.key_for_iteration
					l_equation_value := l_table.item_for_iteration

					if l_equation_value.is_boolean and then not l_equation_value.is_nonsensical then
						l_value := l_equation_value.is_true_boolean
						l_requirement_table.force (l_value, l_query_name)
					end

					l_table.forth
				end

					-- Usefulness of command regarding the desired changes.
				l_command_list := l_model.command_usefulnesses (l_requirement_table)

					-- Generate transition fixes.
				l_target_str := ""
				if not a_pre_expr.is_empty then
					l_target_str.append (a_pre_expr + ".")
				end

				from l_command_list.start
				until l_command_list.after
				loop
					l_command_name := l_command_list.item_for_iteration.cmd_name
					l_usefulness := l_command_list.item_for_iteration.usefulness + 0.5 -- round up

					create l_call_sequence.make (1)
					l_call_sequence.force_last (l_target_str + l_command_name)
					create l_fix.make_with_rank (l_call_sequence, 1, l_usefulness.truncated_to_integer)
					call_sequences.force_last (l_fix)

					l_command_list.forth
				end
			end
		end

	hash_table_to_string (a_table: DS_HASH_TABLE [EPA_STATE, STRING]): STRING
			-- Convert a hashtable to string.
		local
			l_string: STRING
			l_state: EPA_STATE
		do
			create Result.make (64)
			from a_table.start
			until a_table.after
			loop
				Result.append (a_table.item_for_iteration.state_report (a_table.key_for_iteration + ".") + "%N")
				a_table.forth
			end
		end

	cached_results: DS_HASH_TABLE [DS_ARRAYED_LIST [AFX_STATE_TRANSITION_FIX], STRING]
			-- Cache results for better performance on duplicated behavior construction.

	model_manager: EPA_BEHAVIORAL_MODEL_MANAGER
			-- Behavioral model manager.

end
