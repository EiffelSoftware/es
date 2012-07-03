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
	PS_COMPLEX_PART

inherit{NONE}
	REFACTORING_HELPER

create make_with_mode, make_new


feature {PS_EIFFELSTORE_EXPORT}

	attributes: LINKED_LIST[STRING]

	attribute_values: HASH_TABLE [PS_OBJECT_GRAPH_PART, STRING]

	get_value (attr:STRING):PS_OBJECT_GRAPH_PART
		require
			has_attribute: attributes.has (attr)
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

	break_dependency (dependency: PS_OBJECT_GRAPH_PART)
		-- Break the dependency `dependency'
		local
			new_update:PS_SINGLE_OBJECT_PART
			attr:STRING
		do
			create new_update.make_new (represented_object, metadata, is_persistent, root)
			new_update.internal_initialize (write_mode.update)
			attr:= get_attribute_name (dependency)
			new_update.add_attribute (attr, dependency)
			root.add_dependency (new_update)

			attribute_values.remove (attr)
			attributes.prune_all (attr)
		end

	internal_initialize (operation:PS_WRITE_OPERATION)
		do
			write_mode:= operation
			is_initialized:=True
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
			if not attached {PS_IGNORE_PART} value then
				attributes.extend (name)
				attribute_values.extend (value, name)
			end
		end


feature {NONE} -- Initialization

	is_collection:BOOLEAN
		-- Is `Current' an instance of PS_COLLECTION_PART?


	make
		do
			create attributes.make
			attributes.compare_objects
			create attribute_values.make (hashtable_size)
		end


	make_with_mode (an_object:PS_OBJECT_IDENTIFIER_WRAPPER; a_mode: PS_WRITE_OPERATION; a_root:PS_OBJECT_GRAPH_ROOT)
		do
			internal_object_id:=an_object
			represented_object:= an_object.item
			write_mode:=a_mode
			make
			internal_metadata:= object_id.metadata
			root:= a_root
		end


	make_new (obj:ANY; a_metadata:PS_TYPE_METADATA; persistent:BOOLEAN; a_root:PS_OBJECT_GRAPH_ROOT)
		do
			represented_object:= obj
			create write_mode
			write_mode:= write_mode.no_operation
			internal_metadata:= a_metadata
			is_persistent:= persistent
			root:= a_root
			make
		end

feature {PS_EIFFELSTORE_EXPORT} -- Initialization

	finish_initialization (disassembler:PS_OBJECT_DISASSEMBLER)
		local
			i:INTEGER
			reflection:INTERNAL
			next_persistent, new_mode: BOOLEAN
			operation:PS_WRITE_OPERATION
		do
			operation:= disassembler.active_operation
			write_mode:= operation
			from
				create reflection
				i:= 1
			until
				i > reflection.field_count (represented_object)
			loop
				add_attribute (reflection.field_name (i, represented_object), disassembler.next_object_graph_part (reflection.field (i, represented_object), Current, write_mode))
				i:= i+1
			end

			across attributes as cursor loop
				next_persistent:= get_value(cursor.item).is_persistent
				get_value (cursor.item).initialize (disassembler.next_level (level, is_persistent, get_value(cursor.item).is_collection, next_persistent), disassembler.next_operation (level, is_persistent, next_persistent), disassembler)
			end
		end

	hashtable_size:INTEGER = 20



end
