note
	description : "Translate an instruction to JavaScript."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	JSC_INSTRUCTION_WRITER

inherit
	JSC_VISITOR
		redefine
			process_assign_b,
			process_check_b,
			process_debug_b,
			process_if_b,
			process_inspect_b,
			process_instr_call_b,
			process_loop_b,
			process_retry_b,
			process_reverse_b
		end

	SHARED_BYTE_CONTEXT
		export {NONE} all end

	SHARED_JSC_CONTEXT
		export {NONE} all end

	INTERNAL_COMPILER_STRING_EXPORTER
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize object.
		do
			create output.make
			create expression_writer.make
			reset ("")
		end

feature -- Access

	output: attached JSC_SMART_BUFFER
			-- Generated JavaScript code

	dependencies1: attached SET[INTEGER]
			-- Level 1 dependencies

	dependencies2: attached SET[INTEGER]
			-- Level 2 dependencies

	this_used_in_closure: BOOLEAN
			-- Has an inline closure been defined, does it reference Current ?

feature -- Basic Operation

	reset (a_indentation: attached STRING)
			-- Reset translation state.
		do
			output.reset (a_indentation)
			this_used_in_closure := false
			create {LINKED_SET[INTEGER]}dependencies1.make
			create {LINKED_SET[INTEGER]}dependencies2.make
			create invariant_checks.make
		end

	process_assertion (expr: attached BYTE_NODE; assertion_name: attached STRING; assertion_tag: detachable STRING)
			-- Write `expr' as an assertion in JavaScript.
		local
			l_expr: JSC_BUFFER_DATA
		do
			l_expr := invoke_expression_writer (expr)

			output.put_indentation
			output.put ("if(!(")
			output.put_data (l_expr)
			output.put (")) { throw %"")
			output.put (assertion_name)
			output.put (" ")
			if attached assertion_tag as tag then
				output.put (tag)
				output.put (" ")
			end
			output.put ("at ")
			output.put (jsc_context.current_class_name)

			if jsc_context.has_current_feature then
				output.put (".")
				output.put (jsc_context.current_feature_name)
			end

			output.put (" does not hold.%"; }")
			output.put_new_line
		end

feature -- Processing

	process_assign_b (a_node: ASSIGN_B)
			-- Process `a_node'.
		local
			l_source: attached JSC_BUFFER_DATA
			l_target: ACCESS_B

			l_call_access: CALL_ACCESS_B
			l_class: CLASS_C
			l_type: TYPE_A
		do
			create invariant_checks.make
			jsc_context.push_line_number (a_node.line_number)

			l_target := a_node.target
			check l_target /= Void end

			l_source := invoke_expression_writer (a_node.source)

			pre_invariant_checks

			output.put_indentation
			process_assign_target (l_target)
			output.put (" = ")
			output.put_data (l_source)
			output.put (";")
			output.put_new_line

			if attached {CREATION_EXPR_B} a_node.source as safe_src then

				l_type := safe_src.type
				check l_type /= Void end

				l_type := l_type.actual_type
				check l_type /= Void end

				l_call_access := safe_src.call
				check l_call_access /= Void end

				l_class := l_type.associated_class
				check l_class /= Void end

				l_class := jsc_context.informer.redirect_class (l_class)

				if not jsc_context.informer.is_fictive_stub (l_class.class_id)
					and l_class.assertion_level.is_invariant then
					output.push ("")
						process_assign_target (l_target)
						invariant_checks.extend (output.data)
					output.pop
				end
			end

			post_invariant_checks

			jsc_context.pop_line_number
		end

	process_check_b (a_node: CHECK_B)
			-- Process `a_node'.
		local
			l_check: BYTE_NODE
		do
			jsc_context.push_line_number (a_node.line_number)
			if attached a_node.check_list as safe_check_list then
				if jsc_context.current_class.assertion_level.is_check then
					from
						safe_check_list.start
					until
						safe_check_list.after
					loop
						l_check := safe_check_list.item
						check l_check /= Void end

						process_assertion (l_check, "Assertion", Void)
						safe_check_list.forth
					end
				end
			end
			jsc_context.pop_line_number
		end

	process_debug_b (a_node: DEBUG_B)
			-- Process `a_node'.
		local
		do
			jsc_context.push_line_number (a_node.line_number)
			io.put_string("JSC_INSTRUCTION_WRITER: debug_b instruction not supported%N")
			jsc_context.pop_line_number
		end

	process_if_b (a_node: IF_B)
			-- Process `a_node'.
		local
			l_condition: JSC_BUFFER_DATA
			l_elseif: ELSIF_B
		do
			jsc_context.push_line_number (a_node.line_number)
			l_condition := invoke_expression_writer (a_node.condition)

				-- If branch
			output.put_indentation
			output.put ("if (")
			output.put_data (l_condition)
			output.put (") {")
			output.put_new_line

			output.indent
			if attached a_node.compound as safe_compound then
				safe_compound.process (Current)
			end
			output.unindent

				-- Else if parts
			if attached a_node.elsif_list as elsif_list then
				from
					elsif_list.start
				until
					elsif_list.after
				loop

					l_elseif ?= elsif_list.item
					check l_elseif /= Void end

					l_condition := invoke_expression_writer (l_elseif.expr)

					output.put_indentation
					output.put ("} else if (")
					output.put_data (l_condition)
					output.put (") {")
					output.put_new_line

					output.indent
						if attached l_elseif.compound as safe_compound then
							safe_compound.process (Current)
						end
					output.unindent

					elsif_list.forth
				end
			end

				-- Else part
			if attached a_node.else_part as else_part then
				output.put_line ("} else {")
				output.indent
					else_part.process (Current)
				output.unindent
			end
			output.put_line ("}")
			jsc_context.pop_line_number
		end

	process_inspect_b (a_node: INSPECT_B)
			-- Process `a_node'.
		local
		do
			jsc_context.push_line_number (a_node.line_number)
			io.put_string("JSC_INSTRUCTION_WRITER: inspect_b%N")
			jsc_context.pop_line_number
		end

	process_instr_call_b (a_node: INSTR_CALL_B)
			-- Process `a_node'.
		local
			l_call: attached JSC_BUFFER_DATA
		do
			create invariant_checks.make
			jsc_context.push_line_number (a_node.line_number)
			l_call := invoke_expression_writer (a_node.call)

			pre_invariant_checks

			output.put_indentation
			output.put_data (l_call)
			output.put (";")
			output.put_new_line

			post_invariant_checks

			jsc_context.pop_line_number
		end

	process_loop_b (a_node: LOOP_B)
			-- Process `a_node'.
		local
			l_until_expression: attached JSC_BUFFER_DATA
		do
			jsc_context.push_line_number (a_node.line_number)
				-- From
			safe_process (a_node.from_part)

				-- Until
			l_until_expression := invoke_expression_writer (a_node.stop)

			output.put_indentation
			output.put ("while (!(")
			output.put_data (l_until_expression)
			output.put (")) {")
			output.put_new_line
			output.indent
				safe_process (a_node.compound)
			output.unindent
			output.put_line ("}")
			jsc_context.pop_line_number
		end

	process_retry_b (a_node: RETRY_B)
			-- Process `a_node'.
		local
		do
			jsc_context.push_line_number (a_node.line_number)
			output.put_line ("$retry = true;")
			jsc_context.pop_line_number
		end

	process_reverse_b (a_node: REVERSE_B)
			-- Process `a_node'.
		local
			l_context: BYTE_CONTEXT
			l_target: ACCESS_B
			l_source: EXPR_B
			l_target_type, l_source_type: TYPE_A

			l_test: JSC_BUFFER_DATA
			local_name: STRING
		do
			create invariant_checks.make
			jsc_context.push_line_number (a_node.line_number)

			l_context := context
			check l_context /= Void end

			l_target := a_node.target
			check l_target /= Void end

			l_source := a_node.source
			check l_source /= Void end

			l_target_type := l_context.real_type (l_target.type)
			check l_target_type /= Void end

			l_source_type := l_context.real_type (l_source.type)
			check l_source_type /= Void end

				-- Invoke expression writer and get inheritance condition
			expression_writer.reset (output.indentation)
			local_name := expression_writer.process_object_test (l_source, l_target_type, l_source_type, true)
			l_test := expression_writer.output.data
			dependencies1.fill (expression_writer.dependencies1)
			dependencies2.fill (expression_writer.dependencies2)
			this_used_in_closure := this_used_in_closure or expression_writer.this_used_in_closure

			pre_invariant_checks

				-- Emit code
			output.put_indentation
			process_assign_target (l_target)
			output.put (" = ")
			output.put_data (l_test)
			output.put (" ? ")
			output.put (local_name)
			output.put (" : null;")
			output.put_new_line

			post_invariant_checks

			jsc_context.pop_line_number
		end

feature {NONE} -- Implementation

	invariant_checks: attached LINKED_LIST[attached JSC_BUFFER_DATA]

	pre_invariant_checks
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > invariant_checks.count
			loop
				output.put_indentation
				output.put_data (invariant_checks[i])
				output.put (".$invariant();")
				output.put_new_line
				i := i + 1
			end
		end

	post_invariant_checks
		local
			i: INTEGER
		do
			from
				i := invariant_checks.count
			until
				i < 1
			loop
				output.put_indentation
				output.put_data (invariant_checks[i])
				output.put (".$invariant();")
				output.put_new_line
				i := i - 1
			end
		end

	process_assign_target (a_target: attached ACCESS_B)
		local
			l_system: SYSTEM_I
			l_local: LOCAL_B
			l_attribute: ATTRIBUTE_B
			l_class: CLASS_C
			l_feature: FEATURE_I
		do
			l_system := system
			check l_system /= Void end

			if a_target.is_local then
				l_local ?= a_target
				check l_local /= Void end
				output.put (jsc_context.name_mapper.local_name(l_local.position) )

			elseif a_target.is_result then
				output.put (jsc_context.name_mapper.result_name)

			elseif a_target.is_attribute then
				l_attribute ?= a_target
				check l_attribute /= Void end

				l_class := l_system.class_of_id (l_attribute.written_in)
				check l_class /= Void end

				l_feature ?= l_class.feature_of_name_id (l_attribute.attribute_name_id)
				check l_feature /= Void end

				output.put (jsc_context.name_mapper.current_class_target)
				output.put (".")
				output.put (jsc_context.name_mapper.feature_name (l_feature, false))
			else
				check should_not_be_here: false end
			end

		end

	invoke_expression_writer (a_expr_node: BYTE_NODE): attached JSC_BUFFER_DATA
			-- Invoke `expression_writer' over a certain expression and collect results.
		do
			if attached a_expr_node as safe_expr_node then
				expression_writer.reset (output.indentation)
				a_expr_node.process (expression_writer)
				Result := expression_writer.output.data

				dependencies1.fill (expression_writer.dependencies1)
				dependencies2.fill (expression_writer.dependencies2)
				this_used_in_closure := this_used_in_closure or expression_writer.this_used_in_closure
				invariant_checks.append (expression_writer.invariant_checks)
			else
				create Result.make_from_string ("")
			end
		end

	expression_writer: attached JSC_EXPRESSION_WRITER

end
