note
	description: "Value of an expression at a specific breakpoint slot"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_POSITIONED_VALUE

create

	make, default_create

feature -- Initialization

	make (a_bp_slot: like bp_slot; a_value: like value)
			-- Initialize `bp_slot' with `a_bp_slot' and `value' with `a_value'
		do
			set_bp_slot (a_bp_slot)
			set_value (a_value)
		end

feature -- Access

	bp_slot: INTEGER
			-- Breakpoint slot of the expression.

	value: EPA_EXPRESSION_VALUE
			-- Value of the expression.

feature -- Element change

	set_bp_slot (a_bp_slot: like bp_slot)
			-- Set `bp_slot' to `a_bp_slot'.
		require
			a_bp_slot_valid: a_bp_slot > 0
		do
			bp_slot := a_bp_slot
		ensure
			bp_slot_set: bp_slot = a_bp_slot
		end

	set_value (a_value: like value)
			-- Set `value' to `a_value'.
		require
			a_value_not_void: a_value /= Void
		do
			value := a_value
		ensure
			value_set: value = a_value
		end

end
