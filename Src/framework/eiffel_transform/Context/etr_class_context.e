note
	description: "Class-context of a transformable."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_CLASS_CONTEXT
inherit
	ETR_CONTEXT
create
	make
convert
	to_class_c: {CLASS_C}

feature {NONE} -- Creation

	make (a_written_class: like written_class)
			-- make with `a_written_class'
		require
			non_void: a_written_class /= void
		do
			written_class := a_written_class
			class_context := Current
		end

feature -- Conversion

	to_class_c: CLASS_C
			-- `Current' as CLASS_C
		do
			Result := written_class
		end

feature -- Access
	written_class: CLASS_C
			-- Compiled class that belongs to this context

	written_in_features: LIST[ETR_FEATURE_CONTEXT]
			-- Features in this context
		do
			if not attached internal_written_in_features then
				init_features
			end
			Result := internal_written_in_features
		end

	written_in_features_by_name: HASH_TABLE[ETR_FEATURE_CONTEXT, STRING]
			-- Features in this context
		do
			if not attached internal_written_in_features_by_name then
				init_features
			end
			Result := internal_written_in_features_by_name
		end

	has_feature_named (a_name: STRING): BOOLEAN
			-- Is there a feature with `a_name' in this context
		require
			name_attached: a_name /= void
		do
			Result := written_class.feature_named (a_name) /= void
		end

	feature_of_rout_id (a_id: INTEGER): detachable ETR_FEATURE_CONTEXT
			-- Feature with the id `a_id' in the current context
		local
			l_feat: FEATURE_I
		do
			l_feat := written_class.feature_of_rout_id (a_id)

			if attached l_feat then
				create Result.make(l_feat, Current)
			end
		end

	corresponding_feature(a_feature: FEATURE_I): detachable ETR_FEATURE_CONTEXT
			-- Return the corresponding feature in `a_class_context'
		require
			non_void: a_feature /= void
		local
			l_rout_id: INTEGER
			l_feat: FEATURE_I
		do
			Result := feature_of_rout_id(a_feature.rout_id_set.first)
		end

feature {NONE} -- Implementation

	internal_written_in_features: like written_in_features

	internal_written_in_features_by_name: like written_in_features_by_name

	init_features
			-- Init internal feature table
		local
			l_written_in: LIST [E_FEATURE]
			l_feat_context: ETR_FEATURE_CONTEXT
		do
			from
				create {LINKED_LIST[ETR_FEATURE_CONTEXT]}internal_written_in_features.make
				l_written_in := written_class.written_in_features
				create internal_written_in_features_by_name.make(l_written_in.count)
				l_written_in.start
			until
				l_written_in.after
			loop
				create l_feat_context.make (l_written_in.item.associated_feature_i, Current)
				internal_written_in_features.extend(l_feat_context)
				internal_written_in_features_by_name.extend(l_feat_context, l_feat_context.name)
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
