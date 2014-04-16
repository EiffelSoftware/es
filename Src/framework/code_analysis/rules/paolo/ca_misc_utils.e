note
	description: "Summary description for {CA_MISC_UTILS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CA_MISC_UTILS

feature -- String processing

	trim_string (a_string: STRING): STRING
		local
			l_temp: STRING
		do
			from
				Result := a_string.twin
			until
				Result ~ l_temp
			loop
				l_temp := Result.twin
				across trimmable_characters as ic loop
					Result.prune_all_leading (ic.item)
					Result.prune_all_trailing (ic.item)
				end
			end
		end

feature {NONE} -- Implementation

	trimmable_characters: ARRAY [CHARACTER]
		once
			Result := << ' ', '%T' >>
		end

end
