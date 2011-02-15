note
	description: "Summary description for {AFX_PROGRAM_EXECUTION_TRACE_TO_DAIKON_PRINTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_EXECUTION_TRACE_TO_DAIKON_PRINTER

inherit
	DKN_SHARED_EQUALITY_TESTERS

	DKN_CONSTANTS

	DKN_UTILITY

	AFX_SHARED_SERVER_PROGRAM_STATE_SKELETON

create
	make

feature -- Initialization

	make
			-- Initialization.
		do

		end

feature -- Access

	last_declarations: DKN_DECLARATION
			-- Last printed DAIKON declaration.
		do
			if last_declarations_cache = Void then
				create last_declarations_cache.make (20)
			end
			Result := last_declarations_cache
		end

	last_trace: DKN_TRACE
			-- Last printed Daikon trace.
		do
			if last_trace_cache = Void then
				create last_trace_cache.make
			end
			Result := last_trace_cache
		end

feature -- Basic operation

	print_trace_repository (a_repository: DS_HASH_TABLE [AFX_PROGRAM_EXECUTION_TRACE, STRING])
			-- Print the program execution traces in `a_repository' to be used for Daikon.
		require
			repository_attached: a_repository /= Void
		do
			reset_printer
			a_repository.do_all (agent print_trace)
		end

feature{NONE} -- Implementation

	print_trace (a_trace: AFX_PROGRAM_EXECUTION_TRACE)
			-- Print `a_trace' to be used for Daikon.
		require
			trace_attached: a_trace /= Void
		do
			a_trace.do_all (agent print_execution_state)
		end

	print_execution_state (a_state: AFX_PROGRAM_EXECUTION_STATE)
			-- Print `a_state' to be used for Daikon.
		require
			state_attached: a_state /= Void
		local
			l_ppt: DKN_PROGRAM_POINT
			l_trace_record: DKN_TRACE_RECORD

			l_bp_index: INTEGER
			l_state: EPA_STATE
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_skeleton: AFX_PROGRAM_STATE_SKELETON
			l_ppt_name: STRING
			l_dkn_declaration: DKN_PROGRAM_POINT
			l_dkn_trace_record: DKN_TRACE_RECORD
		do
			l_ppt := program_point_from_execution_state (a_state)
			last_declarations.force_last (l_ppt)

			l_trace_record := trace_record_from_execution_state (a_state, l_ppt)
			last_trace.extend (l_trace_record)
		end

	trace_record_from_execution_state (a_state: AFX_PROGRAM_EXECUTION_STATE; a_ppt: DKN_PROGRAM_POINT): DKN_TRACE_RECORD
			-- Trace record from `a_state'.
		require
			state_attached: a_state /= Void
		local
			l_state: EPA_STATE
			l_variables: DS_HASH_SET_CURSOR [DKN_VARIABLE]
			l_var: DKN_VARIABLE
			l_expr_value: EPA_EXPRESSION_VALUE
			l_value: DKN_VARIABLE_VALUE
			l_modified_flag: INTEGER

			l_equation: EPA_EQUATION
			l_expr: AFX_PROGRAM_STATE_ASPECT
			l_val: EPA_EXPRESSION_VALUE

			l_expr_text: STRING
		do
			l_state := a_state.state

			from
				create Result.make (a_ppt)
				l_variables := a_ppt.variables.new_cursor
				l_variables.start
			until
				l_variables.after
			loop
				l_var := l_variables.item

				l_expr_text := l_var.name
				if attached {EPA_EQUATION} l_state.item_with_expression_text (l_expr_text) as lt_equation then
					l_expr_value := lt_equation.value
					if l_expr_value.is_nonsensical then
						l_modified_flag := Modified_flag_2
					else
						l_modified_flag := Modified_flag_0
					end
					create l_value.make (l_var, daikon_value (l_expr_value), l_modified_flag)
				else
					create l_value.make (l_var, Daikon_nonsensical_value, Modified_flag_2)
				end
				Result.values.force_last (l_value, l_var)

				l_variables.forth
			end
		end

	program_point_from_execution_state (a_state: AFX_PROGRAM_EXECUTION_STATE): DKN_PROGRAM_POINT
			-- Program point declaration for `a_state'.
		local
			l_state: EPA_STATE
			l_bp_index: INTEGER
			l_context_class, l_written_class: CLASS_C
			l_feature: FEATURE_I
			l_ppt_name: STRING
			l_skeleton: AFX_PROGRAM_STATE_SKELETON
			l_aspect: AFX_PROGRAM_STATE_ASPECT
			l_variable: DKN_VARIABLE
			l_var_name: STRING
			l_var_type: TYPE_A
		do
			l_state := a_state.state
			l_bp_index := a_state.breakpoint_slot_index

			l_context_class := l_state.class_
			l_written_class := l_state.feature_.written_class
			l_feature := l_state.feature_

			l_ppt_name := l_context_class.name.as_upper + "." + l_feature.feature_name_32.as_lower + {DKN_CONSTANTS}.ppt_tag_separator + l_bp_index.out
			create Result.make_with_type (l_ppt_name, Point_program_point)

			-- Variables declared at this program point.
			l_skeleton := server_program_state_skeleton.skeleton_breakpoint_unspecific (l_context_class, l_feature)
			from l_skeleton.start
			until l_skeleton.after
			loop
				l_aspect := l_skeleton.item_for_iteration

				l_var_name := l_aspect.text
				l_var_type := l_aspect.type
				create l_variable.make (l_var_name, Boolean_rep_type, Variable_var_kind, Boolean_rep_type, l_var_name.hash_code)
				Result.variables.force (l_variable)

				l_skeleton.forth
			end
		end

	daikon_value (a_value: EPA_EXPRESSION_VALUE): STRING
			-- Daikon variable value from `a_value'
		do
			if a_value.is_nonsensical then
				Result := daikon_nonsensical_value
			elseif attached {EPA_BOOLEAN_VALUE} a_value as l_bool then
				if l_bool.item then
					Result := once "1"
				else
					Result := once "0"
				end
			else
				check should_not_happend: False end
			end
		end

	reset_printer
			-- Reset the printer.
		do
			last_declarations_cache := Void
			last_trace_cache := Void
		end

feature -- Cache

	last_declarations_cache: like last_declarations
			-- Cache for `last_declarations'.

	last_trace_cache: like last_trace
			-- Cache for `last_trace'.

end
