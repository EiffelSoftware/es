note
	description: "An item in a state"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_EXPRESSION

inherit
	SHARED_TYPES

	DEBUG_OUTPUT

	HASHABLE

feature -- Access

	feature_: FEATURE_I
			-- Feature returning the integer

	class_: CLASS_C
			-- Context lass of `feature_'

	text: STRING
			-- Expression text of current item
		deferred
		end

	type: detachable TYPE_A
			-- Type of current state
			-- Should be a deanchered and resolved generic type.
		deferred
		end

	ast: EXPR_AS
			-- AST node for `text'
		deferred
		end

	written_class: CLASS_C
			-- Class where `ast' is written

feature -- Status report

	is_valid: BOOLEAN
			-- Is current item valid?
			-- Note: If at some point, current state item is not evaluable,
			-- then it is_valid is False.
		deferred
		end

feature -- Setting

	set_feature (a_feature: like feature_)
			-- Set `feature_' with `a_feature'.
		do
			feature_ := a_feature
		ensure
			feature_set: feature_ = a_feature
		end

	set_class (a_class: like class_)
			-- Set `class_' with `a_class'.
		do
			class_ := a_class
		ensure
			class_set: class_ = a_class
		end

	set_written_class (a_written_class: like written_class)
			-- Set `written_class_' with `a_written_class'.
		do
			written_class := a_written_class
		ensure
			written_class_set: written_class = a_written_class
		end

end
