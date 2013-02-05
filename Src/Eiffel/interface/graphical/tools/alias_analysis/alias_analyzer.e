note
	description: "The engine of alias analysis framework."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ALIAS_ANALYZER

inherit
	AST_ITERATOR
		redefine
			process_access_feat_as,
			process_assign_as,
			process_attribute_as,
			process_bin_eq_as,
			process_bin_ne_as,
			process_case_as,
			process_creation_as,
			process_creation_expr_as,
			process_current_as,
			process_debug_as,
			process_do_as,
			process_eiffel_list,
			process_elseif_as,
			process_expr_call_as,
			process_guard_as,
			process_if_as,
			process_inspect_as,
			process_loop_as,
			process_nested_as,
			process_nested_expr_as,
			process_once_as,
			process_result_as,
			process_routine_as,
			process_void_as
		end

	DEBUG_OUTPUT

	INTERNAL_COMPILER_STRING_EXPORTER

	SHARED_AST_CONTEXT

	SHARED_EIFFEL_PROJECT

	SHARED_ERROR_HANDLER
		rename
			error_handler as ast_error_handler
		end

	SHARED_WORKBENCH

create
	make

feature {NONE} -- Creation

	make
			-- Initialize analyser.
		do
			create dictionary.make
			create keeper.make (any_aliases)
			create ast_type.make (0)
			create ast_alias_after.make (0)
			create ast_alias_before.make (0)
			create {ARRAYED_STACK [INTEGER_32]} bodies.make (0)
			create modified_attributes.make (0)
			create start_time.make_now_utc
			create finish_time.make_now_utc
		end

feature -- Basic operations

	process_class (c: CLASS_C; output: like output_agent)
			-- Perform analysis on the class `c'.
		do
			if attached c.feature_table as t then
				progress_total := t.count
				output_agent := output
				prepare_analysis (c)
				progress_total := t.count
				from
					t.start
				until
					t.after
				loop
					analyze_feature (True, t.item_for_iteration, c)
					progress_current := progress_current + 1
					t.forth
				end
				report_result
			end
		end

	process_feature (f: FEATURE_I; c: CLASS_C; output: like output_agent)
			-- Perform analysis on the feature `f' from the class `c'.
		do
			progress_total := 0
			output_agent := output
			prepare_analysis (c)
			analyze_feature (True, f, c)
			report_result
		end

feature -- Status report

	is_inherited_assertion_included: BOOLEAN
			-- Does the analysis include inherited assertions?

	is_frame_check: BOOLEAN
			-- Does the analysis check frame rule?

	is_done: BOOLEAN
			-- Is analysis over?

	is_update_required: BOOLEAN
			-- Should the client get an update on the current status?

	analysed_features: NATURAL_32
			-- Total number of the features analysed so far.

feature -- Status setting

	set_is_inherited_assertion_included (v: BOOLEAN)
			-- Set `is_inherited_assertion_included' to `v'.
		do
			is_inherited_assertion_included := v
		ensure
			is_inherited_assertion_included_set: is_inherited_assertion_included = v
		end

	set_is_frame_check  (v: BOOLEAN)
			-- Set `is_frame_check' to `v'.
		do
			is_frame_check := v
		ensure
			is_frame_check_set: is_frame_check = v
		end

feature {NONE} -- Analysis

	prepare_analysis (c: CLASS_C)
			-- Prepare analyzer to process `c'.
		do
			start_time.make_now_utc
			context.initialize (c, c.actual_type)
			create dictionary.make
			error_handler.wipe_out
			if attached {ES_ERROR_DISPLAYER} eiffel_project.error_displayer as d then
				d.clear (uuid)
			end
			ast_type.wipe_out
			ast_alias_after.wipe_out
			ast_alias_before.wipe_out
			bodies.wipe_out
				-- Initialize type checker.
			type_checker.init (context)
			type_checker.set_type_recorder (agent record_node_type)
				-- Initialize relation information.
			create keeper.make (any_aliases)
			-- context.add_keeper (keeper)
				-- Initialize attribute information.
			modified_attributes.wipe_out
			dictionary.add_current
			target := dictionary.last_added
			is_done := False
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

	analyze_feature (is_root: BOOLEAN; f: FEATURE_I; c: CLASS_C)
			-- Perform analysis on the feature `f' from the class `c'.
		local
			q: BOOLEAN
			old_current_class: CLASS_C
			old_current_feature: FEATURE_I
			old_written_class: CLASS_C
			old_locals: like {AST_CONTEXT}.locals
			s: GENERIC_SKELETON
			i: like {GENERIC_SKELETON}.count
		do
			update
			old_current_class := context.current_class
			old_current_feature := context.current_feature
			old_written_class := context.written_class
			old_locals := context.locals.twin
			context.clear_feature_context
			context.initialize (c, c.actual_type)
			context.set_current_feature (f)
			context.set_written_class (f.written_class)
			bodies.put (f.body_index)
			type_checker.type_check_only (f, True, f.written_in /= c.class_id, f.is_replicated)
				-- Check if attributes need to be initialized.
			if is_root then
					-- Check if the current feature is a creation procedure.
				if
	--				is_creation_checked and then
					attached c.creators as creators and then creators.has (f.feature_name) or else
					c.creation_feature /= Void and then c.creation_feature.feature_id = f.feature_id
				then
						-- Attributes are set to the default values.
				else
						-- Attributes can be set to anything.
					from
						s := c.skeleton
						i := s.count
					until
						i <= 0
					loop
						if attached c.feature_of_feature_id (s [i].feature_id) as a then
								-- Register an attribute `a' in a dictionary.
							register_attribute (a, c)
								-- Assume that the attribute can be aliased to anything
							keeper.relation.add_any (last_item)
						end
						i := i - 1
					end
				end
			end
			add_locals
			q := is_qualified
			is_qualified := False
			f.body.process (Current)
			is_qualified := q
			remove_locals
			bodies.remove
			context.initialize (old_current_class, old_current_class.actual_type)
			context.set_current_feature (old_current_feature)
			context.set_written_class (old_written_class)
			context.set_locals (old_locals)
			analysed_features := analysed_features + 1
		end

	report_result
			-- Report results of the analysis.
		do
			is_done := True
			if attached {ES_ERROR_DISPLAYER} eiffel_project.error_displayer as d then
				if error_handler.has_error then
					d.trace_errors ({ENVIRONMENT_CATEGORIES}.compilation, uuid, error_handler)
				end
				if error_handler.has_warning then
					d.trace_warnings ({ENVIRONMENT_CATEGORIES}.compilation, uuid, error_handler)
				end
			end
		end

	update
			-- Report current analysis status.
		do
			if is_update_required then
					-- Record current time.
				finish_time.make_now_utc
					-- Update client about current results.
				output_agent.call (Void)
					-- Postpone update for a while.
				is_update_required := False
			end
		end

feature {NONE} -- Visitor

	process_access_feat_as (a: ACCESS_FEAT_AS)
			-- <Precursor>
		local
			old_target: like target
			t: like target
		do
			if a.is_local then
					-- Local variable.
				if
					attached context.locals.item (a.feature_name.name_id) as i and then
					not i.type.is_expanded
				then
					register_local (i)
				else
					last_item := dictionary.non_void_index
				end
			elseif a.is_argument then
					-- Feature argument.
				if
					attached context.current_feature.arguments.i_th (a.argument_position) as i and then
					not i.is_expanded
				then
					register_argument (a.argument_position)
				else
					last_item := dictionary.non_void_index
				end
			elseif a.is_object_test_local then
					-- Object test local.
				last_item := dictionary.non_void_index
			else
					-- Feature call.
				if not is_qualified then
					if attached context.current_class.feature_of_rout_id (a.routine_ids.first) as f then
							-- Feature.
						if f.is_attribute then
								-- Attribute.
							if not f.type.is_expanded then
								if f.type.is_initialization_required and then attached {ATTRIBUTE_I} f as r and then r.has_body and then not bodies.has (r.body_index) then
									analyze_feature (False, f, context.current_class)
								end
								register_attribute (f, context.current_class)
							else
								last_item := dictionary.non_void_index
							end
						elseif f.is_routine then
								-- Routine.
								-- TODO: use AST index and context class to detect recursive calls.
							if
--								bodies.has (f.body_index)
--								and then
								attached node_alias_before (a, context.written_class, context.current_feature, context.current_class) as r
--								and then
--								r.is_equal (keeper.relation)
							then
									-- TODO: handle recursive calls.
									-- Retrieve recorded relation.
								if
									r.is_equal (keeper.relation) and then
									attached node_alias_after (a, context.written_class, context.current_feature, context.current_class) as o
 								then
										-- Use previously recorded relation.
									keeper.relation.copy (o)
--								else
--										-- Remove all the pairs.
--									keeper.relation.wipe_out
--										-- Add predefined entries.
--									keeper.relation.add_any (dictionary.void_index)
--									keeper.relation.add_any (dictionary.non_void_index)
								end
							else
									-- This feature has not been processed yet or has been processed but the aliases before the call are different from the previous call.
									-- Record  alias relation before the call.
								record_node_alias_before (keeper.relation, a, context.written_class, context.current_feature, context.current_class)
									-- TODO: process arguments.
									-- Recurse only when alias relation before the call is different from already evaluated one.
								analyze_feature (False, f, context.current_class)
									-- Record  alias relation after the call.
								record_node_alias_after (keeper.relation, a, context.written_class, context.current_feature, context.current_class)
							end
							if not f.type.is_expanded and then not f.type.is_void then
									-- Set `last_item' to the feature result.
								dictionary.add_result (f, context.current_class)
								last_item := dictionary.last_added
							else
								last_item :=dictionary.non_void_index
							end
						end
					else
						last_item := dictionary.non_void_index
					end
				else
					if
						attached system.class_of_id (a.class_id) as c and then
						attached c.feature_of_rout_id (a.routine_ids.first) as f and then
						not f.type.is_expanded
					then
						if f.is_attribute then
								-- Attribute.
							register_attribute (f, c)
							dictionary.add_qualification (target, last_item)
							last_item := dictionary.last_added
							if dictionary.is_overqualified then
								keeper.relation.add_any (last_item)
							end
						elseif f.is_routine then
								-- Routine.
								-- TODO: handle recursive calls.
							if not bodies.has (f.body_index) then
									-- This feature has not been processed yet.
									-- Evaluate routine body.
								old_target := target
								t := last_item
								target := t
								dictionary.add_reverse (t)
									-- Replace current relation "A" with "t'.A".
								keeper.relation.copy (keeper.relation.mapped (agent qualified (dictionary.last_added, ?)))
									-- TODO: process arguments.
								analyze_feature (False, f, c)
									-- Replace current relation "A" with "t.A".
								keeper.relation.copy (keeper.relation.mapped (agent qualified (t, ?)))
								target := old_target
							end
								-- Set `last_item' to the feature result.
							dictionary.add_result (f, context.current_class)
							last_item := dictionary.last_added
						end
					else
						last_item := dictionary.non_void_index
					end
				end
			end
		end

	process_assign_as (a: ASSIGN_AS)
		local
			s: like last_item
			t: like last_item
		do
			a.target.process (Current)
			t := last_item
			if t > 0 then
					-- Found the target of the assignment.
				a.source.process (Current)
				s := last_item
				if s > 0 then
						-- Found the source of the assignment.
					if s = dictionary.non_void_index then
							-- The source is a new object that cannot have any aliases.
						keeper.relation.add_pair (s, t)
					elseif t /= dictionary.non_void_index then
							-- TODO: remove protection when all targets are processed correctly.
							-- The source may have aliases.
						attach (s, t)
					end
				end
			end
		end

	process_bin_eq_as (a: BIN_EQ_AS)
			-- <Precursor>
		local
			l: like last_item
			r: like last_item
		do
			if
				attached {BIN_TILDE_AS} a or else
				attached node_type (a.left, context.written_class, context.current_feature, context.current_class) as tl and then not tl.is_reference or else
				attached node_type (a.right, context.written_class, context.current_feature, context.current_class) as tr and then not tr.is_reference
			then
					-- Skip tilda expressions and those that are of expanded type.
			else
				a.left.process (Current)
				l := last_item
				if l > 0 then
					a.right.process (Current)
					r := last_item
					if r > 0 and then l /= r then
						if keeper.relation.has_pair (l, r) then
							if attached {BIN_NE_AS} a then
									-- This is a case of "cut" instruction.
								keeper.relation.remove_pair (l, r)
							else
									-- This is a case of "bind" instruction.
							end
						else
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
			end
		end

	process_bin_ne_as (a: BIN_NE_AS)
			-- <Precursor>
		do
			process_bin_eq_as (a)
		end

	process_creation_as (a: CREATION_AS)
			-- <Precursor>
		local
			t: like last_item
			q: BOOLEAN
			old_target: like target
		do
			old_target := target
				-- Compute the target.
			last_item := 0
			a.target.process (Current)
			t := last_item
				-- Process the call.
			q := is_qualified
			is_qualified := True
			target := t
			safe_process (a.call)
			target := old_target
			is_qualified := q
				-- Adjust aliasing for the target.
			if t > 0 then
					-- Remove all relations for `t'.
				keeper.relation.remove (t)
					-- Add a pair to indicate that it is now attached to a non-void value.
				keeper.relation.add_pair (t, dictionary.non_void_index)
			end
		end

	process_current_as (a: CURRENT_AS)
			-- <Precursor>
		do
			dictionary.add_current
			last_item := dictionary.last_added
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
			if not context.current_feature.type.is_expanded then
				dictionary.add_result (context.current_feature, context.current_class)
				last_item := dictionary.last_added
			end
		end

	process_routine_as (a: ROUTINE_AS)
			-- <Precursor>
		local
			t: TYPE_A
			r: like keeper.relation
			s: like {CLASS_C}.skeleton
			i:  like {CLASS_C}.skeleton.count
			l: like modified_attributes.item_for_iteration
			k: like modified_attributes.key_for_iteration
		do
				-- Register "Result".
			t := context.current_feature.type
			if not t.is_void then
				register_attribute (context.current_feature, context.current_class)
				set_default_aliases (t)
			end
			safe_process (a.precondition)
			if is_frame_check then
				r := keeper.relation.twin
			end
			a.routine_body.process (Current)
			if attached r and then attached context.current_class as c then
				from
					s := c.skeleton
					i := s.count
				until
					i <= 0
				loop
					if attached c.feature_of_feature_id (s [i].feature_id) as f then
							-- Register an attribute `a' in a dictionary.
						register_attribute (f, c)
							-- Compare old and new aliases of the attribute.
						if r.table [last_item] /~ keeper.relation.table [last_item] then
							k := [context.current_feature.rout_id_set.first, context.current_class.class_id]
							l := modified_attributes [k]
							if not attached l then
								create l.make (1)
								modified_attributes [k] := l
							end
							l.force (f.feature_name_32)
						end
					end
					i := i - 1
				end
			end
			safe_process (a.postcondition)
				-- TODO: Handle rescue clause.
			process_compound (a.rescue_clause)
		end

	process_void_as (a: VOID_AS)
			-- <Precursor>
		do
			last_item := dictionary.void_index
		end

feature {AST_EIFFEL} -- Visitor: routine

	process_do_as (a: DO_AS)
			-- <Precursor>
		do
			process_compound (a.compound)
		end

	process_once_as (a: ONCE_AS)
			-- <Precursor>
		do
			process_compound (a.compound)
		end

	process_attribute_as (a: ATTRIBUTE_AS)
			-- <Precursor>
		do
			process_compound (a.compound)
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

	process_loop_as (a: LOOP_AS)
		local
			invariant_as: like {LOOP_AS}.invariant_part
			variant_as: like {LOOP_AS}.variant_part
			exit_as: like {LOOP_AS}.stop
			i: INTEGER
		do
			safe_process (a.iteration)
			safe_process (a.from_part)
				-- Compute aliases for the loop invariant, variant, exit condition and compound
				-- in a loop that computes new attachment information at every iteration.
			keeper.enter_realm
			from
				invariant_as := a.invariant_part
				variant_as := a.variant_part
				exit_as := a.stop
				check
					has_at_least_one_iteration: not keeper.is_sibling_dominating
				end
				i := 3
			until
				keeper.is_sibling_dominating or else i <= 0
			loop
					-- TODO: remove iteration limit.
				i := i - 1
					-- Record most recent scope information before the loop, so that
					-- it can be compared with the information after the loop on next iteration.
				keeper.update_sibling
				if attached invariant_as then
						-- Type check the invariant loop
					keeper.enter_realm
					invariant_as.process (Current)
					keeper.leave_optional_realm
				end
				if attached variant_as then
						-- Type check th variant loop
					variant_as.process (Current)
				end
					-- Type check the exit test.
				if exit_as /= Void then
					exit_as.process (Current)
				end
				if attached a.compound as c then
					process_compound (c)
				end
			end
			keeper.leave_realm
		end

feature {AST_EIFFEL} -- Visitor: nested call

	process_creation_expr_as (a: CREATION_EXPR_AS)
		local
			q: BOOLEAN
		do
			a.type.process (Current)
			q := is_qualified
			is_qualified := True
			safe_process (a.call)
			is_qualified := q
				-- TODO: add a temporary local for the new object
		end

	process_nested_expr_as (a: NESTED_EXPR_AS)
		local
			q: BOOLEAN
			old_target: like target
		do
			q := is_qualified
			a.target.process (Current)
			if dictionary.has_index (last_item) and then dictionary.non_void_index /= last_item then
					-- TODO: get rid of all the cases that do not compute the target.
				is_qualified := True
				old_target := target
				target := last_item
				a.message.process (Current)
				target := old_target
				is_qualified := q
			end
		end

	process_nested_as (a: NESTED_AS)
		local
			q: BOOLEAN
			old_target: like target
		do
			q := is_qualified
			a.target.process (Current)
			if dictionary.has_index (last_item) and then dictionary.non_void_index /= last_item then
					-- TODO: get rid of all the cases that do not compute the target.
				is_qualified := True
				old_target := target
				target := last_item
				a.message.process (Current)
				target := old_target
				is_qualified := q
			end
		end

	process_eiffel_list (a: EIFFEL_LIST [AST_EIFFEL])
		local
			q: BOOLEAN
		do
			q := is_qualified
			is_qualified := False
			Precursor (a)
			is_qualified := q
		end

feature {NONE} -- Entity access

	add_locals
			-- Record which locals are initialized to void and non-void values.
		do
			if attached context.locals as l then
				across
					l as i
				loop
						-- Register a local in a dictionary.
					register_local (i.item)
						-- Associate it with the default values.
					set_default_aliases (i.item.actual_type)
				end
			end
			if attached context.current_feature.arguments as a then
				across
					a as i
				loop
						-- Register an argument in a dictionary.
					register_argument (i.cursor_index)
					set_default_aliases (i.item)
						-- Assume that an argument can have an arbitrary value.
					keeper.relation.add_any (last_item)
				end
			end
		end

	remove_locals
			-- Remove any records about locals and arguments.
		do
			if attached context.locals as l then
				across
					l as i
				loop
						-- Get an entry for the local in the dictionary.
					register_local (i.item)
						-- Remove it from the relation.
					remove_prefixed (last_item)
				end
			end
			if attached context.current_feature.arguments as a then
				across
					a as i
				loop
						-- Get an entry for the argument in the dictionary.
					register_argument (i.cursor_index)
						-- Remove it from the relation.
					remove_prefixed (last_item)
				end
			end
		end

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

	set_default_aliases (t: TYPE_A)
			-- Associate `last_item' with the default aliases according to its type `t'.
		do
				-- Check if the element is void or non-void by default.
			if not t.is_reference then
					-- Add a pair "[variable, NonVoid]".
				keeper.relation.add_pair (dictionary.non_void_index, last_item)
			end
			if not t.is_attached then
					-- Attach "Void" to "variable".
				attach (dictionary.void_index, last_item)
			end
		end

feature {NONE} -- Access

	last_item: like dictionary.last_added
			-- Last found item.

	target: like last_item
			-- Current target of a call.

feature {ES_ALIAS_ANALYSIS_TOOL_PANEL} -- Output

	report: STRING_32
			-- Results of the analysis.
		do
			create Result.make_empty
			report_to (Result)
		end

	report_to (o: STRING_32)
			-- Report results of the analysis to `o'.
		local
			d: STRING_32
		do
			if is_frame_check then
				across
					modified_attributes as f
				loop
					if attached system.class_of_id (f.key.class_id) as c then
						o.append_character ('{')
						o.append_string (c.name)
						o.append_character ('}')
						o.append_character ('.')
						o.append_string (c.feature_of_rout_id (f.key.routine_id).feature_name_32)
						d := {STRING_32} ": "
						across
							f.item as a
						loop
							o.append_string (d)
							d := once {STRING_32} ", "
							o.append_string (a.item)
						end
						o.append_character ('%N')
					end
				end
			else
				o.append_string (debug_output)
			end
		end

	report_statistics_to (o: STRING_32)
			-- Report statistics of the analysis to `o'.
		do
			o.append_string ({STRING_32} "Total processed features: ")
			o.append_natural_32 (analysed_features)
			o.append_string ({STRING_32} "%NNumber of different expressions: ")
			o.append_integer (dictionary.count)
			o.append_string ({STRING_32} "%NElapsed time (seconds): ")
			o.append_integer_64 (finish_time.relative_duration (start_time).seconds_count)
		end

feature {NONE} -- Statistics

	start_time: DATE_TIME
			-- Moment of analysis start.

	finish_time: DATE_TIME
			-- Moment of analysis finish.

	progress_total: like {CLASS_C}.feature_table.count
			-- Total number of features to process.

	progress_current: like progress_total
			-- Number of features having been processed.

feature {NONE} -- Output

	debug_output: STRING
			-- <Precursor>
		local
			a: SEARCH_TABLE [INTEGER_32]
			s: STRING
			t: detachable STRING
		do
			if t = Void then
				create Result.make_empty
					-- First item is not delimited with anything.
				t := ""
				across
					keeper.relation.table as i
				loop
						-- Output alias for `i.key' in a format "x: a, b, c".
					Result.append_string (t)
					Result.append_string (dictionary.name (i.key))
					s := ": "
					a := i.item
					if a.is_empty then
						Result.append_string (s)
						Result.append_string ("any")
					else
						from
							a.start
						until
							a.after
						loop
							Result.append_string (s)
							Result.append_string (dictionary.name (a.item_for_iteration))
							s := ", "
							a.forth
						end
					end
						-- Set delimiter for next items.
					t := "%N"
				end
			end
		rescue
			Result.append_string ("%NFailed with exception " + (create {EXCEPTION_MANAGER}).last_exception.out)
			retry
		end

feature {NONE} -- Storage

	dictionary: ALIAS_ANALYZER_DICTIONARY_NATURAL_64
			-- Dictionary of used entities.

	dictionary1: ALIAS_ANALYZER_DICTIONARY
	dictionary2: ALIAS_ANALYZER_DICTIONARY_NATURAL_64
			-- Dictionaries for faster recompilation.

	keeper: ALIAS_ANALYZER_RELATION_KEEPER
			-- Keeper of alias relations.

	any_aliases: ARRAY [INTEGER_32]
			-- Predefined entries that are known to be aliased to anything.
		once
			Result := <<dictionary.void_index, dictionary.non_void_index>>
		end

	modified_attributes: HASH_TABLE
		[SEARCH_TABLE [STRING_32],
		TUPLE [routine_id: like {FEATURE_I}.rout_id_set.first; class_id: like {CLASS_C}.class_id]]
				-- List of attributes modified by a particular feature.

feature {NONE} -- Alias relation update

	attach (s, t: like last_item)
			-- Attach source `s' to target `t'.
		local
			d: like dictionary
			n: like last_item
			p: like keeper.relation.table.item
			r: like keeper.relation
			q: like keeper.relation
			table: like keeper.relation.table
		do
			d := dictionary
			r := keeper.relation
			table := r.table
			if s = t then
					-- Nothing changes.
					-- TODO: Report useless reattachment.
			elseif attached table [s] as a and then a.is_empty then
					-- Any items may be attached to a source.
					-- Remove `t' from all the associations.
				r.remove (t)
					-- `table [t]' is now Void.
					-- Set it to "any item" table.
				table [t] := a
			elseif not d.has_prefix (t, s) then
					-- Simple case: target has no relation to source.
					-- Remove all occurences of target.
					-- r' := r \- {target}
				r.remove (t)
					-- Make aliases of `s' to be aliases of `t'.
					-- r' := r' ∪ ((r' / s) × {t})
				if attached table [s] as a then
						-- Use aliases of `s' as aliases of `t'.
					table [t] := a.twin
						-- Alias target `t' with the aliases of `s'.
					from
						a.start
					until
						a.after
					loop
						p := table [a.item_for_iteration]
						if not p.is_empty then
							p.put (t)
						end
						a.forth
					end
				end
					-- Add one pair for `s' and `t'.
					-- r' := r' ∪ [t, s]
				r.add_pair (s, t)
			else
					-- r' = (r \- {t}) ∪ ((((r / s)  ∪ {s}) \- {t}) × {t})
					-- Apply dot completeness rules to r to be ready for removal of `t':
					-- Expand aliases that start with `t':
					-- 1) for every [t, x] and [t.a, u] add [x.a, u]
					-- 2) for every [t, x] and [x.a, u] add [t.a, u]
					-- 3) for every [t, x] when s = t.a.u add [t.a, x.a]
				if attached table [t] as ta then
					create q.make (any_aliases)
					 -- For every [t, x] and...
					across
						ta as x
					loop
							-- ... except for [t, Void] and [t, NonVoid] and ...
						if x.item /= d.non_void_index and then x.item /= d.void_index then
								-- 1) ... for every [t.a, u] add [x.a, u]
							across
								d.prefixed (t) as tp
							loop
								if attached table [tp.item] as tpa then
									across
										tpa as u
									loop
										d.add_qualification (x.item, d.suffix (t, tp.item))
										if dictionary.is_overqualified then
											q.add_any (d.last_added)
										end
										q.add_pair (d.last_added, u.item)
									end
								end
							end
								-- 2) ... [x.a, u] add [t.a, u]
							across
								d.prefixed (x.item) as xp
							loop
								if attached table [xp.item] as xpa then
									across
										xpa as u
									loop
										d.add_qualification (t, d.suffix (x.item, xp.item))
										if dictionary.is_overqualified then
											q.add_any (d.last_added)
										end
										q.add_pair (d.last_added, u.item)
									end
								end
							end
								-- 3) ... when s = t.a.u add [t.a, x.a]
							n := d.next_prefix (t, s)
							if d.has_index (n) then
								d.add_qualification (x.item, d.suffix (t, n))
								if dictionary.is_overqualified then
									q.add_any (d.last_added)
								end
								q.add_pair (n, d.last_added)
							end
						end
					end
					r.add_relation (q)
				end
					-- Compute p = ((r / s) ∪ {s}) \- {t}
				create p.make (0)
				if attached table [s] as ts then
					across
						ts as tsc
					loop
						if tsc.item /= t and then not d.has_prefix (t, tsc.item) then
							p.force (tsc.item)
						end
					end
				end
				if s /= t and then not d.has_prefix (t, s) then
					p.force (s)
				end
					-- Update r with r \- {t}
				remove_prefixed (t)
					-- Add all the pairs (((r / s) ∪ {s}) \- {t}) × {t}
				across
					p as pc
				loop
					r.add_pair (pc.item, t)
				end
			end
		end

	remove_prefixed (t: like last_item)
			-- Remove `t' and all the elements prefixed with `t' from the current relation,
			-- i.e. update r with r \- {t}, where r is `keeper.relation'.
		local
			r: like keeper.relation
		do
			r := keeper.relation
			r.remove (t)
			across
				dictionary.prefixed (t) as tp
			loop
				r.remove (tp.item)
			end
		end

feature {NONE} -- Mapping

	qualified (q: like last_item; v: like last_item): like last_item
			-- Item `v' with a qualifier `q'.
		do
			dictionary.add_qualification (q, v)
			Result := dictionary.last_added
			if dictionary.is_overqualified then
				keeper.relation.add_any (Result)
			end
		end

feature {NONE} -- Alias recording

	ast_alias_after: HASH_TABLE [like keeper.relation, TUPLE [a: INTEGER; w: INTEGER; f: INTEGER; c: INTEGER]]
			-- Aliases after AST node `a' written in class `w'
			-- when evaluated in a feature `f' of class `c'.

	ast_alias_before: HASH_TABLE [like keeper.relation, TUPLE [a: INTEGER; w: INTEGER; f: INTEGER; c: INTEGER]]
			-- Aliases before AST node `a' written in class `w'
			-- when evaluated in a feature `f' of class `c'.

	record_node_alias_after (t: like keeper.relation; a: AST_EIFFEL; w: CLASS_C; f: FEATURE_I; c: CLASS_C)
			-- Record aliases `t' after AST node `a' written in class `w'
			-- when evaluated in a feature `f' of class `c'.
		do
			if attached a then
				ast_alias_after [[a.index, w.class_id, f.rout_id_set.first, c.class_id]] := t
			end
		end

	record_node_alias_before (t: like keeper.relation; a: AST_EIFFEL; w: CLASS_C; f: FEATURE_I; c: CLASS_C)
			-- Record aliases `t' before AST node `a' written in class `w'
			-- when evaluated in a feature `f' of class `c'.
		do
			if attached a then
				ast_alias_before [[a.index, w.class_id, f.rout_id_set.first, c.class_id]] := t
			end
		end

	node_alias_after (a: AST_EIFFEL; w: CLASS_C; f: FEATURE_I; c: CLASS_C): detachable like keeper.relation
			-- Aliases after AST node `a' written in class `w'
			-- when evaluated in a feature `f' of class `c'.
		do
			Result := ast_alias_after [[a.index, w.class_id, f.rout_id_set.first, c.class_id]]
		end

	node_alias_before (a: AST_EIFFEL; w: CLASS_C; f: FEATURE_I; c: CLASS_C): detachable like keeper.relation
			-- Aliases before AST node `a' written in class `w'
			-- when evaluated in a feature `f' of class `c'.
		do
			Result := ast_alias_before [[a.index, w.class_id, f.rout_id_set.first, c.class_id]]
		end

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

feature {NONE} -- Output

	output_agent: PROCEDURE [ANY , TUPLE]
			-- Procedure to update current status.

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

feature {NONE} -- Recursion

	is_qualified: BOOLEAN
			-- Is qualified call being performed?

	bodies: STACK [INTEGER_32]
			-- Bodies that are being processed

feature {NONE} -- Type checking

	type_checker: AST_FEATURE_CHECKER_GENERATOR
			-- Type checker.
		once
			create Result
		end

note
	copyright: "Copyright (c) 2012-2013, Eiffel Software"
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
