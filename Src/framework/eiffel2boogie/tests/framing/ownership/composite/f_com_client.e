note
	explicit: "all"

class F_COM_CLIENT

feature

	test_d (c1, c2: F_COM_COMPOSITE_D)
		require
			c1.is_wrapped
			c2.is_wrapped
			across c1.up as o all o.item.is_wrapped end
			across c1.observers as o all o.item.is_wrapped end

			modify ([c1, c2])
		local
			c_new: F_COM_COMPOSITE_D
		do
			create c_new.make (10)
			c1.add_child (c_new)
			check c1.is_wrapped and c2.is_wrapped end
			check c1.value >= c_new.value end
		end

end
