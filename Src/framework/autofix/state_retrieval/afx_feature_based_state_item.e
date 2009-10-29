note
	description: "Summary description for {AFX_FEATURE_BASED_STATE_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_FEATURE_BASED_STATE_ITEM

inherit
	AFX_STATE_ITEM
		redefine
			name,
			value,
			is_valid
		end

feature{NONE} -- Initialization

	make (a_class: like class_; a_feature: like feature_) is
			-- Initialize Current.
		do
			class_ := a_class
			feature_ := a_feature
		ensure
			class_set: class_ = a_class
			feature_set: feature_ = a_feature
			not_is_valid: not is_valid
		end

	make_with_value (a_class: like class_; a_feature: like feature_; a_value: like value; a_valid: BOOLEAN) is
			-- Initialize Current.
		do
			make (a_class, a_feature)
			set_value (a_value)
			set_is_valid (a_valid)
		ensure
			value_set: value = a_value
			is_valid_set: is_valid = a_valid
		end

feature -- Access

	name: STRING
			-- Name of current item

	value: detachable ANY
			-- Value of current item

feature -- Setting

	set_name (a_name: like name)
			-- Set `name' with `a_name',
			-- make a new copy of `a_name'.
		do
			create name.make_from_string (a_name)
		ensure
			name_set: name.is_equal (a_name)
		end

	set_is_valid (a_valid: BOOLEAN)
			-- Set `is_valid' with `a_valid'.
		do
			is_valid := a_valid
		ensure
			is_valid_set: is_valid = a_valid
		end

	set_value (a_value: like value)
			-- Set `value' with `a_value'.
		do
			value := a_value
		ensure
			value_set: value = a_value
		end

feature -- Status report

	is_valid: BOOLEAN
			-- Is current item valid?
			-- Note: If at some point, current state item is not evaluable,
			-- then it is_valid is False.

feature -- Debug output

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make (32)
			Result.append (name)
			Result.append (" : ")
			Result.append (value.out)
		end

end
