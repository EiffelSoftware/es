note
	description: "Summary description for {AFX_STATE_ITEM_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_ITEM_VALUE

create
	make

feature{NONE} -- Initialization

	make (a_state: like state_item; a_value: like value)
			-- Initialize Current.
		do
			set_state_item (a_state)
			set_value (a_value)
		ensure
			state_item_set: state_item = a_state
			value_set: value = a_value
		end

feature -- Access

	state_item: AFX_STATE_ITEM
			-- State item whose value is stored in Current

	value: DUMP_VALUE
			-- Value

	type: detachable TYPE_A
			-- Type of `value'
			-- If `has_error', return Void.
		do
			if not has_error then
				Result := value.dynamic_class.actual_type
			end
		end

feature -- Status report

	has_error: BOOLEAN
			-- Was there an error when `state_item' was evaluated?
			-- If True, `value' is not defined.
		do

		end

feature -- Setting

	set_state_item (a_state: like state_item)
			-- Set `state_item' with `a_state'.
		do
			state_item := a_state
		ensure
			state_item_set: state_item = a_state
		end

	set_value (a_value: like value)
			-- Set `value' with `a_value'.
		do
			value := a_value
		ensure
			value_set: value = a_value
		end

end
