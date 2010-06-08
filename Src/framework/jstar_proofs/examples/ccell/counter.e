note
	description: "A simple integer-valued counter."
	author: "Stephan van Staden"
	date: "$Date$"
	revision: "$Revision$"
	sl_predicate: "Cn(x, {cnt:c}) = x.<COUNTER.my_count> |-> c"
	js_logic: "counter.logic"
	js_abstraction: "counter.abs"

class
	COUNTER

create
	init

feature

	init (dummy: INTEGER)
		require
			--SL-- True
		do
		ensure
			--SL-- Cn$(Current,{cnt:0})
		end

	count: INTEGER
		require
			--SL-- Cn$(Current,{cnt:_c})
		do
			Result := my_count
		ensure
			--SL-- Cn$(Current,{cnt:_c}) * Result = _c
		end

	increment
		require
			--SL-- Cn$(Current,{cnt:_c})
		do
			my_count := my_count + 1
		ensure
			--SL-- Cn$(Current,{cnt:builtin_plus(_c,1)})
		end

	increment_helper
		require
			--SLS-- Cn$COUNTER(Current,{cnt:_c})
		do
			my_count := my_count + 1
		ensure
			--SLS-- Cn$COUNTER(Current,{cnt:builtin_plus(_c,1)})
		end

	my_count: INTEGER


end
