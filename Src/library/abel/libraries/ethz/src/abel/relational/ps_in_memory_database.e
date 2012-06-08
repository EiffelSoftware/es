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

feature {PS_EIFFELSTORE_EXPORT}

	retrieve (type: PS_TYPE_METADATA; criteria:PS_CRITERION; attributes:LIST[STRING]; transaction:PS_TRANSACTION) : ITERATION_CURSOR[PS_RETRIEVED_OBJECT]
		-- Retrieves all objects of class `class_name' that match the criteria in `criteria' within transaction `transaction'.
		-- If `atributes' is not empty, it will only retrieve the attributes listed there.
		local
	--		class_name: STRING
	--		result_list: LINKED_LIST[PS_PAIR [INTEGER, HASH_TABLE[STRING, STRING]]]
	--		pair:PS_PAIR [INTEGER, HASH_TABLE[STRING, STRING]]
			keys: ARRAY[INTEGER]
			current_obj: PS_RETRIEVED_OBJECT
			list: LINKED_LIST[PS_RETRIEVED_OBJECT]
			attr: LIST[STRING]
			ref:PS_PAIR[INTEGER, STRING]
		do
			keys:= attach (db[type.class_of_type.name]).current_keys
			create list.make

			across keys as obj_primary loop

				create current_obj.make (obj_primary.item, type.class_of_type)
				-- fill attributes
				if attributes.is_empty then
					attr:= type.attributes
				else
					attr:= attributes
				end
				across attr as cursor loop
					if type.attribute_type (cursor.item).is_basic_type then
						current_obj.add_attribute (cursor.item, get_basic_attribute (obj_primary.item, type.class_of_type.name, cursor.item), "BASIC")
					else
						if has_reference_attribute (obj_primary.item, type.class_of_type.name, cursor.item) then
							ref:= get_reference_attribute (obj_primary.item, type.class_of_type.name, cursor.item)
							current_obj.add_attribute (cursor.item, ref.first.out, ref.second)
						end
					end
				end


				list.extend (current_obj)

			end

			Result:=list.new_cursor

	--		class_name:= type.class_of_type.name
	--		create result_list.make

	--		across attach (class_to_object_keys[class_name]) as obj_cursor
	--		loop
	--			create pair.make (obj_cursor.item, attach (internal_db[obj_cursor.item]))
	--			result_list.extend (pair)
	--		end

	--		Result:= result_list.new_cursor
		end



	retrieve_from_keys (type: PS_TYPE_METADATA; primary_keys: LIST[INTEGER]; transaction:PS_TRANSACTION) : LINKED_LIST[PS_RETRIEVED_OBJECT]
		-- Retrieve all objects of type `type' and with primary key in `primary_keys'.
		local
			current_obj: PS_RETRIEVED_OBJECT
			attr: LIST[STRING]
			ref:PS_PAIR[INTEGER, STRING]
		do
			create Result.make

			across primary_keys as obj_primary loop

				create current_obj.make (obj_primary.item, type.class_of_type)
				attr:= type.attributes

				across attr as cursor loop
					if type.attribute_type (cursor.item).is_basic_type then
						current_obj.add_attribute (cursor.item, get_basic_attribute (obj_primary.item, type.class_of_type.name, cursor.item), "BASIC")
					else
						if has_reference_attribute (obj_primary.item, type.class_of_type.name, cursor.item) then
							ref:= get_reference_attribute (obj_primary.item, type.class_of_type.name, cursor.item)
							current_obj.add_attribute (cursor.item, ref.first.out, ref.second)
						end
					end
				end


				Result.extend (current_obj)

			end
		end


	insert (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Inserts the object into the database
		local
			class_name:STRING
			key:INTEGER
			values:HASH_TABLE[STRING,STRING]
			new_list:LINKED_LIST[INTEGER]
		do
			class_name:= new_key (an_object.object_id).second
			key:= new_key (an_object.object_id).first
			key_mapper.add_entry (an_object.object_id, key)

			insert_empty_object (key, class_name)


			create values.make (an_object.attributes.count)
			across an_object.attributes as attr_name loop
				check attached an_object.attribute_values.at (attr_name.item) as ref then

					if attached{PS_BASIC_ATTRIBUTE_PART} ref as basic then
						values.extend (basic.value.out, attr_name.item)

						add_basic_attribute (key, class_name, attr_name.item, basic.value.out)

					elseif attached {PS_COMPLEX_ATTRIBUTE_PART} ref as complex then
						values.extend (complex.object_id.object_identifier.out, attr_name.item)

						add_reference_attribute (key, class_name, attr_name.item, key_mapper.primary_key_of (complex.object_id))

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
			primary:PS_PAIR[INTEGER, PS_CLASS_METADATA]
		do
--			existing_values := attach ( internal_db[an_object.object_id.object_identifier] )

			primary:= key_mapper.primary_key_of (an_object.object_id)

			across an_object.attributes as attr_name
			from
				i:=an_object.attributes.count
			loop
				--print (i.out + "%N " + attr_name.item + "%N")
				if attached{PS_BASIC_ATTRIBUTE_PART} an_object.attribute_values.at (attr_name.item) as basic then
--					existing_values.force (basic.value.out, attr_name.item)

						remove_basic_attribute (primary.first, primary.second.name, attr_name.item)
						add_basic_attribute (primary.first, primary.second.name, attr_name.item, basic.value.out)


				elseif attached {PS_COMPLEX_ATTRIBUTE_PART} an_object.attribute_values.at (attr_name.item) as complex then
--					existing_values.force (complex.object_id.object_identifier.out, attr_name.item)

						remove_reference_attribute (primary.first, primary.second.name, attr_name.item)
						add_reference_attribute (primary.first, primary.second.name, attr_name.item, key_mapper.primary_key_of (complex.object_id))

				end
				i:=i-1
			variant
				i
			end
		end

	delete (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Deletes an_object from the database
		local
			primary:PS_PAIR[INTEGER, PS_CLASS_METADATA]
		do
			primary:= key_mapper.primary_key_of (an_object.object_id)

			attach (db[primary.second.name]).remove (primary.first)
			key_mapper.remove_primary_key (primary.first, an_object.object_id.metadata)


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
				elseif attached{PS_NULL_REFERENCE_PART} val.item as null then
					new_inserts.extend ("0")
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

	retrieve_objectoriented_collection (collection_type: PS_TYPE_METADATA; collection_primary_key: INTEGER; transaction: PS_TRANSACTION): PS_RETRIEVED_OBJECT_COLLECTION
			-- Retrieves the object-oriented collection of type `object_type' and with primary key `object_primary_key'.
			-- The result is a list of values in correct order, with string representation of either foreign keys  or just basic types - depending on the generic argument of the collection.
			-- The hash table in the result pair is the additional information required by the handler, as given by a previous insert function.
	 	do
			--create Result.make (attach (collections[collection_primary_key]) , attach (collection_info[collection_primary_key]))
			create Result.make (collection_primary_key, collection_type.class_of_type)
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
--			create collection_handlers.make
			create collections.make (db_size)
			create collection_info.make (db_size)
			create db.make (db_size)
			create key_mapper.make
			create key_set.make (100)
		end

	db_size:INTEGER = 100


	key_set:HASH_TABLE[INTEGER, STRING]

	new_key (obj:PS_OBJECT_IDENTIFIER_WRAPPER):PS_PAIR[INTEGER, STRING]
		local
			max:INTEGER
		do
			max:= key_set[obj.metadata.class_of_type.name]
			max:= max+1

			create Result.make (max, obj.metadata.class_of_type.name)
			key_set.force (max, obj.metadata.class_of_type.name)
		end


	insert_empty_object (key:INTEGER; class_name:STRING)
		local
		new_class: HASH_TABLE [ -- primary key to object
			PS_PAIR [ -- object
				HASH_TABLE[STRING, STRING], -- basic types
				HASH_TABLE[PS_PAIR[INTEGER, STRING],STRING]], -- reference types
			INTEGER]
		new_obj: PS_PAIR [ -- object
				HASH_TABLE[STRING, STRING], -- basic types
				HASH_TABLE[PS_PAIR[INTEGER, STRING],STRING]] -- reference types
		do
			if not db.has (class_name) then
				create new_class.make (100)
				db.extend (new_class, class_name)
			else
				new_class:= attach (db[class_name])
			end
			create new_obj.make (create {HASH_TABLE[STRING, STRING]}.make (10), create {HASH_TABLE[PS_PAIR[INTEGER, STRING],STRING]}.make (10))
			new_class.extend (new_obj, key)
		end



	has_reference_attribute (key: INTEGER; class_name:STRING; attr_name:STRING):BOOLEAN
		do
			Result:= get_obj_representation(class_name, key).second.has (attr_name)
		end


	get_reference_attribute (key: INTEGER; class_name:STRING; attr_name:STRING):PS_PAIR[INTEGER, STRING]
		do
			Result:= attach (get_obj_representation(class_name, key).second.item (attr_name))
		end

	get_basic_attribute (key:INTEGER; class_name, attr_name:STRING):STRING
		do
			Result:= attach (get_obj_representation(class_name, key).first.item (attr_name))

		end


	remove_reference_attribute (key: INTEGER; class_name:STRING; attr_name:STRING)
		do
			get_obj_representation(class_name, key).second.remove (attr_name)
		end

	remove_basic_attribute (key:INTEGER; class_name, attr_name:STRING)
		do
			get_obj_representation(class_name, key).first.remove (attr_name)
		end



	add_reference_attribute (key: INTEGER; class_name:STRING; attr_name:STRING; value:PS_PAIR[INTEGER, PS_CLASS_METADATA])
		local
			compat_value: PS_PAIR[INTEGER, STRING]
		do
			create compat_value.make (value.first, value.second.name)
			get_obj_representation(class_name, key).second.extend (compat_value, attr_name)
		end

	add_basic_attribute (key:INTEGER; class_name, attr_name:STRING; value:STRING)
		do
			get_obj_representation(class_name, key).first.extend (value, attr_name)
		end


	get_obj_representation (class_name:STRING; key:INTEGER):PS_PAIR [HASH_TABLE[STRING, STRING], -- basic types
															 HASH_TABLE[PS_PAIR[INTEGER, STRING],STRING]] -- reference types
		do
			Result:= attach (attach (db[class_name]).item(key))
		end


	db: HASH_TABLE [ -- class_name to objects table
		HASH_TABLE [ -- primary key to object
			PS_PAIR [ -- object
				HASH_TABLE[STRING, STRING], -- basic types
				HASH_TABLE[PS_PAIR[INTEGER, STRING],STRING]], -- reference types
			INTEGER] ,
		STRING]



	internal_db:HASH_TABLE[HASH_TABLE[ STRING, STRING], INTEGER]
		-- The internal data store. First key is the POID, and second key is the attribute name

	class_to_object_keys: HASH_TABLE [attached LIST[INTEGER], STRING]




feature {NONE} -- Collection handling

	collections: HASH_TABLE[LINKED_LIST[STRING],INTEGER]
		-- Internal store of collection objects

	collection_info: HASH_TABLE [HASH_TABLE[STRING, STRING], INTEGER]
		-- The capacity of individual SPECIAL objects

end
