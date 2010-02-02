note
	description: "[
					Roundtrip visitor to process parent node in SCOOP client class.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_PARENT_VISITOR

inherit
	SCOOP_PARENT_VISITOR
		redefine
			process_internal_conforming_parents,
			process_parent_as,
			process_id_as,
			process_infix_prefix_as,
			process_rename_as

		end

	SCOOP_BASIC_TYPE
		export
			{NONE} all
		end

	SCOOP_WORKBENCH
		-- Remove `SCOOP_WORKBENCH' with EiffelStudio 6.4
		export
			{NONE} all
		end

create
	make_with_context

feature -- Access

	process_internal_conforming_parents(l_as: PARENT_LIST_AS) is
			-- Process `l_as'.
		do
			if l_as /= Void then
				Precursor (l_as)
			else
				if not is_special_class (parsed_class.class_name.name.as_upper) then
						-- inherit from 'SCOOP_SEPARATE_CLIENT'.
					context.add_string ("%N%Ninherit%N%TSCOOP_SEPARATE_CLIENT")
					context.add_string ("%N%T%Tredefine proxy_ end") -- added by damienm
				end
			end
		end

	compute_ancestors_names(l_as: CLASS_AS; overwrites: HASH_TABLE[STRING,STRING]): LINKED_LIST[STRING] is
			-- gets all ancestors of a class, without duplicates
			require
				has_class_as: l_as /= void
			local
				l_ancestors: LINKED_LIST[STRING]
				l_parent: CLASS_AS
				l_string: STRING
				i: INTEGER
				formal_type: STRING
				n_overwrites: HASH_TABLE[STRING,STRING]
			do
				if result = void then
				  create result.make
				end
				create	n_overwrites.make (0)

				if l_as.internal_conforming_parents /= Void and not l_as.internal_conforming_parents.is_empty then
					from
						l_as.internal_conforming_parents.start
					until
						l_as.internal_conforming_parents.after
					loop

						-- current ancestor	
						l_parent := get_class_as_by_name (l_as.internal_conforming_parents.item.type.class_name.name)

						-- generate generics for ancestors from current class
						l_string := ""
						l_string.append_string (l_as.internal_conforming_parents.item.type.class_name.name)
						if l_as.internal_conforming_parents.item.type.generics /= Void then
							l_string.append_string ("[")
							from
								i := 1
								l_as.internal_conforming_parents.item.type.generics.start
							until
								l_as.internal_conforming_parents.item.type.generics.after
							loop

								-- get formal generic type from the ancestor, only interesting if it is of type `FORMAL_AS'
								formal_type  := l_parent.generics.i_th (i).name.name

								-- print generics and store them for potention overwrites
								if {type: CLASS_TYPE_AS} l_as.internal_conforming_parents.item.type.generics.item then
									l_string.append_string (type.class_name.name)
--									n_overwrites.force (formal_type, type.class_name.name)
									n_overwrites.force (type.class_name.name,formal_type)
								elseif {type: FORMAL_AS} l_as.internal_conforming_parents.item.type.generics.item then
									if overwrites.has_key (type.name.name) then
										l_string.append_string (overwrites.item (type.name.name))

										-- propagate the change
--										n_overwrites.force (formal_type, overwrites.key (type.name.name))
										n_overwrites.force (overwrites.item (type.name.name),formal_type)
									else
										l_string.append_string (type.name.name)
--										n_overwrites.force (formal_type, type.name.name)
										n_overwrites.force (type.name.name,formal_type)
									end
								end

								if not l_as.internal_conforming_parents.item.type.generics.islast then
									l_string.append_string (",")
								end
								i := i+1
								l_as.internal_conforming_parents.item.type.generics.forth

							end
							l_string.append_string ("]")
						end

						-- go up one layer of the hierarchy
						l_ancestors := compute_ancestors_names (l_parent, n_overwrites)

						-- merge lists (eliminating duplicates)
						if not l_ancestors.is_empty then
							from
								l_ancestors.start
							until
								l_ancestors.after
							loop
								if not has_string (result, l_ancestors.item) then
									result.extend (l_ancestors.item)
								end
								l_ancestors.forth
							end
						end

						-- put current ancestor on the list if he is not in the list yet
						if not has_string (result, l_string) then
							result.extend (l_string)
						end
						l_as.internal_conforming_parents.forth
					end
				end

			end

--	get_class_as(name: STRING): CLASS_AS is
--			-- gets class_as from a class name
--			local
--				a_class : CLASS_C
--				i: INTEGER
--			do
--				from
--					i := 1
--				until
--					i > system.classes.sorted_classes.count
--				loop
--					a_class := system.classes.sorted_classes.item (i)
--					if a_class /= Void then
--						if a_class.name_in_upper.is_equal (name.as_upper) then
--							Result := a_class.ast
--						end
--					end
--					i := i + 1
--				end
--			end

feature {NONE} -- Visitor implementation

	process_parent_as (l_as: PARENT_AS) is
		do
			last_index := l_as.type.first_token (match_list).index - 1
			current_parent_c := get_parent_class_c_by_name (l_as.type.class_name.name)
--			if l_as.type.class_name.name.as_upper.is_equal ("ANY") then

--					-- Replace `ANY' with `SCOOP_SEPARATE_CLIENT'.
--				context.add_string ("SCOOP_SEPARATE_CLIENT")
--				-- skipe the rest of the parent clause
--				last_index := l_as.last_token (match_list).index
--			else
				context.add_string ("%N%T")

				if l_as.type.class_name.name.as_upper.is_equal ("ANY") then
					context.add_string ("SCOOP_SEPARATE_CLIENT")
					last_index := l_as.type.class_name.index
				else
					safe_process (l_as.type)
				end

				safe_process (l_as.internal_renaming)
				safe_process (l_as.internal_exports)
				safe_process (l_as.internal_undefining)
				if l_as.internal_redefining /= Void then
					safe_process (l_as.internal_redefining)
					insert_infix_prefix_redefine_list (false)
				else
					insert_infix_prefix_redefine_list (true)
				end


				safe_process (l_as.internal_selecting)

--				if l_as.end_keyword_index > 0 then
					context.add_string ("%N%T%T")
--				end
				if l_as.end_keyword (match_list) /= void then
					safe_process (l_as.end_keyword (match_list))
				else
					-- always needs an end since the input from proxy_
					context.add_string ("end")
				end

--			end
		end

	process_id_as (l_as: ID_AS) is
			-- Process `l_as'.
		do
			process_leading_leaves (l_as.index)

			if not is_special_class (l_as.name) then
				if is_process_export_clause then
					-- print client and proxy class name when printing export clause
					context.add_string (" SCOOP_SEPARATE__")
					put_string (l_as)
					context.add_string (", ")
				end
			end

			-- print id
			put_string (l_as)
			last_index := l_as.index
		end

	process_infix_prefix_as (l_as: INFIX_PREFIX_AS) is
			-- Remove this feature with EiffelStuidio 6.4
			-- It creates for each infix / prefix feature name a list
			-- containing the infix and non-infix notation
		local
			l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
		do
			if not is_rename_clause then
				-- creates comma separated a list of non-infix and infix feature name
				l_feature_name_visitor := scoop_visitor_factory.new_feature_name_visitor
				last_index := l_as.first_token (match_list).index - 1

				-- process INFIX_PREFIX_AS node
				if l_as.is_frozen and then l_as.frozen_keyword.index > 0 then
					safe_process (l_as.frozen_keyword)
				else
					process_leading_leaves (l_as.infix_prefix_keyword.index)
				end
				l_feature_name_visitor.process_declaration_infix_prefix (l_as)
				context.add_string (" " + l_feature_name_visitor.get_feature_name + ", ")
				last_index := l_as.alias_name.index
			end

			Precursor (l_as)
		end

	process_rename_as (l_as: RENAME_AS) is
			-- Remove this feature with EiffelStudio 6.4

			-- Rename 'infx x as non-infix x:
			-- ------------------------------
			-- It creates from a renamed feature with infix / prefix
			-- feature name two statements: one undefine statment
			-- with infix / prefix and one rename statement with
			-- non-infix / non-prefix notation.

			-- Rename 'non-infix x' as 'infix x':
			-- ---------------------------------
			-- we create here only a 'non-infix x
			-- as infix x' renaming
		local
			l_str, l_original_name: STRING
			l_wrapper_name, l_wrapper_feature: STRING
			l_old_name, l_new_name: INFIX_PREFIX_AS
			l_feature_i: FEATURE_I
			l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
		do
			l_old_name ?= l_as.old_name

			-- flag current processing
			is_rename_clause := true

			if l_old_name /= Void then
				-- create first the undefine

				-- create feature name visitor
				l_feature_name_visitor := scoop_visitor_factory.new_feature_name_visitor

				-- create string
				create l_str.make_from_string ("%N%T%T%T")

				-- create first the infix / prefix version of the renaming
				-- get old name without alias
				l_feature_name_visitor.process_original_feature_name (l_as.old_name, true)
				l_original_name := l_feature_name_visitor.get_feature_name
				l_str.append (l_original_name)

				l_str.append (" as ")

				l_new_name ?= l_as.new_name
				if l_new_name /= Void then
					-- infix to infix -> create 2 rename statements

					-- get new name without alias
					l_feature_name_visitor.process_original_feature_name (l_as.new_name, false)
					l_str.append (l_feature_name_visitor.get_feature_name)

				else
					-- infix to non-infix -> create for original rename statement
					-- a new wrapper feature which links to the renamed feature

					-- get FEATURE_I node of current node
					l_feature_name_visitor.process_original_feature_name (l_as.old_name, true)
					l_feature_i := current_parent_c.feature_table.item (l_feature_name_visitor.get_feature_name)

					-- create a new feature name
					l_feature_name_visitor.process_feature_name (l_as.old_name, false)
					create l_wrapper_name.make_from_string(l_feature_name_visitor.get_feature_name)
					l_wrapper_name.append ("_" + class_c.name.as_lower)
					l_wrapper_name.append ("_separate_scoop_wrapper_")

					-- add the new created feature name to the rename statement
					l_str.append (l_wrapper_name)

					-- create now the new feature with the call to the new feature
					create l_wrapper_feature.make_from_string ("%N%N%T" + l_wrapper_name + " ")

					-- get internal argument and type
					if l_old_name.is_infix then
						-- infix -> create a new argument
						l_wrapper_feature.append ("(i: ")

						if l_feature_i.arguments.first.is_formal then
							l_wrapper_feature.append (class_c.generics.first.name.name)
						else
							l_wrapper_feature.append (l_feature_i.arguments.first.name)
						end

						l_wrapper_feature.append (")")
					end

					l_wrapper_feature.append (": ")

					-- set type
					if l_feature_i.type.is_formal then
						l_wrapper_feature.append (class_c.generics.first.name.name)
					elseif l_feature_i.type.is_like_current then
						l_wrapper_feature.append (current_parent_c.name.as_lower)
					else
						l_wrapper_feature.append (l_feature_i.type.name)
					end

					-- set is keyword
					l_wrapper_feature.append (" is")

					-- set comment
					l_wrapper_feature.append ("%N%T%T%T-- Feature wrapper for infix / prefix rename statements.")
					l_wrapper_feature.append ("%N%T%T%T-- Hack for EiffelStudio 6.3")

					-- add do keyword
					l_wrapper_feature.append ("%N%T%Tdo")

					-- add feature call:
					l_wrapper_feature.append ("%N%T%T%TResult := ")
					-- get new name without alias
					l_feature_name_visitor.process_original_feature_name (l_as.new_name, false)
					l_wrapper_feature.append (l_feature_name_visitor.get_feature_name + " ")

					-- add internal arguments as actual arguments
					if l_old_name.is_infix then
						l_wrapper_feature.append ("(i)")
					end

					-- add end keyword
					l_wrapper_feature.append ("%N%T%Tend")

					-- save feature somewhere to add it somewhere
					scoop_workbench_objects.extend_proxy_infix_prefix_wrappers (l_wrapper_feature)

					-- add new feature to the redefine list
					if infix_prefix_redefine_list = Void then
						create infix_prefix_redefine_list.make
					end
					infix_prefix_redefine_list.extend (l_wrapper_name)
				end

				l_str.append (",")
				context.add_string (l_str)
			end

			-- process it again with non-infix notation
			Precursor (l_as)

			-- unflag current processing
			is_rename_clause := false
		end

	insert_infix_prefix_redefine_list (is_insert_with_rename_keyword: BOOLEAN) is
			-- Inserts the elements from `infix_prefix_redefine_list'
			-- Remove this feature with EiffelStudio 6.4
		local
			i, nb: INTEGER
		do

			if is_insert_with_rename_keyword then
				context.add_string ("%N%T%Tredefine")
				-- No need to redefine proxy_ when class is deferred
				context.add_string ("%N%T%T%T proxy_")
			else
				-- No need to redefine proxy_ when class is deferred
				context.add_string (", proxy_")
			end


			if infix_prefix_redefine_list /= Void and then not infix_prefix_redefine_list.is_empty then

				context.add_string (", ")
				from
					i := 1
					nb := infix_prefix_redefine_list.count
				until
					i > nb
				loop
					-- add feature name
					context.add_string (infix_prefix_redefine_list.i_th (i))

					if i < nb then
						-- add comma
						context.add_string (", ")
					end

					i := i + 1
				end
				infix_prefix_redefine_list.wipe_out
			end
		end



feature {NONE} -- Implementation


	has_string(a_list: LINKED_LIST[STRING]; a_item: STRING): BOOLEAN is
		 --`a_item' in `a_list' already?
		do
			result := false
			from
				a_list.start
			until
				a_list.after
			loop
				if a_list.item.is_equal (a_item) then
					result := true
				end
				a_list.forth
			end
		end

--	n_overwrites,overwrites: HASH_TABLE[STRING,STRING]
--			-- Stores overwrites for generics
--			-- used by `compute_ancesotrs'


	is_rename_clause: BOOLEAN
			-- Indicates that the rename clause is processed
			-- Remove this attribute with EiffelStudio 6.4
			-- It is only used for getting a list of non-infix and infix
			-- / non-prefix and prefix notation for a infix / prefix
			-- feature name.

	infix_prefix_redefine_list: LINKED_LIST [STRING]
			-- Remove this list with EiffelStudio 6.4
			-- List of renamed infix / prefix feature names which has
			-- to be inserted in the undefine list

	current_parent_c: CLASS_C
			-- Remove this list with EiffelStudio 6.4

;note
	copyright:	"Copyright (c) 1984-2010, Eiffel Software"
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
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end -- class SCOOP_CLIENT_PARENT_VISITOR
