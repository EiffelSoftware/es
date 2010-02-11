class MY_HASH_TABLE 

create
	make

feature
	make (n : INTEGER)
		do
			create ht.make (n)
		end

	put (v : SEP_PASSENGER; k : INTEGER)
		do
			ht.put (v,k)
		end

	remove (k : INTEGER)
		do
			ht.remove (k)
		end

	item_for_iteration : SEP_PASSENGER
		do
			Result := ht.item_for_iteration
		end

	start
		do
			ht.start
		end

	forth
		require
			not_off: not off
		do
			ht.forth
		end

	after : BOOLEAN
		do
			Result := ht.after
		end

	count : INTEGER
		do
			Result := ht.count
		end

	off : BOOLEAN
		do
			Result := ht.off
		end


feature {NONE}
	ht : HASH_TABLE [SEP_PASSENGER, INTEGER]

end
