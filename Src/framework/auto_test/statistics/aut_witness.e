note
	description:

		"Sequence of requests with their responses that are witness to an observation of that execution"

	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class AUT_WITNESS

inherit
	AUT_REQUEST_LIST
		export {ANY} all
		redefine
			make

		end

	EXCEP_CONST
		export {NONE} all end

	REFACTORING_HELPER

	AUT_ABS_WITNESS
		undefine
			request_list,
			count
		end

create

	make,
	make_default

feature {NONE} -- Initialization

	make (a_list: like list; a_first_index: like first_index; a_last_index: like last_index)
			-- Create new witness.
		do
			Precursor (a_list, a_first_index, a_last_index)
			request := item (count)
			judge
		end

feature -- Access

	set_used_vars (a_used_vars: like used_vars)
		do
			used_vars := a_used_vars
		ensure
			used_vars_set: used_vars = a_used_vars
		end

feature -- Deltas

	deltas (n: INTEGER): DS_LINEAR [DS_LIST [AUT_REQUEST]]
			-- Request list divided into `n' parts.
			-- Requests will be fresh.
		require
			n_big_enough: n >= 2
			n_small_enough: n <= count
		local
		do
		ensure
			delta_not_void: Result /= Void
			delta_doesn_have_void: not Result.has (Void)
			delta_size_correct: Result.count = n
		end

	deltas_complement (i: INTEGER; n: INTEGER): DS_LIST [AUT_REQUEST]
			-- All but the `i'-th complement of the `n' delta list of the current requests.
			-- Requests will be fresh.
		require
			i_big_enough: i >= 1
			i_small_enough: i <= n
			n_big_enough: n >= 2
			n_small_enough: n <= count
		do
		ensure
			delta_not_void: Result /= Void
			delta_doesn_have_void: not Result.has (Void)
		end

invariant

	mutal_is_pass: is_pass = (not is_fail and not is_invalid and not is_bad_response)
	mutal_is_fail: is_fail = (not is_pass and not is_invalid and not is_bad_response)
	mutal_is_invalid: is_invalid = (not is_pass and not is_fail and not is_bad_response)
	mutal_is_bad_response: is_bad_response = (not is_pass and not is_fail and not is_invalid)
	classifications_not_void: classifications /= Void
	no_classification_void: not classifications.has (Void)
	at_most_one_classification: classifications.count <= 1

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
