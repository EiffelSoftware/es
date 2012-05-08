note
	description: "Warning for a non-empty body of an attribute that is of a self-initializing type."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$";
	revision: "$Revision$"

class ALIAS_ANALYZER_WARNING

inherit
	FEATURE_ERROR
		undefine
			error_string
		redefine
			help_text,
			subcode
		end

	WARNING
		undefine
			has_associated_file
		redefine
			subcode
		end

create
	make_always_false,
	make_always_true

feature {NONE} -- Initialization

	make_always_false (l: LOCATION_AS; c: AST_CONTEXT)
			-- Initialize warning object for
			-- a boolean expression that is always False
			-- at location `l' in context `c'.
		do
			make (subcode_always_false, l, c)
		ensure
			subcode_set: subcode = subcode_always_false
			class_c_attached: attached class_c
			e_feature_attached: attached e_feature
			location_set: line = l.line and column = l.column
		end

	make_always_true (l: LOCATION_AS; c: AST_CONTEXT)
			-- Initialize warning object for
			-- a boolean expression that is always True
			-- at location `l' in context `c'.
		do
			make (subcode_always_true, l, c)
		ensure
			subcode_set: subcode = subcode_always_true
			class_c_attached: attached class_c
			e_feature_attached: attached e_feature
			location_set: line = l.line and column = l.column
		end

	make (s: like subcode; l: LOCATION_AS; c: AST_CONTEXT)
			-- Warning object with subcode `s' at location `l' in context `c'.
		require
			valid_s: s = subcode_always_false or s = subcode_always_true
			l_attached: attached l
			c_attached: attached c
			current_feature_attached: attached c.current_feature
		do
			subcode := s
			c.init_error (Current)
			set_location (l)
		ensure
			subcode_set: subcode = s
			class_c_attached: attached class_c
			e_feature_attached: attached e_feature
			location_set: line = l.line and column = l.column
		end

feature -- Properties

	code: STRING = "Alias_analysis_warning"
			-- <Precursor>

	subcode: INTEGER
			-- <Precursor>

feature -- Output

	help_text: LIST [STRING]
			-- Associated help message.
		do
			Result := help_texts [subcode]
		end

feature -- Access

	subcode_always_false: INTEGER = 1
			-- The `subcode' for the message when a boolean expression is always false.

	subcode_always_true: INTEGER = 2
			-- The `subcode' for the message when a boolean expression is always true.

feature {NONE} -- Help texts

	help_texts: ARRAY [LIST [STRING]]
			-- `help_text' corresponding to `subcode'
		once
			create Result.make_empty
			Result.force (create {ARRAYED_LIST [STRING]}.make_from_array (<<"Boolean expression is always False.">>), subcode_always_false)
			Result.force (create {ARRAYED_LIST [STRING]}.make_from_array (<<"Boolean expression is always True.">>), subcode_always_true)
		end

invariant
	subcode_set: subcode = subcode_always_false or subcode = subcode_always_true
	class_c_attached: attached class_c
	e_feature_attached: attached e_feature

note
	copyright:	"Copyright (c) 2012, Eiffel Software"
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
