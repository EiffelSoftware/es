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
		end

feature -- Access

	finders: LINKED_LIST [EPA_EXPRESSION_FINDER]
			-- List of expression finders which will find expressions
			-- according to different criteria

feature -- Basic operations

	search_expressions
			-- Search for expressions, make result available in `last_found_expression'.
		local
			l_emtpy_set: EPA_HASH_SET [EPA_EXPRESSION]
		do
			create l_emtpy_set.make (0)
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
		do
				-- Create an empty expression set.
			last_found_expressions := new_expression_set
			l_found_expressions := last_found_expressions

			create l_existing_expressions.make (a_expression_repository.count)
			l_existing_expressions.set_equality_tester (create {EPA_EXPRESSION_EQUALITY_TESTER})
			l_existing_expressions.append (a_expression_repository)

				-- Iterate through `finders' multiple times until
				-- fix point of the expression set is reached.
			l_finders := finders
			l_cursor := l_finders.cursor
			from
				l_fix_point_reached := False
			until
				l_fix_point_reached
			loop
				from
					l_fix_point_reached := True
					l_finders.start
				until
					l_finders.after
				loop
					l_finder := l_finders.item_for_iteration
					l_finder.search (l_existing_expressions)
					if not l_finder.last_found_expressions.is_empty then
						l_found_expressions.append_last (l_finder.last_found_expressions)
						l_existing_expressions.append_last (l_finder.last_found_expressions)
						l_fix_point_reached := False
					end
					l_finders.forth
				end
			end
			l_finders.go_to (l_cursor)
		end

end
