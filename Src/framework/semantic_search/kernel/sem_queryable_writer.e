note
	description: "Semantic search related document writer"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_QUERYABLE_WRITER [G -> SEM_QUERYABLE]

inherit
	SEM_QUERYABLE_IO [G]

	SEM_SHARED_EQUALITY_TESTER

	SEM_CONSTANTS

	SEM_FIELD_NAMES

	EPA_TYPE_UTILITY

feature -- Basic operations

	write (a_document: G)
			-- Write `a_document' into `output'.
		require
			a_document_attached: a_document /= Void
			output_medium_set: medium /= Void
			output_medium_ready: medium.is_open_write
		deferred
		end

feature{NONE} -- Implementation

	written_fields: DS_HASH_SET [IR_FIELD]
			-- Fields that are already written
			-- Used to avoid writing duplicated fields
		do
			if written_fields_cache = Void then
				create written_fields_cache.make (100)
				written_fields_cache.set_equality_tester (ir_field_equality_tester)
			end
			Result := written_fields_cache
		end

	written_fields_cache: detachable like written_fields
			-- Cache for `written_fields'

end
