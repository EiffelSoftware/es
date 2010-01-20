note
	description: "Represents a path in an ast node"
	author: "$Author$"
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
	make_from_other

feature -- Constants

	separator: CHARACTER is '.'

feature -- Access

	root: AST_EIFFEL

	branch_id: INTEGER
			-- id of the branch

	as_string: STRING

	as_array: ARRAY[INTEGER]
			-- Current in array representation
			-- lazy initialization
		require
			valid: is_valid
		do
			if internal_as_array=void then
				init_array_representation
			end

			Result := internal_as_array
		end

	is_valid: BOOLEAN

	has_prefix(a_prefix: like as_string):BOOLEAN
			-- does current have a_prefix?
		do
			Result := as_string.starts_with (a_prefix)
		end

	parent_path: AST_PATH
			-- the path of `Current's parent
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

feature -- Hashing

	hash_code: INTEGER
			-- Hash code value
		do
			Result := as_string.hash_code
		end

feature {NONE}-- Internal

	internal_parent_path: like Current

	init_parent_path
			-- init `parent_path'
		local
			l_parent_string: STRING
			i: INTEGER
		do
			-- construct path of parent
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

			create internal_parent_path.make_from_string (Current.root, l_parent_string)
		end

	internal_as_array: like as_array

	init_array_representation
			-- init as_array
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

	is_valid_path_expr(a_string_rep: like as_string):BOOLEAN
			-- check if a_string_rep is a valid path expression
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

	make_from_other(an_other: like current)
			-- make from `an_other'
		require
			non_void: an_other /= void
		do
			root := an_other.root
			as_string := an_other.as_string
			is_valid := an_other.is_valid

			branch_id := an_other.branch_id
		end

	make_from_string(a_root: like root; a_string_rep: like as_string)
			-- make from a string
		require
			non_void: a_root /= void and a_string_rep /= void
		do
			root := a_root
			as_string := a_string_rep
			is_valid := is_valid_path_expr(as_string)

			if is_valid then
				branch_id := as_string.split (separator).last.to_integer
			end
		end

	make_from_child(a_child: like root; level: INTEGER)
			-- make current as parent of child, n levels down
		require
			non_void: a_child /= void
			has_path: a_child.path /= void
			valid: a_child.path.is_valid
		local
			l_levels: INTEGER
			i: INTEGER
			l_target_level: INTEGER
		do
			root := a_child.path.root

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

	make_from_parent(a_parent: like root; a_branch_number: INTEGER)
			-- make from parent
		require
			non_void: a_parent /= void
			has_path: a_parent.path /= void
			valid: a_parent.path.is_valid
		do
			root := a_parent.path.root

			branch_id := a_branch_number

			as_string := a_parent.path.as_string + separator.out + branch_id.out

			is_valid := true
		end

	make_as_root(a_root: like root)
			-- make as root
		do
			root := a_root
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
