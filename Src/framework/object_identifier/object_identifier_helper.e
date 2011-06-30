note
	description: "Class to retrieve object identifiers"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	OBJECT_IDENTIFIER_HELPER

feature -- Access

	frozen object_identifier (obj: detachable ANY): INTEGER
			-- Identifier of `obj' if it is attached, otherwise 0
			-- Note: does not work on primitive types.
		do
			if attached {ANY} obj as l_obj then
				Result := object_identifier_internal (l_obj)
			end
		end

feature{NONE} -- Implementation

	frozen object_identifier_internal (obj: ANY): INTEGER
		external
			"C inline"
		alias
			"return eif_object_identifier(eif_access($obj));"
			--
		end


end
