indexing
	description: "Summary description for {EP_MML_WRITER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EP_MML_WRITER

inherit

	EP_EXPRESSION_WRITER
		redefine
			process_feature_call,
			process_creation_expr_b
		end

create
	make

feature

	process_feature_call (a_feature: !FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- Process feature call of feature `a_feature' with parameters `a_parameters'.
		do
			if a_feature.written_class.name.starts_with ("MML") then
				process_mml_feature_call (a_feature, a_parameters)
			else
				process_normal_feature_call (a_feature, a_parameters)
			end
		end

	process_creation_expr_b (a_node: CREATION_EXPR_B)
			-- Process `a_node'.
		local
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
			l_creation_routine_name: STRING
			l_local_name: STRING
			l_temp_expression, l_arguments: STRING
			l_type: CL_TYPE_A
			l_mapped: STRING
			l_open, l_close: INTEGER
		do
			l_type ?= a_node.type
			check l_type /= Void end
			l_feature := system.class_of_id (l_type.class_id).feature_of_feature_id (a_node.call.feature_id)
			check l_feature /= Void end
			l_attached_feature := l_feature

			l_mapped := string_value_in_feature_indexing (l_attached_feature, "mapped_to", Void)
			check l_mapped /= Void end

			l_open := l_mapped.index_of ('(', 1)
			l_close := l_mapped.index_of (')', 1)


--			l_creation_routine_name := name_generator.creation_routine_name (l_attached_feature)
--			l_creation_routine_name := l_creation_routine_name.substring (12, l_creation_routine_name.count).as_lower

				-- Store expression
			l_temp_expression := expression.string
				-- Evaluate parameters with fresh expression
			expression.reset
			safe_process (a_node.call.parameters)
			l_arguments := expression.string
			l_arguments.remove_head (2)
				-- Restore original expression
			expression.reset
			expression.put (l_temp_expression)

			l_mapped.replace_substring (l_arguments, l_open + 1, l_close - 1)
			expression.put (l_mapped)

--			expression.put (l_creation_routine_name + "(" + name_mapper.heap_name + l_arguments + ")")
		end


	process_mml_feature_call (a_feature: !FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- Process feature call of feature `a_feature' with parameters `a_parameters'.
		local
			l_name: STRING
			l_function_name, l_procedure_name, l_field_name: STRING
			l_model_class: STRING
			l_temp_expression, l_arguments: STRING
			l_is_mml_equal, l_is_for_all: BOOLEAN
			l_routine_creation: ROUTINE_CREATION_B
			l_inline_feature: FEATURE_I
			l_byte_code: BYTE_CODE
			l_assignment: ASSIGN_B
		do
--			if a_feature.is_attribute then
--				l_field_name := name_generator.attribute_name (a_feature)
--				expression.put (name_mapper.heap_name + "[" + name_mapper.target_name + ", " + l_field_name + "]")
--			else
				if a_feature.is_infix or else a_feature.feature_name.is_equal ("is_model_equal") then
--					l_name := a_feature.feature_name
--					l_name := l_name.substring (8, l_name.count-1)
--					check l_name.is_equal ("|=|")  end
					check a_parameters.count = 1 end
					l_function_name := "mml.equal"
					l_is_mml_equal := True
				elseif a_feature.feature_name.is_equal ("for_all") then
					check a_parameters.count = 1 end
					l_is_for_all := True
				else

					l_model_class := string_value_in_class_indexing (a_feature.written_class, "mapped_to", "MISSING_MAPPED_TO")

					l_function_name := name_generator.functional_feature_name (a_feature)
					l_function_name := l_function_name.substring (9, l_function_name.count).as_lower
				end

				if l_is_for_all then

					l_routine_creation ?= a_parameters.first.expression
					check l_routine_creation /= Void end
					check l_routine_creation.is_inline_agent end

					l_inline_feature := l_routine_creation.class_type.associated_class.feature_of_rout_id (l_routine_creation.rout_id)
					check l_inline_feature /= Void end
					l_byte_code := byte_server.item (l_inline_feature.body_index)
					check l_byte_code /= Void end
					check l_byte_code.compound.count = 1 end
					l_assignment ?= l_byte_code.compound.first
					check l_assignment /= Void end


						-- Store expression
					l_temp_expression := expression.string
						-- Evaluate parameters with fresh expression
					expression.reset
					expression.put (name_mapper.target_name)

					l_assignment.source.process (Current)

					l_arguments := expression.string
						-- Restore original expression
					expression.reset
					expression.put (l_temp_expression)
				elseif l_is_mml_equal then
					check expression.string.is_empty end
					expression.reset
					safe_process (a_parameters.first.expression)
					l_arguments := expression.string
					expression.reset
				else
						-- Store expression
					l_temp_expression := expression.string
						-- Evaluate parameters with fresh expression
					expression.reset
					expression.put (name_mapper.target_name)
					safe_process (a_parameters)
					l_arguments := expression.string
						-- Restore original expression
					expression.reset
					expression.put (l_temp_expression)
				end

				if l_is_mml_equal then
					expression.put ("(" + name_mapper.target_name + ") == (" + l_arguments + ")")
				elseif l_is_for_all then
					expression.put ("for all ??" + l_arguments + "??")
				else
					expression.put (l_function_name + "(" + name_mapper.heap_name + ", " + l_arguments + ")")
				end

--			end
		end



	has_string_indexing (a_feature: FEATURE_I; a_tag: STRING): BOOLEAN
		do
			Result := string_value_in_feature_indexing (a_feature, a_tag, Void) /= Void
		end

	string_indexing (a_feature: FEATURE_I; a_tag: STRING): STRING
		do
			Result := string_value_in_feature_indexing (a_feature, a_tag, Void)
		end

end
