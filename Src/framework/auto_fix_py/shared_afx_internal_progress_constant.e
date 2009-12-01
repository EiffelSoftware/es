note
	description: "Summary description for {SHARED_AFX_INTERNAL_PROGRESS_CONSTANT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_AFX_INTERNAL_PROGRESS_CONSTANT

feature -- Proposer

	Start_phase_finished_fraction: REAL = 0.05
	Fix_synthesizer_finished_fraction: REAL = 0.45
	System_adjuster_finished_fraction: REAL = 0.6
	Fix_evaluation_phase_i_finished_fraction: REAL = 0.9
	Fix_evaluation_phase_ii_finished_fraction: REAL = 0.95

feature -- Synthesizer

	Failure_explanation_phase_fraction: REAL = 0.05
		-- added together, we should have "Fix_synthesizer_finished_fraction - Start_phase_finished_fraction"
	Position_collection_phase_fraction: REAL = 0.1
	Fixing_target_collection_phase_fraction: REAL = 0.1
	Tune_generation_phase_fraction: REAL = 0.1
	Fix_registration_phase_fraction: REAL = 0.1


invariant

	Start_phase_finished_fraction = Failure_explanation_phase_fraction
	Fix_synthesizer_finished_fraction - Start_phase_finished_fraction = Position_collection_phase_fraction + Fixing_target_collection_phase_fraction
		+ Tune_generation_phase_fraction + Fix_registration_phase_fraction

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
