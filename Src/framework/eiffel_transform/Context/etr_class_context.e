note
	description: "Context of an AST that is to be modified by EiffelTransform."
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_CLASS_CONTEXT
inherit
	ETR_CONTEXT
create
	make

feature --Access
	written_class: detachable CLASS_C
	written_in_features: LIST[ETR_FEATURE_CONTEXT]

	-- fixme: add feature by name
	class_features_by_name: HASH_TABLE[ETR_FEATURE_CONTEXT, STRING]

	feature_of_id(an_id: INTEGER): ETR_FEATURE_CONTEXT
			-- gets feature with the id `an_id' in the current context
		local
			l_feat_i: FEATURE_I
		do
			-- todo:
			-- lookup internal features
			-- then in written_class

			l_feat_i := written_class.feature_of_feature_id (an_id)

			if attached l_feat_i then
				create Result.make(l_feat_i, Current)
			end
		end

feature {NONE} -- Creation

	make(a_written_class: like written_class)
			-- make with `a_written_class'
		require
			non_void: a_written_class /= void
		local
			l_written_in: LIST [E_FEATURE]
		do
			written_class := a_written_class

			-- add features			
			-- fixme: lazy init?!
			from
				create {LINKED_LIST[ETR_FEATURE_CONTEXT]}written_in_features.make
				l_written_in := a_written_class.written_in_features
				l_written_in.start
			until
				l_written_in.after
			loop
				written_in_features.extend(create {ETR_FEATURE_CONTEXT}.make(l_written_in.item.associated_feature_i, Current))
				l_written_in.forth
			end
		end
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
