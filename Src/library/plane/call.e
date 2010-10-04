note
	description: "Summary description for {CALL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CALL

inherit
	VALUE

create
	make,
	make_from_prefixed

feature
	make_from_prefixed (prefixed: STRING)
		require
			proper_prefix: prefixed.starts_with (tag)
		do
			name := prefixed.substring (1, tag.count)

			create {ARRAYED_LIST [VALUE]} args.make (10)
		end

	make ( a_name: STRING
	     ; a_args: LIST [VALUE]
	     )
		do
			name := a_name
			args := a_args
		end

	name: STRING
	args: LIST [VALUE]

	tag : STRING
		do
			Result := "func_"
		end


	execute (env : PLAN_ENVIRONMENT) : ANY --
		local
			rout_obj : ROUTINE [ANY, TUPLE]
		do
			rout_obj := env.lookup_func (name)
			rout_obj.call (list_to_tuple (eval_list (args, env)))

			if attached {FUNCTION [ANY, TUPLE, ANY]} rout_obj as func_obj  then
				Result := func_obj.last_result
			else
				Result := Void
			end

		end


feature {NONE}
	eval_list (to_eval: LIST [VALUE]; env: PLAN_ENVIRONMENT): LIST [ANY]
		local
			evald_args : ARRAYED_LIST [ANY]
			i : INTEGER
		do
			create evald_args.make (10)

			from i := 1
			until i > args.count
			loop
				evald_args.force (args [i].execute (env))
				i := i + 1
			end

			Result := evald_args
		end


	list_to_tuple (l : LIST [ANY]) : TUPLE
		require
			small_list: l.count < 8
		do
			inspect l.count
			when 0 then
				Result := []
			when 1 then
				Result := [l [1]]
			when 2 then
				Result := [l [1], l [2]]
			when 3 then
				Result := [l [1], l [2], l [3]]
			when 4 then
				Result := [l [1], l [2], l [3], l [4]]
			when 5 then
				Result := [l [1], l [2], l [3], l [4], l [5]]
			when 6 then
				Result := [l [1], l [2], l [3], l [4], l [5], l [6]]
			when 7 then
				Result := [l [1], l [2], l [3], l [4], l [5], l [6], l[7]]
			else
				Result := []
			end
		ensure
			same_size: l.count = Result.count
		end

end
