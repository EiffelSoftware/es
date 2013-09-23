note
	component:   "openEHR Archetype Project"
	description: "Validating parser for Archetype Description Language (ADL)"
	keywords:    "ADL, dADL"
	
	author:      "Thomas Beale"
	support:     "Ocean Informatics <support@OceanInformatics.com>"
	copyright:   "Copyright (c) 2004-2009 Ocean Informatics Pty Ltd"
	license:     "See notice at bottom of class"

	file:        "$URL: https://svn.origo.ethz.ch/abel/trunk/libraries/openehr/src/dadl_syntax/parser/dadl_validator.e $"
	revision:    "$LastChangedRevision$"
	last_change: "$LastChangedDate$"

class DADL_VALIDATOR

inherit
	YY_PARSER_SKELETON
		rename
			make as make_parser_skeleton
		redefine
			report_error
		end

	DADL_DEFINITIONS
		export
			{NONE} all
		end

	DATE_TIME_ROUTINES
		export
			{NONE} all
		end

	SHARED_MESSAGE_DB
		export
			{NONE} all
		end

	DADL_SCANNER
		rename
			make as make_scanner
		end

	KL_SHARED_EXCEPTIONS
	KL_SHARED_ARGUMENTS

create
	make


feature {NONE} -- Implementation

	yy_build_parser_tables
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

	yy_create_value_stacks
			-- Create value stacks.
		do
		end

	yy_init_value_stacks
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
			yyvsp19 := -1
			yyvsp20 := -1
			yyvsp21 := -1
			yyvsp22 := -1
			yyvsp23 := -1
			yyvsp24 := -1
			yyvsp25 := -1
			yyvsp26 := -1
			yyvsp27 := -1
			yyvsp28 := -1
			yyvsp29 := -1
			yyvsp30 := -1
			yyvsp31 := -1
			yyvsp32 := -1
			yyvsp33 := -1
			yyvsp34 := -1
		end

	yy_clear_value_stacks
			-- Clear objects in semantic value stacks so that
			-- they can be collected by the garbage collector.
		local
			l_yyvs1_default_item: ANY
			l_yyvs2_default_item: INTEGER
			l_yyvs3_default_item: REAL
			l_yyvs4_default_item: STRING
			l_yyvs5_default_item: CHARACTER
			l_yyvs6_default_item: NUMERIC
			l_yyvs7_default_item: BOOLEAN
			l_yyvs8_default_item: ISO8601_DATE
			l_yyvs9_default_item: ISO8601_DATE_TIME
			l_yyvs10_default_item: ISO8601_TIME
			l_yyvs11_default_item: ISO8601_DURATION
			l_yyvs12_default_item: DT_COMPLEX_OBJECT_NODE
			l_yyvs13_default_item: DT_OBJECT_LEAF
			l_yyvs14_default_item: OG_PATH
			l_yyvs15_default_item: OG_PATH_ITEM
			l_yyvs16_default_item: ARRAYED_LIST [OG_PATH]
			l_yyvs17_default_item: ARRAYED_LIST [STRING]
			l_yyvs18_default_item: ARRAYED_LIST [INTEGER]
			l_yyvs19_default_item: ARRAYED_LIST [REAL]
			l_yyvs20_default_item: ARRAYED_LIST [CHARACTER]
			l_yyvs21_default_item: ARRAYED_LIST [BOOLEAN]
			l_yyvs22_default_item: ARRAYED_LIST [ISO8601_DATE]
			l_yyvs23_default_item: ARRAYED_LIST [ISO8601_TIME]
			l_yyvs24_default_item: ARRAYED_LIST [ISO8601_DATE_TIME]
			l_yyvs25_default_item: ARRAYED_LIST [ISO8601_DURATION]
			l_yyvs26_default_item: ARRAYED_LIST [ANY]
			l_yyvs27_default_item: INTERVAL [INTEGER]
			l_yyvs28_default_item: INTERVAL [REAL]
			l_yyvs29_default_item: INTERVAL [ISO8601_TIME]
			l_yyvs30_default_item: INTERVAL [ISO8601_DATE]
			l_yyvs31_default_item: INTERVAL [ISO8601_DATE_TIME]
			l_yyvs32_default_item: INTERVAL [ISO8601_DURATION]
			l_yyvs33_default_item: PART_COMPARABLE
			l_yyvs34_default_item: INTERVAL [PART_COMPARABLE]
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
			if yyvs19 /= Void then
				yyvs19.fill_with (l_yyvs19_default_item, 0, yyvs19.upper)
			end
			if yyvs20 /= Void then
				yyvs20.fill_with (l_yyvs20_default_item, 0, yyvs20.upper)
			end
			if yyvs21 /= Void then
				yyvs21.fill_with (l_yyvs21_default_item, 0, yyvs21.upper)
			end
			if yyvs22 /= Void then
				yyvs22.fill_with (l_yyvs22_default_item, 0, yyvs22.upper)
			end
			if yyvs23 /= Void then
				yyvs23.fill_with (l_yyvs23_default_item, 0, yyvs23.upper)
			end
			if yyvs24 /= Void then
				yyvs24.fill_with (l_yyvs24_default_item, 0, yyvs24.upper)
			end
			if yyvs25 /= Void then
				yyvs25.fill_with (l_yyvs25_default_item, 0, yyvs25.upper)
			end
			if yyvs26 /= Void then
				yyvs26.fill_with (l_yyvs26_default_item, 0, yyvs26.upper)
			end
			if yyvs27 /= Void then
				yyvs27.fill_with (l_yyvs27_default_item, 0, yyvs27.upper)
			end
			if yyvs28 /= Void then
				yyvs28.fill_with (l_yyvs28_default_item, 0, yyvs28.upper)
			end
			if yyvs29 /= Void then
				yyvs29.fill_with (l_yyvs29_default_item, 0, yyvs29.upper)
			end
			if yyvs30 /= Void then
				yyvs30.fill_with (l_yyvs30_default_item, 0, yyvs30.upper)
			end
			if yyvs31 /= Void then
				yyvs31.fill_with (l_yyvs31_default_item, 0, yyvs31.upper)
			end
			if yyvs32 /= Void then
				yyvs32.fill_with (l_yyvs32_default_item, 0, yyvs32.upper)
			end
			if yyvs33 /= Void then
				yyvs33.fill_with (l_yyvs33_default_item, 0, yyvs33.upper)
			end
			if yyvs34 /= Void then
				yyvs34.fill_with (l_yyvs34_default_item, 0, yyvs34.upper)
			end
		end

	yy_push_last_value (yychar1: INTEGER)
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
				yyvs2.put (last_integer_value, yyvsp2)
			when 3 then
				yyvsp3 := yyvsp3 + 1
				if yyvsp3 >= yyvsc3 then
					if yyvs3 = Void then
						debug ("GEYACC")
							std.error.put_line ("Create yyvs3")
						end
						create yyspecial_routines3
						yyvsc3 := yyInitial_yyvs_size
						yyvs3 := yyspecial_routines3.make (yyvsc3)
					else
						debug ("GEYACC")
							std.error.put_line ("Resize yyvs3")
						end
						yyvsc3 := yyvsc3 + yyInitial_yyvs_size
						yyvs3 := yyspecial_routines3.resize (yyvs3, yyvsc3)
					end
				end
				yyvs3.put (last_real_value, yyvsp3)
			when 4 then
				yyvsp4 := yyvsp4 + 1
				if yyvsp4 >= yyvsc4 then
					if yyvs4 = Void then
						debug ("GEYACC")
							std.error.put_line ("Create yyvs4")
						end
						create yyspecial_routines4
						yyvsc4 := yyInitial_yyvs_size
						yyvs4 := yyspecial_routines4.make (yyvsc4)
					else
						debug ("GEYACC")
							std.error.put_line ("Resize yyvs4")
						end
						yyvsc4 := yyvsc4 + yyInitial_yyvs_size
						yyvs4 := yyspecial_routines4.resize (yyvs4, yyvsc4)
					end
				end
				yyvs4.put (last_string_value, yyvsp4)
			when 5 then
				yyvsp5 := yyvsp5 + 1
				if yyvsp5 >= yyvsc5 then
					if yyvs5 = Void then
						debug ("GEYACC")
							std.error.put_line ("Create yyvs5")
						end
						create yyspecial_routines5
						yyvsc5 := yyInitial_yyvs_size
						yyvs5 := yyspecial_routines5.make (yyvsc5)
					else
						debug ("GEYACC")
							std.error.put_line ("Resize yyvs5")
						end
						yyvsc5 := yyvsc5 + yyInitial_yyvs_size
						yyvs5 := yyspecial_routines5.resize (yyvs5, yyvsc5)
					end
				end
				yyvs5.put (last_character_value, yyvsp5)
			else
				debug ("GEYACC")
					std.error.put_string ("Error in parser: not a token type: ")
					std.error.put_integer (yytypes2.item (yychar1))
					std.error.put_new_line
				end
				abort
			end
		end

	yy_push_error_value
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

	yy_pop_last_value (yystate: INTEGER)
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
			when 19 then
				yyvsp19 := yyvsp19 - 1
			when 20 then
				yyvsp20 := yyvsp20 - 1
			when 21 then
				yyvsp21 := yyvsp21 - 1
			when 22 then
				yyvsp22 := yyvsp22 - 1
			when 23 then
				yyvsp23 := yyvsp23 - 1
			when 24 then
				yyvsp24 := yyvsp24 - 1
			when 25 then
				yyvsp25 := yyvsp25 - 1
			when 26 then
				yyvsp26 := yyvsp26 - 1
			when 27 then
				yyvsp27 := yyvsp27 - 1
			when 28 then
				yyvsp28 := yyvsp28 - 1
			when 29 then
				yyvsp29 := yyvsp29 - 1
			when 30 then
				yyvsp30 := yyvsp30 - 1
			when 31 then
				yyvsp31 := yyvsp31 - 1
			when 32 then
				yyvsp32 := yyvsp32 - 1
			when 33 then
				yyvsp33 := yyvsp33 - 1
			when 34 then
				yyvsp34 := yyvsp34 - 1
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

	yy_do_action (yy_act: INTEGER)
			-- Execute semantic action.
		local
			yyval1: ANY
			yyval12: DT_COMPLEX_OBJECT_NODE
			yyval13: DT_OBJECT_LEAF
			yyval26: ARRAYED_LIST [ANY]
			yyval34: INTERVAL [PART_COMPARABLE]
			yyval4: STRING
			yyval17: ARRAYED_LIST [STRING]
			yyval2: INTEGER
			yyval18: ARRAYED_LIST [INTEGER]
			yyval27: INTERVAL [INTEGER]
			yyval3: REAL
			yyval19: ARRAYED_LIST [REAL]
			yyval28: INTERVAL [REAL]
			yyval7: BOOLEAN
			yyval21: ARRAYED_LIST [BOOLEAN]
			yyval5: CHARACTER
			yyval20: ARRAYED_LIST [CHARACTER]
			yyval8: ISO8601_DATE
			yyval22: ARRAYED_LIST [ISO8601_DATE]
			yyval30: INTERVAL [ISO8601_DATE]
			yyval10: ISO8601_TIME
			yyval23: ARRAYED_LIST [ISO8601_TIME]
			yyval29: INTERVAL [ISO8601_TIME]
			yyval9: ISO8601_DATE_TIME
			yyval24: ARRAYED_LIST [ISO8601_DATE_TIME]
			yyval31: INTERVAL [ISO8601_DATE_TIME]
			yyval11: ISO8601_DURATION
			yyval25: ARRAYED_LIST [ISO8601_DURATION]
			yyval32: INTERVAL [ISO8601_DURATION]
			yyval16: ARRAYED_LIST [OG_PATH]
			yyval14: OG_PATH
			yyval15: OG_PATH_ITEM
		do
			inspect yy_act
when 1 then
--|#line 114 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 114")
end

			output := complex_object_nodes.item
debug("dADL_parse")
	io.put_string("Object data definition validated (non-delimited)%N")
end
			accept
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 2 then
--|#line 122 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 122")
end

			output := yyvs12.item (yyvsp12)
debug("dADL_parse")
	io.put_string("Object data definition validated%N")
end
			accept
		
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
when 3 then
--|#line 130 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 130")
end

debug("dADL_parse")
	io.put_string("dADL text NOT validated%N")
end
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 4 then
--|#line 142 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 142")
end

debug("dADL_parse")
	io.put_string(indent + "attr_val complete%N")
end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 5 then
--|#line 148 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 148")
end

debug("dADL_parse")
	io.put_string(indent + "attr_val complete%N")
end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 6 then
--|#line 154 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 154")
end

debug("dADL_parse")
	io.put_string(indent + "attr_val complete%N")
end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs1.put (yyval1, yyvsp1)
end
when 7 then
--|#line 163 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 163")
end

debug("dADL_parse")
	io.put_string(indent + "attr_val: POP attr node (" +  attr_nodes.item.rm_attr_name+ ")%N")
	indent.remove_tail(1)
end
			attr_nodes.remove
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs1.put (yyval1, yyvsp1)
end
when 8 then
--|#line 173 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 173")
end

			-- create first anonymous object
			if complex_object_nodes.is_empty then
debug("dADL_parse")
	io.put_string(indent + "attr_id: create complex_object_node.make_anonymous%N")
	io.put_string(indent + "attr_id: PUSH Object node%N")
	indent.append("%T")
end
				create complex_object_node.make_anonymous
				complex_object_nodes.extend(complex_object_node)
			end

debug("dADL_parse")
	io.put_string(indent + "attr_id: create_attr_node.make_single(<<" + yyvs4.item (yyvsp4) + ">>)%N")
end
			create attr_node.make_single(yyvs4.item (yyvsp4))

debug("dADL_parse")
	io.put_string(indent + "attr_id: complex_object_nodes.item(" + complex_object_nodes.item.node_id + 
			").put_attribute(<<" + attr_node.rm_attr_name + ">>)%N")
end
			if not complex_object_nodes.item.has_attribute(attr_node.rm_attr_name) then
				complex_object_nodes.item.put_attribute(attr_node)
			else
				abort_with_error("VDATU", <<attr_node.rm_attr_name>>)
			end

debug("dADL_parse")
	io.put_string(indent + "attr_id: PUSH attr node%N")
	indent.append("%T")
end
			attr_nodes.extend(attr_node)
			obj_id := Void
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp4 := yyvsp4 -1
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
when 9 then
--|#line 208 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 208")
end

			abort_with_error("SDAT", Void)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp4 := yyvsp4 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 10 then
--|#line 217 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 217")
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
when 11 then
--|#line 218 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 218")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp13 := yyvsp13 -1
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
when 12 then
--|#line 219 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 219")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp13 := yyvsp13 -1
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
when 13 then
--|#line 222 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 222")
end

			yyval12 := yyvs12.item (yyvsp12)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs12.put (yyval12, yyvsp12)
end
when 14 then
--|#line 226 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 226")
end

			yyval12 := yyvs12.item (yyvsp12)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs12.put (yyval12, yyvsp12)
end
when 15 then
--|#line 235 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 235")
end

			yyval12 := yyvs12.item (yyvsp12)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs12.put (yyval12, yyvsp12)
end
when 16 then
--|#line 239 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 239")
end

			-- probably should set type name on owning attribute - it doesn't belong on each 
			-- object, since it is essentially a constraint
			yyval12 := yyvs12.item (yyvsp12)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp4 := yyvsp4 -1
	yyvs12.put (yyval12, yyvsp12)
end
when 17 then
--|#line 255 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 255")
end

			if complex_object_nodes.item.is_addressable and attr_nodes.item.is_generic then
				-- pop the generic attr node
debug("dADL_parse")
	io.put_string(indent + "multiple_attr_object_block: POP attr node (" +  
		attr_nodes.item.rm_attr_name+ ")%N")
	indent.remove_tail(1)
end
				attr_nodes.remove

debug("dADL_parse")
	io.put_string(indent + "multiple_attr_object_block: POP Object node(" + 
		complex_object_nodes.item.node_id + ")%N")
	indent.remove_tail(1)
end
				yyval12 := complex_object_nodes.item
				complex_object_nodes.remove
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp12 := yyvsp12 + 1
	yyvsp1 := yyvsp1 -3
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
when 18 then
--|#line 277 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 277")
end

			if obj_id /= Void then
				-- we are in a multi-block which is the value of a keyed object
				-- so create the object with the key id
				create complex_object_node.make_identified(obj_id)
				if not attr_nodes.item.has_child_with_id(complex_object_node.node_id) then
debug("dADL_parse")
	io.put_string(indent + "multiple_attr_object_block_head; attr_nodes(<<" + 
		attr_nodes.item.rm_attr_name + ">>).item.put_child(complex_object_node(" + 
		complex_object_node.node_id + "))%N")
end
					attr_nodes.item.put_child(complex_object_node)
				else
					abort_with_error("VOKU", <<complex_object_node.node_id, attr_nodes.item.rm_attr_name >>)
				end

debug("dADL_parse")
	io.put_string(indent + "multiple_attr_object_block_head: PUSH Obj node%N")
	indent.append("%T")
end
				complex_object_nodes.extend(complex_object_node)

				-- now create a generic attribute node to stand for the hidden attribute of the 
				-- generic object, e.g. it might be List<T>.items or whatever
debug("dADL_parse")
	io.put_string(indent + "multiple_attr_object_block_head: create_attr_node.make_multiple_generic%N")
end
				create attr_node.make_multiple_generic

debug("dADL_parse")
	io.put_string(indent + "multiple_attr_object_block_head: complex_object_node(" + 
			complex_object_node.node_id + ").put_attribute(" + attr_node.rm_attr_name + ")%N")
end
				if not complex_object_node.has_attribute(attr_node.rm_attr_name) then
					complex_object_node.put_attribute(attr_node)
				else
					abort_with_error("VDATU", <<attr_node.rm_attr_name>>)
				end

debug("dADL_parse")
	io.put_string(indent + "multiple_attr_object_block_head: PUSH attr node%N")
	indent.append("%T")
end
				attr_nodes.extend(attr_node)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 19 then
--|#line 326 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 326")
end

debug("dADL_parse")
	io.put_string(indent + "one keyed object%N")
end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 20 then
--|#line 332 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 332")
end

debug("dADL_parse")
	io.put_string(indent + "multiple keyed objects%N")
end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 21 then
--|#line 340 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 340")
end

debug("dADL_parse")
	io.put_string(indent + "(keyed object)%N")
end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs1.put (yyval1, yyvsp1)
end
when 22 then
--|#line 348 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 348")
end

			obj_id := yyvs1.item (yyvsp1 - 1).out

debug("dADL_parse")
	io.put_string(indent + "object_key: " + obj_id + 
		" (setting " + attr_nodes.item.rm_attr_name + " to Multiple)%N")
end
			if not attr_nodes.is_empty then
				attr_nodes.item.set_multiple
			else
				abort_with_error("SGEE", <<attr_node.rm_attr_name>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs1.put (yyval1, yyvsp1)
end
when 23 then
--|#line 368 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 368")
end

debug("dADL_parse")
	io.put_string(indent + "untyped single_attr_object_block%N")
end
			yyval12 := yyvs12.item (yyvsp12)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs12.put (yyval12, yyvsp12)
end
when 24 then
--|#line 375 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 375")
end

debug("dADL_parse")
	io.put_string(indent + "typed single_attr_object_block; type = " + yyvs4.item (yyvsp4) + "%N")
end
			yyvs12.item (yyvsp12).set_type_name(yyvs4.item (yyvsp4))
			yyval12 := yyvs12.item (yyvsp12)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp4 := yyvsp4 -1
	yyvs12.put (yyval12, yyvsp12)
end
when 25 then
--|#line 393 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 393")
end

debug("dADL_parse")
	io.put_string(indent + "empty_object_complex_body: POP Object node(" + 
		complex_object_nodes.item.node_id + ")%N")
	indent.remove_tail(1)
end
			yyval12 := complex_object_nodes.item
			complex_object_nodes.remove
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp12 := yyvsp12 + 1
	yyvsp1 := yyvsp1 -2
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
when 26 then
--|#line 403 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 403")
end

debug("dADL_parse")
	io.put_string(indent + "single_attr_object_complex_body: POP Object node(" + 
		complex_object_nodes.item.node_id + ")%N")
	indent.remove_tail(1)
end
			yyval12 := complex_object_nodes.item
			complex_object_nodes.remove
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp12 := yyvsp12 + 1
	yyvsp1 := yyvsp1 -3
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
--|#line 415 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 415")
end

			-- if parent attr is not multiple, create an anon object; else an object identified by a key
			if attr_nodes.is_empty or else not attr_nodes.item.is_multiple then
debug("dADL_parse")
	io.put_string(indent + "single_attr_object_complex_head: create complex_object_node.make_anonymous%N")
end
				create complex_object_node.make_anonymous
			else
debug("dADL_parse")
	io.put_string(indent + "single_attr_object_complex_head: create complex_object_node.make (" + obj_id + ")%N")
end
				create complex_object_node.make_identified(obj_id)
				obj_id := Void
			end

			-- now put the new object under its attribute, if one exists
			if not attr_nodes.is_empty then
				if not attr_nodes.item.has_child_with_id(complex_object_node.node_id) then
debug("dADL_parse")
	io.put_string(indent + "single_attr_object_complex_head: attr_nodes(<<" + 
		attr_nodes.item.rm_attr_name + ">>).item.put_child(complex_object_node(" + 
		complex_object_node.node_id + "))%N")
end
					attr_nodes.item.put_child(complex_object_node)
				else
					abort_with_error("VOKU", <<complex_object_node.node_id, attr_nodes.item.rm_attr_name >>)
				end
			end

			-- finally, put the new object on the object stack
debug("dADL_parse")
	io.put_string(indent + "single_attr_object_complex_head: PUSH Obj node%N")
	indent.append("%T")
end
			complex_object_nodes.extend(complex_object_node)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 28 then
--|#line 457 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 457")
end

debug("dADL_parse")
	io.put_string(indent + "untyped primitive_object_block%N")
end
			yyval13 := yyvs13.item (yyvsp13)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs13.put (yyval13, yyvsp13)
end
when 29 then
--|#line 464 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 464")
end

debug("dADL_parse")
	io.put_string(indent + "typed primitive_object_block; type = " + yyvs4.item (yyvsp4) + "%N")
end
			yyvs13.item (yyvsp13).set_type_name(yyvs4.item (yyvsp4))
			yyval13 := yyvs13.item (yyvsp13)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp4 := yyvsp4 -1
	yyvs13.put (yyval13, yyvsp13)
end
when 30 then
--|#line 478 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 478")
end

debug("dADL_parse")
	io.put_string(indent + "untyped_primitive_object_block; attr_nodes(<<" + 
		attr_nodes.item.rm_attr_name + ">>).item.put_child(<<" + 
		yyvs13.item (yyvsp13).as_string + ">>)%N")
end
			if not attr_nodes.item.has_child_with_id(yyvs13.item (yyvsp13).node_id) then
				attr_nodes.item.put_child(yyvs13.item (yyvsp13))
				yyval13 := yyvs13.item (yyvsp13)
			else
				abort_with_error("VOKU", <<yyvs13.item (yyvsp13).node_id, attr_nodes.item.rm_attr_name >>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs13.put (yyval13, yyvsp13)
end
when 31 then
--|#line 494 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 494")
end

			if obj_id /= Void then
				create {DT_PRIMITIVE_OBJECT} yyval13.make_identified(yyvs1.item (yyvsp1), obj_id)
				obj_id := Void
			else
				create {DT_PRIMITIVE_OBJECT} yyval13.make_anonymous(yyvs1.item (yyvsp1))
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp13 := yyvsp13 + 1
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
when 32 then
--|#line 503 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 503")
end

			if obj_id /= Void then
				create {DT_PRIMITIVE_OBJECT_LIST} yyval13.make_identified(yyvs26.item (yyvsp26), obj_id)
				obj_id := Void
			else
				create {DT_PRIMITIVE_OBJECT_LIST} yyval13.make_anonymous(yyvs26.item (yyvsp26))
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp13 := yyvsp13 + 1
	yyvsp26 := yyvsp26 -1
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
when 33 then
--|#line 512 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 512")
end

			if obj_id /= Void then
				create {DT_PRIMITIVE_OBJECT_INTERVAL} yyval13.make_identified(yyvs34.item (yyvsp34), obj_id)
				obj_id := Void
			else
				create {DT_PRIMITIVE_OBJECT_INTERVAL} yyval13.make_anonymous(yyvs34.item (yyvsp34))
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp13 := yyvsp13 + 1
	yyvsp34 := yyvsp34 -1
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
when 34 then
--|#line 523 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 523")
end

			yyval1 := yyvs1.item (yyvsp1)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 35 then
--|#line 527 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 527")
end

			yyval1 := yyvs2.item (yyvsp2)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp2 := yyvsp2 -1
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
when 36 then
--|#line 531 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 531")
end

			yyval1 := yyvs3.item (yyvsp3)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp3 := yyvsp3 -1
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
--|#line 535 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 535")
end

			yyval1 := yyvs7.item (yyvsp7)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp7 := yyvsp7 -1
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
when 38 then
--|#line 539 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 539")
end

			yyval1 := yyvs5.item (yyvsp5)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp5 := yyvsp5 -1
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
--|#line 543 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 543")
end

			yyval1 := yyvs8.item (yyvsp8)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp8 := yyvsp8 -1
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
when 40 then
--|#line 547 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 547")
end

			yyval1 := yyvs10.item (yyvsp10)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp10 := yyvsp10 -1
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
when 41 then
--|#line 551 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 551")
end

			yyval1 := yyvs9.item (yyvsp9)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp9 := yyvsp9 -1
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
when 42 then
--|#line 555 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 555")
end

			yyval1 := yyvs11.item (yyvsp11)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp11 := yyvsp11 -1
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
when 43 then
--|#line 561 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 561")
end

			yyval26 := yyvs17.item (yyvsp17)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp26 := yyvsp26 + 1
	yyvsp17 := yyvsp17 -1
	if yyvsp26 >= yyvsc26 then
		if yyvs26 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs26")
			end
			create yyspecial_routines26
			yyvsc26 := yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.make (yyvsc26)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs26")
			end
			yyvsc26 := yyvsc26 + yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.resize (yyvs26, yyvsc26)
		end
	end
	yyvs26.put (yyval26, yyvsp26)
end
when 44 then
--|#line 565 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 565")
end

			yyval26 := yyvs18.item (yyvsp18)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp26 := yyvsp26 + 1
	yyvsp18 := yyvsp18 -1
	if yyvsp26 >= yyvsc26 then
		if yyvs26 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs26")
			end
			create yyspecial_routines26
			yyvsc26 := yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.make (yyvsc26)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs26")
			end
			yyvsc26 := yyvsc26 + yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.resize (yyvs26, yyvsc26)
		end
	end
	yyvs26.put (yyval26, yyvsp26)
end
when 45 then
--|#line 569 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 569")
end

			yyval26 := yyvs19.item (yyvsp19)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp26 := yyvsp26 + 1
	yyvsp19 := yyvsp19 -1
	if yyvsp26 >= yyvsc26 then
		if yyvs26 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs26")
			end
			create yyspecial_routines26
			yyvsc26 := yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.make (yyvsc26)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs26")
			end
			yyvsc26 := yyvsc26 + yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.resize (yyvs26, yyvsc26)
		end
	end
	yyvs26.put (yyval26, yyvsp26)
end
when 46 then
--|#line 573 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 573")
end

			yyval26 := yyvs21.item (yyvsp21)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp26 := yyvsp26 + 1
	yyvsp21 := yyvsp21 -1
	if yyvsp26 >= yyvsc26 then
		if yyvs26 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs26")
			end
			create yyspecial_routines26
			yyvsc26 := yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.make (yyvsc26)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs26")
			end
			yyvsc26 := yyvsc26 + yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.resize (yyvs26, yyvsc26)
		end
	end
	yyvs26.put (yyval26, yyvsp26)
end
when 47 then
--|#line 577 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 577")
end

			yyval26 := yyvs20.item (yyvsp20)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp26 := yyvsp26 + 1
	yyvsp20 := yyvsp20 -1
	if yyvsp26 >= yyvsc26 then
		if yyvs26 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs26")
			end
			create yyspecial_routines26
			yyvsc26 := yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.make (yyvsc26)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs26")
			end
			yyvsc26 := yyvsc26 + yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.resize (yyvs26, yyvsc26)
		end
	end
	yyvs26.put (yyval26, yyvsp26)
end
when 48 then
--|#line 581 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 581")
end

			yyval26 := yyvs22.item (yyvsp22)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp26 := yyvsp26 + 1
	yyvsp22 := yyvsp22 -1
	if yyvsp26 >= yyvsc26 then
		if yyvs26 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs26")
			end
			create yyspecial_routines26
			yyvsc26 := yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.make (yyvsc26)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs26")
			end
			yyvsc26 := yyvsc26 + yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.resize (yyvs26, yyvsc26)
		end
	end
	yyvs26.put (yyval26, yyvsp26)
end
when 49 then
--|#line 585 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 585")
end

			yyval26 := yyvs23.item (yyvsp23)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp26 := yyvsp26 + 1
	yyvsp23 := yyvsp23 -1
	if yyvsp26 >= yyvsc26 then
		if yyvs26 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs26")
			end
			create yyspecial_routines26
			yyvsc26 := yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.make (yyvsc26)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs26")
			end
			yyvsc26 := yyvsc26 + yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.resize (yyvs26, yyvsc26)
		end
	end
	yyvs26.put (yyval26, yyvsp26)
end
when 50 then
--|#line 589 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 589")
end

			yyval26 := yyvs24.item (yyvsp24)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp26 := yyvsp26 + 1
	yyvsp24 := yyvsp24 -1
	if yyvsp26 >= yyvsc26 then
		if yyvs26 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs26")
			end
			create yyspecial_routines26
			yyvsc26 := yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.make (yyvsc26)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs26")
			end
			yyvsc26 := yyvsc26 + yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.resize (yyvs26, yyvsc26)
		end
	end
	yyvs26.put (yyval26, yyvsp26)
end
when 51 then
--|#line 593 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 593")
end

			yyval26 := yyvs25.item (yyvsp25)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp26 := yyvsp26 + 1
	yyvsp25 := yyvsp25 -1
	if yyvsp26 >= yyvsc26 then
		if yyvs26 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs26")
			end
			create yyspecial_routines26
			yyvsc26 := yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.make (yyvsc26)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs26")
			end
			yyvsc26 := yyvsc26 + yyInitial_yyvs_size
			yyvs26 := yyspecial_routines26.resize (yyvs26, yyvsc26)
		end
	end
	yyvs26.put (yyval26, yyvsp26)
end
when 52 then
--|#line 599 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 599")
end

			yyval34 := yyvs27.item (yyvsp27)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp34 := yyvsp34 + 1
	yyvsp27 := yyvsp27 -1
	if yyvsp34 >= yyvsc34 then
		if yyvs34 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs34")
			end
			create yyspecial_routines34
			yyvsc34 := yyInitial_yyvs_size
			yyvs34 := yyspecial_routines34.make (yyvsc34)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs34")
			end
			yyvsc34 := yyvsc34 + yyInitial_yyvs_size
			yyvs34 := yyspecial_routines34.resize (yyvs34, yyvsc34)
		end
	end
	yyvs34.put (yyval34, yyvsp34)
end
when 53 then
--|#line 603 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 603")
end

			yyval34 := yyvs28.item (yyvsp28)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp34 := yyvsp34 + 1
	yyvsp28 := yyvsp28 -1
	if yyvsp34 >= yyvsc34 then
		if yyvs34 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs34")
			end
			create yyspecial_routines34
			yyvsc34 := yyInitial_yyvs_size
			yyvs34 := yyspecial_routines34.make (yyvsc34)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs34")
			end
			yyvsc34 := yyvsc34 + yyInitial_yyvs_size
			yyvs34 := yyspecial_routines34.resize (yyvs34, yyvsc34)
		end
	end
	yyvs34.put (yyval34, yyvsp34)
end
when 54 then
--|#line 607 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 607")
end

			yyval34 := yyvs30.item (yyvsp30)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp34 := yyvsp34 + 1
	yyvsp30 := yyvsp30 -1
	if yyvsp34 >= yyvsc34 then
		if yyvs34 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs34")
			end
			create yyspecial_routines34
			yyvsc34 := yyInitial_yyvs_size
			yyvs34 := yyspecial_routines34.make (yyvsc34)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs34")
			end
			yyvsc34 := yyvsc34 + yyInitial_yyvs_size
			yyvs34 := yyspecial_routines34.resize (yyvs34, yyvsc34)
		end
	end
	yyvs34.put (yyval34, yyvsp34)
end
when 55 then
--|#line 611 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 611")
end

			yyval34 := yyvs29.item (yyvsp29)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp34 := yyvsp34 + 1
	yyvsp29 := yyvsp29 -1
	if yyvsp34 >= yyvsc34 then
		if yyvs34 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs34")
			end
			create yyspecial_routines34
			yyvsc34 := yyInitial_yyvs_size
			yyvs34 := yyspecial_routines34.make (yyvsc34)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs34")
			end
			yyvsc34 := yyvsc34 + yyInitial_yyvs_size
			yyvs34 := yyspecial_routines34.resize (yyvs34, yyvsc34)
		end
	end
	yyvs34.put (yyval34, yyvsp34)
end
when 56 then
--|#line 615 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 615")
end

			yyval34 := yyvs31.item (yyvsp31)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp34 := yyvsp34 + 1
	yyvsp31 := yyvsp31 -1
	if yyvsp34 >= yyvsc34 then
		if yyvs34 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs34")
			end
			create yyspecial_routines34
			yyvsc34 := yyInitial_yyvs_size
			yyvs34 := yyspecial_routines34.make (yyvsc34)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs34")
			end
			yyvsc34 := yyvsc34 + yyInitial_yyvs_size
			yyvs34 := yyspecial_routines34.resize (yyvs34, yyvsc34)
		end
	end
	yyvs34.put (yyval34, yyvsp34)
end
when 57 then
--|#line 619 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 619")
end

			yyval34 := yyvs32.item (yyvsp32)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp34 := yyvsp34 + 1
	yyvsp32 := yyvsp32 -1
	if yyvsp34 >= yyvsc34 then
		if yyvs34 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs34")
			end
			create yyspecial_routines34
			yyvsc34 := yyInitial_yyvs_size
			yyvs34 := yyspecial_routines34.make (yyvsc34)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs34")
			end
			yyvsc34 := yyvsc34 + yyInitial_yyvs_size
			yyvs34 := yyspecial_routines34.resize (yyvs34, yyvsc34)
		end
	end
	yyvs34.put (yyval34, yyvsp34)
end
when 58 then
--|#line 628 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 628")
end

			yyval4 := yyvs4.item (yyvsp4)
			type_name := yyvs4.item (yyvsp4)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs4.put (yyval4, yyvsp4)
end
when 59 then
--|#line 633 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 633")
end

			yyval4 := yyvs4.item (yyvsp4)
			type_name := uml_to_eiffel_typename (yyvs4.item (yyvsp4))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs4.put (yyval4, yyvsp4)
end
when 60 then
--|#line 640 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 640")
end

			yyval1 := yyvs4.item (yyvsp4)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp4 := yyvsp4 -1
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
when 61 then
--|#line 646 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 646")
end

			create yyval17.make(0)
			yyval17.extend(yyvs4.item (yyvsp4 - 1))
			yyval17.extend(yyvs4.item (yyvsp4))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp17 := yyvsp17 + 1
	yyvsp4 := yyvsp4 -2
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
when 62 then
--|#line 652 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 652")
end

			yyvs17.item (yyvsp17).extend(yyvs4.item (yyvsp4))
			yyval17 := yyvs17.item (yyvsp17)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp4 := yyvsp4 -1
	yyvs17.put (yyval17, yyvsp17)
end
when 63 then
--|#line 657 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 657")
end

			create yyval17.make(0)
			yyval17.extend(yyvs4.item (yyvsp4))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp17 := yyvsp17 + 1
	yyvsp4 := yyvsp4 -1
	yyvsp1 := yyvsp1 -2
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
when 64 then
--|#line 703 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 703")
end

			if not attached type_name then
				yyval2 := yyvs2.item (yyvsp2).to_integer
			else
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 65 then
--|#line 710 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 710")
end

			yyval2 := yyvs2.item (yyvsp2)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs2.put (yyval2, yyvsp2)
end
when 66 then
--|#line 713 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 713")
end

			yyval2 := - yyvs2.item (yyvsp2)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs2.put (yyval2, yyvsp2)
end
when 67 then
--|#line 718 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 718")
end

			create yyval18.make(0)
			yyval18.extend(yyvs2.item (yyvsp2 - 1))
			yyval18.extend(yyvs2.item (yyvsp2))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp18 := yyvsp18 + 1
	yyvsp2 := yyvsp2 -2
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
when 68 then
--|#line 724 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 724")
end

			yyvs18.item (yyvsp18).extend(yyvs2.item (yyvsp2))
			yyval18 := yyvs18.item (yyvsp18)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp2 := yyvsp2 -1
	yyvs18.put (yyval18, yyvsp18)
end
when 69 then
--|#line 729 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 729")
end

			create yyval18.make(0)
			yyval18.extend(yyvs2.item (yyvsp2))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp18 := yyvsp18 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -2
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
when 70 then
--|#line 736 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 736")
end

			if yyvs2.item (yyvsp2 - 1) <= yyvs2.item (yyvsp2) then
				create integer_interval.make_bounded(yyvs2.item (yyvsp2 - 1), yyvs2.item (yyvsp2), True, True)
				yyval27 := integer_interval
			else
				abort_with_error("VIVLO", <<yyvs2.item (yyvsp2 - 1).out, yyvs2.item (yyvsp2).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp27 := yyvsp27 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -2
	if yyvsp27 >= yyvsc27 then
		if yyvs27 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs27")
			end
			create yyspecial_routines27
			yyvsc27 := yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.make (yyvsc27)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs27")
			end
			yyvsc27 := yyvsc27 + yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.resize (yyvs27, yyvsc27)
		end
	end
	yyvs27.put (yyval27, yyvsp27)
end
when 71 then
--|#line 745 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 745")
end

			if yyvs2.item (yyvsp2 - 1) <= yyvs2.item (yyvsp2) then
				create integer_interval.make_bounded(yyvs2.item (yyvsp2 - 1), yyvs2.item (yyvsp2), False, True)
				yyval27 := integer_interval
			else
				abort_with_error("VIVLO", <<yyvs2.item (yyvsp2 - 1).out, yyvs2.item (yyvsp2).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp27 := yyvsp27 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp2 := yyvsp2 -2
	if yyvsp27 >= yyvsc27 then
		if yyvs27 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs27")
			end
			create yyspecial_routines27
			yyvsc27 := yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.make (yyvsc27)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs27")
			end
			yyvsc27 := yyvsc27 + yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.resize (yyvs27, yyvsc27)
		end
	end
	yyvs27.put (yyval27, yyvsp27)
end
when 72 then
--|#line 754 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 754")
end

			if yyvs2.item (yyvsp2 - 1) <= yyvs2.item (yyvsp2) then
				create integer_interval.make_bounded(yyvs2.item (yyvsp2 - 1), yyvs2.item (yyvsp2), True, False)
				yyval27 := integer_interval
			else
				abort_with_error("VIVLO", <<yyvs2.item (yyvsp2 - 1).out, yyvs2.item (yyvsp2).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp27 := yyvsp27 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp2 := yyvsp2 -2
	if yyvsp27 >= yyvsc27 then
		if yyvs27 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs27")
			end
			create yyspecial_routines27
			yyvsc27 := yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.make (yyvsc27)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs27")
			end
			yyvsc27 := yyvsc27 + yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.resize (yyvs27, yyvsc27)
		end
	end
	yyvs27.put (yyval27, yyvsp27)
end
when 73 then
--|#line 763 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 763")
end

			if yyvs2.item (yyvsp2 - 1) <= yyvs2.item (yyvsp2) then
				create integer_interval.make_bounded(yyvs2.item (yyvsp2 - 1), yyvs2.item (yyvsp2), False, False)
				yyval27 := integer_interval
			else
				abort_with_error("VIVLO", <<yyvs2.item (yyvsp2 - 1).out, yyvs2.item (yyvsp2).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 7
	yyvsp27 := yyvsp27 + 1
	yyvsp1 := yyvsp1 -5
	yyvsp2 := yyvsp2 -2
	if yyvsp27 >= yyvsc27 then
		if yyvs27 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs27")
			end
			create yyspecial_routines27
			yyvsc27 := yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.make (yyvsc27)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs27")
			end
			yyvsc27 := yyvsc27 + yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.resize (yyvs27, yyvsc27)
		end
	end
	yyvs27.put (yyval27, yyvsp27)
end
when 74 then
--|#line 772 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 772")
end

			create integer_interval.make_lower_unbounded(yyvs2.item (yyvsp2), False)
			yyval27 := integer_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp27 := yyvsp27 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
	if yyvsp27 >= yyvsc27 then
		if yyvs27 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs27")
			end
			create yyspecial_routines27
			yyvsc27 := yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.make (yyvsc27)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs27")
			end
			yyvsc27 := yyvsc27 + yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.resize (yyvs27, yyvsc27)
		end
	end
	yyvs27.put (yyval27, yyvsp27)
end
when 75 then
--|#line 777 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 777")
end

			create integer_interval.make_lower_unbounded(yyvs2.item (yyvsp2), True)
			yyval27 := integer_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp27 := yyvsp27 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
	if yyvsp27 >= yyvsc27 then
		if yyvs27 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs27")
			end
			create yyspecial_routines27
			yyvsc27 := yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.make (yyvsc27)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs27")
			end
			yyvsc27 := yyvsc27 + yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.resize (yyvs27, yyvsc27)
		end
	end
	yyvs27.put (yyval27, yyvsp27)
end
when 76 then
--|#line 782 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 782")
end

			create integer_interval.make_upper_unbounded(yyvs2.item (yyvsp2), False)
			yyval27 := integer_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp27 := yyvsp27 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
	if yyvsp27 >= yyvsc27 then
		if yyvs27 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs27")
			end
			create yyspecial_routines27
			yyvsc27 := yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.make (yyvsc27)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs27")
			end
			yyvsc27 := yyvsc27 + yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.resize (yyvs27, yyvsc27)
		end
	end
	yyvs27.put (yyval27, yyvsp27)
end
when 77 then
--|#line 787 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 787")
end

			create integer_interval.make_upper_unbounded(yyvs2.item (yyvsp2), True)
			yyval27 := integer_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp27 := yyvsp27 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
	if yyvsp27 >= yyvsc27 then
		if yyvs27 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs27")
			end
			create yyspecial_routines27
			yyvsc27 := yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.make (yyvsc27)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs27")
			end
			yyvsc27 := yyvsc27 + yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.resize (yyvs27, yyvsc27)
		end
	end
	yyvs27.put (yyval27, yyvsp27)
end
when 78 then
--|#line 792 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 792")
end

			create integer_interval.make_point(yyvs2.item (yyvsp2))
			yyval27 := integer_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp27 := yyvsp27 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp2 := yyvsp2 -1
	if yyvsp27 >= yyvsc27 then
		if yyvs27 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs27")
			end
			create yyspecial_routines27
			yyvsc27 := yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.make (yyvsc27)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs27")
			end
			yyvsc27 := yyvsc27 + yyInitial_yyvs_size
			yyvs27 := yyspecial_routines27.resize (yyvs27, yyvsc27)
		end
	end
	yyvs27.put (yyval27, yyvsp27)
end
when 79 then
--|#line 799 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 799")
end

			yyval3 := yyvs3.item (yyvsp3)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs3.put (yyval3, yyvsp3)
end
when 80 then
--|#line 803 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 803")
end

			yyval3 := yyvs3.item (yyvsp3)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs3.put (yyval3, yyvsp3)
end
when 81 then
--|#line 807 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 807")
end

			yyval3 := - yyvs3.item (yyvsp3)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs3.put (yyval3, yyvsp3)
end
when 82 then
--|#line 813 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 813")
end

			create yyval19.make(0)
			yyval19.extend(yyvs3.item (yyvsp3 - 1))
			yyval19.extend(yyvs3.item (yyvsp3))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp19 := yyvsp19 + 1
	yyvsp3 := yyvsp3 -2
	yyvsp1 := yyvsp1 -1
	if yyvsp19 >= yyvsc19 then
		if yyvs19 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs19")
			end
			create yyspecial_routines19
			yyvsc19 := yyInitial_yyvs_size
			yyvs19 := yyspecial_routines19.make (yyvsc19)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs19")
			end
			yyvsc19 := yyvsc19 + yyInitial_yyvs_size
			yyvs19 := yyspecial_routines19.resize (yyvs19, yyvsc19)
		end
	end
	yyvs19.put (yyval19, yyvsp19)
end
when 83 then
--|#line 819 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 819")
end

			yyvs19.item (yyvsp19).extend(yyvs3.item (yyvsp3))
			yyval19 := yyvs19.item (yyvsp19)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp3 := yyvsp3 -1
	yyvs19.put (yyval19, yyvsp19)
end
when 84 then
--|#line 824 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 824")
end

			create yyval19.make(0)
			yyval19.extend(yyvs3.item (yyvsp3))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp19 := yyvsp19 + 1
	yyvsp3 := yyvsp3 -1
	yyvsp1 := yyvsp1 -2
	if yyvsp19 >= yyvsc19 then
		if yyvs19 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs19")
			end
			create yyspecial_routines19
			yyvsc19 := yyInitial_yyvs_size
			yyvs19 := yyspecial_routines19.make (yyvsc19)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs19")
			end
			yyvsc19 := yyvsc19 + yyInitial_yyvs_size
			yyvs19 := yyspecial_routines19.resize (yyvs19, yyvsc19)
		end
	end
	yyvs19.put (yyval19, yyvsp19)
end
when 85 then
--|#line 831 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 831")
end

			if yyvs3.item (yyvsp3 - 1) <= yyvs3.item (yyvsp3) then
				create real_interval.make_bounded(yyvs3.item (yyvsp3 - 1), yyvs3.item (yyvsp3), True, True)
				yyval28 := real_interval
			else
				abort_with_error("VIVLO", <<yyvs3.item (yyvsp3 - 1).out, yyvs3.item (yyvsp3).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp28 := yyvsp28 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp3 := yyvsp3 -2
	if yyvsp28 >= yyvsc28 then
		if yyvs28 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs28")
			end
			create yyspecial_routines28
			yyvsc28 := yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.make (yyvsc28)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs28")
			end
			yyvsc28 := yyvsc28 + yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.resize (yyvs28, yyvsc28)
		end
	end
	yyvs28.put (yyval28, yyvsp28)
end
when 86 then
--|#line 840 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 840")
end

			if yyvs3.item (yyvsp3 - 1) <= yyvs3.item (yyvsp3) then
				create real_interval.make_bounded(yyvs3.item (yyvsp3 - 1), yyvs3.item (yyvsp3), False, True)
				yyval28 := real_interval
			else
				abort_with_error("VIVLO", <<yyvs3.item (yyvsp3 - 1).out, yyvs3.item (yyvsp3).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp28 := yyvsp28 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp3 := yyvsp3 -2
	if yyvsp28 >= yyvsc28 then
		if yyvs28 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs28")
			end
			create yyspecial_routines28
			yyvsc28 := yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.make (yyvsc28)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs28")
			end
			yyvsc28 := yyvsc28 + yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.resize (yyvs28, yyvsc28)
		end
	end
	yyvs28.put (yyval28, yyvsp28)
end
when 87 then
--|#line 849 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 849")
end

			if yyvs3.item (yyvsp3 - 1) <= yyvs3.item (yyvsp3) then
				create real_interval.make_bounded(yyvs3.item (yyvsp3 - 1), yyvs3.item (yyvsp3), True, False)
				yyval28 := real_interval
			else
				abort_with_error("VIVLO", <<yyvs3.item (yyvsp3 - 1).out, yyvs3.item (yyvsp3).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp28 := yyvsp28 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp3 := yyvsp3 -2
	if yyvsp28 >= yyvsc28 then
		if yyvs28 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs28")
			end
			create yyspecial_routines28
			yyvsc28 := yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.make (yyvsc28)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs28")
			end
			yyvsc28 := yyvsc28 + yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.resize (yyvs28, yyvsc28)
		end
	end
	yyvs28.put (yyval28, yyvsp28)
end
when 88 then
--|#line 858 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 858")
end

			if yyvs3.item (yyvsp3 - 1) <= yyvs3.item (yyvsp3) then
				create real_interval.make_bounded(yyvs3.item (yyvsp3 - 1), yyvs3.item (yyvsp3), False, False)
				yyval28 := real_interval
			else
				abort_with_error("VIVLO", <<yyvs3.item (yyvsp3 - 1).out, yyvs3.item (yyvsp3).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 7
	yyvsp28 := yyvsp28 + 1
	yyvsp1 := yyvsp1 -5
	yyvsp3 := yyvsp3 -2
	if yyvsp28 >= yyvsc28 then
		if yyvs28 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs28")
			end
			create yyspecial_routines28
			yyvsc28 := yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.make (yyvsc28)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs28")
			end
			yyvsc28 := yyvsc28 + yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.resize (yyvs28, yyvsc28)
		end
	end
	yyvs28.put (yyval28, yyvsp28)
end
when 89 then
--|#line 867 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 867")
end

			create real_interval.make_lower_unbounded(yyvs3.item (yyvsp3), False)
			yyval28 := real_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp28 := yyvsp28 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp3 := yyvsp3 -1
	if yyvsp28 >= yyvsc28 then
		if yyvs28 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs28")
			end
			create yyspecial_routines28
			yyvsc28 := yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.make (yyvsc28)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs28")
			end
			yyvsc28 := yyvsc28 + yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.resize (yyvs28, yyvsc28)
		end
	end
	yyvs28.put (yyval28, yyvsp28)
end
when 90 then
--|#line 872 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 872")
end

			create real_interval.make_lower_unbounded(yyvs3.item (yyvsp3), True)
			yyval28 := real_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp28 := yyvsp28 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp3 := yyvsp3 -1
	if yyvsp28 >= yyvsc28 then
		if yyvs28 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs28")
			end
			create yyspecial_routines28
			yyvsc28 := yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.make (yyvsc28)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs28")
			end
			yyvsc28 := yyvsc28 + yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.resize (yyvs28, yyvsc28)
		end
	end
	yyvs28.put (yyval28, yyvsp28)
end
when 91 then
--|#line 877 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 877")
end

			create real_interval.make_upper_unbounded(yyvs3.item (yyvsp3), False)
			yyval28 := real_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp28 := yyvsp28 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp3 := yyvsp3 -1
	if yyvsp28 >= yyvsc28 then
		if yyvs28 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs28")
			end
			create yyspecial_routines28
			yyvsc28 := yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.make (yyvsc28)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs28")
			end
			yyvsc28 := yyvsc28 + yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.resize (yyvs28, yyvsc28)
		end
	end
	yyvs28.put (yyval28, yyvsp28)
end
when 92 then
--|#line 882 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 882")
end

			create real_interval.make_upper_unbounded(yyvs3.item (yyvsp3), True)
			yyval28 := real_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp28 := yyvsp28 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp3 := yyvsp3 -1
	if yyvsp28 >= yyvsc28 then
		if yyvs28 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs28")
			end
			create yyspecial_routines28
			yyvsc28 := yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.make (yyvsc28)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs28")
			end
			yyvsc28 := yyvsc28 + yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.resize (yyvs28, yyvsc28)
		end
	end
	yyvs28.put (yyval28, yyvsp28)
end
when 93 then
--|#line 887 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 887")
end

			create real_interval.make_point(yyvs3.item (yyvsp3))
			yyval28 := real_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp28 := yyvsp28 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp3 := yyvsp3 -1
	if yyvsp28 >= yyvsc28 then
		if yyvs28 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs28")
			end
			create yyspecial_routines28
			yyvsc28 := yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.make (yyvsc28)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs28")
			end
			yyvsc28 := yyvsc28 + yyInitial_yyvs_size
			yyvs28 := yyspecial_routines28.resize (yyvs28, yyvsc28)
		end
	end
	yyvs28.put (yyval28, yyvsp28)
end
when 94 then
--|#line 894 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 894")
end

			yyval7 := True
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp7 := yyvsp7 + 1
	yyvsp1 := yyvsp1 -1
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
when 95 then
--|#line 898 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 898")
end

			yyval7 := False
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp7 := yyvsp7 + 1
	yyvsp1 := yyvsp1 -1
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
when 96 then
--|#line 904 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 904")
end

			create yyval21.make(0)
			yyval21.extend(yyvs7.item (yyvsp7 - 1))
			yyval21.extend(yyvs7.item (yyvsp7))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp21 := yyvsp21 + 1
	yyvsp7 := yyvsp7 -2
	yyvsp1 := yyvsp1 -1
	if yyvsp21 >= yyvsc21 then
		if yyvs21 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs21")
			end
			create yyspecial_routines21
			yyvsc21 := yyInitial_yyvs_size
			yyvs21 := yyspecial_routines21.make (yyvsc21)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs21")
			end
			yyvsc21 := yyvsc21 + yyInitial_yyvs_size
			yyvs21 := yyspecial_routines21.resize (yyvs21, yyvsc21)
		end
	end
	yyvs21.put (yyval21, yyvsp21)
end
when 97 then
--|#line 910 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 910")
end

			yyvs21.item (yyvsp21).extend(yyvs7.item (yyvsp7))
			yyval21 := yyvs21.item (yyvsp21)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp7 := yyvsp7 -1
	yyvs21.put (yyval21, yyvsp21)
end
when 98 then
--|#line 915 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 915")
end

			create yyval21.make(0)
			yyval21.extend(yyvs7.item (yyvsp7))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp21 := yyvsp21 + 1
	yyvsp7 := yyvsp7 -1
	yyvsp1 := yyvsp1 -2
	if yyvsp21 >= yyvsc21 then
		if yyvs21 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs21")
			end
			create yyspecial_routines21
			yyvsc21 := yyInitial_yyvs_size
			yyvs21 := yyspecial_routines21.make (yyvsc21)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs21")
			end
			yyvsc21 := yyvsc21 + yyInitial_yyvs_size
			yyvs21 := yyspecial_routines21.resize (yyvs21, yyvsc21)
		end
	end
	yyvs21.put (yyval21, yyvsp21)
end
when 99 then
--|#line 922 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 922")
end

			yyval5 := yyvs5.item (yyvsp5)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs5.put (yyval5, yyvsp5)
end
when 100 then
--|#line 928 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 928")
end

			create yyval20.make(0)
			yyval20.extend(yyvs5.item (yyvsp5 - 1))
			yyval20.extend(yyvs5.item (yyvsp5))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp20 := yyvsp20 + 1
	yyvsp5 := yyvsp5 -2
	yyvsp1 := yyvsp1 -1
	if yyvsp20 >= yyvsc20 then
		if yyvs20 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs20")
			end
			create yyspecial_routines20
			yyvsc20 := yyInitial_yyvs_size
			yyvs20 := yyspecial_routines20.make (yyvsc20)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs20")
			end
			yyvsc20 := yyvsc20 + yyInitial_yyvs_size
			yyvs20 := yyspecial_routines20.resize (yyvs20, yyvsc20)
		end
	end
	yyvs20.put (yyval20, yyvsp20)
end
when 101 then
--|#line 934 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 934")
end

			yyvs20.item (yyvsp20).extend(yyvs5.item (yyvsp5))
			yyval20 := yyvs20.item (yyvsp20)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp5 := yyvsp5 -1
	yyvs20.put (yyval20, yyvsp20)
end
when 102 then
--|#line 939 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 939")
end

			create yyval20.make(0)
			yyval20.extend(yyvs5.item (yyvsp5))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp20 := yyvsp20 + 1
	yyvsp5 := yyvsp5 -1
	yyvsp1 := yyvsp1 -2
	if yyvsp20 >= yyvsc20 then
		if yyvs20 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs20")
			end
			create yyspecial_routines20
			yyvsc20 := yyInitial_yyvs_size
			yyvs20 := yyspecial_routines20.make (yyvsc20)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs20")
			end
			yyvsc20 := yyvsc20 + yyInitial_yyvs_size
			yyvs20 := yyspecial_routines20.resize (yyvs20, yyvsc20)
		end
	end
	yyvs20.put (yyval20, yyvsp20)
end
when 103 then
--|#line 946 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 946")
end

			if valid_iso8601_date(yyvs4.item (yyvsp4)) then
				create yyval8.make_from_string(yyvs4.item (yyvsp4))
			else
				abort_with_error("VIDV", <<yyvs4.item (yyvsp4)>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp8 := yyvsp8 + 1
	yyvsp4 := yyvsp4 -1
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
when 104 then
--|#line 956 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 956")
end

			create yyval22.make(0)
			yyval22.extend(yyvs8.item (yyvsp8 - 1))
			yyval22.extend(yyvs8.item (yyvsp8))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp22 := yyvsp22 + 1
	yyvsp8 := yyvsp8 -2
	yyvsp1 := yyvsp1 -1
	if yyvsp22 >= yyvsc22 then
		if yyvs22 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs22")
			end
			create yyspecial_routines22
			yyvsc22 := yyInitial_yyvs_size
			yyvs22 := yyspecial_routines22.make (yyvsc22)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs22")
			end
			yyvsc22 := yyvsc22 + yyInitial_yyvs_size
			yyvs22 := yyspecial_routines22.resize (yyvs22, yyvsc22)
		end
	end
	yyvs22.put (yyval22, yyvsp22)
end
when 105 then
--|#line 962 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 962")
end

			yyvs22.item (yyvsp22).extend(yyvs8.item (yyvsp8))
			yyval22 := yyvs22.item (yyvsp22)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp8 := yyvsp8 -1
	yyvs22.put (yyval22, yyvsp22)
end
when 106 then
--|#line 967 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 967")
end

			create yyval22.make(0)
			yyval22.extend(yyvs8.item (yyvsp8))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp22 := yyvsp22 + 1
	yyvsp8 := yyvsp8 -1
	yyvsp1 := yyvsp1 -2
	if yyvsp22 >= yyvsc22 then
		if yyvs22 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs22")
			end
			create yyspecial_routines22
			yyvsc22 := yyInitial_yyvs_size
			yyvs22 := yyspecial_routines22.make (yyvsc22)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs22")
			end
			yyvsc22 := yyvsc22 + yyInitial_yyvs_size
			yyvs22 := yyspecial_routines22.resize (yyvs22, yyvsc22)
		end
	end
	yyvs22.put (yyval22, yyvsp22)
end
when 107 then
--|#line 974 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 974")
end

			if yyvs8.item (yyvsp8 - 1) <= yyvs8.item (yyvsp8) then
				create date_interval.make_bounded(yyvs8.item (yyvsp8 - 1), yyvs8.item (yyvsp8), True, True)
				yyval30 := date_interval
			else
				abort_with_error("VIVLO", <<yyvs8.item (yyvsp8 - 1).out, yyvs8.item (yyvsp8).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp30 := yyvsp30 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp8 := yyvsp8 -2
	if yyvsp30 >= yyvsc30 then
		if yyvs30 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs30")
			end
			create yyspecial_routines30
			yyvsc30 := yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.make (yyvsc30)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs30")
			end
			yyvsc30 := yyvsc30 + yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.resize (yyvs30, yyvsc30)
		end
	end
	yyvs30.put (yyval30, yyvsp30)
end
when 108 then
--|#line 983 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 983")
end

			if yyvs8.item (yyvsp8 - 1) <= yyvs8.item (yyvsp8) then
				create date_interval.make_bounded(yyvs8.item (yyvsp8 - 1), yyvs8.item (yyvsp8), False, True)
				yyval30 := date_interval
			else
				abort_with_error("VIVLO", <<yyvs8.item (yyvsp8 - 1).out, yyvs8.item (yyvsp8).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp30 := yyvsp30 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp8 := yyvsp8 -2
	if yyvsp30 >= yyvsc30 then
		if yyvs30 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs30")
			end
			create yyspecial_routines30
			yyvsc30 := yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.make (yyvsc30)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs30")
			end
			yyvsc30 := yyvsc30 + yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.resize (yyvs30, yyvsc30)
		end
	end
	yyvs30.put (yyval30, yyvsp30)
end
when 109 then
--|#line 992 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 992")
end

			if yyvs8.item (yyvsp8 - 1) <= yyvs8.item (yyvsp8) then
				create date_interval.make_bounded(yyvs8.item (yyvsp8 - 1), yyvs8.item (yyvsp8), True, False)
				yyval30 := date_interval
			else
				abort_with_error("VIVLO", <<yyvs8.item (yyvsp8 - 1).out, yyvs8.item (yyvsp8).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp30 := yyvsp30 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp8 := yyvsp8 -2
	if yyvsp30 >= yyvsc30 then
		if yyvs30 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs30")
			end
			create yyspecial_routines30
			yyvsc30 := yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.make (yyvsc30)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs30")
			end
			yyvsc30 := yyvsc30 + yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.resize (yyvs30, yyvsc30)
		end
	end
	yyvs30.put (yyval30, yyvsp30)
end
when 110 then
--|#line 1001 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1001")
end

			if yyvs8.item (yyvsp8 - 1) <= yyvs8.item (yyvsp8) then
				create date_interval.make_bounded(yyvs8.item (yyvsp8 - 1), yyvs8.item (yyvsp8), False, False)
				yyval30 := date_interval
			else
				abort_with_error("VIVLO", <<yyvs8.item (yyvsp8 - 1).out, yyvs8.item (yyvsp8).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 7
	yyvsp30 := yyvsp30 + 1
	yyvsp1 := yyvsp1 -5
	yyvsp8 := yyvsp8 -2
	if yyvsp30 >= yyvsc30 then
		if yyvs30 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs30")
			end
			create yyspecial_routines30
			yyvsc30 := yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.make (yyvsc30)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs30")
			end
			yyvsc30 := yyvsc30 + yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.resize (yyvs30, yyvsc30)
		end
	end
	yyvs30.put (yyval30, yyvsp30)
end
when 111 then
--|#line 1010 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1010")
end

			create date_interval.make_lower_unbounded(yyvs8.item (yyvsp8), False)
			yyval30 := date_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp30 := yyvsp30 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp8 := yyvsp8 -1
	if yyvsp30 >= yyvsc30 then
		if yyvs30 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs30")
			end
			create yyspecial_routines30
			yyvsc30 := yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.make (yyvsc30)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs30")
			end
			yyvsc30 := yyvsc30 + yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.resize (yyvs30, yyvsc30)
		end
	end
	yyvs30.put (yyval30, yyvsp30)
end
when 112 then
--|#line 1015 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1015")
end

			create date_interval.make_lower_unbounded(yyvs8.item (yyvsp8), True)
			yyval30 := date_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp30 := yyvsp30 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp8 := yyvsp8 -1
	if yyvsp30 >= yyvsc30 then
		if yyvs30 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs30")
			end
			create yyspecial_routines30
			yyvsc30 := yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.make (yyvsc30)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs30")
			end
			yyvsc30 := yyvsc30 + yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.resize (yyvs30, yyvsc30)
		end
	end
	yyvs30.put (yyval30, yyvsp30)
end
when 113 then
--|#line 1020 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1020")
end

			create date_interval.make_upper_unbounded(yyvs8.item (yyvsp8), False)
			yyval30 := date_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp30 := yyvsp30 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp8 := yyvsp8 -1
	if yyvsp30 >= yyvsc30 then
		if yyvs30 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs30")
			end
			create yyspecial_routines30
			yyvsc30 := yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.make (yyvsc30)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs30")
			end
			yyvsc30 := yyvsc30 + yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.resize (yyvs30, yyvsc30)
		end
	end
	yyvs30.put (yyval30, yyvsp30)
end
when 114 then
--|#line 1025 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1025")
end

			create date_interval.make_upper_unbounded(yyvs8.item (yyvsp8), True)
			yyval30 := date_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp30 := yyvsp30 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp8 := yyvsp8 -1
	if yyvsp30 >= yyvsc30 then
		if yyvs30 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs30")
			end
			create yyspecial_routines30
			yyvsc30 := yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.make (yyvsc30)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs30")
			end
			yyvsc30 := yyvsc30 + yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.resize (yyvs30, yyvsc30)
		end
	end
	yyvs30.put (yyval30, yyvsp30)
end
when 115 then
--|#line 1030 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1030")
end

			create date_interval.make_point(yyvs8.item (yyvsp8))
			yyval30 := date_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp30 := yyvsp30 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp8 := yyvsp8 -1
	if yyvsp30 >= yyvsc30 then
		if yyvs30 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs30")
			end
			create yyspecial_routines30
			yyvsc30 := yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.make (yyvsc30)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs30")
			end
			yyvsc30 := yyvsc30 + yyInitial_yyvs_size
			yyvs30 := yyspecial_routines30.resize (yyvs30, yyvsc30)
		end
	end
	yyvs30.put (yyval30, yyvsp30)
end
when 116 then
--|#line 1037 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1037")
end

			if valid_iso8601_time(yyvs4.item (yyvsp4)) then
				create yyval10.make_from_string(yyvs4.item (yyvsp4))
			else
				abort_with_error("VITV", <<yyvs4.item (yyvsp4)>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp10 := yyvsp10 + 1
	yyvsp4 := yyvsp4 -1
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
when 117 then
--|#line 1047 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1047")
end

			create yyval23.make(0)
			yyval23.extend(yyvs10.item (yyvsp10 - 1))
			yyval23.extend(yyvs10.item (yyvsp10))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp23 := yyvsp23 + 1
	yyvsp10 := yyvsp10 -2
	yyvsp1 := yyvsp1 -1
	if yyvsp23 >= yyvsc23 then
		if yyvs23 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs23")
			end
			create yyspecial_routines23
			yyvsc23 := yyInitial_yyvs_size
			yyvs23 := yyspecial_routines23.make (yyvsc23)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs23")
			end
			yyvsc23 := yyvsc23 + yyInitial_yyvs_size
			yyvs23 := yyspecial_routines23.resize (yyvs23, yyvsc23)
		end
	end
	yyvs23.put (yyval23, yyvsp23)
end
when 118 then
--|#line 1053 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1053")
end

			yyvs23.item (yyvsp23).extend(yyvs10.item (yyvsp10))
			yyval23 := yyvs23.item (yyvsp23)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp10 := yyvsp10 -1
	yyvs23.put (yyval23, yyvsp23)
end
when 119 then
--|#line 1058 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1058")
end

			create yyval23.make(0)
			yyval23.extend(yyvs10.item (yyvsp10))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp23 := yyvsp23 + 1
	yyvsp10 := yyvsp10 -1
	yyvsp1 := yyvsp1 -2
	if yyvsp23 >= yyvsc23 then
		if yyvs23 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs23")
			end
			create yyspecial_routines23
			yyvsc23 := yyInitial_yyvs_size
			yyvs23 := yyspecial_routines23.make (yyvsc23)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs23")
			end
			yyvsc23 := yyvsc23 + yyInitial_yyvs_size
			yyvs23 := yyspecial_routines23.resize (yyvs23, yyvsc23)
		end
	end
	yyvs23.put (yyval23, yyvsp23)
end
when 120 then
--|#line 1065 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1065")
end

			if yyvs10.item (yyvsp10 - 1) <= yyvs10.item (yyvsp10) then
				create time_interval.make_bounded(yyvs10.item (yyvsp10 - 1), yyvs10.item (yyvsp10), True, True)
				yyval29 := time_interval
			else
				abort_with_error("VIVLO", <<yyvs10.item (yyvsp10 - 1).out, yyvs10.item (yyvsp10).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp29 := yyvsp29 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp10 := yyvsp10 -2
	if yyvsp29 >= yyvsc29 then
		if yyvs29 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs29")
			end
			create yyspecial_routines29
			yyvsc29 := yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.make (yyvsc29)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs29")
			end
			yyvsc29 := yyvsc29 + yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.resize (yyvs29, yyvsc29)
		end
	end
	yyvs29.put (yyval29, yyvsp29)
end
when 121 then
--|#line 1074 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1074")
end

			if yyvs10.item (yyvsp10 - 1) <= yyvs10.item (yyvsp10) then
				create time_interval.make_bounded(yyvs10.item (yyvsp10 - 1), yyvs10.item (yyvsp10), False, True)
				yyval29 := time_interval
			else
				abort_with_error("VIVLO", <<yyvs10.item (yyvsp10 - 1).out, yyvs10.item (yyvsp10).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp29 := yyvsp29 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp10 := yyvsp10 -2
	if yyvsp29 >= yyvsc29 then
		if yyvs29 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs29")
			end
			create yyspecial_routines29
			yyvsc29 := yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.make (yyvsc29)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs29")
			end
			yyvsc29 := yyvsc29 + yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.resize (yyvs29, yyvsc29)
		end
	end
	yyvs29.put (yyval29, yyvsp29)
end
when 122 then
--|#line 1083 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1083")
end

			if yyvs10.item (yyvsp10 - 1) <= yyvs10.item (yyvsp10) then
				create time_interval.make_bounded(yyvs10.item (yyvsp10 - 1), yyvs10.item (yyvsp10), True, False)
				yyval29 := time_interval
			else
				abort_with_error("VIVLO", <<yyvs10.item (yyvsp10 - 1).out, yyvs10.item (yyvsp10).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp29 := yyvsp29 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp10 := yyvsp10 -2
	if yyvsp29 >= yyvsc29 then
		if yyvs29 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs29")
			end
			create yyspecial_routines29
			yyvsc29 := yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.make (yyvsc29)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs29")
			end
			yyvsc29 := yyvsc29 + yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.resize (yyvs29, yyvsc29)
		end
	end
	yyvs29.put (yyval29, yyvsp29)
end
when 123 then
--|#line 1092 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1092")
end

			if yyvs10.item (yyvsp10 - 1) <= yyvs10.item (yyvsp10) then
				create time_interval.make_bounded(yyvs10.item (yyvsp10 - 1), yyvs10.item (yyvsp10), False, False)
				yyval29 := time_interval
			else
				abort_with_error("VIVLO", <<yyvs10.item (yyvsp10 - 1).out, yyvs10.item (yyvsp10).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 7
	yyvsp29 := yyvsp29 + 1
	yyvsp1 := yyvsp1 -5
	yyvsp10 := yyvsp10 -2
	if yyvsp29 >= yyvsc29 then
		if yyvs29 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs29")
			end
			create yyspecial_routines29
			yyvsc29 := yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.make (yyvsc29)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs29")
			end
			yyvsc29 := yyvsc29 + yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.resize (yyvs29, yyvsc29)
		end
	end
	yyvs29.put (yyval29, yyvsp29)
end
when 124 then
--|#line 1101 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1101")
end

			create time_interval.make_lower_unbounded(yyvs10.item (yyvsp10), False)
			yyval29 := time_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp29 := yyvsp29 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp10 := yyvsp10 -1
	if yyvsp29 >= yyvsc29 then
		if yyvs29 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs29")
			end
			create yyspecial_routines29
			yyvsc29 := yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.make (yyvsc29)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs29")
			end
			yyvsc29 := yyvsc29 + yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.resize (yyvs29, yyvsc29)
		end
	end
	yyvs29.put (yyval29, yyvsp29)
end
when 125 then
--|#line 1106 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1106")
end

			create time_interval.make_lower_unbounded(yyvs10.item (yyvsp10), True)
			yyval29 := time_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp29 := yyvsp29 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp10 := yyvsp10 -1
	if yyvsp29 >= yyvsc29 then
		if yyvs29 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs29")
			end
			create yyspecial_routines29
			yyvsc29 := yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.make (yyvsc29)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs29")
			end
			yyvsc29 := yyvsc29 + yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.resize (yyvs29, yyvsc29)
		end
	end
	yyvs29.put (yyval29, yyvsp29)
end
when 126 then
--|#line 1111 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1111")
end

			create time_interval.make_upper_unbounded(yyvs10.item (yyvsp10), False)
			yyval29 := time_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp29 := yyvsp29 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp10 := yyvsp10 -1
	if yyvsp29 >= yyvsc29 then
		if yyvs29 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs29")
			end
			create yyspecial_routines29
			yyvsc29 := yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.make (yyvsc29)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs29")
			end
			yyvsc29 := yyvsc29 + yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.resize (yyvs29, yyvsc29)
		end
	end
	yyvs29.put (yyval29, yyvsp29)
end
when 127 then
--|#line 1116 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1116")
end

			create time_interval.make_upper_unbounded(yyvs10.item (yyvsp10), True)
			yyval29 := time_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp29 := yyvsp29 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp10 := yyvsp10 -1
	if yyvsp29 >= yyvsc29 then
		if yyvs29 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs29")
			end
			create yyspecial_routines29
			yyvsc29 := yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.make (yyvsc29)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs29")
			end
			yyvsc29 := yyvsc29 + yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.resize (yyvs29, yyvsc29)
		end
	end
	yyvs29.put (yyval29, yyvsp29)
end
when 128 then
--|#line 1121 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1121")
end

			create time_interval.make_point(yyvs10.item (yyvsp10))
			yyval29 := time_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp29 := yyvsp29 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp10 := yyvsp10 -1
	if yyvsp29 >= yyvsc29 then
		if yyvs29 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs29")
			end
			create yyspecial_routines29
			yyvsc29 := yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.make (yyvsc29)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs29")
			end
			yyvsc29 := yyvsc29 + yyInitial_yyvs_size
			yyvs29 := yyspecial_routines29.resize (yyvs29, yyvsc29)
		end
	end
	yyvs29.put (yyval29, yyvsp29)
end
when 129 then
--|#line 1128 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1128")
end

			if valid_iso8601_date_time(yyvs4.item (yyvsp4)) then
				create yyval9.make_from_string(yyvs4.item (yyvsp4))
			else
				abort_with_error("VIDTV", <<yyvs4.item (yyvsp4)>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp4 := yyvsp4 -1
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
when 130 then
--|#line 1138 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1138")
end

			create yyval24.make(0)
			yyval24.extend(yyvs9.item (yyvsp9 - 1))
			yyval24.extend(yyvs9.item (yyvsp9))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp24 := yyvsp24 + 1
	yyvsp9 := yyvsp9 -2
	yyvsp1 := yyvsp1 -1
	if yyvsp24 >= yyvsc24 then
		if yyvs24 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs24")
			end
			create yyspecial_routines24
			yyvsc24 := yyInitial_yyvs_size
			yyvs24 := yyspecial_routines24.make (yyvsc24)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs24")
			end
			yyvsc24 := yyvsc24 + yyInitial_yyvs_size
			yyvs24 := yyspecial_routines24.resize (yyvs24, yyvsc24)
		end
	end
	yyvs24.put (yyval24, yyvsp24)
end
when 131 then
--|#line 1144 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1144")
end

			yyvs24.item (yyvsp24).extend(yyvs9.item (yyvsp9))
			yyval24 := yyvs24.item (yyvsp24)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp9 := yyvsp9 -1
	yyvs24.put (yyval24, yyvsp24)
end
when 132 then
--|#line 1149 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1149")
end

			create yyval24.make(0)
			yyval24.extend(yyvs9.item (yyvsp9))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp24 := yyvsp24 + 1
	yyvsp9 := yyvsp9 -1
	yyvsp1 := yyvsp1 -2
	if yyvsp24 >= yyvsc24 then
		if yyvs24 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs24")
			end
			create yyspecial_routines24
			yyvsc24 := yyInitial_yyvs_size
			yyvs24 := yyspecial_routines24.make (yyvsc24)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs24")
			end
			yyvsc24 := yyvsc24 + yyInitial_yyvs_size
			yyvs24 := yyspecial_routines24.resize (yyvs24, yyvsc24)
		end
	end
	yyvs24.put (yyval24, yyvsp24)
end
when 133 then
--|#line 1156 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1156")
end

			if yyvs9.item (yyvsp9 - 1) <= yyvs9.item (yyvsp9) then
				create date_time_interval.make_bounded(yyvs9.item (yyvsp9 - 1), yyvs9.item (yyvsp9), True, True)
				yyval31 := date_time_interval
			else
				abort_with_error("VIVLO", <<yyvs9.item (yyvsp9 - 1).out, yyvs9.item (yyvsp9).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp31 := yyvsp31 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp9 := yyvsp9 -2
	if yyvsp31 >= yyvsc31 then
		if yyvs31 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs31")
			end
			create yyspecial_routines31
			yyvsc31 := yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.make (yyvsc31)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs31")
			end
			yyvsc31 := yyvsc31 + yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.resize (yyvs31, yyvsc31)
		end
	end
	yyvs31.put (yyval31, yyvsp31)
end
when 134 then
--|#line 1165 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1165")
end

			if yyvs9.item (yyvsp9 - 1) <= yyvs9.item (yyvsp9) then
				create date_time_interval.make_bounded(yyvs9.item (yyvsp9 - 1), yyvs9.item (yyvsp9), False, True)
				yyval31 := date_time_interval
			else
				abort_with_error("VIVLO", <<yyvs9.item (yyvsp9 - 1).out, yyvs9.item (yyvsp9).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp31 := yyvsp31 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp9 := yyvsp9 -2
	if yyvsp31 >= yyvsc31 then
		if yyvs31 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs31")
			end
			create yyspecial_routines31
			yyvsc31 := yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.make (yyvsc31)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs31")
			end
			yyvsc31 := yyvsc31 + yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.resize (yyvs31, yyvsc31)
		end
	end
	yyvs31.put (yyval31, yyvsp31)
end
when 135 then
--|#line 1174 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1174")
end

			if yyvs9.item (yyvsp9 - 1) <= yyvs9.item (yyvsp9) then
				create date_time_interval.make_bounded(yyvs9.item (yyvsp9 - 1), yyvs9.item (yyvsp9), True, False)
				yyval31 := date_time_interval
			else
				abort_with_error("VIVLO", <<yyvs9.item (yyvsp9 - 1).out, yyvs9.item (yyvsp9).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp31 := yyvsp31 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp9 := yyvsp9 -2
	if yyvsp31 >= yyvsc31 then
		if yyvs31 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs31")
			end
			create yyspecial_routines31
			yyvsc31 := yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.make (yyvsc31)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs31")
			end
			yyvsc31 := yyvsc31 + yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.resize (yyvs31, yyvsc31)
		end
	end
	yyvs31.put (yyval31, yyvsp31)
end
when 136 then
--|#line 1183 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1183")
end

			if yyvs9.item (yyvsp9 - 1) <= yyvs9.item (yyvsp9) then
				create date_time_interval.make_bounded(yyvs9.item (yyvsp9 - 1), yyvs9.item (yyvsp9), False, False)
				yyval31 := date_time_interval
			else
				abort_with_error("VIVLO", <<yyvs9.item (yyvsp9 - 1).out, yyvs9.item (yyvsp9).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 7
	yyvsp31 := yyvsp31 + 1
	yyvsp1 := yyvsp1 -5
	yyvsp9 := yyvsp9 -2
	if yyvsp31 >= yyvsc31 then
		if yyvs31 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs31")
			end
			create yyspecial_routines31
			yyvsc31 := yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.make (yyvsc31)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs31")
			end
			yyvsc31 := yyvsc31 + yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.resize (yyvs31, yyvsc31)
		end
	end
	yyvs31.put (yyval31, yyvsp31)
end
when 137 then
--|#line 1192 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1192")
end

			create date_time_interval.make_lower_unbounded(yyvs9.item (yyvsp9), False)
			yyval31 := date_time_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp31 := yyvsp31 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp9 := yyvsp9 -1
	if yyvsp31 >= yyvsc31 then
		if yyvs31 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs31")
			end
			create yyspecial_routines31
			yyvsc31 := yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.make (yyvsc31)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs31")
			end
			yyvsc31 := yyvsc31 + yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.resize (yyvs31, yyvsc31)
		end
	end
	yyvs31.put (yyval31, yyvsp31)
end
when 138 then
--|#line 1197 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1197")
end

			create date_time_interval.make_lower_unbounded(yyvs9.item (yyvsp9), True)
			yyval31 := date_time_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp31 := yyvsp31 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp9 := yyvsp9 -1
	if yyvsp31 >= yyvsc31 then
		if yyvs31 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs31")
			end
			create yyspecial_routines31
			yyvsc31 := yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.make (yyvsc31)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs31")
			end
			yyvsc31 := yyvsc31 + yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.resize (yyvs31, yyvsc31)
		end
	end
	yyvs31.put (yyval31, yyvsp31)
end
when 139 then
--|#line 1202 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1202")
end

			create date_time_interval.make_upper_unbounded(yyvs9.item (yyvsp9), False)
			yyval31 := date_time_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp31 := yyvsp31 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp9 := yyvsp9 -1
	if yyvsp31 >= yyvsc31 then
		if yyvs31 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs31")
			end
			create yyspecial_routines31
			yyvsc31 := yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.make (yyvsc31)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs31")
			end
			yyvsc31 := yyvsc31 + yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.resize (yyvs31, yyvsc31)
		end
	end
	yyvs31.put (yyval31, yyvsp31)
end
when 140 then
--|#line 1207 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1207")
end

			create date_time_interval.make_upper_unbounded(yyvs9.item (yyvsp9), True)
			yyval31 := date_time_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp31 := yyvsp31 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp9 := yyvsp9 -1
	if yyvsp31 >= yyvsc31 then
		if yyvs31 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs31")
			end
			create yyspecial_routines31
			yyvsc31 := yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.make (yyvsc31)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs31")
			end
			yyvsc31 := yyvsc31 + yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.resize (yyvs31, yyvsc31)
		end
	end
	yyvs31.put (yyval31, yyvsp31)
end
when 141 then
--|#line 1212 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1212")
end

			create date_time_interval.make_point(yyvs9.item (yyvsp9))
			yyval31 := date_time_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp31 := yyvsp31 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp9 := yyvsp9 -1
	if yyvsp31 >= yyvsc31 then
		if yyvs31 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs31")
			end
			create yyspecial_routines31
			yyvsc31 := yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.make (yyvsc31)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs31")
			end
			yyvsc31 := yyvsc31 + yyInitial_yyvs_size
			yyvs31 := yyspecial_routines31.resize (yyvs31, yyvsc31)
		end
	end
	yyvs31.put (yyval31, yyvsp31)
end
when 142 then
--|#line 1219 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1219")
end

			if valid_iso8601_duration(yyvs4.item (yyvsp4)) then
				create yyval11.make_from_string(yyvs4.item (yyvsp4))
			else
				abort_with_error("VIDUV", <<yyvs4.item (yyvsp4)>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp11 := yyvsp11 + 1
	yyvsp4 := yyvsp4 -1
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
when 143 then
--|#line 1229 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1229")
end

			create yyval25.make(0)
			yyval25.extend(yyvs11.item (yyvsp11 - 1))
			yyval25.extend(yyvs11.item (yyvsp11))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp25 := yyvsp25 + 1
	yyvsp11 := yyvsp11 -2
	yyvsp1 := yyvsp1 -1
	if yyvsp25 >= yyvsc25 then
		if yyvs25 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs25")
			end
			create yyspecial_routines25
			yyvsc25 := yyInitial_yyvs_size
			yyvs25 := yyspecial_routines25.make (yyvsc25)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs25")
			end
			yyvsc25 := yyvsc25 + yyInitial_yyvs_size
			yyvs25 := yyspecial_routines25.resize (yyvs25, yyvsc25)
		end
	end
	yyvs25.put (yyval25, yyvsp25)
end
when 144 then
--|#line 1235 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1235")
end

			yyvs25.item (yyvsp25).extend(yyvs11.item (yyvsp11))
			yyval25 := yyvs25.item (yyvsp25)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp11 := yyvsp11 -1
	yyvs25.put (yyval25, yyvsp25)
end
when 145 then
--|#line 1240 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1240")
end

			create yyval25.make(0)
			yyval25.extend(yyvs11.item (yyvsp11))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp25 := yyvsp25 + 1
	yyvsp11 := yyvsp11 -1
	yyvsp1 := yyvsp1 -2
	if yyvsp25 >= yyvsc25 then
		if yyvs25 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs25")
			end
			create yyspecial_routines25
			yyvsc25 := yyInitial_yyvs_size
			yyvs25 := yyspecial_routines25.make (yyvsc25)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs25")
			end
			yyvsc25 := yyvsc25 + yyInitial_yyvs_size
			yyvs25 := yyspecial_routines25.resize (yyvs25, yyvsc25)
		end
	end
	yyvs25.put (yyval25, yyvsp25)
end
when 146 then
--|#line 1247 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1247")
end

			if yyvs11.item (yyvsp11 - 1) <= yyvs11.item (yyvsp11) then
				create duration_interval.make_bounded(yyvs11.item (yyvsp11 - 1), yyvs11.item (yyvsp11), True, True)
				yyval32 := duration_interval
			else
				abort_with_error("VIVLO", <<yyvs11.item (yyvsp11 - 1).out, yyvs11.item (yyvsp11).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp11 := yyvsp11 -2
	if yyvsp32 >= yyvsc32 then
		if yyvs32 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs32")
			end
			create yyspecial_routines32
			yyvsc32 := yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.make (yyvsc32)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs32")
			end
			yyvsc32 := yyvsc32 + yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.resize (yyvs32, yyvsc32)
		end
	end
	yyvs32.put (yyval32, yyvsp32)
end
when 147 then
--|#line 1256 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1256")
end

			if yyvs11.item (yyvsp11 - 1) <= yyvs11.item (yyvsp11) then
				create duration_interval.make_bounded(yyvs11.item (yyvsp11 - 1), yyvs11.item (yyvsp11), False, True)
				yyval32 := duration_interval
			else
				abort_with_error("VIVLO", <<yyvs11.item (yyvsp11 - 1).out, yyvs11.item (yyvsp11).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp11 := yyvsp11 -2
	if yyvsp32 >= yyvsc32 then
		if yyvs32 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs32")
			end
			create yyspecial_routines32
			yyvsc32 := yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.make (yyvsc32)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs32")
			end
			yyvsc32 := yyvsc32 + yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.resize (yyvs32, yyvsc32)
		end
	end
	yyvs32.put (yyval32, yyvsp32)
end
when 148 then
--|#line 1265 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1265")
end

			if yyvs11.item (yyvsp11 - 1) <= yyvs11.item (yyvsp11) then
				create duration_interval.make_bounded(yyvs11.item (yyvsp11 - 1), yyvs11.item (yyvsp11), True, False)
				yyval32 := duration_interval
			else
				abort_with_error("VIVLO", <<yyvs11.item (yyvsp11 - 1).out, yyvs11.item (yyvsp11).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp11 := yyvsp11 -2
	if yyvsp32 >= yyvsc32 then
		if yyvs32 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs32")
			end
			create yyspecial_routines32
			yyvsc32 := yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.make (yyvsc32)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs32")
			end
			yyvsc32 := yyvsc32 + yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.resize (yyvs32, yyvsc32)
		end
	end
	yyvs32.put (yyval32, yyvsp32)
end
when 149 then
--|#line 1274 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1274")
end

			if yyvs11.item (yyvsp11 - 1) <= yyvs11.item (yyvsp11) then
				create duration_interval.make_bounded(yyvs11.item (yyvsp11 - 1), yyvs11.item (yyvsp11), False, False)
				yyval32 := duration_interval
			else
				abort_with_error("VIVLO", <<yyvs11.item (yyvsp11 - 1).out, yyvs11.item (yyvsp11).out>>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 7
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -5
	yyvsp11 := yyvsp11 -2
	if yyvsp32 >= yyvsc32 then
		if yyvs32 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs32")
			end
			create yyspecial_routines32
			yyvsc32 := yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.make (yyvsc32)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs32")
			end
			yyvsc32 := yyvsc32 + yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.resize (yyvs32, yyvsc32)
		end
	end
	yyvs32.put (yyval32, yyvsp32)
end
when 150 then
--|#line 1283 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1283")
end

			create duration_interval.make_lower_unbounded(yyvs11.item (yyvsp11), False)
			yyval32 := duration_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp11 := yyvsp11 -1
	if yyvsp32 >= yyvsc32 then
		if yyvs32 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs32")
			end
			create yyspecial_routines32
			yyvsc32 := yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.make (yyvsc32)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs32")
			end
			yyvsc32 := yyvsc32 + yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.resize (yyvs32, yyvsc32)
		end
	end
	yyvs32.put (yyval32, yyvsp32)
end
when 151 then
--|#line 1288 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1288")
end

			create duration_interval.make_lower_unbounded(yyvs11.item (yyvsp11), True)
			yyval32 := duration_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp11 := yyvsp11 -1
	if yyvsp32 >= yyvsc32 then
		if yyvs32 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs32")
			end
			create yyspecial_routines32
			yyvsc32 := yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.make (yyvsc32)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs32")
			end
			yyvsc32 := yyvsc32 + yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.resize (yyvs32, yyvsc32)
		end
	end
	yyvs32.put (yyval32, yyvsp32)
end
when 152 then
--|#line 1293 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1293")
end

			create duration_interval.make_upper_unbounded(yyvs11.item (yyvsp11), False)
			yyval32 := duration_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp11 := yyvsp11 -1
	if yyvsp32 >= yyvsc32 then
		if yyvs32 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs32")
			end
			create yyspecial_routines32
			yyvsc32 := yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.make (yyvsc32)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs32")
			end
			yyvsc32 := yyvsc32 + yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.resize (yyvs32, yyvsc32)
		end
	end
	yyvs32.put (yyval32, yyvsp32)
end
when 153 then
--|#line 1298 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1298")
end

			create duration_interval.make_upper_unbounded(yyvs11.item (yyvsp11), True)
			yyval32 := duration_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp11 := yyvsp11 -1
	if yyvsp32 >= yyvsc32 then
		if yyvs32 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs32")
			end
			create yyspecial_routines32
			yyvsc32 := yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.make (yyvsc32)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs32")
			end
			yyvsc32 := yyvsc32 + yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.resize (yyvs32, yyvsc32)
		end
	end
	yyvs32.put (yyval32, yyvsp32)
end
when 154 then
--|#line 1303 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1303")
end

			create duration_interval.make_point(yyvs11.item (yyvsp11))
			yyval32 := duration_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp11 := yyvsp11 -1
	if yyvsp32 >= yyvsc32 then
		if yyvs32 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs32")
			end
			create yyspecial_routines32
			yyvsc32 := yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.make (yyvsc32)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs32")
			end
			yyvsc32 := yyvsc32 + yyInitial_yyvs_size
			yyvs32 := yyspecial_routines32.resize (yyvs32, yyvsc32)
		end
	end
	yyvs32.put (yyval32, yyvsp32)
end
when 155 then
--|#line 1313 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1313")
end

debug("dADL_parse")
	io.put_string(indent + "object_reference_block; attr_nodes(<<" + 
			attr_nodes.item.rm_attr_name + ">>).item.put_child(<<" + 
			yyvs13.item (yyvsp13).as_string + ">>)%N")
end
			if not attr_nodes.item.has_child_with_id(yyvs13.item (yyvsp13).node_id) then
				attr_nodes.item.put_child(yyvs13.item (yyvsp13))
				yyval13 := yyvs13.item (yyvsp13)
			else
				abort_with_error("VOKU", <<yyvs13.item (yyvsp13).node_id, attr_nodes.item.rm_attr_name >>)
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs13.put (yyval13, yyvsp13)
end
when 156 then
--|#line 1329 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1329")
end

			if obj_id /= Void then
				create {DT_OBJECT_REFERENCE} yyval13.make_identified(yyvs14.item (yyvsp14), obj_id)
				obj_id := Void
			else
				create {DT_OBJECT_REFERENCE} yyval13.make_anonymous(yyvs14.item (yyvsp14))
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp13 := yyvsp13 + 1
	yyvsp14 := yyvsp14 -1
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
when 157 then
--|#line 1338 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1338")
end

			if obj_id /= Void then
				create {DT_OBJECT_REFERENCE_LIST} yyval13.make_identified(yyvs16.item (yyvsp16), obj_id)
				obj_id := Void
			else
				create {DT_OBJECT_REFERENCE_LIST} yyval13.make_anonymous(yyvs16.item (yyvsp16))
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp13 := yyvsp13 + 1
	yyvsp16 := yyvsp16 -1
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
when 158 then
--|#line 1350 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1350")
end

			create yyval16.make(0)
			yyval16.extend(yyvs14.item (yyvsp14 - 1))
			yyval16.extend(yyvs14.item (yyvsp14))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp16 := yyvsp16 + 1
	yyvsp14 := yyvsp14 -2
	yyvsp1 := yyvsp1 -1
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
when 159 then
--|#line 1356 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1356")
end

			yyvs16.item (yyvsp16).extend(yyvs14.item (yyvsp14))
			yyval16 := yyvs16.item (yyvsp16)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp14 := yyvsp14 -1
	yyvs16.put (yyval16, yyvsp16)
end
when 160 then
--|#line 1361 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1361")
end

			create yyval16.make(0)
			yyval16.extend(yyvs14.item (yyvsp14))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp16 := yyvsp16 + 1
	yyvsp14 := yyvsp14 -1
	yyvsp1 := yyvsp1 -2
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
when 161 then
--|#line 1373 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1373")
end

			create yyval14.make_root
debug("OG_PATH_parse")
	io.put_string("....absolute_path (root); %N")
end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp14 := yyvsp14 + 1
	yyvsp1 := yyvsp1 -1
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
when 162 then
--|#line 1380 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1380")
end

			yyval14 := yyvs14.item (yyvsp14)
			yyval14.set_absolute
debug("OG_PATH_parse")
	io.put_string("....absolute_path; %N")
end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs14.put (yyval14, yyvsp14)
end
when 163 then
--|#line 1388 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1388")
end

			yyval14 := yyvs14.item (yyvsp14 - 1)
			yyval14.append_path(yyvs14.item (yyvsp14))
debug("OG_PATH_parse")
	io.put_string("....absolute_path (appended relative path); %N")
end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp14 := yyvsp14 -1
	yyvsp1 := yyvsp1 -1
	yyvs14.put (yyval14, yyvsp14)
end
when 164 then
--|#line 1398 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1398")
end

			create yyval14.make_relative(yyvs15.item (yyvsp15))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp14 := yyvsp14 + 1
	yyvsp15 := yyvsp15 -1
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
when 165 then
--|#line 1402 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1402")
end

			yyval14 := yyvs14.item (yyvsp14)
			yyval14.append_segment(yyvs15.item (yyvsp15))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp15 := yyvsp15 -1
	yyvs14.put (yyval14, yyvsp14)
end
when 166 then
--|#line 1409 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1409")
end

			create yyval15.make_with_object_id(yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4))
debug("OG_PATH_parse")
	io.put_string("...path_segment: " + yyvs4.item (yyvsp4 - 1) + "[" + yyvs4.item (yyvsp4) + "]%N")
end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp15 := yyvsp15 + 1
	yyvsp4 := yyvsp4 -2
	yyvsp1 := yyvsp1 -2
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
when 167 then
--|#line 1416 "dadl_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl_validator.y' at line 1416")
end

			create yyval15.make(yyvs4.item (yyvsp4))
debug("OG_PATH_parse")
	io.put_string("...path_segment: " + yyvs4.item (yyvsp4) + "%N")
end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp15 := yyvsp15 + 1
	yyvsp4 := yyvsp4 -1
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
			else
				debug ("GEYACC")
					std.error.put_string ("Error in parser: unknown rule id: ")
					std.error.put_integer (yy_act)
					std.error.put_new_line
				end
				abort
			end
		end

	yy_do_error_action (yy_act: INTEGER)
			-- Execute error action.
		do
			inspect yy_act
			when 309 then
					-- End-of-file expected action.
				report_eof_expected_error
			else
					-- Default action.
				report_error ("parse error")
			end
		end

feature {NONE} -- Table templates

	yytranslate_template: SPECIAL [INTEGER]
			-- Template for `yytranslate'
		once
			Result := yyfixed_array (<<
			    0,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			   40,   41,    2,   43,   42,   44,    2,   45,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,   37,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,   38,    2,   39,    2,    2,    2,    2,    2,    2,

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
			   25,   26,   27,   28,   29,   30,   31,   32,   33,   34,
			   35,   36, yyDummy>>)
		end

	yyr1_template: SPECIAL [INTEGER]
			-- Template for `yyr1'
		once
			Result := yyfixed_array (<<
			    0,   86,   86,   86,   87,   87,   87,   88,   89,   89,
			   90,   90,   90,   59,   59,   57,   57,   58,   91,   92,
			   92,   93,   94,   55,   55,   56,   56,   96,   61,   61,
			   60,   63,   63,   63,   95,   95,   95,   95,   95,   95,
			   95,   95,   95,   78,   78,   78,   78,   78,   78,   78,
			   78,   78,   85,   85,   85,   85,   85,   85,   46,   46,
			   97,   69,   69,   69,   47,   47,   47,   70,   70,   70,
			   79,   79,   79,   79,   79,   79,   79,   79,   79,   48,
			   48,   48,   71,   71,   71,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   49,   49,   73,   73,   73,   50,

			   72,   72,   72,   51,   74,   74,   74,   82,   82,   82,
			   82,   82,   82,   82,   82,   82,   53,   75,   75,   75,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   52,
			   76,   76,   76,   83,   83,   83,   83,   83,   83,   83,
			   83,   83,   54,   77,   77,   77,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   62,   64,   64,   68,   68,
			   68,   65,   65,   65,   66,   66,   67,   67, yyDummy>>)
		end

	yytypes1_template: SPECIAL [INTEGER]
			-- Template for `yytypes1'
		once
			Result := yyfixed_array (<<
			    1,    1,    1,    4,    1,    4,   12,   12,   12,   12,
			   12,    1,    1,    1,    1,    1,    4,    4,    1,   12,
			   12,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    4,   12,   13,   13,   13,    1,
			    1,    1,    1,    1,    5,    4,    4,    4,    4,    4,
			    3,    2,    2,    3,    7,    5,    8,    9,   10,   11,
			    1,    1,    1,    1,    1,    1,    1,    1,    4,    2,
			    3,    7,    5,    8,    9,   10,   11,   13,   13,   14,
			   16,   17,   18,   19,   20,   21,   22,   23,   24,   25,
			   26,   27,   28,   29,   30,   31,   32,   34,    1,    1,

			   13,    3,    2,    3,    2,    1,    1,    4,   14,   15,
			    1,    1,    1,    1,    2,    3,    8,    9,   10,   11,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    2,    3,    8,    9,   10,
			   11,    2,    3,    8,    9,   10,   11,    2,    3,    8,
			    9,   10,   11,    2,    3,    8,    9,   10,   11,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    4,    1,    1,    1,    2,    1,    1,    1,
			    3,    1,    7,    1,    5,    1,    8,    1,    9,    1,

			   10,    1,   11,   14,    1,   14,   14,    4,    2,    3,
			    5,    7,    8,   10,    9,   11,    4,   15,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			    1,    3,    1,    8,    1,    9,    1,   10,    1,   11,
			    1,    1,    2,    1,    3,    1,    8,    1,    9,    1,
			   10,    1,   11,    2,    1,    3,    1,    8,    1,    9,
			    1,   10,    1,   11,    1,    2,    1,    3,    1,    8,
			    1,    9,    1,   10,    1,   11,    1,    1,    1,    1,

			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1, yyDummy>>)
		end

	yytypes2_template: SPECIAL [INTEGER]
			-- Template for `yytypes2'
		once
			Result := yyfixed_array (<<
			    1,    1,    1,    2,    3,    4,    4,    4,    4,    4,
			    4,    4,    4,    4,    4,    4,    4,    5,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    4,    4,    1,    1,    1,
			    1,    1,    1,    1,    1,    1, yyDummy>>)
		end

	yydefact_template: SPECIAL [INTEGER]
			-- Template for `yydefact'
		once
			Result := yyfixed_array (<<
			    0,    0,   27,    0,    3,    0,   13,   23,   14,   15,
			    2,    1,    4,    0,    0,    0,    0,    0,    9,   24,
			   16,    0,    5,    0,    0,    0,   19,    0,   25,    0,
			   59,   58,    6,   27,    0,   10,   28,   11,   12,    7,
			    0,    0,   95,   94,   99,  142,  129,  116,  103,   60,
			   79,   64,   35,   36,   37,   38,   39,   41,   40,   42,
			    0,   34,   17,   20,    0,   26,  161,    0,   60,   35,
			   36,   37,   38,   39,   41,   40,   42,    0,    0,  156,
			  157,   43,   44,   45,   47,   46,   48,   49,   50,   51,
			   32,   52,   53,   55,   54,   56,   57,   33,   31,   27,

			   29,   81,   66,   80,   65,   22,   21,  167,  162,  164,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,   30,
			  155,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,   78,
			    0,   93,    0,  115,    0,  141,    0,  128,    0,  154,
			    0,   63,   61,    0,    0,   69,   67,    0,    0,   84,
			   82,   98,   96,  102,  100,  106,  104,  132,  130,  119,

			  117,  145,  143,  163,  160,  158,  159,   62,   68,   83,
			  101,   97,  105,  118,  131,  144,    0,  165,   77,   92,
			  114,  140,  127,  153,   75,   90,  112,  138,  125,  151,
			   76,    0,   91,    0,  113,    0,  139,    0,  126,    0,
			  152,    0,   74,   89,  111,  137,  124,  150,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			  166,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,   70,    0,   85,    0,  107,    0,
			  133,    0,  120,    0,  146,    0,   71,    0,   86,    0,
			  108,    0,  134,    0,  121,    0,  147,   72,   87,  109,

			  135,  122,  148,   73,   88,  110,  136,  123,  149,    0,
			    0,    0, yyDummy>>)
		end

	yydefgoto_template: SPECIAL [INTEGER]
			-- Template for `yydefgoto'
		once
			Result := yyfixed_array (<<
			   34,   69,   70,   71,   72,   73,   74,   75,   76,    6,
			    7,    8,    9,   35,   36,   37,   38,   77,   78,   79,
			  108,  109,   80,   81,   82,   83,   84,   85,   86,   87,
			   88,   89,   90,   91,   92,   93,   94,   95,   96,   97,
			  309,   11,   12,   13,   39,   14,   25,   26,   27,   98,
			   15,   61, yyDummy>>)
		end

	yypact_template: SPECIAL [INTEGER]
			-- Template for `yypact'
		once
			Result := yyfixed_array (<<
			  215,  209,  331,  132, -32768,  338, -32768, -32768, -32768, -32768,
			 -32768,   -1, -32768,  333,  330,  180,  329,  326, -32768, -32768,
			 -32768,  328, -32768,   30,  201,   46, -32768,  327, -32768,    0,
			 -32768, -32768, -32768,   14,  325, -32768, -32768, -32768, -32768, -32768,
			  192,    7, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			  300, -32768, -32768, -32768,   30, -32768,  305,  163,  324,  323,
			  322,  321,  320,  319,  318,  317,  316,  315,  314,  233,
			  313,  312,  310,  309,  308,  307,  304,  303,  302,  299,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,  127,

			 -32768, -32768, -32768, -32768, -32768, -32768, -32768,  298,  251, -32768,
			   65,   65,   65,   65,  253,  249,  247,  242,  241,  237,
			   -7,   10,  139,  175,  133,  168,  178,   -8,  176, -32768,
			 -32768,  305,   -6,  297,  311,   18,   29,  301,  122,  274,
			  229,  270,  145,  306,  305,  296,  293,  292,  291,  289,
			  287,  286,  285,  284,  283,  282,  281,  236,  222,  211,
			  205,   82,   81,  280,  279,  278,  277,  276,  275, -32768,
			    6, -32768,  141, -32768,   51, -32768,  136, -32768,  131, -32768,
			  151, -32768, -32768,  295,  294, -32768, -32768,  290,  288, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,

			 -32768, -32768, -32768,  251, -32768,  250,  250, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768,  254, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768,    2, -32768,   38, -32768,   35, -32768,  100, -32768,   57,
			 -32768,   52, -32768, -32768, -32768, -32768, -32768, -32768,   18,  267,
			   29,  266,  274,  265,  270,  264,  229,  263,  145,  262,
			 -32768,   18,  261,   29,  260,  274,  258,  270,  256,  229,
			  255,  145,  252,  245, -32768,  240, -32768,  232, -32768,  228,
			 -32768,  226, -32768,  224, -32768,  217, -32768,  207, -32768,  206,
			 -32768,  196, -32768,  184, -32768,  156, -32768, -32768, -32768, -32768,

			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,  203,
			    3, -32768, yyDummy>>)
		end

	yypgoto_template: SPECIAL [INTEGER]
			-- Template for `yypgoto'
		once
			Result := yyfixed_array (<<
			  340,   11,    4,   -4,    5,  -12,  -16,  -20,  -24, -32768,
			   78, -32768,   22,  337,  339, -32768, -32768, -32768, -32768,   92,
			  191,  179, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768,  357,  157, -32768,  257, -32768, -32768,  332, -32768,  347,
			 -32768, -32768, yyDummy>>)
		end

	yytable_template: SPECIAL [INTEGER]
			-- Template for `yytable'
		once
			Result := yyfixed_array (<<
			   59,  182,   47,  311,   58,   51,    3,    3,   57,   51,
			  104,  103,   56,   51,  199,  181,  204,   51,   50,   65,
			   54,   51,   68,   48,   47,   46,   45,   20,   53,   55,
			  261,   44,  185,   50,  248,   52,   21,   21,   67,   66,
			   43,   42,   50,  119,   48,  184,  183,  118,   33,  184,
			  183,  117,  -18,  184,  183,  116,   20,   41,   40,   66,
			   48,  184,  183,  265,   45,   62,  263,   47,   51,   50,
			    1,  115,  188,  187,   48,   47,   46,   45,  114,  252,
			  271,  188,  187,   19,   24,  269,  150,  156,  162,  168,
			  149,  155,  161,  167,  148,  154,  160,  166,  147,  153,

			  159,  165,  241,  239,  202,  240,  238,  200,   41,   40,
			  198,   46,   19,  196,  146,  152,  158,  164,  215,  192,
			  213,  145,  151,  157,  163,  214,  190,  212,  267,  194,
			   51,   50,  186,   18,  211,   68,   48,   47,   46,   45,
			  209,   47,  210,   50,   44,   50,  208,   46,   43,   42,
			   44,   67,   -8,   43,   42,  193,  259,   45,  257,  256,
			  255,  189,  253,   45,  254,  -18,   51,   50,   22,  250,
			   41,   40,   48,   47,   46,   45,  251,   48,   32,  258,
			  308,  249,  188,  187,  188,  187,   22,    3,   45,   46,
			  195,  113,  112,  111,  110,  102,  101,  191,  201,   28,

			  197,   43,   42,  310,   51,   50,   41,   40,  307,   49,
			   48,   47,   46,   45,   17,   16,    4,  272,   44,  270,
			  306,  268,    3,  266,  205,  206,  237,   43,   42,  236,
			  305,  304,  235,    2,  283,  234,  281,  264,  279,   47,
			  277,  303,  262,  233,   41,   40,  232,  295,  302,  293,
			  301,  291,  300,  289,  275,    1,  299,  231,  180,  273,
			  230,  179,  178,  176,  298,  177,  175,  287,  174,  297,
			  172,  173,  285,  171,  170,  132,  296,  169,  131,  294,
			  292,   46,  290,   48,  288,  286,  284,  282,  280,  278,
			  276,  274,  103,  260,  101,  131,  144,  104,  102,  247,

			  246,  245,  244,  243,  242,  229,  228,  227,  226,  225,
			  224,  223,  107,  222,  216,  221,  220,  219,   44,  207,
			  218,  106,  203,  217,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,  130,  129,    3,  143,   10,    0,  105,
			    5,  142,   66,   99,  141,  140,  139,   64,    0,  138,
			  137,  136,  135,   23,  134,  133,    2,   63,  128,  127,
			  126,  125,  124,  123,  122,  121,  120,   31,   24,  -18,
			   30,   60,   29,  100, yyDummy>>)
		end

	yycheck_template: SPECIAL [INTEGER]
			-- Template for `yycheck'
		once
			Result := yyfixed_array (<<
			   24,    8,   10,    0,   24,    3,    7,    7,   24,    3,
			    3,    4,   24,    3,   22,   22,   22,    3,    4,   19,
			   24,    3,    8,    9,   10,   11,   12,    5,   24,   24,
			   28,   17,   22,    4,   28,   24,   37,   37,   24,   45,
			   26,   27,    4,   67,    9,   43,   44,   67,   18,   43,
			   44,   67,   38,   43,   44,   67,   34,   43,   44,   45,
			    9,   43,   44,   28,   12,   19,   28,   10,    3,    4,
			   40,   67,   43,   44,    9,   10,   11,   12,   67,   28,
			   28,   43,   44,    5,   38,   28,  110,  111,  112,  113,
			  110,  111,  112,  113,  110,  111,  112,  113,  110,  111,

			  112,  113,   21,   21,  128,   24,   24,  127,   43,   44,
			  126,   11,   34,  125,  110,  111,  112,  113,  142,  123,
			  140,  110,  111,  112,  113,  141,  122,  139,   28,  124,
			    3,    4,  121,    1,  138,    8,    9,   10,   11,   12,
			  136,   10,  137,    4,   17,    4,  135,   11,   26,   27,
			   17,   24,   20,   26,   27,   22,  180,   12,  178,   28,
			  176,   22,  174,   12,   28,   38,    3,    4,   11,   28,
			   43,   44,    9,   10,   11,   12,  172,    9,   21,   28,
			   24,  170,   43,   44,   43,   44,   29,    7,   12,   11,
			   22,   28,   29,   30,   31,    3,    4,   22,   22,   19,

			   22,   26,   27,    0,    3,    4,   43,   44,   24,    8,
			    9,   10,   11,   12,    5,    6,    1,  241,   17,  239,
			   24,  237,    7,  235,  132,  133,   21,   26,   27,   24,
			   24,   24,   21,   18,  258,   24,  256,  233,  254,   10,
			  252,   24,  231,   21,   43,   44,   24,  271,   24,  269,
			   24,  267,   24,  265,  250,   40,   24,   21,   21,  248,
			   24,   24,   21,   21,   24,   24,   24,  263,   21,   24,
			   21,   24,  261,   24,   21,   42,   24,   24,   45,   24,
			   24,   11,   24,    9,   24,   24,   24,   24,   24,   24,
			   24,   24,    4,   39,    4,   45,   45,    3,    3,   24,

			   24,   24,   24,   24,   24,   24,   24,   24,   24,   24,
			   24,   24,    7,   24,    8,   24,   24,   24,   17,    8,
			   24,   64,  131,  144,   -1,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   19,   19,    7,   38,    0,   -1,   39,
			    0,   42,   45,   18,   42,   42,   42,   20,   -1,   42,
			   42,   42,   42,   20,   42,   42,   18,   25,   42,   42,
			   42,   42,   42,   42,   42,   42,   42,   41,   38,   38,
			   41,   24,   15,   34, yyDummy>>)
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

	yyvs2: SPECIAL [INTEGER]
			-- Stack for semantic values of type INTEGER

	yyvsc2: INTEGER
			-- Capacity of semantic value stack `yyvs2'

	yyvsp2: INTEGER
			-- Top of semantic value stack `yyvs2'

	yyspecial_routines2: KL_SPECIAL_ROUTINES [INTEGER]
			-- Routines that ought to be in SPECIAL [INTEGER]

	yyvs3: SPECIAL [REAL]
			-- Stack for semantic values of type REAL

	yyvsc3: INTEGER
			-- Capacity of semantic value stack `yyvs3'

	yyvsp3: INTEGER
			-- Top of semantic value stack `yyvs3'

	yyspecial_routines3: KL_SPECIAL_ROUTINES [REAL]
			-- Routines that ought to be in SPECIAL [REAL]

	yyvs4: SPECIAL [STRING]
			-- Stack for semantic values of type STRING

	yyvsc4: INTEGER
			-- Capacity of semantic value stack `yyvs4'

	yyvsp4: INTEGER
			-- Top of semantic value stack `yyvs4'

	yyspecial_routines4: KL_SPECIAL_ROUTINES [STRING]
			-- Routines that ought to be in SPECIAL [STRING]

	yyvs5: SPECIAL [CHARACTER]
			-- Stack for semantic values of type CHARACTER

	yyvsc5: INTEGER
			-- Capacity of semantic value stack `yyvs5'

	yyvsp5: INTEGER
			-- Top of semantic value stack `yyvs5'

	yyspecial_routines5: KL_SPECIAL_ROUTINES [CHARACTER]
			-- Routines that ought to be in SPECIAL [CHARACTER]

	yyvs6: SPECIAL [NUMERIC]
			-- Stack for semantic values of type NUMERIC

	yyvsc6: INTEGER
			-- Capacity of semantic value stack `yyvs6'

	yyvsp6: INTEGER
			-- Top of semantic value stack `yyvs6'

	yyspecial_routines6: KL_SPECIAL_ROUTINES [NUMERIC]
			-- Routines that ought to be in SPECIAL [NUMERIC]

	yyvs7: SPECIAL [BOOLEAN]
			-- Stack for semantic values of type BOOLEAN

	yyvsc7: INTEGER
			-- Capacity of semantic value stack `yyvs7'

	yyvsp7: INTEGER
			-- Top of semantic value stack `yyvs7'

	yyspecial_routines7: KL_SPECIAL_ROUTINES [BOOLEAN]
			-- Routines that ought to be in SPECIAL [BOOLEAN]

	yyvs8: SPECIAL [ISO8601_DATE]
			-- Stack for semantic values of type ISO8601_DATE

	yyvsc8: INTEGER
			-- Capacity of semantic value stack `yyvs8'

	yyvsp8: INTEGER
			-- Top of semantic value stack `yyvs8'

	yyspecial_routines8: KL_SPECIAL_ROUTINES [ISO8601_DATE]
			-- Routines that ought to be in SPECIAL [ISO8601_DATE]

	yyvs9: SPECIAL [ISO8601_DATE_TIME]
			-- Stack for semantic values of type ISO8601_DATE_TIME

	yyvsc9: INTEGER
			-- Capacity of semantic value stack `yyvs9'

	yyvsp9: INTEGER
			-- Top of semantic value stack `yyvs9'

	yyspecial_routines9: KL_SPECIAL_ROUTINES [ISO8601_DATE_TIME]
			-- Routines that ought to be in SPECIAL [ISO8601_DATE_TIME]

	yyvs10: SPECIAL [ISO8601_TIME]
			-- Stack for semantic values of type ISO8601_TIME

	yyvsc10: INTEGER
			-- Capacity of semantic value stack `yyvs10'

	yyvsp10: INTEGER
			-- Top of semantic value stack `yyvs10'

	yyspecial_routines10: KL_SPECIAL_ROUTINES [ISO8601_TIME]
			-- Routines that ought to be in SPECIAL [ISO8601_TIME]

	yyvs11: SPECIAL [ISO8601_DURATION]
			-- Stack for semantic values of type ISO8601_DURATION

	yyvsc11: INTEGER
			-- Capacity of semantic value stack `yyvs11'

	yyvsp11: INTEGER
			-- Top of semantic value stack `yyvs11'

	yyspecial_routines11: KL_SPECIAL_ROUTINES [ISO8601_DURATION]
			-- Routines that ought to be in SPECIAL [ISO8601_DURATION]

	yyvs12: SPECIAL [DT_COMPLEX_OBJECT_NODE]
			-- Stack for semantic values of type DT_COMPLEX_OBJECT_NODE

	yyvsc12: INTEGER
			-- Capacity of semantic value stack `yyvs12'

	yyvsp12: INTEGER
			-- Top of semantic value stack `yyvs12'

	yyspecial_routines12: KL_SPECIAL_ROUTINES [DT_COMPLEX_OBJECT_NODE]
			-- Routines that ought to be in SPECIAL [DT_COMPLEX_OBJECT_NODE]

	yyvs13: SPECIAL [DT_OBJECT_LEAF]
			-- Stack for semantic values of type DT_OBJECT_LEAF

	yyvsc13: INTEGER
			-- Capacity of semantic value stack `yyvs13'

	yyvsp13: INTEGER
			-- Top of semantic value stack `yyvs13'

	yyspecial_routines13: KL_SPECIAL_ROUTINES [DT_OBJECT_LEAF]
			-- Routines that ought to be in SPECIAL [DT_OBJECT_LEAF]

	yyvs14: SPECIAL [OG_PATH]
			-- Stack for semantic values of type OG_PATH

	yyvsc14: INTEGER
			-- Capacity of semantic value stack `yyvs14'

	yyvsp14: INTEGER
			-- Top of semantic value stack `yyvs14'

	yyspecial_routines14: KL_SPECIAL_ROUTINES [OG_PATH]
			-- Routines that ought to be in SPECIAL [OG_PATH]

	yyvs15: SPECIAL [OG_PATH_ITEM]
			-- Stack for semantic values of type OG_PATH_ITEM

	yyvsc15: INTEGER
			-- Capacity of semantic value stack `yyvs15'

	yyvsp15: INTEGER
			-- Top of semantic value stack `yyvs15'

	yyspecial_routines15: KL_SPECIAL_ROUTINES [OG_PATH_ITEM]
			-- Routines that ought to be in SPECIAL [OG_PATH_ITEM]

	yyvs16: SPECIAL [ARRAYED_LIST [OG_PATH]]
			-- Stack for semantic values of type ARRAYED_LIST [OG_PATH]

	yyvsc16: INTEGER
			-- Capacity of semantic value stack `yyvs16'

	yyvsp16: INTEGER
			-- Top of semantic value stack `yyvs16'

	yyspecial_routines16: KL_SPECIAL_ROUTINES [ARRAYED_LIST [OG_PATH]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [OG_PATH]]

	yyvs17: SPECIAL [ARRAYED_LIST [STRING]]
			-- Stack for semantic values of type ARRAYED_LIST [STRING]

	yyvsc17: INTEGER
			-- Capacity of semantic value stack `yyvs17'

	yyvsp17: INTEGER
			-- Top of semantic value stack `yyvs17'

	yyspecial_routines17: KL_SPECIAL_ROUTINES [ARRAYED_LIST [STRING]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [STRING]]

	yyvs18: SPECIAL [ARRAYED_LIST [INTEGER]]
			-- Stack for semantic values of type ARRAYED_LIST [INTEGER]

	yyvsc18: INTEGER
			-- Capacity of semantic value stack `yyvs18'

	yyvsp18: INTEGER
			-- Top of semantic value stack `yyvs18'

	yyspecial_routines18: KL_SPECIAL_ROUTINES [ARRAYED_LIST [INTEGER]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [INTEGER]]

	yyvs19: SPECIAL [ARRAYED_LIST [REAL]]
			-- Stack for semantic values of type ARRAYED_LIST [REAL]

	yyvsc19: INTEGER
			-- Capacity of semantic value stack `yyvs19'

	yyvsp19: INTEGER
			-- Top of semantic value stack `yyvs19'

	yyspecial_routines19: KL_SPECIAL_ROUTINES [ARRAYED_LIST [REAL]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [REAL]]

	yyvs20: SPECIAL [ARRAYED_LIST [CHARACTER]]
			-- Stack for semantic values of type ARRAYED_LIST [CHARACTER]

	yyvsc20: INTEGER
			-- Capacity of semantic value stack `yyvs20'

	yyvsp20: INTEGER
			-- Top of semantic value stack `yyvs20'

	yyspecial_routines20: KL_SPECIAL_ROUTINES [ARRAYED_LIST [CHARACTER]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [CHARACTER]]

	yyvs21: SPECIAL [ARRAYED_LIST [BOOLEAN]]
			-- Stack for semantic values of type ARRAYED_LIST [BOOLEAN]

	yyvsc21: INTEGER
			-- Capacity of semantic value stack `yyvs21'

	yyvsp21: INTEGER
			-- Top of semantic value stack `yyvs21'

	yyspecial_routines21: KL_SPECIAL_ROUTINES [ARRAYED_LIST [BOOLEAN]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [BOOLEAN]]

	yyvs22: SPECIAL [ARRAYED_LIST [ISO8601_DATE]]
			-- Stack for semantic values of type ARRAYED_LIST [ISO8601_DATE]

	yyvsc22: INTEGER
			-- Capacity of semantic value stack `yyvs22'

	yyvsp22: INTEGER
			-- Top of semantic value stack `yyvs22'

	yyspecial_routines22: KL_SPECIAL_ROUTINES [ARRAYED_LIST [ISO8601_DATE]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [ISO8601_DATE]]

	yyvs23: SPECIAL [ARRAYED_LIST [ISO8601_TIME]]
			-- Stack for semantic values of type ARRAYED_LIST [ISO8601_TIME]

	yyvsc23: INTEGER
			-- Capacity of semantic value stack `yyvs23'

	yyvsp23: INTEGER
			-- Top of semantic value stack `yyvs23'

	yyspecial_routines23: KL_SPECIAL_ROUTINES [ARRAYED_LIST [ISO8601_TIME]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [ISO8601_TIME]]

	yyvs24: SPECIAL [ARRAYED_LIST [ISO8601_DATE_TIME]]
			-- Stack for semantic values of type ARRAYED_LIST [ISO8601_DATE_TIME]

	yyvsc24: INTEGER
			-- Capacity of semantic value stack `yyvs24'

	yyvsp24: INTEGER
			-- Top of semantic value stack `yyvs24'

	yyspecial_routines24: KL_SPECIAL_ROUTINES [ARRAYED_LIST [ISO8601_DATE_TIME]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [ISO8601_DATE_TIME]]

	yyvs25: SPECIAL [ARRAYED_LIST [ISO8601_DURATION]]
			-- Stack for semantic values of type ARRAYED_LIST [ISO8601_DURATION]

	yyvsc25: INTEGER
			-- Capacity of semantic value stack `yyvs25'

	yyvsp25: INTEGER
			-- Top of semantic value stack `yyvs25'

	yyspecial_routines25: KL_SPECIAL_ROUTINES [ARRAYED_LIST [ISO8601_DURATION]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [ISO8601_DURATION]]

	yyvs26: SPECIAL [ARRAYED_LIST [ANY]]
			-- Stack for semantic values of type ARRAYED_LIST [ANY]

	yyvsc26: INTEGER
			-- Capacity of semantic value stack `yyvs26'

	yyvsp26: INTEGER
			-- Top of semantic value stack `yyvs26'

	yyspecial_routines26: KL_SPECIAL_ROUTINES [ARRAYED_LIST [ANY]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [ANY]]

	yyvs27: SPECIAL [INTERVAL [INTEGER]]
			-- Stack for semantic values of type INTERVAL [INTEGER]

	yyvsc27: INTEGER
			-- Capacity of semantic value stack `yyvs27'

	yyvsp27: INTEGER
			-- Top of semantic value stack `yyvs27'

	yyspecial_routines27: KL_SPECIAL_ROUTINES [INTERVAL [INTEGER]]
			-- Routines that ought to be in SPECIAL [INTERVAL [INTEGER]]

	yyvs28: SPECIAL [INTERVAL [REAL]]
			-- Stack for semantic values of type INTERVAL [REAL]

	yyvsc28: INTEGER
			-- Capacity of semantic value stack `yyvs28'

	yyvsp28: INTEGER
			-- Top of semantic value stack `yyvs28'

	yyspecial_routines28: KL_SPECIAL_ROUTINES [INTERVAL [REAL]]
			-- Routines that ought to be in SPECIAL [INTERVAL [REAL]]

	yyvs29: SPECIAL [INTERVAL [ISO8601_TIME]]
			-- Stack for semantic values of type INTERVAL [ISO8601_TIME]

	yyvsc29: INTEGER
			-- Capacity of semantic value stack `yyvs29'

	yyvsp29: INTEGER
			-- Top of semantic value stack `yyvs29'

	yyspecial_routines29: KL_SPECIAL_ROUTINES [INTERVAL [ISO8601_TIME]]
			-- Routines that ought to be in SPECIAL [INTERVAL [ISO8601_TIME]]

	yyvs30: SPECIAL [INTERVAL [ISO8601_DATE]]
			-- Stack for semantic values of type INTERVAL [ISO8601_DATE]

	yyvsc30: INTEGER
			-- Capacity of semantic value stack `yyvs30'

	yyvsp30: INTEGER
			-- Top of semantic value stack `yyvs30'

	yyspecial_routines30: KL_SPECIAL_ROUTINES [INTERVAL [ISO8601_DATE]]
			-- Routines that ought to be in SPECIAL [INTERVAL [ISO8601_DATE]]

	yyvs31: SPECIAL [INTERVAL [ISO8601_DATE_TIME]]
			-- Stack for semantic values of type INTERVAL [ISO8601_DATE_TIME]

	yyvsc31: INTEGER
			-- Capacity of semantic value stack `yyvs31'

	yyvsp31: INTEGER
			-- Top of semantic value stack `yyvs31'

	yyspecial_routines31: KL_SPECIAL_ROUTINES [INTERVAL [ISO8601_DATE_TIME]]
			-- Routines that ought to be in SPECIAL [INTERVAL [ISO8601_DATE_TIME]]

	yyvs32: SPECIAL [INTERVAL [ISO8601_DURATION]]
			-- Stack for semantic values of type INTERVAL [ISO8601_DURATION]

	yyvsc32: INTEGER
			-- Capacity of semantic value stack `yyvs32'

	yyvsp32: INTEGER
			-- Top of semantic value stack `yyvs32'

	yyspecial_routines32: KL_SPECIAL_ROUTINES [INTERVAL [ISO8601_DURATION]]
			-- Routines that ought to be in SPECIAL [INTERVAL [ISO8601_DURATION]]

	yyvs33: SPECIAL [PART_COMPARABLE]
			-- Stack for semantic values of type PART_COMPARABLE

	yyvsc33: INTEGER
			-- Capacity of semantic value stack `yyvs33'

	yyvsp33: INTEGER
			-- Top of semantic value stack `yyvs33'

	yyspecial_routines33: KL_SPECIAL_ROUTINES [PART_COMPARABLE]
			-- Routines that ought to be in SPECIAL [PART_COMPARABLE]

	yyvs34: SPECIAL [INTERVAL [PART_COMPARABLE]]
			-- Stack for semantic values of type INTERVAL [PART_COMPARABLE]

	yyvsc34: INTEGER
			-- Capacity of semantic value stack `yyvs34'

	yyvsp34: INTEGER
			-- Top of semantic value stack `yyvs34'

	yyspecial_routines34: KL_SPECIAL_ROUTINES [INTERVAL [PART_COMPARABLE]]
			-- Routines that ought to be in SPECIAL [INTERVAL [PART_COMPARABLE]]

feature {NONE} -- Constants

	yyFinal: INTEGER = 311
			-- Termination state id

	yyFlag: INTEGER = -32768
			-- Most negative INTEGER

	yyNtbase: INTEGER = 46
			-- Number of tokens

	yyLast: INTEGER = 373
			-- Upper bound of `yytable' and `yycheck'

	yyMax_token: INTEGER = 291
			-- Maximum token id
			-- (upper bound of `yytranslate'.)

	yyNsyms: INTEGER = 98
			-- Number of symbols
			-- (terminal and nonterminal)

feature -- User-defined features



feature -- Initialization

	make
			-- Create a new parser.
		do
			make_scanner
			make_parser_skeleton
		end

	execute (in_text:STRING; a_source_start_line: INTEGER)
		do
			reset
			accept -- ensure no syntax errors lying around from previous invocation

			source_start_line := a_source_start_line

			create indent.make(0)
			create complex_object_nodes.make(0)
			create attr_nodes.make(0)

			create time_vc
			create date_vc
	
			set_input_buffer (new_string_buffer (in_text))
			parse
		end

feature {YY_PARSER_ACTION} -- Basic Operations

	report_error (a_message: STRING)
			-- Print error message.
		do
			add_error_with_location("general_error", <<a_message>>, error_loc)
		end

	abort_with_error (err_code: STRING; args: ARRAY [STRING])
		do
			add_error_with_location(err_code, args, error_loc)
			abort
		end

	error_loc: attached STRING
		do
			create Result.make_empty
			if attached {YY_FILE_BUFFER} input_buffer as f_buffer then
				Result.append (f_buffer.file.name + ", ")
			end
			Result.append ("line " + (in_lineno + source_start_line).out)
			Result.append(" [last dADL token = " + token_name(last_token) + "]")
		end

feature -- Access

	source_start_line: INTEGER
			-- offset of source in other document, else 0

	output: DT_COMPLEX_OBJECT_NODE
			-- parsed structure

feature {NONE} -- Parse Tree

	complex_object_nodes: ARRAYED_STACK [DT_COMPLEX_OBJECT_NODE]
	complex_object_node: DT_COMPLEX_OBJECT_NODE
	last_object_node: DT_OBJECT_ITEM

	attr_nodes: ARRAYED_STACK [DT_ATTRIBUTE_NODE]
	attr_node: DT_ATTRIBUTE_NODE

	obj_id: STRING
			-- qualifier of last rel name; use for next object creation

	rm_attr_name: STRING
	node_type: STRING
	node_id: STRING

	time_vc: TIME_VALIDITY_CHECKER
	date_vc: DATE_VALIDITY_CHECKER

feature {NONE} -- Implementation 
	
	integer_interval: INTERVAL [INTEGER]
	real_interval: INTERVAL [REAL]
	date_interval: INTERVAL [ISO8601_DATE]
	time_interval: INTERVAL [ISO8601_TIME]
	date_time_interval: INTERVAL [ISO8601_DATE_TIME]
	duration_interval: INTERVAL [ISO8601_DURATION]

	indent: STRING
	str: STRING

	type_name: STRING

end
