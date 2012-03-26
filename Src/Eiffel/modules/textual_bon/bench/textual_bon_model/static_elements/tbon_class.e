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
	make (a_class_as: CLASS_AS; a_text_formatter: like associated_text_formatter_decorator)
			-- Create a textual BON class.
		do
			associated_class := a_class_as
			associated_text_formatter_decorator := a_text_formatter

			create name.make_element (associated_text_formatter_decorator, associated_class_name)
			create {LINKED_LIST[TBON_CLASS_TYPE]} ancestors.make
			create {LINKED_LIST[TBON_FEATURE_CLAUSE]} feature_clauses.make
			create {LINKED_LIST[TBON_FORMAL_GENERIC]} type_parameters.make

			if associated_class.top_indexes /= Void then
				create indexing_clause.make_element (associated_text_formatter_decorator, associated_class_indices)
			end

			if associated_class.invariant_part /= Void then
				create class_invariant.make_element (associated_text_formatter_decorator, associated_class_invariant_assertion_list)
			end

			if associated_class.conforming_parents /= Void then
				extract_associated_class_ancestors
			end

			if associated_class.generics /= Void then
				extract_associated_class_type_parameters
			end
		end

feature -- Access

	ancestors: LIST[TBON_CLASS_TYPE]
			-- From which classes does this class inherit?

	associated_text_formatter_decorator: TEXT_FORMATTER_DECORATOR

	class_invariant: TBON_INVARIANT
			-- What is the invariant of this class?

	feature_clauses: LIST[TBON_FEATURE_CLAUSE]
			-- What are the feature clauses of this class?

	indexing_clause: TBON_INDEXING_CLAUSE
			-- What is the indexing clause of this class?

	name: attached TBON_IDENTIFIER
			-- What is the name of this class?

	type_parameters: LIST[TBON_FORMAL_GENERIC]
			-- What are the type parameters of this class?

feature -- Status report
	has_ancestors: BOOLEAN
			-- Does this class have any ancestors?
		do
			Result := ancestors /= Void and then ancestors.count > 0
		end

	has_indexing_clause: BOOLEAN
			-- Does this class have an indexing clause?
		do
			Result := indexing_clause /= Void
		end

	has_type_parameters: BOOLEAN
			-- Does this class have any type parameters?
		do
			Result := type_parameters /= Void and then type_parameters.count > 0
		end

	is_deferred: BOOLEAN
			-- Is this class deferred?

	is_effective: BOOLEAN
			-- Is this class effective?

	is_generic: BOOLEAN
			-- Is this class generic?
		do
			Result := type_parameters /= Void or else type_parameters.is_empty
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

	associated_class_invariant_assertion_list: LIST[TBON_ASSERTION]
			-- Extract the class invariants of the assocated class.	
		require
			class_has_invariant: associated_class.invariant_part /= Void
		local
			l_assertion: TBON_ASSERTION
			l_assertions: like associated_class.invariant_part.assertion_list
		do
			l_assertions := associated_class.invariant_part.assertion_list
			from
				l_assertions.start
			until
				l_assertions.exhausted
			loop
				-- Get assertion details from l_assertions.i_th
				-- create l_assertion.make_element
				-- Result.put (l_assertion)
				l_assertions.forth
			end
		end

	associated_class_indices: LIST[TBON_INDEX]
			-- Extract the indices of an indexing clause of the associated class
		local
			l_index_tag: TBON_IDENTIFIER
			l_index_terms: LIST[STRING]
			l_index: TBON_INDEX
			l_index_list: LIST[TBON_INDEX]
		do
			create {LINKED_LIST[TBON_INDEX]} l_index_list.make
			from
				associated_class.top_indexes.start
			until
				associated_class.top_indexes.exhausted
			loop
				create l_index_tag.make_element (associated_text_formatter_decorator, associated_class.top_indexes.item.tag.string_value_32)
				l_index_terms := strings_from_atomics (associated_class.top_indexes.item.index_list)
				create l_index.make_element (associated_text_formatter_decorator, l_index_tag, l_index_terms)

				l_index_list.extend (l_index)

				associated_class.top_indexes.forth
			end

			Result := l_index_list
		end

	associated_class_name: STRING
			-- Extract class name from the abstract class syntax.
		once
			Result := associated_class.class_name.string_value_32
		end

	create_arguments_for_feature (feat: FEATURE_AS): LIST[TBON_FEATURE_ARGUMENT]
			-- Create BON arguments for a feature AST
		local
			l_feature_arguments: LIST[TBON_FEATURE_ARGUMENT]
		do
			create {ARRAYED_LIST[TBON_FEATURE_ARGUMENT]} l_feature_arguments.make (5)

			feat.body.arguments.do_all (
				agent (l_argument: TYPE_DEC_AS; l_argument_list: LIST[TBON_FEATURE_ARGUMENT])
					require
						argument_not_void: l_argument /= Void
					local
						l_feature_argument: TBON_FEATURE_ARGUMENT
						l_argument_formal_name: TBON_IDENTIFIER
						l_argument_type: TBON_CLASS_TYPE
					do
						-- Loop through IDs of formal argument names
						from
							l_argument.id_list.start
						until
							l_argument.id_list.exhausted
						loop
							-- Index the names heap to get formal argument name
							create l_argument_formal_name.make_element (associated_text_formatter_decorator, l_argument.names_heap.item_32 (l_argument.id_list.item))
							-- Get argument type
							create l_argument_type.make_element (associated_text_formatter_decorator, l_argument.type.dump)

							create l_feature_argument.make_element (associated_text_formatter_decorator, l_argument_formal_name, l_argument_type)
							l_argument_list.put (l_feature_argument)

							l_argument.id_list.forth
						end
					ensure
						l_argument_list.count = old l_argument_list.count + l_argument.id_list.count
					end (?, l_feature_arguments)
			)
		end

	extract_associated_class_ancestors
			-- Extract the ancestors for the associated class
		require
			has_conforming_parents: associated_class.conforming_parents /= Void
		do
			associated_class.conforming_parents.do_all (
				agent (ancestor: PARENT_AS)
					local
						ancestor_class_type: TBON_CLASS_TYPE
					do
						create ancestor_class_type.make_element (associated_text_formatter_decorator, ancestor.type.class_name.string_value_32)
						ancestors.put (ancestor_class_type)
					ensure
						ancestors.count = old ancestors.count + 1
					end
			)
		end

	extract_associated_class_feature_clauses
			-- Extract the feature clauses and features of the associated class
		do
			associated_class.features.do_all (
				agent (feature_clause: FEATURE_CLAUSE_AS; feature_clause_list: LIST[TBON_FEATURE_CLAUSE])
					require
						feature_clause_not_void: feature_clause /= Void
						feature_clause_list_not_void: feature_clause_list /= Void
					local
						l_feature_clause: TBON_FEATURE_CLAUSE
					do
						l_feature_clause := new_feature_clause_with_features (feature_clause)
						feature_clause_list.put (l_feature_clause)
					ensure
						feature_clause_list.count = old  feature_clause_list.count + 1
					end (?, feature_clauses)
				)

		end

	extract_associated_class_type_parameters
			-- Extract the type paramters of the associated class.
			-- Results are stored in the type_parameters list.
		require
			has_generics: associated_class.generics /= Void
		do
			associated_class.generics.do_all (
				agent (generic: FORMAL_DEC_AS)
					local
						l_formal_generic_name: TBON_FORMAL_GENERIC_NAME
						l_identifier: TBON_IDENTIFIER
						l_formal_generic: TBON_FORMAL_GENERIC
						l_constraining_type: TBON_CLASS_TYPE
					do
						create l_identifier.make_element (associated_text_formatter_decorator, generic.name.name_8)
						create l_formal_generic_name.make_element (associated_text_formatter_decorator, l_identifier)

						if generic.has_constraint then
							create l_constraining_type.make_element (associated_text_formatter_decorator, generic.constraints.first.type.dump)
						else
							l_constraining_type := Void
						end

						create l_formal_generic.make_element (associated_text_formatter_decorator, l_formal_generic_name, l_constraining_type)
						type_parameters.put (l_formal_generic)
					ensure
						type_parameters.count = old type_parameters.count + 1
					end
				)
		end

	new_feature (feat: FEATURE_AS): TBON_FEATURE
			-- Create a BON feature from the AST.
		local
			l_feature: TBON_FEATURE
			l_feature_name: TBON_IDENTIFIER
			l_feature_arguments: LIST[TBON_FEATURE_ARGUMENT]
			l_feature_type: TBON_CLASS_TYPE
			l_feature_type_mark: TBON_TYPE_MARK
			l_feature_comments: LIST[STRING]
			l_feature_renaming_clause: TBON_RENAMING_CLAUSE
			l_feature_precondition: TBON_PRECONDITION
			l_feature_postcondition: TBON_POSTCONDITION

			l_renaming_parent: TBON_CLASS_TYPE
			l_renaming_old_name: STRING
			l_renaming_final_name: STRING

			l_pre_assertion_list: LIST[TBON_ASSERTION]
			l_post_assertion_list: LIST[TBON_ASSERTION]

			-- Remember deferred/effective/redefined!
		do
			-- Name
			create l_feature_name.make_element (associated_text_formatter_decorator, feat.feature_name.string_value_32)

			-- Arguments
			l_feature_arguments := create_arguments_for_feature (feat)

			-- Type
			if feat.body.type /= Void then -- feat.is_function or feat.is_attribute then
				create l_feature_type.make_element (associated_text_formatter_decorator, feat.body.type.dump)
			else
				l_feature_type := Void
			end

			-- Type mark
			create l_feature_type_mark.make_element
				-- Set as association if not a constant, due to difficulty of finding out whether the type is expanded
			if feat.body.is_constant or else (feat.body.as_routine /= Void and then feat.body.as_routine.is_once) then
				l_feature_type_mark.set_as_shared_association (1)
			else
				l_feature_type_mark.set_as_association
			end


			-- Comments
			create {ARRAYED_LIST[STRING]} l_feature_comments.make (5)
			feat.comment (Void).do_all (
				agent (l_comment: EIFFEL_COMMENT_LINE; l_comment_list: LIST[STRING])
					do
						l_comment_list.put (l_comment.content_32)
					ensure
						l_comment_list.count = old l_comment_list.count + 1
					end (?, l_feature_comments)
			)

			-- Renaming clause
			from
				associated_class.parents.start
			until
				associated_class.parents.exhausted
			loop
				if associated_class.parents.item.renaming /= Void then
					from
						associated_class.parents.item.renaming.start
					until
						associated_class.parents.item.renaming.exhausted
					loop
						l_renaming_old_name := associated_class.parents.item.renaming.item.old_name.visual_name_32
						l_renaming_final_name := associated_class.parents.item.renaming.item.new_name.visual_name_32

						if l_renaming_old_name.is_equal (l_feature_name.string_value) then
							check l_renaming_old_name /= Void and l_renaming_final_name /= Void end

							create l_renaming_parent.make_element (associated_text_formatter_decorator, associated_class.parents.item.type.class_name.string_value_32)
							create l_feature_renaming_clause.make_element (l_renaming_parent, l_renaming_final_name)

							-- End both loops
							associated_class.parents.item.renaming.finish
							associated_class.parents.finish
						end
					end

					associated_class.parents.item.renaming.forth
				end

				associated_class.parents.forth
			end

			-- Precondition
			if feat.body.as_routine /= Void and then feat.body.as_routine.has_precondition then
				create {ARRAYED_LIST[TBON_ASSERTION]} l_pre_assertion_list.make (10) -- ITU_FIXME_42

				feat.body.as_routine.precondition.assertions.do_all (
					agent (l_precondition: TAGGED_AS; assertion_list: LIST[TBON_ASSERTION])
						require
							precondition_not_void: l_precondition /= Void
							list_not_void: assertion_list /= Void
						local
							l_bon_assertion: TBON_EXPRESSION
						do
							create l_bon_assertion.make_element
							assertion_list.put (l_bon_assertion)
						ensure
							assertion_list.count = old assertion_list.count + 1
						end
				)

				create l_feature_precondition.make_element (l_pre_assertion_list)
			end

			check -- If feature has a precondition, a precondition muat have been created
				feat.body.as_routine /= Void and then feat.body.as_routine.has_precondition
				implies
				l_feature_precondition /= Void
			end

			-- Postcondition
			if feat.body.as_routine /= Void and then feat.body.as_routine.has_postcondition then
				create {ARRAYED_LIST[TBON_ASSERTION]} l_post_assertion_list.make (10) -- ITU_FIXME_42

				feat.body.as_routine.postcondition.assertions.do_all (
					agent (l_postcondition: TAGGED_AS; assertion_list: LIST[TBON_ASSERTION])
						require
							postcondition_not_void: l_postcondition /= Void
							list_not_void: assertion_list /= Void
						local
							l_bon_assertion: TBON_EXPRESSION
						do
							create l_bon_assertion.make_element
							assertion_list.put (l_bon_assertion)
						ensure
							assertion_list.count = old assertion_list.count + 1
						end
				)

				create l_feature_postcondition.make_element (l_post_assertion_list)
			end

			check -- If feature has a postcondition, a postcondition muat have been created
				feat.body.as_routine /= Void and then feat.body.as_routine.has_postcondition
				implies
				l_feature_postcondition /= Void
			end

			create l_feature.make_element (associated_text_formatter_decorator,
										   l_feature_name,
										   l_feature_arguments,
										   l_feature_type,
										   l_feature_type_mark,
										   l_feature_comments,
										   l_feature_renaming_clause,
										   l_feature_precondition,
										   l_feature_postcondition)

			-- Set status
			if feat.body.as_routine /= Void and then feat.body.as_routine.is_deferred then
				l_feature.set_deferred
			end

			Result := l_feature
		end

	new_feature_clause_with_features (feature_clause: FEATURE_CLAUSE_AS): TBON_FEATURE_CLAUSE
			-- Create a textual BON feature clause and its associated features
		local
			l_bon_feature_clause: TBON_FEATURE_CLAUSE
			l_comment_list: LIST[STRING]
			l_feature_list: LIST[TBON_FEATURE]
			l_selective_export: TBON_SELECTIVE_EXPORT

			l_redefined_features: LIST[STRING]
		do
			-- Get comments
			create {ARRAYED_LIST[STRING]} l_comment_list.make(2)

			feature_clause.comment (Void).do_all (
				agent (line: EIFFEL_COMMENT_LINE; l_l_comment_list: LIST[STRING])
					do
						l_l_comment_list.put (line.content_32)
					ensure
						l_l_comment_list.count = old l_l_comment_list.count + 1
					end (?, l_comment_list)
				)

			-- Create features
			feature_clause.features.do_all (
				agent (l_feature_as: FEATURE_AS; l_l_feature_list: LIST[TBON_FEATURE])
					require
						feature_as_not_void: l_feature_as /= Void
						feature_list_not_void: l_l_feature_list /= Void
					local
						l_feature: TBON_FEATURE
					do
						l_feature := new_feature (l_feature_as)
						l_l_feature_list.put (l_feature)
					ensure
						l_l_feature_list.count = old l_l_feature_list.count + 1
					end (?, l_feature_list)
			)

			l_selective_export := new_selective_export (feature_clause)

			set_redefined_bon_features_as_redefined (l_feature_list)

			create l_bon_feature_clause.make_element (associated_text_formatter_decorator, l_comment_list, l_feature_list, l_selective_export)

			Result := l_bon_feature_clause
		end

	new_selective_export (feature_clause: FEATURE_CLAUSE_AS): TBON_SELECTIVE_EXPORT
			-- Create a new selective export from a feature clause
		local
			l_selective_export: TBON_SELECTIVE_EXPORT
			l_export_list: LIST[TBON_CLASS_TYPE]
		do
			-- Get export client classes
			create {ARRAYED_LIST[TBON_CLASS_TYPE]} l_export_list.make(3)

			if feature_clause.clients.clients /= Void then
				feature_clause.clients.clients.do_all (
					agent (client_id: ID_AS; l_client_list: LIST[TBON_CLASS_TYPE])
						require
							client_id_not_void: client_id /= Void
							client_list_not_void: l_client_list /= Void
						local
							l_class_type: TBON_CLASS_TYPE
						do
							create l_class_type.make_element (associated_text_formatter_decorator, client_id.name_8)
							l_client_list.put (l_class_type)
						ensure
							l_client_list.count = old l_client_list.count + 1
						end (?, l_export_list)
				)

				create l_selective_export.make_element_with_class_list (l_export_list)
			else
				l_selective_export := Void
			end

			Result := l_selective_export
		end

	set_class_status
			-- Set the status of this class
		do
			if associated_class.is_deferred then
				set_is_deferred
			-- Sufficient information about parents seems to be unavailable to determine other status flags.
			end
		end

	set_redefined_bon_features_as_redefined (feature_list: LIST[TBON_FEATURE])
			-- Set 'is_redefined' for all redefined textual BON features that represent a redefined feture.
		local
			l_feature_list: LIST[TBON_FEATURE]
			l_redefined_features: LIST[STRING]
		do
			l_feature_list := feature_list

			-- Get redefined features from AST
			create {ARRAYED_LIST[STRING]} l_redefined_features.make (10)
			associated_class.parents.do_if (
				agent (parent: PARENT_AS; feature_name_list: LIST[STRING])
					require
						parent_not_void: parent /= Void
						feature_name_list_not_void: feature_name_list /= Void
					do
						from
							parent.redefining.start
						until
							parent.redefining.exhausted
						loop
							feature_name_list.put (parent.redefining.item.visual_name_32)
							parent.redefining.forth
						end
					end (?, l_redefined_features)
			, agent (parent: PARENT_AS): BOOLEAN do Result := parent.is_effecting end)

			-- Set redefined BON features as redefined
			l_redefined_features.do_all (
				agent (l_feature_name: STRING; l_l_feature_list: LIST[TBON_FEATURE])
					require
						feature_name_not_void: l_feature_name /= Void
						feature_list_not_void: l_l_feature_list /= Void
					do
						from
							l_l_feature_list.start
						until
							l_l_feature_list.exhausted
						loop
							if l_l_feature_list.item.name.string_value.is_equal (l_feature_name) then
								l_l_feature_list.item.set_redefined
							end

							l_l_feature_list.forth
						end
					ensure
						l_l_feature_list.count = old l_l_feature_list.count + 1
					end (?,l_feature_list)
			)
		end

	strings_from_atomics (l_list: EIFFEL_LIST[ATOMIC_AS]): LIST[STRING]
			-- Extract the string values of a list of ATOMIC_AS's and return them as list of strings
		local
			i: INTEGER
		do
			from
				i := 0
			until
				i < l_list.count
			loop
				Result.put (l_list.i_th (i).string_value_32)
				i := i + 1
			end
		end


invariant
	must_have_name: name /= Void
	must_describe_class: associated_class /= Void
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
