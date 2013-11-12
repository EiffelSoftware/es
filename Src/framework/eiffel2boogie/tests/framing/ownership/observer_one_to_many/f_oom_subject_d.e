note
	explicit: "all"

class F_OOM_SUBJECT_D

create
	make

feature

	value: INTEGER
	observers_list: F_OOM_LIST [F_OOM_OBSERVER_D]

	make
		note
			status: creator
		require
			is_open

			modify (Current) -- default: creator
		do
			create observers_list.make
			set_owns ([observers_list]) -- implicit?
			wrap -- default: creator
		ensure
			observers_list.is_empty
			observers = [] -- todo: should be implied by previous line
			is_wrapped -- default: creator
		end

	update (new_val: INTEGER)
		require
			is_wrapped -- default: public
			across observers as o all o.item.is_wrapped end -- default: public

			modify_field ("value", Current)
			modify_field ("cache", observers_list.sequence)
		local
			i: INTEGER
		do
			unwrap
			unwrap_all (observers)

			value := new_val

--			from
--				i := 1
--			invariant
--				across 1 |..| (i - 1) as j all observers_list[j.item].cache = new_val end
--			until
--				i > observers_list.count
--			loop
--				observers_list [i].notify
--				i := i + 1
--			end
			wrap_all (observers)
			wrap
		ensure
			value = new_val
			is_wrapped -- default: public
			across observers as o all o.item.is_wrapped end -- default: public
		end

feature {F_OOM_OBSERVER_D}

	register (o: F_OOM_OBSERVER_D)
		note
			explicit: contracts
		require
			is_wrapped
			o.is_open

			modify (Current) -- default: command
		do
			unwrap
			observers_list.extend_back (o)
			set_observers (observers + [o])
			wrap
		ensure
			observers = (old observers & o)
			observers_list.has (o)
			is_wrapped
		end

invariant
	observers_list /= Void
	across observers_list.sequence as o all o.item /= Void end
	observers = observers_list.sequence
	owns = [observers_list]
	subjects = [] -- default
	abc: not observers[Current]

note
	explicit: observers

end
