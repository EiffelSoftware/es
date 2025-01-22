note
	description: "[
		Constants representing BSON binary subtypes.
		These values indicate the subtype of a BSON binary element.
		See: http://bsonspec.org/ for more information on BSON binary subtypes.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=bson_subtype_t", "src=http://mongoc.org/libbson/current/bson_subtype_t.html", "protocol=uri"

class
	BSON_SUBTYPE

feature -- Access

	bson_subtype_binary: INTEGER = 0x00
			-- Generic binary subtype

	bson_subtype_function: INTEGER = 0x01
			-- Function

	bson_subtype_binary_deprecated: INTEGER = 0x02
			-- Binary (Old/Deprecated)

	bson_subtype_uuid_deprecated: INTEGER = 0x03
			-- UUID (Old/Deprecated)

	bson_subtype_uuid: INTEGER = 0x04
			-- UUID

	bson_subtype_md5: INTEGER = 0x05
			-- MD5

	bson_subtype_column: INTEGER = 0x07
			-- Column

	bson_subtype_sensitive: INTEGER = 0x08
			-- Sensitive data

	bson_subtype_user: INTEGER = 0x80
			-- User defined

feature -- Status report

	is_valid_subtype (a_subtype: INTEGER): BOOLEAN
			-- Is `a_subtype` a valid BSON binary subtype?
		do
			Result := a_subtype = bson_subtype_binary or
				a_subtype = bson_subtype_function or
				a_subtype = bson_subtype_binary_deprecated or
				a_subtype = bson_subtype_uuid_deprecated or
				a_subtype = bson_subtype_uuid or
				a_subtype = bson_subtype_md5 or
				a_subtype = bson_subtype_column or
				a_subtype = bson_subtype_sensitive or
				a_subtype = bson_subtype_user
		end

feature -- Text representation

	subtype_name (a_subtype: INTEGER): STRING
			-- Name of the BSON binary subtype `a_subtype`
		require
			valid_subtype: is_valid_subtype (a_subtype)
		do
			inspect a_subtype
			when bson_subtype_binary then Result := "Binary"
			when bson_subtype_function then Result := "Function"
			when bson_subtype_binary_deprecated then Result := "Binary (Deprecated)"
			when bson_subtype_uuid_deprecated then Result := "UUID (Deprecated)"
			when bson_subtype_uuid then Result := "UUID"
			when bson_subtype_md5 then Result := "MD5"
			when bson_subtype_column then Result := "Column"
			when bson_subtype_sensitive then Result := "Sensitive"
			when bson_subtype_user then Result := "User Defined"
			else
				Result := "Unknown"
			end
		end

end 