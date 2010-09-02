note
	description : "An example represents a stock exchange model: one exchange, m brokers and n traiders."
	date        : "$Date: 2010-08-19$"
	revision    : "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	--list of traiders
	traiders : LINKED_LIST [ attached separate TRAIDER ]
	--list of brokers
	brokers : LINKED_LIST [ attached separate BROKER ]
	--stock exchange
	exchange : attached separate EXCHANGE
	--initial stock price
	initial_price : INTEGER

	--temporary variables
	l_broker : attached separate BROKER
	l_traider : attached separate TRAIDER

	-- number of traiders
	traid_num : INTEGER
	-- number of brokers
	brok_num : INTEGER

	--random value for traiders to brokers matching
	rnd : RANDOM

	i, j : INTEGER

	make
			-- Run application.
		do
			initial_price := 100
			traid_num := 11
			brok_num := 3

			create rnd.make
			rnd.set_seed ( 777 )

			create traiders.make
			create brokers.make
			create exchange.make ( initial_price )

			--brokers creation
			from
				j := 1
			until j > brok_num

			loop
				create l_broker.make ( exchange )
				brokers.extend ( l_broker )
				j := j + 1
			end

			from
				j := 1
			until j > traid_num

			loop
				--matching i-th broker to j-th traider
				i := 1 + rnd.next_random (j) \\ brok_num
				create l_traider.make ( j, brokers.i_th ( i ), (initial_price / traid_num).truncated_to_integer )
				traiders.extend ( l_traider )
				j := j + 1
			end
			--making separate transactions by traiders via certain brokers
			--every traider's transaction have impact on stock price
			from
				traiders.start
			until
				traiders.after
			loop
				make_transaction ( traiders.item )
				traiders.forth
			end

			--output stock price
			output ( exchange )

		end

	--separate call
	make_transaction ( a_traider : attached separate TRAIDER )
	do
		a_traider.transaction
	end
	--separate call
	output ( an_exchange: attached separate EXCHANGE )
	do
		an_exchange.output
	end

end
