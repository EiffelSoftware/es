class F_OOO_OBSERVER

create
	make

feature

	make (s: F_OOO_SUBJECT)
		note
			status: creator
		require
			s.observer = Void

			modify (Current)
			modify_field (["observer", "observers", "closed"], s)
		do
			subject := s
			s.register (Current)
			cache := s.value

			set_subjects ([subject])
		ensure
			subject = s
		end

feature -- Access

	cache: INTEGER
			-- Cached value of subject.

	subject: F_OOO_SUBJECT
			-- Subject of this observer.

feature {F_OOO_SUBJECT} -- Element change

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
	attached subject
	subject.observer = Current
	cache_synchronized: cache = subject.value
	subjects = [subject]

end
