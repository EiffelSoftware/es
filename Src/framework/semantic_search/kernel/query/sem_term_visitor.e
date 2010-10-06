note
	description: "Visitor for {SEM_TERM}s"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_TERM_VISITOR

feature -- Process

	process_change_term (a_term: SEM_CHANGE_TERM)
			-- Process `a_term'.
		deferred
		end

	process_contract_term (a_term: SEM_CONTRACT_TERM)
			-- Process `a_term'.
		deferred
		end

	process_property_term (a_term: SEM_PROPERTY_TERM)
			-- Process `a_term'.
		deferred
		end

	process_variable_term (a_term: SEM_VARIABLE_TERM)
			-- Process `a_term'.
		deferred
		end

end
