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

	resolved_item (s: READABLE_STRING_GENERAL): STRING_32
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
								if attached execution_environment.item (vn) as v then
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

note
	copyright: "2011-2024, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
