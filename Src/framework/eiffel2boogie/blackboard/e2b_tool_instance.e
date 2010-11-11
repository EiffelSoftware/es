note
	description: "Summary description for {E2B_TOOL_INSTANCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TOOL_INSTANCE

inherit

	EBB_TOOL_INSTANCE

create
	make

feature -- Status report

	is_running: BOOLEAN
			-- Is instance running?
		do
			Result := verify_task.has_next_step
		end

feature {EBB_TOOL_EXECUTION} -- Basic operations

	start
			-- Start instance.
		local
			l_input: E2B_TRANSLATOR_INPUT
			l_update_blackboard_task: E2B_UPDATE_BLACKBOARD_TASK
		do
			create l_input.make
			l_input.class_list.append (input.classes)
			create verify_task.make (l_input)
			create l_update_blackboard_task.make (Current, verify_task)
			verify_task.append_task (l_update_blackboard_task)

			rota.run_task (verify_task)
		end

	cancel
			-- Cancel instance.
		do
			verify_task.cancel
		end

feature {NONE} -- Implementation

	verify_task: E2B_VERIFY_TASK
			-- Verification task

	frozen rota: ROTA_S
			-- Access to rota service
		local
			l_service_consumer: SERVICE_CONSUMER [ROTA_S]
		do
			create l_service_consumer
			if l_service_consumer.is_service_available then
				Result := l_service_consumer.service
			else
				check False end
			end
		end

end
