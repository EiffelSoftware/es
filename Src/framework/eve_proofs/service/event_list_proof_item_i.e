indexing
	description:
		"[
			Interface for events from EVE Proofs.
		]"
	date: "$Date$"
	revision: "$Revision$"

deferred class EVENT_LIST_PROOF_ITEM_I

inherit

	EVENT_LIST_ITEM_I

feature {NONE} -- Initialization

	initialize (a_class: CLASS_C; a_feature: FEATURE_I)
			-- Initalize event item.
			--
			-- `a_class': Class associated with event.
			-- `a_feature': Feature associated with event.
		do
			context_class := a_class
			context_feature := a_feature
			category := {ENVIRONMENT_CATEGORIES}.none
			priority := {PRIORITY_LEVELS}.normal
		ensure
			context_class_set: context_class = a_class
			context_feature_set: context_feature = a_feature
		end

feature -- Access

	context_class: CLASS_C
			-- Class corresponding to event

	context_feature: FEATURE_I
			-- Feature corresponding to event

	milliseconds_used: NATURAL
			-- Milliseconds used for proof

	frozen type: NATURAL_8
			-- <Precursor>
		once
			Result := {EVENT_LIST_ITEM_TYPES}.unknown
		end

	frozen category: NATURAL_8
			-- <Precursor>

	frozen priority: INTEGER_8
			-- <Precursor>

feature -- Status report

	is_invalidated: BOOLEAN
			-- <Precursor>

	is_valid_data (a_data: ANY): BOOLEAN
			-- <Precursor>
		do
			Result := True
		end

feature -- Element change

	set_milliseconds_used (a_value: NATURAL)
			-- Set `milliseconds_used' to `a_value'.
		do
			milliseconds_used := a_value
		ensure
			milliseconds_used_set: milliseconds_used = a_value
		end

	set_category (a_category: like category)
			-- <Precursor>
		do
			category := a_category
		end

	set_priority (a_priority: like priority)
			-- <Precursor>
		do
			priority := a_priority
		end

feature -- Basic operations

	invalidate
			-- <Precursor>
		do
			is_invalidated := True
		end

invariant

	context_class_attached: context_class /= Void

end
