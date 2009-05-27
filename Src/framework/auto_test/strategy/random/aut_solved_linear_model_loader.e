note
	description: "Summary description for {AUT_MODEL_LOADER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_SOLVED_LINEAR_MODEL_LOADER

--feature{NONE} -- Initialization

--	make (a_input_stream: like input_stream; a_constrained_arguments: like constrained_arguments) is
--			-- Initialize.
--		do
--			input_stream := a_input_stream
--			create constrained_arguments.make (a_constrained_arguments.count)
--			constrained_arguments.set_equality_tester (create {AGENT_BASED_EQUALITY_TESTER [STRING]}.make (agent (a, b: STRING): BOOLEAN do Result := a.is_equal (b) end))

--			create valuation.make (a_constrained_arguments.count)
--			valuation.compare_objects

--			from
--				a_constrained_arguments.start
--			until
--				a_constrained_arguments.after
--			loop
--				constrained_arguments.force_last (a_constrained_arguments.item_for_iteration)
--				a_constrained_arguments.forth
--			end
--		end

feature -- Access

	constrained_arguments: DS_HASH_SET [STRING]
			-- List of names of constrained arguments

	valuation: HASH_TABLE [INTEGER, STRING]
			-- Valuation of arguments
			-- Has effect only if `has_model' is True

	input_stream: detachable KL_STRING_INPUT_STREAM
			-- Input stream of model

feature -- Status report

	has_model: BOOLEAN
			-- Is there a model where constrained arguments have valuation?

feature -- Basic operations

	load_model is
			-- Load model from `input_stream'.
			-- If there is a model for `constrained_arguments', set `has_model' to True,
			-- and then load valuations of constrained arguments into `valuation'.
		deferred
		end

feature -- Setting

	set_constrained_arguments (a_args: like constrained_arguments) is
			-- Set `constrained_arguments' with `a_args'.
		do
			create constrained_arguments.make (a_args.count)
			constrained_arguments.set_equality_tester (create {KL_STRING_EQUALITY_TESTER})
			a_args.do_all (agent constrained_arguments.force_last)
		end

	set_input_stream (a_stream: like input_stream) is
			-- Set `input_stream' with `a_stream'.
		do
			input_stream := a_stream
		ensure
			input_stream_set: input_stream = a_stream
		end

;note
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
