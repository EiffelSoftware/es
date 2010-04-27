note
	description: "Summary description for {EPA_TYPE_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_TYPE_UTILITY

inherit
	SHARED_TYPES

	SHARED_EIFFEL_PARSER

	SHARED_STATELESS_VISITOR

	REFACTORING_HELPER

	SHARED_WORKBENCH

feature -- Access

	actual_type_from_formal_type (a_type: TYPE_A; a_context: CLASS_C): TYPE_A
			-- If `a_type' is formal, return its actual type in context of `a_context'
			-- otherwise return `a_type' itself.
		do
			if a_type.is_formal then
				if attached {FORMAL_A} a_type as l_formal then
					Result := l_formal.constrained_type (a_context)
				end
			else
				Result := a_type
			end
			if Result.has_generics then
				Result := Result.associated_class.constraint_actual_type
			end
		ensure
			result_attached: Result /= Void
		end


	type_a_from_string (a_name: STRING; a_context_class: CLASS_C): TYPE_A
			-- Type parsed from `a_name'
			-- If `a_name' is "NONE", return {NONE_A}.
			-- If `a_name' is an unknown type, return Void.
			-- The result is resolved in `a_context_class'.
		require
			a_name_not_void: a_name /= Void
		local
			l_type_as: TYPE_AS
			l_options: CONF_OPTION
		do
			fixme ("Code is similar to ERL_G_TYPE_ROUTINES.base_type. Refactoring is needed.")
			if a_name.is_case_insensitive_equal ("NONE") then
				Result := none_type
			else
					-- Setup syntax level according to `a_context_class'.
				l_options := a_context_class.lace_class.options
				inspect l_options.syntax.index
				when {CONF_OPTION}.syntax_index_obsolete then
					type_parser.set_syntax_version ({EIFFEL_SCANNER}.obsolete_64_syntax)
				when {CONF_OPTION}.syntax_index_transitional then
					type_parser.set_syntax_version ({EIFFEL_SCANNER}.transitional_64_syntax)
				else
					type_parser.set_syntax_version ({EIFFEL_SCANNER}.ecma_syntax)
				end

					-- Parse `a_name' into a type AST node.
				type_parser.parse_from_string ("type " + a_name, a_context_class)
				l_type_as := type_parser.type_node

					-- Generate TYPE_A object from type AST node.
				if l_type_as /= Void and then attached {CLASS_C} a_context_class as l_context_class then
					Result := type_a_generator.evaluate_type_if_possible (l_type_as, l_context_class)
				end
			end
		end

	type_a_from_string_in_application_context (a_name: STRING): TYPE_A
			-- Type parsed rom `a_name' in the context of current application root class
		require
			root_class_exists: workbench.system.root_type.associated_class /= Void
		do
			Result := type_a_from_string (a_name, workbench.system.root_type.associated_class)
		end

	resolved_type_in_context (a_type: TYPE_A; a_context_class: ClASS_C): TYPE_A
			-- Resolved type of `a_type' in context `a_context_class'
		do
			Result := a_type.actual_type.instantiation_in (a_context_class.actual_type, a_context_class.class_id)
			Result := actual_type_from_formal_type (Result, a_context_class)
		end

feature{NONE} -- Implementation

	cleaned_type_name (a_type_name: STRING): STRING
			-- A copy from `a_type_name', with all "?" removed.
		do
			fixme ("Not needed for 6.5 and above. 21.4.2010 Jasonw")
			create Result.make_from_string (a_type_name)
			Result.replace_substring_all (once "?", once "")
		end

end
