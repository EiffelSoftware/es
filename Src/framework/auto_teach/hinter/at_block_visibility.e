note
	description: "Summary description for {AT_HINTER_BLOCK_VISIBILITY}." -- TODO
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AT_BLOCK_VISIBILITY

create
	make_with_visibility_agent

feature -- Access

	block_type: AT_BLOCK_TYPE

	default_visibility: BOOLEAN
		do
			Result := default_visibility_agent.item ([block_type])
		end

	global_visibility_override: AT_TRI_STATE_BOOLEAN assign set_local_visiblity_override

	local_visibility_override: AT_TRI_STATE_BOOLEAN assign set_local_visiblity_override

	reset_overrides
			-- Reset all the visibility override attributes.
		do
			reset_global_overrides
			reset_local_overrides
		end

	reset_global_overrides
			-- Reset the global visibility override attribute.
		do
			global_visibility_override.set_undefined
		end

	reset_local_overrides
			-- Reset the local visibility override attribute.
		do
			local_visibility_override.set_undefined
		end


feature {NONE} -- Setters

	set_local_visiblity_override (a_tristate: AT_TRI_STATE_BOOLEAN)
		do
			local_visibility_override := a_tristate
		end


feature {NONE} -- Implementation

	default_visibility_agent: FUNCTION [ANY, TUPLE [AT_BLOCK_TYPE], BOOLEAN]


feature {NONE} -- Initialization

	make_with_visibility_agent (a_block_type: AT_BLOCK_TYPE; a_default_visibility_agent: like default_visibility_agent)
			-- Initialize `Current', setting the block type
			-- and the agent for retrieving the block default visibility.
		do
			block_type := a_block_type
			default_visibility_agent := a_default_visibility_agent
		end

end
