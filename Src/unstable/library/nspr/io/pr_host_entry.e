note
	description: "Summary description for {PR_HOST_ENTRY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PR_HOST_ENTRY

inherit
	PR_CONSTANTS

create
	lookup

feature -- Access
	name: ESTRING_8

	aliases: LIST[ESTRING_8]

	addresses: LIST[PR_NET_ADDRESS]

feature {NONE} -- Initialization
	lookup (a_hostname: ESTRING_8; a_port: NATURAL_16)
		local
			l_buf, l_hostentry: MANAGED_POINTER
			l_addr: PR_NET_ADDRESS
			l_cstring: C_STRING
			l_addresses: ARRAYED_LIST[PR_NET_ADDRESS]
			l_aliases: ARRAYED_LIST[ESTRING_8]
			p: POINTER
			i, n: INTEGER
		do
			create l_buf.make (PR_NETDB_BUF_SIZE)
			create l_hostentry.make (sizeof_PRHostEnt)
			create l_cstring.make (a_hostname)
			if pr_success = c.pr_gethostbyname (l_cstring.item, l_buf.item, l_buf.count, l_hostentry.item) then
				create name.make_from_c (h_name(l_hostentry.item))
				create l_aliases.make (8)
				from
					i := 0
					p := enumerate_aliases (l_hostentry.item, 0)
				until
					p.is_default_pointer
				loop
					l_aliases.extend (create {ESTRING_8}.make_from_c(enumerate_aliases (l_hostentry.item, i)))
					i := i + 1
				end
				l_aliases.resize (l_aliases.count)
				aliases := l_aliases

				create l_addresses.make(8)
				from
					create l_addr.make_empty
					i := c.pr_enumeratehostent (0, l_hostentry.item, a_port, l_addr.pointer)
				until
					i <= 0
				loop
					l_addresses.extend (l_addr)
					create l_addr.make_empty
					i := c.pr_enumeratehostent (i, l_hostentry.item, a_port, l_addr.pointer)
				end
				l_addresses.resize (l_addresses.count)
				addresses := l_addresses
			else
				create {ARRAYED_LIST[ESTRING_8]}aliases.make (0)
				create {ARRAYED_LIST[PR_NET_ADDRESS]}addresses.make (0)
			end
		end

	PR_NETDB_BUF_SIZE: INTEGER
		external
			"C inline use <nspr4/prnetdb.h>"
		alias
			"return PR_NETDB_BUF_SIZE;"
		end

	sizeof_PRHostEnt: INTEGER
		external
			"C inline use <nspr4/prnetdb.h>"
		alias
			"return sizeof (PRHostEnt);"
		end

	h_name (hostent: POINTER): POINTER
		external
			"C inline use <nspr4/prnetdb.h>"
		alias
			"{
				PRHostEnt* e = $hostent;
				return e->h_name;
			}"
		end

	enumerate_aliases (hostent: POINTER; num: INTEGER): POINTER
		external
			"C inline use <nspr4/prnetdb.h>"
		alias
			"{
				PRHostEnt* e = $hostent;
				return (e->h_aliases)[$num];
			}"
		end

	c: PR_IO_C

end
