note
	description: "Serialization/Deserialization class. Uses a custom, human-readable format"
	author: "Teseo Schneider, Marco Piccioni"
	date: "08.04.2009"

class
	SERIALIZER

	create
		make,
		make_with_config_path

feature {NONE} -- Implementation

	internal_util: INTERNAL
		-- Utility class

	file: PLAIN_TEXT_FILE
		-- File used to read and write objects.

	objects_serialized: ARRAYED_LIST [ANY]
		-- Container of all the serialized objects.

	objects_deserialized: DS_HASH_TABLE [ANY,INTEGER]
		-- Contains all objects associated with an id at deserialization.

	id: INTEGER
		-- Object id, used for serialization.

	ids: ARRAYED_LIST [INTEGER]
		-- Id's for all classes.

	names: ARRAYED_LIST [INTEGER]
		-- Names for all classes.

	versions: ARRAYED_LIST [INTEGER]
		-- Versions for all classes.

	variables: DS_HASH_TABLE [ANY,STRING]
		-- All variables.

	schema_evolution_handlers_table: DS_HASH_TABLE[SCHEMA_EVOLUTION_HANDLER,STRING]
		-- Table with all the object schema evolution handlers.

feature -- Utilities

	config_path: STRING
		-- The configuration file path.

feature -- Creation features

	make_with_config_path (path: STRING)
			--  Create with a user-defined path.
		require
			path_not_empty: path /= Void and then not path.is_empty
		do
			create internal_util
			config_path := path
		ensure
			config_path_set: config_path = path
			internal_created: internal_util /= Void
		end

	make
			-- Create with default configuration path (config.cfg in the root directory).
		do
			make_with_config_path ("config.cfg")
		end

feature --Serialization

	serialize (obj: ANY)
			-- Serialize obj and read the path in the config file.
		require
			object_exists: obj /= Void
		do
			serialize_with_path (obj, save_path + internal_util.class_name (obj))
		end

	serialize_with_path (obj: ANY; path: STRING)
			-- Serialize obj at path.
		require
			path_exists: path /= Void and then not path.is_empty
			object_not_void: obj /= Void
		local
			serial_temp: STRING
				-- Store the content of the serialization.
		do
			create objects_serialized.make (1)
				-- table of all objects creation.
			id := 1
			serial_temp := create_string (obj, "")
				-- call the recursive function `create_string'
			create file.make_open_write (path)
			file.put_string (serial_temp)
			file.close
				-- Open the file, write the string representation of the objects and close the file.
		ensure
			file_closed: file.is_closed
		end

feature -- Deserialization

	deserialize_with_default_path (file_name: STRING): ANY
			-- Deserialize an object given a file name (path read in configuration file).
		require
			not_empty_file_name: file_name /= Void and then not file_name.is_empty
		do
			Result := deserialize_with_path (save_path + file_name)
		end

	deserialize_object (obj: ANY): ANY 
			-- Deserialize obj (pick the class name from obj).
		require
			object_not_void: obj /= Void
		do
			Result := deserialize_with_path (save_path + internal_util.class_name (obj))
		end

	deserialize_with_path (path: STRING): ANY
			-- Deserialize an object at path.
		require
			path_exists: path /= Void and then not path.is_empty
		do
			create ids.make (1)
			create names.make (1)
			create versions.make (1)
			create objects_deserialized.make_default
				--create all tables
			id := 1
			ids.force (1)
			create file.make_open_read (path)
			file.start
			variables := create_hash_table
				--creation the hash tables for all variables
			file.close
			Result := create_objects (variables)
				--creation of all the objects
		ensure
			file_closed: file.is_closed
		end

feature -- Deserialization with schema evolution handler

	deserialize_patch_with_default_path (file_name: STRING; table: DS_HASH_TABLE [SCHEMA_EVOLUTION_HANDLER, STRING]): ANY
			-- Deserialize an object of a class with the given name (read path in configuration file)
		require
			file_name_exists: file_name /= Void and then not file_name.is_empty
			table_not_void: table /= Void
		do
			Result := deserialize_patch_with_path (save_path + file_name, table)
		end

	deserialize_patch_object (obj: ANY;  table: DS_HASH_TABLE [SCHEMA_EVOLUTION_HANDLER, STRING]): ANY
			-- deserialize an obj (pick the class name from the obj)
		require
			object_not_void: obj /= Void
			table_not_void: table /= Void
		do
			Result := deserialize_patch_with_path (save_path + internal_util.class_name (obj),  table)
		end

	deserialize_patch_with_path (path: STRING; table: DS_HASH_TABLE [SCHEMA_EVOLUTION_HANDLER, STRING]): ANY
			-- Deserialize an object at path.
		require
			path_exists: path/=Void and then not path.is_empty
			table_not_void: table/=Void
		do
			schema_evolution_handlers_table := table
			Result := deserialize_with_path (path)
		end

feature{NONE} --filter

	is_filtered_class (obj: ANY): BOOLEAN
			-- Does obj class already have a filter?
		require
			object_not_void: obj /= Void
		local
			test: FILTER_CLASS
		do
			test ?= obj

			Result := test /= Void
		end

	filter (obj: ANY): CUSTOM_SERIALIZATION_FILTER
			-- The filter
		local
			type: INTEGER
			tmp: FILTER_CLASS
		do
			tmp ?= obj
			if tmp /= Void then
				type := internal_util.dynamic_type_from_string (tmp.filter)
				Result ?= internal_util.new_instance_of (type)
				if Result /= Void then
					Result.initialize
				end
			end
		end

feature{NONE} -- Recursive functions for serialization

	create_string (obj: ANY; s: STRING): STRING
			-- Create the string representation of object obj (s is used for the recursive call).
		require
			not_void_string: s /= Void
			object_not_void: obj /= Void
		local
			attributes_num: INTEGER
				-- Number of object attributes
			i: INTEGER
				--iteration index
			value: ANY
				-- Attribute value.
			name: STRING
				-- Attribute name.
			type: INTEGER
				-- Attribute type.
			class_name: STRING
				-- The attribute class name.
			tmp: VERSIONED_CLASS
				--var for the cast
			--exception: EXCEPTIONS
				--exception
			is_filtered: BOOLEAN
				-- Is the class filtered?
			a_filter: CUSTOM_SERIALIZATION_FILTER
				--filter
			version: INTEGER
				--version
		do
			Result := s
				--pick the old string
			tmp ?= obj
			version := 1
			if tmp /= Void then
				version := tmp.version
			else
				print ("Informational message: class %"" + internal_util.class_name (obj) + "%" does not inherit from %"VERSIONED_CLASS%", so the current version number is set automatically to 1")
			end
			Result := Result + internal_util.class_name (obj) + ";" + version.out + "%N"
				--write id and version
			id := id + 1
				--increment the id
			is_filtered := is_filtered_class (obj)
				--test the filter
			objects_serialized.force (obj)
				--add to list of objects, to check if the obj exists
			attributes_num := internal_util.field_count (obj)
				--count the obj attributes
			from i := 1 until i > attributes_num loop
				--loop on all the attributes
				a_filter := filter (obj)
				name := internal_util.field_name (i, obj)
			if is_filtered and then a_filter /= Void and then a_filter.has (name) then
				--do nothing, just not save the attribute.
			else
				value := internal_util.field (i, obj)
					--pick the name and the value
				if value /= Void then --the field is not void
					type := internal_util.field_type (i, obj)
					class_name := internal_util.class_name (value)
					if not (is_reference(type) or class_name.substring (1, 9).is_equal ("STRING_32") or class_name.substring (1, 8).is_equal ("STRING_8")) then --not a primitive type
						--see if is not a reference or a string
						if objects_serialized.has (value) then
							Result := Result + name + ";from%N" + objects_serialized.index_of (value, 1).out + "%N"
								--if the object is in the system
						else --if is a new object
							--tmp?=value
								--try to cast to versioned class
							--if tmp/=Void then --if is a versioned class
								Result := Result + name + ";from%N" + id.out + "%N"
								--Result:=create_string (tmp, Result)
								Result := create_string (value, Result)
									--recursive call
							--else --not versioned class: exception...
							--	create exception
							--	exception.raise ("All the system classes must inherit from VERSIONED_CLASS")
							--end
						end
					else --string or basic types
						Result := Result + name + ";" + value.out + "%N"
							--simply add the value
					end
				else --field is void
					Result := Result + name + ";Void%N"
				end
			end
				i := i + 1
			end
		Result := Result + "end%N"
			--add an end for the end of the class
	end

feature{NONE} -- Recursive functions for deserialization

	create_hash_table: DS_HASH_TABLE [ANY, STRING]
			--creation of the hash table for all the field
		require
			ids_exists: ids /= Void
			names_exists: names /= Void
			versions_exist: versions /= Void
			file_is_open: not file.is_closed
		local
			current_string: STRING
				--current read string
			split: LIST [STRING]
				--splitted for ";"
			has_stopped: BOOLEAN
				-- Should I exit the loop?
			name: INTEGER
				--class name
			current_id: INTEGER
				--id of the class
			version: INTEGER
				--version of the class
		do
			create Result.make_default
			current_string := ""
			has_stopped := false
				--initialization
			file.read_line
			current_string := file.last_string
			split := current_string.split (';')
			name := internal_util.dynamic_type_from_string (split.i_th (1))
				--pick the class "name"
			version := split.i_th (2).to_integer
				--read the version
			names.force (name)
				--add to the name array
			versions.force (version)
				--add to the versions array
			from  until file.end_of_file or has_stopped loop --read the remaining info on file
				file.read_line
				current_string := file.last_string
					--read line
				split := current_string.split (';')
					--slip
				if split.count = 2 then	--if content a name and a value
					if split.i_th (2).is_equal ("from") then --is not a primitive type
						file.read_line
						current_string := file.last_string
						current_id := current_string.to_integer
							--read the id
						if ids.has (current_id) then --if the obj is already in the system
							Result.force (current_id, split.i_th (1))
								--add to the hash table the id
						else
							ids.force (current_id)
								--store the class id
							Result.force (create_hash_table, split.i_th (1))
								--recursive call
						end
					else --is a primitive type or a string
						Result.force (split.i_th(2),split.i_th (1))
							--simply add the 2 values
					end
				else
					has_stopped := true
						--if is not a value and a name (keyword `end') exit the loop
				end
			end
		end

	create_objects (table: DS_HASH_TABLE [ANY,STRING]): ANY
			--creation of all the objects, index current object (for the
			--ids, table for the recursive call)
		require
			ids_exist: ids /= Void
			table_exists: table /= Void
			names_exist: names /= Void
			versions_exist: versions /= Void
			objects_deserialized_exist: objects_deserialized /= Void
		local
			name,value: STRING
				-- Attribute name and value.
			tmp: DS_HASH_TABLE [ANY,STRING]
				-- Used for assignment attempt.
			obj_id: INTEGER
				-- Used for assignment attempt.
			attr, i: INTEGER
				-- number of attributes and index for the loop.
			exception: EXCEPTIONS
				-- exception
			current_name: INTEGER
				--class name
			current_version: INTEGER
				--current version
			serialized_version: INTEGER
				--serialized version
			current_id: INTEGER
				--id of the class
			set: BOOLEAN
				--if the field is already set
			a_filter: CUSTOM_SERIALIZATION_FILTER
				--the filter
			versioned_class: VERSIONED_CLASS
				-- Used for assignement attempt
		do
			current_name := names.i_th (id)
			current_id := ids.i_th(id)
			serialized_version := versions.i_th (id)
				--pick all the arguments

			Result := internal_util.new_instance_of (current_name)
				--creation of the current object

			current_version := 1
			versioned_class ?= Result
			if versioned_class /= Void then
				current_version := versioned_class.version
			end
				--read the obj version
			objects_deserialized.force (Result, current_id)
				--add the obj to the hash table
			attr := internal_util.field_count (Result)
				--count the attributes.
			from i := 1 until i > attr loop --loop into the filed
				set := false
				name := internal_util.field_name (i, Result)
					--pick the file name
				if current_version /= serialized_version and schema_evolution_handlers_table /= Void then
					set := handle_object_schema_evolution (internal_util.field_type (i, Result), Result, name, i, current_version, serialized_version)
					--set the value from the patch
				end
					--this check happens before the file reading: if in a new version same attributes can be set, the old version is read
				a_filter := filter (Result)
				if is_filtered_class (Result) and then a_filter /= Void and then a_filter.has (name) then
					set_attribute (internal_util.field_type (i, Result), Result, a_filter.value(name),i)
					set := true
					--set the value from the filter
				end
				if table.has (name) and (not set) then --if the name is in the hash table and the attribute is not set
					value ?= table.item (name)
						--try to cast to string
					if value = Void then --not a string
						tmp ?= table.item (name)
							--try to cast to hash table
						if tmp /= Void then
							--is a hash table
							id := id + 1
							internal_util.set_reference_field (i, Result, create_objects (tmp))
								--recursive call
						else
							--is an id object (integer)
							obj_id ?= table.item (name)
							internal_util.set_reference_field (i, Result, objects_deserialized.item (obj_id))
								--pick the existing object in the objects hash table (id is the key)
						end
					elseif value.is_equal ("Void") then --the value is a string and each value is `Void'
						internal_util.set_reference_field (i, Result, Void)
					elseif internal_util.field_type (i, Result)=internal_util.reference_type then
						--value is a reference type and not void (a string)
						set_string (Result, value, i)
					else
						 --value is a primitive type and not void (int, double, char,...)
						set_attribute (internal_util.field_type (i, Result), Result, value, i)
							--setting the field of the current obj (Result)
					end
				elseif not set then --not set and not in the saved file
					create exception
					exception.raise ("Cannot set attribute:" + name)
				end
				i := i + 1
			end
		end

feature{NONE} -- Utilities

	save_path: STRING
			-- Read the configuration file and get the path
		do
			create file.make_open_read (config_path)
			file.start
			file.read_line
			Result := file.last_string
			file.close
		ensure
			Result_not_void: Result/=Void
			File_closed: file.is_closed
		end

feature{NONE} -- Setters

	set_attribute (type: INTEGER; obj: ANY; generic_value: ANY; index: INTEGER)
			-- Set the attribute `index' of type `type' of object obj to value `generic_value'
		require
			value_exists: generic_value /= Void
			object_exists: obj /= Void
			positive_index: index > 0
		local
			exception: EXCEPTIONS
			value: STRING
				--the string representation of the value
		do
			value := generic_value.out
			-------------------------INTEGER---------------------------------
			if type = internal_util.integer_8_type and value.is_integer_8 then
				internal_util.set_integer_8_field (index, obj, value.to_integer_8)

			elseif type = internal_util.integer_16_type and value.is_integer_16 then
				internal_util.set_integer_16_field (index, obj, value.to_integer_16)

			elseif type = internal_util.integer_32_type and value.is_integer_32 then
				internal_util.set_integer_32_field (index, obj, value.to_integer_32)

			elseif type = internal_util.integer_64_type and value.is_integer_64 then
				internal_util.set_integer_64_field (index, obj, value.to_integer_64)
			--------------------------DOUBLE--------------------------------------
			elseif type = internal_util.double_type and value.is_double then
				internal_util.set_double_field (index, obj, value.to_double)
			---------------------------CHAR---------------------------------------
			elseif type = internal_util.character_8_type and value.count = 1 then
				internal_util.set_character_8_field (index, obj, value.area[1])

			elseif type = internal_util.character_32_type and value.count = 1 then
				internal_util.set_character_32_field (index, obj, value.area[1])
			---------------------------BOOLEAN-------------------------------------
			elseif type = internal_util.boolean_type and value.is_boolean then
				internal_util.set_boolean_field (index, obj, value.to_boolean)
			---------------------------NATURAL-------------------------------------
			elseif type = internal_util.natural_8_type and value.is_natural_8 then
				internal_util.set_natural_8_field (index, obj, value.to_natural_8)

			elseif type = internal_util.natural_16_type and value.is_natural_16 then
				internal_util.set_natural_16_field (index, obj, value.to_natural_16)

			elseif type = internal_util.natural_32_type and value.is_natural_32 then
				internal_util.set_natural_32_field (index, obj, value.to_natural_32)

			elseif type = internal_util.natural_64_type and value.is_natural_64 then
				internal_util.set_natural_64_field (index, obj, value.to_natural_64)
			---------------------------REAL------------------------------------
			elseif type = internal_util.real_32_type and value.is_real then
				internal_util.set_real_32_field (index, obj, value.to_real)
			---------------------------OBJ-----------------------------------
			elseif type = internal_util.reference_type then
				internal_util.set_reference_field (index, obj, generic_value)
			--------------------------------ELSE--------------------------------
			else
				create exception
				exception.raise ("The static and dynamic type of teh attribute are incompatible.")
			end
		end

	set_string (obj: ANY; value: STRING; index: INTEGER)
			-- set a string value
		require
			value_not_void: value /= Void
			object_not_void: obj /= Void
			positive_index: index > 0
		local
			string: STRING
				--tmp variable for the conversion
		do
			string := value
			internal_util.set_reference_field (index, obj, string)
				--try to set the 8 bit string
				--if the field is a 32 bit string, the string is converted
			rescue
				string := value.to_string_32
			retry
		end

feature{NONE} -- Schema evolution handling

	evaluate_default_value (type: INTEGER; obj: ANY; i: INTEGER; tmp: TUPLE [LIST [STRING],FUNCTION [ANY,TUPLE,ANY]])
			-- evaluate a value
		local
			vars: LIST [STRING]
				-- Names of attributes.
			f: FUNCTION [ANY,TUPLE [LIST [ANY]],ANY]
				-- Function.
			values: ARRAYED_LIST [ANY]
				-- Value of attributes to pass to the function.
			attributes: DS_HASH_TABLE [ANY,STRING]
				-- Attributes name and value pairs.
			index, max: INTEGER
				-- Indexes for iteration.
		do
			create attributes.make_default
			vars ?= tmp.item (1)
				--variables for the function (the attribute name of the current object, then values be used to calculate, with the function, the new attribute).
			f ?= tmp.item (2)
				--function
			create values.make (vars.count)
				--values of the vars
			max := internal_util.field_count (obj)

			from index := 1 until index > max loop
				attributes.force (internal_util.field (index, obj), internal_util.field_name (index, obj))
				index := index + 1
			end

			from vars.start until vars.after loop
				values.force (attributes.item (vars.item))
					-- Read the value and add the values to the array.
				vars.forth
			end

			set_attribute (type, obj, f.item ([values]), i)
				-- Evaluate the function and sets the field.
		end

feature {NONE} -- Schema evolution handler management.

	handle_object_schema_evolution (type: INTEGER; obj: ANY; field_name: STRING; index, current_version, serialized_version: INTEGER): BOOLEAN
			-- Check what the schema evolution handler for an object can do.
		require
			table_exists: schema_evolution_handlers_table /= Void
			obj_exists: obj/=Void
		local
			current_patch: SCHEMA_EVOLUTION_HANDLER
			tmp: DS_HASH_TABLE[TUPLE[LIST[STRING],FUNCTION[ANY,TUPLE,ANY]],STRING]
			tuple: TUPLE[LIST[STRING],FUNCTION[ANY,TUPLE,ANY]]
			exception: EXCEPTIONS
		do
			Result:=false
			if schema_evolution_handlers_table.has (internal_util.class_name (obj)) then --the current class can be pached
				current_patch := schema_evolution_handlers_table.item (internal_util.class_name (obj))
					--pick the class schema evolution handler

				tmp := current_patch.create_schema_evolution_handler (serialized_version, current_version)

				if tmp.has (field_name) then --if the schema evolution handler can handle the version change between current and serialized
					Result := true
					tuple := tmp.item (field_name)
					evaluate_default_value (type, obj, index, tuple)
				end
			else
					create exception
					exception.raise ("The schema evolution handler for the class: " + internal_util.class_name (obj) +
					" cannot handle the version change.")
			end
		end

feature{NONE} --type tests

	is_integer (type: INTEGER): BOOLEAN
			-- Is `type' an integer?
		do
			Result := internal_util.integer_16_type = type or internal_util.integer_32_type = type or internal_util.integer_64_type = type or internal_util.integer_8_type = type
		end

	is_double (type: INTEGER): BOOLEAN
			--  Is `type' a double?
		do
			Result := internal_util.double_type = type or internal_util.real_32_type = type
		end

	is_char (type: INTEGER): BOOLEAN
			--  Is type a character?
		do
			Result := internal_util.character_type = type
		end

	is_boolean (type: INTEGER): BOOLEAN
			--  Is `type' a booelan?
		do
			Result := internal_util.boolean_type = type
		end

	is_natural (type: INTEGER): BOOLEAN
			--  Is `type' a natural?
		do
			Result := internal_util.natural_16_type = type or internal_util.natural_32_type = type or internal_util.natural_64_type = type or internal_util.natural_8_type = type
		end

	is_reference (type: INTEGER): BOOLEAN
			-- Is `type' a reference or a string?
		do
			Result := is_integer (type) or is_double (type) or is_char (type) or is_boolean (type) or is_natural (type)
		end

feature -- setter

	set_config_path (path: STRING)
			-- Set the config path.
		do
			config_path := path
		end

invariant
	internal_util_exists: internal_util /= Void
	--patch_not_void: patch_table/=Void
	config_path_exists: config_path /= Void and then not config_path.is_empty
end
