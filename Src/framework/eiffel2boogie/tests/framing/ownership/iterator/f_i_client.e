note
	explicit: "all"

class F_I_CLIENT

feature

	test
		local
			c: F_I_COLLECTION
			i1, i2: F_I_ITERATOR
			l_i: INTEGER
		do
			create c.make (10)
--			check c.count = 0 end
--			check c.capacity = 10 end
--			check c.observers.is_empty end

			c.add (1)
--			check c.count = 1 end
--			check c.capacity = 10 end
--			check c.observers.is_empty end

			c.add (2)

--			check c.count = 2 end
--			check c.capacity = 10 end
--			check c.observers.is_empty end

			create i1.make (c)

--			check c.count = 2 end
--			check c.capacity = 10 end
--			check c.observers = [i1] end
--			check i1.before end
--			check not i1.after end
--			check i1.index = 0 end

			i1.forth

--			check c.count = 2 end
--			check c.capacity = 10 end
--			check c.observers = [i1] end
--			check i1.index = 1 end
--			check not i1.before end
--			check not i1.after end

			l_i := i1.item

--			check c.count = 2 end
--			check c.capacity = 10 end
--			check c.observers = [i1] end
--			check i1.index = 1 end
--			check not i1.before end
--			check not i1.after end

			i1.forth

--			check c.count = 2 end
--			check c.capacity = 10 end
--			check c.observers = [i1] end
--			check i1.index = 2 end
--			check not i1.before end
--			check not i1.after end

			l_i := i1.item

--			check c.count = 2 end
--			check c.capacity = 10 end
--			check c.observers = [i1] end
--			check i1.index = 2 end
--			check not i1.before end
--			check not i1.after end

			i1.forth

--			check c.count = 2 end
--			check c.capacity = 10 end
--			check c.observers = [i1] end
--			check i1.index = 3 end
--			check not i1.before end
--			check i1.after end

--			check i1.after end

--			from
--				i1.forth
--			until
--				i1.after
--			loop
----				print (i1.item)
--				i1.forth
--			end

			c.add (3)
			check i1.is_open end
			check c.observers.is_empty end
			create i2.make (c)

--			check false end
		end

	test_d
		local
			c: F_I_COLLECTION_D
			i1, i2: F_I_ITERATOR_D
			l_i: INTEGER
		do
			create c.make (10)
			c.add (1)
			c.add (2)

			create i1.make (c)

			i1.forth
			l_i := i1.item
			i1.forth
			l_i := i1.item
			i1.forth
			check i1.after end

			c.add (3)
			check i1.is_open end
			check c.observers.is_empty end
			create i2.make (c)
		end

end
