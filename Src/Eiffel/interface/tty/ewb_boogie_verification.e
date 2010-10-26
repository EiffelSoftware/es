note
	description: "Summary description for {EWB_BOOGIE_VERIFICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_BOOGIE_VERIFICATION

inherit

	EWB_CMD

	SHARED_EP_ENVIRONMENT
		rename
			Warnings as Boogie_warnings
		export
			{NONE} all
		end

	SHARED_ERROR_HANDLER
		export {NONE} all end

	COMPILER_EXPORTER

feature -- Properties

	name: STRING
		do
			Result := "Boogie Verification"
		end

	help_message: STRING_GENERAL
		do
			Result := "Verify project using Boogie verifier"
		end

	abbreviation: CHARACTER
		do
			Result := 'b'
		end

feature -- Execution

	execute
			-- <Precursor>
		local
			l_groups: LIST [CONF_GROUP]
			l_cluster: CLUSTER_I
			l_proof_event: EVENT_LIST_PROOF_ITEM_I
		do
			eve_proofs.reset
			eve_proofs.register_message_callbacks (agent (s: STRING) do output_window.put_string (s) output_window.put_new_line end, agent (s: STRING) do end)
			from
				l_groups := eiffel_universe.groups
				l_groups.start
			until
				l_groups.after
			loop
				l_cluster ?= l_groups.item_for_iteration
					-- Only load top-level clusters, as they are loaded recursively afterwards
				if l_cluster /= Void and then l_cluster.parent_cluster = Void then
					load_cluster (l_cluster)
				end
				l_groups.forth
			end

			if eve_proofs.classes_to_verify.is_empty then
				output_window.put_string (names.message_no_classes_to_proof)
				output_window.put_new_line
			else
				eve_proofs.execute_verification
			end

				-- Add warninigs and errors
			--error_handler.warning_list.append (boogie_warnings)
			--error_handler.warning_list.finish
			--error_handler.error_list.append (errors)
			--error_handler.error_list.finish
				-- Display warnings
			--error_handler.trace

			if event_list.is_service_available then
				from
					event_list.service.all_items.start
					event_list.service.all_items.start
				until
					event_list.service.all_items.after
				loop
					l_proof_event ?= event_list.service.all_items.item_for_iteration
					if l_proof_event /= Void then
						print_event (l_proof_event)
					end
					event_list.service.all_items.forth
				end
			end
		end

	load_class (a_class: CLASS_I)
			-- Load `a_class' for verification.
		local
			l_class_c: CLASS_C
		do
			if a_class.is_compiled then
				l_class_c := a_class.compiled_class
				check l_class_c /= Void end
				eve_proofs.add_class_to_verify (l_class_c)
			end
		end

	load_cluster (a_cluster: CLUSTER_I)
			-- Load `a_cluster' for verification.
		require
			a_cluster_not_void: a_cluster /= Void
		local
			l_conf_class: CONF_CLASS
			l_class_i: CLASS_I
		do
			from
				a_cluster.classes.start
			until
				a_cluster.classes.after
			loop
				l_conf_class := a_cluster.classes.item_for_iteration
				l_class_i := eiffel_universe.class_named (l_conf_class.name, a_cluster)
				load_class (l_class_i)
				a_cluster.classes.forth
			end
			if a_cluster.sub_clusters /= Void then
				from
					a_cluster.sub_clusters.start
				until
					a_cluster.sub_clusters.after
				loop
					load_cluster (a_cluster.sub_clusters.item_for_iteration)
					a_cluster.sub_clusters.forth
				end
			end
		end

	frozen event_list: SERVICE_CONSUMER [EVENT_LIST_S]
			-- Access to an event list service {EVENT_LIST_S} consumer
		once
			create Result
		ensure
			result_attached: Result /= Void
		end

	print_event (a_proof_event: EVENT_LIST_PROOF_ITEM_I)
			-- Print event `a_proof_event' to console.
		local
			l_successful: EVENT_LIST_PROOF_SUCCESSFUL_ITEM
			l_failed: EVENT_LIST_PROOF_FAILED_ITEM
			l_skipped: EVENT_LIST_PROOF_SKIPPED_ITEM
		do
			l_successful ?= a_proof_event
			l_failed ?= a_proof_event
			l_skipped ?= a_proof_event

			if l_successful /= Void then
				print_successful (l_successful)
			elseif l_failed /= Void then
				from
					l_failed.error_list.start
				until
					l_failed.error_list.after
				loop
					print_error (l_failed.error_list.item, l_failed)
					l_failed.error_list.forth
				end
			elseif l_skipped /= Void then
				print_skipped (l_skipped)
			end
		end

	print_successful (a_event: EVENT_LIST_PROOF_SUCCESSFUL_ITEM)
		do
			output_window.add ("--------------------------------------%N")
			output_window.add ("Type: successful%N")
			output_window.add ("Title: proof successful%N")
			print_class_and_feature (a_event)
			print_time (a_event)
		end

	print_skipped (a_event: EVENT_LIST_PROOF_SKIPPED_ITEM)
		do
			output_window.add ("--------------------------------------%N")
			output_window.add ("Type: skipped%N")
			output_window.add ("Title: proof skipped%N")
			print_class_and_feature (a_event)

			if a_event.description /= Void then
				output_window.add ("Information: %N")
				output_window.add (a_event.description)
				output_window.add_new_line
			end
		end

	print_error (a_error: EP_ERROR; a_proof_event: EVENT_LIST_PROOF_FAILED_ITEM)
			-- Print error to console.
		local
			l_verification_error: EP_VERIFICATION_ERROR
		do
			output_window.add ("--------------------------------------%N")
			output_window.add ("Type: failed%N")
			output_window.add ("Title: ")
			a_error.trace_single_line (output_window)
			output_window.add_new_line

			print_class_and_feature (a_proof_event)

			l_verification_error ?= a_error
			if l_verification_error /= Void and then l_verification_error.tag /= Void then
				output_window.add ("Tag: ")
				output_window.add (l_verification_error.tag)
				output_window.add_new_line
			end

			if a_error.line > 0 then
				output_window.add ("Line: ")
				output_window.add (a_error.line.out)
				output_window.add_new_line
			end

			print_time (a_proof_event)

			if a_error.message /= Void then
				output_window.add ("Message: ")
				output_window.add (a_error.message)
				output_window.add_new_line
			end

			if a_error.description /= Void then
				output_window.add ("Information: %N")
				output_window.add (a_error.description)
				output_window.add_new_line
			end

			output_window.add_new_line
		end

	print_class_and_feature (a_proof_event: EVENT_LIST_PROOF_ITEM_I)
		do
			output_window.add ("Class: ")
			output_window.add_class (a_proof_event.context_class.original_class)
			output_window.add_new_line

			output_window.add ("Feature: ")
			output_window.add_feature (a_proof_event.context_feature.e_feature, a_proof_event.context_feature.feature_name)
			output_window.add_new_line
		end

	print_time (a_proof_event: EVENT_LIST_PROOF_ITEM_I)
		do
			output_window.add ("Time: ")
			output_window.add (a_proof_event.milliseconds_used.out)
			output_window.add_new_line
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
