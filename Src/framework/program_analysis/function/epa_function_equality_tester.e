note
	description: "Equality tester for {CI_FUNCTION}"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FUNCTION_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [EPA_FUNCTION]
		redefine
			test
		end

feature -- Status report

	test (v, u: EPA_FUNCTION): BOOLEAN
		local
			l_u_cur: CURSOR
			l_v_cur: CURSOR
			l_u_types: LINKED_LIST [TYPE_A]
			l_v_types: LINKED_LIST [TYPE_A]
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
					-- Case sensitive comparison is used here,
					-- although insensitive comparion also suffice.
				if v.body ~ u.body and then v.arity = v.arity then
					l_u_types := u.types
					l_v_types := v.types
					l_u_cur := l_u_types.cursor
					l_v_cur := l_v_types.cursor
					Result := True
					from
						l_v_types.start
						l_u_types.start
					until
						l_v_types.after or else not Result
					loop
						Result := l_v_types.item_for_iteration.is_equivalent (l_u_types.item_for_iteration)
						l_v_types.forth
						l_u_types.forth
					end
					l_v_types.go_to (l_v_cur)
					l_u_types.go_to (l_u_cur)
				end
			end
		end

end
