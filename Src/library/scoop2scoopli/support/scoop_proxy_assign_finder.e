indexing
	description: "Summary description for {SCOOP_PROXY_ASSIGN_FINDER}."
	author: ""
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

	has_parents_feature_with_assigner (an_original_name, an_original_alias_name: STRING; a_base_class: CLASS_C): BOOLEAN is
			-- Returns true if some ancestors have a feature with
			-- name `an_original_feature_name' and an assigner.
		local
			l_result: TUPLE [found: BOOLEAN; assigner: STRING]
		do
			l_result := has_feature (an_original_name, an_original_alias_name, a_base_class, false, false)
			Result := l_result.found
		end

	has_current_or_parents_feature_with_assigner (an_original_name, an_original_alias_name: STRING; a_parent_class: CLASS_C): BOOLEAN is
			-- Returns true if some ancestors have a feature with
			-- name `an_original_feature_name' and an assigner.
		local
			l_result: TUPLE [found: BOOLEAN; assigner: STRING]
		do
			l_result := has_feature (an_original_name, an_original_alias_name, a_parent_class, true, false)
			Result := l_result.found
		end

	is_first_parent_feature_deferred (an_original_name, an_original_alias_name: STRING; a_base_class: CLASS_C): BOOLEAN is
			-- Returns true if the first inherited parent feature of
			-- `an_original_feature_name' is deferred
		do
			Result := is_first_feature_deferred (an_original_name, an_original_alias_name, a_base_class, false)
		end

	get_inherited_assigner_name (an_original_name, an_original_alias_name: STRING; a_base_class: CLASS_C): STRING is
			-- Returns the inherited assigner name
		local
			l_result: TUPLE [found: BOOLEAN; assigner: STRING]
		do
			l_result := has_feature (an_original_name, an_original_alias_name, a_base_class, false, true)
			Result := l_result.assigner
		end


feature {NONE} -- Implementation

	has_feature (an_original_name, an_original_alias_name: STRING; a_class_c: CLASS_C; is_check_base_class, track_assigner: BOOLEAN): TUPLE [found: BOOLEAN; assigner: STRING] is
			-- Returns true if (the current parent class or) some ancestors have
			-- a feature with name `an_original_feature_name' and an assigner.
			-- if `is_check_base_class' then check also the current class
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
					if l_feature_i.written_in = a_class_c.class_id
						-- test only features in current processed class,
						-- otherwise we dont get the renaming					
						and then l_feature_i.assigner_name /= Void then

						l_result.found := true
						l_result.assigner := l_feature_i.assigner_name
					end
				end
			end

			if not l_result.found then
				-- get any renamings of `an_original_feature' of all parents
				create l_assign_visitor
				l_parent_renamings := l_assign_visitor.get_renamings (an_original_name, an_original_alias_name, a_class_c, true)
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
							l_skip_current_parent := true
						end
						j := j + 1
					end
				end

				if not l_skip_current_parent then

					-- check parents (recursive call - therefore check also current class)
					if l_rename_str.is_equal (an_original_alias_name) then
						l_tmp_result := has_feature (an_original_name, an_original_alias_name, l_class_c, true, track_assigner)
					else
						l_tmp_result := has_feature (l_rename_str, l_rename_str, l_class_c, true, track_assigner)
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

--	has_parent_feature_with_assigner_p (an_original_feature_name: STRING; a_class_c: CLASS_C; is_check_base_class: BOOLEAN): BOOLEAN is
--			-- Returns true if (the current parent class or) some ancestors have
--			-- a feature with name `an_original_feature_name' as assigner.
--			-- if `is_check_base_class' then check also the current class
--		local
--			l_feature_table: FEATURE_TABLE
--			l_skip_current_parent: BOOLEAN
--			i, j, nb, nbj: INTEGER
--			l_rename_str, l_assigner_str: STRING
--			l_class_c: CLASS_C
--			l_feature_i: FEATURE_I
--			l_assign_visitor: SCOOP_PROXY_ASSIGN_VISITOR
--			l_result, l_tmp_result: TUPLE [found: BOOLEAN; assigner: STRING]
--			l_tuple: TUPLE [parent_name: STRING; old_feature_name, new_feature_name: STRING]
--			l_parent_renamings, l_old_parent_renamings: LINKED_LIST [TUPLE [parent_name: STRING; old_feature_name, new_feature_name: STRING]]
--		do
--			create l_result

--			if is_check_base_class then
--				-- check current class
--				l_feature_table := a_class_c.feature_table
--				from
--					l_feature_table.start
--				until
--					l_feature_table.after
--				loop
--					l_feature_i := l_feature_table.item_for_iteration

--					if l_feature_i.assigner_name /= Void and then
--						l_feature_i.assigner_name.is_equal (an_original_feature_name) then

--						Result := true
--					end
--				end
--			end

--			if not Result then
--				-- get any renamings of `an_original_feature' of all parents
--				create l_assign_visitor
--				l_parent_renamings := l_assign_visitor.get_renamings (an_original_feature_name, a_class_c, true)
--			end

--			-- check parents of this parent class
--			from
--				i := 1
--				nb := a_class_c.parents_classes.count
--			until
--				i > nb or Result
--			loop
--				l_class_c := a_class_c.parents_classes.i_th (i)
--				l_skip_current_parent := false

--				-- get rename of current assigner
--				l_rename_str := an_original_feature_name
--				from
--					j := 1
--					nbj := l_parent_renamings.count
--				until
--					j > nbj
--				loop
--					l_tuple := l_parent_renamings.i_th (j)
--					if l_tuple.parent_name.is_equal (l_class_c.name_in_upper)
--						and then l_tuple.new_feature_name.is_equal (an_original_feature_name) then

--						l_rename_str := l_tuple.old_feature_name
--					end
--					j := j + 1
--				end

--				-- check also: is feature f newly defined? case rename f as g,
--				-- but no feature is renamed from x to f. In this case f
--				-- is new feature - do not track it further in the parents.
--				-- set `l_skip_current_parent'
--				if l_rename_str.is_equal (an_original_feature_name) then
--					-- we do not have rename 'g as f' statement for current feature f.

--					l_old_parent_renamings := l_assign_visitor.get_renamings (an_original_feature_name, a_class_c, false)

--					-- test if there is a rename statement with 'f as x'
--					-- in this case the current f would not have a parent version.
--					from
--						j := 1
--						nbj := l_old_parent_renamings.count
--					until
--						j > nbj
--					loop
--						l_tuple := l_old_parent_renamings.i_th (j)
--						if l_tuple.parent_name.is_equal (l_class_c.name_in_upper)
--							and then l_tuple.old_feature_name.is_equal (an_original_feature_name) then

--							-- there is a rename statement 'f as x'. therefore we skip the current parent.
--							l_skip_current_parent := true
--						end
--						j := j + 1
--					end

--				end

--				if not l_skip_current_parent then
--					-- check parents (recursive call - therefore check also current class)
--					l_tmp_result := has_feature (l_rename_str, l_class_c, true, track_assigner)
--					l_result.found :=  l_result.found or l_tmp_result.found
--				end
--				i := i + 1
--			end


--		end

	is_first_feature_deferred (an_original_name, an_original_alias_name: STRING; a_class_c: CLASS_C; is_check_a_class_a: BOOLEAN): BOOLEAN is
			-- Returns `true' if the first inherited parent feature of
			-- `an_original_feature_name' is deferred
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
						Result := true
					end
				elseif not a_class_c.is_deferred then
					l_abort := true
				end
			end

			-- do not go further if class is already effective
			if not l_abort then
				-- get any renamings of `an_original_feature' of all parents
				create l_assign_visitor
				l_parent_renamings := l_assign_visitor.get_renamings (an_original_name, an_original_alias_name, a_class_c, true)

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
						Result := Result or is_first_feature_deferred (an_original_name, an_original_alias_name, l_class_c, true)
					else
						-- feature name has been renamed -> check only renamed name
						Result := Result or is_first_feature_deferred (l_rename_str, l_rename_str, l_class_c, true)
					end

					i := i + 1
				end
			end
		end

end
