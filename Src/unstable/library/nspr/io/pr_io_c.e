note
	description: "{PR_IO_C} is a wrapper around NSPR I/O functions."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	PR_IO_C

feature -- Addresses
	PR_InitializeNetAddr(val: NATURAL; port: NATURAL_16; addr: POINTER): INTEGER
		external
			"C use <nspr4/prnetdb.h>"
		alias
			"PR_InitializeNetAddr"
		end

	PR_StringToNetAddr(string, addr: POINTER): INTEGER
		external
			"C use <nspr4/prnetdb.h>"
		alias
			"PR_StringToNetAddr"
		end

	PR_NetAddrToString(addr, string: POINTER; size: INTEGER_32): INTEGER
		external
			"C use <nspr4/prnetdb.h>"
		alias
			"PR_NetAddrToString"
		end

	PR_GetHostByName(hostname, buf: POINTER; bufsize: INTEGER; hostentry: POINTER): INTEGER
		external
			"C use <nspr4/prnetdb.h>"
		alias
			"PR_GetHostByName"
		end

	PR_GetHostByAddr(hostaddr, buf: POINTER; bufsize: INTEGER; hostentry: POINTER): INTEGER
		external
			"C use <nspr4/prnetdb.h>"
		alias
			"PR_GetHostByAddr"
		end

	PR_EnumerateHostEnt(enumIndex: INTEGER; hostEnt: POINTER; port: NATURAL_16; address: POINTER): INTEGER
		external
			"C use <nspr4/prnetdb.h>"
		alias
			"PR_EnumerateHostEnt"
		end

feature -- Sockets
	PR_OpenTCPSocket (af: INTEGER): POINTER
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_OpenTCPSocket"
		end

	PR_Connect (fd, addr: POINTER; timeout: NATURAL_64): INTEGER
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_Connect"
		end


	PR_Bind (fd, addr: POINTER): INTEGER
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_Bind"
		end

	PR_Listen (fd: POINTER; backlog: INTEGER): INTEGER
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_Listen"
		end

	PR_Accept (fd, addr: POINTER; timeout: NATURAL_64): POINTER
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_Accept"
		end

	PR_Recv (fd, buf: POINTER; amount: INTEGER_32; flags: INTEGER; timeout: NATURAL_64): INTEGER_32
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_Recv"
		end

	PR_Send (fd, buf: POINTER; amount: INTEGER_32; flags: INTEGER; timeout: NATURAL_64): INTEGER_32
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_Send"
		end

	PR_Shutdown (fd: POINTER; how: INTEGER): INTEGER
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_Shutdown"
		end

	PR_Close (fd: POINTER): INTEGER
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_Close"
		end

	PR_GetSocketOption (fd, data: POINTER): INTEGER
		external
			"C use <nspr4/prio.h>"
		alias
			"PR_GetSocketOption"
		end
end
