indexing
	description: "Objects that provide a tty command for changing cdd status"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_CDD_STATUS

inherit

	EWB_CDD_CMD

feature -- Access

	name: STRING is "Status"

	help_message: STRING is "Enable/disable and/or configure CDD"

	abbreviation: CHARACTER is 's'

feature -- Execution

	execute is
			-- Retrieve user input for configuring cdd.
		require else
			target_not_void: eiffel_universe.target /= Void
		local
			l_manager: CDD_MANAGER
			l_was_enabled, l_bool: BOOLEAN
		do
			l_manager := debugger_manager.cdd_manager

			io.new_line
			if l_manager.is_cdd_enabled then
				if not command_line_io.confirmed_with_default (confirm_enabling, True) then
					l_manager.disable_cdd
				end
			elseif command_line_io.confirmed_with_default (confirm_disabling, True) then
				l_manager.enable_cdd
			end

			if l_manager.is_cdd_enabled then
				if command_line_io.confirmed_with_default (confirm_extracting, True) then
					if not l_manager.is_extracting_enabled then
						l_manager.enable_extracting
					end
				else
					if l_manager.is_extracting_enabled then
						l_manager.disable_extracting
					end
				end

				if command_line_io.confirmed_with_default (confirm_capture_replay, False) then
					l_manager.enable_capture_replay
				else
					l_manager.disable_capture_replay
				end
			end
		end


end
