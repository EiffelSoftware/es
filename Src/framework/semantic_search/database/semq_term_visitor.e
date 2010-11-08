note
	description: "Visitor for {SEMQ_TERM}s"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEMQ_TERM_VISITOR

feature -- Process

	process_equation_term (a_term: SEMQ_EQUATION_TERM)
			-- Process `a_term'.
		deferred
		end

	process_variable_term (a_term: SEMQ_VARIABLE_TERM)
			-- Process `a_term'.
		deferred
		end

	process_meta_term (a_term: SEMQ_META_TERM)
			-- Process `a_term'.
		deferred
		end


end
