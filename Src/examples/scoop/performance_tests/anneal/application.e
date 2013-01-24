note
  description : "anneal application root class"
  date        : "$Date$"
  revision    : "$Revision$"

class
  APPLICATION

inherit
  ARGUMENTS

create
  make

feature {NONE} -- Initialization
  size: INTEGER = 1000
  max_dist: REAL_64 = 200.0
  map: separate MAP
  num_runs: INTEGER = 10

  make
    -- Run application.
    local
      i: INTEGER
      t1: TIME
      t2: TIME
      num_workers: INTEGER
      workers: ARRAYED_LIST [separate WORKER]
      worker: separate WORKER
    do
      num_workers := argument (1).to_integer_32
      create map.generate_map (size, max_dist)
      print ("Map generated%N")
      create t1.make_now
      create workers.make (num_workers)
      from i := 1 until i > num_workers loop
        create worker.make_default
        workers.extend (worker)
        i := i + 1
      end


      from i := 1
      until i > num_runs
      loop
      	test (num_workers, workers);
        i := i + 1
      end

      create t2.make_now

      print ((t2.relative_duration (t1).fine_seconds_count/num_runs).out + "%N")
    end


  test (num_workers: INTEGER; workers: ARRAYED_LIST [separate WORKER])
    local
      i: INTEGER
      worker: separate WORKER

      route: separate ROUTE
      barrier: separate BARRIER
    do
      create route.make (size)
      create barrier.make (1)

      -- print (tour_dist (map, route).out + "%N")
      -- print_valid (route)

      from i := 1 until i > num_workers loop
      	worker := workers [i]
        run_worker (worker, i, route, barrier)
        i := i + 1
      end

      from i := 1 until i > num_workers loop
        wait (workers [i])
        i := i + 1
      end

      -- print_valid (route)
      -- print (tour_dist (map, route).out + "%N")
    end

  print_valid (r: separate ROUTE)
    do
      print ("Valid route: " + r.valid.out + "%N")
    end

  print_time
    do
      print ((create {DATE_TIME}.make_now).out + "%N")
    end

  wait (w: separate WORKER)
    require
      w.default = w.default
    do

    end

  run_worker (worker: separate WORKER; i: INTEGER; route: separate ROUTE; barrier: separate BARRIER)
    do
      worker.make (i, map, route, barrier)
      worker.run
    end

  tour_dist (a_map: separate ARRAY2[REAL_64]; route: separate ROUTE): REAL_64
    local
      i, last: INTEGER
    do
      last := route [1]
      Result := 0.0
      from i := 2 until i > size loop
        Result := Result + a_map [last, route[i]]
        last := route [i]
        i := i + 1
      end
    end

  generate_map (a_map: separate ARRAY2[REAL_64])
    local
      i, j: INTEGER
      n: INTEGER
      rand: RANDOM
    do
      create rand.set_seed (42)
      n := a_map.width
      from i := 1 until i > n loop
        from j := 1 until j > n loop
          a_map [i, j] := rand.real_item * max_dist
          rand.forth
          j := j + 1
        end
        i := i + 1
      end
    end

end
