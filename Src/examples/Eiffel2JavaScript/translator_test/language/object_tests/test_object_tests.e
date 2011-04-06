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

					if {safe_a:LINKED_LIST[STRING]}a then
					else
						assert (false)
					end

					if {safe_a:attached LINKED_LIST[STRING]}a then
					else
						assert (false)
					end

					if attached{LINKED_LIST[STRING]}a as safe_a then
					else
						assert (false)
					end

					if attached{LINKED_LIST[attached STRING]}a as safe_a then
					else
						assert (false)
					end

					if attached{LIST[attached STRING]}a as safe_a then
					else
						assert (false)
					end

					if attached{LIST[attached ANY]}a as safe_a then
					else
						assert (false)
					end

					if attached{LIST[ANY]}a as safe_a then
					else
						assert (false)
					end

					if attached{LIST[INTEGER]}a as safe_a then
						assert (false)
					else
					end
				end
			)
			invoke_test ("2", agent
				local
					b: LIST[STRING]
				do
					create {LINKED_LIST[attached STRING]}b.make

					if attached{LINKED_LIST[STRING]}b as safe_a then
					else
						assert (false)
					end

					if attached{LINKED_LIST[attached STRING]}b as safe_a then
					else
						assert (false)
					end

					if attached{LIST[attached STRING]}b as safe_a then
					else
						assert (false)
					end

					if attached{LIST[attached ANY]}b as safe_a then
					else
						assert (false)
					end

					if attached{LIST[ANY]}b as safe_a then
					else
						assert (false)
					end

					if attached{LIST[INTEGER]}b as safe_a then
						assert (false)
					else
					end
				end
			)
			invoke_test ("3", agent
				local
					c: LIST[STRING]
				do
					create {LINKED_LIST[STRING]}c.make

					if attached{LINKED_LIST[STRING]}c as safe_a then
					else
						assert (false)
					end

					if attached{LINKED_LIST[attached STRING]}c as safe_a then
						assert (false)
					else
					end

					if attached{LIST[attached STRING]}c as safe_a then
						assert (false)
					else
					end

					if attached{LIST[attached ANY]}c as safe_a then
						assert (false)
					else
					end

					if attached{LIST[ANY]}c as safe_a then
					else
						assert (false)
					end

					if attached{LIST[INTEGER]}c as safe_a then
						assert (false)
					else
					end
				end
			)
			invoke_test ("4", agent
				local
					d: HASH_TABLE[LIST[ANY], HASHABLE]
					d1: HASH_TABLE[LIST[ANY], HASHABLE]
					d2: HASH_TABLE[attached LINKED_LIST[attached STRING], INTEGER]
				do
					d := Void
					if {safe_d:HASH_TABLE[LIST[ANY], HASHABLE]}d  then
						assert (false)
					else
					end

					d1 ?= d
					if d1 /= Void then
						assert (false)
					else
					end

					create {HASH_TABLE[attached LINKED_LIST[attached STRING], INTEGER]}d.make (2)

					if attached{HASH_TABLE[attached LINKED_LIST[attached STRING], INTEGER]}d as safe_d then
					else
						assert (false)
					end

					d2 ?= d
					if d2 /= Void then
					else
						assert (false)
					end

					if attached{HASH_TABLE[attached LIST[STRING], INTEGER]}d as safe_d then
					else
						assert (false)
					end

						-- Known issue: this fails because INTEGER is not HASHABLE in JS world
--					if attached{HASH_TABLE[ANY, HASHABLE]}d as safe_d then
--					else
--						assert (false)
--					end
				end
			)
			invoke_test ("5", agent
				local
					a: ANY
				do
					a := 3
					if attached{INTEGER}a as safe_a then
					else
						assert (false)
					end

						-- Known issue: this fails because INTEGER is not HASHABLE in JS world
--					if attached{HASHABLE}a as safe_a then
--					else
--						assert (false)
--					end

					if attached{ANY}a as safe_a then
					else
						assert (false)
					end

					if attached{STRING}a as safe_a then
						assert (false)
					else
					end
				end
			)
		end

end
