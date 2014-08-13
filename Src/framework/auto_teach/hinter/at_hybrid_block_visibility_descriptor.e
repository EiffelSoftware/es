note
	description: "[
		Visibility and handling settings for a type of hybrid code block.
		Hybrid blocks are complex blocks that can optionally be treated as simple blocks.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AT_HYBRID_BLOCK_VISIBILITY_DESCRIPTOR

inherit

	AT_COMPLEX_BLOCK_VISIBILITY_DESCRIPTOR
		redefine
			make_with_two_agents
		end


create
	make_with_two_agents

feature -- Treatment

	global_treat_as_complex: BOOLEAN assign set_global_treat_as_complex
		-- The global policy of treating this block type as a complex block.
		-- This is not a tri-state boolean, it must always be set to some value.

	local_treat_as_complex_override: AT_TRI_STATE_BOOLEAN assign set_local_treat_as_complex_override
		-- The local policy of treating this block type as a complex block.
		-- Overrides the global policy.

	reset_local_treatment_overrides
			-- Reset the local treat-as-simple/complex override attributes.
			-- Note that this is not a redefinition.
		do
			local_treat_as_complex_override.set_undefined
		end

feature {NONE} -- Setters

	set_global_treat_as_complex (a_value: BOOLEAN)
			-- Set `global_treat_as_complex' to `a_value'.
		do
			global_treat_as_complex := a_value
		end

	set_local_treat_as_complex_override (a_value: AT_TRI_STATE_BOOLEAN)
			-- Set `local_treat_as_complex_override' to `a_value'.
		do
			local_treat_as_complex_override := a_value
		end

feature {NONE} -- Initialization

	make_with_two_agents (a_block_type: AT_BLOCK_TYPE; a_default_visibility_agent: like default_visibility_agent; a_default_content_visibility_agent: like default_content_visibility_agent)
			-- <Precursor>
		do
			Precursor (a_block_type, a_default_visibility_agent, a_default_content_visibility_agent)
			global_treat_as_complex := True
		end

invariant
	is_hybrid_block: block_type.enum_type.is_hybrid_block_type (block_type)

end
