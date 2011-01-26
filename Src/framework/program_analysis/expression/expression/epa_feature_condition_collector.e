note
	description: "Class to collect conditions in spliting statements such as if, loop"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FEATURE_CONDITION_COLLECTOR

inherit
	AST_ITERATOR
		redefine
			process_if_as,
			process_assign_as,
			process_elseif_as,
			process_loop_as
		end

	EPA_SHARED_EQUALITY_TESTERS

	EPA_UTILITY

feature -- Access

	conditions: DS_HASH_SET [EPA_EXPRESSION]
			-- Set of expressions representing splitting conditions
			-- collected from the last `collect'.
			-- There is no special order among elements inside `conditions'.
			-- Expression nest relation is not preserved.

	assignments: DS_HASH_TABLE [LINKED_LIST [ASSIGN_AS], EPA_EXPRESSION]
			-- Table from splitting expressions to all assignments that appear
			-- before them. Keys are splitting expressions (the same as in `conditions'), values
			-- are assignments that appear before those splitting conditions (in AST process order.

feature -- Debugging purpose

	dumped_conditions: STRING
			-- String representation for `conditions'
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
		do
			create Result.make (512)
			from
				l_cursor := conditions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.append (l_cursor.item.text)
				Result.append_character ('%N')
				l_cursor.forth
			end
		end

	dumped_assignments: STRING
			-- String representation for `assignments'
		local
			l_cursor: DS_HASH_TABLE_CURSOR [LINKED_LIST [ASSIGN_AS], EPA_EXPRESSION]
		do
			create Result.make (512)
			from
				l_cursor := assignments.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.append (l_cursor.key.text)
				Result.append_character ('%N')
				across l_cursor.item as l_assigns loop
					Result.append_character ('%T')
					Result.append (text_from_ast (l_assigns.item))
				end
				l_cursor.forth
			end
		end

feature -- Basic operations

	collect (a_class: CLASS_C; a_feature: FEATURE_I)
			-- Collect splitting conditions in `a_feature' from `a_class'.
			-- Make result available in `conditions' and `assignments'
		do
			initialize
			context_class := a_class
			context_feature := a_feature
			written_class := a_feature.written_class

				-- Process feature body AST to find splitting conditions.
			if attached {BODY_AS} a_feature.e_feature.ast.body as l_body and then attached {ROUTINE_AS} l_body.as_routine as l_routine then
				l_routine.process (Current)
			end
		end

feature{NONE} -- Implementation

	visited_assigments: LINKED_LIST [ASSIGN_AS]
			-- List of assignments that has been visited so far.

	context_class: CLASS_C
			-- Context class

	context_feature: FEATURE_I
			-- Context feature

	written_class: CLASS_C
			-- Written class of `context_feature'

feature{NONE} -- Implementation

	initialize
			-- Initialize data structures.
		do
			create conditions.make (10)
			conditions.set_equality_tester (expression_equality_tester)

			create assignments.make (10)
			assignments.set_key_equality_tester (expression_equality_tester)

			create visited_assigments.make
		end

feature{NONE} -- Process

	process_if_as (l_as: IF_AS)
		local
			l_condition: EPA_AST_EXPRESSION
		do
			create l_condition.make_with_feature (context_class, context_feature, l_as.condition, written_class)
			conditions.force_last (l_condition)
			assignments.force_last (visited_assigments.twin, l_condition)

			l_as.condition.process (Current)
			safe_process (l_as.compound)
			safe_process (l_as.elsif_list)
			safe_process (l_as.else_part)
		end

	process_assign_as (l_as: ASSIGN_AS)
		do
			visited_assigments.extend (l_as)
			Precursor (l_as)
		end

	process_elseif_as (l_as: ELSIF_AS)
		local
			l_condition: EPA_AST_EXPRESSION
		do
			create l_condition.make_with_feature (context_class, context_feature, l_as.expr, written_class)
			conditions.force_last (l_condition)
			assignments.force_last (visited_assigments.twin, l_condition)

			l_as.expr.process (Current)
			safe_process (l_as.compound)
		end

	process_loop_as (l_as: LOOP_AS)
		local
			l_condition: EPA_AST_EXPRESSION
		do
			safe_process (l_as.iteration)
			safe_process (l_as.from_part)
			safe_process (l_as.invariant_part)
			create l_condition.make_with_feature (context_class, context_feature, l_as.stop, written_class)
			conditions.force_last (l_condition)
			assignments.force_last (visited_assigments.twin, l_condition)
			safe_process (l_as.stop)
			safe_process (l_as.compound)
			safe_process (l_as.variant_part)
		end

end
