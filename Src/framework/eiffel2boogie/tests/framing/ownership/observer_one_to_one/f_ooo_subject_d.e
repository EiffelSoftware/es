note
	explicit: "all"

class F_OOO_SUBJECT_D

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
			set_observers([]) -- defalt: creator
			wrap -- default: creator
		ensure then
			is_wrapped -- default: creator
			observer = Void -- default: default_create
		end

feature -- Access

	value: INTEGER
		-- Subject's value.

	observer: detachable F_OOO_OBSERVER_D
		-- Observer of this subject.

feature -- Element change

	update (new_val: INTEGER)
		require
			is_wrapped	-- default: public
			across observers as oc all oc.item.is_wrapped end -- default: public

			modify_field ("cache", observer)
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
		end

feature {F_OOO_OBSERVER_D} -- Element change

	register (o: F_OOO_OBSERVER_D)
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
	observer = Void implies observers = []
	observer /= Void implies observers = [observer]
	owns = [] -- default
	subjects = [] -- default

end
