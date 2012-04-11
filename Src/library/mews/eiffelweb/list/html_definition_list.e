indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HTML_DEFINITION_LIST

inherit
	HTML_LIST

create
	make


feature {NONE} -- Initialization

	make is
			-- Initialize `Current'.
		do
			create elements.make
			create term_elements.make
		end

feature -- Access

	list_start_out:STRING is
			-- list start tag
		do
			Result:=definition_list_start
		end

	list_end_out:STRING is
			-- list end tag
		do
			Result:=definition_list_end
		end

	body_out: STRING is
			-- out of main list items
		do
			Result:="";
			from elements.start
			until elements.after
			loop
				if (term_elements.has (elements.item)) then
					Result.append(def_t_entry_start)
				else
					Result.append(def_d_entry_start)
				end
				Result.append(elements.item)
				if (term_elements.has (elements.item)) then
					Result.append(def_t_entry_end)
				else
					Result.append(def_d_entry_end)
				end
				Result.append(newline)
				elements.forth
			end
		end

feature -- element insertion

	add_term_element(el:STRING) is
			-- add definition list term element
		do
			add_element (el)
			term_elements.extend (el)
		end
	add_term_element_at_position(el:STRING;pos:INTEGER) is
			-- add definition list term element at position pos
		do
			add_element_at_position (el,pos)
			term_elements.extend (el)
		end


feature {NONE}-- variables

term_elements: LINKED_LIST[STRING]

invariant
	invariant_clause: True -- Your invariant here

end
