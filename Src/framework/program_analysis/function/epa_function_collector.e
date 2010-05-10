note
	description: "Composed functions finder, which delegates its job to a set of worker finders, and collect the results from those worker finders."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FUNCTION_COLLECTOR

inherit
	EPA_FUNCTION_FINDER

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			create finders.make
			create new_function_added_actions
		end

feature -- Access

	functions: DS_HASH_SET [EPA_FUNCTION]
			-- Functions found by last `search'

	finders: LINKED_LIST [EPA_FUNCTION_FINDER]
			-- List of functions finders which will find functions
			-- according to different criteria

	new_function_added_actions: ACTION_SEQUENCE [TUPLE [newly_added_functions: like functions]]
			-- Actions to be performed when `newly_added_functions' are added into `functions'

	max_round: INTEGER
			-- Maximum number of rounds to apply `finders' in `search'.
			-- 0 means no limit, the applying will only finish when fix point has been reached.
			-- Default: 0.

feature -- Basic operations

	search (a_repository: like functions)
			-- <Precursor>
			-- Apply all finders in `finders' multiple times
			-- until fix point in `functions' is reached
		local
			l_fix_point_reached: BOOLEAN
			l_cursor: CURSOR
			l_finders: like finders
			l_found_functions: like functions
			l_finder: EPA_FUNCTION_FINDER
			l_existing_functions: like functions
			l_newly_added: like newly_added_functions
			l_new_exprs: like functions
			l_round: INTEGER
		do
				-- Create an empty function set.			
			functions := new_function_set
			l_found_functions := functions

			create l_existing_functions.make (a_repository.count)
			l_existing_functions.set_equality_tester (function_equality_tester)
			l_existing_functions.append (a_repository)

				-- Iterate through `finders' multiple times until
				-- fix point of the function set is reached.
			l_finders := finders
			l_cursor := l_finders.cursor
			from
				l_fix_point_reached := False
			until
				l_fix_point_reached or (max_round > 0 implies l_round > max_round)
			loop
				create newly_added_functions.make (100)
				l_newly_added := newly_added_functions
				l_newly_added.set_equality_tester (function_equality_tester)

					-- One round of applying `finders'.
				from
					l_fix_point_reached := True
					l_finders.start
				until
					l_finders.after
				loop
					l_finder := l_finders.item_for_iteration
					l_finder.search (l_existing_functions)
					l_new_exprs := l_finder.functions
					if not l_new_exprs.is_empty then
						l_found_functions.append_last (l_new_exprs)
						l_existing_functions.append_last (l_new_exprs)
						l_newly_added.append_last (l_new_exprs)
						l_fix_point_reached := False
					end
					l_finders.forth
				end

					-- Notify that there is are functions added into
					-- `functions' in this round.
				if not l_fix_point_reached then
					new_function_added_actions.call ([l_newly_added])
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

	newly_added_functions: detachable like functions
			-- The set of functions that are added into `functions'
			-- by the last round of searching, with one round meaning applying all `finders'.
			-- Empty before the first round of searching.

end
