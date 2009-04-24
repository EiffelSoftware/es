indexing
	description: "Information on how to serialize objects.represents custom serialization [which attributes should be serialized]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SERIALIZED_FORM

create
	make

feature -- init

	make is
			-- init serialized form
		do
			create serialized_forms.make (5)
		end

feature -- Access


feature -- Status

	has_serialized_form (a_type_name: STRING): BOOLEAN is
			-- does a serialized_form exist for a_type_name
		require
			not_void:  a_type_name /= void
			not_empty:  not a_type_name.is_empty
		do
			Result := serialized_forms.has (a_type_name)
		end


feature -- Basic operations

	put_serialized_form (a_list: ARRAYED_LIST[STRING];a_type_name: STRING) is
			-- put 'a_list' for 'a_type_name' as new serialized form.
			-- if a serialized form already exists for a_type_name
			-- it gets replaced by this one
		require
			not_void: a_list /= void and a_type_name /= void
			not_empty: not a_list.is_empty and not a_type_name.is_empty
		local
			l_list: ARRAYED_LIST[STRING]
			l_name: STRING
		do
			-- prevent capturing
			create l_list.make_from_array (a_list)
			create l_name.make_from_string (a_type_name)

			-- insert
			if has_serialized_form(l_name) then
				serialized_forms.replace (l_list, l_name)
			else
				serialized_forms.extend (l_list, l_name)
			end
		end

	get_serialized_form (a_type_name: STRING): ARRAYED_LIST[STRING] is
			-- return serialized form for a_type_name
			-- returns void if none existend.
		require
			not_void:  a_type_name /= void
			not_empty:  not a_type_name.is_empty
		local
			l_list: ARRAYED_LIST[STRING]
		do
			if serialized_forms.has (a_type_name) then
				--prevent leaking
				create l_list.make_from_array (serialized_forms.item (a_type_name))

				Result := l_list
			else
				Result := void
			end
		end


feature {NONE} -- implementation

	serialized_forms: HASH_TABLE[ARRAYED_LIST[STRING],STRING]


end
