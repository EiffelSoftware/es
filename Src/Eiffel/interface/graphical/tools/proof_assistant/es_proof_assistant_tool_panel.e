indexing
	description: "Summary description for {ES_PROOF_ASSISTANT_TOOL_PANEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_PROOF_ASSISTANT_TOOL_PANEL

inherit

	ES_DOCKABLE_STONABLE_TOOL_PANEL [EV_TEXT]

	EXCEPTIONS
	export {NONE} all end

create
	make

feature

	create_widget: EV_TEXT
		do
			create Result
		end

	build_tool_interface (root_widget: EV_TEXT)
		do
			create jstar_proofs.make (agent user_widget.set_text)
			propagate_drop_actions (Void)
		end

	create_tool_bar_items: ?DS_ARRAYED_LIST [SD_TOOL_BAR_ITEM]
		local
			texts: ARRAY [STRING]
			actions: ARRAY [PROCEDURE [ANY, TUPLE]]
			button: SD_TOOL_BAR_BUTTON
			i: INTEGER
		do
			texts := <<"Code", "Specs", "Logic", "Abs", "CFG", "Execution">>
			actions := <<agent show_text_window ("Code", agent {JSTAR_PROOFS}.jimple_code),
						 agent show_text_window ("Specs", agent {JSTAR_PROOFS}.specs),
						 agent show_window_for_file ("Logic", agent {JSTAR_PROOFS}.logic_file_name),
						 agent show_window_for_file ("Abstraction Rules", agent {JSTAR_PROOFS}.abs_file_name),
						 Void, Void>>

			from
				create Result.make (texts.count)
				create window_references.make
				i := 1
			until
				i > texts.count
			loop
				create button.make
				button.set_text (texts [i])
				button.select_actions.extend (actions [i])
				Result.put (button, i)
				i := i + 1
			end
		end

feature {NONE}

	on_stone_changed (a_old_stone: ?like stone)
		local
			l_retry: BOOLEAN
			l_error_prompt: ES_ERROR_PROMPT
		do
			if not l_retry then
				if {st: !CLASSC_STONE} stone and then {c: !CLASS_C} st.e_class then
					jstar_proofs.prove (c)
				end
			end
		rescue
			create l_error_prompt.make_standard (tag_name)
			l_error_prompt.set_title ("Separation logic proof tool error")
			l_error_prompt.show_on_active_window
			l_retry := True
			retry
		end

	jstar_proofs: JSTAR_PROOFS

	show_window_for_file (window_title: STRING; filename_agent: FUNCTION [ANY, TUPLE, STRING])
		local
			l_filename: STRING
			l_text_file: PLAIN_TEXT_FILE
			l_text: STRING
			l_retried: BOOLEAN
		do
			if not l_retried then
				l_filename := filename_agent.item ([jstar_proofs])
				if l_filename = Void then
					create_text_window (window_title, "Unavailable")
				else
					from
						create l_text_file.make_open_read (l_filename)
						l_text_file.start
						l_text := ""
					until
						l_text_file.off
					loop
						l_text_file.read_line
						if l_text.count > 0 then
							l_text.append ("%N")
						end
						l_text.append (l_text_file.last_string)
					end
					create_text_window (window_title, l_text)
				end
			else
				create_text_window (window_title, "Unavailable")
			end
		rescue
			l_retried := True
			retry
		end

	show_text_window (window_title: STRING; source: FUNCTION [ANY, TUPLE, STRING])
		do
			create_text_window (window_title, source.item ([jstar_proofs]))
		end

	create_text_window (window_title: STRING; text_content: STRING)
		local
			l_text_widget: EV_TEXT
			l_window: EV_TITLED_WINDOW
		do
			create l_window.make_with_title (window_title)
			create l_text_widget.make_with_text (text_content)
			l_window.put (l_text_widget)
			l_window.set_size (500, 300)
			l_window.close_request_actions.put_front (agent close_window (l_window))
			window_references.put_front (l_window)
			l_window.show
		end

	close_window (a_window: EV_TITLED_WINDOW)
		do
			window_references.prune_all (a_window)
			a_window.destroy
		end

	window_references: LINKED_LIST [EV_TITLED_WINDOW]
		-- References to the displayed windows, so that they don't get garbage collected.

;indexing
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
