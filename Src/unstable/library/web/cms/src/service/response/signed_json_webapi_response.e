note
	description: "Summary description for JSON {JSON_WEBAPI_RESPONSE}."
	date: "$Date$"
	revision: "$Revision$"

class
	SIGNED_JSON_WEBAPI_RESPONSE

inherit
	JSON_WEBAPI_RESPONSE
		rename
			make as make_response
		redefine
			prepare_page_response_before_sending
		end

create
	make

feature {NONE} -- Initialization

	make (a_key: READABLE_STRING_8; req: WSF_REQUEST; res: WSF_RESPONSE; a_api: like api)
		do
			signature_key := a_key
			make_response (req, res, a_api)
		end

feature -- Access

	signature_key: READABLE_STRING_8

feature -- Execution

	prepare_page_response_before_sending (m: WSF_PAGE_RESPONSE)
		local
			hm: HMAC_SHA256
			j: STRING_8
		do
			j := m.body
			if j = Void then
				j := ""
			end
			create hm.make_ascii_key (signature_key)
			hm.update_from_string (j)
			m.header.put_header_key_value ("X-EWF-Roc-Sign", hm.base64_digest)
		end

invariant

note
	copyright: "2011-2024, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
