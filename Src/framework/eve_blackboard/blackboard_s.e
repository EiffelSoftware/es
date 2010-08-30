note
	description: "Service for accessing and controling the blackboard."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BLACKBOARD_S

inherit

	SERVICE_I

feature {NONE} -- Initalization

	initialize
			-- Initialize blackboard service.
		require
			data_attached: attached data
			control_attached: attached control
			tools_attached: attached tools
		local
			l_shared_project: SHARED_EIFFEL_PROJECT
		do
			create data_initialized_event
			create data_changed_event
			create tool_execution_changed_event
			create blackboard_started_event
			create blackboard_stopped_event

			create l_shared_project
			l_shared_project.eiffel_project.manager.load_agents.extend (agent data.update_from_universe)
			l_shared_project.eiffel_project.manager.load_agents.extend (agent data_initialized_event.publish ([]))
		end

feature -- Access

	data: attached EBB_SYSTEM_DATA
			-- Blackboard data for system.
		deferred
		end

	control: attached EBB_CONTROL
			-- Blackboard control.
		deferred
		end

	tools: attached LIST [attached EBB_TOOL]
			-- Available tools for blackboard.
		deferred
		end

feature -- Status report

	is_running: BOOLEAN
			-- Is blackboard service running?
		require
			usable: is_interface_usable
		do
			Result := control.is_running
		end

feature -- Status setting

	start
			-- Start blackboard service.
		require
			usable: is_interface_usable
		do
			if attached rota as l_rota then
				control.start
				if not rota.has_task (control) then
					rota.run_task (control)
				end
				blackboard_started_event.publish ([])
			end
		ensure
			running: attached rota implies is_running
		end

	stop
			-- Stop blackboard service.
		require
			usable: is_interface_usable
		do
			control.cancel
			blackboard_stopped_event.publish ([])
		ensure
			not_running: not is_running
		end

feature -- Basic operations

	register_tool (a_tool: attached EBB_TOOL)
			-- Register `a_tool' for the blackboard.
		do
			if not tools.has (a_tool) then
				tools.extend (a_tool)
			end
		ensure
			tool_added: tools.has (a_tool)
		end

feature -- Events

	data_initialized_event: EVENT_TYPE [TUPLE]
			-- Event that blackboard data has been initialized.
			-- This happens when a project is loaded.

	data_changed_event: EVENT_TYPE [TUPLE]
			-- Event that some blackboard data has been changed.

	tool_execution_changed_event: EVENT_TYPE [TUPLE]
			-- Event that some tool execution changed.

	blackboard_started_event: EVENT_TYPE [TUPLE]
			-- Event that blackboard execution has started.

	blackboard_stopped_event: EVENT_TYPE [TUPLE]
			-- Event that blackboard executino has stopped.

	on_class_changed (a_class: CLASS_I)
			-- Handle event that `a_class' has been changed.
			-- I.e. added, removed, or a feature was added/removed/renamed.
		do
				-- TODO: Check if class had been removed. HOW?
			if False then
				data.remove_class (a_class)
			else
				if data.has_class (a_class) then
					data.update_class (a_class)
				else
					data.add_class (a_class)
				end
			end
		end

feature {NONE} -- Implementation

	frozen rota: detachable ROTA_S
			-- Access to rota service
		local
			l_service_consumer: SERVICE_CONSUMER [ROTA_S]
		do
			create l_service_consumer
			if l_service_consumer.is_service_available and then l_service_consumer.service.is_interface_usable then
				Result := l_service_consumer.service
			end
		end

end
