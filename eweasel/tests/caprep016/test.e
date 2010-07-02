class
	TEST

inherit
	THREAD_CONTROL

	EXECUTION_ENVIRONMENT

creation
	make

feature

	make
		local
			l_socket: NETWORK_STREAM_SOCKET
			l_thread: WORKER_THREAD
		do
			create mutex.make
			create barrier.make
			create l_socket.make_loopback_server_by_port (0)
			l_socket.listen (1)
			create l_thread.make (agent receive (l_socket.port))
			l_thread.launch
			send (l_socket)

			join_all
			{RT_CAPTURE_REPLAY}.print_string ({RT_CAPTURE_REPLAY}.thread_id.out + " done%N")
		end

feature {NONE}

	port: INTEGER

	mutex: MUTEX

	barrier: CONDITION_VARIABLE

	send (a_socket: NETWORK_STREAM_SOCKET)
		local
			l_accept: NETWORK_STREAM_SOCKET
		do
			a_socket.accept
			mutex.lock
			l_accept := a_socket.accepted
			l_accept.independent_store (storable)
			{RT_CAPTURE_REPLAY}.print_string ({RT_CAPTURE_REPLAY}.thread_id.out + " sent%N")
			mutex.unlock
			barrier.signal
		end

	receive (a_port: INTEGER)
		local
			l_socket: NETWORK_STREAM_SOCKET
		do
			create l_socket.make_client_by_address_and_port ((create {INET_ADDRESS_FACTORY}).create_loopback, a_port)
			mutex.lock
			l_socket.set_blocking
			l_socket.connect
			barrier.wait (mutex)
			mutex.unlock
			if attached l_socket.retrieved as l_any and then l_any.is_deep_equal (storable) then
				{RT_CAPTURE_REPLAY}.print_string ({RT_CAPTURE_REPLAY}.thread_id.out + " received%N")
			else
				{RT_CAPTURE_REPLAY}.print_string ({RT_CAPTURE_REPLAY}.thread_id.out + " failed%N")
			end
		end

	storable: HASH_TABLE [ANY, HASHABLE]
		do
			create Result.make (10)
			Result.force (create {ANY}, "ANY")
			Result.force ("A string", "A string")
			Result.force ({NATURAL_64} 5, "NATURAL_64 5")
			Result.force ({INTEGER_8} -1, "INTEGER_8 -1")
			Result.force (<< 100, Void, -3.5, "A string", create {ANY} >>, "ARRAY[ANY]")
		end

end

