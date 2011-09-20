note
	description: "Summary description for {AFX_PRECONDITION_VIOLATION_SIGNATURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PRECONDITION_VIOLATION_SIGNATURE

inherit
	AFX_ASSERTION_VIOLATION_SIGNATURE
		redefine
			analyze_exception_condition_in_recipient
		end

create
	make

feature{NONE} -- Initialization

	make (a_exception_class: CLASS_C; a_exception_feature: FEATURE_I;
				a_exception_breakpoint: INTEGER;
				a_recipient_class: CLASS_C; a_recipient_feature: FEATURE_I;
				a_recipient_breakpoint: INTEGER; a_recipient_nested_breakpoint: INTEGER)
			-- Initialization.
		do
			set_exception_code ({EXCEP_CONST}.precondition)
			make_common (a_exception_class, a_exception_feature,
					a_exception_breakpoint, 0,
					a_recipient_class, a_recipient_feature,
					a_recipient_breakpoint, a_recipient_nested_breakpoint)
		end

feature{NONE} -- Implementation

	analyze_exception_condition_in_recipient
			-- Analyze exception in the recipient feature.
		local
			l_call_analyzer: AFX_CALL_AT_BREAKPOINT_ANALYZER
			l_operands: DS_HASH_TABLE [STRING, STRING]
			l_arguments: DS_HASH_TABLE [INTEGER, STRING]
			l_argument_name: STRING
			l_argument_position: INTEGER
			l_actual_parameters: DS_ARRAYED_LIST [EPA_EXPRESSION]
			l_qualifier: AFX_PRECONDITION_ASSERTION_REWRITER
		do
			create l_call_analyzer
			l_call_analyzer.analyze_feature_call (recipient_class, recipient_feature,
					recipient_breakpoint, recipient_nested_breakpoint, exception_class, exception_feature.feature_name_32)

			if l_call_analyzer.is_last_call_precursor then
					-- FIXME: how to express the exception condition in recipient?
				check not_supported: false end
			else
					-- List of operands for the failing feature call.
				l_actual_parameters := l_call_analyzer.last_argument_list
				create l_operands.make (l_actual_parameters.count + 1)
				l_operands.force (l_call_analyzer.last_callee_target.text, "Current")
				l_arguments := arguments_of_feature (exception_feature)
				from l_arguments.start
				until l_arguments.after
				loop
					l_argument_name := l_arguments.key_for_iteration
					l_argument_position := l_arguments.item_for_iteration
					l_operands.force (l_actual_parameters.item (l_argument_position).text, l_argument_name)
					l_arguments.forth
				end

					-- Rewrite `exception_condition' in recipient.
				create l_qualifier
				l_qualifier.rewrite_precondition_assertion (exception_condition, l_operands, recipient_class, recipient_feature)
				set_exception_condition_in_recipient (l_qualifier.last_rewritten_assertion)
			end
		end


end
