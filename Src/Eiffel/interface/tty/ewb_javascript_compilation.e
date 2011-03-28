note
	description : "Command line entry point for JavaScript compilation."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	date        : "$Date$"
	revision    : "$Revision$"

class
	EWB_JAVASCRIPT_COMPILATION

inherit

	EWB_CMD

	SHARED_EIFFEL_PROJECT
		export {NONE} all end

	INTERNAL_COMPILER_STRING_EXPORTER
		export {NONE} all end

	SHARED_JSC_ENVIRONMENT
		rename
			warnings as real_warnings,
			errors as real_errors
		export {NONE} all
		end

feature -- Properties

	name: STRING
		do
			Result := "JavaScript Compiler"
		end

	help_message: STRING_GENERAL
		do
			Result := ""
		end

	abbreviation: CHARACTER
		do
			Result := 'J'
		end

feature -- Execution

	execute
			-- Execute the translation to JavaScript
		local
			l_groups: LIST [CONF_GROUP]
			l_cluster: CLUSTER_I
		do
			javascript_compiler.reset
			javascript_compiler.register_message_callbacks (agent (s: STRING) do output_window.put_string (s) output_window.put_new_line end, agent (s: STRING) do end)

				-- Blindingly regenerate all JavaScript.
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

			javascript_compiler.execute_compilation

			from
				real_errors.start
			until
				real_errors.after
			loop
				print_error (real_errors.item, "Error")
				real_errors.forth
			end

			from
				real_warnings.start
			until
				real_warnings.after
			loop
				print_error (real_warnings.item, "Warning")
				real_warnings.forth
			end
		end

feature {NONE} -- Implementation

	print_error (a_error: attached JSC_ERROR; a_type: attached STRING)
		do
			io.error.put_string ("-------------------------------------------------------------------------------")
			io.error.put_new_line
			io.error.put_new_line
			io.error.put_string (a_type + ": ")
			io.error.put_string (a_error.code)
			io.error.put_new_line
			io.error.put_new_line
			io.error.put_string (a_error.message)
			io.error.put_new_line
			io.error.put_string (a_error.description)
			io.error.put_new_line
			io.error.put_new_line
			if attached a_error.class_c as safe_class_c then
				io.error.put_string ("Class: ")
				io.error.put_string (safe_class_c.name_in_upper)
				io.error.put_new_line
			end
			if attached a_error.e_feature as safe_e_feature then
				io.error.put_string ("Feature: ")
				io.error.put_string (safe_e_feature.name)
				io.error.put_new_line
			end
			if a_error.line > 0 then
				io.error.put_string ("Line: ")
				io.error.put_integer (a_error.line)
				io.error.put_new_line
			end
			io.error.put_new_line
		end

	javascript_compiler: JAVASCRIPT_COMPILER
		once
			create Result.make
		end

	load_class (a_class: CLASS_I)
			-- Load `a_class' for translation.
		do
			if a_class.is_compiled and then attached a_class.compiled_class as safe_compiled_class then
				javascript_compiler.add_class_to_compile (safe_compiled_class)
			end
		end

	load_cluster (a_cluster: CLUSTER_I)
			-- Load `a_cluster' recursively for translation.
		require
			a_cluster_not_void: a_cluster /= Void
		local
			l_class_i: CLASS_I
		do
			from
				a_cluster.classes.start
			until
				a_cluster.classes.after
			loop
				l_class_i := eiffel_universe.class_named (a_cluster.classes.item_for_iteration.name, a_cluster)
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
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
