note
	description: "Refactoring that pretty prints a class"
	date: "$Date$"
	revision: "$Revision$"

class
	ERF_CLASS_PRETTY_PRINT

inherit
	ERF_ETR_REFACTORING
		redefine
			refactor,
			ask_run_settings
		end

	SHARED_WORKBENCH
		export
			{NONE} all
		end

	REFACTORING_HELPER
		export
			{NONE} all
		end

	ETR_SHARED_TOOLS
	SHARED_ERROR_HANDLER
	SHARED_SERVER

create
	make

feature -- Status

	class_set: BOOLEAN
			-- Has the the class been set?
		do
			Result := class_i /= Void
		end

feature -- Element change

	set_class (a_class: CLASS_I)
			-- The class to pretty-print.
		require
			a_class_not_void: a_class /= Void
		do
			class_i := a_class
		ensure
			class_set_correct: class_set and class_i = a_class
		end

feature {NONE} -- Implementation

	class_i: CLASS_I
			-- The class to print.

	ask_run_settings
            -- Ask for the settings, that are run specific.
		require else
			class_set: class_set
        do
			retry_ask_run_settings := true
        end

	refactor
			-- Do the refactoring changes.
		require else
			class_set: class_set
		local
			l_written_class: CLASS_C
			l_class_modifier: ERF_CLASS_TEXT_MODIFICATION
			l_retry: BOOLEAN
			l_comments: HASH_TABLE[STRING,STRING]
			l_class_string: STRING
			l_matchlist: LEAF_AS_LIST
		do
			if not l_retry then
				success := true
				l_written_class := class_i.compiled_class
				l_matchlist := match_list_server.item (l_written_class.class_id)

				l_comments := ast_tools.extract_class_comments (l_written_class.ast, l_matchlist)
				l_class_string := ast_tools.commented_class_to_string (l_written_class.ast, l_comments)

				create l_class_modifier.make (class_i)
				l_class_modifier.prepare
				l_class_modifier.set_changed_text (l_class_string)
				l_class_modifier.commit
	        	current_actions.extend (l_class_modifier)
	        end
	    rescue
	    	if not etr_error_handler.has_errors then
				etr_error_handler.add_error (Current, "refactor", "Unhandled exception from EiffelTransform")
			end

			show_etr_error
			success := false
			error_handler.wipe_out
			l_retry := true
			retry
		end

note
	copyright:	"Copyright (c) 1984-2010, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
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
