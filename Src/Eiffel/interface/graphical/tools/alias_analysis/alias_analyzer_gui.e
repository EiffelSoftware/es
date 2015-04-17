note
	description: "The gui view of the alias analysis tool."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ALIAS_ANALYZER_GUI

inherit
	EV_HORIZONTAL_BOX

create
	make

feature {NONE}

	feature_view: EB_ROUTINE_FLAT_FORMATTER
	step_over_button: EV_BUTTON

	first_alias_breakpoint: EDITOR_TOKEN_ALIAS_BREAKPOINT
	cur_alias_breakpoint: EDITOR_TOKEN_ALIAS_BREAKPOINT

	make (a_develop_window: EB_DEVELOPMENT_WINDOW)
		local
			l_drop_actions: EV_PND_ACTION_SEQUENCE
			l_button_box: EV_VERTICAL_BOX
		do
			default_create

			create l_drop_actions
			l_drop_actions.extend (agent on_stone_changed)

			create feature_view.make (a_develop_window)
			feature_view.set_editor_displayer (feature_view.displayer_generator.any_generator.item ([a_develop_window, l_drop_actions]))
			feature_view.set_combo_box (create {EV_COMBO_BOX}.make_with_text ((create {INTERFACE_NAMES}).l_Flat_view))
			feature_view.on_shown

			create step_over_button.make_with_text_and_action ("", agent on_step_over)
			step_over_button.set_pixmap ((create {EB_SHARED_PIXMAPS}).icon_pixmaps.debug_step_over_icon)
			step_over_button.disable_sensitive

			create l_button_box
			l_button_box.extend (step_over_button)
			l_button_box.disable_item_expand (step_over_button)

			extend (feature_view.editor.widget)
			extend (l_button_box)
			disable_item_expand (l_button_box)
		end

	on_stone_changed (a_stone: STONE)
		local
			l_el: EIFFEL_EDITOR_LINE
			l_line_number: INTEGER_32
			l_last: EDITOR_TOKEN_ALIAS_BREAKPOINT

			l_internal: INTERNAL
			l_field_index: INTEGER_32
			l_done: BOOLEAN
		do
			feature_view.set_stone (a_stone)

			from
				l_el := feature_view.editor.text_displayed.first_line
				l_line_number := 1
			until
				l_el = Void
			loop
				if
					attached {EDITOR_TOKEN_BREAKPOINT} l_el.real_first_token as etb and then
					etb.pebble /= Void
				then
					if l_internal = Void then
						create l_internal
						from
							l_field_index := 1
						until
							l_done
						loop
							if l_internal.field (l_field_index, l_el) = etb then
								l_done := True
							else
								l_field_index := l_field_index + 1
							end
						end
					end

					if l_last = Void then
						l_last := create {EDITOR_TOKEN_ALIAS_BREAKPOINT}.make_replace (etb, l_line_number)
						l_last.active := True
						first_alias_breakpoint := l_last
						cur_alias_breakpoint := l_last
						step_over_button.enable_sensitive
					else
						l_last.next_alias_breakpoint := create {EDITOR_TOKEN_ALIAS_BREAKPOINT}.make_replace (etb, l_line_number)
						l_last.next_alias_breakpoint.previous_alias_breakpoint := l_last
						l_last := l_last.next_alias_breakpoint
					end
					l_internal.set_reference_field (l_field_index, l_el, l_last)
				end
				l_el := l_el.next
				l_line_number := l_line_number + 1
			end
			feature_view.editor.refresh
		ensure
			step_over_button.is_sensitive
			first_alias_breakpoint /= Void
			cur_alias_breakpoint = first_alias_breakpoint
		end

	on_step_over
		do
			cur_alias_breakpoint.active := False
			cur_alias_breakpoint := cur_alias_breakpoint.next_alias_breakpoint
			if cur_alias_breakpoint = Void then
				cur_alias_breakpoint := first_alias_breakpoint
			end
			cur_alias_breakpoint.active := True
			feature_view.editor.display_line_with_context (cur_alias_breakpoint.line_number)
			feature_view.editor.refresh
		end

invariant
	feature_view /= Void
	step_over_button /= Void

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
