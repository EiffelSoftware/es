note
	description: "Command line command for Boogie verification"
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_BOOGIE_VERIFICATION

inherit

	EWB_CMD
		rename
			messages as ewb_messages
		end

	SHARED_ERROR_HANDLER
		export {NONE} all end

	COMPILER_EXPORTER

	INTERNAL_COMPILER_STRING_EXPORTER

	E2B_SHARED_CONTEXT

create
	make_with_arguments

feature {NONE} -- Initialization

	make_with_arguments (a_arguments: LINKED_LIST [STRING])
			-- Initialize with `a_arguments'.
		require
			a_arguments_attached: a_arguments /= Void
		do
			create user_options.make
			user_options.compare_objects
			create selection.make
			from
				a_arguments.start
			until
				a_arguments.after
			loop
				if a_arguments.item.starts_with ("-") then
					user_options.extend (a_arguments.item)
					a_arguments.forth
					if not a_arguments.after and a_arguments.item.is_integer then
						user_options.extend (a_arguments.item)
						a_arguments.forth
					end
				else
					selection.extend (a_arguments.item)
					a_arguments.forth
				end
			end
		end

feature -- Access

	autoproof: E2B_AUTOPROOF
			-- Autoproof.

	user_options: LINKED_LIST [STRING]
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
			html_writer: E2B_HTML_OUTPUT
			l_html: BOOLEAN
			l_measure: BOOLEAN
			l_start, l_duration: NATURAL_64
		do
			create autoproof.make
				-- Load options
			if user_options.has ("-twostep") then
				options.set_two_step_verification_enabled (True)
			elseif user_options.has ("-notwostep") then
				options.set_two_step_verification_enabled (False)
			end
			if user_options.has ("-overflow") then
				options.set_checking_overflow (True)
			elseif user_options.has ("-nooverflow") then
				options.set_checking_overflow (False)
			end
			if user_options.has ("-trigger") then
				options.set_generating_triggers (True)
			elseif user_options.has ("-notrigger") then
				options.set_generating_triggers (False)
			end
			if user_options.has ("-arithtrigger") then
				options.set_triggering_on_arithmetic (True)
			elseif user_options.has ("-noarithtrigger") then
				options.set_triggering_on_arithmetic (False)
			end
			if user_options.has ("-arithfresh") then
				options.set_arithmetic_extracted (True)
			elseif user_options.has ("-noarithfresh") then
				options.set_arithmetic_extracted (False)
			end
			if user_options.has ("-autounroll") then
				options.set_automatic_loop_unrolling_enabled (True)
			elseif user_options.has ("-noautounroll") then
				options.set_automatic_loop_unrolling_enabled (False)
			end
			if user_options.has ("-unrolldepth") then
				options.set_loop_unrolling_depth (option_argument ("-unrolldepth", options.loop_unrolling_depth))
			end
			if user_options.has ("-autoinline") then
				options.set_automatic_inlining_enabled (True)
			elseif user_options.has ("-noautoinline") then
				options.set_automatic_inlining_enabled (False)
			end
			if user_options.has ("-inlinedepth") then
				options.set_max_recursive_inlining_depth (option_argument ("-inlinedepth", options.max_recursive_inlining_depth))
			end
			if user_options.has ("-ownership") then
				options.set_ownership_enabled (True)
			elseif user_options.has ("-noownership") then
				options.set_ownership_enabled (False)
			end

			if user_options.has ("-timeout") then
				options.set_is_enforcing_timeout (True)
				options.set_timeout (option_argument ("-timeout", options.timeout))
			end

			if user_options.has ("-printtime") then
				options.set_print_time (True)
			elseif user_options.has ("-noprinttime") then
				options.set_print_time (False)
			end

			if user_options.has ("-bulk") then
				options.set_bulk_verification_enabled (True)
			elseif user_options.has ("-forked") then
				options.set_bulk_verification_enabled (False)
			end


			if selection.is_empty then
				load_universe
			else
				load_selection
			end

			l_measure := user_options.has ("-measure")

			l_html := user_options.has ("-html")
			if l_html then
				create html_writer
				html_writer.print_header
				autoproof.add_notification (agent html_writer.print_verification_result (?))
			else
				autoproof.add_notification (agent print_result (?))
			end
			if options.is_bulk_verification_enabled or l_measure then
				l_start := current_time_millis
				autoproof.verify
				l_duration := current_time_millis - l_start
			else
				autoproof.verify_forked
			end
			if l_measure then
			end
			if l_html then
				html_writer.print_footer
			end

			if l_measure then
				if l_html then
					output_window.add ("<p>Bulk time: " + l_duration.out + "</p>")
				else
					output_window.add ("Bulk time: " + l_duration.out + "%N")
				end

				autoproof.clear_notifications
				l_start := current_time_millis
				autoproof.verify_forked
				l_duration := current_time_millis - l_start
				if l_html then
					output_window.add ("<p>Forked time: " + l_duration.out + "</p>")
				else
					output_window.add ("Forked time: " + l_duration.out + "%N")
				end
			end

		end

	option_argument (a_option: STRING; a_default: INTEGER): INTEGER
		require
			user_options.has (a_option)
		local
			l_index: INTEGER
		do
			l_index := user_options.index_of (a_option, 1)
			if l_index > 0 and then user_options.i_th (l_index + 1).is_integer then
				Result := user_options.i_th (l_index + 1).to_integer
			else
				Result := a_default
			end
		end

feature {NONE} -- Printing console

	print_result (a_result: E2B_RESULT)
			-- Print results to output.
		do
			across a_result.verification_results as i loop
				output_window.add ("======================================%N")
				if attached {E2B_SUCCESSFUL_VERIFICATION} i.item as l_success then
					print_successful_verification (l_success)
				elseif attached {E2B_FAILED_VERIFICATION} i.item as l_failure then
					print_failed_verification (l_failure)
				elseif attached {E2B_AUTOPROOF_ERROR} i.item as l_error then
					print_error (l_error)
				else
					check False end
				end
			end
		end

	print_successful_verification (a_success: E2B_SUCCESSFUL_VERIFICATION)
			-- Print successful verification information.
		local
			time_string: STRING
		do
			print_feature_information (a_success)
			if options.is_print_time then
				time_string := " (" + time_format.formatted (a_success.time) + "s)"
			else
				time_string := ""
			end
			if a_success.original_errors = Void or else a_success.original_errors.is_empty then
				output_window.add ("Successfully verified" + time_string + ".%N")
			else
					-- Two-step verification result
				output_window.add ("Successfully verified after inlining" + time_string + ".%N")
				output_window.add ("Original errors:%N")
				across a_success.original_errors as i loop
					if i.cursor_index = 1 then
						output_window.add_new_line
					else
						output_window.add ("--------------------------------------%N")
					end
					i.item.multi_line_message (output_window)
					output_window.add_new_line
				end
			end
		end

	print_failed_verification (a_failure: E2B_FAILED_VERIFICATION)
			-- Print failed verifcation information.
		local
			time_string: STRING
		do
			print_feature_information (a_failure)
			if options.is_print_time then
				time_string := " (" + time_format.formatted (a_failure.time) + "s)"
			else
				time_string := ""
			end
			output_window.add ("Verification failed" + time_string + ".%N")
			across a_failure.errors as i loop
				if i.cursor_index = 1 then
					output_window.add_new_line
				else
					output_window.add ("--------------------------------------%N")
				end
				if i.item.context_line_number > 0 then
					output_window.add ("Line: " + i.item.context_line_number.out + ". ")
				end
				i.item.single_line_message (output_window)
				output_window.add_new_line
			end
		end

	print_error (a_error: E2B_AUTOPROOF_ERROR)
			-- Print failed verifcation information.
		do
			print_feature_information (a_error)
			output_window.add ("AutoProof error.%N")
			if a_error.context_line_number > 0 then
				output_window.add ("Line: " + a_error.context_line_number.out + ". ")
			end
			output_window.add (a_error.type + ": ")
			a_error.single_line_message (output_window)
			output_window.add_new_line
		end

	print_feature_information (a_proc: E2B_VERIFICATION_RESULT)
			-- Print feature information.
		do
			if attached a_proc.context_class then
				output_window.add_class (a_proc.context_class.original_class)
			end
			if attached a_proc.context_feature then
				output_window.add (".")
				output_window.add_feature (a_proc.context_feature.e_feature, a_proc.context_feature.feature_name_32)
			end
			if attached a_proc.verification_context then
				output_window.add (" (")
				output_window.add (a_proc.verification_context)
				output_window.add (")")
			end
			output_window.add_new_line
		end

feature {NONE} -- Implementation

	load_universe
			-- Load all classes from universe.
		local
			l_groups: LIST [CONF_GROUP]
		do
			from
				l_groups := eiffel_universe.groups
				l_groups.start
			until
				l_groups.after
			loop
					-- Only load top-level clusters, as they are loaded recursively afterwards
				if attached {CLUSTER_I} l_groups.item_for_iteration as l_cluster and then l_cluster.parent_cluster = Void then
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
					autoproof.add_feature (l_feature)
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
				autoproof.add_class (l_class_c)
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

	time_format: FORMAT_DOUBLE
			-- Format for verfication times.
		once
			create Result.make (4, 2)
		end

	current_time_millis: NATURAL_64
		external
			"C inline use <time.h>, <sys/timeb.h>"
		alias
			"[
				struct timeb t;
				ftime(&t);
				return (unsigned long long int)time(NULL) * 1000 + t.millitm;
			]"
		end

note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
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
