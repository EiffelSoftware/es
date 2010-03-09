note
	description: "Objects that represent transition materialized through a feature call"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_FEATURE_CALL_TRANSITION

inherit
	SEM_TRANSITION
		redefine
			context
		end

	EPA_UTILITY

create
	make,
	make_with_operands

feature{NONE} -- Initialization

	make (a_context_class: like context_class; a_feature: like feature_; a_precondition: like precondition; a_postcondition: like postcondition)
			-- Initialize Current.
		do
			feature_ := a_feature
			context_class := a_context_class
			precondition := a_precondition
			postcondition := a_postcondition
			initialize_internal
			context :=  context_class.name_in_upper + once "__" + a_feature.feature_name.as_lower
		end

	make_with_operands (a_context_class: like context_class; a_feature: like feature_; a_precondition: like precondition; a_postcondition: like postcondition)
			-- Initialize Current, with operands set to the operands involved in `a_feature'.
		local
			l_feat: like final_feature
		do
			make (a_context_class, a_feature, a_precondition, a_postcondition)

				-- Initialize `operands' and `operand_positions'.
			l_feat := final_feature
			operands_of_feature (l_feat).do_all_with_key (
				agent (a_pos: INTEGER; a_name: STRING)
					local
						l_expr: EPA_AST_EXPRESSION
					do
						create l_expr.make_with_text (context_class, feature_, a_name, context_class)
						operands.force_last (l_expr)
						operand_positions.force_last (a_pos, l_expr)
					end)
		end

feature -- Access

	feature_: FEATURE_I
			-- Feature associated with Current transition

	context_class: CLASS_C
			-- Context class from which `feature_' is viewed

	final_feature: like feature_
			-- Final feature of `feature_' in `context_class',
			-- with renaming resolved.
		do
			Result := context_class.feature_of_rout_id_set (feature_.rout_id_set)
		ensure
			good_result: Result /= Void
		end

	content: STRING
			-- <Precursor>
		do
			Result := internal_content
		end

	context: STRING
			-- Context of current transition

feature{NONE} -- Implementation

	initialize_internal
			-- Iniitalize internal data structures in Current,
			-- based on `feature_' and `context_class'.
		local
			l_feat: like final_feature
			l_target: EPA_AST_EXPRESSION
			l_operand_count: INTEGER
			l_result: EPA_AST_EXPRESSION
			l_arg: EPA_AST_EXPRESSION
			l_class: like context_class
			i: INTEGER
			c: INTEGER
			l_content: STRING
		do
				-- Calculate the number of operands in Current transition.
			l_feat := final_feature
			l_class := context_class
			create l_content.make (64)
			l_operand_count := l_feat.argument_count + 1
			if not l_feat.type.is_void then
				l_operand_count := l_operand_count + 1
			end

			create operands.make (l_operand_count)
			create operand_positions.make (l_operand_count)
			create inputs.make (l_operand_count)
			create outputs.make (l_operand_count)

				-- Handle result operand.
			if not l_feat.type.is_void then
				create l_result.make_with_text (l_class, l_feat, once "Result", l_class)
				put_operand (l_result, l_operand_count, False, True)
				l_content.append (anonymous_operand_name (l_operand_count))
				l_content.append (once " := ")
			end

				-- Handle target operand.
			create l_target.make_with_text (l_class, l_feat, once "Current", l_class)
			put_operand (l_target, 0, True, True)
			l_content.append (anonymous_operand_name (0))
			l_content.append (l_feat.feature_name.as_lower)

				-- Handle argument operands.
			c := l_feat.argument_count
			if c > 0 then
				l_content.append (" (")
				from
					i := 1
				until
					i > c
				loop
					create l_arg.make_with_text (l_class, l_feat, l_feat.arguments.item_name (i), l_class)
					put_operand (l_arg, c + 1, True, True)
					l_content.append (anonymous_operand_name (c + 1))
					if i < c then
						l_content.append_string (once ", ")
					end
					i := i + 1
				end
				l_content.append_character (')')
			end


				-- Setup `content'.
			internal_content := final_feature.feature_name.twin
		end

	internal_content: STRING
			-- Cache for `content'

end
