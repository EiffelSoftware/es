class SEP_PASSENGER

create
	make

feature
	passenger : separate PASSENGER

	make (p : separate PASSENGER)
	do
		passenger := p
	ensure
		passenger_set: passenger = p
	end
end
