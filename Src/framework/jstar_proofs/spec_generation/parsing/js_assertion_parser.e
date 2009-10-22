class JS_ASSERTION_PARSER
--class JS_PREDICATE_DEFINITION_PARSER

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
		end

	yy_clear_value_stacks is
			-- Clear objects in semantic value stacks so that
			-- they can be collected by the garbage collector.
		do
			if yyvs1 /= Void then
				yyvs1.clear_all
			end
			if yyvs2 /= Void then
				yyvs2.clear_all
			end
			if yyvs3 /= Void then
				yyvs3.clear_all
			end
			if yyvs4 /= Void then
				yyvs4.clear_all
			end
			if yyvs5 /= Void then
				yyvs5.clear_all
			end
			if yyvs6 /= Void then
				yyvs6.clear_all
			end
			if yyvs7 /= Void then
				yyvs7.clear_all
			end
			if yyvs8 /= Void then
				yyvs8.clear_all
			end
			if yyvs9 /= Void then
				yyvs9.clear_all
			end
			if yyvs10 /= Void then
				yyvs10.clear_all
			end
			if yyvs11 /= Void then
				yyvs11.clear_all
			end
			if yyvs12 /= Void then
				yyvs12.clear_all
			end
			if yyvs13 /= Void then
				yyvs13.clear_all
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
			yyval6: JS_ASSERTION_NODE
			yyval2: STRING
			yyval8: LINKED_LIST [JS_ARGUMENT_NODE]
			yyval7: JS_ARGUMENT_NODE
			yyval9: JS_VARIABLE_NODE
			yyval11: LINKED_LIST [JS_FLD_EQUALITY_NODE]
			yyval10: JS_FLD_EQUALITY_NODE
			yyval12: JS_TYPE_NODE
			yyval1: ANY
			yyval13: JS_FIELD_SIG_NODE
		do
			inspect yy_act
when 1 then
--|#line 81 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 81")
end

create {JS_TRUE_NODE} yyval6.make; assertion := yyval6 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp6 := yyvsp6 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp6 >= yyvsc6 then
		if yyvs6 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs6")
			end
			create yyspecial_routines6
			yyvsc6 := yyInitial_yyvs_size
			yyvs6 := yyspecial_routines6.make (yyvsc6)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs6")
			end
			yyvsc6 := yyvsc6 + yyInitial_yyvs_size
			yyvs6 := yyspecial_routines6.resize (yyvs6, yyvsc6)
		end
	end
	yyvs6.put (yyval6, yyvsp6)
end
when 2 then
--|#line 82 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 82")
end

create {JS_FALSE_NODE} yyval6.make; assertion := yyval6 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp6 := yyvsp6 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp6 >= yyvsc6 then
		if yyvs6 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs6")
			end
			create yyspecial_routines6
			yyvsc6 := yyInitial_yyvs_size
			yyvs6 := yyspecial_routines6.make (yyvsc6)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs6")
			end
			yyvsc6 := yyvsc6 + yyInitial_yyvs_size
			yyvs6 := yyspecial_routines6.resize (yyvs6, yyvsc6)
		end
	end
	yyvs6.put (yyval6, yyvsp6)
end
when 3 then
--|#line 83 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 83")
end

create {JS_MAPSTO_NODE} yyval6.make (yyvs7.item (yyvsp7 - 1), yyvs13.item (yyvsp13), yyvs7.item (yyvsp7)); assertion := yyval6 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp6 := yyvsp6 + 1
	yyvsp7 := yyvsp7 -2
	yyvsp1 := yyvsp1 -2
	yyvsp13 := yyvsp13 -1
	if yyvsp6 >= yyvsc6 then
		if yyvs6 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs6")
			end
			create yyspecial_routines6
			yyvsc6 := yyInitial_yyvs_size
			yyvs6 := yyspecial_routines6.make (yyvsc6)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs6")
			end
			yyvsc6 := yyvsc6 + yyInitial_yyvs_size
			yyvs6 := yyspecial_routines6.resize (yyvs6, yyvsc6)
		end
	end
	yyvs6.put (yyval6, yyvsp6)
end
when 4 then
--|#line 84 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 84")
end

create {JS_PURE_PREDICATE_NODE} yyval6.make (yyvs2.item (yyvsp2), yyvs8.item (yyvsp8)); assertion := yyval6 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp6 := yyvsp6 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
	yyvsp8 := yyvsp8 -1
	if yyvsp6 >= yyvsc6 then
		if yyvs6 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs6")
			end
			create yyspecial_routines6
			yyvsc6 := yyInitial_yyvs_size
			yyvs6 := yyspecial_routines6.make (yyvsc6)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs6")
			end
			yyvsc6 := yyvsc6 + yyInitial_yyvs_size
			yyvs6 := yyspecial_routines6.resize (yyvs6, yyvsc6)
		end
	end
	yyvs6.put (yyval6, yyvsp6)
end
when 5 then
--|#line 85 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 85")
end

create {JS_SPATIAL_PRED_NODE} yyval6.make (yyvs2.item (yyvsp2), yyvs8.item (yyvsp8)); assertion := yyval6 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp6 := yyvsp6 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -2
	yyvsp8 := yyvsp8 -1
	if yyvsp6 >= yyvsc6 then
		if yyvs6 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs6")
			end
			create yyspecial_routines6
			yyvsc6 := yyInitial_yyvs_size
			yyvs6 := yyspecial_routines6.make (yyvsc6)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs6")
			end
			yyvsc6 := yyvsc6 + yyInitial_yyvs_size
			yyvs6 := yyspecial_routines6.resize (yyvs6, yyvsc6)
		end
	end
	yyvs6.put (yyval6, yyvsp6)
end
when 6 then
--|#line 86 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 86")
end

create {JS_STAR_NODE} yyval6.make (yyvs6.item (yyvsp6 - 1), yyvs6.item (yyvsp6)); assertion := yyval6 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp6 := yyvsp6 -1
	yyvsp1 := yyvsp1 -1
	yyvs6.put (yyval6, yyvsp6)
end
when 7 then
--|#line 87 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 87")
end

create {JS_OR_NODE} yyval6.make (yyvs6.item (yyvsp6 - 1), yyvs6.item (yyvsp6)); assertion := yyval6 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp6 := yyvsp6 -1
	yyvsp1 := yyvsp1 -1
	yyvs6.put (yyval6, yyvsp6)
end
when 8 then
--|#line 88 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 88")
end

create {JS_TYPE_JUDGEMENT_NODE} yyval6.make (yyvs7.item (yyvsp7), yyvs12.item (yyvsp12)); assertion := yyval6 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp6 := yyvsp6 + 1
	yyvsp7 := yyvsp7 -1
	yyvsp1 := yyvsp1 -1
	yyvsp12 := yyvsp12 -1
	if yyvsp6 >= yyvsc6 then
		if yyvs6 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs6")
			end
			create yyspecial_routines6
			yyvsc6 := yyInitial_yyvs_size
			yyvs6 := yyspecial_routines6.make (yyvsc6)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs6")
			end
			yyvsc6 := yyvsc6 + yyInitial_yyvs_size
			yyvs6 := yyspecial_routines6.resize (yyvs6, yyvsc6)
		end
	end
	yyvs6.put (yyval6, yyvsp6)
end
when 9 then
--|#line 89 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 89")
end

create {JS_BINOP_NODE} yyval6.make (yyvs7.item (yyvsp7 - 1), yyvs2.item (yyvsp2), yyvs7.item (yyvsp7)); assertion := yyval6 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp6 := yyvsp6 + 1
	yyvsp7 := yyvsp7 -2
	yyvsp2 := yyvsp2 -1
	if yyvsp6 >= yyvsc6 then
		if yyvs6 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs6")
			end
			create yyspecial_routines6
			yyvsc6 := yyInitial_yyvs_size
			yyvs6 := yyspecial_routines6.make (yyvsc6)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs6")
			end
			yyvsc6 := yyvsc6 + yyInitial_yyvs_size
			yyvs6 := yyspecial_routines6.resize (yyvs6, yyvsc6)
		end
	end
	yyvs6.put (yyval6, yyvsp6)
end
when 10 then
--|#line 90 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 90")
end

yyval6 := yyvs6.item (yyvsp6); assertion := yyval6 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs6.put (yyval6, yyvsp6)
end
when 11 then
--|#line 93 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 93")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 12 then
--|#line 94 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 94")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 13 then
--|#line 95 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 95")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 14 then
--|#line 96 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 96")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 15 then
--|#line 97 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 97")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 16 then
--|#line 98 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 98")
end

yyval2 := yyvs2.item (yyvsp2) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 17 then
--|#line 101 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 101")
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
when 18 then
--|#line 102 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 102")
end

yyval8 := yyvs8.item (yyvsp8) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs8.put (yyval8, yyvsp8)
end
when 19 then
--|#line 105 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 105")
end

create yyval8.make; yyval8.put_front (yyvs7.item (yyvsp7)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp8 := yyvsp8 + 1
	yyvsp7 := yyvsp7 -1
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
when 20 then
--|#line 106 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 106")
end

yyvs8.item (yyvsp8).put_front (yyvs7.item (yyvsp7)); yyval8 := yyvs8.item (yyvsp8) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp7 := yyvsp7 -1
	yyvsp1 := yyvsp1 -1
	yyvs8.put (yyval8, yyvsp8)
end
when 21 then
--|#line 109 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 109")
end

create {JS_VARIABLE_AS_ARG_NODE} yyval7.make (yyvs9.item (yyvsp9)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp7 := yyvsp7 + 1
	yyvsp9 := yyvsp9 -1
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
when 22 then
--|#line 110 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 110")
end

create {JS_FUNCTION_TERM_AS_ARG_NODE} yyval7.make (yyvs2.item (yyvsp2), yyvs8.item (yyvsp8)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp7 := yyvsp7 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -2
	yyvsp8 := yyvsp8 -1
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
when 23 then
--|#line 111 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 111")
end

create {JS_INTEGER_AS_ARG_NODE} yyval7.make (yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp7 := yyvsp7 + 1
	yyvsp2 := yyvsp2 -1
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
when 24 then
--|#line 113 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 113")
end

create {JS_FLD_EQ_LIST_AS_ARG_NODE} yyval7.make (yyvs11.item (yyvsp11)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp7 := yyvsp7 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp11 := yyvsp11 -1
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
when 25 then
--|#line 116 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 116")
end

create yyval9.make (yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 26 then
--|#line 117 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 117")
end

create yyval9.make ("?" + yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp9 := yyvsp9 + 1
	yyvsp1 := yyvsp1 -1
	yyvsp2 := yyvsp2 -1
	if yyvsp9 >= yyvsc9 then
		if yyvs9 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs9")
			end
			create yyspecial_routines9
			yyvsc9 := yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.make (yyvsc9)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs9")
			end
			yyvsc9 := yyvsc9 + yyInitial_yyvs_size
			yyvs9 := yyspecial_routines9.resize (yyvs9, yyvsc9)
		end
	end
	yyvs9.put (yyval9, yyvsp9)
end
when 27 then
--|#line 120 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 120")
end

create yyval11.make; yyval11.put_front (yyvs10.item (yyvsp10)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp11 := yyvsp11 + 1
	yyvsp10 := yyvsp10 -1
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
when 28 then
--|#line 121 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 121")
end

yyvs11.item (yyvsp11).put_front (yyvs10.item (yyvsp10)); yyval11 := yyvs11.item (yyvsp11) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp10 := yyvsp10 -1
	yyvsp1 := yyvsp1 -1
	yyvs11.put (yyval11, yyvsp11)
end
when 29 then
--|#line 124 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 124")
end

create yyval10.make (yyvs2.item (yyvsp2), yyvs7.item (yyvsp7)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp10 := yyvsp10 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -1
	yyvsp7 := yyvsp7 -1
	if yyvsp10 >= yyvsc10 then
		if yyvs10 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs10")
			end
			create yyspecial_routines10
			yyvsc10 := yyInitial_yyvs_size
			yyvs10 := yyspecial_routines10.make (yyvsc10)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs10")
			end
			yyvsc10 := yyvsc10 + yyInitial_yyvs_size
			yyvs10 := yyspecial_routines10.resize (yyvs10, yyvsc10)
		end
	end
	yyvs10.put (yyval10, yyvsp10)
end
when 30 then
--|#line 127 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 127")
end

create yyval12.make (yyvs2.item (yyvsp2)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp12 := yyvsp12 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -1
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
when 31 then
--|#line 130 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 130")
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
when 32 then
--|#line 131 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 131")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs1.put (yyval1, yyvsp1)
end
when 33 then
--|#line 134 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 134")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp12 := yyvsp12 -1
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
when 34 then
--|#line 135 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 135")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp12 := yyvsp12 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 35 then
--|#line 138 "parser.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'parser.y' at line 138")
end

create yyval13.make (yyvs2.item (yyvsp2 - 2), yyvs2.item (yyvsp2 - 1)) 
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp13 := yyvsp13 + 1
	yyvsp2 := yyvsp2 -4
	yyvsp1 := yyvsp1 -1
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
			when 68 then
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
			   25,   26,   27,   28, yyDummy>>)
		end

	yyr1_template: SPECIAL [INTEGER] is
			-- Template for `yyr1'
		once
			Result := yyfixed_array (<<
			    0,   29,   29,   29,   29,   29,   29,   29,   29,   29,
			   29,   30,   30,   30,   30,   30,   30,   31,   31,   32,
			   32,   33,   33,   33,   33,   34,   34,   35,   35,   36,
			   37,   39,   39,   40,   40,   38, yyDummy>>)
		end

	yytypes1_template: SPECIAL [INTEGER] is
			-- Template for `yytypes1'
		once
			Result := yyfixed_array (<<
			    6,    1,    1,    1,    1,    2,    2,    1,    1,    6,
			    7,    9,    2,    6,    2,   11,   10,    1,    2,    1,
			    1,    2,    1,    1,    2,    2,    2,    2,    2,    2,
			    1,    1,    1,    1,    2,    8,    8,    7,    1,    6,
			    6,    2,   13,    2,   12,    7,    7,   11,    1,    1,
			    1,    8,    2,    1,    1,    1,    8,    8,    1,    1,
			    7,   12,    1,    1,    2,    1,    1,    2,    1,    1,
			    1, yyDummy>>)
		end

	yytypes2_template: SPECIAL [INTEGER] is
			-- Template for `yytypes2'
		once
			Result := yyfixed_array (<<
			    1,    1,    1,    1,    2,    2,    2,    2,    2,    1,
			    1,    1,    2,    1,    1,    2,    2,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1, yyDummy>>)
		end

	yydefact_template: SPECIAL [INTEGER] is
			-- Template for `yydefact'
		once
			Result := yyfixed_array (<<
			    0,    1,    0,    0,    0,   23,   25,    2,    0,    0,
			    0,   21,   26,    0,    0,    0,   27,   17,    0,    0,
			    0,   16,    0,    0,   11,   12,   13,   14,   15,    0,
			   10,    0,   24,    0,   25,    0,   18,   19,   17,    7,
			    6,    0,    0,   31,    8,    9,   29,   28,   17,   22,
			    0,    0,    0,    0,    0,   30,    0,   20,    4,    0,
			    3,   33,    0,   22,    0,    0,   32,   35,   34,    0,
			    0, yyDummy>>)
		end

	yydefgoto_template: SPECIAL [INTEGER] is
			-- Template for `yydefgoto'
		once
			Result := yyfixed_array (<<
			    9,   29,   35,   36,   10,   11,   15,   16,   61,   42,
			   55,   62, yyDummy>>)
		end

	yypact_template: SPECIAL [INTEGER] is
			-- Template for `yypact'
		once
			Result := yyfixed_array (<<
			   23, -32768,   51,   23,   32, -32768,   46, -32768,   49,    3,
			   48, -32768, -32768,  -15,   54,   37,   35,   -7,   39,   23,
			   23, -32768,   45,   -2, -32768, -32768, -32768, -32768, -32768,   -7,
			 -32768,   -7, -32768,   32,   30,   22, -32768,   34,   -7,   24,
			 -32768,   28,   21,   17, -32768, -32768, -32768, -32768,   -7,    1,
			   -7,    8,   19,   -7,   -2, -32768,    6, -32768, -32768,   14,
			 -32768,   18,   -5, -32768,   10,   -2, -32768, -32768, -32768,    4,
			 -32768, yyDummy>>)
		end

	yypgoto_template: SPECIAL [INTEGER] is
			-- Template for `yypgoto'
		once
			Result := yyfixed_array (<<
			   -1, -32768,  -33,   25,  -17, -32768,   36, -32768,   47, -32768,
			 -32768,    2, yyDummy>>)
		end

	yytable_template: SPECIAL [INTEGER] is
			-- Template for `yytable'
		once
			Result := yyfixed_array (<<
			   37,   -5,   13,   69,   70,   51,   20,   19,   34,    5,
			    4,   30,   45,   43,   46,   56,    2,   67,   39,   40,
			   66,   37,   -5,   -5,   20,   19,    8,   -5,   65,   64,
			   59,   37,   63,   37,   58,   54,   60,    7,    6,    5,
			    4,   53,    3,   52,   50,   20,    2,   14,   49,   48,
			   41,    1,   28,   27,   26,   25,   24,   23,   38,   22,
			   21,   32,   33,   31,   18,   17,   12,   68,    0,   47,
			   44,    0,    0,    0,    0,   57, yyDummy>>)
		end

	yycheck_template: SPECIAL [INTEGER] is
			-- Template for `yycheck'
		once
			Result := yyfixed_array (<<
			   17,    0,    3,    0,    0,   38,   21,   22,   15,   16,
			   17,   26,   29,   15,   31,   48,   23,    7,   19,   20,
			   25,   38,   21,   22,   21,   22,    3,   26,   10,   15,
			   11,   48,   26,   50,   26,   18,   53,   14,   15,   16,
			   17,   20,   19,   15,   10,   21,   23,   15,   26,   19,
			    5,   28,    4,    5,    6,    7,    8,    9,   19,   11,
			   12,   24,   27,    9,   15,   19,   15,   65,   -1,   33,
			   23,   -1,   -1,   -1,   -1,   50, yyDummy>>)
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

	yyvs6: SPECIAL [JS_ASSERTION_NODE]
			-- Stack for semantic values of type JS_ASSERTION_NODE

	yyvsc6: INTEGER
			-- Capacity of semantic value stack `yyvs6'

	yyvsp6: INTEGER
			-- Top of semantic value stack `yyvs6'

	yyspecial_routines6: KL_SPECIAL_ROUTINES [JS_ASSERTION_NODE]
			-- Routines that ought to be in SPECIAL [JS_ASSERTION_NODE]

	yyvs7: SPECIAL [JS_ARGUMENT_NODE]
			-- Stack for semantic values of type JS_ARGUMENT_NODE

	yyvsc7: INTEGER
			-- Capacity of semantic value stack `yyvs7'

	yyvsp7: INTEGER
			-- Top of semantic value stack `yyvs7'

	yyspecial_routines7: KL_SPECIAL_ROUTINES [JS_ARGUMENT_NODE]
			-- Routines that ought to be in SPECIAL [JS_ARGUMENT_NODE]

	yyvs8: SPECIAL [LINKED_LIST [JS_ARGUMENT_NODE]]
			-- Stack for semantic values of type LINKED_LIST [JS_ARGUMENT_NODE]

	yyvsc8: INTEGER
			-- Capacity of semantic value stack `yyvs8'

	yyvsp8: INTEGER
			-- Top of semantic value stack `yyvs8'

	yyspecial_routines8: KL_SPECIAL_ROUTINES [LINKED_LIST [JS_ARGUMENT_NODE]]
			-- Routines that ought to be in SPECIAL [LINKED_LIST [JS_ARGUMENT_NODE]]

	yyvs9: SPECIAL [JS_VARIABLE_NODE]
			-- Stack for semantic values of type JS_VARIABLE_NODE

	yyvsc9: INTEGER
			-- Capacity of semantic value stack `yyvs9'

	yyvsp9: INTEGER
			-- Top of semantic value stack `yyvs9'

	yyspecial_routines9: KL_SPECIAL_ROUTINES [JS_VARIABLE_NODE]
			-- Routines that ought to be in SPECIAL [JS_VARIABLE_NODE]

	yyvs10: SPECIAL [JS_FLD_EQUALITY_NODE]
			-- Stack for semantic values of type JS_FLD_EQUALITY_NODE

	yyvsc10: INTEGER
			-- Capacity of semantic value stack `yyvs10'

	yyvsp10: INTEGER
			-- Top of semantic value stack `yyvs10'

	yyspecial_routines10: KL_SPECIAL_ROUTINES [JS_FLD_EQUALITY_NODE]
			-- Routines that ought to be in SPECIAL [JS_FLD_EQUALITY_NODE]

	yyvs11: SPECIAL [LINKED_LIST [JS_FLD_EQUALITY_NODE]]
			-- Stack for semantic values of type LINKED_LIST [JS_FLD_EQUALITY_NODE]

	yyvsc11: INTEGER
			-- Capacity of semantic value stack `yyvs11'

	yyvsp11: INTEGER
			-- Top of semantic value stack `yyvs11'

	yyspecial_routines11: KL_SPECIAL_ROUTINES [LINKED_LIST [JS_FLD_EQUALITY_NODE]]
			-- Routines that ought to be in SPECIAL [LINKED_LIST [JS_FLD_EQUALITY_NODE]]

	yyvs12: SPECIAL [JS_TYPE_NODE]
			-- Stack for semantic values of type JS_TYPE_NODE

	yyvsc12: INTEGER
			-- Capacity of semantic value stack `yyvs12'

	yyvsp12: INTEGER
			-- Top of semantic value stack `yyvs12'

	yyspecial_routines12: KL_SPECIAL_ROUTINES [JS_TYPE_NODE]
			-- Routines that ought to be in SPECIAL [JS_TYPE_NODE]

	yyvs13: SPECIAL [JS_FIELD_SIG_NODE]
			-- Stack for semantic values of type JS_FIELD_SIG_NODE

	yyvsc13: INTEGER
			-- Capacity of semantic value stack `yyvs13'

	yyvsp13: INTEGER
			-- Top of semantic value stack `yyvs13'

	yyspecial_routines13: KL_SPECIAL_ROUTINES [JS_FIELD_SIG_NODE]
			-- Routines that ought to be in SPECIAL [JS_FIELD_SIG_NODE]

feature {NONE} -- Constants

	yyFinal: INTEGER is 70
			-- Termination state id

	yyFlag: INTEGER is -32768
			-- Most negative INTEGER

	yyNtbase: INTEGER is 29
			-- Number of tokens

	yyLast: INTEGER is 75
			-- Upper bound of `yytable' and `yycheck'

	yyMax_token: INTEGER is 283
			-- Maximum token id
			-- (upper bound of `yytranslate'.)

	yyNsyms: INTEGER is 41
			-- Number of symbols
			-- (terminal and nonterminal)

feature -- User-defined features


-- User code

    make
        do
            make_scanner
            make_parser_skeleton
        end
    
        -- Only one of the following two attributes will be valid!!!
    assertion: JS_ASSERTION_NODE
    predicate_definition: JS_PRED_DEF_NODE
    
end
