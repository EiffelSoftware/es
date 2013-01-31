note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	IV_TYPE_VISITOR

feature -- Visitor

	process_boolean_type (a_type: IV_BASIC_TYPE)
			-- Process boolean type.
		deferred
		end

	process_integer_type (a_type: IV_BASIC_TYPE)
			-- Process integer type.
		deferred
		end

	process_real_type (a_type: IV_BASIC_TYPE)
			-- Process integer type.
		deferred
		end

	process_reference_type (a_type: IV_BASIC_TYPE)
			-- Process integer type.
		deferred
		end

	process_generic_type (a_type: IV_GENERIC_TYPE)
			-- Process generic type.
		deferred
		end

	process_type_type (a_type: IV_BASIC_TYPE)
			-- Process type type.
		deferred
		end

	process_heap_type (a_type: IV_BASIC_TYPE)
			-- Process type type.
		deferred
		end

	process_field_type (a_type: IV_FIELD_TYPE)
			-- Process type type.
		deferred
		end

	process_set_type (a_type: IV_SET_TYPE)
			-- Process type type.
		deferred
		end

end
