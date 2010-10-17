note
	description: "Class that represents a term for contracts (precondition, postconditions)"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_CONTRACT_TERM

inherit
	SEM_EQUATION_TERM
		redefine
			queryable,
			is_precondition,
			is_postcondition,
			is_human_written,
			is_contract
		end

create
	make

feature{NONE} -- Initialization

	make (a_queryable: like queryable; a_equation: like equation; a_precondition: BOOLEAN; a_human_written: BOOLEAN; a_is_negated: BOOLEAN)
			-- Initialize Current.
		do
			initialize
			queryable := a_queryable
			equation := a_equation
			is_precondition := a_precondition
			is_human_written := a_human_written
			set_is_negated (a_is_negated)
		end

feature -- Access

	queryable: SEM_TRANSITION
			-- Transition where current term is from

	text: STRING
			-- Text representation of Current
		do
			create Result.make (128)
			if is_precondition then
				Result.append (once "Precondition, ")
			else
				Result.append (once "Postcondition, ")
			end
			if is_human_written then
				Result.append (once "human-written, ")
			end
			Result.append (equation.text)
		end

feature -- Status report

	is_contract: BOOLEAN = True
			-- Is current a contract term?

	is_precondition: BOOLEAN
			-- Is current contract a precondition?

	is_postcondition: BOOLEAN
			-- Is current contract a postcodition?
		do
			Result := not is_precondition
		end

	is_human_written: BOOLEAN
			-- Is current contract human-written?

feature -- Process

	process (a_visitor: SEM_TERM_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_contract_term (Current)
		end


end
