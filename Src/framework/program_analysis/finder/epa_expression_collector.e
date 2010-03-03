note
	description: "Objects to collect potentially interesting expressions using customized expression finders"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXPRESSION_COLLECTOR

inherit
	EPA_EXPRESSION_FINDER

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			create finders.make
			create new_expression_added_actions
		end

feature -- Access

	finders: LINKED_LIST [EPA_EXPRESSION_FINDER]
			-- List of expression finders which will find expressions
			-- according to different criteria

	new_expression_added_actions: ACTION_SEQUENCE [TUPLE [newly_added_expressions: like last_found_expressions]]
			-- Actions to be performed when `newly_added_expressions' are added into `last_found_expressions'

	max_round: INTEGER
			-- Maximum number of rounds to apply `finders' in `search' or `search_expressions'.
			-- 0 means no limit, the applying will only finish when fix point has been reached.
			-- Default: 0.

feature -- Basic operations

	search_expressions
			-- Search for expressions, make result available in `last_found_expression'.
		local
			l_emtpy_set: EPA_HASH_SET [EPA_EXPRESSION]
		do
			create l_emtpy_set.make (100)
			l_emtpy_set.set_equality_tester (create {EPA_EXPRESSION_EQUALITY_TESTER})
			search (l_emtpy_set)
		end

	search (a_expression_repository: EPA_HASH_SET [EPA_EXPRESSION])
			-- <Precursor>
			-- Apply expression all finders in `finders' multiple times
			-- until fix point in `last_found_expression' is reached
		local
			l_fix_point_reached: BOOLEAN
			l_cursor: CURSOR
			l_finders: like finders
			l_found_expressions: like last_found_expressions
			l_finder: EPA_EXPRESSION_FINDER
			l_existing_expressions: like last_found_expressions
			l_newly_added: like newly_added_expressions
			l_new_exprs: like last_found_expressions
			l_round: INTEGER
		do
				-- Create an empty expression set.			
			last_found_expressions := new_expression_set
			l_found_expressions := last_found_expressions

			create l_existing_expressions.make (a_expression_repository.count)
			l_existing_expressions.set_equality_tester (expression_equality_tester)
			l_existing_expressions.append (a_expression_repository)

				-- Iterate through `finders' multiple times until
				-- fix point of the expression set is reached.
			l_finders := finders
			l_cursor := l_finders.cursor
			from
				l_fix_point_reached := False
			until
				l_fix_point_reached or (max_round > 0 implies l_round > max_round)
			loop
				create newly_added_expressions.make (100)
				l_newly_added := newly_added_expressions
				l_newly_added.set_equality_tester (expression_equality_tester)

					-- One round of applying `finders'.
				from
					l_fix_point_reached := True
					l_finders.start
				until
					l_finders.after
				loop
					l_finder := l_finders.item_for_iteration
					l_finder.search (l_existing_expressions)
					l_new_exprs := l_finder.last_found_expressions
					if not l_new_exprs.is_empty then
						l_found_expressions.append_last (l_new_exprs)
						l_existing_expressions.append_last (l_new_exprs)
						l_newly_added.append_last (l_new_exprs)
						l_fix_point_reached := False
					end
					l_finders.forth
				end

					-- Notify that there is are expressions added into
					-- `last_found_expressions' in this round.
				if not l_fix_point_reached then
					new_expression_added_actions.call ([l_newly_added])
				end
				l_round := l_round + 1
			end
			l_finders.go_to (l_cursor)
		end

feature -- Setting

	set_max_round (i: INTEGER)
			-- Set `max_round' with `i'.
		require
			i_non_negative: i >= 0
		do
			max_round := i
		ensure
			max_round_set: max_round = i
		end

feature{NONE} -- Implementation

	newly_added_expressions: detachable EPA_HASH_SET [EPA_EXPRESSION]
			-- The set of expressions that are added into `last_found_expressions'
			-- by the last round of searching, with one round meaning applying all `finders'.
			-- Empty before the first round of searching.

end
