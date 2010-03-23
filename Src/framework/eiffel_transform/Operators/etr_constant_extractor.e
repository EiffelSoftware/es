note
	description: "Operator for the extract constant-refactoring"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_CONSTANT_EXTRACTOR
inherit
	SHARED_SERVER
	ETR_SHARED_ERROR_HANDLER
	ETR_SHARED_LOGGER
	ETR_SHARED_TOOLS
	ETR_SHARED_BASIC_OPERATORS
	ETR_SHARED_PARSERS

feature {NONE} -- Implementation

	constant_finder: ETR_CONSTANT_FINDER
			-- Visitor to find constants
		once
			create Result
		end

	process_descendants (a_class: CLASS_C)
			-- Process descendants of `a_class'
		local
			l_descendants: LIST[CLASS_C]
		do
			l_descendants := a_class.direct_descendants

			from
				l_descendants.start
			until
				l_descendants.after or error_handler.has_errors
			loop
				process_class (l_descendants.item, -1)
				if not l_descendants.item.direct_descendants.is_empty then
					process_descendants (l_descendants.item)
				end

				l_descendants.forth
			end
		end

	process_ancestors (a_class: CLASS_C; level: INTEGER)
			-- Process ancestors of `a_class'
		local
			l_ancestors: LIST[CLASS_C]
		do
			l_ancestors := a_class.parents_classes

			from
				l_ancestors.start
			until
				l_ancestors.after or error_handler.has_errors
			loop
				process_class (l_ancestors.item, level)
				if not l_ancestors.item.parents_classes.is_empty then
					process_ancestors (l_ancestors.item, level+1)
				end

				l_ancestors.forth
			end
		end

	process_class (a_class: CLASS_C; level: INTEGER)
			-- Process a_class
		local
			l_found: TUPLE[occ_class: CLASS_C; locs: LIST[AST_PATH]]
		do
			constant_finder.find_constants (constant, a_class.ast, void)

			if level=0 and constant_finder.found_constants.is_empty then
				error_handler.add_error (Current, "process_class", "Constant not found in specified class.")
			elseif not constant_finder.found_constants.is_empty then
				-- check if already processed
				if not found_classes.has (a_class.name) then
					l_found := [a_class, constant_finder.found_constants]
					found_constants.extend (l_found)
					found_classes.extend (a_class.name)
				end

				if level>highest_level then
					highest_level := level
					declaring_class := a_class
				elseif level=highest_level and declaring_class.class_id /= a_class.class_id then
					error_handler.add_error (Current, "process_class", "Can't decide in which ancestor to declare the constant%NUse the constant extraction in the desired ancestor.")
				end
			end
		end

	process_feature (a_written_class: CLASS_C; a_feature_name: STRING)
			-- Process `a_feature_name' in `a_written_class'
		local
			l_found: TUPLE[occ_class: CLASS_C; locs: LIST[AST_PATH]]
		do
			constant_finder.find_constants (constant, a_written_class.ast, a_feature_name)

			if constant_finder.found_constants.is_empty then
				error_handler.add_error (Current, "process_feature", "Constant not found in specified feature or feature not found in class.")
			else
				l_found := [a_written_class, constant_finder.found_constants]
				found_constants.extend (l_found)

				declaring_class := a_written_class
			end
		end

	found_classes: LINKED_LIST[STRING]

	highest_level: INTEGER
			-- Level in inheritance hierarchy
			-- 0= originating class
			-- >0 ancestors of it
			-- -1 descendants

	constant: AST_EIFFEL
			-- The constant we're extracting	

	found_constants: LIST[TUPLE[occ_class: CLASS_C; locs: LIST[AST_PATH]]]
			-- Occurences of the constant found per class

	const_ast_to_type (a_ast: AST_EIFFEL): STRING
		do
			if attached {INTEGER_AS}a_ast then
				Result := "INTEGER"
			elseif attached {REAL_AS}a_ast then
				Result := "REAL"
			elseif attached {CHAR_AS}a_ast then
				Result := "CHARACTER"
			elseif attached {BOOL_AS}a_ast then
				Result := "BOOLEAN"
			elseif attached {STRING_AS}a_ast or attached {VERBATIM_STRING_AS}a_ast then
				Result := "STRING"
			elseif attached {BIT_CONST_AS}a_ast as b then
				Result := "BIT " + b.value.name.count.out
			end
		end

feature -- Access

	declaring_class: CLASS_C
			-- Class where the constant will be declared

	is_already_declared: BOOLEAN

	modifiers: LIST[TUPLE[occ_class: CLASS_C; mods: LIST[ETR_AST_MODIFICATION]]]

feature -- Operations

	extract_constant (a_constant: ETR_TRANSFORMABLE; a_contained_feature_name, a_constant_name: STRING; a_process_whole_cass, a_process_ancestors, a_process_descendants: BOOLEAN)
			-- Extracts `a_constant' while also processing ancestors/descendants
		require
			cons_non_void: a_constant /= void
			cons_valid: a_constant.is_valid
			context_valid: not a_constant.context.is_empty
			name_non_void: a_constant_name /= void and a_contained_feature_name /= void
		local
			l_earliest_occurence: CLASS_C
			l_source_class: CLASS_C
			l_source_feature: FEATURE_I
			l_parents: LIST[CLASS_C]
			l_class_mods: TUPLE[occ_class: CLASS_C; mods: LIST[ETR_AST_MODIFICATION]]
			l_mods: LINKED_LIST[ETR_AST_MODIFICATION]
			l_const_var: ETR_TRANSFORMABLE
			l_feat_clause: FEATURE_CLAUSE_AS
			l_clients: CLIENT_AS
			l_class_list: CLASS_LIST_AS
			l_feat_list: EIFFEL_LIST[FEATURE_AS]

			l_modifier: ETR_AST_MODIFIER
			l_log_str: STRING
			l_existing_feat: FEATURE_I
			l_constant_kind: STRING
			l_constant_type_as: TYPE_AS
			l_constant_type: TYPE_A
		do
			create {LINKED_LIST[TUPLE[occ_class: CLASS_C; locs: LIST[AST_PATH]]]}found_constants.make
			create {LINKED_LIST[TUPLE[occ_class: CLASS_C; mods: LIST[ETR_AST_MODIFICATION]]]}modifiers.make
			create found_classes.make
			found_classes.compare_objects
			constant := a_constant.target_node
			l_source_class := a_constant.context.class_context.written_class
			l_source_feature := l_source_class.feature_named (a_contained_feature_name)
			is_already_declared := false

			if l_source_feature = void then
				error_handler.add_error (Current, "extract_constant", "There is no feature named "+a_contained_feature_name+" in "+l_source_class.name_in_upper+".")
			end

			logger.log_info ("extract_constant starting. Name: "+a_constant_name+";Whole class: "+a_process_whole_cass.out+"; Ancestors: "+a_process_ancestors.out+"; Descendants: "+a_process_descendants.out)

			highest_level := -1

			if not error_handler.has_errors then
				if not a_process_whole_cass then
					process_feature (l_source_class, a_contained_feature_name)
				else
					if a_process_ancestors then
						process_ancestors (l_source_class, 1)
					end
					process_class (l_source_class, 0)
					if a_process_descendants then
						process_descendants (l_source_class)
					end
				end
			end

			if not error_handler.has_errors then
				-- Make sure all class inherit in some way from the class we declare in
				from
					found_constants.start
				until
					found_constants.after or error_handler.has_errors
				loop
					if not found_constants.item.occ_class.conform_to (declaring_class) then
						error_handler.add_error (Current, "extract_constant",
							"Constant will be declared in " + declaring_class.name_in_upper + " but " + found_constants.item.occ_class.name_in_upper +
							"does not inherit from it")
					end

					found_constants.forth
				end
			end

			if not error_handler.has_errors then
				-- construct a feature clause
				-- exported to NONE with the constant
				create l_class_list.make (1)
				l_class_list.extend (create {NONE_ID_AS}.make)

				create l_clients.initialize (l_class_list)
				l_constant_kind := const_ast_to_type (a_constant.target_node)
				parsing_helper.parse_type (l_constant_kind)
				l_constant_type_as := parsing_helper.parsed_type
				l_constant_type := type_checker.written_type_from_type_as (l_constant_type_as, l_source_class, l_source_feature)

				parsing_helper.parse_feature (a_constant_name+":"+l_constant_kind+" = "+a_constant.out)
				create l_feat_list.make (1)
				l_feat_list.extend (parsing_helper.parsed_feature)
				create l_feat_clause.initialize (l_clients, l_feat_list, create {KEYWORD_AS}.make_null, 0)

				l_const_var := (create {ETR_TRANSFORMABLE_FACTORY}).new_expr (a_constant_name, create {ETR_CONTEXT}.make_empty)

				logger.log_info ("Declaring class: "+declaring_class.name_in_upper)
				logger.log_info ("Occurrences:")
				from
					found_constants.start
				until
					found_constants.after
				loop
					l_log_str := found_constants.item.occ_class.name_in_upper+": "
					from
						create l_mods.make
						found_constants.item.locs.start
					until
						found_constants.item.locs.after
					loop
						l_log_str.append (found_constants.item.locs.item.as_string)

						l_mods.extend (	basic_operators.replace (found_constants.item.locs.item, l_const_var))

						found_constants.item.locs.forth

						if not found_constants.item.locs.after then
							l_log_str.append (", ")
						end
					end
					if found_constants.item.occ_class.class_id = declaring_class.class_id then
						-- add modifier for declaration
						l_existing_feat := declaring_class.feature_named (a_constant_name)

						if l_existing_feat /= void then
							-- check if there already is a constant with the same name
							if attached {CONSTANT_I}l_existing_feat as c then
								-- check if type matches
								if c.type.same_type(l_constant_type) and then c.type.is_equivalent (l_constant_type) then
									-- check if value matches (string comparison)
									if c.value.string_value.is_equal (a_constant.out) then
										is_already_declared := true
									else
										error_handler.add_error (Current, "extract_constant", "There already is a feature named "+a_constant_name+" in "+declaring_class.name_in_upper+ " but it has a different value (string comparison).")
									end
								else
									error_handler.add_error (Current, "extract_constant", "There already is a feature named "+a_constant_name+" in "+declaring_class.name_in_upper+ " but it's of a different type.")
								end
							else
								error_handler.add_error (Current, "extract_constant", "There already is a feature named "+a_constant_name+" in "+declaring_class.name_in_upper+ " but it's not a constant.")
							end
						else
							-- insert new feature clause to feature-clause list (1.8)
							l_mods.extend (basic_operators.list_append (create {AST_PATH}.make_from_string("1.8"), create {ETR_TRANSFORMABLE}.make(l_feat_clause, create {ETR_CONTEXT}.make_empty, false)))
						end
					end

					modifiers.extend ([found_constants.item.occ_class,l_mods])

					logger.log_info (l_log_str)

					found_constants.forth
				end
			end

			logger.log_info ("extract_constant complete")
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
