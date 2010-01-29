note
	description: "An alternatively specified counted integer-valued cell."
	author: "Stephan van Staden"
	date: "$Date$"
	revision: "$Revision$"
	sl_predicate: "Cell(x,{val:v;cnt:c}) = Cell$CELL(x,{val:v}) * Cn$COUNTER(x,{cnt:c})"
	sl_predicate: "Cn(x,{cnt:c}) = Cn$COUNTER(x,{cnt:c})"
	js_logic: "ccel2.logic"
	js_abstraction: "ccel2.abs"

class
	CCEL2

inherit
	CEL
		redefine init, value, set_value end

	COUNTER
		redefine init, count end

create
	init

feature

	init (v: INTEGER)
		require else
			--SL-- True
		do
			Precursor {CEL} (v)
			Precursor {COUNTER} (12345)
		ensure then
			--SL-- Cell$(Current,{val:v;cnt:0})
		end

	value: INTEGER
			-- This function is inherited but respecified, hence its listing here
		require else
			--SL-- Cell$(Current,{val:_v;cnt:_c})
		do
			Result := Precursor {CEL}
		ensure then
			--SL-- Cell$(Current,{val:_v;cnt:_c}) * Result = _v
		end

	set_value (v: INTEGER)
			-- This procedure is truly overridden.
		require else
			--SL-- Cell$(Current,{val:_v;cnt:_c})
		do
			increment_helper
			Precursor {CEL} (v)
		ensure then
			--SL-- Cell$(Current,{val:v;cnt:builtin_plus(_c,1)})
		end

	count: INTEGER
			-- This function is inherited but respecified, hence it's listed here
		require else
			--SL1-- Cell$(Current,{val:_v;cnt:_c})
			--SL2-- Cn$(Current,{cnt:_c})
		do
			Result := Precursor {COUNTER}
		ensure then
			--SL1-- Cell$(Current,{val:_v;cnt:_c}) * Result = _c
			--SL2-- Cn$(Current,{cnt:_c}) * Result = _c
		end

end
