note
	description: "Summary description for {AFX_TIMER_THREAD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TIMER_THREAD

inherit
	THREAD
		rename
			sleep as thread_sleep,
			launch as launch_thread
		export
			{NONE} all
		end

	AFX_INTERPRETER_CONSTANTS


	DT_SHARED_SYSTEM_CLOCK
		export
			{NONE} all
		end

	EXECUTION_ENVIRONMENT
		rename
			launch as launch_process
		export
			{NONE} all
		end

	KL_SHARED_OPERATING_SYSTEM
		export
			{NONE} all
		end

	REFACTORING_HELPER
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_action: like action)
			-- Initialize.
		do
			create mutex.make
			create condition_variable.make
			action := a_action
		end

feature {NONE} -- Access

	mutex: MUTEX
			-- Mutex for controlling access to `process', `timeout' and `condition_variable'.

	condition_variable: CONDITION_VARIABLE
			-- Condition variable for timout thread

	timeout: INTEGER
			-- Number of seconds being spent until process is terminated

	action: PROCEDURE [ANY, TUPLE]
			-- Action to be performed when Current time out

	should_quit: BOOLEAN
			-- Should current thread exit?

feature -- Status report

	is_launched: BOOLEAN
			-- Has `process' been launched?

feature -- Status setting

	set_timeout (a_timeout: like timeout)
			-- Set `timeout' to `a_timeout'.
		require
			not_a_timeout_negative: a_timeout >= 0
		do
			mutex.lock
			timeout := a_timeout
			if is_launched then
				condition_variable.signal
			end
			mutex.unlock
		end

	set_should_quit (b: BOOLEAN)
			-- Set `should_quit' to `b'.
		do
--			mutex.lock
			should_quit := b
			if is_launched then
				condition_variable.signal
			end
--			mutex.unlock
		end

	reset_timer
			-- Reset any timer currently running to `a_timeout'
		require
			launched: is_launched
		do
			mutex.lock
			condition_variable.signal
			mutex.unlock
		end

feature -- Basic operations

	start
			-- Launch current timer.
		do
			is_launched := True
			launch_thread
		ensure
			launched: is_launched
		end

feature {NONE} -- Basic operations

	execute
			-- <Precursor>
		local
			l_done, l_exp: BOOLEAN
		do
			from
				mutex.lock
			until
				l_done
			loop
				if timeout > 0 then
					l_exp := condition_variable.wait_with_timeout (mutex, timeout * 1000)
					if not l_exp then
						action.call (Void)
					end
				end
				if should_quit then
					l_done := True
				else
					if timeout = 0 then
						condition_variable.wait (mutex)
					end
				end
			end
			mutex.unlock
		end

invariant
	timeout_not_negative: timeout >= 0

end
