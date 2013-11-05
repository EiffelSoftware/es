class F_I_CLIENT

feature

	test
		local
			c: F_I_COLLECTION
			i1, i2: F_I_ITERATOR
		do
			create c.make (10)
			c.add (1)
			c.add (2)
			check c.observers.is_empty end
			create i1.make (c)
			check c.observers.has (i1) end
			from
				i1.forth
			until
				i1.after
			loop
--				print (i1.item)
				i1.forth
			end
			c.add (3)
			check i1.is_open end
			check c.observers.is_empty end
			create i2.make (c)
		end

end
