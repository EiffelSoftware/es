note
	description: "[
		Constants representing BSON types.
		These values indicate the type of a BSON element.
		See: http://bsonspec.org/ for more information on BSON types.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=bson_type_t", "src=http://mongoc.org/libbson/current/bson_type_t.html", "protocol=uri"

class
	BSON_TYPE

feature -- Access

	bson_type_eoo: INTEGER = 0x00
			-- End of object

	bson_type_double: INTEGER = 0x01
			-- \x01 double - 64-bit binary floating point

	bson_type_utf8: INTEGER = 0x02
			-- \x02 string - UTF-8 string

	bson_type_document: INTEGER = 0x03
			-- \x03 document - Embedded document

	bson_type_array: INTEGER = 0x04
			-- \x04 array - Array

	bson_type_binary: INTEGER = 0x05
			-- \x05 binary - Binary data

	bson_type_undefined: INTEGER = 0x06
			-- \x06 undefined - Deprecated

	bson_type_oid: INTEGER = 0x07
			-- \x07 ObjectId - 12-byte ObjectId

	bson_type_bool: INTEGER = 0x08
			-- \x08 bool - true or false

	bson_type_date_time: INTEGER = 0x09
			-- \x09 date - UTC datetime

	bson_type_null: INTEGER = 0x0A
			-- \x0A null - Null value

	bson_type_regex: INTEGER = 0x0B
			-- \x0B regex - Regular expression

	bson_type_dbpointer: INTEGER = 0x0C
			-- \x0C dbpointer - Deprecated

	bson_type_code: INTEGER = 0x0D
			-- \x0D code - JavaScript code

	bson_type_symbol: INTEGER = 0x0E
			-- \x0E symbol - Deprecated

	bson_type_codewscope: INTEGER = 0x0F
			-- \x0F code with scope - JavaScript code w/ scope

	bson_type_int32: INTEGER = 0x10
			-- \x10 int32 - 32-bit integer

	bson_type_timestamp: INTEGER = 0x11
			-- \x11 timestamp - Timestamp

	bson_type_int64: INTEGER = 0x12
			-- \x12 int64 - 64-bit integer

	bson_type_decimal128: INTEGER = 0x13
			-- \x13 decimal128 - Decimal128

	bson_type_maxkey: INTEGER = 0x7F
			-- \x7F maxkey - Max key

	bson_type_minkey: INTEGER = 0xFF
			-- \xFF minkey - Min key

feature -- Status report

	is_valid_type (a_type: INTEGER): BOOLEAN
			-- Is `a_type` a valid BSON type?
		do
			Result := a_type = bson_type_eoo or
				a_type = bson_type_double or
				a_type = bson_type_utf8 or
				a_type = bson_type_document or
				a_type = bson_type_array or
				a_type = bson_type_binary or
				a_type = bson_type_undefined or
				a_type = bson_type_oid or
				a_type = bson_type_bool or
				a_type = bson_type_date_time or
				a_type = bson_type_null or
				a_type = bson_type_regex or
				a_type = bson_type_dbpointer or
				a_type = bson_type_code or
				a_type = bson_type_symbol or
				a_type = bson_type_codewscope or
				a_type = bson_type_int32 or
				a_type = bson_type_timestamp or
				a_type = bson_type_int64 or
				a_type = bson_type_decimal128 or
				a_type = bson_type_maxkey or
				a_type = bson_type_minkey
		end

feature -- Text representation

	type_name (a_type: INTEGER): STRING
			-- Name of the BSON type `a_type`
		require
			valid_type: is_valid_type (a_type)
		do
			inspect a_type
			when bson_type_eoo then Result := "EOO"
			when bson_type_double then Result := "Double"
			when bson_type_utf8 then Result := "UTF-8"
			when bson_type_document then Result := "Document"
			when bson_type_array then Result := "Array"
			when bson_type_binary then Result := "Binary"
			when bson_type_undefined then Result := "Undefined"
			when bson_type_oid then Result := "ObjectId"
			when bson_type_bool then Result := "Boolean"
			when bson_type_date_time then Result := "DateTime"
			when bson_type_null then Result := "Null"
			when bson_type_regex then Result := "Regex"
			when bson_type_dbpointer then Result := "DBPointer"
			when bson_type_code then Result := "Code"
			when bson_type_symbol then Result := "Symbol"
			when bson_type_codewscope then Result := "CodeWScope"
			when bson_type_int32 then Result := "Int32"
			when bson_type_timestamp then Result := "Timestamp"
			when bson_type_int64 then Result := "Int64"
			when bson_type_decimal128 then Result := "Decimal128"
			when bson_type_maxkey then Result := "MaxKey"
			when bson_type_minkey then Result := "MinKey"
			else
				Result := "Unknown"
			end
		end

end 