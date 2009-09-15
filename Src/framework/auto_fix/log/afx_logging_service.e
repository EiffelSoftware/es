note
	description: "Summary description for {AFX_LOGGING_SERVICE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_LOGGING_SERVICE

inherit

    AFX_LOGGING_SERVICE_I

inherit{NONE}

	EVENT_TYPE [TUPLE [info: AFX_LOG_ENTRY_I]]
		rename
		    default_create as create_event
		end

create
    make

feature -- Initialization

	make
			-- initialize a new object
		do
			create_event
			create observers.make_default
		end

feature -- Logging

	log (an_entry: AFX_LOG_ENTRY_I)
			-- <Precursor>
		do
		    publish([an_entry])
		end

feature -- Status report

	has_registered (an_observer: AFX_LOGGING_EVENT_OBSERVER_I): BOOLEAN
		do
		    	-- using "=" for equality testing
		    Result := observers.has (an_observer)
		end

feature -- Registration

	register_observer (an_observer: AFX_LOGGING_EVENT_OBSERVER_I)
			-- <Precursor>
		do
		    subscribe (agent an_observer.log)
		    observers.force_last (an_observer)
		end

	unregister_observer (an_observer: AFX_LOGGING_EVENT_OBSERVER_I)
			-- <Precursor>
		local
		    l_observer: AFX_LOGGING_EVENT_OBSERVER_I
		    l_observers: like observers
		do
		    l_observers := observers

		    unsubscribe (agent an_observer.log)

				-- remove observer from list
		    l_observers.start
		    l_observers.search_forth (an_observer)
		    check not l_observers.after end
		    l_observer := l_observers.item_for_iteration
		    l_observer.finish_logging
		    l_observers.remove_at
		end

	unregister_all
			-- <Precursor>
		local
			l_observers: DS_ARRAYED_LIST [AFX_LOGGING_EVENT_OBSERVER_I]
		do
		    subscribers.wipe_out

		    l_observers := observers
		    from l_observers.start
		    until l_observers.after
		    loop
		        l_observers.item_for_iteration.finish_logging
		        l_observers.forth
		    end
		    l_observers.wipe_out
		end

feature -- Implementation

	observers: DS_ARRAYED_LIST [AFX_LOGGING_EVENT_OBSERVER_I]
			-- observers subscribed to this event

invariant

    same_count: subscribers.count = observers.count

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
