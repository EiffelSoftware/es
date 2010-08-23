note
	description: "Parent class for all tools which work on the blackboard."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EBB_TOOL

feature -- Access

	name: attached STRING
			-- Name of tool.
		deferred
		end

	description: attached STRING
			-- Description of tool.
		deferred
		end

	configurations: attached LINKED_LIST [attached EBB_TOOL_CONFIGURATION]
			-- List of available tool configurations.
		deferred
		ensure
			not_empty: not Result.is_empty
		end

	default_configuration: attached EBB_TOOL_CONFIGURATION
			-- Default tool configuration.
		do
			Result := configurations.first
		end

feature -- Basic operations

	create_new_instance (a_execution: attached EBB_TOOL_EXECUTION)
			-- Create a new instance of this tool to execute `a_execution'.
		require
			correct_tool: a_execution.tool = Current
		deferred
		ensure
			last_instance_attached: attached last_instance
		end

	last_instance: detachable EBB_TOOL_INSTANCE
			-- Last created instance, if any.
		deferred
		end

end
