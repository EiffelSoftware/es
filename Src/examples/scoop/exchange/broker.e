note
	description: "BROKER is an intermediary between TRAIDERs and EXCHANGE."
	author: "Andrey Nikonov"
	date: "$2010-08-19$"
	revision: "$Revision$"

class
	BROKER
create
	make

feature

	make ( an_exchange : attached separate EXCHANGE  )
	--initialize
	do
		exchange := an_exchange
	end

	transaction ( a_traider : attached separate TRAIDER )
	do
		make_transaction ( exchange, a_traider )
	end

	make_transaction ( an_exchange : attached separate EXCHANGE; a_traider : attached separate TRAIDER  )
	do
		an_exchange.transaction ( a_traider )
	end

feature {NONE} -- Implementation

	exchange : attached separate EXCHANGE

end
