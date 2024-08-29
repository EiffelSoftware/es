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
			c: CHARACTER_32
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
					if i < n then
						i := i + 1
						if s [i] = '{' then
							j := s.index_of ('}', i + 1)
							if j > i then
								vn := s.substring (i + 1, j - 1)
								if attached expanded_variable (vn) as v then
									Result.append_string_general (v)
								else
									Result.extend ('$')
									Result.extend ('{')
									Result.append_string_general (vn)
									Result.extend ('}')
								end
								i := j
							end
						end
					else
						Result.extend (c)
					end
				else
					Result.extend (c)
				end
				i := i + 1
			end
		end

	expanded_variable (a_expr: READABLE_STRING_GENERAL): detachable READABLE_STRING_GENERAL
			-- Expand `a_expr`
			-- Supporting:
			-- 	${VARNAME}          -> value of VAR
			-- 	${VARNAME:-default} -> value of VAR if set and non-empty, otherwise default
			-- 	${VARNAME-default}  -> value of VAR if set, otherwise default
		deferred
		end

note
	copyright: "2011-2024, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
