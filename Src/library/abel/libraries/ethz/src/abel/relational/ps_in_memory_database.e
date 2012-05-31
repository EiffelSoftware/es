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

	retrieve (class_name:STRING; criteria:PS_CRITERION; attributes:LIST[STRING]; transaction:PS_TRANSACTION) : ITERATION_CURSOR[PS_PAIR [INTEGER, HASH_TABLE[STRING, STRING]]]
		-- Retrieves all objects of class `class_name' that match the criteria in `criteria' within transaction `transaction'.
		-- If `atributes' is not empty, it will only retrieve the attributes listed there.
		local
			result_list: LINKED_LIST[PS_PAIR [INTEGER, HASH_TABLE[STRING, STRING]]]
			pair:PS_PAIR [INTEGER, HASH_TABLE[STRING, STRING]]
		do
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
					existing_values.replace (basic.value.out, attr_name.item)
				elseif attached {PS_COMPLEX_ATTRIBUTE_PART} an_object.attribute_values.at (attr_name.item) as complex then
					existing_values.replace (complex.object_id.object_identifier.out, attr_name.item)
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

	insert_collection (a_collection: PS_COLLECTION_PART[ITERABLE[ANY]]; a_transaction:PS_TRANSACTION)
		-- Add all entries in a_collection to the database
		do
		end

--	update_collection (a_collection: PS_COLLECTION_PART[ITERABLE[ANY]]; a_transaction:PS_TRANSACTION)
		-- Update a_collection (replace with any pre-existing collection)
--		do
--		end

	delete_collection (a_collection: PS_COLLECTION_PART[ITERABLE[ANY]]; a_transaction:PS_TRANSACTION)
		-- Delete a_collection from the database
		do
		end


	-- How to access the data?
	-- Queries: CLASS_NAME (+ Criteria) -> Cursor of primary keys (or actual data)
	-- Reload: Key -> Object

	-- Update: Key, Object ->
	-- Insert: Object ->
	-- Delete: Key ->


	-- HASH_TABLE [LIST[INTEGER] (key), STRING (class_name) ]
	-- HASH_TABLE [HASH_TABLE [STRING (Value), STRING (attr_name)], INTEGER (key) ]


	internal_db:HASH_TABLE[HASH_TABLE[ STRING, STRING], INTEGER]
		-- The internal data store. First key is the POID, and second key is the attribute name

	class_to_object_keys: HASH_TABLE [attached LIST[INTEGER], STRING]

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
		end

	db_size:INTEGER = 100




end
