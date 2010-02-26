note
	description: "Summary description for {AFX_ACCESS_ID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_ACCESS

inherit
	DEBUG_OUTPUT

	AFX_UTILITY

feature{NONE} -- Initialization

	make_with_class_feature (a_class: like context_class; a_feature: like context_feature; a_written_class: like written_class)
			-- Initialize `context_class' with `a_class' and `context_feature' with `a_feature'.
		do
			context_class := a_class
			context_feature := a_feature
			written_class := a_written_class
		ensure
			context_class_set: context_class = a_class
			context_feature_set: context_feature = a_feature
			written_class_set: written_class = a_written_class
		end

feature -- Access

	context_class: CLASS_C
			-- Class in which current is accessed

	context_feature: FEATURE_I
			-- Feature in which current is accessed

	written_class: CLASS_C
			-- Class where `text' is written

	type: TYPE_A
			-- Type of current access
		deferred
		ensure
			result_attached: Result /= Void
			result_not_formal: not Result.is_formal
		end

	text: STRING
			-- Text of current access
		deferred
		ensure
			result_not_empty: not Result.is_empty
		end

	length: INTEGER
			-- Length of current access
		deferred
		ensure
			good_result: Result >= 1
		end

	expression: EPA_EXPRESSION
			-- Expression representation
		do
			create {EPA_AST_EXPRESSION} Result.make_with_text (context_class, context_feature, text, written_class)
		ensure
			good_result: Result.type.same_as (type)
		end

feature -- Status report

	is_current: BOOLEAN
			-- Is current access is "Current"?
		do
		end

	is_local: BOOLEAN
			-- Is current access a local?
		do
		end

	is_result: BOOLEAN
			-- Is current access a result?
		do
		end

	is_feature: BOOLEAN
			-- Is Current access a feature?
		do
		end

	is_argument: BOOLEAN
			-- Is Current access an argument?
		do
		end

	is_nested: BOOLEAN
			-- Is Current access nested?
		do
		end

	is_type_integer: BOOLEAN
			-- Is `type' an integer type?
		do
			Result := type.is_integer
		end

	is_type_boolean: BOOLEAN
			-- Is `type' a boolean type?
		do
			Result := type.is_boolean
		end

feature -- Debug output

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := text + " : " + type.name
		end

feature -- Setting

	set_context_class (a_class: like context_class)
			-- Set `context_class' with `a_class'.
		do
			context_class := a_class
		ensure
			context_class_set: context_class = a_class
		end

	set_context_feature (a_feature: like context_feature)
			-- Set `context_feature' with `a_feature'.
		do
			context_feature := a_feature
		ensure
			context_feature_set: context_feature = a_feature
		end

	set_written_class (a_written_class: like written_class)
			-- Set `written_class_' with `a_written_class'.
		do
			written_class := a_written_class
		ensure
			written_class_set: written_class = a_written_class
		end

end
