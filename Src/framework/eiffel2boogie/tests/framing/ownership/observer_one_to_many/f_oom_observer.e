class F_OOM_OBSERVER

create
	make

feature

	subject: F_OOM_SUBJECT

	cache: INTEGER

	make (s: F_OOM_SUBJECT)
		note
			status: creator
		require
			s /= Void

			modify ([s, Current])
		do
			subject := s
			s.register (Current)
			cache := s.value
			set_subjects ([subject])
		ensure
			subject = s
			s.observers = (old s.observers & Current)
		end

feature {F_OOM_SUBJECT}

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
end
