note
	description: "[
			Object Representing Find and Modify Flags
			This enum describes the flags that can be used with find and modify operations.
			
			Flags:
			MONGOC_FIND_AND_MODIFY_NONE - No flags set.
			MONGOC_FIND_AND_MODIFY_REMOVE - Remove the document matched by the query.
			MONGOC_FIND_AND_MODIFY_UPSERT - Insert a document if none match the query.
			MONGOC_FIND_AND_MODIFY_RETURN_NEW - Return the modified document rather than the original.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_find_and_modify_flags_t", "src=http://mongoc.org/libmongoc/current/mongoc_find_and_modify_flags_t.html", "protocol=uri"

class
	MONGODB_FIND_AND_MODIFY_FLAGS

inherit
	MONGODB_ENUM

create
	make

feature {NONE} -- Initialization

	make
			-- Create an instance with default flags set as MONGOC_FIND_AND_MODIFY_NONE.
		do
			value := 0
		end

feature -- Constants

	none: INTEGER = 0
			-- No flags set

	remove: INTEGER = 0x1
			-- Remove the document matched by the query

	upsert: INTEGER = 0x2
			-- Insert a document if none match the query

	return_new: INTEGER = 0x4
			-- Return the modified document rather than the original

feature -- Change Element

	mark_none
			-- Set flags to none
		do
			value := none
		end

	mark_remove
			-- Set remove flag
		do
			value := value | remove
		end

	mark_upsert
			-- Set upsert flag
		do
			value := value | upsert
		end

	mark_return_new
			-- Set return_new flag
		do
			value := value | return_new
		end

	unmark_remove
			-- Unset remove flag
		do
			value := value & (0xFFFF - remove)
		end

	unmark_upsert
			-- Unset upsert flag
		do
			value := value & (0xFFFF - upsert)
		end

	unmark_return_new
			-- Unset return_new flag
		do
			value := value & (0xFFFF - return_new)
		end

feature -- Status Report

	is_valid_value (a_value: INTEGER): BOOLEAN
			-- Is `a_value` a valid combination of flags?
		do
			Result := a_value >= 0 and a_value <= 7 -- All possible combinations of the three flags
		end

	is_none: BOOLEAN
			-- Are no flags set?
		do
			Result := value = none
		end

	is_remove: BOOLEAN
			-- Is remove flag set?
		do
			Result := (value & remove) /= 0
		end

	is_upsert: BOOLEAN
			-- Is upsert flag set?
		do
			Result := (value & upsert) /= 0
		end

	is_return_new: BOOLEAN
			-- Is return_new flag set?
		do
			Result := (value & return_new) /= 0
		end

end
