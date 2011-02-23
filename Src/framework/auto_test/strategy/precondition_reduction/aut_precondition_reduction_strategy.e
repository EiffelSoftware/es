note
	description: "[
		Precondition reduction startegy
		This strategy tries to generate objects that violate the pre-state
		invariants that have been observed in already generated test cases.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PRECONDITION_REDUCTION_STRATEGY

inherit
	AUT_STRATEGY
		redefine
			make,
			start,
			cancel
		end

	AUT_SHARED_EQUALITY_TESTER

create
	make

feature {NONE} -- Initialization

	make (a_interpreter: like interpreter; a_system: like system; an_error_handler: like error_handler)
			-- Create new strategy.
		do
			Precursor (a_interpreter, a_system, an_error_handler)
			create prestate_invariants.make

			create violated_prestate_invariants.make (50)
			violated_prestate_invariants.set_equality_tester (aut_state_invariant_equality_tester)

			create failed_prestate_invariants.make (50)
			failed_prestate_invariants.set_equality_tester (aut_state_invariant_equality_tester)

			connection := interpreter.configuration.semantic_database_config.connection
			load_prestate_invariants
		end

feature -- Status report

	has_next_step: BOOLEAN
			-- <Precursor>
		do
			Result := not prestate_invariants.is_empty
		end

feature {ROTA_S, ROTA_TASK_I, ROTA_TASK_COLLECTION_I} -- Status setting

	start
			-- Perform a start step.
		do
			Precursor
			interpreter.set_is_in_replay_mode (False)
			assign_void
--			if queue.highest_dynamic_priority > 0 then
--				select_new_sub_task
--			end
		end

	cancel
		do
			sub_task := Void
			interpreter.stop
		end

	step
		do
--			if interpreter.is_running and interpreter.is_ready then
--				sub_task.step
--			end
--			if interpreter.is_running and not interpreter.is_ready then
--				interpreter.stop
--			end
--			if not interpreter.is_running then
--				if sub_task /= Void and then sub_task.has_next_step then
--					sub_task.cancel
--				end
--				interpreter.start
--				assign_void
--			end
--			if not sub_task.has_next_step then
--				if queue.highest_dynamic_priority > 0 then
--					select_new_sub_task
--				else
--					sub_task := Void
--				end
--			end
		end

feature{NONE} -- Implementation

	sub_task: AUT_TASK
			-- Current sub task

	assign_void
			-- Assign void to the next free variable.
			-- Note: Copied from {AUT_RANDOM_STRATEGY}
			-- This causes code duplication, but avoid merge
			-- problem when synchronizing with trunk.
		local
			void_constant: ITP_CONSTANT
		do
			if interpreter.is_running and interpreter.is_ready then
				create void_constant.make (Void)
				interpreter.assign_expression (interpreter.variable_table.new_variable, void_constant)
			end
		end

	load_prestate_invariants
			-- Load pre-state invariants into `prestate_invariants'.
		local
			l_loader: AUT_PRESTATE_INVARIANT_LOADER
			l_retriever: AUT_QUERYABLE_QUERYABLE_RETRIEVER
			l_con: MYSQL_CLIENT
		do
			create l_loader
			l_loader.load (interpreter.configuration.prestate_invariant_path)
			prestate_invariants.append (l_loader.last_invariants)

--			create l_retriever
--			l_retriever.retrieve_objects (l_loader.last_invariants.first.expression, l_loader.last_class, l_loader.last_feature, False, connection)
		end

	connection: MYSQL_CLIENT
			-- Database connection

feature{NONE} -- Implementation

	prestate_invariants: LINKED_LIST [AUT_STATE_INVARIANT]
			-- List of pre-state invariants that are to be considered

	violated_prestate_invariants: DS_HASH_SET [AUT_STATE_INVARIANT]
			-- Set of pre-state invariants that are already violated

	failed_prestate_invariants: DS_HASH_SET [AUT_STATE_INVARIANT]
			-- Set of pre-state invariants that we fail to violate
			-- (after a maximum steps of tries)

;note
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
