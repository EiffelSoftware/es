note
	explicit: "all"

class F_OOM_SUBJECT_D

create
	make

feature

	value: INTEGER
	observers_list: F_OOM_LIST [F_OOM_OBSERVER_D]

	make
		require
			is_open

			modify (Current) -- default: creator
		do
			create observers_list
			set_owns ([observers_list]) -- implicit?
			wrap
		ensure
			observers_list.is_empty
			observers = [] -- todo: should be implied by previous line
			is_wrapped
		end

	update (new_val: INTEGER)
		require
			is_wrapped
			across observers as o all o.item.is_wrapped end

			modify_field ("value", Current)
			modify_field ("cache", observers_list.sequence)
		local
			i: INTEGER
		do
			unwrap
			across observers as o loop
				o.item.unwrap
			end

			value := new_val
			from
				i := 1
			invariant
				across 1 |..| (i - 1) as j all observers_list[j.item].cache = new_val end
			until
				i > observers_list.count
			loop
				observers_list [i].notify
				i := i + 1
			end
			across observers as o loop
				o.item.wrap
			end
			wrap
		ensure
			value = new_val
			is_wrapped
			across observers as o all o.item.is_wrapped end
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
			observers_list.has (o)
			is_wrapped
		end

invariant
	observers_list /= Void
	across observers_list.sequence as o all o.item /= Void end
	observers = observers_list.sequence
	owns = [observers_list]
	subjects = [] -- default

note
	explicit: observers

end
