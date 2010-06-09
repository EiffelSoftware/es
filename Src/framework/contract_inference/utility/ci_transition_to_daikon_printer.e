note
	description: "Class to output a set of transitions into Daikon format"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_TRANSITION_TO_DAIKON_PRINTER

inherit
	SEM_TRANSITION_PRINTER

	DKN_SHARED_EQUALITY_TESTERS

	INTERNAL_COMPILER_STRING_EXPORTER

	DKN_CONSTANTS

feature -- Access

	last_declarations: DKN_DECLARATION
			-- Last generated Daikon declaration from `transitions'

	last_trace: DKN_TRACE
			-- Last generated Daikon trace from `transitions'
			-- The order of trace record in this list is arbitrary.

feature -- Status report

	is_transition_valid (a_transition: SEM_TRANSITION): BOOLEAN
			-- Is `a_transition' valid to be added into Current?
		do
			Result := True
		end

feature -- Generate

	generate
			-- Generate `last_declarations' and `last_trace' from `transitions'.
		local
			l_enter_ppt: DKN_PROGRAM_POINT
			l_exit_ppt: DKN_PROGRAM_POINT
			l_ppt_name: STRING
		do
				-- Inititalize result.
			create last_declarations.make (20)
			create last_trace.make

				-- Construct enter and exit program points.
			l_ppt_name := class_.name_in_upper + "." + feature_.feature_name.as_lower
			create l_enter_ppt.make_as_enter (l_ppt_name)
			create l_exit_ppt.make_as_exit (l_ppt_name)
			calculate_declarations (l_enter_ppt, pre_state_expressions)
			calculate_declarations (l_exit_ppt, post_state_expressions)

		end

feature{NONE} -- Implementation

	feature_: FEATURE_I
			-- Feature whose contracts are being inferred

	class_: CLASS_C
			-- Class from which `feature_' is viewed

feature{NONE} -- Implementation

	calculate_declarations (a_ppt: DKN_PROGRAM_POINT; a_variables: like pre_state_expressions)
			-- Calculate variable declaractions from `a_variables' for program point `a_ppt'.
		do
			a_ppt.variables.append (variable_declaractions (a_variables))
		end

	variable_declaractions (a_variable_names: like pre_state_expressions): DS_HASH_SET [DKN_VARIABLE]
			-- Set of variable declarations derived from `a_state'
		local
			l_cursor: DS_HASH_TABLE_CURSOR [TYPE_A, STRING_8]
			l_variable: like variable_declaraction
		do
			from
				l_cursor := a_variable_names.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_variable := variable_declaraction (l_cursor.key, l_cursor.item)
				l_cursor.forth
			end
		end

	variable_declaraction (a_var_name: STRING; a_type: TYPE_A): DKN_VARIABLE
			-- Variable declaraction for `a_var_name' and `a_type'
		local
			l_rep_type: STRING
			l_var_kind: STRING
			l_dec_type: STRING
			l_comparability: INTEGER
		do
			if a_type.is_boolean then
				l_rep_type := boolean_rep_type
				l_comparability := boolean_comparability
			elseif a_type.is_integer then
				l_rep_type := integer_rep_type
				l_comparability := integer_comparability
			elseif a_type.is_real_32 or a_type.is_real_64 then
				l_rep_type := double_rep_type
				l_comparability := double_comparability
			else
				l_rep_type := hashcode_rep_type
				l_comparability := hash_code_comparability
			end
			l_dec_type := l_rep_type
			l_var_kind := variable_var_kind
			create Result.make (a_var_name, l_rep_type, l_var_kind, l_dec_type, l_comparability)
		end

feature{NONE} -- Implementation

	boolean_comparability: INTEGER = 1
	integer_comparability: INTEGER = 2
	double_comparability: INTEGER = 3
	hash_code_comparability: INTEGER = 4

end
