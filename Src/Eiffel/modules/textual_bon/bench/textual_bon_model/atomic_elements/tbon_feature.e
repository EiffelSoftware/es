note
	description: "A feature in a class described by a BON specification."
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TBON_FEATURE

inherit
	TEXTUAL_BON_ELEMENT
		redefine
			process_to_informal_textual_bon
		end

feature -- Access
	arguments: LIST[TUPLE[STRING, STRING]]
			-- What are the arguments to this feature?

	comment: STRING
			-- What is the comment of this feature?

	name: attached TBON_IDENTIFIER
			-- What is the name of this feature?

	renaming_clause: TBON_RENAMING_CLAUSE
			-- What is the renaming clause of this feature?

	postcondition: TBON_POSTCONDITION
			-- What is the postcondition of this feature?

	precondition: TBON_PRECONDITION
			-- What is the precondition of this feature?

feature -- Processing
	process_to_informal_bon
			-- Process this element into informal textual BON.
		require else
			has_comment: has_comment
		local
			l_text_formatter_decorator: like text_formatter_decorator
		do
			l_text_formatter_decorator := text_formatter_decorator
			l_text_formatter_decorator.process_string_text (ti_double_quote, Void)
			l_text_formatter_decorator.process_string_text (comment, Void)
			l_text_formatter_decorator.process_string_text (ti_double_quote, Void)
		end

feature -- Status report
	has_arguments: BOOLEAN
			-- Does this feature have any arguments?
		do
			Result := arguments /= Void
		end

	has_comment: BOOLEAN
			-- Does this feature have a comment
		do
			Result := comment /= Void
		end

	has_postcondition: BOOLEAN
			-- Does this feature have a postcondition?
		do
			Result := postcondition /= Void
		end

	has_precondition: BOOLEAN
			-- Does this feature have a precondition?
		do
			Result := precondition /= Void
		end

	is_deferred: BOOLEAN
			-- Is this feature deferred?

	is_effective: BOOLEAN
			-- Is this feature effective?

	is_redefined: BOOLEAN
			-- Is this feature redefined?

	is_renamed: BOOLEAN
			-- Is this feature renamed?
		do
			Result := renaming_clause /= Void
		end

feature -- Status setting
	set_deferred
			-- Set this feature to be deferred.
		do
			is_deferred := True
			is_effective := False
		ensure
			is_deferred: is_deferred
			is_not_effective: not is_effective
		end

	set_effective
			-- Set this feature to be effective.
		do
			is_effective := True
			is_deferred := False
		ensure
			is_effective: is_effective
			is_not_deferred: not is_deferred
		end

	set_redefined
			-- Set this feature to be redefined.
		do
			is_redefined := True
		ensure
			is_redefined: is_redefined
		end

invariant
	not_deferred_and_effective: is_deferred implies not is_effective
	must_have_arguments_if_not_void: has_arguments implies not arguments.is_empty

note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
