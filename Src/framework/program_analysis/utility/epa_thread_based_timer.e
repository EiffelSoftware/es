note
	description: "Class to simulate timeout using thread"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_THREAD_BASED_TIMER

inherit
	THREAD


create
	make,
	make_with_action

feature{NONE} -- Initialization

	make (a_timeout: INTEGER; a_should_repeat: BOOLEAN)
			-- Initialize Current.
		do
			timeout := a_timeout
			should_repeat := a_should_repeat
			create timeout_actions
		end

	make_with_action (a_timeout: INTEGER; a_should_repeat: BOOLEAN; a_action: PROCEDURE [ANY, TUPLE])
			-- Initialize Current.
		do
			make (a_timeout, a_should_repeat)
			timeout_actions.extend (a_action)
		end

feature -- Access

	timeout: INTEGER
			-- Time cound down in milliseconds.

	timeout_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be executed when timeout happens.

feature -- Status report

	should_terminate: BOOLEAN
			-- Should the timeout be terminated?

	should_repeat: BOOLEAN
			-- Should the timeout be repeated?

	has_started: BOOLEAN
			-- Has Current timeout started yet?

	has_terminated: BOOLEAN
			-- Has Current timeout terminated?
		do
			Result := terminated
		end

	has_paused: BOOLEAN
			-- Has Current timeout been paused?

feature -- Setting

	set_should_terminate (b: BOOLEAN)
			-- Set `should_terminate' with `b'.
			-- Note: For simplicity, no lock is used, so race condition may occur.
		do
			should_terminate := b
		ensure
			should_terminate_set: should_terminate = b
		end

feature -- Basic operations

	start
			-- Start Current timer.
		require
			not_started_yet: not has_started
		do
			has_started := True
			launch
		end

	pause
			-- Pause Current timer.
		require
			has_started: has_started
		do
			has_paused := True
			paused_times := paused_times + 1
		end

	resume
			-- Resume Current timer.
		require
			has_paused: has_paused
		do
			has_paused := False
		end

feature{NONE} -- Implementation

	execute
			-- Routine executed when thread is launched.
		local
			l_should_exit: BOOLEAN
			l_slices: INTEGER
			i: INTEGER
			l_paused_times: INTEGER
			l_count: INTEGER
		do
			l_slices := timeout // 5 + 1
			i := 1
			from until l_should_exit loop
				l_paused_times := paused_times
				sleep (5 * 1_000_000)
				l_count := l_count + 1
				if not should_terminate and then (l_paused_times = paused_times) then
					if i > l_slices then
						if not should_terminate and then not has_paused then
							timeout_actions.call (Void)
						end
						i := 1
						l_should_exit := not should_repeat
					else
						i := i + 1
					end
				else
					i := 1
					l_count := 0
				end
				if not l_should_exit then
					l_should_exit := should_terminate
				end
					-- This is hack to avoid that the current thread never ends.
				if not l_should_exit then
					l_should_exit := l_count > 200 * 60 * 10 -- 10 minutes.
				end
			end
		end

	paused_times: INTEGER
			-- Number of times that `pause' has been called

end
