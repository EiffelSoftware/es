note
	description: "Summary description for {APPLICATION_ENVIRONMENT_RESOLVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION_ENVIRONMENT_RESOLVER

inherit
	APPLICATION_RESOLVER

	SHARED_EXECUTION_ENVIRONMENT

feature -- Access

	expanded_variable (a_expr: READABLE_STRING_GENERAL): detachable READABLE_STRING_GENERAL
			-- <Precursor/>
		local
			i,j: INTEGER
			vn: READABLE_STRING_GENERAL
			dft: detachable READABLE_STRING_GENERAL
			c: CHARACTER_32
			l_is_set_and_non_empty: BOOLEAN
			err: BOOLEAN
		do
			dft := Void
			vn := a_expr

			i := a_expr.index_of (':', 1)
			if i > 1 then
				l_is_set_and_non_empty := True
				c := a_expr [i + 1]
				vn := a_expr.substring (1, i - 1)
				dft := a_expr.substring (i + 2, a_expr.count)
				err := c /= '-'
			else
				j := a_expr.index_of ('-', 1)
				if j > 0 then
					vn := a_expr.substring (1, i - 1)
					dft := a_expr.substring (i + 1, a_expr.count)
				end
			end
			if err then
					-- TODO: handle error ...
			elseif attached execution_environment.item (vn) as v then
				if l_is_set_and_non_empty and v.is_empty then
					Result := dft
				else
					Result := v
				end
			else
				Result := dft
			end
		end

note
	copyright: "2011-2024, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
