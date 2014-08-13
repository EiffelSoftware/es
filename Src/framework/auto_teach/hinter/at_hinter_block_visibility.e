note
	description: "Summary description for {AT_HINTER_BLOCK_VISIBILITY}." -- TODO
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AT_HINTER_BLOCK_VISIBILITY

create
	make

feature -- Access

	global_visibility: BOOLEAN
		do
			Result := global_visibility_agent.item ([])
		end

	parent_block: detachable AT_HINTER_BLOCK_VISIBILITY

	local_visibility_override: AT_TRI_STATE_BOOLEAN assign set_local_visiblity_override

	content_visibility_override: AT_TRI_STATE_BOOLEAN assign set_content_visibility_override

feature {NONE} -- Setters

	set_local_visiblity_override (a_tristate: AT_TRI_STATE_BOOLEAN)
		do
			local_visibility_override := a_tristate
		end

	set_content_visibility_override (a_tristate: AT_TRI_STATE_BOOLEAN)
		do
			content_visibility_override := a_tristate
		end

feature {NONE} -- Implementation

	global_visibility_agent: FUNCTION [ANY, TUPLE, BOOLEAN]

feature {NONE} -- Initialization


	make (a_parent: detachable AT_HINTER_BLOCK_VISIBILITY; a_global_visibility_agent: like global_visibility_agent)
			-- Initialize `Current', setting the parent block
			-- and the agent for retrieving the block global visibility.
		do
			parent_block := a_parent
			global_visibility_agent := a_global_visibility_agent
		end

	set_defaults
			-- Set the default values for all attributes.
		do
			local_visibility_override.set_undefined
			content_visibility_override.set_undefined
		end

end
