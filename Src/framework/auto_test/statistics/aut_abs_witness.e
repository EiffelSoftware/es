note
	description: "Summary description for {AUT_ABS_WITNESS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_ABS_WITNESS

create
	make_with_request

feature{NONE} -- Implementation

	make_with_request (a_request: like request)
			-- Initialize Current with `a_request'.
		do
			request := a_request
			judge
		end

feature -- Access

	request: AUT_REQUEST
			-- Interpreter of current witness

	classifications: DS_ARRAYED_LIST [AUT_TEST_CASE_RESULT]
			-- Classifcations resulting from this witness

	request_list: DS_LIST [AUT_REQUEST]
			-- List of all requests
		local
			arrayed_list: DS_ARRAYED_LIST [AUT_REQUEST]
			i: INTEGER
		do
			create arrayed_list.make (1)
			arrayed_list.force_last (request)
			Result := arrayed_list
		ensure
			request_list_not_void: Result /= Void
			no_request_void: not Result.has (Void)
			list_has_request: Result.has (request)
		end

	used_vars: DS_HASH_TABLE [TUPLE [type: detachable TYPE_A; name: detachable STRING; check_dyn_type: BOOLEAN; use_void: BOOLEAN], ITP_VARIABLE]
			-- Set of used variables: keys are variables, items are tuples of static type of variable
			-- and a boolean flag showing if the static type should be checked against dynamic type
			-- (is only the case for variables returned as results of function calls and those whose type
			-- is left Void)

	count: INTEGER
			-- Number of requests
		do
			Result := 1
		end

feature -- Status report

	is_pass: BOOLEAN
			-- Did test case pass?

	is_fail: BOOLEAN
			-- Did test case fail? This means a bug was found.

	is_invalid: BOOLEAN
			-- Was test case not executable because a prerequisite was not
			-- established? Most often this means a precondition was violated.

	is_bad_response: BOOLEAN
			-- Did an unknown error occure that made the interpreter respond
			-- in an unexpected way?

	is_same_bug (other: like Current): BOOLEAN
			-- Is `other' witnessing the same bug as this witness?
			-- Note that this is a heuristics that considers class, feature and exception only.
		require
			other_not_void: other /= Void
			witnesses_fail: is_fail and other.is_fail
		local
			cs: DS_LINEAR_CURSOR [AUT_TEST_CASE_RESULT]
			cs_other: DS_LINEAR_CURSOR [AUT_TEST_CASE_RESULT]
			response: AUT_NORMAL_RESPONSE
			other_response: AUT_NORMAL_RESPONSE
		do
			Result := classifications.count = other.classifications.count
			if Result then
				from
					cs := classifications.new_cursor
					cs.start
					cs_other := other.classifications.new_cursor
					cs_other.start
				until
					cs.off or not Result
				loop
					Result := (cs.item.class_ = cs_other.item.class_) and (cs.item.feature_ = cs_other.item.feature_)
					cs.forth
					cs_other.forth
				end
				cs.go_after
				cs_other.go_after
			end
			if Result then
				response ?= request.response
				other_response ?= other.request.response
				check
					response_not_void: response /= Void
					other_response_not_void: other_response /= Void
				end
				Result := response.exception.code = other_response.exception.code and
							equal (response.exception.class_name, other_response.exception.class_name) and
							equal (response.exception.recipient_name, other_response.exception.recipient_name) and
							equal (response.exception.tag_name, other_response.exception.tag_name) and
							equal (response.exception.break_point_slot, other_response.exception.break_point_slot)
			end
		end

	is_same_original_bug (other: like Current): BOOLEAN is
			-- Is `other' witnessing the same original bug as this witness?
			-- Note that this is a heuristics that considers class, feature and exception only.
		require
			other_not_void: other /= Void
			witnesses_fail: is_fail and other.is_fail
		local
			response: AUT_NORMAL_RESPONSE
			other_response: AUT_NORMAL_RESPONSE
		do
			response ?= request.response
			other_response ?= other.request.response
			check
				response_not_void: response /= Void
				other_response_not_void: other_response /= Void
			end
			Result := response.exception.code = other_response.exception.code and
						equal (response.exception.class_name, other_response.exception.class_name) and
						equal (response.exception.recipient_name, other_response.exception.recipient_name) and
						equal (response.exception.tag_name, other_response.exception.tag_name) and
						equal (response.exception.break_point_slot, other_response.exception.break_point_slot)
		end

feature {NONE} -- Implementation

	judge
			-- Judge current witness.
		local
			last_request: AUT_REQUEST
			normal_response: AUT_NORMAL_RESPONSE
			classification: AUT_TEST_CASE_RESULT
			invoke_request: AUT_INVOKE_FEATURE_REQUEST
			create_request: AUT_CREATE_OBJECT_REQUEST
			feature_: FEATURE_I
			class_: CLASS_C
		do
			create {DS_ARRAYED_LIST [AUT_TEST_CASE_RESULT]} classifications.make (1)
			last_request := request
			create_request ?= last_request
			invoke_request ?= last_request

			if create_request /= Void then
				class_ := create_request.class_of_target_type
				if create_request.creation_procedure /= Void then
					feature_ := create_request.creation_procedure
				else
					feature_ := class_.default_create_feature
				end
			elseif invoke_request /= Void then
				if invoke_request.target_type /= Void then
					class_ := invoke_request.class_of_target_type
					feature_ := invoke_request.feature_to_call
				end
			end
			check
				consistent: (feature_ /= Void) = (class_ /= Void)
			end
			if last_request.response /= Void then
				if last_request.response.is_bad or last_request.response.is_error then
					is_bad_response := True
					if feature_ /= Void then
						create classification.make (Current, class_, feature_)
						classifications.force_last (classification)
					end
				else
					normal_response ?= last_request.response
					check
						normal_response_not_void: normal_response /= Void
					end
					if normal_response.exception = Void then
						is_pass := True
						if feature_ /= Void then
							create classification.make (Current, class_, feature_)
							classifications.force_last (classification)
						end
					else
						if not normal_response.exception.is_test_invalid then
							is_fail := True
							-- TODO: if the exception trace is bigger than one, we should create a classification
							-- for each routine that failed, not only for the bottom most
							if feature_ /= Void then
								create classification.make (Current, class_, feature_)
								classifications.force_last (classification)
							end
						else
							is_invalid := True
							if feature_ /= Void then
								create classification.make (Current, class_, feature_)
								classifications.force_last (classification)
							end
						end
					end
				end
			else
				-- No response recorded (maybe the request was not executed because of an inconsistency) -> invalid
				is_invalid := True
			end
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
