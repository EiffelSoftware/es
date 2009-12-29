note
	description: "Context of an AST that is to be modified by EiffelTransform. PLACEHOLDER."
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_CONTEXT
inherit
	REFACTORING_HELPER
		export
			{NONE} all
		end
create
	make_from_class,
	make_from_feature,
	default_create -- debug so we don't break other stuff yet

feature --Access
	--fixme: should we use more general types like CLASS_C and FEATURE_I ?
	written_class: EIFFEL_CLASS_C
	written_feature: detachable E_FEATURE

	is_feature: BOOLEAN
			-- does `Current' represent the context of a feature

feature {NONE} -- Creation

	make_from_class(a_class: like written_class)
			-- make with `a_class'
		require
			non_void: a_class /= void
		do
			written_class := a_class

--			is_feature := false
		end

	make_from_feature(a_feature: like written_feature)
			-- make with `a_feature'
		require
			non_void: a_feature /= void
			good_written_class: a_feature.written_in /= 0
			eiffel_written_class: a_feature.written_class.is_eiffel_class_c
		do
			written_feature := a_feature
			fixme("Is this what we want?")
			written_class := a_feature.written_class.eiffel_class_c

			is_feature := true
		end

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
