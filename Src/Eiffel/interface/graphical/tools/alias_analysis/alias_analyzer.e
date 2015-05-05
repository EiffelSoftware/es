note
	description: "An engine of alias analysis framework."

deferred class
	ALIAS_ANALYZER

inherit

	AST_ITERATOR
		redefine
			process_case_as,
			process_debug_as,
			process_eiffel_list,
			process_elseif_as,
			process_guard_as,
			process_if_as,
			process_inspect_as,
			process_void_as
		end

	SHARED_AST_CONTEXT

feature {NONE} -- Creation

	make
			-- Initialize analyser.
		do
			create dictionary.make
			create ast_type.make (0)
			create start_time.make_now_utc
			create finish_time.make_now_utc
			create keeper.make_from_array (<<>>)
		end

feature -- Analysis

	process_class (c: CLASS_C; u: PROCEDURE [ANY, TUPLE [ANY]])
			-- Perform analysis on the class `c'
			-- calling agent `u' from time to time to report progress.
		do
			update_agent := u
			prepare_analysis (c)
			if attached c.feature_table as t then
				progress_total := t.count
			end
		end

	process_feature (f: FEATURE_I; c: CLASS_C; u: PROCEDURE [ANY, TUPLE [ANY]])
			-- Perform analysis on the feature `f' from the class `c'
			-- calling agent `u' from time to time to report progress.
		do
			update_agent := u
			prepare_analysis (c)
			progress_total := 1
		end

	update
			-- Report current analysis status.
		local
			t: like timeout
		do
			if is_update_required then
					-- Postpone update for a while.
				is_update_required := False
					-- Update client about current results.
				update_agent.call ([Void])
					-- Record current time (finish time if the computation is over).
				finish_time.make_now_utc
					-- Check for timeout.
				t := timeout
				if t > 0 and then finish_time.relative_duration (start_time).seconds_count > t then
					is_timeout := True
					is_done := True
				end
			end
		end

feature {NONE} -- Initialization

	prepare_analysis (c: CLASS_C)
			-- Prepare analyzer to process a class `c' or a feature of this class.
		do
				-- Record start time.
			start_time.make_now_utc
			is_timeout := False
				-- Initialize current context using specified class.
			original_class := c
			context.initialize (c, c.actual_type)
				-- Reset storage.
			create dictionary.make
			ast_type.wipe_out
			is_attachment := False
				-- Initialize type checker.
			type_checker.init (context)
			type_checker.set_type_recorder (agent record_node_type)
				-- Set status.
			is_done := False
			is_stop_requested := False
				-- Set statistics.
			is_update_required := True
			analysed_features := 0
			progress_current := 0
			(create {WORKER_THREAD}.make (
				agent (e: EXECUTION_ENVIRONMENT)
					do
						from
						until
							is_done
						loop
							is_update_required := True
							e.sleep (100_000_000)
						end
					end
				(create {EXECUTION_ENVIRONMENT})
			)).launch
		end

feature {NONE} -- Status report: analysis control

	is_inherited_assertion_included: BOOLEAN
			-- Does the analysis include inherited assertions?

	is_all_features: BOOLEAN
			-- Does the analysis include all features, including non-redeclared ones inherited from the class ANY?

	is_stop_requested: BOOLEAN
			-- Should the analysis be stopped?

feature {NONE} -- Status report: analysis state

	is_update_required: BOOLEAN
			-- Should the client get an update on the current status?

	is_done: BOOLEAN
			-- Is analysis over?

feature {NONE} -- Status report: AST processing

	is_attachment: BOOLEAN
			-- Is attachment being performed?

	is_qualified: BOOLEAN
			-- Is qualified call being performed?

feature {NONE} -- Status report: timing

	is_timeout: BOOLEAN
			-- Has analysis timed out?

	timeout: like {DATE_TIME_DURATION}.seconds_count = 60
			-- Number of seconds after which the analysis times out.

feature -- Status setting: analysis control

	set_is_inherited_assertion_included (v: BOOLEAN)
			-- Set `is_inherited_assertion_included' to `v'.
		do
			is_inherited_assertion_included := v
		ensure
			is_inherited_assertion_included_set: is_inherited_assertion_included = v
		end

	set_is_all_features (v: BOOLEAN)
			-- Set `is_all_features' to `v'.
		do
			is_all_features := v
		ensure
			is_all_features_set: is_all_features = v
		end

	stop
			-- Stop analysis.
		do
			is_stop_requested := True
			is_done := True
		ensure
			is_stop_requested: is_stop_requested
			is_done: is_done
		end

feature {AST_EIFFEL} -- Visitor: compound

	process_compound (c: EIFFEL_LIST [INSTRUCTION_AS])
		do
			if c /= Void then
				c.process (Current)
			end
		end

	process_case_as (a: CASE_AS)
		do
			a.interval.process (Current)
			process_compound (a.compound)
			keeper.save_sibling
		end

	process_debug_as (a: DEBUG_AS)
		do
			keeper.enter_realm
			process_compound (a.compound)
			keeper.leave_optional_realm
		end

	process_elseif_as (a: ELSIF_AS)
		do
			a.expr.process (Current)
			process_compound (a.compound)
			keeper.save_sibling
			keeper.update_realm
		end

	process_guard_as (a: GUARD_AS)
		do
			safe_process (a.check_list)
			process_compound (a.compound)
		end

	process_if_as (a: IF_AS)
		do
			a.condition.process (Current)
			keeper.enter_realm
			process_compound (a.compound)
			keeper.save_sibling
			keeper.update_realm
			safe_process (a.elsif_list)
			process_compound (a.else_part)
			keeper.save_sibling
			keeper.leave_realm
		end

	process_inspect_as (a: INSPECT_AS)
		do
			a.switch.process (Current)
			keeper.enter_realm
			safe_process (a.case_list)
			if a.else_part /= Void then
				process_compound (a.else_part)
				keeper.save_sibling
			end
			keeper.leave_realm
		end

feature {AST_EIFFEL} -- Visitor: expression

	process_void_as (a: VOID_AS)
			-- <Precursor>
		do
			last_item := dictionary.void_index
		end

feature {AST_EIFFEL} -- Visitor: nested call

	process_eiffel_list (a: EIFFEL_LIST [AST_EIFFEL])
		local
			q: BOOLEAN
			l_cursor: INTEGER
		do
			q := is_qualified
			is_qualified := False

			--Precursor (a)
			from
				l_cursor := a.index
				a.start
			until
				a.after
			loop
				if attached a.item as l_item then
					update_agent.call (l_item)
					l_item.process (Current)
				else
					check False end
				end
				a.forth
			end
			a.go_i_th (l_cursor)

			is_qualified := q
		end

feature {NONE} -- Entity access

	register_argument (a: INTEGER_32)
			-- Register an argument identified by its position `a'
			--  and set `last_item' to the corresopnding dictionary entry.
		do
			dictionary.add_argument (a, context.current_feature, context.current_class)
			last_item := dictionary.last_added
		end

	register_local (l: LOCAL_INFO)
			-- Register local identified by `l'
			--  and set `last_item' to the corresopnding dictionary entry.
		do
			dictionary.add_local
				(l.position,
				context.current_feature,
				context.current_class)
			last_item := dictionary.last_added
		end

	register_attribute (a: FEATURE_I; c: CLASS_C)
			-- Register attribute identified by `a' in class `c'
			-- and set `lst_item' to the corresopnding dictionary entry.
		do
			dictionary.add_feature (a, c)
			last_item := dictionary.last_added
		end

feature {NONE} -- Access

	last_item: like dictionary.last_added
			-- Last found item.

	original_class: CLASS_C
			-- Class for which analysis is initiated.

feature {NONE} -- Type recording

	ast_type: HASH_TABLE [TYPE_A, TUPLE [a: INTEGER; w: INTEGER; f: INTEGER; c: INTEGER]]
			-- Type of AST node `a' written in class `w'
			-- when evaluated in a feature `f' of class `c'.

	record_node_type (t: TYPE_A; a: AST_EIFFEL; w: CLASS_C; f: FEATURE_I; c: CLASS_C)
			-- Record type `t' of AST node `a' written in class `w'
			-- when evaluated in a feature `f' of class `c'.
		do
			if attached a then
				ast_type [[a.index, w.class_id, f.rout_id_set.first, c.class_id]] := t
			end
		end

	node_type (a: AST_EIFFEL; w: CLASS_C; f: FEATURE_I; c: CLASS_C): detachable TYPE_A
			-- Type of AST node `a' written in class `w'
			-- when evaluated in a feature `f' of class `c'.
		do
			Result := ast_type [[a.index, w.class_id, f.rout_id_set.first, c.class_id]]
		end

feature {NONE} -- Type checking

	type_checker: AST_FEATURE_CHECKER_GENERATOR
			-- Type checker.
		once
			create Result
		end

feature {NONE} -- Timing

	start_time: DATE_TIME
			-- Moment of analysis start.

	finish_time: DATE_TIME
			-- Moment of analysis finish.

feature {NONE} -- Statistics

	analysed_features: NATURAL_32
			-- Total number of the features analysed so far.

	progress_total: like {CLASS_C}.feature_table.count
			-- Total number of features to process.

	progress_current: like progress_total
			-- Number of features having been processed.

feature {NONE} -- Storage

	dictionary: ALIAS_ANALYZER_DICTIONARY_NATURAL_64
			-- Dictionary of used entities.

	keeper: AST_COLLECTION_KEEPER
			-- Collection of keepers.

feature {NONE} -- Client callback

	update_agent: PROCEDURE [ANY , TUPLE [ANY]]
			-- Procedure to update current status.

feature {ES_ALIAS_ANALYSIS_TOOL_PANEL} -- Output

	report_to (o: STRING_32)
			-- Report results of the analysis to `o'.
		deferred
		end

	report_statistics_to (o: STRING_32)
			-- Report statistics of the analysis to `o'.
		do
			if is_timeout then
				o.append_string ({STRING_32} "Analysis timed out.%N")
			elseif is_stop_requested then
				o.append_string ({STRING_32} "Analysis terminated by user.%N")
			end
			o.append_string ({STRING_32} "Total processed features: ")
			o.append_natural_32 (analysed_features)
			if progress_total > 0 then
				o.append_string ({STRING_32} "%NBatch processing progress: ")
				o.append_integer ((progress_current * 100) // progress_total)
			end
			o.append_string ({STRING_32} "%NElapsed time (seconds): ")
			o.append_integer_64 (finish_time.relative_duration (start_time).seconds_count)
		end

note
	date: "$Date$"
	revision: "$Revision$"
	copyright: "Copyright (c) 1984-2015, Eiffel Software"
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
