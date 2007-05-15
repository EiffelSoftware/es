indexing
	description: "[
					Common interface for call events.
					]"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CALL_EVENT

inherit
	EVENT

feature -- Creation
	make(a_target: NON_BASIC_ENTITY; a_feature_name: STRING; the_arguments: LIST[ENTITY])
		--TODO: add contracts for target and feature - name
		require
			a_target_not_void: a_target /= Void
			a_feature_name_not_void: a_feature_name /= Void
			the_arguments_not_void: the_arguments /= Void
		do
				target := a_target
				feature_name := a_feature_name
				arguments := the_arguments
		end

feature -- Access

	target: NON_BASIC_ENTITY

	feature_name: STRING

	arguments: LIST[ENTITY]


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

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
		target_not_void: target /= Void
		feature_name_not_void: feature_name /= Void
		arguments_not_void: arguments /= Void

end
