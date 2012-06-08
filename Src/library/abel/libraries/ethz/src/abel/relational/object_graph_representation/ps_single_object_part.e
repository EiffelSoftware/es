note
	description:
		"[
			Represents a single object in an object graph.
		
			This class encapsulates all information needed to perform a write operation.
			Only the values in the `attributes' lists actually get inserted/updated.
			Any other values that might be present in the object will be ignored (this allows to leave current 
			DB entries "untouched", and later to define non-persistent attributes to an object)

		]"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_SINGLE_OBJECT_PART

inherit
	PS_COMPLEX_ATTRIBUTE_PART

create make_with_mode


feature


--	metadata: PS_METADATA

--	basic_attributes: LINKED_LIST[STRING]

--	basic_attribute_values: HASH_TABLE [ANY, STRING]

--	references: LINKED_LIST[STRING]

--	reference_values: HASH_TABLE [PS_OBJECT_GRAPH_PART, STRING]

	attributes: LINKED_LIST[STRING]

	attribute_values: HASH_TABLE [PS_OBJECT_GRAPH_PART, STRING]

	get_value (attr:STRING):PS_OBJECT_GRAPH_PART
		do
			Result:= attach (attribute_values[attr])
		end

	dependencies:LINKED_LIST[PS_OBJECT_GRAPH_PART]
		do
			create Result.make
			from attribute_values.start	until attribute_values.after
			loop
				if not attribute_values.item_for_iteration.is_basic_attribute then
					Result.extend (attribute_values.item_for_iteration)
				end
				attribute_values.forth
			end
		end

	remove_dependency (obj:PS_OBJECT_GRAPH_PART)
		-- Remove dependency `obj' from the list
		do
--			print (obj)
			from attributes.start
			until attributes.after
			loop
--				print (attributes.item.out + "%N")
				if attached attribute_values.item (attributes.item_for_iteration) as item then
--					print (item)
					if  item.is_equal( obj )then
						attribute_values.remove (attributes.item_for_iteration)
						attributes.remove
--						print ("removed%N")
					else
						attributes.forth
					end
				else
					attributes.forth
				end
			end
		end

	get_attribute_name (value: PS_OBJECT_GRAPH_PART):STRING
		-- Get the attribute name of a dependeny
		local
			found:BOOLEAN
		do
			from
				attributes.start
				found:=False
				Result:=""
			until attributes.after or found
			loop
				if attached attribute_values.item (attributes.item_for_iteration) as val and then val = value then
					Result:=attributes.item_for_iteration
					found:=True
				end
				attributes.forth
			end
		end


	add_attribute (name:STRING; value:PS_OBJECT_GRAPH_PART)
		-- add an attribute to the object (only if it should not be ignored)
		do
			if attribute_values.count *2  >= attribute_values.capacity * 3 then
				attribute_values.accommodate (attribute_values.capacity * 2)
			end

			if not attached {PS_IGNORE_PART} value then
				attributes.extend (name)
				attribute_values.extend (value, name)
			end
		end


feature {NONE} -- Initialization

	make
		do
--			create basic_attributes.make
--			create references.make
--			create basic_attribute_values.make (hashtable_size)
--			create reference_values.make (hashtable_size)
			create attributes.make
			create attribute_values.make (hashtable_size)

		end


	make_with_mode (an_object:PS_OBJECT_IDENTIFIER_WRAPPER; a_mode: PS_WRITE_OPERATION)
		do
			object_id:=an_object
			write_mode:=a_mode
			make
		end


	hashtable_size:INTEGER = 20



end
