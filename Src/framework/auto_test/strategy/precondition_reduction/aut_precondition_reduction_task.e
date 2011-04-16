note
	description: "Task for precondition reduction"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_PRECONDITION_REDUCTION_TASK

inherit
	AUT_TASK

	AUT_SHARED_CONSTANTS
		export {NONE} all end

	ERL_G_TYPE_ROUTINES

	REFACTORING_HELPER

	EQA_TEST_CASE_SERIALIZATION_UTILITY

	SHARED_TYPES

	EPA_UTILITY
		undefine
			system
		end

	EPA_SHARED_EQUALITY_TESTERS
		undefine
			system
		end

feature -- Access

	system: SYSTEM_I
			-- System

	interpreter: AUT_INTERPRETER_PROXY
			-- Proxy to the interpreter.

	error_handler: AUT_ERROR_HANDLER
			-- Error handler.

	current_predicate: AUT_STATE_INVARIANT
			-- Current pre-state predicate to satisfy

	class_: CLASS_C
			-- Class of `current_predicate'.
		do
			Result := current_predicate.context_class
		end

	feature_: FEATURE_I
			-- Feature of `current_predicate'.
		do
			Result := current_predicate.feature_
		end

feature{NONE} -- Implementation

	execute_task (a_task: AUT_TASK)
			-- Execute `a_task' until it is finished.
		local
			l_should_quit: BOOLEAN
		do
			from
				a_task.start
			until
				not a_task.has_next_step or l_should_quit
			loop
				if interpreter.is_running and not interpreter.is_ready then
					interpreter.stop
					a_task.cancel
					l_should_quit := True
				else
					a_task.step
				end
			end
		end

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
