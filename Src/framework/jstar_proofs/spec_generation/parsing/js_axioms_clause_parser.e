class JS_AXIOMS_CLAUSE_PARSER


inherit
    YY_PARSER_SKELETON
        rename make as make_parser_skeleton end
    
    JS_SPEC_LEXER
    rename make as make_scanner end
    
create
    make

feature {NONE} -- Implementation

	yy_build_parser_tables is
			-- Build parser tables.
		do
			yytranslate := yytranslate_template
			yyr1 := yyr1_template
			yytypes1 := yytypes1_template
			yytypes2 := yytypes2_template
			yydefact := yydefact_template
			yydefgoto := yydefgoto_template
			yypact := yypact_template
			yypgoto := yypgoto_template
			yytable := yytable_template
			yycheck := yycheck_template
		end

	yy_create_value_stacks is
			-- Create value stacks.
		do
		end

	yy_init_value_stacks is
			-- Initialize value stacks.
		do
			yyvsp1 := -1
			yyvsp2 := -1
			yyvsp3 := -1
			yyvsp4 := -1
			yyvsp5 := -1
			yyvsp6 := -1
			yyvsp7 := -1
			yyvsp8 := -1
			yyvsp9 := -1
			yyvsp10 := -1
			yyvsp11 := -1
			yyvsp12 := -1
			yyvsp13 := -1
			yyvsp14 := -1
			yyvsp15 := -1
			yyvsp16 := -1
			yyvsp17 := -1
			yyvsp18 := -1
		end

	yy_clear_value_stacks is
			-- Clear objects in semantic value stacks so that
			-- they can be collected by the garbage collector.
		local
			l_yyvs1_default_item: ANY
			l_yyvs2_default_item: STRING
			l_yyvs3_default_item: JS_PRED_DEF_NODE
			l_yyvs4_default_item: JS_PARAM_NODE
			l_yyvs5_default_item: LINKED_LIST [JS_PARAM_NODE]
			l_yyvs6_default_item: JS_EXPORTS_NODE
			l_yyvs7_default_item: JS_NAMED_FORMULA_NODE
			l_yyvs8_default_item: LINKED_LIST [JS_NAMED_FORMULA_NODE]
			l_yyvs9_default_item: JS_WHERE_PRED_DEF_NODE
			l_yyvs10_default_item: LINKED_LIST [JS_WHERE_PRED_DEF_NODE]
			l_yyvs11_default_item: JS_ASSERTION_NODE
			l_yyvs12_default_item: JS_ARGUMENT_NODE
			l_yyvs13_default_item: LINKED_LIST [JS_ARGUMENT_NODE]
			l_yyvs14_default_item: JS_VARIABLE_NODE
			l_yyvs15_default_item: JS_FLD_EQUALITY_NODE
			l_yyvs16_default_item: LINKED_LIST [JS_FLD_EQUALITY_NODE]
			l_yyvs17_default_item: JS_TYPE_NODE
			l_yyvs18_default_item: JS_FIELD_SIG_NODE
		do
			if yyvs1 /= Void then
				yyvs1.fill_with (l_yyvs1_default_item, 0, yyvs1.upper)
			end
			if yyvs2 /= Void then
				yyvs2.fill_with (l_yyvs2_default_item, 0, yyvs2.upper)
			end
			if yyvs3 /= Void then
				yyvs3.fill_with (l_yyvs3_default_item, 0, yyvs3.upper)
			end
			if yyvs4 /= Void then
				yyvs4.fill_with (l_yyvs4_default_item, 0, yyvs4.upper)
			end
			if yyvs5 /= Void then
				yyvs5.fill_with (l_yyvs5_default_item, 0, yyvs5.upper)
			end
			if yyvs6 /= Void then
				yyvs6.fill_with (l_yyvs6_default_item, 0, yyvs6.upper)
			end
			if yyvs7 /= Void then
				yyvs7.fill_with (l_yyvs7_default_item, 0, yyvs7.upper)
			end
			if yyvs8 /= Void then
				yyvs8.fill_with (l_yyvs8_default_item, 0, yyvs8.upper)
			end
			if yyvs9 /= Void then
				yyvs9.fill_with (l_yyvs9_default_item, 0, yyvs9.upper)
			end
			if yyvs10 /= Void then
				yyvs10.fill_with (l_yyvs10_default_item, 0, yyvs10.upper)
			end
			if yyvs11 /= Void then
				yyvs11.fill_with (l_yyvs11_default_item, 0, yyvs11.upper)
			end
			if yyvs12 /= Void then
				yyvs12.fill_with (l_yyvs12_default_item, 0, yyvs12.upper)
			end
			if yyvs13 /= Void then
				yyvs13.fill_with (l_yyvs13_default_item, 0, yyvs13.upper)
			end
			if yyvs14 /= Void then
				yyvs14.fill_with (l_yyvs14_default_item, 0, yyvs14.upper)
			end
			if yyvs15 /= Void then
				yyvs15.fill_with (l_yyvs15_default_item, 0, yyvs15.upper)
			end
			if yyvs16 /= Void then
				yyvs16.fill_with (l_yyvs16_default_item, 0, yyvs16.upper)
			end
			if yyvs17 /= Void then
				yyvs17.fill_with (l_yyvs17_default_item, 0, yyvs17.upper)
			end
			if yyvs18 /= Void then
				yyvs18.fill_with (l_yyvs18_default_item, 0, yyvs18.upper)
			end
		end

	yy_push_last_value (yychar1: INTEGER) is
			-- Push semantic value associated with token `last_token'
			-- (with internal id `yychar1') on top of corresponding
			-- value stack.
		do
			inspect yytypes2.item (yychar1)
			when 1 then
				yyvsp1 := yyvsp1 + 1
				if yyvsp1 >= yyvsc1 then
					if yyvs1 = Void then
						debug ("GEYACC")
							std.error.put_line ("Create yyvs1")
						end
						create yyspecial_routines1
						yyvsc1 := yyInitial_yyvs_size
						yyvs1 := yyspecial_routines1.make (yyvsc1)
					else
						debug ("GEYACC")
							std.error.put_line ("Resize yyvs1")
						end
						yyvsc1 := yyvsc1 + yyInitial_yyvs_size
						yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
					end
				end
				yyvs1.put (last_any_value, yyvsp1)
			when 2 then
				yyvsp2 := yyvsp2 + 1
				if yyvsp2 >= yyvsc2 then
					if yyvs2 = Void then
						debug ("GEYACC")
							std.error.put_line ("Create yyvs2")
						end
						create yyspecial_routines2
						yyvsc2 := yyInitial_yyvs_size
						yyvs2 := yyspecial_routines2.make (yyvsc2)
					else
						debug ("GEYACC")
							std.error.put_line ("Resize yyvs2")
						end
						yyvsc2 := yyvsc2 + yyInitial_yyvs_size
						yyvs2 := yyspecial_routines2.resize (yyvs2, yyvsc2)
					end
				end
				yyvs2.put (last_string_value, yyvsp2)
			else
				debug ("GEYACC")
					std.error.put_string ("Error in parser: not a token type: ")
					std.error.put_integer (yytypes2.item (yychar1))
					std.error.put_new_line
				end
				abort
			end
		end

	yy_push_error_value is
			-- Push semantic value associated with token 'error'
			-- on top of corresponding value stack.
		local
			yyval1: ANY
		do
			yyvsp1 := yyvsp1 + 1
			if yyvsp1 >= yyvsc1 then
				if yyvs1 = Void then
					debug ("GEYACC")
						std.error.put_line ("Create yyvs1")
					end
					create yyspecial_routines1
					yyvsc1 := yyInitial_yyvs_size
					yyvs1 := yyspecial_routines1.make (yyvsc1)
				else
					debug ("GEYACC")
						std.error.put_line ("Resize yyvs1")
					end
					yyvsc1 := yyvsc1 + yyInitial_yyvs_size
					yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
				end
			end
			yyvs1.put (yyval1, yyvsp1)
		end

	yy_pop_last_value (yystate: INTEGER) is
			-- Pop semantic value from stack when in state `yystate'.
		local
			yy_type_id: INTEGER
		do
			yy_type_id := yytypes1.item (yystate)
			inspect yy_type_id
			when 1 then
				yyvsp1 := yyvsp1 - 1
			when 2 then
				yyvsp2 := yyvsp2 - 1
			when 3 then
				yyvsp3 := yyvsp3 - 1
			when 4 then
				yyvsp4 := yyvsp4 - 1
			when 5 then
				yyvsp5 := yyvsp5 - 1
			when 6 then
				yyvsp6 := yyvsp6 - 1
			when 7 then
				yyvsp7 := yyvsp7 - 1
			when 8 then
				yyvsp8 := yyvsp8 - 1
			when 9 then
				yyvsp9 := yyvsp9 - 1
			when 10 then
				yyvsp10 := yyvsp10 - 1
			when 11 then
				yyvsp11 := yyvsp11 - 1
			when 12 then
				yyvsp12 := yyvsp12 - 1
			when 13 then
				yyvsp13 := yyvsp13 - 1
			when 14 then
				yyvsp14 := yyvsp14 - 1
			when 15 then
				yyvsp15 := yyvsp15 - 1
			when 16 then
				yyvsp16 := yyvsp16 - 1
			when 17 then
				yyvsp17 := yyvsp17 - 1
			when 18 then
				yyvsp18 := yyvsp18 - 1
			else
				debug ("GEYACC")
					std.error.put_string ("Error in parser: unknown type id: ")
					std.error.put_integer (yy_type_id)
					std.error.put_new_line
				end
				abort
			end
		end

feature {NONE} -- Semantic actions

	yy_do_action (yy_act: INTEGER) is
			-- Execute semantic action.
		local
			yyval8: LINKED_LIST [JS_NAMED_FORMULA_NODE]
			yyval7: JS_NAMED_FORMULA_NODE
			yyval11: JS_ASSERTION_NODE
			yyval2: STRING
			yyval13: LINKED_LIST [JS_ARGUMENT_NODE]
			yyval12: JS_ARGUMENT_NODE
			yyval14: JS_VARIABLE_NODE
			yyval16: LINKED_LIST [JS_FLD_EQUALITY_NODE]
			yyval15: JS_FLD_EQUALITY_NODE
			yyval17: JS_TYPE_NODE
			yyval1: ANY
			yyval18: JS_FIELD_SIG_NODE
		do
			inspect yy_act
when 1 then
--|#line 93 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 93")
end

create yyval8.make 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp8 := yyvsp8 + 1
	if yyvsp8 >= yyvsc8 then
		if yyvs8 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs8")
			end
			create yyspecial_routines8
			yyvsc8 := yyInitial_yyvs_size
			yyvs8 := yyspecial_routines8.make (yyvsc8)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs8")
			end
			yyvsc8 := yyvsc8 + yyInitial_yyvs_size
			yyvs8 := yyspecial_routines8.resize (yyvs8, yyvsc8)
		end
	end
	yyvs8.put (yyval8, yyvsp8)
end
when 2 then
--|#line 94 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 94")
end

yyvs8.item (yyvsp8).put_front (yyvs7.item (yyvsp7)); yyval8 := yyvs8.item (yyvsp8) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp7 := yyvsp7 -1
	yyvs8.put (yyval8, yyvsp8)
end
when 3 then
--|#line 97 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 97")
end

create {JS_NAMED_IMPLICATION_NODE} yyval7.make (yyvs2.item (yyvsp2), yyvs11.item (yyvsp11 - 1), yyvs11.item (yyvsp11)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp7 := yyvsp7 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -2
	yyvsp11 := yyvsp11 -2
	if yyvsp7 >= yyvsc7 then
		if yyvs7 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs7")
			end
			create yyspecial_routines7
			yyvsc7 := yyInitial_yyvs_size
			yyvs7 := yyspecial_routines7.make (yyvsc7)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs7")
			end
			yyvsc7 := yyvsc7 + yyInitial_yyvs_size
			yyvs7 := yyspecial_routines7.resize (yyvs7, yyvsc7)
		end
	end
	yyvs7.put (yyval7, yyvsp7)
end
when 4 then
--|#line 98 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 98")
end

create {JS_NAMED_IFF_NODE} yyval7.make (yyvs2.item (yyvsp2), yyvs11.item (yyvsp11 - 1), yyvs11.item (yyvsp11)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp7 := yyvsp7 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -2
	yyvsp11 := yyvsp11 -2
	if yyvsp7 >= yyvsc7 then
		if yyvs7 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs7")
			end
			create yyspecial_routines7
			yyvsc7 := yyInitial_yyvs_size
			yyvs7 := yyspecial_routines7.make (yyvsc7)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs7")
			end
			yyvsc7 := yyvsc7 + yyInitial_yyvs_size
			yyvs7 := yyspecial_routines7.resize (yyvs7, yyvsc7)
		end
	end
	yyvs7.put (yyval7, yyvsp7)
end
when 5 then
--|#line 108 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 108")
end

axioms_clause := yyvs8.item (yyvsp8) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs8.put (yyval8, yyvsp8)
end
when 6 then
--|#line 111 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 111")
end

create {JS_TRUE_NODE} yyval11.make; assertion := yyval11 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp11 := yyvsp11 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp11 >= yyvsc11 then
		if yyvs11 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs11")
			end
			create yyspecial_routines11
			yyvsc11 := yyInitial_yyvs_size
			yyvs11 := yyspecial_routines11.make (yyvsc11)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs11")
			end
			yyvsc11 := yyvsc11 + yyInitial_yyvs_size
			yyvs11 := yyspecial_routines11.resize (yyvs11, yyvsc11)
		end
	end
	yyvs11.put (yyval11, yyvsp11)
end
when 7 then
--|#line 112 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 112")
end

create {JS_FALSE_NODE} yyval11.make; assertion := yyval11 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp11 := yyvsp11 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp11 >= yyvsc11 then
		if yyvs11 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs11")
			end
			create yyspecial_routines11
			yyvsc11 := yyInitial_yyvs_size
			yyvs11 := yyspecial_routines11.make (yyvsc11)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs11")
			end
			yyvsc11 := yyvsc11 + yyInitial_yyvs_size
			yyvs11 := yyspecial_routines11.resize (yyvs11, yyvsc11)
		end
	end
	yyvs11.put (yyval11, yyvsp11)
end
when 8 then
--|#line 113 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 113")
end

create {JS_MAPSTO_NODE} yyval11.make (yyvs12.item (yyvsp12 - 1), yyvs18.item (yyvsp18), yyvs12.item (yyvsp12)); assertion := yyval11 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp11 := yyvsp11 + 1
	yyvsp12 := yyvsp12 -2
	yyvsp1 := yyvsp1 -2
	yyvsp18 := yyvsp18 -1
	if yyvsp11 >= yyvsc11 then
		if yyvs11 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs11")
			end
			create yyspecial_routines11
			yyvsc11 := yyInitial_yyvs_size
			yyvs11 := yyspecial_routines11.make (yyvsc11)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs11")
			end
			yyvsc11 := yyvsc11 + yyInitial_yyvs_size
			yyvs11 := yyspecial_routines11.resize (yyvs11, yyvsc11)
		end
	end
	yyvs11.put (yyval11, yyvsp11)
end
when 9 then
--|#line 114 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 114")
end

create {JS_PURE_PREDICATE_NODE} yyval11.make (yyvs2.item (yyvsp2), yyvs13.item (yyvsp13)); assertion := yyval11 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp11 := yyvsp11 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
	yyvsp13 := yyvsp13 -1
	if yyvsp11 >= yyvsc11 then
		if yyvs11 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs11")
			end
			create yyspecial_routines11
			yyvsc11 := yyInitial_yyvs_size
			yyvs11 := yyspecial_routines11.make (yyvsc11)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs11")
			end
			yyvsc11 := yyvsc11 + yyInitial_yyvs_size
			yyvs11 := yyspecial_routines11.resize (yyvs11, yyvsc11)
		end
	end
	yyvs11.put (yyval11, yyvsp11)
end
when 10 then
--|#line 115 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 115")
end

create {JS_SPATIAL_PRED_NODE} yyval11.make (yyvs2.item (yyvsp2), yyvs13.item (yyvsp13)); assertion := yyval11 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp11 := yyvsp11 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -2
	yyvsp13 := yyvsp13 -1
	if yyvsp11 >= yyvsc11 then
		if yyvs11 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs11")
			end
			create yyspecial_routines11
			yyvsc11 := yyInitial_yyvs_size
			yyvs11 := yyspecial_routines11.make (yyvsc11)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs11")
			end
			yyvsc11 := yyvsc11 + yyInitial_yyvs_size
			yyvs11 := yyspecial_routines11.resize (yyvs11, yyvsc11)
		end
	end
	yyvs11.put (yyval11, yyvsp11)
end
when 11 then
--|#line 116 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 116")
end

create {JS_STAR_NODE} yyval11.make (yyvs11.item (yyvsp11 - 1), yyvs11.item (yyvsp11)); assertion := yyval11 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp11 := yyvsp11 -1
	yyvsp1 := yyvsp1 -1
	yyvs11.put (yyval11, yyvsp11)
end
when 12 then
--|#line 117 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 117")
end

create {JS_OR_NODE} yyval11.make (yyvs11.item (yyvsp11 - 1), yyvs11.item (yyvsp11)); assertion := yyval11 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp11 := yyvsp11 -1
	yyvsp1 := yyvsp1 -1
	yyvs11.put (yyval11, yyvsp11)
end
when 13 then
--|#line 118 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 118")
end

create {JS_TYPE_JUDGEMENT_NODE} yyval11.make (yyvs12.item (yyvsp12), yyvs17.item (yyvsp17)); assertion := yyval11 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp11 := yyvsp11 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp1 := yyvsp1 -1
	yyvsp17 := yyvsp17 -1
	if yyvsp11 >= yyvsc11 then
		if yyvs11 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs11")
			end
			create yyspecial_routines11
			yyvsc11 := yyInitial_yyvs_size
			yyvs11 := yyspecial_routines11.make (yyvsc11)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs11")
			end
			yyvsc11 := yyvsc11 + yyInitial_yyvs_size
			yyvs11 := yyspecial_routines11.resize (yyvs11, yyvsc11)
		end
	end
	yyvs11.put (yyval11, yyvsp11)
end
when 14 then
--|#line 119 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 119")
end

create {JS_BINOP_NODE} yyval11.make (yyvs12.item (yyvsp12 - 1), yyvs2.item (yyvsp2), yyvs12.item (yyvsp12)); assertion := yyval11 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp11 := yyvsp11 + 1
	yyvsp12 := yyvsp12 -2
	yyvsp2 := yyvsp2 -1
	if yyvsp11 >= yyvsc11 then
		if yyvs11 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs11")
			end
			create yyspecial_routines11
			yyvsc11 := yyInitial_yyvs_size
			yyvs11 := yyspecial_routines11.make (yyvsc11)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs11")
			end
			yyvsc11 := yyvsc11 + yyInitial_yyvs_size
			yyvs11 := yyspecial_routines11.resize (yyvs11, yyvsc11)
		end
	end
	yyvs11.put (yyval11, yyvsp11)
end
when 15 then
--|#line 120 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 120")
end

yyval11 := yyvs11.item (yyvsp11); assertion := yyval11 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs11.put (yyval11, yyvsp11)
end
when 16 then
--|#line 123 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 123")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 17 then
--|#line 124 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 124")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 18 then
--|#line 125 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 125")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 19 then
--|#line 126 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 126")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 20 then
--|#line 127 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 127")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 21 then
--|#line 128 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 128")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 22 then
--|#line 131 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 131")
end

create yyval13.make 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp13 := yyvsp13 + 1
	if yyvsp13 >= yyvsc13 then
		if yyvs13 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs13")
			end
			create yyspecial_routines13
			yyvsc13 := yyInitial_yyvs_size
			yyvs13 := yyspecial_routines13.make (yyvsc13)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs13")
			end
			yyvsc13 := yyvsc13 + yyInitial_yyvs_size
			yyvs13 := yyspecial_routines13.resize (yyvs13, yyvsc13)
		end
	end
	yyvs13.put (yyval13, yyvsp13)
end
when 23 then
--|#line 132 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 132")
end

yyval13 := yyvs13.item (yyvsp13) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs13.put (yyval13, yyvsp13)
end
when 24 then
--|#line 135 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 135")
end

create yyval13.make; yyval13.put_front (yyvs12.item (yyvsp12)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp13 := yyvsp13 + 1
	yyvsp12 := yyvsp12 -1
	if yyvsp13 >= yyvsc13 then
		if yyvs13 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs13")
			end
			create yyspecial_routines13
			yyvsc13 := yyInitial_yyvs_size
			yyvs13 := yyspecial_routines13.make (yyvsc13)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs13")
			end
			yyvsc13 := yyvsc13 + yyInitial_yyvs_size
			yyvs13 := yyspecial_routines13.resize (yyvs13, yyvsc13)
		end
	end
	yyvs13.put (yyval13, yyvsp13)
end
when 25 then
--|#line 136 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 136")
end

yyvs13.item (yyvsp13).put_front (yyvs12.item (yyvsp12)); yyval13 := yyvs13.item (yyvsp13) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp12 := yyvsp12 -1
	yyvsp1 := yyvsp1 -1
	yyvs13.put (yyval13, yyvsp13)
end
when 26 then
--|#line 139 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 139")
end

create {JS_VARIABLE_AS_ARG_NODE} yyval12.make (yyvs14.item (yyvsp14)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp12 := yyvsp12 + 1
	yyvsp14 := yyvsp14 -1
	if yyvsp12 >= yyvsc12 then
		if yyvs12 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs12")
			end
			create yyspecial_routines12
			yyvsc12 := yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.make (yyvsc12)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs12")
			end
			yyvsc12 := yyvsc12 + yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.resize (yyvs12, yyvsc12)
		end
	end
	yyvs12.put (yyval12, yyvsp12)
end
when 27 then
--|#line 140 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 140")
end

create {JS_FUNCTION_TERM_AS_ARG_NODE} yyval12.make (yyvs2.item (yyvsp2), yyvs13.item (yyvsp13)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp12 := yyvsp12 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -2
	yyvsp13 := yyvsp13 -1
	if yyvsp12 >= yyvsc12 then
		if yyvs12 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs12")
			end
			create yyspecial_routines12
			yyvsc12 := yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.make (yyvsc12)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs12")
			end
			yyvsc12 := yyvsc12 + yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.resize (yyvs12, yyvsc12)
		end
	end
	yyvs12.put (yyval12, yyvsp12)
end
when 28 then
--|#line 141 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 141")
end

create {JS_INTEGER_AS_ARG_NODE} yyval12.make (yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp12 := yyvsp12 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp12 >= yyvsc12 then
		if yyvs12 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs12")
			end
			create yyspecial_routines12
			yyvsc12 := yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.make (yyvsc12)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs12")
			end
			yyvsc12 := yyvsc12 + yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.resize (yyvs12, yyvsc12)
		end
	end
	yyvs12.put (yyval12, yyvsp12)
end
when 29 then
--|#line 143 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 143")
end

create {JS_FLD_EQ_LIST_AS_ARG_NODE} yyval12.make (yyvs16.item (yyvsp16)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp12 := yyvsp12 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp16 := yyvsp16 -1
	if yyvsp12 >= yyvsc12 then
		if yyvs12 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs12")
			end
			create yyspecial_routines12
			yyvsc12 := yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.make (yyvsc12)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs12")
			end
			yyvsc12 := yyvsc12 + yyInitial_yyvs_size
			yyvs12 := yyspecial_routines12.resize (yyvs12, yyvsc12)
		end
	end
	yyvs12.put (yyval12, yyvsp12)
end
when 30 then
--|#line 146 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 146")
end

create yyval14.make (yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp14 := yyvsp14 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp14 >= yyvsc14 then
		if yyvs14 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs14")
			end
			create yyspecial_routines14
			yyvsc14 := yyInitial_yyvs_size
			yyvs14 := yyspecial_routines14.make (yyvsc14)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs14")
			end
			yyvsc14 := yyvsc14 + yyInitial_yyvs_size
			yyvs14 := yyspecial_routines14.resize (yyvs14, yyvsc14)
		end
	end
	yyvs14.put (yyval14, yyvsp14)
end
when 31 then
--|#line 147 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 147")
end

create yyval14.make ("?" + yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp14 := yyvsp14 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp2 := yyvsp2 -1
	if yyvsp14 >= yyvsc14 then
		if yyvs14 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs14")
			end
			create yyspecial_routines14
			yyvsc14 := yyInitial_yyvs_size
			yyvs14 := yyspecial_routines14.make (yyvsc14)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs14")
			end
			yyvsc14 := yyvsc14 + yyInitial_yyvs_size
			yyvs14 := yyspecial_routines14.resize (yyvs14, yyvsc14)
		end
	end
	yyvs14.put (yyval14, yyvsp14)
end
when 32 then
--|#line 150 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 150")
end

create yyval16.make; yyval16.put_front (yyvs15.item (yyvsp15)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp16 := yyvsp16 + 1
	yyvsp15 := yyvsp15 -1
	if yyvsp16 >= yyvsc16 then
		if yyvs16 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs16")
			end
			create yyspecial_routines16
			yyvsc16 := yyInitial_yyvs_size
			yyvs16 := yyspecial_routines16.make (yyvsc16)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs16")
			end
			yyvsc16 := yyvsc16 + yyInitial_yyvs_size
			yyvs16 := yyspecial_routines16.resize (yyvs16, yyvsc16)
		end
	end
	yyvs16.put (yyval16, yyvsp16)
end
when 33 then
--|#line 151 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 151")
end

yyvs16.item (yyvsp16).put_front (yyvs15.item (yyvsp15)); yyval16 := yyvs16.item (yyvsp16) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp15 := yyvsp15 -1
	yyvsp1 := yyvsp1 -1
	yyvs16.put (yyval16, yyvsp16)
end
when 34 then
--|#line 154 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 154")
end

create yyval15.make (yyvs2.item (yyvsp2), yyvs12.item (yyvsp12)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp15 := yyvsp15 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -1
	yyvsp12 := yyvsp12 -1
	if yyvsp15 >= yyvsc15 then
		if yyvs15 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs15")
			end
			create yyspecial_routines15
			yyvsc15 := yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.make (yyvsc15)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs15")
			end
			yyvsc15 := yyvsc15 + yyInitial_yyvs_size
			yyvs15 := yyspecial_routines15.resize (yyvs15, yyvsc15)
		end
	end
	yyvs15.put (yyval15, yyvsp15)
end
when 35 then
--|#line 157 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 157")
end

create yyval17.make (yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp17 := yyvsp17 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp17 >= yyvsc17 then
		if yyvs17 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs17")
			end
			create yyspecial_routines17
			yyvsc17 := yyInitial_yyvs_size
			yyvs17 := yyspecial_routines17.make (yyvsc17)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs17")
			end
			yyvsc17 := yyvsc17 + yyInitial_yyvs_size
			yyvs17 := yyspecial_routines17.resize (yyvs17, yyvsc17)
		end
	end
	yyvs17.put (yyval17, yyvsp17)
end
when 36 then
--|#line 160 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 160")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 0
	yyvsp1 := yyvsp1 + 1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 37 then
--|#line 161 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 161")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs1.put (yyval1, yyvsp1)
end
when 38 then
--|#line 164 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 164")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp17 := yyvsp17 -1
	if yyvsp1 >= yyvsc1 then
		if yyvs1 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs1")
			end
			create yyspecial_routines1
			yyvsc1 := yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.make (yyvsc1)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs1")
			end
			yyvsc1 := yyvsc1 + yyInitial_yyvs_size
			yyvs1 := yyspecial_routines1.resize (yyvs1, yyvsc1)
		end
	end
	yyvs1.put (yyval1, yyvsp1)
end
when 39 then
--|#line 165 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 165")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp17 := yyvsp17 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 40 then
--|#line 168 "temp.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'temp.y' at line 168")
end

create yyval18.make (yyvs2.item (yyvsp2 - 2), yyvs2.item (yyvsp2 - 1)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp18 := yyvsp18 + 1
	yyvsp2 := yyvsp2 -4
	yyvsp1 := yyvsp1 -1
	if yyvsp18 >= yyvsc18 then
		if yyvs18 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs18")
			end
			create yyspecial_routines18
			yyvsc18 := yyInitial_yyvs_size
			yyvs18 := yyspecial_routines18.make (yyvsc18)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs18")
			end
			yyvsc18 := yyvsc18 + yyInitial_yyvs_size
			yyvs18 := yyspecial_routines18.resize (yyvs18, yyvsc18)
		end
	end
	yyvs18.put (yyval18, yyvsp18)
end
			else
				debug ("GEYACC")
					std.error.put_string ("Error in parser: unknown rule id: ")
					std.error.put_integer (yy_act)
					std.error.put_new_line
				end
				abort
			end
		end

	yy_do_error_action (yy_act: INTEGER) is
			-- Execute error action.
		do
			inspect yy_act
			when 78 then
					-- End-of-file expected action.
				report_eof_expected_error
			else
					-- Default action.
				report_error ("parse error")
			end
		end

feature {NONE} -- Table templates

	yytranslate_template: SPECIAL [INTEGER] is
			-- Template for `yytranslate'
		once
			Result := yyfixed_array (<<
			    0,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,

			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,

			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    1,    2,    3,    4,
			    5,    6,    7,    8,    9,   10,   11,   12,   13,   14,
			   15,   16,   17,   18,   19,   20,   21,   22,   23,   24,
			   25,   26,   27,   28,   29,   30,   31, yyDummy>>)
		end

	yyr1_template: SPECIAL [INTEGER] is
			-- Template for `yyr1'
		once
			Result := yyfixed_array (<<
			    0,   32,   32,   33,   33,   34,   35,   35,   35,   35,
			   35,   35,   35,   35,   35,   35,   36,   36,   36,   36,
			   36,   36,   37,   37,   38,   38,   39,   39,   39,   39,
			   40,   40,   41,   41,   42,   43,   45,   45,   46,   46,
			   44, yyDummy>>)
		end

	yytypes1_template: SPECIAL [INTEGER] is
			-- Template for `yytypes1'
		once
			Result := yyfixed_array (<<
			    8,    2,    8,    7,    1,    8,    1,    1,    1,    1,
			    2,    2,    1,    1,   11,   12,   14,    2,   11,    2,
			   16,   15,    1,    2,    1,    1,    1,    1,    2,    1,
			    1,    2,    2,    2,    2,    2,    2,    1,    1,    1,
			    1,    2,   13,   13,   12,    1,   11,   11,   11,   11,
			    2,   18,    2,   17,   12,   12,   16,    1,    1,    1,
			   13,    2,    1,    1,    1,   13,   13,    1,    1,   12,
			   17,    1,    1,    2,    1,    1,    2,    1,    8,    1,
			    1, yyDummy>>)
		end

	yytypes2_template: SPECIAL [INTEGER] is
			-- Template for `yytypes2'
		once
			Result := yyfixed_array (<<
			    1,    1,    1,    1,    2,    2,    2,    2,    2,    1,
			    1,    1,    2,    1,    1,    2,    2,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1, yyDummy>>)
		end

	yydefact_template: SPECIAL [INTEGER] is
			-- Template for `yydefact'
		once
			Result := yyfixed_array (<<
			    1,    0,    5,    1,    0,    2,    6,    0,    0,    0,
			   28,   30,    7,    0,    0,    0,   26,   31,    0,    0,
			    0,   32,   22,    0,    0,    0,    0,    0,   21,    0,
			    0,   16,   17,   18,   19,   20,    0,   15,    0,   29,
			    0,   30,    0,   23,   24,   22,    4,    3,   12,   11,
			    0,    0,   36,   13,   14,   34,   33,   22,   27,    0,
			    0,    0,    0,    0,   35,    0,   25,    9,    0,    8,
			   38,    0,   27,    0,    0,   37,   40,   39,    0,    0,
			    0, yyDummy>>)
		end

	yydefgoto_template: SPECIAL [INTEGER] is
			-- Template for `yydefgoto'
		once
			Result := yyfixed_array (<<
			    2,    3,   78,   14,   36,   42,   43,   15,   16,   20,
			   21,   70,   51,   64,   71, yyDummy>>)
		end

	yypact_template: SPECIAL [INTEGER] is
			-- Template for `yypact'
		once
			Result := yyfixed_array (<<
			   62,   67, -32768,   62,   27, -32768, -32768,   60,   27,   41,
			 -32768,   55, -32768,   56,  -11,   61, -32768, -32768,    0,   51,
			   35,   31,   -8,   38,   27,   27,   27,   27, -32768,   49,
			   -3, -32768, -32768, -32768, -32768, -32768,   -8, -32768,   -8, -32768,
			   41,   34,   26, -32768,   39,   -8,  -17,  -17,   30, -32768,
			   32,   28,   21, -32768, -32768, -32768, -32768,   -8,    3,   -8,
			   12,   25,   -8,   -3, -32768,    5, -32768, -32768,   13, -32768,
			   17,    7, -32768,   10,   -3, -32768, -32768, -32768,    6,    2,
			 -32768, yyDummy>>)
		end

	yypgoto_template: SPECIAL [INTEGER] is
			-- Template for `yypgoto'
		once
			Result := yyfixed_array (<<
			   78, -32768, -32768,   37, -32768,  -44,   20,  -22, -32768,   42,
			 -32768,   50, -32768, -32768,    4, yyDummy>>)
		end

	yytable_template: SPECIAL [INTEGER] is
			-- Template for `yytable'
		once
			Result := yyfixed_array (<<
			   44,   60,   80,  -10,   27,   26,   79,   41,   10,    9,
			   27,   26,   52,   65,   54,    7,   55,   76,  -10,   25,
			   24,   27,   26,   44,  -10,  -10,   37,   74,   73,  -10,
			   13,   72,   75,  -10,  -10,   44,   68,   44,   67,   63,
			   69,   12,   11,   10,    9,   18,    8,   61,   62,   59,
			    7,   27,   58,   57,   50,    6,   19,   45,   40,   39,
			   38,   46,   47,   48,   49,   35,   34,   33,   32,   31,
			   30,   23,   29,   28,   22,   17,    4,    1,   77,   66,
			   53,    5,   56, yyDummy>>)
		end

	yycheck_template: SPECIAL [INTEGER] is
			-- Template for `yycheck'
		once
			Result := yyfixed_array (<<
			   22,   45,    0,    0,   21,   22,    0,   15,   16,   17,
			   21,   22,   15,   57,   36,   23,   38,    7,   15,   30,
			   31,   21,   22,   45,   21,   22,   26,   10,   15,   26,
			    3,   26,   25,   30,   31,   57,   11,   59,   26,   18,
			   62,   14,   15,   16,   17,    8,   19,   15,   20,   10,
			   23,   21,   26,   19,    5,   28,   15,   19,   27,   24,
			    9,   24,   25,   26,   27,    4,    5,    6,    7,    8,
			    9,   15,   11,   12,   19,   15,    9,   15,   74,   59,
			   30,    3,   40, yyDummy>>)
		end

feature {NONE} -- Semantic value stacks

	yyvs1: SPECIAL [ANY]
			-- Stack for semantic values of type ANY

	yyvsc1: INTEGER
			-- Capacity of semantic value stack `yyvs1'

	yyvsp1: INTEGER
			-- Top of semantic value stack `yyvs1'

	yyspecial_routines1: KL_SPECIAL_ROUTINES [ANY]
			-- Routines that ought to be in SPECIAL [ANY]

	yyvs2: SPECIAL [STRING]
			-- Stack for semantic values of type STRING

	yyvsc2: INTEGER
			-- Capacity of semantic value stack `yyvs2'

	yyvsp2: INTEGER
			-- Top of semantic value stack `yyvs2'

	yyspecial_routines2: KL_SPECIAL_ROUTINES [STRING]
			-- Routines that ought to be in SPECIAL [STRING]

	yyvs3: SPECIAL [JS_PRED_DEF_NODE]
			-- Stack for semantic values of type JS_PRED_DEF_NODE

	yyvsc3: INTEGER
			-- Capacity of semantic value stack `yyvs3'

	yyvsp3: INTEGER
			-- Top of semantic value stack `yyvs3'

	yyspecial_routines3: KL_SPECIAL_ROUTINES [JS_PRED_DEF_NODE]
			-- Routines that ought to be in SPECIAL [JS_PRED_DEF_NODE]

	yyvs4: SPECIAL [JS_PARAM_NODE]
			-- Stack for semantic values of type JS_PARAM_NODE

	yyvsc4: INTEGER
			-- Capacity of semantic value stack `yyvs4'

	yyvsp4: INTEGER
			-- Top of semantic value stack `yyvs4'

	yyspecial_routines4: KL_SPECIAL_ROUTINES [JS_PARAM_NODE]
			-- Routines that ought to be in SPECIAL [JS_PARAM_NODE]

	yyvs5: SPECIAL [LINKED_LIST [JS_PARAM_NODE]]
			-- Stack for semantic values of type LINKED_LIST [JS_PARAM_NODE]

	yyvsc5: INTEGER
			-- Capacity of semantic value stack `yyvs5'

	yyvsp5: INTEGER
			-- Top of semantic value stack `yyvs5'

	yyspecial_routines5: KL_SPECIAL_ROUTINES [LINKED_LIST [JS_PARAM_NODE]]
			-- Routines that ought to be in SPECIAL [LINKED_LIST [JS_PARAM_NODE]]

	yyvs6: SPECIAL [JS_EXPORTS_NODE]
			-- Stack for semantic values of type JS_EXPORTS_NODE

	yyvsc6: INTEGER
			-- Capacity of semantic value stack `yyvs6'

	yyvsp6: INTEGER
			-- Top of semantic value stack `yyvs6'

	yyspecial_routines6: KL_SPECIAL_ROUTINES [JS_EXPORTS_NODE]
			-- Routines that ought to be in SPECIAL [JS_EXPORTS_NODE]

	yyvs7: SPECIAL [JS_NAMED_FORMULA_NODE]
			-- Stack for semantic values of type JS_NAMED_FORMULA_NODE

	yyvsc7: INTEGER
			-- Capacity of semantic value stack `yyvs7'

	yyvsp7: INTEGER
			-- Top of semantic value stack `yyvs7'

	yyspecial_routines7: KL_SPECIAL_ROUTINES [JS_NAMED_FORMULA_NODE]
			-- Routines that ought to be in SPECIAL [JS_NAMED_FORMULA_NODE]

	yyvs8: SPECIAL [LINKED_LIST [JS_NAMED_FORMULA_NODE]]
			-- Stack for semantic values of type LINKED_LIST [JS_NAMED_FORMULA_NODE]

	yyvsc8: INTEGER
			-- Capacity of semantic value stack `yyvs8'

	yyvsp8: INTEGER
			-- Top of semantic value stack `yyvs8'

	yyspecial_routines8: KL_SPECIAL_ROUTINES [LINKED_LIST [JS_NAMED_FORMULA_NODE]]
			-- Routines that ought to be in SPECIAL [LINKED_LIST [JS_NAMED_FORMULA_NODE]]

	yyvs9: SPECIAL [JS_WHERE_PRED_DEF_NODE]
			-- Stack for semantic values of type JS_WHERE_PRED_DEF_NODE

	yyvsc9: INTEGER
			-- Capacity of semantic value stack `yyvs9'

	yyvsp9: INTEGER
			-- Top of semantic value stack `yyvs9'

	yyspecial_routines9: KL_SPECIAL_ROUTINES [JS_WHERE_PRED_DEF_NODE]
			-- Routines that ought to be in SPECIAL [JS_WHERE_PRED_DEF_NODE]

	yyvs10: SPECIAL [LINKED_LIST [JS_WHERE_PRED_DEF_NODE]]
			-- Stack for semantic values of type LINKED_LIST [JS_WHERE_PRED_DEF_NODE]

	yyvsc10: INTEGER
			-- Capacity of semantic value stack `yyvs10'

	yyvsp10: INTEGER
			-- Top of semantic value stack `yyvs10'

	yyspecial_routines10: KL_SPECIAL_ROUTINES [LINKED_LIST [JS_WHERE_PRED_DEF_NODE]]
			-- Routines that ought to be in SPECIAL [LINKED_LIST [JS_WHERE_PRED_DEF_NODE]]

	yyvs11: SPECIAL [JS_ASSERTION_NODE]
			-- Stack for semantic values of type JS_ASSERTION_NODE

	yyvsc11: INTEGER
			-- Capacity of semantic value stack `yyvs11'

	yyvsp11: INTEGER
			-- Top of semantic value stack `yyvs11'

	yyspecial_routines11: KL_SPECIAL_ROUTINES [JS_ASSERTION_NODE]
			-- Routines that ought to be in SPECIAL [JS_ASSERTION_NODE]

	yyvs12: SPECIAL [JS_ARGUMENT_NODE]
			-- Stack for semantic values of type JS_ARGUMENT_NODE

	yyvsc12: INTEGER
			-- Capacity of semantic value stack `yyvs12'

	yyvsp12: INTEGER
			-- Top of semantic value stack `yyvs12'

	yyspecial_routines12: KL_SPECIAL_ROUTINES [JS_ARGUMENT_NODE]
			-- Routines that ought to be in SPECIAL [JS_ARGUMENT_NODE]

	yyvs13: SPECIAL [LINKED_LIST [JS_ARGUMENT_NODE]]
			-- Stack for semantic values of type LINKED_LIST [JS_ARGUMENT_NODE]

	yyvsc13: INTEGER
			-- Capacity of semantic value stack `yyvs13'

	yyvsp13: INTEGER
			-- Top of semantic value stack `yyvs13'

	yyspecial_routines13: KL_SPECIAL_ROUTINES [LINKED_LIST [JS_ARGUMENT_NODE]]
			-- Routines that ought to be in SPECIAL [LINKED_LIST [JS_ARGUMENT_NODE]]

	yyvs14: SPECIAL [JS_VARIABLE_NODE]
			-- Stack for semantic values of type JS_VARIABLE_NODE

	yyvsc14: INTEGER
			-- Capacity of semantic value stack `yyvs14'

	yyvsp14: INTEGER
			-- Top of semantic value stack `yyvs14'

	yyspecial_routines14: KL_SPECIAL_ROUTINES [JS_VARIABLE_NODE]
			-- Routines that ought to be in SPECIAL [JS_VARIABLE_NODE]

	yyvs15: SPECIAL [JS_FLD_EQUALITY_NODE]
			-- Stack for semantic values of type JS_FLD_EQUALITY_NODE

	yyvsc15: INTEGER
			-- Capacity of semantic value stack `yyvs15'

	yyvsp15: INTEGER
			-- Top of semantic value stack `yyvs15'

	yyspecial_routines15: KL_SPECIAL_ROUTINES [JS_FLD_EQUALITY_NODE]
			-- Routines that ought to be in SPECIAL [JS_FLD_EQUALITY_NODE]

	yyvs16: SPECIAL [LINKED_LIST [JS_FLD_EQUALITY_NODE]]
			-- Stack for semantic values of type LINKED_LIST [JS_FLD_EQUALITY_NODE]

	yyvsc16: INTEGER
			-- Capacity of semantic value stack `yyvs16'

	yyvsp16: INTEGER
			-- Top of semantic value stack `yyvs16'

	yyspecial_routines16: KL_SPECIAL_ROUTINES [LINKED_LIST [JS_FLD_EQUALITY_NODE]]
			-- Routines that ought to be in SPECIAL [LINKED_LIST [JS_FLD_EQUALITY_NODE]]

	yyvs17: SPECIAL [JS_TYPE_NODE]
			-- Stack for semantic values of type JS_TYPE_NODE

	yyvsc17: INTEGER
			-- Capacity of semantic value stack `yyvs17'

	yyvsp17: INTEGER
			-- Top of semantic value stack `yyvs17'

	yyspecial_routines17: KL_SPECIAL_ROUTINES [JS_TYPE_NODE]
			-- Routines that ought to be in SPECIAL [JS_TYPE_NODE]

	yyvs18: SPECIAL [JS_FIELD_SIG_NODE]
			-- Stack for semantic values of type JS_FIELD_SIG_NODE

	yyvsc18: INTEGER
			-- Capacity of semantic value stack `yyvs18'

	yyvsp18: INTEGER
			-- Top of semantic value stack `yyvs18'

	yyspecial_routines18: KL_SPECIAL_ROUTINES [JS_FIELD_SIG_NODE]
			-- Routines that ought to be in SPECIAL [JS_FIELD_SIG_NODE]

feature {NONE} -- Constants

	yyFinal: INTEGER is 80
			-- Termination state id

	yyFlag: INTEGER is -32768
			-- Most negative INTEGER

	yyNtbase: INTEGER is 32
			-- Number of tokens

	yyLast: INTEGER is 82
			-- Upper bound of `yytable' and `yycheck'

	yyMax_token: INTEGER is 286
			-- Maximum token id
			-- (upper bound of `yytranslate'.)

	yyNsyms: INTEGER is 47
			-- Number of symbols
			-- (terminal and nonterminal)

feature -- User-defined features


-- User code

    make
        do
            make_scanner
            make_parser_skeleton
        end
    
        -- Only one of the following attributes will be valid!!!
    assertion: JS_ASSERTION_NODE
    predicate_definition: JS_PRED_DEF_NODE
	exports_clause: JS_EXPORTS_NODE
	axioms_clause: LINKED_LIST [JS_NAMED_FORMULA_NODE]
    
end
