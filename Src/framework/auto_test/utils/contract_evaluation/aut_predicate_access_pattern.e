note
	description: "[
			Predicate access pattern from a feature.
			This classes maintains a two way mapping from
			entities of a feature (target, argument) to arguments
			of a predicate.
			
			For example:
			
			l.put (v: ANY; i: INTEGER)
				require
					extendible: l.extendible
					not_has_v: not has (v)
					
			The predicate "extendible" is a one argument predicate, the first
			argument of the predicate is the target object.
			
			The predicate "not_has_v" is a two argument predicate, the first
			argument of the predicate is the target object, and then second 
			argument of the predicate is the first argument of the feature call.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PREDICATE_ACCESS_PATTERN

create
	make

feature{NONE} -- Initialization

	make (a_feature: like feature_; a_predicate: like predicate; a_access_pattern: like access_pattern) is
			-- Initialize current.
		require
			a_feature_attached: a_feature /= Void
			a_predicate_attached: a_predicate /= Void
			a_access_pattern_attached: a_access_pattern /= Void
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
			-- Value is the argument position (which is 1-based) in the assoicated `predicate'.

	break_point_slot: INTEGER
			-- Break point slot indicating where current predicate appears in
			-- `feature_' viewed from `context_class'

feature -- Setting

	set_break_point_slot (a_index: INTEGER) is
			-- Set `break_point_slot' with `a_index'.
		do
			break_point_slot := a_index
		ensure
			index_set: break_point_slot = a_index
		end

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
