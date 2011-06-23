note
	description: "Records and evaluates statement paths to find first common level of target variable occurrence for extraction."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_ENTRY_POINT_FINDER

inherit
	AST_ITERATOR
		redefine
			process_eiffel_list,
				-- List of instructions
			process_assigner_call_as,
			process_assign_as,
--			process_check_as,
			process_creation_as,
--			process_debug_as,
--			process_guard_as,
			process_if_as,
			process_inspect_as,
			process_instr_call_as,
			process_loop_as
--			process_retry_as
		end

	EXT_AST_UTILITY

	EXT_SHARED_LOGGER

	REFACTORING_HELPER

create
	make

feature {NONE} -- Initialization

	make
			-- Default initialization.
		do
			create target_variable_usage_set.make
			target_variable_usage_set.compare_objects

			create ast_node_caching_table.make (10)
			ast_node_caching_table.compare_objects
		end

feature -- Configuration

	variable_context: EXT_VARIABLE_CONTEXT
		assign set_variable_context
			-- Contextual information about relevant variables.

	set_variable_context (a_context: EXT_VARIABLE_CONTEXT)
			-- Sets `variable_context' to `a_context'	
		require
			attached a_context
		do
			variable_context := a_context
		end

feature -- Access

	last_entry_point: detachable EIFFEL_LIST [INSTRUCTION_AS]
			-- Minimum sized compound covering all instructions that use the target variables.
			-- Returns `Void' if no such compound could be calculated.
		local
			l_path_node_set: LINKED_SET [AST_PATH]
		do
			debug
				across
					target_variable_usage_set as l_cursor
				loop
					log.put_string (once "[target_variable_usage] " + l_cursor.item.as_string + once "%N")
				end

				across
					ast_node_caching_table as l_cursor
				loop
					log.put_string (once "[ast_node_caching] " + l_cursor.key.as_string + once "%N")
				end
			end

			create l_path_node_set.make
			l_path_node_set.merge (ast_node_caching_table.current_keys)

			if
				attached common_prefix (target_variable_usage_set) as l_common_sub_path and then
				attached longest_prefix (l_path_node_set, l_common_sub_path) as l_longest_prefix
			then
				debug
					log.put_string (once "[common_sub_path  ] " + l_common_sub_path.as_string + once "%N")
					log.put_string (once "[selected_compound] " + l_longest_prefix.as_string + once "%N")
				end

				if attached {EIFFEL_LIST [INSTRUCTION_AS]} ast_node_caching_table.at (l_longest_prefix) as l_compound_as then
						-- directly return instruction compound
					Result := l_compound_as

				elseif attached {INSTRUCTION_AS} ast_node_caching_table.at (l_longest_prefix) as l_instruction_as then
						-- wrap instruction into compound
					create Result.make (1)
					Result.force (l_instruction_as)

				else
						-- invalid type of node in `ast_node_caching_table'.
					check false end
				end
			end
		end

feature {NONE} -- Implementation

	target_variable_usage_set: LINKED_SET [AST_PATH]
			-- Tracks the path of each statement that mentions the target variables.

	ast_node_caching_table: HASH_TABLE [AST_EIFFEL, AST_PATH]
			-- Tracks the path of ast nodes to locate common
			-- parent node of `target_variable_usage_set'.

	longest_prefix (a_path_set: LINKED_SET [AST_PATH]; a_target: AST_PATH): detachable AST_PATH
			-- Returns the item from `a_path_set' that is the longest prefix of `a_target'
		require
			attached a_target
			attached a_path_set
		do
			across
				a_path_set as l_cursor
			loop
				if a_target.is_child_of (l_cursor.item) then
						-- if `Result' wasn't set previously or the actual item has longer prefix,
						-- then update the `Result'.
					if not attached Result or attached Result and l_cursor.item.is_child_of (Result) then
						Result := l_cursor.item
					end
				end
			end
		end

	common_prefix (a_path_set: LINKED_SET [AST_PATH]): detachable AST_PATH
			-- Calulates the longest common prefix on all items of `a_path_set'.
			-- Returns `Void' if no common prefix was found or `a_path_set' is empty.
		require
			attached a_path_set
		local
			l_sub_path_string: STRING
			l_all_equal, l_done: BOOLEAN
			l_criterion, l_position, l_min_length: INTEGER
			l_path_array_list: LINKED_LIST [ARRAY [INTEGER]]
		do
			if not a_path_set.is_empty then
					-- find minimum length over all path expressions
					-- and group path expressions (that are represented as arrays)
					-- for analysis in a collection container.
				create l_path_array_list.make
				l_min_length := {INTEGER}.max_value

				across
					a_path_set as l_cursor
				loop
					l_path_array_list.force (l_cursor.item.as_array)
					if l_cursor.item.as_array.count < l_min_length then
						l_min_length := l_cursor.item.as_array.count
					end
				end

					-- calculate common subpath and store it in Result
				from
					l_position := 1
					create l_sub_path_string.make_empty
				until
					l_position > l_min_length or l_done
				loop
					l_criterion := l_path_array_list.first [l_position]
					l_all_equal := across l_path_array_list as l_cursor all l_cursor.item [l_position] = l_criterion end

					if l_all_equal then
						if l_position /= 1 then l_sub_path_string.append (".") end
						l_sub_path_string.append (l_criterion.out)

						l_position := l_position + 1
					else
						l_done := True
					end
				end

					-- create `Result' from string representation
				if not l_sub_path_string.is_empty then
					create Result.make_from_string (l_sub_path_string)
				end
			end
		end

	process_assigner_call_as (a_as: ASSIGNER_CALL_AS)
		do
			if is_ast_eiffel_using_target_variable (a_as, variable_context) then
				target_variable_usage_set.put (a_as.path)
			end
		end

	process_assign_as (a_as: ASSIGN_AS)
		do
			if is_ast_eiffel_using_target_variable (a_as, variable_context) then
				target_variable_usage_set.put (a_as.path)
			end
		end

	process_creation_as (a_as: CREATION_AS)
		do
			if is_ast_eiffel_using_target_variable (a_as, variable_context) then
				target_variable_usage_set.put (a_as.path)
			end
		end

	process_eiffel_list (a_as: EIFFEL_LIST [AST_EIFFEL])
		do
			if attached {EIFFEL_LIST [INSTRUCTION_AS]} a_as then
				ast_node_caching_table.put (a_as, a_as.path)
			end
			Precursor (a_as)
		end

	process_if_as (a_as: IF_AS)
		do
				-- Record `a_as' if and only if the condition mentions the target.
			if is_ast_eiffel_using_target_variable (a_as.condition, variable_context) then
				target_variable_usage_set.put (a_as.path)
			end
			safe_process (a_as.compound)
			safe_process (a_as.elsif_list)
			safe_process (a_as.else_part)
		end

	process_inspect_as (a_as: INSPECT_AS)
		do
				-- Record `a_as' if and only if the switch mentions the target.			
			if is_ast_eiffel_using_target_variable (a_as.switch, variable_context) then
				target_variable_usage_set.put (a_as.path)
			end
			safe_process (a_as.case_list)
			safe_process (a_as.else_part)
		end

	process_instr_call_as (a_as: INSTR_CALL_AS)
		do
			fixme ("Consider calls on `Current'.")

			if is_ast_eiffel_using_target_variable (a_as, variable_context) then
				target_variable_usage_set.put (a_as.path)
			end
		end

	process_loop_as (a_as: LOOP_AS)
		do
			fixme ("Simplified model not considering `across' loops.")

			if attached a_as.from_part then
					-- Record `a_as' if and only if either
					-- the initialization or the condition mentions the target.			
				if is_ast_eiffel_using_target_variable (a_as.from_part, variable_context) or
					is_ast_eiffel_using_target_variable (a_as.stop, variable_context)
				then
					target_variable_usage_set.put (a_as.path)
				end
			end
			safe_process (a_as.compound)
		end

invariant
	attached ast_node_caching_table
	attached target_variable_usage_set

end
