note
	description: "[
		Given a context class and an exception position, and also a range for collection, complete collector collects every position inside that range 
		(it does not matter whether the exception position is inside the range).
		
		Specially,
		if the range was not specified, all positions in the exception feature will be collected ;
		if the range is not inside the feature of exception, NO position will be collected.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_POSITION_COMPLETE_COLLECTOR

inherit

	AFX_FIX_POSITION_COLLECTER_I
		rename
		    config as config_general
		end

	AST_ITERATOR
		redefine
--		    	-- features
--			process_feature_as,

		    	-- basic instructions
			process_assign_as,
			process_instr_call_as,
			process_assigner_call_as,
			process_check_as,
			process_creation_as,

				-- control constructs
			process_if_as,
			process_inspect_as,
			process_loop_as,

				-- processed as constrol constructs
			process_debug_as,
			process_retry_as
		end

inherit{NONE}

    AST_ITERATOR
		rename
				-- control constructs
			process_if_as as pre_process_if_as,
			process_inspect_as as pre_process_inspect_as,
			process_loop_as as pre_process_loop_as,

				-- processed as constrol constructs
			process_debug_as as pre_process_debug_as,
			process_retry_as as pre_process_retry_as

		undefine
--		    	-- features
--			process_feature_as,

		    	-- basic instructions
			process_inline_agent_creation_as,
			process_assign_as,
			process_instr_call_as,
			process_assigner_call_as,
			process_check_as,
			process_creation_as
		end

feature -- Access

    context_feature: detachable feature_AS
    		-- <Precursor>

    exception_position: detachable AFX_EXCEPTION_CALL_STACK_FRAME_I
    		-- <Precursor>

	range: detachable INSTRUCTION_AS assign set_range
			-- the range for complete collection.
			-- if void, collect all instruction positions in the feature containing `an_exception_position'

	fix_positions: like last_collection
			-- internal storage for position collection

	last_collection: detachable DS_ARRAYED_LIST[AFX_FIX_POSITION]
			-- <Precursor>

feature -- Status report

	is_inside_range: BOOLEAN
			-- are we currently inside range ?

	is_collecting: BOOLEAN
			-- are we currently collecting positions?
		do
		    Result := range = Void or else is_inside_range
		end

feature -- Setting up

	config (a_feature: attached like context_feature; an_exception_position: attached like exception_position; a_range: like range)
			-- config the collecting strategy
		do
		    config_general (a_feature, an_exception_position)
		    range := a_range
		end

	config_general (a_feature: attached like context_feature; an_exception_position: attached like exception_position)
			-- <Precursor>
		do
    	    context_feature := a_feature
    	    exception_position := an_exception_position
		end

feature -- Collect

    collect_fix_positions
    		-- <Precursor>
    	local
    	    l_positions: DS_ARRAYED_LIST[AFX_FIX_POSITION]
    	do
    	    is_inside_range := False
    	    create fix_positions.make_default

    	    safe_process (context_feature)

				-- detach `fix_positions' from the argument
			last_collection := fix_positions
			fix_positions := Void
    	end

feature{NONE} -- Setting

	set_range (a_range: like range)
			-- set the range for complete collecting
		do
		    range := a_range
		end

feature{NONE} -- Implementation

	is_range (a_as: detachable AST_EIFFEL): BOOLEAN
			-- if `a_as' is the `range'
		require
		    is_not_collecting: not is_collecting
		do
		    Result := range.equivalent (a_as, range)
		    		and then range.start_position = a_as.start_position
		end

feature{NONE} -- Process feature

--	process_feature_as (l_as: FEATURE_AS)
--			-- select the feature with right name to look into
--		local
--		    l_expected_feature_name: STRING
--		    l_current_feature_names: EIFFEL_LIST [FEATURE_NAME]
--		    l_a_name: STRING
--		    l_is_matching: BOOLEAN
--		do
--		    if not (l_as.is_attribute or l_as.is_constant) then
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

	process_basic_instruction (a_as: AST_EIFFEL)
			-- process basic eiffel instructions, i.e. instructions other than loop, if, inspect, ...
		require
		    is_ready_to_collect: is_ready_to_collect
		local
		    l_pos: AFX_FIX_POSITION
		    l_range_start: BOOLEAN
		do
		    	-- update scope info
			if not is_collecting and then is_range (a_as) then
   		        l_range_start := True
   		        is_inside_range := True
			end

				-- collect if inside range
		    if is_inside_range then
    		    create l_pos.make (exception_position, a_as)
    		    fix_positions.force_last (l_pos)
    		end

				-- get out of range if appropriate
			if l_range_start then
			    is_inside_range := False
			end
		end

	process_assign_as (l_as: ASSIGN_AS)
		do
			process_basic_instruction (l_as)
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		do
		    process_basic_instruction (l_as)
		end

	process_check_as (l_as: CHECK_AS)
		do
		    process_basic_instruction (l_as)
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
		    process_basic_instruction (l_as)
		end

	process_creation_as (l_as: CREATION_AS)
		do
		    process_basic_instruction (l_as)
		end

feature{NONE} -- Process expressions
	-- no expression will be processed, since there would be no fix position inside an expression

feature{NONE} -- Process control constructs

	process_control_construct (a_as: AST_EIFFEL; a_precursor: PROCEDURE[ANY, TUPLE])
			-- process control constructs in eiffel, i.e. loop, if, inspect, ...
		require
		    is_ready_to_collect: is_ready_to_collect
		local
		    l_pos: AFX_FIX_POSITION
		    l_range_start: BOOLEAN
		do
		    if not is_collecting and then is_range (a_as) then
		        l_range_start := True
		        is_inside_range := True
		    end

		    if is_inside_range then
		        create l_pos.make (exception_position, a_as)
		        fix_positions.force_last (l_pos)
		    end

		    a_precursor.apply

		    if l_range_start then
		        is_inside_range := False
		    end
		end

	process_if_as (l_as: IF_AS)
		do
		    process_control_construct (l_as, agent pre_process_if_as (l_as))
		end

	process_inspect_as (l_as: INSPECT_AS)
		do
		    process_control_construct (l_as, agent pre_process_inspect_as (l_as))
		end

	process_loop_as (l_as: LOOP_AS)
		do
		    process_control_construct (l_as, agent pre_process_loop_as (l_as))
		end

feature{NONE} -- Process debug/retry

	process_debug_as (l_as: DEBUG_AS)
		do
		    process_control_construct (l_as, agent pre_process_debug_as (l_as))
		end

	process_retry_as (l_as: RETRY_AS)
		do
		    process_control_construct (l_as, agent pre_process_retry_as (l_as))
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
