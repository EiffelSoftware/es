note
	description: "Summary description for {EPA_POSITIONED_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_POSITIONED_VALUE

create

	make, default_create

feature -- Creation procedure

	make (a_bp_slot: like bp_slot; a_value: like value)
			--
		do
			set_bp_slot (a_bp_slot)
			set_value (a_value)
		end

feature -- Access

	bp_slot: INTEGER
			--

	value: EPA_EXPRESSION_VALUE
			--

feature -- Element change

	set_bp_slot (a_bp_slot: like bp_slot)
			--
		require
			a_bp_slot_valid: a_bp_slot > 0
		do
			bp_slot := a_bp_slot
		ensure
			bp_slot_set: bp_slot = a_bp_slot
		end

	set_value (a_value: like value)
			--
		require
			a_value_not_void: a_value /= Void
		do
			value := a_value
		ensure
			value_set: value = a_value
		end

end
