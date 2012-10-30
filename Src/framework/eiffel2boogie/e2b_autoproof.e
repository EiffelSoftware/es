note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_AUTOPROOF

create
	make

feature {NONE} -- Initialization

	make
			-- Intialize AutoProof.
		do
			reset
		end

feature -- Access

	input: E2B_TRANSLATOR_INPUT
			-- Input for translator.

	last_result: detachable E2B_RESULT
			-- Result of last verification.
		do
			if verify_task /= Void and verify_task.verifier_result /= Void then
				Result := verify_task.verifier_result
			end
		end

feature -- Status report

	is_running: BOOLEAN
			-- Is verification running?
		do
			Result := verify_task /= Void and then verify_task.has_next_step
		end

	is_finished: BOOLEAN
			-- Is verification finished?
		do
			Result := verify_task = Void or else not verify_task.has_next_step
		end

feature -- Element change

	add_class (a_class: CLASS_C)
			-- Add class `a_class' to be verified.
		do
			input.add_class (a_class)
		end

	add_feature (a_feature: FEATURE_I)
			-- Add feature `a_feature' to be verified.
		do
			input.add_feature (a_feature)
		end

	add_notification (a_agent: PROCEDURE [ANY, TUPLE [E2B_RESULT]])
			-- Add agent that gets notified when verification is finished.
		require
			a_agent_attached: attached a_agent
		do
			notification_agents.extend (a_agent)
		end

feature -- Basic operations

	reset
			-- Reset AutoProof.
		do
			create input.make
			create notification_agents.make
			verify_task := Void
		ensure
			not_running: not is_running
		end

	verify
			-- Verify input.
		require
			not_running: not is_running
		local
			l_notify_task: E2B_NOTIFY_TASK
		do
			if attached rota as l_rota then
				create verify_task.make (input)
				create l_notify_task.make (verify_task)
				l_notify_task.notification_agents.append (notification_agents)
				verify_task.append_task (l_notify_task)
				if not rota.has_task (verify_task) then
					rota.run_task (verify_task)
				end
			end
		ensure
			running_or_finished: is_running or is_finished
		end

feature -- Implementation

	verify_task: detachable E2B_VERIFY_TASK
			-- Verify task.

	notification_agents: LINKED_LIST [PROCEDURE [ANY, TUPLE [E2B_RESULT]]]
			-- List of notification agents.

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
