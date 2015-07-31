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

	INTERNAL_COMPILER_STRING_EXPORTER

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
			if Result.is_loose and then Result.has_generics then
				Result := Result.associated_class.constraint_actual_type
			end
		ensure
			result_attached: Result /= Void
		end

	explicit_type_in_context (a_type: TYPE_A; a_context_type: TYPE_A): TYPE_A
			-- Explicit type resolved from `a_type' in the context of `a_context_type'
			-- The returned explicit type will not have anchors and formal generics.
		require
			a_context_type_has_associated_class: a_context_type.has_associated_class
		do
			Result := actual_type_from_formal_type (a_type.actual_type, a_context_type.associated_class)
			--a_type.actual_type.instantiation_in (a_context_type, a_context_type.associated_class.class_id)
			Result := Result.context_free_type
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
					type_parser.set_syntax_version ({EIFFEL_SCANNER}.obsolete_syntax)
				when {CONF_OPTION}.syntax_index_transitional then
					type_parser.set_syntax_version ({EIFFEL_SCANNER}.transitional_syntax)
				when {CONF_OPTION}.syntax_index_provisional then
					type_parser.set_syntax_version ({EIFFEL_SCANNER}.provisional_syntax)
				else
					type_parser.set_syntax_version ({EIFFEL_SCANNER}.ecma_syntax)
				end

					-- Parse `a_name' into a type AST node.
				type_parser.parse_from_utf8_string ("type " + a_name, a_context_class)
				l_type_as := type_parser.type_node

					-- Generate TYPE_A object from type AST node.
				if l_type_as /= Void and then attached {CLASS_C} a_context_class as l_context_class then
					Result := type_a_generator.evaluate_type (l_type_as, l_context_class)
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

	output_type_name (a_type: STRING): STRING
			-- Formatted type name from `a_type'
		do
			create Result.make_from_string (a_type)
			Result.replace_substring_all (once "?", once "")
			Result.replace_substring_all (once "detachable ", once "")
			Result.replace_substring_all (once "separate ", once "")
		end

	is_type_conformant (a_type1: TYPE_A; a_type2: TYPE_A; a_context_type: TYPE_A): BOOLEAN
			-- Is `a_type1' conformant to `a_type2' in the context of `a_context_type'?
		require
			a_context_type_has_class: a_context_type.has_associated_class
		local
			l_type1, l_type2: TYPE_A
		do
			l_type1 := a_type1.actual_type
			l_type1 := actual_type_from_formal_type (l_type1, a_context_type.associated_class)
			l_type1 := l_type1.actual_type.instantiation_in (a_context_type, a_context_type.associated_class.class_id)

			l_type2 := a_type2.actual_type
			l_type2 := actual_type_from_formal_type (l_type2, a_context_type.associated_class)
			l_type2 := l_type2.actual_type.instantiation_in (a_context_type, a_context_type.associated_class.class_id)
			Result := l_type1.conform_to (a_context_type.associated_class, l_type2)
		end

feature{NONE} -- Implementation

	cleaned_type_name (a_type_name: STRING): STRING
			-- A copy from `a_type_name', with all "?" removed.
		do
			Result := a_type_name.twin
			Result.replace_substring_all (once "?", once "detachable ")
		end

end
