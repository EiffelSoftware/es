class F_OOO_OBSERVER

create
	make

feature

	make (s: F_OOO_SUBJECT)
		note
			status: creator
		require
			s.observer = Void
			across s.observers as sc all sc.item.is_wrapped end -- default: public

			modify (s)
			modify (Current) -- default: creator
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
			attached subject

			modify_field ("cache", Current)
		do
			cache := subject.value
		ensure
			cache = subject.value
		end

invariant
	attached subject
	subject.observer = Current
	cache = subject.value
	subjects = [subject]

end
