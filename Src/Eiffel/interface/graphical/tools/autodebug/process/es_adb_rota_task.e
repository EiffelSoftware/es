note
	description: "Summary description for {ES_ADB_ROTA_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ES_ADB_ROTA_TASK

inherit
	ROTA_TIMED_TASK_I

	ES_ADB_SHARED_INFO_CENTER

feature -- Access

	Is_interface_usable: BOOLEAN = True
			-- <Precursor>

	Sleep_time: NATURAL_32 = 400
			-- <Precursor>

	output_buffer: ES_ADB_PROCESS_OUTPUT_BUFFER
			-- Buffer to direct the output.

	on_start_actions: ACTION_SEQUENCE [TUPLE]
			-- Action to perform when the task starts.

	on_terminate_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to perform when the task terminates.

feature -- Operation

	start
			-- Start the task.
		do
			if on_start_actions /= Void then
				on_start_actions.call (Void)
			end
			rota.run_task (Current)
		end

	wrap_up
			-- Wrap up when the task terminates.
		do
			if on_terminate_actions /= Void then
				on_terminate_actions.call (Void)
			end
		end

feature -- Service

	frozen rota: ROTA_S
			-- Access to rota service
		local
			l_service_consumer: SERVICE_CONSUMER [ROTA_S]
		do
			create l_service_consumer
			if l_service_consumer.is_service_available and then l_service_consumer.service.is_interface_usable then
				Result := l_service_consumer.service
			end
		end



note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
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
