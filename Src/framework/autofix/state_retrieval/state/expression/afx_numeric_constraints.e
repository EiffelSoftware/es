note
	description: "Summary description for {AFXP_CONSTRAINTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_NUMERIC_CONSTRAINTS

inherit
	AFX_UTILITY

	DEBUG_OUTPUT

create
	make

feature{NONE} -- Initialization

	make (a_expression: like expression)
			-- Initialize Current.
		do
			expression := a_expression
			create components.make (5)
			components.set_equality_tester (expression_equality_tester)
			create occurrence_frequency.make (5)
			occurrence_frequency.compare_objects
		end

feature -- Access

	expression: detachable AFX_EXPRESSION
			-- Expression from which `components' come
			-- If Void, items in `components' may come from multiple assertions.

	components: DS_HASH_SET [AFX_EXPRESSION]
			-- Distinct components in the last analyzed expression.
			-- For example, in an assertion "i > 0 and i <= count",
			-- `i', `count' are components.
			-- Only have effect if `is_matched' is True.

	occurrence_frequency: HASH_TABLE [INTEGER, AFX_EXPRESSION]
			-- Occurrence frequency of the components in the last analyzed expression
			-- Key is a component, value is the number of times it appears in the expression.
			-- Occurrence frequency is used as one of the heuristics to decide which compoents in
			-- the last analyzed expression are constrained, and which ones are constraining.
			-- Normally, if a component appears more often, it is more likely to be a contrained component.
			-- For example, in assertion "i >= 0 and i <= count", `i' appear 2 times, so it is more likely
			-- to be a contrained component.

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		local
			l_cursor: CURSOR
		do
			create Result.make (1024)
			l_cursor := occurrence_frequency.cursor
			from
				occurrence_frequency.start
			until
				occurrence_frequency.after
			loop
				Result.append (occurrence_frequency.key_for_iteration.text)
				Result.append (once " : ")
				Result.append (occurrence_frequency.item_for_iteration.out)
				Result.append (once "%N")
				occurrence_frequency.forth
			end
			occurrence_frequency.go_to (l_cursor)
		end

feature -- Basic operations

	increase_occurrence_frequency (a_expr: AFX_EXPRESSION; a_increase: INTEGER)
			-- Increase the occurrence frequency of `a_expr' by `a_increas'.
		require
			a_increase_positive: a_increase > 0
		do
			if occurrence_frequency.has (a_expr) then
				occurrence_frequency.replace (occurrence_frequency.item (a_expr) + a_increase, a_expr)
			else
				occurrence_frequency.put (a_increase, a_expr)
				components.force_last (a_expr)
			end
		end

	merge (other: like Current)
			-- Merge other into Current.
		local
			l_other_fre: like occurrence_frequency
		do
			from
				l_other_fre := other.occurrence_frequency
				l_other_fre.start
			until
				l_other_fre.after
			loop
				increase_occurrence_frequency (l_other_fre.key_for_iteration, l_other_fre.item_for_iteration)
				l_other_fre.forth
			end
		end

end
