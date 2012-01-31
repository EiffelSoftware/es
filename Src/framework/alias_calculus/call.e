note
	description: "Representation of a Call instruction, qualified or unqualified."
	author: "Bertrand Meyer"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CALL

inherit
	SIMPLE
		redefine is_applicable end

	SIZING
		undefine out end

feature -- Initialization

	make (pn: STRING; pr: PROGRAM)
				-- Initialize with `pn' as name of procedure in `pr'.
				-- Serves as creation procedure in UNQUALIFIED_CALL,
				-- needs to be complemented in QUALIFIED_CALL.
		require
			name_exists: pn /= Void and then not pn.is_empty
			program_exists: pr /= Void
		do
			proc_name := pn
			program := pr
		ensure
			name_set: proc_name = pn
			program_set: program = pr
		end


feature -- Access

	proc_name: STRING
				-- Name of  procedure.

	program: PROGRAM
				-- Program to which both this call and its
				-- procedure belong.

	proc: PROCEDURE1
				-- Procedure being called.
			require
				exists: program.has (proc_name)
			do
				Result := program.item (proc_name)
			ensure
				consistent_name: Result.name ~ proc_name
			end

feature -- Status report

	is_applicable (a: ALIAS_RELATION): BOOLEAN
			-- Is call ready to be applied to `a' ?
		do
			Result := proc.body.is_applicable (a)
		end


invariant
	proc_name_exists: proc_name /= Void and then not proc_name.is_empty
	program_exists: program /= Void
end
