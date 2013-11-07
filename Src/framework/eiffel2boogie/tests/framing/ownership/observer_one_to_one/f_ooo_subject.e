note
	status: no_ownership_defaults

class F_OOO_SUBJECT

inherit

	ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		note
			status: creator
		require else
			is_open -- default: creator
			modify (Current) -- default: creator
		do
			set_observers([observer])
			wrap -- default: creator
		ensure then
			is_wrapped -- default: creator
			observer = Void -- default: default_create
		end

feature -- Access

	value: INTEGER
		-- Subject's value.

	observer: detachable F_OOO_OBSERVER
		-- Observer of this subject.

feature -- Element change

	update (new_val: INTEGER)
		require
			is_wrapped	-- default: public
			across observers as oc all oc.item.is_wrapped end -- default: public

			modify (observer)
			modify_field ("value", Current)
		do
			unwrap -- default: public
			if attached observer then
				observer.unwrap
			end
			value := new_val
			if attached observer then
				observer.notify
				observer.wrap
			end
			wrap -- default: public
		ensure
			value_set: value = new_val
			is_wrapped	-- default: public
			across observers as oc all oc.item.is_wrapped end -- default: public

			observer = old observer -- TODO: fine-grained modifies
			observer.subject = old observer.subject -- TODO: fine-grained modifies
		end

feature {F_OOO_OBSERVER} -- Element change

	register (o: F_OOO_OBSERVER)
			-- Register `o' as observer.
		note
			explicit: contracts
		require
			-- is_open: removed due to explicit contracts
			-- across observers as sc all sc.item.is_open end: removed due to explicit contracts

			observer = Void
			is_wrapped
			o.is_open

--			modify ([Current, "observer"]) -- default: command
			modify (Current)
		do
			unwrap
			observer := o
			set_observers ([o]) -- add_observer_ (o) -- feature from ANY, maintains open_, ensures observers = old observers + { o }
			wrap
		ensure
			observer = o
			is_wrapped

			-- is_open: removed due to explicit contracts
			-- across observers as sc all sc.item.is_open end: removed due to explicit contracts
		end

invariant
	observers = [observer]
	owns = [] -- default
	subjects = [] -- default

end
