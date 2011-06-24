class
	TEST_AGENTS

inherit
	TEST

create
	make

feature {NONE} -- Initialization

	make
		do
			invoke_test ("1", agent
				local
					agents: LIST[attached FUNCTION[ANY, attached TUPLE[INTEGER], INTEGER]]
					i: INTEGER
				do
					agents := agents_maker
					from
						i := 1
					until
						i > 10
					loop
						assert (agents[i].item ([i]) = 2 * i)
						i := i + 1
					end
				end
			)
		end

	agents_maker: attached LIST[attached FUNCTION[ANY, attached TUPLE[INTEGER], INTEGER]]
		local
			i: INTEGER
		do
			from
				create {LINKED_LIST[attached FUNCTION[ANY, attached TUPLE[INTEGER], INTEGER]]}Result.make
				i := 1
			until
				i > 10
			loop
				Result.extend (agent (a,b: INTEGER): INTEGER do
					Result := a + b
				end (i, ?))
				i := i + 1
			end
		end



end
