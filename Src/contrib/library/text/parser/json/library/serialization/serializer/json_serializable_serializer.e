note
	description: "Summary description for {JSON_SERIALIZABLE_SERIALIZER}."
	date: "$Date$"
	revision: "$Revision$"

class
	JSON_SERIALIZABLE_SERIALIZER

inherit
	JSON_SERIALIZER

feature -- Conversion

	to_json (obj: detachable ANY; ctx: JSON_SERIALIZER_CONTEXT): JSON_VALUE
			-- JSON value representing the JSON serialization of Eiffel value `obj', in the eventual context `ctx'.	
		do
			if attached {JSON_SERIALIZABLE} obj as ser then
				Result := ser.to_json (ctx)
			else
				check is_json_serializable: False end
				create {JSON_NULL} Result
			end
		end

note
	copyright: "2010-2024, Jocelyn Fiat, Javier Velilla, Eiffel Software and others https://github.com/eiffelhub/json."
	license: "https://github.com/eiffelhub/json/blob/master/License.txt"
end
