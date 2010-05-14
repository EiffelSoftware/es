note
	description: "Seach functionality to find assigners within ancestors of a class."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROXY_ASSIGN_FINDER

inherit
	SCOOP_WORKBENCH
		export
			{NONE} all
		end

feature -- Access

	has_parents_feature_with_assigner (an_original_name, an_original_alias_name: STRING; a_base_class: CLASS_C): BOOLEAN
			-- Does the feature with name `an_original_name' or `an_original_alias_name'
			-- and an assigner exists within the ancestors of `a_base_class'?
		local
			l_result: TUPLE [found: BOOLEAN; assigner: STRING]
		do
			l_result := has_feature (an_original_name, an_original_alias_name, a_base_class, false, false, false)
			Result := l_result.found
		end

	has_current_or_parents_feature_with_assigner (an_original_name, an_original_alias_name: STRING; a_parent_class: CLASS_C): BOOLEAN
			-- Does the feature with name `an_original_name' or `an_original_alias_name'
			-- and an assigner exists within the ancestors of `a_base_class' or itself?
		local
			l_result: TUPLE [found: BOOLEAN; assigner: STRING]
		do
			l_result := has_feature (an_original_name, an_original_alias_name, a_parent_class, True, false, false)
			Result := l_result.found
		end

	is_first_parent_feature_deferred (an_original_name, an_original_alias_name: STRING; a_base_class: CLASS_C): BOOLEAN
			-- Is the first inherited parent feature of the feature with
			-- name `an_original_name' or `an_original_alias' deferred?
		do
			Result := is_first_feature_deferred (an_original_name, an_original_alias_name, a_base_class, false)
		end

	inherited_assigner_name (an_original_name, an_original_alias_name: STRING; a_base_class: CLASS_C): STRING
			-- Inherited assigner name of the feature with name `an_original_name'
			-- or `an_original_alias_name'.
		local
			l_result: TUPLE [found: BOOLEAN; assigner: STRING]
		do
			l_result := has_feature (an_original_name, an_original_alias_name, a_base_class, false, True,false)
			Result := l_result.assigner
		end

feature -- Access Redeclaration substituion

	have_to_replace_internal_arguments (a_feature_name: FEATURE_NAME; a_class: CLASS_C; a_argument_position: INTEGER): BOOLEAN
			-- Do we need to replace the return type?
			-- Is the case when we have a redeclaration with a separate return type
		require
			a_class_is_valid: a_class /= void
			a_feature_name_is_valid: a_feature_name /= void and then a_class.feature_table.has (a_feature_name.internal_name.name)
			a_argument_position_is_valid: a_argument_position > 0 and
					a_argument_position <= a_class.feature_table.item (a_feature_name.internal_name.name).arguments.count
		local
			l_child_feature: FEATURE_I
			l_ancestor_features: LINKED_SET[FEATURE_I]
			l_current_feature: FEATURE_I
			l_one_parent_feature_argument_is_non_separate: BOOLEAN
		do
			l_child_feature := a_class.feature_table.item (a_feature_name.internal_name.name)
			from
				l_ancestor_features := ancestor_features (l_child_feature.rout_id_set, a_class)
				l_ancestor_features.start
			until
				l_ancestor_features.after
			loop
				l_current_feature := l_ancestor_features.item
				if not l_current_feature.arguments.at (a_argument_position).is_separate then
					l_one_parent_feature_argument_is_non_separate := true
				end
				l_ancestor_features.forth
			end
			Result := (l_child_feature.arguments /= void and then l_child_feature.arguments.i_th (a_argument_position).is_separate) and l_one_parent_feature_argument_is_non_separate
		end

	have_to_replace_return_type (a_feature_name: FEATURE_NAME; a_class: CLASS_C): BOOLEAN
			-- Do we need to replace the return type?
			-- Is the case when we have a redeclaration with a separate return type
		require
			a_class_is_valid: a_class /= void
			a_feature_name_is_valid:
				a_feature_name /= void and then
				a_class.feature_table.has (a_feature_name.internal_name.name) and then
				a_class.feature_table.item (a_feature_name.internal_name.name).type /= void
		local
			l_child_feature: FEATURE_I
			l_ancestor_features: LINKED_SET[FEATURE_I]
			l_current_feature: FEATURE_I
			l_one_parent_feature_has_separate_return_type: BOOLEAN
		do
			l_child_feature := a_class.feature_table.item (a_feature_name.internal_name.name)
			from
				l_ancestor_features := ancestor_features (l_child_feature.rout_id_set, a_class)
				l_ancestor_features.start
			until
				l_ancestor_features.after
			loop
				l_current_feature := l_ancestor_features.item
				if l_current_feature.type.is_separate then
					l_one_parent_feature_has_separate_return_type := true
				end
				l_ancestor_features.forth
			end
			Result := not l_child_feature.type.is_separate and l_one_parent_feature_has_separate_return_type
		end

	ancestor_features (a_feature: ROUT_ID_SET; a_class: CLASS_C): LINKED_SET[FEATURE_I]
			-- All the ancestors features of the feature defined in 'a_feature' written in class 'a_class'.
		local
			l_parent_class: CLASS_C
			l_parent_feature: FEATURE_I
		do
			from
				a_class.parents_classes.start
				create Result.make
			until
				a_class.parents_classes.after
			loop
				l_parent_class := a_class.parents_classes.item
				l_parent_feature := l_parent_class.feature_of_rout_id_set (a_feature)
				if l_parent_feature /= void then
					Result.put (l_parent_feature)
					Result.fill (ancestor_features(a_feature, l_parent_class))
				end
				a_class.parents_classes.forth
			end
		end

	generic_parameters_to_replace (a_feature_name: FEATURE_NAME; a_class_c: CLASS_C; is_processed_class: BOOLEAN;  internal_argument: TUPLE[pos:INTEGER;type:TYPE_AS]; is_return_type: BOOLEAN): LINKED_LIST[TUPLE[INTEGER,INTEGER]] is
			-- Do we need to substitute generics? Is the case when we have a redeclaration with separate generics
			-- `is_processed_class' : Is the class we are checking the current processed class?
			-- `is_return_type' : Are we checking the generics of a return type? If this is `False' we are cheking the generics of a internal argument
			-- `internal_argument': Is void when `is_return_type' is true. Else it denotes the position of the internal argument we are currently checking
			-- Returns the list of the generics we need to adapt
			require
				has_name: a_feature_name /= void
				has_class: a_class_c /= void
				makes_sense: internal_argument = void implies is_return_type
			local
				l_type_expr_visitor: SCOOP_TYPE_EXPR_VISITOR
				parent_class_c: CLASS_C
				l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
				l_original_feature_alias_name,l_original_feature_name: STRING
				l_class_as: CLASS_AS
			do
				-- Setup:
				l_feature_name_visitor := scoop_visitor_factory.new_feature_name_visitor
				l_type_expr_visitor := scoop_visitor_factory.new_type_expr_visitor

				l_class_as := class_as_by_name (a_class_c.name)

				-- Check if class has a redefine clause for this feature
				create generic_parameters_to_substitute.make
				if l_class_as.parents /= void then

					-- get original feature name
					l_feature_name_visitor.process_original_feature_name_no_matchlist (a_feature_name, True, is_processed_class)
					l_original_feature_alias_name := l_feature_name_visitor.feature_name
					l_feature_name_visitor.process_original_feature_name_no_matchlist (a_feature_name, False, is_processed_class)
					l_original_feature_name := l_feature_name_visitor.feature_name

					from
						l_class_as.parents.start
					until
						l_class_as.parents.after
					loop
						if l_class_as.parents.item.redefining /= void and then l_class_as.parents.item.redefining.has (a_feature_name) then
							-- Has a redefine clause for this feature:
							parent_class_c := system.class_of_id (class_as_by_name (l_class_as.parents.item.type.class_name.name).class_id)
							if is_return_type then
								original_class_type := a_class_c.feature_named (a_feature_name.visual_name).body.body.type
							else
								original_class_type := internal_argument.type
							end
							has_parent_feature_different_generics (l_original_feature_name, l_original_feature_alias_name, parent_class_c,internal_argument, is_return_type)
						end
						l_class_as.parents.forth
					end
				end
				Result := generic_parameters_to_substitute
			end

feature {NONE} -- Implementation

	has_feature (an_original_name, an_original_alias_name: STRING; a_class_c: CLASS_C; is_check_base_class, track_assigner, ignore_found: BOOLEAN): TUPLE [found: BOOLEAN; assigner: STRING]
			-- Does some ancestors of `a_class_c' have a feature with name `an_original_name'
			-- or `an_original_alias_name' and an assigner?
			-- Check also `a_class_c' if `is_check_base_class' has value `True'.
			-- If `ignore_found' is `true' we ignore findings and keep searching until we get `return_type_separate'
		local
			l_skip_current_parent: BOOLEAN
			i, j, nb, nbj: INTEGER
			l_rename_str, l_assigner_str: STRING
			l_class_c: CLASS_C
			l_feature_i: FEATURE_I
			l_assign_visitor: SCOOP_PROXY_ASSIGN_VISITOR
			l_result, l_tmp_result: TUPLE [found: BOOLEAN; assigner: STRING]
			l_tuple: TUPLE [parent_name: STRING; old_feature_name, new_feature_name: STRING]
			l_parent_renamings, l_old_parent_renamings: LINKED_LIST [TUPLE [parent_name: STRING; old_feature_name, new_feature_name: STRING]]
			start_position: TUPLE[stage,pos:INTEGER]
		do
			create l_result

			if is_check_base_class then
				-- check current class
				if a_class_c.feature_table.has (an_original_name) or a_class_c.feature_table.has (an_original_alias_name) then
					if a_class_c.feature_table.has (an_original_name) then
						l_feature_i := a_class_c.feature_table.item (an_original_name)
					else
						l_feature_i := a_class_c.feature_table.item (an_original_alias_name)
					end

					if ignore_found then
						-- Used to find redeclarated features
						-- `check_return_type' : Check if return type was redeclared from separate to non separate
						-- `internal_argument_to_check' /= void : Check if if internal arguments was redeclared from non separate to separate
						-- `check_generics' : Check if generics from a class type was redeclared
								-- from separate to non separate from a return type
								-- from non separate to separate from an internal argument
						if compare_return_type and then l_feature_i.type /= void then
							if compare_generics then
								create start_position.default_create
								start_position.stage := 0
								start_position.pos := 1
								compare_generic_parameters(l_feature_i.body.body.type, original_class_type, start_position)
							elseif l_feature_i.type.is_separate then
								return_type_separate := True
								l_result.found := True
								-- Result found: Stop Searching
							end
						end
						if compare_internal_argument and then l_feature_i.body.body.internal_arguments /= void then
							if has_nseparate_internal_argument(l_feature_i) then
								internal_argument_nseparate := True
								l_result.found := True
							end
						end
					elseif l_feature_i.written_in = a_class_c.class_id
						-- test only features in current processed class,
						-- otherwise we dont get the renaming					
					and then l_feature_i.assigner_name /= Void then
						l_result.found := True
						l_result.assigner := l_feature_i.assigner_name
					end
				end
			end

			if (not l_result.found) then
				-- get any renamings of `an_original_feature' of all parents
				create l_assign_visitor
				l_parent_renamings := l_assign_visitor.get_renamings (an_original_name, an_original_alias_name, a_class_c, True)
			end

			-- check parents of this parent class
			from
				i := 1
				nb := a_class_c.parents_classes.count
			until
				i > nb or l_result.found
			loop
				l_class_c := a_class_c.parents_classes.i_th (i)
				l_skip_current_parent := false

				-- get rename of current assigner
				l_rename_str := an_original_alias_name
				from
					j := 1
					nbj := l_parent_renamings.count
				until
					j > nbj
				loop
					l_tuple := l_parent_renamings.i_th (j)
					if l_tuple.parent_name.is_equal (l_class_c.name_in_upper)
						and then l_tuple.new_feature_name.is_equal (an_original_name)
						or l_tuple.new_feature_name.is_equal (an_original_alias_name) then

						l_rename_str := l_tuple.old_feature_name
					end
					j := j + 1
				end

				-- check also: is feature f newly defined? case rename f as g,
				-- but no feature is renamed from x to f. In this case f
				-- is new feature - do not track it further in the parents.
				-- set `l_skip_current_parent'
				if l_rename_str.is_equal (an_original_alias_name) then
					-- we do not have rename 'g as f' statement for current feature f.

					l_old_parent_renamings := l_assign_visitor.get_renamings (an_original_name, an_original_alias_name, a_class_c, false)

					-- test if there is a rename statement with 'f as x'
					-- in this case the current f would not have a parent version.
					from
						j := 1
						nbj := l_old_parent_renamings.count
					until
						j > nbj
					loop
						l_tuple := l_old_parent_renamings.i_th (j)
						if l_tuple.parent_name.is_equal (l_class_c.name_in_upper)
							and then l_tuple.old_feature_name.is_equal (an_original_name)
							or l_tuple.old_feature_name.is_equal (an_original_alias_name) then

							-- there is a rename statement 'f as x'. therefore we skip the current parent.
							l_skip_current_parent := True
						end
						j := j + 1
					end
				end

				if not l_skip_current_parent then

					-- check parents (recursive call - therefore check also current class)
					if l_rename_str.is_equal (an_original_alias_name) then
						l_tmp_result := has_feature (an_original_name, an_original_alias_name, l_class_c, True, track_assigner, ignore_found)
					else
						l_tmp_result := has_feature (l_rename_str, l_rename_str, l_class_c, True, track_assigner, ignore_found)
					end
					l_result.found :=  l_result.found or l_tmp_result.found

					-- test if the returned assigner name is renamed in current class
					if track_assigner and l_tmp_result.found and l_result.assigner = Void then

						-- get rename of current assigner
						l_rename_str := l_tmp_result.assigner
						l_assigner_str := l_tmp_result.assigner

						l_old_parent_renamings := l_assign_visitor.get_renamings (l_rename_str, l_rename_str, a_class_c, false)

						from
							j := 1
							nbj := l_old_parent_renamings.count
						until
							j > nbj
						loop
							l_tuple := l_old_parent_renamings.i_th (j)
							if l_tuple.parent_name.is_equal (l_class_c.name_in_upper)
								and then l_tuple.old_feature_name.is_equal (l_rename_str) then

								l_assigner_str := l_tuple.new_feature_name
							end
							j := j + 1
						end

						l_result.assigner := l_assigner_str
					end
				end
				i := i + 1
			end

			Result := l_result
		end

	is_first_feature_deferred (an_original_name, an_original_alias_name: STRING; a_class_c: CLASS_C; is_check_a_class_a: BOOLEAN): BOOLEAN
			-- Is the first inherited parent feature of the feature with name `an_original_name'
			-- or `an_original_alias_name' deferred?
		local
			l_abort: BOOLEAN
			i, j, nb, nbj: INTEGER
			l_rename_str: STRING
			l_class_c: CLASS_C
			l_feature_i: FEATURE_I
			l_assign_visitor: SCOOP_PROXY_ASSIGN_VISITOR
			l_tuple: TUPLE [parent_name: STRING; old_feature_name: STRING]
			l_parent_renamings: LINKED_LIST [TUPLE [parent_name: STRING; old_feature_name: STRING]]
		do
			if is_check_a_class_a then
				-- check current class
				if a_class_c.is_deferred and then a_class_c.feature_table.has (an_original_name)
					or a_class_c.feature_table.has (an_original_alias_name) then

					if a_class_c.feature_table.has (an_original_name) then
						l_feature_i := a_class_c.feature_table.item (an_original_name)
					else
						l_feature_i := a_class_c.feature_table.item (an_original_alias_name)
					end
					if l_feature_i.is_deferred then
						Result := True
					end
				elseif not a_class_c.is_deferred then
					l_abort := True
				end
			end

			-- do not go further if class is already effective
			if not l_abort then
				-- get any renamings of `an_original_feature' of all parents
				create l_assign_visitor
				l_parent_renamings := l_assign_visitor.get_renamings (an_original_name, an_original_alias_name, a_class_c, True)

				-- check parents of this parent class
				from
					i := 1
					nb := a_class_c.parents_classes.count
				until
					i > nb or Result
				loop
					l_class_c := a_class_c.parents_classes.i_th (i)

					-- get rename of current assigner
					l_rename_str := an_original_alias_name
					from
						j := 1
						nbj := l_parent_renamings.count
					until
						j > nbj
					loop
						l_tuple := l_parent_renamings.i_th (j)
						if l_tuple.parent_name.is_equal (l_class_c.name_in_upper) then
							l_rename_str := l_tuple.old_feature_name
						end
						j := j + 1
					end

					-- check parents (recursive call - therefore check also current class)
					if l_rename_str.is_equal (an_original_alias_name) then
						-- no renamings -> check both names
						Result := Result or is_first_feature_deferred (an_original_name, an_original_alias_name, l_class_c, True)
					else
						-- feature name has been renamed -> check only renamed name
						Result := Result or is_first_feature_deferred (l_rename_str, l_rename_str, l_class_c, True)
					end

					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation Redeclaration substitution

	has_parent_feature_different_generics (an_original_name, an_original_alias_name: STRING; a_base_class: CLASS_C; internal_argument:TUPLE[pos:INTEGER;type:TYPE_AS]; is_return_type: BOOLEAN)
			-- Does the feature with name `an_original_name' or `an_original_alias_name' has a parent redeclaration
			-- and does it have different generic parameter (separateness wise)
			-- `is_return_type' : Are we checking the generics of a return type? If this is `False' we are cheking the generics of a internal argument
			-- `internal_argument': Is void when `is_return_type' is true. Else it denotes the position of the internal argument we are currently checking
		require
			makes_sense: internal_argument = void implies is_return_type
		local
			l_result: TUPLE [found: BOOLEAN; assigner: STRING]
		do
			if is_return_type then
				-- Check generics from a return type
				compare_return_type := True
			else
				-- Check generics from a internal argument
				compare_internal_argument := True
				internal_argument_to_check := internal_argument.pos
			end
			compare_generics := True
			l_result := has_feature (an_original_name, an_original_alias_name, a_base_class, True, False, True)
			compare_generics := False
			compare_internal_argument := False
			compare_return_type := False
			internal_argument_to_check := 0
		end


	compare_generic_parameters(curr_type: TYPE_AS; org_type: TYPE_AS; position: TUPLE[stage:INTEGER;pos: INTEGER])
			--
		local
			i: INTEGER
			l_position: TUPLE[stage:INTEGER;pos: INTEGER]
		do
			position.stage := position.stage +1
			if attached {CLASS_TYPE_AS} org_type as o_typ and attached {CLASS_TYPE_AS} curr_type as c_typ then
				-- Check if generics are different (separate wise)
				if not c_typ.is_separate.is_equal(o_typ.is_separate) then
					if not generic_parameters_to_substitute.has (position) then
						create l_position.default_create
						l_position.pos := position.pos
						l_position.stage := position.stage
						generic_parameters_to_substitute.put_front (l_position)
					end
				end
			end
			if attached {GENERIC_CLASS_TYPE_AS} org_type as o_typ and attached {GENERIC_CLASS_TYPE_AS} curr_type as c_typ then
				-- Nested generic type call recursively
				from
					i := 1
				until
					i > o_typ.generics.count
				loop
					position.pos := i
					compare_generic_parameters (c_typ.generics.i_th(i), o_typ.generics.i_th (i), position)
					position.stage := position.stage -1
					i := i+1
				end

			else

			end

		end


	has_nseparate_internal_argument(l_feature_i: FEATURE_I): BOOLEAN
			-- Used for internal_arguments return type fix
			-- Compare internal argument from original feature and feature from parent class

		local
			pos: INTEGER
			start_position: TUPLE[stage,pos:INTEGER]
		do
			pos := 1 -- # of argument
			from
				l_feature_i.body.body.internal_arguments.arguments.start
			until
				l_feature_i.body.body.internal_arguments.arguments.after
			loop
				-- Get each id from the id_list
				from
					l_feature_i.body.body.internal_arguments.arguments.item.id_list.start
				until
					l_feature_i.body.body.internal_arguments.arguments.item.id_list.after
				loop
					if pos = internal_argument_to_check then
						-- Found the argument we want to check!
						if attached {CLASS_TYPE_AS} l_feature_i.body.body.internal_arguments.arguments.item.type as type then
							-- Check it's type!
							if compare_generics then
								create start_position.default_create
								start_position.stage := 0
								start_position.pos := 1
								compare_generic_parameters(type, original_class_type, start_position)
								-- Keep searching in further ancestors to build the complete list of generics to substitute in the current internal argument.
								Result := false
							elseif not type.is_separate then
								-- Found it!
								Result := true
							end
						end
					end
					pos := pos +1
					l_feature_i.body.body.internal_arguments.arguments.item.id_list.forth
				end
				l_feature_i.body.body.internal_arguments.arguments.forth
			end
		end

feature {NONE} -- implementation for redeclaration


	compare_return_type: BOOLEAN
		-- Compare return types of the ancestor's version.
	return_type_separate: BOOLEAN
		-- Is the return type of the found feature separate?
		-- Used for redeclaration fix


	compare_internal_argument: BOOLEAN
		-- Compare internal arguments of the ancestor's version.
	internal_argument_to_check : INTEGER
		-- Separate argument to check in the parents
	internal_argument_nseparate: BOOLEAN
		-- Is the internal argument of the found feature non separate?
		-- Used for redeclaration fix

	compare_generics: BOOLEAN
		-- Ccmpare generics of the ancestor's version.
	generic_parameters_to_substitute: LINKED_LIST[TUPLE[INTEGER,INTEGER]]
		-- The generic parameters to substitute
	original_class_type: TYPE_AS
		-- Class type to check redeclared features with.
;note
	copyright:	"Copyright (c) 1984-2010, Chair of Software Engineering"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
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
			ETH Zurich
			Chair of Software Engineering
			Website http://se.inf.ethz.ch/
		]"

end -- class SCOOP_PROXY_ASSIGN_FINDER
