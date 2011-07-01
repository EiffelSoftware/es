note
	description: "[
		This class represents annotations associated with a break point location
		from some AST node.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ANN_ANNOTATION

inherit
	EPA_SHARED_EQUALITY_TESTERS

	HASHABLE

	DEBUG_OUTPUT

	OBJECT_IDENTIFIER_HELPER

	ANN_ANNOTATION_HELPER

feature -- Access

	breakpoints: DS_HASH_SET [INTEGER]
			-- Set of program locations (breakpoint slots)
			-- on which current annotation covers.
			-- All the breakpoints must be included, not only the
			-- first and the last breakpoints covering certain
			-- code block. For example, for an if-statement, you
			-- can specify only breakpoints in one branch to mean that
			-- current annotation only covers that branch. Or you can
			-- specify breakpoints from both branches to mean that
			-- current annotation covers both.
			-- The breakpoint numbers inside this set are absolute breakpoints.
			-- That means if there is inheried preconditions, there breakpoints
			-- should count (so the first line in the feature is not 1 anymore).
		do
			if locations_breakpoints = Void then
				create locations_breakpoints.make (5)
			end
			Result := locations_breakpoints
		ensure
			good_result: Result = locations_breakpoints
		end

	first_breakpoint: INTEGER
			-- First breakpoint in `breakpoints'
		require
			breakpoint_exists: not breakpoints.is_empty
		local
			l_cursor: like breakpoints.new_cursor
			l_has_result: BOOLEAN
		do
			from
				l_cursor := breakpoints.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if l_has_result then
					if l_cursor.item < Result then
						Result := l_cursor.item
					end
				else
					Result := l_cursor.item
				end
				l_cursor.forth
			end
		end

	last_breakpoint: INTEGER
			-- Last breakpoint in `breakpoints'
		require
			breakpoint_exists: not breakpoints.is_empty
		local
			l_cursor: like breakpoints.new_cursor
		do
			from
				l_cursor := breakpoints.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if l_cursor.item > Result then
					Result := l_cursor.item
				end
				l_cursor.forth
			end
		end

feature{NONE} -- Implementation

	locations_breakpoints: like breakpoints
			-- Cache for `breakpoints'

end
