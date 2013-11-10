-- Probably not needed. (See {CA_CFG_RULE}.)

note
	description: "Summary description for {CA_BACKWARD_FEATURE_ITERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_BACKWARD_FEATURE_ITERATOR

inherit
	AST_ITERATOR
		redefine
			process_eiffel_list
		end

feature {NONE} -- Implementation

	process_eiffel_list (a_list: EIFFEL_LIST[AST_EIFFEL])
		local
			l_cursor: INTEGER
		do
			from
				l_cursor := a_list.index
				a_list.finish
			until
				a_list.before
			loop
				if attached a_list.item as l_item then
					l_item.process (Current)
				else
					check False end
				end
				a_list.back
			end
			a_list.go_i_th (l_cursor)
		end

end
