note
	description: "{PR_TCP_SOCKET} represents a tcp socket."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	PR_TCP_SOCKET

inherit
	PR_CONSTANTS
	DISPOSABLE

create
	open_ipv4,
	open_ipv6,
	make_from_fd

feature {NONE} -- Initialization
	open_ipv4
	do
		error := Void
		address_family := ipv4
		pr_fd := c.pr_opentcpsocket(address_family)
		if pr_fd.is_default_pointer then
			(create {PR_EXCEPTION}.make).raise
		end
	ensure
		address_family = ipv4
	end

	open_ipv6
	do
		error := Void
		address_family := ipv6
		pr_fd := c.pr_opentcpsocket(address_family)
		if pr_fd.is_default_pointer then
			(create {PR_EXCEPTION}.make).raise
		end
	ensure
		address_family = ipv6
	end

	make_from_fd (a_fd: POINTER; a_address_family: NATURAL_16)
	do
		error := Void
		address_family := a_address_family
		pr_fd := a_fd
		can_receive := True
		can_send := True
	ensure
		address_family = a_address_family
		is_connected
	end


feature -- Status setting
	set_use_exceptions (a_val: BOOLEAN)
		do
			use_exceptions := a_val
		ensure
			use_exceptions = a_val
		end

	connect (a_addr: PR_NET_ADDRESS; a_timeout: NATURAL_32)
		require
			timout_valid: (a_timeout >= pr_interval_min and a_timeout <= pr_interval_max)
				or a_timeout = pr_interval_no_wait or a_timeout = pr_interval_no_timeout
			not is_connected
			not is_listening
			not is_closed
			a_addr.family = address_family
		local
			l_error: PR_ERROR
		do
			error := Void
			was_timeout := False
			if pr_failure = c.pr_connect (pr_fd, a_addr.pointer, a_timeout) then
				create l_error.make
				if l_error.is_timeout then
					was_timeout := True
				else
					error := l_error
					if use_exceptions then
						(create {PR_EXCEPTION}.make).raise
					end
				end
			else
				can_receive := True
				can_send := True
				is_bound := True
				peer_address := a_addr
			end
		ensure
			not (attached error or was_timeout) implies
				can_receive and
				can_send and
				is_bound and
				peer_address = a_addr
		end

	bind (a_addr: PR_NET_ADDRESS)
		require
			not is_connected
			not is_bound
			not is_listening
			not is_closed
			a_addr.family = address_family
		do
			error := Void
			if pr_failure = c.pr_bind (pr_fd, a_addr.pointer) then
				create error.make
				if use_exceptions then
					(create {PR_EXCEPTION}.make).raise
				end
			else
				is_bound := True
				socket_address := a_addr
			end
		ensure
			not attached error implies
				socket_address = a_addr and
				is_bound
		end

	listen (a_backlog: INTEGER)
		require
			a_backlog >= 0
			is_bound
			not is_connected
			not is_listening
			not is_closed
		do
			error := Void
			if pr_failure = c.pr_listen (pr_fd, a_backlog) then
				create error.make
				if use_exceptions then
					(create {PR_EXCEPTION}.make).raise
				end
			else
				is_listening := True
			end
		ensure
			not attached error implies
				is_listening
		end

	accept (a_timeout: NATURAL_32)
		require
			timout_valid: (a_timeout >= pr_interval_min and a_timeout <= pr_interval_max)
				or a_timeout = pr_interval_no_wait or a_timeout = pr_interval_no_timeout
			not is_closed
			is_listening
		local
			l_addr: PR_NET_ADDRESS
			l_error: PR_ERROR
			l_fd: POINTER
		do
			error := Void
			was_timeout := False
			create l_addr.make_empty
			l_fd := c.pr_accept (pr_fd, l_addr.pointer, a_timeout)
			if l_fd.is_default_pointer then
				create l_error.make
				if l_error.is_timeout then
					was_timeout := True
				else
					error := l_error
					if use_exceptions then
						(create {PR_EXCEPTION}.make).raise
					end
				end
			else
				create last_accepted_socket.make_from_fd(l_fd, address_family)
			end
		ensure
			not (attached error or was_timeout) implies
				attached last_accepted_socket and
				last_accepted_socket /= old last_accepted_socket
		end

	shutdown_send
		require
			not is_closed
			can_send
		do
			error := Void
			if pr_failure = c.pr_shutdown (pr_fd, pr_shutdown_send) then
				create error.make
				if use_exceptions then
					(create {PR_EXCEPTION}.make).raise
				end
			else
				can_send := False
			end
		ensure
			not attached error implies
				not can_send
		end

	shutdown_receive
		require
			not is_closed
			can_receive
		do
			error := Void
			if pr_failure = c.pr_shutdown (pr_fd, pr_shutdown_recv) then
				create error.make
				if use_exceptions then
					(create {PR_EXCEPTION}.make).raise
				end
			else
				is_listening := True
			end
		ensure
			not attached error implies
				not can_receive
		end

	shutdown_both
		require
			not is_closed
			can_send or can_receive
		do
			error := Void
			if pr_failure = c.pr_shutdown (pr_fd, pr_shutdown_both) then
				create error.make
				if use_exceptions then
					(create {PR_EXCEPTION}.make).raise
				end
			else
				is_listening := True
			end
		ensure
			not attached error implies
				not can_receive and not can_send
		end

	close
		require
			not is_closed
		local
			l_dummy: INTEGER
		do
			l_dummy := c.pr_close (pr_fd)
			create pr_fd
			can_receive := False
			can_send := False
			is_bound := False
			is_listening := False
		ensure
			is_closed
		end

	detach
		-- Detach socket from Eiffel, leaving the socket perpetually open.
		require
			not is_closed
		do
			create pr_fd
			can_receive := False
			can_send := False
			is_bound := False
			is_listening := False
		ensure
			is_closed
		end

feature -- Access
	last_accepted_socket: detachable PR_TCP_SOCKET

	pr_fd: POINTER
		-- The file descriptor of the socket

feature -- Status report
	address_family: NATURAL_16

	is_connected: BOOLEAN
		do
			Result := can_receive or can_send
		end

	is_closed: BOOLEAN
		do
			Result := pr_fd.is_default_pointer
		end

	can_receive: BOOLEAN

	can_send: BOOLEAN

	is_bound: BOOLEAN

	is_listening: BOOLEAN

	peer_address: PR_NET_ADDRESS

	socket_address: PR_NET_ADDRESS

	use_exceptions: BOOLEAN assign set_use_exceptions

	error: detachable PR_ERROR

	was_timeout: BOOLEAN
		-- True on timeout of `accept' or `connect'


	recv_buffer_size: NATURAL
		do
			if not is_closed then
				Result := get_sock_option_recv_buffer_size (pr_fd)
			end
		end

	send_buffer_size: NATURAL
		do
			if not is_closed then
				Result := get_sock_option_send_buffer_size (pr_fd)
			end
		end

feature -- Input
	receive_to_special (a_special: separate SPECIAL[ANY]; a_timeout: NATURAL_32)
		-- Receive data and put them in the supplied special, taking care of the endianness conversion
		require
			timout_valid: (a_timeout >= pr_interval_min and a_timeout <= pr_interval_max)
				or a_timeout = pr_interval_no_wait or a_timeout = pr_interval_no_timeout
			can_receive
		local
			l_error: PR_ERROR
			l_amount: INTEGER_32
		do
			error := Void
			was_timeout := False
			l_amount := receive_special_c (pr_fd, a_special, a_timeout)
			if l_amount = -1 then
				create l_error.make
				if l_error.is_timeout then
					bytes_received := 0
					was_timeout := True
				else
					error := l_error
					if use_exceptions then
						(create {PR_EXCEPTION}.make).raise
					end
				end
			elseif l_amount = 0 then
				can_receive := False
				can_send := False
				bytes_received := 0
			else
				bytes_received := l_amount
			end
		ensure
			not (attached error or was_timeout) implies
				not is_connected or bytes_received > 0
		end

	receive_to_managed_pointer (a_ptr: MANAGED_POINTER; a_timeout: NATURAL_64)
		-- Receive data and put it in memory where `a_ptr' points to. Updates is_connected if connections was closed.
		require
			timout_valid: (a_timeout >= pr_interval_min and a_timeout <= pr_interval_max)
				or a_timeout = pr_interval_no_wait or a_timeout = pr_interval_no_timeout
			can_receive
		do
			receive_to_pointer (a_ptr.item, a_ptr.count, a_timeout)
		ensure
			not (attached error or was_timeout) implies
				not is_connected or bytes_received > 0
		end

	receive_to_pointer (a_ptr: POINTER; a_count: INTEGER_32; a_timeout: NATURAL_64)
		-- Receive data and put it in memory where `a_ptr' points to. Updates is_connected if connections was closed.
		require
			timout_valid: (a_timeout >= pr_interval_min and a_timeout <= pr_interval_max)
				or a_timeout = pr_interval_no_wait or a_timeout = pr_interval_no_timeout
			can_receive
		local
			l_error: PR_ERROR
			l_amount: INTEGER_32
		do
			error := Void
			was_timeout := False
			l_amount := c.pr_recv (pr_fd, a_ptr, a_count, 0, a_timeout)
			if l_amount = -1 then
				create l_error.make
				if l_error.is_timeout then
					bytes_received := 0
					was_timeout := True
				else
					error := l_error
					if use_exceptions then
						(create {PR_EXCEPTION}.make).raise
					end
				end
			elseif l_amount = 0 then
				can_receive := False
				can_send := False
				bytes_received := 0
			else
				bytes_received := l_amount
			end
		ensure
			not (attached error or was_timeout) implies
				not is_connected or bytes_received > 0
		end

	bytes_received: INTEGER

feature -- Output
	send_from_special (a_special: separate SPECIAL[ANY]; a_timeout: NATURAL_32)
		-- Send data from the supplied special, taking care of the endianness conversion
		require
			timout_valid: (a_timeout >= pr_interval_min and a_timeout <= pr_interval_max)
				or a_timeout = pr_interval_no_wait or a_timeout = pr_interval_no_timeout
			can_send
		local
			l_error: PR_ERROR
			l_amount: INTEGER_32
		do
			error := Void
			was_timeout := False
			l_amount := send_special_c (pr_fd, a_special, a_timeout)
			if l_amount = -1 then
				create l_error.make
				if l_error.is_timeout then
					bytes_sent := 0
					was_timeout := True
				else
					error := l_error
					if use_exceptions then
						(create {PR_EXCEPTION}.make).raise
					end
				end
			elseif l_amount = 0 then
				can_receive := False
				can_send := False
				bytes_sent := 0
			else
				bytes_sent := l_amount
			end
		ensure
			not (attached error or was_timeout) implies
				not is_connected or bytes_sent > 0
		end

	send_from_managed_pointer (a_ptr: MANAGED_POINTER; a_count: INTEGER_32; a_timeout: NATURAL_64)
		-- Receive data and put it in memory where `a_ptr' points to. Updates is_connected if connections was closed.
		require
			timout_valid: (a_timeout >= pr_interval_min and a_timeout <= pr_interval_max)
				or a_timeout = pr_interval_no_wait or a_timeout = pr_interval_no_timeout
			can_send
		do
			send_from_pointer (a_ptr.item, a_count, a_timeout)
		ensure
			not (attached error or was_timeout) implies
				not is_connected or bytes_sent > 0
		end

	send_from_pointer (a_ptr: POINTER; a_count: INTEGER_32; a_timeout: NATURAL_64)
		-- Receive data and put it in memory where `a_ptr' points to. Updates is_connected if connections was closed.
		require
			timout_valid: (a_timeout >= pr_interval_min and a_timeout <= pr_interval_max)
				or a_timeout = pr_interval_no_wait or a_timeout = pr_interval_no_timeout
			can_send
		local
			l_error: PR_ERROR
			l_amount: INTEGER_32
		do
			error := Void
			was_timeout := False
			l_amount := c.pr_send (pr_fd, a_ptr, a_count, 0, a_timeout)
			if l_amount = -1 then
				create l_error.make
				if l_error.is_timeout then
					bytes_sent := 0
					was_timeout := True
				else
					error := l_error
					if use_exceptions then
						(create {PR_EXCEPTION}.make).raise
					end
				end
			elseif l_amount = 0 then
				can_receive := False
				can_send := False
				bytes_sent := 0
			else
				bytes_sent := l_amount
			end
		ensure
			not (attached error or was_timeout) implies
				not is_connected or bytes_sent > 0
		end

	bytes_sent: INTEGER

feature -- Address families
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

feature -- Timeout constants
	pr_interval_min: NATURAL_32 = 1000
	pr_interval_max: NATURAL_32 = 100000
	pr_interval_no_wait: NATURAL_32 = 0
	pr_interval_no_timeout: NATURAL_32 = 0xffffffff

feature {NONE} -- Implementation
	c: PR_IO_C

	receive_special_c (a_fd: POINTER; a_special: separate SPECIAL[ANY]; a_timeout: NATURAL_32): INTEGER
	external
		"C inline use <nspr4/prio.h>, <nspr4/prnetdb.h>"
	alias
		"{
			#define bswap64(y) (((uint64_t)ntohl(y)) << 32 | ntohl(y>>32))
			int i;
			PRInt32 element_size = eif_attribute (eif_access($a_special), "element_size", EIF_INTEGER, NULL);
			PRInt32 capacity = eif_attribute (eif_access($a_special), "capacity", EIF_INTEGER, NULL);
			void * base_address = eif_attribute (eif_access($a_special), "base_address", EIF_POINTER, NULL);
			PRInt32 amount = PR_Recv ($a_fd, base_address, capacity * element_size, 0, $a_timeout);

	        EIF_PROCEDURE ep;
	        EIF_TYPE_ID tid;

	        tid = eif_type_id ("SPECIAL");
	        ep = eif_procedure ("set_count", tid);
	        (ep) (eif_access($a_special),amount);
        			
			if (amount <= 0) return amount;
			if (PR_ntohl(1345) == 1345)
				return amount;
			if (element_size == 2) {
				for (i = 0; i < amount / element_size; i++) {
					((PRUint16*)base_address)[i] = PR_ntohs(((PRUint16*)base_address)[i]);
				}
			} else if (element_size == 4) {
				for (i = 0; i < amount / element_size; i++) {
					((PRUint32*)base_address)[i] = PR_ntohl(((PRUint32*)base_address)[i]);
				}
			} else if (element_size == 8) {
				for (i = 0; i < amount / element_size; i++) {
					((PRUint64*)base_address)[i] = bswap64(((PRUint64*)base_address)[i]);
				}
			}
			return amount;
		}"
	end

	send_special_c (a_fd: POINTER; a_special: separate SPECIAL[ANY]; a_timeout: NATURAL_32): INTEGER
	external
		"C inline use <nspr4/prio.h>, <nspr4/prnetdb.h>"
	alias
		"{
			#define bswap64(y) (((uint64_t)ntohl(y)) << 32 | ntohl(y>>32))
			int i;
			PRInt32 element_size = eif_attribute (eif_access($a_special), "element_size", EIF_INTEGER, NULL);
			PRInt32 count = eif_attribute (eif_access($a_special), "capacity", EIF_INTEGER, NULL);
			void * base_address = eif_attribute (eif_access($a_special), "base_address", EIF_POINTER, NULL);
			if (PR_ntohl(1345) != 1345) {
				if (element_size == 2) {
					for (i = 0; i < count / element_size; i++) {
						((PRUint16*)base_address)[i] = PR_ntohs(((PRUint16*)base_address)[i]);
					}
				} else if (element_size == 4) {
					for (i = 0; i < count / element_size; i++) {
						((PRUint32*)base_address)[i] = PR_ntohl(((PRUint32*)base_address)[i]);
					}
				} else if (element_size == 8) {
					for (i = 0; i < count / element_size; i++) {
						((PRUint64*)base_address)[i] = bswap64(((PRUint64*)base_address)[i]);
					}
				}
			}
			return PR_Send ($a_fd, base_address, count * element_size, 0, $a_timeout);
		}"
	end

	get_sock_option_recv_buffer_size (a_fd: POINTER): NATURAL
		external
			"C inline use <nspr4/prio.h>"
		alias
			"{
				PRSocketOptionData d;
				d.option = PR_SockOpt_RecvBufferSize;
				PR_GetSocketOption ($a_fd, &d);
				return d.value.recv_buffer_size;
			}"
		end

	get_sock_option_send_buffer_size (a_fd: POINTER): NATURAL
		external
			"C inline use <nspr4/prio.h>"
		alias
			"{
				PRSocketOptionData d;
				d.option = PR_SockOpt_SendBufferSize;
				PR_GetSocketOption ($a_fd, &d);
				return d.value.send_buffer_size;
			}"
		end


	dispose
		do
			if not pr_fd.is_default_pointer then
				close
			end
		end

invariant
	address_family = ipv4 or address_family = ipv6
	is_connected: is_connected = can_receive or can_send
	is_closed: is_closed implies
		not is_connected and
		not is_bound and
		not is_listening
end
