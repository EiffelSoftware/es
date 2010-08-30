note
	description: "Summary description for {SEM_TRANSITION_WRITER2}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_TRANSITION_WRITER2 [G -> SEM_TRANSITION]

inherit
	SEM_DOCUMENT_WRITER2 [G]

feature -- Access

	precondition_veto_agents: LINKED_LIST [FUNCTION [ANY, TUPLE [EPA_EQUATION], BOOLEAN]]
			-- List of agents to decide if a precondition is to be written into result document
			-- A precondition is selected if all agents returns True.
			-- If the list is empty, all preconditions are selected by default.
		do
			if precondition_veto_agents_cache = Void then
				create precondition_veto_agents_cache.make
			end
			Result := precondition_veto_agents_cache
		end

	postcondition_veto_agents: LINKED_LIST [FUNCTION [ANY, TUPLE [EPA_EQUATION], BOOLEAN]]
			-- List of agents to decide if a postcondition is to be written into result document
			-- A postcondition is selected if all agents returns True.
			-- If the list is empty, all postconditions are selected by default.
		do
			if postcondition_veto_agents_cache = Void then
				create postcondition_veto_agents_cache.make
			end
			Result := postcondition_veto_agents_cache
		end

	auxiliary_field_agents: LINKED_LIST [FUNCTION [ANY, TUPLE [a_transition: like queryable], DS_HASH_SET [SEM_DOCUMENT_FIELD]]]
			-- Actions to return a list of auxiliary fields for `a_transition'
			-- If the list is empty, no auxiliary field is used.
		do
			if auxiliary_field_agents_cache = Void then
				create auxiliary_field_agents_cache.make
			end
			Result := auxiliary_field_agents_cache
		end

feature{NONE} -- Implementation

	precondition_veto_agents_cache: detachable like precondition_veto_agents
			-- Cache for `precondition_veto_agents'

	postcondition_veto_agents_cache: detachable like postcondition_veto_agents
			-- Cache for `postcondition_veto_agents'

	auxiliary_field_agents_cache: detachable like auxiliary_field_agents
			-- Cache for `auxiliary_fields_agent'

feature{NONE} -- Writing

	write_auxiliary_fields
			-- Write auxiliary fields retrieved from `auxiliary_field_agents' into `output'.
		local
			l_fields: DS_HASH_SET [SEM_DOCUMENT_FIELD]
		do
				-- Collect all auxiliary fields from `auxiliary_field_agents'.
			create l_fields.make (10)
			l_fields.set_equality_tester (document_field_equality_tester)
			across auxiliary_field_agents as l_agents loop
				l_fields.append_last (l_agents.item.item ([queryable]))
			end

				-- Write collected auxiliary fields into `output'.
			l_fields.do_all (agent write_field)
		end

end
