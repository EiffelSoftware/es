note
	description:

		"Abstract ancestor to all well formed responses received from the interpreter"

	copyright: "Copyright (c) 2006, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class AUT_NORMAL_RESPONSE

inherit

	AUT_RESPONSE
		rename
			make as make_response
		redefine
			is_exception,
			is_precondition_violation,
			is_postcondition_violation,
			is_class_invariant_violation_on_entry,
			is_class_invariant_violation_on_exit
		end

create

	make,
	make_exception

feature {NONE} -- Initialization

	make (a_response_text: like raw_text)
			-- Create new response.
		require
			a_response_text_not_void: a_response_text /= Void
		do
			make_response (a_response_text)
		ensure
			response_text_set: raw_text = a_response_text
			exception_void: exception = Void
		end

	make_exception (a_response_text: like raw_text; an_exception: like exception)
			-- Create new response where an exception was raised.
		require
			a_response_text_not_void: a_response_text /= Void
			an_exception_not_void: an_exception /= Void
		do
			raw_text := a_response_text
			exception := an_exception
		ensure
			response_text_set: raw_text = a_response_text
			exception_set: exception = an_exception
		end

feature -- Status report

	is_bad: BOOLEAN
			-- Is response not well formed syntacticly?
		do
			Result := False
		ensure then
			definition: not Result
		end

	is_error: BOOLEAN
			-- Is response an error message?
		do
			Result := False
		ensure then
			definition: not Result
		end

	is_exception: BOOLEAN
			-- Does response contain an exception from testee feature?
		do
			Result := exception /= Void
		ensure then
			good_result: Result = (exception /= Void)
		end

	has_exception: BOOLEAN
			-- Does `Current' contain an exception from testee?
		do
			Result := exception /= Void
		ensure
			good_result: Result = (exception /= Void)
		end

	is_precondition_violation: BOOLEAN is
			-- Does response contain a precondition violation from the testee feature?
			-- True means current test case is invalid.
		do
			Result := exception /= Void and then exception.code = {EXCEP_CONST}.precondition
		end

	is_postcondition_violation: BOOLEAN is
			-- Does response contain a postcondition violation from the testee feature?
		do
			Result := exception /= Void and then exception.code = {EXCEP_CONST}.postcondition
		end

	is_class_invariant_violation_on_entry: BOOLEAN is
			-- Does response contain a class invariant violation on feature entry?
		do
			Result := exception /= Void and then exception.is_invariant_violation_on_feature_entry
		end

	is_class_invariant_violation_on_exit: BOOLEAN is
			-- Does response contain a class invariant violation on feature exit?
		do
			Result := exception /= Void and then exception.code = {EXCEP_CONST}.class_invariant and then not (exception.is_invariant_violation_on_feature_entry)
		end

feature -- Access

	exception: AUT_EXCEPTION
			-- Exception raised during request execution (if any)

feature -- Process

	process (a_visitor: AUT_RESPONSE_VISITOR)
			-- Process `Current' using `a_visitor'.
		do
			a_visitor.process_normal_response (Current)
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
