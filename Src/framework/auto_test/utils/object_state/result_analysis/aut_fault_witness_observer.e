note
	description: "Summary description for {AUT_FAULT_WITNESS_OBSERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_FAULT_WITNESS_OBSERVER

inherit
	AUT_WITNESS_OBSERVER
		redefine
			system
		end

create
	make

feature{NONE} -- Initialization

	make (a_system: like system) is
			-- Initialize.
		do
			system := a_system
			create witnesses.make (50)
			witnesses.set_equality_tester (faulty_witness_equality_tester)
		ensure
			system_set: system = a_system
		end

feature -- Access

	witnesses: DS_ARRAYED_LIST [AUT_ABS_WITNESS]
			-- Table of witnesses revealing faults

feature -- Process

	process_witness (a_witness: AUT_ABS_WITNESS) is
			-- Handle `a_witness'.
		do
			if a_witness.is_fail and then not witnesses.has (a_witness) then
				witnesses.force_last (a_witness)
			end
		end

feature{NONE} -- Implementation

	system: SYSTEM_I;
			-- Current system

	faulty_witness_equality_tester: AGENT_BASED_EQUALITY_TESTER [AUT_WITNESS] is
			-- Tester to decide if `a_witness' and `b_witness' reveals the same fault
		do
			create Result.make (agent (a_witness, b_witness: AUT_WITNESS): BOOLEAN
				do
					Result :=
						a_witness.is_fail and then
						b_witness.is_fail and then
						a_witness.is_same_original_bug (b_witness)
				end)
		end

;note
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
