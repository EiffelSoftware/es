note
	description: "The engine of alias analysis framework based on alias graph."

class
	ALIAS_ANALYZER_ON_GRAPH

inherit
	ALIAS_ANALYZER
		redefine
			make,
			prepare_analysis,
			process_class,
			process_feature,
				-- Visitor
			process_access_feat_as,
			process_assign_as
		end

	SHARED_WORKBENCH

create
	make

feature {NONE} -- Initialization

	make
			-- <Precursor>
		do
			Precursor
			create dictionary.make
			create alias_keeper.make
		end

feature -- Analysis

	process_class (c: CLASS_C; u: PROCEDURE [ANY, TUPLE [ANY]])
			-- <Precursor>
		do
			Precursor (c, u)
		end

	process_feature (f: FEATURE_I; c: CLASS_C; u: PROCEDURE [ANY, TUPLE [ANY]])
			-- <Precursor>
		do
			Precursor (f, c, u)
		end

feature {NONE} -- Initialization

	prepare_analysis (c: CLASS_C)
			-- Prepare analyzer to process `c'.
		do
			Precursor (c)
			create keeper.make_from_array (<<alias_keeper>>)
		end

feature {NONE} -- Visitor

	process_access_feat_as (a: ACCESS_FEAT_AS)
			-- <Precursor>
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
					-- TODO: handle object test locals.
				last_item := dictionary.non_void_index
			else
					-- Feature call.
					-- TODO: handle features.
				if attached context.current_class.feature_of_rout_id (a.routine_ids.first) as f then
					register_attribute (f, context.current_class)
				else
					last_item := dictionary.non_void_index
				end
			end
		end

	process_assign_as (a: ASSIGN_AS)
			-- <Precursor>
		local
			s: like last_item
		do
			a.source.process (Current)
			s := last_item
			is_attachment := True
			a.target.process (Current)
			is_attachment := False
			if s = dictionary.void_index then
					-- This is a "forget" instruction of alias calculus.
				alias_keeper.graph.remove_tag (last_item)
			else
			end
		end

feature {NONE} -- Output

	report_to (o: STRING_32)
			-- <Precursor>
		do
			o.append_string ({STRING_32} "Report of alias analyzer based on graphs is not implemented yet.")
		end

feature {NONE} -- Storage

	alias_keeper: ALIAS_ANALYZER_GRAPH_KEEPER
			-- Keeper of alias graphs.

;note
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
