note
	description: "Summary description for {EBB_CA_VERIFICATION_RESULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_CA_VERIFICATION_RESULT

inherit
	DOUBLE_MATH

	EBB_VERIFICATION_RESULT
		rename make as make_ end

create
	make

feature {NONE} -- Initialization

	make (a_feature: FEATURE_I; a_configuration: EBB_TOOL_CONFIGURATION; a_errors: INTEGER; a_warnings: INTEGER; a_hints: INTEGER)
			-- Initialize result.
		local
			l_score, l_weight: REAL_64
		do
			errors := a_errors
			warnings := a_warnings
			hints := a_hints

			if errors > 0 then
				l_score := -1
				l_weight := 1
			else
				l_score := 0 - a_warnings * 0.1

				if l_score = 0 and a_hints = 0 then
					l_weight := 0
				else
					l_weight := (1.0).min(sqrt(a_warnings / 10))
				end
			end

			make_ (a_feature, a_configuration, l_score.truncated_to_real)

			weight := l_weight.truncated_to_real
		end

feature -- Access

	message: STRING
		do
			Result := "The analysis returned " + errors.out + " errors, " + warnings.out + " warnings and " + hints.out + " hints."
		end

	warnings: INTEGER

	errors: INTEGER

	hints: INTEGER

invariant
note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
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
