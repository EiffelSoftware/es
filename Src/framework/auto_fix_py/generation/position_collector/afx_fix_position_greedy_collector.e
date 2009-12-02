note
	description: "[
		Given a context class and an exception position, greedy collector collects every position along the execution path from feature entry to exception position.
		If the exception position is in a condition branch (e.g. if-, elseif-, when-, or else-), only the position in that branch (till exception position) will be collected.
		If it is in a loop (body, variant, or invariant), everything inside that loop would be collected.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_POSITION_GREEDY_COLLECTOR

inherit

    AFX_FIX_POSITION_COLLECTER_I
    	redefine
    	    is_ready_to_collect
    	end

	AST_ITERATOR
		redefine
--		    	-- feature
--			process_feature_as,

		    	-- basic instructions
			process_assign_as,
			process_assigner_call_as,
			process_creation_as,
			process_instr_call_as,
			process_check_as,

		    	-- expressions
			process_inline_agent_creation_as,
			process_variant_as,
			process_tagged_as,
			process_object_test_as,
			process_nested_as,

				-- constructs
			process_eiffel_list,
			process_if_as,
			process_inspect_as,
			process_loop_as

				-- no special process needed
			-- process_debug_as
		end

feature -- Setting up

	config (a_feature: attached like context_feature; an_exception_position: attached like exception_position)
			-- <Precursor>
		do
    	    context_feature := a_feature
    	    exception_position := an_exception_position
    	    exception_ast := an_exception_position.breakpoint_info.ast
    	ensure then
    	    exception_ast_not_void: exception_ast /= Void
		end

feature -- Collect

    collect_fix_positions
    		-- <Precursor>
    	do
			has_found := False
			create fix_positions.make_default

    	    safe_process (context_feature)

				-- detach `fix_positions' from the result
			last_collection := fix_positions
			fix_positions := Void
    	end

feature -- Access

    context_feature: detachable FEATURE_AS
    		-- the class where the exception happened and the fixes are to be applied

    exception_position: detachable AFX_EXCEPTION_CALL_STACK_FRAME_I
    		-- the position of the exception to be fixed

	exception_ast: detachable AST_EIFFEL
    		-- the ast containing the exception point

	last_collection: detachable DS_ARRAYED_LIST[AFX_FIX_POSITION]
			-- <Precursor>

feature -- Status report

	is_ready_to_collect: BOOLEAN
			-- <Precursor>
		do
		    Result := Precursor and then exception_ast /= Void
		end

feature{NONE} -- implementation

	is_exception_ast (l_as: detachable AST_EIFFEL): BOOLEAN
			-- if `l_as' is the `exception_ast'
		require
		    is_ready_to_collect: is_ready_to_collect
		do
		    Result := exception_ast.equivalent (l_as, exception_ast)
		    		and then exception_ast.start_position = l_as.start_position
		end

	check_position (a_as: detachable AST_EIFFEL)
			-- check if `a_as' is the exception ast we are looking for, set the `has_found' flag if yes.
		require
		    is_ready_to_collect: is_ready_to_collect
		do
			if is_exception_ast (a_as) then
		    	has_found := True
			end
		end

	has_found: BOOLEAN
			-- have we already found the instruction-level ast node?

	fix_positions: like last_collection
			-- storage for the collected fix positions

	loop_depth: INTEGER
			-- the depth of us inside loops

feature{NONE} -- Process features

--	process_feature_as (l_as: FEATURE_AS)
--			-- select the feature with right name to look into
--		local
--		    l_expected_feature_name: STRING
--		    l_current_feature_names: EIFFEL_LIST [FEATURE_NAME]
--		    l_a_name: STRING
--		    l_is_matching: BOOLEAN
--		do
--		    if not (has_found or l_as.is_attribute or l_as.is_constant) then
--    		    l_expected_feature_name := exception_position.routine_name
--    			l_current_feature_names := l_as.feature_names

--    			from l_current_feature_names.start
--    			until l_current_feature_names.after or l_is_matching
--    			loop
--    			    l_a_name := l_current_feature_names.item_for_iteration.visual_name
--    			    if l_expected_feature_name ~ l_a_name then
--    			        l_is_matching := True
--    			    end

--    			    l_current_feature_names.forth
--    			end

--    			if l_is_matching then
--    			    safe_process (l_as.body)
--    			end
--		    end
--		end

feature{NONE} -- Process basic insturctions

	collect_as (l_as: INSTRUCTION_AS)
			-- collect `l_as' into `fix_positions'
		local
		    l_pos: AFX_FIX_POSITION
		do
	        create l_pos.make (exception_position, l_as)
	        fix_positions.force_last (l_pos)
		end

	process_assign_as (l_as: ASSIGN_AS)
		do
		    if not has_found then
		        collect_as (l_as)

		        check_position (l_as)
		        Precursor (l_as)
		    end
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		do
		    if not has_found then
		        collect_as (l_as)

		        check_position (l_as)
		        Precursor (l_as)
		    end
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
		    if not has_found then
		        collect_as (l_as)

		        check_position (l_as)
		        Precursor (l_as)
		    end
		end

	process_creation_as (l_as: CREATION_AS)
		do
		    if not has_found then
		        collect_as (l_as)

		        check_position (l_as)
		        Precursor (l_as)
		    end
		end

	process_check_as (l_as: CHECK_AS)
		do
		    if not has_found then
		        collect_as (l_as)

		        check_position (l_as)
		        Precursor (l_as)
		    end
		end

feature{NONE} -- Process expressions

	process_variant_as (l_as: VARIANT_AS)
		do
		    if not has_found then
    			check_position (l_as)
    			Precursor(l_as)
		    end
		end

	process_tagged_as (l_as: TAGGED_AS)
		do
		    if not has_found then
    			check_position (l_as)
    			Precursor(l_as)
		    end
		end

	process_object_test_as (l_as: OBJECT_TEST_AS)
		do
		    if not has_found then
    			check_position (l_as)
    			Precursor(l_as)
		    end
		end

	process_nested_as (l_as: NESTED_AS)
		do
		    if not has_found then
    			check_position (l_as)
    			Precursor(l_as)
		    end
		end

	process_inline_agent_creation_as (l_as: INLINE_AGENT_CREATION_AS)
		do
		    if not has_found then
    			check_position (l_as)
    			Precursor(l_as)
		    end
		end

feature{NONE} -- Process constructs

	process_eiffel_list (l_as: EIFFEL_LIST [AST_EIFFEL])
			-- process each item in the list until `has_found'
		local
		    l_cursor: INTEGER
		do
		    if not has_found then
       			from
       				l_cursor := l_as.index
       				l_as.start
       			until
       				l_as.after or has_found
       			loop
       				safe_process (l_as.item)

       				l_as.forth
       			end
       			l_as.go_i_th (l_cursor)
		    end
		end

	process_if_as (l_as: IF_AS)
		local
		    l_elsif: detachable ELSIF_AS
		    l_global_collection: like fix_positions
		    l_local_collection: like fix_positions
		    l_compounds: DS_ARRAYED_LIST[EIFFEL_LIST [INSTRUCTION_AS]]
		do
				-- collect position of if-as, if exception was raised in if-condition, or elseif-conditions
		    if not has_found then
		        collect_as (l_as)

		        check_position (l_as)
		        safe_process (l_as.condition)
		    end
		    if not has_found and then attached l_as.elsif_list as l_elseif_list then
   			    from l_elseif_list.start
   			    until l_elseif_list.after or has_found
   			    loop
   			        l_elsif := l_elseif_list.item_for_iteration

   			        check_position (l_elsif)
   			        safe_process (l_elsif.expr)

   			        l_elseif_list.forth
   			    end
		    end

				-- process separate branches of if-as
			if not has_found then
    		    	-- collect all instruction lists into `l_compounds'
    		    	-- including those in if-part, elseif-list, and else-part
    		    create l_compounds.make_default
    		    l_compounds.force_last (l_as.compound)
    		    if attached l_as.elsif_list as l_elseif_list2 then
       			    from l_elseif_list2.start
       			    until l_elseif_list2.after
       			    loop
       			        l_elsif := l_elseif_list2.item_for_iteration
       			        l_compounds.force_last (l_elsif.compound)

       			        l_elseif_list2.forth
       			    end
    		    end
    		    if attached l_as.else_part as l_else then
    		        l_compounds.force_last (l_else)
    		    end

    		    	-- backup the global collection so far
        		l_global_collection := fix_positions
        		fix_positions := Void
        		create l_local_collection.make_default

    				-- go through each compound to collect
    			from l_compounds.start
    			until l_compounds.after or has_found
    			loop
    		    		-- create a list for nested collection
        		    create fix_positions.make_default

    				safe_process (l_compounds.item_for_iteration)

    					-- record all positions traversed in this branch, in case the whole `if_as' should be collected
    				l_local_collection.append_last (fix_positions)

    			    l_compounds.forth
    			end

   				if has_found then
          			l_global_collection.append_last (fix_positions)
          		else
          		    l_global_collection.append_last (l_local_collection)
   				end

    				-- restore the global collection
       			fix_positions := l_global_collection
			end
		end

	process_inspect_as (l_as: INSPECT_AS)
		local
		    l_global_collection: like fix_positions
		    l_local_collection: like fix_positions
		    l_compounds: DS_ARRAYED_LIST[EIFFEL_LIST [INSTRUCTION_AS]]
		do
				-- collect position of inspect-as, if exception was raised in inspect-expression
		    if not has_found then
		        collect_as (l_as)

		        check_position (l_as)
		        safe_process (l_as.switch)
		    end

				-- process separate branches of inspect-as
			if not has_found then
    		    	-- collect all instruction lists into `l_compounds'
    		    	-- including those in when-parts and in else-part
    		    create l_compounds.make_default
    		    if attached l_as.case_list as l_case_list then
       			    from l_case_list.start
       			    until l_case_list.after
       			    loop
       			        l_compounds.force_last (l_case_list.item_for_iteration.compound)
       			        l_case_list.forth
       			    end
    		    end
    		    if attached l_as.else_part as l_else then
    		        l_compounds.force_last (l_else)
    		    end

    		    	-- backup the global collection so far
        		l_global_collection := fix_positions
        		fix_positions := Void
        		create l_local_collection.make_default

    				-- go through each compound to collect
    			from l_compounds.start
    			until l_compounds.after or has_found
    			loop
    		    		-- create a list for nested collection
        		    create fix_positions.make_default

    				safe_process (l_compounds.item_for_iteration)

    					-- record all positions traversed in this branch, in case the whole `if_as' should be collected
    				l_local_collection.append_last (fix_positions)

    			    l_compounds.forth
    			end

   				if has_found then
          			l_global_collection.append_last (fix_positions)
          		else
          		    l_global_collection.append_last (l_local_collection)
   				end

    				-- restore the global collection
       			fix_positions := l_global_collection
			end
		end

	process_loop_as (l_as: LOOP_AS)
		local
		    l_global_collection: like fix_positions
		    l_local_collection: like fix_positions
		    l_exp_count: INTEGER
		    l_exp_list: EIFFEL_LIST[AST_EIFFEL]
		    l_compounds: ARRAYED_LIST[EIFFEL_LIST [INSTRUCTION_AS]]
		    l_complete_collector: AFX_FIX_POSITION_COMPLETE_COLLECTOR
		do
	        l_global_collection := fix_positions

		    if not has_found then
		        create fix_positions.make_default
		        safe_process (l_as.from_part)

    		    if has_found then
    		    	l_global_collection.append_last (fix_positions)
    		    else
    				loop_depth := loop_depth + 1

    		        collect_as (l_as)

    		        	-- check until-exp, invariant, and variant
    		        	-- reserve 2 slots for until-exp and variant
    		        if attached l_as.invariant_part as l_inv then
    		            l_exp_count := l_inv.count + 2
    		        else
    		            l_exp_count := 2
    		        end

    		        create l_exp_list.make (l_exp_count)
    		        if attached l_as.stop as l_stop then l_exp_list.force (l_stop) end
    		        if attached l_as.invariant_part as l_inv2 then l_exp_list.append (l_as.invariant_part) end
    		        if attached l_as.variant_part as l_var then l_exp_list.force (l_var) end

    		        safe_process (l_exp_list)

    			    safe_process (l_as.compound)

    		        if has_found then
    		        	if loop_depth = 1  then
    		        	    	-- complete collection
    		        	    create l_complete_collector
    		        	    l_complete_collector.config (context_feature, exception_position, l_as)
    		        	    l_complete_collector.collect_fix_positions
    		        	    fix_positions := l_complete_collector.last_collection

    		        	    	-- collect all positions in the loop
    		        	    l_global_collection.append_last (fix_positions)
    		        	else
    		        	    -- loop_depth > 1
    		        	    -- do nothing, since everything will be collected at loop_depth 1
    		        	end
    		        else
    		            	-- in this case, fix_position should have collected all positions inside loop
    	    		    l_global_collection.append_last (fix_positions)
    		        end

        			loop_depth := loop_depth - 1
    		    end
		    end

	        fix_positions := l_global_collection
		end


note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
