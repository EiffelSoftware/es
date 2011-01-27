note
	description: "Constants for the logging library."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

frozen class
	ELOG_CONSTANTS

feature -- Logging Level Constants

	Fatal_level: INTEGER = 100
		-- Level for the most severe error situations, typically leading to aborting the application.

	Error_level: INTEGER = 80
		-- Level for standard errors.

	Warning_level: INTEGER = 60
		-- Level for potential errors. Further investigation is suggested.

	Info_level: INTEGER = 40
		-- Level for informational messages, useful to track important operations.

	Debug_level: INTEGER = 20
		-- Level providing the most fine-grained information, useful when debugging.

feature -- Time Mode Constants

	Duration_time_logging_mode: INTEGER = 1
			-- Log time duration from `start_time' to now.

	Absolute_time_logging_mode: INTEGER = 2
			-- Log time as absolute time now.

	No_time_logging_mode: INTEGER = 3
			-- No time logging.

feature -- Formatting Constants

	String_offset: INTEGER = 32
			-- Space for the log message, including logging level and time, excluding the message itself.

feature -- Validity checks

	is_time_logging_mode_valid (a_mode: INTEGER): BOOLEAN
			-- Is `a_mode' a valid time logging mode?
		do
			Result :=
				a_mode = Duration_time_logging_mode or
				a_mode = Absolute_time_logging_mode or
				a_mode = No_time_logging_mode
		end


	is_level_valid (a_level: INTEGER): BOOLEAN
			-- Is `a_level' a valid logging level?
		do
			Result :=
				a_level = Fatal_level or
				a_level = Error_level or
				a_level = Warning_level or
				a_level = Info_level or
				a_level = Debug_level
		end

feature -- Output

	logging_level_as_string (a_level: INTEGER): STRING
			-- Logging level expressed as a string.
		require
			a_level_acceptable: is_level_valid (a_level)
		do
			inspect	a_level
			when Fatal_level then
				Result := once "FATAL"
			when Error_level then
				Result := once "ERROR"
			when Warning_level then
				Result := once "WARNING"
			when Info_level then
				Result := once "INFO"
			when Debug_level then
				Result := once "DEBUG"
			else
				Result := once "Logging level undefined"
			end
		end
end
