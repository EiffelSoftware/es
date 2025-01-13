note
	description: "Summary description for {BOOK}."
	date: "$Date$"
	revision: "$Revision$"

class
	BOOK

create
	make, make_with_id

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_32; a_description: READABLE_STRING_32; a_image: READABLE_STRING_32)
			-- Initialize object.
		do
				-- Initialize
			create id.make (Void)
			name := a_name
			description := a_description
			image := a_image
		ensure
			name_set: name.is_case_insensitive_equal (a_name)
			description_set: description.is_case_insensitive_equal (a_description)
			image_set: image.is_case_insensitive_equal (a_image)
		end


	make_with_id (a_id: READABLE_STRING_32; a_name: READABLE_STRING_32; a_description: READABLE_STRING_32; a_image: READABLE_STRING_32)
			-- Initialize object.
		do
				-- Initialize
			create id.make_with_string (a_id)
			name := a_name
			description := a_description
			image := a_image
		ensure
			name_set: name.is_case_insensitive_equal (a_name)
			description_set: description.is_case_insensitive_equal (a_description)
			image_set: image.is_case_insensitive_equal (a_image)
		end

feature -- Set ID

	set_id (a_id: READABLE_STRING_32)
		do
			create id.make_with_string (a_id)
		end


feature -- Access

	id: BSON_OID

	name: STRING_32

	description: STRING_32

	image: STRING_32

feature -- JSON

	to_json: JSON_VALUE
		local
			l_result: JSON_OBJECT
		do
			create l_result.make_empty
			l_result.put_string (id.oid_to_string, create {JSON_STRING}.make_from_string ("_id"))
			l_result.put_string (name, create {JSON_STRING}.make_from_string ("name"))
			l_result.put_string (description, create {JSON_STRING}.make_from_string ("description"))
			l_result.put_string (image, create {JSON_STRING}.make_from_string ("image"))
			Result := l_result
		end

	to_json_string: STRING_8
		do
			Result := to_json.representation
		end

end
