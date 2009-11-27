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
		do
			l_type ?= a_node.type
			check l_type /= Void end
			l_feature := system.class_of_id (l_type.class_id).feature_of_feature_id (a_node.call.feature_id)
			check l_feature /= Void end
			l_attached_feature := l_feature

			l_creation_routine_name := name_generator.creation_routine_name (l_attached_feature)
			l_creation_routine_name := l_creation_routine_name.substring (12, l_creation_routine_name.count).as_lower

				-- Store expression
			l_temp_expression := expression.string
				-- Evaluate parameters with fresh expression
			expression.reset
			safe_process (a_node.call.parameters)
			l_arguments := expression.string
				-- Restore original expression
			expression.reset
			expression.put (l_temp_expression)

			expression.put (l_creation_routine_name + "(" + name_mapper.heap_name + l_arguments + ")")
		end


	process_mml_feature_call (a_feature: !FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- Process feature call of feature `a_feature' with parameters `a_parameters'.
		local
			l_name: STRING
			l_function_name, l_procedure_name, l_field_name: STRING
			l_temp_expression, l_arguments: STRING
		do
--			if a_feature.is_attribute then
--				l_field_name := name_generator.attribute_name (a_feature)
--				expression.put (name_mapper.heap_name + "[" + name_mapper.target_name + ", " + l_field_name + "]")
--			else
				if a_feature.is_infix then
					l_name := a_feature.feature_name
					l_name := l_name.substring (8, l_name.count-1)
					check l_name.is_equal ("|=|") end
					l_function_name := "mml.equal"
				else
					l_function_name := name_generator.functional_feature_name (a_feature)
					l_function_name := l_function_name.substring (9, l_function_name.count).as_lower
				end
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

				expression.put (l_function_name + "(" + name_mapper.heap_name + ", " + l_arguments + ")")
--			end
		end

end
