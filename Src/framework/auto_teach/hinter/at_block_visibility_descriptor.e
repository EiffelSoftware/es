note
	description: "Descriptor containing visibility for a type of code block."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_BLOCK_VISIBILITY_DESCRIPTOR

create
	make_with_visibility_agent

feature -- Access

	block_type: AT_BLOCK_TYPE
			-- The type of this block.

	default_visibility: BOOLEAN
			-- The default visibility for this block.
		do
			Result := default_visibility_agent.item ([block_type])
		end

	global_visibility_override: AT_TRI_STATE_BOOLEAN assign set_global_visiblity_override
			-- Global (class-wide) visibility override flag.
			-- If set to True or False, overrides the default visibility.

	local_visibility_override: AT_TRI_STATE_BOOLEAN assign set_local_visiblity_override
			-- Local (one occurrence only) visibility override flag.
			-- If set to True or False, overrides the default visibility
			-- and the global visibility flag.

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

	set_global_visiblity_override (a_value: AT_TRI_STATE_BOOLEAN)
			-- Set `global_visibility_override' to `a_value'.
		do
			global_visibility_override := a_value
		end

	set_local_visiblity_override (a_value: AT_TRI_STATE_BOOLEAN)
			-- Set `local_visibility_override' to `a_value'.
		do
			local_visibility_override := a_value
		end


feature {NONE} -- Implementation

	default_visibility_agent: FUNCTION [ANY, TUPLE [AT_BLOCK_TYPE], BOOLEAN]
			-- Agent for retrieving the default visibility for this block type.

feature {NONE} -- Initialization

	make_with_visibility_agent (a_block_type: AT_BLOCK_TYPE; a_default_visibility_agent: like default_visibility_agent)
			-- Initialize `Current', setting the block type
			-- and the agent for retrieving the block default visibility.
		do
			block_type := a_block_type
			default_visibility_agent := a_default_visibility_agent
		end

end
