note
	description: "Inferring change specification from postconditions."
	author: "Alexander Tchitchigin"
	date: "$Date$"
	revision: "$Revision$"

class
	CHANGE_SPEC_ANALYZER_ON_RELATION

inherit
	CHANGE_ANALYZER_ON_RELATION
		redefine
			make,
			report_to,
				-- Visitor
			process_routine_as,
			process_access_feat_as,
			    -- Change spec inference
		    process_un_old_as,
		    process_ensure_as,
		    process_invariant_as
		end


create
	make

feature {NONE} -- Creation

	make
		do
			Precursor
		end

feature {NONE} -- Visitor

	process_routine_as (a: ROUTINE_AS)
			-- Process `l_as'.
			-- (from ALIAS_ANALYZER_ON_RELATION)
		local
			t: TYPE_A
		do
			t := Context.current_feature.type
			if not t.is_void then
				register_attribute (Context.current_feature, Context.current_class)
				set_default_aliases (t)
			end
			safe_process (a.precondition)
--			a.routine_body.process (Current) -- ignore body in spec analyzer
			safe_process (a.postcondition)
			process_compound (a.rescue_clause)
		end

	process_access_feat_as (a: ACCESS_FEAT_AS)
			-- <Precursor>
		do
			Precursor (a)

			if a.is_local then
			elseif a.is_argument then
			elseif a.is_object_test_local then
			else
					-- Feature call.
				if not is_qualified then
					if attached context.current_class.feature_of_rout_id (a.routine_ids.first) as f then
							-- Feature.
						if f.is_routine then
							if f.rout_id_set.first = system.any_copy_id or else f.rout_id_set.first = standard_copy_id then
									-- All the attributes of the current object may change.
								across
									context.current_class.skeleton as s
								loop
										-- Record that an attribute is changed.
									record_attribute_change (context.current_class.feature_of_feature_id (s.item.feature_id))
								end
							elseif is_special_routine (f.rout_id_set.first) then
									-- A feature that modifies SPECIAL is called.
								dictionary.add_current
								record_immediate_change (dictionary.last_added)
							end
--						elseif f.is_attribute and then is_attachment then
						elseif f.is_attribute then
								-- Record that the target is changed
								-- Regardless of attachment but I don't know what it means
							record_attribute_change (f)
						end
					end
				elseif
					attached system.class_of_id (a.class_id) as c and then
					attached c.feature_of_rout_id (a.routine_ids.first) as f and then
					 is_special_routine (f.rout_id_set.first)
				then
						-- A feature that modifies SPECIAL is called.
					record_immediate_change (target)
				end
			end
		end

	-- Change spec inference

	process_un_old_as (l_as: UN_OLD_AS)
			-- Process `l_as'.
			-- (from AST_ITERATOR)
		do
			-- ignore features marked with old
		end

	process_ensure_as (l_as: ENSURE_AS)
			-- Process `l_as'.
		do
			across l_as.assertions as asrtn loop collect_props (asrtn.item) end
		end

	process_invariant_as (l_as: INVARIANT_AS)
			-- Process `l_as'.
		do
--			safe_process (l_as.assertion_list)
			-- ignore invariants they have nothing to do with change spec
		end

feature {NONE} -- Internal working procedures

	collect_props (asrtn: TAGGED_AS)
			-- Add all properties from `asrtn' to change spec set.
		do
			asrtn.expr.process (Current)  -- should call process_access_feature_as
		end

feature {NONE} -- Output

	report_to (o: STRING_32)
			-- <Precursor>
		local
			s: STRING_32
			v: like last_item
			l: TWO_WAY_SORTED_SET [STRING_32]
		do
			if not collected_output.is_empty then
				o.append_string (collected_output)
				if not missing_model_dependency.is_empty then
					o.append_string ("%N%NMissing model dependencies:")
					across
						missing_model_dependency as m
					loop
						o.append_character (' ')
						o.append_string (m.item)
					end
				end
			else
				create l.make
				l.compare_objects
				dictionary.add_feature (last_feature, last_class)
				v := dictionary.last_added
				across
					change_keeper.set as c
				loop
					if dictionary.is_attribute_chain (c.item, v) then
						add_model_queries (c.item, l)
					end
				end
				s := {STRING_32} ""
				across
					l as c
				loop
					o.append_string (s)
					o.append_string (c.item)
					s := once {STRING_32} ", "
				end
			end
		end


note
	copyright: "Copyright (c) 1984-2015, Eiffel Software"
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
