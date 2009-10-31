note
	description: "State of a class"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_MODEL

inherit
	LINKED_LIST [AFX_STATE_ITEM]

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
	make_with_basic_argumentless_query

feature{NONE} -- Initialization

	make_with_basic_argumentless_query (a_class: CLASS_C)
			-- Initialize Current with argumentless
			-- qureies of basic types in `a_class'.
		local
			l_queries: LIST [FEATURE_I]
			l_item: AFX_EXPR_STATE_ITEM
		do
			l_queries := supported_queries_of_type (a_class.actual_type)
			from
				l_queries.start
			until
				l_queries.after
			loop
				create l_item.make_with_text (a_class, l_queries.item_for_iteration, l_queries.item_for_iteration.feature_name)
				l_item.set_name (l_queries.item_for_iteration.feature_name)
				extend (l_item)
				l_queries.forth
			end
		end

end
