note
	description: "State of a class"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_SKELETON

inherit
	DS_HASH_SET [AFX_EXPRESSION]

	AUT_OBJECT_STATE_REQUEST_UTILITY
		undefine
			is_equal,
			copy
		end

	SHARED_WORKBENCH
		undefine
			is_equal,
			copy
		end

create
	make,
	make_with_basic_argumentless_query,
	make_with_accesses

feature{NONE} -- Initialization

	make_with_basic_argumentless_query (a_class: CLASS_C)
			-- Initialize Current with argumentless
			-- qureies of basic types in `a_class'.
		local
			l_queries: LIST [FEATURE_I]
			l_item: AFX_AST_EXPRESSION
		do
			l_queries := supported_queries_of_type (a_class.actual_type)
			make (l_queries.count)
			from
				l_queries.start
			until
				l_queries.after
			loop
				create l_item.make_with_text (a_class, l_queries.item_for_iteration, l_queries.item_for_iteration.feature_name)
				l_item.set_name (l_queries.item_for_iteration.feature_name)
				force_last (l_item)
				l_queries.forth
			end
		end

	make_with_accesses (a_accesses: LIST [AFX_ACCESS])
			-- Initialize Current with `a_accesses'.
		local
			l_cursor: CURSOR
			l_expr: AFX_EXPRESSION
		do
			make (a_accesses.count)
			l_cursor := a_accesses.cursor
			from
				a_accesses.start
			until
				a_accesses.after
			loop
				l_expr := a_accesses.item_for_iteration.expression
				l_expr.set_name (l_expr.text)
				force_last (l_expr)
				a_accesses.forth
			end
			a_accesses.go_to (l_cursor)
		end

end
