note
	description: "A cell storing an integer."
	author: "Stephan van Staden"
	date: "$Date$"
	revision: "$Revision$"
	sl_predicate: "Cell(x, {val:v}) = x.<CEL.my_value> |-> v"
	js_logic: "cel.logic"
	js_abstraction: "cel.abs"

class
	CEL

create
	init

feature

	init (v: INTEGER)
		require
			--SL-- True
		do
			my_value := v
		ensure
			--SL-- Cell$(Current, {val:v})
		end

	value: INTEGER
		require
			--SL-- Cell$(Current, {val:_v})
		do
			Result := my_value
		ensure
			--SL-- Cell$(Current, {val:_v}) * Result = _v
		end

	set_value (v: INTEGER)
        require
        	--SL-- Cell$(Current, {val:_v})
        do
            my_value := v
        ensure
        	--SL-- Cell$(Current, {val:v})
        end

	my_value: INTEGER

end
