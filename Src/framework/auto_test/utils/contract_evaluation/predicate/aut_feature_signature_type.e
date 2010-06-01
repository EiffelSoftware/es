note
	description: "Summary description for {AUT_FEATURE_SIGNATURE_TYPE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_FEATURE_SIGNATURE_TYPE

inherit
	HASHABLE

create
	make

feature{NONE} -- Initialization

	make (a_feature: like feature_; a_position: like position) is
			-- Initialize.
		require
			a_feature_attached: a_feature /= Void
			a_position_valid: is_position_valid (a_position, a_feature)
		local
			l_feat: FEATURE_I
		do
			feature_ := a_feature
			l_feat := feature_.feature_

			if a_position = 0 then
				type := a_feature.type
			elseif a_position <= l_feat.argument_count then
				type := l_feat.arguments.i_th (a_position).actual_type.instantiation_in (a_feature.type, a_feature.type.associated_class.class_id)
			else
				type := l_feat.type.actual_type.instantiation_in (a_feature.type, a_feature.type.associated_class.class_id)
			end
			position := a_position
		ensure
			position_set: position = a_position
			feature_set: feature_ = a_feature
			type_has_class: type.has_associated_class
		end

feature -- Access

	feature_: AUT_FEATURE_OF_TYPE
			-- Feature from which current signature entity comes

	argument_count: INTEGER is
			-- Number of arguments in `feature_'
		do
			Result := feature_.feature_.argument_count
		ensure
			good_result: Result = feature_.feature_.argument_count
		end

	type: TYPE_A
			-- Type of the entity in `position'

	position: INTEGER
			-- 0-based Entity position
			-- 0 represents the target of a feature call,
			-- `argument_count' + 1 represents the returned object, if any.

	hash_code: INTEGER
			-- Hash code value
		do
			Result := position
		ensure then
			good_result: Result = position
		end

feature -- Status report

	is_result_value: BOOLEAN is
			-- Does current represent result value of `feature_'?
		do
			Result := position = feature_.feature_.argument_count + 1
		ensure
			good_result: Result = (position = feature_.feature_.argument_count + 1)
		end

	is_position_valid (a_position: like position; a_feature: like feature_): BOOLEAN is
			-- Is `a_position' valid in the context of `a_feature'?
		local
			l_feat: FEATURE_I
		do
			if a_position >= 0 then
				l_feat := a_feature.feature_
				if l_feat.type.is_none then
					Result := a_position <= l_feat.argument_count
				else
					Result := a_position <= l_feat.argument_count + 1
				end
			end
		end

invariant
	feature_attached: feature_ /= Void
	position_valid: is_position_valid (position, feature_)

;note
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
