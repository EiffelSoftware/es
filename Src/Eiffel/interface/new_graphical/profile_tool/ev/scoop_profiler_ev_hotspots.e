note
	description: "Hotspots helper."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SCOOP_PROFILER_EV_HOTSPOTS

feature -- Direct helpers

	hs_direct_integer (a_feature: SCOOP_PROFILER_FEATURE_PROFILE; a_agent: FUNCTION [SCOOP_PROFILER_FEATURE_PROFILE, TUPLE[], INTEGER]): INTEGER
			-- What's the result of applying `a_agent` on `a_feature`?
		require
			a_feature /= Void
			a_agent /= Void
		do
			a_agent.call ([a_feature])
			Result := a_agent.last_result
		end

	hs_direct_double (a_feature: SCOOP_PROFILER_FEATURE_PROFILE; a_agent: FUNCTION [SCOOP_PROFILER_FEATURE_PROFILE, TUPLE[], DOUBLE]): DOUBLE
			-- What's the result of applying `a_agent` on `a_feature`?
		require
			a_feature /= Void
			a_agent /= Void
		do
			a_agent.call ([a_feature])
			Result := a_agent.last_result
		end

feature -- Hotspot highliters

	hs_highlight_ok (a_item: EV_GRID_ITEM)
			-- Highlight `a_item` as ok.
		require
			a_item /= Void
		do
			a_item.set_foreground_color (hotspot_foreground_color)
			a_item.set_background_color (hotspot_background_color)
		end

	hs_highlight_warn (a_item: EV_GRID_ITEM)
			-- Highlight `a_item` as warning.
		require
			a_item /= Void
		do
			a_item.set_foreground_color (hotspot_foreground_color)
			a_item.set_background_color (hotspot_warn_color)
		end

	hs_highlight_error (a_item: EV_GRID_ITEM)
			-- Highlight `a_item` as error.
		require
			a_item /= Void
		do
			a_item.set_foreground_color (hotspot_foreground_color)
			a_item.set_background_color (hotspot_error_color)
		end

feature -- Hot spots

	hotspot_integer_min (a_col: EV_GRID_COLUMN; a_agent: FUNCTION [ANY, TUPLE[SCOOP_PROFILER_FEATURE_PROFILE], INTEGER]; a_highlighter: PROCEDURE [ANY, TUPLE [EV_GRID_ITEM]])
			-- Hotspot minimum of `a_col` using `a_agent`.
			-- Highlight with `a_highlighter`.
		require
			a_col /= Void
			a_agent /= Void
			a_highlighter /= Void
		local
			l_i: INTEGER
			l_min, l_current: INTEGER
			l_list: LINKED_LIST [EV_GRID_ITEM]
			l_first: BOOLEAN
		do
			create l_list.make
			from
				l_i := 1
			until
				l_i > a_col.count
			loop
				if a_col.item (l_i) /= Void and then a_col.item (l_i).data /= Void then
					if attached {SCOOP_PROFILER_FEATURE_PROFILE} a_col.item (l_i).data as t_feature then
						a_agent.call ([t_feature])
						l_current := a_agent.last_result
						if l_min > l_current or not l_first then
							l_min := l_current
							l_first := True
							l_list.wipe_out
							l_list.extend (a_col.item (l_i))
						elseif l_min = l_current then
							l_list.extend (a_col.item (l_i))
						end
					end
				end
				l_i := l_i + 1
			end
			l_list.do_all (a_highlighter)
		end

	hotspot_integer_max (a_col: EV_GRID_COLUMN; a_agent: FUNCTION [ANY, TUPLE[SCOOP_PROFILER_FEATURE_PROFILE], INTEGER]; a_highlighter: PROCEDURE [ANY, TUPLE [EV_GRID_ITEM]])
			-- Hotspot maximum of `a_col` using `a_agent`.
			-- Highlight with `a_highlighter`.
		require
			a_col /= Void
			a_agent /= Void
			a_highlighter /= Void
		local
			l_i, l_max, l_current: INTEGER
			l_first: BOOLEAN
			l_list: LINKED_LIST [EV_GRID_ITEM]
		do
			create l_list.make
			from
				l_i := 1
			until
				l_i > a_col.count
			loop
				if a_col.item (l_i) /= Void and then a_col.item (l_i).data /= Void then
					if attached {SCOOP_PROFILER_FEATURE_PROFILE} a_col.item (l_i).data as t_feature then
						a_agent.call ([t_feature])
						l_current := a_agent.last_result
						if l_current > l_max or not l_first then
							l_max := l_current
							l_first := True
							l_list.wipe_out
							l_list.extend (a_col.item (l_i))
						elseif l_current = l_max then
							l_list.extend (a_col.item (l_i))
						end
					end
				end
				l_i := l_i + 1
			end
			l_list.do_all (a_highlighter)
		end

	hotspot_integer (a_col: EV_GRID_COLUMN; a_agent: FUNCTION [ANY, TUPLE[SCOOP_PROFILER_FEATURE_PROFILE], INTEGER]; a_highlighter: PROCEDURE [ANY, TUPLE [EV_GRID_ITEM]]; a_int: INTEGER)
			-- Hotspot `a_col` using `a_agent` if equal to `a_int`.
			-- Highlight with `a_highlighter`.
		require
			a_col /= Void
			a_agent /= Void
			a_highlighter /= Void
		local
			l_i: INTEGER
		do
			from
				l_i := 1
			until
				l_i > a_col.count
			loop
				if a_col.item (l_i) /= Void and then a_col.item (l_i).data /= Void then
					if attached {SCOOP_PROFILER_FEATURE_PROFILE} a_col.item (l_i).data as t_feature then
						a_agent.call ([t_feature])
						if a_agent.last_result = a_int then
							a_highlighter.call ([a_col.item (l_i)])
						end
					end
				end
				l_i := l_i + 1
			end
		end

	hotspot_integer_not (a_col: EV_GRID_COLUMN; a_agent: FUNCTION [ANY, TUPLE[SCOOP_PROFILER_FEATURE_PROFILE], INTEGER]; a_highlighter: PROCEDURE [ANY, TUPLE [EV_GRID_ITEM]]; a_int: INTEGER)
			-- Hotspot `a_col` using `a_agent` if not equal to `a_int`.
			-- Highlight with `a_highlighter`.
		require
			a_col /= Void
			a_agent /= Void
			a_highlighter /= Void
		local
			l_i: INTEGER
		do
			from
				l_i := 1
			until
				l_i > a_col.count
			loop
				if a_col.item (l_i) /= Void and then a_col.item (l_i).data /= Void then
					if attached {SCOOP_PROFILER_FEATURE_PROFILE} a_col.item (l_i).data as t_feature then
						a_agent.call ([t_feature])
						if a_agent.last_result /= a_int then
							a_highlighter.call ([a_col.item (l_i)])
						end
					end
				end
				l_i := l_i + 1
			end
		end

	hotspot_double_min (a_col: EV_GRID_COLUMN; a_agent: FUNCTION [ANY, TUPLE[SCOOP_PROFILER_FEATURE_PROFILE], DOUBLE]; a_highlighter: PROCEDURE [ANY, TUPLE [EV_GRID_ITEM]])
			-- Hotspot minimum of `a_col` using `a_agent`.
			-- Highlight with `a_highlighter`.
		require
			a_col /= Void
			a_agent /= Void
			a_highlighter /= Void
		local
			l_i: INTEGER
			l_min, l_current: DOUBLE
			l_list: LINKED_LIST [EV_GRID_ITEM]
			l_first: BOOLEAN
		do
			create l_list.make
			from
				l_i := 1
			until
				l_i > a_col.count
			loop
				if a_col.item (l_i) /= Void and then a_col.item (l_i).data /= Void then
					if attached {SCOOP_PROFILER_FEATURE_PROFILE} a_col.item (l_i).data as t_feature then
						a_agent.call ([t_feature])
						l_current := a_agent.last_result
						if l_min > l_current or not l_first then
							l_min := l_current
							l_list.wipe_out
							l_list.extend (a_col.item (l_i))
							l_first := True
						elseif l_min = l_current then
							l_list.extend (a_col.item (l_i))
						end
					end
				end
				l_i := l_i + 1
			end
			l_list.do_all (a_highlighter)
		end

	hotspot_double_max (a_col: EV_GRID_COLUMN; a_agent: FUNCTION [ANY, TUPLE[SCOOP_PROFILER_FEATURE_PROFILE], DOUBLE]; a_highlighter: PROCEDURE [ANY, TUPLE [EV_GRID_ITEM]])
			-- Hotspot maximum of `a_col` using `a_agent`.
			-- Highlight with `a_highlighter`.
		require
			a_col /= Void
			a_agent /= Void
			a_highlighter /= Void
		local
			l_i: INTEGER
			l_max, l_current: DOUBLE
			l_list: LINKED_LIST [EV_GRID_ITEM]
			l_first: BOOLEAN
		do
			create l_list.make
			from
				l_i := 1
			until
				l_i > a_col.count
			loop
				if a_col.item (l_i) /= Void and then a_col.item (l_i).data /= Void then
					if attached {SCOOP_PROFILER_FEATURE_PROFILE} a_col.item (l_i).data as t_feature then
						a_agent.call ([t_feature])
						l_current := a_agent.last_result
						if l_current > l_max or not l_first then
							l_max := l_current
							l_list.wipe_out
							l_list.extend (a_col.item (l_i))
							l_first := True
						elseif l_current = l_max then
							l_list.extend (a_col.item (l_i))
						end
					end
				end
				l_i := l_i + 1
			end
			l_list.do_all (a_highlighter)
		end

	hotspot_double (a_col: EV_GRID_COLUMN; a_agent: FUNCTION [ANY, TUPLE[SCOOP_PROFILER_FEATURE_PROFILE], DOUBLE]; a_highlighter: PROCEDURE [ANY, TUPLE [EV_GRID_ITEM]]; a_double: DOUBLE)
			-- Hotspot `a_col` using `a_agent` if equal to `a_double`.
			-- Highlight with `a_highlighter`.
		require
			a_col /= Void
			a_agent /= Void
			a_highlighter /= Void
		local
			l_i: INTEGER
		do
			from
				l_i := 1
			until
				l_i > a_col.count
			loop
				if a_col.item (l_i) /= Void and then a_col.item (l_i).data /= Void then
					if attached {SCOOP_PROFILER_FEATURE_PROFILE} a_col.item (l_i).data as t_feature then
						a_agent.call ([t_feature])
						if a_agent.last_result = a_double then
							a_highlighter.call ([a_col.item (l_i)])
						end
					end
				end
				l_i := l_i + 1
			end
		end

	hotspot_double_not (a_col: EV_GRID_COLUMN; a_agent: FUNCTION [ANY, TUPLE [SCOOP_PROFILER_FEATURE_PROFILE], DOUBLE]; a_highlighter: PROCEDURE [ANY, TUPLE [EV_GRID_ITEM]]; a_double: DOUBLE)
			-- Hotspot `a_col` using `a_agent` if not equal to `a_double`.
			-- Highlight with `a_highlighter`.
		require
			a_col /= Void
			a_agent /= Void
			a_highlighter /= Void
		local
			l_i: INTEGER
		do
			from
				l_i := 1
			until
				l_i > a_col.count
			loop
				if a_col.item (l_i) /= Void and then a_col.item (l_i).data /= Void then
					if attached {SCOOP_PROFILER_FEATURE_PROFILE} a_col.item (l_i).data as t_feature then
						a_agent.call ([t_feature])
						if a_agent.last_result /= a_double then
							a_highlighter.call ([a_col.item (l_i)])
						end
					end
				end
				l_i := l_i + 1
			end
		end

feature -- Colors

	Hotspot_ok_color: EV_COLOR
			-- Ok color
		once
			create Result.make_with_8_bit_rgb (200, 255, 100)
		ensure
			Result /= Void
		end

	Hotspot_warn_color: EV_COLOR
			-- Warning color
		once
			create Result.make_with_8_bit_rgb (255, 255, 153)
		ensure
			Result /= Void
		end

	Hotspot_error_color: EV_COLOR
			-- Error color
		once
			create Result.make_with_8_bit_rgb (255, 200, 0)
		ensure
			Result /= Void
		end

	Hotspot_background_color: EV_COLOR
			-- Standard background color
		once
			create Result.make_with_8_bit_rgb (255, 255, 255)
		ensure
			Result /= Void
		end

	Hotspot_foreground_color: EV_COLOR
			-- Standard foreground color
		once
			create Result.make_with_8_bit_rgb (0, 0, 0)
		ensure
			Result /= Void
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
