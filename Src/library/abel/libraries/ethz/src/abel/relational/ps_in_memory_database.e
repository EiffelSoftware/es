note
	description: "Stores all object values in the main memory."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_IN_MEMORY_DATABASE

inherit
	PS_BACKEND_STRATEGY
	PS_EIFFELSTORE_EXPORT

create make

feature

	retrieve (type: PS_TYPE_METADATA; criteria:PS_CRITERION; attributes:LIST[STRING]; transaction:PS_TRANSACTION) : ITERATION_CURSOR[PS_PAIR [INTEGER, HASH_TABLE[STRING, STRING]]]
		-- Retrieves all objects of class `class_name' that match the criteria in `criteria' within transaction `transaction'.
		-- If `atributes' is not empty, it will only retrieve the attributes listed there.
		local
			class_name: STRING
			result_list: LINKED_LIST[PS_PAIR [INTEGER, HASH_TABLE[STRING, STRING]]]
			pair:PS_PAIR [INTEGER, HASH_TABLE[STRING, STRING]]
		do
			class_name:= type.class_of_type.name
			create result_list.make

			across attach (class_to_object_keys[class_name]) as obj_cursor
			loop
				create pair.make (obj_cursor.item, attach (internal_db[obj_cursor.item]))
				result_list.extend (pair)
			end

			Result:= result_list.new_cursor
		end



	insert (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Inserts the object into the database
		local
			class_name:STRING
			key:INTEGER
			values:HASH_TABLE[STRING,STRING]
			new_list:LINKED_LIST[INTEGER]
		do
			class_name:= an_object.object_id.class_name
			key:= an_object.object_id.object_identifier

			create values.make (an_object.attributes.count)
			across an_object.attributes as attr_name loop
				check attached an_object.attribute_values.at (attr_name.item) as ref then

					if attached{PS_BASIC_ATTRIBUTE_PART} ref as basic then
						values.extend (basic.value.out, attr_name.item)
					elseif attached {PS_COMPLEX_ATTRIBUTE_PART} ref as complex then
						values.extend (complex.object_id.object_identifier.out, attr_name.item)
					end

				end
			end

			internal_db.extend (values, key)
			if attached{LIST[INTEGER]} class_to_object_keys.at (class_name) as list then
				list.extend (key)
			else
				create new_list.make
				new_list.extend (key)
				class_to_object_keys.extend (new_list, class_name)
			end


		end

	update (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Updates an_object
		local
			existing_values:HASH_TABLE[STRING, STRING]
			i:INTEGER
		do
			existing_values := attach ( internal_db[an_object.object_id.object_identifier] )

			across an_object.attributes as attr_name
			from
				i:=an_object.attributes.count
			loop
				--print (i.out + "%N " + attr_name.item + "%N")
				if attached{PS_BASIC_ATTRIBUTE_PART} an_object.attribute_values.at (attr_name.item) as basic then
					existing_values.force (basic.value.out, attr_name.item)
				elseif attached {PS_COMPLEX_ATTRIBUTE_PART} an_object.attribute_values.at (attr_name.item) as complex then
					existing_values.force (complex.object_id.object_identifier.out, attr_name.item)
				end
				i:=i-1
			variant
				i
			end
		end

	delete (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Deletes an_object from the database
		do
			internal_db.remove (an_object.object_id.object_identifier)
			attach (class_to_object_keys[an_object.object_id.class_name]).prune (an_object.object_id.object_identifier)
		end



	insert_objectoriented_collection (a_collection: PS_OBJECT_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Add all entries in a_collection to the database
		local
			id: INTEGER
			new_inserts: LINKED_LIST[STRING]
		do
			id:= a_collection.object_id.object_identifier
			if not collections.has (id) then
				collections.extend (create{LINKED_LIST[STRING]}.make, id)
			end

			create new_inserts.make
			across a_collection.values as val loop
				if attached{PS_BASIC_ATTRIBUTE_PART} val.item as basic then
					new_inserts.extend (basic.value)
				elseif attached {PS_COMPLEX_ATTRIBUTE_PART} val.item as complex then
					new_inserts.extend (complex.object_id.object_identifier.out)
				end
			end

			attach (collections[id]).append (new_inserts) -- TODO: order

			collection_info.force (a_collection.additional_information, id)

		end

	delete_objectoriented_collection (a_collection: PS_OBJECT_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Delete a_collection from the database
		do
			collection_info.remove (a_collection.object_id.object_identifier)
			collections.remove (a_collection.object_id.object_identifier)
		end

	retrieve_objectoriented_collection (collection_type: PS_TYPE_METADATA; collection_primary_key: INTEGER; transaction: PS_TRANSACTION): PS_PAIR [LIST[STRING],HASH_TABLE[STRING, STRING]]
			-- Retrieves the object-oriented collection of type `object_type' and with primary key `object_primary_key'.
			-- The result is a list of values in correct order, with string representation of either foreign keys  or just basic types - depending on the generic argument of the collection.
			-- The hash table in the result pair is the additional information required by the handler, as given by a previous insert function.
	 	do
			create Result.make (attach (collections[collection_primary_key]) , attach (collection_info[collection_primary_key]))
	 	end



	string_representation:STRING
		-- The current DB content as a string
		local
			class_names: ARRAY[STRING]
			objects:LIST[INTEGER]
			object_values: HASH_TABLE[STRING, STRING]
		do
			class_names:= class_to_object_keys.current_keys
			Result := ""

			across class_names as class_cursor loop

				Result:= Result + "Current class: " + class_cursor.item + "%N%N"
				-- print each object of this class

				objects := attach (class_to_object_keys[class_cursor.item])
				across objects  as obj_cursor loop

					Result:= Result + "%T Object key: " + obj_cursor.item.out + "%N"
					object_values := attach ( internal_db[obj_cursor.item])

					across object_values.current_keys as key_cursor loop
						Result := Result + "%T%T" + key_cursor.item + ": " + attach (object_values[key_cursor.item]) + "%N"
					end
					Result:= Result + "%N%N"
				end
			end
		end

feature{NONE} -- Initialization

	make
		do
			create internal_db.make (db_size)
			create class_to_object_keys.make (db_size)
			create collection_handlers.make
			create collections.make (db_size)
			create collection_info.make (db_size)
		end

	db_size:INTEGER = 100


	internal_db:HASH_TABLE[HASH_TABLE[ STRING, STRING], INTEGER]
		-- The internal data store. First key is the POID, and second key is the attribute name

	class_to_object_keys: HASH_TABLE [attached LIST[INTEGER], STRING]

feature {NONE} -- Collection handling

	collections: HASH_TABLE[LINKED_LIST[STRING],INTEGER]
		-- Internal store of collection objects

	collection_info: HASH_TABLE [HASH_TABLE[STRING, STRING], INTEGER]
		-- The capacity of individual SPECIAL objects

end
