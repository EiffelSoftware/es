class F_MC_MASTER

feature {NONE} -- Initialization

	-- TODO: default_create
	
feature

	time: INTEGER
			-- Clock time.

	tick
		require
			is_wrapped
			across observers as o all o.is_open end

			modify (Current) -- default
		do
			unwrap -- default
			time := time + 1
			wrap -- default
		ensure
			time > old time
			is_wrapped
		end

invariant
	0 <= time
	owns = [] -- default
	subjects = [] -- default

end

-- note
	-- description: "Version without reset."  

-- class MASTER
-- feature
  -- time: INTEGER
  
  -- -- default_create
    -- -- require
      -- -- open_
    -- -- modify Current
    -- -- do
      -- -- owns_ := {}
      -- -- subjects_ := {}
      -- -- observers_ := {}
      -- -- time := 0
      -- -- wrap_
    -- -- ensure
      -- -- wrapped_
      -- -- observers.is_empty
    -- -- end
    
  -- tick
    -- note explicit: contracts
    -- require
      -- wrapped_
      -- across observers as o all o.open_ end
    -- -- modify Current
    -- do
      -- -- unwrap_
      -- time := time + 1
      -- -- wrap_
    -- ensure
      -- time > old time
      -- wrapped_
    -- end
      
-- invariant
  -- 0 <= time  
  -- -- owns_ = {}  
  -- -- subjects = {}
-- note
  -- explicit: observers_ -- otherwise would be empty by default
-- end
