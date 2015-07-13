note
	description: "The engine of change analysis framework based on alias relation."

class	CHANGE_ANALYZER_ON_RELATION

inherit
	ALIAS_ANALYZER_ON_RELATION
		redefine
			create_keepers,
			debug_output,
			make,
			prefix_positive,
			prefix_negative,
			prepare_analysis,
			process_feature,
			report_to,
				-- Visitor
			process_access_feat_as
		end

create
	make

feature {NONE} -- Creation

	make
			-- <Precursor>
		do
			Precursor
			create model_dependency.make (0)
			create missing_model_dependency.make
			create is_specification_feature_map.make (0)
		end

feature -- Basic operation

	process_feature (f: FEATURE_I; c: CLASS_C; u: like update_agent)
			-- <Precursor>
		do
				-- Process only features that are generally available and are not specification features
				-- unless processing of a specific feature is explicitly requested.
			if progress_total <= 1 or else f.export_status.is_all and then not is_specification_feature (f) then
				Precursor (f, c, u)
--				s.append_string (n)
--				n := once {STRING_32} "%N"
--				s.append_string (f.feature_name_32)
--				s.append_string ({STRING_32} ": ")
--				report_to (s)
			end
		end

feature {NONE} -- Status report

	is_model_report: BOOLEAN
			-- Should model queries rather than attributes be used by `report_to'?

feature -- Status setting

	set_is_model_report (v: BOOLEAN)
			-- Set `is_model_report' to `v'.
		do
			is_model_report := v
		ensure
			is_model_report_set: is_model_report = v
		end

feature {NONE} -- Initialization

	create_keepers
			-- <Precursor>
		do
			Precursor
			create change_keeper.make
			keeper.extend (change_keeper)
		end

feature {NONE} -- Analysis

	prepare_analysis (c: CLASS_C)
			-- <Precursor>
		do
			Precursor (c)
				-- Initialize attribute information.
			is_specification_feature_map.wipe_out
				-- Initialize model information.
			model_dependency.wipe_out
			missing_model_dependency.wipe_out
			collect_model_queries (c)
		end

feature {NONE} -- Visitor

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
						elseif f.is_attribute and then is_attachment then
								-- Attachment to an attribute.
								-- Record that the target is changed.
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

feature {NONE} -- Change analysis

	record_change (t: like target)
			-- Record that the target `t' is changed.
		local
			q: like last_item
			v: like last_item
		do
			change_keeper.set.put (t)
			q := dictionary.index_qualifier (t)
			if q /= 0 then
				v := dictionary.index_tail (t)
				across
					alias_keeper.relation.aliases (q) as c
				loop
					if c.item /= dictionary.void_index and then c.item /= dictionary.non_void_index then
						dictionary.add_qualification (c.item, v)
						change_keeper.set.put (dictionary.last_added)
					end
				end
			end
		end

	record_immediate_change (t: like target)
			-- Record that an object for the target `t' is changed.
		do
			change_keeper.set.put (t)
			across
				alias_keeper.relation.aliases (t) as c
			loop
				change_keeper.set.put (c.item)
			end
		end

	record_attribute_change (a: FEATURE_I)
			-- Record that an attribute `a' of class `context.current_class' is changed.
		do
			register_attribute (a, context.current_class)
				-- Do not record change for specification feature.
			if not is_specification_feature (a) then
				record_change (last_item)
			end
		end

feature {NONE} -- Storage

	change_keeper: ALIAS_ANALYZER_CHANGE_SET_KEEPER
			-- Keeper of change sets.

feature {NONE} -- Coordinate transformation

	prefix_negative (map: FUNCTION [ANY, TUPLE [like last_item], like last_item])
			-- <Precursor>
		do
			Precursor (map)
			change_keeper.set.copy (change_keeper.set.mapped (map))
		end

	prefix_positive (map: FUNCTION [ANY, TUPLE [like last_item], like last_item])
			-- <Precursor>
		do
			Precursor (map)
			if attached change_keeper.set.mapped (map) as s then
				change_keeper.set.wipe_out
				across
					s as w
				loop
					record_change (w.item)
				end
			end
		end

feature {NONE} -- Model queries

	add_model_queries (t: like last_item; l: COMPARABLE_SET [STRING_32])
			-- Add model queries corresponding to `t' to `l'.
		local
			is_raw: BOOLEAN
		do
				-- Report this raw item unless it can be expressed via dependencies.
			is_raw := True
				-- Check if this item corresponds to an unqualified feature.
			if
				dictionary.is_feature (t) and then
				attached model_dependency.item (dictionary.routine_id (t)) as s
			then
					-- Add model queries that depend on this item.
				l.merge (s)
					-- Report this item if dependencies are incomplete.
				is_raw := not missing_model_dependency.is_empty
			end
			if is_raw then
					-- Report this item itself.
				l.extend (dictionary.name (t))
			end
		end

	model_dependency: HASH_TABLE [COMPARABLE_SET [STRING_32], like {ROUT_ID_SET}.first]
			-- Names of model queries corresponding to routine IDs of attributes they depend on.

	missing_model_dependency: TWO_WAY_SORTED_SET [STRING_32]
			-- List of model queries without dependencies.

	collect_model_queries (c: CLASS_C)
			-- Collect information about model queries.
		local
			l: LIST [STRING_32]
			n: detachable STRING_32
			has_dependency: BOOLEAN
		do
			if is_model_report then
				create {ARRAYED_LIST [STRING_32]} l.make (0)
				collect_model_names (c.ast.top_indexes, l)
				collect_model_names (c.ast.bottom_indexes, l)
				across
					l as m
				loop
					has_dependency := False
						-- Check if a listed feature is available in the class.
					if attached c.feature_named_32 (m.item) as f then
						if f.is_attribute then
								-- An attribute depends on itself.
							add_model_dependency (f.feature_name_32, f.rout_id_set.first)
							has_dependency := True
						elseif
							attached f.body as b and then
							attached b.indexes as i and then
							attached i.index_as_of_tag_name ("dependency") as t and then
							attached t.index_list as q
						then
								-- Routine depends on attributes listed in a note clause.
							across
								q as p
							loop
								if attached {STRING_AS} p.item as s then
									n := s.value
								elseif attached {ID_AS} p.item as id then
									n := id.name
								else
									n := Void
								end
								if attached n and then attached c.feature_named_32 (n.as_lower) as g then
									add_model_dependency (f.feature_name_32, g.rout_id_set.first)
									has_dependency := True
								end
							end
						end
					end
					if not has_dependency then
							-- Add this item to the list of model queries without dependencies.
						missing_model_dependency.extend (m.item)
					end
				end
			end
		end

	collect_model_names (notes: detachable INDEXING_CLAUSE_AS; l: LIST [STRING_32])
			-- Add names of model queries from note clause `notes' to a list `l'.
		do
			if
				attached notes and then
				attached notes.index_as_of_tag_name ("model") as t and then
				attached t.index_list as q
			then
				across
					q as n
				loop
					if attached {STRING_AS} n.item as s then
						l.extend (s.value)
					elseif attached {ID_AS} n.item as id then
						l.extend (id.name)
					end
				end
			end
		end

	add_model_dependency (name: STRING_32; r: like {ROUT_ID_SET}.first)
			-- Add a dependency of model query `name' on feature with routine ID `r'.
		local
			s: detachable COMPARABLE_SET [STRING_32]
		do
			s := model_dependency.item (r)
				-- Create a new list if there is none for the given routine ID.
			if not attached s then
				create {TWO_WAY_SORTED_SET [STRING_32]} s.make
				s.compare_objects
				model_dependency.extend (s, r)
			end
			s.extend (name)
		end

	is_specification_feature (f: FEATURE_I): BOOLEAN
			-- Is `f' a specification feature that is not executable?
		local
			r: like {ROUT_ID_SET}.first
		do
			r := f.rout_id_set.first
			is_specification_feature_map.search (r)
			if is_specification_feature_map.found then
				Result := is_specification_feature_map.found_item
			else
				if
					attached f.body as b and then
					attached b.indexes as i and then
					attached i.index_as_of_tag_name ("status") as t and then
					attached t.index_list as l and then
					across l as n some
						attached {STRING_AS} n.item as s and then s.value.is_case_insensitive_equal ("specification") or else
						attached {ID_AS} n.item as id and then id.name.is_case_insensitive_equal ("specification")
					end
				then
					Result := True
				end
				is_specification_feature_map.force (Result, r)
			end
		end

	is_specification_feature_map: HASH_TABLE [BOOLEAN, like {ROUT_ID_SET}.first]
			-- Map of specification features.

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

	debug_output: STRING
			--  <Precursor>
		local
			s: STRING_32
		do
			Result := Precursor
			Result.append_string ("%N%NChange set:")
			s := {STRING_32} " "
			across
				change_keeper.set as c
			loop
				Result.append_string (s)
				Result.append_string (dictionary.name (c.item))
				s := once {STRING_32} ", "
			end
		end

feature {NONE} -- Information about standard features

	routine_id (feature_name_id: like system.names.id_of; class_descriptor: CLASS_I): INTEGER
			-- Routine id of a feature named `feature_name_id' in a class specified by `class_descriptor'.
		do
			if
				attached class_descriptor as c and then
				c.is_compiled and then
				attached c.compiled_class.feature_table.item_id (feature_name_id) as f
			then
				Result := f.rout_id_set.first
			end
		end

	standard_copy_id: INTEGER
			-- Routine id of  "{ANY}.standard_copy".
		once
			Result := routine_id (system.names.standard_copy_name_id, system.any_class)
		end

	is_special_routine (r: INTEGER): BOOLEAN
			-- Does a routine of routine id `r' correspond to a routine from the class SPECIAL that changes object state?
		do
			Result := r = put_id or else r = extend_id or else r = set_count_id or else r = standard_copy_id or else r = system.any_copy_id
		end

	put_id: INTEGER
			-- Routine id of  "{SPECIAL}.put".
		once
			Result := routine_id (system.names.put_name_id, system.special_class)
		end

	extend_id: INTEGER
			-- Routine id of  "{SPECIAL}.extend".
		once
			Result := routine_id (system.names.extend_name_id, system.special_class)
		end

	set_count_id: INTEGER
			-- Routine id of  "{SPECIAL}.set_count".
		once
			Result := routine_id (system.names.set_count_name_id, system.special_class)
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
