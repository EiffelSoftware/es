note
	description: "Tree representing a set of repositories"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_REPOSITORIES_TREE

inherit
	ES_TREE

	EB_REPOSITORIES_OBSERVER
		undefine
			default_create, is_equal, copy
		redefine
			on_item_added, on_item_removed, on_update
		end

	EB_CONSTANTS
		undefine
			default_create, is_equal, copy
		end

	EB_RECYCLABLE
		undefine
			default_create, is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make (a_repositories_manager: EB_REPOSITORIES_MANAGER; a_context_menu_factory: EB_CONTEXT_MENU_FACTORY)
			-- Initialization: build the widget and the tree.
		do
			default_create
			context_menu_factory := a_context_menu_factory
			repositories_manager := a_repositories_manager
			repositories.add_observer (Current)

			if repositories_manager.repositories.sensitive then
				enable_sensitive
			else
				disable_sensitive
			end

			set_minimum_height (20)
			enable_default_tree_navigation_behavior (False, False, False, True)
		end

feature -- Observer pattern

	on_item_added (a_item: EB_REPOSITORIES_ITEM)
			-- `a_item' has been added
		local
			l_tree_item: EB_REPOSITORIES_TREE_ITEM
			l_tree_parent: EV_TREE_NODE
		do
			create l_tree_item.make (a_item)
			l_tree_item.set_text (a_item.name)
			l_tree_parent := retrieve_item_recursively_by_data (a_item.parent, True)
			if l_tree_parent /= Void then
				l_tree_parent.extend (l_tree_item)
			else
				extend (l_tree_item)
			end
		end

	on_item_removed (a_item: EB_REPOSITORIES_ITEM)
			-- `a_item' has been removed
		local
			l_tree_parent: EV_TREE_NODE
		do
			l_tree_parent := retrieve_item_recursively_by_data (a_item.parent, True)

			if l_tree_parent = Void then
					-- Remove whole repository
				prune (retrieve_item_recursively_by_data (a_item, True))
			else
					-- Remove a single folder or item of a repository
				l_tree_parent.prune (retrieve_item_recursively_by_data (a_item, True))
			end

		end

	on_update
			-- Completely recompute the observer state.
		do
		end

feature {NONE} -- Cleaning

	internal_recycle
			-- To be called when the object is no more used.
		do
			if repositories /= Void then
				repositories.remove_observer (Current)
			end
			repositories_manager := Void
		end

feature {NONE} -- Implementation

	context_menu_factory: EB_CONTEXT_MENU_FACTORY
			-- Context menu factory

	repositories_manager: EB_REPOSITORIES_MANAGER;
			-- Associated repositories manager

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
