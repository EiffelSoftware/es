note
	description: "Pair with an expression and an expression list."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SORTABLE_EXPRESSION_LIST
inherit
	COMPARABLE
create
	make

feature -- Initialization

	make (k: EXPRESSION; l: SORTED_TWO_WAY_LIST [EXPRESSION])
			-- Set up with key `k' and list `l'
		do
			key := k
			list := l
		end

feature -- Access

	key: EXPRESSION
			-- Base expression, serves as key.

	list: SORTED_TWO_WAY_LIST [EXPRESSION]
			-- Associated list of expressions.

feature -- Comparison

	is_less alias "<" (sel: SORTABLE_EXPRESSION_LIST): BOOLEAN
			-- Is key less than the key of `sel'?
		do
			Result := (key < sel.key)
		end

	is_same (other: SORTABLE_EXPRESSION_LIST): BOOLEAN
			-- Are current list and `other' considered equal?
		local
			other_list: SORTED_TWO_WAY_LIST [EXPRESSION]
		do
			if key ~ other.key then
				other_list := other.list
				from
					list.start ; other_list.start ; Result := True
				until
					(not Result) or list.after
				loop
					if other_list.after then
						Result := False
					else
						Result := (list.item ~ other_list.item)
						list.forth ; other_list.forth
					end
				end
				Result := Result and other_list.after
			end
		end
invariant

	key_exists: key /= Void
	list_exists: list /= Void

end
