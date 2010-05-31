note
	description: "[
			Given a predicate and a set of objects with types,
			this class generate a set of tuples from those objects,
			all the object tuples can be used to evalue the predicate.
			This means, the arity of tuples and all the types in the tuples
			correspond to the types of that predicate
			]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PREDICATE_ARGUMENT_ARRANGER

inherit
	AUT_PREDICATE_UTILITY
		undefine
			system
		end

create
	make

feature{NONE} -- Initialization

	make (a_predicate: like predicate; a_system: like system) is
			-- Initialize `predicate' with `a_predicate'.
		require
			a_predicate_attached: a_predicate /= Void
			a_system_attached: a_system /= Void
		do
			predicate := a_predicate
			system := a_system
			set_should_contain_result (True)
		ensure
			predicate_set: predicate = a_predicate
			system_set: system = a_system
			should_contain_result: should_contain_result
		end

feature -- Access

	predicate: AUT_PREDICATE
			-- Predicate under consideration

	system: SYSTEM_I
			-- System under consideration

feature -- Basic operations

	arrangements_for_feature (a_feature: AUT_FEATURE_OF_TYPE): like arrangements is
			-- List of possible arrangement of (possibly a subset of) objects from `a_feature' that
			-- is suitable to be used to evaluate `predicate'
		local
			l_objs: DS_HASH_SET [AUT_FEATURE_SIGNATURE_TYPE]
			i: INTEGER
			l_count: INTEGER
		do
			create l_objs.make (a_feature.feature_.argument_count + 2)
			l_objs.set_equality_tester (feature_signature_type_equality_tester)

			l_count := 1 + l_count + a_feature.feature_.argument_count
			if not a_feature.feature_.type.is_void then
				l_count := l_count + 1
			end

			from
				i := 0
			until
				i = l_count
			loop
				l_objs.force_last (create {AUT_FEATURE_SIGNATURE_TYPE}.make (a_feature, i))
				i := i + 1
			end

			Result := arrangements (l_objs)
		end

	arrangements (a_object_set: DS_HASH_SET [AUT_FEATURE_SIGNATURE_TYPE]): DS_LINKED_LIST [ARRAY [AUT_FEATURE_SIGNATURE_TYPE]] is
			-- List of possible arrangement of (possibly a subset of) objects from `a_object_set' that
			-- is suitable to be used to evaluate `predicate'
		require
			a_object_set_attached: a_object_set /= Void
		local
			l_candidates: like conformant_types
			i: INTEGER
			l_arg_count: INTEGER
			l_curr_arg_types: LINKED_LIST [AUT_FEATURE_SIGNATURE_TYPE]
			l_done: BOOLEAN
			l_last_arrangement: ARRAY [AUT_FEATURE_SIGNATURE_TYPE]
			l_has_result: BOOLEAN
			l_has_result_tester: PREDICATE [ANY, TUPLE [AUT_FEATURE_SIGNATURE_TYPE]]
		do
			create Result.make
			if predicate.arity > 0 then
				l_candidates := conformant_types (a_object_set)
				l_arg_count := predicate.arity
				create l_last_arrangement.make (1, l_arg_count)
				l_has_result_tester := agent (a: AUT_FEATURE_SIGNATURE_TYPE): BOOLEAN do Result := a.is_result_value end
				l_has_result := a_object_set.there_exists (l_has_result_tester)
				from
					i := 1
					l_curr_arg_types := l_candidates.item (i)
					l_curr_arg_types.start
				until
					l_done
				loop
					if l_curr_arg_types.after then
							-- Backtrack.
						i := i - 1
						if i = 0 then
								-- We finished all possible arrangements.
							l_done := True
						else
							l_curr_arg_types := l_candidates.item (i)
							if not l_curr_arg_types.after then
								l_curr_arg_types.forth
							end
						end
					else
						l_last_arrangement.put (l_curr_arg_types.item_for_iteration, i)
						if i < l_arg_count then
								-- If some argument are not fixed yet.
							i := i + 1
							l_curr_arg_types := l_candidates.item (i)
							l_curr_arg_types.start
						else
							if (l_has_result and then should_contain_result) implies l_last_arrangement.there_exists (l_has_result_tester) then
									-- We found one arrangement, add it into result.
								Result.force_last (l_last_arrangement.twin)
							end
							l_curr_arg_types.forth
						end
					end
				end
			end
		ensure
			result_attached: Result /= Void
		end

feature -- Status report

	is_universal_conformant_to_any: BOOLEAN
			-- Are all types conformant to {ANY}?
			-- Semantically speaking, all types conform to {ANY},
			-- while this concept is introduced to reduce the number of object tuples
			-- that `predicate' needs to be evaluated with.
			-- For example, in LINKED_LIST [ANY], if there is a call to l.put (i, v),
			-- you don't really want to evaluate the predicate l.has (i), even though the
			-- type of i: INTEGER conforms to the type of the argument in predicate has, which is
			-- {ANY}.
			-- Default: False

	should_contain_result: BOOLEAN
			-- Should the returned arrangement contain
			-- the object representing the returned value?
			-- This is used to reduce the number of predicates that
			-- needs to be reevaluated after a query call: we only
			-- want to reevalate predicates that have something to do
			-- with the result value.
			-- Default: True

feature -- Setting

	set_is_universal_conformant_to_any (b: BOOLEAN) is
			-- Set `is_universal_conformant_to_any' with `b'.
		do
			is_universal_conformant_to_any := b
		ensure
			is_universal_conformant_to_any_set: is_universal_conformant_to_any = b
		end

	set_should_contain_result (b: BOOLEAN) is
			-- Set `should_contain_result' with `b'.
		do
			should_contain_result := b
		ensure
			should_contain_result_set: should_contain_result = b
		end

feature{NONE} -- Implementation

	conformant_types (a_object_set: DS_HASH_SET [AUT_FEATURE_SIGNATURE_TYPE]): ARRAY [LINKED_LIST [AUT_FEATURE_SIGNATURE_TYPE]] is
			-- Array of list of types, all the types in a list conforms to the type of the argument in `predicate' at the location
			-- The conformance comparison takes `is_universal_conformant_to_any' into consideration.
		require
			a_object_set_attached: a_object_set /= Void
			predicate_has_argument: predicate.arity > 0
		local
			i: INTEGER
			l_count: INTEGER
			l_types: LINKED_LIST [AUT_FEATURE_SIGNATURE_TYPE]
			l_pred_arg_type: TYPE_A
		do
			l_count := predicate.arity
			create Result.make (1, l_count)
			from
				i := 1
			until
				i > l_count
			loop
				l_pred_arg_type := predicate.argument_types.item (i)
				create l_types.make
				from
					a_object_set.start
				until
					a_object_set.after
				loop
					if is_signature_type_conformant_to_type (a_object_set.item_for_iteration, l_pred_arg_type) then
						l_types.extend (a_object_set.item_for_iteration)
					end
					a_object_set.forth
				end
				Result.put (l_types, i)
				i := i + 1
			end
		ensure
			result_attached: Result /= Void
			good_result: Result.count = predicate.arity
		end

	is_signature_type_conformant_to_type (a_signature_type: AUT_FEATURE_SIGNATURE_TYPE; a_type: TYPE_A): BOOLEAN is
			-- Is type in `a_signature_type' conformant to `a_type'?
			-- The conformance comparison takes `is_universal_conformant_to_any' into consideration.
		require
			a_signature_type_attached: a_signature_type /= Void
			a_type_attached: a_type /= Void
			a_signature_type_has_class: a_signature_type.type.has_associated_class
			a_type_has_class: a_type.has_associated_class
		local
			l_any_class: CLASS_C
		do
			l_any_class := system.any_class.compiled_representation
			Result := a_signature_type.type.conform_to (system.root_type.associated_class, a_type)
			if
				Result and then
				(not is_universal_conformant_to_any) and then
				a_type.associated_class.class_id = l_any_class.class_id
			then
				Result := a_signature_type.type.associated_class.class_id = l_any_class.class_id
			end
		end

invariant
	predicate_attached: predicate /= Void
	system_attached: system /= Void

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
