note
	description: "Tool GUI implementation"
	author: "Teseo Schneider, Marco Piccioni"
	date: "07.04.09"

class
	SCHEMA_EVOLUTION_TOOL

inherit
	EV_FRAME

create
	make

feature -- Creation

	make
			-- Initialize tool
		local
			tmp: EV_VERTICAL_BOX
			buttons: EV_FIXED
		do
			create status.make
			default_create
			set_style (1)
			buttons := create_button_menu
			create tmp
			tmp.extend (buttons)
			tmp.disable_item_expand (buttons)
			tmp.extend (status)
			extend(tmp)
		ensure
			status_exist: status /= Void
		end

feature {NONE} -- Implementation

	status: SET_MESSAGE_BOX
		-- Status messages.

	create_button_menu: EV_FIXED
			-- Build the menu.
		local
			tmp: EV_BUTTON
			x:INTEGER
		do
			create Result
			create tmp.make_with_text_and_action ("Release", agent control (agent release))
			Result.extend(tmp)
			Result.set_item_size (tmp, tmp.width, tmp.height)
			Result.set_item_position (tmp, 0,0)
			x := tmp.width + 5
			create tmp.make_with_text_and_action ("Create Handler", agent control (agent schema_evolution_handler))
			Result.extend(tmp)
			Result.set_item_size (tmp, tmp.width, tmp.height)
			Result.set_item_position (tmp, x, 0)
			x := x + tmp.width
			create tmp.make_with_text_and_action ("Release Handler", agent control (agent release_schema_evolution_handler))
			Result.extend(tmp)
			Result.set_item_size (tmp, tmp.width, tmp.height)
			Result.set_item_position (tmp, x, 0)
			x := x + tmp.width + 5
			create tmp.make_with_text_and_action ("Create Filter", agent control(agent filter))
			Result.extend(tmp)
			Result.set_item_size (tmp, tmp.width, tmp.height)
			Result.set_item_position (tmp, x, 0)
			x := x + tmp.width
		end

feature {NONE} -- Sanity checks

	control (action: PROCEDURE [ANY, TUPLE])
			-- If the config file exists perform `action', else create the file
		require
			action_not_void: action /= Void
		local
			file: PLAIN_TEXT_FILE
			creator: SET_CONFIG_FILE_CREATOR
			const: SET_UTILITY_AND_CONSTANTS
		do
			create const
			create file.make (const.current_dir + const.separator + const.config_file)
			if file.exists and file.is_readable then
				action.call (Void)
			else
				create creator.make (action)
				creator.display ("")
			end
		end


feature {NONE} -- Actions

	release
			-- Action triggered when clicking on `release'.
		local
			releaser: SET_RELEASER
			messages: DS_ARRAYED_LIST[STRING]
		do
			create releaser.make
			messages := releaser.release
			status.print_messages (messages)
		end

	schema_evolution_handler
			-- Schema evolution handler button click.
		local
			tmp: SET_HANDLER_GUI
		do
			create tmp.make (status)
		end


	release_schema_evolution_handler
			-- Release the schema evolution handler.
		local
			releaser: SET_RELEASER
		do
			create releaser.make
			status.print_messages (releaser.release_schema_evolution_handler)
		end

feature {NONE} -- Filter

	filter
			-- Fiter creation
		local
			tmp: SET_FILTER_GUI
		do
			create tmp
			tmp.filter
		end

invariant
	-- Insert invariant here
note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
