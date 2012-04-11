indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HTML_UNORDERED_LIST

inherit
	HTML_LIST

create
	make


feature --Creation

	make is
			-- creation procedure
		do
			create elements.make
		end


feature -- out feature: giving STRING representation

	list_start_out:STRING is
			-- list start tag
		do
			Result:=unordered_list_start
		end

	list_end_out:STRING is
			-- list end tag
		do
			Result:=unordered_list_end
		end

	body_out: STRING is
			-- out of main list items
		do
			Result:="";
			from elements.start
			until elements.after
			loop
				Result.append(entry_start)
				Result.append(elements.item)
				Result.append(entry_end)
				Result.append(newline)
				elements.forth
			end
		end



invariant
	invariant_clause: True -- Your invariant here

end
