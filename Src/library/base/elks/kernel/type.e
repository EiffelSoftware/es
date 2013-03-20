indexing
	description: "Representation of an Eiffel type."
	library: "Free implementation of ELKS library"
	copyright: "Copyright (c) 1986-2004, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class
	TYPE [G]

inherit
	ANY
		redefine
			is_equal
		end

create {NONE}

feature -- Comparison

	is_equal (other: like Current): BOOLEAN is
			-- Is `other' attached to an object considered
			-- equal to current object?
		local
			l_internal: INTERNAL
		do
			create l_internal
			Result := l_internal.generic_dynamic_type (Current, 1) =
				l_internal.generic_dynamic_type (other, 1)
		end

feature -- Conversion

	adapt alias "[]" (g: G): G is
			-- Adapts `g' or calls necessary conversion routine to adapt `g'
		do
			Result := g
		ensure
			adapted: equal (Result, g)
		end

	attempt alias "#?" (obj: ANY): G is
			-- Result of assignment attempt of `obj' to entity of type G
		do
			Result ?= obj
		ensure
			assigned_or_void: Result = obj or Result = default_value
		end

	default_value: G is
		do
		end

end
