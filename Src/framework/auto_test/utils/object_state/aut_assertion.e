note
	description: "Summary description for {AUT_ASSERTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_ASSERTION

create
	make

feature{NONE} -- Initialization

	make (a_tag: like tag; a_written_class: like written_class) is
			-- Set `tag' with `a_tag' and `written_class' with `a_written_class'.
		require
			a_tag_attached: a_tag /= Void
			a_written_class_attached: a_written_class /= Void
		do
			set_tag (a_tag)
			set_written_class (a_written_class)
		end

feature -- Access

	tag: TAGGED_AS
			-- Assertion tag AST node

	written_class: CLASS_C
			-- Class where `tag' is written

	tag_name: STRING is
			-- Name of `tag'
		do
			if tag.tag /= Void then
				Result := tag.tag.name.twin
			else
				create Result.make_empty
			end
		ensure
			result_attached: Result /= Void
		end

feature -- Setting

	set_tag (a_tag: like tag) is
			-- Set `tag' with `a_tag'.
		require
			a_tag_attached: a_tag /= Void
		do
			tag := a_tag
		ensure
			tag_set: tag = a_tag
		end

	set_written_class (a_written_class: like written_class) is
			-- Set `written_class' with `a_written_class'.
		require
			a_written_class_attached: a_written_class /= Void
		do
			written_class := a_written_class
		ensure
			written_class_set: written_class = a_written_class
		end

invariant
	tag_attached: tag /= Void
	written_class_attached: written_class /= Void

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
