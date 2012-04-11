indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	HTML_LIST

inherit
	HTML_LIST_CONSTANTS
	undefine
		out
	end





feature -- Adding Elements
	add_element(el:STRING) is
			-- add element in front of the list

		do
			elements.extend (el)
		end

	add_element_at_position(el:STRING;pos:INTEGER) is
			-- add element at position
		local
			j,i:INTEGER

		do
			i:= elements.count
			elements.extend (elements.i_th (pos))
			from j:=0
			until j=(i-pos)
			loop
				elements.extend (elements.i_th (pos+1))
				elements.go_i_th (pos)
				elements.remove_right
				j:=j+1
			end
			elements.put_i_th (el, pos)
		end

	remove_all_elements is
			-- remove all elements
		do
			elements.wipe_out
		end

	remove_element_by_name (el:STRING) is
			-- remove elements by name
		do
			from elements.start
			until elements.item.is_equal (el)
			loop
				elements.forth
			end
			elements.remove
		end

	remove_element_by_index (pos:INTEGER) is
			-- remove elements by position
		do
			elements.go_i_th (pos)
			elements.remove
		end

	add_class(s:STRING) is
			-- add the attribute "class" to the whole list
		do
			attr_class := s
		end



feature -- Elements out: provides STRING representation


	out: STRING is
			-- Provide a STRING representation for the current table
		do
			Result:= list_start_out
			Result.append(attributes_out);
			Result.append(Tag_end);
			Result.append(NewLine);
			Result.append(body_out);
			Result.append(list_end_out);
		end;

feature {NONE} -- Elements out helpers	

	list_start_out: STRING is
			-- list start tag out

			deferred
			end

	body_out: STRING is

		deferred
		end

	attributes_out: STRING is
			-- String representation for the attributes
			-- of the table

		do
			Result:=""
			if attr_class /= Void and then attr_class /= "" then
				Result.append (" class=%""+attr_class+"%" ")
			end
		end


	list_end_out: STRING is
			-- list end tag out

		deferred
		end


feature {NONE} -- Implementation

	elements: LINKED_LIST[STRING]

	attr_class : STRING

invariant
	invariant_clause: True -- Your invariant here

end
