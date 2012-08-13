note
	description: "Summary description for {AFX_POSTMORTEM_ANALYSIS_RECORD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_POSTMORTEM_ANALYSIS_RECORD

inherit{NONE}
	EPA_UTILITY

	SHARED_EIFFEL_PARSER

create
	make

feature{NONE} -- Initialization

	make (a_target: EPA_FEATURE_WITH_CONTEXT_CLASS; a_id: STRING; a_is_proper: BOOLEAN; a_fix: STRING; a_schema_type: INTEGER; a_nbr_old_statements, a_size_snippet, a_branching_factor: INTEGER)
			-- Initialization.
		do
			target := a_target
			id := a_id.twin
			is_proper := a_is_proper
			fix_text := a_fix.twin
			schema_type := a_schema_type
			nbr_old_statements := a_nbr_old_statements
			size_snippet := a_size_snippet
			branching_factor := a_branching_factor
		end

feature -- Access

	target: EPA_FEATURE_WITH_CONTEXT_CLASS
			-- Target feature associated with the record.

	id: STRING
			-- ID of the fix.

	is_proper: BOOLEAN
			-- Is the fix proper?

	fix_text: STRING
			-- Text of the fix.

feature -- Features of the fix

	schema_type: INTEGER
			-- Type of the fixing schema used in the fix.

	nbr_old_statements: INTEGER
			-- Number of statements from the original program that become conditional after fixing.

	size_snippet: INTEGER
			-- Number of statements in the inserted snippet.

	branching_factor: INTEGER
			-- Number of branches to reach the failing location from the point of injection of the instantiated fix schema.

feature -- String representation

	csv_header: STRING
			-- Header for CSV format.
		once
			Result := "target, id, is_proper, schema_type, nbr_old_statements, size_snippet, branching_factor"
		end

	csv_out: STRING
			-- Record in CSV form.
		local
		do
			create Result.make (128)
			Result.append (target.out)
			Result.append (",")
			Result.append (id)
			Result.append (",")
			Result.append (is_proper.out)
			Result.append (",")
			Result.append (schema_type.out)
			Result.append (",")
			Result.append (nbr_old_statements.out)
			Result.append (",")
			Result.append (size_snippet.out)
			Result.append (",")
			Result.append (branching_factor.out)
		end

feature -- Constant

	Schema_snippet: INTEGER = 1
	Schema_if_old: INTEGER = 2
	Schema_if_snippet: INTEGER = 3
	Schema_if_old_else_snippet: INTEGER = 4
	Schema_if_snippet_else_old: INTEGER = 5

end
