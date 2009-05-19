note
	description: "Summary description for {AUT_PRECONDITION_EVALUATION_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PRECONDITION_EVALUATION_TASK

inherit
	AUT_TASK

	ERL_G_TYPE_ROUTINES

	AUT_SHARED_RANDOM

create
	make

feature{NONE} -- Initialization

	make (a_feature: like feature_; a_vars: DS_LIST [ITP_VARIABLE]; a_interpreter: like interpreter) is
			-- Initialize current.
		local
			i: INTEGER
		do
			feature_ := a_feature
			interpreter := a_interpreter
			object_pool := interpreter.typed_object_pool

			create variables.make (1, a_vars.count)
			from
				i := 1
				a_vars.start
			until
				a_vars.after
			loop
				variables.put (a_vars.item_for_iteration, i)
				i := i + 1
				a_vars.forth
			end

			if is_evaluation_enabled then
				setup_mentioned_argument_indexes
			end
		end

feature -- Access

	system: SYSTEM_I is
			-- Current system
		do
			Result := interpreter.system
		end

	interpreter: AUT_INTERPRETER_PROXY
			-- Interpreter to execute test cases

	feature_: AUT_FEATURE_OF_TYPE
			-- Feature whose precondition is to be evaluated

	variables: ARRAY [ITP_VARIABLE]
			-- Variables used to evaluate the precondition of
			-- `feature_'
			-- The first item in the list is the target to be used
			-- to call `feature_'. The rest items are (possibly) arguments
			-- of that feature.

	object_pool: AUT_TYPED_OBJECT_POOL
			-- Ojbect pool from which objects are selected
			-- to satisfy the precondition of `feature_'

	types: DS_ARRAYED_LIST [TYPE_A]
			-- Types related to `feature_', including target type and
			-- argument types.

feature -- Status

	steps_completed: BOOLEAN
			-- Has all steps completed?

	has_next_step: BOOLEAN is
			-- Is there a next step to execute?
		do
			Result := interpreter.is_running and interpreter.is_ready and not steps_completed
		end

	is_precondition_satisfied: BOOLEAN
			-- Is precondition of `feature_' satisfied by `variables'?

	is_evaluation_enabled: BOOLEAN is
			-- Is feature precondition evaluation enabled?
		do
			Result := interpreter.configuration.is_precondition_checking_enabled
		end

feature -- Execution

	start
			-- Start execution of task.
		local
			l_list: DS_ARRAYED_LIST [ITP_VARIABLE]
		do
			if is_evaluation_enabled then
				create l_list.make (variables.count)
				variables.do_all (agent l_list.force_last)
				if variables.count = feature_.feature_.argument_count + 1 then
					is_precondition_satisfied := interpreter.is_precondition_satisfied (feature_, l_list)
					steps_completed := is_precondition_satisfied

					if has_next_step then
						setup_indexes
					end
				else
					cancel
				end
			else
					-- If precondition evaluation is disabled, we
					-- assume the preconditions is satisfied.
				is_precondition_satisfied := True
				steps_completed := True
			end
		end

	step
			-- Perform the next step of the task.
		local
			l_done: BOOLEAN
			l_indexes: DS_ARRAYED_LIST [INTEGER]
			l_count: INTEGER
			l_index: INTEGER
			l_ran: INTEGER
			l_list: DS_ARRAYED_LIST [ITP_VARIABLE]
			l_variable: ITP_VARIABLE
			l_pool: like object_pool
			l_available_count: like candicate_object_count
			l_available_indexes: like candidate_object_indexes
			l_variables: like variables
			l_real_index: like real_argument_indexes
			l_real_ind: INTEGER
		do
			l_pool := object_pool
			l_available_count := candicate_object_count
			l_available_indexes := candidate_object_indexes
			l_variables := variables
			l_real_index := real_argument_indexes
				-- Iterate to a new object combination.
			from
				l_indexes := l_available_indexes.item (current_argument_index)
				l_count := l_available_count.item (current_argument_index)
			until
				l_done
			loop
					-- If there is no candidate object for current argument, backtrack.
				if l_count = 0 then
					l_available_count.put (l_indexes.count, current_argument_index)
					current_argument_index := current_argument_index - 1
					if current_argument_index = 0 then
							-- We have exhausted all possibilities.
						steps_completed := True
						l_done := True
					end
				else
					l_real_ind := l_real_index.item (current_argument_index)
					random.forth
					l_ran := (random.item_for_iteration \\ l_count) + 1
					l_variable := l_pool.variable_table.item (types.item (l_real_ind)).item (l_indexes.item (l_ran))

					l_variables.put (l_variable, l_real_ind)
					l_indexes.swap (l_count, l_ran)
					l_available_count.put (l_count - 1, current_argument_index)

						-- If there are some arguments that are not chosen yet,
						-- continue search for them, otherwise, finish current search
						-- for one object combination.
					if current_argument_index = argument_count then
						l_done := True
					else
						current_argument_index := current_argument_index + 1
					end
				end

				if not l_done then
					l_indexes := l_available_indexes.item (current_argument_index)
					l_count := l_available_count.item (current_argument_index)
				end
			end

				-- Evaluate current preconditions on selected objects in `variables'.
			if has_next_step then
				create l_list.make (variables.count)
				l_variables.do_all (agent l_list.force_last)
				is_precondition_satisfied := interpreter.is_precondition_satisfied (feature_, l_list)
				steps_completed := is_precondition_satisfied
			end
		end

	cancel
			-- Cancel task.
		do
			steps_completed := True
		end

feature{NONE} -- Implementation

	types_of_feature (a_feature: AUT_FEATURE_OF_TYPE): DS_ARRAYED_LIST [TYPE_A] is
			-- List of types (target type and argument type) of `a_feature'
		local
			l_types: LIST [TYPE_A]
		do
			create Result.make (a_feature.feature_.argument_count + 1)
			Result.force_last (a_feature.type)
			l_types := feature_argument_types (a_feature.feature_, a_feature.type)
			l_types.do_all (agent Result.force_last)
		end

	setup_indexes is
			-- Setup `candidate_object_indexes' and `candidate_object_count'.
		local
			l_type: TYPE_A
			l_objects: DS_LIST [ITP_VARIABLE]
			i: INTEGER
		do
			types := types_of_feature (feature_)
			create candidate_object_indexes.make (types.count)
			create candicate_object_count.make (1, types.count)
			create real_argument_indexes.make (types.count)
			from
				types.start
				i := 1
			until
				types.after
			loop
				if mentioned_argument_indexes.has (types.index) then
					l_type := types.item_for_iteration
					l_objects := object_pool.variable_table.item (l_type)
					candidate_object_indexes.force_last (index_interval (l_objects.count))
					candicate_object_count.put (l_objects.count, i)
					real_argument_indexes.force_last (types.index)
					i := i + 1
				end
				types.forth
			end

			current_argument_index := 1
			argument_count := real_argument_indexes.count
		end

	candidate_object_indexes: DS_ARRAYED_LIST [DS_ARRAYED_LIST [INTEGER]]
			-- List of indexes for objects in object pool for each argument for current predicate.

	candicate_object_count: ARRAY [INTEGER]
			-- Number of objects which are to be searched yet
			-- Array index is the index for arguments.

	current_argument_index: INTEGER
			-- Index of currently searched argument

	argument_count: INTEGER
			-- Number of argument that needs to be searched
			-- argument (including call target) that are not mentioned in the precondition
			-- are not to be searched.

	index_interval (a_count: INTEGER): DS_ARRAYED_LIST [INTEGER] is
			-- List of integers from 1 to `a_count'
		local
			l_interval: INTEGER_INTERVAL
		do
			create Result.make (a_count)
			create l_interval.make (1, a_count)
			l_interval.do_all (agent (i: INTEGER; l: DS_ARRAYED_LIST [INTEGER]) do l.force_last (i) end (?, Result))
		end

	real_argument_indexes: DS_ARRAYED_LIST [INTEGER]
			-- Real argument indexes
			-- Index of this array is 1-based, and represents the i-th argument to search
			-- value in this array is the real argument index for the predicate.

	mentioned_argument_indexes: DS_HASH_SET [INTEGER]
			-- 1-based indexes of arguments that are mentioned in preconditions
			-- of current feature.
			-- The argument with index 1 is the target object
			-- The argument with index 2 is the first argument of the feature to call

	setup_mentioned_argument_indexes is
			-- Setup `mentioned_argument_indexes'.
		local
			l_patterns: DS_LINEAR [AUT_PREDICATE_OF_FEATURE]
			l_access_pattern: DS_HASH_TABLE [INTEGER, INTEGER]
		do
			create mentioned_argument_indexes.make (variables.count)
			check interpreter.predicate_pattern_by_feature.has (feature_) end
			l_patterns := interpreter.predicate_pattern_by_feature.item (feature_)
			from
				l_patterns.start
			until
				l_patterns.after
			loop
				l_access_pattern := l_patterns.item_for_iteration.access_pattern
				from
					l_access_pattern.start
				until
					l_access_pattern.after
				loop
					mentioned_argument_indexes.force_last (l_access_pattern.key_for_iteration + 1)
					l_access_pattern.forth
				end
				l_patterns.forth
			end
		end

;note
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
