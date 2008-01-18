indexing
	description: "Objects that process the context of some call stack element"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_CAPTURE_OBSERVER

feature -- Access

	is_initialized: BOOLEAN is
			-- Has `Current' been initialized?
		deferred
		end

feature -- Status setting

	start (an_adv: ABSTRACT_DEBUG_VALUE; a_feature: E_FEATURE; a_class: CLASS_C; a_cs_uuid: STRING; a_cs_level: INTEGER) is
			-- Start capturing state for `a_feature' in `a_class'.
			-- `a_cs_uuid' is an ID for the call stack.
		require
			not_initialized: not is_initialized
			an_adv_not_void: an_adv /= Void
			a_feature_not_void: a_feature /= Void
			a_class_not_void: a_class /= Void
			a_cs_uuid_not_void: a_cs_uuid /= Void
			a_cs_level_positive: a_cs_level > 0
		deferred
		ensure
			initialized: is_initialized
		end

	finish is
			-- Set `output_stream' to `Void'.
		require
			initialized: is_initialized
		deferred
		ensure
			not_initialized: not is_initialized
		end

feature -- Basic operations

	put_object (an_id, a_type: STRING; an_inv: BOOLEAN; some_attributes: DS_LIST [STRING]) is
			-- Add a captured object of type `a_type' and attributes `some_attributes'.
			-- `an_id' is the associated id for reconstructing the state and `an_inv'
			-- indicated if the object has to fulfill its invariants.
		require
			an_id_not_empty: an_id /= Void and then not an_id.is_empty
			a_type_not_empty: a_type /= Void and then not a_type.is_empty
			some_attributes_not_void: some_attributes /= Void
			some_attributes_valid: not some_attributes.has (Void)
			initialized: is_initialized
		deferred
		end

end
