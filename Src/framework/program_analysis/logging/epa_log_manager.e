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
			create level_stack.make
			push_level (info_level)
			set_level_threshold (info_level)
		end

feature -- Access

	loggers: LINKED_LIST [EPA_LOGGER]
			-- List of loggers which can output messages into different formats

feature -- Access

	level: INTEGER
			-- Current logging level
			-- Default: `info_level'
		do
			Result := level_stack.item
		end

	level_threshold: INTEGER
			-- Logging level threshold
			-- Only when `level' >= `level_threshold', messages are actually logged.
			-- Default: `info_level'

feature -- Logging level constants

	severe_level: INTEGER = 100
		-- Highest logging level

	info_level: INTEGER = 80

	fine_level: INTEGER = 60

	finer_level: INTEGER = 40

	finest_level: INTEGER = 20
		-- Lowest logging level

	is_level_valid (a_level: INTEGER): BOOLEAN
			-- Is `a_level' a valid logging level?
		do
			Result :=
				a_level = severe_level or else
				a_level = info_level or else
				a_level = fine_level or else
				a_level = finer_level or else
				a_level = finest_level
		end

	is_logging_needed: BOOLEAN
			-- Is logging needed?
			-- Criterion: `level' >= `level_threshold'.
		do
			Result := level >= level_threshold
		end

feature -- Setting

	push_level (a_level: INTEGER)
			-- Store current `level' in a stack and
			-- set `level' with `a_level'.
		require
			a_level_valid: is_level_valid (a_level)
		do
			level_stack.extend (a_level)
		end

	pop_level
			-- Pop the last stored log level
		do
			if not level_stack.is_empty then
				level_stack.remove
			end
		end

	set_level_threshold (a_level_threshold: INTEGER)
			-- Set `level_threshold' with `a_leve'.
		require
			a_level_threshold_valid: is_level_valid (a_level_threshold)
		do
			level_threshold := a_level_threshold
		ensure
			level_threshold_set: level_threshold = a_level_threshold
		end

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
			if is_logging_needed then
				loggers.do_all (agent {EPA_LOGGER}.put_string (a_string))
			end
		end

	put_line (a_string: STRING)
			-- Log `a_string' as a line.
		local
			l_str: STRING
		do
			if is_logging_needed then
				create l_str.make (a_string.count + 1)
				l_str.append (a_string)
				l_str.append_character ('%N')
				loggers.do_all (agent {EPA_LOGGER}.put_string (l_str))
			end
		end

	put_line_with_time (a_string: STRING)
			-- Log `a_string' as a line, and append current time or elapsed time in front of that string.
		local
			l_str: STRING
		do
			if is_logging_needed then
				create l_str.make (a_string.count + 1)
				l_str.append (a_string)
				l_str.append_character ('%N')
				put_string_with_time (l_str)
			end
		end

	put_string_with_time (a_string: STRING)
			-- Log `a_string', and append current time or elapsed time in front of that string.
		local
			l_str: STRING
		do
			if is_logging_needed then
				create l_str.make (a_string.count + 32)
				l_str.append (time_prefix)
				l_str.append (a_string)
				put_string (l_str)
			end
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

	level_stack: LINKED_STACK [INTEGER]
			-- Stack for logging levels

end
