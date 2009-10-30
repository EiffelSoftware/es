note
	description: "An item in a state"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_STATE_ITEM

inherit
	SHARED_TYPES

	DEBUG_OUTPUT

feature -- Access

	feature_: FEATURE_I
			-- Feature returning the integer

	class_: CLASS_C
			-- Context lass of `feature_'

	name: STRING
			-- Name of current item
		deferred
		ensure
			result_attached: Result /= Void
			result_valid: not Result.is_empty
		end

	value: detachable ANY
			-- Value current item
		deferred
		end

	text: STRING
			-- Expression text of current item
		deferred
		end

	type: detachable TYPE_A
			-- Type of current state
			-- Should be a deanchered and resolved generic type.
		deferred
		end

--	body: STRING
--			-- String representation of the expression of current item.
--		deferred
--		ensure
--			result_attached: Result /= Void
--		end

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

end
