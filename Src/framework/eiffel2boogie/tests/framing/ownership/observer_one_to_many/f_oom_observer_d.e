note
	explicit: "all"

class F_OOM_OBSERVER_D

create
	make

feature

	subject: F_OOM_SUBJECT_D

	cache: INTEGER

	make (s: F_OOM_SUBJECT_D)
		note
			status: creator
		require
			s /= Void
			s.is_wrapped -- default: creator
			across s.observers as o all o.item.is_wrapped end -- default: creator
			is_open -- default: creator

			modify ([s, Current])
		do
			subject := s
			s.register (Current)
			cache := s.value
			set_subjects ([subject]) -- implicit?
			wrap -- default: creator
		ensure
			subject = s
			is_wrapped -- default: creator
			across observers as o all o.item.is_wrapped end -- default: creator
			s.is_wrapped -- default: creator
			across s.observers as o all o.item.is_wrapped end -- default: creator
			s.observers = (old s.observers & Current)
		end

feature {F_OOM_SUBJECT_D}

	  notify
		require
			is_open
			inv_without ("cache_synchronized")

			modify_field ("cache", Current)
		do
			cache := subject.value
		ensure
			inv
		end

invariant
	subject /= Void
	subject.observers.has (Current)
	cache_synchronized: cache = subject.value
	subjects = [subject]
	across subjects as s all s.item.observers.has (Current) end -- default
	owns = [] -- default
	observers = [] -- default

end
