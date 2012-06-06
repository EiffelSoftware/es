note
	description: "Represents a freshly retrieved object consisting of strings only."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_RETRIEVED_OBJECT
inherit PS_EIFFELSTORE_EXPORT


create
	make

convert
	 to_old_format: {PS_PAIR [INTEGER_32, HASH_TABLE[STRING_8, STRING_8]]}

feature

	primary_key: INTEGER

	class_metadata: PS_CLASS_METADATA


	has_attribute (attr_name: STRING):BOOLEAN
		do
			Result:= basic_values.has (attr_name) or reference_values.has (attr_name)
		end


	basic_attribute (attribute_name: STRING):STRING
		do
			Result:= attach (basic_values[attribute_name])
		end

	foreign_key (attribute_name: STRING):PS_PAIR[INTEGER, STRING]
		do
			if reference_values.has (attribute_name) then
				Result:= attach (reference_values[attribute_name])
			else
				create Result.make (0, "")
			end

		end


	add_basic_attribute (name, value: STRING)
		do
			basic_values.extend (value, name)
		end

	add_foreign_key (attribute_name: STRING; key:INTEGER; class_type:STRING)
		local
			new_pair: PS_PAIR[INTEGER, STRING]
		do
			create new_pair.make (key, class_type)
			reference_values.extend (new_pair, attribute_name)
		end



feature -- conversion - should be replaced sometime!

	to_old_format: PS_PAIR [INTEGER, HASH_TABLE[STRING, STRING]]
		local
			string_hash: HASH_TABLE[STRING, STRING]
		do
			create string_hash.make (20)
			across basic_values.current_keys as key_cursor loop
				string_hash.extend (attach (basic_values[key_cursor.item]), key_cursor.item)
			end
			across reference_values.current_keys as key_cursor loop
				string_hash.extend (attach (reference_values[key_cursor.item]).first.out , key_cursor.item)
			end

			create Result.make (primary_key, string_hash)

		end


feature {NONE} -- Initialization

	basic_values: HASH_TABLE[STRING, STRING]

	reference_values: HASH_TABLE [PS_PAIR[INTEGER, STRING], STRING]


	make (key: INTEGER; class_data: PS_CLASS_METADATA)
			-- Initialization for `Current'.
		do
			primary_key:= key
			class_metadata:= class_data
			create basic_values.make (10)
			create reference_values.make (10)
		end

end
