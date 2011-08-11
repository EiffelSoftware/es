note
	description: "Class to extract programmer written contracts as annotations for snippets"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_CONTRACT_ANNOTATION_EXTRACTOR

inherit
	EXT_ANNOTATION_EXTRACTOR [ANN_ANNOTATION]

	EPA_FEATURE_CALL_COLLECTOR_UTILITY

	EPA_UTILITY

	EPA_CONTRACT_EXTRACTOR

	ANN_SHARED_EQUALITY_TESTERS

feature -- Basic operations

	extract_from_snippet (a_snippet: EXT_SNIPPET)
			-- Extract annotations from `a_snippet' and
			-- make results available in `last_annotations'.
		local
			l_call_collector: EXT_SNIPPET_FEATURE_CALL_COLLECTOR
			l_rewriter: EPA_CONTRACT_REWRITE_VISITOR

			l_bp_slot: INTEGER
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_signature: TUPLE [feature_name: STRING; operands: HASH_TABLE [STRING, INTEGER]]
			l_vars: HASH_TABLE [STRING, STRING]
			l_target_name: STRING
			l_feat: TUPLE [context_class: CLASS_C; feat: FEATURE_I]
			l_pre_annotation: ANN_STATE_ANNOTATION
			l_post_annotation: ANN_STATE_ANNOTATION
			l_retried: BOOLEAN
		do
			create last_annotations.make (10)
			last_annotations.set_equality_tester (annotation_equality_tester)

			if not l_retried then
				l_vars := a_snippet.variable_context.variables_of_interest
					-- Collect all feature calls in `a_snippet.
				create l_call_collector
				l_call_collector.collect (a_snippet)

					-- Rewrite contracts of the called features into
					-- the snippet context.
				create l_rewriter
				across l_call_collector.last_calls as l_calls loop
					l_bp_slot := l_calls.key
					across l_calls.item as l_cur loop
						l_signature := signature_of_call (l_cur.item)
						if l_signature.operands.has (0) and then l_signature.operands.item (0) /= Void then
							l_target_name := l_signature.operands.item (0)
							l_feat := feature_from_call_as (l_cur.item, l_signature, a_snippet)
							if l_feat /= Void then
								l_feature := l_feat.feat
								l_class := l_feat.context_class

									-- Collect precondition annotations.
								across precondition_of_feature (l_feat.feat, l_feat.context_class) as l_pres loop
									l_rewriter.rewrite (l_pres.item.ast, l_feature, l_feature.written_class, l_class, l_target_name, l_signature.operands)
									if not l_rewriter.has_error then
										if across l_rewriter.mentioned_actual_args as l_args all l_signature.operands.has (l_args.key) end then
											create l_pre_annotation.make_as_precondition (l_bp_slot, l_rewriter.assertion)
											last_annotations.force_last (l_pre_annotation)
										end
									end
								end

									-- Collect postcondition annotations.
								if not l_feature.has_return_value then
									fixme("For simplicity, we do not rewrite postconditions of queries. 21.07.2011")
									across postcondition_of_feature (l_feat.feat, l_feat.context_class) as l_posts loop
										l_rewriter.rewrite (l_posts.item.ast, l_feature, l_feature.written_class, l_class, l_target_name, l_signature.operands)
										if not l_rewriter.has_error then
											if across l_rewriter.mentioned_actual_args as l_args all l_signature.operands.has (l_args.key) end then
												create l_post_annotation.make_as_postcondition (l_bp_slot, l_rewriter.assertion)
												last_annotations.force_last (l_post_annotation)
											end
										end
									end
								end
							end
						end
					end
				end
			end
		rescue
			l_retried := True
			retry
		end

feature{NONE} -- Implementation

	feature_from_call_as (a_call_as: CALL_AS; a_signature: TUPLE [feature_name: STRING; operands: HASH_TABLE [STRING, INTEGER]]; a_snippet: EXT_SNIPPET): TUPLE [context_class: CLASS_C; callee: FEATURE_I]
			-- Feature from `a_call_as' in the context of `a_snippet'
			-- In result, `callee' is the feature object extracted from `a_call_as', and
			-- `context_class' provides the context of that feature.
			-- If no valid feature call is found, return Void.
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_vars: HASH_TABLE [STRING, STRING]
			l_target_name: STRING
			l_target_type: TYPE_A
			l_feature_name: STRING
		do
			l_vars := a_snippet.variable_context.variables_of_interest
			l_target_name := a_signature.operands.item (0)
			if not l_target_name.has ('.') and not l_target_name.has ('(') and then l_vars.has (l_target_name) then
				fixme ("We only handle variable targets, not targets as complex feature calls. Jasonw 20-07-2011.")
				l_target_type := type_a_from_string_in_application_context (l_vars.item (l_target_name))
				if l_target_type /= Void and then l_target_type.has_associated_class then
					l_class := l_target_type.associated_class
					l_feature_name := a_signature.feature_name
					l_feature := l_class.feature_named (l_feature_name)
					if l_feature /= Void then
						Result := [l_class, l_feature]
					end
				end
			end

		end

end
