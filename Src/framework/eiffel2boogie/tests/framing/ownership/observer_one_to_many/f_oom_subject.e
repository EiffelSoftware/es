class F_OOM_SUBJECT

create
	make

feature

	value: INTEGER
	observers_list: F_OOM_LIST [F_OOM_OBSERVER]

	make
		note
			status: creator
		require
			is_open
		do
			create observers_list.make
			set_owns ([observers_list])
		ensure
			observers_list.is_empty
			observers = [] -- todo: should be implied by previous line
		end

	update (new_val: INTEGER)
		require
			modify_field ("value", Current)
			modify_field ("cache", observers_list.sequence)
		local
			i: INTEGER
			l_old_sequence: MML_SET [F_OOM_OBSERVER]
		do
			unwrap_all (observers)

			value := new_val
			from
				i := 1
			invariant
--				across 1 |..| (i - 1) as j all observers_list[j.item].cache = new_val end
			until
				i > observers_list.count
			loop
				observers_list [i].notify
				i := i + 1
			end

			wrap_all (observers)
		ensure
			value = new_val
		end

feature {F_OOM_OBSERVER}

	register (o: F_OOM_OBSERVER)
		note
			explicit: contracts
		require
			is_wrapped
			o.is_open
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
	not observers[Current]

note
	explicit: observers

end
