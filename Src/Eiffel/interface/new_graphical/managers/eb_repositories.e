note
	description: "Object that encapsulates an organized set of repositories "
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_REPOSITORIES

inherit
	EB_REPOSITORIES_ITEM_LIST
		export
			{ANY} string_representation
		redefine
			default_create,
			on_item_added,
			on_item_removed
		end

	SHARED_EIFFEL_PROJECT
		undefine
			default_create,
			is_equal,
			copy
		end

create
	default_create

create {EB_REPOSITORIES}
	make, make_filled

feature {NONE} -- Initialization

	default_create
		do
			make (10)
			create observer_list.make (10)
			enable_sensitive
			Eiffel_project.manager.close_agents.extend (agent disable_sensitive)
			Eiffel_project.manager.create_agents.extend (agent enable_sensitive)
		end

feature -- Initialize from session

	make_with_string (a_string: STRING_32)
			-- Re-Initialize the repositories from `a_string'.
		local
			analyzed_string: STRING_32
		do
			wipe_out
			if a_string /= Void and then a_string.substring_index (name, 1) = 1 then
				-- Remove the initial string "Repositories(" and the final string ")"
				analyzed_string := a_string.substring (name.count + 2, a_string.count)
				analyzed_string := analyzed_string.substring (1, analyzed_string.count - 1)
				initialize_with_string (analyzed_string)
			end
--			on_update
		end

feature -- Status report

	sensitive: BOOLEAN
			-- Are observers sensitive?

	loading_error: BOOLEAN;
			-- Did an error occur while loading the repostiories?

feature -- Element change

	add_repository (a_repository_url: STRING_32; a_username, a_password: detachable STRING_32; a_development_window: EB_DEVELOPMENT_WINDOW)
			-- Add a new repository to `Current'
		require
			valid_repository_url: a_repository_url /= Void and then not a_repository_url.is_empty
			development_window_not_void: a_development_window /= Void
		local
			l_repositories_root: EB_REPOSITORIES_ROOT
		do
			create l_repositories_root.make (a_repository_url, Current)
			l_repositories_root.set_username (a_username)
			l_repositories_root.set_password (a_password)
			l_repositories_root.set_development_window (a_development_window)

			l_repositories_root.load_repository

			extend (l_repositories_root)
		end

	enable_sensitive
			-- Make all observers sensitive.
		do
			if not sensitive then
				sensitive := True
				from
					observer_list.start
				until
					observer_list.after
				loop
					observer_list.item.enable_sensitive
					observer_list.forth
				end
			end
		end

	disable_sensitive
			-- Make all observers sensitive.
		do
			if sensitive then
				sensitive := False
				from
					observer_list.start
				until
					observer_list.after
				loop
					observer_list.item.disable_sensitive
					observer_list.forth
				end
			end
		end

feature -- Observer pattern

	add_observer (a_observer: EB_REPOSITORIES_OBSERVER)
		do
			observer_list.extend (a_observer)
		end

	remove_observer (a_observer: EB_REPOSITORIES_OBSERVER)
		do
			observer_list.start
			observer_list.prune_all (a_observer)
		end

	on_item_added (a_item: EB_REPOSITORIES_ITEM; a_item_list: ARRAYED_LIST [EB_REPOSITORIES_ITEM])
		do
			from
				observer_list.start
			until
				observer_list.after
			loop
				observer_list.item.on_item_added (a_item)
				observer_list.forth
			end
		end

	on_item_removed(a_item: EB_REPOSITORIES_ITEM; a_item_list: ARRAYED_LIST [EB_REPOSITORIES_ITEM])
		do
			from observer_list.start
			until observer_list.after
			loop
				observer_list.item.on_item_removed (a_item)
				observer_list.forth
			end
		end

	on_update
		do
			from observer_list.start
			until observer_list.after
			loop
				observer_list.item.on_update
				observer_list.forth
			end
		end

feature {NONE} -- Attributes

	observer_list: ARRAYED_LIST [EB_REPOSITORIES_OBSERVER]

feature {NONE} -- Implementetation

	parent: EB_REPOSITORIES_ITEM_LIST
			-- Parent for Current
		do
			Result := Current
		end

	name: STRING_32
			-- Name of the item.
		once
			Result := "Repositories"
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
