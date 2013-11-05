class F_MC_CLOCK

create
	make

feature {NONE} -- Initialization

	make (m: F_MC_MASTER)
			-- Initialize clock with `m'.
		note
			status: creator
		require
			is_open -- default
			m.is_wrapped -- default
			m /= Void

			modify (Current) -- default: creator
--			modify ([m, "observers"])
			modify (m)
		do
			set_owns ([]) -- default: creator
			set_subjects ([]) -- default: creator
			set_observers ([]) -- default: creator

			master := m
			local_time := master.time

			m.unwrap
			m.set_observers (m.observers + [Current]) -- m.observers.add (Current)
			m.wrap

			set_subjects ([m]) -- default

			wrap -- default
		ensure
			is_wrapped -- default
			m.is_wrapped -- default
			master = m
			local_time = m.time
			m.observers = old m.observers + [Current]

			m.time = old m.time -- TODO: fine-grained modifies
		end

feature -- Access

	master: F_MC_MASTER
			-- Master clock.

	local_time: INTEGER
			-- Time of local clock.

	sync
			-- Sync clock to master.
		require
			is_wrapped -- default
			master.is_wrapped

			modify (Current)
		do
			unwrap -- default
			local_time := master.time
			wrap -- default
		ensure
			is_wrapped -- default
			local_time = master.time
		end

invariant
	attached master
	0 <= local_time
	local_time <= master.time
	subjects = [master]
	across subjects as s all s.item.observers.has (Current) end -- default
	owns = [] -- default
	observers = [] -- default

end

-- note
	-- description: "Version without reset. In a more complex scenario synch would take an open object with a partially holding invariant."

-- class CLOCK

-- create
  -- make

-- feature
  -- master: MASTER
  -- local_time: INTEGER

  -- make (m: MASTER)
    -- require
      -- -- open_
      -- -- m.wrapped_
      -- m /= Void
    -- modify Current
    -- modify [observers_] m
    -- do
      -- -- owns_ := {}
      -- -- subjects_ := {} -- Always in the beginning of a creation procedure, reassigned later
      -- -- observers_ := {}
      -- master := m
      -- local_time := master.time
      -- m.unwrap_
      -- m.add_observer_ (Current) -- feature from ANY, maintains open_, ensures observers = old observers + { o }
      -- m.wrap_
      -- -- subjects_ := { m }
      -- -- wrap_
    -- ensure
      -- -- wrapped_
      -- -- m.wrapped_
      -- master = m
      -- local_time = m.time
      -- m.observers_ = old m.observers_ + { Current }
    -- end

  -- synch
    -- require
      -- -- wrapped_
      -- master.wrapped_ -- otherwise cannot prove 0 <= local_time -- should this be default?
    -- -- modify: Current
    -- do
      -- -- unwrap_
      -- local_time := master.time
      -- -- wrap_
    -- ensure
      -- -- wrapped_
      -- local_time = master.time
    -- end    
    
-- invariant
  -- master /= Void
  -- 0 <= local_time
  -- local_time <= master.time
  -- subjects_ = { master }
  -- -- across subjects_ as s all s.observers.has (Current) end
  -- -- owns_ = {}
  -- -- observers_ = {}  
-- end
