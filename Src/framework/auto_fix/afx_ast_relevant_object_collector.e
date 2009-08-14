note
	description: "TODO: more precise analysis"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_AST_RELEVANT_OBJECT_COLLECTOR

inherit

	AST_ITERATOR
		redefine
            process_access_id_as,
            process_creation_as,
            process_elseif_as,
            process_if_as,
            process_inspect_as,
            process_instr_call_as,
            process_loop_as,
            process_variant_as,
            process_tagged_as
		end

create
    make

feature
    make
    		-- initialize new visitor
    	do
			create locals_args_and_attributes.make(10)
    	end

feature -- Status report

	is_relevant: BOOLEAN
			-- should objects visited now be considered relevant?

feature -- Access

	caller_feature: E_FEATURE
	caller_class: CLASS_C

	callee_feature: detachable E_FEATURE
	callee_class: detachable CLASS_C

	ast: AST_EIFFEL

	relevant_objects: detachable HASH_TABLE[TYPE_A, STRING]
			-- relevant objects collected during last visiting

	locals_args_and_attributes: HASH_TABLE[TYPE_A, STRING]

feature -- operation

	collect_relevant_objects (a_caller: E_FEATURE; a_callee: detachable E_FEATURE; a_as: AST_EIFFEL;
								a_relevant_objects: HASH_TABLE[TYPE_A, STRING])
			-- prepare the visitor to collect objects influencing the execution of `a_callee' from `a_caller'
		do
		    caller_feature := a_caller
		    caller_class := a_caller.associated_class

		    callee_feature := a_callee
		    if attached a_callee as l_callee then
			    callee_class := a_callee.associated_class
		    end

		    ast := a_as

			relevant_objects := a_relevant_objects
			locals_args_and_attributes.wipe_out

			get_locals_args_and_attributes

			a_as.process (Current)

				-- put "Current" as relevant
			if not relevant_objects.has_key ("Current") then
			    relevant_objects.put (a_caller.associated_class.actual_type, "Current")
			end

			relevant_objects := Void
		end

feature -- implementation

	get_locals_args_and_attributes
			-- put all the local variables and formal arguments into the `locals_and_args' table
		require
		    relevant_objects_not_void: relevant_objects /= Void
		local
		    l_server: DEBUGGER_AST_SERVER
		    l_feature: E_FEATURE
		    l_class: CLASS_C
		    l_argument_count: INTEGER
		    l_argument_list: E_FEATURE_ARGUMENTS
		    l_argument_name_list: LIST[STRING_8]
		    l_local_table: detachable HASH_TABLE [LOCAL_INFO, INTEGER]
		    l_local_info: LOCAL_INFO
		    l_local_id: INTEGER_32
		    l_local_name: STRING
		    l_list_type_as: detachable EIFFEL_LIST[TYPE_DEC_AS]
		    l_type_as: TYPE_DEC_AS
		    l_id_list: IDENTIFIER_LIST
		    i: INTEGER
			l_feature_table: FEATURE_TABLE
			l_feature_or_attribute: FEATURE_I
		do
		    l_feature := caller_feature

			if l_feature.argument_count > 0 then
    		    l_argument_list := l_feature.arguments
    		    l_argument_name_list := l_feature.argument_names

    		    	-- add arguments into the list
    		    from
    		        l_argument_list.start
    		        l_argument_name_list.start
    		    until
    		        l_argument_list.after
    		    loop
    		        if l_argument_list.item /= Void then
   		                locals_args_and_attributes.put(l_argument_list.item, l_argument_name_list.item)
    		        end
    		        l_argument_list.forth
    		    end
			end

		    	-- locals
		    create l_server.make(10)
		    l_local_table := l_server.local_table (l_feature)

		    l_list_type_as := l_feature.locals
		    if l_list_type_as /= Void and then not l_list_type_as.is_empty then
    		    from
    		        l_list_type_as.start
    		    until
    		        l_list_type_as.after
    		    loop
    		        l_type_as := l_list_type_as.item
    		        l_id_list := l_type_as.id_list

    		        from
    		            i := 1
    		        until
    		            i > l_id_list.count
    		        loop
    		            l_local_id := l_id_list.at (i)
    		            l_local_name := l_type_as.item_name (i)
    		            l_local_info := l_local_table.at (l_local_id)

    		            locals_args_and_attributes.put(l_local_info.type, l_local_name)
    		            i := i + 1
    		        end

    		        l_list_type_as.forth
    		    end
		    end

				-- also attributes of the class?
			l_class := l_feature.associated_class
			l_feature_table := l_class.feature_table
			if l_feature_table /= Void and then not l_feature_table.is_empty then
    			from
    			    l_feature_table.start
    			until
    			    l_feature_table.after
    			loop
    			    l_feature_or_attribute := l_feature_table.item_for_iteration
    			    if l_feature_or_attribute.is_attribute then

    			        locals_args_and_attributes.put(l_feature_or_attribute.type, l_feature_or_attribute.feature_name)
    			    end

    			    l_feature_table.forth
    			end
			end

				-- add `Current' into the list
			if not locals_args_and_attributes.has_key ("Current") then
				locals_args_and_attributes.put(caller_feature.associated_class.actual_type, "Current")
			end
		end

		-- {AST_EIFFEL} types dealt with are according to `AST_DEBUGGER_BREAKABLE_STRATEGY'
feature {NONE} -- Iteration

	process_access_id_as(a_as: ACCESS_ID_AS)
		do
			if locals_args_and_attributes.has_key (a_as.access_name) then
			    relevant_objects.put (locals_args_and_attributes.found_item, a_as.access_name)
			end
		end

-- Current is added into the result list anyway		
--	process_current_as (a_as: CURRENT_AS)
--		do
--		
--		end

--	process_result_as (a_as: RESULT_AS)
--		do
--		    if relevant_objects then

--		    end
--		    relevant_objects.extend_last (a_as)
--		end

-- From: process_assign_as (l_as: ASSIGN_AS)
--		 target: ACCESS_AS
-- 		 source: EXPR_AS
-- <Precursor>

-- From: process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
--		 target: EXPR_AS
--		 source: EXPR_AS
-- <Precursor>:

-- From: process_creation_as (l_as: CREATION_AS)
--		 type: N/A
--		 call: ACCESS_INV_AS
-- target does not matter
	process_creation_as (a_as: CREATION_AS)
		do
		    a_as.call.process (Current)
		end

-- From: process_elseif_as (l_as: ELSIF_AS)
--		 expr: EXPR_AS
--		 compound: EIFFEL_LIST [INSTRUCTION_AS]
	process_elseif_as (a_as: ELSIF_AS)
		do
		    a_as.expr.process (Current)
		end

-- From: process_if_as (a_as: IF_AS)
--		 conditions: EXPR_AS
--		 compound: EIFFEL_LIST [INSTRUCTION_AS]
--		 elsif_list: EIFFEL_LIST [ELSIF_AS]
--		 else_part: EIFFEL_LIST [INSTRUCTION_AS]
	process_if_as (a_as: IF_AS)
		do
		    a_as.condition.process (Current)
		end

-- From: process_inspect_as (a_as: INSPECT_AS)
--		 switch: EXPR_AS
--		 case_list: EIFFEL_LIST [CASE_AS]
--		 else_part: EIFFEL_LIST [INSTRUCTION_AS]
	process_inspect_as (a_as: INSPECT_AS)
		do
		    a_as.switch.process (Current)
		end

-- From: process_instr_call_as (a_as: INSTR_CALL_AS)
--		 call: CALL_AS
	process_instr_call_as (a_as: INSTR_CALL_AS)
		do
		    a_as.call.process (Current)
		end

-- From: process_loop_as (a_as: LOOP_AS)
--		 from_part: EIFFEL_LIST [INSTRUCTION_AS]
--		 invariant_part: EIFFEL_LIST [TAGGED_AS]
--		 variant_part: VARIANT_AS
--		 stop: EXPR_AS
--		 compound: EIFFEL_LIST [INSTRUCTION_AS]
	process_loop_as (a_as: LOOP_AS)
		do
		    a_as.stop.process (Current)
		end

-- From: process_variant_as (a_as: VARIANT_AS)
--		 expr: EXPR_AS
	process_variant_as (a_as: VARIANT_AS)
		do
		    a_as.expr.process (Current)
		end

-- From: process_retry_as (l_as: RETRY_AS)
--		 N/A

-- From: process_assign_as (l_as)
--		 the same as process_assign_as (l_as)

-- From: process_routine_as (l_as: ROUTINE_AS)
--		 we should NOT come into this situation

-- From: process_inline_agent_creation_as (l_as: INLINE_AGENT_CREATION_AS)
--		 Don't know what to do about this!
--		 The definition itself here should be safe, but check out if we need to prepare for the possible use of this agent
--		 body: BODY_AS
--		 operands: EIFFEL_LIST [OPERAND_AS]

-- From: process_tagged_as (l_as: TAGGED_AS)
--		 tag: ID_AS
--		 expr: EXPR_AS
--		
	process_tagged_as (a_as: TAGGED_AS)
		do
			a_as.expr.process (Current)
		end

-- From: process_nested_as (a_as: NESTED_AS)
--		 target: ACCESS_AS
--		 message: CALL_AS
--	process_nested_as (a_as: NESTED_AS)
--		do
--			
--		end

-- From: process_object_test_as (l_as: OBJECT_TEST_AS)
--		 Left for furture work
--	process_object_test_as (l_as: OBJECT_TEST_AS)
--		do
--		end



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
