note
	description: "Summary description for {AFX_FIXING_OPERATION_ON_REFERENCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIXING_OPERATION_ON_REFERENCE

inherit

	AFX_FIXING_OPERATION
		redefine
			is_equal,
			key_to_hash
		end

create
	make

feature{NONE} -- Initialization

	make (a_target: AFX_FIXING_TARGET; a_expression: AFX_PROGRAM_STATE_EXPRESSION; a_feature: FEATURE_I; a_type: INTEGER)
			-- Initialization.
		require
			is_valid_type_for_reference (a_type)
		do
			fixing_target := a_target

			create target_expressions.make (1)
			target_expressions.set_equality_tester (program_state_expression_equality_tester)
			target_expressions.force (a_expression)

			feature_to_call := a_feature

			type := a_type
		end

feature -- Access

	feature_to_call: FEATURE_I
			-- Feature to be called on the target expression.

	operation_text: STRING
			-- <Precursor>
		local
			l_expr_text: STRING
		do
			l_expr_text := target_expressions.first.text
			Result := operation_text_template
			Result.replace_substring_all ("{1}", l_expr_text)
			Result.replace_substring_all ("{2}", feature_to_call.feature_name_32)
		end

feature -- Status report

	is_equal (a_operation: AFX_FIXING_OPERATION_ON_REFERENCE): BOOLEAN
			-- <Precursor>
		do
			Result := a_operation /= Void and then Precursor (a_operation) and then feature_to_call.feature_id = a_operation.feature_to_call.feature_id
		end

feature{NONE} -- Implementation

	key_to_hash: DS_LINEAR [INTEGER]
			-- <Precursor>
		do
			Result := Precursor
			check attached {DS_ARRAYED_LIST [INTEGER]} Result as lt_result then
				lt_result.force_last (feature_to_call.feature_id)
			end
		end

invariant

	one_target_expression: target_expressions /= Void and then target_expressions.count = 1
	reference_target_expression: target_expressions.first.type.is_reference

end
