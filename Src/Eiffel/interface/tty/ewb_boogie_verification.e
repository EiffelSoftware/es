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

	autoproof: E2B_AUTOPROOF
			-- Autoproof.

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
		do
			create autoproof.make
				-- Load options
			if options.has ("-abc") then

			end
			if selection.is_empty then
				load_universe
			else
				load_selection
			end
			autoproof.verify
			print_result (autoproof.last_result)
		end

feature {NONE} -- Implementation

	print_result (a_result: E2B_RESULT)
			-- Print results to output.
		do
			if a_result.has_execution_errors then
				output_window.add ("Boogie verification failed!")
				output_window.add_new_line
				output_window.add_new_line
				across a_result.execution_errors as i loop
					output_window.add (i.item.title)
					output_window.add (": ")
					output_window.add (i.item.message)
				end
			else
				across a_result.procedure_results as i loop
					output_window.add ("======================================%N")
					if attached {E2B_SUCCESSFUL_VERIFICATION} i.item as l_success then
						print_successful_verification (l_success)
					elseif attached {E2B_FAILED_VERIFICATION} i.item as l_failure then
						print_failed_verification (l_failure)
					else
						check False end
					end
				end
			end
		end

	print_successful_verification (a_success: E2B_SUCCESSFUL_VERIFICATION)
			-- Print successful verification information.
		do
			print_feature_information (a_success)
			if a_success.original_errors = Void or else a_success.original_errors.is_empty then
				output_window.add ("Successfully verified.%N")
			else
					-- Two-step verification result
				output_window.add ("Successfully verified after inlining.%N")
			end
		end

	print_failed_verification (a_failure: E2B_FAILED_VERIFICATION)
			-- Print failed verifcation information.
		do
			print_feature_information (a_failure)
			output_window.add ("Verification failed.%N")
			across a_failure.errors as i loop
				if i.cursor_index = 1 then
					output_window.add_new_line
				else
					output_window.add ("--------------------------------------%N")
				end
				i.item.multi_line_message (output_window)
				output_window.add_new_line
			end
		end

	print_feature_information (a_proc: E2B_PROCEDURE_RESULT)
			-- Print feature information.
		do
			output_window.add_class (a_proc.eiffel_class.original_class)
			output_window.add (".")
			output_window.add_feature (a_proc.eiffel_feature.e_feature, a_proc.eiffel_feature.feature_name_32)
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
