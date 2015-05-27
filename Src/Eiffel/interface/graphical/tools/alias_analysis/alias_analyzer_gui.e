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
	step_out_button: EV_BUTTON
	test_button: EV_BUTTON
	alias_info_text: EV_TEXT

	alias_analysis_runner: ALIAS_ANALYSIS_RUNNER


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
			feature_view.editor.margin.margin_area.pointer_button_release_actions.wipe_out

			create step_over_button.make_with_text_and_action ("", agent on_step_over)
			step_over_button.set_pixmap ((create {EB_SHARED_PIXMAPS}).icon_pixmaps.debug_step_over_icon)
			step_over_button.disable_sensitive

			create step_out_button.make_with_text_and_action ("", agent on_step_out)
			step_out_button.set_pixmap ((create {EB_SHARED_PIXMAPS}).icon_pixmaps.debug_step_out_icon)
			step_out_button.disable_sensitive

			create test_button.make_with_text_and_action ("TS", agent run_tests)
			test_button.set_tooltip ("Run Test Suite")

			create alias_info_text
			alias_info_text.disable_edit

			create l_button_box
			l_button_box.extend (step_over_button)
			l_button_box.disable_item_expand (step_over_button)
			l_button_box.extend (step_out_button)
			l_button_box.disable_item_expand (step_out_button)
			l_button_box.extend (create {EV_HORIZONTAL_BOX})
			l_button_box.extend (test_button)
			l_button_box.disable_item_expand (test_button)

			extend (feature_view.editor.widget)
			extend (l_button_box)
			disable_item_expand (l_button_box)
			extend (alias_info_text)
		end

	reset
		do
			feature_view.editor.clear_window
			step_over_button.disable_sensitive
			step_out_button.disable_sensitive
			alias_info_text.set_text ("")
			alias_analysis_runner := Void
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
			reset
			if
				attached {FEATURE_STONE} a_stone as fs and then
				attached {E_ROUTINE} fs.e_feature as r and then
				attached {PROCEDURE_I} r.associated_class.feature_named_32 (r.name_32) as p
			then
				feature_view.set_stone (a_stone)
				step_over_button.enable_sensitive
				step_out_button.enable_sensitive
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
						create l_last.make_replace (etb, l_line_number, l_last)
						l_internal.set_reference_field (l_field_index, l_el, l_last)
					end
					l_el := l_el.next
					l_line_number := l_line_number + 1
				end
				create alias_analysis_runner.make (
						p,
						l_last,
						agent do feature_view.editor.refresh end
					)
			end
		end

	on_step_over
		do
			alias_analysis_runner.step_over
			alias_info_text.set_text (alias_analysis_runner.report)
			if alias_analysis_runner.is_done then
				step_over_button.disable_sensitive
				step_out_button.disable_sensitive
			end
		end

	on_step_out
		do
			alias_analysis_runner.step_out
			alias_info_text.set_text (alias_analysis_runner.report)
			if alias_analysis_runner.is_done then
				step_over_button.disable_sensitive
				step_out_button.disable_sensitive
			end
		end

	run_tests
		local
			l_testsuite_name: STRING_8
			l_l: LIST [CLASS_I]
			l_ft: FEATURE_TABLE
		do
			reset

			l_testsuite_name := "ALIAS_ANALYSIS_TESTSUITE"
			l_l := feature_view.eiffel_universe.classes_with_name (l_testsuite_name)
			inspect l_l.count
			when 1 then
				if attached l_l.first.compiled_class as c then
					from
						l_ft := c.feature_table
						l_ft.start
					until
						l_ft.after
					loop
						if l_ft.item_for_iteration.written_class = c then
							test_class (l_ft.item_for_iteration.type.base_class)
						end
						l_ft.forth
					end
				else
					alias_info_text.set_text ("Class " + l_testsuite_name + " not compiled?!")
				end
			when 0 then
				alias_info_text.set_text ("Class " + l_testsuite_name + " not found?!")
			else
				alias_info_text.set_text (l_l.count.out + " " + l_testsuite_name + " classes found?!")
			end
		end

	test_class (a_c: CLASS_C)
		require
			a_c /= Void
		local
			l_ft: FEATURE_TABLE
		do
			alias_info_text.append_text ("Testing " + a_c.name + "%N")
			from
				l_ft := a_c.feature_table
				l_ft.start
			until
				l_ft.after
			loop
				if
					attached {PROCEDURE_I} l_ft.item_for_iteration as p and then
					p.e_feature.written_class = a_c
				then
					test_feature (p)
				end
				l_ft.forth
			end
		end

	test_feature (a_f: PROCEDURE_I)
		require
			a_f /= Void
		local
			l_analyzer: ALIAS_ANALYSIS_RUNNER
			l_expected, l_actual: STRING_32
		do
			if attached expected_aliasing (a_f) as l_expected_list then
				create l_analyzer.make (a_f, Void, Void)
				across l_expected_list as c loop
					l_analyzer.step_until (c.item.index)
					l_expected := c.item.aliasing
					l_actual := l_analyzer.report

					alias_info_text.append_text ("   - " + a_f.feature_name_32 + " [" + c.item.index.out + "]: ")
					if l_actual.is_equal (l_expected) then
						alias_info_text.append_text ("PASS%N")
					else
						alias_info_text.append_text ("FAIL:%N")
						alias_info_text.append_text ("      --- --- --- expected --- --- ---%N")
						if not l_expected.is_empty then
							across l_expected.split ('%N') as c2 loop
								alias_info_text.append_text ("      " + c2.item + "%N")
							end
						end
						alias_info_text.append_text ("      --- --- ---  actual  --- --- ---%N")
						if not l_actual.is_empty then
							across l_actual.split ('%N') as c2 loop
								alias_info_text.append_text ("      " + c2.item + "%N")
							end
						end
						alias_info_text.append_text ("      --- --- --- ---  --- --- --- ---%N")
					end
				end
			end
		end

	expected_aliasing (a_f: PROCEDURE_I): LIST [TUPLE [index: INTEGER_32; aliasing: STRING_32]]
		require
			a_f /= Void
		local
			l_error: STRING_8
			l_note_key, l_index_str: STRING_8
			l_index: INTEGER_32
			l_aliasing: STRING_32
		do
			if a_f.e_feature.ast.indexes /= Void then
				create {TWO_WAY_LIST [TUPLE [INTEGER_32, STRING_32]]} Result.make
				across
					a_f.e_feature.ast.indexes as c
				until
					l_error /= Void
				loop
					l_note_key := c.item.tag.name_8
					if l_note_key.starts_with ("aliasing") then
						l_index_str := l_note_key.substring(("aliasing").count + 1, l_note_key.count)
						if l_index_str.is_empty then
							l_index := a_f.number_of_breakpoint_slots
						elseif l_index_str.is_integer_32 then
							l_index := l_index_str.to_integer_32
						else
							l_error := "Note %"" + l_note_key + "%" has an invalid index (" + l_index_str + ")"
						end
						if l_error = Void then
							if
								l_index >= 1 and
								l_index <= a_f.number_of_breakpoint_slots and
								(Result.is_empty or else Result.last.index < l_index)
							then
								inspect c.item.index_list.count
								when 1 then
									l_aliasing := c.item.index_list[1].string_value_32
									if l_aliasing.starts_with ("%"") and l_aliasing.ends_with ("%"") then
										l_aliasing := l_aliasing.substring (2, l_aliasing.count - 1)
										l_aliasing.replace_substring_all ("%%N", "%N")
										Result.extend ([l_index, l_aliasing])
									else
										l_error := "Note %"" + l_note_key + "%" has an invalid value"
									end
								when 0 then
									l_error := "Note %"" + l_note_key + "%" has no values"
								else
									l_error := "Note %"" + l_note_key + "%" has " + c.item.index_list.count.out + " values"
								end
							else
								l_error := "Note %"" + l_note_key + "%" has an invalid index (" + l_index.out + ")"
							end
						end
					end
				end
				if l_error /= Void then
					alias_info_text.append_text ("   - " + a_f.feature_name_32 + ": " + l_error + "?!%N")
					Result := Void
				elseif Result.is_empty then
					Result := Void
				end
			end
		ensure
			Result = Void or else not Result.is_empty
		end

invariant
	feature_view /= Void
	step_over_button /= Void
	step_out_button /= Void

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
