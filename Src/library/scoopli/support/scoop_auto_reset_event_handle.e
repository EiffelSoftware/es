indexing
	description: "Objects that implement AUTO_RESET_EVENT_HANDLE.%
				 %Minimalistic implementation of .NET's AUTO_RESET_EVENT on EiffelThread."
	author: "Piotr Nienaltowski"
	date: "$Date$"
	revision: "$Revision$"
	build_number: "0.4.4000"

class
	SCOOP_AUTO_RESET_EVENT_HANDLE

create
	make

feature
	make (a_state: BOOLEAN) is
			-- Creation procedure.
		do
			create cv_mutex.make
			create cv_sema.make (0)
			state := a_state
		end

	set is
			-- Set state to signalled.
		do
			cv_mutex.lock
			if not state then
				if waiting_count > 0 then
					cv_sema.post
					waiting_count := waiting_count - 1
				else
					state := True
				end
			end
			cv_mutex.unlock
		end

	reset is
			-- Set state to not signalled.
		do
			cv_mutex.lock
			state := False
			cv_mutex.unlock
		end

	wait_one is
			-- Block calling thread until state is signalled.
		do
			cv_mutex.lock
			if not state then
				waiting_count := waiting_count + 1
				cv_mutex.unlock
				cv_sema.wait
			else
				state := False
				cv_mutex.unlock
			end
		end


	cv_mutex: MUTEX
		-- Mutex used for calls to `wait'.

	state: BOOLEAN
		-- Signalled or not signalled.

	cv_sema: SEMAPHORE
		-- Auxiliary semaphore.

	waiting_count: INTEGER_32
		-- Number of waiting threads.

invariant
	state implies waiting_count = 0

end -- class AUTO_CONDITION_VARIABLE
