note
	description: "Logging manager handling multiple loggers."
	author: "Jason Yi Wei, Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	ELOG_LOG_MANAGER

inherit{NONE}
	ELOG_CONSTANTS

create
	make,
	make_with_loggers,
	make_with_logger_array

feature {NONE} -- Initialization

	make
			-- Initialize logger.
			-- Default: `Error_level'.
		do
			create loggers.make
			create level_stack.make
			push_level (Error_level)
			set_level_threshold (Error_level)
		end

	make_with_loggers (a_loggers: LINEAR [ELOG_LOGGER])
			-- Initialize current with `a_loggers'.
			-- Default: `Error_level'.
		do
			make
			a_loggers.do_all (agent extend_with_logger)
		end

	make_with_logger_array (a_loggers: ARRAY [ELOG_LOGGER])
			-- Initialize current with `a_loggers'.
			-- Default: `Error_level'.
		do
			make
			a_loggers.do_all (agent extend_with_logger)
		end

feature -- Access

	loggers: LINKED_LIST [ELOG_LOGGER]
			-- List of loggers which can output messages using different formats and media.

	level: INTEGER
			-- Current logging level.
			-- Default: `Error_level'.
		do
			Result := level_stack.item
		end

	level_threshold: INTEGER
			-- Logging level threshold.
			-- Only when `level' >= `level_threshold', messages are actually logged.
			-- Default: `Error_level'.			

	is_current_logging_level_active: BOOLEAN
			-- Is `level' >= `level_threshold'?
		do
			Result := level >= level_threshold
		end

	time_logging_mode: INTEGER
			-- Mode to log time information.
			-- Default: `no_time_logging_mode'
			-- See `is_time_logging_mode_valid' for possible values for this attribute.

	start_time: detachable DATE_TIME
			-- Start time of current logging
		do
			if start_time_internal = Void then
				create start_time_internal.make_now
			end
			Result := start_time_internal
		end

	duration_until_now: DATE_TIME_DURATION
			-- Duration of current program run from `start_time' until now.
		local
			time_now: DATE_TIME
		do
			create time_now.make_now
			Result := time_now.duration
			Result := Result.time_to_canonical
		end

feature -- Logging basic operations

	push_level (a_level: INTEGER)
			-- Store current `level' in a stack.
			-- Set `level' to `a_level'.
		require
			a_level_valid: is_level_valid (a_level)
		do
			level_stack.extend (a_level)
		end

	pop_level
			-- Pop the last stored log level.
		do
			if not level_stack.is_empty then
				level_stack.remove
			end
		end

	extend_with_logger (a_logger: ELOG_LOGGER)
			-- Extend `loggers' with `a_logger'.
		do
			loggers.extend (a_logger)
		end

	put_string (a_string: STRING)
			-- Log `a_string'.
		do
			if is_current_logging_level_active then
				across loggers as l_loggers loop
					l_loggers.item.put_string (a_string)
				end
			end
		end

	put_string_with_level (a_string: STRING; a_level: INTEGER)
			-- Log `a_string' at log level `a_level'.
		require
			a_level_valid: is_level_valid (a_level)
		local
			l_str: STRING
		do
			push_level (a_level)
			if is_current_logging_level_active then
				create l_str.make (a_string.count + String_offset)
				l_str.append (level_prefix (a_level))
				l_str.append (a_string)
				put_string (l_str)
			end
			pop_level
		end

	put_string_with_time (a_string: STRING)
			-- Log `a_string'. Append current or elapsed time.
		local
			l_str: STRING
		do
			if is_current_logging_level_active then
				create l_str.make (a_string.count + String_offset)
				a_string.append (time_prefix)
				l_str.append (a_string)
				put_string (l_str)
			end
		end

	put_string_with_level_and_time (a_string: STRING; a_level: INTEGER)
			-- Log `a_string' at log level `a_level'. Append current or elapsed time.
		require
			a_level_valid: is_level_valid (a_level)
		local
			l_str: STRING
		do
			push_level (a_level)
			if is_current_logging_level_active then
				create l_str.make (a_string.count + String_offset)
				l_str.append (level_prefix (a_level))
				l_str.append (time_prefix)
				l_str.append (a_string)
				put_string (l_str)
			end
			pop_level
		end

	put_string_with_time_and_level (a_string: STRING; a_level: INTEGER)
			-- Log `a_string'. Append current or elapsed time and then log level `a_level'.
		require
			a_level_valid: is_level_valid (a_level)
		local
			l_str: STRING
		do
			push_level (a_level)
			if is_current_logging_level_active then
				create l_str.make (a_string.count + String_offset)
				l_str.append (time_prefix)
				l_str.append (level_prefix (a_level))
				l_str.append (a_string)
				put_string (l_str)
			end
			pop_level
		end

	put_line (a_string: STRING)
			-- Log `a_string' as a line.
		local
			l_str: STRING
		do
			create l_str.make (a_string.count + 2)
			l_str.append (a_string)
			l_str.append_character ('%N')
			put_string (l_str)
		end

	put_line_with_level (a_string: STRING; a_level: INTEGER)
			-- Log `a_string' at `a_level' as a line.
		require
			a_level_valid: is_level_valid (a_level)
		local
			l_str: STRING
		do
			create l_str.make (a_string.count + String_offset + 2)
			push_level (a_level)
			l_str.append (level_prefix (a_level))
			l_str.append (a_string)
			l_str.append_character ('%N')
			put_string (l_str)
			pop_level
		end

	put_line_with_time (a_string: STRING)
			-- Log `a_string' as a line. Prepend current or elapsed time.
		local
			l_str: STRING
		do
			create l_str.make (a_string.count + String_offset + 2)
			l_str.append (time_prefix)
			l_str.append (a_string)
			l_str.append_character ('%N')
			put_string (l_str)
		end

	put_line_with_level_and_time (a_string: STRING; a_level: INTEGER)
			-- Log `a_string' as a line prepending `a_level' and then current or elapsed time.
		require
			a_level_valid: is_level_valid (a_level)
		local
			l_str: STRING
		do
			create l_str.make (a_string.count + String_offset + 2)
			push_level (a_level)
			l_str.append (level_prefix (a_level))
			l_str.append (time_prefix)
			l_str.append (a_string)
			l_str.append_character ('%N')
			put_string (l_str)
			pop_level
		end

	put_line_with_time_and_level (a_string: STRING; a_level: INTEGER)
			-- Log `a_string' as a line prepending current or elapsed time and then log level `a_level'.
		require
			a_level_valid: is_level_valid (a_level)
		local
			l_str: STRING
		do
			create l_str.make (a_string.count + String_offset + 2)
			push_level (a_level)
			l_str.append (time_prefix)
			l_str.append (level_prefix (a_level))
			l_str.append (a_string)
			l_str.append_character ('%N')
			put_string (l_str)
			pop_level
		end

feature -- Status setters

	set_level_threshold (a_level_threshold: INTEGER)
			-- Set `level_threshold' to `a_level_threshold'.
		require
			a_level_threshold_valid: is_level_valid (a_level_threshold)
		do
			level_threshold := a_level_threshold
		ensure
			level_threshold_set: level_threshold = a_level_threshold
		end

	set_time_logging_mode (a_mode: INTEGER)
			-- Set `time_logging_mode' to `a_mode'.
		require
			a_mode_valid: is_time_logging_mode_valid (a_mode)
		do
			time_logging_mode := a_mode
		ensure
			time_logging_mode_set: time_logging_mode = a_mode
		end

	set_duration_time_mode
			-- Set `time_logging_mode' to `duration_time_logging_mode'.
			-- Set `start_time' as now.
		do
			set_time_logging_mode (duration_time_logging_mode)
			set_start_time_as_now
		end

	set_absolute_time_mode
			-- Set `time_logging_mode' to `absolute_time_logging_mode'.
		do
			set_time_logging_mode (absolute_time_logging_mode)
		end

	set_start_time (a_time: like start_time)
			-- Set `start_time' to `a_time'.
		do
			start_time_internal := a_time
		ensure
			start_time_set: start_time = a_time
		end

	set_start_time_as_now
			-- Set `start_time' as the system time now.
		local
			l_date_time: DATE_TIME
		do
			create l_date_time.make_now
			set_start_time (l_date_time)
		end

feature {NONE} -- Implementation

	time_prefix: STRING
			-- Prefix for time
		local
			l_date_time: DATE_TIME
			l_date_time_duration: DATE_TIME_DURATION
		do
			create Result.make (32)
			if time_logging_mode = duration_time_logging_mode then
				l_date_time_duration := duration_until_now
				l_date_time_duration.set_origin_date_time (start_time_internal)
				Result.append (format_date_time_duration (l_date_time_duration))
				Result.append_character (':')
				Result.append_character (' ')
			elseif time_logging_mode = absolute_time_logging_mode then
				create l_date_time.make_now
				Result.append (l_date_time.out)
				Result.append_character (':')
				Result.append_character (' ')
			end
		end

	format_date_time_duration (l_date_time_duration: DATE_TIME_DURATION): STRING
				-- Basic format for a {DATE_TIME_DURATION} object.
				-- A configurable version of this should really be provided by some formatter class in cluster time/format.
		do
			create Result.make (64)
			Result.append (once "Elapsed time (y:m:d:h:m:s): ")
			Result.append (l_date_time_duration.year.out)
			Result.append_character (':')
			Result.append (l_date_time_duration.month.out)
			Result.append_character (':')
			Result.append (l_date_time_duration.year.out)
			Result.append_character (':')
			Result.append (l_date_time_duration.hour.out)
			Result.append_character (':')
			Result.append (l_date_time_duration.minute.out)
			Result.append_character (':')
			Result.append (l_date_time_duration.second.out)
		end

	start_time_internal: detachable DATE_TIME
			-- Cache for `start_time'

feature {NONE} -- Implementation

	level_stack: LINKED_STACK [INTEGER]
			-- Stack for logging levels

	level_prefix (a_level: INTEGER): STRING
			-- Prefix for `a_level'
		do
			create Result.make (24)
			Result.append_character ('[')
			Result.append (logging_level_as_string (a_level))
			Result.append_character (']')
			Result.append_character (' ')
		end

end
