note
	description: "[
			Interface to make a class JSON serializable.
			
			To use in relation with JSON_SERIALIZABLE_SERIALIZER
		]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	JSON_SERIALIZABLE

feature -- Conversion

	to_json (ctx: JSON_SERIALIZER_CONTEXT): JSON_VALUE
			-- JSON value representing the JSON serialization of Eiffel value `Current', in the eventual context `ctx'.	
		deferred
		end

note
	copyright: "2010-2024, Javier Velilla, Jocelyn Fiat, Eiffel Software and others https://github.com/eiffelhub/json."
	license: "https://github.com/eiffelhub/json/blob/master/License.txt"
end
