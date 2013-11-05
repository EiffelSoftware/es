class F_OOO_SUBJECT

feature {NONE} -- Initialization

	-- TODO: default create

feature -- Access

	value: INTEGER
		-- Subject's value.

	observer: detachable F_OOO_OBSERVER
		-- Observer of this subject.

feature -- Element change

	update (new_val: INTEGER)
		require
			is_wrapped	-- default: public
			across observers as oc all oc.item.is_wrapped end -- default: public

			modify (observer)
--			modify ([Current, "value"])
			modify (Current)
		do
			unwrap -- default: public
			if attached observer then
				observer.unwrap
			end
			value := new_val
			if attached observer then
				observer.notify
				observer.wrap
			end
			wrap -- default: public
		ensure
			value_set: value = new_val
			is_wrapped	-- default: public
			across observers as oc all oc.item.is_wrapped end -- default: public
		end

feature {F_OOO_OBSERVER} -- Element change

	register (o: F_OOO_OBSERVER)
			-- Register `o' as observer.
		note
			explicit: contracts
		require
			-- is_open: removed due to explicit contracts
			observer = Void
			is_wrapped
			o.is_open

--			modify ([Current, "observer"]) -- default: command
			modify (Current)
		do
			unwrap
			observer := o
			set_observers ([o]) -- add_observer_ (o) -- feature from ANY, maintains open_, ensures observers = old observers + { o }
			wrap
		ensure
			observer = o
			is_wrapped
			-- is_open: removed due to explicit contracts
		end

invariant
	observers = [observer]
	owns = [] -- default
	subjects = [] -- default

end


  -- value: INTEGER
  -- observer: F_OOO_OBSERVER
  
  -- -- default_create
    -- -- require
      -- -- open_
    -- -- do
      -- -- owns_ := {}
      -- -- subjects_ := {}
      -- -- observers_ := {}
      -- -- value := 0
      -- -- observer := Void
      -- -- wrap_
    -- -- ensure
      -- -- wrapped_
    -- -- end
    
  -- update (new_val: INTEGER)
    -- -- require
      -- -- wrapped_
      -- -- across observers_ as o all o.wrapped_ end
    -- modify [value] Current
    -- modify observer
    -- do
      -- -- unwrap_
      -- if observer /= Void then
        -- observer.unwrap_
      -- end
      -- value := new_val
      -- if observer /= Void then
        -- observer.notify
        -- observer.wrap_
      -- end
      -- -- wrap_
    -- ensure
      -- value = new_val
      -- -- wrapped_
      -- -- across observers_ as o all o.wrapped_ end      
    -- end
    
-- feature {F_OOO_OBSERVER}    

  -- register (o: F_OOO_OBSERVER)
    -- note explicit: contracts
    -- require
      -- observer = Void
      -- wrapped_
      -- o.open_
    -- do
      -- -- unwrap_
      -- observer := o
      -- add_observer_ (o) -- feature from ANY, maintains open_, ensures observers = old observers + { o }
      -- -- wrap_
    -- ensure
      -- observer = o
      -- wrapped_
    -- end
    
-- invariant
  -- -- another way to write this is: observers_ = { observer } - { Void } (but this could be slower)
  -- observer = Void implies observers_.is_empty
  -- observer /= Void implies observers_ = { observer }
  -- -- owns_ = {}
  -- -- subjects = {}
-- note
  -- explicit: observers_
