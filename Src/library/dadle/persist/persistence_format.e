indexing
	description: "Summary description for {PERSISTENCE_FORMAT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PERSISTENCE_FORMAT

feature -- Access

	serialized_form: SERIALIZED_FORM

	error_message: STRING

feature -- Basic operations

	store (object: ANY; medium: PERSISTENCE_MEDIUM)
			-- stores object using medium
		require
			object_exists: object /= Void
			medium_exists: medium /= Void
		deferred
		end

	retrieve (medium: PERSISTENCE_MEDIUM): ANY
		require
			medium_exists: medium /= Void
		deferred
		end

	set_serialized_form (custom_ser: SERIALIZED_FORM)
				-- Set desired custom serialized form. This is what will be serialized.
		require
			object_exists: custom_ser /= Void
		do
			 serialized_form := custom_ser
		ensure
			object_set: custom_ser = serialized_form
		end

end
