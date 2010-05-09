note
	description: "Log manager"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_LOG_MANAGER

inherit
	DT_SHARED_SYSTEM_CLOCK
		export {NONE} all end

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize.
		do
			create loggers.make
		end

feature -- Access

	loggers: LINKED_LIST [EPA_LOGGER]
			-- List of loggers which can output messages into different formats

feature -- Access


feature -- Time logging

	time_logging_mode: INTEGER
			-- Mode to log time
			-- Default: `no_time_logging_mode'
			-- See `is_time_logging_mode_valid' for possible values for this attribute.

	set_time_logging_mode (a_mode: INTEGER)
			-- Set `time_logging_mode' with `a_mode'.
		require
			a_mode_valid: is_time_logging_mode_valid (a_mode)
		do
			time_logging_mode := a_mode
		ensure
			time_logging_mode_set: time_logging_mode = a_mode
		end

	start_time: DT_DATE_TIME
			-- Start time of current logging
		do
			if start_time_internal = Void then
				start_time_internal := system_clock.date_time_now
			end
			Result := start_time_internal
		end

	duration_until_now: DT_DATE_TIME_DURATION is
			-- Duration from the start of current AutoTest run until now
		local
			time_now: DT_DATE_TIME
		do
			time_now := system_clock.date_time_now
			Result := time_now.duration (start_time)
			Result.set_time_canonical
		end

	set_start_time (a_time: like start_time)
			-- Set `start_time' with `a_time'.
		do
			start_time_internal := a_time
		ensure
			start_time_set: start_time = a_time
		end

	set_start_time_as_now
			-- Set `start_time' as the system time now.
		do
			set_start_time (system_clock.date_time_now)
		end

feature -- Constants/Time

	duration_time_logging_mode: INTEGER = 1
			-- Log time duration from `start_time' to now

	absolute_time_logging_mode: INTEGER = 2
			-- Log time as absolute time now

	no_time_logging_mode: INTEGER = 3
			-- No time logging

	is_time_logging_mode_valid (a_mode: INTEGER): BOOLEAN
			-- Is `a_mode' a valid time logging mode?
		do
			Result :=
				a_mode = duration_time_logging_mode or
				a_mode = absolute_time_logging_mode or
				a_mode = no_time_logging_mode
		end

feature -- Logging

	put_string (a_string: STRING)
			-- Log `a_string'.
		do
			loggers.do_all (agent {EPA_LOGGER}.put_string (a_string))
		end

	put_line (a_string: STRING)
			-- Log `a_string' as a line.
		local
			l_str: STRING
		do
			create l_str.make (a_string.count + 1)
			l_str.append (a_string)
			l_str.append_character ('%N')
			loggers.do_all (agent {EPA_LOGGER}.put_string (l_str))
		end

	put_line_with_time (a_string: STRING)
			-- Log `a_string' as a line, and append current time or elapsed time in front of that string.
		local
			l_str: STRING
		do
			create l_str.make (a_string.count + 1)
			l_str.append (a_string)
			l_str.append_character ('%N')
			put_string_with_time (l_str)
		end

	put_string_with_time (a_string: STRING)
			-- Log `a_string', and append current time or elapsed time in front of that string.
		local
			l_str: STRING
		do
			create l_str.make (a_string.count + 32)
			l_str.append (time_prefix)
			l_str.append (a_string)
			put_string (l_str)
		end

feature{NONE} -- Impmelentation

	time_prefix: STRING
			-- Prefix for time
		do
			create Result.make (32)
			if time_logging_mode = duration_time_logging_mode then
				Result.append (duration_until_now.out)
			elseif time_logging_mode = absolute_time_logging_mode then
				Result.append (system_clock.date_time_now.out)
			end
			Result.append (once ": ")
		end

	start_time_internal: detachable DT_DATE_TIME
			-- Cache for `start_time'

end
