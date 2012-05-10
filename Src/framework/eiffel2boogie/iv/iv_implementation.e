note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_IMPLEMENTATION

inherit

	IV_DECLARATION

create
	make

feature {NONE} -- Initialization

	make (a_procedure: IV_PROCEDURE)
			-- Initialize implementation of procedure `a_procedure'.
		require
			a_procedure_attached: attached a_procedure
		do
			procedure := a_procedure
			create locals.make
			create body.make_name ("entry")
		ensure
			procedure_set: procedure = a_procedure
		end

feature -- Access

	procedure: IV_PROCEDURE
			-- Procedure that this implementation is about.

	locals: LINKED_LIST [IV_ENTITY_DECLARATION]
			-- Local variables.

	body: IV_BLOCK
			-- List of statements.

feature -- Element change

	add_local (a_name: STRING; a_type: IV_TYPE)
			-- Add local variable with name `a_name' and type `a_type'.
		do
			locals.extend (create {IV_ENTITY_DECLARATION}.make (a_name, a_type))
		ensure
			local_added: locals.last.name ~ a_name
			local_added: locals.last.type = a_type
		end

feature -- Visitor

	process (a_visitor: IV_UNIVERSE_VISITOR)
			-- <Precursor>
		do
			a_visitor.process_implementation (Current)
		end

invariant
	locals_attached: attached locals
	body_attached: attached body

end
