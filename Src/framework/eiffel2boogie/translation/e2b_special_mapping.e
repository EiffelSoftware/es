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
			call_handlers.extend (create {E2B_CUSTOM_ARRAY_CALL_HANDLER})
			call_handlers.extend (create {E2B_CUSTOM_INTEGER_CALL_HANDLER})
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

end
