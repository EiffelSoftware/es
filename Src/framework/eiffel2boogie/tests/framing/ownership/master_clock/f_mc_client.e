class F_MC_CLIENT

feature

	test
		local
			m: F_MC_MASTER
			c1, c2: F_MC_CLOCK
		do
			create m
			create c1.make (m)
			create c2.make (m)

			check m.observers = [c1, c2] end

			unwrap_all ([c1, c2])
			m.tick
			wrap_all ([c1, c2])

			c1.sync
			c2.sync
		end

end

-- class CLIENT
-- feature
  -- test
    -- local
      -- m: MASTER
      -- c1, c2: CLOCK
    -- do
      -- create m
      -- create c1.make (m)
      -- create c2.make (m)
      -- check m.observers_ = { c1, c2 } end
      -- c1.unwrap_; c2.unwrap_
      -- m.tick
      -- c1.wrap_; c2.wrap_ -- c1.user_inv follows from the postcondition of tick and the invariant of CLOCK
      -- c1.sync
      -- c2.sync
    -- end
-- end
