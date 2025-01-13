note
    description: "[
        Document validation options for BSON.
        These flags may be combined to specify a level of BSON document validation.
        A value of 0 requests the minimum applicable level of validation.
    ]"
    date: "$Date$"
    revision: "$Revision$"
    EIS: "name=bson_validate_flags_t", "src=https://mongoc.org/libbson/current/bson_validate_flags_t.html", "protocol=uri"

class
    BSON_VALIDATE_FLAGS

feature -- Access

    bson_validate_none: INTEGER = 0
            -- Minimum level of validation; in libbson, validates element headers.

    bson_validate_utf8: INTEGER = 0x01
            -- All keys and string values are checked for invalid UTF-8.
            -- Binary value: (1 << 0)

    bson_validate_dollar_keys: INTEGER = 0x02
            -- Prohibit keys that start with `$` outside of a "DBRef" subdocument.
            -- Binary value: (1 << 1)

    bson_validate_dot_keys: INTEGER = 0x04
            -- Prohibit keys that contain `.` anywhere in the string.
            -- Binary value: (1 << 2)

    bson_validate_utf8_allow_null: INTEGER = 0x08
            -- String values are allowed to have embedded NULL bytes.
            -- Binary value: (1 << 3)

    bson_validate_empty_keys: INTEGER = 0x10
            -- Prohibit zero-length keys.
            -- Binary value: (1 << 4)

feature -- Operations

    is_valid_flag (a_flag: INTEGER): BOOLEAN
            -- Check if the flag value is valid
        do
            Result := a_flag = bson_validate_none or else
                     a_flag = bson_validate_utf8 or else
                     a_flag = bson_validate_dollar_keys or else
                     a_flag = bson_validate_dot_keys or else
                     a_flag = bson_validate_utf8_allow_null or else
                     a_flag = bson_validate_empty_keys or else
                     is_valid_combination (a_flag)
        end

    is_valid_combination (a_flags: INTEGER): BOOLEAN
            -- Check if the combination of flags is valid
        do
            Result := (a_flags & (bson_validate_utf8 |
                                bson_validate_dollar_keys |
                                bson_validate_dot_keys |
                                bson_validate_utf8_allow_null |
                                bson_validate_empty_keys)) = a_flags
        end

feature -- Combination

    combine_flags (a_flags: ARRAY[INTEGER]): INTEGER
            -- Combine multiple validation flags
        require
            flags_not_void: a_flags /= Void
            flags_valid: across a_flags as flag all is_valid_flag (flag.item) end
        do
            across a_flags as flag loop
                Result := Result | flag.item
            end
        ensure
            valid_combination: is_valid_combination (Result)
        end

invariant
    valid_constants: is_valid_flag (bson_validate_none) and
                    is_valid_flag (bson_validate_utf8) and
                    is_valid_flag (bson_validate_dollar_keys) and
                    is_valid_flag (bson_validate_dot_keys) and
                    is_valid_flag (bson_validate_utf8_allow_null) and
                    is_valid_flag (bson_validate_empty_keys)

end 