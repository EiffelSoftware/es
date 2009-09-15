note
	description: "[
		Basic collector collects all variables/expressions that appear at the fix position.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIXING_TARGET_COLLECTOR_BASIC

inherit
	AFX_FIXING_TARGET_COLLECTOR_I

	AST_ITERATOR
		redefine
            process_access_id_as,
            process_current_as,
            process_result_as,
            process_variant_as,
            process_tagged_as,
            process_object_test_as,
            process_inline_agent_creation_as,
            process_if_as,
            process_inspect_as,
            process_loop_as
		end

	SHARED_AFX_FEATURE_FIXING_TARGET_INFO_SERVER

feature -- Access

	context_feature: detachable E_FEATURE
			-- <Precursor>

	fix_position: detachable AST_EIFFEL
			-- <Precursor>

	last_collection: HASH_TABLE [AFX_FIXING_TARGET_I, STRING]
			-- <Precursor>
		do
			if internal_fixing_target_collection = Void then
			    create internal_fixing_target_collection.make (5)
			end

			Result := internal_fixing_target_collection
		end

feature -- Status report

	is_setting_valid (a_feature: like context_feature; a_position: like fix_position): BOOLEAN
			-- <Precursor>
		do
		    Result := a_feature /= Void and then a_position /= Void
		end

feature -- operation

	collect_fixing_targets (a_feature: like context_feature; a_position: like fix_position)
			-- <Precursor>
		local
		    l_server: like feature_fixing_target_info_server
		do
		    context_feature := a_feature
		    fix_position := a_position

				-- retrieve fixing target info of the feature
		    l_server := feature_fixing_target_info_server
		    feature_fixing_target_info := l_server.fixing_target_info (context_feature)
		    check feature_fixing_target_info /= Void end

				-- internal storage
			create internal_fixing_target_collection.make (5)

				-- process
			a_position.process (Current)

				-- put "Current" as relevant
			if not internal_fixing_target_collection.has_key ("Current") and then feature_fixing_target_info.has_target ("current") then
			    internal_fixing_target_collection.put (feature_fixing_target_info.found_target, "current")
			end
		end

feature{NONE} -- Status report

	is_collecting: BOOLEAN
			-- should targets visited now be collected?

feature{NONE} -- Access

	internal_fixing_target_collection: detachable like last_collection
			-- internal storage for collection result

	feature_fixing_target_info: detachable AFX_FEATURE_FIXING_TARGET_INFO
			-- fixing target info of context feature

feature{NONE} -- Process

	process_access_id_as(a_as: ACCESS_ID_AS)
		local
		    l_name: STRING
		do
		    l_name := a_as.access_name
		    l_name.to_lower
			if feature_fixing_target_info.has_target (l_name) then
			    internal_fixing_target_collection.put (feature_fixing_target_info.found_target, l_name)
			end
		end

	process_current_as (a_as: CURRENT_AS)
		local
		    l_name: STRING
		do
		    l_name := a_as.access_name
		    l_name.to_lower
			if feature_fixing_target_info.has_target (l_name) then
			    internal_fixing_target_collection.put (feature_fixing_target_info.found_target, l_name)
			end
		end

	process_result_as (a_as: RESULT_AS)
		local
		    l_name: STRING
		do
		    l_name := a_as.access_name
		    l_name.to_lower
			if feature_fixing_target_info.has_target (l_name) then
			    internal_fixing_target_collection.put (feature_fixing_target_info.found_target, l_name)
			end
		end

feature{NONE} -- Process expressions

	process_variant_as (l_as: VARIANT_AS)
		do
    		safe_process (l_as.expr)
		end

	process_tagged_as (l_as: TAGGED_AS)
		do
    		safe_process (l_as.expr)
		end

	process_object_test_as (l_as: OBJECT_TEST_AS)
		do
    		safe_process (l_as.expression)
		end

	process_inline_agent_creation_as (l_as: INLINE_AGENT_CREATION_AS)
		do
   				-- only operands are evaluated in current feature
   			safe_process (l_as.operands)
		end

feature{NONE} -- Process constructs

	process_if_as (l_as: IF_AS)
			-- when an `IF_AS' is registered as the fix position, it is because the exception was inside one of the conditions.
			-- so we only need to collect those targets in if- and elseif- conditions
		local
		    l_elsif: detachable ELSIF_AS
		do
			safe_process (l_as.condition)

				-- whether the conditions in the elseif parts are responsible? If yes, the exception ast should be of type {IF_AST}
				-- To correct this, fix should also be applied before the if-construct
			if attached l_as.elsif_list as l_elseif_list then
			    from l_elseif_list.start
			    until l_elseif_list.after
			    loop
			        l_elsif := l_elseif_list.item_for_iteration

   			        	safe_process (l_elsif.expr)

			        l_elseif_list.forth
			    end
			end
		end

	process_inspect_as (l_as: INSPECT_AS)
			-- for exceptions raised during evaluating the inspect expression, we collect targets in inspect expression
		do
   			safe_process (l_as.switch)
		end

	process_loop_as (l_as: LOOP_AS)
			-- when a `LOOP_AS' is registered as the fix position, the exception was in either `stop', `invariant_part', or `variant_part'
		do
				-- according to AST_DEBUGGER_BREAKABLE_STRATEGY.process_loop_as, stop-part and also `TAGGED_AS'es in invariant and variant parts
				-- could be registered as breakpoint slots. So we check for these situations.
				--
    			-- All until-expression, variant-expressions and invariant expressions are checked before and after each loop, although they appear in different places
    			-- their fixes shared the same set of places, i.e. right after the from-part and right after the loop-body.
    			-- For all these cases, the fix position will be at the loop-as, and how to fix depends on the type of exception we are working on
			safe_process (l_as.stop)
	        safe_process (l_as.invariant_part)
	        safe_process (l_as.variant_part)
		end

;note
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
