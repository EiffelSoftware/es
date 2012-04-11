indexing
	component:   "openEHR Archetype Project"
	description: "Validating parser for Archetype Description Language (ADL)"
	keywords:    "ADL, dADL"
	
	author:      "Thomas Beale"
	support:     "Ocean Informatics <support@OceanInformatics.biz>"
	copyright:   "Copyright (c) 2004, 2005 Ocean Informatics Pty Ltd"
	license:     "See notice at bottom of class"

	file:        "$URL: http://www.openehr.org/svn/ref_impl_eiffel/TRUNK/libraries/common_libs/src/structures/syntax/dadl/parser/dadl2_validator.y $"
	revision:    "$LastChangedRevision$"
	last_change: "$LastChangedDate$"

class DADL2_VALIDATOR

inherit
	YY_PARSER_SKELETON
		rename
			make as make_parser_skeleton
		redefine
			report_error
		end

	DATE_TIME_ROUTINES
		export
			{NONE} all
		end

	DADL_SCANNER
		rename
			make as make_scanner, 
			reset as reset_scanner
		end

	KL_SHARED_EXCEPTIONS
	KL_SHARED_ARGUMENTS

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
			yyvsp35 := -1
			yyvsp36 := -1
			yyvsp37 := -1
			yyvsp38 := -1
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
			if yyvs14 /= Void then
				yyvs14.clear_all
			end
			if yyvs15 /= Void then
				yyvs15.clear_all
			end
			if yyvs16 /= Void then
				yyvs16.clear_all
			end
			if yyvs17 /= Void then
				yyvs17.clear_all
			end
			if yyvs18 /= Void then
				yyvs18.clear_all
			end
			if yyvs19 /= Void then
				yyvs19.clear_all
			end
			if yyvs20 /= Void then
				yyvs20.clear_all
			end
			if yyvs21 /= Void then
				yyvs21.clear_all
			end
			if yyvs22 /= Void then
				yyvs22.clear_all
			end
			if yyvs23 /= Void then
				yyvs23.clear_all
			end
			if yyvs24 /= Void then
				yyvs24.clear_all
			end
			if yyvs25 /= Void then
				yyvs25.clear_all
			end
			if yyvs26 /= Void then
				yyvs26.clear_all
			end
			if yyvs27 /= Void then
				yyvs27.clear_all
			end
			if yyvs28 /= Void then
				yyvs28.clear_all
			end
			if yyvs29 /= Void then
				yyvs29.clear_all
			end
			if yyvs30 /= Void then
				yyvs30.clear_all
			end
			if yyvs31 /= Void then
				yyvs31.clear_all
			end
			if yyvs32 /= Void then
				yyvs32.clear_all
			end
			if yyvs33 /= Void then
				yyvs33.clear_all
			end
			if yyvs34 /= Void then
				yyvs34.clear_all
			end
			if yyvs35 /= Void then
				yyvs35.clear_all
			end
			if yyvs36 /= Void then
				yyvs36.clear_all
			end
			if yyvs37 /= Void then
				yyvs37.clear_all
			end
			if yyvs38 /= Void then
				yyvs38.clear_all
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
				yyvs4.put (last_pointer_value, yyvsp4)
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
				yyvs5.put (last_string_value, yyvsp5)
			when 6 then
				yyvsp6 := yyvsp6 + 1
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
				yyvs6.put (last_character_value, yyvsp6)
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
			when 35 then
				yyvsp35 := yyvsp35 - 1
			when 36 then
				yyvsp36 := yyvsp36 - 1
			when 37 then
				yyvsp37 := yyvsp37 - 1
			when 38 then
				yyvsp38 := yyvsp38 - 1
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
			yyval1: ANY
			yyval15: DT_COMPLEX_OBJECT_NODE
			yyval16: DT_OBJECT_LEAF
			yyval30: ARRAYED_LIST [ANY]
			yyval38: INTERVAL_EHR [PART_COMPARABLE]
			yyval5: STRING
			yyval17: ARRAYED_LIST [STRING]
			yyval2: INTEGER
			yyval18: ARRAYED_LIST [INTEGER_REF]
			yyval31: INTERVAL_EHR [INTEGER_REF]
			yyval3: REAL
			yyval4: POINTER
			yyval20: ARRAYED_LIST [REAL_REF]
			yyval32: INTERVAL_EHR [REAL_REF]
			yyval7: BOOLEAN
			yyval24: ARRAYED_LIST [BOOLEAN_REF]
			yyval14: INTEGER_REF
			yyval6: CHARACTER
			yyval22: ARRAYED_LIST [CHARACTER_REF]
			yyval8: ISO8601_DATE
			yyval25: ARRAYED_LIST [ISO8601_DATE]
			yyval34: INTERVAL_EHR [ISO8601_DATE]
			yyval10: ISO8601_TIME
			yyval26: ARRAYED_LIST [ISO8601_TIME]
			yyval33: INTERVAL_EHR [ISO8601_TIME]
			yyval9: ISO8601_DATE_TIME
			yyval27: ARRAYED_LIST [ISO8601_DATE_TIME]
			yyval35: INTERVAL_EHR [ISO8601_DATE_TIME]
			yyval11: ISO8601_DURATION
			yyval28: ARRAYED_LIST [ISO8601_DURATION]
			yyval36: INTERVAL_EHR [ISO8601_DURATION]
			yyval12: CODE_PHRASE
			yyval29: ARRAYED_LIST [CODE_PHRASE]
			yyval13: URI
		do
			inspect yy_act
when 1 then
--|#line 114 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 114")
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
--|#line 122 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 122")
end

			output := yyvs15.item (yyvsp15)
			debug("dADL_parse")
				io.put_string("Object data definition validated%N")
			end
			accept
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp15 := yyvsp15 -1
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
--|#line 130 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 130")
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
--|#line 143 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 143")
end

			debug("dADL_parse")
				io.put_string(indent + "attr_val complete%N")
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 5 then
--|#line 149 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 149")
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
--|#line 155 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 155")
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
--|#line 164 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 164")
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
--|#line 174 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 174")
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
				io.put_string(indent + "attr_id: create_attr_node.make_single(<<" + yyvs5.item (yyvsp5) + ">>)%N")
			end
			create attr_node.make_single(yyvs5.item (yyvsp5))

			debug("dADL_parse")
				io.put_string(indent + "attr_id: complex_object_nodes.item(" + complex_object_nodes.item.node_id + 
						").put_attribute(<<" + attr_node.rm_attr_name + ">>)%N")
			end
			if not complex_object_nodes.item.has_attribute(attr_node.rm_attr_name) then
				complex_object_nodes.item.put_attribute(attr_node)
			else
				raise_error
				report_error("Duplicate relationship: " + attr_node.rm_attr_name)
				abort
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
when 9 then
--|#line 211 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 211")
end

			raise_error
			report_error("Error in attribute value")
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp5 := yyvsp5 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 10 then
--|#line 222 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 222")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp15 := yyvsp15 -1
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
--|#line 223 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 223")
end


if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp16 := yyvsp16 -1
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
--|#line 226 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 226")
end

			yyval15 := yyvs15.item (yyvsp15)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs15.put (yyval15, yyvsp15)
end
when 13 then
--|#line 230 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 230")
end

			yyval15 := yyvs15.item (yyvsp15)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs15.put (yyval15, yyvsp15)
end
when 14 then
--|#line 239 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 239")
end

			yyval15 := yyvs15.item (yyvsp15)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs15.put (yyval15, yyvsp15)
end
when 15 then
--|#line 243 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 243")
end

			-- probably should set type name on owning attribute - it doesn't belong on each 
			-- object, since it is essentially a constraint
			yyval15 := yyvs15.item (yyvsp15)
			node_type := yyvs5.item (yyvsp5)
			if yyval15 /= void then
				yyval15.set_type_name(yyvs5.item (yyvsp5))
			else
				complex_object_nodes.item.attributes.last.set_type_name(yyvs5.item (yyvsp5))
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp5 := yyvsp5 -1
	yyvs15.put (yyval15, yyvsp15)
end
when 16 then
--|#line 265 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 265")
end

			if complex_object_nodes.item.is_addressable and attr_nodes.item.is_generic then
				-- pop the generic attr node
				debug("dADL_parse")
					io.put_string(indent + "multiple_attr_object_block: POP attr node (" +  attr_nodes.item.rm_attr_name+ ")%N")
					indent.remove_tail(1)
				end
				attr_nodes.remove

				debug("dADL_parse")
					io.put_string(indent + "multiple_attr_object_block: POP Object node(" + complex_object_nodes.item.node_id + ")%N")
					indent.remove_tail(1)
				end
				yyval15 := complex_object_nodes.item
				complex_object_nodes.remove
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -3
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
when 17 then
--|#line 285 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 285")
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
					raise_error
					report_error("Key must be unique; key [" + complex_object_node.node_id + 
						"] already exists under attribute %"" + 
						attr_nodes.item.rm_attr_name + "%"")
					abort
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
					raise_error
					report_error("Duplicate relationship: " + attr_node.rm_attr_name)
					abort
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
when 18 then
--|#line 340 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 340")
end

			debug("dADL_parse")
				io.put_string(indent + "one keyed object%N")
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 19 then
--|#line 346 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 346")
end

			debug("dADL_parse")
				io.put_string(indent + "multiple keyed objects%N")
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs1.put (yyval1, yyvsp1)
end
when 20 then
--|#line 354 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 354")
end

			debug("dADL_parse")
				io.put_string(indent + "(keyed object)%N")
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs1.put (yyval1, yyvsp1)
end
when 21 then
--|#line 362 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 362")
end

			obj_id := yyvs1.item (yyvsp1 - 1).out

			debug("dADL_parse")
				io.put_string(indent + "object_key: " + obj_id + 
					" (setting " + attr_nodes.item.rm_attr_name + " to Multiple)%N")
			end
			if not attr_nodes.is_empty then
				attr_nodes.item.set_multiple
			else
				raise_error
				report_error("generic object not enclosed by normal object not allowed")
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs1.put (yyval1, yyvsp1)
end
when 22 then
--|#line 384 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 384")
end

			debug("dADL_parse")
				io.put_string(indent + "untyped single_attr_object_block%N")
			end
			yyval15 := yyvs15.item (yyvsp15)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs15.put (yyval15, yyvsp15)
end
when 23 then
--|#line 391 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 391")
end

			debug("dADL_parse")
				io.put_string(indent + "typed single_attr_object_block; type = " + yyvs5.item (yyvsp5) + "%N")
			end
			yyvs15.item (yyvsp15).set_type_name(yyvs5.item (yyvsp5))
			yyval15 := yyvs15.item (yyvsp15)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp5 := yyvsp5 -1
	yyvs15.put (yyval15, yyvsp15)
end
when 24 then
--|#line 409 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 409")
end

			debug("dADL_parse")
				io.put_string(indent + "empty_object_complex_body: POP Object node(" + 
					complex_object_nodes.item.node_id + ")%N")
				indent.remove_tail(1)
			end
			yyval15 := complex_object_nodes.item
			complex_object_nodes.remove
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp15 := yyvsp15 + 1
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
when 25 then
--|#line 419 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 419")
end

			debug("dADL_parse")
				io.put_string(indent + "single_attr_object_complex_body: POP Object node(" + 
					complex_object_nodes.item.node_id + ")%N")
				indent.remove_tail(1)
			end
			yyval15 := complex_object_nodes.item
			complex_object_nodes.remove
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -3
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
when 26 then
--|#line 431 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 431")
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
					raise_error
					report_error("Key must be unique; key [" + complex_object_node.node_id 
								+ "] already exists under attribute %"" + attr_nodes.item.rm_attr_name + "%"")
					abort
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
when 27 then
--|#line 477 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 477")
end

			debug("dADL_parse")
				io.put_string(indent + "untyped primitive_object_block%N")
			end
			yyval16 := yyvs16.item (yyvsp16)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs16.put (yyval16, yyvsp16)
end
when 28 then
--|#line 484 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 484")
end

			debug("dADL_parse")
				io.put_string(indent + "typed primitive_object_block; type = " + yyvs5.item (yyvsp5) + "%N")
			end
			yyvs16.item (yyvsp16).set_type_name(yyvs5.item (yyvsp5))
			yyval16 := yyvs16.item (yyvsp16)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp5 := yyvsp5 -1
	yyvs16.put (yyval16, yyvsp16)
end
when 29 then
--|#line 494 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 494")
end

			debug("dADL_parse")
				io.put_string(indent + "untyped_primitive_object_block; attr_nodes(<<" + 
						attr_nodes.item.rm_attr_name + ">>).item.put_child(<<" + 
						leaf_object_node.as_string + ">>)%N")
			end
			if not attr_nodes.item.has_child_with_id(leaf_object_node.node_id) then
				attr_nodes.item.put_child(leaf_object_node)
				yyval16 := leaf_object_node
			else
				raise_error
				report_error("Key must be unique; key [" + leaf_object_node.node_id 
						+ "] already exists under attribute %"" + attr_nodes.item.rm_attr_name + "%"")
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp16 := yyvsp16 + 1
	yyvsp1 := yyvsp1 -3
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
when 30 then
--|#line 513 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 513")
end

			if obj_id /= Void then
				create {DT_PRIMITIVE_OBJECT} leaf_object_node.make_identified(yyvs1.item (yyvsp1), obj_id)
				obj_id := Void
			else
				create {DT_PRIMITIVE_OBJECT} leaf_object_node.make_anonymous(yyvs1.item (yyvsp1))
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 31 then
--|#line 522 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 522")
end

			if obj_id /= Void then
				create {DT_PRIMITIVE_OBJECT_LIST} leaf_object_node.make_identified(yyvs30.item (yyvsp30), obj_id)
				obj_id := Void
			else
				create {DT_PRIMITIVE_OBJECT_LIST} leaf_object_node.make_anonymous(yyvs30.item (yyvsp30))
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp30 := yyvsp30 -1
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
--|#line 531 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 531")
end

			if obj_id /= Void then
				create {DT_PRIMITIVE_OBJECT_INTERVAL} leaf_object_node.make_identified(yyvs38.item (yyvsp38), obj_id)
				obj_id := Void
			else
				create {DT_PRIMITIVE_OBJECT_INTERVAL} leaf_object_node.make_anonymous(yyvs38.item (yyvsp38))
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp38 := yyvsp38 -1
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
when 33 then
--|#line 540 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 540")
end

			if obj_id /= Void then
				create {DT_PRIMITIVE_OBJECT} leaf_object_node.make_identified(yyvs12.item (yyvsp12), obj_id)
				obj_id := Void
			else
				create {DT_PRIMITIVE_OBJECT} leaf_object_node.make_anonymous(yyvs12.item (yyvsp12))
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
--|#line 549 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 549")
end

			if obj_id /= Void then
				create {DT_PRIMITIVE_OBJECT_LIST} leaf_object_node.make_identified(yyvs29.item (yyvsp29), obj_id)
				obj_id := Void
			else
				create {DT_PRIMITIVE_OBJECT_LIST} leaf_object_node.make_anonymous(yyvs29.item (yyvsp29))
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp29 := yyvsp29 -1
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
when 35 then
--|#line 560 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 560")
end

			yyval1 := yyvs1.item (yyvsp1)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 36 then
--|#line 564 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 564")
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
when 37 then
--|#line 568 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 568")
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
when 38 then
--|#line 572 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 572")
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
when 39 then
--|#line 576 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 576")
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
when 40 then
--|#line 580 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 580")
end

			yyval1 := yyvs6.item (yyvsp6)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp6 := yyvsp6 -1
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
--|#line 584 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 584")
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
when 42 then
--|#line 588 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 588")
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
when 43 then
--|#line 592 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 592")
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
when 44 then
--|#line 596 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 596")
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
when 45 then
--|#line 600 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 600")
end

			yyval1 := yyvs13.item (yyvsp13)
		
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
when 46 then
--|#line 604 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 604")
end

			yyval1 := yyvs1.item (yyvsp1)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
when 47 then
--|#line 608 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 608")
end

			yyval1 := yyvs14.item (yyvsp14)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp14 := yyvsp14 -1
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
when 48 then
--|#line 614 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 614")
end

			yyval30 := yyvs17.item (yyvsp17)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp30 := yyvsp30 + 1
	yyvsp17 := yyvsp17 -1
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
when 49 then
--|#line 618 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 618")
end

			yyval30 := yyvs18.item (yyvsp18)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp30 := yyvsp30 + 1
	yyvsp18 := yyvsp18 -1
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
when 50 then
--|#line 622 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 622")
end

			yyval30 := yyvs20.item (yyvsp20)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp30 := yyvsp30 + 1
	yyvsp20 := yyvsp20 -1
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
when 51 then
--|#line 626 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 626")
end

			yyval30 := yyvs24.item (yyvsp24)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp30 := yyvsp30 + 1
	yyvsp24 := yyvsp24 -1
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
when 52 then
--|#line 630 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 630")
end

			yyval30 := yyvs22.item (yyvsp22)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp30 := yyvsp30 + 1
	yyvsp22 := yyvsp22 -1
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
when 53 then
--|#line 634 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 634")
end

			yyval30 := yyvs25.item (yyvsp25)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp30 := yyvsp30 + 1
	yyvsp25 := yyvsp25 -1
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
when 54 then
--|#line 638 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 638")
end

			yyval30 := yyvs26.item (yyvsp26)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp30 := yyvsp30 + 1
	yyvsp26 := yyvsp26 -1
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
when 55 then
--|#line 642 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 642")
end

			yyval30 := yyvs27.item (yyvsp27)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp30 := yyvsp30 + 1
	yyvsp27 := yyvsp27 -1
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
when 56 then
--|#line 646 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 646")
end

			yyval30 := yyvs28.item (yyvsp28)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp30 := yyvsp30 + 1
	yyvsp28 := yyvsp28 -1
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
when 57 then
--|#line 652 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 652")
end

			yyval38 := yyvs31.item (yyvsp31)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp38 := yyvsp38 + 1
	yyvsp31 := yyvsp31 -1
	if yyvsp38 >= yyvsc38 then
		if yyvs38 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs38")
			end
			create yyspecial_routines38
			yyvsc38 := yyInitial_yyvs_size
			yyvs38 := yyspecial_routines38.make (yyvsc38)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs38")
			end
			yyvsc38 := yyvsc38 + yyInitial_yyvs_size
			yyvs38 := yyspecial_routines38.resize (yyvs38, yyvsc38)
		end
	end
	yyvs38.put (yyval38, yyvsp38)
end
when 58 then
--|#line 656 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 656")
end

			yyval38 := yyvs32.item (yyvsp32)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp38 := yyvsp38 + 1
	yyvsp32 := yyvsp32 -1
	if yyvsp38 >= yyvsc38 then
		if yyvs38 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs38")
			end
			create yyspecial_routines38
			yyvsc38 := yyInitial_yyvs_size
			yyvs38 := yyspecial_routines38.make (yyvsc38)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs38")
			end
			yyvsc38 := yyvsc38 + yyInitial_yyvs_size
			yyvs38 := yyspecial_routines38.resize (yyvs38, yyvsc38)
		end
	end
	yyvs38.put (yyval38, yyvsp38)
end
when 59 then
--|#line 660 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 660")
end

			yyval38 := yyvs34.item (yyvsp34)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp38 := yyvsp38 + 1
	yyvsp34 := yyvsp34 -1
	if yyvsp38 >= yyvsc38 then
		if yyvs38 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs38")
			end
			create yyspecial_routines38
			yyvsc38 := yyInitial_yyvs_size
			yyvs38 := yyspecial_routines38.make (yyvsc38)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs38")
			end
			yyvsc38 := yyvsc38 + yyInitial_yyvs_size
			yyvs38 := yyspecial_routines38.resize (yyvs38, yyvsc38)
		end
	end
	yyvs38.put (yyval38, yyvsp38)
end
when 60 then
--|#line 664 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 664")
end

			yyval38 := yyvs33.item (yyvsp33)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp38 := yyvsp38 + 1
	yyvsp33 := yyvsp33 -1
	if yyvsp38 >= yyvsc38 then
		if yyvs38 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs38")
			end
			create yyspecial_routines38
			yyvsc38 := yyInitial_yyvs_size
			yyvs38 := yyspecial_routines38.make (yyvsc38)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs38")
			end
			yyvsc38 := yyvsc38 + yyInitial_yyvs_size
			yyvs38 := yyspecial_routines38.resize (yyvs38, yyvsc38)
		end
	end
	yyvs38.put (yyval38, yyvsp38)
end
when 61 then
--|#line 668 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 668")
end

			yyval38 := yyvs35.item (yyvsp35)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp38 := yyvsp38 + 1
	yyvsp35 := yyvsp35 -1
	if yyvsp38 >= yyvsc38 then
		if yyvs38 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs38")
			end
			create yyspecial_routines38
			yyvsc38 := yyInitial_yyvs_size
			yyvs38 := yyspecial_routines38.make (yyvsc38)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs38")
			end
			yyvsc38 := yyvsc38 + yyInitial_yyvs_size
			yyvs38 := yyspecial_routines38.resize (yyvs38, yyvsc38)
		end
	end
	yyvs38.put (yyval38, yyvsp38)
end
when 62 then
--|#line 672 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 672")
end

			yyval38 := yyvs36.item (yyvsp36)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp38 := yyvsp38 + 1
	yyvsp36 := yyvsp36 -1
	if yyvsp38 >= yyvsc38 then
		if yyvs38 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs38")
			end
			create yyspecial_routines38
			yyvsc38 := yyInitial_yyvs_size
			yyvs38 := yyspecial_routines38.make (yyvsc38)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs38")
			end
			yyvsc38 := yyvsc38 + yyInitial_yyvs_size
			yyvs38 := yyspecial_routines38.resize (yyvs38, yyvsc38)
		end
	end
	yyvs38.put (yyval38, yyvsp38)
end
when 63 then
--|#line 680 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 680")
end

			yyval5 := yyvs5.item (yyvsp5)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs5.put (yyval5, yyvsp5)
end
when 64 then
--|#line 684 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 684")
end

			yyval5 := yyvs5.item (yyvsp5)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs5.put (yyval5, yyvsp5)
end
when 65 then
--|#line 688 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 688")
end

			yyval5 := yyvs5.item (yyvsp5)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs5.put (yyval5, yyvsp5)
end
when 66 then
--|#line 692 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 692")
end

			yyval5 := yyvs5.item (yyvsp5)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs5.put (yyval5, yyvsp5)
end
when 67 then
--|#line 698 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 698")
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
when 68 then
--|#line 704 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 704")
end

			create yyval17.make(0)
			yyval17.extend(yyvs5.item (yyvsp5 - 1))
			yyval17.extend(yyvs5.item (yyvsp5))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp17 := yyvsp17 + 1
	yyvsp5 := yyvsp5 -2
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
when 69 then
--|#line 710 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 710")
end

			create yyval17.make(0)
			yyval17.extend(void)
			yyval17.extend(void)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp17 := yyvsp17 + 1
	yyvsp1 := yyvsp1 -3
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
when 70 then
--|#line 716 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 716")
end

			create yyval17.make(0)
			yyval17.extend(yyvs5.item (yyvsp5))
			yyval17.extend(void)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp17 := yyvsp17 + 1
	yyvsp5 := yyvsp5 -1
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
when 71 then
--|#line 722 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 722")
end

			create yyval17.make(0)
			yyval17.extend(void)
			yyval17.extend(yyvs5.item (yyvsp5))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp17 := yyvsp17 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp5 := yyvsp5 -1
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
when 72 then
--|#line 728 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 728")
end

			yyvs17.item (yyvsp17).extend(yyvs5.item (yyvsp5))
			yyval17 := yyvs17.item (yyvsp17)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp5 := yyvsp5 -1
	yyvs17.put (yyval17, yyvsp17)
end
when 73 then
--|#line 733 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 733")
end

			yyvs17.item (yyvsp17).extend(void)
			yyval17 := yyvs17.item (yyvsp17)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs17.put (yyval17, yyvsp17)
end
when 74 then
--|#line 738 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 738")
end

			create yyval17.make(0)
			yyval17.extend(yyvs5.item (yyvsp5))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp17 := yyvsp17 + 1
	yyvsp5 := yyvsp5 -1
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
when 75 then
--|#line 743 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 743")
end

			create yyval17.make(0)
			yyval17.extend(void)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp17 := yyvsp17 + 1
	yyvsp1 := yyvsp1 -3
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
when 76 then
--|#line 750 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 750")
end

			yyval2 := yyvs2.item (yyvsp2)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
when 77 then
--|#line 753 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 753")
end

			yyval2 := yyvs2.item (yyvsp2)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs2.put (yyval2, yyvsp2)
end
when 78 then
--|#line 756 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 756")
end

			yyval2 := - yyvs2.item (yyvsp2)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs2.put (yyval2, yyvsp2)
end
when 79 then
--|#line 761 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 761")
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
when 80 then
--|#line 767 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 767")
end

			yyvs18.item (yyvsp18).extend(yyvs2.item (yyvsp2))
			yyval18 := yyvs18.item (yyvsp18)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp2 := yyvsp2 -1
	yyvs18.put (yyval18, yyvsp18)
end
when 81 then
--|#line 772 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 772")
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
when 82 then
--|#line 779 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 779")
end

			if yyvs2.item (yyvsp2 - 1) <= yyvs2.item (yyvsp2) then
				create integer_interval.make_bounded(yyvs2.item (yyvsp2 - 1), yyvs2.item (yyvsp2), True, True)
				yyval31 := integer_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs2.item (yyvsp2 - 1).out + " must be <= " + yyvs2.item (yyvsp2).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp31 := yyvsp31 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -2
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
when 83 then
--|#line 790 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 790")
end

			if yyvs2.item (yyvsp2 - 1) <= yyvs2.item (yyvsp2) then
				create integer_interval.make_bounded(yyvs2.item (yyvsp2 - 1), yyvs2.item (yyvsp2), False, True)
				yyval31 := integer_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs2.item (yyvsp2 - 1).out + " must be <= " + yyvs2.item (yyvsp2).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp31 := yyvsp31 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp2 := yyvsp2 -2
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
when 84 then
--|#line 801 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 801")
end

			if yyvs2.item (yyvsp2 - 1) <= yyvs2.item (yyvsp2) then
				create integer_interval.make_bounded(yyvs2.item (yyvsp2 - 1), yyvs2.item (yyvsp2), True, False)
				yyval31 := integer_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs2.item (yyvsp2 - 1).out + " must be <= " + yyvs2.item (yyvsp2).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp31 := yyvsp31 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp2 := yyvsp2 -2
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
when 85 then
--|#line 812 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 812")
end

			if yyvs2.item (yyvsp2 - 1) <= yyvs2.item (yyvsp2) then
				create integer_interval.make_bounded(yyvs2.item (yyvsp2 - 1), yyvs2.item (yyvsp2), False, False)
				yyval31 := integer_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs2.item (yyvsp2 - 1).out + " must be <= " + yyvs2.item (yyvsp2).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 7
	yyvsp31 := yyvsp31 + 1
	yyvsp1 := yyvsp1 -5
	yyvsp2 := yyvsp2 -2
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
when 86 then
--|#line 823 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 823")
end

			create integer_interval.make_lower_unbounded(yyvs2.item (yyvsp2), False)
			yyval31 := integer_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp31 := yyvsp31 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
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
when 87 then
--|#line 828 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 828")
end

			create integer_interval.make_lower_unbounded(yyvs2.item (yyvsp2), True)
			yyval31 := integer_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp31 := yyvsp31 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
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
when 88 then
--|#line 833 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 833")
end

			create integer_interval.make_upper_unbounded(yyvs2.item (yyvsp2), False)
			yyval31 := integer_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp31 := yyvsp31 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
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
when 89 then
--|#line 838 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 838")
end

			create integer_interval.make_upper_unbounded(yyvs2.item (yyvsp2), True)
			yyval31 := integer_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp31 := yyvsp31 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp2 := yyvsp2 -1
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
when 90 then
--|#line 843 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 843")
end

			create integer_interval.make_point(yyvs2.item (yyvsp2))
			yyval31 := integer_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp31 := yyvsp31 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp2 := yyvsp2 -1
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
when 91 then
--|#line 850 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 850")
end

			yyval3 := yyvs3.item (yyvsp3)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs3.put (yyval3, yyvsp3)
end
when 92 then
--|#line 854 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 854")
end

			yyval3 := yyvs3.item (yyvsp3)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs3.put (yyval3, yyvsp3)
end
when 93 then
--|#line 858 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 858")
end

			yyval3 := - yyvs3.item (yyvsp3)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs3.put (yyval3, yyvsp3)
end
when 94 then
--|#line 864 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 864")
end

			yyval4 := yyvs4.item (yyvsp4)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs4.put (yyval4, yyvsp4)
end
when 95 then
--|#line 871 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 871")
end

			create yyval20.make(0)
			yyval20.extend(yyvs3.item (yyvsp3 - 1))
			yyval20.extend(yyvs3.item (yyvsp3))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp20 := yyvsp20 + 1
	yyvsp3 := yyvsp3 -2
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
when 96 then
--|#line 877 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 877")
end

			yyvs20.item (yyvsp20).extend(yyvs3.item (yyvsp3))
			yyval20 := yyvs20.item (yyvsp20)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp3 := yyvsp3 -1
	yyvs20.put (yyval20, yyvsp20)
end
when 97 then
--|#line 882 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 882")
end

			create yyval20.make(0)
			yyval20.extend(yyvs3.item (yyvsp3))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp20 := yyvsp20 + 1
	yyvsp3 := yyvsp3 -1
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
when 98 then
--|#line 889 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 889")
end

			if yyvs3.item (yyvsp3 - 1) <= yyvs3.item (yyvsp3) then
				create real_interval.make_bounded(yyvs3.item (yyvsp3 - 1), yyvs3.item (yyvsp3), True, True)
				yyval32 := real_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs3.item (yyvsp3 - 1).out + " must be <= " + yyvs3.item (yyvsp3).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp3 := yyvsp3 -2
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
when 99 then
--|#line 900 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 900")
end

			if yyvs3.item (yyvsp3 - 1) <= yyvs3.item (yyvsp3) then
				create real_interval.make_bounded(yyvs3.item (yyvsp3 - 1), yyvs3.item (yyvsp3), False, True)
				yyval32 := real_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs3.item (yyvsp3 - 1).out + " must be <= " + yyvs3.item (yyvsp3).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp3 := yyvsp3 -2
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
when 100 then
--|#line 911 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 911")
end

			if yyvs3.item (yyvsp3 - 1) <= yyvs3.item (yyvsp3) then
				create real_interval.make_bounded(yyvs3.item (yyvsp3 - 1), yyvs3.item (yyvsp3), True, False)
				yyval32 := real_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs3.item (yyvsp3 - 1).out + " must be <= " + yyvs3.item (yyvsp3).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp3 := yyvsp3 -2
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
when 101 then
--|#line 922 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 922")
end

			if yyvs3.item (yyvsp3 - 1) <= yyvs3.item (yyvsp3) then
				create real_interval.make_bounded(yyvs3.item (yyvsp3 - 1), yyvs3.item (yyvsp3), False, False)
				yyval32 := real_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs3.item (yyvsp3 - 1).out + " must be <= " + yyvs3.item (yyvsp3).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 7
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -5
	yyvsp3 := yyvsp3 -2
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
when 102 then
--|#line 933 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 933")
end

			create real_interval.make_lower_unbounded(yyvs3.item (yyvsp3), False)
			yyval32 := real_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp3 := yyvsp3 -1
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
when 103 then
--|#line 938 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 938")
end

			create real_interval.make_lower_unbounded(yyvs3.item (yyvsp3), True)
			yyval32 := real_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp3 := yyvsp3 -1
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
when 104 then
--|#line 943 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 943")
end

			create real_interval.make_upper_unbounded(yyvs3.item (yyvsp3), False)
			yyval32 := real_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp3 := yyvsp3 -1
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
when 105 then
--|#line 948 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 948")
end

			create real_interval.make_upper_unbounded(yyvs3.item (yyvsp3), True)
			yyval32 := real_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp3 := yyvsp3 -1
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
when 106 then
--|#line 953 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 953")
end

			create real_interval.make_point(yyvs3.item (yyvsp3))
			yyval32 := real_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp32 := yyvsp32 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp3 := yyvsp3 -1
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
when 107 then
--|#line 960 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 960")
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
when 108 then
--|#line 964 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 964")
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
when 109 then
--|#line 970 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 970")
end

			create yyval24.make(0)
			yyval24.extend(yyvs7.item (yyvsp7 - 1))
			yyval24.extend(yyvs7.item (yyvsp7))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp24 := yyvsp24 + 1
	yyvsp7 := yyvsp7 -2
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
when 110 then
--|#line 976 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 976")
end

			yyvs24.item (yyvsp24).extend(yyvs7.item (yyvsp7))
			yyval24 := yyvs24.item (yyvsp24)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp7 := yyvsp7 -1
	yyvs24.put (yyval24, yyvsp24)
end
when 111 then
--|#line 981 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 981")
end

			create yyval24.make(0)
			yyval24.extend(yyvs7.item (yyvsp7))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp24 := yyvsp24 + 1
	yyvsp7 := yyvsp7 -1
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
when 112 then
--|#line 988 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 988")
end

			yyval14 := void
		
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
when 113 then
--|#line 995 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 995")
end

			yyval6 := yyvs6.item (yyvsp6)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs6.put (yyval6, yyvsp6)
end
when 114 then
--|#line 1001 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1001")
end

			create yyval22.make(0)
			yyval22.extend(yyvs6.item (yyvsp6 - 1))
			yyval22.extend(yyvs6.item (yyvsp6))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp22 := yyvsp22 + 1
	yyvsp6 := yyvsp6 -2
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
when 115 then
--|#line 1007 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1007")
end

			yyvs22.item (yyvsp22).extend(yyvs6.item (yyvsp6))
			yyval22 := yyvs22.item (yyvsp22)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp6 := yyvsp6 -1
	yyvs22.put (yyval22, yyvsp22)
end
when 116 then
--|#line 1012 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1012")
end

			create yyval22.make(0)
			yyval22.extend(yyvs6.item (yyvsp6))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp22 := yyvsp22 + 1
	yyvsp6 := yyvsp6 -1
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
when 117 then
--|#line 1019 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1019")
end

			if valid_iso8601_date(yyvs5.item (yyvsp5)) then
				create yyval8.make_from_string(yyvs5.item (yyvsp5))
			else
				raise_error
				report_error("invalid ISO8601 date: " + yyvs5.item (yyvsp5))
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp8 := yyvsp8 + 1
	yyvsp5 := yyvsp5 -1
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
when 118 then
--|#line 1031 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1031")
end

			create yyval25.make(0)
			yyval25.extend(yyvs8.item (yyvsp8 - 1))
			yyval25.extend(yyvs8.item (yyvsp8))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp25 := yyvsp25 + 1
	yyvsp8 := yyvsp8 -2
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
when 119 then
--|#line 1037 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1037")
end

			yyvs25.item (yyvsp25).extend(yyvs8.item (yyvsp8))
			yyval25 := yyvs25.item (yyvsp25)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp8 := yyvsp8 -1
	yyvs25.put (yyval25, yyvsp25)
end
when 120 then
--|#line 1042 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1042")
end

			create yyval25.make(0)
			yyval25.extend(yyvs8.item (yyvsp8))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp25 := yyvsp25 + 1
	yyvsp8 := yyvsp8 -1
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
when 121 then
--|#line 1049 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1049")
end

			if yyvs8.item (yyvsp8 - 1) <= yyvs8.item (yyvsp8) then
				create date_interval.make_bounded(yyvs8.item (yyvsp8 - 1), yyvs8.item (yyvsp8), True, True)
				yyval34 := date_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs8.item (yyvsp8 - 1).out + " must be <= " + yyvs8.item (yyvsp8).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp34 := yyvsp34 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp8 := yyvsp8 -2
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
when 122 then
--|#line 1060 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1060")
end

			if yyvs8.item (yyvsp8 - 1) <= yyvs8.item (yyvsp8) then
				create date_interval.make_bounded(yyvs8.item (yyvsp8 - 1), yyvs8.item (yyvsp8), False, True)
				yyval34 := date_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs8.item (yyvsp8 - 1).out + " must be <= " + yyvs8.item (yyvsp8).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp34 := yyvsp34 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp8 := yyvsp8 -2
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
when 123 then
--|#line 1071 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1071")
end

			if yyvs8.item (yyvsp8 - 1) <= yyvs8.item (yyvsp8) then
				create date_interval.make_bounded(yyvs8.item (yyvsp8 - 1), yyvs8.item (yyvsp8), True, False)
				yyval34 := date_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs8.item (yyvsp8 - 1).out + " must be <= " + yyvs8.item (yyvsp8).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp34 := yyvsp34 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp8 := yyvsp8 -2
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
when 124 then
--|#line 1082 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1082")
end

			if yyvs8.item (yyvsp8 - 1) <= yyvs8.item (yyvsp8) then
				create date_interval.make_bounded(yyvs8.item (yyvsp8 - 1), yyvs8.item (yyvsp8), False, False)
				yyval34 := date_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs8.item (yyvsp8 - 1).out + " must be <= " + yyvs8.item (yyvsp8).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 7
	yyvsp34 := yyvsp34 + 1
	yyvsp1 := yyvsp1 -5
	yyvsp8 := yyvsp8 -2
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
when 125 then
--|#line 1093 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1093")
end

			create date_interval.make_lower_unbounded(yyvs8.item (yyvsp8), False)
			yyval34 := date_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp34 := yyvsp34 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp8 := yyvsp8 -1
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
when 126 then
--|#line 1098 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1098")
end

			create date_interval.make_lower_unbounded(yyvs8.item (yyvsp8), True)
			yyval34 := date_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp34 := yyvsp34 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp8 := yyvsp8 -1
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
when 127 then
--|#line 1103 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1103")
end

			create date_interval.make_upper_unbounded(yyvs8.item (yyvsp8), False)
			yyval34 := date_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp34 := yyvsp34 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp8 := yyvsp8 -1
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
when 128 then
--|#line 1108 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1108")
end

			create date_interval.make_upper_unbounded(yyvs8.item (yyvsp8), True)
			yyval34 := date_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp34 := yyvsp34 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp8 := yyvsp8 -1
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
when 129 then
--|#line 1113 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1113")
end

			create date_interval.make_point(yyvs8.item (yyvsp8))
			yyval34 := date_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp34 := yyvsp34 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp8 := yyvsp8 -1
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
when 130 then
--|#line 1120 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1120")
end

			if valid_iso8601_time(yyvs5.item (yyvsp5)) then
				create yyval10.make_from_string(yyvs5.item (yyvsp5))
			else
				raise_error
				report_error("invalid ISO8601 time: " + yyvs5.item (yyvsp5))
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp10 := yyvsp10 + 1
	yyvsp5 := yyvsp5 -1
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
when 131 then
--|#line 1132 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1132")
end

			create yyval26.make(0)
			yyval26.extend(yyvs10.item (yyvsp10 - 1))
			yyval26.extend(yyvs10.item (yyvsp10))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp26 := yyvsp26 + 1
	yyvsp10 := yyvsp10 -2
	yyvsp1 := yyvsp1 -1
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
when 132 then
--|#line 1138 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1138")
end

			yyvs26.item (yyvsp26).extend(yyvs10.item (yyvsp10))
			yyval26 := yyvs26.item (yyvsp26)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp10 := yyvsp10 -1
	yyvs26.put (yyval26, yyvsp26)
end
when 133 then
--|#line 1143 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1143")
end

			create yyval26.make(0)
			yyval26.extend(yyvs10.item (yyvsp10))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp26 := yyvsp26 + 1
	yyvsp10 := yyvsp10 -1
	yyvsp1 := yyvsp1 -2
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
when 134 then
--|#line 1150 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1150")
end

			if yyvs10.item (yyvsp10 - 1) <= yyvs10.item (yyvsp10) then
				create time_interval.make_bounded(yyvs10.item (yyvsp10 - 1), yyvs10.item (yyvsp10), True, True)
				yyval33 := time_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs10.item (yyvsp10 - 1).out + " must be <= " + yyvs10.item (yyvsp10).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp10 := yyvsp10 -2
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 135 then
--|#line 1161 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1161")
end

			if yyvs10.item (yyvsp10 - 1) <= yyvs10.item (yyvsp10) then
				create time_interval.make_bounded(yyvs10.item (yyvsp10 - 1), yyvs10.item (yyvsp10), False, True)
				yyval33 := time_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs10.item (yyvsp10 - 1).out + " must be <= " + yyvs10.item (yyvsp10).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp10 := yyvsp10 -2
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 136 then
--|#line 1172 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1172")
end

			if yyvs10.item (yyvsp10 - 1) <= yyvs10.item (yyvsp10) then
				create time_interval.make_bounded(yyvs10.item (yyvsp10 - 1), yyvs10.item (yyvsp10), True, False)
				yyval33 := time_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs10.item (yyvsp10 - 1).out + " must be <= " + yyvs10.item (yyvsp10).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp10 := yyvsp10 -2
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 137 then
--|#line 1183 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1183")
end

			if yyvs10.item (yyvsp10 - 1) <= yyvs10.item (yyvsp10) then
				create time_interval.make_bounded(yyvs10.item (yyvsp10 - 1), yyvs10.item (yyvsp10), False, False)
				yyval33 := time_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs10.item (yyvsp10 - 1).out + " must be <= " + yyvs10.item (yyvsp10).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 7
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -5
	yyvsp10 := yyvsp10 -2
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 138 then
--|#line 1194 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1194")
end

			create time_interval.make_lower_unbounded(yyvs10.item (yyvsp10), False)
			yyval33 := time_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp10 := yyvsp10 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 139 then
--|#line 1199 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1199")
end

			create time_interval.make_lower_unbounded(yyvs10.item (yyvsp10), True)
			yyval33 := time_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp10 := yyvsp10 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 140 then
--|#line 1204 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1204")
end

			create time_interval.make_upper_unbounded(yyvs10.item (yyvsp10), False)
			yyval33 := time_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp10 := yyvsp10 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 141 then
--|#line 1209 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1209")
end

			create time_interval.make_upper_unbounded(yyvs10.item (yyvsp10), True)
			yyval33 := time_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp10 := yyvsp10 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 142 then
--|#line 1214 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1214")
end

			create time_interval.make_point(yyvs10.item (yyvsp10))
			yyval33 := time_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp33 := yyvsp33 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp10 := yyvsp10 -1
	if yyvsp33 >= yyvsc33 then
		if yyvs33 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs33")
			end
			create yyspecial_routines33
			yyvsc33 := yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.make (yyvsc33)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs33")
			end
			yyvsc33 := yyvsc33 + yyInitial_yyvs_size
			yyvs33 := yyspecial_routines33.resize (yyvs33, yyvsc33)
		end
	end
	yyvs33.put (yyval33, yyvsp33)
end
when 143 then
--|#line 1221 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1221")
end

			if valid_iso8601_date_time(yyvs5.item (yyvsp5)) then
				create yyval9.make_from_string(yyvs5.item (yyvsp5))
			else
				raise_error
				report_error("invalid ISO8601 date/time: " + yyvs5.item (yyvsp5))
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp9 := yyvsp9 + 1
	yyvsp5 := yyvsp5 -1
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
when 144 then
--|#line 1233 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1233")
end

			create yyval27.make(0)
			yyval27.extend(yyvs9.item (yyvsp9 - 1))
			yyval27.extend(yyvs9.item (yyvsp9))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp27 := yyvsp27 + 1
	yyvsp9 := yyvsp9 -2
	yyvsp1 := yyvsp1 -1
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
when 145 then
--|#line 1239 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1239")
end

			yyvs27.item (yyvsp27).extend(yyvs9.item (yyvsp9))
			yyval27 := yyvs27.item (yyvsp27)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp9 := yyvsp9 -1
	yyvs27.put (yyval27, yyvsp27)
end
when 146 then
--|#line 1244 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1244")
end

			create yyval27.make(0)
			yyval27.extend(yyvs9.item (yyvsp9))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp27 := yyvsp27 + 1
	yyvsp9 := yyvsp9 -1
	yyvsp1 := yyvsp1 -2
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
when 147 then
--|#line 1251 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1251")
end

			if yyvs9.item (yyvsp9 - 1) <= yyvs9.item (yyvsp9) then
				create date_time_interval.make_bounded(yyvs9.item (yyvsp9 - 1), yyvs9.item (yyvsp9), True, True)
				yyval35 := date_time_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs9.item (yyvsp9 - 1).out + " must be <= " + yyvs9.item (yyvsp9).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp35 := yyvsp35 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp9 := yyvsp9 -2
	if yyvsp35 >= yyvsc35 then
		if yyvs35 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs35")
			end
			create yyspecial_routines35
			yyvsc35 := yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.make (yyvsc35)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs35")
			end
			yyvsc35 := yyvsc35 + yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.resize (yyvs35, yyvsc35)
		end
	end
	yyvs35.put (yyval35, yyvsp35)
end
when 148 then
--|#line 1262 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1262")
end

			if yyvs9.item (yyvsp9 - 1) <= yyvs9.item (yyvsp9) then
				create date_time_interval.make_bounded(yyvs9.item (yyvsp9 - 1), yyvs9.item (yyvsp9), False, True)
				yyval35 := date_time_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs9.item (yyvsp9 - 1).out + " must be <= " + yyvs9.item (yyvsp9).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp35 := yyvsp35 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp9 := yyvsp9 -2
	if yyvsp35 >= yyvsc35 then
		if yyvs35 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs35")
			end
			create yyspecial_routines35
			yyvsc35 := yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.make (yyvsc35)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs35")
			end
			yyvsc35 := yyvsc35 + yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.resize (yyvs35, yyvsc35)
		end
	end
	yyvs35.put (yyval35, yyvsp35)
end
when 149 then
--|#line 1273 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1273")
end

			if yyvs9.item (yyvsp9 - 1) <= yyvs9.item (yyvsp9) then
				create date_time_interval.make_bounded(yyvs9.item (yyvsp9 - 1), yyvs9.item (yyvsp9), True, False)
				yyval35 := date_time_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs9.item (yyvsp9 - 1).out + " must be <= " + yyvs9.item (yyvsp9).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp35 := yyvsp35 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp9 := yyvsp9 -2
	if yyvsp35 >= yyvsc35 then
		if yyvs35 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs35")
			end
			create yyspecial_routines35
			yyvsc35 := yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.make (yyvsc35)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs35")
			end
			yyvsc35 := yyvsc35 + yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.resize (yyvs35, yyvsc35)
		end
	end
	yyvs35.put (yyval35, yyvsp35)
end
when 150 then
--|#line 1284 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1284")
end

			if yyvs9.item (yyvsp9 - 1) <= yyvs9.item (yyvsp9) then
				create date_time_interval.make_bounded(yyvs9.item (yyvsp9 - 1), yyvs9.item (yyvsp9), False, False)
				yyval35 := date_time_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs9.item (yyvsp9 - 1).out + " must be <= " + yyvs9.item (yyvsp9).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 7
	yyvsp35 := yyvsp35 + 1
	yyvsp1 := yyvsp1 -5
	yyvsp9 := yyvsp9 -2
	if yyvsp35 >= yyvsc35 then
		if yyvs35 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs35")
			end
			create yyspecial_routines35
			yyvsc35 := yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.make (yyvsc35)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs35")
			end
			yyvsc35 := yyvsc35 + yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.resize (yyvs35, yyvsc35)
		end
	end
	yyvs35.put (yyval35, yyvsp35)
end
when 151 then
--|#line 1295 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1295")
end

			create date_time_interval.make_lower_unbounded(yyvs9.item (yyvsp9), False)
			yyval35 := date_time_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp35 := yyvsp35 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp9 := yyvsp9 -1
	if yyvsp35 >= yyvsc35 then
		if yyvs35 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs35")
			end
			create yyspecial_routines35
			yyvsc35 := yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.make (yyvsc35)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs35")
			end
			yyvsc35 := yyvsc35 + yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.resize (yyvs35, yyvsc35)
		end
	end
	yyvs35.put (yyval35, yyvsp35)
end
when 152 then
--|#line 1300 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1300")
end

			create date_time_interval.make_lower_unbounded(yyvs9.item (yyvsp9), True)
			yyval35 := date_time_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp35 := yyvsp35 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp9 := yyvsp9 -1
	if yyvsp35 >= yyvsc35 then
		if yyvs35 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs35")
			end
			create yyspecial_routines35
			yyvsc35 := yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.make (yyvsc35)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs35")
			end
			yyvsc35 := yyvsc35 + yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.resize (yyvs35, yyvsc35)
		end
	end
	yyvs35.put (yyval35, yyvsp35)
end
when 153 then
--|#line 1305 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1305")
end

			create date_time_interval.make_upper_unbounded(yyvs9.item (yyvsp9), False)
			yyval35 := date_time_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp35 := yyvsp35 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp9 := yyvsp9 -1
	if yyvsp35 >= yyvsc35 then
		if yyvs35 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs35")
			end
			create yyspecial_routines35
			yyvsc35 := yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.make (yyvsc35)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs35")
			end
			yyvsc35 := yyvsc35 + yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.resize (yyvs35, yyvsc35)
		end
	end
	yyvs35.put (yyval35, yyvsp35)
end
when 154 then
--|#line 1310 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1310")
end

			create date_time_interval.make_upper_unbounded(yyvs9.item (yyvsp9), True)
			yyval35 := date_time_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp35 := yyvsp35 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp9 := yyvsp9 -1
	if yyvsp35 >= yyvsc35 then
		if yyvs35 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs35")
			end
			create yyspecial_routines35
			yyvsc35 := yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.make (yyvsc35)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs35")
			end
			yyvsc35 := yyvsc35 + yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.resize (yyvs35, yyvsc35)
		end
	end
	yyvs35.put (yyval35, yyvsp35)
end
when 155 then
--|#line 1315 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1315")
end

			create date_time_interval.make_point(yyvs9.item (yyvsp9))
			yyval35 := date_time_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp35 := yyvsp35 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp9 := yyvsp9 -1
	if yyvsp35 >= yyvsc35 then
		if yyvs35 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs35")
			end
			create yyspecial_routines35
			yyvsc35 := yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.make (yyvsc35)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs35")
			end
			yyvsc35 := yyvsc35 + yyInitial_yyvs_size
			yyvs35 := yyspecial_routines35.resize (yyvs35, yyvsc35)
		end
	end
	yyvs35.put (yyval35, yyvsp35)
end
when 156 then
--|#line 1322 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1322")
end

			if valid_iso8601_duration(yyvs5.item (yyvsp5)) then
				create yyval11.make_from_string(yyvs5.item (yyvsp5))
			else
				raise_error
				report_error("invalid ISO8601 duration: " + yyvs5.item (yyvsp5))
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp11 := yyvsp11 + 1
	yyvsp5 := yyvsp5 -1
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
when 157 then
--|#line 1334 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1334")
end

			create yyval28.make(0)
			yyval28.extend(yyvs11.item (yyvsp11 - 1))
			yyval28.extend(yyvs11.item (yyvsp11))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp28 := yyvsp28 + 1
	yyvsp11 := yyvsp11 -2
	yyvsp1 := yyvsp1 -1
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
when 158 then
--|#line 1340 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1340")
end

			yyvs28.item (yyvsp28).extend(yyvs11.item (yyvsp11))
			yyval28 := yyvs28.item (yyvsp28)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp11 := yyvsp11 -1
	yyvs28.put (yyval28, yyvsp28)
end
when 159 then
--|#line 1345 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1345")
end

			create yyval28.make(0)
			yyval28.extend(yyvs11.item (yyvsp11))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp28 := yyvsp28 + 1
	yyvsp11 := yyvsp11 -1
	yyvsp1 := yyvsp1 -2
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
when 160 then
--|#line 1352 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1352")
end

			if yyvs11.item (yyvsp11 - 1) <= yyvs11.item (yyvsp11) then
				create duration_interval.make_bounded(yyvs11.item (yyvsp11 - 1), yyvs11.item (yyvsp11), True, True)
				yyval36 := duration_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs11.item (yyvsp11 - 1).out + " must be <= " + yyvs11.item (yyvsp11).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 5
	yyvsp36 := yyvsp36 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp11 := yyvsp11 -2
	if yyvsp36 >= yyvsc36 then
		if yyvs36 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs36")
			end
			create yyspecial_routines36
			yyvsc36 := yyInitial_yyvs_size
			yyvs36 := yyspecial_routines36.make (yyvsc36)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs36")
			end
			yyvsc36 := yyvsc36 + yyInitial_yyvs_size
			yyvs36 := yyspecial_routines36.resize (yyvs36, yyvsc36)
		end
	end
	yyvs36.put (yyval36, yyvsp36)
end
when 161 then
--|#line 1363 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1363")
end

			if yyvs11.item (yyvsp11 - 1) <= yyvs11.item (yyvsp11) then
				create duration_interval.make_bounded(yyvs11.item (yyvsp11 - 1), yyvs11.item (yyvsp11), False, True)
				yyval36 := duration_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs11.item (yyvsp11 - 1).out + " must be <= " + yyvs11.item (yyvsp11).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp36 := yyvsp36 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp11 := yyvsp11 -2
	if yyvsp36 >= yyvsc36 then
		if yyvs36 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs36")
			end
			create yyspecial_routines36
			yyvsc36 := yyInitial_yyvs_size
			yyvs36 := yyspecial_routines36.make (yyvsc36)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs36")
			end
			yyvsc36 := yyvsc36 + yyInitial_yyvs_size
			yyvs36 := yyspecial_routines36.resize (yyvs36, yyvsc36)
		end
	end
	yyvs36.put (yyval36, yyvsp36)
end
when 162 then
--|#line 1374 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1374")
end

			if yyvs11.item (yyvsp11 - 1) <= yyvs11.item (yyvsp11) then
				create duration_interval.make_bounded(yyvs11.item (yyvsp11 - 1), yyvs11.item (yyvsp11), True, False)
				yyval36 := duration_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs11.item (yyvsp11 - 1).out + " must be <= " + yyvs11.item (yyvsp11).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 6
	yyvsp36 := yyvsp36 + 1
	yyvsp1 := yyvsp1 -4
	yyvsp11 := yyvsp11 -2
	if yyvsp36 >= yyvsc36 then
		if yyvs36 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs36")
			end
			create yyspecial_routines36
			yyvsc36 := yyInitial_yyvs_size
			yyvs36 := yyspecial_routines36.make (yyvsc36)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs36")
			end
			yyvsc36 := yyvsc36 + yyInitial_yyvs_size
			yyvs36 := yyspecial_routines36.resize (yyvs36, yyvsc36)
		end
	end
	yyvs36.put (yyval36, yyvsp36)
end
when 163 then
--|#line 1385 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1385")
end

			if yyvs11.item (yyvsp11 - 1) <= yyvs11.item (yyvsp11) then
				create duration_interval.make_bounded(yyvs11.item (yyvsp11 - 1), yyvs11.item (yyvsp11), False, False)
				yyval36 := duration_interval
			else
				raise_error
				report_error("Invalid interval: " + yyvs11.item (yyvsp11 - 1).out + " must be <= " + yyvs11.item (yyvsp11).out)
				abort
			end
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 7
	yyvsp36 := yyvsp36 + 1
	yyvsp1 := yyvsp1 -5
	yyvsp11 := yyvsp11 -2
	if yyvsp36 >= yyvsc36 then
		if yyvs36 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs36")
			end
			create yyspecial_routines36
			yyvsc36 := yyInitial_yyvs_size
			yyvs36 := yyspecial_routines36.make (yyvsc36)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs36")
			end
			yyvsc36 := yyvsc36 + yyInitial_yyvs_size
			yyvs36 := yyspecial_routines36.resize (yyvs36, yyvsc36)
		end
	end
	yyvs36.put (yyval36, yyvsp36)
end
when 164 then
--|#line 1396 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1396")
end

			create duration_interval.make_lower_unbounded(yyvs11.item (yyvsp11), False)
			yyval36 := duration_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp36 := yyvsp36 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp11 := yyvsp11 -1
	if yyvsp36 >= yyvsc36 then
		if yyvs36 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs36")
			end
			create yyspecial_routines36
			yyvsc36 := yyInitial_yyvs_size
			yyvs36 := yyspecial_routines36.make (yyvsc36)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs36")
			end
			yyvsc36 := yyvsc36 + yyInitial_yyvs_size
			yyvs36 := yyspecial_routines36.resize (yyvs36, yyvsc36)
		end
	end
	yyvs36.put (yyval36, yyvsp36)
end
when 165 then
--|#line 1401 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1401")
end

			create duration_interval.make_lower_unbounded(yyvs11.item (yyvsp11), True)
			yyval36 := duration_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp36 := yyvsp36 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp11 := yyvsp11 -1
	if yyvsp36 >= yyvsc36 then
		if yyvs36 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs36")
			end
			create yyspecial_routines36
			yyvsc36 := yyInitial_yyvs_size
			yyvs36 := yyspecial_routines36.make (yyvsc36)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs36")
			end
			yyvsc36 := yyvsc36 + yyInitial_yyvs_size
			yyvs36 := yyspecial_routines36.resize (yyvs36, yyvsc36)
		end
	end
	yyvs36.put (yyval36, yyvsp36)
end
when 166 then
--|#line 1406 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1406")
end

			create duration_interval.make_upper_unbounded(yyvs11.item (yyvsp11), False)
			yyval36 := duration_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp36 := yyvsp36 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp11 := yyvsp11 -1
	if yyvsp36 >= yyvsc36 then
		if yyvs36 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs36")
			end
			create yyspecial_routines36
			yyvsc36 := yyInitial_yyvs_size
			yyvs36 := yyspecial_routines36.make (yyvsc36)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs36")
			end
			yyvsc36 := yyvsc36 + yyInitial_yyvs_size
			yyvs36 := yyspecial_routines36.resize (yyvs36, yyvsc36)
		end
	end
	yyvs36.put (yyval36, yyvsp36)
end
when 167 then
--|#line 1411 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1411")
end

			create duration_interval.make_upper_unbounded(yyvs11.item (yyvsp11), True)
			yyval36 := duration_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 4
	yyvsp36 := yyvsp36 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp11 := yyvsp11 -1
	if yyvsp36 >= yyvsc36 then
		if yyvs36 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs36")
			end
			create yyspecial_routines36
			yyvsc36 := yyInitial_yyvs_size
			yyvs36 := yyspecial_routines36.make (yyvsc36)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs36")
			end
			yyvsc36 := yyvsc36 + yyInitial_yyvs_size
			yyvs36 := yyspecial_routines36.resize (yyvs36, yyvsc36)
		end
	end
	yyvs36.put (yyval36, yyvsp36)
end
when 168 then
--|#line 1416 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1416")
end

			create duration_interval.make_point(yyvs11.item (yyvsp11))
			yyval36 := duration_interval
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp36 := yyvsp36 + 1
	yyvsp1 := yyvsp1 -2
	yyvsp11 := yyvsp11 -1
	if yyvsp36 >= yyvsc36 then
		if yyvs36 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs36")
			end
			create yyspecial_routines36
			yyvsc36 := yyInitial_yyvs_size
			yyvs36 := yyspecial_routines36.make (yyvsc36)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs36")
			end
			yyvsc36 := yyvsc36 + yyInitial_yyvs_size
			yyvs36 := yyspecial_routines36.resize (yyvs36, yyvsc36)
		end
	end
	yyvs36.put (yyval36, yyvsp36)
end
when 169 then
--|#line 1423 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1423")
end

			create term.make_from_string(yyvs5.item (yyvsp5))
			yyval12 := term
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp12 := yyvsp12 + 1
	yyvsp5 := yyvsp5 -1
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
when 170 then
--|#line 1428 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1428")
end

			raise_error
			report_error("Invalid term code reference: %"" + yyvs5.item (yyvsp5) + "%"; spaces not allowed in code string")
			abort
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp12 := yyvsp12 + 1
	yyvsp5 := yyvsp5 -1
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
when 171 then
--|#line 1436 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1436")
end

			create yyval29.make(0)
			yyval29.extend(yyvs12.item (yyvsp12 - 1))
			yyval29.extend(yyvs12.item (yyvsp12))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp29 := yyvsp29 + 1
	yyvsp12 := yyvsp12 -2
	yyvsp1 := yyvsp1 -1
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
when 172 then
--|#line 1442 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1442")
end

			yyvs29.item (yyvsp29).extend(yyvs12.item (yyvsp12))
			yyval29 := yyvs29.item (yyvsp29)
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp12 := yyvsp12 -1
	yyvs29.put (yyval29, yyvsp29)
end
when 173 then
--|#line 1447 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1447")
end

			create yyval29.make(0)
			yyval29.extend(yyvs12.item (yyvsp12))
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 3
	yyvsp29 := yyvsp29 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp1 := yyvsp1 -2
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
when 174 then
--|#line 1454 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1454")
end

			create a_uri.make_from_string(yyvs5.item (yyvsp5))
			yyval13 := a_uri
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvsp13 := yyvsp13 + 1
	yyvsp5 := yyvsp5 -1
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
when 175 then
--|#line 1461 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1461")
end

			create a_path.make_from_string(yyvs5.item (yyvsp5))
			yyval1 := a_path
		
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
when 176 then
--|#line 1466 "dadl2_validator.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'dadl2_validator.y' at line 1466")
end

			create a_path.make_root
			yyval1 := a_path
		
if yy_parsing_status >= yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
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
			when 314 then
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
			   43,   44,    2,   46,   45,   47,    2,   48,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,   40,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,    2,    2,    2,    2,    2,    2,    2,    2,    2,
			    2,   41,    2,   42,    2,    2,    2,    2,    2,    2,

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
			   35,   36,   37,   38,   39, yyDummy>>)
		end

	yyr1_template: SPECIAL [INTEGER] is
			-- Template for `yyr1'
		once
			Result := yyfixed_array (<<
			    0,   87,   87,   87,   88,   88,   88,   89,   90,   90,
			   91,   91,   66,   66,   64,   64,   65,   92,   93,   93,
			   94,   95,   62,   62,   63,   63,   97,   68,   68,   67,
			   98,   98,   98,   98,   98,   96,   96,   96,   96,   96,
			   96,   96,   96,   96,   96,   96,   96,   96,   79,   79,
			   79,   79,   79,   79,   79,   79,   79,   86,   86,   86,
			   86,   86,   86,   49,   49,   49,   49,   99,   69,   69,
			   69,   69,   69,   69,   69,   69,   50,   50,   50,   70,
			   70,   70,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   51,   51,   51,   52,   71,   71,   71,   81,   81,

			   81,   81,   81,   81,   81,   81,   81,   53,   53,   73,
			   73,   73,   61,   54,   72,   72,   72,   55,   74,   74,
			   74,   83,   83,   83,   83,   83,   83,   83,   83,   83,
			   57,   75,   75,   75,   82,   82,   82,   82,   82,   82,
			   82,   82,   82,   56,   76,   76,   76,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   58,   77,   77,   77,
			   85,   85,   85,   85,   85,   85,   85,   85,   85,   59,
			   59,   78,   78,   78,   60,  100,  100, yyDummy>>)
		end

	yytypes1_template: SPECIAL [INTEGER] is
			-- Template for `yytypes1'
		once
			Result := yyfixed_array (<<
			    1,    1,    1,    5,    5,    5,    1,    5,   15,   15,
			   15,   15,   15,    1,    1,    1,    1,    1,    5,    5,
			    1,   15,   15,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    5,   15,   16,   16,
			    1,    1,    1,    1,    5,    1,    1,    1,    6,    5,
			    5,    5,    5,    5,    5,    4,    3,    2,    2,    3,
			    4,    7,    6,    8,    9,   10,   11,   13,   14,    1,
			    1,    1,    1,    1,    1,    1,    5,    1,    1,    5,
			    5,    2,    3,    7,    6,    8,    9,   10,   11,   12,
			   17,   18,   20,   22,   24,   25,   26,   27,   28,   29,

			   30,   31,   32,   33,   34,   35,   36,   38,    1,    1,
			   16,    3,    2,    3,    2,    1,    1,    1,    1,    1,
			    1,    1,    2,    3,    8,    9,   10,   11,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    5,    2,    3,    8,    9,   10,   11,    2,    3,
			    8,    9,   10,   11,    2,    3,    8,    9,   10,   11,
			    2,    3,    8,    9,   10,   11,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    5,    1,    1,    1,    2,    1,    1,    1,    3,    1,

			    7,    1,    6,    1,    8,    1,    9,    1,   10,    1,
			   11,    1,   12,    1,    5,    2,    3,    6,    7,    8,
			   10,    9,   11,   12,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    2,    1,    3,    1,    8,
			    1,    9,    1,   10,    1,   11,    1,    2,    1,    3,
			    1,    8,    1,    9,    1,   10,    1,   11,    2,    1,
			    3,    1,    8,    1,    9,    1,   10,    1,   11,    1,
			    2,    1,    3,    1,    8,    1,    9,    1,   10,    1,

			   11,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1, yyDummy>>)
		end

	yytypes2_template: SPECIAL [INTEGER] is
			-- Template for `yytypes2'
		once
			Result := yyfixed_array (<<
			    1,    1,    1,    2,    3,    4,    5,    5,    5,    5,
			    5,    5,    5,    5,    5,    5,    5,    5,    5,    6,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    5,    5,
			    1,    1,    1,    1,    1,    1,    1,    1,    1, yyDummy>>)
		end

	yydefact_template: SPECIAL [INTEGER] is
			-- Template for `yydefact'
		once
			Result := yyfixed_array (<<
			    0,    0,   26,    0,   66,   65,    3,    0,   12,   22,
			   13,   14,    2,    1,    4,    0,    0,    0,    0,    0,
			    9,   23,   15,    0,    5,    0,    0,    0,   18,    0,
			   24,    0,   64,   63,    6,   26,    0,   10,   27,   11,
			    7,  176,    0,    0,  175,  108,  107,  112,  113,  174,
			  156,  143,  130,  117,   67,   94,   91,   76,   36,   37,
			   38,   39,   40,   41,   43,   42,   44,   45,   47,    0,
			   35,   46,   16,   19,    0,   25,  170,  112,    0,  169,
			   67,   36,   37,   39,   40,   41,   43,   42,   44,   33,
			   48,   49,   50,   52,   51,   53,   54,   55,   56,   34,

			   31,   57,   58,   60,   59,   61,   62,   32,   30,    0,
			   28,   93,   78,   92,   77,   21,   20,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,   29,   69,
			   75,   71,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,   90,    0,  106,    0,
			  129,    0,  155,    0,  142,    0,  168,    0,   70,   74,
			   68,    0,    0,   81,   79,    0,    0,   97,   95,  111,

			  109,  116,  114,  120,  118,  146,  144,  133,  131,  159,
			  157,  173,  171,   73,   72,   80,   96,  115,  110,  119,
			  132,  145,  158,  172,   89,  105,  128,  154,  141,  167,
			   87,  103,  126,  152,  139,  165,   88,    0,  104,    0,
			  127,    0,  153,    0,  140,    0,  166,    0,   86,  102,
			  125,  151,  138,  164,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,   82,
			    0,   98,    0,  121,    0,  147,    0,  134,    0,  160,
			    0,   83,    0,   99,    0,  122,    0,  148,    0,  135,

			    0,  161,   84,  100,  123,  149,  136,  162,   85,  101,
			  124,  150,  137,  163,    0,    0,    0, yyDummy>>)
		end

	yydefgoto_template: SPECIAL [INTEGER] is
			-- Template for `yydefgoto'
		once
			Result := yyfixed_array (<<
			   36,   58,   59,   60,   61,   62,   63,   64,   65,   66,
			   89,   67,   68,    8,    9,   10,   11,   37,   38,   39,
			   90,   91,   92,   93,   94,   95,   96,   97,   98,   99,
			  100,  101,  102,  103,  104,  105,  106,  107,  314,   13,
			   14,   15,   40,   16,   27,   28,   29,   69,   17,  109,
			   70,   71, yyDummy>>)
		end

	yypact_template: SPECIAL [INTEGER] is
			-- Template for `yypact'
		once
			Result := yyfixed_array (<<
			  220,  172,  333,  114, -32768, -32768, -32768,  353, -32768, -32768,
			 -32768, -32768, -32768,   36, -32768,  347,  329,  111,  328,  327,
			 -32768, -32768, -32768,  326, -32768,  131,  158,  174, -32768,  325,
			 -32768,  104, -32768, -32768, -32768,   11,  324, -32768, -32768, -32768,
			 -32768, -32768,  246,  205, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,  265,
			 -32768, -32768, -32768, -32768,  131, -32768, -32768,  323,  190, -32768,
			  322,  321,  320,  319,  318,  317,  316,  315,  314,  313,
			  312,  311,  310,  309,  308,  307,  306,  305,  304,  301,

			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,  302,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768,  156,   22,   22,
			   22,   22,  257,  256,  255,  251,  250,  244,   53,  102,
			   24,  222,   48,   56,   51,   -6,  183,  175,  181,   14,
			  126,  303,  153,  281,  261,  277,  219,  148, -32768, -32768,
			 -32768, -32768,  298,  295,  294,  293,  292,  291,  290,  289,
			  288,  287,  286,  285,  243,  239,  238,  231,  225,  -17,
			  284,  283,  282,  280,  279,  278, -32768,    7, -32768,   70,
			 -32768,  149, -32768,  134, -32768,  123, -32768,  206, -32768, -32768,
			 -32768,  300,  299, -32768, -32768,  297,  296, -32768, -32768, -32768,

			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768,   -1, -32768,   32,
			 -32768,  143, -32768,  115, -32768,   97, -32768,  179, -32768, -32768,
			 -32768, -32768, -32768, -32768,   14,  273,  126,  272,  281,  271,
			  277,  270,  261,  269,  219,  268,   14,  267,  126,  266,
			  281,  264,  277,  262,  261,  260,  219,  259,  258, -32768,
			  242, -32768,  234, -32768,  230, -32768,  229, -32768,  218, -32768,
			  213, -32768,  208, -32768,  191, -32768,  119, -32768,  105, -32768,

			   47, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768,   65,   13, -32768, yyDummy>>)
		end

	yypgoto_template: SPECIAL [INTEGER] is
			-- Template for `yypgoto'
		once
			Result := yyfixed_array (<<
			  332,   21,    3, -32768,  -28,  -32,  -23,  -27,  -31,  -35,
			   83, -32768, -32768, -32768,  121, -32768,   99,  330,  341, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,  331,
			  -12, -32768,  252, -32768, -32768,  349, -32768,  340, -32768, -32768,
			 -32768, -32768, yyDummy>>)
		end

	yytable_template: SPECIAL [INTEGER] is
			-- Template for `yytable'
		once
			Result := yyfixed_array (<<
			   88,   24,   57,   84,   87,   52,  247,   83,   86,  246,
			   57,   34,   85,  316,   57,   56,   55,   57,  207,   24,
			   80,   53,   52,   51,   50,   57,   56,   79,   56,   49,
			   48,  266,   53,   52,   51,   50,   56,   78,   82,  254,
			   77,   46,   45,  127,    3,  192,  191,  126,  197,   76,
			   44,  125,  -17,  192,  191,  124,   81,   43,   42,   41,
			  192,  191,  190,   51,  268,  315,   53,   48,   43,   42,
			  196,  195,  201,  313,   56,  205,   23,  189,  196,  195,
			  203,  123,  188,  157,  163,  169,  175,  156,  162,  168,
			  174,  155,  161,  167,  173,  154,  160,  166,  172,  122,

			  202,  210,  256,  200,  208,   57,   22,  206,   52,  217,
			  204,  222,    3,  220,  218,   20,  196,  195,  221,    3,
			  219,  153,  159,  165,  171,   75,  193,   51,   21,  274,
			   56,  312,   30,  198,   52,   22,   -8,    5,    4,  152,
			  158,  164,  170,  216,   23,  311,   51,  272,  192,  191,
			  194,   35,  265,   53,  263,  262,  261,   21,  259,   53,
			  215,   57,   56,   55,   79,  151,  260,   54,   53,   52,
			   51,   50,  196,  195,    1,  270,   49,   48,   19,   18,
			  150,  258,  257,   46,   45,  149,   76,   47,   46,   45,
			  214,   79,   50,   57,   56,   72,   50,   44,  255,  211,

			   53,   52,   51,   50,   43,   42,   41,  209,  114,  113,
			  213,  276,  277,   76,  275,   26,  273,  310,  271,   50,
			  212,    6,  121,  120,  119,  118,    5,    4,    3,  288,
			  223,  286,   50,  284,  309,  282,   43,   42,  264,  308,
			    2,  300,  269,  298,  307,  296,  199,  294,  245,  112,
			  111,  244,   46,   45,  243,  306,  305,  242,  267,  280,
			  304,  241,  239,    1,  240,  238,  237,  187,  303,  236,
			  186,  292,   52,  185,  183,  278,  184,  182,  181,  179,
			  177,  180,  178,  176,  302,  301,  299,  290,  297,   51,
			  295,   53,  293,  291,  289,  287,  285,  283,  281,  279,

			  113,  111,  114,  112,  253,  252,  251,  115,  250,  249,
			  248,  235,  234,  233,  232,  231,  230,  229,  228,  227,
			  226,  225,   48,  148,  224,    0,  116,    0,    0,    0,
			   12,    0,    7,    0,    3,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,   35,    0,  147,   74,   31,  146,
			  145,  144,  143,  142,  141,  140,  139,  138,  137,  136,
			  135,  134,  133,  132,  131,  130,  129,  128,  117,   25,
			   26,   33,   32,    2,  -17,  108,   73,  110, yyDummy>>)
		end

	yycheck_template: SPECIAL [INTEGER] is
			-- Template for `yycheck'
		once
			Result := yyfixed_array (<<
			   35,   13,    3,   35,   35,   11,   23,   35,   35,   26,
			    3,   23,   35,    0,    3,    4,    5,    3,   24,   31,
			    9,   10,   11,   12,   13,    3,    4,   16,    4,   18,
			   19,   32,   10,   11,   12,   13,    4,   26,   35,   32,
			   29,   30,   31,   78,    8,   46,   47,   78,   24,   38,
			   39,   78,   41,   46,   47,   78,   35,   46,   47,   48,
			   46,   47,    9,   12,   32,    0,   10,   19,   46,   47,
			   46,   47,   24,   26,    4,   24,   40,   24,   46,   47,
			   24,   78,   29,  118,  119,  120,  121,  118,  119,  120,
			  121,  118,  119,  120,  121,  118,  119,  120,  121,   78,

			  132,  136,   32,  131,  135,    3,    7,  134,   11,  141,
			  133,  146,    8,  144,  142,    1,   46,   47,  145,    8,
			  143,  118,  119,  120,  121,   21,   24,   12,    7,   32,
			    4,   26,   21,  130,   11,   36,   22,    6,    7,  118,
			  119,  120,  121,  140,   40,   26,   12,   32,   46,   47,
			  129,   20,  187,   10,  185,   32,  183,   36,  181,   10,
			  139,    3,    4,    5,   16,    9,   32,    9,   10,   11,
			   12,   13,   46,   47,   43,   32,   18,   19,    6,    7,
			   24,   32,  179,   30,   31,   29,   38,   29,   30,   31,
			    9,   16,   13,    3,    4,   21,   13,   39,  177,   24,

			   10,   11,   12,   13,   46,   47,   48,   24,    3,    4,
			   29,   32,  247,   38,  245,   41,  243,   26,  241,   13,
			  137,    1,   32,   33,   34,   35,    6,    7,    8,  264,
			  147,  262,   13,  260,   26,  258,   46,   47,   32,   26,
			   20,  276,  239,  274,   26,  272,   24,  270,   23,    3,
			    4,   26,   30,   31,   23,   26,   26,   26,  237,  256,
			   26,   23,   23,   43,   26,   26,   23,   23,   26,   26,
			   26,  268,   11,   23,   23,  254,   26,   26,   23,   23,
			   23,   26,   26,   26,   26,   26,   26,  266,   26,   12,
			   26,   10,   26,   26,   26,   26,   26,   26,   26,   26,

			    4,    4,    3,    3,   26,   26,   26,   42,   26,   26,
			   26,   26,   26,   26,   26,   26,   26,   26,   26,   26,
			   26,   26,   19,   21,   26,   -1,   74,   -1,   -1,   -1,
			    0,   -1,    0,   -1,    8,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   20,   -1,   45,   22,   17,   45,
			   45,   45,   45,   45,   45,   45,   45,   45,   45,   45,
			   45,   45,   45,   45,   45,   45,   45,   45,   45,   22,
			   41,   44,   44,   20,   41,   35,   27,   36, yyDummy>>)
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

	yyvs4: SPECIAL [POINTER]
			-- Stack for semantic values of type POINTER

	yyvsc4: INTEGER
			-- Capacity of semantic value stack `yyvs4'

	yyvsp4: INTEGER
			-- Top of semantic value stack `yyvs4'

	yyspecial_routines4: KL_SPECIAL_ROUTINES [POINTER]
			-- Routines that ought to be in SPECIAL [POINTER]

	yyvs5: SPECIAL [STRING]
			-- Stack for semantic values of type STRING

	yyvsc5: INTEGER
			-- Capacity of semantic value stack `yyvs5'

	yyvsp5: INTEGER
			-- Top of semantic value stack `yyvs5'

	yyspecial_routines5: KL_SPECIAL_ROUTINES [STRING]
			-- Routines that ought to be in SPECIAL [STRING]

	yyvs6: SPECIAL [CHARACTER]
			-- Stack for semantic values of type CHARACTER

	yyvsc6: INTEGER
			-- Capacity of semantic value stack `yyvs6'

	yyvsp6: INTEGER
			-- Top of semantic value stack `yyvs6'

	yyspecial_routines6: KL_SPECIAL_ROUTINES [CHARACTER]
			-- Routines that ought to be in SPECIAL [CHARACTER]

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

	yyvs12: SPECIAL [CODE_PHRASE]
			-- Stack for semantic values of type CODE_PHRASE

	yyvsc12: INTEGER
			-- Capacity of semantic value stack `yyvs12'

	yyvsp12: INTEGER
			-- Top of semantic value stack `yyvs12'

	yyspecial_routines12: KL_SPECIAL_ROUTINES [CODE_PHRASE]
			-- Routines that ought to be in SPECIAL [CODE_PHRASE]

	yyvs13: SPECIAL [URI]
			-- Stack for semantic values of type URI

	yyvsc13: INTEGER
			-- Capacity of semantic value stack `yyvs13'

	yyvsp13: INTEGER
			-- Top of semantic value stack `yyvs13'

	yyspecial_routines13: KL_SPECIAL_ROUTINES [URI]
			-- Routines that ought to be in SPECIAL [URI]

	yyvs14: SPECIAL [INTEGER_REF]
			-- Stack for semantic values of type INTEGER_REF

	yyvsc14: INTEGER
			-- Capacity of semantic value stack `yyvs14'

	yyvsp14: INTEGER
			-- Top of semantic value stack `yyvs14'

	yyspecial_routines14: KL_SPECIAL_ROUTINES [INTEGER_REF]
			-- Routines that ought to be in SPECIAL [INTEGER_REF]

	yyvs15: SPECIAL [DT_COMPLEX_OBJECT_NODE]
			-- Stack for semantic values of type DT_COMPLEX_OBJECT_NODE

	yyvsc15: INTEGER
			-- Capacity of semantic value stack `yyvs15'

	yyvsp15: INTEGER
			-- Top of semantic value stack `yyvs15'

	yyspecial_routines15: KL_SPECIAL_ROUTINES [DT_COMPLEX_OBJECT_NODE]
			-- Routines that ought to be in SPECIAL [DT_COMPLEX_OBJECT_NODE]

	yyvs16: SPECIAL [DT_OBJECT_LEAF]
			-- Stack for semantic values of type DT_OBJECT_LEAF

	yyvsc16: INTEGER
			-- Capacity of semantic value stack `yyvs16'

	yyvsp16: INTEGER
			-- Top of semantic value stack `yyvs16'

	yyspecial_routines16: KL_SPECIAL_ROUTINES [DT_OBJECT_LEAF]
			-- Routines that ought to be in SPECIAL [DT_OBJECT_LEAF]

	yyvs17: SPECIAL [ARRAYED_LIST [STRING]]
			-- Stack for semantic values of type ARRAYED_LIST [STRING]

	yyvsc17: INTEGER
			-- Capacity of semantic value stack `yyvs17'

	yyvsp17: INTEGER
			-- Top of semantic value stack `yyvs17'

	yyspecial_routines17: KL_SPECIAL_ROUTINES [ARRAYED_LIST [STRING]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [STRING]]

	yyvs18: SPECIAL [ARRAYED_LIST [INTEGER_REF]]
			-- Stack for semantic values of type ARRAYED_LIST [INTEGER_REF]

	yyvsc18: INTEGER
			-- Capacity of semantic value stack `yyvs18'

	yyvsp18: INTEGER
			-- Top of semantic value stack `yyvs18'

	yyspecial_routines18: KL_SPECIAL_ROUTINES [ARRAYED_LIST [INTEGER_REF]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [INTEGER_REF]]

	yyvs19: SPECIAL [REAL_REF]
			-- Stack for semantic values of type REAL_REF

	yyvsc19: INTEGER
			-- Capacity of semantic value stack `yyvs19'

	yyvsp19: INTEGER
			-- Top of semantic value stack `yyvs19'

	yyspecial_routines19: KL_SPECIAL_ROUTINES [REAL_REF]
			-- Routines that ought to be in SPECIAL [REAL_REF]

	yyvs20: SPECIAL [ARRAYED_LIST [REAL_REF]]
			-- Stack for semantic values of type ARRAYED_LIST [REAL_REF]

	yyvsc20: INTEGER
			-- Capacity of semantic value stack `yyvs20'

	yyvsp20: INTEGER
			-- Top of semantic value stack `yyvs20'

	yyspecial_routines20: KL_SPECIAL_ROUTINES [ARRAYED_LIST [REAL_REF]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [REAL_REF]]

	yyvs21: SPECIAL [CHARACTER_REF]
			-- Stack for semantic values of type CHARACTER_REF

	yyvsc21: INTEGER
			-- Capacity of semantic value stack `yyvs21'

	yyvsp21: INTEGER
			-- Top of semantic value stack `yyvs21'

	yyspecial_routines21: KL_SPECIAL_ROUTINES [CHARACTER_REF]
			-- Routines that ought to be in SPECIAL [CHARACTER_REF]

	yyvs22: SPECIAL [ARRAYED_LIST [CHARACTER_REF]]
			-- Stack for semantic values of type ARRAYED_LIST [CHARACTER_REF]

	yyvsc22: INTEGER
			-- Capacity of semantic value stack `yyvs22'

	yyvsp22: INTEGER
			-- Top of semantic value stack `yyvs22'

	yyspecial_routines22: KL_SPECIAL_ROUTINES [ARRAYED_LIST [CHARACTER_REF]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [CHARACTER_REF]]

	yyvs23: SPECIAL [BOOLEAN_REF]
			-- Stack for semantic values of type BOOLEAN_REF

	yyvsc23: INTEGER
			-- Capacity of semantic value stack `yyvs23'

	yyvsp23: INTEGER
			-- Top of semantic value stack `yyvs23'

	yyspecial_routines23: KL_SPECIAL_ROUTINES [BOOLEAN_REF]
			-- Routines that ought to be in SPECIAL [BOOLEAN_REF]

	yyvs24: SPECIAL [ARRAYED_LIST [BOOLEAN_REF]]
			-- Stack for semantic values of type ARRAYED_LIST [BOOLEAN_REF]

	yyvsc24: INTEGER
			-- Capacity of semantic value stack `yyvs24'

	yyvsp24: INTEGER
			-- Top of semantic value stack `yyvs24'

	yyspecial_routines24: KL_SPECIAL_ROUTINES [ARRAYED_LIST [BOOLEAN_REF]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [BOOLEAN_REF]]

	yyvs25: SPECIAL [ARRAYED_LIST [ISO8601_DATE]]
			-- Stack for semantic values of type ARRAYED_LIST [ISO8601_DATE]

	yyvsc25: INTEGER
			-- Capacity of semantic value stack `yyvs25'

	yyvsp25: INTEGER
			-- Top of semantic value stack `yyvs25'

	yyspecial_routines25: KL_SPECIAL_ROUTINES [ARRAYED_LIST [ISO8601_DATE]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [ISO8601_DATE]]

	yyvs26: SPECIAL [ARRAYED_LIST [ISO8601_TIME]]
			-- Stack for semantic values of type ARRAYED_LIST [ISO8601_TIME]

	yyvsc26: INTEGER
			-- Capacity of semantic value stack `yyvs26'

	yyvsp26: INTEGER
			-- Top of semantic value stack `yyvs26'

	yyspecial_routines26: KL_SPECIAL_ROUTINES [ARRAYED_LIST [ISO8601_TIME]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [ISO8601_TIME]]

	yyvs27: SPECIAL [ARRAYED_LIST [ISO8601_DATE_TIME]]
			-- Stack for semantic values of type ARRAYED_LIST [ISO8601_DATE_TIME]

	yyvsc27: INTEGER
			-- Capacity of semantic value stack `yyvs27'

	yyvsp27: INTEGER
			-- Top of semantic value stack `yyvs27'

	yyspecial_routines27: KL_SPECIAL_ROUTINES [ARRAYED_LIST [ISO8601_DATE_TIME]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [ISO8601_DATE_TIME]]

	yyvs28: SPECIAL [ARRAYED_LIST [ISO8601_DURATION]]
			-- Stack for semantic values of type ARRAYED_LIST [ISO8601_DURATION]

	yyvsc28: INTEGER
			-- Capacity of semantic value stack `yyvs28'

	yyvsp28: INTEGER
			-- Top of semantic value stack `yyvs28'

	yyspecial_routines28: KL_SPECIAL_ROUTINES [ARRAYED_LIST [ISO8601_DURATION]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [ISO8601_DURATION]]

	yyvs29: SPECIAL [ARRAYED_LIST [CODE_PHRASE]]
			-- Stack for semantic values of type ARRAYED_LIST [CODE_PHRASE]

	yyvsc29: INTEGER
			-- Capacity of semantic value stack `yyvs29'

	yyvsp29: INTEGER
			-- Top of semantic value stack `yyvs29'

	yyspecial_routines29: KL_SPECIAL_ROUTINES [ARRAYED_LIST [CODE_PHRASE]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [CODE_PHRASE]]

	yyvs30: SPECIAL [ARRAYED_LIST [ANY]]
			-- Stack for semantic values of type ARRAYED_LIST [ANY]

	yyvsc30: INTEGER
			-- Capacity of semantic value stack `yyvs30'

	yyvsp30: INTEGER
			-- Top of semantic value stack `yyvs30'

	yyspecial_routines30: KL_SPECIAL_ROUTINES [ARRAYED_LIST [ANY]]
			-- Routines that ought to be in SPECIAL [ARRAYED_LIST [ANY]]

	yyvs31: SPECIAL [INTERVAL_EHR [INTEGER_REF]]
			-- Stack for semantic values of type INTERVAL_EHR [INTEGER_REF]

	yyvsc31: INTEGER
			-- Capacity of semantic value stack `yyvs31'

	yyvsp31: INTEGER
			-- Top of semantic value stack `yyvs31'

	yyspecial_routines31: KL_SPECIAL_ROUTINES [INTERVAL_EHR [INTEGER_REF]]
			-- Routines that ought to be in SPECIAL [INTERVAL_EHR [INTEGER_REF]]

	yyvs32: SPECIAL [INTERVAL_EHR [REAL_REF]]
			-- Stack for semantic values of type INTERVAL_EHR [REAL_REF]

	yyvsc32: INTEGER
			-- Capacity of semantic value stack `yyvs32'

	yyvsp32: INTEGER
			-- Top of semantic value stack `yyvs32'

	yyspecial_routines32: KL_SPECIAL_ROUTINES [INTERVAL_EHR [REAL_REF]]
			-- Routines that ought to be in SPECIAL [INTERVAL_EHR [REAL_REF]]

	yyvs33: SPECIAL [INTERVAL_EHR [ISO8601_TIME]]
			-- Stack for semantic values of type INTERVAL_EHR [ISO8601_TIME]

	yyvsc33: INTEGER
			-- Capacity of semantic value stack `yyvs33'

	yyvsp33: INTEGER
			-- Top of semantic value stack `yyvs33'

	yyspecial_routines33: KL_SPECIAL_ROUTINES [INTERVAL_EHR [ISO8601_TIME]]
			-- Routines that ought to be in SPECIAL [INTERVAL_EHR [ISO8601_TIME]]

	yyvs34: SPECIAL [INTERVAL_EHR [ISO8601_DATE]]
			-- Stack for semantic values of type INTERVAL_EHR [ISO8601_DATE]

	yyvsc34: INTEGER
			-- Capacity of semantic value stack `yyvs34'

	yyvsp34: INTEGER
			-- Top of semantic value stack `yyvs34'

	yyspecial_routines34: KL_SPECIAL_ROUTINES [INTERVAL_EHR [ISO8601_DATE]]
			-- Routines that ought to be in SPECIAL [INTERVAL_EHR [ISO8601_DATE]]

	yyvs35: SPECIAL [INTERVAL_EHR [ISO8601_DATE_TIME]]
			-- Stack for semantic values of type INTERVAL_EHR [ISO8601_DATE_TIME]

	yyvsc35: INTEGER
			-- Capacity of semantic value stack `yyvs35'

	yyvsp35: INTEGER
			-- Top of semantic value stack `yyvs35'

	yyspecial_routines35: KL_SPECIAL_ROUTINES [INTERVAL_EHR [ISO8601_DATE_TIME]]
			-- Routines that ought to be in SPECIAL [INTERVAL_EHR [ISO8601_DATE_TIME]]

	yyvs36: SPECIAL [INTERVAL_EHR [ISO8601_DURATION]]
			-- Stack for semantic values of type INTERVAL_EHR [ISO8601_DURATION]

	yyvsc36: INTEGER
			-- Capacity of semantic value stack `yyvs36'

	yyvsp36: INTEGER
			-- Top of semantic value stack `yyvs36'

	yyspecial_routines36: KL_SPECIAL_ROUTINES [INTERVAL_EHR [ISO8601_DURATION]]
			-- Routines that ought to be in SPECIAL [INTERVAL_EHR [ISO8601_DURATION]]

	yyvs37: SPECIAL [PART_COMPARABLE]
			-- Stack for semantic values of type PART_COMPARABLE

	yyvsc37: INTEGER
			-- Capacity of semantic value stack `yyvs37'

	yyvsp37: INTEGER
			-- Top of semantic value stack `yyvs37'

	yyspecial_routines37: KL_SPECIAL_ROUTINES [PART_COMPARABLE]
			-- Routines that ought to be in SPECIAL [PART_COMPARABLE]

	yyvs38: SPECIAL [INTERVAL_EHR [PART_COMPARABLE]]
			-- Stack for semantic values of type INTERVAL_EHR [PART_COMPARABLE]

	yyvsc38: INTEGER
			-- Capacity of semantic value stack `yyvs38'

	yyvsp38: INTEGER
			-- Top of semantic value stack `yyvs38'

	yyspecial_routines38: KL_SPECIAL_ROUTINES [INTERVAL_EHR [PART_COMPARABLE]]
			-- Routines that ought to be in SPECIAL [INTERVAL_EHR [PART_COMPARABLE]]

feature {NONE} -- Constants

	yyFinal: INTEGER is 316
			-- Termination state id

	yyFlag: INTEGER is -32768
			-- Most negative INTEGER

	yyNtbase: INTEGER is 49
			-- Number of tokens

	yyLast: INTEGER is 377
			-- Upper bound of `yytable' and `yycheck'

	yyMax_token: INTEGER is 294
			-- Maximum token id
			-- (upper bound of `yytranslate'.)

	yyNsyms: INTEGER is 101
			-- Number of symbols
			-- (terminal and nonterminal)

feature -- User-defined features



feature -- Initialization

	make is
			-- Create a new parser.
		do
			make_scanner
			make_parser_skeleton
		end

	execute(in_text:STRING; a_source_start_line: INTEGER) is
		do
			reset_scanner
			accept -- ensure no syntax errors lying around from previous invocation

			source_start_line := a_source_start_line

			create indent.make(0)
			create error_text.make(0)
			create error_message.make(0)

			create complex_object_nodes.make(0)
			create attr_nodes.make(0)

			create time_vc
			create date_vc
	
			set_input_buffer (new_string_buffer (in_text))
			parse
		end

feature {YY_PARSER_ACTION} -- Basic Operations

	report_error (a_message: STRING) is
			-- Print error message.
		local
			f_buffer: YY_FILE_BUFFER
		do
			error_message.append (a_message + " [last dADL token = " + token_name(last_token) + "]")

			f_buffer ?= input_buffer
			if f_buffer /= Void then
				error_text.append (f_buffer.file.name + ", line ")
			else
				error_text.append ("line ")
			end
			error_text.append ((in_lineno + source_start_line).out + ": " + error_message + "%N")
		end

feature -- Access

	error_text: STRING
			-- complete error text including line number location

	error_message: STRING
			-- message part of error text

	source_start_line: INTEGER
			-- offset of source in other document, else 0

	output: DT_COMPLEX_OBJECT_NODE
			-- parsed structure

feature {NONE} -- Parse Tree

	complex_object_nodes: ARRAYED_STACK[DT_COMPLEX_OBJECT_NODE]
	complex_object_node: DT_COMPLEX_OBJECT_NODE
	leaf_object_node: DT_OBJECT_LEAF
	last_object_node: DT_OBJECT_ITEM

	attr_nodes: ARRAYED_STACK[DT_ATTRIBUTE_NODE]
	attr_node: DT_ATTRIBUTE_NODE

	obj_id: STRING
			-- qualifier of last rel name; use for next object creation

	rm_attr_name: STRING
	node_type: STRING
	node_id: STRING

	time_vc: TIME_VALIDITY_CHECKER
	date_vc: DATE_VALIDITY_CHECKER

feature {NONE} -- Implementation 
	
	term: CODE_PHRASE
	a_uri: URI
	a_path:OG_PATH

	integer_interval: INTERVAL_EHR [INTEGER_REF]
	real_interval: INTERVAL_EHR [REAL_REF]
	date_interval: INTERVAL_EHR [ISO8601_DATE]
	time_interval: INTERVAL_EHR [ISO8601_TIME]
	date_time_interval: INTERVAL_EHR [ISO8601_DATE_TIME]
	duration_interval: INTERVAL_EHR [ISO8601_DURATION]

	indent: STRING
	str: STRING

end
