note
	description: "Load and analyze proxy_logs"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_LOG_LOADER

create
	make

feature{NONE} -- Initialization

	make (a_config: like configuration)
			-- Initialize.
		do
			configuration := a_config
		end

feature -- Access

	configuration: TEST_GENERATOR

feature -- Basic operations

	load
			-- Load log in `configuration'.`log_file_path' with log processor named `configuration'.`log_processor'.
		local
			l_processor_name: detachable STRING
			l_processor: AUT_LOG_PROCESSOR
		do
			l_processor_name := configuration.log_processor
			if l_processor_name /= Void then
				 l_processor_name.to_lower
				 if log_processors.has (l_processor_name) then
					l_processor := log_processors.item (l_processor_name)
					l_processor.set_configuration (configuration)
					l_processor.process
				 end
			end
		end

feature{NONE} -- Implementation

	log_processors: HASH_TABLE [AUT_LOG_PROCESSOR, STRING]
			-- Table of registered log processors
			-- [Log processor, name of the processor]
		do
			if log_processors_internal = Void then
				create log_processors_internal.make (5)
				log_processors_internal.compare_objects
				log_processors_internal.extend (create{AUT_RESULT_ANALYZER}.make (configuration.system, configuration), "ps")
			end
			Result := log_processors_internal
		end

	log_processors_internal: like log_processors
			-- Implementation of `log_processors'

;note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
