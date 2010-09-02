note
	description: "Traider has an id, price impact value and character - bull or bear."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TRAIDER
create
	make

feature
	make ( an_id : INTEGER; a_broker : attached separate BROKER; a_price_impact_value : INTEGER  )
	--initialize
	do
		id := an_id
		broker := a_broker
		price_impact_value := a_price_impact_value
	end

	transaction
	do
		make_transaction ( broker, Current )
	end

	make_transaction ( a_broker :  attached separate BROKER; a_traider : attached separate TRAIDER )
	do
		a_broker.transaction ( a_traider )
	end

	is_bull : BOOLEAN
	-- is traider a bull ( True ) or bear ( False )
	do
		Result := id \\ 2 = 0
	end

	invoke
	do
		--wait by necessity
	end

feature -- Implementation

	id : INTEGER

feature {NONE}

	broker : attached separate BROKER

feature {EXCHANGE}
	price_impact_value : INTEGER

end
