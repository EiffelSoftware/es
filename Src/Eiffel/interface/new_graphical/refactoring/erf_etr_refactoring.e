note
	description: "Refactoring that used EiffelTransform."
	date: "$Date$"
	revision: "$Revision$"

class
	ERF_ETR_REFACTORING
inherit
	ERF_REFACTORING
		redefine
			execute
		end
	ETR_SHARED_ERROR_HANDLER
		rename
			error_handler as etr_error_handler
		end
	ETR_SHARED_LOGGER

feature {NONE} -- Implementation

	log_exception(a_class: ANY; a_feat: STRING)
			-- Log exception that caused the failure of EiffelTransform
		local
			l_exception: EXCEPTION
		do
			if not etr_error_handler.has_errors then
				etr_error_handler.add_error (Current, a_feat, "Unhandled exception from EiffelTransform")
			end

			l_exception := (create {EXCEPTION_MANAGER}).last_exception
			if l_exception /= void then
				if not etr_error_handler.has_errors then
					etr_error_handler.add_error (a_class, a_feat, l_exception.meaning)
				end

				logger.log_error ("Exception:%N"+l_exception.out)
			end
		end

feature -- Error handling

	show_etr_error
			-- Report etr error
		local
			l_error_msg: STRING
		do
			if etr_error_handler.has_errors then
				from
					create l_error_msg.make_empty
					etr_error_handler.errors.start
				until
					etr_error_handler.errors.after
				loop
					l_error_msg.append (etr_error_handler.errors.item)
					etr_error_handler.errors.forth
					if not etr_error_handler.errors.after then
						l_error_msg.append ("%N")
					end
				end
				prompts.show_error_prompt (l_error_msg, Void, Void)
			end
		end

feature -- Basic actions

	execute
			-- Execute the refactoring
		local
			all_checks_ok: BOOLEAN
			compiler_check: ERF_COMPILATION_SUCCESSFUL
		do
			success := False
			status_bar := window_manager.last_focused_development_window.status_bar
			create compiler_check.make

				-- check if compilation is ok
			compiler_check.execute
			if not compiler_check.success then
				(create {ES_SHARED_PROMPT_PROVIDER}).prompts.show_error_prompt (compiler_check.error_message, Void, Void)
			else
					-- Get open classes
				window_manager.for_all_development_windows (agent add_window_to_open_classes)

					-- Ask settings till the checks all complete successfully or if the user cancels
				ask_run_settings
				if retry_ask_run_settings then
					from
						all_checks_ok := checks.for_all (agent check_successful)
					until
						not retry_ask_run_settings or else all_checks_ok
					loop
						ask_run_settings
						all_checks_ok := checks.for_all (agent check_successful)
					end
						-- Checks ok and user didn't cancel
					if all_checks_ok and retry_ask_run_settings then
							-- Handle undo
						create current_actions.make (0)

						refactor

						if success then
							-- Execute compilation
							compiler_check.execute
							success := compiler_check.success

								-- on error ask if we should rollback
							if not success then
									-- success, because, now the user can choose to keep the changes or if he rollbacks, success will be set to False
								success := True
								(create {ES_SHARED_PROMPT_PROVIDER}).prompts.show_question_prompt (compiler_check.error_message.as_string_32+" " + interface_names.l_rollback_question, Void, agent rollback, agent commit)
							else
								commit
							end
						end
					end
					window_manager.for_all_development_windows (agent {EB_DEVELOPMENT_WINDOW}.synchronize)
				end
			end
		rescue
				-- on exception undo any changes
			rollback
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
