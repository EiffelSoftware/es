class F_MC_MASTER

inherit
	ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		note
			status: creator
		require else
			is_open -- default: creator
		do
			wrap -- default: creator
		ensure then
			time = 0 -- default: default_create
			is_wrapped -- default: creator
			observers.is_empty -- default: default_create
		end
	
feature

	time: INTEGER
			-- Clock time.

	tick
		note
			explicit: contracts
		require
			is_wrapped
			across observers as o all o.item.is_open end

			-- modify ([Current, "time"])
			modify (Current)
		do
			unwrap -- default
			time := time + 1
			wrap -- default
		ensure
			time > old time
			is_wrapped

			observers = old observers -- TODO: fine-grained modifies
		end

invariant
	0 <= time
	owns = [] -- default
	subjects = [] -- default

note
	explicit: observers
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
