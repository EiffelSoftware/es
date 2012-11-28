note
	description: "[
		IV-visitor that generates Boogie code.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_BOOGIE_PRINTER

inherit

	IV_UNIVERSE_VISITOR

	IV_CONTRACT_VISITOR

	IV_STATEMENT_VISITOR

	IV_EXPRESSION_VISITOR

	IV_TYPE_VISITOR

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize universe visitor.
		do
			reset
		end

feature -- Access

	output: E2B_BOOGIE_TEXT
			-- Boogie text output.

feature -- Basic operations

	reset
			-- Reset universe visitor.
		do
			create output
		end

feature -- Universe Visitor

	process_function (a_function: IV_FUNCTION)
			-- <Precursor>
		do
			output.put ("function ")
			output.put (a_function.name)
			output.put ("(")
			across a_function.arguments as i loop
				if i.cursor_index /= 1 then
					output.put (", ")
				end
				process_entity_declaration (i.item)
			end
			output.put (") returns (")
			a_function.type.process (Current)
			output.put (")")
			if attached a_function.body as l_body then
				output.put (" {")
				output.put_new_line
				output.indent
				output.put (output.indentation_string)
				l_body.process (Current)
				output.unindent
				output.put_new_line
				output.put ("}")
			else
				output.put (";")
			end
			output.put_new_line
			output.put_new_line
		end

	process_variable (a_variable: IV_VARIABLE)
			-- <Precursor>
		do
			output.put ("var ")
			process_entity_declaration (a_variable)
			output.put (";")
			output.put_new_line
			output.put_new_line
		end

	process_constant (a_constant: IV_CONSTANT)
			-- <Precursor>
		do
			output.put ("const ")
			if a_constant.is_unique then
				output.put ("unique ")
			end
			output.put (a_constant.name)
			output.put (": ")
			a_constant.type.process (Current)
			output.put (";")
			output.put_new_line
			output.put_new_line
		end

	process_axiom (a_axiom: IV_AXIOM)
			-- <Precursor>
		do
			output.put ("axiom (")
			a_axiom.expression.process (Current)
			output.put (");")
			output.put_new_line
			output.put_new_line
		end

	process_procedure (a_procedure: IV_PROCEDURE)
			-- <Precursor>
		do
			output.put ("procedure ")
			output.put (a_procedure.name)
			output.put ("(")
			across a_procedure.arguments as i loop
				if i.cursor_index /= 1 then
					output.put (", ")
				end
				process_entity_declaration (i.item)
			end
			output.put (")")
			if not a_procedure.results.is_empty then
				output.put (" returns (")
				across a_procedure.results as i loop
					if i.cursor_index /= 1 then
						output.put (", ")
					end
					process_entity_declaration (i.item)
				end
				output.put (")")
			end
			output.put (";")
			output.put_new_line
			output.indent
			across a_procedure.contracts as i loop
				i.item.process (Current)
			end
			output.unindent
			output.put_new_line
			across a_procedure.implementations as i loop
				i.item.process (Current)
			end
			output.put_new_line
			output.put_new_line
		end

	process_implementation (a_implementation: IV_IMPLEMENTATION)
			-- <Precursor>
		do
			output.put ("implementation ")
			output.put (a_implementation.procedure.name)
			output.put ("(")
			across a_implementation.procedure.arguments as i loop
				if i.cursor_index /= 1 then
					output.put (", ")
				end
				output.put (i.item.name)
				output.put (": ")
				i.item.type.process (Current)
			end
			output.put (")")
			if not a_implementation.procedure.results.is_empty then
				output.put (" returns (")
				across a_implementation.procedure.results as i loop
					if i.cursor_index /= 1 then
						output.put (", ")
					end
					output.put (i.item.name)
					output.put (": ")
					i.item.type.process (Current)
				end
				output.put (")")
			end
			output.put_new_line
			output.put ("{")
			output.put_new_line
			output.indent
			if not a_implementation.locals.is_empty then
				across a_implementation.locals as i loop
					output.put_indentation
					output.put ("var ")
					output.put (i.item.name)
					output.put (": ")
					i.item.type.process (Current)
					output.put (";")
					output.put_new_line
				end
				output.put_new_line
				output.put_line ("init_locals:")
				across a_implementation.locals as i loop
					output.put_indentation
					output.put (i.item.name)
					output.put (" := ")
					output.put (default_value (i.item.type))
					output.put (";")
					output.put_new_line
				end
				output.put_new_line
			end
			a_implementation.body.process (Current)
			output.unindent
			output.put ("}")
			output.put_new_line
			output.put_new_line
		end

feature -- Contract visitor

	process_precondition (a_precondition: IV_PRECONDITION)
			-- <Precursor>
		do
			output.put_indentation
			if a_precondition.is_free then
				output.put ("free ")
			end
			output.put ("requires ")
			a_precondition.expression.process (Current)
			output.put (";")
			print_assertion_information (a_precondition)
			output.put_new_line
		end

	process_postcondition (a_postcondition: IV_POSTCONDITION)
			-- <Precursor>
		do
			output.put_indentation
			if a_postcondition.is_free then
				output.put ("free ")
			end
			output.put ("ensures ")
			a_postcondition.expression.process (Current)
			output.put (";")
			print_assertion_information (a_postcondition)
			output.put_new_line
		end

	process_modifies (a_modifies: IV_MODIFIES)
			-- <Precursor>
		do
			output.put_indentation
			output.put ("modifies ")
			across a_modifies.names as i loop
				if i.cursor_index /= 1 then
					output.put (", ")
				end
				output.put (i.item)
			end
			output.put (";")
			output.put_new_line
		end

feature -- Statement Visitor

	process_assert (a_assert: IV_ASSERT)
			-- <Precursor>
		do
			output.put_indentation
			output.put ("assert ")
			a_assert.expression.process (Current)
			output.put (";")
			print_assertion_information (a_assert)
			output.put_new_line
		end

	process_assume (a_assume: IV_ASSUME)
			-- <Precursor>
		do
			output.put_indentation
			output.put ("assume ")
			if attached a_assume.attribute_string then
				output.put ("{" + a_assume.attribute_string + "} ")
			end
			a_assume.expression.process (Current)
			output.put (";")
			output.put_new_line
		end

	process_assignment (a_assignment: IV_ASSIGNMENT)
			-- <Precursor>
		do
			output.put_indentation
			a_assignment.target.process (Current)
			output.put (" := ")
			a_assignment.source.process (Current)
			output.put (";")
			output.put_new_line
		end

	process_block (a_block: IV_BLOCK)
			-- <Precursor>
		do
			if not a_block.name.is_empty then
				output.put_indentation
				output.put (a_block.name)
				output.put (":")
				output.put_new_line
			end
			across a_block.statements as i loop
				print_statement_origin_information (i.item)
				i.item.process (Current)
			end
		end

	process_conditional (a_conditional: IV_CONDITIONAL)
			-- <Precursor>
		do
			output.put_indentation
			output.put ("if (")
			a_conditional.condition.process (Current)
			output.put (") {")
			output.put_new_line
			output.indent
			a_conditional.then_block.process (Current)
			output.unindent
			output.put_line ("} else {")
			output.indent
			a_conditional.else_block.process (Current)
			output.unindent
			output.put_line ("}")
		end

	process_havoc (a_havoc: IV_HAVOC)
			-- <Precursor>
		do
			output.put_indentation
			output.put ("havoc ")
			across a_havoc.names as i loop
				if i.cursor_index /= 1 then
					output.put (", ")
				end
				output.put (i.item)
			end
			output.put (";")
			output.put_new_line
		end

	process_label (a_label: IV_LABEL)
			-- <Precursor>
		do
			check False end
		end

	process_loop (a_loop: IV_LOOP)
			-- <Precursor>
		do
			output.put_indentation
			output.put ("while (")
			if a_loop.is_until_loop then
				output.put ("!(")
			end
			a_loop.condition.process (Current)
			if a_loop.is_until_loop then
				output.put (")")
			end
			output.put (")")
			output.put_new_line
			output.indent
			across a_loop.invariants as i loop
				output.put_indentation
				i.item.process (Current)
				output.put (";")
				output.put_new_line
			end
			output.unindent
			output.put_line ("{")
			a_loop.body.process (Current)
			output.put_line ("}")
		end

	process_goto (a_goto: IV_GOTO)
			-- <Precursor>
		do
			output.put_indentation
			output.put ("goto ")
			across a_goto.blocks as i loop
				if i.cursor_index /= 1 then
					output.put (", ")
				end
				output.put (i.item.name)
			end
			output.put (";")
			output.put_new_line
		end

	process_procedure_call (a_call: IV_PROCEDURE_CALL)
			-- <Precursor>
		do
			output.put_indentation
			output.put ("call ")
			if attached a_call.target as l_target then
				l_target.process (Current)
				output.put (" := ")
			end
			output.put (a_call.name)
			output.put ("(")
			across a_call.arguments as i loop
				if i.cursor_index /= 1 then
					output.put (", ")
				end
				i.item.process (Current)
			end
			output.put (");")
			output.put_new_line
		end

	process_return (a_return: IV_RETURN)
			-- <Precursor>
		do
			output.put_indentation
			output.put ("return;")
			output.put_new_line
		end

	print_statement_origin_information (a_statement: IV_STATEMENT)
			-- Print origin information of `a_statement'.
		do
			if attached a_statement.origin_information as l_origin then
				output.put_comment_line (l_origin.file + ":" + l_origin.line.out)
				if l_origin.line > 0 then
					output.put_comment_line (l_origin.text_of_line)
				end
			end
		end

	print_assertion_information (a_assertion: IV_ASSERTION)
			-- Print assertion information of `a_assertion'.
		do
			if attached a_assertion.information as l_info then
				output.put (" // ")
				output.put (l_info.type)
				if attached l_info.tag as l_tag then
					output.put (" tag:")
					output.put (l_tag)
				end
				if attached l_info.line as l_line then
					output.put (" line:")
					output.put (l_line)
				end
			end
		end

feature -- Expression Visitor

	process_binary_operation (a_operation: IV_BINARY_OPERATION)
			-- <Precursor>
		do
			output.put ("(")
			a_operation.left.process (Current)
			output.put (") ")
			output.put (a_operation.operator)
			output.put (" (")
			a_operation.right.process (Current)
			output.put (")")
		end

	process_entity (a_entity: IV_ENTITY)
			-- <Precursor>
		do
			output.put (a_entity.name)
		end

	process_exists (a_exists: IV_EXISTS)
			-- <Precursor>
		do
			process_quantifier ("exists", a_exists)
		end

	process_forall (a_forall: IV_FORALL)
			-- <Precursor>
		do
			process_quantifier ("forall", a_forall)
		end

	process_function_call (a_call: IV_FUNCTION_CALL)
			-- <Precursor>
		do
			output.put (a_call.name)
			output.put ("(")
			across a_call.arguments as i loop
				if i.cursor_index /= 1 then
					output.put (", ")
				end
				i.item.process (Current)
			end
			output.put (")")
		end

	process_map_access (a_map_access: IV_MAP_ACCESS)
			-- <Precursor>
		do
			a_map_access.target.process (Current)
			output.put ("[")
			across a_map_access.indexes as i loop
				if i.cursor_index /= 1 then
					output.put (", ")
				end
				i.item.process (Current)
			end
			output.put ("]")
		end

	process_unary_operation (a_operation: IV_UNARY_OPERATION)
			-- <Precursor>
		do
			output.put (a_operation.operator)
			output.put ("(")
			a_operation.expression.process (Current)
			output.put (")")
		end

	process_value (a_value: IV_VALUE)
			-- <Precursor>
		do
			output.put (a_value.value)
		end

feature -- Type Visitor

	process_boolean_type (a_type: IV_BASIC_TYPE)
			-- <Precursor>
		do
			output.put ("bool")
		end

	process_integer_type (a_type: IV_BASIC_TYPE)
			-- <Precursor>
		do
			output.put ("int")
		end

	process_real_type (a_type: IV_BASIC_TYPE)
			-- <Precursor>
		do
			output.put ("real")
		end

	process_reference_type (a_type: IV_BASIC_TYPE)
			-- <Precursor>
		do
			output.put ("ref")
		end

	process_generic_type (a_type: IV_GENERIC_TYPE)
			-- <Precursor>
		do
			output.put ("beta")
--			check False end
		end

	process_type_type (a_type: IV_BASIC_TYPE)
			-- <Precursor>
		do
			output.put ("Type")
		end

	process_heap_type (a_type: IV_BASIC_TYPE)
			-- <Precursor>
		do
			output.put ("HeapType")
		end

	process_field_type (a_type: IV_FIELD_TYPE)
			-- <Precursor>
		do
			output.put ("Field ")
			a_type.content_type.process (Current)
		end

feature -- Other

	process_entity_declaration (a_declaration: IV_ENTITY_DECLARATION)
			-- <Precursor>
		do
				-- TODO: extract this helper function to some parent
			output.put (a_declaration.name)
			output.put (": ")
			a_declaration.type.process (Current)
			if attached a_declaration.property as l_property then
				output.put (" where ")
				l_property.process (Current)
			end
		end

	process_quantifier (a_keyword: STRING; a_quantifier: IV_QUANTIFIER)
			-- Process quantifier `a_quantifier'.
		local
			l_generic_printed: BOOLEAN
		do
			across a_quantifier.bound_variables as i until l_generic_printed loop
				if attached {IV_GENERIC_TYPE} i.item.type or attached {IV_FIELD_TYPE} i.item.type then
					l_generic_printed := True
				end
			end

			output.put ("(")
			output.put (a_keyword)
			if l_generic_printed then
				output.put ("<beta>")
			end
			output.put (" ")
			across a_quantifier.bound_variables as i loop
				if i.cursor_index /= 1 then
					output.put (", ")
				end
				process_entity_declaration (i.item)
			end
			output.put (" :: ")
			a_quantifier.expression.process (Current)
			output.put (")")
		end

	default_value (a_type: IV_TYPE): STRING
			-- Default value for type `a_type'.
		do
			if a_type.is_boolean then
				Result := "false"
			elseif a_type.is_integer then
				Result := "0"
			elseif a_type.is_real then
				Result := "0.0"
			elseif a_type.is_reference then
				Result := "Void"
			else
				check False end
			end
		end

end
