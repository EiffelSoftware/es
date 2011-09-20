note
	description: "Summary description for {AFX_VOID_CALL_TARGET_VIOLATION_SIGNATURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_VOID_CALL_TARGET_VIOLATION_SIGNATURE

inherit
	AFX_EXCEPTION_SIGNATURE
		redefine
			analyze_exception_condition
		end

create
	make

feature{NONE} -- Initialization

	make (a_exception_feature_name: STRING;
				a_recipient_class: CLASS_C; a_recipient_feature: FEATURE_I;
				a_recipient_breakpoint: INTEGER; a_recipient_nested_breakpoint: INTEGER)
			-- Initialization.
			-- Target of the call to `a_exception_feature', from `recipient_class'.`recipient_feature' is Void.
		do
			set_exception_code ({EXCEP_CONST}.Void_call_target)
			callee_feature_name := a_exception_feature_name.twin
			make_common (Void, Void,
					0, 0,
					a_recipient_class, a_recipient_feature,
					a_recipient_breakpoint, a_recipient_nested_breakpoint)
		end

feature -- Access

	callee_feature_name: STRING
			-- Name of the feature, called on a Void target.

feature{NONE} -- Implementation

	analyze_exception_condition
			-- <Precursor>
		local
			l_call_analyzer: AFX_CALL_AT_BREAKPOINT_ANALYZER
			l_target_text: STRING
			l_operands: DS_HASH_TABLE [STRING, STRING]
			l_arguments: DS_HASH_TABLE [INTEGER, STRING]
			l_argument_name: STRING
			l_argument_position: INTEGER
			l_actual_parameters: DS_ARRAYED_LIST [EPA_EXPRESSION]
			l_qualifier: AFX_PRECONDITION_ASSERTION_REWRITER
			l_expression: EPA_AST_EXPRESSION
		do
			create l_call_analyzer
			l_call_analyzer.analyze_feature_call (recipient_class, recipient_feature,
					recipient_breakpoint, recipient_nested_breakpoint, Void, callee_feature_name)
			check non_precursor_call: not l_call_analyzer.is_last_call_precursor end
			set_exception_class (l_call_analyzer.callee_class)
			set_exception_feature (l_call_analyzer.callee_feature)

			l_target_text := "(" + l_call_analyzer.last_callee_target.text + ")"
			create l_expression.make_with_text (recipient_class, recipient_feature, l_target_text + " /= Void", recipient_feature.written_class)
			set_exception_condition (l_expression)
		end

	analyze_exception_condition_in_recipient
			-- <Precursor>
		do
			set_exception_condition_in_recipient (exception_condition)
		end

end
