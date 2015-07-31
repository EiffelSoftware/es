note
	description: "Summary description for {AFX_CODE_FIX_TO_FEATURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_CODE_FIX_TO_FAULT

inherit
	AFX_FIX_TO_FAULT
		undefine out end

	AFX_FIX_TO_FEATURE
		undefine out end

	SHARED_EIFFEL_PARSER
		undefine out end

	DEBUG_OUTPUT
		undefine out end

	AFX_SHARED_SESSION
		undefine out end

create
	make

feature{NONE} -- Initialization

	make (a_feature: AFX_FEATURE_TO_MONITOR; a_fixing_target: like fixing_target; a_fixed_body_text: STRING; a_scheme_type: INTEGER)
			-- Initialization.
		require
			a_feature /= Void
			a_fixing_target /= Void
			a_fixed_body_text /= Void and then not a_fixed_body_text.is_empty
			is_valid_scheme (a_scheme_type)
		do
			make_general

			set_context_feature (a_feature)
			fixing_target := a_fixing_target
			fixed_body_text := a_fixed_body_text
			scheme_type := a_scheme_type

			set_ranking (fixing_target.rank)
		end

feature -- Access

	fixing_target: AFX_FIXING_TARGET
			-- The target at which this fix aims.

	fixed_body_text: STRING
			-- New body text for `context_feature' after fixing.
			-- Body text includes everything between "do" and "end" (inclusive).

	fixed_feature_text: STRING
			-- New feature text for `context_feature' after fixing.
			-- Feature text includes everything between feature_name and "end" (inclusive).

	scheme_type: INTEGER
			-- Scheme type used to generate the fix.

	formatted_output: STRING
			-- <Precursor>

feature -- Set

	set_fixed_feature_text (a_text: STRING)
		require
			a_text /= Void and then a_text.has_substring (fixed_body_text)
		local
			l_printer: ETR_AST_STRUCTURE_PRINTER
			l_output: ETR_AST_STRING_OUTPUT
			l_feat_text: STRING
			l_parser: like entity_feature_parser
		do
			fixed_feature_text := a_text

			l_parser := entity_feature_parser
			l_parser.set_syntax_version (l_parser.provisional_syntax)
			l_parser.parse_from_utf8_string ("feature " + a_text, Void)
			create l_output.make_with_indentation_string ("%T")
			create l_printer.make_with_output (l_output)
			l_printer.print_ast_to_output (l_parser.feature_node)
			formatted_output := l_output.string_representation
		end

feature -- Redefinition

	signature: STRING
			-- <Precursor>
		do
			Result := "Subject=Fix to implementation;ID=Auto-" + id.out + ";Validity=" + is_valid.out + ";Type=" + name_of_scheme_type (scheme_type) +";"
		end

	out: STRING
			-- <Precursor>
		do
			create Result.make (1024)

				-- CAUTION: We use the fault_signature_id from command line argument, instead
				--			of the one from the fault replay (session.fault_signature_id),
				-- 			which contains more detailed info though.
				--			In this way, we can match the fixes to the faults in AutoDebug.
				--			See: AFX_CONTRACT_FIX_TO_FAULT
			Result.append ("  -- FaultID:" + session.config.fault_signature_id + ";%N")

			Result.append ("  -- FixInfo:" + signature + "%N")
			Result.append (formatted_output)
		end

	debug_output: STRING
			-- <Precursor>
		do
			Result := out
		end

feature -- Status report

	is_valid_scheme (a_scheme: INTEGER): BOOLEAN
			--
		do
			Result := a_scheme >= Scheme_unconditional_add and then a_scheme <= Scheme_conditional_replace
		end

feature -- Scheme type name

	name_of_scheme_type (a_type: INTEGER): STRING
			--
		do
			Result := scheme_type_names.item (a_type)
		end

feature{NONE} -- Scheme type names

	scheme_type_names: ARRAY[STRING]
			-- Array of scheme type names.
		once
			Result := <<"Unconditional add", "Conditional add", "Conditional execute", "Conditional replace">>
			Result.compare_objects
		end

feature -- Scheme type constants

	Scheme_unconditional_add: INTEGER = 1

	Scheme_conditional_add: INTEGER = 2

	Scheme_conditional_execute: INTEGER = 3

	Scheme_conditional_replace: INTEGER = 4

end
