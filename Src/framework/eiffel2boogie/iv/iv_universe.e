note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_UNIVERSE

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize universe.
		do
			create declarations.make
		end

feature -- Access

	declarations: LINKED_LIST [IV_DECLARATION]
			-- List of top-level declarations.

	procedure_named (a_name: STRING): detachable IV_PROCEDURE
			-- Boogie procedure with name `a_name'.
		do
			from
				declarations.start
			until
				declarations.after or Result /= Void
			loop
				if attached {IV_PROCEDURE} declarations.item as l_proc and then l_proc.name ~ a_name then
					Result := l_proc
				end
				declarations.forth
			end
		end


feature -- Element change

	add_declaration (a_declaration: IV_DECLARATION)
			-- Add top-level declaration to `declarations'.
		require
			a_delcaration_attached: attached a_declaration
		do
			declarations.extend (a_declaration)
		ensure
			a_declaration_added: declarations.last = a_declaration
		end

feature -- Visitor

	process (a_visitor: IV_UNIVERSE_VISITOR)
			-- Process universe with `a_visitor'.
		do
			across declarations as i loop
				i.item.process (a_visitor)
			end
		end

	process_non_built_in (a_visitor: IV_UNIVERSE_VISITOR)
			-- Process declarations that are not built-in with `a_visitor'.
		do
			across declarations as i loop
				if not i.item.is_built_in then
					i.item.process (a_visitor)
				end
			end
		end

end
