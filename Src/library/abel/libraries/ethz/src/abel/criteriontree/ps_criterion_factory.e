note
	description: "Factory class to create agent or predefined criteria."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_CRITERION_FACTORY
inherit
	PS_PREDEFINED_OPERATORS

create
	default_create

feature -- Creating a criterion

	new alias "[]" (tuple: TUPLE [ANY]): PS_CRITERION
			-- This function creates a new criterion according to the tuple in the argument.
			-- The tuple should either contain a single PREDICATE or tree values of the form [STRING, STRING, ANY]
		require
			well_formed: is_agent (tuple) or is_predefined (tuple)
		do
			if is_agent (tuple) then
				check attached {PREDICATE [ANY, TUPLE [ANY]]} tuple [1] as predicate then
					Result:=new_agent (predicate)
				end
			else
			-- is_predefined = True, otherwise there would be a contract violation	
				Result := new_predefined (tuple[1].out, tuple[2].out, tuple[3].as_attached)
			end
		end


	new_agent (a_predicate: PREDICATE [ANY, TUPLE [ANY]]): PS_CRITERION
			-- creates a criterion with an agent
		do
			create {PS_AGENT_CRITERION} Result.make (a_predicate)
		end

	new_predefined (object_attribute: STRING; operator: STRING; value: ANY): PS_CRITERION
			-- creates a predefined criterion
		require
			correct_operator_and_value: is_valid_combination (operator, value)
		do
			create {PS_PREDEFINED_CRITERION} Result.make (object_attribute, operator, value)
		end


feature -- Preconditions

	is_agent (tuple: TUPLE [ANY]): BOOLEAN
			-- See if the tuple corresponds to the format for agents
		do
			Result := attached {TUPLE [PREDICATE [ANY, TUPLE [ANY]]]} tuple
		end

	is_predefined (tuple: TUPLE [ANY]): BOOLEAN
			-- See if the tuple corresponds to the format of predefined tuples and has a valid operator/value combination
		do
			if attached {TUPLE [STRING, STRING, ANY]} tuple then
				Result := is_valid_combination (tuple[2].out, tuple[3].as_attached)
			else
				Result:=false
			end
		end
end
