note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_SPECIAL_MAPPING

inherit {NONE}
	IV_SHARED_TYPES

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize special mappings.
		do
			create {LINKED_LIST [E2B_CUSTOM_CALL_HANDLER]} call_handlers.make
			call_handlers.extend (create {E2B_CUSTOM_OWNERSHIP_HANDLER})
			call_handlers.extend (create {E2B_CUSTOM_LOGICAL_HANDLER})
			call_handlers.extend (create {E2B_CUSTOM_ARRAY_CALL_HANDLER})
			call_handlers.extend (create {E2B_CUSTOM_INTEGER_CALL_HANDLER})
			call_handlers.extend (create {E2B_CUSTOM_ANY_CALL_HANDLER})
			create {LINKED_LIST [E2B_CUSTOM_NESTED_HANDLER]} nested_handlers.make
			nested_handlers.extend (create {E2B_CUSTOM_LOGICAL_HANDLER})
			nested_handlers.extend (create {E2B_CUSTOM_ANY_CALL_HANDLER})
		end

feature -- Access

	call_handlers: LIST [E2B_CUSTOM_CALL_HANDLER]
			-- List of custom call handlers.

	handler_for_call (a_target_type: TYPE_A; a_feature: FEATURE_I): detachable E2B_CUSTOM_CALL_HANDLER
			-- Custom handler for `a_feature' (if any).
		do
			from
				call_handlers.start
			until
				call_handlers.after or attached Result
			loop
				if call_handlers.item.is_handling_call (a_target_type, a_feature) then
					Result := call_handlers.item
				end
				call_handlers.forth
			end
		end

	nested_handlers: LIST [E2B_CUSTOM_NESTED_HANDLER]
			-- List of custom nested handlers.

	handler_for_nested (a_nested: NESTED_B): detachable E2B_CUSTOM_NESTED_HANDLER
			-- Custom handler for `a_nested' (if any).
		do
			from
				nested_handlers.start
			until
				nested_handlers.after or attached Result
			loop
				if nested_handlers.item.is_handling_nested (a_nested) then
					Result := nested_handlers.item
				end
				nested_handlers.forth
			end
		end

feature -- Access (built-ins)

	builtin_any_functions: ARRAY [STRING_32]
			-- List of builtin function names.
		once
			Result := <<
				"is_wrapped",
				"is_free",
				"is_open",
				"inv",
				"inv_without",
				"inv_only",
				"is_field_writable",
				"is_fully_writable",
				"is_field_readable",
				"is_fully_readable",
				"transitive_owns",
				"ownership_domain",
				"is_fresh"
			>>
			Result.compare_objects
		end

	builtin_any_procedures: ARRAY [STRING_32]
			-- List of builtin procedure names.
		once
			Result := <<
				"wrap",
				"wrap_all",
				"unwrap",
				"unwrap_all"
			>>
			Result.compare_objects
		end

	ghost_access: ARRAY [STRING_32]
			-- List of built-in ghost attributes.
		once
			Result := <<
				"closed",
				"owner",
				"owns",
				"subjects",
				"observers"
			>>
			Result.compare_objects
		end

	ghost_access_types: ARRAY [IV_TYPE]
			-- List of types of built-in ghost attributes.
		once
			Result := <<
				types.bool,
				types.ref,
				types.set (types.ref),
				types.set (types.ref),
				types.set (types.ref)
			>>
		end

	ghost_access_type (name: STRING): IV_TYPE
			-- Boogie types of a built-in attribute with name `name'.
		require
			is_ghost_access: ghost_access.has (name)
		local
			i: INTEGER
		do
			from
				i := ghost_access.lower
			until
				ghost_access [i] ~ name
			loop
				i := i + 1
			end
			Result := ghost_access_types [i]
		end

	ghost_setter: ARRAY [STRING_32]
			-- List of feature names.
		once
			Result := <<
				"set_owner",
				"set_owns",
				"set_subjects",
				"set_observers"
			>>
			Result.compare_objects
		end

	void_ok_features: ARRAY [STRING_32]
			-- List of special ANY feature names that can be called on Void.
		once
			Result := <<
				"old_",
				"generating_type"
			>>
			Result.compare_objects
		end

	default_tags: ARRAY [STRING_32]
			-- Tags of default invariant clauses.
		once
			Result := << "default_observers", "default_subjects", "default_owns", "A2" >>
			Result.compare_objects
		end

end
