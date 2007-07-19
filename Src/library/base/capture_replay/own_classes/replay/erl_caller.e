indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ERL_CALLER

inherit
	CALLER

	ERL_SHARED_UNIVERSE

feature -- Access

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	call (target: ANY; feature_name: STRING; arguments: DS_LIST[ANY]) is
			-- Call `target'.`feature_name'(`arguments')
		local
			target_class: ERL_CLASS
			a_feature: ROUTINE [ANY, TUPLE]
		do
			target_class := universe.class_by_object (target)
			a_feature := target_class.feature_(feature_name)
			a_feature.call_from_cr_management_code (target_class.operands(feature_name, target, arguments.to_array))
--			target_class.invoke_feature (feature_name, target, arguments.to_array)
		end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
