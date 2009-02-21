indexing
	description: "TODO"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EVENT_LIST_PROOF_ITEM_I

inherit
	EVENT_LIST_ITEM_I

feature {NONE} -- Initialization

	initialize (a_class: CLASS_C; a_feature: FEATURE_I)
			-- Initalize context.
		do
			context_class := a_class
			context_feature := a_feature
		ensure
			context_class_set: context_class = a_class
			context_feature_set: context_feature = a_feature
		end

feature -- Access

	context_class: CLASS_C
			-- Class corresponding to event

	context_feature: FEATURE_I
			-- Feature corresponding to event

	frozen type: NATURAL_8
			-- <Precursor>
		once
			Result := {EVENT_LIST_ITEM_TYPES}.error
		end

	frozen category: NATURAL_8
			-- <Precursor>
		once
			Result := {ENVIRONMENT_CATEGORIES}.none
		end

	frozen priority: INTEGER_8
			-- <Precursor>
		once
			Result := {PRIORITY_LEVELS}.normal
		end

feature -- Status report

	is_invalidated: BOOLEAN
			-- <Precursor>

	is_valid_data (a_data: ANY): BOOLEAN
			-- <Precursor>
		do
			Result := True
		end

feature -- Basic operations

	invalidate
			-- <Precursor>
		do
			is_invalidated := True
		end

end
