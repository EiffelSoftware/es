note
	description: "Summary description for {AUT_PREDICATE_OF_FEATURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PREDICATE_OF_FEATURE

create
	make

feature{NONE} -- Initialization

	make (a_feature: like feature_; a_predicate: like predicate; a_access_pattern: like access_pattern) is
			-- Initialize current.
		do
			feature_ := a_feature
			predicate := a_predicate
			access_pattern := a_access_pattern
		ensure
			feature_set: feature_ = a_feature
			predicate_set: predicate = a_predicate
			access_pattern_set: access_pattern = a_access_pattern
		end

feature -- Access

	feature_: AUT_FEATURE_OF_TYPE
			-- Feature whose predicates are represented in Current

	context_class: CLASS_C is
			-- Class associated with `feature_'
		do
			Result := feature_.associated_class
		ensure
			good_result: Result = feature_.associated_class
		end

	predicate: AUT_PREDICATE
			-- Predicate associated with `feature_'

	access_pattern: DS_HASH_TABLE [INTEGER, INTEGER]
			-- Access patterns for the predicates associated with current feature.
			-- [call variable index, predicate argument index]
			-- Key is the variable index in actual feature call (0 is the index for target).
			-- Value is the argument position in the assoicated `predicate'.

invariant
		access_pattern_valid: access_pattern.count = predicate.narity

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
