note
	description: "Visibility settings for a type of complex code block."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_COMPLEX_BLOCK_VISIBILITY

inherit

	AT_BLOCK_VISIBILITY
		redefine
			reset_overrides,
			reset_global_overrides,
			reset_local_overrides
		end

create
	default_create, make_with_two_agents

feature -- Access

	default_content_visibility: AT_TRI_STATE_BOOLEAN
		do
			Result := default_content_visibility_agent.item ([block_type])
		end

	global_content_visibility_override: AT_TRI_STATE_BOOLEAN assign set_global_content_visibility_override

	local_content_visibility_override: AT_TRI_STATE_BOOLEAN assign set_local_content_visibility_override

	reset_overrides
			-- Reset all the visibility and content visibility override attributes.
		do
			Precursor
		end

	reset_global_overrides
			-- Reset the global visibility and content visibility override attribute.
		do
			Precursor
			global_content_visibility_override.set_undefined
		end

	reset_local_overrides
			-- Reset the local visibility and content visibility override attributes.
		do
			Precursor
			local_content_visibility_override.set_undefined
		end

feature {NONE} -- Setters

	set_global_content_visibility_override (a_tristate: AT_TRI_STATE_BOOLEAN)
		do
			global_content_visibility_override := a_tristate
		end

	set_local_content_visibility_override (a_tristate: AT_TRI_STATE_BOOLEAN)
		do
			local_content_visibility_override := a_tristate
		end

	make_with_two_agents (a_block_type: AT_BLOCK_TYPE; a_default_visibility_agent: like default_visibility_agent; a_default_content_visibility_agent: like default_content_visibility_agent)
			-- Initialize `Current', setting the block type and the agents for retrieving
			-- the block default visibility and default content visibility respectively.
		require
			complex_block: a_block_type.enum_type.is_complex_block_type (a_block_type)
		do
			make_with_visibility_agent (a_block_type, a_default_visibility_agent)
			default_content_visibility_agent := a_default_content_visibility_agent
		end

feature {NONE} -- Implementation

	default_content_visibility_agent: FUNCTION [ANY, TUPLE [AT_BLOCK_TYPE], AT_TRI_STATE_BOOLEAN]

invariant
	is_complex_block: block_type.enum_type.is_complex_block_type (block_type)

end
