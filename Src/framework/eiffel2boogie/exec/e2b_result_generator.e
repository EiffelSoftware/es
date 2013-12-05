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
			last_result.autoproof_errors.append (autoproof_errors)
				-- Add Boogie errors
			across a_boogie_result.boogie_errors as i loop
				create l_ap_error
				l_ap_error.set_type ("Boogie error")
				l_ap_error.set_single_line_message (i.item)
				last_result.autoproof_errors.extend (l_ap_error)
			end
				-- Call result handler for each Boogie procedure
			across a_boogie_result.procedure_results as i loop
				process_procedure_result (i.item)
			end
		end

feature -- Implementation

	process_procedure_result (a_item: E2B_BOOGIE_PROCEDURE_RESULT)
			-- Process procedure result.
		local
			l_agent: PROCEDURE [ANY, TUPLE [E2B_BOOGIE_PROCEDURE_RESULT, E2B_RESULT]]
		do
			if result_handlers.has_key (a_item.name) then
				l_agent.call ([a_item, last_result])
			else
				process_default_result (a_item)
			end
		end

	process_default_result (a_item: E2B_BOOGIE_PROCEDURE_RESULT)
			-- Default handler for Boogie procedure results.
		local
			l_success: E2B_SUCCESSFUL_VERIFICATION
		do
			check name_translator.feature_for_boogie_name (a_item.name) /= Void end
			if a_item.is_successful then
				create l_success.set_procedure_name (a_item.name)
				l_success.set_time (a_item.time)
				last_result.procedure_results.extend (l_success)
			elseif a_item.is_inconclusive then

			else
				check a_item.is_error end
				process_default_error (a_item)
			end
		end

	process_default_error (a_item: E2B_BOOGIE_PROCEDURE_RESULT)
			-- Handler for mapping Boogie procedure errors to Eiffel.
		require
			is_error: a_item.is_error
		local
			l_failure: E2B_FAILED_VERIFICATION
			l_error: E2B_VERIFICATION_ERROR
		do
			create l_failure.make (a_item.name)
			l_failure.set_time (a_item.time)
			across a_item.errors as i loop
				l_error := process_individual_error (i.item)
				l_failure.errors.extend (l_error)
			end
			last_result.procedure_results.extend (l_failure)
		end

	process_individual_error (a_error: E2B_BOOGIE_PROCEDURE_ERROR): E2B_VERIFICATION_ERROR
			-- Handle individual Boogie procedure error.
		local
			l_e: E2B_VIOLATION
		do
			if a_error.has_related_location then
				create l_e.make_with_description (a_error.error_code, a_error.line_text, a_error.line_text + "%N" + a_error.related_line_text)
			else
				create l_e.make_with_description (a_error.error_code, a_error.line_text, a_error.line_text)
			end

			Result := l_e
		end

end
