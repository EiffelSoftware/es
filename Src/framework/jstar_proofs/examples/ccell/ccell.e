note
	description: "A counted integer-valued cell."
	author: "Stephan van Staden"
	date: "$Date$"
	revision: "$Revision$"
	sl_predicate: "Cell(x,{val:v;cnt:c}) = Cc$CCELL(x,{val:v;cnt:c})"
	sl_predicate: "Cn(x,{cnt:c}) = Cn$COUNTER(x,{cnt:c})"
	sl_predicate: "Cc(x,{val:v;cnt:c}) = Cell$CELL(x,{val:v}) * Cn$COUNTER(x,{cnt:c})"
	js_logic: "ccell.logic"
	js_abstraction: "ccell.abs"

class
	CCELL

inherit
	CEL
		redefine init, value, set_value end

	COUNTER
		redefine init, count, increment end

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
			--SL-- Cc$(Current,{val:v;cnt:0})
		end

	value: INTEGER
			-- This function is inherited but respecified, hence its listing here
		require else
			--SL1-- Cc$(Current,{val:_v;cnt:_c})
			--SL2-- Cell$(Current,{val:_v;cnt:_c})
		do
			Result := Precursor {CEL}
		ensure then
			--SL1-- Cc$(Current,{val:_v;cnt:_c}) * Result = _v
			--SL2-- Cell$(Current,{val:_v;cnt:_c}) * Result = _v
		end

	set_value (v: INTEGER)
			-- This procedure is truly overridden.
		require else
			--SL1-- Cc$(Current,{val:_v;cnt:_c})
			--SL2-- Cell$(Current,{val:_v;cnt:_c})
		do
			increment_helper
			Precursor {CEL} (v)
		ensure then
			--SL1-- Cc$(Current,{val:v;cnt:builtin_plus(_c,1)})
			--SL2-- Cell$(Current,{val:v;cnt:builtin_plus(_c,1)})
		end

	count: INTEGER
			-- This function is inherited but respecified, hence it's listed here
		require else
			--SL1-- Cc$(Current,{val:_v;cnt:_c})
			--SL2-- Cn$(Current,{cnt:_c})
		do
			Result := Precursor {COUNTER}
		ensure then
			--SL1-- Cc$(Current,{val:_v;cnt:_c}) * Result = _c
			--SL2-- Cn$(Current,{cnt:_c}) * Result = _c
		end

	increment
			-- Also inherited and respecified
		require else
			--SL1-- Cc$(Current,{val:_v;cnt:_c})
			--SL2-- Cn$(Current,{cnt:_c})
		do
			Precursor {COUNTER}
		ensure then
			--SL1-- Cc$(Current,{val:_v;cnt:builtin_plus(_c,1)})
			--SL2-- Cn$(Current,{cnt:builtin_plus(_c,1)})
		end

end
