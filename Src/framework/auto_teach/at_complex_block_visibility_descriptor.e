note
	description: "Visibility settings for a type of complex code block."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_COMPLEX_BLOCK_VISIBILITY_DESCRIPTOR

inherit

	AT_BLOCK_VISIBILITY_DESCRIPTOR
		redefine
			reset_overrides,
			reset_global_overrides,
			reset_local_overrides
		end

create
	default_create, make_with_two_agents

feature {NONE} -- Initialization

	make_with_two_agents (a_block_type: AT_BLOCK_TYPE; a_default_visibility_agent: like default_visibility_agent; a_default_content_visibility_agent: like default_content_visibility_agent)
			-- Initialize `Current', setting the block type and the agents for retrieving
			-- the block default visibility and default content visibility respectively.
		require
			complex_block: a_block_type.is_complex
		do
			make_with_visibility_agent (a_block_type, a_default_visibility_agent)
			default_content_visibility_agent := a_default_content_visibility_agent
			global_treat_as_complex := True
		end

feature -- Content visibility

	default_content_visibility: AT_TRILEAN
			-- The default 'content visibility' value for this type of block.
		do
			Result := default_content_visibility_agent.item ([block_type])
		end

	global_content_visibility_override: AT_TRILEAN assign set_global_content_visibility_override
			-- Global (class-wide) content visibility override flag.
			-- If set to True or False, overrides the default content visibility.

	local_content_visibility_override: AT_TRILEAN assign set_local_content_visibility_override
			-- Local (one occurrence only) content visibility override flag.
			-- If set to True or False, overrides the default content visibility
			-- and the global content visibility flag.

	effective_content_visibility: AT_TRILEAN
			-- What is the effective content visibility for this block type,
			-- keeping the default value and the overrides into account?
		do
				-- Inner to outer. More specific overrides win over general settings.
			Result := default_content_visibility.subjected_to (global_content_visibility_override).subjected_to (local_content_visibility_override)
		end

	effective_content_visibility_policy_strength: AT_POLICY_STRENGTH
			-- Where does the `effective_content_visibility' value come from?
		do
			if local_content_visibility_override.is_defined then
				Result := enum_policy_strength.Ps_local
			elseif global_content_visibility_override.is_defined then
				Result := enum_policy_strength.Ps_global
			elseif default_content_visibility.is_defined then
				Result := enum_policy_strength.Ps_default
			else
				Result := enum_policy_strength.Ps_not_set
			end
		end

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

feature -- Treatment

	global_treat_as_complex: BOOLEAN assign set_global_treat_as_complex
		-- The global policy of treating this block type as a complex block.
		-- This is not a trilean, it must always be set to some value.

	local_treat_as_complex_override: AT_TRILEAN assign set_local_treat_as_complex_override
		-- The local policy of treating this block type as a complex block.
		-- Overrides the global policy.

	reset_local_treatment_overrides
			-- Reset the local treat-as-atomic/complex override attributes.
			-- Note that this is not a redefinition.
		do
			local_treat_as_complex_override.set_undefined
		end

feature {NONE} -- Setters

	set_global_content_visibility_override (a_value: AT_TRILEAN)
			-- Set `global_content_visibility_override' to `a_value'.
		do
			global_content_visibility_override := a_value
		end

	set_local_content_visibility_override (a_value: AT_TRILEAN)
			-- Set `local_content_visibility_override' to `a_value'.
		do
			local_content_visibility_override := a_value
		end

	set_global_treat_as_complex (a_value: BOOLEAN)
			-- Set `global_treat_as_complex' to `a_value'.
		do
			global_treat_as_complex := a_value
		end

	set_local_treat_as_complex_override (a_value: AT_TRILEAN)
			-- Set `local_treat_as_complex_override' to `a_value'.
		do
			local_treat_as_complex_override := a_value
		end


feature {NONE} -- Implementation

	default_content_visibility_agent: FUNCTION [ANY, TUPLE [AT_BLOCK_TYPE], AT_TRILEAN]
			-- Agent for retrieving the default content visibility for this block type.

invariant
	is_complex_block: block_type.is_complex

end
