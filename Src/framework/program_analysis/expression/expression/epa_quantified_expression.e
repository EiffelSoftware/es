note
	description: "Objects that represent quantified expressions"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_QUANTIFIED_EXPRESSION

inherit
	EPA_EXPRESSION
		undefine
			text_in_context
		redefine
			is_quantified,
			text,
			ast
		end

feature{NONE} -- Initialization

	make (a_variable: STRING; a_variable_type: TYPE_A; a_predicate: like predicate; a_class: like class_; a_feature: like feature_; a_written_class: like written_class)
			-- Initialize Current.
		do
			create variables.make (1)
			variables.compare_objects
			variables.put (a_variable_type, a_variable.twin)
			set_class (a_class)
			set_feature (a_feature)
			set_written_class (a_written_class)
			predicate := a_predicate
			text := text_with_predicate (predicate.text)
			type := boolean_type
			if ast = Void then
				build_ast (a_variable, a_variable_type, a_predicate.ast)
			end
		end

feature{NONE} -- Initialization

	make_from_ast (a_quantification: QUANTIFIED_AS; a_class: like class_; a_feature: like feature_; a_written_class: like written_class)
			-- Initialize Current from `a_quantification'.
			-- For the moment, we only support single varaible in `a_for_all_as'.
		local
			l_predicate: EPA_AST_EXPRESSION
		do
			ast := a_quantification
			create l_predicate.make_with_text_and_type (a_class, a_feature, text_from_ast (a_quantification.expression), a_written_class, boolean_type)
			make (a_quantification.variables.first.item_name (1), type_a_from_string (text_from_ast (a_quantification.variables.first.type), a_class), l_predicate, a_class, a_feature, a_written_class)
		end

feature -- Access

	variables: HASH_TABLE [TYPE_A, STRING]
			-- Bounded variables and their types
			-- Key is the name of a bounded variable, value is the type of that variable
			-- Note: For the moment, only single bounded variable is supported.

	predicate: EPA_EXPRESSION
			-- Predicate of current quantification

	type: TYPE_A
			-- Type of Current expression

	ast: QUANTIFIED_AS
			-- AST of current expression

	text: STRING
			-- Expression text of current item
			-- Note: The output may not in correct Eiffel syntax, so it cannot be directly used
			-- as an expression to evaluate (for example, in debugger).
			-- Current Eiffel syntax does not support some of the well-formed quantified expressions,
			-- for example, forall x. old has(x) implies has (x). 2.3.2010 Jasonw.

	text_with_predicate (a_predicate: STRING): STRING
			-- Text of current expression
		local
			l_cursor: CURSOR
			l_variables: like variables
			i, c: INTEGER
		do
			create Result.make (64)
			Result.append (quantifier_name)
			Result.append_character (' ')

			l_variables := variables
			l_cursor := l_variables.cursor
			from
				i := 1
				c := l_variables.count
				l_variables.start
			until
				l_variables.after
			loop
				Result.append (l_variables.key_for_iteration)
--				Result.append (once ": ")
--				Result.append (l_variables.item_for_iteration.name)
				if i < c then
					Result.append (once ", ")
				end
				i := i + 1
				l_variables.forth
			end
			l_variables.go_to (l_cursor)
			Result.append (once " : ")
			Result.append (a_predicate)
		end

feature -- Status report

	is_quantified: BOOLEAN = True
			-- Is Current expression quantified, either universal or existential?

	is_variables_valid: BOOLEAN
			-- Is variables valid?
		local
			l_feature: detachable like feature_
		do
			fixme ("Only single bounded variable is supported for the moment. 2.3.2010 Jasonw")
			Result := variables.count = 1

			if Result then
					-- Check there is no feature with the same feature name as bounded variables.
				l_feature := feature_
				from
					variables.start
				until
					variables.after or not Result
				loop
					Result := attached context_class.feature_named (variables.key_for_iteration)
					if Result and then l_feature /= Void then
						to_implement ("Check if there is no local variable with the same name as the variable. 2.3.2010 Jasonw")
					end
					variables.forth
				end
			end
		end

feature -- Access

	quantifier_name: STRING
			-- Name of the quantifier
		deferred
		end

feature{NONE} -- Implementation

	build_ast (a_variable_name: STRING; a_type: TYPE_A; a_expression: EXPR_AS)
			-- Build `ast' from `a_variable_name' and `a_expression'
		deferred
		end

	type_in_text_from_a_type (a_type: TYPE_A): STRING
			-- Type in text from `a_type' object.
			-- Adapted from {LIKE_FEATURE} and {FORMAL_A}.
		local
		do
			if attached {LIKE_FEATURE} a_type as lt_like then
				create Result.make (20)
--				Result.append_character ('[')
				if lt_like.has_attached_mark then
					Result.append_character ('!')
				elseif lt_like.has_detachable_mark then
					Result.append_character ('?')
				end
				if lt_like.has_separate_mark then
					Result.append ({SHARED_TEXT_ITEMS}.ti_separate_keyword)
					Result.append_character (' ')
				end
				Result.append ("like " + lt_like.feature_name)
			elseif attached {FORMAL_A} a_type as lt_formal then
				Result := class_.generics [lt_formal.position].name.name
			else
				Result := a_type.name
			end
		end

	build_ast_internal (a_variable_name: STRING; a_type: TYPE_A; a_expression: EXPR_AS; a_universal: BOOLEAN)
			-- Build `ast' from `a_variable_name' and `a_expression'
		local
			l_vars_def: EIFFEL_LIST [LIST_DEC_AS]
			l_text: STRING
			l_parser: like entity_declaration_parser
		do
			create l_text.make (32)
			l_text.append (ti_local_keyword)
			l_text.append_character ('%N')
			l_text.append (a_variable_name)
			l_text.append_character (':')

			-- Resolve generic parameters if any.
--			l_text.append (type_in_text_from_a_type (a_type))
			l_text.append (type_in_text_from_a_type (a_type.instantiated_in(class_.constraint_actual_type)))

			l_parser := entity_declaration_parser
			l_parser.set_syntax_version (l_parser.Provisional_syntax)
			l_parser.parse_from_ascii_string (l_text, Void)
			l_vars_def := l_parser.entity_declaration_node
			if a_universal then
				create {FOR_ALL_AS} ast.initialize (l_vars_def, a_expression)
			else
				create {THERE_EXISTS_AS} ast.initialize (l_vars_def, a_expression)
			end
		end

invariant
	predicate_is_valid: predicate.is_predicate and not predicate.is_quantified

end
