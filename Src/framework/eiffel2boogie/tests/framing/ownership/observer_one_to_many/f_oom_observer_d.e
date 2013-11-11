note
	explicit: "all"

class F_OOM_OBSERVER_D

create
	make

feature

	subject: F_OOM_SUBJECT_D

	cache: INTEGER

	make (s: F_OOM_SUBJECT_D)
		require
			s /= Void
			s.is_wrapped
			is_open

			modify ([s, Current])
		do
			subject := s
			s.register (Current)
			cache := s.value
			set_subjects ([subject]) -- implicit?
			wrap
		ensure
			subject = s
			is_wrapped
			s.is_wrapped
			s.observers = (old s.observers & Current)
		end

feature {F_OOM_SUBJECT_D}

	  notify
		require
		  is_open -- default: non-public
		  subject /= Void
		do
			cache := subject.value
		ensure
			subject = old subject
			cache = subject.value
			is_open -- default: non-public
		end

invariant
	subject /= Void
	subject.observers.has (Current)
	cache = subject.value
	subjects = [subject]
	across subjects as s all s.item.observers.has (Current) end
	owns = []
	observers = []

end
