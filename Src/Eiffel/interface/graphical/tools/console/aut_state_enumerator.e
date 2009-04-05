note
	description: "Summary description for {AUT_STATE_ENUMERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_STATE_ENUMERATOR

create
	make,
	make_with_ranges

feature{NONE} -- Initialization

	make is
			-- Initialization.
		do
			create ranges.make (10)
		end

	make_with_ranges (a_ranges: ARRAY [AUT_ABSTRACT_RANGE [AUT_ABSTRACT_VALUE]]) is
			-- Extend `a_ranges' into Current.
		require
			a_ranges_attached: a_ranges /= Void
		do
			create ranges.make (a_ranges.count)
			a_ranges.do_all (agent ranges.extend)
		end

feature -- Access

	ranges: ARRAYED_LIST [AUT_ABSTRACT_RANGE [AUT_ABSTRACT_VALUE]];
			-- Ranges for components of a state
			-- For example, for boolean query vector state,
			-- all the components are boolean values.
			-- Note: Do not change `ranges' during iteration.

	item: LIST [AUT_ABSTRACT_VALUE] is
			-- State at current cursor
		require
			available: not before and then not after
		local
			i: INTEGER
		do
			create	{LINKED_LIST [AUT_ABSTRACT_VALUE]} Result.make
			from
				i := 1
			until
				i > ranges.count
			loop
				Result.extend (ranges.i_th (i).item)
				i := i + 1
			end
		ensure
			result_attached: Result /= Void
		end

	item_with_name: HASH_TABLE [AUT_ABSTRACT_VALUE, STRING] is
			-- `item' associated with names in their ranges
		require
			available: not before and then not after
		local
			i: INTEGER
			l_count: INTEGER
			l_ranges: like ranges
		do
			l_ranges := ranges
			l_count := l_ranges.count
			create Result.make (l_count)
			from
				i := 1
			until
				i > l_count
			loop
				Result.put (ranges.i_th (i).item, ranges.i_th (i).name)
				i := i + 1
			end
		ensure
			result_attached: Result /= Void
		end

	count: INTEGER is
			-- Number of states
		local
			i: INTEGER
			l_count: INTEGER
			l_ranges: like ranges
		do
			l_ranges := ranges
			if not l_ranges.is_empty then
				l_count := l_ranges.count
				from
					Result := 1
					i := 1
				until
					i > l_count
				loop
					Result := Result * l_ranges.i_th (i).count
					i := i + 1
				end
			end
		ensure
			result_attached: Result /= Void
		end

feature -- Status report

	before: BOOLEAN is
			-- Is enumeration started?
		do
			Result := ranges.is_empty or else (enum_stack = Void or else enum_stack.is_empty)
		end

	after: BOOLEAN
			-- Is enumeration finished?

feature -- Basic operations

	start is
			-- Start enumeration.
		do
			after := False
			create enum_stack.make
			forth
		end

	forth is
			-- Step further in the state enumeration.
		local
			l_index: INTEGER
			l_range: AUT_ABSTRACT_RANGE [AUT_ABSTRACT_VALUE]
		do
			l_index := enum_stack.count
			if l_index = 0 then
				l_index := 1
				l_range := ranges.i_th (l_index)
				enum_stack.extend (l_range)
				l_range.start
			else
				l_range := enum_stack.item
				l_range.forth
			end
			from until
				(enum_stack.count = ranges.count and then not ranges.i_th (l_index).after) or else after
			loop
				if l_range.after then
					enum_stack.remove
					l_index := l_index - 1
					if enum_stack.is_empty then
						after := True
					else
						l_range := enum_stack.item
						l_range.forth
					end
				elseif l_index < ranges.count then
					l_index := l_index + 1
					l_range := ranges.i_th (l_index)
					l_range.start
					enum_stack.extend (l_range)
				else
					l_range.forth
				end
			end
		end

feature{NONE} -- Implementation

	enum_stack: LINKED_STACK [AUT_ABSTRACT_RANGE [AUT_ABSTRACT_VALUE]]
			-- Stack used for back-tracking during state enumeration

invariant
	ranges_attached: ranges /= Void

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
