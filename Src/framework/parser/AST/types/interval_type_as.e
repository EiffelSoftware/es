indexing

	description:
			"Abstract node for alternative values of a multi-branch %
			%instruction. Version for Bench."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class INTERVAL_TYPE_AS

inherit
	TYPE_AS
		redefine
			is_equivalent, first_token, last_token
		end

create
	initialize

feature {NONE} -- Initialization

	initialize (l: like lower; u: like upper; d_as: like dotdot_symbol) is
			-- Create a new INTERVAL AST node.
		require
			l_not_void: l /= Void
			-- TODO: Sometimes we get called with Void. 
		--	r_not_void: u /= Void
		--	d_as_not_void: d_as /= Void
		do
			lower := l
			upper := u
			dotdot_symbol := d_as
		ensure
			lower_set: lower = l
			upper_set: upper = u
			dotdot_symbol_set: dotdot_symbol = d_as
		end

feature -- Visitor

	process (v: AST_VISITOR) is
			-- process current element.
		do
			v.process_interval_type_as (Current)
		end

feature -- Roundtrip

	dotdot_symbol: SYMBOL_AS
			-- Symbol ".." associated with this structure

feature -- Attributes

	lower: TYPE_AS
			-- Lower bound

	upper: TYPE_AS
			-- Upper bound

feature -- Roundtrip/Token

	first_token (a_list: LEAF_AS_LIST): LEAF_AS is
		do
			Result := Precursor (a_list)
			if a_list = Void then
				Result := lower.first_token (a_list)
			end
		end

	last_token (a_list: LEAF_AS_LIST): LEAF_AS is
		do
			Result := Precursor (a_list)
			if a_list = Void then
				Result := upper.last_token (a_list)
			end
		end

feature -- Comparison

	is_equivalent (other: like Current): BOOLEAN is
			-- Is `other' equivalent to the current object ?
		do
			Result := equivalent (lower, other.lower) and
				equivalent (upper, other.upper)
		end

feature {INTERVAL_TYPE_AS} -- Replication

	set_lower (l: like lower) is
			-- Set `lower' to `l'.
		require
			l_not_void: l /= Void
		do
			lower := l
		end

	set_upper (u: like upper) is
			-- Set `upper' to `u'.
		do
			upper := u
		end

feature -- Support

	dump: STRING is
			-- Dumped string
		do
			create Result.make_empty
			Result.append (lower.dump)
			Result.append (" .. ")
			Result.append (upper.dump)
		end

invariant
	lower_not_void: lower /= Void

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end -- class INTERVAL_AS
