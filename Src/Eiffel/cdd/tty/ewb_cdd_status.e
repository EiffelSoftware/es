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
		do
			io.new_line

			if cdd_manager.is_project_initialized then
				if command_line_io.confirmed_with_default (confirm_extracting, True) then
					if not cdd_manager.is_extracting_enabled then
						cdd_manager.enable_extracting
					end
				else
					if cdd_manager.is_extracting_enabled then
						cdd_manager.disable_extracting
					end
				end
			else
				io.put_string ("Please compile project first.")
			end
		end


end
