note
	description: "A basic control for the blackboard."
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_BASIC_CONTROL

inherit

	EBB_CONTROL

	SHARED_EIFFEL_PROJECT

create
	make

feature -- Access

	name: STRING = "Basic"
			-- <Precursor>

feature -- Basic operations

	think
			-- <Precursor>
		do
		end

	create_new_tool_executions
			-- <Precursor>
		local
			l_class: EBB_CLASS_DATA
			l_input: EBB_TOOL_INPUT
			l_tool: EBB_TOOL
			l_configuration: EBB_TOOL_CONFIGURATION
			l_execution: EBB_TOOL_EXECUTION
		do
				-- Only launch new tool when:
				--  - no other tool is running
				--  - no other tool is waiting
				--  - no compilation is running
				--  - there is a tool
			if
				blackboard.executions.running_executions.is_empty and
				blackboard.executions.waiting_executions.is_empty and
				not eiffel_project.is_compiling and
				not blackboard.tools.is_empty
			then

				l_class := next_class
				if l_class = Void then
						-- Nothing to do
				else
						-- Create input set
					create l_input.make
					l_input.add_class (l_class.compiled_class)

						-- Select tool and configuration.
--					l_tool := blackboard.tools.i_th (1)
					l_tool := blackboard.tools.i_th (2)
					l_configuration := l_tool.default_configuration

						-- Add tool execution to waiting list
					create l_execution.make (l_tool, l_configuration, l_input)
					blackboard.executions.queue_tool_execution (l_execution)
				end
			end
		end

	next_class: detachable EBB_CLASS_DATA
			-- Select next class to work on.
		local
			l_classes: LIST [EBB_CLASS_DATA]
		do
			from
				l_classes := blackboard.data.classes
				l_classes.start
			until
				l_classes.after or attached Result
			loop
				if l_classes.item.is_stale and l_classes.item.is_compiled then
					Result := l_classes.item
				end
				l_classes.forth
			end
		end

	next_feature: detachable EBB_FEATURE_DATA
			-- Select next feature to work on.
		local
			l_features: LIST [EBB_FEATURE_DATA]
		do
			from
				l_features := blackboard.data.features
				l_features.start
			until
				l_features.after or attached Result
			loop
				if l_features.item.is_stale then
					Result := l_features.item
				end
				l_features.forth
			end
		end

end
