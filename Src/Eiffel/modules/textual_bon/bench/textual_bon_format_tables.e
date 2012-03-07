note
	description: "Summary description for {TEXTUAL_BON_FORMAT_TABLES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEXTUAL_BON_FORMAT_TABLES

inherit
	EB_SHARED_FORMAT_TABLES
		redefine
			clear_class_tables,
			clear_format_tables
		end

feature -- Attributes
	informal_bon_table: HASH_TABLE[TEXT_FORMATTER, CLASS_C]
			-- Table of last informal BON formats.
		once
			Result.make (history_size)
		end

	formal_bon_table: HASH_TABLE[TEXT_FORMATTER, CLASS_C]
			-- Table of last formal BON formats.
		once
			Result.make (history_size)
		end


feature -- Properties
	informal_bon_context_text (a_class: CLASS_C; a_formatter: TEXT_FORMATTER): BOOLEAN
			-- Format context of the informal BON form of `a_class'
		require
			a_class_not_void: a_class /= Void
			valid_a_class: a_class.is_valid
			a_formatter_not_void: a_formatter /= Void
		local
			ctxt: CLASS_TEXT_FORMATTER
		do
			create ctxt
			ctxt.set_is_without_breakable
			ctxt.set_is_informal_bon
			ctxt.format (a_class, a_formatter)

			Result := ctxt.error
		end

	formal_bon_context_text (a_class: CLASS_C; a_formatter: TEXT_FORMATTER): BOOLEAN
			-- Format context of the formal BON form of `a_class'
		require
			a_class_not_void: a_class /= Void
			valid_a_class: a_class.is_valid
			a_formatter_not_void: a_formatter /= Void
		local
			ctxt: CLASS_TEXT_FORMATTER
		do
			create ctxt
			ctxt.set_is_without_breakable
			ctxt.set_is_formal_bon
			ctxt.format (a_class, a_formatter)

			Result := ctxt.error
		end

feature -- Clearing tables
	clear_format_tables
			-- Clear all the format tables (after a compilation)
		do
			Precursor
			informal_bon_table.wipe_out
			formal_bon_table.wipe_out
		end

	clear_class_tables
			-- Clear the cache for class tables except for
			-- the `clickable_table'.
		do
			Precursor
			informal_bon_table.wipe_out
			formal_bon_table.wipe_out
		end



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
