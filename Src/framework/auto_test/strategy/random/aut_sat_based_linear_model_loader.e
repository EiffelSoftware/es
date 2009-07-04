note
	description: "Summary description for {AUT_SAT_BASED_LINEAR_MODEL_LOADER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_SAT_BASED_LINEAR_MODEL_LOADER

inherit
	AUT_LINEAR_MODEL_LOADER

feature{NONE} -- Initialization

	make (a_operands: like constrained_operands; a_stream: like input_stream) is
			-- Initialize `constrained_operands' with `a_operands' and
			-- `input_stream' with `a_stream'.
		require
			a_operands_attached: a_operands /= Void
			a_stream_attached: a_stream /= Void
		do
			set_constrained_arguments (a_operands)
			set_input_stream (a_stream)
		end

feature -- Access

	input_stream: detachable KL_STRING_INPUT_STREAM
			-- Input stream of model

feature -- Setting

	set_input_stream (a_stream: like input_stream) is
			-- Set `input_stream' with `a_stream'.
		do
			input_stream := a_stream
		ensure
			input_stream_set: input_stream = a_stream
		end

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
