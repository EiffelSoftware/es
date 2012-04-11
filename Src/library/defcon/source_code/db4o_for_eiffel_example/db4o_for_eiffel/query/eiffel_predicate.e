indexing
	description: "[
			Predicates used by Native Queries in db4o databases.
		]"
	author: "Ruihua Jin"
	date: "$Date: 2008/01/22 16:18:35$"
	revision: "$Revision: 1.0$"

class
	EIFFEL_PREDICATE[OBJECT_TYPE]

inherit
	DB4O_PREDICATE
	GENERICITY_HELPER

create
	make_open_target_agent,
	make_closed_target_agent

feature {NONE} -- Initialization

	make_open_target_agent (p: FUNCTION[OBJECT_TYPE, TUPLE[], BOOLEAN]; sample: OBJECT_TYPE) is
			-- Initialize with `p' and `sample'.
		require
			agent_not_void: p /= Void
			sample_not_void: sample /= Void
		do
			open_target_predicate := p
			sample_object := sample
		end

	make_closed_target_agent (p: FUNCTION[ANY, TUPLE[OBJECT_TYPE], BOOLEAN]; sample: OBJECT_TYPE) is
			-- Initialize with `p' and `sample'.
		require
			agent_not_void: p /= Void
			sample_not_void: sample /= Void
		do
			closed_target_predicate := p
			sample_object := sample
		end

feature  -- Match

	match (obj: OBJECT_TYPE): BOOLEAN is
			-- Does `obj' match requirements?
			-- Uses either `open_target_predicate' or `closed_target_predicate' to
			-- decide for match result;
			-- Also tests whether `obj' conforms to `sample_object'
			-- if `sample_object' is generic.
		do
			if is_generic_object then
				if (open_target_predicate /= Void) then
					Result := conforms_to_object (obj, sample_object) and then open_target_predicate.item ([obj])
				else
					Result := conforms_to_object (obj, sample_object) and then closed_target_predicate.item ([obj])
				end
			else
				if (open_target_predicate /= Void) then
					Result := open_target_predicate.item ([obj])
				else
					Result := closed_target_predicate.item ([obj])
				end
			end
		end

feature {NONE} -- Implementation

	closed_target_predicate: FUNCTION[ANY, TUPLE[OBJECT_TYPE], BOOLEAN]
			-- Predicate with closed target and one open argument of type `OBJECT_TYPE'

	open_target_predicate: FUNCTION[OBJECT_TYPE, TUPLE[], BOOLEAN]
			-- Predicate with open target and closed arguments

	sample_object: OBJECT_TYPE
			-- Sample object, used for genericity

	is_generic_object: BOOLEAN is
			-- Is `sample_object' of generic type?
		local
			type: RT_GENERIC_TYPE
		once
			type ?= pure_implementation_type (dynamic_type (sample_object))
			Result := type /= Void
		end

invariant
	one_predicate: open_target_predicate /= Void xor closed_target_predicate /= Void
	sample_not_void: sample_object /= Void

end
