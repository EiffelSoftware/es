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
		do
			create observers_list
			set_owns ([observers_list]) -- implicit?
			wrap
		ensure
			observers_list.is_empty
			is_wrapped
		end

	update (new_val: INTEGER)
		require
			is_wrapped
			across observers as o all o.is_wrapped end

			modify_field ("value", Current)
			modify (observers_list.sequence) -- modify contents
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
				i > observers.count
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
    note explicit: contracts
    require
      wrapped_
      o.open_
    do
      -- unwrap_
      observers.extend_back (o)
      add_observer_ (o) -- feature from ANY, maintains open_, ensures observers = old observers + { o }
      -- wrap_
    ensure
      observers.has (o)
      wrapped_
    end

invariant
	observers_list /= Void
	across observers_list.sequence.range as o all o /= Void end
	observers = observers.sequence.range
	owns = [observers]
	subjects = [] -- default

note
	explicit: observers

end
