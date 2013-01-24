class
  WORKER

create
  make_default

feature
  make_default
  	do

  	end

  make (seed: INTEGER; a_map: separate ARRAY2 [REAL_64];
        a_route: separate ROUTE
        a_barrier: separate BARRIER)
    do
      map := a_map
      create random_gen.set_seed (seed)
      num_cities := a_map.width
      route := a_route
      inner_iters := 1000
      outer_iters := 32
      barrier := a_barrier
    end


feature
  random_gen: RANDOM
  num_cities: INTEGER
  inner_iters: INTEGER
  outer_iters: INTEGER

  map: separate ARRAY2 [REAL_64]

  route: separate ROUTE

  run
    local
      delta_dist: REAL_64
      t: REAL_64
      a, b: CITY
      i, j: INTEGER
      good, bad: INTEGER
      decision: INTEGER
    do
      from
        good := 0
        bad := -1
        t := 200
        i := 0
        a := random_city (route)
      until
        not keep_going (i, good, bad, t)
      loop
        from
          j := 0
        until
          not (j < inner_iters)
        loop
          b := random_city (route)

          delta_dist := calculate_dist (map, a, b)
          decision := decide (delta_dist, t)


          if decision = Accept_good then
            good := good + 1
            swap (route, a, b)
          elseif decision = Accept_bad then
            bad := bad + 1
            swap (route, a, b)
          end

          a := b
          j := j + 1
        end

        -- barrier_work
        t := cool (t)
        i := i + 1
      end
    end

  Accept_good: INTEGER = 2
  Accept_bad: INTEGER = 1
  Deny: INTEGER = 0

  single_dist (a_map: separate ARRAY2[REAL_64]; a: CITY): REAL_64
    do
      if a.left /= -1 then
        Result := Result + a_map [a.left, a.id]
      end

      if a.right /= -1 then
        Result := Result + a_map [a.id, a.right]
      end
    end

  calculate_dist (a_map: separate ARRAY2[REAL_64]; a, b: CITY): REAL_64
    local
      swapa, swapb: CITY
    do
      Result := 0.0
      create swapa.make (a.id, b.indexInRoute, b.left, b.right)
      create swapb.make (b.id, a.indexInRoute, a.left, a.right)

      Result := Result + single_dist (a_map, swapa)
      Result := Result + single_dist (a_map, swapb)

      Result := Result - single_dist (a_map, a)
      Result := Result - single_dist (a_map, b)
    end

  random_city (r: separate ROUTE): CITY
    local
      idx: INTEGER
      id: INTEGER
      left, right: INTEGER
    do
      idx := (get_random * num_cities).ceiling
      id := r [idx]

      if idx = 1 then
        left := -1
      else
        left := r [idx - 1]
      end

      if idx = num_cities then
        right := -1
      else
        right := r [idx + 1]
      end


      create Result.make (id, idx, left, right)
    end

  swap (r: separate ROUTE; a, b: CITY)
    do
      r.swap (a.indexInRoute, b.indexInRoute)
    end

  get_random: REAL_64
    do
      Result := random_gen.real_item
      random_gen.forth
    end

  decide (delta_dist, t: REAL_64): INTEGER
    local
      rnd: REAL_64
    do
      if delta_dist < 0 then
        Result := Accept_good
      else
        rnd := get_random
        if {DOUBLE_MATH}.exp (-delta_dist/t) > rnd then
          Result := Accept_bad
        else
          Result := Deny
        end
      end
    end

  cool (t: REAL_64): REAL_64
    do
      Result := t / 1.5
    end

  keep_going (i, good, bad: INTEGER; t: REAL_64): BOOLEAN
    do
      if i = -1 then
        check keep_going: False end
      else
        Result := i < outer_iters
      end
    end

feature {NONE} -- Barrier attributes and routines
  barrier: separate BARRIER

  barrier_work
    do
      barrier_join (barrier)
      barrier_leave (barrier)
    end

  barrier_leave (a_barrier: separate BARRIER)
    require
      a_barrier.leaveable
    do
      a_barrier.leave
    end

  barrier_join (a_barrier: separate BARRIER)
    require
      a_barrier.joinable
    do
      a_barrier.join
    end

end

