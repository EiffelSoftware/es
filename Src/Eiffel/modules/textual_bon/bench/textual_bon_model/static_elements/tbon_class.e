note
	description: "A class in a BON specification."
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_CLASS

create
	make

feature -- Initialization
	make (class_as: CLASS_AS)
			-- Create a textual BON class.
		do
			create name.make_element (associated_class_name)
			create {ARRAYED_LIST[TBON_CLASS_TYPE]} ancestors.make (10)

			extract_associated_class_ancestors
		end

feature -- Access
	ancestors: LIST[TBON_CLASS_TYPE]
			-- From which classes does this class inherit?

	class_invariant: TBON_INVARIANT
			-- What is the invariant of this class?

	feature_clauses: LIST[TBON_FEATURE_CLAUSE]
			-- What are the feature clauses of this class?

	--indexing_clause: TBON_INDEXING_CLAUSE
			-- What is the indexing clause of this class?

	name: attached TBON_IDENTIFIER
			-- What is the name of this class?

	type_parameters: LIST[TBON_FORMAL_GENERIC]
			-- What are the type parameters of this class?

feature -- Status report	
	is_deferred: BOOLEAN
			-- Is this class deferred?

	is_effective: BOOLEAN
			-- Is this class effective?

	is_generic: BOOLEAN
			-- Is this class generic?
		do
			Result := type_parameters /= Void
		end

	is_interfaced: BOOLEAN
			-- Is this class interfaced?

	is_persistent: BOOLEAN
			-- Is this class persistent?

	is_reused: BOOLEAN
			-- Is this class reused?

	is_root: BOOLEAN
			-- Is this class a root class?

feature -- Status setting
	set_is_deferred
			-- Set this class to be deferred.
		do
			is_deferred := True
			is_effective := False
			is_root := False
		ensure
			is_deferred: is_deferred
			is_not_effective: not is_effective
			is_not_root: not is_root
		end

	set_is_effective
			-- Set this class to be effective.
		do
			is_deferred := False
			is_effective := True
			is_root := False
		ensure
			is_not_deferred: not is_deferred
			is_effective: is_effective
			is_not_root: not is_root
		end

	set_is_root
			-- Set this class to be a root class.
		do
			is_deferred := False
			is_effective := False
			is_root := True
		ensure
			is_not_deferred: not is_deferred
			is_not_effective: not is_effective
			is_root: is_root
		end

feature {NONE} -- Implementation
	associated_class: CLASS_AS
			-- What is the associated Eiffel class of this BON class?

	associated_class_name: STRING
			-- Extract class name from the abstract class syntax.
		once
			Result := associated_class.class_name.string_value_32
		end

	create_feature_clause_with_features (feature_clause: FEATURE_CLAUSE_AS)
			-- Create a textual BON feature clause and its associated features
		local
			--bon_feature_clause: TBON_FEATURE_CLAUSE
		do
			--create bon_feature_clause.make_element (feature_clause., feature_list: [detachable] LIST [[detachable] TBON_FEATURE], sel_export: [detachable] TBON_SELECTIVE_EXPORT)
		end

	extract_associated_class_ancestors
			-- Extract the ancestors for the associated class
		do
			associated_class.conforming_parents.do_all (agent (ancestor: PARENT_AS)
				local
					ancestor_class_type: TBON_CLASS_TYPE
				do
					create ancestor_class_type.make_element (ancestor.type.class_name.string_value_32)
					ancestors.put (ancestor_class_type)
				ensure
					ancestors.count = old ancestors.count + 1
				end
			)
		end

	extract_associated_class_feature_clauses
			-- Extract the feature clauses and features of the associated class
		do
			--associated_class.features
		end


invariant
	deferred_status_is_consistent: is_deferred implies not is_effective and not is_root
	effective_status_is_consistent: is_effective implies not is_deferred and not is_root
	root_status_is_consistent: is_root implies not is_deferred and not is_effective
	must_have_type_parameters_if_not_void: is_generic implies not type_parameters.is_empty


;note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
