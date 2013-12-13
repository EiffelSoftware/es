note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_RESULT_GENERATOR

inherit

	E2B_SHARED_CONTEXT

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize.
		do

		end

feature -- Access

	last_result: detachable E2B_RESULT
			-- Last generated result.

feature -- Basic operations

	process_boogie_result (a_boogie_result: E2B_BOOGIE_RESULT)
			-- Process `a_boogie_result'.
		local
			l_ap_error: E2B_AUTOPROOF_ERROR
		do
			create last_result.make
				-- Add AutoProof errors
			last_result.verification_results.append (autoproof_errors)
				-- Add Boogie errors
			across a_boogie_result.boogie_errors as i loop
				create l_ap_error
				l_ap_error.set_type ("Boogie")
				l_ap_error.set_message (i.item)
				last_result.verification_results.extend (l_ap_error)
			end
				-- Call result handler for each Boogie procedure
			across a_boogie_result.procedure_results as i loop
				process_procedure_result (i.item)
			end
		end

feature {NONE} -- Implementation

	process_procedure_result (a_item: E2B_BOOGIE_PROCEDURE_RESULT)
			-- Process procedure result.
		local
			l_agent: PROCEDURE [ANY, TUPLE [E2B_BOOGIE_PROCEDURE_RESULT, E2B_RESULT]]
		do
			if result_handlers.has_key (a_item.name) then
				l_agent := result_handlers[a_item.name]
				l_agent.call ([a_item, last_result])
			else
				process_default_result (a_item)
			end
		end

	has_validity_error (a_feature: FEATURE_I): BOOLEAN
			-- Does `a_item' refer to a feature with a validty error?
		local
			l_errors: LIST [E2B_AUTOPROOF_ERROR]
			l_error: E2B_AUTOPROOF_ERROR
		do
			from
				l_errors := last_result.autoproof_errors
				l_errors.start
			until
				l_errors.after or Result
			loop
				l_error := l_errors.item
				if
					l_error.context_class /= Void and then
					l_error.context_class.class_id = a_feature.written_in and then
					l_error.context_feature /= Void and then
					l_error.context_feature.rout_id_set.first = a_feature.rout_id_set.first
				then
					Result := True
				end
				l_errors.forth
			end
		end

	process_default_result (a_item: E2B_BOOGIE_PROCEDURE_RESULT)
			-- Default handler for Boogie procedure results.
		local
			l_feature: FEATURE_I
			l_context: STRING
			l_success: E2B_SUCCESSFUL_VERIFICATION
			l_inconclusive: E2B_INCONCLUSIVE_RESULT
			l_failure: E2B_FAILED_VERIFICATION
		do
			l_feature := name_translator.feature_for_boogie_name (a_item.name)
			if a_item.name.starts_with ("create.") then
				l_context := "creator"
			end
			check l_feature /= Void end
			if has_validity_error (l_feature) then
					-- Ignore results of features with a validity error
			elseif a_item.is_successful then
				create l_success
				l_success.set_feature (l_feature)
				l_success.set_verification_context (l_context)
				l_success.set_time (a_item.time)
				last_result.add_result (l_success)
			elseif a_item.is_inconclusive then
				create l_inconclusive.make
				l_inconclusive.set_feature (l_feature)
				l_inconclusive.set_verification_context (l_context)
				last_result.add_result (l_inconclusive)
			else
				check a_item.is_error end
				create l_failure.make
				l_failure.set_feature (l_feature)
				l_failure.set_verification_context (l_context)
				l_failure.set_time (a_item.time)
				across a_item.errors as i loop
					process_individual_error (i.item, l_failure)
				end
				last_result.add_result (l_failure)
			end
		end

	process_individual_error (a_error: E2B_BOOGIE_PROCEDURE_ERROR; a_failure: E2B_FAILED_VERIFICATION)
			-- Handle individual Boogie procedure error.
		local
			l_error: E2B_DEFAULT_VERIFICATION_ERROR
		do
			create l_error.make (a_failure)
			a_failure.errors.extend (l_error)
			l_error.set_boogie_error (a_error)
			l_error.set_message (message_for_error (a_error))
			l_error.set_line_number (line_for_error (a_error))
		end

	message_for_error (a_error: E2B_BOOGIE_PROCEDURE_ERROR): STRING_32
			-- Select message for `a_error'.
		local
			l_type, l_tag: STRING
			l_has_tag: BOOLEAN
		do
			if a_error.has_related_location then
					-- It's a pre- or postcondition violation
				l_type := a_error.related_attributes["type"]
				l_tag := a_error.related_attributes["tag"]
				l_has_tag := a_error.related_attributes.has_key ("tag")
			else
				l_type := a_error.attributes["type"]
				l_tag := a_error.attributes["tag"]
				l_has_tag := a_error.attributes.has_key ("tag")
			end

			if l_type ~ "check" then
					-- Check violation
				if l_has_tag then
					Result := messages.check_with_tag_violated
				else
					Result := messages.check_violated
				end
			elseif l_type ~ "pre" then
					-- Precondition violation
				if l_has_tag then
					Result := messages.precondition_with_tag_violated
				else
					Result := messages.precondition_violated
				end
			elseif l_type ~ "post" then
					-- Postcondition violation
				if l_has_tag then
					Result := messages.postcondition_with_tag_violated
				else
					Result := messages.postcondition_violated
				end
			elseif l_type ~ "loop_inv" then
				if a_error.is_loop_inv_violated_on_entry then
					if l_has_tag then
						Result := messages.loop_inv_with_tag_violated_on_entry
					else
						Result := messages.loop_inv_violated_on_entry
					end
				else
					check a_error.is_loop_inv_not_maintained end
					if l_has_tag then
						Result := messages.loop_inv_with_tag_not_maintained
					else
						Result := messages.loop_inv_not_maintained
					end
				end
			elseif l_type ~ "loop_var_ge_zero" then
				if l_has_tag then
					Result := messages.loop_var_with_tag_negative
				else
					Result := messages.loop_var_negative
				end
			elseif l_type ~ "loop_var_decr" then
				if l_has_tag then
					Result := messages.loop_var_with_tag_not_decreasing
				else
					Result := messages.loop_var_not_decreasing
				end
			elseif l_type ~ "attached" then
					-- Possible void call
				if a_error.is_assert_error then
					Result := messages.void_call
				elseif a_error.is_precondition_violation then
					if l_has_tag then
						Result := messages.void_call_in_precondition_with_tag
					else
						Result := messages.void_call_in_precondition
					end
				elseif a_error.is_postcondition_violation then
					if l_has_tag then
						Result := messages.void_call_in_postcondition_with_tag
					else
						Result := messages.void_call_in_postcondition
					end
				else
					Result := messages.void_call
				end
			elseif l_type ~ "termination" then
				check a_error.is_assert_error end
				check l_has_tag end
				if l_tag ~ "variant_decreases" then
					Result := messages.decreases_not_decreasing
				elseif l_tag.starts_with ("bounded") then
					Result := messages.decreases_bounded (l_tag.substring (8, l_tag.count))
				else
					check internal_error: False end
				end
			elseif l_type ~ "overflow" then
					-- Arithmetic overflow
				if a_error.is_assert_error then
					Result := messages.overflow
				elseif a_error.is_precondition_violation then
					if l_has_tag then
						Result := messages.overflow_in_precondition_with_tag
					else
						Result := messages.overflow_in_precondition
					end
				elseif a_error.is_postcondition_violation then
					if l_has_tag then
						Result := messages.overflow_in_postcondition_with_tag
					else
						Result := messages.overflow_in_postcondition
					end
				else
					Result := messages.overflow
				end
			elseif l_type ~ "assign" then
					-- Attribute update failed
				check a_error.is_precondition_violation end
				check l_has_tag end
				if l_tag ~ "attached_and_allocated" then
					Result := messages.assignment_attached_and_allocated
				elseif l_tag ~ "closed_or_owner_not_allowed" then
					Result := messages.assignment_closed_or_owner_not_allowed
				elseif l_tag ~ "target_open" then
					Result := messages.assignment_target_open
				elseif l_tag ~ "observers_open_or_inv_preserved" then
					Result := messages.assignment_observers_open_or_inv_preserved
				elseif l_tag ~ "attribute_writable" then
					Result := messages.assignment_attribute_writable
				else
					check internal_error: False end
				end
			else
					-- default error message
				if l_has_tag then
					Result := "$type error with tag $tag."
				else
					Result := "$type error."
				end
			end
			if a_error.is_postcondition_violation then
				if a_error.related_attributes.has_key ("default") then
					Result := Result + " " + messages.ownership_explicit_note
				end
			else
				if a_error.attributes.has_key ("default") then
					Result := Result + " " + messages.ownership_explicit_note
				end
			end
		end

	line_for_error (a_error: E2B_BOOGIE_PROCEDURE_ERROR): INTEGER
			-- Select line number for `a_error'.
		do
			if a_error.is_postcondition_violation then
				if a_error.related_attributes.has_key ("line") then
					Result := a_error.related_attributes["line"].to_integer
				end
			else
				if a_error.attributes.has_key ("line") then
					Result := a_error.attributes["line"].to_integer
				end
			end
		end

end
