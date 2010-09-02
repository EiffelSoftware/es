note
	description : "Model of stock exchange. Each transaction have influence on stock price. If traider's character (bull of bear) coincide with market trend then stock price impact factor is doubled."
	date        : "$Date: 2010-08-19$"
	revision    : "$Revision$"

class
	EXCHANGE

create
	make

feature
	make ( an_initial_price : INTEGER )
	do
		price := an_initial_price
		old_price := price
	end

	transaction ( a_traider : attached separate TRAIDER)
	do
		if is_bullish_trend then

			old_price := price
			if a_traider.is_bull then
				price := price + a_traider.price_impact_value * 2
				else
				price := price - a_traider.price_impact_value
			end

			else -- bearish trend

			if a_traider.is_bull then
				price := price + a_traider.price_impact_value
				else
				price := price - a_traider.price_impact_value * 2
			end

		end
	end

	is_bullish_trend : BOOLEAN
	do
		Result := price > old_price
	end

	output
	do
		io.put_string ( "Stock price = " + price.out)
		io.put_new_line
	end

feature {NONE}

	old_price : INTEGER
	price : INTEGER

end
