note
	description: "Utility for feature call collector"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FEATURE_CALL_COLLECTOR_UTILITY

inherit
	EPA_UTILITY

feature -- Access

	calls_without_breakpoints (a_calls: HASH_TABLE [LINKED_LIST [CALL_AS], INTEGER]): LINKED_LIST [CALL_AS]
			-- Calls from `a_calls, with calls from different calls at various
			-- breakpoints accumulated together, and with duplicates removed.
			-- `a_calls' is a hash-table, keys are break point slots,
			-- values are feature calls associated with those break points.			
		local
			l_set: LINKED_SET [STRING]
			l_text: STRING
		do
			create Result.make
			create l_set.make
			l_set.compare_objects
			across a_calls as l_bps loop
				across l_bps.item as l_calls loop
					l_text := text_from_ast (l_calls.item)
					if not l_set.has (l_text) then
						l_set.force (l_text)
						Result.extend (l_calls.item)
					end
				end
			end
		end

	signature_of_call (a_call: CALL_AS): TUPLE [feature_name: STRING; operands: HASH_TABLE [STRING, INTEGER]]
			-- Signature information extracted from `a_call'.
			-- In result, `feature_name' is the name of the feature appeared in `a_call'.
			-- `operands' is a hash-table. Keys are 0-based operand indices, 0 represents the target,
			-- 1 represents the first actual argument, and so on.
		local
			l_feature_name: STRING
			l_operands: HASH_TABLE [STRING, INTEGER]
			l_nested_signature: TUPLE [target_name: STRING; called_feature: ACCESS_AS]
			l_called_feature: ACCESS_AS
			l_message_signature: TUPLE [feature_name: STRING; operands: HASH_TABLE [STRING, INTEGER]]
		do
			if attached {NESTED_AS} a_call as l_nested_call then
					-- Get target name and the called feature of this nested call
				l_nested_signature := get_nested_signature (l_nested_call)

					-- Get the name of the called feature
				l_called_feature := l_nested_signature.called_feature
				l_feature_name := l_called_feature.access_name

					-- Get the arguments of the called feature, if any
				if l_called_feature.parameters /= Void then
					l_operands := get_arguments_of_a_call (l_called_feature)
				else
					create l_operands.make (1)
				end
					-- Add the target of the called feature
				l_operands.put (l_nested_signature.target_name, 0)

			elseif attached {ACCESS_FEAT_AS} a_call as l_feat_call then
					-- Set the feature name
				l_feature_name := text_from_ast (l_feat_call.feature_name)

					-- Get the arguments of the called feature, if any
				if l_feat_call.parameters /= Void then
					l_operands := get_arguments_of_a_call (l_feat_call)
				else
					create l_operands.make (1)
				end
					-- Add target: since it's a unqualified call, target is set to Void
				l_operands.put (Void, 0)

			elseif attached {CREATION_EXPR_AS} a_call as l_creation_expr then

				if l_creation_expr.call /= Void then
						-- Set the feature name if the creation expression contains a call of a cration procedure
					l_feature_name := text_from_ast (l_creation_expr.call.feature_name)

						-- Get the arguments of the called feature, if any
					if l_creation_expr.call.parameters /= Void then
						l_operands := get_arguments_of_a_call (l_creation_expr.call)
					else
						create l_operands.make (1)
					end
						-- Since there is no real target in a creation expression, add the type in curly parentheses
					l_operands.put ("{" + text_from_ast (l_creation_expr.type) + "}",0)
				else
						-- If there's no call of a creation procedure, the feature name says "default_create"
					l_feature_name := "default_create"
				end

			elseif attached {CURRENT_AS} a_call as l_current then

					-- For CURRENT_AS, there are no parameters, so only return the access name as the feature name
				l_feature_name := l_current.access_name

					-- Set the target to Void
				create l_operands.make (1)
				l_operands.put (Void, 0)

			elseif attached {RESULT_AS} a_call as l_result then

					-- For RESULT_AS, there are no parameters, so only return the access name as the feature name
				l_feature_name := l_result.access_name

					-- Set the target to Void
				create l_operands.make (1)
				l_operands.put (Void, 0)

			elseif attached {PRECURSOR_AS} a_call as l_precursor then

					-- Set the feature name to "Precursor"
				l_feature_name := "Precursor"

					-- Get the arguments of the call
				if l_precursor.parameters /= Void then
					l_operands := get_arguments_of_a_call (l_precursor)
				else
					create l_operands.make (1)
				end
					-- Set the target to Void
				l_operands.put (Void, 0)

			elseif attached {NESTED_EXPR_AS} a_call as l_nested_expr then

				if attached {NESTED_AS} l_nested_expr.message then

						-- For a nested message, get the feature name and the operands using the message only
					l_message_signature := signature_of_call (l_nested_expr.message)
					l_feature_name := l_message_signature.feature_name
					l_operands := l_message_signature.operands

						-- Prepend the original target (in parentheses) to the target of the message
					l_operands.force ("("+text_from_ast (l_nested_expr.target)+")."+l_operands.item (0), 0)

				elseif attached {ACCESS_FEAT_AS} l_nested_expr.message as l_feat_call then

						-- Set the feature name
					l_feature_name := text_from_ast (l_feat_call.feature_name)

						-- Get the arguments of the called feature, if any
					if l_feat_call.parameters /= Void then
						l_operands := get_arguments_of_a_call (l_feat_call)
					else
						create l_operands.make (1)
					end
						-- Add the target (in parentheses)
					l_operands.put ("("+text_from_ast (l_nested_expr.target)+")", 0)

				end

			end

				-- Add the feature name and the hash table containing the operands to the resulting tuple
			Result := [l_feature_name, l_operands]

		end

feature {NONE} -- Implementation

	get_nested_signature (a_as: CALL_AS): TUPLE [target_name: STRING; called_feature: ACCESS_AS]
			-- Returns a tuple containing the target name of a NESTED_AS and the called feature
		local
			l_target_name: STRING
			l_called_feature: ACCESS_AS
			l_recursive_signature: TUPLE [target_name: STRING; called_feature: ACCESS_AS]
			l_recursive_target: STRING
		do
			if attached {NESTED_AS} a_as as l_nested_as then
					-- Recursively get signature of message of the nested call
				l_recursive_signature := get_nested_signature (l_nested_as.message)

					-- Target name is this_target.target_of_nested_message.....
				l_target_name := text_from_ast (l_nested_as.target)
				l_recursive_target := l_recursive_signature.target_name
				if not l_recursive_target.is_empty then
					l_target_name.append ("." + l_recursive_target)
				end

					-- Get the name of the called feature
				l_called_feature := l_recursive_signature.called_feature

					-- Return target name and name of the called feature
				Result := [l_target_name, l_called_feature]

			elseif attached {ACCESS_FEAT_AS} a_as as l_feat_call then
				Result := ["", l_feat_call]
			end
		end

	get_arguments_of_a_call (a_call: ACCESS_AS): HASH_TABLE [STRING, INTEGER]
			-- Returns a hash table containing the arguments of an ACCESS_AS
		local
			l_parameter_number: INTEGER
		do
			if a_call.parameters /= Void then
				create Result.make (a_call.parameters.count+1)
				from
					l_parameter_number := 1
				until
					l_parameter_number > a_call.parameters.count
				loop
						-- Iteratively add arguments of the call to the resulting hash table
					Result.put (text_from_ast (a_call.parameters.i_th (l_parameter_number)), l_parameter_number)
					l_parameter_number := l_parameter_number + 1
				end
			end
		end

end
