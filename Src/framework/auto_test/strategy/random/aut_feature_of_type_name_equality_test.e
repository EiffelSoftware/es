note
	description: "Summary description for {AUT_FEATURE_OF_TYPE_NAME_EQUALITY_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_FEATURE_OF_TYPE_NAME_EQUALITY_TEST


inherit

	KL_EQUALITY_TESTER [AUT_FEATURE_OF_TYPE]
		redefine
			test
		end

	EPA_ARGUMENTLESS_PRIMITIVE_FEATURE_FINDER
		undefine
			system
		end

create
	make

feature {NONE} -- Initialization

	make (a_system: like system)
			-- Create new tester.
			-- `a_feature' of type `a_type'.
		do
			system := a_system
		end

feature -- Access

	system: SYSTEM_I
			-- Current system

feature -- Status report

	test (v, u: AUT_FEATURE_OF_TYPE): BOOLEAN
		local
			l_feat_v: FEATURE_I
			l_feat_u: FEATURE_I
			l_class_v: CLASS_C
			l_class_u: CLASS_C
		do
			if v /= Void and then u /= Void then
				l_class_v := v.type.associated_class
				l_class_u := u.type.associated_class
				if l_class_v.class_id = l_class_u.class_id then
					Result := v.feature_.feature_name.is_case_insensitive_equal (u.feature_.feature_name)
--					l_feat_v := final_feature (v.feature_.feature_name, v.feature_.written_class, l_class_v)
--					l_feat_u := final_feature (u.feature_.feature_name, u.feature_.written_class, l_class_u)
--					Result := l_feat_v.feature_name.is_case_insensitive_equal (l_feat_u.feature_name)
				end
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
