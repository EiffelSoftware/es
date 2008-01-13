indexing
	description: "[
		Objects that observe a set of test routines and adopt changes of that
		set appropriately to a own set of test routines. The objects can
		themselves have observers which are notified whenever the own set
		of test routines changes.
		In addition, CDD_OBSERVING_VIEW keeps track of how many obervers there
		are. That way it will only react on changes if there are any observers
		listening to Current.
	]"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_ACTIVE_VIEW

feature -- Access

	client_count: NATURAL
			-- Number of clients accessing view

	is_observing: BOOLEAN is
			-- Is this filter observing `test_suite'?
			-- If it is then changes to `test_suite' will be
			-- reflected by this filter immediately, otherwise
			-- `refresh' must be called.
		deferred
		end

feature -- Element change

	add_client is
			-- Increase client count and
			-- enable observing if it was not enabled before.
		do
			client_count := client_count + 1
			if not is_observing then
				enable_observing
			end
		ensure
			clients_increased: client_count = old client_count + 1
		end

	remove_client is
			-- Remove `an_observer' from `change_actions' and
			-- disable observing if there are no observers left.
		require
			client_count_positive: client_count > 0
		do
			client_count := client_count - 1
			if client_count = 0 then
				disable_observing
			end
		ensure
			clients_decreased: client_count = old client_count - 1
		end

feature {NONE} -- Status setting

	enable_observing is
			-- Enable auto update mode.
		require
			not_observing: not is_observing
		deferred
		ensure
			observing: is_observing
		end

	disable_observing is
			-- Disable auto update mode.
		require
			observing: is_observing
		deferred
		ensure
			not_observing: not is_observing
		end

invariant

	client_count_positive_equals_observing: (client_count > 0) = is_observing

end
