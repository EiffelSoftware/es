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
			if
				blackboard.executions.running_executions.is_empty and
				blackboard.executions.waiting_executions.is_empty and
				not eiffel_project.is_compiling and
				not blackboard.tools.is_empty
			then
				current_class_index := current_class_index + 1
				if current_class_index > blackboard.data.classes.count then
					current_class_index := 1
				end
--				io.put_string ("Think: selected class " + current_class.class_name + "%N")
			end
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

				l_class := current_class
				if l_class.is_compiled and then l_class.is_stale then
					create l_input.make
					l_input.add_class (current_class.compiled_class)
					if l_class.is_static_score_stale then
						l_tool := blackboard.default_tool_of_type ({EBB_TOOL_CATEGORY}.static_verification)
					else
						l_tool := blackboard.default_tool_of_type ({EBB_TOOL_CATEGORY}.dynamic_verification)
					end
					if l_tool /= Void then
						l_configuration := l_tool.default_configuration

--						io.put_string ("Execute: selected tool " + l_tool.name + "%N")
							-- Add tool execution to waiting list
						create l_execution.make (l_tool, l_configuration, l_input)
						blackboard.executions.queue_tool_execution (l_execution)
					end
				end
			end
		end

feature {NONE} -- Implementation

	current_class_index: INTEGER
			-- Index of current class being verified.

	current_class: EBB_CLASS_DATA
			-- Current class being verified.
		do
			Result := blackboard.data.classes.i_th (current_class_index)
		end


end
