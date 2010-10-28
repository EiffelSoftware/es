note
	description: "All status messages"
	author: "Teseo Schneider, Marco Piccioni"
	date: "07.04.2009"

class
	SET_STATUS_MESSAGES

feature -- Filter-related

        main_filter_dir_created (name: STRING): STRING
                        -- Root filter directory creation message.
                do
                        Result := "Root filter directory created at %"" + name + "%"."
                end

feature -- Project release-related

        release (release_path: STRING): STRING
                        -- Project released message.
                do
                        Result := "Project released at %"" + release_path + "%" folder."
                end

        handler_released (path: STRING): STRING
                        -- Handlers released message.
                do
                        Result := "Handlers released in %"" + path + "%"."
                end

feature -- Handler-related

        main_handler_dir_creation (name: STRING): STRING
                        -- Project handler directory creation message.
                do
                        Result := "Project handler directory created at: %"" + name + "%"."
                end

        repo_handlers_dir_creation (name: STRING): STRING
                        -- Repository handlers directory creation message.
                do
                        Result := "Repository handler directory created at: %"" + name + "%"."
                end

        main_handler_created (path: STRING): STRING
                        -- Main handler file creation message.
                do
                        Result := "Main handler file (%"" + path + "%") created."
                end

feature -- Errors

        not_enough_releases: STRING
                        -- Not enough releases message.
                do
                        Result := "There are not enough releases to create a schema evolution handler. You must have at least 2 releases."
                end


        config_file_not_found: STRING
                        -- Configuration file not found message.
                do
                        Result := "The configuration file was not found."
                end

        handler_folder_not_found: STRING
                        -- Handler folder not found message.
                do
                        Result := "The handler folder was not found."
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
