class F_OOO_OBSERVER

create
	make

feature

	make (s: F_OOO_SUBJECT)
		note
			status: creator
		require
			s.observer = Void
			s.is_wrapped -- default
			is_open -- default

			modify (s)
			modify (Current) -- default: creator
		do
			set_owns ([]) -- default: creator
			set_subjects ([]) -- default: creator
			set_observers ([]) -- default: creator

			subject := s
			s.register (Current)
			cache := s.value

			set_subjects ([subject])
			wrap
		ensure
			subject = s
			is_wrapped -- default
			s.is_wrapped -- default
		end

feature -- Access

	cache: INTEGER
			-- Cached value of subject.

	subject: F_OOO_SUBJECT
			-- Subject of this observer.

feature {F_OOO_SUBJECT} -- Element change

	notify
		require
			is_open -- default
			attached subject
		do
			cache := subject.value
		ensure
			subject = old subject
			cache = subject.value
			is_open -- default
		end

invariant
	attached subject
	subject.observer = Current
	cache = subject.value
	subjects = [subject]
	across subjects as sc all sc.item.observers.has (Current) end -- default
	owns = [] -- default
	observers = [] -- default

end

-- feature
  -- subject: F_OOO_SUBJECT
  
  -- cache: INTEGER
  
  -- make (s: F_OOO_SUBJECT)
    -- require
      -- s.observer = Void
      -- -- s.wrapped_
      -- -- open_
    -- modify s, Current
    -- do
      -- -- owns_ := {}
      -- -- subjects_ := {}
      -- -- observers_ := {}    
      -- subject := s      
      -- s.register (Current)
      -- cache := s.value
      -- -- subjects_ = { subject } -- because subjects_ is implicit
      -- -- wrap_
    -- ensure
      -- subject = s
      -- -- wrapped_
      -- -- s.wrapped_
    -- end
    
-- feature {SUBJECT}    
  -- notify
    -- require
      -- -- open_
      -- subject /= Void
    -- do
      -- cache := subject.value -- Another possibility for notify would be to wrap the object, but then we have to list the rest of the invariant in the precondition
    -- ensure
      -- subject = old subject
      -- cache = subject.value
      -- -- open_
    -- end
  
-- invariant
  -- subject /= Void
  -- subject.observer = Current
  -- cache = subject.value
  -- subjects_ = { subject }
  -- -- across subjects_ as s all s.observers.has (Current) end
  -- -- owns_ = {}
  -- -- observers_ = {}   
