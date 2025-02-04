note
	description: "Summary description for {SCM_SETUP_BOX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCM_SETUP_BOX

inherit
	SHARED_SCM_NAMES
		redefine
			default_create
		end

create
	default_create

convert
	widget: {EV_WIDGET}

feature {NONE} -- Initialization

	default_create
		do
			Precursor
			create widget
			build_interface (widget)
		end

	build_interface (b: EV_VERTICAL_BOX)
		local
			txt: EVS_LABEL
			but: EV_BUTTON
			hb: EV_HORIZONTAL_BOX
			cl: EV_CELL
		do
			create txt.make_with_text (scm_names.text_select_groups_to_monitor)
			txt.set_is_text_wrapped (True); txt.align_text_left; txt.align_text_top
			b.extend (txt)
			b.disable_item_expand (txt)

			create grid
			b.extend (grid)

			create but.make_with_text (scm_names.button_switch_back)
			but.select_actions.extend (agent on_switch_back_clicked)
			create hb
			hb.extend (create {EV_CELL})
			hb.extend (but)
			hb.disable_item_expand (but)

			switch_back_box := hb
			b.extend (hb)
			b.disable_item_expand (hb)


			b.resize_actions.extend (agent (alab: EV_WIDGET; ax,ay,aw,ah: INTEGER_32)
				do
					alab.refresh_now
				end(txt,?,?,?,?)
			)
		end

feature -- Basic operation

	set_workspace (ws: SCM_WORKSPACE)
		do
			workspace := ws
			grid.set_workspace (ws)
		end

	set_back_action (ag: detachable PROCEDURE)
		do
			switch_back_action := ag
			if attached switch_back_box as w then
				if ag = Void then
					w.hide
				else
					w.show
				end
			end
		end

	reset
		do
			if attached grid as g then
				g.reset
			end
		end

feature -- Event

	on_switch_back_clicked
		do
			if attached switch_back_action as act then
				act.call
			end
		end

feature -- Access

	switch_back_action: detachable PROCEDURE

	switch_back_box: EV_WIDGET

	workspace: detachable SCM_WORKSPACE

	widget: EV_VERTICAL_BOX

	grid: SCM_SETUP_GRID

invariant
note
	copyright: "Copyright (c) 1984-2025, Eiffel Software"
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
