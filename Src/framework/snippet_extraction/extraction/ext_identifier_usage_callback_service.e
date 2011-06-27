note
	description: "Invokes a callback everytime an identifier (with or without a feature call) is used within a AST."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_IDENTIFIER_USAGE_CALLBACK_SERVICE

inherit
	AST_ITERATOR
		redefine
			process_access_id_as,
			process_current_as,
--			process_id_as,
			process_nested_as,
			process_result_as
		end

	REFACTORING_HELPER

feature -- Access

	is_mode_disjoint: BOOLEAN
		assign set_is_mode_disjoint
		-- Setting how callbacks behave for feature calls on a specific variable.
		-- If set to True: When  feature call is encountered, first a callback for that event is triggered
		-- and AST iteration won't continue. Hence, no additional callback for accessing the indentifier
		-- will be triggered. Otherwise AST iteration will continue and trigger the second callback as well.

	set_is_mode_disjoint (a_disjoint: BOOLEAN)
			-- Assigner for `is_mode_disjoint'.
		require
			a_disjoint_not_void: attached a_disjoint
		do
			is_mode_disjoint := a_disjoint
		end


	on_access_identifier: ROUTINE [ANY, TUPLE [a_as: ACCESS_AS]]
		assign set_on_access_identifier
			-- Callback agent triggered when an identifier is accessed.

	set_on_access_identifier (a_action: like on_access_identifier)
			-- Assigner for `on_access_identifier'.
		require
			a_action_not_void: attached a_action
		do
			on_access_identifier := a_action
		end

	on_access_identifier_with_feature_call: ROUTINE [ANY, TUPLE [a_as: NESTED_AS]]
		assign set_on_access_identifier_with_feature_call
			-- Callback agent triggered when an identifier with a feature call is accessed.

	set_on_access_identifier_with_feature_call (a_action: like on_access_identifier_with_feature_call)
			-- Assigner for `on_access_identifier_with_feature_call'.
		require
			a_action_not_void: attached a_action
		do
			on_access_identifier_with_feature_call := a_action
		end

--	on_id: ROUTINE [ANY, TUPLE [a_as: ID_AS]]
--		assign set_on_id
--			-- Callback agent triggered when an `{ID_AS}' node is accessed.

--	set_on_id (a_action: like on_id)
--			-- Assigner for `on_id'.
--		require
--			a_action_not_void: attached a_action
--		do
--			on_id := a_action
--		end

feature {NONE} -- Access Recording

	process_nested_as (l_as: NESTED_AS)
			-- Recording identifiers that are used with feature calls.
		do
				-- Invoke callback agent if configured.
			if attached on_access_identifier_with_feature_call then
				on_access_identifier_with_feature_call.call ([l_as])
			end

				-- Omit processing `l_as.target' in `is_mode_disjoint' to avoid interfering reporting doubles.
				-- Process `l_as.message' as in `{AST_ITERATOR}' to parse actual arguments.
			if not is_mode_disjoint then
				l_as.target.process (Current)
			else
				if
					not attached {ACCESS_ID_AS} l_as.target and
					not attached {RESULT_AS} l_as.target and
					not attached {CURRENT_AS} l_as.target
				then
					l_as.target.process (Current)
				end
			end
			l_as.message.process (Current)
		end

	process_access_id_as (l_as: ACCESS_ID_AS)
			-- Recording identifiers that are used.
			-- Note: In case of `is_mode_disjoint', `{NESTED_AS}' subtrees don't process `{NESTED_AS}.target'. See `process_nested_as'.
		do
				-- Invoke callback agent if configured.
			if attached on_access_identifier then
				on_access_identifier.call ([l_as])
			end
			Precursor (l_as)
		end

	process_result_as (l_as: RESULT_AS)
			-- Recording access to `Result' identifier.
			-- Note: In case of `is_mode_disjoint', `{NESTED_AS}' subtrees don't process `{NESTED_AS}.target'. See `process_nested_as'.
		do
				-- Invoke callback agent if configured.
			if attached on_access_identifier then
				on_access_identifier.call ([l_as])
			end
			Precursor (l_as)
		end

	process_current_as (l_as: CURRENT_AS)
			-- Recording access to `Current' identifier.
			-- Note: In case of `is_mode_disjoint', `{NESTED_AS}' subtrees don't process `{NESTED_AS}.target'. See `process_nested_as'.
		do
				-- Invoke callback agent if configured.
			if attached on_access_identifier then
				on_access_identifier.call ([l_as])
			end
			Precursor (l_as)
		end

--	process_id_as (l_as: ID_AS)
--			-- Recording access to `{ID_AS}' identifier.
--		do
--				-- Invoke callback agent if configured.
--			if attached on_id then
--				on_id.call ([l_as])
--			end
--			Precursor (l_as)
--		end

end
