note
	description: "Command line command for Boogie verification"
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_BOOGIE_VERIFICATION

inherit

	EWB_CMD

	SHARED_ERROR_HANDLER
		export {NONE} all end

	COMPILER_EXPORTER

	INTERNAL_COMPILER_STRING_EXPORTER

create
	make_with_arguments

feature {NONE} -- Initialization

	make_with_arguments (a_arguments: LINKED_LIST [STRING])
			-- Initialize with `a_arguments'.
		require
			a_arguments_attached: a_arguments /= Void
		do
			create options.make
			create selection.make
			from
				a_arguments.start
			until
				a_arguments.after
			loop
				if a_arguments.item.starts_with ("-") then
					options.extend (a_arguments.item)
				else
					selection.extend (a_arguments.item)
				end
				a_arguments.forth
			end
		end

feature -- Properties

	options: LINKED_LIST [STRING]
			-- Option arguments to Boogie command line.

	selection: LINKED_LIST [STRING]
			-- Class and feature selection arguments to Boogie command line.

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
			l_proof_event: EVENT_LIST_PROOF_ITEM_I
			l_boogie_universe: IV_UNIVERSE
			l_translator: E2B_TRANSLATOR
			l_boogie_generator: E2B_BOOGIE_GENERATOR
			l_verifier: E2B_VERIFIER
			l_result: E2B_RESULT
			l_context: E2B_SHARED_CONTEXT
		do
				-- Load options
			if options.has ("-abc") then

			end

				-- Load selection, add it to `translator_input'
			create translator_input.make
			if selection.is_empty then
				load_universe
			else
				load_selection
			end

				-- Translate elements
			from
				create l_boogie_universe.make
				create l_translator.make (l_boogie_universe)
				l_translator.add_input (translator_input)
			until
				not l_translator.has_next_step
			loop
				l_translator.step
			end

				-- Generate Boogie code
			create l_boogie_generator.make (l_boogie_universe)
			l_boogie_generator.generate_verifier_input

				-- Run Boogie verifier
			create l_verifier.make
			l_verifier.set_input (l_boogie_generator.last_generated_verifier_input)
			l_verifier.verify
			l_result := l_verifier.last_result

--			if l_result.has_verification_errors then
--				create l_context
--				create l_boogie_universe.make
--				create l_translator.make (l_boogie_universe)
--				across l_result.verification_errors as i loop
--					-- TODO: set up inlining for
--					l_translator.add_feature_of_type (i.item.eiffel_feature, i.item.eiffel_class.actual_type)
--					l_context.options.routines_to_inline.extend (i.item.eiffel_feature.body_index)

--				end
--				from until not l_translator.has_next_step loop
--					l_translator.step
--				end
--				create l_boogie_generator.make (l_boogie_universe)
--				l_boogie_generator.generate_verifier_input
--				create l_verifier.make
--				l_verifier.set_input (l_boogie_generator.last_generated_verifier_input)
--				l_verifier.verify
--				across l_verifier.last_result.verified_procedures as j loop
--					l_result.verified_procedures.extend (j.item)
--					from
--						l_result.verification_errors.start
--					until
--						l_result.verification_errors.after
--					loop
--						if l_result.verification_errors.item.eiffel_feature.body_index = j.item.eiffel_feature.body_index then
--							l_result.verification_errors.remove
--						else
--							l_result.verification_errors.forth
--						end
--					end
--				end
--			end



				-- Create output
			l_result.verified_procedures.do_all (
				agent (l_proc: E2B_PROCEDURE_RESULT)
					do
						io.put_string ("Verified: {" + l_proc.eiffel_class.name + "}." + l_proc.eiffel_feature.feature_name)
						io.put_new_line
					end
			)
			l_result.verification_errors.do_all (
				agent (l_proc: E2B_VERIFICATION_ERROR)
					do
						io.put_string ("Failed: {" + l_proc.eiffel_class.name + "}." + l_proc.eiffel_feature.feature_name)
						if l_proc.is_attached_violation then
							io.put_string (" attached violation")
						elseif l_proc.is_check_violation then
							io.put_string (" check violation")
						elseif l_proc.is_frame_condition_violation then
							io.put_string (" frame violation")
						elseif l_proc.is_invariant_violation then
							io.put_string (" invariant violation")
						elseif l_proc.is_postcondition_violation then
							io.put_string (" postcondition violation")
						elseif l_proc.is_precondition_violation then
							io.put_string (" precondition violation")
						end
						if attached l_proc.tag then
							io.put_string (" tag:" + l_proc.tag)
						end
						io.put_new_line
					end
			)

--			if event_list.is_service_available then
--				from
--					event_list.service.all_items.start
--					event_list.service.all_items.start
--				until
--					event_list.service.all_items.after
--				loop
--					l_proof_event ?= event_list.service.all_items.item_for_iteration
--					if l_proof_event /= Void then
--						print_event (l_proof_event)
--					end
--					event_list.service.all_items.forth
--				end
--			end
		end

feature {NONE} -- Implementation

	translator_input: E2B_TRANSLATOR_INPUT
			-- Translator.

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

	load_universe
			-- Load all classes from universe.
		local
			l_groups: LIST [CONF_GROUP]
			l_cluster: CLUSTER_I
		do
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
		end

	load_selection
			-- Load classes and features from selection.
		local
			l_item: STRING
			l_parts: LIST [STRING]
			l_classes: LIST [CLASS_I]
		do
			from
				selection.start
			until
				selection.after
			loop
				l_item := selection.item
				if l_item.has ('.') then
						-- It's an individual feature
					l_parts := l_item.split ('.')
					l_classes := universe.classes_with_name (l_parts.i_th (1))
					if l_classes /= Void and then not l_classes.is_empty then
						load_feature (l_classes.first, l_parts.i_th (2))
					else
						print ("Class " + selection.item + " not found (skipped).%N")
					end
				else
						-- It's a class
					l_classes := universe.classes_with_name (selection.item)
					if l_classes /= Void and then not l_classes.is_empty then
						load_class (l_classes.first)
					else
						print ("Class " + selection.item + " not found (skipped).%N")
					end
				end
				selection.forth
			end
		end

	load_feature (a_class: CLASS_I; a_feature_name: STRING)
			-- Load `a_feature' for verification.
		local
			l_feature: FEATURE_I
		do
			if a_class.is_compiled then
				l_feature := a_class.compiled_class.feature_named (a_feature_name)
				if l_feature /= Void then
					translator_input.add_feature (l_feature)
				else
					print ("Feature " + a_class.name + "." + a_feature_name + " not found (skipped).%N")
				end
			else
				print ("Class " + a_class.name + " not compiled (skipped).%N")
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
				translator_input.add_class (l_class_c)
			else
				print ("Class " + a_class.name + " not compiled (skipped).%N")
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

note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
