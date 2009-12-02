note
	description: "Summary description for {AFX_FIX_POSITION_BASIC_COLLECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_POSITION_BASIC_COLLECTOR

inherit

    AFX_FIX_POSITION_COLLECTER_I
    	redefine
    	    is_ready_to_collect
    	end

	AST_ITERATOR
		redefine
--		    	-- features
--			process_feature_as,

		    	-- instructions
			process_assign_as,
			process_assigner_call_as,
			process_creation_as,
			process_instr_call_as,
			process_check_as,

				-- constructs
			process_if_as,
			process_elseif_as,
			process_inspect_as,
			process_loop_as,

				-- expressions
			process_variant_as,
			process_tagged_as,
			process_object_test_as,
			process_nested_as,
			process_inline_agent_creation_as,
			process_bin_eq_as

				-- lists of `INSTRUCTION_AS'es do not need special process
			-- process_debug_as,
			-- else part of if	
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
			create fix_positions.make_default
			has_found := False

    	    safe_process (context_feature)
    	end

feature -- Access

    context_feature: detachable FEATURE_AS
    		-- <Precursor>

    exception_position: detachable AFX_EXCEPTION_CALL_STACK_FRAME_I
    		-- <Precursor>

	exception_ast: detachable AST_EIFFEL
    		-- the ast containing the exception point

	last_collection: detachable DS_ARRAYED_LIST[AFX_FIX_POSITION]
			-- <Precursor>
		do
		    if fix_positions = Void then
		        create fix_positions.make_default
		    end

		    Result := fix_positions
		end

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

	collect_as (l_as: INSTRUCTION_AS)
			-- collect `l_as' into `fix_positions'
		local
		    l_pos: AFX_FIX_POSITION
		do
	        create l_pos.make (exception_position, l_as)
	        fix_positions.force_last (l_pos)
		end

	has_found: BOOLEAN
			-- have we already found the instruction-level ast node?

	fix_positions: like last_collection
			-- internal storage for collection result

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

feature{NONE} -- Process basic instructions

	process_assign_as (l_as: ASSIGN_AS)
		do
		    if not has_found then
    			check_position (l_as)
    			Precursor(l_as)

    			if has_found then collect_as (l_as) end
		    end
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		do
    		if not has_found then
    			check_position (l_as)
    			Precursor(l_as)

    			if has_found then collect_as (l_as) end
    		end
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
    		if not has_found then
    			check_position (l_as)
    			Precursor(l_as)

    			if has_found then collect_as (l_as) end
    		end
		end

	process_creation_as (l_as: CREATION_AS)
		do
    		if not has_found then
    			check_position (l_as)
    			Precursor(l_as)

    			if has_found then collect_as (l_as) end
    		end
		end

	process_check_as (l_as: CHECK_AS)
			-- no fix inside a check construct
		do
    		if not has_found then
    			check_position (l_as)
    			Precursor(l_as)

    			if has_found then collect_as (l_as) end
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
    				-- only operands are evaluated in current feature
    			safe_process (l_as.operands)
			end
		end

	process_bin_eq_as (l_as: BIN_EQ_AS)
		do
		    if not has_found then
		        check_position (l_as)
		        Precursor (l_as)
		    end
		end

feature{NONE} -- Process constructs

	process_if_as (l_as: IF_AS)
		local
		    l_elsif: detachable ELSIF_AS
		do
    		if not has_found then
    				-- whether the if-condition is responsible for the exception? If yes, the exception ast should be of type {IF_AST}
    				-- To correct this, fix should be applied before the if-construct
    			check_position (l_as)
    			safe_process (l_as.condition)
    		end

    		if has_found then
    			collect_as (l_as)
    		else
    				-- whether the conditions in the elseif parts are responsible? If yes, the exception ast should be of type {IF_AST}
    				-- To correct this, fix should also be applied before the if-construct
    			if attached l_as.elsif_list as l_elseif_list then
    			    from l_elseif_list.start
    			    until l_elseif_list.after or has_found
    			    loop
    			        l_elsif := l_elseif_list.item_for_iteration

    			        check_position (l_elsif)
   			        	safe_process (l_elsif.expr)

    			        l_elseif_list.forth
    			    end
    			end
    		end

    		if has_found then
    			collect_as (l_as)
    		else
    				-- instruction list does not need special attention
    			safe_process (l_as.compound)

    				-- `ELSIF_AS' are not checked against the exception ast in `process_elseif_as',
    				-- but are checked altogether in `process_if_as'
    				-- Ref.: `process_elseif_as'
    			safe_process (l_as.elsif_list)

    				-- else-part is another instruction list
    			safe_process (l_as.else_part)
    		end
		end

	process_elseif_as (l_as: ELSIF_AS)
			-- Ref.: `process_if_as'
		do
		    if not has_found then
			    safe_process (l_as.compound)
		    end
		end

	process_inspect_as (l_as: INSPECT_AS)
			-- for exceptions raised during evaluating the inspect expression, the exception ast should be of type {INSPECT_AS}
		do
		    if not has_found then
    			check_position (l_as)
    			safe_process (l_as.switch)
		    end

		    if has_found then
		        collect_as (l_as)
		    else
		        safe_process (l_as.case_list)
		        safe_process (l_as.else_part)
		    end
		end

	process_loop_as (l_as: LOOP_AS)
			-- Attention: (Ref.: AST_DEBUGGER_BREAKABLE_STRATEGY)
		do
		    if not has_found then
    				-- according to AST_DEBUGGER_BREAKABLE_STRATEGY.process_loop_as, stop-part and also `TAGGED_AS'es in invariant and variant parts
    				-- could be registered as breakpoint slots. So we check for these situations.
    				--
        			-- All until-expression, variant-expressions and invariant expressions are checked before and after each loop, although they appear in different places
        			-- their fixes shared the same set of places, i.e. right after the from-part and right after the loop-body.
        			-- For all these cases, the fix position will be at the loop-as, and how to fix depends on the type of exception we are working on
    			check_position (l_as.stop)
    			safe_process (l_as.stop)
    	        safe_process (l_as.invariant_part)
    	        safe_process (l_as.variant_part)
    	    end

			if has_found then
			    collect_as (l_as)
			else
    				-- lists of AST_EIFFEL
    	        safe_process (l_as.from_part)
    	        safe_process (l_as.compound)
		    end
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
