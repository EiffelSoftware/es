note
	description: "Precondition reductor by only selecting existing objects"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_OBJECT_SELECTION_PRECONDITION_REDUCTOR

inherit
	AUT_PRECONDITION_REDUCTOR

create
	make

feature -- Status report

	has_next_step: BOOLEAN
			-- Does `Current' have a next step to execute?
		do
			Result := not should_quit and not is_reduction_successful
		end

feature -- Execution

	start
			-- Start execution of task.
		do
			set_should_quit (False)
			set_try_count (0)
			set_is_reduction_successful (False)
		end

	step
			-- Perform a next step.
		local
			l_objects: LINKED_LIST [SEMQ_RESULT]
			l_satisfier: AUT_PRESTATE_PREDICATE_SATISFIER
			l_object_count: INTEGER
		do
					-- We try to search in the semantic database to see if there are some object combination
					-- which violates the pre-state invariant. If so, we use those objects as our new test inputs.
			set_try_count (try_count + 1)
			if try_count > 1 then
				l_object_count := 10
			else
				l_object_count := 5
			end
			if not connection.is_connected then

			end
			object_retriever.retrieve_objects (
				current_predicate.expression,
				current_predicate.context_class,
				current_predicate.feature_,
				True,
				True,
				connection,
				used_queryable_ids,
				try_count < 2,
				l_object_count, True)

			if connection.last_error_number /= 0 then
				progress_log_manager.put_string (" [Database problem]")
				cancel_when_database_timeout
			else
				l_objects := object_retriever.last_objects
				if l_objects /= Void and then not l_objects.is_empty then
					update_queryable_id_set (used_queryable_ids, l_objects)
					l_satisfier := object_selector (l_objects)
					execute_task (l_satisfier)

					if l_satisfier.is_current_predicate_satisfied then
						set_should_quit (True)
						set_is_reduction_successful (True)
					else
						if used_queryable_ids.count > 20 then
							progress_log_manager.put_string (" [Not satisfied]")
							set_should_quit (True)
						else
							io.put_string ("I'll read more data.%N")
						end
					end
				end
--				else
				if not should_quit then
					if current_predicate.is_implication then
							-- We force implication invalidation to quit faster.
						set_try_count (try_count + 5)
					end
					if try_count > 5 then
							-- There is no objects as-is satisfying `current_predicate'
						set_should_quit (True)
						progress_log_manager.put_string (" [No object]")
					else
						io.put_string ("I cannot find any objects, I'll relax the contraint and try again.%N")
					end
				end
--				end				
			end
			restart_interpreter_when_necessary
		end

	cancel
			-- Abort current execution.
		do
			set_should_quit (True)
		end

feature{NONE} -- Implementation

	try_count: INTEGER
			-- Number of times we tried to retrieve some objects;

feature{NONE} -- Implementation

	set_try_count (i: INTEGER)
			-- Set `try_count' with `i'.
		do
			try_count := i
		ensure
			try_count_set: try_count = i
		end

	cancel_when_database_timeout
			-- Cancel when database times out.
		do
			reconnect
				-- We force the precondition-reduction process to quit soon
				-- for invariants which cause database problems (usually due
				-- to long lasting queries).
			set_should_quit (True)
		end

	object_selector (a_combinations: LINKED_LIST [SEMQ_RESULT]): AUT_PRESTATE_PREDICATE_SATISFIER
			-- Object selector for `a_combinations'
		do
			create Result.make (system, interpreter, error_handler, current_predicate, a_combinations)
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
