note
	description: "Summary description for {AUT_PREDICATE_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PREDICATE_UTILITY

inherit
	ERL_G_TYPE_ROUTINES

	SHARED_WORKBENCH

feature -- Access

	predicate_equality_tester: AGENT_BASED_EQUALITY_TESTER [AUT_PREDICATE] is
			-- Equality tester for predicate
		do
			create Result.make (agent (a, b: AUT_PREDICATE): BOOLEAN do Result := a.is_equal (b) end)
		end

	feature_of_type_equality_tester: AUT_FEATURE_OF_TYPE_EQUALITY_TESTER is
			-- Equality tester for feature of type
		do
			create Result.make
		end

	string_equality_tester: AGENT_BASED_EQUALITY_TESTER [STRING] is
			-- Equality test for string
		do
			create Result.make (agent (a, b: STRING): BOOLEAN do Result := a.is_equal (b) end)
		end

	sovled_linear_model_loader: AUT_SOLVED_LINEAR_MODEL_LOADER is
			-- Loader of a solved linear model
		do
			if {PLATFORM}.is_windows then
				create {AUT_Z3_SOLVED_LINEAR_MODEL_LOADER} Result
			else
				create {AUT_CVC3_SOLVED_LINEAR_MODEL_LOADER} Result
			end
		end

	linear_constraint_solver_command (a_smtlib_file_path: STRING): STRING is
			-- Command to sovle linear constraints, with input file `a_smtlib_file_path'
		do
			if {PLATFORM}.is_windows then
				Result := "z3 /m /smt " + a_smtlib_file_path
			else
				Result := "/bin/sh -c %"cvc3 +model -lang smt " + a_smtlib_file_path + "%""
			end
		end

	testable_features (a_type: TYPE_A; a_system: SYSTEM_I): DS_LINKED_LIST [AUT_FEATURE_OF_TYPE] is
			-- Features in `a_type' in `a_system' which are testable by AutoTest
		require
			a_type_has_class: a_type.has_associated_class
		local
			feature_: AUT_FEATURE_OF_TYPE
			class_: CLASS_C
			feature_i: FEATURE_I
			l_feat_table: FEATURE_TABLE
			l_any_class: CLASS_C
		do
			create Result.make
			l_any_class := a_system.any_class.compiled_class
			class_ := a_type.associated_class

			l_feat_table := class_.feature_table
			from
				l_feat_table.start
			until
				l_feat_table.after
			loop
				feature_i := l_feat_table.item_for_iteration
				if not feature_i.is_prefix and then not feature_i.is_infix then
						-- Normal exported features.
					if
						feature_i.export_status.is_exported_to (l_any_class) or else
						is_exported_creator (feature_i, a_type)
					then
						Result.force_last (create {AUT_FEATURE_OF_TYPE}.make (feature_i, a_type))
					end
				end
				l_feat_table.forth
			end
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
