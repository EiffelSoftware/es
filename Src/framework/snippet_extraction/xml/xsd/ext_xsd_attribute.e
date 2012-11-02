note
	description: "Class to synthesize local attributes XML Schema definitions."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_XSD_ATTRIBUTE

inherit
	EXT_XML_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_name: like name)
			-- Initializaton with mandatory XML attribute "name".
		do
			name := a_name
		end

feature -- Access

	id: detachable IMMUTABLE_STRING_8
		assign set_id
			-- Value of "id" attribute.

	name: IMMUTABLE_STRING_8
		assign set_name
			-- Value of "name" attribute.

	type: detachable IMMUTABLE_STRING_8
		assign set_type
			-- Value of "type" attribute.

	attribute_form: detachable IMMUTABLE_STRING_8
		assign set_attribute_form
			-- Value of "form" attribute.

	attribute_use: detachable IMMUTABLE_STRING_8
		assign set_attribute_use
			-- Value of "use" attribute.

	default_value: detachable IMMUTABLE_STRING_8
		assign set_default_value
			-- Value of "default" attribute.

	fixed_value: detachable IMMUTABLE_STRING_8
		assign set_fixed_value
			-- Value of "fixed" attribute.

feature -- Configuration

	set_id (a_id: like id)
			-- Sets `id'.
		do
			id := a_id
		end

	set_name (a_name: like name)
			-- Sets `name'.
		do
			name := a_name
		end

	set_type (a_type: like type)
			-- Sets `type'.
		do
			type := a_type
		end

	set_attribute_form (a_form: like attribute_form)
			-- Sets `attribute_form'.
		do
			attribute_form := a_form
		end

	set_attribute_use (a_use: like attribute_use)
			-- Sets `attribute_use'.
		do
			attribute_use := a_use
		end

	set_default_value (a_value: like default_value)
			-- Sets `default_value'.
		do
			default_value := a_value
		end

	set_fixed_value (a_value: like fixed_value)
			-- Sets `fixed_value'.
		do
			fixed_value := a_value
		end

feature -- DEBUG OUTPUT

	debug_output: STRING
			-- String representation.
		do
			create Result.make_empty
		end

feature -- Implementation

	as_xml: XML_ELEMENT
			-- Process `Current' as local XML attribute.
		do
			create Result.make (Void, "attribute", xml_ns_xsd)

			if attached id then
				Result.add_unqualified_attribute ("id", id.as_string_32)
			end

			Result.add_unqualified_attribute ("name", name.as_string_32)

			if attached type then
				Result.add_unqualified_attribute ("type", type.as_string_32)
			end

			if attached attribute_form then
				Result.add_unqualified_attribute ("form", attribute_form.as_string_32)
			end

			if attached attribute_use then
				Result.add_unqualified_attribute ("use", attribute_use.as_string_32)
			end

			if attached default_value then
				Result.add_unqualified_attribute ("default", default_value.as_string_32)
			end

			if attached fixed_value then
				Result.add_unqualified_attribute ("fixed", fixed_value.as_string_32)
			end
		end

end
