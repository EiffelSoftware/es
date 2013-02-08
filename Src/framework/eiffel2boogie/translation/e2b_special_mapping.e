note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_SPECIAL_MAPPING

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize special mappings.
		do
			create {LINKED_LIST [E2B_CUSTOM_CALL_HANDLER]} call_handlers.make
			call_handlers.extend (create {E2B_CUSTOM_OWNERSHIP_HANDLER})
			call_handlers.extend (create {E2B_CUSTOM_ARRAY_CALL_HANDLER})
			call_handlers.extend (create {E2B_CUSTOM_INTEGER_CALL_HANDLER})
			create {LINKED_LIST [E2B_CUSTOM_NESTED_HANDLER]} nested_handlers.make
			nested_handlers.extend (create {E2B_CUSTOM_OWNERSHIP_HANDLER})
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

end
