indexing
	description: "Summary description for {SCOOP_PROXY_PARENT_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROXY_PARENT_VISITOR

inherit
	SCOOP_PARENT_VISITOR
		redefine
			process_internal_conforming_parents,
			process_internal_non_conforming_parents,
			process_generic_class_type_as,
			process_parent_as,
			process_rename_as,
			process_id_as,
			process_redefine_clause_as,
			process_undefine_clause_as,
			process_select_clause_as,
			process_feat_name_id_as,
			process_feature_name_alias_as
		end

	SCOOP_WORKBENCH
		export
			{NONE} all
		end

	SCOOP_BASIC_TYPE
		export
			{NONE} all
		end

create
	make_with_context

feature -- Access

	process_internal_conforming_parents(l_as: PARENT_LIST_AS) is
			-- Process `l_as'.
		do
			is_process_first_select := true
			if l_as /= Void then
				create parent_redefine_list.make
				Precursor (l_as)
				scoop_workbench_objects.append_parent_redefine_list (parent_redefine_list)
			else
					-- inherit 'SCOOP_SEPARATE__ANY' if (conforming) parent list contains no elemets.
				context.add_string ("%N%Ninherit%N%TSCOOP_SEPARATE__ANY")
					-- rename and redefine 'implementation_'
				if parsed_class.is_expanded then
					context.add_string ("%N%T%Trename%N%T%T%Timplementation_ as implementation_any_%N%T%Tselect%N%T%T%Timplementation_any_%N%T%Tend")
				else
					context.add_string ("%N%T%Tredefine implementation_ end")
				end
			end
		end

	process_internal_non_conforming_parents(l_as: PARENT_LIST_AS) is
			-- Process `l_as'
		do
			is_process_first_select := false
			create parent_redefine_list.make
			Precursor (l_as)
			scoop_workbench_objects.append_parent_redefine_list (parent_redefine_list)
		end

feature {NONE} -- Visitor implementation

	process_parent_as (l_as: PARENT_AS) is
			-- Process `l_as'.
		local
			l_parent_name: STRING
			l_string_context: ROUNDTRIP_STRING_LIST_CONTEXT
		do
			-- set current processed parent
			current_processed_parent := l_as

			last_index := l_as.type.start_position - 1
			-- skip parent if it is 'ANY'
			if l_as.type.class_name.name.is_equal ("ANY") then
				-- skip complete parent_clause
				last_index := l_as.end_position
			else
				context.add_string ("%N%T")
				l_string_context ?= context

				-- process parent object
				create parent_object.make (l_as.type.class_name.name)
				scoop_workbench_objects.add_proxy_parent_object (parent_object)
				create l_parent_name.make_from_string (l_as.type.class_name.name)
				parent_object.set_parent_name (l_parent_name)
				parent_object.set_parent_class_c (get_parent_class_c_by_name (l_parent_name))

				-- process type
				safe_process (l_as.type)
				parent_object.set_parent_cursor (l_string_context.get_cursor)

				-- process internal renaming
				safe_process (l_as.internal_renaming)
				if parsed_class.is_expanded then
					if l_as.internal_renaming = Void then
						context.add_string ("%N%T%Trename")
					end
					-- add renaming of 'implementation_'
					context.add_string ("%N%T%T%Timplementation_ as implementation_" + l_as.type.class_name.name.as_lower + "_")

					-- mark rename clause
					parent_object.set_rename_cursor (l_string_context.get_cursor)
				elseif l_as.internal_renaming /= Void then
					-- mark rename clause
					parent_object.set_rename_cursor (l_string_context.get_cursor)
				end

				-- process internal exports
				safe_process (l_as.internal_exports)

				-- process internal undefining	
				safe_process (l_as.internal_undefining)

				-- process internal redefining
				safe_process (l_as.internal_redefining)
				if l_as.internal_redefining /= Void then
					context.add_string (",")
				else
					context.add_string ("%N%T%Tredefine")
				end
				context.add_string ("%N%T%T%Timplementation_")
				parent_object.set_redefine_cursor (l_string_context.get_cursor)

				-- process internal selection
				safe_process (l_as.internal_selecting)
				if parsed_class.is_expanded and then is_process_first_select then
					if l_as.internal_selecting = Void then
						context.add_string ("%N%T%Tselect")
					else
						context.add_string (", ")
					end
					context.add_string ("%N%T%T%Timplementation_" + l_as.type.class_name.name.as_lower + "_")
					is_process_first_select := false
				end

					-- add in each case the end keyword
				context.add_string ("%N%T%Tend")
				if l_as.end_keyword_index > 0 then
					last_index := l_as.end_keyword_index
				else
					last_index := l_as.type.end_position
				end
			end
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS) is
			-- Process `l_as'.
		local
			l_generics_visitor: SCOOP_GENERICS_VISITOR
		do
			safe_process (l_as.lcurly_symbol (match_list))
			safe_process (l_as.attachment_mark (match_list))
			safe_process (l_as.expanded_keyword (match_list))
			safe_process (l_as.class_name)

			l_generics_visitor := scoop_visitor_factory.new_generics_visitor (context)
			l_generics_visitor.process_internal_generics (l_as.internal_generics, true, false)

			safe_process (l_as.rcurly_symbol (match_list))
		end

	process_id_as (l_as: ID_AS) is
			-- Process `l_as'.
		local
			a_class: CLASS_AS
			l_scoop_separate_str: STRING
		do
			create l_scoop_separate_str.make_from_string (" SCOOP_SEPARATE__")
			process_leading_leaves (l_as.index)

			if not is_basic_type (l_as.name) then
				if is_process_export_clause then
					-- print client and proxy class name when printing export clause
					context.add_string (l_scoop_separate_str)
					put_string (l_as)
					context.add_string (", ")
				else
					-- add prefix if parent class is not expanded.
					a_class := get_class_as_by_name (l_as.name)
					if (a_class /= Void and then not a_class.is_expanded) then
						context.add_string (l_scoop_separate_str)
					end
				end
			end

			-- print id
			put_string (l_as)
			last_index := l_as.index
		end

	process_rename_as (l_as: RENAME_AS) is
			-- Process `l_as'.
		local
			l_old_name, l_new_name, l_str: STRING
			l_original_old_name, l_original_old_alias_name: STRING
			l_class_c: CLASS_C
			l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
			l_assign_finder: SCOOP_PROXY_ASSIGN_FINDER
		do
			Precursor (l_as)

			-- Create rename statement for assigner wrapper features
			-- if the current rename statement renames a feature which
			-- is used as assigner in a parent class. If the current
			-- statement renames f from g to f then add a rename feature
			-- "g_scoop_separate_assigner_ as f_scoop_separate_assigner_"

			-- create visitors
			create l_assign_finder
			l_feature_name_visitor := scoop_visitor_factory.new_feature_name_visitor

			-- get current processed parent
			l_class_c := parent_object.parent_class_c

			-- get original old name
			l_feature_name_visitor.process_original_feature_name (l_as.old_name, false)
			l_original_old_name := l_feature_name_visitor.get_feature_name
			l_feature_name_visitor.process_original_feature_name (l_as.old_name, true)
			l_original_old_alias_name := l_feature_name_visitor.get_feature_name

			-- check if old name is a feature with assigner in current parent or an ancestor
			if l_assign_finder.has_current_or_parents_feature_with_assigner (l_original_old_name, l_original_old_alias_name, l_class_c) then

				-- get old and new name (with infix replacement)
				l_feature_name_visitor.process_feature_name (l_as.old_name, false)
				l_old_name := l_feature_name_visitor.get_feature_name
				l_feature_name_visitor.process_feature_name (l_as.new_name, false)
				l_new_name := l_feature_name_visitor.get_feature_name

				-- create rename statement
				create l_str.make_from_string (",%N%T%T%T" + l_old_name + "_scoop_separate_assigner_")
				l_str.append (" as " + l_new_name + "_scoop_separate_assigner_")
				context.add_string (l_str)
			end
		end

	process_redefine_clause_as (l_as: REDEFINE_CLAUSE_AS) is
			-- Process `l_as'.
		local
			i, nb: INTEGER
			l_class_c: CLASS_C
			l_redefine_name, l_redefine_alias_name: STRING
			l_assign_finder: SCOOP_PROXY_ASSIGN_FINDER
			l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
			l_redefine_tuple: TUPLE [orignial_feature_name, original_feature_alias_name: STRING; parent_object: SCOOP_PROXY_PARENT_OBJECT ]
		do
			-- process node
			Precursor (l_as)

			-- get all redefine statements which are features with assigner in an ancestor.
			create l_assign_finder
			l_feature_name_visitor := scoop_visitor_factory.new_feature_name_visitor

			if l_as.content /= Void then
				-- iterate over all redefine statements
				from
					i := 1
					nb := l_as.content.count
				until
					i > nb
				loop
					-- get redefine statement / feature name
					l_feature_name_visitor.process_original_feature_name (l_as.content.i_th (i), false)
					l_redefine_name := l_feature_name_visitor.get_feature_name
					l_feature_name_visitor.process_original_feature_name (l_as.content.i_th (i), true)
					l_redefine_alias_name :=  l_feature_name_visitor.get_feature_name

					-- check if current parent or an ancestor has the actual redefined feature
					-- defined together with an assigner

					-- get current class
					l_class_c := parent_object.parent_class_c

					if l_assign_finder.has_current_or_parents_feature_with_assigner (l_redefine_name, l_redefine_alias_name, l_class_c) then
						-- current parent class or an ancestor has found a feature with
						-- feature name `l_redefine_name' and assigner. Save `l_redefine_name' and
						-- reference to parent_object in list to insert it when creating the
						-- `f_scoop_separate_assinger_' feature.
						create l_redefine_tuple
						l_redefine_tuple.orignial_feature_name := l_redefine_name
						l_redefine_tuple.original_feature_alias_name := l_redefine_alias_name
						l_redefine_tuple.parent_object := parent_object
						parent_redefine_list.extend (l_redefine_tuple)
					end
					i := i + 1
				end
			end
		end

	process_undefine_clause_as (l_as: UNDEFINE_CLAUSE_AS) is
			-- Process `l_as'.
		do
			-- process node
			Precursor (l_as)

			-- check if undefine feature name is a feature with assigner in an ancestor.
			-- insert if found a undefine statement for the assigner wrapper feature.
			if l_as.content /= Void then
				check_list_and_add_assigner_wrapper_feature_name (l_as.content)
			end
		end

	process_select_clause_as (l_as: SELECT_CLAUSE_AS) is
			-- Process `l_as'.
		do
			-- process node
			Precursor (l_as)

			-- check if select feature name is a feature with assigner in an ancestor
			-- insert if found a undefine statement for the assigner wrapper feature.
			if l_as.content /= Void then
				check_list_and_add_assigner_wrapper_feature_name (l_as.content)
			end
		end

	process_feat_name_id_as (l_as: FEAT_NAME_ID_AS) is
			-- Process `l_as'.
		local
			l_feature_name: STRING
			l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
		do
			-- get feature name without alias
			l_feature_name_visitor := scoop_visitor_factory.new_feature_name_visitor
			l_feature_name_visitor.process_feature_name (l_as, false)
			l_feature_name := l_feature_name_visitor.get_feature_name

			-- process frozen keyowrd
			safe_process (l_as.frozen_keyword)

			-- insert the feature name
			process_leading_leaves (l_as.feature_name.index)
			context.add_string (l_feature_name)
			last_index := l_as.feature_name.index
		end

	process_feature_name_alias_as (l_as: FEATURE_NAME_ALIAS_AS) is
			-- Process `l_as'.
		local
			l_feature_name: STRING
			l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
		do
			-- get feature name without alias
			l_feature_name_visitor := scoop_visitor_factory.new_feature_name_visitor
			l_feature_name_visitor.process_feature_name (l_as, false)
			l_feature_name := l_feature_name_visitor.get_feature_name

			-- process frozen keyword
			safe_process (l_as.frozen_keyword)

			-- insert feature name
			process_leading_leaves (l_as.feature_name.index)
			context.add_string (l_feature_name)
			last_index := l_as.feature_name.index

			-- process alias
			if l_as.alias_name /= Void then
				safe_process (l_as.alias_keyword (match_list))
				safe_process (l_as.alias_name)
				if l_as.has_convert_mark then
					safe_process (l_as.convert_keyword (match_list))
				end
			end
		end

feature {NONE} -- Implementation

	check_list_and_add_assigner_wrapper_feature_name (a_list: EIFFEL_LIST [FEATURE_NAME]) is
			-- checks if a FEATURE_NAME item is a feature with assigner in a ancestor class
			-- an inserts in this case the name of the assign wrapper feature.
		require
			a_list_not_void: a_list /= Void
		local
			i, nb: INTEGER
			l_class_c: CLASS_C
			l_feature_name: FEATURE_NAME
			l_original_feature_name, l_original_feature_alias_name, l_feature_name_str, l_str: STRING
			l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
			l_assign_finder: SCOOP_PROXY_ASSIGN_FINDER
		do
			create l_assign_finder
			l_feature_name_visitor := scoop_visitor_factory.new_feature_name_visitor

			from
				i := 1
				nb := a_list.count
			until
				i > nb
			loop
				l_feature_name := a_list.i_th (i)

				-- get original old name (without infix replacement)
				l_feature_name_visitor.process_original_feature_name (l_feature_name, false)
				l_original_feature_name := l_feature_name_visitor.get_feature_name
				l_feature_name_visitor.process_original_feature_name (l_feature_name, true)
				l_original_feature_alias_name := l_feature_name_visitor.get_feature_name

				-- get current class
				l_class_c := parent_object.parent_class_c

				-- check if old name is a feature with assigner in current parent or an ancestor
				if l_assign_finder.has_current_or_parents_feature_with_assigner (l_original_feature_name, l_original_feature_alias_name, l_class_c) then
					-- get feature name (with infix replacement)
					l_feature_name_visitor.process_feature_name (l_feature_name, false)
					l_feature_name_str := l_feature_name_visitor.get_feature_name

					-- create select / undefine clause
					create l_str.make_from_string (",%N%T%T%T" + l_feature_name_str + "_scoop_separate_assigner_")
					context.add_string (l_str)
				end

				i := i + 1
			end
		end

feature {NONE} -- Implementation

	is_process_first_select: BOOLEAN
			-- indicates internal select of first parent should be processed.

	current_processed_parent: PARENT_AS
			-- Reference to current processed parent.

	parent_object: SCOOP_PROXY_PARENT_OBJECT
			-- Current proxy parent object.

	parent_redefine_list: LINKED_LIST [TUPLE [orignial_feature_name, original_feature_alias_name: STRING; parent_object: SCOOP_PROXY_PARENT_OBJECT ]]
			-- List of redefine features with corresponding parent object.

end
