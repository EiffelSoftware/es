note
	description: "Summary description for {APPLICATION_RESOLVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	APPLICATION_RESOLVER

feature -- Access

	resolved_item (s: READABLE_STRING_GENERAL): STRING_32
			-- Resolve `s` by expanding ${VARNAME}
			-- Supporting:
			-- 	${VARNAME}          -> value of VAR
			-- 	${VARNAME:-default} -> value of VAR if set and non-empty, otherwise default
			-- 	${VARNAME-default}  -> value of VAR if set, otherwise default
		local
			i,j,n: INTEGER
			prev,c: CHARACTER_32
			vn: READABLE_STRING_32
		do
			from
				i := 1
				n := s.count
				create Result.make (n)
			until
				i > n
			loop
				c := s [i]
				inspect c
				when '$' then
					if
						prev /= '\' and -- If $ is escaped ...
						i < n
					then
						if s [i + 1] = '{' then
							i := i + 1
							j := s.index_of ('}', i + 1)
							if j > i then
								vn := s.substring (i + 1, j - 1)
								if attached expanded_expression (vn) as v then
									Result.append_string_general (v)
								else
									Result.extend ('$')
									Result.extend ('{')
									Result.append_string_general (vn)
									Result.extend ('}')
								end
								i := j
							else
								Result.extend (c)
								Result.extend ('{')
							end
						else
							Result.extend (c)
						end
					else
						Result.extend (c)
					end
				else
					Result.extend (c)
				end
				i := i + 1
				prev := c
			end
		end

	expanded_expression (a_expr: READABLE_STRING_GENERAL): detachable READABLE_STRING_GENERAL
			-- Expand `a_expr`
			-- Supporting:
			-- 	${VARNAME}          -> value of VAR
			-- 	${VARNAME:-default} -> value of VAR if set and non-empty, otherwise default
			-- 	${VARNAME-default}  -> value of VAR if set, otherwise default
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
					vn := a_expr.substring (1, j - 1)
					dft := a_expr.substring (j + 1, a_expr.count)
				end
			end
			if err then
					-- TODO: handle error ...
			elseif attached expanded_variable (vn) as v then
				if l_is_set_and_non_empty and v.is_empty then
					Result := dft
				else
					Result := v
				end
			else
				Result := dft
			end
		end

	expanded_variable (vn: READABLE_STRING_GENERAL): detachable READABLE_STRING_GENERAL
		deferred
		end

note
	copyright: "2011-2024, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
