note
	description: "[
					Roundtrip visitor to create enclosing routine in SCOOP client class.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_FEATURE_ER_VISITOR

inherit
	SCOOP_CLIENT_FEATURE_VISITOR
		redefine
			process_body_as,
			process_precursor_as,
			process_ensure_as,
			process_ensure_then_as,
			process_access_feat_as,
			process_access_assert_as,
			process_static_access_as,
			process_result_as,
			process_binary_as
		--	process_type_dec_as
		end

	SHARED_ERROR_HANDLER
		export
			{NONE} all
		end

create
	make

feature -- Access

	process_feature_body (l_as: BODY_AS; l_fo: SCOOP_CLIENT_FEATURE_OBJECT) is
			-- Process `l_as': the locking requester to the original feature.
		require
			l_fo_not_void: l_fo /= Void
			l_fo_preconditions_not_void: l_fo.preconditions /= Void
			l_fo_postconditions_not_void: l_fo.postconditions /= Void
		do
			fo := l_fo

			-- print feature name
			context.add_string ("%N%N%T" + fo.feature_name + "_scoop_separate_")
			context.add_string (class_c.name.as_lower + "_enclosing_routine ")

			-- process body
			last_index := l_as.first_token (match_list).index
			safe_process (l_as)
		end

feature {NONE} -- Node implementation

	process_body_as (l_as: BODY_AS) is
		local
			c_as: CONSTANT_AS
			l_assign_finder: SCOOP_PROXY_ASSIGN_FINDER
			feature_name: FEATURE_NAME
		do
--			-- Initialise `internal_arguments_to_substitute'
--			create internal_arguments_to_substitute.make (0)

			is_internal_arguments := True
			safe_process (l_as.internal_arguments)
			is_internal_arguments := False


			safe_process (l_as.colon_symbol (match_list))

--			if l_as.type /= void then

--			-- Fix for redeclarations if feature is query type:
--			-- If `l_as.type' is non separate but was separate in an ancestor version we need to make it separate
--			-- Only a potential problem when return type is `non-separate' and a `CLASS_TYPE_AS'
--			-- If `feature_name' is void we are in an attribute or constant

--				if attached {CLASS_TYPE_AS} l_as.type as typ and then not typ.is_separate then
--					create l_assign_finder

--					from
--						feature_as.feature_names.start
--					until
--						feature_as.feature_names.after
--					loop
--						feature_name := feature_as.feature_names.item
--						feature_as.feature_names.forth
--					end

--					if l_assign_finder.have_to_replace_return_type(feature_name, class_c, false) then
--						context.add_string ({SCOOP_SYSTEM_CONSTANTS}.scoop_proxy_class_prefix+typ.class_name.name)
--						result_substitution := true
--						seperate_result_signature := typ.class_name.name
--					end
--				end
--			end
--			if not result_substitution then
--				-- Nothing was done -> process normally
--				safe_process (l_as.type)
--			else
--				last_index := l_as.type.last_token (match_list).index
--			end

			safe_process (l_as.type)
			safe_process (l_as.assign_keyword (match_list))
			safe_process (l_as.assigner)
			safe_process (l_as.is_keyword (match_list))

			c_as ?= l_as.content
			if c_as /= Void then
				l_as.content.process (Current)
				safe_process (l_as.indexing_clause)
			else
				safe_process (l_as.indexing_clause)

					-- add comment
				context.add_string ("%N%T%T%T-- Wrapper for enclosing routine `" + fo.feature_name.as_lower + "'.")

					-- process body (routine_as)
				safe_process (l_as.content)

			end

--			-- Wipe out `internal_arguments_to_substitute'
--			internal_arguments_to_substitute.wipe_out
		end

	process_precursor_as (l_as: PRECURSOR_AS) is
		local
			l_parent: STRING
		do
			last_index := l_as.first_token (match_list).index - 1

				-- print normal call to inherited feature
			context.add_string ("%N%T%T%T" + fo.feature_name + "_scoop_separate_")

			if l_as.parent_base_class /= Void then
				create l_parent.make_from_string (l_as.parent_base_class.class_name.name.as_lower)
				context.add_string (l_parent + "_enclosing_routine ")
			else
					-- get name of parent base class		
				l_parent := precursor_parent (fo.feature_name)
				if l_parent /= Void then
					context.add_string (l_parent.as_lower + "_enclosing_routine ")
				else
					error_handler.insert_error (create {INTERNAL_ERROR}.make (
							"In {SCOOP_CLIENT_FEATURE_ER_VISITOR}.process_precursor_as could%N%
							%not find a valid parent for the Precursor statement."))
				end
			end
			if l_as.internal_parameters /= void then
				last_index := l_as.internal_parameters.first_token (match_list).index - 1
			end

			update_current_level_with_call (l_as)
			process_internal_parameters(l_as.internal_parameters)
			last_index := l_as.last_token (match_list).index
		end

	process_ensure_then_as (l_as: ENSURE_THEN_AS) is
		local
			i: INTEGER
			a_post_condition: TAGGED_AS
		do
			process_ensure_as(l_as)
		end

	process_ensure_as (l_as: ENSURE_AS) is
		local
			i: INTEGER
			a_post_condition: TAGGED_AS
		do
			if attached {ENSURE_THEN_AS} l_as then
				context.add_string ("%N%T%Tensure then")
			else
				context.add_string ("%N%T%Tensure")
			end
			processing_assertions := True
				-- separate argument increased postcondition counter call
			if fo.arguments.has_separate_arguments and then fo.arguments.has_postcondition_occurrence then
				from
					i := 1
				until
					i > fo.arguments.separate_arguments.count
				loop
					context.add_string ("%N%T%T%T")
					context.add_string (fo.arguments.get_i_th_postcondition_argument_name (i))
					context.add_string (".increased_postcondition_counter (")
					context.add_string (fo.arguments.get_i_th_postcondition_argument_count (i).out)
					context.add_string (")")
					i := i + 1
				end
			end

				-- print immediate postcondition clauses.
			from
				i := 1
			until
				i > fo.postconditions.immediate_postconditions.count
			loop
				a_post_condition := fo.postconditions.immediate_postconditions.i_th (i).tagged_as
				last_index := a_post_condition.first_token (match_list).index - 1
				context.add_string ("%N%T%T%T")
				safe_process (a_post_condition)
				i := i + 1
			end

			if l_as /= Void then
				last_index := l_as.last_token (match_list).index
			end
			processing_assertions := False
		end

feature {NONE} -- Adding .implementation_ for precondition processing.

	process_binary_as (l_as: BINARY_AS)
		do
			if processing_assertions then
				safe_process (l_as.left)
				safe_process (l_as.operator (match_list))
				safe_process (l_as.right)
			else
				Precursor (l_as)
			end
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			if processing_assertions then
				safe_process (l_as.feature_name)

				update_current_level_with_call (l_as)

				if current_level.type.is_separate then
					context.add_string (".implementation_")
					set_current_level_is_separate (False)
				end

				process_internal_parameters(l_as.internal_parameters)
			else
				Precursor (l_as)
			end
		end

	process_access_assert_as (l_as: ACCESS_ASSERT_AS)
		local
			add_implementation_: BOOLEAN
		do

			if processing_assertions then
				add_implementation_ := True

				safe_process (l_as.feature_name)

				update_current_level_with_call (l_as)

--				if internal_arguments_to_substitute /= void then
--					from
--						internal_arguments_to_substitute.start
--					until
--						internal_arguments_to_substitute.after
--					loop
--						if internal_arguments_to_substitute.item.is_equal (l_as.feature_name.name_id) then
--							-- Is an internal argument we changed the type from:
--							-- No need to add `.implementation_'
--							add_implementation_ := False
--						end
--						internal_arguments_to_substitute.forth
--					end
--				end

				if current_level.type.is_separate then
					if add_implementation_ then
						context.add_string (".implementation_")
					end
					set_current_level_is_separate (False)
				end

				process_internal_parameters(l_as.internal_parameters)
			else
				Precursor (l_as)
			end
		end

	process_static_access_as (l_as: STATIC_ACCESS_AS)
		do
			if processing_assertions then
				safe_process (l_as.feature_keyword (match_list))
				safe_process (l_as.class_type)
				safe_process (l_as.dot_symbol (match_list))
				safe_process (l_as.feature_name)

				update_current_level_with_call (l_as)

				if current_level.type.is_separate then
					context.add_string (".implementation_")
					set_current_level_is_separate (False)
				end

				-- process internal parameters and add current if target is of separate type.
				process_internal_parameters(l_as.internal_parameters)
			else
				Precursor (l_as)
			end
		end

	process_result_as (l_as: RESULT_AS)
		do
			Precursor (l_as)
			if processing_assertions and current_level.type.is_separate then
				context.add_string (".implementation_")
				set_current_level_is_separate (False)
			end
		end

feature {NONE} -- Node implementation

	precursor_parent (a_feature_name: STRING): STRING is
			-- returns the parent of a precursor feature.
			-- traverses the redefining list of the parents.
		local
			i, j: INTEGER
		do
			from
				i := 1
			until
				i > parsed_class.parents.count
			loop
				if parsed_class.parents.i_th (i).redefining /= Void then
					from
						j := 1
					until
						j > parsed_class.parents.i_th (i).redefining.count
					loop
						if parsed_class.parents.i_th (i).redefining.i_th (i).internal_name.name.is_equal (a_feature_name) then
							Result := parsed_class.parents.i_th (i).type.class_name.name
						end
						j := j + 1
					end

				end
				i := i + 1
			end
		end
--feature -- Internal Argument Generic Substitution

--	process_type_dec_as (l_as: TYPE_DEC_AS)

--		do
--			if is_internal_arguments and then attached {CLASS_TYPE_AS} l_as.type as typ then
--				-- We are in Internal Arguments (not random type dec)
--					single_process_identifier_list (l_as.id_list,typ)
--					last_index := l_as.last_token (match_list).index
--			else
--				Precursor (l_as)
--			end
--		end
--	single_process_identifier_list (l_as: IDENTIFIER_LIST; l_as_type: CLASS_TYPE_AS)
--			-- Process `l_as'
--		local
--			pos,x,j,i, l_count: INTEGER
--			l_index: INTEGER
--			l_ids: CONSTRUCT_LIST [INTEGER]
--			l_id_as: ID_AS
--			l_leaf: LEAF_AS
--			type_dec: TYPE_DEC_AS
--			l_generics_visitor: SCOOP_GENERICS_VISITOR
--			generics_to_substitute: LINKED_LIST[TUPLE[INTEGER,INTEGER]]
--			l_assign_finder: SCOOP_PROXY_ASSIGN_FINDER
--			add_scoop_separate__: BOOLEAN
--			interal_argument_to_substitute: TUPLE[pos:INTEGER;type:TYPE_AS]
--		do
--			if l_as /= Void then
--				l_ids := l_as.id_list
--				if l_ids /= Void and l_ids.count > 0 then

--					-- Get the position of the first argument of the list in the feature
--					x := 1
--					from
--						j := 1
--					until
--						j > feature_as.body.internal_arguments.arguments.count
--					loop
--						type_dec:= feature_as.body.internal_arguments.arguments.i_th (j)
--						from
--							type_dec.id_list.id_list.start
--						until
--							type_dec.id_list.id_list.after
--						loop
--							if type_dec.id_list.id_list.item.is_equal (l_ids.i_th (1)) then
--								pos := x
--							end
--							x := x +1
--							type_dec.id_list.id_list.forth
--						end
--						j := j +1
--					end

--					from
--						l_ids.start
--						i := 1
--							-- Temporary/reused objects to print identifiers.
--						create l_id_as.initialize_from_id (1)
--						if l_as.separator_list /= Void then
--							l_count := l_as.separator_list.count
--						end
--					until
--						l_ids.after
--					loop
--						l_index := l_ids.item
--						if match_list.valid_index (l_index) then
--							l_leaf := match_list.i_th (l_index)
--								-- Note that we do not set the `name_id' for `l_id_as' since it will require
--								-- updating the NAMES_HEAP and we do not want to do that. It is assumed in roundtrip
--								-- mode that the text is never obtained from the node itself but from the `text' queries.
--							l_id_as.set_position (l_leaf.line, l_leaf.column, l_leaf.position, l_leaf.location_count)
--							l_id_as.set_index (l_index)
--							safe_process (l_id_as)

--							context.add_string (":")
--							last_index := l_as_type.first_token (match_list).index
--							-- Check if we need to substitute the internal argument
--							add_scoop_separate__ := False
--							if l_as_type.is_separate then
--								add_scoop_separate__ := True
----								if need_internal_argument_substitution(feature_as.feature_name, class_c, pos) then
----									feature_object.internal_arguments_to_substitute.put_front (l_ids.item)
----									substitute_internal_argument := True
----									add_scoop_separate__ := False

----								end
--							end
--							if add_scoop_separate__ then
--								context.add_string ({SCOOP_SYSTEM_CONSTANTS}.scoop_proxy_class_prefix)
--							end
--							context.add_string (l_as_type.class_name.name)
--							if attached {GENERIC_CLASS_TYPE_AS} l_as_type as gen_typ then
--								create l_assign_finder
--								l_generics_visitor := scoop_visitor_factory.new_generics_visitor (context)
--								create interal_argument_to_substitute.default_create
--								interal_argument_to_substitute.pos := pos
--								interal_argument_to_substitute.type := gen_typ
--								generics_to_substitute := l_assign_finder.generic_parameters_to_replace (feature_object.feature_name_object, class_c, False, interal_argument_to_substitute, False)
--								if not generics_to_substitute.is_empty then
--									l_generics_visitor.set_generics_to_substitute (generics_to_substitute)
--								end
--								l_generics_visitor.process_internal_generics (gen_typ.generics, True, True)
--							end
--						end
--						if i <= l_count then
--							context.add_string ("; ")
--							i := i + 1
--						end
--						pos := pos +1
--						l_ids.forth
--					end
--				end
--			end
--		end


feature {NONE} -- Implementation

	fo: SCOOP_CLIENT_FEATURE_OBJECT
			-- feature object of current processed feature.

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

end -- class SCOOP_CLIENT_FEATURE_ER_VISITOR
