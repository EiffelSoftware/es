note
	description: "Refactoring that makes a class effective by using empty implementations."
	date: "$Date$"
	revision: "$Revision$"
class
	ERF_MAKE_EFFECTIVE
inherit
	ERF_ETR_REFACTORING
		redefine
			ask_run_settings,
			refactor
		end

	REFACTORING_HELPER
		export
			{NONE} all
		end

	SHARED_SERVER
	SHARED_ERROR_HANDLER
	ETR_SHARED_OPERATORS
	ETR_SHARED_TOOLS

create
	make

feature -- Status

	class_set: BOOLEAN
			-- Has the class to change been set?
		do
			Result := class_i /= void
		end

feature -- Element change

	set_class (a_class: like class_i)
			-- That class that get's renamed
		require
			a_class_not_void: a_class /= void
		do
			class_i := a_class
		end

feature {NONE} -- Implementation

	refactor
			-- Do the refactoring changes.
		require else
			class_set: class_set
		local
			l_matchlist: LEAF_AS_LIST
			l_class_modifier: ERF_CLASS_TEXT_MODIFICATION
			l_transformable: ETR_TRANSFORMABLE
			l_compiled_class: CLASS_C
			l_retry: BOOLEAN
			l_comments: HASH_TABLE[STRING,STRING]
			l_class_string: STRING
		do
			if not l_retry then
				success := true

				etr_error_handler.reset_errors

				l_compiled_class := class_i.compiled_class
				l_matchlist := match_list_server.item (l_compiled_class.class_id)

				create l_transformable.make_in_class (l_compiled_class.ast, l_compiled_class)

				effective_class_generator.generate_effective_class (l_transformable)

				if not etr_error_handler.has_errors then
					l_comments := ast_tools.extract_class_comments (l_compiled_class.ast, l_matchlist)

					-- set comments for pulled down features to `<precursor>'

					from
						effective_class_generator.pulled_down_features.start
					until
						effective_class_generator.pulled_down_features.after
					loop
						l_comments.force (" <precursor>", effective_class_generator.pulled_down_features.item)
						effective_class_generator.pulled_down_features.forth
					end

					l_class_string := ast_tools.commented_class_to_string (effective_class_generator.transformation_result.target_node, l_comments)

					l_compiled_class.ast.replace_text (l_class_string, l_matchlist)

					create l_class_modifier.make (class_i)
					l_class_modifier.prepare
					l_class_modifier.set_changed_text (l_matchlist.all_modified_text)
					l_class_modifier.commit
		        	current_actions.extend (l_class_modifier)
		        else
		        	show_etr_error
		        	success := false
		        	error_handler.wipe_out
				end
			end
		rescue
			log_exception(Current, "refactor")

			show_etr_error
			success := false
			error_handler.wipe_out
			l_retry := true
			retry
		end

    ask_run_settings
            -- Ask for the settings, that are run specific.
		require else
			class_set: class_set
        do
			retry_ask_run_settings := true
        end

	class_i: EIFFEL_CLASS_I;
			-- The class we're operating in
;
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
