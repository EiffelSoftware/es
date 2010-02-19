note
	description: "EiffelTransform Operators"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_SHARED_OPERATORS
inherit
	ETR_SHARED_BASIC_OPERATORS

feature {NONE} -- Operators

	inspect_replacer: ETR_INSPECT_REPLACER
			-- Shared instance of ETR_INSPECT_REPLACER
		once
			create Result
		end

	assignment_attempt_reaplacer: ETR_ASSIGNMENT_ATTEMPT_REPLACER
			-- Shared instance of ETR_ASSIGNMENT_ATTEMPT_REPLACER
		once
			create Result
		end

	effective_class_generator: ETR_EFFECTIVE_CLASS_GENERATOR
			-- Shared instance of ETR_EFFECTIVE_CLASS_GENERATOR
		once
			create Result
		end

	renamer: ETR_RENAMER
			-- Shared instance of ETR_RENAMER
		once
			create Result
		end

	setter_generator: ETR_SETTER_GENERATOR
			-- Shared instance of ETR_SETTER_GENERATOR
		once
			create Result
		end

	method_extractor: ETR_METHOD_EXTRACTOR
			-- Shared instance of ETR_METHOD_EXTRACTOR
		once
			create Result
		end

	constant_extractor: ETR_CONSTANT_EXTRACTOR
			-- Shared instance of ETR_CONSTANT_EXTRACTOR
		once
			create Result
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
