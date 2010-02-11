This is an implementation of "Roller Coaster" problem as described in 
"The Little Book of Semaphores" by Allen B. Downey Version 2.1.5.

Problem Description:
  
  Suppose there are n passenger threads and a car thread. The passengers 
  repeatedly wait to take rides in the car, which can hold C passengers, 
  where C < n. The car can go around the tracks only when it is full.
  
  Here are some additional details:
    • Passengers should invoke board and unboard.
    • The car should invoke load, run and unload.
    • Passengers cannot board until the car has invoked load
    • The car cannot depart until C passengers have boarded.
    • Passengers cannot unboard until the car has invoked unload.