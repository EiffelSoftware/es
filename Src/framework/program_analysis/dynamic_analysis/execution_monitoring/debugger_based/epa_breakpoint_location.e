note
	description: "Objects that represent a breakpoint based program location"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_BREAKPOINT_LOCATION

inherit
	EPA_PROGRAM_LOCATION
		redefine
			is_equal,
			hash_code
		end

--create
--	make

feature{NONE} -- Initialization

	make (a_feature: like feature_; a_slot: INTEGER)
			-- Initialize Current.
		require
			a_slot_is_valid: a_slot >= 1 and then a_slot <= a_feature.number_of_breakpoint_slots
		do
			feature_ := a_feature
			slot := a_slot
		ensure
			feature_set: feature_ = a_feature
			slot_set: slot = a_slot
		end

feature -- Access

	feature_: FEATURE_I
			-- Feature in which Current breakpoint exists

	slot: INTEGER
			-- Breakpoint slot number

	hash_code: INTEGER
			-- Hash code value
		local
		do
			if internal_hash_code = 0 then
					-- Compounents used to calculate hash code: written class id; feature body index; slot number.
				internal_hash_code :=
					(feature_.written_class.class_id.out + once ";" + feature_.body_index.out + once ";" + slot.out).hash_code
			end
			Result := internal_hash_code
		end

feature -- Status report

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result :=
				feature_.written_class.class_id = other.feature_.written_class.class_id and then
				feature_.body_index = other.feature_.body_index and then
				slot = other.slot
		end

invariant
	slot_positive: slot > 0

end
