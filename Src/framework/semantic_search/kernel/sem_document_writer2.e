note
	description: "Semantic search related document writer"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_DOCUMENT_WRITER2 [G -> SEM_QUERYABLE]

inherit
	SEM_SHARED_EQUALITY_TESTER

	SEM_CONSTANTS

	SEM_FIELD_NAMES

	EPA_TYPE_UTILITY

feature -- Access

	output: IO_MEDIUM
		-- Output medium of `write'

feature -- Basic operations

	write (a_document: G)
			-- Write `a_document' into `output'.
		require
			a_document_attached: a_document /= Void
			output_medium_set: output /= Void
			output_medium_ready: output.is_open_write
		deferred
		end

feature -- Setting

	set_output_medium (a_output: like output)
			-- Set `output' with `a_output'.
		do
			output := a_output
		ensure
			output_set: output = a_output
		end

feature{NONE} -- Implementation

	queryable: G
			-- Queryable

	written_fields: DS_HASH_SET [SEM_DOCUMENT_FIELD]
			-- Fields that are already written
			-- Used to avoid writing duplicated fields
		do
			if written_fields_cache = Void then
				create written_fields_cache.make (100)
				written_fields_cache.set_equality_tester (document_field_equality_tester)
			end
			Result := written_fields_cache
		end

	written_fields_cache: detachable like written_fields
			-- Cache for `written_fields'

	write_field (a_field: SEM_DOCUMENT_FIELD)
			-- Write `a_field' into `output', and update `written_fields'.
		do
			if not written_fields.has (a_field) then
				output.put_string (a_field.out)
				output.put_new_line

				written_fields.force_last (a_field)
			end
		end

	write_field_with_data (a_name: STRING; a_value: STRING; a_type: STRING; a_boost: DOUBLE)
			-- Write field specified through `a_name', `a_value', `a_type' and `a_boost' into `output'.
		do
			write_field (create {SEM_DOCUMENT_FIELD}.make (a_name, a_value, a_type, a_boost))
		end

end
