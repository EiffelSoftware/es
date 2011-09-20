note
	description: "Summary description for {AFX_EXCEPTION_RECIPIENT_FEATURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXCEPTION_RECIPIENT_FEATURE

inherit
	EPA_FEATURE_WITH_CONTEXT_CLASS

	EPA_CONTROL_DISTANCE_CONSTANT
		undefine
			is_equal, out
		end

create
	make_for_exception

feature{NONE} -- Initialization

	make_for_exception (a_exception: AFX_EXCEPTION_SIGNATURE)
			-- Initialization.
		require
			exception_attached: a_exception /= Void
		do
			exception := a_exception
			make (a_exception.recipient_feature, a_exception.recipient_class)
		end

feature -- Access

	exception: AFX_EXCEPTION_SIGNATURE
			-- Exception for Current.

feature -- Dynamic state

	expressions_to_monitor: DS_HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
			-- Expressions to monitor regarding Current.
		local
			l_generator: AFX_EXPRESSIONS_TO_MONITOR_GENERATOR
		do
			if expressions_to_monitor_cache = Void then
				create l_generator
				l_generator.generate_for_feature (Current)
				expressions_to_monitor_cache := l_generator.last_expressions_to_monitor
			end
			Result := expressions_to_monitor_cache
		ensure
			result_attached: Result /= Void
		end

	state_skeleton: EPA_STATE_SKELETON
			-- State skeleton based on `expressions_to_monitor'.
		local
			l_expr_list: ARRAYED_LIST [EPA_EXPRESSION]
			l_expressions_to_monitor: like expressions_to_monitor
		do
			if state_skeleton_cache = Void then
				l_expressions_to_monitor := expressions_to_monitor
				create l_expr_list.make (l_expressions_to_monitor.count)
				l_expressions_to_monitor.keys.do_all (agent l_expr_list.force)
				create state_skeleton_cache.make_with_expressions (context_class, feature_, l_expr_list)
			end
			Result := state_skeleton_cache
		end

	derived_state_skeleton: EPA_STATE_SKELETON
			-- State skeleton for `a_feature', derived from `expressions_to_monitor'.
		local
			l_expressions_to_monitor: like expressions_to_monitor
			l_expressions: EPA_HASH_SET [EPA_EXPRESSION]
			l_builder: AFX_DERIVED_STATE_SKELETON_BUILDER
		do
			if derived_state_skeleton_cache = Void then
				l_expressions_to_monitor := expressions_to_monitor
				create l_expressions.make_equal (l_expressions_to_monitor.count)
				l_expressions_to_monitor.keys.do_all (agent l_expressions.force)
				create l_builder
				l_builder.build_skeleton (Current, l_expressions)
				derived_state_skeleton_cache := l_builder.last_derived_skeleton
			end
			Result := derived_state_skeleton_cache
		end

feature -- Static structure

	first_breakpoint_in_body: INTEGER
			-- First breakpoint in the body of Current.
		do
			Result := ast_structure.first_breakpoint_slot_number
		end

	last_breakpoint_in_body: INTEGER
			-- Last breakpoint in the body of Current.
		do
			Result := ast_structure.last_breakpoint_slot_number
		end

	ast_structure: AFX_FEATURE_AST_STRUCTURE_NODE
			-- AST structure of Current.
		local
			l_structure_gen: AFX_AST_STRUCTURE_NODE_GENERATOR
		do
			if ast_structure_cache = Void then
				create l_structure_gen
				l_structure_gen.generate (context_class, feature_)
				ast_structure_cache := l_structure_gen.structure
			end
			Result := ast_structure_cache
		end

	body_compound_ast: EIFFEL_LIST [INSTRUCTION_AS]
			-- AST node for body of the recipient.
			-- It is the compound part of a DO_AS.
		do
			if attached {BODY_AS} feature_.body.body as l_body then
				if attached {ROUTINE_AS} l_body.content as l_routine then
					if attached {DO_AS} l_routine.routine_body as l_do then
						Result := l_do.compound
					end
				end
			end
		end

	feature_as_ast: FEATURE_AS
			-- AST for the recipient.
		do
			Result := feature_.e_feature.ast
		end

feature -- Query

	control_distances_to_exception_point (a_breakpoint: INTEGER): INTEGER
			-- Control distance of `a_breakpoint' to the exception point.
			-- If the exception point is not reachable from `a_breakpoint' in the CFG,
			-- return `Control_distance_infinite'.
		local
			l_calculator: EPA_CONTROL_DISTANCE_CALCULATOR
		do
			if control_distance_report_regarding_exception_point = Void then
				create l_calculator.make
				l_calculator.calculate_within_feature (context_class, feature_, exception.recipient_breakpoint)
				control_distance_report_regarding_exception_point := l_calculator.last_report_concerning_bp_indexes
			end

			if control_distance_report_regarding_exception_point.has (a_breakpoint) then
				Result := control_distance_report_regarding_exception_point.item (a_breakpoint)
			else
				Result := Infinite_distance
			end
		end


feature{NONE} -- Access

	control_distance_report_regarding_exception_point: DS_HASH_TABLE [INTEGER, INTEGER]
			-- Control distance report mapping breakpoint indexes to their distances from the exception point.

feature{NONE} -- Cache

	expressions_to_monitor_cache: DS_HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]
			-- Cache for `expressions_to_monitor'.

	ast_structure_cache: AFX_FEATURE_AST_STRUCTURE_NODE
			-- Cache for `ast_structure'.

	state_skeleton_cache: EPA_STATE_SKELETON
			-- Cache for `state_skeleton'.

	derived_state_skeleton_cache: EPA_STATE_SKELETON
			-- Cache for `derived_state_skeleton'.

end
