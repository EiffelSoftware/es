class
	TEST_OBJECT_TESTS
inherit
	TEST

create
	make

feature {NONE} -- Initialization

	make
		do
			invoke_test ("1", agent
				local
					a: LIST[attached STRING]
				do
					create {LINKED_LIST[attached STRING]}a.make

					assert ({safe_a:LINKED_LIST[STRING]}a)
					assert ({safe_a:attached LINKED_LIST[STRING]}a)
					assert (attached{LINKED_LIST[STRING]}a)
					assert (attached{LINKED_LIST[attached STRING]}a)
					assert (attached{LIST[attached STRING]}a)
					assert (attached{LIST[attached ANY]}a)
					assert (attached{LIST[ANY]}a)
					assert (not attached{LIST[INTEGER]}a)
				end
			)
			invoke_test ("2", agent
				local
					b: LIST[STRING]
				do
					create {LINKED_LIST[attached STRING]}b.make

					assert (attached{LINKED_LIST[STRING]}b)
					assert (attached{LINKED_LIST[attached STRING]}b)
					assert (attached{LIST[attached STRING]}b)
					assert (attached{LIST[attached ANY]}b)
					assert (attached{LIST[ANY]}b)
					assert (not attached{LIST[INTEGER]}b)
				end
			)
			invoke_test ("3", agent
				local
					c: LIST[STRING]
				do
					create {LINKED_LIST[STRING]}c.make

					assert (attached{LINKED_LIST[STRING]}c)
					assert (not attached{LINKED_LIST[attached STRING]}c)
					assert (not attached{LIST[attached STRING]}c)
					assert (not attached{LIST[attached ANY]}c)
					assert (attached{LIST[ANY]}c)
					assert (not attached{LIST[INTEGER]}c)
				end
			)
			invoke_test ("4", agent
				local
					d: HASH_TABLE[LIST[ANY], HASHABLE]
					d1: HASH_TABLE[LIST[ANY], HASHABLE]
					d2: HASH_TABLE[attached LINKED_LIST[attached STRING], INTEGER]
				do
					d := Void
					assert (not {safe_d:HASH_TABLE[LIST[ANY], HASHABLE]}d)
					d1 ?= d
					assert (d1 = Void)

					create {HASH_TABLE[attached LINKED_LIST[attached STRING], INTEGER]}d.make (2)
					assert (attached{HASH_TABLE[attached LINKED_LIST[attached STRING], INTEGER]}d)

					d2 ?= d
					assert (d2 /= Void)

					assert (attached{HASH_TABLE[attached LIST[STRING], INTEGER]}d)
						-- Known issue: this fails because INTEGER is not HASHABLE in JS world
--					assert (attached{HASH_TABLE[ANY, HASHABLE]}d)
				end
			)
			invoke_test ("5", agent
				local
					a: ANY
				do
					a := 3
					assert (attached{INTEGER}a)
						-- Known issue: this fails because INTEGER is not HASHABLE in JS world
--					assert (attached{HASHABLE}a)
					assert (attached{ANY}a)
					assert (not attached{STRING}a)
				end
			)
		end

end
