note
	description: "Summary description for {EWB_AUTO_FIX_RETRIEVE_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_AUTO_FIX_RETRIEVE_STATE

inherit
	SHARED_WORKBENCH

	SHARED_EXEC_ENVIRONMENT
	SHARED_EIFFEL_PROJECT
	PROJECT_CONTEXT
	SYSTEM_CONSTANTS

	SHARED_DEBUGGER_MANAGER

	SHARED_BENCH_NAMES

	AUT_CONTRACT_EXTRACTOR

	AFX_SHARED_CLASS_THEORY

create
	make

feature{NONE} -- Initialization

	make (a_config: AFX_CONFIG)
			-- Initialize Current.
		do
			config := a_config
			create daikon_generator.make
		ensure
			config_set: config = a_config
		end

feature -- Access

	config: AFX_CONFIG
			-- Config for AutoFix ocmmand line

feature
	daikon_generator : AFX_DAIKON_GENERATOR

feature -- Execute

	execute
			-- Execute current command.
		local
			l_bp_manager: AFX_BREAKPOINT_MANAGER
			l_state: AFX_STATE_SKELETON
			l_action: AFX_BREAKPOINT_WHEN_HITS_ACTION_EXPR_EVALUATION
			l_gen: AFX_NESTED_EXPRESSION_GENERATOR

			l_smt_generator:AFX_SMTLIB_GENERATOR
			l_inv: LINKED_LIST [AUT_EXPRESSION]
			l_theory: AFX_THEORY
			l_smt_expr: DS_HASH_TABLE [AFX_SOLVER_EXPR, EPA_EXPRESSION]

			l_test_state_implication: BOOLEAN
			l_build_theory: BOOLEAN
			l_retrieve_system_state: BOOLEAN
			l: AFX_SIMPLE_FUNCTION_POSTCONDITION_GENERATOR
			l_test_postcondition_generation: BOOLEAN
			l_test_daikon_generation: BOOLEAN
		do
			if l_build_theory then
				l_theory := resolved_class_theory (first_class_starts_with_name ("LINKED_LIST"))
				io.put_string ("============================EXECUTE=========================================%N")
				from
					l_theory.functions.start
				until
					l_theory.functions.after
				loop
					io.put_string (l_theory.functions.item_for_iteration.expression + "%N")
					l_theory.functions.forth
				end
				io.put_string ("%N%N")
				from
					l_theory.axioms.start
				until
					l_theory.axioms.after
				loop
					io.put_string (l_theory.axioms.item_for_iteration.expression + "%N")
					l_theory.axioms.forth
				end
			end

			l_retrieve_system_state := True
			if l_retrieve_system_state then
				create l_bp_manager.make (config.state_recipient_class, config.state_recipient)

				create l_gen.make
				l_gen.generate (config.state_recipient_class, config.state_recipient)
				create l_state.make_with_accesses (config.state_recipient_class, config.state_recipient, l_gen.accesses)
				l_state := l_state.simplified
				l_theory := l_state.theory

				l_smt_expr := l_state.smtlib_expressions
				io.put_string ("=======================EXECUTE2=====================================%N")
				io.put_string (l_theory.debug_output)
				io.put_string ("%N%N")
				from
					l_smt_expr.start
				until
					l_smt_expr.after
				loop
					io.put_string (l_smt_expr.item_for_iteration.expression + "%N")
					l_smt_expr.forth
				end


				create l_action.make (l_state, config.state_recipient_class, config.state_recipient)
				debugger_manager.breakpoints_manager.remove_user_breakpoints_in_feature (config.state_recipient.e_feature)

				l_bp_manager.set_hit_action_with_agent (l_state, agent on_hit)
				l_bp_manager.set_all_breakpoints (l_state)
				l_bp_manager.toggle_breakpoints (True)

				debugger_manager.set_should_menu_be_raised_when_application_stopped (False)
				debugger_manager.observer_provider.application_stopped_actions.extend_kamikaze (agent on_application_stopped)
				start_debugger
				l_bp_manager.toggle_breakpoints (False)

			end

--			l_test_state_implication := True
			if l_test_state_implication then
				test_state_implication
			end

--			l_test_daikon_generation := True
			if l_test_daikon_generation then
				io.put_string (daikon_generator.declarations)
				io.put_string (daikon_generator.traces)
			end

--			l_test_postcondition_generation := True
			if l_test_postcondition_generation then
				test_postcondition_generation
			end
		end

	test_state_implication
			-- Test state implication
		local
			l_s1, l_s2: AFX_STATE
			l_pred1, l_pred2: AFX_EQUATION
			l_expr1, l_expr2: EPA_AST_EXPRESSION
			l_value1: EPA_INTEGER_VALUE
			l_value2: EPA_BOOLEAN_VALUE
			l_value3: EPA_RANDOM_BOOLEAN_VALUE
		do
			create l_s1.make (1, config.state_recipient_class, config.state_recipient)
			create l_s2.make (1, config.state_recipient_class, config.state_recipient)

			create l_expr1.make_with_text (config.state_recipient_class, config.state_recipient, "index", config.state_recipient_class)
			create l_expr2.make_with_text (config.state_recipient_class, config.state_recipient, "index > 0", config.state_recipient_class)

			create l_value1.make (5)
			create l_value2.make (True)

			create l_value3.make
			create l_pred1.make (l_expr1, l_value1)
			create l_pred2.make (l_expr2, l_value3)

			l_s1.force_last (l_pred1)
			l_s2.force_last (l_pred2)

--			io.put_string ("s1 -> s2 = " + (l_s1 implies l_s2).out + "%N")

			io.put_string (l_pred2.as_predicate.text + "%N")
		end

	test_postcondition_generation
		local
			l_generator: AFX_SIMPLE_FUNCTION_POSTCONDITION_GENERATOR
			l_feature: FEATURE_I
		do
			create l_generator
			l_feature := config.state_recipient_class.feature_named ("before")
			l_generator.generate (config.state_recipient_class, l_feature)
			io.put_string (l_generator.last_postcondition + "%N")
		end

feature{NONE} -- Implementation

	start_debugger
		require
			debugger_manager /= Void
		local
			ctlr: DEBUGGER_CONTROLLER
			wdir: STRING
			param: DEBUGGER_EXECUTION_PARAMETERS
		do
			if wdir = Void or else wdir.is_empty then
				wdir := Eiffel_project.lace.directory_name
						--Execution_environment.current_working_directory
			end
			ctlr := debugger_manager.controller
			create param
			param.set_arguments ("")
			param.set_working_directory (config.working_directory)
			debugger_manager.set_execution_ignoring_breakpoints (False)
			ctlr.debug_application (param, {EXEC_MODES}.run)
		end

	on_hit (a_breakpoint: BREAKPOINT; a_state: AFX_STATE) is
			-- Action to be performed when `a_breakpoint' is hit and `a_state' is retrieved
			-- Due to the naming convention the class and the feature_name cannot be void
		require
			class_name:a_state.class_.name /= void
			feature_name:a_state.feature_.feature_name /= void
		local

		do

--			daikon_generator.add_state (a_state,a_breakpoint.breakable_line_number, false)


			if a_state.feature_ = void then
			    io.put_string ("============== "+ a_state.class_.name +" =====================================%N")
			else
				io.put_string ("============== "+ a_state.feature_.feature_name +" =====================================%N")
			end

			io.put_string ("===================================================%N")
			io.put_string ("BP_" + a_breakpoint.breakable_line_number.out + "%N")
			from
				a_state.start
			until
				a_state.after
			loop
				io.put_string (a_state.item_for_iteration.expression.text + " = " + a_state.item_for_iteration.value.out + "%N")
				a_state.forth
			end
		end

	on_application_stopped (a_dm: DEBUGGER_MANAGER)
			-- Action to be performed when application is stopped in the debugger
		do
			if a_dm.application_is_executing or a_dm.application_is_stopped then
				a_dm.application.kill
			end
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
