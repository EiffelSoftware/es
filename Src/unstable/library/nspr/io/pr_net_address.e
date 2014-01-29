note
	description: "{PR_NET_ADDRESS} represents a network (ip) address and port."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	PR_NET_ADDRESS

inherit
	PR_CONSTANTS

create
	default_create,
	make_from_string,
	make_from_c

create {PR_NET_ADDRESS, PR_TCP_SOCKET, PR_HOST_ENTRY}
	make_empty

feature {NONE} -- Initialization
	make_from_string(a_ip: ESTRING_8; a_port: NATURAL_16)
		local
			l_str: C_STRING
			l_addr: MANAGED_POINTER
		do
			create l_str.make (a_ip)
			l_addr := create_PRNetAddr_pointer
			if pr_success = c.pr_stringtonetaddr (l_str.item, l_addr.item) then
				pointer := l_addr.item
				memory := l_addr
				if pr_failure = c.pr_initializenetaddr (pr_ipaddrnull, a_port, l_addr.item) then
					create pointer
					memory := Void
				end
			end
		end

	make_empty
		local
			l_addr: MANAGED_POINTER
		do
			l_addr := create_PRNetAddr_pointer
			memory := l_addr
			pointer := l_addr.item
		end

	make_from_c (a_pointer: POINTER)
		do
			create {MANAGED_POINTER}memory.make_from_pointer (a_pointer, sizeof_prnetaddr)
		end

feature -- Measurement
	family: NATURAL_16
		do
			Result := get_family (pointer)
		end

	is_ipv6: BOOLEAN


feature -- Status report
	is_valid: BOOLEAN
		do
			Result := not pointer.is_default_pointer
		end

feature -- Constants
	ipv4: NATURAL_16
	external
		"C inline use <nspr4/prio.h>"
	alias
		"return PR_AF_INET;"
	end

	ipv6: NATURAL_16
	external
		"C inline use <nspr4/prio.h>"
	alias
		"return PR_AF_INET6;"
	end


feature {NONE} -- Implementation
	c: PR_IO_C

	create_PRNetAddr_pointer: MANAGED_POINTER
		do
			create Result.make (sizeof_PRNetAddr)
		end

	sizeof_PRNetAddr: INTEGER
		external
			"C inline use <nspr4/prio.h>"
		alias
			"return sizeof (PRNetAddr);"
		end

	get_family (a_ptr: POINTER): NATURAL_16
		external
			"C inline use <nspr4/prio.h>"
		alias
			"return ((PRNetAddr*)$a_ptr)->raw.family;"
		end

feature -- Status report		

	memory: detachable separate MANAGED_POINTER

feature {PR_TCP_SOCKET, PR_HOST_ENTRY}
	pointer: POINTER

	PR_IpAddrNull: NATURAL = 0
	PR_IpAddrAny: NATURAL = 1
	PR_IpAddrLoopback: NATURAL = 2
end
