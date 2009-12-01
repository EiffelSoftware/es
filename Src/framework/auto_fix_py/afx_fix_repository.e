note
	description: "Summary description for {AFX_FIX_REPOSITORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_REPOSITORY

inherit
    SHARED_AFX_FIX_ID

create
    make

feature -- Initialization

	make (a_size: INTEGER)
			-- Initialize a new object
		require
		    positive_size: a_size > 0
		do
		    create storage.make (a_size)
		end
feature -- Access

	storage: HASH_TABLE [DS_ARRAYED_LIST[AFX_FIX_INFO_I], INTEGER]
			-- the storage where all fixes are registered.
			-- Fixes are categorized according to the class_id of the class where they are to be used.

	fixes: DS_LINEAR [AFX_FIX_INFO_I]
			-- list of all fixes
		local
		    l_list: DS_ARRAYED_LIST[AFX_FIX_INFO_I]
		do
	        create l_list.make_default

		    from storage.start
		    until storage.after
		    loop
		        l_list.append_last (storage.item_for_iteration)
		        storage.forth
		    end

		    Result := l_list
		end

feature -- Status report

	is_empty: BOOLEAN
			-- has the repository any fixes?
		do
		    Result := storage.is_empty
		end

feature -- Operation

	start_registration
			-- get ready to accept fix registration
		do
		    storage.wipe_out
		    reset_global_fix_id
		end

	register_fix (a_fix: AFX_FIX_INFO_I; a_class_id: INTEGER)
			-- register a fix
		local
		    l_list: DS_ARRAYED_LIST[AFX_FIX_INFO_I]
		do
		    check a_fix.fix_id = 0 end
		    a_fix.set_fix_id (global_fix_id)
		    step_global_fix_id

		    if storage.has_key (a_class_id) then
				l_list := storage.found_item
				l_list.force_last (a_fix)
			else
			    create l_list.make_default
			    l_list.force_last (a_fix)
			    storage.put (l_list, a_class_id)
		    end
		end

;note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
