note
	description: "The engine of alias analysis framework."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ALIAS_ANALYZER

inherit
	AST_FEATURE_CHECKER_GENERATOR
		rename
			error_handler as ast_error_handler
		redefine
			check_locals,
			process_access_assert_as,
			process_access_feat_as,
			process_access_id_as,
			process_access_inv_as,
			process_assign_as,
			process_bin_eq_as,
			process_creation_as,
			process_expr_call_as,
			process_result_as,
			process_routine_as,
			process_void_as
		end

	SHARED_AST_CONTEXT
		rename
			context as shared_context
		end

	SHARED_EIFFEL_PROJECT

create
	make

feature {NONE} -- Creation

	make
			-- Initialize analyser.
		do
			create dictionary.make
			create keeper.make (0)
		end

feature -- Basic operations

	process_class (c: CLASS_C)
			-- Perform analysis on the class `c'.
		do
			prepare_analysis (c)
			if attached c.feature_table as t then
				from
					t.start
				until
					t.after
				loop
					analyze_feature (t.item_for_iteration, c)
					t.forth
				end
			end
			report_result
		end

	process_feature (f: FEATURE_I; c: CLASS_C)
			-- Perform analysis on the feature `f' from the class `c'.
		do
			prepare_analysis (c)
			analyze_feature (f, c)
			report_result
		end

feature -- Status report

	is_inherited_assertion_included: BOOLEAN
			-- Does the analysis include inherited assertions?

feature -- Status setting

	set_is_inherited_assertion_included (v: BOOLEAN)
			-- Set `is_inherited_assertion_included' to `v'.
		do
			is_inherited_assertion_included := v
		ensure
			is_inherited_assertion_included_set: is_inherited_assertion_included = v
		end

feature {NONE} -- Analysis

	prepare_analysis (c: CLASS_C)
			-- Prepare analyzer to process `c'.
		do
			init (shared_context)
			context.initialize (c, c.actual_type)
			create dictionary.make
			error_handler.wipe_out
			if attached {ES_ERROR_DISPLAYER} eiffel_project.error_displayer as d then
				d.clear (uuid)
			end
		end

	analyze_feature (f: FEATURE_I; c: CLASS_C)
			-- Perform analysis on the feature `f' from the class `c'.
		do
			context.clear_feature_context
			context.set_current_feature (f)
			context.set_written_class (f.written_class)
			create keeper.make (0)
			-- context.add_keeper (keeper)
			type_check_only (f, is_inherited_assertion_included, f.written_in /= c.class_id, f.is_replicated)
		end

	report_result
			-- Report results of the analysis.
		do
			if attached {ES_ERROR_DISPLAYER} eiffel_project.error_displayer as d then
				if error_handler.has_error then
					d.trace_errors ({ENVIRONMENT_CATEGORIES}.compilation, uuid, error_handler)
				end
				if error_handler.has_warning then
					d.trace_warnings ({ENVIRONMENT_CATEGORIES}.compilation, uuid, error_handler)
				end
			end
		end

feature {NONE} -- Visitor

	process_access_assert_as (a: ACCESS_ASSERT_AS)
			-- <Precursor>
		do
			Precursor (a)
			process_access (a)
		end

	process_access_feat_as (a: ACCESS_FEAT_AS)
			-- <Precursor>
		do
			Precursor (a)
			process_access (a)
		end

	process_access_id_as (a: ACCESS_ID_AS)
			-- <Precursor>
		do
			Precursor (a)
			process_access (a)
		end

	process_access_inv_as (a: ACCESS_INV_AS)
			-- <Precursor>
		do
			Precursor (a)
			process_access (a)
		end

	process_assign_as (a: ASSIGN_AS)
		local
			s: like last_item
			t: like last_item
		do
			reset_for_unqualified_call_checking
			a.target.process (Current)
			t := last_item
			if t > 0 then
					-- Found the target of the assignment.
				a.source.process (Current)
				s := last_item
				if s > 0 then
						-- Found the source of the assignment.
					if s = {ALIAS_ANALYZER_DICTIONARY}.non_void_index then
							-- The source is a new object that cannot have any aliases.
						keeper.relation.add_pair (s, t)
					else
							-- The source may have aliases.
						keeper.relation.attach (s, t)
					end
				end
			end
			Precursor (a)
		end

	process_bin_eq_as (a: BIN_EQ_AS)
			-- <Precursor>
		local
			l: like last_item
			r: like last_item
		do
			if not attached {BIN_TILDE_AS} a then
				a.left.process (Current)
				l := last_item
				if l > 0 then
					a.right.process (Current)
					r := last_item
					if r > 0 and then not keeper.relation.has_pair (l, r) then
						if attached {BIN_NE_AS} a then
								-- The condition is always true.
							report_true_expression (a.first_token (Void))
						else
								-- The condition is always false.
							report_false_expression (a.first_token (Void))
						end
					end
				end
			end
			Precursor (a)
		end

	process_creation_as (a: CREATION_AS)
			-- <Precursor>
		local
			t: like last_item
		do
			reset_for_unqualified_call_checking
			a.target.process (Current)
			t := last_item
			if t > 0 then
					-- Remove all relations for `t'.
				keeper.relation.remove (t)
					-- Add a pair to indicate that it is now attached to a non-void value.
				keeper.relation.add_pair (t, {ALIAS_ANALYZER_DICTIONARY}.non_void_index)
			end
			Precursor (a)
		end

	process_expr_call_as (a: EXPR_CALL_AS)
			-- <Precursor>
		do
				-- Clear last found item.
			last_item := 0
			Precursor (a)
		end

	process_result_as (a: RESULT_AS)
			-- <Precursor>
		do
				-- Clear last found item.
			last_item := 0
			if not current_feature.type.is_expanded then
				dictionary.add_result (context.current_feature, context.current_class)
				last_item := dictionary.last_added
			end
			Precursor (a)
		end

	process_routine_as (a: ROUTINE_AS)
			-- <Precursor>
		local
			t: TYPE_A
			r: NATURAL_32
		do
				-- Register "Result".
			dictionary.add_result (context.current_feature, context.current_class)
			r := dictionary.last_added
			t := current_feature.type
			if not t.is_reference then
					-- Add a pair "[result, NonVoid]".
				keeper.relation.add_pair ({ALIAS_ANALYZER_DICTIONARY}.non_void_index, r)
			end
			if not t.is_expanded then
					-- Attach "Void" to "result".
				keeper.relation.attach ({ALIAS_ANALYZER_DICTIONARY}.void_index, r)
			end
			Precursor (a)
		end

	process_void_as (a: VOID_AS)
			-- <Precursor>
		do
			last_item := {ALIAS_ANALYZER_DICTIONARY}.void_index
			Precursor (a)
		end

feature {NONE} -- Entity access

	check_locals (a: ROUTINE_AS)
			-- <Precursor>
			-- Record which locals are initialized to void and non-void values.
		local
			t: TYPE_A
			n: NATURAL_32
		do
			Precursor (a)
			if attached context.locals as l then
				across
					l as i
				loop
						-- Register a local in a dictionary.
					register_local (i.item)
					n := last_item
						-- Check if the local is void or non-void by default.
					t := i.item.actual_type
					if not t.is_reference then
							-- Add a pair "[variable, NonVoid]".
						keeper.relation.add_pair ({ALIAS_ANALYZER_DICTIONARY}.non_void_index, n)
					end
					if not t.is_expanded then
							-- Attach "Void" to "variable".
						keeper.relation.attach ({ALIAS_ANALYZER_DICTIONARY}.void_index, n)
					end
				end
			end
		end

	process_access (a: ACCESS_FEAT_AS)
			-- Process access to the entity `a'.
		do
				-- Clear last found item.
			last_item := 0
			if
				a.is_local and then
				attached context.locals.item (a.feature_name.name_id) as i and then
				not i.type.is_expanded
			then
				register_local (i)
			end
		end

	register_local (l: LOCAL_INFO)
			-- Register local identified by `l' and set `last_item'
			-- to the corresopnding dictionary entry.
		do
			dictionary.add_local
				(l.position,
				context.current_feature,
				context.current_class)
			last_item := dictionary.last_added
		end

feature {NONE} -- Access

	last_item: like {ALIAS_ANALYZER_DICTIONARY}.last_added
			-- Last found item.

feature {NONE} -- Storage

	dictionary: ALIAS_ANALYZER_DICTIONARY
			-- Dictionary of used entities.

	keeper: ALIAS_ANALYZER_RELATION_KEEPER
			-- Keeper of alias relations.

feature {NONE} -- Output

	error_handler: ERROR_HANDLER
			-- Handler to record reports from the analyzer.
		once
			create Result.make
		end

	report_false_expression (a: LOCATION_AS)
			-- Report that the condition at `a' is always False.
		do
			error_handler.insert_warning (create {ALIAS_ANALYZER_WARNING}.make_always_false (a, context))
		end

	report_true_expression (a: LOCATION_AS)
			-- Report that the condition at `a' is always False.
		do
			error_handler.insert_warning (create {ALIAS_ANALYZER_WARNING}.make_always_true (a, context))
		end

	uuid: UUID
			-- UUID of the analyzer.
		once
			create Result.make_from_string ("E1FFE10F-1401-47E2-9CD7-2A492C969376")
		end

note
	copyright: "Copyright (c) 2012, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
