note
	description: "Represents a path in an ast node"
	date: "$Date$"
	revision: "$Revision$"

class
	AST_PATH
inherit
	HASHABLE
		redefine
			is_equal
		end
create
	make_from_parent,
	make_as_root,
	make_from_string,
	make_from_child,
	make_from_other,
	make_subpath

feature -- Constants

	separator: CHARACTER is '.'
			-- Separator used in the string representation

feature -- Access

	branch_id: INTEGER
			-- Id of the branch

	as_string: STRING
			-- `Current' as string

	as_array: ARRAY[INTEGER]
			-- Current in array representation
		require
			valid: is_valid
		do
			if internal_as_array=void then
				init_array_representation
			end

			Result := internal_as_array
		end

	is_valid: BOOLEAN
			-- Is current a valid path?

	has_prefix (a_prefix: like as_string):BOOLEAN
			-- Does current have a_prefix?
		do
			Result := as_string.starts_with (a_prefix)
		end

	parent_path: like Current
			-- The path of `Current's parent
		require
			valid: is_valid
			not_root: as_array.count>1
		do
			if not attached internal_parent_path then
				init_parent_path
			end

			Result := internal_parent_path
		ensure
			Result.is_valid
		end

	is_child_of (a_other: like Current): BOOLEAN
			-- Is `Current' a child of `a_other'
		require
			valid: is_valid
			other_set: a_other /= void
			other_valid: a_other.is_valid
		do
			Result := has_prefix (a_other.as_string)
		end

	is_root: BOOLEAN
			-- Is `Current' the path of a root?
		require
			valid: is_valid
		do
			Result := as_array.count = 1
		end

feature -- Hashing

	hash_code: INTEGER
			-- Hash code value
		do
			Result := as_string.hash_code
		end

feature {NONE}-- Internal

	internal_parent_path: like Current

	init_parent_path
			-- Init `parent_path'
		local
			l_parent_string: STRING
			i: INTEGER
		do
			-- Construct path of parent
			from
				i := Current.as_array.lower
				create l_parent_string.make_empty
			until
				i > Current.as_array.upper-1
			loop
				if i /= Current.as_array.upper-1 then
					l_parent_string := l_parent_string + Current.as_array[i].out + {AST_PATH}.separator.out
				else
					l_parent_string := l_parent_string + Current.as_array[i].out
				end
				i := i+1
			end

			create internal_parent_path.make_from_string (l_parent_string)
		end

	internal_as_array: like as_array

	init_array_representation
			-- Initialize as_array
		require
			valid: is_valid
		local
			split_list: LIST[STRING]
			i: INTEGER
		do
			split_list := as_string.split (separator)

			from
				split_list.start
				create internal_as_array.make(1,split_list.count)
				i := 1
			until
				split_list.after
			loop
				internal_as_array.put (split_list.item.to_integer, i)
				split_list.forth
				i:=i+1
			end
		end

feature -- Validation

	is_valid_path_expr (a_string_rep: like as_string):BOOLEAN
			-- Check if a_string_rep is a valid path expression
		local
			split_list: LIST[STRING]
		do
			split_list := a_string_rep.split (separator)

			-- check if each entry in the list can be converted to integer and is > 0
			from
				Result := true
				split_list.start
			until
				split_list.after or not Result
			loop
				if not split_list.item.is_integer or else split_list.item.to_integer<=0 then
					Result := false
				else
					split_list.forth
				end
			end
		end

feature -- Comparison

	is_equal(other: like Current):BOOLEAN
			-- is other equal to current?
		do
			Result := as_string.is_equal (other.as_string)
		end

feature {NONE} -- Creation

	make_subpath (a_other: like current; a_subpath: like as_string)
			-- Make as subpath of `a_other'
		require
			non_void: a_other /= void and a_subpath /= void
			valid: a_other.is_valid
			subpath_valid: is_valid_path_expr (a_subpath)
		local
			l_first_sep: INTEGER
			l_tail: STRING
		do
			l_first_sep := a_subpath.index_of (separator, 1)
			if l_first_sep>0 then
				l_tail := a_subpath.substring (l_first_sep+1, a_subpath.count)
				make_from_string (a_other.as_string+separator.out+l_tail)
			else
				is_valid := false
			end
		end

	make_from_other(a_other: like current)
			-- Make from `a_other'
		require
			non_void: a_other /= void
		do
			as_string := a_other.as_string
			is_valid := a_other.is_valid

			branch_id := a_other.branch_id
		end

	make_from_string(a_string_rep: like as_string)
			-- make from a string
		require
			non_void: a_string_rep /= void
		do
			as_string := a_string_rep
			is_valid := is_valid_path_expr(as_string)

			if is_valid then
				branch_id := as_string.split (separator).last.to_integer
			end
		end

	make_from_child(a_child: AST_EIFFEL; level: INTEGER)
			-- Make current as parent of child, n levels down
		require
			non_void: a_child /= void
			has_path: a_child.path /= void
			valid: a_child.path.is_valid
		local
			l_levels: INTEGER
			i: INTEGER
			l_target_level: INTEGER
		do
			l_levels := a_child.path.as_array.count

			if l_levels>level then
				l_target_level := l_levels - level

				as_string := a_child.path.as_array[1].out

				from
					i := 2
				until
					i > l_target_level
				loop
					as_string := as_string + separator.out + a_child.path.as_array[i].out
					i:=i+1
				end

				branch_id := a_child.path.as_array[i-1]
				is_valid := true
			end
		end

	make_from_parent(a_parent_path: like Current; a_branch_number: INTEGER)
			-- Make from parent
		require
			non_void: a_parent_path /= void
			valid: a_parent_path.is_valid
		do
			branch_id := a_branch_number

			as_string := a_parent_path.as_string + separator.out + branch_id.out

			is_valid := true
		end

	make_as_root
			-- make as root
		do
			as_string := "1"

			is_valid := true
			branch_id := 0
		end

invariant
	consistent: is_valid implies is_valid_path_expr(as_string)

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
