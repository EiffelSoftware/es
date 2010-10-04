note
	description : "plane application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	MISC_TESTS

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
		local
			tl_parse: TLPLAN_PARSE
			file: PLAIN_TEXT_FILE
			vals : LIST [VALUE]
			anno: PLAN_ANNOTATOR
		do
			create tl_parse.make
			create file.make ("soln.plan")

			file.open_read

			vals := tl_parse.parse (file)

			print (vals.count)
		end

	writing_tlplan_direct
		local
			plan_gen : PLAN_GENERATOR
		do
			create plan_gen.make ("Test", simple_domain, simple_problem, "/home/scott/")
			plan_gen.write_files
			plan_gen.generate.do_nothing
		end

	simple_problem : PDDL_PROBLEM
		local
			ob : OBJ
			init: BIN_EXPR
			islist: UN_EXPR
			len_list: UN_EXPR
			const_list: CONST_EXPR
			const_0, const_1: CONST_EXPR
			goal : BIN_EXPR
		do
			create ob.make ("lst", "List")

			create const_list.make_const ("lst")
			create len_list.make_un ("count", const_list)
			create const_1.make_const ("1")
			create init.make_bin ("=", len_list, const_1)

			create islist.make_un ("is-list", const_list)

			create const_0.make_const ("0")
			create goal.make_bin ("=", len_list, const_0)

			create Result.make ( "Test"
			                   , create {ARRAYED_LIST[OBJ]}.make_from_array (<<ob>>)
			                   , create {ARRAYED_LIST[EXPR]}.make_from_array (<<init, islist>>)
			                   , create {ARRAYED_LIST[EXPR]}.make_from_array (<<goal>>))
		end

	simple_domain : ADL_DOMAIN
		local
			s1,s2 : SYMBOL_DEF
		do
			create s1.make_func ("count", 1)
			create s2.make_pred ("is-list", 1)

			create Result.make ( create {ARRAYED_LIST[SYMBOL_DEF]}.make_from_array (<<s1,s2>>)
			                   , create {ARRAYED_LIST[ADL_ACTION]}.make_from_array (<<simple_action>>)
			                   )
		end

	simple_action : ADL_ACTION
		local
			l_expr: VAR_EXPR
			pre_expr: UN_EXPR
			main_expr: UN_EXPR
			clear_expr: BIN_EXPR
			prec : PRE

			len_list: UN_EXPR
			const_0 : CONST_EXPR
		do
			create l_expr.make_var ("l")

			create pre_expr.make_un ("is-list", l_expr)
			create prec.make ("l", pre_expr)

			create len_list.make_un ("count", l_expr)
			create const_0.make_const ("0")
			create clear_expr.make_bin ("=", len_list, const_0)

			create main_expr.make_un ("add", clear_expr)

			create Result.make ( "wipeout"
			                   , create {ARRAYED_LIST[STRING]}.make_from_array (<<"l">>)
			                   , create {ARRAYED_LIST[PRE]}.make_from_array (<<prec>>)
			                   , create {ARRAYED_LIST[EXPR]}.make_from_array (<<main_expr>>)
			                   )

		end

end
