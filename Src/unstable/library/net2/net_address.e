note
	description: "Summary description for {NET_ADDRESS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	NET_ADDRESS

create
	default_create,
	make_from_string

feature {NONE} -- Initialization
	make_from_string (a_ip: ESTRING_8; a_port: NATURAL_16)
		do
			create internal.make_from_string (a_ip, a_port)
		end

feature -- Measurment
	is_valid: BOOLEAN
		do
			Result := internal.is_valid
		end

	is_ipv4: BOOLEAN
		do
			Result := internal.family = internal.ipv4
		end

	is_ipv6: BOOLEAN
		do
			Result := internal.family = internal.ipv6
		end

feature -- Access
	internal: PR_NET_ADDRESS

end
