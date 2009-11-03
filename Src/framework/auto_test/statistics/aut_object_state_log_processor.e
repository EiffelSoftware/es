note
	description: "AutoTest log processor to analyze object states."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_OBJECT_STATE_LOG_PROCESSOR

inherit
	AUT_LOG_PROCESSOR

	AUT_PROXY_EVENT_RECORDER
		rename
			make as recorder_make
		redefine
			process_invoke_feature_request,
			process_create_object_request,
			process_object_state_request
		end

create
	make

feature{NONE} -- Initialization

	make (a_system: like system; a_config: like configuration; a_session: AUT_SESSION) is
			-- Initialize.
		require
			a_system_attached: a_system /= Void
			a_config_attached: a_config /= Void
			a_session_attached: a_session /= Void
		do
			system := a_system
			configuration := a_config
			session := a_session
			recorder_make (system)
		end

feature -- Process

	process is
			-- Process log file specified in `configuration'.
		local
			l_log_publisher: AUT_RESULT_REPOSITORY_PUBLISHER
			l_log_stream: KL_TEXT_INPUT_FILE
			l_output_file: KL_TEXT_OUTPUT_FILE
			l_log_parser: AUT_LOG_PARSER
		do
				-- Load log file.
			create l_log_stream.make (configuration.log_file_path)
			l_log_stream.open_read
			create l_log_parser.make (system, session.error_handler)
			l_log_parser.add_observer (Current)
			l_log_parser.parse_stream (l_log_stream)
			l_log_stream.close
		end

feature{NONE} -- Process

	process_invoke_feature_request (a_request: AUT_INVOKE_FEATURE_REQUEST)
			-- <Precursor>
		do
			Precursor (a_request)
			to_implement ("Implement if you want to do something with the feature invocation requrest. 3.11.2009 Jasonw")
		end

	process_create_object_request (a_request: AUT_CREATE_OBJECT_REQUEST)
			-- <Precursor>
		do
			Precursor (a_request)
			to_implement ("Implement if you want to do something with the object creation request. 3.11.2009 Jasonw")
		end

	process_object_state_request (a_request: AUT_OBJECT_STATE_REQUEST)
			-- Process `a_request'.
		do
			Precursor (a_request)
			to_implement ("Implement if you want to do something with the object state. 3.11.2009 Jasonw")
		end

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
