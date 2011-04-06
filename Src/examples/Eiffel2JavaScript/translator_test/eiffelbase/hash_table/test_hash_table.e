class
	TEST_HASH_TABLE

inherit
	TEST

create
	make

feature {NONE} -- Initialization

	make
		do
			invoke_test ("1", agent
				local
					h: HASH_TABLE[attached STRING, attached STRING]
					foo: STRING
				do
					create h.make(5)
					assert (h.count = 0)
					assert_arrays_equal (h.current_keys, <<>>)
					assert (h.is_empty)

					h.put ("winter", "January")
					h.put ("winter", "February")
					h.put ("spring", "March")
					h.put ("spring", "April")
					h.put ("spring", "May")
					h.put ("summer", "June")
					h.put ("summer", "July")
					h.put ("summer", "August")
					h.put ("autumn", "September")
					h.put ("autumn", "October")
					h.put ("autumn", "November")
					h.put ("winter", "December")

					assert (h.count = 12)
					assert_arrays_equal (h.current_keys, << "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" >>)

					foo := h["January"]
					check foo /= Void end
					assert (foo.is_equal ("winter"))

					h["january"] := "another"
					assert (h.has ("january"))

					foo := h["January"]
					check foo /= Void end
					assert (foo.is_equal ("winter"))

					foo := h["january"]
					check foo /= Void end
					assert (foo.is_equal ("another"))

					h["January"] := "another"

					foo := h["January"]
					check foo /= Void end
					assert (foo.is_equal ("another"))

					assert (h.has ("january"))
					h.remove ("january")
					assert (not h.has ("january"))

				end
			)
		end

feature {NONE} -- Implementation

	assert_arrays_equal(arr1, arr2: attached ARRAY[attached STRING])
		local
			i: INTEGER
		do
			assert (arr1.lower = arr2.lower)
			assert (arr1.upper = arr2.upper)
			from i:=arr1.lower until i>arr1.upper loop
				assert (arr1[i].is_equal (arr2[i]))
				i := i + 1
			end
		end

end
