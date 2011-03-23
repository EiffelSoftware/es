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
		end

feature {NONE} -- Implementation

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
