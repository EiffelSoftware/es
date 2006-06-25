indexing

	description: "Eiffel parsers"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class EIFFEL_PARSER

inherit

	EIFFEL_PARSER_ERROR_REPORTER

	SHARED_NAMES_HEAP

create
	make,
	make_with_factory

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
			yyvsp39 := -1
			yyvsp40 := -1
			yyvsp41 := -1
			yyvsp42 := -1
			yyvsp43 := -1
			yyvsp44 := -1
			yyvsp45 := -1
			yyvsp46 := -1
			yyvsp47 := -1
			yyvsp48 := -1
			yyvsp49 := -1
			yyvsp50 := -1
			yyvsp51 := -1
			yyvsp52 := -1
			yyvsp53 := -1
			yyvsp54 := -1
			yyvsp55 := -1
			yyvsp56 := -1
			yyvsp57 := -1
			yyvsp58 := -1
			yyvsp59 := -1
			yyvsp60 := -1
			yyvsp61 := -1
			yyvsp62 := -1
			yyvsp63 := -1
			yyvsp64 := -1
			yyvsp65 := -1
			yyvsp66 := -1
			yyvsp67 := -1
			yyvsp68 := -1
			yyvsp69 := -1
			yyvsp70 := -1
			yyvsp71 := -1
			yyvsp72 := -1
			yyvsp73 := -1
			yyvsp74 := -1
			yyvsp75 := -1
			yyvsp76 := -1
			yyvsp77 := -1
			yyvsp78 := -1
			yyvsp79 := -1
			yyvsp80 := -1
			yyvsp81 := -1
			yyvsp82 := -1
			yyvsp83 := -1
			yyvsp84 := -1
			yyvsp85 := -1
			yyvsp86 := -1
			yyvsp87 := -1
			yyvsp88 := -1
			yyvsp89 := -1
			yyvsp90 := -1
			yyvsp91 := -1
			yyvsp92 := -1
			yyvsp93 := -1
			yyvsp94 := -1
			yyvsp95 := -1
			yyvsp96 := -1
			yyvsp97 := -1
			yyvsp98 := -1
			yyvsp99 := -1
			yyvsp100 := -1
			yyvsp101 := -1
			yyvsp102 := -1
			yyvsp103 := -1
			yyvsp104 := -1
			yyvsp105 := -1
			yyvsp106 := -1
			yyvsp107 := -1
			yyvsp108 := -1
			yyvsp109 := -1
			yyvsp110 := -1
			yyvsp111 := -1
			yyvsp112 := -1
			yyvsp113 := -1
			yyvsp114 := -1
			yyvsp115 := -1
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
			if yyvs39 /= Void then
				yyvs39.clear_all
			end
			if yyvs40 /= Void then
				yyvs40.clear_all
			end
			if yyvs41 /= Void then
				yyvs41.clear_all
			end
			if yyvs42 /= Void then
				yyvs42.clear_all
			end
			if yyvs43 /= Void then
				yyvs43.clear_all
			end
			if yyvs44 /= Void then
				yyvs44.clear_all
			end
			if yyvs45 /= Void then
				yyvs45.clear_all
			end
			if yyvs46 /= Void then
				yyvs46.clear_all
			end
			if yyvs47 /= Void then
				yyvs47.clear_all
			end
			if yyvs48 /= Void then
				yyvs48.clear_all
			end
			if yyvs49 /= Void then
				yyvs49.clear_all
			end
			if yyvs50 /= Void then
				yyvs50.clear_all
			end
			if yyvs51 /= Void then
				yyvs51.clear_all
			end
			if yyvs52 /= Void then
				yyvs52.clear_all
			end
			if yyvs53 /= Void then
				yyvs53.clear_all
			end
			if yyvs54 /= Void then
				yyvs54.clear_all
			end
			if yyvs55 /= Void then
				yyvs55.clear_all
			end
			if yyvs56 /= Void then
				yyvs56.clear_all
			end
			if yyvs57 /= Void then
				yyvs57.clear_all
			end
			if yyvs58 /= Void then
				yyvs58.clear_all
			end
			if yyvs59 /= Void then
				yyvs59.clear_all
			end
			if yyvs60 /= Void then
				yyvs60.clear_all
			end
			if yyvs61 /= Void then
				yyvs61.clear_all
			end
			if yyvs62 /= Void then
				yyvs62.clear_all
			end
			if yyvs63 /= Void then
				yyvs63.clear_all
			end
			if yyvs64 /= Void then
				yyvs64.clear_all
			end
			if yyvs65 /= Void then
				yyvs65.clear_all
			end
			if yyvs66 /= Void then
				yyvs66.clear_all
			end
			if yyvs67 /= Void then
				yyvs67.clear_all
			end
			if yyvs68 /= Void then
				yyvs68.clear_all
			end
			if yyvs69 /= Void then
				yyvs69.clear_all
			end
			if yyvs70 /= Void then
				yyvs70.clear_all
			end
			if yyvs71 /= Void then
				yyvs71.clear_all
			end
			if yyvs72 /= Void then
				yyvs72.clear_all
			end
			if yyvs73 /= Void then
				yyvs73.clear_all
			end
			if yyvs74 /= Void then
				yyvs74.clear_all
			end
			if yyvs75 /= Void then
				yyvs75.clear_all
			end
			if yyvs76 /= Void then
				yyvs76.clear_all
			end
			if yyvs77 /= Void then
				yyvs77.clear_all
			end
			if yyvs78 /= Void then
				yyvs78.clear_all
			end
			if yyvs79 /= Void then
				yyvs79.clear_all
			end
			if yyvs80 /= Void then
				yyvs80.clear_all
			end
			if yyvs81 /= Void then
				yyvs81.clear_all
			end
			if yyvs82 /= Void then
				yyvs82.clear_all
			end
			if yyvs83 /= Void then
				yyvs83.clear_all
			end
			if yyvs84 /= Void then
				yyvs84.clear_all
			end
			if yyvs85 /= Void then
				yyvs85.clear_all
			end
			if yyvs86 /= Void then
				yyvs86.clear_all
			end
			if yyvs87 /= Void then
				yyvs87.clear_all
			end
			if yyvs88 /= Void then
				yyvs88.clear_all
			end
			if yyvs89 /= Void then
				yyvs89.clear_all
			end
			if yyvs90 /= Void then
				yyvs90.clear_all
			end
			if yyvs91 /= Void then
				yyvs91.clear_all
			end
			if yyvs92 /= Void then
				yyvs92.clear_all
			end
			if yyvs93 /= Void then
				yyvs93.clear_all
			end
			if yyvs94 /= Void then
				yyvs94.clear_all
			end
			if yyvs95 /= Void then
				yyvs95.clear_all
			end
			if yyvs96 /= Void then
				yyvs96.clear_all
			end
			if yyvs97 /= Void then
				yyvs97.clear_all
			end
			if yyvs98 /= Void then
				yyvs98.clear_all
			end
			if yyvs99 /= Void then
				yyvs99.clear_all
			end
			if yyvs100 /= Void then
				yyvs100.clear_all
			end
			if yyvs101 /= Void then
				yyvs101.clear_all
			end
			if yyvs102 /= Void then
				yyvs102.clear_all
			end
			if yyvs103 /= Void then
				yyvs103.clear_all
			end
			if yyvs104 /= Void then
				yyvs104.clear_all
			end
			if yyvs105 /= Void then
				yyvs105.clear_all
			end
			if yyvs106 /= Void then
				yyvs106.clear_all
			end
			if yyvs107 /= Void then
				yyvs107.clear_all
			end
			if yyvs108 /= Void then
				yyvs108.clear_all
			end
			if yyvs109 /= Void then
				yyvs109.clear_all
			end
			if yyvs110 /= Void then
				yyvs110.clear_all
			end
			if yyvs111 /= Void then
				yyvs111.clear_all
			end
			if yyvs112 /= Void then
				yyvs112.clear_all
			end
			if yyvs113 /= Void then
				yyvs113.clear_all
			end
			if yyvs114 /= Void then
				yyvs114.clear_all
			end
			if yyvs115 /= Void then
				yyvs115.clear_all
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
				yyvs4.put (last_symbol_as_value, yyvsp4)
			when 12 then
				yyvsp12 := yyvsp12 + 1
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
				yyvs12.put (last_keyword_as_value, yyvsp12)
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
				yyvs2.put (last_id_as_value, yyvsp2)
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
				yyvs3.put (last_char_as_value, yyvsp3)
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
				yyvs5.put (last_bool_as_value, yyvsp5)
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
				yyvs6.put (last_result_as_value, yyvsp6)
			when 7 then
				yyvsp7 := yyvsp7 + 1
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
				yyvs7.put (last_retry_as_value, yyvsp7)
			when 8 then
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
				yyvs8.put (last_unique_as_value, yyvsp8)
			when 9 then
				yyvsp9 := yyvsp9 + 1
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
				yyvs9.put (last_current_as_value, yyvsp9)
			when 10 then
				yyvsp10 := yyvsp10 + 1
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
				yyvs10.put (last_deferred_as_value, yyvsp10)
			when 11 then
				yyvsp11 := yyvsp11 + 1
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
				yyvs11.put (last_void_as_value, yyvsp11)
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
			when 39 then
				yyvsp39 := yyvsp39 - 1
			when 40 then
				yyvsp40 := yyvsp40 - 1
			when 41 then
				yyvsp41 := yyvsp41 - 1
			when 42 then
				yyvsp42 := yyvsp42 - 1
			when 43 then
				yyvsp43 := yyvsp43 - 1
			when 44 then
				yyvsp44 := yyvsp44 - 1
			when 45 then
				yyvsp45 := yyvsp45 - 1
			when 46 then
				yyvsp46 := yyvsp46 - 1
			when 47 then
				yyvsp47 := yyvsp47 - 1
			when 48 then
				yyvsp48 := yyvsp48 - 1
			when 49 then
				yyvsp49 := yyvsp49 - 1
			when 50 then
				yyvsp50 := yyvsp50 - 1
			when 51 then
				yyvsp51 := yyvsp51 - 1
			when 52 then
				yyvsp52 := yyvsp52 - 1
			when 53 then
				yyvsp53 := yyvsp53 - 1
			when 54 then
				yyvsp54 := yyvsp54 - 1
			when 55 then
				yyvsp55 := yyvsp55 - 1
			when 56 then
				yyvsp56 := yyvsp56 - 1
			when 57 then
				yyvsp57 := yyvsp57 - 1
			when 58 then
				yyvsp58 := yyvsp58 - 1
			when 59 then
				yyvsp59 := yyvsp59 - 1
			when 60 then
				yyvsp60 := yyvsp60 - 1
			when 61 then
				yyvsp61 := yyvsp61 - 1
			when 62 then
				yyvsp62 := yyvsp62 - 1
			when 63 then
				yyvsp63 := yyvsp63 - 1
			when 64 then
				yyvsp64 := yyvsp64 - 1
			when 65 then
				yyvsp65 := yyvsp65 - 1
			when 66 then
				yyvsp66 := yyvsp66 - 1
			when 67 then
				yyvsp67 := yyvsp67 - 1
			when 68 then
				yyvsp68 := yyvsp68 - 1
			when 69 then
				yyvsp69 := yyvsp69 - 1
			when 70 then
				yyvsp70 := yyvsp70 - 1
			when 71 then
				yyvsp71 := yyvsp71 - 1
			when 72 then
				yyvsp72 := yyvsp72 - 1
			when 73 then
				yyvsp73 := yyvsp73 - 1
			when 74 then
				yyvsp74 := yyvsp74 - 1
			when 75 then
				yyvsp75 := yyvsp75 - 1
			when 76 then
				yyvsp76 := yyvsp76 - 1
			when 77 then
				yyvsp77 := yyvsp77 - 1
			when 78 then
				yyvsp78 := yyvsp78 - 1
			when 79 then
				yyvsp79 := yyvsp79 - 1
			when 80 then
				yyvsp80 := yyvsp80 - 1
			when 81 then
				yyvsp81 := yyvsp81 - 1
			when 82 then
				yyvsp82 := yyvsp82 - 1
			when 83 then
				yyvsp83 := yyvsp83 - 1
			when 84 then
				yyvsp84 := yyvsp84 - 1
			when 85 then
				yyvsp85 := yyvsp85 - 1
			when 86 then
				yyvsp86 := yyvsp86 - 1
			when 87 then
				yyvsp87 := yyvsp87 - 1
			when 88 then
				yyvsp88 := yyvsp88 - 1
			when 89 then
				yyvsp89 := yyvsp89 - 1
			when 90 then
				yyvsp90 := yyvsp90 - 1
			when 91 then
				yyvsp91 := yyvsp91 - 1
			when 92 then
				yyvsp92 := yyvsp92 - 1
			when 93 then
				yyvsp93 := yyvsp93 - 1
			when 94 then
				yyvsp94 := yyvsp94 - 1
			when 95 then
				yyvsp95 := yyvsp95 - 1
			when 96 then
				yyvsp96 := yyvsp96 - 1
			when 97 then
				yyvsp97 := yyvsp97 - 1
			when 98 then
				yyvsp98 := yyvsp98 - 1
			when 99 then
				yyvsp99 := yyvsp99 - 1
			when 100 then
				yyvsp100 := yyvsp100 - 1
			when 101 then
				yyvsp101 := yyvsp101 - 1
			when 102 then
				yyvsp102 := yyvsp102 - 1
			when 103 then
				yyvsp103 := yyvsp103 - 1
			when 104 then
				yyvsp104 := yyvsp104 - 1
			when 105 then
				yyvsp105 := yyvsp105 - 1
			when 106 then
				yyvsp106 := yyvsp106 - 1
			when 107 then
				yyvsp107 := yyvsp107 - 1
			when 108 then
				yyvsp108 := yyvsp108 - 1
			when 109 then
				yyvsp109 := yyvsp109 - 1
			when 110 then
				yyvsp110 := yyvsp110 - 1
			when 111 then
				yyvsp111 := yyvsp111 - 1
			when 112 then
				yyvsp112 := yyvsp112 - 1
			when 113 then
				yyvsp113 := yyvsp113 - 1
			when 114 then
				yyvsp114 := yyvsp114 - 1
			when 115 then
				yyvsp115 := yyvsp115 - 1
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
		do
			if yy_act <= 200 then
				yy_do_action_1_200 (yy_act)
			elseif yy_act <= 400 then
				yy_do_action_201_400 (yy_act)
			elseif yy_act <= 600 then
				yy_do_action_401_600 (yy_act)
			else
				debug ("GEYACC")
					std.error.put_string ("Error in parser: unknown rule id: ")
					std.error.put_integer (yy_act)
					std.error.put_new_line
				end
				abort
			end
		end

	yy_do_action_1_200 (yy_act: INTEGER) is
			-- Execute semantic action.
		do
			inspect yy_act
			when 1 then
					--|#line 227 "eiffel.y"
				yy_do_action_1
			when 2 then
					--|#line 234 "eiffel.y"
				yy_do_action_2
			when 3 then
					--|#line 241 "eiffel.y"
				yy_do_action_3
			when 4 then
					--|#line 248 "eiffel.y"
				yy_do_action_4
			when 5 then
					--|#line 255 "eiffel.y"
				yy_do_action_5
			when 6 then
					--|#line 262 "eiffel.y"
				yy_do_action_6
			when 7 then
					--|#line 269 "eiffel.y"
				yy_do_action_7
			when 8 then
					--|#line 276 "eiffel.y"
				yy_do_action_8
			when 9 then
					--|#line 285 "eiffel.y"
				yy_do_action_9
			when 10 then
					--|#line 332 "eiffel.y"
				yy_do_action_10
			when 11 then
					--|#line 333 "eiffel.y"
				yy_do_action_11
			when 12 then
					--|#line 334 "eiffel.y"
				yy_do_action_12
			when 13 then
					--|#line 338 "eiffel.y"
				yy_do_action_13
			when 14 then
					--|#line 340 "eiffel.y"
				yy_do_action_14
			when 15 then
					--|#line 340 "eiffel.y"
				yy_do_action_15
			when 16 then
					--|#line 353 "eiffel.y"
				yy_do_action_16
			when 17 then
					--|#line 363 "eiffel.y"
				yy_do_action_17
			when 18 then
					--|#line 365 "eiffel.y"
				yy_do_action_18
			when 19 then
					--|#line 374 "eiffel.y"
				yy_do_action_19
			when 20 then
					--|#line 374 "eiffel.y"
				yy_do_action_20
			when 21 then
					--|#line 394 "eiffel.y"
				yy_do_action_21
			when 22 then
					--|#line 402 "eiffel.y"
				yy_do_action_22
			when 23 then
					--|#line 402 "eiffel.y"
				yy_do_action_23
			when 24 then
					--|#line 412 "eiffel.y"
				yy_do_action_24
			when 25 then
					--|#line 416 "eiffel.y"
				yy_do_action_25
			when 26 then
					--|#line 420 "eiffel.y"
				yy_do_action_26
			when 27 then
					--|#line 429 "eiffel.y"
				yy_do_action_27
			when 28 then
					--|#line 436 "eiffel.y"
				yy_do_action_28
			when 29 then
					--|#line 436 "eiffel.y"
				yy_do_action_29
			when 30 then
					--|#line 444 "eiffel.y"
				yy_do_action_30
			when 31 then
					--|#line 451 "eiffel.y"
				yy_do_action_31
			when 32 then
					--|#line 453 "eiffel.y"
				yy_do_action_32
			when 33 then
					--|#line 455 "eiffel.y"
				yy_do_action_33
			when 34 then
					--|#line 457 "eiffel.y"
				yy_do_action_34
			when 35 then
					--|#line 462 "eiffel.y"
				yy_do_action_35
			when 36 then
					--|#line 472 "eiffel.y"
				yy_do_action_36
			when 37 then
					--|#line 484 "eiffel.y"
				yy_do_action_37
			when 38 then
					--|#line 494 "eiffel.y"
				yy_do_action_38
			when 39 then
					--|#line 506 "eiffel.y"
				yy_do_action_39
			when 40 then
					--|#line 511 "eiffel.y"
				yy_do_action_40
			when 41 then
					--|#line 523 "eiffel.y"
				yy_do_action_41
			when 42 then
					--|#line 528 "eiffel.y"
				yy_do_action_42
			when 43 then
					--|#line 540 "eiffel.y"
				yy_do_action_43
			when 44 then
					--|#line 545 "eiffel.y"
				yy_do_action_44
			when 45 then
					--|#line 555 "eiffel.y"
				yy_do_action_45
			when 46 then
					--|#line 557 "eiffel.y"
				yy_do_action_46
			when 47 then
					--|#line 566 "eiffel.y"
				yy_do_action_47
			when 48 then
					--|#line 568 "eiffel.y"
				yy_do_action_48
			when 49 then
					--|#line 577 "eiffel.y"
				yy_do_action_49
			when 50 then
					--|#line 584 "eiffel.y"
				yy_do_action_50
			when 51 then
					--|#line 584 "eiffel.y"
				yy_do_action_51
			when 52 then
					--|#line 593 "eiffel.y"
				yy_do_action_52
			when 53 then
					--|#line 596 "eiffel.y"
				yy_do_action_53
			when 54 then
					--|#line 600 "eiffel.y"
				yy_do_action_54
			when 55 then
					--|#line 600 "eiffel.y"
				yy_do_action_55
			when 56 then
					--|#line 616 "eiffel.y"
				yy_do_action_56
			when 57 then
					--|#line 618 "eiffel.y"
				yy_do_action_57
			when 58 then
					--|#line 622 "eiffel.y"
				yy_do_action_58
			when 59 then
					--|#line 631 "eiffel.y"
				yy_do_action_59
			when 60 then
					--|#line 641 "eiffel.y"
				yy_do_action_60
			when 61 then
					--|#line 649 "eiffel.y"
				yy_do_action_61
			when 62 then
					--|#line 649 "eiffel.y"
				yy_do_action_62
			when 63 then
					--|#line 660 "eiffel.y"
				yy_do_action_63
			when 64 then
					--|#line 667 "eiffel.y"
				yy_do_action_64
			when 65 then
					--|#line 667 "eiffel.y"
				yy_do_action_65
			when 66 then
					--|#line 676 "eiffel.y"
				yy_do_action_66
			when 67 then
					--|#line 677 "eiffel.y"
				yy_do_action_67
			when 68 then
					--|#line 680 "eiffel.y"
				yy_do_action_68
			when 69 then
					--|#line 687 "eiffel.y"
				yy_do_action_69
			when 70 then
					--|#line 690 "eiffel.y"
				yy_do_action_70
			when 71 then
					--|#line 694 "eiffel.y"
				yy_do_action_71
			when 72 then
					--|#line 702 "eiffel.y"
				yy_do_action_72
			when 73 then
					--|#line 710 "eiffel.y"
				yy_do_action_73
			when 74 then
					--|#line 714 "eiffel.y"
				yy_do_action_74
			when 75 then
					--|#line 721 "eiffel.y"
				yy_do_action_75
			when 76 then
					--|#line 722 "eiffel.y"
				yy_do_action_76
			when 77 then
					--|#line 726 "eiffel.y"
				yy_do_action_77
			when 78 then
					--|#line 728 "eiffel.y"
				yy_do_action_78
			when 79 then
					--|#line 737 "eiffel.y"
				yy_do_action_79
			when 80 then
					--|#line 739 "eiffel.y"
				yy_do_action_80
			when 81 then
					--|#line 750 "eiffel.y"
				yy_do_action_81
			when 82 then
					--|#line 752 "eiffel.y"
				yy_do_action_82
			when 83 then
					--|#line 754 "eiffel.y"
				yy_do_action_83
			when 84 then
					--|#line 758 "eiffel.y"
				yy_do_action_84
			when 85 then
					--|#line 763 "eiffel.y"
				yy_do_action_85
			when 86 then
					--|#line 767 "eiffel.y"
				yy_do_action_86
			when 87 then
					--|#line 773 "eiffel.y"
				yy_do_action_87
			when 88 then
					--|#line 775 "eiffel.y"
				yy_do_action_88
			when 89 then
					--|#line 779 "eiffel.y"
				yy_do_action_89
			when 90 then
					--|#line 785 "eiffel.y"
				yy_do_action_90
			when 91 then
					--|#line 787 "eiffel.y"
				yy_do_action_91
			when 92 then
					--|#line 793 "eiffel.y"
				yy_do_action_92
			when 93 then
					--|#line 803 "eiffel.y"
				yy_do_action_93
			when 94 then
					--|#line 814 "eiffel.y"
				yy_do_action_94
			when 95 then
					--|#line 820 "eiffel.y"
				yy_do_action_95
			when 96 then
					--|#line 822 "eiffel.y"
				yy_do_action_96
			when 97 then
					--|#line 833 "eiffel.y"
				yy_do_action_97
			when 98 then
					--|#line 835 "eiffel.y"
				yy_do_action_98
			when 99 then
					--|#line 840 "eiffel.y"
				yy_do_action_99
			when 100 then
					--|#line 842 "eiffel.y"
				yy_do_action_100
			when 101 then
					--|#line 848 "eiffel.y"
				yy_do_action_101
			when 102 then
					--|#line 850 "eiffel.y"
				yy_do_action_102
			when 103 then
					--|#line 860 "eiffel.y"
				yy_do_action_103
			when 104 then
					--|#line 862 "eiffel.y"
				yy_do_action_104
			when 105 then
					--|#line 867 "eiffel.y"
				yy_do_action_105
			when 106 then
					--|#line 873 "eiffel.y"
				yy_do_action_106
			when 107 then
					--|#line 877 "eiffel.y"
				yy_do_action_107
			when 108 then
					--|#line 881 "eiffel.y"
				yy_do_action_108
			when 109 then
					--|#line 885 "eiffel.y"
				yy_do_action_109
			when 110 then
					--|#line 889 "eiffel.y"
				yy_do_action_110
			when 111 then
					--|#line 891 "eiffel.y"
				yy_do_action_111
			when 112 then
					--|#line 898 "eiffel.y"
				yy_do_action_112
			when 113 then
					--|#line 900 "eiffel.y"
				yy_do_action_113
			when 114 then
					--|#line 908 "eiffel.y"
				yy_do_action_114
			when 115 then
					--|#line 917 "eiffel.y"
				yy_do_action_115
			when 116 then
					--|#line 924 "eiffel.y"
				yy_do_action_116
			when 117 then
					--|#line 924 "eiffel.y"
				yy_do_action_117
			when 118 then
					--|#line 933 "eiffel.y"
				yy_do_action_118
			when 119 then
					--|#line 937 "eiffel.y"
				yy_do_action_119
			when 120 then
					--|#line 941 "eiffel.y"
				yy_do_action_120
			when 121 then
					--|#line 945 "eiffel.y"
				yy_do_action_121
			when 122 then
					--|#line 949 "eiffel.y"
				yy_do_action_122
			when 123 then
					--|#line 953 "eiffel.y"
				yy_do_action_123
			when 124 then
					--|#line 957 "eiffel.y"
				yy_do_action_124
			when 125 then
					--|#line 961 "eiffel.y"
				yy_do_action_125
			when 126 then
					--|#line 967 "eiffel.y"
				yy_do_action_126
			when 127 then
					--|#line 969 "eiffel.y"
				yy_do_action_127
			when 128 then
					--|#line 973 "eiffel.y"
				yy_do_action_128
			when 129 then
					--|#line 980 "eiffel.y"
				yy_do_action_129
			when 130 then
					--|#line 980 "eiffel.y"
				yy_do_action_130
			when 131 then
					--|#line 990 "eiffel.y"
				yy_do_action_131
			when 132 then
					--|#line 994 "eiffel.y"
				yy_do_action_132
			when 133 then
					--|#line 996 "eiffel.y"
				yy_do_action_133
			when 134 then
					--|#line 1000 "eiffel.y"
				yy_do_action_134
			when 135 then
					--|#line 1002 "eiffel.y"
				yy_do_action_135
			when 136 then
					--|#line 1006 "eiffel.y"
				yy_do_action_136
			when 137 then
					--|#line 1013 "eiffel.y"
				yy_do_action_137
			when 138 then
					--|#line 1013 "eiffel.y"
				yy_do_action_138
			when 139 then
					--|#line 1022 "eiffel.y"
				yy_do_action_139
			when 140 then
					--|#line 1028 "eiffel.y"
				yy_do_action_140
			when 141 then
					--|#line 1030 "eiffel.y"
				yy_do_action_141
			when 142 then
					--|#line 1032 "eiffel.y"
				yy_do_action_142
			when 143 then
					--|#line 1036 "eiffel.y"
				yy_do_action_143
			when 144 then
					--|#line 1038 "eiffel.y"
				yy_do_action_144
			when 145 then
					--|#line 1047 "eiffel.y"
				yy_do_action_145
			when 146 then
					--|#line 1054 "eiffel.y"
				yy_do_action_146
			when 147 then
					--|#line 1054 "eiffel.y"
				yy_do_action_147
			when 148 then
					--|#line 1065 "eiffel.y"
				yy_do_action_148
			when 149 then
					--|#line 1071 "eiffel.y"
				yy_do_action_149
			when 150 then
					--|#line 1079 "eiffel.y"
				yy_do_action_150
			when 151 then
					--|#line 1083 "eiffel.y"
				yy_do_action_151
			when 152 then
					--|#line 1090 "eiffel.y"
				yy_do_action_152
			when 153 then
					--|#line 1090 "eiffel.y"
				yy_do_action_153
			when 154 then
					--|#line 1100 "eiffel.y"
				yy_do_action_154
			when 155 then
					--|#line 1102 "eiffel.y"
				yy_do_action_155
			when 156 then
					--|#line 1106 "eiffel.y"
				yy_do_action_156
			when 157 then
					--|#line 1111 "eiffel.y"
				yy_do_action_157
			when 158 then
					--|#line 1117 "eiffel.y"
				yy_do_action_158
			when 159 then
					--|#line 1119 "eiffel.y"
				yy_do_action_159
			when 160 then
					--|#line 1123 "eiffel.y"
				yy_do_action_160
			when 161 then
					--|#line 1128 "eiffel.y"
				yy_do_action_161
			when 162 then
					--|#line 1134 "eiffel.y"
				yy_do_action_162
			when 163 then
					--|#line 1136 "eiffel.y"
				yy_do_action_163
			when 164 then
					--|#line 1140 "eiffel.y"
				yy_do_action_164
			when 165 then
					--|#line 1145 "eiffel.y"
				yy_do_action_165
			when 166 then
					--|#line 1155 "eiffel.y"
				yy_do_action_166
			when 167 then
					--|#line 1160 "eiffel.y"
				yy_do_action_167
			when 168 then
					--|#line 1162 "eiffel.y"
				yy_do_action_168
			when 169 then
					--|#line 1164 "eiffel.y"
				yy_do_action_169
			when 170 then
					--|#line 1168 "eiffel.y"
				yy_do_action_170
			when 171 then
					--|#line 1175 "eiffel.y"
				yy_do_action_171
			when 172 then
					--|#line 1175 "eiffel.y"
				yy_do_action_172
			when 173 then
					--|#line 1182 "eiffel.y"
				yy_do_action_173
			when 174 then
					--|#line 1186 "eiffel.y"
				yy_do_action_174
			when 175 then
					--|#line 1189 "eiffel.y"
				yy_do_action_175
			when 176 then
					--|#line 1191 "eiffel.y"
				yy_do_action_176
			when 177 then
					--|#line 1193 "eiffel.y"
				yy_do_action_177
			when 178 then
					--|#line 1197 "eiffel.y"
				yy_do_action_178
			when 179 then
					--|#line 1200 "eiffel.y"
				yy_do_action_179
			when 180 then
					--|#line 1206 "eiffel.y"
				yy_do_action_180
			when 181 then
					--|#line 1215 "eiffel.y"
				yy_do_action_181
			when 182 then
					--|#line 1215 "eiffel.y"
				yy_do_action_182
			when 183 then
					--|#line 1225 "eiffel.y"
				yy_do_action_183
			when 184 then
					--|#line 1229 "eiffel.y"
				yy_do_action_184
			when 185 then
					--|#line 1236 "eiffel.y"
				yy_do_action_185
			when 186 then
					--|#line 1237 "eiffel.y"
				yy_do_action_186
			when 187 then
					--|#line 1241 "eiffel.y"
				yy_do_action_187
			when 188 then
					--|#line 1243 "eiffel.y"
				yy_do_action_188
			when 189 then
					--|#line 1247 "eiffel.y"
				yy_do_action_189
			when 190 then
					--|#line 1247 "eiffel.y"
				yy_do_action_190
			when 191 then
					--|#line 1273 "eiffel.y"
				yy_do_action_191
			when 192 then
					--|#line 1275 "eiffel.y"
				yy_do_action_192
			when 193 then
					--|#line 1277 "eiffel.y"
				yy_do_action_193
			when 194 then
					--|#line 1281 "eiffel.y"
				yy_do_action_194
			when 195 then
					--|#line 1281 "eiffel.y"
				yy_do_action_195
			when 196 then
					--|#line 1299 "eiffel.y"
				yy_do_action_196
			when 197 then
					--|#line 1304 "eiffel.y"
				yy_do_action_197
			when 198 then
					--|#line 1306 "eiffel.y"
				yy_do_action_198
			when 199 then
					--|#line 1312 "eiffel.y"
				yy_do_action_199
			when 200 then
					--|#line 1314 "eiffel.y"
				yy_do_action_200
			else
				debug ("GEYACC")
					std.error.put_string ("Error in parser: unknown rule id: ")
					std.error.put_integer (yy_act)
					std.error.put_new_line
				end
				abort
			end
		end

	yy_do_action_201_400 (yy_act: INTEGER) is
			-- Execute semantic action.
		do
			inspect yy_act
			when 201 then
					--|#line 1318 "eiffel.y"
				yy_do_action_201
			when 202 then
					--|#line 1320 "eiffel.y"
				yy_do_action_202
			when 203 then
					--|#line 1322 "eiffel.y"
				yy_do_action_203
			when 204 then
					--|#line 1326 "eiffel.y"
				yy_do_action_204
			when 205 then
					--|#line 1328 "eiffel.y"
				yy_do_action_205
			when 206 then
					--|#line 1332 "eiffel.y"
				yy_do_action_206
			when 207 then
					--|#line 1339 "eiffel.y"
				yy_do_action_207
			when 208 then
					--|#line 1339 "eiffel.y"
				yy_do_action_208
			when 209 then
					--|#line 1348 "eiffel.y"
				yy_do_action_209
			when 210 then
					--|#line 1357 "eiffel.y"
				yy_do_action_210
			when 211 then
					--|#line 1358 "eiffel.y"
				yy_do_action_211
			when 212 then
					--|#line 1361 "eiffel.y"
				yy_do_action_212
			when 213 then
					--|#line 1363 "eiffel.y"
				yy_do_action_213
			when 214 then
					--|#line 1374 "eiffel.y"
				yy_do_action_214
			when 215 then
					--|#line 1376 "eiffel.y"
				yy_do_action_215
			when 216 then
					--|#line 1378 "eiffel.y"
				yy_do_action_216
			when 217 then
					--|#line 1380 "eiffel.y"
				yy_do_action_217
			when 218 then
					--|#line 1382 "eiffel.y"
				yy_do_action_218
			when 219 then
					--|#line 1384 "eiffel.y"
				yy_do_action_219
			when 220 then
					--|#line 1386 "eiffel.y"
				yy_do_action_220
			when 221 then
					--|#line 1388 "eiffel.y"
				yy_do_action_221
			when 222 then
					--|#line 1390 "eiffel.y"
				yy_do_action_222
			when 223 then
					--|#line 1394 "eiffel.y"
				yy_do_action_223
			when 224 then
					--|#line 1396 "eiffel.y"
				yy_do_action_224
			when 225 then
					--|#line 1396 "eiffel.y"
				yy_do_action_225
			when 226 then
					--|#line 1403 "eiffel.y"
				yy_do_action_226
			when 227 then
					--|#line 1403 "eiffel.y"
				yy_do_action_227
			when 228 then
					--|#line 1412 "eiffel.y"
				yy_do_action_228
			when 229 then
					--|#line 1414 "eiffel.y"
				yy_do_action_229
			when 230 then
					--|#line 1414 "eiffel.y"
				yy_do_action_230
			when 231 then
					--|#line 1421 "eiffel.y"
				yy_do_action_231
			when 232 then
					--|#line 1421 "eiffel.y"
				yy_do_action_232
			when 233 then
					--|#line 1430 "eiffel.y"
				yy_do_action_233
			when 234 then
					--|#line 1432 "eiffel.y"
				yy_do_action_234
			when 235 then
					--|#line 1441 "eiffel.y"
				yy_do_action_235
			when 236 then
					--|#line 1454 "eiffel.y"
				yy_do_action_236
			when 237 then
					--|#line 1454 "eiffel.y"
				yy_do_action_237
			when 238 then
					--|#line 1470 "eiffel.y"
				yy_do_action_238
			when 239 then
					--|#line 1472 "eiffel.y"
				yy_do_action_239
			when 240 then
					--|#line 1474 "eiffel.y"
				yy_do_action_240
			when 241 then
					--|#line 1487 "eiffel.y"
				yy_do_action_241
			when 242 then
					--|#line 1489 "eiffel.y"
				yy_do_action_242
			when 243 then
					--|#line 1493 "eiffel.y"
				yy_do_action_243
			when 244 then
					--|#line 1496 "eiffel.y"
				yy_do_action_244
			when 245 then
					--|#line 1498 "eiffel.y"
				yy_do_action_245
			when 246 then
					--|#line 1502 "eiffel.y"
				yy_do_action_246
			when 247 then
					--|#line 1508 "eiffel.y"
				yy_do_action_247
			when 248 then
					--|#line 1517 "eiffel.y"
				yy_do_action_248
			when 249 then
					--|#line 1519 "eiffel.y"
				yy_do_action_249
			when 250 then
					--|#line 1521 "eiffel.y"
				yy_do_action_250
			when 251 then
					--|#line 1523 "eiffel.y"
				yy_do_action_251
			when 252 then
					--|#line 1527 "eiffel.y"
				yy_do_action_252
			when 253 then
					--|#line 1529 "eiffel.y"
				yy_do_action_253
			when 254 then
					--|#line 1533 "eiffel.y"
				yy_do_action_254
			when 255 then
					--|#line 1537 "eiffel.y"
				yy_do_action_255
			when 256 then
					--|#line 1539 "eiffel.y"
				yy_do_action_256
			when 257 then
					--|#line 1545 "eiffel.y"
				yy_do_action_257
			when 258 then
					--|#line 1552 "eiffel.y"
				yy_do_action_258
			when 259 then
					--|#line 1561 "eiffel.y"
				yy_do_action_259
			when 260 then
					--|#line 1565 "eiffel.y"
				yy_do_action_260
			when 261 then
					--|#line 1572 "eiffel.y"
				yy_do_action_261
			when 262 then
					--|#line 1572 "eiffel.y"
				yy_do_action_262
			when 263 then
					--|#line 1582 "eiffel.y"
				yy_do_action_263
			when 264 then
					--|#line 1584 "eiffel.y"
				yy_do_action_264
			when 265 then
					--|#line 1595 "eiffel.y"
				yy_do_action_265
			when 266 then
					--|#line 1604 "eiffel.y"
				yy_do_action_266
			when 267 then
					--|#line 1615 "eiffel.y"
				yy_do_action_267
			when 268 then
					--|#line 1623 "eiffel.y"
				yy_do_action_268
			when 269 then
					--|#line 1634 "eiffel.y"
				yy_do_action_269
			when 270 then
					--|#line 1644 "eiffel.y"
				yy_do_action_270
			when 271 then
					--|#line 1661 "eiffel.y"
				yy_do_action_271
			when 272 then
					--|#line 1678 "eiffel.y"
				yy_do_action_272
			when 273 then
					--|#line 1702 "eiffel.y"
				yy_do_action_273
			when 274 then
					--|#line 1707 "eiffel.y"
				yy_do_action_274
			when 275 then
					--|#line 1716 "eiffel.y"
				yy_do_action_275
			when 276 then
					--|#line 1726 "eiffel.y"
				yy_do_action_276
			when 277 then
					--|#line 1733 "eiffel.y"
				yy_do_action_277
			when 278 then
					--|#line 1733 "eiffel.y"
				yy_do_action_278
			when 279 then
					--|#line 1743 "eiffel.y"
				yy_do_action_279
			when 280 then
					--|#line 1757 "eiffel.y"
				yy_do_action_280
			when 281 then
					--|#line 1772 "eiffel.y"
				yy_do_action_281
			when 282 then
					--|#line 1788 "eiffel.y"
				yy_do_action_282
			when 283 then
					--|#line 1788 "eiffel.y"
				yy_do_action_283
			when 284 then
					--|#line 1811 "eiffel.y"
				yy_do_action_284
			when 285 then
					--|#line 1813 "eiffel.y"
				yy_do_action_285
			when 286 then
					--|#line 1819 "eiffel.y"
				yy_do_action_286
			when 287 then
					--|#line 1821 "eiffel.y"
				yy_do_action_287
			when 288 then
					--|#line 1834 "eiffel.y"
				yy_do_action_288
			when 289 then
					--|#line 1837 "eiffel.y"
				yy_do_action_289
			when 290 then
					--|#line 1846 "eiffel.y"
				yy_do_action_290
			when 291 then
					--|#line 1848 "eiffel.y"
				yy_do_action_291
			when 292 then
					--|#line 1859 "eiffel.y"
				yy_do_action_292
			when 293 then
					--|#line 1862 "eiffel.y"
				yy_do_action_293
			when 294 then
					--|#line 1866 "eiffel.y"
				yy_do_action_294
			when 295 then
					--|#line 1874 "eiffel.y"
				yy_do_action_295
			when 296 then
					--|#line 1874 "eiffel.y"
				yy_do_action_296
			when 297 then
					--|#line 1881 "eiffel.y"
				yy_do_action_297
			when 298 then
					--|#line 1885 "eiffel.y"
				yy_do_action_298
			when 299 then
					--|#line 1888 "eiffel.y"
				yy_do_action_299
			when 300 then
					--|#line 1890 "eiffel.y"
				yy_do_action_300
			when 301 then
					--|#line 1892 "eiffel.y"
				yy_do_action_301
			when 302 then
					--|#line 1896 "eiffel.y"
				yy_do_action_302
			when 303 then
					--|#line 1900 "eiffel.y"
				yy_do_action_303
			when 304 then
					--|#line 1902 "eiffel.y"
				yy_do_action_304
			when 305 then
					--|#line 1913 "eiffel.y"
				yy_do_action_305
			when 306 then
					--|#line 1915 "eiffel.y"
				yy_do_action_306
			when 307 then
					--|#line 1919 "eiffel.y"
				yy_do_action_307
			when 308 then
					--|#line 1926 "eiffel.y"
				yy_do_action_308
			when 309 then
					--|#line 1926 "eiffel.y"
				yy_do_action_309
			when 310 then
					--|#line 1935 "eiffel.y"
				yy_do_action_310
			when 311 then
					--|#line 1939 "eiffel.y"
				yy_do_action_311
			when 312 then
					--|#line 1946 "eiffel.y"
				yy_do_action_312
			when 313 then
					--|#line 1946 "eiffel.y"
				yy_do_action_313
			when 314 then
					--|#line 1956 "eiffel.y"
				yy_do_action_314
			when 315 then
					--|#line 1958 "eiffel.y"
				yy_do_action_315
			when 316 then
					--|#line 1960 "eiffel.y"
				yy_do_action_316
			when 317 then
					--|#line 1962 "eiffel.y"
				yy_do_action_317
			when 318 then
					--|#line 1964 "eiffel.y"
				yy_do_action_318
			when 319 then
					--|#line 1966 "eiffel.y"
				yy_do_action_319
			when 320 then
					--|#line 1968 "eiffel.y"
				yy_do_action_320
			when 321 then
					--|#line 1970 "eiffel.y"
				yy_do_action_321
			when 322 then
					--|#line 1972 "eiffel.y"
				yy_do_action_322
			when 323 then
					--|#line 1974 "eiffel.y"
				yy_do_action_323
			when 324 then
					--|#line 1976 "eiffel.y"
				yy_do_action_324
			when 325 then
					--|#line 1978 "eiffel.y"
				yy_do_action_325
			when 326 then
					--|#line 1980 "eiffel.y"
				yy_do_action_326
			when 327 then
					--|#line 1982 "eiffel.y"
				yy_do_action_327
			when 328 then
					--|#line 1984 "eiffel.y"
				yy_do_action_328
			when 329 then
					--|#line 1986 "eiffel.y"
				yy_do_action_329
			when 330 then
					--|#line 1988 "eiffel.y"
				yy_do_action_330
			when 331 then
					--|#line 1990 "eiffel.y"
				yy_do_action_331
			when 332 then
					--|#line 1995 "eiffel.y"
				yy_do_action_332
			when 333 then
					--|#line 2005 "eiffel.y"
				yy_do_action_333
			when 334 then
					--|#line 2007 "eiffel.y"
				yy_do_action_334
			when 335 then
					--|#line 2011 "eiffel.y"
				yy_do_action_335
			when 336 then
					--|#line 2013 "eiffel.y"
				yy_do_action_336
			when 337 then
					--|#line 2013 "eiffel.y"
				yy_do_action_337
			when 338 then
					--|#line 2023 "eiffel.y"
				yy_do_action_338
			when 339 then
					--|#line 2025 "eiffel.y"
				yy_do_action_339
			when 340 then
					--|#line 2027 "eiffel.y"
				yy_do_action_340
			when 341 then
					--|#line 2031 "eiffel.y"
				yy_do_action_341
			when 342 then
					--|#line 2035 "eiffel.y"
				yy_do_action_342
			when 343 then
					--|#line 2037 "eiffel.y"
				yy_do_action_343
			when 344 then
					--|#line 2042 "eiffel.y"
				yy_do_action_344
			when 345 then
					--|#line 2046 "eiffel.y"
				yy_do_action_345
			when 346 then
					--|#line 2053 "eiffel.y"
				yy_do_action_346
			when 347 then
					--|#line 2053 "eiffel.y"
				yy_do_action_347
			when 348 then
					--|#line 2063 "eiffel.y"
				yy_do_action_348
			when 349 then
					--|#line 2065 "eiffel.y"
				yy_do_action_349
			when 350 then
					--|#line 2075 "eiffel.y"
				yy_do_action_350
			when 351 then
					--|#line 2078 "eiffel.y"
				yy_do_action_351
			when 352 then
					--|#line 2080 "eiffel.y"
				yy_do_action_352
			when 353 then
					--|#line 2082 "eiffel.y"
				yy_do_action_353
			when 354 then
					--|#line 2086 "eiffel.y"
				yy_do_action_354
			when 355 then
					--|#line 2090 "eiffel.y"
				yy_do_action_355
			when 356 then
					--|#line 2092 "eiffel.y"
				yy_do_action_356
			when 357 then
					--|#line 2096 "eiffel.y"
				yy_do_action_357
			when 358 then
					--|#line 2098 "eiffel.y"
				yy_do_action_358
			when 359 then
					--|#line 2102 "eiffel.y"
				yy_do_action_359
			when 360 then
					--|#line 2104 "eiffel.y"
				yy_do_action_360
			when 361 then
					--|#line 2108 "eiffel.y"
				yy_do_action_361
			when 362 then
					--|#line 2115 "eiffel.y"
				yy_do_action_362
			when 363 then
					--|#line 2115 "eiffel.y"
				yy_do_action_363
			when 364 then
					--|#line 2124 "eiffel.y"
				yy_do_action_364
			when 365 then
					--|#line 2129 "eiffel.y"
				yy_do_action_365
			when 366 then
					--|#line 2133 "eiffel.y"
				yy_do_action_366
			when 367 then
					--|#line 2137 "eiffel.y"
				yy_do_action_367
			when 368 then
					--|#line 2142 "eiffel.y"
				yy_do_action_368
			when 369 then
					--|#line 2147 "eiffel.y"
				yy_do_action_369
			when 370 then
					--|#line 2154 "eiffel.y"
				yy_do_action_370
			when 371 then
					--|#line 2159 "eiffel.y"
				yy_do_action_371
			when 372 then
					--|#line 2171 "eiffel.y"
				yy_do_action_372
			when 373 then
					--|#line 2187 "eiffel.y"
				yy_do_action_373
			when 374 then
					--|#line 2191 "eiffel.y"
				yy_do_action_374
			when 375 then
					--|#line 2195 "eiffel.y"
				yy_do_action_375
			when 376 then
					--|#line 2203 "eiffel.y"
				yy_do_action_376
			when 377 then
					--|#line 2207 "eiffel.y"
				yy_do_action_377
			when 378 then
					--|#line 2211 "eiffel.y"
				yy_do_action_378
			when 379 then
					--|#line 2218 "eiffel.y"
				yy_do_action_379
			when 380 then
					--|#line 2228 "eiffel.y"
				yy_do_action_380
			when 381 then
					--|#line 2230 "eiffel.y"
				yy_do_action_381
			when 382 then
					--|#line 2232 "eiffel.y"
				yy_do_action_382
			when 383 then
					--|#line 2234 "eiffel.y"
				yy_do_action_383
			when 384 then
					--|#line 2236 "eiffel.y"
				yy_do_action_384
			when 385 then
					--|#line 2238 "eiffel.y"
				yy_do_action_385
			when 386 then
					--|#line 2248 "eiffel.y"
				yy_do_action_386
			when 387 then
					--|#line 2250 "eiffel.y"
				yy_do_action_387
			when 388 then
					--|#line 2255 "eiffel.y"
				yy_do_action_388
			when 389 then
					--|#line 2259 "eiffel.y"
				yy_do_action_389
			when 390 then
					--|#line 2266 "eiffel.y"
				yy_do_action_390
			when 391 then
					--|#line 2266 "eiffel.y"
				yy_do_action_391
			when 392 then
					--|#line 2276 "eiffel.y"
				yy_do_action_392
			when 393 then
					--|#line 2286 "eiffel.y"
				yy_do_action_393
			when 394 then
					--|#line 2292 "eiffel.y"
				yy_do_action_394
			when 395 then
					--|#line 2296 "eiffel.y"
				yy_do_action_395
			when 396 then
					--|#line 2301 "eiffel.y"
				yy_do_action_396
			when 397 then
					--|#line 2306 "eiffel.y"
				yy_do_action_397
			when 398 then
					--|#line 2308 "eiffel.y"
				yy_do_action_398
			when 399 then
					--|#line 2312 "eiffel.y"
				yy_do_action_399
			when 400 then
					--|#line 2314 "eiffel.y"
				yy_do_action_400
			else
				debug ("GEYACC")
					std.error.put_string ("Error in parser: unknown rule id: ")
					std.error.put_integer (yy_act)
					std.error.put_new_line
				end
				abort
			end
		end

	yy_do_action_401_600 (yy_act: INTEGER) is
			-- Execute semantic action.
		do
			inspect yy_act
			when 401 then
					--|#line 2321 "eiffel.y"
				yy_do_action_401
			when 402 then
					--|#line 2323 "eiffel.y"
				yy_do_action_402
			when 403 then
					--|#line 2327 "eiffel.y"
				yy_do_action_403
			when 404 then
					--|#line 2329 "eiffel.y"
				yy_do_action_404
			when 405 then
					--|#line 2337 "eiffel.y"
				yy_do_action_405
			when 406 then
					--|#line 2339 "eiffel.y"
				yy_do_action_406
			when 407 then
					--|#line 2341 "eiffel.y"
				yy_do_action_407
			when 408 then
					--|#line 2343 "eiffel.y"
				yy_do_action_408
			when 409 then
					--|#line 2347 "eiffel.y"
				yy_do_action_409
			when 410 then
					--|#line 2354 "eiffel.y"
				yy_do_action_410
			when 411 then
					--|#line 2363 "eiffel.y"
				yy_do_action_411
			when 412 then
					--|#line 2366 "eiffel.y"
				yy_do_action_412
			when 413 then
					--|#line 2368 "eiffel.y"
				yy_do_action_413
			when 414 then
					--|#line 2370 "eiffel.y"
				yy_do_action_414
			when 415 then
					--|#line 2372 "eiffel.y"
				yy_do_action_415
			when 416 then
					--|#line 2374 "eiffel.y"
				yy_do_action_416
			when 417 then
					--|#line 2376 "eiffel.y"
				yy_do_action_417
			when 418 then
					--|#line 2380 "eiffel.y"
				yy_do_action_418
			when 419 then
					--|#line 2383 "eiffel.y"
				yy_do_action_419
			when 420 then
					--|#line 2385 "eiffel.y"
				yy_do_action_420
			when 421 then
					--|#line 2387 "eiffel.y"
				yy_do_action_421
			when 422 then
					--|#line 2389 "eiffel.y"
				yy_do_action_422
			when 423 then
					--|#line 2391 "eiffel.y"
				yy_do_action_423
			when 424 then
					--|#line 2393 "eiffel.y"
				yy_do_action_424
			when 425 then
					--|#line 2395 "eiffel.y"
				yy_do_action_425
			when 426 then
					--|#line 2397 "eiffel.y"
				yy_do_action_426
			when 427 then
					--|#line 2399 "eiffel.y"
				yy_do_action_427
			when 428 then
					--|#line 2401 "eiffel.y"
				yy_do_action_428
			when 429 then
					--|#line 2403 "eiffel.y"
				yy_do_action_429
			when 430 then
					--|#line 2405 "eiffel.y"
				yy_do_action_430
			when 431 then
					--|#line 2407 "eiffel.y"
				yy_do_action_431
			when 432 then
					--|#line 2409 "eiffel.y"
				yy_do_action_432
			when 433 then
					--|#line 2411 "eiffel.y"
				yy_do_action_433
			when 434 then
					--|#line 2413 "eiffel.y"
				yy_do_action_434
			when 435 then
					--|#line 2415 "eiffel.y"
				yy_do_action_435
			when 436 then
					--|#line 2419 "eiffel.y"
				yy_do_action_436
			when 437 then
					--|#line 2421 "eiffel.y"
				yy_do_action_437
			when 438 then
					--|#line 2423 "eiffel.y"
				yy_do_action_438
			when 439 then
					--|#line 2425 "eiffel.y"
				yy_do_action_439
			when 440 then
					--|#line 2427 "eiffel.y"
				yy_do_action_440
			when 441 then
					--|#line 2431 "eiffel.y"
				yy_do_action_441
			when 442 then
					--|#line 2433 "eiffel.y"
				yy_do_action_442
			when 443 then
					--|#line 2437 "eiffel.y"
				yy_do_action_443
			when 444 then
					--|#line 2441 "eiffel.y"
				yy_do_action_444
			when 445 then
					--|#line 2445 "eiffel.y"
				yy_do_action_445
			when 446 then
					--|#line 2447 "eiffel.y"
				yy_do_action_446
			when 447 then
					--|#line 2451 "eiffel.y"
				yy_do_action_447
			when 448 then
					--|#line 2454 "eiffel.y"
				yy_do_action_448
			when 449 then
					--|#line 2456 "eiffel.y"
				yy_do_action_449
			when 450 then
					--|#line 2458 "eiffel.y"
				yy_do_action_450
			when 451 then
					--|#line 2460 "eiffel.y"
				yy_do_action_451
			when 452 then
					--|#line 2464 "eiffel.y"
				yy_do_action_452
			when 453 then
					--|#line 2467 "eiffel.y"
				yy_do_action_453
			when 454 then
					--|#line 2469 "eiffel.y"
				yy_do_action_454
			when 455 then
					--|#line 2473 "eiffel.y"
				yy_do_action_455
			when 456 then
					--|#line 2485 "eiffel.y"
				yy_do_action_456
			when 457 then
					--|#line 2488 "eiffel.y"
				yy_do_action_457
			when 458 then
					--|#line 2490 "eiffel.y"
				yy_do_action_458
			when 459 then
					--|#line 2492 "eiffel.y"
				yy_do_action_459
			when 460 then
					--|#line 2494 "eiffel.y"
				yy_do_action_460
			when 461 then
					--|#line 2496 "eiffel.y"
				yy_do_action_461
			when 462 then
					--|#line 2500 "eiffel.y"
				yy_do_action_462
			when 463 then
					--|#line 2502 "eiffel.y"
				yy_do_action_463
			when 464 then
					--|#line 2513 "eiffel.y"
				yy_do_action_464
			when 465 then
					--|#line 2515 "eiffel.y"
				yy_do_action_465
			when 466 then
					--|#line 2519 "eiffel.y"
				yy_do_action_466
			when 467 then
					--|#line 2524 "eiffel.y"
				yy_do_action_467
			when 468 then
					--|#line 2532 "eiffel.y"
				yy_do_action_468
			when 469 then
					--|#line 2534 "eiffel.y"
				yy_do_action_469
			when 470 then
					--|#line 2538 "eiffel.y"
				yy_do_action_470
			when 471 then
					--|#line 2540 "eiffel.y"
				yy_do_action_471
			when 472 then
					--|#line 2544 "eiffel.y"
				yy_do_action_472
			when 473 then
					--|#line 2546 "eiffel.y"
				yy_do_action_473
			when 474 then
					--|#line 2552 "eiffel.y"
				yy_do_action_474
			when 475 then
					--|#line 2560 "eiffel.y"
				yy_do_action_475
			when 476 then
					--|#line 2573 "eiffel.y"
				yy_do_action_476
			when 477 then
					--|#line 2577 "eiffel.y"
				yy_do_action_477
			when 478 then
					--|#line 2580 "eiffel.y"
				yy_do_action_478
			when 479 then
					--|#line 2582 "eiffel.y"
				yy_do_action_479
			when 480 then
					--|#line 2584 "eiffel.y"
				yy_do_action_480
			when 481 then
					--|#line 2586 "eiffel.y"
				yy_do_action_481
			when 482 then
					--|#line 2588 "eiffel.y"
				yy_do_action_482
			when 483 then
					--|#line 2590 "eiffel.y"
				yy_do_action_483
			when 484 then
					--|#line 2594 "eiffel.y"
				yy_do_action_484
			when 485 then
					--|#line 2596 "eiffel.y"
				yy_do_action_485
			when 486 then
					--|#line 2601 "eiffel.y"
				yy_do_action_486
			when 487 then
					--|#line 2605 "eiffel.y"
				yy_do_action_487
			when 488 then
					--|#line 2612 "eiffel.y"
				yy_do_action_488
			when 489 then
					--|#line 2612 "eiffel.y"
				yy_do_action_489
			when 490 then
					--|#line 2622 "eiffel.y"
				yy_do_action_490
			when 491 then
					--|#line 2629 "eiffel.y"
				yy_do_action_491
			when 492 then
					--|#line 2635 "eiffel.y"
				yy_do_action_492
			when 493 then
					--|#line 2642 "eiffel.y"
				yy_do_action_493
			when 494 then
					--|#line 2653 "eiffel.y"
				yy_do_action_494
			when 495 then
					--|#line 2657 "eiffel.y"
				yy_do_action_495
			when 496 then
					--|#line 2664 "eiffel.y"
				yy_do_action_496
			when 497 then
					--|#line 2671 "eiffel.y"
				yy_do_action_497
			when 498 then
					--|#line 2681 "eiffel.y"
				yy_do_action_498
			when 499 then
					--|#line 2685 "eiffel.y"
				yy_do_action_499
			when 500 then
					--|#line 2687 "eiffel.y"
				yy_do_action_500
			when 501 then
					--|#line 2689 "eiffel.y"
				yy_do_action_501
			when 502 then
					--|#line 2691 "eiffel.y"
				yy_do_action_502
			when 503 then
					--|#line 2693 "eiffel.y"
				yy_do_action_503
			when 504 then
					--|#line 2695 "eiffel.y"
				yy_do_action_504
			when 505 then
					--|#line 2700 "eiffel.y"
				yy_do_action_505
			when 506 then
					--|#line 2703 "eiffel.y"
				yy_do_action_506
			when 507 then
					--|#line 2705 "eiffel.y"
				yy_do_action_507
			when 508 then
					--|#line 2707 "eiffel.y"
				yy_do_action_508
			when 509 then
					--|#line 2709 "eiffel.y"
				yy_do_action_509
			when 510 then
					--|#line 2711 "eiffel.y"
				yy_do_action_510
			when 511 then
					--|#line 2713 "eiffel.y"
				yy_do_action_511
			when 512 then
					--|#line 2715 "eiffel.y"
				yy_do_action_512
			when 513 then
					--|#line 2717 "eiffel.y"
				yy_do_action_513
			when 514 then
					--|#line 2728 "eiffel.y"
				yy_do_action_514
			when 515 then
					--|#line 2730 "eiffel.y"
				yy_do_action_515
			when 516 then
					--|#line 2734 "eiffel.y"
				yy_do_action_516
			when 517 then
					--|#line 2739 "eiffel.y"
				yy_do_action_517
			when 518 then
					--|#line 2750 "eiffel.y"
				yy_do_action_518
			when 519 then
					--|#line 2753 "eiffel.y"
				yy_do_action_519
			when 520 then
					--|#line 2755 "eiffel.y"
				yy_do_action_520
			when 521 then
					--|#line 2759 "eiffel.y"
				yy_do_action_521
			when 522 then
					--|#line 2763 "eiffel.y"
				yy_do_action_522
			when 523 then
					--|#line 2769 "eiffel.y"
				yy_do_action_523
			when 524 then
					--|#line 2775 "eiffel.y"
				yy_do_action_524
			when 525 then
					--|#line 2777 "eiffel.y"
				yy_do_action_525
			when 526 then
					--|#line 2781 "eiffel.y"
				yy_do_action_526
			when 527 then
					--|#line 2787 "eiffel.y"
				yy_do_action_527
			when 528 then
					--|#line 2791 "eiffel.y"
				yy_do_action_528
			when 529 then
					--|#line 2800 "eiffel.y"
				yy_do_action_529
			when 530 then
					--|#line 2802 "eiffel.y"
				yy_do_action_530
			when 531 then
					--|#line 2804 "eiffel.y"
				yy_do_action_531
			when 532 then
					--|#line 2808 "eiffel.y"
				yy_do_action_532
			when 533 then
					--|#line 2814 "eiffel.y"
				yy_do_action_533
			when 534 then
					--|#line 2818 "eiffel.y"
				yy_do_action_534
			when 535 then
					--|#line 2824 "eiffel.y"
				yy_do_action_535
			when 536 then
					--|#line 2826 "eiffel.y"
				yy_do_action_536
			when 537 then
					--|#line 2830 "eiffel.y"
				yy_do_action_537
			when 538 then
					--|#line 2836 "eiffel.y"
				yy_do_action_538
			when 539 then
					--|#line 2840 "eiffel.y"
				yy_do_action_539
			when 540 then
					--|#line 2849 "eiffel.y"
				yy_do_action_540
			when 541 then
					--|#line 2856 "eiffel.y"
				yy_do_action_541
			when 542 then
					--|#line 2858 "eiffel.y"
				yy_do_action_542
			when 543 then
					--|#line 2862 "eiffel.y"
				yy_do_action_543
			when 544 then
					--|#line 2864 "eiffel.y"
				yy_do_action_544
			when 545 then
					--|#line 2868 "eiffel.y"
				yy_do_action_545
			when 546 then
					--|#line 2874 "eiffel.y"
				yy_do_action_546
			when 547 then
					--|#line 2888 "eiffel.y"
				yy_do_action_547
			when 548 then
					--|#line 2892 "eiffel.y"
				yy_do_action_548
			when 549 then
					--|#line 2896 "eiffel.y"
				yy_do_action_549
			when 550 then
					--|#line 2900 "eiffel.y"
				yy_do_action_550
			when 551 then
					--|#line 2904 "eiffel.y"
				yy_do_action_551
			when 552 then
					--|#line 2908 "eiffel.y"
				yy_do_action_552
			when 553 then
					--|#line 2912 "eiffel.y"
				yy_do_action_553
			when 554 then
					--|#line 2916 "eiffel.y"
				yy_do_action_554
			when 555 then
					--|#line 2920 "eiffel.y"
				yy_do_action_555
			when 556 then
					--|#line 2924 "eiffel.y"
				yy_do_action_556
			when 557 then
					--|#line 2928 "eiffel.y"
				yy_do_action_557
			when 558 then
					--|#line 2932 "eiffel.y"
				yy_do_action_558
			when 559 then
					--|#line 2936 "eiffel.y"
				yy_do_action_559
			when 560 then
					--|#line 2940 "eiffel.y"
				yy_do_action_560
			when 561 then
					--|#line 2944 "eiffel.y"
				yy_do_action_561
			when 562 then
					--|#line 2948 "eiffel.y"
				yy_do_action_562
			when 563 then
					--|#line 2952 "eiffel.y"
				yy_do_action_563
			when 564 then
					--|#line 2956 "eiffel.y"
				yy_do_action_564
			when 565 then
					--|#line 2960 "eiffel.y"
				yy_do_action_565
			when 566 then
					--|#line 2964 "eiffel.y"
				yy_do_action_566
			when 567 then
					--|#line 2968 "eiffel.y"
				yy_do_action_567
			when 568 then
					--|#line 2972 "eiffel.y"
				yy_do_action_568
			when 569 then
					--|#line 2978 "eiffel.y"
				yy_do_action_569
			when 570 then
					--|#line 2982 "eiffel.y"
				yy_do_action_570
			when 571 then
					--|#line 2986 "eiffel.y"
				yy_do_action_571
			when 572 then
					--|#line 2990 "eiffel.y"
				yy_do_action_572
			when 573 then
					--|#line 2996 "eiffel.y"
				yy_do_action_573
			when 574 then
					--|#line 3000 "eiffel.y"
				yy_do_action_574
			when 575 then
					--|#line 3004 "eiffel.y"
				yy_do_action_575
			when 576 then
					--|#line 3008 "eiffel.y"
				yy_do_action_576
			when 577 then
					--|#line 3012 "eiffel.y"
				yy_do_action_577
			when 578 then
					--|#line 3016 "eiffel.y"
				yy_do_action_578
			when 579 then
					--|#line 3020 "eiffel.y"
				yy_do_action_579
			when 580 then
					--|#line 3024 "eiffel.y"
				yy_do_action_580
			when 581 then
					--|#line 3028 "eiffel.y"
				yy_do_action_581
			when 582 then
					--|#line 3032 "eiffel.y"
				yy_do_action_582
			when 583 then
					--|#line 3036 "eiffel.y"
				yy_do_action_583
			when 584 then
					--|#line 3040 "eiffel.y"
				yy_do_action_584
			when 585 then
					--|#line 3044 "eiffel.y"
				yy_do_action_585
			when 586 then
					--|#line 3048 "eiffel.y"
				yy_do_action_586
			when 587 then
					--|#line 3052 "eiffel.y"
				yy_do_action_587
			when 588 then
					--|#line 3056 "eiffel.y"
				yy_do_action_588
			when 589 then
					--|#line 3060 "eiffel.y"
				yy_do_action_589
			when 590 then
					--|#line 3064 "eiffel.y"
				yy_do_action_590
			when 591 then
					--|#line 3070 "eiffel.y"
				yy_do_action_591
			when 592 then
					--|#line 3074 "eiffel.y"
				yy_do_action_592
			when 593 then
					--|#line 3078 "eiffel.y"
				yy_do_action_593
			when 594 then
					--|#line 3080 "eiffel.y"
				yy_do_action_594
			when 595 then
					--|#line 3084 "eiffel.y"
				yy_do_action_595
			when 596 then
					--|#line 3087 "eiffel.y"
				yy_do_action_596
			when 597 then
					--|#line 3090 "eiffel.y"
				yy_do_action_597
			when 598 then
					--|#line 3093 "eiffel.y"
				yy_do_action_598
			when 599 then
					--|#line 3096 "eiffel.y"
				yy_do_action_599
			else
				debug ("GEYACC")
					std.error.put_string ("Error in parser: unknown rule id: ")
					std.error.put_integer (yy_act)
					std.error.put_new_line
				end
				abort
			end
		end

	yy_do_action_1 is
			--|#line 227 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 227 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 227")
end

				if type_parser or expression_parser or feature_parser or indexing_parser or entity_declaration_parser or invariant_parser then
					raise_error
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs1.put (yyval1, yyvsp1)
end
		end

	yy_do_action_2 is
			--|#line 234 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 234 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 234")
end

				if not type_parser or expression_parser or feature_parser or indexing_parser or entity_declaration_parser or invariant_parser then
					raise_error
				end
				type_node := yyvs79.item (yyvsp79)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp79 := yyvsp79 -1
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
		end

	yy_do_action_3 is
			--|#line 241 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 241 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 241")
end

				if not feature_parser or not single_parser_type then
					raise_error
				end
				feature_node := yyvs51.item (yyvsp51)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp51 := yyvsp51 -1
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
		end

	yy_do_action_4 is
			--|#line 248 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 248 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 248")
end

				if not expression_parser or not single_parser_type then
					raise_error
				end
				expression_node := yyvs48.item (yyvsp48)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp48 := yyvsp48 -1
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
		end

	yy_do_action_5 is
			--|#line 255 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 255 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 255")
end

				if not indexing_parser or not single_parser_type then
					raise_error
				end
				indexing_node := yyvs102.item (yyvsp102)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp1 := yyvsp1 + 1
	yyvsp102 := yyvsp102 -1
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
		end

	yy_do_action_6 is
			--|#line 262 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 262 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 262")
end

				if not invariant_parser or not single_parser_type then
					raise_error
				end
				invariant_node := yyvs62.item (yyvsp62)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp62 := yyvsp62 -1
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
		end

	yy_do_action_7 is
			--|#line 269 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 269 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 269")
end

				if not entity_declaration_parser or not single_parser_type then
					raise_error
				end
				entity_declaration_node := Void
			
if yy_parsing_status = yyContinue then
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
		end

	yy_do_action_8 is
			--|#line 276 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 276 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 276")
end

				if not entity_declaration_parser or not single_parser_type then
					raise_error
				end
				entity_declaration_node := yyvs112.item (yyvsp112)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp1 := yyvsp1 -1
	yyvsp12 := yyvsp12 -1
	yyvsp112 := yyvsp112 -1
	yyvs1.put (yyval1, yyvsp1)
end
		end

	yy_do_action_9 is
			--|#line 285 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 285 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 285")
end

				if yyvs19.item (yyvsp19 - 1) /= Void then
					temp_string_as1 := yyvs19.item (yyvsp19 - 1).second
				else
					temp_string_as1 := Void
				end
				if yyvs19.item (yyvsp19) /= Void then
					temp_string_as2 := yyvs19.item (yyvsp19).second
				else
					temp_string_as2 := Void
				end
				
				root_node := new_class_description (yyvs2.item (yyvsp2), temp_string_as1,
					is_deferred, is_expanded, is_separate, is_frozen_class, is_external_class, is_partial_class,
					yyvs102.item (yyvsp102 - 1), yyvs102.item (yyvsp102), yyvs100.item (yyvsp100), yyvs106.item (yyvsp106), yyvs87.item (yyvsp87), yyvs86.item (yyvsp86), yyvs94.item (yyvsp94), yyvs62.item (yyvsp62), suppliers, temp_string_as2, yyvs12.item (yyvsp12))
				if root_node /= Void then
					root_node.set_text_positions (
						formal_generics_end_position,
						inheritance_end_position,
						features_end_position)
						if yyvs19.item (yyvsp19 - 1) /= Void then
							root_node.set_alias_keyword (yyvs19.item (yyvsp19 - 1).first)
						end
						if yyvs19.item (yyvsp19) /= Void then
							root_node.set_obsolete_keyword (yyvs19.item (yyvsp19).first)
						end
						root_node.set_header_mark (frozen_keyword, expanded_keyword, deferred_keyword, separate_keyword, external_keyword)
						root_node.set_class_keyword (yyvs12.item (yyvsp12 - 1))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 16
	yyvsp1 := yyvsp1 -2
	yyvsp102 := yyvsp102 -2
	yyvsp12 := yyvsp12 -2
	yyvsp2 := yyvsp2 -1
	yyvsp100 := yyvsp100 -1
	yyvsp19 := yyvsp19 -2
	yyvsp106 := yyvsp106 -1
	yyvsp87 := yyvsp87 -1
	yyvsp86 := yyvsp86 -1
	yyvsp94 := yyvsp94 -1
	yyvsp62 := yyvsp62 -1
	yyvs1.put (yyval1, yyvsp1)
end
		end

	yy_do_action_10 is
			--|#line 332 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 332 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 332")
end

inheritance_end_position := position 
if yy_parsing_status = yyContinue then
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
		end

	yy_do_action_11 is
			--|#line 333 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 333 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 333")
end

features_end_position := position 
if yy_parsing_status = yyContinue then
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
		end

	yy_do_action_12 is
			--|#line 334 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 334 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 334")
end

feature_clause_end_position := position 
if yy_parsing_status = yyContinue then
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
		end

	yy_do_action_13 is
			--|#line 338 "eiffel.y"
		local
			yyval102: INDEXING_CLAUSE_AS
		do
--|#line 338 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 338")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp102 := yyvsp102 + 1
	if yyvsp102 >= yyvsc102 then
		if yyvs102 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs102")
			end
			create yyspecial_routines102
			yyvsc102 := yyInitial_yyvs_size
			yyvs102 := yyspecial_routines102.make (yyvsc102)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs102")
			end
			yyvsc102 := yyvsc102 + yyInitial_yyvs_size
			yyvs102 := yyspecial_routines102.resize (yyvs102, yyvsc102)
		end
	end
	yyvs102.put (yyval102, yyvsp102)
end
		end

	yy_do_action_14 is
			--|#line 340 "eiffel.y"
		local
			yyval102: INDEXING_CLAUSE_AS
		do
--|#line 340 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 340")
end

				yyval102 := yyvs102.item (yyvsp102)
				if yyval102 /= Void then
					yyval102.set_indexing_keyword (yyvs12.item (yyvsp12))
				end				
				set_has_old_verbatim_strings_warning (initial_has_old_verbatim_strings_warning)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp102 := yyvsp102 -1
	yyvsp12 := yyvsp12 -1
	yyvsp1 := yyvsp1 -2
	yyvs102.put (yyval102, yyvsp102)
end
		end

	yy_do_action_15 is
			--|#line 340 "eiffel.y"
		local
			yyval102: INDEXING_CLAUSE_AS
		do
--|#line 340 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 340")
end

				initial_has_old_verbatim_strings_warning := has_old_verbatim_strings_warning
				set_has_old_verbatim_strings_warning (false)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp102 := yyvsp102 + 1
	if yyvsp102 >= yyvsc102 then
		if yyvs102 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs102")
			end
			create yyspecial_routines102
			yyvsc102 := yyInitial_yyvs_size
			yyvs102 := yyspecial_routines102.make (yyvsc102)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs102")
			end
			yyvsc102 := yyvsc102 + yyInitial_yyvs_size
			yyvs102 := yyspecial_routines102.resize (yyvs102, yyvsc102)
		end
	end
	yyvs102.put (yyval102, yyvsp102)
end
		end

	yy_do_action_16 is
			--|#line 353 "eiffel.y"
		local
			yyval102: INDEXING_CLAUSE_AS
		do
--|#line 353 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 353")
end

				yyval102 := ast_factory.new_indexing_clause_as (0)
				if yyval102 /= Void then
					yyval102.set_indexing_keyword (yyvs12.item (yyvsp12))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp102 := yyvsp102 + 1
	yyvsp12 := yyvsp12 -1
	if yyvsp102 >= yyvsc102 then
		if yyvs102 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs102")
			end
			create yyspecial_routines102
			yyvsc102 := yyInitial_yyvs_size
			yyvs102 := yyspecial_routines102.make (yyvsc102)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs102")
			end
			yyvsc102 := yyvsc102 + yyInitial_yyvs_size
			yyvs102 := yyspecial_routines102.resize (yyvs102, yyvsc102)
		end
	end
	yyvs102.put (yyval102, yyvsp102)
end
		end

	yy_do_action_17 is
			--|#line 363 "eiffel.y"
		local
			yyval102: INDEXING_CLAUSE_AS
		do
--|#line 363 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 363")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp102 := yyvsp102 + 1
	if yyvsp102 >= yyvsc102 then
		if yyvs102 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs102")
			end
			create yyspecial_routines102
			yyvsc102 := yyInitial_yyvs_size
			yyvs102 := yyspecial_routines102.make (yyvsc102)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs102")
			end
			yyvsc102 := yyvsc102 + yyInitial_yyvs_size
			yyvs102 := yyspecial_routines102.resize (yyvs102, yyvsc102)
		end
	end
	yyvs102.put (yyval102, yyvsp102)
end
		end

	yy_do_action_18 is
			--|#line 365 "eiffel.y"
		local
			yyval102: INDEXING_CLAUSE_AS
		do
--|#line 365 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 365")
end

				yyval102 := ast_factory.new_indexing_clause_as (0)
				if yyval102 /= Void then
						yyval102.set_indexing_keyword (yyvs12.item (yyvsp12 - 1))
						yyval102.set_end_keyword (yyvs12.item (yyvsp12))
				end		
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp102 := yyvsp102 + 1
	yyvsp12 := yyvsp12 -2
	if yyvsp102 >= yyvsc102 then
		if yyvs102 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs102")
			end
			create yyspecial_routines102
			yyvsc102 := yyInitial_yyvs_size
			yyvs102 := yyspecial_routines102.make (yyvsc102)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs102")
			end
			yyvsc102 := yyvsc102 + yyInitial_yyvs_size
			yyvs102 := yyspecial_routines102.resize (yyvs102, yyvsc102)
		end
	end
	yyvs102.put (yyval102, yyvsp102)
end
		end

	yy_do_action_19 is
			--|#line 374 "eiffel.y"
		local
			yyval102: INDEXING_CLAUSE_AS
		do
--|#line 374 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 374")
end

				yyval102 := yyvs102.item (yyvsp102)
				if yyval102 /= Void then
					if yyvs12.item (yyvsp12 - 1) /= Void then
						yyval102.set_indexing_keyword (yyvs12.item (yyvsp12 - 1))
					end
					if yyvs12.item (yyvsp12) /= Void then	
						yyval102.set_end_keyword (yyvs12.item (yyvsp12))
					end
				end				
				set_has_old_verbatim_strings_warning (initial_has_old_verbatim_strings_warning)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 6
	yyvsp102 := yyvsp102 -1
	yyvsp12 := yyvsp12 -2
	yyvsp1 := yyvsp1 -2
	yyvs102.put (yyval102, yyvsp102)
end
		end

	yy_do_action_20 is
			--|#line 374 "eiffel.y"
		local
			yyval102: INDEXING_CLAUSE_AS
		do
--|#line 374 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 374")
end

				initial_has_old_verbatim_strings_warning := has_old_verbatim_strings_warning
				set_has_old_verbatim_strings_warning (false)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp102 := yyvsp102 + 1
	if yyvsp102 >= yyvsc102 then
		if yyvs102 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs102")
			end
			create yyspecial_routines102
			yyvsc102 := yyInitial_yyvs_size
			yyvs102 := yyspecial_routines102.make (yyvsc102)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs102")
			end
			yyvsc102 := yyvsc102 + yyInitial_yyvs_size
			yyvs102 := yyspecial_routines102.resize (yyvs102, yyvsc102)
		end
	end
	yyvs102.put (yyval102, yyvsp102)
end
		end

	yy_do_action_21 is
			--|#line 394 "eiffel.y"
		local
			yyval102: INDEXING_CLAUSE_AS
		do
--|#line 394 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 394")
end

				yyval102 := ast_factory.new_indexing_clause_as (counter_value + 1)
				if yyval102 /= Void and yyvs57.item (yyvsp57) /= Void then
					yyval102.reverse_extend (yyvs57.item (yyvsp57))
					yyval102.update_lookup (yyvs57.item (yyvsp57))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp102 := yyvsp102 + 1
	yyvsp57 := yyvsp57 -1
	if yyvsp102 >= yyvsc102 then
		if yyvs102 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs102")
			end
			create yyspecial_routines102
			yyvsc102 := yyInitial_yyvs_size
			yyvs102 := yyspecial_routines102.make (yyvsc102)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs102")
			end
			yyvsc102 := yyvsc102 + yyInitial_yyvs_size
			yyvs102 := yyspecial_routines102.resize (yyvs102, yyvsc102)
		end
	end
	yyvs102.put (yyval102, yyvsp102)
end
		end

	yy_do_action_22 is
			--|#line 402 "eiffel.y"
		local
			yyval102: INDEXING_CLAUSE_AS
		do
--|#line 402 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 402")
end

				yyval102 := yyvs102.item (yyvsp102)
				if yyval102 /= Void and yyvs57.item (yyvsp57) /= Void then
					yyval102.reverse_extend (yyvs57.item (yyvsp57))
					yyval102.update_lookup (yyvs57.item (yyvsp57))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp102 := yyvsp102 -1
	yyvsp57 := yyvsp57 -1
	yyvs102.put (yyval102, yyvsp102)
end
		end

	yy_do_action_23 is
			--|#line 402 "eiffel.y"
		local
			yyval102: INDEXING_CLAUSE_AS
		do
--|#line 402 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 402")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp102 := yyvsp102 + 1
	if yyvsp102 >= yyvsc102 then
		if yyvs102 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs102")
			end
			create yyspecial_routines102
			yyvsc102 := yyInitial_yyvs_size
			yyvs102 := yyspecial_routines102.make (yyvsc102)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs102")
			end
			yyvsc102 := yyvsc102 + yyInitial_yyvs_size
			yyvs102 := yyspecial_routines102.resize (yyvs102, yyvsc102)
		end
	end
	yyvs102.put (yyval102, yyvsp102)
end
		end

	yy_do_action_24 is
			--|#line 412 "eiffel.y"
		local
			yyval57: INDEX_AS
		do
--|#line 412 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 412")
end

yyval57 := yyvs57.item (yyvsp57) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs57.put (yyval57, yyvsp57)
end
		end

	yy_do_action_25 is
			--|#line 416 "eiffel.y"
		local
			yyval57: INDEX_AS
		do
--|#line 416 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 416")
end

				yyval57 := ast_factory.new_index_as (yyvs2.item (yyvsp2), yyvs84.item (yyvsp84), yyvs4.item (yyvsp4 - 1))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp57 := yyvsp57 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp4 := yyvsp4 -2
	yyvsp84 := yyvsp84 -1
	if yyvsp57 >= yyvsc57 then
		if yyvs57 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs57")
			end
			create yyspecial_routines57
			yyvsc57 := yyInitial_yyvs_size
			yyvs57 := yyspecial_routines57.make (yyvsc57)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs57")
			end
			yyvsc57 := yyvsc57 + yyInitial_yyvs_size
			yyvs57 := yyspecial_routines57.resize (yyvs57, yyvsc57)
		end
	end
	yyvs57.put (yyval57, yyvsp57)
end
		end

	yy_do_action_26 is
			--|#line 420 "eiffel.y"
		local
			yyval57: INDEX_AS
		do
--|#line 420 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 420")
end

				yyval57 := ast_factory.new_index_as (Void, yyvs84.item (yyvsp84), Void)
				if yyvs84.item (yyvsp84) /= Void then
					report_warning(parser_errors.missing_index_part_warning, yyvs84.item (yyvsp84))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp57 := yyvsp57 + 1
	yyvsp84 := yyvsp84 -1
	yyvsp4 := yyvsp4 -1
	if yyvsp57 >= yyvsc57 then
		if yyvs57 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs57")
			end
			create yyspecial_routines57
			yyvsc57 := yyInitial_yyvs_size
			yyvs57 := yyspecial_routines57.make (yyvsc57)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs57")
			end
			yyvsc57 := yyvsc57 + yyInitial_yyvs_size
			yyvs57 := yyspecial_routines57.resize (yyvs57, yyvsc57)
		end
	end
	yyvs57.put (yyval57, yyvsp57)
end
		end

	yy_do_action_27 is
			--|#line 429 "eiffel.y"
		local
			yyval84: EIFFEL_LIST [ATOMIC_AS]
		do
--|#line 429 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 429")
end

				yyval84 := ast_factory.new_eiffel_list_atomic_as (counter_value + 1)
				if yyval84 /= Void and yyvs31.item (yyvsp31) /= Void then
					yyval84.reverse_extend (yyvs31.item (yyvsp31))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp84 := yyvsp84 + 1
	yyvsp31 := yyvsp31 -1
	if yyvsp84 >= yyvsc84 then
		if yyvs84 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs84")
			end
			create yyspecial_routines84
			yyvsc84 := yyInitial_yyvs_size
			yyvs84 := yyspecial_routines84.make (yyvsc84)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs84")
			end
			yyvsc84 := yyvsc84 + yyInitial_yyvs_size
			yyvs84 := yyspecial_routines84.resize (yyvs84, yyvsc84)
		end
	end
	yyvs84.put (yyval84, yyvsp84)
end
		end

	yy_do_action_28 is
			--|#line 436 "eiffel.y"
		local
			yyval84: EIFFEL_LIST [ATOMIC_AS]
		do
--|#line 436 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 436")
end

				yyval84 := yyvs84.item (yyvsp84)
				if yyval84 /= Void and yyvs31.item (yyvsp31) /= Void then
					yyval84.reverse_extend (yyvs31.item (yyvsp31))
					ast_factory.reverse_extend_separator (yyval84, yyvs4.item (yyvsp4))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp84 := yyvsp84 -1
	yyvsp31 := yyvsp31 -1
	yyvsp4 := yyvsp4 -1
	yyvs84.put (yyval84, yyvsp84)
end
		end

	yy_do_action_29 is
			--|#line 436 "eiffel.y"
		local
			yyval84: EIFFEL_LIST [ATOMIC_AS]
		do
--|#line 436 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 436")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp84 := yyvsp84 + 1
	if yyvsp84 >= yyvsc84 then
		if yyvs84 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs84")
			end
			create yyspecial_routines84
			yyvsc84 := yyInitial_yyvs_size
			yyvs84 := yyspecial_routines84.make (yyvsc84)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs84")
			end
			yyvsc84 := yyvsc84 + yyInitial_yyvs_size
			yyvs84 := yyspecial_routines84.resize (yyvs84, yyvsc84)
		end
	end
	yyvs84.put (yyval84, yyvsp84)
end
		end

	yy_do_action_30 is
			--|#line 444 "eiffel.y"
		local
			yyval84: EIFFEL_LIST [ATOMIC_AS]
		do
--|#line 444 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 444")
end

-- TO DO: remove this TE_SEMICOLON (see: INDEX_AS.index_list /= Void)
				yyval84 := ast_factory.new_eiffel_list_atomic_as (0)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp84 := yyvsp84 + 1
	yyvsp4 := yyvsp4 -1
	if yyvsp84 >= yyvsc84 then
		if yyvs84 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs84")
			end
			create yyspecial_routines84
			yyvsc84 := yyInitial_yyvs_size
			yyvs84 := yyspecial_routines84.make (yyvsc84)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs84")
			end
			yyvsc84 := yyvsc84 + yyInitial_yyvs_size
			yyvs84 := yyspecial_routines84.resize (yyvs84, yyvsc84)
		end
	end
	yyvs84.put (yyval84, yyvsp84)
end
		end

	yy_do_action_31 is
			--|#line 451 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 451 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 451")
end

yyval31 := yyvs2.item (yyvsp2) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp31 := yyvsp31 + 1
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
		end

	yy_do_action_32 is
			--|#line 453 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 453 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 453")
end

yyval31 := yyvs31.item (yyvsp31) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs31.put (yyval31, yyvsp31)
end
		end

	yy_do_action_33 is
			--|#line 455 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 455 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 455")
end

yyval31 := ast_factory.new_custom_attribute_as (yyvs43.item (yyvsp43), Void, yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp31 := yyvsp31 + 1
	yyvsp43 := yyvsp43 -1
	yyvsp12 := yyvsp12 -1
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
		end

	yy_do_action_34 is
			--|#line 457 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 457 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 457")
end

yyval31 := ast_factory.new_custom_attribute_as (yyvs43.item (yyvsp43), yyvs78.item (yyvsp78), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp31 := yyvsp31 + 1
	yyvsp43 := yyvsp43 -1
	yyvsp78 := yyvsp78 -1
	yyvsp12 := yyvsp12 -1
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
		end

	yy_do_action_35 is
			--|#line 462 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 462 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 462")
end

				is_deferred := False
				is_expanded := False
				is_separate := False

				deferred_keyword := Void
				expanded_keyword := Void
				separate_keyword := Void
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs1.put (yyval1, yyvsp1)
end
		end

	yy_do_action_36 is
			--|#line 472 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 472 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 472")
end

				is_frozen_class := False
				is_deferred := True
				is_expanded := False
				is_separate := False

				frozen_keyword := Void
				deferred_keyword := yyvs10.item (yyvsp10)
				expanded_keyword := Void
				separate_keyword := Void
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp10 := yyvsp10 -1
	yyvs1.put (yyval1, yyvsp1)
end
		end

	yy_do_action_37 is
			--|#line 484 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 484 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 484")
end

				is_deferred := False
				is_expanded := True
				is_separate := False
				
				deferred_keyword := Void
				expanded_keyword := yyvs12.item (yyvsp12)
				separate_keyword := Void
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp12 := yyvsp12 -1
	yyvs1.put (yyval1, yyvsp1)
end
		end

	yy_do_action_38 is
			--|#line 494 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 494 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 494")
end

				is_deferred := False
				is_expanded := False
				is_separate := True

				deferred_keyword := Void
				expanded_keyword := Void
				separate_keyword := yyvs12.item (yyvsp12)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -1
	yyvsp12 := yyvsp12 -1
	yyvs1.put (yyval1, yyvsp1)
end
		end

	yy_do_action_39 is
			--|#line 506 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 506 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 506")
end

				is_frozen_class := False
				frozen_keyword := Void
			
if yy_parsing_status = yyContinue then
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
		end

	yy_do_action_40 is
			--|#line 511 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 511 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 511")
end

					-- I'm adding a few comments line
					-- here because otherwise the generated
					-- parser is very different from the
					-- previous one, since line numbers are
					-- emitted.
				is_frozen_class := True
				frozen_keyword := yyvs12.item (yyvsp12)
			
if yy_parsing_status = yyContinue then
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
		end

	yy_do_action_41 is
			--|#line 523 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 523 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 523")
end

				is_external_class := False
				external_keyword := Void
			
if yy_parsing_status = yyContinue then
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
		end

	yy_do_action_42 is
			--|#line 528 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 528 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 528")
end

				if il_parser then
					is_external_class := True
					external_keyword := yyvs12.item (yyvsp12)
				else
						-- Trigger a syntax error.
					raise_error
				end
			
if yy_parsing_status = yyContinue then
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
		end

	yy_do_action_43 is
			--|#line 540 "eiffel.y"
		local
			yyval12: KEYWORD_AS
		do
--|#line 540 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 540")
end

				yyval12 := yyvs12.item (yyvsp12);
				is_partial_class := false;
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs12.put (yyval12, yyvsp12)
end
		end

	yy_do_action_44 is
			--|#line 545 "eiffel.y"
		local
			yyval12: KEYWORD_AS
		do
--|#line 545 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 545")
end

			yyval12 := yyvs12.item (yyvsp12);
			is_partial_class := true;
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs12.put (yyval12, yyvsp12)
end
		end

	yy_do_action_45 is
			--|#line 555 "eiffel.y"
		local
			yyval19: PAIR [KEYWORD_AS, STRING_AS]
		do
--|#line 555 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 555")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp19 := yyvsp19 + 1
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
		end

	yy_do_action_46 is
			--|#line 557 "eiffel.y"
		local
			yyval19: PAIR [KEYWORD_AS, STRING_AS]
		do
--|#line 557 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 557")
end

				yyval19 := ast_factory.new_keyword_string_pair (yyvs12.item (yyvsp12), yyvs18.item (yyvsp18))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp19 := yyvsp19 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp18 := yyvsp18 -1
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
		end

	yy_do_action_47 is
			--|#line 566 "eiffel.y"
		local
			yyval94: EIFFEL_LIST [FEATURE_CLAUSE_AS]
		do
--|#line 566 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 566")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp94 := yyvsp94 + 1
	if yyvsp94 >= yyvsc94 then
		if yyvs94 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs94")
			end
			create yyspecial_routines94
			yyvsc94 := yyInitial_yyvs_size
			yyvs94 := yyspecial_routines94.make (yyvsc94)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs94")
			end
			yyvsc94 := yyvsc94 + yyInitial_yyvs_size
			yyvs94 := yyspecial_routines94.resize (yyvs94, yyvsc94)
		end
	end
	yyvs94.put (yyval94, yyvsp94)
end
		end

	yy_do_action_48 is
			--|#line 568 "eiffel.y"
		local
			yyval94: EIFFEL_LIST [FEATURE_CLAUSE_AS]
		do
--|#line 568 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 568")
end

				yyval94 := yyvs94.item (yyvsp94)
				if yyval94 /= Void and then yyval94.is_empty then
					yyval94 := Void
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs94.put (yyval94, yyvsp94)
end
		end

	yy_do_action_49 is
			--|#line 577 "eiffel.y"
		local
			yyval94: EIFFEL_LIST [FEATURE_CLAUSE_AS]
		do
--|#line 577 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 577")
end

				yyval94 := ast_factory.new_eiffel_list_feature_clause_as (counter_value + 1)
				if yyval94 /= Void and yyvs52.item (yyvsp52) /= Void then
					yyval94.reverse_extend (yyvs52.item (yyvsp52))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp94 := yyvsp94 + 1
	yyvsp52 := yyvsp52 -1
	if yyvsp94 >= yyvsc94 then
		if yyvs94 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs94")
			end
			create yyspecial_routines94
			yyvsc94 := yyInitial_yyvs_size
			yyvs94 := yyspecial_routines94.make (yyvsc94)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs94")
			end
			yyvsc94 := yyvsc94 + yyInitial_yyvs_size
			yyvs94 := yyspecial_routines94.resize (yyvs94, yyvsc94)
		end
	end
	yyvs94.put (yyval94, yyvsp94)
end
		end

	yy_do_action_50 is
			--|#line 584 "eiffel.y"
		local
			yyval94: EIFFEL_LIST [FEATURE_CLAUSE_AS]
		do
--|#line 584 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 584")
end

				yyval94 := yyvs94.item (yyvsp94)
				if yyval94 /= Void and yyvs52.item (yyvsp52) /= Void then
					yyval94.reverse_extend (yyvs52.item (yyvsp52))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp94 := yyvsp94 -1
	yyvsp52 := yyvsp52 -1
	yyvs94.put (yyval94, yyvsp94)
end
		end

	yy_do_action_51 is
			--|#line 584 "eiffel.y"
		local
			yyval94: EIFFEL_LIST [FEATURE_CLAUSE_AS]
		do
--|#line 584 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 584")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp94 := yyvsp94 + 1
	if yyvsp94 >= yyvsc94 then
		if yyvs94 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs94")
			end
			create yyspecial_routines94
			yyvsc94 := yyInitial_yyvs_size
			yyvs94 := yyspecial_routines94.make (yyvsc94)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs94")
			end
			yyvsc94 := yyvsc94 + yyInitial_yyvs_size
			yyvs94 := yyspecial_routines94.resize (yyvs94, yyvsc94)
		end
	end
	yyvs94.put (yyval94, yyvsp94)
end
		end

	yy_do_action_52 is
			--|#line 593 "eiffel.y"
		local
			yyval52: FEATURE_CLAUSE_AS
		do
--|#line 593 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 593")
end

yyval52 := ast_factory.new_feature_clause_as (yyvs38.item (yyvsp38),
				ast_factory.new_eiffel_list_feature_as (0), fclause_pos, feature_clause_end_position) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp52 := yyvsp52 + 1
	yyvsp38 := yyvsp38 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp52 >= yyvsc52 then
		if yyvs52 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs52")
			end
			create yyspecial_routines52
			yyvsc52 := yyInitial_yyvs_size
			yyvs52 := yyspecial_routines52.make (yyvsc52)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs52")
			end
			yyvsc52 := yyvsc52 + yyInitial_yyvs_size
			yyvs52 := yyspecial_routines52.resize (yyvs52, yyvsc52)
		end
	end
	yyvs52.put (yyval52, yyvsp52)
end
		end

	yy_do_action_53 is
			--|#line 596 "eiffel.y"
		local
			yyval52: FEATURE_CLAUSE_AS
		do
--|#line 596 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 596")
end

yyval52 := ast_factory.new_feature_clause_as (yyvs38.item (yyvsp38), yyvs93.item (yyvsp93), fclause_pos, feature_clause_end_position) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp52 := yyvsp52 + 1
	yyvsp38 := yyvsp38 -1
	yyvsp1 := yyvsp1 -3
	yyvsp93 := yyvsp93 -1
	if yyvsp52 >= yyvsc52 then
		if yyvs52 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs52")
			end
			create yyspecial_routines52
			yyvsc52 := yyInitial_yyvs_size
			yyvs52 := yyspecial_routines52.make (yyvsc52)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs52")
			end
			yyvsc52 := yyvsc52 + yyInitial_yyvs_size
			yyvs52 := yyspecial_routines52.resize (yyvs52, yyvsc52)
		end
	end
	yyvs52.put (yyval52, yyvsp52)
end
		end

	yy_do_action_54 is
			--|#line 600 "eiffel.y"
		local
			yyval38: CLIENT_AS
		do
--|#line 600 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 600")
end

yyval38 := yyvs38.item (yyvsp38) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp38 := yyvsp38 -1
	yyvsp12 := yyvsp12 -1
	yyvs38.put (yyval38, yyvsp38)
end
		end

	yy_do_action_55 is
			--|#line 600 "eiffel.y"
		local
			yyval38: CLIENT_AS
		do
--|#line 600 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 600")
end

				fclause_pos := yyvs12.item (yyvsp12)
				if yyvs12.item (yyvsp12) /= Void then
						-- Originally, it was 8, I changed it to 7, delete the following line when fully tested. (Jason)
					fclause_pos.set_position (line, column, position, 7)
				else
						-- Originally, it was 8, I changed it to 7 (Jason)
					fclause_pos := ast_factory.new_feature_keyword_as (line, column, position, 7, Current)
				end
				
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp38 := yyvsp38 + 1
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
		end

	yy_do_action_56 is
			--|#line 616 "eiffel.y"
		local
			yyval38: CLIENT_AS
		do
--|#line 616 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 616")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp38 := yyvsp38 + 1
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
		end

	yy_do_action_57 is
			--|#line 618 "eiffel.y"
		local
			yyval38: CLIENT_AS
		do
--|#line 618 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 618")
end

yyval38 := ast_factory.new_client_as (yyvs101.item (yyvsp101)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp38 := yyvsp38 + 1
	yyvsp101 := yyvsp101 -1
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
		end

	yy_do_action_58 is
			--|#line 622 "eiffel.y"
		local
			yyval101: CLASS_LIST_AS
		do
--|#line 622 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 622")
end

				yyval101 := ast_factory.new_class_list_as (1)
				if yyval101 /= Void then
					yyval101.reverse_extend (new_none_id)
					yyval101.set_lcurly_symbol (yyvs4.item (yyvsp4 - 1))
					yyval101.set_rcurly_symbol (yyvs4.item (yyvsp4))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp101 := yyvsp101 + 1
	yyvsp4 := yyvsp4 -2
	if yyvsp101 >= yyvsc101 then
		if yyvs101 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs101")
			end
			create yyspecial_routines101
			yyvsc101 := yyInitial_yyvs_size
			yyvs101 := yyspecial_routines101.make (yyvsc101)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs101")
			end
			yyvsc101 := yyvsc101 + yyInitial_yyvs_size
			yyvs101 := yyspecial_routines101.resize (yyvs101, yyvsc101)
		end
	end
	yyvs101.put (yyval101, yyvsp101)
end
		end

	yy_do_action_59 is
			--|#line 631 "eiffel.y"
		local
			yyval101: CLASS_LIST_AS
		do
--|#line 631 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 631")
end

				yyval101 := yyvs101.item (yyvsp101)
				if yyval101 /= Void then
					yyval101.set_lcurly_symbol (yyvs4.item (yyvsp4 - 1))
					yyval101.set_rcurly_symbol (yyvs4.item (yyvsp4))
				end				
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp4 := yyvsp4 -2
	yyvsp1 := yyvsp1 -2
	yyvs101.put (yyval101, yyvsp101)
end
		end

	yy_do_action_60 is
			--|#line 641 "eiffel.y"
		local
			yyval101: CLASS_LIST_AS
		do
--|#line 641 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 641")
end

				yyval101 := ast_factory.new_class_list_as (counter_value + 1)
				if yyval101 /= Void and yyvs2.item (yyvsp2) /= Void then
					yyval101.reverse_extend (yyvs2.item (yyvsp2))
					suppliers.insert_light_supplier_id (yyvs2.item (yyvsp2))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp101 := yyvsp101 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp101 >= yyvsc101 then
		if yyvs101 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs101")
			end
			create yyspecial_routines101
			yyvsc101 := yyInitial_yyvs_size
			yyvs101 := yyspecial_routines101.make (yyvsc101)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs101")
			end
			yyvsc101 := yyvsc101 + yyInitial_yyvs_size
			yyvs101 := yyspecial_routines101.resize (yyvs101, yyvsc101)
		end
	end
	yyvs101.put (yyval101, yyvsp101)
end
		end

	yy_do_action_61 is
			--|#line 649 "eiffel.y"
		local
			yyval101: CLASS_LIST_AS
		do
--|#line 649 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 649")
end

				yyval101 := yyvs101.item (yyvsp101)
				if yyval101 /= Void and yyvs2.item (yyvsp2) /= Void then
					yyval101.reverse_extend (yyvs2.item (yyvsp2))
					suppliers.insert_light_supplier_id (yyvs2.item (yyvsp2))
					ast_factory.reverse_extend_separator (yyval101, yyvs4.item (yyvsp4))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp101 := yyvsp101 -1
	yyvsp2 := yyvsp2 -1
	yyvsp4 := yyvsp4 -1
	yyvs101.put (yyval101, yyvsp101)
end
		end

	yy_do_action_62 is
			--|#line 649 "eiffel.y"
		local
			yyval101: CLASS_LIST_AS
		do
--|#line 649 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 649")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp101 := yyvsp101 + 1
	if yyvsp101 >= yyvsc101 then
		if yyvs101 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs101")
			end
			create yyspecial_routines101
			yyvsc101 := yyInitial_yyvs_size
			yyvs101 := yyspecial_routines101.make (yyvsc101)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs101")
			end
			yyvsc101 := yyvsc101 + yyInitial_yyvs_size
			yyvs101 := yyspecial_routines101.resize (yyvs101, yyvsc101)
		end
	end
	yyvs101.put (yyval101, yyvsp101)
end
		end

	yy_do_action_63 is
			--|#line 660 "eiffel.y"
		local
			yyval93: EIFFEL_LIST [FEATURE_AS]
		do
--|#line 660 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 660")
end

				yyval93 := ast_factory.new_eiffel_list_feature_as (counter_value + 1)
				if yyval93 /= Void and yyvs51.item (yyvsp51) /= Void then
					yyval93.reverse_extend (yyvs51.item (yyvsp51))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp93 := yyvsp93 + 1
	yyvsp51 := yyvsp51 -1
	if yyvsp93 >= yyvsc93 then
		if yyvs93 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs93")
			end
			create yyspecial_routines93
			yyvsc93 := yyInitial_yyvs_size
			yyvs93 := yyspecial_routines93.make (yyvsc93)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs93")
			end
			yyvsc93 := yyvsc93 + yyInitial_yyvs_size
			yyvs93 := yyspecial_routines93.resize (yyvs93, yyvsc93)
		end
	end
	yyvs93.put (yyval93, yyvsp93)
end
		end

	yy_do_action_64 is
			--|#line 667 "eiffel.y"
		local
			yyval93: EIFFEL_LIST [FEATURE_AS]
		do
--|#line 667 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 667")
end

				yyval93 := yyvs93.item (yyvsp93)
				if yyval93 /= Void and yyvs51.item (yyvsp51) /= Void then
					yyval93.reverse_extend (yyvs51.item (yyvsp51))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp93 := yyvsp93 -1
	yyvsp51 := yyvsp51 -1
	yyvs93.put (yyval93, yyvsp93)
end
		end

	yy_do_action_65 is
			--|#line 667 "eiffel.y"
		local
			yyval93: EIFFEL_LIST [FEATURE_AS]
		do
--|#line 667 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 667")
end

increment_counter
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp93 := yyvsp93 + 1
	if yyvsp93 >= yyvsc93 then
		if yyvs93 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs93")
			end
			create yyspecial_routines93
			yyvsc93 := yyInitial_yyvs_size
			yyvs93 := yyspecial_routines93.make (yyvsc93)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs93")
			end
			yyvsc93 := yyvsc93 + yyInitial_yyvs_size
			yyvs93 := yyspecial_routines93.resize (yyvs93, yyvsc93)
		end
	end
	yyvs93.put (yyval93, yyvsp93)
end
		end

	yy_do_action_66 is
			--|#line 676 "eiffel.y"
		local
			yyval4: SYMBOL_AS
		do
--|#line 676 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 676")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
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
	yyvs4.put (yyval4, yyvsp4)
end
		end

	yy_do_action_67 is
			--|#line 677 "eiffel.y"
		local
			yyval4: SYMBOL_AS
		do
--|#line 677 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 677")
end

yyval4 := yyvs4.item (yyvsp4) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs4.put (yyval4, yyvsp4)
end
		end

	yy_do_action_68 is
			--|#line 680 "eiffel.y"
		local
			yyval51: FEATURE_AS
		do
--|#line 680 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 680")
end

				yyval51 := ast_factory.new_feature_as (yyvs95.item (yyvsp95), yyvs34.item (yyvsp34), feature_indexes, position)
				feature_indexes := Void
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp51 := yyvsp51 + 1
	yyvsp1 := yyvsp1 -3
	yyvsp95 := yyvsp95 -1
	yyvsp34 := yyvsp34 -1
	if yyvsp51 >= yyvsc51 then
		if yyvs51 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs51")
			end
			create yyspecial_routines51
			yyvsc51 := yyInitial_yyvs_size
			yyvs51 := yyspecial_routines51.make (yyvsc51)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs51")
			end
			yyvsc51 := yyvsc51 + yyInitial_yyvs_size
			yyvs51 := yyspecial_routines51.resize (yyvs51, yyvsc51)
		end
	end
	yyvs51.put (yyval51, yyvsp51)
end
		end

	yy_do_action_69 is
			--|#line 687 "eiffel.y"
		local
			yyval95: EIFFEL_LIST [FEATURE_NAME]
		do
--|#line 687 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 687")
end

yyval95 := yyvs95.item (yyvsp95)
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs95.put (yyval95, yyvsp95)
end
		end

	yy_do_action_70 is
			--|#line 690 "eiffel.y"
		local
			yyval95: EIFFEL_LIST [FEATURE_NAME]
		do
--|#line 690 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 690")
end

report_unexpected_error (text, Void, True) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs95.put (yyval95, yyvsp95)
end
		end

	yy_do_action_71 is
			--|#line 694 "eiffel.y"
		local
			yyval95: EIFFEL_LIST [FEATURE_NAME]
		do
--|#line 694 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 694")
end

				yyval95 := ast_factory.new_eiffel_list_feature_name (counter_value + 1)
				if yyval95 /= Void and yyvs83.item (yyvsp83) /= Void then
					yyval95.reverse_extend (yyvs83.item (yyvsp83))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp95 := yyvsp95 + 1
	yyvsp83 := yyvsp83 -1
	if yyvsp95 >= yyvsc95 then
		if yyvs95 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs95")
			end
			create yyspecial_routines95
			yyvsc95 := yyInitial_yyvs_size
			yyvs95 := yyspecial_routines95.make (yyvsc95)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs95")
			end
			yyvsc95 := yyvsc95 + yyInitial_yyvs_size
			yyvs95 := yyspecial_routines95.resize (yyvs95, yyvsc95)
		end
	end
	yyvs95.put (yyval95, yyvsp95)
end
		end

	yy_do_action_72 is
			--|#line 702 "eiffel.y"
		local
			yyval95: EIFFEL_LIST [FEATURE_NAME]
		do
--|#line 702 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 702")
end

				yyval95 := yyvs95.item (yyvsp95)
				if yyval95 /= Void and yyvs83.item (yyvsp83) /= Void and counter_value > 0 then
					yyval95.reverse_extend (yyvs83.item (yyvsp83))
					ast_factory.reverse_extend_separator (yyval95, last_symbol_as_value)
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp83 := yyvsp83 -1
	yyvs95.put (yyval95, yyvsp95)
end
		end

	yy_do_action_73 is
			--|#line 710 "eiffel.y"
		local
			yyval95: EIFFEL_LIST [FEATURE_NAME]
		do
--|#line 710 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 710")
end

report_expected_after_error (parser_errors.comma_symbol, last_symbol_as_value, parser_errors.a_feature_name, False) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp95 := yyvsp95 + 1
	yyvsp83 := yyvsp83 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp95 >= yyvsc95 then
		if yyvs95 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs95")
			end
			create yyspecial_routines95
			yyvsc95 := yyInitial_yyvs_size
			yyvs95 := yyspecial_routines95.make (yyvsc95)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs95")
			end
			yyvsc95 := yyvsc95 + yyInitial_yyvs_size
			yyvs95 := yyspecial_routines95.resize (yyvs95, yyvsc95)
		end
	end
	yyvs95.put (yyval95, yyvsp95)
end
		end

	yy_do_action_74 is
			--|#line 714 "eiffel.y"
		local
			yyval83: FEATURE_NAME
		do
--|#line 714 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 714")
end

				increment_counter
				yyval83 := yyvs83.item (yyvsp83)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs83.put (yyval83, yyvsp83)
end
		end

	yy_do_action_75 is
			--|#line 721 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 721 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 721")
end


if yy_parsing_status = yyContinue then
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
		end

	yy_do_action_76 is
			--|#line 722 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 722 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 722")
end

report_expected_after_error (parser_errors.comma_symbol, yyvs4.item (yyvsp4), parser_errors.a_feature_name, False) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp4 := yyvsp4 -1
	yyvs1.put (yyval1, yyvsp1)
end
		end

	yy_do_action_77 is
			--|#line 726 "eiffel.y"
		local
			yyval83: FEATURE_NAME
		do
--|#line 726 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 726")
end

yyval83 := yyvs83.item (yyvsp83) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs83.put (yyval83, yyvsp83)
end
		end

	yy_do_action_78 is
			--|#line 728 "eiffel.y"
		local
			yyval83: FEATURE_NAME
		do
--|#line 728 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 728")
end

				yyval83 := yyvs83.item (yyvsp83)
				if yyval83 /= Void then
					yyval83.set_frozen_keyword (yyvs12.item (yyvsp12))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp12 := yyvsp12 -1
	yyvs83.put (yyval83, yyvsp83)
end
		end

	yy_do_action_79 is
			--|#line 737 "eiffel.y"
		local
			yyval83: FEATURE_NAME
		do
--|#line 737 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 737")
end

yyval83 := yyvs83.item (yyvsp83) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs83.put (yyval83, yyvsp83)
end
		end

	yy_do_action_80 is
			--|#line 739 "eiffel.y"
		local
			yyval83: FEATURE_NAME
		do
--|#line 739 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 739")
end

				if yyvs13.item (yyvsp13) /= Void then
					yyval83 := ast_factory.new_feature_name_alias_as (yyvs2.item (yyvsp2), yyvs13.item (yyvsp13).alias_name, has_convert_mark, yyvs13.item (yyvsp13).alias_keyword, yyvs13.item (yyvsp13).convert_keyword)
				else
					yyval83 := ast_factory.new_feature_name_alias_as (yyvs2.item (yyvsp2), Void, has_convert_mark, Void, Void)
				end
				
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp83 := yyvsp83 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp13 := yyvsp13 -1
	if yyvsp83 >= yyvsc83 then
		if yyvs83 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs83")
			end
			create yyspecial_routines83
			yyvsc83 := yyInitial_yyvs_size
			yyvs83 := yyspecial_routines83.make (yyvsc83)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs83")
			end
			yyvsc83 := yyvsc83 + yyInitial_yyvs_size
			yyvs83 := yyspecial_routines83.resize (yyvs83, yyvsc83)
		end
	end
	yyvs83.put (yyval83, yyvsp83)
end
		end

	yy_do_action_81 is
			--|#line 750 "eiffel.y"
		local
			yyval83: FEATURE_NAME
		do
--|#line 750 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 750")
end

yyval83 := ast_factory.new_feature_name_id_as (yyvs2.item (yyvsp2)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp83 := yyvsp83 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp83 >= yyvsc83 then
		if yyvs83 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs83")
			end
			create yyspecial_routines83
			yyvsc83 := yyInitial_yyvs_size
			yyvs83 := yyspecial_routines83.make (yyvsc83)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs83")
			end
			yyvsc83 := yyvsc83 + yyInitial_yyvs_size
			yyvs83 := yyspecial_routines83.resize (yyvs83, yyvsc83)
		end
	end
	yyvs83.put (yyval83, yyvsp83)
end
		end

	yy_do_action_82 is
			--|#line 752 "eiffel.y"
		local
			yyval83: FEATURE_NAME
		do
--|#line 752 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 752")
end

yyval83 := yyvs83.item (yyvsp83) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs83.put (yyval83, yyvsp83)
end
		end

	yy_do_action_83 is
			--|#line 754 "eiffel.y"
		local
			yyval83: FEATURE_NAME
		do
--|#line 754 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 754")
end

yyval83 := yyvs83.item (yyvsp83) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs83.put (yyval83, yyvsp83)
end
		end

	yy_do_action_84 is
			--|#line 758 "eiffel.y"
		local
			yyval83: FEATURE_NAME
		do
--|#line 758 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 758")
end

yyval83 := ast_factory.new_infix_as (yyvs18.item (yyvsp18), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp83 := yyvsp83 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp18 := yyvsp18 -1
	if yyvsp83 >= yyvsc83 then
		if yyvs83 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs83")
			end
			create yyspecial_routines83
			yyvsc83 := yyInitial_yyvs_size
			yyvs83 := yyspecial_routines83.make (yyvsc83)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs83")
			end
			yyvsc83 := yyvsc83 + yyInitial_yyvs_size
			yyvs83 := yyspecial_routines83.resize (yyvs83, yyvsc83)
		end
	end
	yyvs83.put (yyval83, yyvsp83)
end
		end

	yy_do_action_85 is
			--|#line 763 "eiffel.y"
		local
			yyval83: FEATURE_NAME
		do
--|#line 763 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 763")
end

yyval83 := ast_factory.new_prefix_as (yyvs18.item (yyvsp18), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp83 := yyvsp83 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp18 := yyvsp18 -1
	if yyvsp83 >= yyvsc83 then
		if yyvs83 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs83")
			end
			create yyspecial_routines83
			yyvsc83 := yyInitial_yyvs_size
			yyvs83 := yyspecial_routines83.make (yyvsc83)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs83")
			end
			yyvsc83 := yyvsc83 + yyInitial_yyvs_size
			yyvs83 := yyspecial_routines83.resize (yyvs83, yyvsc83)
		end
	end
	yyvs83.put (yyval83, yyvsp83)
end
		end

	yy_do_action_86 is
			--|#line 767 "eiffel.y"
		local
			yyval13: ALIAS_TRIPLE
		do
--|#line 767 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 767")
end

				yyval13 := ast_factory.new_alias_triple (yyvs12.item (yyvsp12 - 1), yyvs18.item (yyvsp18), yyvs12.item (yyvsp12))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp13 := yyvsp13 + 1
	yyvsp12 := yyvsp12 -2
	yyvsp18 := yyvsp18 -1
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
		end

	yy_do_action_87 is
			--|#line 773 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 773 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 773")
end

yyval18 := yyvs18.item (yyvsp18) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs18.put (yyval18, yyvsp18)
end
		end

	yy_do_action_88 is
			--|#line 775 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 775 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 775")
end

				yyval18 := ast_factory.new_string_as ("not", line, column, position, 5, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_89 is
			--|#line 779 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 779 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 779")
end

				yyval18 := ast_factory.new_string_as ("[]", line, column, position, 4, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_90 is
			--|#line 785 "eiffel.y"
		local
			yyval12: KEYWORD_AS
		do
--|#line 785 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 785")
end

has_convert_mark := False 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp12 := yyvsp12 + 1
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
		end

	yy_do_action_91 is
			--|#line 787 "eiffel.y"
		local
			yyval12: KEYWORD_AS
		do
--|#line 787 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 787")
end

has_convert_mark := True
				yyval12 := yyvs12.item (yyvsp12)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs12.put (yyval12, yyvsp12)
end
		end

	yy_do_action_92 is
			--|#line 793 "eiffel.y"
		local
			yyval34: BODY_AS
		do
--|#line 793 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 793")
end

					-- Attribute case
				if yyvs17.item (yyvsp17) = Void then
					yyval34 := ast_factory.new_body_as (Void, yyvs79.item (yyvsp79), Void, Void, yyvs4.item (yyvsp4), Void, Void, yyvs102.item (yyvsp102))
				else
					yyval34 := ast_factory.new_body_as (Void, yyvs79.item (yyvsp79), yyvs17.item (yyvsp17).second, Void, yyvs4.item (yyvsp4), Void, yyvs17.item (yyvsp17).first, yyvs102.item (yyvsp102))
				end				
				feature_indexes := yyvs102.item (yyvsp102)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp34 := yyvsp34 + 1
	yyvsp4 := yyvsp4 -1
	yyvsp79 := yyvsp79 -1
	yyvsp17 := yyvsp17 -1
	yyvsp102 := yyvsp102 -1
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
		end

	yy_do_action_93 is
			--|#line 803 "eiffel.y"
		local
			yyval34: BODY_AS
		do
--|#line 803 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 803")
end

					-- Constant case
				if yyvs17.item (yyvsp17) = Void then
					yyval34 := ast_factory.new_body_as (Void, yyvs79.item (yyvsp79), Void, yyvs39.item (yyvsp39), yyvs4.item (yyvsp4), yyvs12.item (yyvsp12), Void, yyvs102.item (yyvsp102))
				else
					yyval34 := ast_factory.new_body_as (Void, yyvs79.item (yyvsp79), yyvs17.item (yyvsp17).second, yyvs39.item (yyvsp39), yyvs4.item (yyvsp4), yyvs12.item (yyvsp12), yyvs17.item (yyvsp17).first, yyvs102.item (yyvsp102))
				end
				
				feature_indexes := yyvs102.item (yyvsp102)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 6
	yyvsp34 := yyvsp34 + 1
	yyvsp4 := yyvsp4 -1
	yyvsp79 := yyvsp79 -1
	yyvsp17 := yyvsp17 -1
	yyvsp12 := yyvsp12 -1
	yyvsp39 := yyvsp39 -1
	yyvsp102 := yyvsp102 -1
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
		end

	yy_do_action_94 is
			--|#line 814 "eiffel.y"
		local
			yyval34: BODY_AS
		do
--|#line 814 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 814")
end

					-- procedure without arguments		
				yyval34 := ast_factory.new_body_as (Void, Void, Void, yyvs74.item (yyvsp74), Void, yyvs12.item (yyvsp12), Void, yyvs102.item (yyvsp102))
				feature_indexes := yyvs102.item (yyvsp102)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp34 := yyvsp34 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp102 := yyvsp102 -1
	yyvsp74 := yyvsp74 -1
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
		end

	yy_do_action_95 is
			--|#line 820 "eiffel.y"
		local
			yyval34: BODY_AS
		do
--|#line 820 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 820")
end

report_expected_after_error (parser_errors.is_keyword, Void, parser_errors.a_routine_body_or_constant, True) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp34 := yyvsp34 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp102 := yyvsp102 -1
	yyvsp1 := yyvsp1 -1
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
		end

	yy_do_action_96 is
			--|#line 822 "eiffel.y"
		local
			yyval34: BODY_AS
		do
--|#line 822 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 822")
end

					-- Function without arguments
				if yyvs17.item (yyvsp17) = Void then
					yyval34 := ast_factory.new_body_as (Void, yyvs79.item (yyvsp79), Void, yyvs74.item (yyvsp74), yyvs4.item (yyvsp4), yyvs12.item (yyvsp12), Void, yyvs102.item (yyvsp102))
				else
					yyval34 := ast_factory.new_body_as (Void, yyvs79.item (yyvsp79), yyvs17.item (yyvsp17).second, yyvs74.item (yyvsp74), yyvs4.item (yyvsp4), yyvs12.item (yyvsp12), yyvs17.item (yyvsp17).first, yyvs102.item (yyvsp102))
				end
				
				feature_indexes := yyvs102.item (yyvsp102)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 6
	yyvsp34 := yyvsp34 + 1
	yyvsp4 := yyvsp4 -1
	yyvsp79 := yyvsp79 -1
	yyvsp17 := yyvsp17 -1
	yyvsp12 := yyvsp12 -1
	yyvsp102 := yyvsp102 -1
	yyvsp74 := yyvsp74 -1
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
		end

	yy_do_action_97 is
			--|#line 833 "eiffel.y"
		local
			yyval34: BODY_AS
		do
--|#line 833 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 833")
end

report_expected_after_error (parser_errors.is_keyword, Void, parser_errors.a_routine_body_or_constant, True) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 6
	yyvsp34 := yyvsp34 + 1
	yyvsp4 := yyvsp4 -1
	yyvsp79 := yyvsp79 -1
	yyvsp17 := yyvsp17 -1
	yyvsp12 := yyvsp12 -1
	yyvsp102 := yyvsp102 -1
	yyvsp1 := yyvsp1 -1
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
		end

	yy_do_action_98 is
			--|#line 835 "eiffel.y"
		local
			yyval34: BODY_AS
		do
--|#line 835 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 835")
end

				report_expected_after_error (parser_errors.colon_symbol, yyvs4.item (yyvsp4), parser_errors.a_class_name, False) 
				report_expected_after_error (parser_errors.is_keyword, yyvs12.item (yyvsp12), parser_errors.a_routine_body_or_constant, True) 
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp34 := yyvsp34 + 1
	yyvsp4 := yyvsp4 -1
	yyvsp12 := yyvsp12 -1
	yyvsp102 := yyvsp102 -1
	yyvsp1 := yyvsp1 -1
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
		end

	yy_do_action_99 is
			--|#line 840 "eiffel.y"
		local
			yyval34: BODY_AS
		do
--|#line 840 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 840")
end

report_expected_after_error (parser_errors.colon_symbol, yyvs4.item (yyvsp4), parser_errors.a_class_name, True) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp34 := yyvsp34 + 1
	yyvsp4 := yyvsp4 -1
	yyvsp102 := yyvsp102 -1
	yyvsp1 := yyvsp1 -1
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
		end

	yy_do_action_100 is
			--|#line 842 "eiffel.y"
		local
			yyval34: BODY_AS
		do
--|#line 842 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 842")
end

					-- procedure with arguments
				yyval34 := ast_factory.new_body_as (yyvs114.item (yyvsp114), Void, Void, yyvs74.item (yyvsp74), Void, yyvs12.item (yyvsp12), Void, yyvs102.item (yyvsp102))
				feature_indexes := yyvs102.item (yyvsp102)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp34 := yyvsp34 + 1
	yyvsp114 := yyvsp114 -1
	yyvsp12 := yyvsp12 -1
	yyvsp102 := yyvsp102 -1
	yyvsp74 := yyvsp74 -1
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
		end

	yy_do_action_101 is
			--|#line 848 "eiffel.y"
		local
			yyval34: BODY_AS
		do
--|#line 848 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 848")
end

report_expected_after_error (parser_errors.is_keyword, Void, parser_errors.a_routine_body, True) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp34 := yyvsp34 + 1
	yyvsp114 := yyvsp114 -1
	yyvsp12 := yyvsp12 -1
	yyvsp102 := yyvsp102 -1
	yyvsp1 := yyvsp1 -1
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
		end

	yy_do_action_102 is
			--|#line 850 "eiffel.y"
		local
			yyval34: BODY_AS
		do
--|#line 850 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 850")
end

					-- Function with arguments
				if yyvs17.item (yyvsp17) = Void then
					yyval34 := ast_factory.new_body_as (yyvs114.item (yyvsp114), yyvs79.item (yyvsp79), Void, yyvs74.item (yyvsp74), yyvs4.item (yyvsp4), yyvs12.item (yyvsp12), Void, yyvs102.item (yyvsp102))
				else
					yyval34 := ast_factory.new_body_as (yyvs114.item (yyvsp114), yyvs79.item (yyvsp79), yyvs17.item (yyvsp17).second, yyvs74.item (yyvsp74), yyvs4.item (yyvsp4), yyvs12.item (yyvsp12), yyvs17.item (yyvsp17).first, yyvs102.item (yyvsp102))
				end				
				feature_indexes := yyvs102.item (yyvsp102)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 7
	yyvsp34 := yyvsp34 + 1
	yyvsp114 := yyvsp114 -1
	yyvsp4 := yyvsp4 -1
	yyvsp79 := yyvsp79 -1
	yyvsp17 := yyvsp17 -1
	yyvsp12 := yyvsp12 -1
	yyvsp102 := yyvsp102 -1
	yyvsp74 := yyvsp74 -1
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
		end

	yy_do_action_103 is
			--|#line 860 "eiffel.y"
		local
			yyval34: BODY_AS
		do
--|#line 860 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 860")
end

report_expected_after_error (parser_errors.is_keyword, Void, parser_errors.a_routine_body, True) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 7
	yyvsp34 := yyvsp34 + 1
	yyvsp114 := yyvsp114 -1
	yyvsp4 := yyvsp4 -1
	yyvsp79 := yyvsp79 -1
	yyvsp17 := yyvsp17 -1
	yyvsp12 := yyvsp12 -1
	yyvsp102 := yyvsp102 -1
	yyvsp1 := yyvsp1 -1
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
		end

	yy_do_action_104 is
			--|#line 862 "eiffel.y"
		local
			yyval34: BODY_AS
		do
--|#line 862 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 862")
end

				report_expected_after_error (parser_errors.colon_symbol, yyvs4.item (yyvsp4), parser_errors.a_class_name, False) 
				report_expected_after_error (parser_errors.is_keyword, Void, parser_errors.a_routine_body, True)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp34 := yyvsp34 + 1
	yyvsp114 := yyvsp114 -1
	yyvsp4 := yyvsp4 -1
	yyvsp12 := yyvsp12 -1
	yyvsp102 := yyvsp102 -1
	yyvsp1 := yyvsp1 -1
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
		end

	yy_do_action_105 is
			--|#line 867 "eiffel.y"
		local
			yyval34: BODY_AS
		do
--|#line 867 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 867")
end

				report_expected_after_error (parser_errors.colon_symbol, yyvs4.item (yyvsp4), parser_errors.a_class_name, False) 
				report_expected_after_error (parser_errors.feature_declaration, yyvs4.item (yyvsp4), parser_errors.is_keyword, False)
				report_expected_after_error (parser_errors.feature_declaration, Void, parser_errors.a_routine_body, True)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp34 := yyvsp34 + 1
	yyvsp114 := yyvsp114 -1
	yyvsp4 := yyvsp4 -1
	yyvsp102 := yyvsp102 -1
	yyvsp1 := yyvsp1 -1
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
		end

	yy_do_action_106 is
			--|#line 873 "eiffel.y"
		local
			yyval34: BODY_AS
		do
--|#line 873 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 873")
end

report_expected_after_error (parser_errors.feature_declaration, yyvs114.item (yyvsp114), parser_errors.is_keyword, True) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp34 := yyvsp34 + 1
	yyvsp114 := yyvsp114 -1
	yyvsp102 := yyvsp102 -1
	yyvsp1 := yyvsp1 -1
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
		end

	yy_do_action_107 is
			--|#line 877 "eiffel.y"
		local
			yyval17: PAIR [KEYWORD_AS, ID_AS]
		do
--|#line 877 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 877")
end

				yyval17 := ast_factory.new_assigner_mark_as (Void, Void)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp17 := yyvsp17 + 1
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
		end

	yy_do_action_108 is
			--|#line 881 "eiffel.y"
		local
			yyval17: PAIR [KEYWORD_AS, ID_AS]
		do
--|#line 881 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 881")
end

				yyval17 := ast_factory.new_assigner_mark_as (yyvs12.item (yyvsp12), yyvs2.item (yyvsp2))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp17 := yyvsp17 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp2 := yyvsp2 -1
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
		end

	yy_do_action_109 is
			--|#line 885 "eiffel.y"
		local
			yyval17: PAIR [KEYWORD_AS, ID_AS]
		do
--|#line 885 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 885")
end

report_expected_after_error (parser_errors.assign_keyword, yyvs12.item (yyvsp12), parser_errors.a_indentifier, False) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp17 := yyvsp17 + 1
	yyvsp12 := yyvsp12 -1
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
		end

	yy_do_action_110 is
			--|#line 889 "eiffel.y"
		local
			yyval39: CONSTANT_AS
		do
--|#line 889 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 889")
end

yyval39 := ast_factory.new_constant_as (yyvs31.item (yyvsp31)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp39 := yyvsp39 + 1
	yyvsp31 := yyvsp31 -1
	if yyvsp39 >= yyvsc39 then
		if yyvs39 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs39")
			end
			create yyspecial_routines39
			yyvsc39 := yyInitial_yyvs_size
			yyvs39 := yyspecial_routines39.make (yyvsc39)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs39")
			end
			yyvsc39 := yyvsc39 + yyInitial_yyvs_size
			yyvs39 := yyspecial_routines39.resize (yyvs39, yyvsc39)
		end
	end
	yyvs39.put (yyval39, yyvsp39)
end
		end

	yy_do_action_111 is
			--|#line 891 "eiffel.y"
		local
			yyval39: CONSTANT_AS
		do
--|#line 891 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 891")
end

yyval39 := ast_factory.new_constant_as (yyvs8.item (yyvsp8)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp39 := yyvsp39 + 1
	yyvsp8 := yyvsp8 -1
	if yyvsp39 >= yyvsc39 then
		if yyvs39 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs39")
			end
			create yyspecial_routines39
			yyvsc39 := yyInitial_yyvs_size
			yyvs39 := yyspecial_routines39.make (yyvsc39)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs39")
			end
			yyvsc39 := yyvsc39 + yyInitial_yyvs_size
			yyvs39 := yyspecial_routines39.resize (yyvs39, yyvsc39)
		end
	end
	yyvs39.put (yyval39, yyvsp39)
end
		end

	yy_do_action_112 is
			--|#line 898 "eiffel.y"
		local
			yyval106: PARENT_LIST_AS
		do
--|#line 898 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 898")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp106 := yyvsp106 + 1
	if yyvsp106 >= yyvsc106 then
		if yyvs106 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs106")
			end
			create yyspecial_routines106
			yyvsc106 := yyInitial_yyvs_size
			yyvs106 := yyspecial_routines106.make (yyvsc106)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs106")
			end
			yyvsc106 := yyvsc106 + yyInitial_yyvs_size
			yyvs106 := yyspecial_routines106.resize (yyvs106, yyvsc106)
		end
	end
	yyvs106.put (yyval106, yyvsp106)
end
		end

	yy_do_action_113 is
			--|#line 900 "eiffel.y"
		local
			yyval106: PARENT_LIST_AS
		do
--|#line 900 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 900")
end

				report_warning (parser_errors.empty_inherit_clause_warning, Void)
				yyval106 := ast_factory.new_eiffel_list_parent_as (0)
				if yyval106 /= Void then
					yyval106.set_inherit_keyword (yyvs12.item (yyvsp12))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp106 := yyvsp106 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp4 := yyvsp4 -1
	if yyvsp106 >= yyvsc106 then
		if yyvs106 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs106")
			end
			create yyspecial_routines106
			yyvsc106 := yyInitial_yyvs_size
			yyvs106 := yyspecial_routines106.make (yyvsc106)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs106")
			end
			yyvsc106 := yyvsc106 + yyInitial_yyvs_size
			yyvs106 := yyspecial_routines106.resize (yyvs106, yyvsc106)
		end
	end
	yyvs106.put (yyval106, yyvsp106)
end
		end

	yy_do_action_114 is
			--|#line 908 "eiffel.y"
		local
			yyval106: PARENT_LIST_AS
		do
--|#line 908 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 908")
end

				yyval106 := yyvs106.item (yyvsp106)
				if yyval106 /= Void then
					yyval106.set_inherit_keyword (yyvs12.item (yyvsp12))
				end				
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp12 := yyvsp12 -1
	yyvsp1 := yyvsp1 -2
	yyvs106.put (yyval106, yyvsp106)
end
		end

	yy_do_action_115 is
			--|#line 917 "eiffel.y"
		local
			yyval106: PARENT_LIST_AS
		do
--|#line 917 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 917")
end

				yyval106 := ast_factory.new_eiffel_list_parent_as (counter_value + 1)
				if yyval106 /= Void and yyvs66.item (yyvsp66) /= Void then
					yyval106.reverse_extend (yyvs66.item (yyvsp66))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp106 := yyvsp106 + 1
	yyvsp66 := yyvsp66 -1
	if yyvsp106 >= yyvsc106 then
		if yyvs106 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs106")
			end
			create yyspecial_routines106
			yyvsc106 := yyInitial_yyvs_size
			yyvs106 := yyspecial_routines106.make (yyvsc106)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs106")
			end
			yyvsc106 := yyvsc106 + yyInitial_yyvs_size
			yyvs106 := yyspecial_routines106.resize (yyvs106, yyvsc106)
		end
	end
	yyvs106.put (yyval106, yyvsp106)
end
		end

	yy_do_action_116 is
			--|#line 924 "eiffel.y"
		local
			yyval106: PARENT_LIST_AS
		do
--|#line 924 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 924")
end

				yyval106 := yyvs106.item (yyvsp106)
				if yyval106 /= Void and yyvs66.item (yyvsp66) /= Void then
					yyval106.reverse_extend (yyvs66.item (yyvsp66))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp106 := yyvsp106 -1
	yyvsp66 := yyvsp66 -1
	yyvs106.put (yyval106, yyvsp106)
end
		end

	yy_do_action_117 is
			--|#line 924 "eiffel.y"
		local
			yyval106: PARENT_LIST_AS
		do
--|#line 924 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 924")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp106 := yyvsp106 + 1
	if yyvsp106 >= yyvsc106 then
		if yyvs106 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs106")
			end
			create yyspecial_routines106
			yyvsc106 := yyInitial_yyvs_size
			yyvs106 := yyspecial_routines106.make (yyvsc106)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs106")
			end
			yyvsc106 := yyvsc106 + yyInitial_yyvs_size
			yyvs106 := yyspecial_routines106.resize (yyvs106, yyvsc106)
		end
	end
	yyvs106.put (yyval106, yyvsp106)
end
		end

	yy_do_action_118 is
			--|#line 933 "eiffel.y"
		local
			yyval66: PARENT_AS
		do
--|#line 933 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 933")
end

yyval66 := yyvs66.item (yyvsp66) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp4 := yyvsp4 -1
	yyvs66.put (yyval66, yyvsp66)
end
		end

	yy_do_action_119 is
			--|#line 937 "eiffel.y"
		local
			yyval80: CLASS_TYPE_AS
		do
--|#line 937 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 937")
end

yyval80 := ast_factory.new_class_type_as (yyvs2.item (yyvsp2), yyvs111.item (yyvsp111)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp80 := yyvsp80 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp111 := yyvsp111 -1
	if yyvsp80 >= yyvsc80 then
		if yyvs80 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs80")
			end
			create yyspecial_routines80
			yyvsc80 := yyInitial_yyvs_size
			yyvs80 := yyspecial_routines80.make (yyvsc80)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs80")
			end
			yyvsc80 := yyvsc80 + yyInitial_yyvs_size
			yyvs80 := yyspecial_routines80.resize (yyvs80, yyvsc80)
		end
	end
	yyvs80.put (yyval80, yyvsp80)
end
		end

	yy_do_action_120 is
			--|#line 941 "eiffel.y"
		local
			yyval66: PARENT_AS
		do
--|#line 941 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 941")
end

				yyval66 := ast_factory.new_parent_as (yyvs80.item (yyvsp80), Void, Void, Void, Void, Void, Void)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp66 := yyvsp66 + 1
	yyvsp80 := yyvsp80 -1
	if yyvsp66 >= yyvsc66 then
		if yyvs66 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs66")
			end
			create yyspecial_routines66
			yyvsc66 := yyInitial_yyvs_size
			yyvs66 := yyspecial_routines66.make (yyvsc66)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs66")
			end
			yyvsc66 := yyvsc66 + yyInitial_yyvs_size
			yyvs66 := yyspecial_routines66.resize (yyvs66, yyvsc66)
		end
	end
	yyvs66.put (yyval66, yyvsp66)
end
		end

	yy_do_action_121 is
			--|#line 945 "eiffel.y"
		local
			yyval66: PARENT_AS
		do
--|#line 945 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 945")
end

				yyval66 := ast_factory.new_parent_as (yyvs80.item (yyvsp80), Void, Void, Void, Void, yyvs99.item (yyvsp99), yyvs12.item (yyvsp12))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp66 := yyvsp66 + 1
	yyvsp80 := yyvsp80 -1
	yyvsp99 := yyvsp99 -1
	yyvsp12 := yyvsp12 -1
	if yyvsp66 >= yyvsc66 then
		if yyvs66 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs66")
			end
			create yyspecial_routines66
			yyvsc66 := yyInitial_yyvs_size
			yyvs66 := yyspecial_routines66.make (yyvsc66)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs66")
			end
			yyvsc66 := yyvsc66 + yyInitial_yyvs_size
			yyvs66 := yyspecial_routines66.resize (yyvs66, yyvsc66)
		end
	end
	yyvs66.put (yyval66, yyvsp66)
end
		end

	yy_do_action_122 is
			--|#line 949 "eiffel.y"
		local
			yyval66: PARENT_AS
		do
--|#line 949 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 949")
end

				yyval66 := ast_factory.new_parent_as (yyvs80.item (yyvsp80), Void, Void, Void, yyvs98.item (yyvsp98), yyvs99.item (yyvsp99), yyvs12.item (yyvsp12))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp66 := yyvsp66 + 1
	yyvsp80 := yyvsp80 -1
	yyvsp98 := yyvsp98 -1
	yyvsp99 := yyvsp99 -1
	yyvsp12 := yyvsp12 -1
	if yyvsp66 >= yyvsc66 then
		if yyvs66 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs66")
			end
			create yyspecial_routines66
			yyvsc66 := yyInitial_yyvs_size
			yyvs66 := yyspecial_routines66.make (yyvsc66)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs66")
			end
			yyvsc66 := yyvsc66 + yyInitial_yyvs_size
			yyvs66 := yyspecial_routines66.resize (yyvs66, yyvsc66)
		end
	end
	yyvs66.put (yyval66, yyvsp66)
end
		end

	yy_do_action_123 is
			--|#line 953 "eiffel.y"
		local
			yyval66: PARENT_AS
		do
--|#line 953 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 953")
end

				yyval66 := ast_factory.new_parent_as (yyvs80.item (yyvsp80), Void, Void, yyvs97.item (yyvsp97), yyvs98.item (yyvsp98), yyvs99.item (yyvsp99), yyvs12.item (yyvsp12))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp66 := yyvsp66 + 1
	yyvsp80 := yyvsp80 -1
	yyvsp97 := yyvsp97 -1
	yyvsp98 := yyvsp98 -1
	yyvsp99 := yyvsp99 -1
	yyvsp12 := yyvsp12 -1
	if yyvsp66 >= yyvsc66 then
		if yyvs66 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs66")
			end
			create yyspecial_routines66
			yyvsc66 := yyInitial_yyvs_size
			yyvs66 := yyspecial_routines66.make (yyvsc66)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs66")
			end
			yyvsc66 := yyvsc66 + yyInitial_yyvs_size
			yyvs66 := yyspecial_routines66.resize (yyvs66, yyvsc66)
		end
	end
	yyvs66.put (yyval66, yyvsp66)
end
		end

	yy_do_action_124 is
			--|#line 957 "eiffel.y"
		local
			yyval66: PARENT_AS
		do
--|#line 957 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 957")
end

				yyval66 := ast_factory.new_parent_as (yyvs80.item (yyvsp80), Void, yyvs90.item (yyvsp90), yyvs97.item (yyvsp97), yyvs98.item (yyvsp98), yyvs99.item (yyvsp99), yyvs12.item (yyvsp12))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 6
	yyvsp66 := yyvsp66 + 1
	yyvsp80 := yyvsp80 -1
	yyvsp90 := yyvsp90 -1
	yyvsp97 := yyvsp97 -1
	yyvsp98 := yyvsp98 -1
	yyvsp99 := yyvsp99 -1
	yyvsp12 := yyvsp12 -1
	if yyvsp66 >= yyvsc66 then
		if yyvs66 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs66")
			end
			create yyspecial_routines66
			yyvsc66 := yyInitial_yyvs_size
			yyvs66 := yyspecial_routines66.make (yyvsc66)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs66")
			end
			yyvsc66 := yyvsc66 + yyInitial_yyvs_size
			yyvs66 := yyspecial_routines66.resize (yyvs66, yyvsc66)
		end
	end
	yyvs66.put (yyval66, yyvsp66)
end
		end

	yy_do_action_125 is
			--|#line 961 "eiffel.y"
		local
			yyval66: PARENT_AS
		do
--|#line 961 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 961")
end

				yyval66 := ast_factory.new_parent_as (yyvs80.item (yyvsp80), yyvs108.item (yyvsp108), yyvs90.item (yyvsp90), yyvs97.item (yyvsp97), yyvs98.item (yyvsp98), yyvs99.item (yyvsp99), yyvs12.item (yyvsp12))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 7
	yyvsp66 := yyvsp66 + 1
	yyvsp80 := yyvsp80 -1
	yyvsp108 := yyvsp108 -1
	yyvsp90 := yyvsp90 -1
	yyvsp97 := yyvsp97 -1
	yyvsp98 := yyvsp98 -1
	yyvsp99 := yyvsp99 -1
	yyvsp12 := yyvsp12 -1
	if yyvsp66 >= yyvsc66 then
		if yyvs66 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs66")
			end
			create yyspecial_routines66
			yyvsc66 := yyInitial_yyvs_size
			yyvs66 := yyspecial_routines66.make (yyvsc66)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs66")
			end
			yyvsc66 := yyvsc66 + yyInitial_yyvs_size
			yyvs66 := yyspecial_routines66.resize (yyvs66, yyvsc66)
		end
	end
	yyvs66.put (yyval66, yyvsp66)
end
		end

	yy_do_action_126 is
			--|#line 967 "eiffel.y"
		local
			yyval108: RENAME_CLAUSE_AS
		do
--|#line 967 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 967")
end

yyval108 := ast_factory.new_rename_clause_as (Void, yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp108 := yyvsp108 + 1
	yyvsp12 := yyvsp12 -1
	if yyvsp108 >= yyvsc108 then
		if yyvs108 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs108")
			end
			create yyspecial_routines108
			yyvsc108 := yyInitial_yyvs_size
			yyvs108 := yyspecial_routines108.make (yyvsc108)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs108")
			end
			yyvsc108 := yyvsc108 + yyInitial_yyvs_size
			yyvs108 := yyspecial_routines108.resize (yyvs108, yyvsc108)
		end
	end
	yyvs108.put (yyval108, yyvsp108)
end
		end

	yy_do_action_127 is
			--|#line 969 "eiffel.y"
		local
			yyval108: RENAME_CLAUSE_AS
		do
--|#line 969 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 969")
end

yyval108 := ast_factory.new_rename_clause_as (yyvs107.item (yyvsp107), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp108 := yyvsp108 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp1 := yyvsp1 -2
	yyvsp107 := yyvsp107 -1
	if yyvsp108 >= yyvsc108 then
		if yyvs108 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs108")
			end
			create yyspecial_routines108
			yyvsc108 := yyInitial_yyvs_size
			yyvs108 := yyspecial_routines108.make (yyvsc108)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs108")
			end
			yyvsc108 := yyvsc108 + yyInitial_yyvs_size
			yyvs108 := yyspecial_routines108.resize (yyvs108, yyvsc108)
		end
	end
	yyvs108.put (yyval108, yyvsp108)
end
		end

	yy_do_action_128 is
			--|#line 973 "eiffel.y"
		local
			yyval107: EIFFEL_LIST [RENAME_AS]
		do
--|#line 973 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 973")
end

				yyval107 := ast_factory.new_eiffel_list_rename_as (counter_value + 1)
				if yyval107 /= Void and yyvs70.item (yyvsp70) /= Void then
					yyval107.reverse_extend (yyvs70.item (yyvsp70))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp107 := yyvsp107 + 1
	yyvsp70 := yyvsp70 -1
	if yyvsp107 >= yyvsc107 then
		if yyvs107 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs107")
			end
			create yyspecial_routines107
			yyvsc107 := yyInitial_yyvs_size
			yyvs107 := yyspecial_routines107.make (yyvsc107)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs107")
			end
			yyvsc107 := yyvsc107 + yyInitial_yyvs_size
			yyvs107 := yyspecial_routines107.resize (yyvs107, yyvsc107)
		end
	end
	yyvs107.put (yyval107, yyvsp107)
end
		end

	yy_do_action_129 is
			--|#line 980 "eiffel.y"
		local
			yyval107: EIFFEL_LIST [RENAME_AS]
		do
--|#line 980 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 980")
end

				yyval107 := yyvs107.item (yyvsp107)
				if yyval107 /= Void and yyvs70.item (yyvsp70) /= Void then
					yyval107.reverse_extend (yyvs70.item (yyvsp70))
					ast_factory.reverse_extend_separator (yyval107, yyvs4.item (yyvsp4))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp107 := yyvsp107 -1
	yyvsp70 := yyvsp70 -1
	yyvsp4 := yyvsp4 -1
	yyvs107.put (yyval107, yyvsp107)
end
		end

	yy_do_action_130 is
			--|#line 980 "eiffel.y"
		local
			yyval107: EIFFEL_LIST [RENAME_AS]
		do
--|#line 980 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 980")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp107 := yyvsp107 + 1
	if yyvsp107 >= yyvsc107 then
		if yyvs107 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs107")
			end
			create yyspecial_routines107
			yyvsc107 := yyInitial_yyvs_size
			yyvs107 := yyspecial_routines107.make (yyvsc107)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs107")
			end
			yyvsc107 := yyvsc107 + yyInitial_yyvs_size
			yyvs107 := yyspecial_routines107.resize (yyvs107, yyvsc107)
		end
	end
	yyvs107.put (yyval107, yyvsp107)
end
		end

	yy_do_action_131 is
			--|#line 990 "eiffel.y"
		local
			yyval70: RENAME_AS
		do
--|#line 990 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 990")
end

yyval70 := ast_factory.new_rename_as (yyvs83.item (yyvsp83 - 1), yyvs83.item (yyvsp83), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp70 := yyvsp70 + 1
	yyvsp83 := yyvsp83 -2
	yyvsp12 := yyvsp12 -1
	if yyvsp70 >= yyvsc70 then
		if yyvs70 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs70")
			end
			create yyspecial_routines70
			yyvsc70 := yyInitial_yyvs_size
			yyvs70 := yyspecial_routines70.make (yyvsc70)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs70")
			end
			yyvsc70 := yyvsc70 + yyInitial_yyvs_size
			yyvs70 := yyspecial_routines70.resize (yyvs70, yyvsc70)
		end
	end
	yyvs70.put (yyval70, yyvsp70)
end
		end

	yy_do_action_132 is
			--|#line 994 "eiffel.y"
		local
			yyval90: EXPORT_CLAUSE_AS
		do
--|#line 994 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 994")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp90 := yyvsp90 + 1
	if yyvsp90 >= yyvsc90 then
		if yyvs90 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs90")
			end
			create yyspecial_routines90
			yyvsc90 := yyInitial_yyvs_size
			yyvs90 := yyspecial_routines90.make (yyvsc90)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs90")
			end
			yyvsc90 := yyvsc90 + yyInitial_yyvs_size
			yyvs90 := yyspecial_routines90.resize (yyvs90, yyvsc90)
		end
	end
	yyvs90.put (yyval90, yyvsp90)
end
		end

	yy_do_action_133 is
			--|#line 996 "eiffel.y"
		local
			yyval90: EXPORT_CLAUSE_AS
		do
--|#line 996 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 996")
end

yyval90 := yyvs90.item (yyvsp90) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs90.put (yyval90, yyvsp90)
end
		end

	yy_do_action_134 is
			--|#line 1000 "eiffel.y"
		local
			yyval90: EXPORT_CLAUSE_AS
		do
--|#line 1000 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1000")
end

yyval90 := ast_factory.new_export_clause_as (yyvs89.item (yyvsp89), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp90 := yyvsp90 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp1 := yyvsp1 -2
	yyvsp89 := yyvsp89 -1
	if yyvsp90 >= yyvsc90 then
		if yyvs90 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs90")
			end
			create yyspecial_routines90
			yyvsc90 := yyInitial_yyvs_size
			yyvs90 := yyspecial_routines90.make (yyvsc90)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs90")
			end
			yyvsc90 := yyvsc90 + yyInitial_yyvs_size
			yyvs90 := yyspecial_routines90.resize (yyvs90, yyvsc90)
		end
	end
	yyvs90.put (yyval90, yyvsp90)
end
		end

	yy_do_action_135 is
			--|#line 1002 "eiffel.y"
		local
			yyval90: EXPORT_CLAUSE_AS
		do
--|#line 1002 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1002")
end

yyval90 := ast_factory.new_export_clause_as (Void, yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp90 := yyvsp90 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp4 := yyvsp4 -1
	if yyvsp90 >= yyvsc90 then
		if yyvs90 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs90")
			end
			create yyspecial_routines90
			yyvsc90 := yyInitial_yyvs_size
			yyvs90 := yyspecial_routines90.make (yyvsc90)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs90")
			end
			yyvsc90 := yyvsc90 + yyInitial_yyvs_size
			yyvs90 := yyspecial_routines90.resize (yyvs90, yyvsc90)
		end
	end
	yyvs90.put (yyval90, yyvsp90)
end
		end

	yy_do_action_136 is
			--|#line 1006 "eiffel.y"
		local
			yyval89: EIFFEL_LIST [EXPORT_ITEM_AS]
		do
--|#line 1006 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1006")
end

				yyval89 := ast_factory.new_eiffel_list_export_item_as (counter_value + 1)
				if yyval89 /= Void and yyvs47.item (yyvsp47) /= Void then
					yyval89.reverse_extend (yyvs47.item (yyvsp47))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp89 := yyvsp89 + 1
	yyvsp47 := yyvsp47 -1
	if yyvsp89 >= yyvsc89 then
		if yyvs89 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs89")
			end
			create yyspecial_routines89
			yyvsc89 := yyInitial_yyvs_size
			yyvs89 := yyspecial_routines89.make (yyvsc89)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs89")
			end
			yyvsc89 := yyvsc89 + yyInitial_yyvs_size
			yyvs89 := yyspecial_routines89.resize (yyvs89, yyvsc89)
		end
	end
	yyvs89.put (yyval89, yyvsp89)
end
		end

	yy_do_action_137 is
			--|#line 1013 "eiffel.y"
		local
			yyval89: EIFFEL_LIST [EXPORT_ITEM_AS]
		do
--|#line 1013 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1013")
end

				yyval89 := yyvs89.item (yyvsp89)
				if yyval89 /= Void and yyvs47.item (yyvsp47) /= Void then
					yyval89.reverse_extend (yyvs47.item (yyvsp47))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp89 := yyvsp89 -1
	yyvsp47 := yyvsp47 -1
	yyvs89.put (yyval89, yyvsp89)
end
		end

	yy_do_action_138 is
			--|#line 1013 "eiffel.y"
		local
			yyval89: EIFFEL_LIST [EXPORT_ITEM_AS]
		do
--|#line 1013 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1013")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp89 := yyvsp89 + 1
	if yyvsp89 >= yyvsc89 then
		if yyvs89 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs89")
			end
			create yyspecial_routines89
			yyvsc89 := yyInitial_yyvs_size
			yyvs89 := yyspecial_routines89.make (yyvsc89)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs89")
			end
			yyvsc89 := yyvsc89 + yyInitial_yyvs_size
			yyvs89 := yyspecial_routines89.resize (yyvs89, yyvsc89)
		end
	end
	yyvs89.put (yyval89, yyvsp89)
end
		end

	yy_do_action_139 is
			--|#line 1022 "eiffel.y"
		local
			yyval47: EXPORT_ITEM_AS
		do
--|#line 1022 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1022")
end

					yyval47 := ast_factory.new_export_item_as (ast_factory.new_client_as (yyvs101.item (yyvsp101)), yyvs53.item (yyvsp53))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp47 := yyvsp47 + 1
	yyvsp101 := yyvsp101 -1
	yyvsp53 := yyvsp53 -1
	yyvsp4 := yyvsp4 -1
	if yyvsp47 >= yyvsc47 then
		if yyvs47 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs47")
			end
			create yyspecial_routines47
			yyvsc47 := yyInitial_yyvs_size
			yyvs47 := yyspecial_routines47.make (yyvsc47)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs47")
			end
			yyvsc47 := yyvsc47 + yyInitial_yyvs_size
			yyvs47 := yyspecial_routines47.resize (yyvs47, yyvsc47)
		end
	end
	yyvs47.put (yyval47, yyvsp47)
end
		end

	yy_do_action_140 is
			--|#line 1028 "eiffel.y"
		local
			yyval53: FEATURE_SET_AS
		do
--|#line 1028 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1028")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp53 := yyvsp53 + 1
	if yyvsp53 >= yyvsc53 then
		if yyvs53 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs53")
			end
			create yyspecial_routines53
			yyvsc53 := yyInitial_yyvs_size
			yyvs53 := yyspecial_routines53.make (yyvsc53)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs53")
			end
			yyvsc53 := yyvsc53 + yyInitial_yyvs_size
			yyvs53 := yyspecial_routines53.resize (yyvs53, yyvsc53)
		end
	end
	yyvs53.put (yyval53, yyvsp53)
end
		end

	yy_do_action_141 is
			--|#line 1030 "eiffel.y"
		local
			yyval53: FEATURE_SET_AS
		do
--|#line 1030 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1030")
end

yyval53 := ast_factory.new_all_as (yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp53 := yyvsp53 + 1
	yyvsp12 := yyvsp12 -1
	if yyvsp53 >= yyvsc53 then
		if yyvs53 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs53")
			end
			create yyspecial_routines53
			yyvsc53 := yyInitial_yyvs_size
			yyvs53 := yyspecial_routines53.make (yyvsc53)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs53")
			end
			yyvsc53 := yyvsc53 + yyInitial_yyvs_size
			yyvs53 := yyspecial_routines53.resize (yyvs53, yyvsc53)
		end
	end
	yyvs53.put (yyval53, yyvsp53)
end
		end

	yy_do_action_142 is
			--|#line 1032 "eiffel.y"
		local
			yyval53: FEATURE_SET_AS
		do
--|#line 1032 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1032")
end

yyval53 := ast_factory.new_feature_list_as (yyvs95.item (yyvsp95)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp53 := yyvsp53 + 1
	yyvsp95 := yyvsp95 -1
	if yyvsp53 >= yyvsc53 then
		if yyvs53 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs53")
			end
			create yyspecial_routines53
			yyvsc53 := yyInitial_yyvs_size
			yyvs53 := yyspecial_routines53.make (yyvsc53)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs53")
			end
			yyvsc53 := yyvsc53 + yyInitial_yyvs_size
			yyvs53 := yyspecial_routines53.resize (yyvs53, yyvsc53)
		end
	end
	yyvs53.put (yyval53, yyvsp53)
end
		end

	yy_do_action_143 is
			--|#line 1036 "eiffel.y"
		local
			yyval86: CONVERT_FEAT_LIST_AS
		do
--|#line 1036 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1036")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp86 := yyvsp86 + 1
	if yyvsp86 >= yyvsc86 then
		if yyvs86 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs86")
			end
			create yyspecial_routines86
			yyvsc86 := yyInitial_yyvs_size
			yyvs86 := yyspecial_routines86.make (yyvsc86)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs86")
			end
			yyvsc86 := yyvsc86 + yyInitial_yyvs_size
			yyvs86 := yyspecial_routines86.resize (yyvs86, yyvsc86)
		end
	end
	yyvs86.put (yyval86, yyvsp86)
end
		end

	yy_do_action_144 is
			--|#line 1038 "eiffel.y"
		local
			yyval86: CONVERT_FEAT_LIST_AS
		do
--|#line 1038 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1038")
end

			yyval86 := yyvs86.item (yyvsp86)
			if yyval86 /= Void then
				yyval86.set_convert_keyword (yyvs12.item (yyvsp12))
			end
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp12 := yyvsp12 -1
	yyvsp1 := yyvsp1 -2
	yyvs86.put (yyval86, yyvsp86)
end
		end

	yy_do_action_145 is
			--|#line 1047 "eiffel.y"
		local
			yyval86: CONVERT_FEAT_LIST_AS
		do
--|#line 1047 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1047")
end

			yyval86 := ast_factory.new_eiffel_list_convert (counter_value + 1)
			if yyval86 /= Void and yyvs40.item (yyvsp40) /= Void then
				yyval86.reverse_extend (yyvs40.item (yyvsp40))
			end
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp86 := yyvsp86 + 1
	yyvsp40 := yyvsp40 -1
	if yyvsp86 >= yyvsc86 then
		if yyvs86 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs86")
			end
			create yyspecial_routines86
			yyvsc86 := yyInitial_yyvs_size
			yyvs86 := yyspecial_routines86.make (yyvsc86)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs86")
			end
			yyvsc86 := yyvsc86 + yyInitial_yyvs_size
			yyvs86 := yyspecial_routines86.resize (yyvs86, yyvsc86)
		end
	end
	yyvs86.put (yyval86, yyvsp86)
end
		end

	yy_do_action_146 is
			--|#line 1054 "eiffel.y"
		local
			yyval86: CONVERT_FEAT_LIST_AS
		do
--|#line 1054 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1054")
end

			yyval86 := yyvs86.item (yyvsp86)
			if yyval86 /= Void and yyvs40.item (yyvsp40) /= Void then
				yyval86.reverse_extend (yyvs40.item (yyvsp40))
				ast_factory.reverse_extend_separator (yyval86, yyvs4.item (yyvsp4))
			end
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp86 := yyvsp86 -1
	yyvsp40 := yyvsp40 -1
	yyvsp4 := yyvsp4 -1
	yyvs86.put (yyval86, yyvsp86)
end
		end

	yy_do_action_147 is
			--|#line 1054 "eiffel.y"
		local
			yyval86: CONVERT_FEAT_LIST_AS
		do
--|#line 1054 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1054")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp86 := yyvsp86 + 1
	if yyvsp86 >= yyvsc86 then
		if yyvs86 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs86")
			end
			create yyspecial_routines86
			yyvsc86 := yyInitial_yyvs_size
			yyvs86 := yyspecial_routines86.make (yyvsc86)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs86")
			end
			yyvsc86 := yyvsc86 + yyInitial_yyvs_size
			yyvs86 := yyspecial_routines86.resize (yyvs86, yyvsc86)
		end
	end
	yyvs86.put (yyval86, yyvsp86)
end
		end

	yy_do_action_148 is
			--|#line 1065 "eiffel.y"
		local
			yyval40: CONVERT_FEAT_AS
		do
--|#line 1065 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1065")
end

				-- True because this is a conversion feature used as a creation
				-- procedure in current class.
			yyval40 := ast_factory.new_convert_feat_as (True, yyvs83.item (yyvsp83), yyvs111.item (yyvsp111), yyvs4.item (yyvsp4 - 3), yyvs4.item (yyvsp4), Void, yyvs4.item (yyvsp4 - 2), yyvs4.item (yyvsp4 - 1))
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 6
	yyvsp40 := yyvsp40 + 1
	yyvsp83 := yyvsp83 -1
	yyvsp4 := yyvsp4 -4
	yyvsp111 := yyvsp111 -1
	if yyvsp40 >= yyvsc40 then
		if yyvs40 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs40")
			end
			create yyspecial_routines40
			yyvsc40 := yyInitial_yyvs_size
			yyvs40 := yyspecial_routines40.make (yyvsc40)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs40")
			end
			yyvsc40 := yyvsc40 + yyInitial_yyvs_size
			yyvs40 := yyspecial_routines40.resize (yyvs40, yyvsc40)
		end
	end
	yyvs40.put (yyval40, yyvsp40)
end
		end

	yy_do_action_149 is
			--|#line 1071 "eiffel.y"
		local
			yyval40: CONVERT_FEAT_AS
		do
--|#line 1071 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1071")
end

				-- False because this is not a conversion feature used as a creation
				-- procedure.
			yyval40 := ast_factory.new_convert_feat_as (False, yyvs83.item (yyvsp83), yyvs111.item (yyvsp111), Void, Void, yyvs4.item (yyvsp4 - 2), yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4))
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp40 := yyvsp40 + 1
	yyvsp83 := yyvsp83 -1
	yyvsp4 := yyvsp4 -3
	yyvsp111 := yyvsp111 -1
	if yyvsp40 >= yyvsc40 then
		if yyvs40 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs40")
			end
			create yyspecial_routines40
			yyvsc40 := yyInitial_yyvs_size
			yyvs40 := yyspecial_routines40.make (yyvsc40)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs40")
			end
			yyvsc40 := yyvsc40 + yyInitial_yyvs_size
			yyvs40 := yyspecial_routines40.resize (yyvs40, yyvsc40)
		end
	end
	yyvs40.put (yyval40, yyvsp40)
end
		end

	yy_do_action_150 is
			--|#line 1079 "eiffel.y"
		local
			yyval95: EIFFEL_LIST [FEATURE_NAME]
		do
--|#line 1079 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1079")
end

yyval95 := yyvs95.item (yyvsp95) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs95.put (yyval95, yyvsp95)
end
		end

	yy_do_action_151 is
			--|#line 1083 "eiffel.y"
		local
			yyval95: EIFFEL_LIST [FEATURE_NAME]
		do
--|#line 1083 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1083")
end

				yyval95 := ast_factory.new_eiffel_list_feature_name (counter_value + 1)
				if yyval95 /= Void and yyvs83.item (yyvsp83) /= Void then
					yyval95.reverse_extend (yyvs83.item (yyvsp83))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp95 := yyvsp95 + 1
	yyvsp83 := yyvsp83 -1
	if yyvsp95 >= yyvsc95 then
		if yyvs95 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs95")
			end
			create yyspecial_routines95
			yyvsc95 := yyInitial_yyvs_size
			yyvs95 := yyspecial_routines95.make (yyvsc95)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs95")
			end
			yyvsc95 := yyvsc95 + yyInitial_yyvs_size
			yyvs95 := yyspecial_routines95.resize (yyvs95, yyvsc95)
		end
	end
	yyvs95.put (yyval95, yyvsp95)
end
		end

	yy_do_action_152 is
			--|#line 1090 "eiffel.y"
		local
			yyval95: EIFFEL_LIST [FEATURE_NAME]
		do
--|#line 1090 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1090")
end

				yyval95 := yyvs95.item (yyvsp95)
				if yyval95 /= Void and yyvs83.item (yyvsp83) /= Void then
					yyval95.reverse_extend (yyvs83.item (yyvsp83))
					ast_factory.reverse_extend_separator (yyval95, yyvs4.item (yyvsp4))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp95 := yyvsp95 -1
	yyvsp83 := yyvsp83 -1
	yyvsp4 := yyvsp4 -1
	yyvs95.put (yyval95, yyvsp95)
end
		end

	yy_do_action_153 is
			--|#line 1090 "eiffel.y"
		local
			yyval95: EIFFEL_LIST [FEATURE_NAME]
		do
--|#line 1090 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1090")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp95 := yyvsp95 + 1
	if yyvsp95 >= yyvsc95 then
		if yyvs95 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs95")
			end
			create yyspecial_routines95
			yyvsc95 := yyInitial_yyvs_size
			yyvs95 := yyspecial_routines95.make (yyvsc95)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs95")
			end
			yyvsc95 := yyvsc95 + yyInitial_yyvs_size
			yyvs95 := yyspecial_routines95.resize (yyvs95, yyvsc95)
		end
	end
	yyvs95.put (yyval95, yyvsp95)
end
		end

	yy_do_action_154 is
			--|#line 1100 "eiffel.y"
		local
			yyval97: UNDEFINE_CLAUSE_AS
		do
--|#line 1100 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1100")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp97 := yyvsp97 + 1
	if yyvsp97 >= yyvsc97 then
		if yyvs97 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs97")
			end
			create yyspecial_routines97
			yyvsc97 := yyInitial_yyvs_size
			yyvs97 := yyspecial_routines97.make (yyvsc97)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs97")
			end
			yyvsc97 := yyvsc97 + yyInitial_yyvs_size
			yyvs97 := yyspecial_routines97.resize (yyvs97, yyvsc97)
		end
	end
	yyvs97.put (yyval97, yyvsp97)
end
		end

	yy_do_action_155 is
			--|#line 1102 "eiffel.y"
		local
			yyval97: UNDEFINE_CLAUSE_AS
		do
--|#line 1102 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1102")
end

yyval97 := yyvs97.item (yyvsp97) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs97.put (yyval97, yyvsp97)
end
		end

	yy_do_action_156 is
			--|#line 1106 "eiffel.y"
		local
			yyval97: UNDEFINE_CLAUSE_AS
		do
--|#line 1106 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1106")
end

			yyval97 := ast_factory.new_undefine_clause_as (Void, yyvs12.item (yyvsp12))
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp97 := yyvsp97 + 1
	yyvsp12 := yyvsp12 -1
	if yyvsp97 >= yyvsc97 then
		if yyvs97 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs97")
			end
			create yyspecial_routines97
			yyvsc97 := yyInitial_yyvs_size
			yyvs97 := yyspecial_routines97.make (yyvsc97)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs97")
			end
			yyvsc97 := yyvsc97 + yyInitial_yyvs_size
			yyvs97 := yyspecial_routines97.resize (yyvs97, yyvsc97)
		end
	end
	yyvs97.put (yyval97, yyvsp97)
end
		end

	yy_do_action_157 is
			--|#line 1111 "eiffel.y"
		local
			yyval97: UNDEFINE_CLAUSE_AS
		do
--|#line 1111 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1111")
end

				yyval97 := ast_factory.new_undefine_clause_as (yyvs95.item (yyvsp95), yyvs12.item (yyvsp12))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp97 := yyvsp97 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp95 := yyvsp95 -1
	if yyvsp97 >= yyvsc97 then
		if yyvs97 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs97")
			end
			create yyspecial_routines97
			yyvsc97 := yyInitial_yyvs_size
			yyvs97 := yyspecial_routines97.make (yyvsc97)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs97")
			end
			yyvsc97 := yyvsc97 + yyInitial_yyvs_size
			yyvs97 := yyspecial_routines97.resize (yyvs97, yyvsc97)
		end
	end
	yyvs97.put (yyval97, yyvsp97)
end
		end

	yy_do_action_158 is
			--|#line 1117 "eiffel.y"
		local
			yyval98: REDEFINE_CLAUSE_AS
		do
--|#line 1117 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1117")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp98 := yyvsp98 + 1
	if yyvsp98 >= yyvsc98 then
		if yyvs98 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs98")
			end
			create yyspecial_routines98
			yyvsc98 := yyInitial_yyvs_size
			yyvs98 := yyspecial_routines98.make (yyvsc98)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs98")
			end
			yyvsc98 := yyvsc98 + yyInitial_yyvs_size
			yyvs98 := yyspecial_routines98.resize (yyvs98, yyvsc98)
		end
	end
	yyvs98.put (yyval98, yyvsp98)
end
		end

	yy_do_action_159 is
			--|#line 1119 "eiffel.y"
		local
			yyval98: REDEFINE_CLAUSE_AS
		do
--|#line 1119 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1119")
end

yyval98 := yyvs98.item (yyvsp98) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs98.put (yyval98, yyvsp98)
end
		end

	yy_do_action_160 is
			--|#line 1123 "eiffel.y"
		local
			yyval98: REDEFINE_CLAUSE_AS
		do
--|#line 1123 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1123")
end

			yyval98 := ast_factory.new_redefine_clause_as (Void, yyvs12.item (yyvsp12))
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp98 := yyvsp98 + 1
	yyvsp12 := yyvsp12 -1
	if yyvsp98 >= yyvsc98 then
		if yyvs98 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs98")
			end
			create yyspecial_routines98
			yyvsc98 := yyInitial_yyvs_size
			yyvs98 := yyspecial_routines98.make (yyvsc98)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs98")
			end
			yyvsc98 := yyvsc98 + yyInitial_yyvs_size
			yyvs98 := yyspecial_routines98.resize (yyvs98, yyvsc98)
		end
	end
	yyvs98.put (yyval98, yyvsp98)
end
		end

	yy_do_action_161 is
			--|#line 1128 "eiffel.y"
		local
			yyval98: REDEFINE_CLAUSE_AS
		do
--|#line 1128 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1128")
end

				yyval98 := ast_factory.new_redefine_clause_as (yyvs95.item (yyvsp95), yyvs12.item (yyvsp12))				
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp98 := yyvsp98 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp95 := yyvsp95 -1
	if yyvsp98 >= yyvsc98 then
		if yyvs98 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs98")
			end
			create yyspecial_routines98
			yyvsc98 := yyInitial_yyvs_size
			yyvs98 := yyspecial_routines98.make (yyvsc98)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs98")
			end
			yyvsc98 := yyvsc98 + yyInitial_yyvs_size
			yyvs98 := yyspecial_routines98.resize (yyvs98, yyvsc98)
		end
	end
	yyvs98.put (yyval98, yyvsp98)
end
		end

	yy_do_action_162 is
			--|#line 1134 "eiffel.y"
		local
			yyval99: SELECT_CLAUSE_AS
		do
--|#line 1134 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1134")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp99 := yyvsp99 + 1
	if yyvsp99 >= yyvsc99 then
		if yyvs99 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs99")
			end
			create yyspecial_routines99
			yyvsc99 := yyInitial_yyvs_size
			yyvs99 := yyspecial_routines99.make (yyvsc99)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs99")
			end
			yyvsc99 := yyvsc99 + yyInitial_yyvs_size
			yyvs99 := yyspecial_routines99.resize (yyvs99, yyvsc99)
		end
	end
	yyvs99.put (yyval99, yyvsp99)
end
		end

	yy_do_action_163 is
			--|#line 1136 "eiffel.y"
		local
			yyval99: SELECT_CLAUSE_AS
		do
--|#line 1136 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1136")
end

yyval99 := yyvs99.item (yyvsp99) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs99.put (yyval99, yyvsp99)
end
		end

	yy_do_action_164 is
			--|#line 1140 "eiffel.y"
		local
			yyval99: SELECT_CLAUSE_AS
		do
--|#line 1140 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1140")
end

			yyval99 := ast_factory.new_select_clause_as (Void, yyvs12.item (yyvsp12))
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp99 := yyvsp99 + 1
	yyvsp12 := yyvsp12 -1
	if yyvsp99 >= yyvsc99 then
		if yyvs99 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs99")
			end
			create yyspecial_routines99
			yyvsc99 := yyInitial_yyvs_size
			yyvs99 := yyspecial_routines99.make (yyvsc99)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs99")
			end
			yyvsc99 := yyvsc99 + yyInitial_yyvs_size
			yyvs99 := yyspecial_routines99.resize (yyvs99, yyvsc99)
		end
	end
	yyvs99.put (yyval99, yyvsp99)
end
		end

	yy_do_action_165 is
			--|#line 1145 "eiffel.y"
		local
			yyval99: SELECT_CLAUSE_AS
		do
--|#line 1145 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1145")
end

				yyval99 := ast_factory.new_select_clause_as (yyvs95.item (yyvsp95), yyvs12.item (yyvsp12))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp99 := yyvsp99 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp95 := yyvsp95 -1
	if yyvsp99 >= yyvsc99 then
		if yyvs99 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs99")
			end
			create yyspecial_routines99
			yyvsc99 := yyInitial_yyvs_size
			yyvs99 := yyspecial_routines99.make (yyvsc99)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs99")
			end
			yyvsc99 := yyvsc99 + yyInitial_yyvs_size
			yyvs99 := yyspecial_routines99.resize (yyvs99, yyvsc99)
		end
	end
	yyvs99.put (yyval99, yyvsp99)
end
		end

	yy_do_action_166 is
			--|#line 1155 "eiffel.y"
		local
			yyval114: FORMAL_ARGU_DEC_LIST_AS
		do
--|#line 1155 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1155")
end

				yyval114 := ast_factory.new_formal_argu_dec_list_as (Void, yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4)) 
				report_warning (parser_errors.empty_parenthesis_warning, yyvs4.item (yyvsp4 - 1))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp114 := yyvsp114 + 1
	yyvsp4 := yyvsp4 -2
	if yyvsp114 >= yyvsc114 then
		if yyvs114 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs114")
			end
			create yyspecial_routines114
			yyvsc114 := yyInitial_yyvs_size
			yyvs114 := yyspecial_routines114.make (yyvsc114)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs114")
			end
			yyvsc114 := yyvsc114 + yyInitial_yyvs_size
			yyvs114 := yyspecial_routines114.resize (yyvs114, yyvsc114)
		end
	end
	yyvs114.put (yyval114, yyvsp114)
end
		end

	yy_do_action_167 is
			--|#line 1160 "eiffel.y"
		local
			yyval114: FORMAL_ARGU_DEC_LIST_AS
		do
--|#line 1160 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1160")
end

yyval114 := ast_factory.new_formal_argu_dec_list_as (yyvs112.item (yyvsp112), yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp114 := yyvsp114 + 1
	yyvsp4 := yyvsp4 -2
	yyvsp1 := yyvsp1 -2
	yyvsp112 := yyvsp112 -1
	if yyvsp114 >= yyvsc114 then
		if yyvs114 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs114")
			end
			create yyspecial_routines114
			yyvsc114 := yyInitial_yyvs_size
			yyvs114 := yyspecial_routines114.make (yyvsc114)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs114")
			end
			yyvsc114 := yyvsc114 + yyInitial_yyvs_size
			yyvs114 := yyspecial_routines114.resize (yyvs114, yyvsc114)
		end
	end
	yyvs114.put (yyval114, yyvsp114)
end
		end

	yy_do_action_168 is
			--|#line 1162 "eiffel.y"
		local
			yyval114: FORMAL_ARGU_DEC_LIST_AS
		do
--|#line 1162 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1162")
end

report_expected_match_error (parser_errors.open_paran_symbol, yyvs4.item (yyvsp4), parser_errors.close_paran_symbol, Void, False) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp114 := yyvsp114 + 1
	yyvsp4 := yyvsp4 -1
	yyvsp1 := yyvsp1 -3
	yyvsp112 := yyvsp112 -1
	if yyvsp114 >= yyvsc114 then
		if yyvs114 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs114")
			end
			create yyspecial_routines114
			yyvsc114 := yyInitial_yyvs_size
			yyvs114 := yyspecial_routines114.make (yyvsc114)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs114")
			end
			yyvsc114 := yyvsc114 + yyInitial_yyvs_size
			yyvs114 := yyspecial_routines114.resize (yyvs114, yyvsc114)
		end
	end
	yyvs114.put (yyval114, yyvsp114)
end
		end

	yy_do_action_169 is
			--|#line 1164 "eiffel.y"
		local
			yyval114: FORMAL_ARGU_DEC_LIST_AS
		do
--|#line 1164 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1164")
end

report_expected_after_error (parser_errors.open_paran_symbol, yyvs4.item (yyvsp4), parser_errors.a_formal_argument, True) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp114 := yyvsp114 + 1
	yyvsp4 := yyvsp4 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp114 >= yyvsc114 then
		if yyvs114 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs114")
			end
			create yyspecial_routines114
			yyvsc114 := yyInitial_yyvs_size
			yyvs114 := yyspecial_routines114.make (yyvsc114)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs114")
			end
			yyvsc114 := yyvsc114 + yyInitial_yyvs_size
			yyvs114 := yyspecial_routines114.resize (yyvs114, yyvsc114)
		end
	end
	yyvs114.put (yyval114, yyvsp114)
end
		end

	yy_do_action_170 is
			--|#line 1168 "eiffel.y"
		local
			yyval112: TYPE_DEC_LIST_AS
		do
--|#line 1168 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1168")
end

				yyval112 := ast_factory.new_eiffel_list_type_dec_as (counter_value + 1)
				if yyval112 /= Void and yyvs81.item (yyvsp81) /= Void then
					yyval112.reverse_extend (yyvs81.item (yyvsp81))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp112 := yyvsp112 + 1
	yyvsp81 := yyvsp81 -1
	if yyvsp112 >= yyvsc112 then
		if yyvs112 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs112")
			end
			create yyspecial_routines112
			yyvsc112 := yyInitial_yyvs_size
			yyvs112 := yyspecial_routines112.make (yyvsc112)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs112")
			end
			yyvsc112 := yyvsc112 + yyInitial_yyvs_size
			yyvs112 := yyspecial_routines112.resize (yyvs112, yyvsc112)
		end
	end
	yyvs112.put (yyval112, yyvsp112)
end
		end

	yy_do_action_171 is
			--|#line 1175 "eiffel.y"
		local
			yyval112: TYPE_DEC_LIST_AS
		do
--|#line 1175 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1175")
end

				yyval112 := yyvs112.item (yyvsp112)
				if yyval112 /= Void and yyvs81.item (yyvsp81) /= Void and counter_value > 0 then
					yyval112.reverse_extend (yyvs81.item (yyvsp81))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp112 := yyvsp112 -1
	yyvsp81 := yyvsp81 -1
	yyvs112.put (yyval112, yyvsp112)
end
		end

	yy_do_action_172 is
			--|#line 1175 "eiffel.y"
		local
			yyval112: TYPE_DEC_LIST_AS
		do
--|#line 1175 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1175")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp112 := yyvsp112 + 1
	if yyvsp112 >= yyvsc112 then
		if yyvs112 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs112")
			end
			create yyspecial_routines112
			yyvsc112 := yyInitial_yyvs_size
			yyvs112 := yyspecial_routines112.make (yyvsc112)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs112")
			end
			yyvsc112 := yyvsc112 + yyInitial_yyvs_size
			yyvs112 := yyspecial_routines112.resize (yyvs112, yyvsc112)
		end
	end
	yyvs112.put (yyval112, yyvsp112)
end
		end

	yy_do_action_173 is
			--|#line 1182 "eiffel.y"
		local
			yyval112: TYPE_DEC_LIST_AS
		do
--|#line 1182 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1182")
end

report_unexpected_error (text, Void, True) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp112 := yyvsp112 + 1
	yyvsp81 := yyvsp81 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp112 >= yyvsc112 then
		if yyvs112 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs112")
			end
			create yyspecial_routines112
			yyvsc112 := yyInitial_yyvs_size
			yyvs112 := yyspecial_routines112.make (yyvsc112)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs112")
			end
			yyvsc112 := yyvsc112 + yyInitial_yyvs_size
			yyvs112 := yyspecial_routines112.resize (yyvs112, yyvsc112)
		end
	end
	yyvs112.put (yyval112, yyvsp112)
end
		end

	yy_do_action_174 is
			--|#line 1186 "eiffel.y"
		local
			yyval81: TYPE_DEC_AS
		do
--|#line 1186 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1186")
end

yyval81 := ast_factory.new_type_dec_as (yyvs20.item (yyvsp20), yyvs79.item (yyvsp79), yyvs4.item (yyvsp4 - 1)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp81 := yyvsp81 + 1
	yyvsp20 := yyvsp20 -1
	yyvsp4 := yyvsp4 -2
	yyvsp79 := yyvsp79 -1
	if yyvsp81 >= yyvsc81 then
		if yyvs81 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs81")
			end
			create yyspecial_routines81
			yyvsc81 := yyInitial_yyvs_size
			yyvs81 := yyspecial_routines81.make (yyvsc81)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs81")
			end
			yyvsc81 := yyvsc81 + yyInitial_yyvs_size
			yyvs81 := yyspecial_routines81.resize (yyvs81, yyvsc81)
		end
	end
	yyvs81.put (yyval81, yyvsp81)
end
		end

	yy_do_action_175 is
			--|#line 1189 "eiffel.y"
		local
			yyval81: TYPE_DEC_AS
		do
--|#line 1189 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1189")
end

report_expected_after_error (parser_errors.colon_symbol, yyvs4.item (yyvsp4 - 1), parser_errors.a_class_name, False) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp81 := yyvsp81 + 1
	yyvsp20 := yyvsp20 -1
	yyvsp4 := yyvsp4 -2
	yyvsp1 := yyvsp1 -1
	if yyvsp81 >= yyvsc81 then
		if yyvs81 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs81")
			end
			create yyspecial_routines81
			yyvsc81 := yyInitial_yyvs_size
			yyvs81 := yyspecial_routines81.make (yyvsc81)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs81")
			end
			yyvsc81 := yyvsc81 + yyInitial_yyvs_size
			yyvs81 := yyspecial_routines81.resize (yyvs81, yyvsc81)
		end
	end
	yyvs81.put (yyval81, yyvsp81)
end
		end

	yy_do_action_176 is
			--|#line 1191 "eiffel.y"
		local
			yyval81: TYPE_DEC_AS
		do
--|#line 1191 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1191")
end

report_expected_before_error (parser_errors.a_class_name, yyvs79.item (yyvsp79), parser_errors.colon_symbol, False)
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp81 := yyvsp81 + 1
	yyvsp20 := yyvsp20 -1
	yyvsp79 := yyvsp79 -1
	yyvsp4 := yyvsp4 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp81 >= yyvsc81 then
		if yyvs81 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs81")
			end
			create yyspecial_routines81
			yyvsc81 := yyInitial_yyvs_size
			yyvs81 := yyspecial_routines81.make (yyvsc81)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs81")
			end
			yyvsc81 := yyvsc81 + yyInitial_yyvs_size
			yyvs81 := yyspecial_routines81.resize (yyvs81, yyvsc81)
		end
	end
	yyvs81.put (yyval81, yyvsp81)
end
		end

	yy_do_action_177 is
			--|#line 1193 "eiffel.y"
		local
			yyval81: TYPE_DEC_AS
		do
--|#line 1193 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1193")
end

report_expected_after_error (parser_errors.formal_argument_declaration, last_id_as_value, parser_errors.colon_symbol, True) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp81 := yyvsp81 + 1
	yyvsp20 := yyvsp20 -1
	yyvsp4 := yyvsp4 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp81 >= yyvsc81 then
		if yyvs81 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs81")
			end
			create yyspecial_routines81
			yyvsc81 := yyInitial_yyvs_size
			yyvs81 := yyspecial_routines81.make (yyvsc81)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs81")
			end
			yyvsc81 := yyvsc81 + yyInitial_yyvs_size
			yyvs81 := yyspecial_routines81.resize (yyvs81, yyvsc81)
		end
	end
	yyvs81.put (yyval81, yyvsp81)
end
		end

	yy_do_action_178 is
			--|#line 1197 "eiffel.y"
		local
			yyval20: IDENTIFIER_LIST
		do
--|#line 1197 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1197")
end

yyval20 := yyvs20.item (yyvsp20) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs20.put (yyval20, yyvsp20)
end
		end

	yy_do_action_179 is
			--|#line 1200 "eiffel.y"
		local
			yyval20: IDENTIFIER_LIST
		do
--|#line 1200 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1200")
end

				report_unexpected_error (text, Void, True) 
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp1 := yyvsp1 -3
	yyvs20.put (yyval20, yyvsp20)
end
		end

	yy_do_action_180 is
			--|#line 1206 "eiffel.y"
		local
			yyval20: IDENTIFIER_LIST
		do
--|#line 1206 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1206")
end

				yyval20 := ast_factory.new_identifier_list (counter_value + 1)
				if yyval20 /= Void and yyvs2.item (yyvsp2) /= Void then
					Names_heap.put (yyvs2.item (yyvsp2))
					yyval20.reverse_extend (Names_heap.found_item)
					ast_factory.reverse_extend_identifier (yyval20.id_list, yyvs2.item (yyvsp2))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp20 := yyvsp20 + 1
	yyvsp2 := yyvsp2 -1
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
		end

	yy_do_action_181 is
			--|#line 1215 "eiffel.y"
		local
			yyval20: IDENTIFIER_LIST
		do
--|#line 1215 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1215")
end

				yyval20 := yyvs20.item (yyvsp20 - 1)
				if yyval20 /= Void and yyvs2.item (yyvsp2) /= Void and counter_value > 0 then
					Names_heap.put (yyvs2.item (yyvsp2))
					yyval20.reverse_extend (Names_heap.found_item)
					ast_factory.reverse_extend_identifier (yyval20.id_list, yyvs2.item (yyvsp2))
					ast_factory.reverse_extend_separator (yyval20.id_list, last_symbol_as_value)
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp20 := yyvsp20 -1
	yyvsp2 := yyvsp2 -1
	yyvs20.put (yyval20, yyvsp20)
end
		end

	yy_do_action_182 is
			--|#line 1215 "eiffel.y"
		local
			yyval20: IDENTIFIER_LIST
		do
--|#line 1215 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1215")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp20 := yyvsp20 + 1
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
		end

	yy_do_action_183 is
			--|#line 1225 "eiffel.y"
		local
			yyval20: IDENTIFIER_LIST
		do
--|#line 1225 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1225")
end

report_expected_after_error (parser_errors.comma_symbol, last_symbol_as_value, parser_errors.an_identifier, False) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp20 := yyvsp20 + 1
	yyvsp2 := yyvsp2 -1
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
		end

	yy_do_action_184 is
			--|#line 1229 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 1229 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1229")
end

				increment_counter
				yyval2 := yyvs2.item (yyvsp2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs2.put (yyval2, yyvsp2)
end
		end

	yy_do_action_185 is
			--|#line 1236 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 1236 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1236")
end


if yy_parsing_status = yyContinue then
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
		end

	yy_do_action_186 is
			--|#line 1237 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 1237 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1237")
end

report_expected_after_error (parser_errors.comma_symbol, yyvs4.item (yyvsp4), parser_errors.an_identifier, False) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp4 := yyvsp4 -1
	yyvs1.put (yyval1, yyvsp1)
end
		end

	yy_do_action_187 is
			--|#line 1241 "eiffel.y"
		local
			yyval20: IDENTIFIER_LIST
		do
--|#line 1241 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1241")
end

yyval20 := ast_factory.new_identifier_list (0) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp20 := yyvsp20 + 1
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
		end

	yy_do_action_188 is
			--|#line 1243 "eiffel.y"
		local
			yyval20: IDENTIFIER_LIST
		do
--|#line 1243 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1243")
end

yyval20 := yyvs20.item (yyvsp20) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs20.put (yyval20, yyvsp20)
end
		end

	yy_do_action_189 is
			--|#line 1247 "eiffel.y"
		local
			yyval74: ROUTINE_AS
		do
--|#line 1247 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1247")
end

				if yyvs19.item (yyvsp19) /= Void then
					temp_string_as1 := yyvs19.item (yyvsp19).second
					temp_keyword_as := yyvs19.item (yyvsp19).first
				else
					temp_string_as1 := Void
					temp_keyword_as := Void
				end
				if yyvs16.item (yyvsp16) /= Void then
					yyval74 := ast_factory.new_routine_as (temp_string_as1, yyvs71.item (yyvsp71), yyvs113.item (yyvsp113), yyvs73.item (yyvsp73), yyvs46.item (yyvsp46), yyvs16.item (yyvsp16).second, yyvs12.item (yyvsp12), once_manifest_string_count, fbody_pos, temp_keyword_as, yyvs16.item (yyvsp16).first)
				else
					yyval74 := ast_factory.new_routine_as (temp_string_as1, yyvs71.item (yyvsp71), yyvs113.item (yyvsp113), yyvs73.item (yyvsp73), yyvs46.item (yyvsp46), Void, yyvs12.item (yyvsp12), once_manifest_string_count, fbody_pos, temp_keyword_as, Void)					
				end
				once_manifest_string_count := 0
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 8
	yyvsp19 := yyvsp19 -1
	yyvsp71 := yyvsp71 -1
	yyvsp113 := yyvsp113 -1
	yyvsp73 := yyvsp73 -1
	yyvsp46 := yyvsp46 -1
	yyvsp16 := yyvsp16 -1
	yyvsp12 := yyvsp12 -1
	yyvs74.put (yyval74, yyvsp74)
end
		end

	yy_do_action_190 is
			--|#line 1247 "eiffel.y"
		local
			yyval74: ROUTINE_AS
		do
--|#line 1247 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1247")
end

fbody_pos := position 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp74 := yyvsp74 + 1
	if yyvsp74 >= yyvsc74 then
		if yyvs74 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs74")
			end
			create yyspecial_routines74
			yyvsc74 := yyInitial_yyvs_size
			yyvs74 := yyspecial_routines74.make (yyvsc74)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs74")
			end
			yyvsc74 := yyvsc74 + yyInitial_yyvs_size
			yyvs74 := yyspecial_routines74.resize (yyvs74, yyvsc74)
		end
	end
	yyvs74.put (yyval74, yyvsp74)
end
		end

	yy_do_action_191 is
			--|#line 1273 "eiffel.y"
		local
			yyval73: ROUT_BODY_AS
		do
--|#line 1273 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1273")
end

yyval73 := yyvs60.item (yyvsp60) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp73 := yyvsp73 + 1
	yyvsp60 := yyvsp60 -1
	if yyvsp73 >= yyvsc73 then
		if yyvs73 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs73")
			end
			create yyspecial_routines73
			yyvsc73 := yyInitial_yyvs_size
			yyvs73 := yyspecial_routines73.make (yyvsc73)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs73")
			end
			yyvsc73 := yyvsc73 + yyInitial_yyvs_size
			yyvs73 := yyspecial_routines73.resize (yyvs73, yyvsc73)
		end
	end
	yyvs73.put (yyval73, yyvsp73)
end
		end

	yy_do_action_192 is
			--|#line 1275 "eiffel.y"
		local
			yyval73: ROUT_BODY_AS
		do
--|#line 1275 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1275")
end

yyval73 := yyvs49.item (yyvsp49) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp73 := yyvsp73 + 1
	yyvsp49 := yyvsp49 -1
	if yyvsp73 >= yyvsc73 then
		if yyvs73 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs73")
			end
			create yyspecial_routines73
			yyvsc73 := yyInitial_yyvs_size
			yyvs73 := yyspecial_routines73.make (yyvsc73)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs73")
			end
			yyvsc73 := yyvsc73 + yyInitial_yyvs_size
			yyvs73 := yyspecial_routines73.resize (yyvs73, yyvsc73)
		end
	end
	yyvs73.put (yyval73, yyvsp73)
end
		end

	yy_do_action_193 is
			--|#line 1277 "eiffel.y"
		local
			yyval73: ROUT_BODY_AS
		do
--|#line 1277 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1277")
end

yyval73 := yyvs10.item (yyvsp10) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp73 := yyvsp73 + 1
	yyvsp10 := yyvsp10 -1
	if yyvsp73 >= yyvsc73 then
		if yyvs73 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs73")
			end
			create yyspecial_routines73
			yyvsc73 := yyInitial_yyvs_size
			yyvs73 := yyspecial_routines73.make (yyvsc73)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs73")
			end
			yyvsc73 := yyvsc73 + yyInitial_yyvs_size
			yyvs73 := yyspecial_routines73.resize (yyvs73, yyvsc73)
		end
	end
	yyvs73.put (yyval73, yyvsp73)
end
		end

	yy_do_action_194 is
			--|#line 1281 "eiffel.y"
		local
			yyval49: EXTERNAL_AS
		do
--|#line 1281 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1281")
end

				if yyvs19.item (yyvsp19) /= Void then
					yyval49 := ast_factory.new_external_as (yyvs50.item (yyvsp50), yyvs19.item (yyvsp19).second, yyvs12.item (yyvsp12), yyvs19.item (yyvsp19).first)
				else
					yyval49 := ast_factory.new_external_as (yyvs50.item (yyvsp50), Void, yyvs12.item (yyvsp12), Void)
				end
				has_externals := True
				set_has_old_verbatim_strings_warning (initial_has_old_verbatim_strings_warning)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp12 := yyvsp12 -1
	yyvsp50 := yyvsp50 -1
	yyvsp19 := yyvsp19 -1
	yyvs49.put (yyval49, yyvsp49)
end
		end

	yy_do_action_195 is
			--|#line 1281 "eiffel.y"
		local
			yyval49: EXTERNAL_AS
		do
--|#line 1281 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1281")
end

					-- To avoid warnings for manifest string used to represent external data.
				initial_has_old_verbatim_strings_warning := has_old_verbatim_strings_warning
				set_has_old_verbatim_strings_warning (false)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp49 := yyvsp49 + 1
	if yyvsp49 >= yyvsc49 then
		if yyvs49 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs49")
			end
			create yyspecial_routines49
			yyvsc49 := yyInitial_yyvs_size
			yyvs49 := yyspecial_routines49.make (yyvsc49)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs49")
			end
			yyvsc49 := yyvsc49 + yyInitial_yyvs_size
			yyvs49 := yyspecial_routines49.resize (yyvs49, yyvsc49)
		end
	end
	yyvs49.put (yyval49, yyvsp49)
end
		end

	yy_do_action_196 is
			--|#line 1299 "eiffel.y"
		local
			yyval50: EXTERNAL_LANG_AS
		do
--|#line 1299 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1299")
end

yyval50 := ast_factory.new_external_lang_as (yyvs18.item (yyvsp18)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp50 := yyvsp50 + 1
	yyvsp18 := yyvsp18 -1
	if yyvsp50 >= yyvsc50 then
		if yyvs50 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs50")
			end
			create yyspecial_routines50
			yyvsc50 := yyInitial_yyvs_size
			yyvs50 := yyspecial_routines50.make (yyvsc50)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs50")
			end
			yyvsc50 := yyvsc50 + yyInitial_yyvs_size
			yyvs50 := yyspecial_routines50.resize (yyvs50, yyvsc50)
		end
	end
	yyvs50.put (yyval50, yyvsp50)
end
		end

	yy_do_action_197 is
			--|#line 1304 "eiffel.y"
		local
			yyval19: PAIR [KEYWORD_AS, STRING_AS]
		do
--|#line 1304 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1304")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp19 := yyvsp19 + 1
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
		end

	yy_do_action_198 is
			--|#line 1306 "eiffel.y"
		local
			yyval19: PAIR [KEYWORD_AS, STRING_AS]
		do
--|#line 1306 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1306")
end

				yyval19 := ast_factory.new_keyword_string_pair (yyvs12.item (yyvsp12), yyvs18.item (yyvsp18))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp19 := yyvsp19 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp18 := yyvsp18 -1
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
		end

	yy_do_action_199 is
			--|#line 1312 "eiffel.y"
		local
			yyval60: INTERNAL_AS
		do
--|#line 1312 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1312")
end

yyval60 := ast_factory.new_do_as (yyvs15.item (yyvsp15), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp60 := yyvsp60 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp15 := yyvsp15 -1
	if yyvsp60 >= yyvsc60 then
		if yyvs60 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs60")
			end
			create yyspecial_routines60
			yyvsc60 := yyInitial_yyvs_size
			yyvs60 := yyspecial_routines60.make (yyvsc60)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs60")
			end
			yyvsc60 := yyvsc60 + yyInitial_yyvs_size
			yyvs60 := yyspecial_routines60.resize (yyvs60, yyvsc60)
		end
	end
	yyvs60.put (yyval60, yyvsp60)
end
		end

	yy_do_action_200 is
			--|#line 1314 "eiffel.y"
		local
			yyval60: INTERNAL_AS
		do
--|#line 1314 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1314")
end

yyval60 := ast_factory.new_once_as (yyvs15.item (yyvsp15), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp60 := yyvsp60 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp15 := yyvsp15 -1
	if yyvsp60 >= yyvsc60 then
		if yyvs60 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs60")
			end
			create yyspecial_routines60
			yyvsc60 := yyInitial_yyvs_size
			yyvs60 := yyspecial_routines60.make (yyvsc60)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs60")
			end
			yyvsc60 := yyvsc60 + yyInitial_yyvs_size
			yyvs60 := yyspecial_routines60.resize (yyvs60, yyvsc60)
		end
	end
	yyvs60.put (yyval60, yyvsp60)
end
		end

	yy_do_action_201 is
			--|#line 1318 "eiffel.y"
		local
			yyval113: LOCAL_DEC_LIST_AS
		do
--|#line 1318 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1318")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp113 := yyvsp113 + 1
	if yyvsp113 >= yyvsc113 then
		if yyvs113 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs113")
			end
			create yyspecial_routines113
			yyvsc113 := yyInitial_yyvs_size
			yyvs113 := yyspecial_routines113.make (yyvsc113)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs113")
			end
			yyvsc113 := yyvsc113 + yyInitial_yyvs_size
			yyvs113 := yyspecial_routines113.resize (yyvs113, yyvsc113)
		end
	end
	yyvs113.put (yyval113, yyvsp113)
end
		end

	yy_do_action_202 is
			--|#line 1320 "eiffel.y"
		local
			yyval113: LOCAL_DEC_LIST_AS
		do
--|#line 1320 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1320")
end

yyval113 := ast_factory.new_local_dec_list_as (ast_factory.new_eiffel_list_type_dec_as (0), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp113 := yyvsp113 + 1
	yyvsp12 := yyvsp12 -1
	if yyvsp113 >= yyvsc113 then
		if yyvs113 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs113")
			end
			create yyspecial_routines113
			yyvsc113 := yyInitial_yyvs_size
			yyvs113 := yyspecial_routines113.make (yyvsc113)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs113")
			end
			yyvsc113 := yyvsc113 + yyInitial_yyvs_size
			yyvs113 := yyspecial_routines113.resize (yyvs113, yyvsc113)
		end
	end
	yyvs113.put (yyval113, yyvsp113)
end
		end

	yy_do_action_203 is
			--|#line 1322 "eiffel.y"
		local
			yyval113: LOCAL_DEC_LIST_AS
		do
--|#line 1322 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1322")
end

yyval113 := ast_factory.new_local_dec_list_as (yyvs112.item (yyvsp112), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp113 := yyvsp113 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp1 := yyvsp1 -2
	yyvsp112 := yyvsp112 -1
	if yyvsp113 >= yyvsc113 then
		if yyvs113 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs113")
			end
			create yyspecial_routines113
			yyvsc113 := yyInitial_yyvs_size
			yyvs113 := yyspecial_routines113.make (yyvsc113)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs113")
			end
			yyvsc113 := yyvsc113 + yyInitial_yyvs_size
			yyvs113 := yyspecial_routines113.resize (yyvs113, yyvsc113)
		end
	end
	yyvs113.put (yyval113, yyvsp113)
end
		end

	yy_do_action_204 is
			--|#line 1326 "eiffel.y"
		local
			yyval15: EIFFEL_LIST [INSTRUCTION_AS]
		do
--|#line 1326 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1326")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp15 := yyvsp15 + 1
	yyvsp1 := yyvsp1 -1
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
		end

	yy_do_action_205 is
			--|#line 1328 "eiffel.y"
		local
			yyval15: EIFFEL_LIST [INSTRUCTION_AS]
		do
--|#line 1328 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1328")
end

yyval15 := yyvs15.item (yyvsp15) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp1 := yyvsp1 -3
	yyvs15.put (yyval15, yyvsp15)
end
		end

	yy_do_action_206 is
			--|#line 1332 "eiffel.y"
		local
			yyval15: EIFFEL_LIST [INSTRUCTION_AS]
		do
--|#line 1332 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1332")
end

				yyval15 := ast_factory.new_eiffel_list_instruction_as (counter_value + 1)
				if yyval15 /= Void and yyvs14.item (yyvsp14) /= Void then
					yyval15.reverse_extend (yyvs14.item (yyvsp14))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp15 := yyvsp15 + 1
	yyvsp14 := yyvsp14 -1
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
		end

	yy_do_action_207 is
			--|#line 1339 "eiffel.y"
		local
			yyval15: EIFFEL_LIST [INSTRUCTION_AS]
		do
--|#line 1339 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1339")
end

				yyval15 := yyvs15.item (yyvsp15)
				if yyval15 /= Void and yyvs14.item (yyvsp14) /= Void then
					yyval15.reverse_extend (yyvs14.item (yyvsp14))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp15 := yyvsp15 -1
	yyvsp14 := yyvsp14 -1
	yyvs15.put (yyval15, yyvsp15)
end
		end

	yy_do_action_208 is
			--|#line 1339 "eiffel.y"
		local
			yyval15: EIFFEL_LIST [INSTRUCTION_AS]
		do
--|#line 1339 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1339")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp15 := yyvsp15 + 1
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
		end

	yy_do_action_209 is
			--|#line 1348 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1348 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1348")
end

				yyval14 := yyvs14.item (yyvsp14) 
				if yyval14 /= Void then
					yyval14.set_line_pragma (last_line_pragma)
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs14.put (yyval14, yyvsp14)
end
		end

	yy_do_action_210 is
			--|#line 1357 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 1357 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1357")
end


if yy_parsing_status = yyContinue then
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
		end

	yy_do_action_211 is
			--|#line 1358 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 1358 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1358")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp4 := yyvsp4 -1
	yyvs1.put (yyval1, yyvsp1)
end
		end

	yy_do_action_212 is
			--|#line 1361 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1361 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1361")
end

yyval14 := yyvs42.item (yyvsp42) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp14 := yyvsp14 + 1
	yyvsp42 := yyvsp42 -1
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
		end

	yy_do_action_213 is
			--|#line 1363 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1363 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1363")
end

					-- Call production should be used instead,
					-- but this complicates the grammar.
				if has_type then
					error_handler.insert_error (create {SYNTAX_ERROR}.make (line, column, filename, "Expression cannot be used as an instruction", False))
					error_handler.raise_error
				else
					yyval14 := new_call_instruction_from_expression (yyvs48.item (yyvsp48))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp14 := yyvsp14 + 1
	yyvsp48 := yyvsp48 -1
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
		end

	yy_do_action_214 is
			--|#line 1374 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1374 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1374")
end

yyval14 := yyvs30.item (yyvsp30) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp14 := yyvsp14 + 1
	yyvsp30 := yyvsp30 -1
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
		end

	yy_do_action_215 is
			--|#line 1376 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1376 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1376")
end

yyval14 := yyvs29.item (yyvsp29) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp14 := yyvsp14 + 1
	yyvsp29 := yyvsp29 -1
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
		end

	yy_do_action_216 is
			--|#line 1378 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1378 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1378")
end

yyval14 := yyvs72.item (yyvsp72) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp14 := yyvsp14 + 1
	yyvsp72 := yyvsp72 -1
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
		end

	yy_do_action_217 is
			--|#line 1380 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1380 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1380")
end

yyval14 := yyvs56.item (yyvsp56) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp14 := yyvsp14 + 1
	yyvsp56 := yyvsp56 -1
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
		end

	yy_do_action_218 is
			--|#line 1382 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1382 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1382")
end

yyval14 := yyvs58.item (yyvsp58) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp14 := yyvsp14 + 1
	yyvsp58 := yyvsp58 -1
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
		end

	yy_do_action_219 is
			--|#line 1384 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1384 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1384")
end

yyval14 := yyvs63.item (yyvsp63) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp14 := yyvsp14 + 1
	yyvsp63 := yyvsp63 -1
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
		end

	yy_do_action_220 is
			--|#line 1386 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1386 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1386")
end

yyval14 := yyvs44.item (yyvsp44) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp14 := yyvsp14 + 1
	yyvsp44 := yyvsp44 -1
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
		end

	yy_do_action_221 is
			--|#line 1388 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1388 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1388")
end

yyval14 := yyvs37.item (yyvsp37) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp14 := yyvsp14 + 1
	yyvsp37 := yyvsp37 -1
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
		end

	yy_do_action_222 is
			--|#line 1390 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1390 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1390")
end

yyval14 := yyvs7.item (yyvsp7) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp14 := yyvsp14 + 1
	yyvsp7 := yyvsp7 -1
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
		end

	yy_do_action_223 is
			--|#line 1394 "eiffel.y"
		local
			yyval71: REQUIRE_AS
		do
--|#line 1394 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1394")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp71 := yyvsp71 + 1
	if yyvsp71 >= yyvsc71 then
		if yyvs71 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs71")
			end
			create yyspecial_routines71
			yyvsc71 := yyInitial_yyvs_size
			yyvs71 := yyspecial_routines71.make (yyvsc71)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs71")
			end
			yyvsc71 := yyvsc71 + yyInitial_yyvs_size
			yyvs71 := yyspecial_routines71.resize (yyvs71, yyvsc71)
		end
	end
	yyvs71.put (yyval71, yyvsp71)
end
		end

	yy_do_action_224 is
			--|#line 1396 "eiffel.y"
		local
			yyval71: REQUIRE_AS
		do
--|#line 1396 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1396")
end

				id_level := Normal_level
				yyval71 := ast_factory.new_require_as (yyvs22.item (yyvsp22), yyvs12.item (yyvsp12))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp12 := yyvsp12 -1
	yyvsp22 := yyvsp22 -1
	yyvs71.put (yyval71, yyvsp71)
end
		end

	yy_do_action_225 is
			--|#line 1396 "eiffel.y"
		local
			yyval71: REQUIRE_AS
		do
--|#line 1396 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1396")
end

id_level := Assert_level 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp71 := yyvsp71 + 1
	if yyvsp71 >= yyvsc71 then
		if yyvs71 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs71")
			end
			create yyspecial_routines71
			yyvsc71 := yyInitial_yyvs_size
			yyvs71 := yyspecial_routines71.make (yyvsc71)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs71")
			end
			yyvsc71 := yyvsc71 + yyInitial_yyvs_size
			yyvs71 := yyspecial_routines71.resize (yyvs71, yyvsc71)
		end
	end
	yyvs71.put (yyval71, yyvsp71)
end
		end

	yy_do_action_226 is
			--|#line 1403 "eiffel.y"
		local
			yyval71: REQUIRE_AS
		do
--|#line 1403 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1403")
end

				id_level := Normal_level
				yyval71 := ast_factory.new_require_else_as (yyvs22.item (yyvsp22), yyvs12.item (yyvsp12 - 1), yyvs12.item (yyvsp12))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp12 := yyvsp12 -2
	yyvsp22 := yyvsp22 -1
	yyvs71.put (yyval71, yyvsp71)
end
		end

	yy_do_action_227 is
			--|#line 1403 "eiffel.y"
		local
			yyval71: REQUIRE_AS
		do
--|#line 1403 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1403")
end

id_level := Assert_level 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp71 := yyvsp71 + 1
	if yyvsp71 >= yyvsc71 then
		if yyvs71 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs71")
			end
			create yyspecial_routines71
			yyvsc71 := yyInitial_yyvs_size
			yyvs71 := yyspecial_routines71.make (yyvsc71)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs71")
			end
			yyvsc71 := yyvsc71 + yyInitial_yyvs_size
			yyvs71 := yyspecial_routines71.resize (yyvs71, yyvsc71)
		end
	end
	yyvs71.put (yyval71, yyvsp71)
end
		end

	yy_do_action_228 is
			--|#line 1412 "eiffel.y"
		local
			yyval46: ENSURE_AS
		do
--|#line 1412 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1412")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp46 := yyvsp46 + 1
	if yyvsp46 >= yyvsc46 then
		if yyvs46 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs46")
			end
			create yyspecial_routines46
			yyvsc46 := yyInitial_yyvs_size
			yyvs46 := yyspecial_routines46.make (yyvsc46)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs46")
			end
			yyvsc46 := yyvsc46 + yyInitial_yyvs_size
			yyvs46 := yyspecial_routines46.resize (yyvs46, yyvsc46)
		end
	end
	yyvs46.put (yyval46, yyvsp46)
end
		end

	yy_do_action_229 is
			--|#line 1414 "eiffel.y"
		local
			yyval46: ENSURE_AS
		do
--|#line 1414 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1414")
end

				id_level := Normal_level
				yyval46 := ast_factory.new_ensure_as (yyvs22.item (yyvsp22), yyvs12.item (yyvsp12))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp12 := yyvsp12 -1
	yyvsp22 := yyvsp22 -1
	yyvs46.put (yyval46, yyvsp46)
end
		end

	yy_do_action_230 is
			--|#line 1414 "eiffel.y"
		local
			yyval46: ENSURE_AS
		do
--|#line 1414 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1414")
end

id_level := Assert_level 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp46 := yyvsp46 + 1
	if yyvsp46 >= yyvsc46 then
		if yyvs46 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs46")
			end
			create yyspecial_routines46
			yyvsc46 := yyInitial_yyvs_size
			yyvs46 := yyspecial_routines46.make (yyvsc46)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs46")
			end
			yyvsc46 := yyvsc46 + yyInitial_yyvs_size
			yyvs46 := yyspecial_routines46.resize (yyvs46, yyvsc46)
		end
	end
	yyvs46.put (yyval46, yyvsp46)
end
		end

	yy_do_action_231 is
			--|#line 1421 "eiffel.y"
		local
			yyval46: ENSURE_AS
		do
--|#line 1421 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1421")
end

				id_level := Normal_level
				yyval46 := ast_factory.new_ensure_then_as (yyvs22.item (yyvsp22), yyvs12.item (yyvsp12 - 1), yyvs12.item (yyvsp12))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp12 := yyvsp12 -2
	yyvsp22 := yyvsp22 -1
	yyvs46.put (yyval46, yyvsp46)
end
		end

	yy_do_action_232 is
			--|#line 1421 "eiffel.y"
		local
			yyval46: ENSURE_AS
		do
--|#line 1421 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1421")
end

id_level := Assert_level 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp46 := yyvsp46 + 1
	if yyvsp46 >= yyvsc46 then
		if yyvs46 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs46")
			end
			create yyspecial_routines46
			yyvsc46 := yyInitial_yyvs_size
			yyvs46 := yyspecial_routines46.make (yyvsc46)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs46")
			end
			yyvsc46 := yyvsc46 + yyInitial_yyvs_size
			yyvs46 := yyspecial_routines46.resize (yyvs46, yyvsc46)
		end
	end
	yyvs46.put (yyval46, yyvsp46)
end
		end

	yy_do_action_233 is
			--|#line 1430 "eiffel.y"
		local
			yyval22: EIFFEL_LIST [TAGGED_AS]
		do
--|#line 1430 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1430")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp22 := yyvsp22 + 1
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
		end

	yy_do_action_234 is
			--|#line 1432 "eiffel.y"
		local
			yyval22: EIFFEL_LIST [TAGGED_AS]
		do
--|#line 1432 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1432")
end

				yyval22 := yyvs22.item (yyvsp22)
				if yyval22 /= Void and then yyval22.is_empty then
					yyval22 := Void
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs22.put (yyval22, yyvsp22)
end
		end

	yy_do_action_235 is
			--|#line 1441 "eiffel.y"
		local
			yyval22: EIFFEL_LIST [TAGGED_AS]
		do
--|#line 1441 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1441")
end

					-- Special list treatment here as we do not want Void
					-- element in `Assertion_list'.
				if yyvs21.item (yyvsp21) /= Void then
					yyval22 := ast_factory.new_eiffel_list_tagged_as (counter_value + 1)
					if yyval22 /= Void then
						yyval22.reverse_extend (yyvs21.item (yyvsp21))
					end
				else
					yyval22 := ast_factory.new_eiffel_list_tagged_as (counter_value)
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp22 := yyvsp22 + 1
	yyvsp21 := yyvsp21 -1
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
		end

	yy_do_action_236 is
			--|#line 1454 "eiffel.y"
		local
			yyval22: EIFFEL_LIST [TAGGED_AS]
		do
--|#line 1454 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1454")
end

				yyval22 := yyvs22.item (yyvsp22)
				if yyval22 /= Void and yyvs21.item (yyvsp21) /= Void then
					yyval22.reverse_extend (yyvs21.item (yyvsp21))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp22 := yyvsp22 -1
	yyvsp21 := yyvsp21 -1
	yyvs22.put (yyval22, yyvsp22)
end
		end

	yy_do_action_237 is
			--|#line 1454 "eiffel.y"
		local
			yyval22: EIFFEL_LIST [TAGGED_AS]
		do
--|#line 1454 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1454")
end

					-- Only increment counter when clause is not Void.
				if yyvs21.item (yyvsp21) /= Void then
					increment_counter
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp22 := yyvsp22 + 1
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
		end

	yy_do_action_238 is
			--|#line 1470 "eiffel.y"
		local
			yyval21: TAGGED_AS
		do
--|#line 1470 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1470")
end

yyval21 := ast_factory.new_tagged_as (Void, yyvs48.item (yyvsp48), Void) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp21 := yyvsp21 + 1
	yyvsp48 := yyvsp48 -1
	yyvsp4 := yyvsp4 -1
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
		end

	yy_do_action_239 is
			--|#line 1472 "eiffel.y"
		local
			yyval21: TAGGED_AS
		do
--|#line 1472 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1472")
end

yyval21 := ast_factory.new_tagged_as (yyvs2.item (yyvsp2), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4 - 1)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp21 := yyvsp21 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp4 := yyvsp4 -2
	yyvsp48 := yyvsp48 -1
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
		end

	yy_do_action_240 is
			--|#line 1474 "eiffel.y"
		local
			yyval21: TAGGED_AS
		do
--|#line 1474 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1474")
end

			-- Always create an object here for roundtrip parser.
			-- This "fake" assertion will be filtered out later.
			yyval21 := ast_factory.new_tagged_as (yyvs2.item (yyvsp2), Void, yyvs4.item (yyvsp4 - 1))
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp21 := yyvsp21 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp4 := yyvsp4 -2
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
		end

	yy_do_action_241 is
			--|#line 1487 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1487 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1487")
end

yyval79 := yyvs79.item (yyvsp79) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_242 is
			--|#line 1489 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1489 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1489")
end

yyval79 := yyvs79.item (yyvsp79) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_243 is
			--|#line 1493 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1493 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1493")
end

yyval79 := new_class_type (yyvs2.item (yyvsp2), yyvs111.item (yyvsp111)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp79 := yyvsp79 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp111 := yyvsp111 -1
	if yyvsp79 >= yyvsc79 then
		if yyvs79 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs79")
			end
			create yyspecial_routines79
			yyvsc79 := yyInitial_yyvs_size
			yyvs79 := yyspecial_routines79.make (yyvsc79)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs79")
			end
			yyvsc79 := yyvsc79 + yyInitial_yyvs_size
			yyvs79 := yyspecial_routines79.resize (yyvs79, yyvsc79)
		end
	end
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_244 is
			--|#line 1496 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1496 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1496")
end

yyval79 := yyvs79.item (yyvsp79) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_245 is
			--|#line 1498 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1498 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1498")
end

yyval79 := yyvs79.item (yyvsp79) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_246 is
			--|#line 1502 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1502 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1502")
end

				yyval79 := yyvs79.item (yyvsp79)
				ast_factory.set_expanded_class_type (yyval79, True, yyvs12.item (yyvsp12))
				report_warning (parser_errors.declared_expanded_warning, yyvs12.item (yyvsp12))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp12 := yyvsp12 -1
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_247 is
			--|#line 1508 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1508 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1508")
end

				last_class_type ?= yyvs79.item (yyvsp79)
				if last_class_type /= Void then
					last_class_type.set_is_separate (True, yyvs12.item (yyvsp12))
					last_class_type := Void
				end
				yyval79 := yyvs79.item (yyvsp79)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp12 := yyvsp12 -1
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_248 is
			--|#line 1517 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1517 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1517")
end

yyval79 := ast_factory.new_bits_as (yyvs59.item (yyvsp59), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp79 := yyvsp79 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp59 := yyvsp59 -1
	if yyvsp79 >= yyvsc79 then
		if yyvs79 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs79")
			end
			create yyspecial_routines79
			yyvsc79 := yyInitial_yyvs_size
			yyvs79 := yyspecial_routines79.make (yyvsc79)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs79")
			end
			yyvsc79 := yyvsc79 + yyInitial_yyvs_size
			yyvs79 := yyspecial_routines79.resize (yyvs79, yyvsc79)
		end
	end
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_249 is
			--|#line 1519 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1519 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1519")
end

yyval79 := ast_factory.new_bits_symbol_as (yyvs2.item (yyvsp2), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp79 := yyvsp79 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp2 := yyvsp2 -1
	if yyvsp79 >= yyvsc79 then
		if yyvs79 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs79")
			end
			create yyspecial_routines79
			yyvsc79 := yyInitial_yyvs_size
			yyvs79 := yyspecial_routines79.make (yyvsc79)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs79")
			end
			yyvsc79 := yyvsc79 + yyInitial_yyvs_size
			yyvs79 := yyspecial_routines79.resize (yyvs79, yyvsc79)
		end
	end
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_250 is
			--|#line 1521 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1521 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1521")
end

yyval79 := ast_factory.new_like_id_as (yyvs2.item (yyvsp2), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp79 := yyvsp79 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp2 := yyvsp2 -1
	if yyvsp79 >= yyvsc79 then
		if yyvs79 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs79")
			end
			create yyspecial_routines79
			yyvsc79 := yyInitial_yyvs_size
			yyvs79 := yyspecial_routines79.make (yyvsc79)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs79")
			end
			yyvsc79 := yyvsc79 + yyInitial_yyvs_size
			yyvs79 := yyspecial_routines79.resize (yyvs79, yyvsc79)
		end
	end
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_251 is
			--|#line 1523 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1523 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1523")
end

yyval79 := ast_factory.new_like_current_as (yyvs9.item (yyvsp9), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp79 := yyvsp79 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp9 := yyvsp9 -1
	if yyvsp79 >= yyvsc79 then
		if yyvs79 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs79")
			end
			create yyspecial_routines79
			yyvsc79 := yyInitial_yyvs_size
			yyvs79 := yyspecial_routines79.make (yyvsc79)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs79")
			end
			yyvsc79 := yyvsc79 + yyInitial_yyvs_size
			yyvs79 := yyspecial_routines79.resize (yyvs79, yyvsc79)
		end
	end
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_252 is
			--|#line 1527 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1527 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1527")
end

yyval79 := yyvs79.item (yyvsp79) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_253 is
			--|#line 1529 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1529 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1529")
end

yyval79 := yyvs79.item (yyvsp79) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_254 is
			--|#line 1533 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1533 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1533")
end

yyval79 := new_class_type (yyvs2.item (yyvsp2), yyvs111.item (yyvsp111)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp79 := yyvsp79 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp111 := yyvsp111 -1
	if yyvsp79 >= yyvsc79 then
		if yyvs79 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs79")
			end
			create yyspecial_routines79
			yyvsc79 := yyInitial_yyvs_size
			yyvs79 := yyspecial_routines79.make (yyvsc79)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs79")
			end
			yyvsc79 := yyvsc79 + yyInitial_yyvs_size
			yyvs79 := yyspecial_routines79.resize (yyvs79, yyvsc79)
		end
	end
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_255 is
			--|#line 1537 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1537 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1537")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp111 := yyvsp111 + 1
	if yyvsp111 >= yyvsc111 then
		if yyvs111 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs111")
			end
			create yyspecial_routines111
			yyvsc111 := yyInitial_yyvs_size
			yyvs111 := yyspecial_routines111.make (yyvsc111)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs111")
			end
			yyvsc111 := yyvsc111 + yyInitial_yyvs_size
			yyvs111 := yyspecial_routines111.resize (yyvs111, yyvsc111)
		end
	end
	yyvs111.put (yyval111, yyvsp111)
end
		end

	yy_do_action_256 is
			--|#line 1539 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1539 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1539")
end

				yyval111 := yyvs111.item (yyvsp111)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs111.put (yyval111, yyvsp111)
end
		end

	yy_do_action_257 is
			--|#line 1545 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1545 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1545")
end

				yyval111 := yyvs111.item (yyvsp111)
				if yyval111 /= Void then
					yyval111.set_positions (yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp4 := yyvsp4 -2
	yyvs111.put (yyval111, yyvsp111)
end
		end

	yy_do_action_258 is
			--|#line 1552 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1552 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1552")
end

				yyval111 := ast_factory.new_eiffel_list_type (0)
				if yyval111 /= Void then
					yyval111.set_positions (yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4))
				end	
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp111 := yyvsp111 + 1
	yyvsp4 := yyvsp4 -2
	if yyvsp111 >= yyvsc111 then
		if yyvs111 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs111")
			end
			create yyspecial_routines111
			yyvsc111 := yyInitial_yyvs_size
			yyvs111 := yyspecial_routines111.make (yyvsc111)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs111")
			end
			yyvsc111 := yyvsc111 + yyInitial_yyvs_size
			yyvs111 := yyspecial_routines111.resize (yyvs111, yyvsc111)
		end
	end
	yyvs111.put (yyval111, yyvsp111)
end
		end

	yy_do_action_259 is
			--|#line 1561 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1561 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1561")
end

yyval111 := yyvs111.item (yyvsp111) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs111.put (yyval111, yyvsp111)
end
		end

	yy_do_action_260 is
			--|#line 1565 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1565 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1565")
end

				yyval111 := ast_factory.new_eiffel_list_type (counter_value + 1)
				if yyval111 /= Void and yyvs79.item (yyvsp79) /= Void then
					yyval111.reverse_extend (yyvs79.item (yyvsp79))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp111 := yyvsp111 + 1
	yyvsp79 := yyvsp79 -1
	if yyvsp111 >= yyvsc111 then
		if yyvs111 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs111")
			end
			create yyspecial_routines111
			yyvsc111 := yyInitial_yyvs_size
			yyvs111 := yyspecial_routines111.make (yyvsc111)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs111")
			end
			yyvsc111 := yyvsc111 + yyInitial_yyvs_size
			yyvs111 := yyspecial_routines111.resize (yyvs111, yyvsc111)
		end
	end
	yyvs111.put (yyval111, yyvsp111)
end
		end

	yy_do_action_261 is
			--|#line 1572 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1572 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1572")
end

				yyval111 := yyvs111.item (yyvsp111)
				if yyval111 /= Void and yyvs79.item (yyvsp79) /= Void then
					yyval111.reverse_extend (yyvs79.item (yyvsp79))
					ast_factory.reverse_extend_separator (yyval111, yyvs4.item (yyvsp4))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp111 := yyvsp111 -1
	yyvsp79 := yyvsp79 -1
	yyvsp4 := yyvsp4 -1
	yyvs111.put (yyval111, yyvsp111)
end
		end

	yy_do_action_262 is
			--|#line 1572 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1572 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1572")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp111 := yyvsp111 + 1
	if yyvsp111 >= yyvsc111 then
		if yyvs111 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs111")
			end
			create yyspecial_routines111
			yyvsc111 := yyInitial_yyvs_size
			yyvs111 := yyspecial_routines111.make (yyvsc111)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs111")
			end
			yyvsc111 := yyvsc111 + yyInitial_yyvs_size
			yyvs111 := yyspecial_routines111.resize (yyvs111, yyvsc111)
		end
	end
	yyvs111.put (yyval111, yyvsp111)
end
		end

	yy_do_action_263 is
			--|#line 1582 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1582 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1582")
end

yyval79 := ast_factory.new_class_type_as (yyvs2.item (yyvsp2), Void) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp79 := yyvsp79 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp79 >= yyvsc79 then
		if yyvs79 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs79")
			end
			create yyspecial_routines79
			yyvsc79 := yyInitial_yyvs_size
			yyvs79 := yyspecial_routines79.make (yyvsc79)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs79")
			end
			yyvsc79 := yyvsc79 + yyInitial_yyvs_size
			yyvs79 := yyspecial_routines79.resize (yyvs79, yyvsc79)
		end
	end
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_264 is
			--|#line 1584 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1584 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1584")
end

			  	last_type_list := ast_factory.new_eiffel_list_type (0)
				if last_type_list /= Void then
					last_type_list.set_positions (yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4))
				end
				yyval79 := ast_factory.new_class_type_as (yyvs2.item (yyvsp2), last_type_list)
				last_type_list := Void
				remove_counter
				remove_counter2
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp79 := yyvsp79 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -2
	yyvsp4 := yyvsp4 -2
	if yyvsp79 >= yyvsc79 then
		if yyvs79 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs79")
			end
			create yyspecial_routines79
			yyvsc79 := yyInitial_yyvs_size
			yyvs79 := yyspecial_routines79.make (yyvsc79)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs79")
			end
			yyvsc79 := yyvsc79 + yyInitial_yyvs_size
			yyvs79 := yyspecial_routines79.resize (yyvs79, yyvsc79)
		end
	end
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_265 is
			--|#line 1595 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1595 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1595")
end

				if yyvs111.item (yyvsp111) /= Void then
					yyvs111.item (yyvsp111).set_positions (yyvs4.item (yyvsp4), last_rsqure)
				end
				yyval79 := ast_factory.new_class_type_as (yyvs2.item (yyvsp2), yyvs111.item (yyvsp111))
				remove_counter
				remove_counter2
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp79 := yyvsp79 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -2
	yyvsp4 := yyvsp4 -1
	yyvsp111 := yyvsp111 -1
	if yyvsp79 >= yyvsc79 then
		if yyvs79 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs79")
			end
			create yyspecial_routines79
			yyvsc79 := yyInitial_yyvs_size
			yyvs79 := yyspecial_routines79.make (yyvsc79)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs79")
			end
			yyvsc79 := yyvsc79 + yyInitial_yyvs_size
			yyvs79 := yyspecial_routines79.resize (yyvs79, yyvsc79)
		end
	end
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_266 is
			--|#line 1604 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1604 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1604")
end

				if yyvs112.item (yyvsp112) /= Void then
					yyvs112.item (yyvsp112).set_positions (yyvs4.item (yyvsp4), last_rsqure)
				end
				yyval79 := ast_factory.new_named_tuple_type_as (yyvs2.item (yyvsp2), ast_factory.new_formal_argu_dec_list_as (yyvs112.item (yyvsp112), yyvs4.item (yyvsp4), Void))
				remove_counter
				remove_counter2
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp79 := yyvsp79 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp1 := yyvsp1 -2
	yyvsp4 := yyvsp4 -1
	yyvsp112 := yyvsp112 -1
	if yyvsp79 >= yyvsc79 then
		if yyvs79 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs79")
			end
			create yyspecial_routines79
			yyvsc79 := yyInitial_yyvs_size
			yyvs79 := yyspecial_routines79.make (yyvsc79)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs79")
			end
			yyvsc79 := yyvsc79 + yyInitial_yyvs_size
			yyvs79 := yyspecial_routines79.resize (yyvs79, yyvsc79)
		end
	end
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_267 is
			--|#line 1615 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1615 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1615")
end

				yyval111 := ast_factory.new_eiffel_list_type (counter_value + 1)
				if yyval111 /= Void and yyvs79.item (yyvsp79) /= Void then
					yyval111.reverse_extend (yyvs79.item (yyvsp79))
				end
				last_rsqure := yyvs4.item (yyvsp4)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp111 := yyvsp111 + 1
	yyvsp79 := yyvsp79 -1
	yyvsp4 := yyvsp4 -1
	if yyvsp111 >= yyvsc111 then
		if yyvs111 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs111")
			end
			create yyspecial_routines111
			yyvsc111 := yyInitial_yyvs_size
			yyvs111 := yyspecial_routines111.make (yyvsc111)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs111")
			end
			yyvsc111 := yyvsc111 + yyInitial_yyvs_size
			yyvs111 := yyspecial_routines111.resize (yyvs111, yyvsc111)
		end
	end
	yyvs111.put (yyval111, yyvsp111)
end
		end

	yy_do_action_268 is
			--|#line 1623 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1623 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1623")
end

				yyval111 := yyvs111.item (yyvsp111)
				if yyval111 /= Void and yyvs2.item (yyvsp2) /= Void then
					if not case_sensitive then
						yyvs2.item (yyvsp2).to_upper		
					end
					yyval111.reverse_extend (new_class_type (yyvs2.item (yyvsp2), Void))
					ast_factory.reverse_extend_separator (yyval111, yyvs4.item (yyvsp4))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp2 := yyvsp2 -1
	yyvsp4 := yyvsp4 -1
	yyvsp1 := yyvsp1 -1
	yyvs111.put (yyval111, yyvsp111)
end
		end

	yy_do_action_269 is
			--|#line 1634 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1634 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1634")
end

				yyval111 := yyvs111.item (yyvsp111)
				if yyval111 /= Void and yyvs79.item (yyvsp79) /= Void then
					yyval111.reverse_extend (yyvs79.item (yyvsp79))
					ast_factory.reverse_extend_separator (yyval111, yyvs4.item (yyvsp4))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp79 := yyvsp79 -1
	yyvsp4 := yyvsp4 -1
	yyvsp1 := yyvsp1 -1
	yyvs111.put (yyval111, yyvsp111)
end
		end

	yy_do_action_270 is
			--|#line 1644 "eiffel.y"
		local
			yyval112: TYPE_DEC_LIST_AS
		do
--|#line 1644 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1644")
end

				yyval112 := ast_factory.new_eiffel_list_type_dec_as (counter2_value + 1)
				last_identifier_list := ast_factory.new_identifier_list (counter_value + 1)
				
				if yyval112 /= Void and last_identifier_list /= Void and yyvs2.item (yyvsp2) /= Void then
					if not case_sensitive then
						yyvs2.item (yyvsp2).to_lower		
					end
					Names_heap.put (yyvs2.item (yyvsp2))
					last_identifier_list.reverse_extend (Names_heap.found_item)
					ast_factory.reverse_extend_identifier (last_identifier_list.id_list, yyvs2.item (yyvsp2))
				end
				yyval112.reverse_extend (ast_factory.new_type_dec_as (last_identifier_list, yyvs79.item (yyvsp79), yyvs4.item (yyvsp4 - 1)))
				last_identifier_list := Void     
				last_rsqure := yyvs4.item (yyvsp4)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp112 := yyvsp112 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp4 := yyvsp4 -2
	yyvsp79 := yyvsp79 -1
	if yyvsp112 >= yyvsc112 then
		if yyvs112 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs112")
			end
			create yyspecial_routines112
			yyvsc112 := yyInitial_yyvs_size
			yyvs112 := yyspecial_routines112.make (yyvsc112)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs112")
			end
			yyvsc112 := yyvsc112 + yyInitial_yyvs_size
			yyvs112 := yyspecial_routines112.resize (yyvs112, yyvsc112)
		end
	end
	yyvs112.put (yyval112, yyvsp112)
end
		end

	yy_do_action_271 is
			--|#line 1661 "eiffel.y"
		local
			yyval112: TYPE_DEC_LIST_AS
		do
--|#line 1661 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1661")
end

				yyval112 := yyvs112.item (yyvsp112)
				if yyval112 /= Void then
					last_identifier_list := yyval112.reversed_first.id_list
					if last_identifier_list /= Void then
						if not case_sensitive then
							yyvs2.item (yyvsp2).to_lower		
						end
						Names_heap.put (yyvs2.item (yyvsp2))
						last_identifier_list.reverse_extend (Names_heap.found_item)
						ast_factory.reverse_extend_identifier (last_identifier_list.id_list, yyvs2.item (yyvsp2))
						ast_factory.reverse_extend_separator (last_identifier_list.id_list, yyvs4.item (yyvsp4))
					end
					last_identifier_list := Void     
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp2 := yyvsp2 -1
	yyvsp4 := yyvsp4 -1
	yyvsp1 := yyvsp1 -1
	yyvs112.put (yyval112, yyvsp112)
end
		end

	yy_do_action_272 is
			--|#line 1678 "eiffel.y"
		local
			yyval112: TYPE_DEC_LIST_AS
		do
--|#line 1678 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1678")
end

				yyval112 := yyvs112.item (yyvsp112)
				last_identifier_list := ast_factory.new_identifier_list (counter_value + 1)
				
				if yyval112 /= Void and yyvs2.item (yyvsp2) /= Void and yyvs79.item (yyvsp79) /= Void and last_identifier_list /= Void then
					if not case_sensitive then
						yyvs2.item (yyvsp2).to_lower		
					end
					Names_heap.put (yyvs2.item (yyvsp2))
					last_identifier_list.reverse_extend (Names_heap.found_item)
					ast_factory.reverse_extend_identifier (last_identifier_list.id_list, yyvs2.item (yyvsp2))
					
					yyval112.reverse_extend (ast_factory.new_type_dec_as (last_identifier_list, yyvs79.item (yyvsp79), yyvs4.item (yyvsp4 - 1)))
				end
				last_identifier_list := Void
				remove_counter
				add_counter
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 6
	yyvsp2 := yyvsp2 -1
	yyvsp4 := yyvsp4 -2
	yyvsp79 := yyvsp79 -1
	yyvsp1 := yyvsp1 -1
	yyvs112.put (yyval112, yyvsp112)
end
		end

	yy_do_action_273 is
			--|#line 1702 "eiffel.y"
		local
			yyval100: FORMAL_GENERIC_LIST_AS
		do
--|#line 1702 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1702")
end

				-- $$ := Void
				formal_generics_end_position := 0
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp100 := yyvsp100 + 1
	if yyvsp100 >= yyvsc100 then
		if yyvs100 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs100")
			end
			create yyspecial_routines100
			yyvsc100 := yyInitial_yyvs_size
			yyvs100 := yyspecial_routines100.make (yyvsc100)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs100")
			end
			yyvsc100 := yyvsc100 + yyInitial_yyvs_size
			yyvs100 := yyspecial_routines100.resize (yyvs100, yyvsc100)
		end
	end
	yyvs100.put (yyval100, yyvsp100)
end
		end

	yy_do_action_274 is
			--|#line 1707 "eiffel.y"
		local
			yyval100: FORMAL_GENERIC_LIST_AS
		do
--|#line 1707 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1707")
end

				formal_generics_end_position := position
				--- $$ := Void
				yyval100 := ast_factory.new_eiffel_list_formal_dec_as (0)
				if yyval100 /= Void then
					yyval100.set_squre_symbols (yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp100 := yyvsp100 + 1
	yyvsp4 := yyvsp4 -2
	if yyvsp100 >= yyvsc100 then
		if yyvs100 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs100")
			end
			create yyspecial_routines100
			yyvsc100 := yyInitial_yyvs_size
			yyvs100 := yyspecial_routines100.make (yyvsc100)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs100")
			end
			yyvsc100 := yyvsc100 + yyInitial_yyvs_size
			yyvs100 := yyspecial_routines100.resize (yyvs100, yyvsc100)
		end
	end
	yyvs100.put (yyval100, yyvsp100)
end
		end

	yy_do_action_275 is
			--|#line 1716 "eiffel.y"
		local
			yyval100: FORMAL_GENERIC_LIST_AS
		do
--|#line 1716 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1716")
end

				formal_generics_end_position := position
				yyval100 := yyvs100.item (yyvsp100)
				if yyval100 /= Void then
					yyval100.set_squre_symbols (yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp4 := yyvsp4 -2
	yyvsp1 := yyvsp1 -2
	yyvs100.put (yyval100, yyvsp100)
end
		end

	yy_do_action_276 is
			--|#line 1726 "eiffel.y"
		local
			yyval100: FORMAL_GENERIC_LIST_AS
		do
--|#line 1726 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1726")
end

				yyval100 := ast_factory.new_eiffel_list_formal_dec_as (counter_value + 1)
				if yyval100 /= Void and yyvs55.item (yyvsp55) /= Void then
					yyval100.reverse_extend (yyvs55.item (yyvsp55))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp100 := yyvsp100 + 1
	yyvsp55 := yyvsp55 -1
	if yyvsp100 >= yyvsc100 then
		if yyvs100 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs100")
			end
			create yyspecial_routines100
			yyvsc100 := yyInitial_yyvs_size
			yyvs100 := yyspecial_routines100.make (yyvsc100)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs100")
			end
			yyvsc100 := yyvsc100 + yyInitial_yyvs_size
			yyvs100 := yyspecial_routines100.resize (yyvs100, yyvsc100)
		end
	end
	yyvs100.put (yyval100, yyvsp100)
end
		end

	yy_do_action_277 is
			--|#line 1733 "eiffel.y"
		local
			yyval100: FORMAL_GENERIC_LIST_AS
		do
--|#line 1733 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1733")
end

				yyval100 := yyvs100.item (yyvsp100)
				if yyval100 /= Void and yyvs55.item (yyvsp55) /= Void then
					yyval100.reverse_extend (yyvs55.item (yyvsp55))
					ast_factory.reverse_extend_separator (yyval100, yyvs4.item (yyvsp4))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp100 := yyvsp100 -1
	yyvsp55 := yyvsp55 -1
	yyvsp4 := yyvsp4 -1
	yyvs100.put (yyval100, yyvsp100)
end
		end

	yy_do_action_278 is
			--|#line 1733 "eiffel.y"
		local
			yyval100: FORMAL_GENERIC_LIST_AS
		do
--|#line 1733 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1733")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp100 := yyvsp100 + 1
	if yyvsp100 >= yyvsc100 then
		if yyvs100 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs100")
			end
			create yyspecial_routines100
			yyvsc100 := yyInitial_yyvs_size
			yyvs100 := yyspecial_routines100.make (yyvsc100)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs100")
			end
			yyvsc100 := yyvsc100 + yyInitial_yyvs_size
			yyvs100 := yyspecial_routines100.resize (yyvs100, yyvsc100)
		end
	end
	yyvs100.put (yyval100, yyvsp100)
end
		end

	yy_do_action_279 is
			--|#line 1743 "eiffel.y"
		local
			yyval54: FORMAL_AS
		do
--|#line 1743 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1743")
end

				if equal (None_classname, yyvs2.item (yyvsp2)) then
						-- Trigger an error when constraint is NONE.
						-- Needs to be done manually since current test for
						-- checking that `$2' is not a class name
						-- will fail for NONE, whereas before there were some
						-- syntactic conflict since `NONE' was a keyword and
						-- therefore not part of `TE_ID'.
					raise_error
				else
					yyval54 := ast_factory.new_formal_as (yyvs2.item (yyvsp2), True, False, yyvs12.item (yyvsp12))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp54 := yyvsp54 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp2 := yyvsp2 -1
	if yyvsp54 >= yyvsc54 then
		if yyvs54 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs54")
			end
			create yyspecial_routines54
			yyvsc54 := yyInitial_yyvs_size
			yyvs54 := yyspecial_routines54.make (yyvsc54)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs54")
			end
			yyvsc54 := yyvsc54 + yyInitial_yyvs_size
			yyvs54 := yyspecial_routines54.resize (yyvs54, yyvsc54)
		end
	end
	yyvs54.put (yyval54, yyvsp54)
end
		end

	yy_do_action_280 is
			--|#line 1757 "eiffel.y"
		local
			yyval54: FORMAL_AS
		do
--|#line 1757 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1757")
end

				if equal (None_classname, yyvs2.item (yyvsp2)) then
						-- Trigger an error when constraint is NONE.
						-- Needs to be done manually since current test for
						-- checking that `$2' is not a class name
						-- will fail for NONE, whereas before there were some
						-- syntactic conflict since `NONE' was a keyword and
						-- therefore not part of `TE_ID'.
					raise_error
				else
					yyval54 := ast_factory.new_formal_as (yyvs2.item (yyvsp2), False, True, yyvs12.item (yyvsp12))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp54 := yyvsp54 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp2 := yyvsp2 -1
	if yyvsp54 >= yyvsc54 then
		if yyvs54 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs54")
			end
			create yyspecial_routines54
			yyvsc54 := yyInitial_yyvs_size
			yyvs54 := yyspecial_routines54.make (yyvsc54)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs54")
			end
			yyvsc54 := yyvsc54 + yyInitial_yyvs_size
			yyvs54 := yyspecial_routines54.resize (yyvs54, yyvsc54)
		end
	end
	yyvs54.put (yyval54, yyvsp54)
end
		end

	yy_do_action_281 is
			--|#line 1772 "eiffel.y"
		local
			yyval54: FORMAL_AS
		do
--|#line 1772 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1772")
end

				if equal (None_classname, yyvs2.item (yyvsp2)) then
						-- Trigger an error when constraint is NONE.
						-- Needs to be done manually since current test for
						-- checking that `$1' is not a class name
						-- will fail for NONE, whereas before there were some
						-- syntactic conflict since `NONE' was a keyword and
						-- therefore not part of `TE_ID'.
					raise_error
				else
					yyval54 := ast_factory.new_formal_as (yyvs2.item (yyvsp2), False, False, Void)
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp54 := yyvsp54 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp54 >= yyvsc54 then
		if yyvs54 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs54")
			end
			create yyspecial_routines54
			yyvsc54 := yyInitial_yyvs_size
			yyvs54 := yyspecial_routines54.make (yyvsc54)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs54")
			end
			yyvsc54 := yyvsc54 + yyInitial_yyvs_size
			yyvs54 := yyspecial_routines54.resize (yyvs54, yyvsc54)
		end
	end
	yyvs54.put (yyval54, yyvsp54)
end
		end

	yy_do_action_282 is
			--|#line 1788 "eiffel.y"
		local
			yyval55: FORMAL_DEC_AS
		do
--|#line 1788 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1788")
end

				if yyvs115.item (yyvsp115) /= Void then
					if yyvs115.item (yyvsp115).creation_constrain /= Void then
						yyval55 := ast_factory.new_formal_dec_as (yyvs54.item (yyvsp54), yyvs115.item (yyvsp115).type, yyvs115.item (yyvsp115).creation_constrain.feature_list, yyvs115.item (yyvsp115).constrain_symbol, yyvs115.item (yyvsp115).creation_constrain.create_keyword, yyvs115.item (yyvsp115).creation_constrain.end_keyword)
					else
						yyval55 := ast_factory.new_formal_dec_as (yyvs54.item (yyvsp54), yyvs115.item (yyvsp115).type, Void, yyvs115.item (yyvsp115).constrain_symbol, Void, Void)				
					end					
				else
					yyval55 := ast_factory.new_formal_dec_as (yyvs54.item (yyvsp54), Void, Void, Void, Void, Void)
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp54 := yyvsp54 -1
	yyvsp115 := yyvsp115 -1
	yyvs55.put (yyval55, yyvsp55)
end
		end

	yy_do_action_283 is
			--|#line 1788 "eiffel.y"
		local
			yyval55: FORMAL_DEC_AS
		do
--|#line 1788 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1788")
end

				if yyvs54.item (yyvsp54) /= Void then
						-- Needs to be done here, in case current formal is used in
						-- Constraint.
					formal_parameters.extend (yyvs54.item (yyvsp54))
					yyvs54.item (yyvsp54).set_position (formal_parameters.count)
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp55 := yyvsp55 + 1
	if yyvsp55 >= yyvsc55 then
		if yyvs55 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs55")
			end
			create yyspecial_routines55
			yyvsc55 := yyInitial_yyvs_size
			yyvs55 := yyspecial_routines55.make (yyvsc55)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs55")
			end
			yyvsc55 := yyvsc55 + yyInitial_yyvs_size
			yyvs55 := yyspecial_routines55.resize (yyvs55, yyvsc55)
		end
	end
	yyvs55.put (yyval55, yyvsp55)
end
		end

	yy_do_action_284 is
			--|#line 1811 "eiffel.y"
		local
			yyval115: CONSTRAINT_TRIPLE
		do
--|#line 1811 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1811")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp115 := yyvsp115 + 1
	if yyvsp115 >= yyvsc115 then
		if yyvs115 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs115")
			end
			create yyspecial_routines115
			yyvsc115 := yyInitial_yyvs_size
			yyvs115 := yyspecial_routines115.make (yyvsc115)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs115")
			end
			yyvsc115 := yyvsc115 + yyInitial_yyvs_size
			yyvs115 := yyspecial_routines115.resize (yyvs115, yyvsc115)
		end
	end
	yyvs115.put (yyval115, yyvsp115)
end
		end

	yy_do_action_285 is
			--|#line 1813 "eiffel.y"
		local
			yyval115: CONSTRAINT_TRIPLE
		do
--|#line 1813 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1813")
end

				yyval115 := ast_factory.new_constraint_triple (yyvs4.item (yyvsp4), yyvs79.item (yyvsp79), yyvs96.item (yyvsp96))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp115 := yyvsp115 + 1
	yyvsp4 := yyvsp4 -1
	yyvsp79 := yyvsp79 -1
	yyvsp96 := yyvsp96 -1
	if yyvsp115 >= yyvsc115 then
		if yyvs115 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs115")
			end
			create yyspecial_routines115
			yyvsc115 := yyInitial_yyvs_size
			yyvs115 := yyspecial_routines115.make (yyvsc115)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs115")
			end
			yyvsc115 := yyvsc115 + yyInitial_yyvs_size
			yyvs115 := yyspecial_routines115.resize (yyvs115, yyvsc115)
		end
	end
	yyvs115.put (yyval115, yyvsp115)
end
		end

	yy_do_action_286 is
			--|#line 1819 "eiffel.y"
		local
			yyval96: CREATION_CONSTRAIN_TRIPLE
		do
--|#line 1819 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1819")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp96 := yyvsp96 + 1
	if yyvsp96 >= yyvsc96 then
		if yyvs96 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs96")
			end
			create yyspecial_routines96
			yyvsc96 := yyInitial_yyvs_size
			yyvs96 := yyspecial_routines96.make (yyvsc96)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs96")
			end
			yyvsc96 := yyvsc96 + yyInitial_yyvs_size
			yyvs96 := yyspecial_routines96.resize (yyvs96, yyvsc96)
		end
	end
	yyvs96.put (yyval96, yyvsp96)
end
		end

	yy_do_action_287 is
			--|#line 1821 "eiffel.y"
		local
			yyval96: CREATION_CONSTRAIN_TRIPLE
		do
--|#line 1821 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1821")
end

				yyval96 := ast_factory.new_creation_constrain_triple (yyvs95.item (yyvsp95), yyvs12.item (yyvsp12 - 1), yyvs12.item (yyvsp12))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp96 := yyvsp96 + 1
	yyvsp12 := yyvsp12 -2
	yyvsp95 := yyvsp95 -1
	if yyvsp96 >= yyvsc96 then
		if yyvs96 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs96")
			end
			create yyspecial_routines96
			yyvsc96 := yyInitial_yyvs_size
			yyvs96 := yyspecial_routines96.make (yyvsc96)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs96")
			end
			yyvsc96 := yyvsc96 + yyInitial_yyvs_size
			yyvs96 := yyspecial_routines96.resize (yyvs96, yyvsc96)
		end
	end
	yyvs96.put (yyval96, yyvsp96)
end
		end

	yy_do_action_288 is
			--|#line 1834 "eiffel.y"
		local
			yyval56: IF_AS
		do
--|#line 1834 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1834")
end

yyval56 := ast_factory.new_if_as (yyvs48.item (yyvsp48), yyvs15.item (yyvsp15), Void, Void, yyvs12.item (yyvsp12), yyvs12.item (yyvsp12 - 2), yyvs12.item (yyvsp12 - 1), Void) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp56 := yyvsp56 + 1
	yyvsp12 := yyvsp12 -3
	yyvsp48 := yyvsp48 -1
	yyvsp15 := yyvsp15 -1
	if yyvsp56 >= yyvsc56 then
		if yyvs56 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs56")
			end
			create yyspecial_routines56
			yyvsc56 := yyInitial_yyvs_size
			yyvs56 := yyspecial_routines56.make (yyvsc56)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs56")
			end
			yyvsc56 := yyvsc56 + yyInitial_yyvs_size
			yyvs56 := yyspecial_routines56.resize (yyvs56, yyvsc56)
		end
	end
	yyvs56.put (yyval56, yyvsp56)
end
		end

	yy_do_action_289 is
			--|#line 1837 "eiffel.y"
		local
			yyval56: IF_AS
		do
--|#line 1837 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1837")
end

				if yyvs16.item (yyvsp16) /= Void then
					yyval56 := ast_factory.new_if_as (yyvs48.item (yyvsp48), yyvs15.item (yyvsp15), Void, yyvs16.item (yyvsp16).second, yyvs12.item (yyvsp12), yyvs12.item (yyvsp12 - 2), yyvs12.item (yyvsp12 - 1), yyvs16.item (yyvsp16).first)
				else
					yyval56 := ast_factory.new_if_as (yyvs48.item (yyvsp48), yyvs15.item (yyvsp15), Void, Void, yyvs12.item (yyvsp12), yyvs12.item (yyvsp12 - 2), yyvs12.item (yyvsp12 - 1), Void)

				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 6
	yyvsp56 := yyvsp56 + 1
	yyvsp12 := yyvsp12 -3
	yyvsp48 := yyvsp48 -1
	yyvsp15 := yyvsp15 -1
	yyvsp16 := yyvsp16 -1
	if yyvsp56 >= yyvsc56 then
		if yyvs56 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs56")
			end
			create yyspecial_routines56
			yyvsc56 := yyInitial_yyvs_size
			yyvs56 := yyspecial_routines56.make (yyvsc56)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs56")
			end
			yyvsc56 := yyvsc56 + yyInitial_yyvs_size
			yyvs56 := yyspecial_routines56.resize (yyvs56, yyvsc56)
		end
	end
	yyvs56.put (yyval56, yyvsp56)
end
		end

	yy_do_action_290 is
			--|#line 1846 "eiffel.y"
		local
			yyval56: IF_AS
		do
--|#line 1846 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1846")
end

yyval56 := ast_factory.new_if_as (yyvs48.item (yyvsp48), yyvs15.item (yyvsp15), yyvs88.item (yyvsp88), Void, yyvs12.item (yyvsp12), yyvs12.item (yyvsp12 - 2), yyvs12.item (yyvsp12 - 1), Void) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 6
	yyvsp56 := yyvsp56 + 1
	yyvsp12 := yyvsp12 -3
	yyvsp48 := yyvsp48 -1
	yyvsp15 := yyvsp15 -1
	yyvsp88 := yyvsp88 -1
	if yyvsp56 >= yyvsc56 then
		if yyvs56 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs56")
			end
			create yyspecial_routines56
			yyvsc56 := yyInitial_yyvs_size
			yyvs56 := yyspecial_routines56.make (yyvsc56)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs56")
			end
			yyvsc56 := yyvsc56 + yyInitial_yyvs_size
			yyvs56 := yyspecial_routines56.resize (yyvs56, yyvsc56)
		end
	end
	yyvs56.put (yyval56, yyvsp56)
end
		end

	yy_do_action_291 is
			--|#line 1848 "eiffel.y"
		local
			yyval56: IF_AS
		do
--|#line 1848 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1848")
end

				if yyvs16.item (yyvsp16) /= Void then
					yyval56 := ast_factory.new_if_as (yyvs48.item (yyvsp48), yyvs15.item (yyvsp15), yyvs88.item (yyvsp88), yyvs16.item (yyvsp16).second, yyvs12.item (yyvsp12), yyvs12.item (yyvsp12 - 2), yyvs12.item (yyvsp12 - 1), yyvs16.item (yyvsp16).first)
				else
					yyval56 := ast_factory.new_if_as (yyvs48.item (yyvsp48), yyvs15.item (yyvsp15), yyvs88.item (yyvsp88), Void, yyvs12.item (yyvsp12), yyvs12.item (yyvsp12 - 2), yyvs12.item (yyvsp12 - 1), Void)
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 7
	yyvsp56 := yyvsp56 + 1
	yyvsp12 := yyvsp12 -3
	yyvsp48 := yyvsp48 -1
	yyvsp15 := yyvsp15 -1
	yyvsp88 := yyvsp88 -1
	yyvsp16 := yyvsp16 -1
	if yyvsp56 >= yyvsc56 then
		if yyvs56 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs56")
			end
			create yyspecial_routines56
			yyvsc56 := yyInitial_yyvs_size
			yyvs56 := yyspecial_routines56.make (yyvsc56)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs56")
			end
			yyvsc56 := yyvsc56 + yyInitial_yyvs_size
			yyvs56 := yyspecial_routines56.resize (yyvs56, yyvsc56)
		end
	end
	yyvs56.put (yyval56, yyvsp56)
end
		end

	yy_do_action_292 is
			--|#line 1859 "eiffel.y"
		local
			yyval88: EIFFEL_LIST [ELSIF_AS]
		do
--|#line 1859 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1859")
end

yyval88 := yyvs88.item (yyvsp88) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs88.put (yyval88, yyvsp88)
end
		end

	yy_do_action_293 is
			--|#line 1862 "eiffel.y"
		local
			yyval88: EIFFEL_LIST [ELSIF_AS]
		do
--|#line 1862 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1862")
end

report_unexpected_error (text, Void, True) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp1 := yyvsp1 -3
	yyvs88.put (yyval88, yyvsp88)
end
		end

	yy_do_action_294 is
			--|#line 1866 "eiffel.y"
		local
			yyval88: EIFFEL_LIST [ELSIF_AS]
		do
--|#line 1866 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1866")
end

				yyval88 := ast_factory.new_eiffel_list_elseif_as (counter_value + 1)
				if yyval88 /= Void and yyvs45.item (yyvsp45) /= Void then
					yyval88.reverse_extend (yyvs45.item (yyvsp45))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp88 := yyvsp88 + 1
	yyvsp45 := yyvsp45 -1
	if yyvsp88 >= yyvsc88 then
		if yyvs88 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs88")
			end
			create yyspecial_routines88
			yyvsc88 := yyInitial_yyvs_size
			yyvs88 := yyspecial_routines88.make (yyvsc88)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs88")
			end
			yyvsc88 := yyvsc88 + yyInitial_yyvs_size
			yyvs88 := yyspecial_routines88.resize (yyvs88, yyvsc88)
		end
	end
	yyvs88.put (yyval88, yyvsp88)
end
		end

	yy_do_action_295 is
			--|#line 1874 "eiffel.y"
		local
			yyval88: EIFFEL_LIST [ELSIF_AS]
		do
--|#line 1874 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1874")
end

				yyval88 := yyvs88.item (yyvsp88)
				if yyval88 /= Void and yyvs45.item (yyvsp45) /= Void and counter_value > 0 then
					yyval88.reverse_extend (yyvs45.item (yyvsp45))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp88 := yyvsp88 -1
	yyvsp45 := yyvsp45 -1
	yyvs88.put (yyval88, yyvsp88)
end
		end

	yy_do_action_296 is
			--|#line 1874 "eiffel.y"
		local
			yyval88: EIFFEL_LIST [ELSIF_AS]
		do
--|#line 1874 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1874")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp88 := yyvsp88 + 1
	if yyvsp88 >= yyvsc88 then
		if yyvs88 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs88")
			end
			create yyspecial_routines88
			yyvsc88 := yyInitial_yyvs_size
			yyvs88 := yyspecial_routines88.make (yyvsc88)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs88")
			end
			yyvsc88 := yyvsc88 + yyInitial_yyvs_size
			yyvs88 := yyspecial_routines88.resize (yyvs88, yyvsc88)
		end
	end
	yyvs88.put (yyval88, yyvsp88)
end
		end

	yy_do_action_297 is
			--|#line 1881 "eiffel.y"
		local
			yyval88: EIFFEL_LIST [ELSIF_AS]
		do
--|#line 1881 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1881")
end

report_unexpected_error (text, Void, True) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp88 := yyvsp88 + 1
	yyvsp45 := yyvsp45 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp88 >= yyvsc88 then
		if yyvs88 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs88")
			end
			create yyspecial_routines88
			yyvsc88 := yyInitial_yyvs_size
			yyvs88 := yyspecial_routines88.make (yyvsc88)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs88")
			end
			yyvsc88 := yyvsc88 + yyInitial_yyvs_size
			yyvs88 := yyspecial_routines88.resize (yyvs88, yyvsc88)
		end
	end
	yyvs88.put (yyval88, yyvsp88)
end
		end

	yy_do_action_298 is
			--|#line 1885 "eiffel.y"
		local
			yyval45: ELSIF_AS
		do
--|#line 1885 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1885")
end

yyval45 := ast_factory.new_elseif_as (yyvs48.item (yyvsp48), yyvs15.item (yyvsp15), yyvs12.item (yyvsp12 - 1), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp45 := yyvsp45 + 1
	yyvsp12 := yyvsp12 -2
	yyvsp48 := yyvsp48 -1
	yyvsp15 := yyvsp15 -1
	if yyvsp45 >= yyvsc45 then
		if yyvs45 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs45")
			end
			create yyspecial_routines45
			yyvsc45 := yyInitial_yyvs_size
			yyvs45 := yyspecial_routines45.make (yyvsc45)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs45")
			end
			yyvsc45 := yyvsc45 + yyInitial_yyvs_size
			yyvs45 := yyspecial_routines45.resize (yyvs45, yyvsc45)
		end
	end
	yyvs45.put (yyval45, yyvsp45)
end
		end

	yy_do_action_299 is
			--|#line 1888 "eiffel.y"
		local
			yyval45: ELSIF_AS
		do
--|#line 1888 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1888")
end

report_expected_match_error (parser_errors.elseif_keyword, yyvs12.item (yyvsp12), parser_errors.then_keyword, Void, True) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp45 := yyvsp45 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp48 := yyvsp48 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp45 >= yyvsc45 then
		if yyvs45 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs45")
			end
			create yyspecial_routines45
			yyvsc45 := yyInitial_yyvs_size
			yyvs45 := yyspecial_routines45.make (yyvsc45)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs45")
			end
			yyvsc45 := yyvsc45 + yyInitial_yyvs_size
			yyvs45 := yyspecial_routines45.resize (yyvs45, yyvsc45)
		end
	end
	yyvs45.put (yyval45, yyvsp45)
end
		end

	yy_do_action_300 is
			--|#line 1890 "eiffel.y"
		local
			yyval45: ELSIF_AS
		do
--|#line 1890 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1890")
end

report_expected_before_error (parser_errors.then_keyword, yyvs12.item (yyvsp12), parser_errors.an_expression, False) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp45 := yyvsp45 + 1
	yyvsp12 := yyvsp12 -2
	yyvsp15 := yyvsp15 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp45 >= yyvsc45 then
		if yyvs45 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs45")
			end
			create yyspecial_routines45
			yyvsc45 := yyInitial_yyvs_size
			yyvs45 := yyspecial_routines45.make (yyvsc45)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs45")
			end
			yyvsc45 := yyvsc45 + yyInitial_yyvs_size
			yyvs45 := yyspecial_routines45.resize (yyvs45, yyvsc45)
		end
	end
	yyvs45.put (yyval45, yyvsp45)
end
		end

	yy_do_action_301 is
			--|#line 1892 "eiffel.y"
		local
			yyval45: ELSIF_AS
		do
--|#line 1892 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1892")
end

report_expected_after_error (parser_errors.elseif_keyword, yyvs12.item (yyvsp12), parser_errors.an_expression, True) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp45 := yyvsp45 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp45 >= yyvsc45 then
		if yyvs45 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs45")
			end
			create yyspecial_routines45
			yyvsc45 := yyInitial_yyvs_size
			yyvs45 := yyspecial_routines45.make (yyvsc45)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs45")
			end
			yyvsc45 := yyvsc45 + yyInitial_yyvs_size
			yyvs45 := yyspecial_routines45.resize (yyvs45, yyvsc45)
		end
	end
	yyvs45.put (yyval45, yyvsp45)
end
		end

	yy_do_action_302 is
			--|#line 1896 "eiffel.y"
		local
			yyval16: PAIR [KEYWORD_AS, EIFFEL_LIST [INSTRUCTION_AS]]
		do
--|#line 1896 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1896")
end

yyval16 := ast_factory.new_keyword_instruction_list_pair (yyvs12.item (yyvsp12), yyvs15.item (yyvsp15)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp16 := yyvsp16 + 1
	yyvsp12 := yyvsp12 -1
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
		end

	yy_do_action_303 is
			--|#line 1900 "eiffel.y"
		local
			yyval58: INSPECT_AS
		do
--|#line 1900 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1900")
end

yyval58 := ast_factory.new_inspect_as (yyvs48.item (yyvsp48), yyvs85.item (yyvsp85), Void, yyvs12.item (yyvsp12), yyvs12.item (yyvsp12 - 1), Void) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp58 := yyvsp58 + 1
	yyvsp12 := yyvsp12 -2
	yyvsp48 := yyvsp48 -1
	yyvsp85 := yyvsp85 -1
	if yyvsp58 >= yyvsc58 then
		if yyvs58 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs58")
			end
			create yyspecial_routines58
			yyvsc58 := yyInitial_yyvs_size
			yyvs58 := yyspecial_routines58.make (yyvsc58)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs58")
			end
			yyvsc58 := yyvsc58 + yyInitial_yyvs_size
			yyvs58 := yyspecial_routines58.resize (yyvs58, yyvsc58)
		end
	end
	yyvs58.put (yyval58, yyvsp58)
end
		end

	yy_do_action_304 is
			--|#line 1902 "eiffel.y"
		local
			yyval58: INSPECT_AS
		do
--|#line 1902 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1902")
end

				if yyvs15.item (yyvsp15) /= Void then
					yyval58 := ast_factory.new_inspect_as (yyvs48.item (yyvsp48), yyvs85.item (yyvsp85), yyvs15.item (yyvsp15), yyvs12.item (yyvsp12), yyvs12.item (yyvsp12 - 2), yyvs12.item (yyvsp12 - 1))
				else
					yyval58 := ast_factory.new_inspect_as (yyvs48.item (yyvsp48), yyvs85.item (yyvsp85),
						ast_factory.new_eiffel_list_instruction_as (0), yyvs12.item (yyvsp12), yyvs12.item (yyvsp12 - 2), yyvs12.item (yyvsp12 - 1))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 6
	yyvsp58 := yyvsp58 + 1
	yyvsp12 := yyvsp12 -3
	yyvsp48 := yyvsp48 -1
	yyvsp85 := yyvsp85 -1
	yyvsp15 := yyvsp15 -1
	if yyvsp58 >= yyvsc58 then
		if yyvs58 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs58")
			end
			create yyspecial_routines58
			yyvsc58 := yyInitial_yyvs_size
			yyvs58 := yyspecial_routines58.make (yyvsc58)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs58")
			end
			yyvsc58 := yyvsc58 + yyInitial_yyvs_size
			yyvs58 := yyspecial_routines58.resize (yyvs58, yyvsc58)
		end
	end
	yyvs58.put (yyval58, yyvsp58)
end
		end

	yy_do_action_305 is
			--|#line 1913 "eiffel.y"
		local
			yyval85: EIFFEL_LIST [CASE_AS]
		do
--|#line 1913 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1913")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp85 := yyvsp85 + 1
	if yyvsp85 >= yyvsc85 then
		if yyvs85 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs85")
			end
			create yyspecial_routines85
			yyvsc85 := yyInitial_yyvs_size
			yyvs85 := yyspecial_routines85.make (yyvsc85)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs85")
			end
			yyvsc85 := yyvsc85 + yyInitial_yyvs_size
			yyvs85 := yyspecial_routines85.resize (yyvs85, yyvsc85)
		end
	end
	yyvs85.put (yyval85, yyvsp85)
end
		end

	yy_do_action_306 is
			--|#line 1915 "eiffel.y"
		local
			yyval85: EIFFEL_LIST [CASE_AS]
		do
--|#line 1915 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1915")
end

yyval85 := yyvs85.item (yyvsp85) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs85.put (yyval85, yyvsp85)
end
		end

	yy_do_action_307 is
			--|#line 1919 "eiffel.y"
		local
			yyval85: EIFFEL_LIST [CASE_AS]
		do
--|#line 1919 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1919")
end

				yyval85 := ast_factory.new_eiffel_list_case_as (counter_value + 1)
				if yyval85 /= Void and yyvs36.item (yyvsp36) /= Void then
					yyval85.reverse_extend (yyvs36.item (yyvsp36))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp85 := yyvsp85 + 1
	yyvsp36 := yyvsp36 -1
	if yyvsp85 >= yyvsc85 then
		if yyvs85 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs85")
			end
			create yyspecial_routines85
			yyvsc85 := yyInitial_yyvs_size
			yyvs85 := yyspecial_routines85.make (yyvsc85)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs85")
			end
			yyvsc85 := yyvsc85 + yyInitial_yyvs_size
			yyvs85 := yyspecial_routines85.resize (yyvs85, yyvsc85)
		end
	end
	yyvs85.put (yyval85, yyvsp85)
end
		end

	yy_do_action_308 is
			--|#line 1926 "eiffel.y"
		local
			yyval85: EIFFEL_LIST [CASE_AS]
		do
--|#line 1926 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1926")
end

				yyval85 := yyvs85.item (yyvsp85)
				if yyval85 /= Void and yyvs36.item (yyvsp36) /= Void then
					yyval85.reverse_extend (yyvs36.item (yyvsp36))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp85 := yyvsp85 -1
	yyvsp36 := yyvsp36 -1
	yyvs85.put (yyval85, yyvsp85)
end
		end

	yy_do_action_309 is
			--|#line 1926 "eiffel.y"
		local
			yyval85: EIFFEL_LIST [CASE_AS]
		do
--|#line 1926 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1926")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp85 := yyvsp85 + 1
	if yyvsp85 >= yyvsc85 then
		if yyvs85 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs85")
			end
			create yyspecial_routines85
			yyvsc85 := yyInitial_yyvs_size
			yyvs85 := yyspecial_routines85.make (yyvsc85)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs85")
			end
			yyvsc85 := yyvsc85 + yyInitial_yyvs_size
			yyvs85 := yyspecial_routines85.resize (yyvs85, yyvsc85)
		end
	end
	yyvs85.put (yyval85, yyvsp85)
end
		end

	yy_do_action_310 is
			--|#line 1935 "eiffel.y"
		local
			yyval36: CASE_AS
		do
--|#line 1935 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1935")
end

yyval36 := ast_factory.new_case_as (yyvs103.item (yyvsp103), yyvs15.item (yyvsp15), yyvs12.item (yyvsp12 - 1), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 6
	yyvsp36 := yyvsp36 + 1
	yyvsp12 := yyvsp12 -2
	yyvsp1 := yyvsp1 -2
	yyvsp103 := yyvsp103 -1
	yyvsp15 := yyvsp15 -1
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
		end

	yy_do_action_311 is
			--|#line 1939 "eiffel.y"
		local
			yyval103: EIFFEL_LIST [INTERVAL_AS]
		do
--|#line 1939 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1939")
end

				yyval103 := ast_factory.new_eiffel_list_interval_as (counter_value + 1)
				if yyval103 /= Void and yyvs61.item (yyvsp61) /= Void then
					yyval103.reverse_extend (yyvs61.item (yyvsp61))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp103 := yyvsp103 + 1
	yyvsp61 := yyvsp61 -1
	if yyvsp103 >= yyvsc103 then
		if yyvs103 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs103")
			end
			create yyspecial_routines103
			yyvsc103 := yyInitial_yyvs_size
			yyvs103 := yyspecial_routines103.make (yyvsc103)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs103")
			end
			yyvsc103 := yyvsc103 + yyInitial_yyvs_size
			yyvs103 := yyspecial_routines103.resize (yyvs103, yyvsc103)
		end
	end
	yyvs103.put (yyval103, yyvsp103)
end
		end

	yy_do_action_312 is
			--|#line 1946 "eiffel.y"
		local
			yyval103: EIFFEL_LIST [INTERVAL_AS]
		do
--|#line 1946 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1946")
end

				yyval103 := yyvs103.item (yyvsp103)
				if yyval103 /= Void and yyvs61.item (yyvsp61) /= Void then
					yyval103.reverse_extend (yyvs61.item (yyvsp61))
					ast_factory.reverse_extend_separator (yyval103, yyvs4.item (yyvsp4))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp103 := yyvsp103 -1
	yyvsp61 := yyvsp61 -1
	yyvsp4 := yyvsp4 -1
	yyvs103.put (yyval103, yyvsp103)
end
		end

	yy_do_action_313 is
			--|#line 1946 "eiffel.y"
		local
			yyval103: EIFFEL_LIST [INTERVAL_AS]
		do
--|#line 1946 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1946")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp103 := yyvsp103 + 1
	if yyvsp103 >= yyvsc103 then
		if yyvs103 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs103")
			end
			create yyspecial_routines103
			yyvsc103 := yyInitial_yyvs_size
			yyvs103 := yyspecial_routines103.make (yyvsc103)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs103")
			end
			yyvsc103 := yyvsc103 + yyInitial_yyvs_size
			yyvs103 := yyspecial_routines103.resize (yyvs103, yyvsc103)
		end
	end
	yyvs103.put (yyval103, yyvsp103)
end
		end

	yy_do_action_314 is
			--|#line 1956 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1956 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1956")
end

yyval61 := ast_factory.new_interval_as (yyvs59.item (yyvsp59), Void, Void) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp61 := yyvsp61 + 1
	yyvsp59 := yyvsp59 -1
	if yyvsp61 >= yyvsc61 then
		if yyvs61 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs61")
			end
			create yyspecial_routines61
			yyvsc61 := yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.make (yyvsc61)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs61")
			end
			yyvsc61 := yyvsc61 + yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.resize (yyvs61, yyvsc61)
		end
	end
	yyvs61.put (yyval61, yyvsp61)
end
		end

	yy_do_action_315 is
			--|#line 1958 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1958 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1958")
end

yyval61 := ast_factory.new_interval_as (yyvs59.item (yyvsp59 - 1), yyvs59.item (yyvsp59), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp61 := yyvsp61 + 1
	yyvsp59 := yyvsp59 -2
	yyvsp4 := yyvsp4 -1
	if yyvsp61 >= yyvsc61 then
		if yyvs61 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs61")
			end
			create yyspecial_routines61
			yyvsc61 := yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.make (yyvsc61)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs61")
			end
			yyvsc61 := yyvsc61 + yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.resize (yyvs61, yyvsc61)
		end
	end
	yyvs61.put (yyval61, yyvsp61)
end
		end

	yy_do_action_316 is
			--|#line 1960 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1960 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1960")
end

yyval61 := ast_factory.new_interval_as (yyvs3.item (yyvsp3), Void, Void) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp61 := yyvsp61 + 1
	yyvsp3 := yyvsp3 -1
	if yyvsp61 >= yyvsc61 then
		if yyvs61 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs61")
			end
			create yyspecial_routines61
			yyvsc61 := yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.make (yyvsc61)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs61")
			end
			yyvsc61 := yyvsc61 + yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.resize (yyvs61, yyvsc61)
		end
	end
	yyvs61.put (yyval61, yyvsp61)
end
		end

	yy_do_action_317 is
			--|#line 1962 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1962 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1962")
end

yyval61 := ast_factory.new_interval_as (yyvs3.item (yyvsp3 - 1), yyvs3.item (yyvsp3), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp61 := yyvsp61 + 1
	yyvsp3 := yyvsp3 -2
	yyvsp4 := yyvsp4 -1
	if yyvsp61 >= yyvsc61 then
		if yyvs61 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs61")
			end
			create yyspecial_routines61
			yyvsc61 := yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.make (yyvsc61)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs61")
			end
			yyvsc61 := yyvsc61 + yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.resize (yyvs61, yyvsc61)
		end
	end
	yyvs61.put (yyval61, yyvsp61)
end
		end

	yy_do_action_318 is
			--|#line 1964 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1964 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1964")
end

yyval61 := ast_factory.new_interval_as (yyvs2.item (yyvsp2), Void, Void) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp61 := yyvsp61 + 1
	yyvsp2 := yyvsp2 -1
	if yyvsp61 >= yyvsc61 then
		if yyvs61 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs61")
			end
			create yyspecial_routines61
			yyvsc61 := yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.make (yyvsc61)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs61")
			end
			yyvsc61 := yyvsc61 + yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.resize (yyvs61, yyvsc61)
		end
	end
	yyvs61.put (yyval61, yyvsp61)
end
		end

	yy_do_action_319 is
			--|#line 1966 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1966 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1966")
end

yyval61 := ast_factory.new_interval_as (yyvs2.item (yyvsp2 - 1), yyvs2.item (yyvsp2), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp61 := yyvsp61 + 1
	yyvsp2 := yyvsp2 -2
	yyvsp4 := yyvsp4 -1
	if yyvsp61 >= yyvsc61 then
		if yyvs61 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs61")
			end
			create yyspecial_routines61
			yyvsc61 := yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.make (yyvsc61)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs61")
			end
			yyvsc61 := yyvsc61 + yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.resize (yyvs61, yyvsc61)
		end
	end
	yyvs61.put (yyval61, yyvsp61)
end
		end

	yy_do_action_320 is
			--|#line 1968 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1968 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1968")
end

yyval61 := ast_factory.new_interval_as (yyvs2.item (yyvsp2), yyvs59.item (yyvsp59), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp61 := yyvsp61 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp4 := yyvsp4 -1
	yyvsp59 := yyvsp59 -1
	if yyvsp61 >= yyvsc61 then
		if yyvs61 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs61")
			end
			create yyspecial_routines61
			yyvsc61 := yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.make (yyvsc61)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs61")
			end
			yyvsc61 := yyvsc61 + yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.resize (yyvs61, yyvsc61)
		end
	end
	yyvs61.put (yyval61, yyvsp61)
end
		end

	yy_do_action_321 is
			--|#line 1970 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1970 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1970")
end

yyval61 := ast_factory.new_interval_as (yyvs59.item (yyvsp59), yyvs2.item (yyvsp2), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp61 := yyvsp61 + 1
	yyvsp59 := yyvsp59 -1
	yyvsp4 := yyvsp4 -1
	yyvsp2 := yyvsp2 -1
	if yyvsp61 >= yyvsc61 then
		if yyvs61 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs61")
			end
			create yyspecial_routines61
			yyvsc61 := yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.make (yyvsc61)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs61")
			end
			yyvsc61 := yyvsc61 + yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.resize (yyvs61, yyvsc61)
		end
	end
	yyvs61.put (yyval61, yyvsp61)
end
		end

	yy_do_action_322 is
			--|#line 1972 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1972 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1972")
end

yyval61 := ast_factory.new_interval_as (yyvs2.item (yyvsp2), yyvs3.item (yyvsp3), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp61 := yyvsp61 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp4 := yyvsp4 -1
	yyvsp3 := yyvsp3 -1
	if yyvsp61 >= yyvsc61 then
		if yyvs61 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs61")
			end
			create yyspecial_routines61
			yyvsc61 := yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.make (yyvsc61)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs61")
			end
			yyvsc61 := yyvsc61 + yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.resize (yyvs61, yyvsc61)
		end
	end
	yyvs61.put (yyval61, yyvsp61)
end
		end

	yy_do_action_323 is
			--|#line 1974 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1974 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1974")
end

yyval61 := ast_factory.new_interval_as (yyvs3.item (yyvsp3), yyvs2.item (yyvsp2), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp61 := yyvsp61 + 1
	yyvsp3 := yyvsp3 -1
	yyvsp4 := yyvsp4 -1
	yyvsp2 := yyvsp2 -1
	if yyvsp61 >= yyvsc61 then
		if yyvs61 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs61")
			end
			create yyspecial_routines61
			yyvsc61 := yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.make (yyvsc61)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs61")
			end
			yyvsc61 := yyvsc61 + yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.resize (yyvs61, yyvsc61)
		end
	end
	yyvs61.put (yyval61, yyvsp61)
end
		end

	yy_do_action_324 is
			--|#line 1976 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1976 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1976")
end

yyval61 := ast_factory.new_interval_as (yyvs68.item (yyvsp68), Void, Void) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp61 := yyvsp61 + 1
	yyvsp68 := yyvsp68 -1
	if yyvsp61 >= yyvsc61 then
		if yyvs61 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs61")
			end
			create yyspecial_routines61
			yyvsc61 := yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.make (yyvsc61)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs61")
			end
			yyvsc61 := yyvsc61 + yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.resize (yyvs61, yyvsc61)
		end
	end
	yyvs61.put (yyval61, yyvsp61)
end
		end

	yy_do_action_325 is
			--|#line 1978 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1978 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1978")
end

yyval61 := ast_factory.new_interval_as (yyvs68.item (yyvsp68), yyvs2.item (yyvsp2), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp61 := yyvsp61 + 1
	yyvsp68 := yyvsp68 -1
	yyvsp4 := yyvsp4 -1
	yyvsp2 := yyvsp2 -1
	if yyvsp61 >= yyvsc61 then
		if yyvs61 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs61")
			end
			create yyspecial_routines61
			yyvsc61 := yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.make (yyvsc61)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs61")
			end
			yyvsc61 := yyvsc61 + yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.resize (yyvs61, yyvsc61)
		end
	end
	yyvs61.put (yyval61, yyvsp61)
end
		end

	yy_do_action_326 is
			--|#line 1980 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1980 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1980")
end

yyval61 := ast_factory.new_interval_as (yyvs2.item (yyvsp2), yyvs68.item (yyvsp68), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp61 := yyvsp61 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp4 := yyvsp4 -1
	yyvsp68 := yyvsp68 -1
	if yyvsp61 >= yyvsc61 then
		if yyvs61 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs61")
			end
			create yyspecial_routines61
			yyvsc61 := yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.make (yyvsc61)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs61")
			end
			yyvsc61 := yyvsc61 + yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.resize (yyvs61, yyvsc61)
		end
	end
	yyvs61.put (yyval61, yyvsp61)
end
		end

	yy_do_action_327 is
			--|#line 1982 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1982 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1982")
end

yyval61 := ast_factory.new_interval_as (yyvs68.item (yyvsp68 - 1), yyvs68.item (yyvsp68), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp61 := yyvsp61 + 1
	yyvsp68 := yyvsp68 -2
	yyvsp4 := yyvsp4 -1
	if yyvsp61 >= yyvsc61 then
		if yyvs61 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs61")
			end
			create yyspecial_routines61
			yyvsc61 := yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.make (yyvsc61)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs61")
			end
			yyvsc61 := yyvsc61 + yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.resize (yyvs61, yyvsc61)
		end
	end
	yyvs61.put (yyval61, yyvsp61)
end
		end

	yy_do_action_328 is
			--|#line 1984 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1984 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1984")
end

yyval61 := ast_factory.new_interval_as (yyvs68.item (yyvsp68), yyvs59.item (yyvsp59), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp61 := yyvsp61 + 1
	yyvsp68 := yyvsp68 -1
	yyvsp4 := yyvsp4 -1
	yyvsp59 := yyvsp59 -1
	if yyvsp61 >= yyvsc61 then
		if yyvs61 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs61")
			end
			create yyspecial_routines61
			yyvsc61 := yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.make (yyvsc61)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs61")
			end
			yyvsc61 := yyvsc61 + yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.resize (yyvs61, yyvsc61)
		end
	end
	yyvs61.put (yyval61, yyvsp61)
end
		end

	yy_do_action_329 is
			--|#line 1986 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1986 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1986")
end

yyval61 := ast_factory.new_interval_as (yyvs59.item (yyvsp59), yyvs68.item (yyvsp68), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp61 := yyvsp61 + 1
	yyvsp59 := yyvsp59 -1
	yyvsp4 := yyvsp4 -1
	yyvsp68 := yyvsp68 -1
	if yyvsp61 >= yyvsc61 then
		if yyvs61 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs61")
			end
			create yyspecial_routines61
			yyvsc61 := yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.make (yyvsc61)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs61")
			end
			yyvsc61 := yyvsc61 + yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.resize (yyvs61, yyvsc61)
		end
	end
	yyvs61.put (yyval61, yyvsp61)
end
		end

	yy_do_action_330 is
			--|#line 1988 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1988 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1988")
end

yyval61 := ast_factory.new_interval_as (yyvs68.item (yyvsp68), yyvs3.item (yyvsp3), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp61 := yyvsp61 + 1
	yyvsp68 := yyvsp68 -1
	yyvsp4 := yyvsp4 -1
	yyvsp3 := yyvsp3 -1
	if yyvsp61 >= yyvsc61 then
		if yyvs61 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs61")
			end
			create yyspecial_routines61
			yyvsc61 := yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.make (yyvsc61)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs61")
			end
			yyvsc61 := yyvsc61 + yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.resize (yyvs61, yyvsc61)
		end
	end
	yyvs61.put (yyval61, yyvsp61)
end
		end

	yy_do_action_331 is
			--|#line 1990 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1990 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1990")
end

yyval61 := ast_factory.new_interval_as (yyvs3.item (yyvsp3), yyvs68.item (yyvsp68), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp61 := yyvsp61 + 1
	yyvsp3 := yyvsp3 -1
	yyvsp4 := yyvsp4 -1
	yyvsp68 := yyvsp68 -1
	if yyvsp61 >= yyvsc61 then
		if yyvs61 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs61")
			end
			create yyspecial_routines61
			yyvsc61 := yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.make (yyvsc61)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs61")
			end
			yyvsc61 := yyvsc61 + yyInitial_yyvs_size
			yyvs61 := yyspecial_routines61.resize (yyvs61, yyvsc61)
		end
	end
	yyvs61.put (yyval61, yyvsp61)
end
		end

	yy_do_action_332 is
			--|#line 1995 "eiffel.y"
		local
			yyval63: LOOP_AS
		do
--|#line 1995 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1995")
end

				if yyvs23.item (yyvsp23) /= Void then
					yyval63 := ast_factory.new_loop_as (yyvs15.item (yyvsp15 - 1), yyvs23.item (yyvsp23).second, yyvs82.item (yyvsp82), yyvs48.item (yyvsp48), yyvs15.item (yyvsp15), yyvs12.item (yyvsp12), yyvs12.item (yyvsp12 - 3), yyvs23.item (yyvsp23).first, yyvs12.item (yyvsp12 - 2), yyvs12.item (yyvsp12 - 1))
				else
					yyval63 := ast_factory.new_loop_as (yyvs15.item (yyvsp15 - 1), Void, yyvs82.item (yyvsp82), yyvs48.item (yyvsp48), yyvs15.item (yyvsp15), yyvs12.item (yyvsp12), yyvs12.item (yyvsp12 - 3), Void, yyvs12.item (yyvsp12 - 2), yyvs12.item (yyvsp12 - 1))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 9
	yyvsp63 := yyvsp63 + 1
	yyvsp12 := yyvsp12 -4
	yyvsp15 := yyvsp15 -2
	yyvsp23 := yyvsp23 -1
	yyvsp82 := yyvsp82 -1
	yyvsp48 := yyvsp48 -1
	if yyvsp63 >= yyvsc63 then
		if yyvs63 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs63")
			end
			create yyspecial_routines63
			yyvsc63 := yyInitial_yyvs_size
			yyvs63 := yyspecial_routines63.make (yyvsc63)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs63")
			end
			yyvsc63 := yyvsc63 + yyInitial_yyvs_size
			yyvs63 := yyspecial_routines63.resize (yyvs63, yyvsc63)
		end
	end
	yyvs63.put (yyval63, yyvsp63)
end
		end

	yy_do_action_333 is
			--|#line 2005 "eiffel.y"
		local
			yyval23: PAIR [KEYWORD_AS, EIFFEL_LIST [TAGGED_AS]]
		do
--|#line 2005 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2005")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp23 := yyvsp23 + 1
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
		end

	yy_do_action_334 is
			--|#line 2007 "eiffel.y"
		local
			yyval23: PAIR [KEYWORD_AS, EIFFEL_LIST [TAGGED_AS]]
		do
--|#line 2007 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2007")
end

yyval23 := ast_factory.new_invariant_pair (yyvs12.item (yyvsp12), yyvs22.item (yyvsp22)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp23 := yyvsp23 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp22 := yyvsp22 -1
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
		end

	yy_do_action_335 is
			--|#line 2011 "eiffel.y"
		local
			yyval62: INVARIANT_AS
		do
--|#line 2011 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2011")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp62 := yyvsp62 + 1
	if yyvsp62 >= yyvsc62 then
		if yyvs62 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs62")
			end
			create yyspecial_routines62
			yyvsc62 := yyInitial_yyvs_size
			yyvs62 := yyspecial_routines62.make (yyvsc62)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs62")
			end
			yyvsc62 := yyvsc62 + yyInitial_yyvs_size
			yyvs62 := yyspecial_routines62.resize (yyvs62, yyvsc62)
		end
	end
	yyvs62.put (yyval62, yyvsp62)
end
		end

	yy_do_action_336 is
			--|#line 2013 "eiffel.y"
		local
			yyval62: INVARIANT_AS
		do
--|#line 2013 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2013")
end

				id_level := Normal_level
				yyval62 := ast_factory.new_invariant_as (yyvs22.item (yyvsp22), once_manifest_string_count, yyvs12.item (yyvsp12))
				once_manifest_string_count := 0
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp12 := yyvsp12 -1
	yyvsp22 := yyvsp22 -1
	yyvs62.put (yyval62, yyvsp62)
end
		end

	yy_do_action_337 is
			--|#line 2013 "eiffel.y"
		local
			yyval62: INVARIANT_AS
		do
--|#line 2013 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2013")
end

id_level := Invariant_level 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp62 := yyvsp62 + 1
	if yyvsp62 >= yyvsc62 then
		if yyvs62 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs62")
			end
			create yyspecial_routines62
			yyvsc62 := yyInitial_yyvs_size
			yyvs62 := yyspecial_routines62.make (yyvsc62)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs62")
			end
			yyvsc62 := yyvsc62 + yyInitial_yyvs_size
			yyvs62 := yyspecial_routines62.resize (yyvs62, yyvsc62)
		end
	end
	yyvs62.put (yyval62, yyvsp62)
end
		end

	yy_do_action_338 is
			--|#line 2023 "eiffel.y"
		local
			yyval82: VARIANT_AS
		do
--|#line 2023 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2023")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp82 := yyvsp82 + 1
	if yyvsp82 >= yyvsc82 then
		if yyvs82 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs82")
			end
			create yyspecial_routines82
			yyvsc82 := yyInitial_yyvs_size
			yyvs82 := yyspecial_routines82.make (yyvsc82)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs82")
			end
			yyvsc82 := yyvsc82 + yyInitial_yyvs_size
			yyvs82 := yyspecial_routines82.resize (yyvs82, yyvsc82)
		end
	end
	yyvs82.put (yyval82, yyvsp82)
end
		end

	yy_do_action_339 is
			--|#line 2025 "eiffel.y"
		local
			yyval82: VARIANT_AS
		do
--|#line 2025 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2025")
end

yyval82 := ast_factory.new_variant_as (yyvs2.item (yyvsp2), yyvs48.item (yyvsp48), yyvs12.item (yyvsp12), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp82 := yyvsp82 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp2 := yyvsp2 -1
	yyvsp4 := yyvsp4 -1
	yyvsp48 := yyvsp48 -1
	if yyvsp82 >= yyvsc82 then
		if yyvs82 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs82")
			end
			create yyspecial_routines82
			yyvsc82 := yyInitial_yyvs_size
			yyvs82 := yyspecial_routines82.make (yyvsc82)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs82")
			end
			yyvsc82 := yyvsc82 + yyInitial_yyvs_size
			yyvs82 := yyspecial_routines82.resize (yyvs82, yyvsc82)
		end
	end
	yyvs82.put (yyval82, yyvsp82)
end
		end

	yy_do_action_340 is
			--|#line 2027 "eiffel.y"
		local
			yyval82: VARIANT_AS
		do
--|#line 2027 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2027")
end

yyval82 := ast_factory.new_variant_as (Void, yyvs48.item (yyvsp48), yyvs12.item (yyvsp12), Void) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp82 := yyvsp82 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp48 := yyvsp48 -1
	if yyvsp82 >= yyvsc82 then
		if yyvs82 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs82")
			end
			create yyspecial_routines82
			yyvsc82 := yyInitial_yyvs_size
			yyvs82 := yyspecial_routines82.make (yyvsc82)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs82")
			end
			yyvsc82 := yyvsc82 + yyInitial_yyvs_size
			yyvs82 := yyspecial_routines82.resize (yyvs82, yyvsc82)
		end
	end
	yyvs82.put (yyval82, yyvsp82)
end
		end

	yy_do_action_341 is
			--|#line 2031 "eiffel.y"
		local
			yyval44: DEBUG_AS
		do
--|#line 2031 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2031")
end

yyval44 := ast_factory.new_debug_as (yyvs110.item (yyvsp110), yyvs15.item (yyvsp15), yyvs12.item (yyvsp12 - 1), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp44 := yyvsp44 + 1
	yyvsp12 := yyvsp12 -2
	yyvsp110 := yyvsp110 -1
	yyvsp15 := yyvsp15 -1
	if yyvsp44 >= yyvsc44 then
		if yyvs44 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs44")
			end
			create yyspecial_routines44
			yyvsc44 := yyInitial_yyvs_size
			yyvs44 := yyspecial_routines44.make (yyvsc44)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs44")
			end
			yyvsc44 := yyvsc44 + yyInitial_yyvs_size
			yyvs44 := yyspecial_routines44.resize (yyvs44, yyvsc44)
		end
	end
	yyvs44.put (yyval44, yyvsp44)
end
		end

	yy_do_action_342 is
			--|#line 2035 "eiffel.y"
		local
			yyval110: DEBUG_KEY_LIST_AS
		do
--|#line 2035 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2035")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp110 := yyvsp110 + 1
	if yyvsp110 >= yyvsc110 then
		if yyvs110 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs110")
			end
			create yyspecial_routines110
			yyvsc110 := yyInitial_yyvs_size
			yyvs110 := yyspecial_routines110.make (yyvsc110)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs110")
			end
			yyvsc110 := yyvsc110 + yyInitial_yyvs_size
			yyvs110 := yyspecial_routines110.resize (yyvs110, yyvsc110)
		end
	end
	yyvs110.put (yyval110, yyvsp110)
end
		end

	yy_do_action_343 is
			--|#line 2037 "eiffel.y"
		local
			yyval110: DEBUG_KEY_LIST_AS
		do
--|#line 2037 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2037")
end

				yyval110 := ast_factory.new_debug_key_list_as (Void, yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4))
				report_warning (parser_errors.empty_parenthesis_warning, yyvs4.item (yyvsp4 - 1))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp110 := yyvsp110 + 1
	yyvsp4 := yyvsp4 -2
	if yyvsp110 >= yyvsc110 then
		if yyvs110 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs110")
			end
			create yyspecial_routines110
			yyvsc110 := yyInitial_yyvs_size
			yyvs110 := yyspecial_routines110.make (yyvsc110)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs110")
			end
			yyvsc110 := yyvsc110 + yyInitial_yyvs_size
			yyvs110 := yyspecial_routines110.resize (yyvs110, yyvsc110)
		end
	end
	yyvs110.put (yyval110, yyvsp110)
end
		end

	yy_do_action_344 is
			--|#line 2042 "eiffel.y"
		local
			yyval110: DEBUG_KEY_LIST_AS
		do
--|#line 2042 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2042")
end

yyval110 := ast_factory.new_debug_key_list_as (yyvs109.item (yyvsp109), yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp110 := yyvsp110 + 1
	yyvsp4 := yyvsp4 -2
	yyvsp1 := yyvsp1 -2
	yyvsp109 := yyvsp109 -1
	if yyvsp110 >= yyvsc110 then
		if yyvs110 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs110")
			end
			create yyspecial_routines110
			yyvsc110 := yyInitial_yyvs_size
			yyvs110 := yyspecial_routines110.make (yyvsc110)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs110")
			end
			yyvsc110 := yyvsc110 + yyInitial_yyvs_size
			yyvs110 := yyspecial_routines110.resize (yyvs110, yyvsc110)
		end
	end
	yyvs110.put (yyval110, yyvsp110)
end
		end

	yy_do_action_345 is
			--|#line 2046 "eiffel.y"
		local
			yyval109: EIFFEL_LIST [STRING_AS]
		do
--|#line 2046 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2046")
end

				yyval109 := ast_factory.new_eiffel_list_string_as (counter_value + 1)
				if yyval109 /= Void and yyvs18.item (yyvsp18) /= Void then
					yyval109.reverse_extend (yyvs18.item (yyvsp18))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp109 := yyvsp109 + 1
	yyvsp18 := yyvsp18 -1
	if yyvsp109 >= yyvsc109 then
		if yyvs109 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs109")
			end
			create yyspecial_routines109
			yyvsc109 := yyInitial_yyvs_size
			yyvs109 := yyspecial_routines109.make (yyvsc109)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs109")
			end
			yyvsc109 := yyvsc109 + yyInitial_yyvs_size
			yyvs109 := yyspecial_routines109.resize (yyvs109, yyvsc109)
		end
	end
	yyvs109.put (yyval109, yyvsp109)
end
		end

	yy_do_action_346 is
			--|#line 2053 "eiffel.y"
		local
			yyval109: EIFFEL_LIST [STRING_AS]
		do
--|#line 2053 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2053")
end

				yyval109 := yyvs109.item (yyvsp109)
				if yyval109 /= Void and yyvs18.item (yyvsp18) /= Void then
					yyval109.reverse_extend (yyvs18.item (yyvsp18))
					ast_factory.reverse_extend_separator (yyval109, yyvs4.item (yyvsp4))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp109 := yyvsp109 -1
	yyvsp18 := yyvsp18 -1
	yyvsp4 := yyvsp4 -1
	yyvs109.put (yyval109, yyvsp109)
end
		end

	yy_do_action_347 is
			--|#line 2053 "eiffel.y"
		local
			yyval109: EIFFEL_LIST [STRING_AS]
		do
--|#line 2053 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2053")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp109 := yyvsp109 + 1
	if yyvsp109 >= yyvsc109 then
		if yyvs109 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs109")
			end
			create yyspecial_routines109
			yyvsc109 := yyInitial_yyvs_size
			yyvs109 := yyspecial_routines109.make (yyvsc109)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs109")
			end
			yyvsc109 := yyvsc109 + yyInitial_yyvs_size
			yyvs109 := yyspecial_routines109.resize (yyvs109, yyvsc109)
		end
	end
	yyvs109.put (yyval109, yyvsp109)
end
		end

	yy_do_action_348 is
			--|#line 2063 "eiffel.y"
		local
			yyval16: PAIR [KEYWORD_AS, EIFFEL_LIST [INSTRUCTION_AS]]
		do
--|#line 2063 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2063")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp16 := yyvsp16 + 1
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
		end

	yy_do_action_349 is
			--|#line 2065 "eiffel.y"
		local
			yyval16: PAIR [KEYWORD_AS, EIFFEL_LIST [INSTRUCTION_AS]]
		do
--|#line 2065 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2065")
end

				if yyvs15.item (yyvsp15) = Void then
					yyval16 := ast_factory.new_keyword_instruction_list_pair (yyvs12.item (yyvsp12), ast_factory.new_eiffel_list_instruction_as (0))
				else
					yyval16 := ast_factory.new_keyword_instruction_list_pair (yyvs12.item (yyvsp12), yyvs15.item (yyvsp15))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp16 := yyvsp16 + 1
	yyvsp12 := yyvsp12 -1
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
		end

	yy_do_action_350 is
			--|#line 2075 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2075 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2075")
end

yyval48 := yyvs32.item (yyvsp32) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp48 := yyvsp48 + 1
	yyvsp32 := yyvsp32 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_351 is
			--|#line 2078 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2078 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2078")
end

yyval48 := yyvs48.item (yyvsp48) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_352 is
			--|#line 2080 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2080 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2080")
end

yyval48 := ast_factory.new_expr_call_as (yyvs35.item (yyvsp35)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp48 := yyvsp48 + 1
	yyvsp35 := yyvsp35 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_353 is
			--|#line 2082 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2082 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2082")
end

yyval48 := yyvs68.item (yyvsp68) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp48 := yyvsp48 + 1
	yyvsp68 := yyvsp68 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_354 is
			--|#line 2086 "eiffel.y"
		local
			yyval30: ASSIGNER_CALL_AS
		do
--|#line 2086 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2086")
end

yyval30 := ast_factory.new_assigner_call_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp30 := yyvsp30 + 1
	yyvsp48 := yyvsp48 -2
	yyvsp4 := yyvsp4 -1
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
		end

	yy_do_action_355 is
			--|#line 2090 "eiffel.y"
		local
			yyval29: ASSIGN_AS
		do
--|#line 2090 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2090")
end

yyval29 := ast_factory.new_assign_as (ast_factory.new_access_id_as (yyvs2.item (yyvsp2), Void), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp29 := yyvsp29 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp4 := yyvsp4 -1
	yyvsp48 := yyvsp48 -1
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
		end

	yy_do_action_356 is
			--|#line 2092 "eiffel.y"
		local
			yyval29: ASSIGN_AS
		do
--|#line 2092 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2092")
end

yyval29 := ast_factory.new_assign_as (yyvs6.item (yyvsp6), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp29 := yyvsp29 + 1
	yyvsp6 := yyvsp6 -1
	yyvsp4 := yyvsp4 -1
	yyvsp48 := yyvsp48 -1
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
		end

	yy_do_action_357 is
			--|#line 2096 "eiffel.y"
		local
			yyval72: REVERSE_AS
		do
--|#line 2096 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2096")
end

yyval72 := ast_factory.new_reverse_as (ast_factory.new_access_id_as (yyvs2.item (yyvsp2), Void), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp72 := yyvsp72 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp4 := yyvsp4 -1
	yyvsp48 := yyvsp48 -1
	if yyvsp72 >= yyvsc72 then
		if yyvs72 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs72")
			end
			create yyspecial_routines72
			yyvsc72 := yyInitial_yyvs_size
			yyvs72 := yyspecial_routines72.make (yyvsc72)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs72")
			end
			yyvsc72 := yyvsc72 + yyInitial_yyvs_size
			yyvs72 := yyspecial_routines72.resize (yyvs72, yyvsc72)
		end
	end
	yyvs72.put (yyval72, yyvsp72)
end
		end

	yy_do_action_358 is
			--|#line 2098 "eiffel.y"
		local
			yyval72: REVERSE_AS
		do
--|#line 2098 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2098")
end

yyval72 := ast_factory.new_reverse_as (yyvs6.item (yyvsp6), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp72 := yyvsp72 + 1
	yyvsp6 := yyvsp6 -1
	yyvsp4 := yyvsp4 -1
	yyvsp48 := yyvsp48 -1
	if yyvsp72 >= yyvsc72 then
		if yyvs72 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs72")
			end
			create yyspecial_routines72
			yyvsc72 := yyInitial_yyvs_size
			yyvs72 := yyspecial_routines72.make (yyvsc72)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs72")
			end
			yyvsc72 := yyvsc72 + yyInitial_yyvs_size
			yyvs72 := yyspecial_routines72.resize (yyvs72, yyvsc72)
		end
	end
	yyvs72.put (yyval72, yyvsp72)
end
		end

	yy_do_action_359 is
			--|#line 2102 "eiffel.y"
		local
			yyval87: EIFFEL_LIST [CREATE_AS]
		do
--|#line 2102 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2102")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp87 := yyvsp87 + 1
	if yyvsp87 >= yyvsc87 then
		if yyvs87 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs87")
			end
			create yyspecial_routines87
			yyvsc87 := yyInitial_yyvs_size
			yyvs87 := yyspecial_routines87.make (yyvsc87)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs87")
			end
			yyvsc87 := yyvsc87 + yyInitial_yyvs_size
			yyvs87 := yyspecial_routines87.resize (yyvs87, yyvsc87)
		end
	end
	yyvs87.put (yyval87, yyvsp87)
end
		end

	yy_do_action_360 is
			--|#line 2104 "eiffel.y"
		local
			yyval87: EIFFEL_LIST [CREATE_AS]
		do
--|#line 2104 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2104")
end

yyval87 := yyvs87.item (yyvsp87) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs87.put (yyval87, yyvsp87)
end
		end

	yy_do_action_361 is
			--|#line 2108 "eiffel.y"
		local
			yyval87: EIFFEL_LIST [CREATE_AS]
		do
--|#line 2108 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2108")
end

				yyval87 := ast_factory.new_eiffel_list_create_as (counter_value + 1)
				if yyval87 /= Void and yyvs41.item (yyvsp41) /= Void then
					yyval87.reverse_extend (yyvs41.item (yyvsp41))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp87 := yyvsp87 + 1
	yyvsp41 := yyvsp41 -1
	if yyvsp87 >= yyvsc87 then
		if yyvs87 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs87")
			end
			create yyspecial_routines87
			yyvsc87 := yyInitial_yyvs_size
			yyvs87 := yyspecial_routines87.make (yyvsc87)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs87")
			end
			yyvsc87 := yyvsc87 + yyInitial_yyvs_size
			yyvs87 := yyspecial_routines87.resize (yyvs87, yyvsc87)
		end
	end
	yyvs87.put (yyval87, yyvsp87)
end
		end

	yy_do_action_362 is
			--|#line 2115 "eiffel.y"
		local
			yyval87: EIFFEL_LIST [CREATE_AS]
		do
--|#line 2115 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2115")
end

				yyval87 := yyvs87.item (yyvsp87)
				if yyval87 /= Void and yyvs41.item (yyvsp41) /= Void then
					yyval87.reverse_extend (yyvs41.item (yyvsp41))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp87 := yyvsp87 -1
	yyvsp41 := yyvsp41 -1
	yyvs87.put (yyval87, yyvsp87)
end
		end

	yy_do_action_363 is
			--|#line 2115 "eiffel.y"
		local
			yyval87: EIFFEL_LIST [CREATE_AS]
		do
--|#line 2115 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2115")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp87 := yyvsp87 + 1
	if yyvsp87 >= yyvsc87 then
		if yyvs87 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs87")
			end
			create yyspecial_routines87
			yyvsc87 := yyInitial_yyvs_size
			yyvs87 := yyspecial_routines87.make (yyvsc87)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs87")
			end
			yyvsc87 := yyvsc87 + yyInitial_yyvs_size
			yyvs87 := yyspecial_routines87.resize (yyvs87, yyvsc87)
		end
	end
	yyvs87.put (yyval87, yyvsp87)
end
		end

	yy_do_action_364 is
			--|#line 2124 "eiffel.y"
		local
			yyval41: CREATE_AS
		do
--|#line 2124 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2124")
end

				yyval41 := ast_factory.new_create_as (Void, Void, yyvs12.item (yyvsp12))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp41 := yyvsp41 + 1
	yyvsp12 := yyvsp12 -1
	if yyvsp41 >= yyvsc41 then
		if yyvs41 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs41")
			end
			create yyspecial_routines41
			yyvsc41 := yyInitial_yyvs_size
			yyvs41 := yyspecial_routines41.make (yyvsc41)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs41")
			end
			yyvsc41 := yyvsc41 + yyInitial_yyvs_size
			yyvs41 := yyspecial_routines41.resize (yyvs41, yyvsc41)
		end
	end
	yyvs41.put (yyval41, yyvsp41)
end
		end

	yy_do_action_365 is
			--|#line 2129 "eiffel.y"
		local
			yyval41: CREATE_AS
		do
--|#line 2129 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2129")
end

				yyval41 := ast_factory.new_create_as (yyvs38.item (yyvsp38), yyvs95.item (yyvsp95), yyvs12.item (yyvsp12))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp41 := yyvsp41 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp38 := yyvsp38 -1
	yyvsp95 := yyvsp95 -1
	if yyvsp41 >= yyvsc41 then
		if yyvs41 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs41")
			end
			create yyspecial_routines41
			yyvsc41 := yyInitial_yyvs_size
			yyvs41 := yyspecial_routines41.make (yyvsc41)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs41")
			end
			yyvsc41 := yyvsc41 + yyInitial_yyvs_size
			yyvs41 := yyspecial_routines41.resize (yyvs41, yyvsc41)
		end
	end
	yyvs41.put (yyval41, yyvsp41)
end
		end

	yy_do_action_366 is
			--|#line 2133 "eiffel.y"
		local
			yyval41: CREATE_AS
		do
--|#line 2133 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2133")
end

				yyval41 := ast_factory.new_create_as (ast_factory.new_client_as (yyvs101.item (yyvsp101)), Void, yyvs12.item (yyvsp12))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp41 := yyvsp41 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp101 := yyvsp101 -1
	if yyvsp41 >= yyvsc41 then
		if yyvs41 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs41")
			end
			create yyspecial_routines41
			yyvsc41 := yyInitial_yyvs_size
			yyvs41 := yyspecial_routines41.make (yyvsc41)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs41")
			end
			yyvsc41 := yyvsc41 + yyInitial_yyvs_size
			yyvs41 := yyspecial_routines41.resize (yyvs41, yyvsc41)
		end
	end
	yyvs41.put (yyval41, yyvsp41)
end
		end

	yy_do_action_367 is
			--|#line 2137 "eiffel.y"
		local
			yyval41: CREATE_AS
		do
--|#line 2137 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2137")
end

				yyval41 := ast_factory.new_create_as (Void, Void, yyvs12.item (yyvsp12))
					report_warning (parser_errors.creation_use_warning, yyvs12.item (yyvsp12))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp41 := yyvsp41 + 1
	yyvsp12 := yyvsp12 -1
	if yyvsp41 >= yyvsc41 then
		if yyvs41 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs41")
			end
			create yyspecial_routines41
			yyvsc41 := yyInitial_yyvs_size
			yyvs41 := yyspecial_routines41.make (yyvsc41)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs41")
			end
			yyvsc41 := yyvsc41 + yyInitial_yyvs_size
			yyvs41 := yyspecial_routines41.resize (yyvs41, yyvsc41)
		end
	end
	yyvs41.put (yyval41, yyvsp41)
end
		end

	yy_do_action_368 is
			--|#line 2142 "eiffel.y"
		local
			yyval41: CREATE_AS
		do
--|#line 2142 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2142")
end

				yyval41 := ast_factory.new_create_as (yyvs38.item (yyvsp38), yyvs95.item (yyvsp95), yyvs12.item (yyvsp12))
				report_warning (parser_errors.creation_use_warning, yyvs12.item (yyvsp12))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp41 := yyvsp41 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp38 := yyvsp38 -1
	yyvsp95 := yyvsp95 -1
	if yyvsp41 >= yyvsc41 then
		if yyvs41 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs41")
			end
			create yyspecial_routines41
			yyvsc41 := yyInitial_yyvs_size
			yyvs41 := yyspecial_routines41.make (yyvsc41)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs41")
			end
			yyvsc41 := yyvsc41 + yyInitial_yyvs_size
			yyvs41 := yyspecial_routines41.resize (yyvs41, yyvsc41)
		end
	end
	yyvs41.put (yyval41, yyvsp41)
end
		end

	yy_do_action_369 is
			--|#line 2147 "eiffel.y"
		local
			yyval41: CREATE_AS
		do
--|#line 2147 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2147")
end

				yyval41 := ast_factory.new_create_as (ast_factory.new_client_as (yyvs101.item (yyvsp101)), Void, yyvs12.item (yyvsp12))
				report_warning (parser_errors.creation_use_warning, yyvs12.item (yyvsp12))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp41 := yyvsp41 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp101 := yyvsp101 -1
	if yyvsp41 >= yyvsc41 then
		if yyvs41 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs41")
			end
			create yyspecial_routines41
			yyvsc41 := yyInitial_yyvs_size
			yyvs41 := yyspecial_routines41.make (yyvsc41)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs41")
			end
			yyvsc41 := yyvsc41 + yyInitial_yyvs_size
			yyvs41 := yyspecial_routines41.resize (yyvs41, yyvsc41)
		end
	end
	yyvs41.put (yyval41, yyvsp41)
end
		end

	yy_do_action_370 is
			--|#line 2154 "eiffel.y"
		local
			yyval75: ROUTINE_CREATION_AS
		do
--|#line 2154 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2154")
end

			yyval75 := ast_factory.new_agent_routine_creation_as (
				Void, yyvs2.item (yyvsp2), yyvs105.item (yyvsp105), False, yyvs12.item (yyvsp12), Void)
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp75 := yyvsp75 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp2 := yyvsp2 -1
	yyvsp105 := yyvsp105 -1
	if yyvsp75 >= yyvsc75 then
		if yyvs75 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs75")
			end
			create yyspecial_routines75
			yyvsc75 := yyInitial_yyvs_size
			yyvs75 := yyspecial_routines75.make (yyvsc75)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs75")
			end
			yyvsc75 := yyvsc75 + yyInitial_yyvs_size
			yyvs75 := yyspecial_routines75.resize (yyvs75, yyvsc75)
		end
	end
	yyvs75.put (yyval75, yyvsp75)
end
		end

	yy_do_action_371 is
			--|#line 2159 "eiffel.y"
		local
			yyval75: ROUTINE_CREATION_AS
		do
--|#line 2159 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2159")
end

			if yyvs24.item (yyvsp24) /= Void then
				yyval75 := ast_factory.new_agent_routine_creation_as (yyvs24.item (yyvsp24).operand, yyvs2.item (yyvsp2), yyvs105.item (yyvsp105), True, yyvs12.item (yyvsp12), yyvs4.item (yyvsp4))
				if yyval75 /= Void then
					yyval75.set_lparan_symbol (yyvs24.item (yyvsp24).lparan_symbol)
					yyval75.set_rparan_symbol (yyvs24.item (yyvsp24).rparan_symbol)
				end
			else
				yyval75 := ast_factory.new_agent_routine_creation_as (Void, yyvs2.item (yyvsp2), yyvs105.item (yyvsp105), True, yyvs12.item (yyvsp12), yyvs4.item (yyvsp4))
			end
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp75 := yyvsp75 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp24 := yyvsp24 -1
	yyvsp4 := yyvsp4 -1
	yyvsp2 := yyvsp2 -1
	yyvsp105 := yyvsp105 -1
	if yyvsp75 >= yyvsc75 then
		if yyvs75 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs75")
			end
			create yyspecial_routines75
			yyvsc75 := yyInitial_yyvs_size
			yyvs75 := yyspecial_routines75.make (yyvsc75)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs75")
			end
			yyvsc75 := yyvsc75 + yyInitial_yyvs_size
			yyvs75 := yyspecial_routines75.resize (yyvs75, yyvsc75)
		end
	end
	yyvs75.put (yyval75, yyvsp75)
end
		end

	yy_do_action_372 is
			--|#line 2171 "eiffel.y"
		local
			yyval75: ROUTINE_CREATION_AS
		do
--|#line 2171 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2171")
end

			if yyvs77.item (yyvsp77) /= Void then
				yyval75 := yyvs77.item (yyvsp77).first
				report_warning(parser_errors.tilda_use_warning, void)
			end
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp75 := yyvsp75 + 1
	yyvsp77 := yyvsp77 -1
	if yyvsp75 >= yyvsc75 then
		if yyvs75 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs75")
			end
			create yyspecial_routines75
			yyvsc75 := yyInitial_yyvs_size
			yyvs75 := yyspecial_routines75.make (yyvsc75)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs75")
			end
			yyvsc75 := yyvsc75 + yyInitial_yyvs_size
			yyvs75 := yyspecial_routines75.resize (yyvs75, yyvsc75)
		end
	end
	yyvs75.put (yyval75, yyvsp75)
end
		end

	yy_do_action_373 is
			--|#line 2187 "eiffel.y"
		local
			yyval77: PAIR [ROUTINE_CREATION_AS, LOCATION_AS]
		do
--|#line 2187 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2187")
end

			yyval77 := ast_factory.new_old_routine_creation_as (yyvs2.item (yyvsp2), Void, yyvs2.item (yyvsp2), yyvs105.item (yyvsp105), False, yyvs4.item (yyvsp4))
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp77 := yyvsp77 + 1
	yyvsp4 := yyvsp4 -1
	yyvsp2 := yyvsp2 -1
	yyvsp105 := yyvsp105 -1
	if yyvsp77 >= yyvsc77 then
		if yyvs77 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs77")
			end
			create yyspecial_routines77
			yyvsc77 := yyInitial_yyvs_size
			yyvs77 := yyspecial_routines77.make (yyvsc77)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs77")
			end
			yyvsc77 := yyvsc77 + yyInitial_yyvs_size
			yyvs77 := yyspecial_routines77.resize (yyvs77, yyvsc77)
		end
	end
	yyvs77.put (yyval77, yyvsp77)
end
		end

	yy_do_action_374 is
			--|#line 2191 "eiffel.y"
		local
			yyval77: PAIR [ROUTINE_CREATION_AS, LOCATION_AS]
		do
--|#line 2191 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2191")
end

			yyval77 := ast_factory.new_old_routine_creation_as (yyvs2.item (yyvsp2 - 1), ast_factory.new_operand_as (Void, ast_factory.new_access_id_as (yyvs2.item (yyvsp2 - 1), Void), Void), yyvs2.item (yyvsp2), yyvs105.item (yyvsp105), True, yyvs4.item (yyvsp4))
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp77 := yyvsp77 + 1
	yyvsp2 := yyvsp2 -2
	yyvsp4 := yyvsp4 -1
	yyvsp105 := yyvsp105 -1
	if yyvsp77 >= yyvsc77 then
		if yyvs77 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs77")
			end
			create yyspecial_routines77
			yyvsc77 := yyInitial_yyvs_size
			yyvs77 := yyspecial_routines77.make (yyvsc77)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs77")
			end
			yyvsc77 := yyvsc77 + yyInitial_yyvs_size
			yyvs77 := yyspecial_routines77.resize (yyvs77, yyvsc77)
		end
	end
	yyvs77.put (yyval77, yyvsp77)
end
		end

	yy_do_action_375 is
			--|#line 2195 "eiffel.y"
		local
			yyval77: PAIR [ROUTINE_CREATION_AS, LOCATION_AS]
		do
--|#line 2195 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2195")
end

			yyval77 := ast_factory.new_old_routine_creation_as (yyvs48.item (yyvsp48), ast_factory.new_operand_as (Void, Void, yyvs48.item (yyvsp48)), yyvs2.item (yyvsp2), yyvs105.item (yyvsp105), True, yyvs4.item (yyvsp4))
			if yyval77 /= Void and then yyval77.first /= Void	then
				yyval77.first.set_lparan_symbol (yyvs4.item (yyvsp4 - 2))
				yyval77.first.set_rparan_symbol (yyvs4.item (yyvsp4 - 1))
			end
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 6
	yyvsp77 := yyvsp77 + 1
	yyvsp4 := yyvsp4 -3
	yyvsp48 := yyvsp48 -1
	yyvsp2 := yyvsp2 -1
	yyvsp105 := yyvsp105 -1
	if yyvsp77 >= yyvsc77 then
		if yyvs77 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs77")
			end
			create yyspecial_routines77
			yyvsc77 := yyInitial_yyvs_size
			yyvs77 := yyspecial_routines77.make (yyvsc77)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs77")
			end
			yyvsc77 := yyvsc77 + yyInitial_yyvs_size
			yyvs77 := yyspecial_routines77.resize (yyvs77, yyvsc77)
		end
	end
	yyvs77.put (yyval77, yyvsp77)
end
		end

	yy_do_action_376 is
			--|#line 2203 "eiffel.y"
		local
			yyval77: PAIR [ROUTINE_CREATION_AS, LOCATION_AS]
		do
--|#line 2203 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2203")
end

			yyval77 := ast_factory.new_old_routine_creation_as (yyvs2.item (yyvsp2), ast_factory.new_operand_as (Void, yyvs6.item (yyvsp6), Void), yyvs2.item (yyvsp2), yyvs105.item (yyvsp105), True, yyvs4.item (yyvsp4))
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp77 := yyvsp77 + 1
	yyvsp6 := yyvsp6 -1
	yyvsp4 := yyvsp4 -1
	yyvsp2 := yyvsp2 -1
	yyvsp105 := yyvsp105 -1
	if yyvsp77 >= yyvsc77 then
		if yyvs77 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs77")
			end
			create yyspecial_routines77
			yyvsc77 := yyInitial_yyvs_size
			yyvs77 := yyspecial_routines77.make (yyvsc77)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs77")
			end
			yyvsc77 := yyvsc77 + yyInitial_yyvs_size
			yyvs77 := yyspecial_routines77.resize (yyvs77, yyvsc77)
		end
	end
	yyvs77.put (yyval77, yyvsp77)
end
		end

	yy_do_action_377 is
			--|#line 2207 "eiffel.y"
		local
			yyval77: PAIR [ROUTINE_CREATION_AS, LOCATION_AS]
		do
--|#line 2207 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2207")
end

			yyval77 := ast_factory.new_old_routine_creation_as (yyvs2.item (yyvsp2), ast_factory.new_operand_as (Void, yyvs9.item (yyvsp9), Void), yyvs2.item (yyvsp2), yyvs105.item (yyvsp105), True, yyvs4.item (yyvsp4))
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp77 := yyvsp77 + 1
	yyvsp9 := yyvsp9 -1
	yyvsp4 := yyvsp4 -1
	yyvsp2 := yyvsp2 -1
	yyvsp105 := yyvsp105 -1
	if yyvsp77 >= yyvsc77 then
		if yyvs77 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs77")
			end
			create yyspecial_routines77
			yyvsc77 := yyInitial_yyvs_size
			yyvs77 := yyspecial_routines77.make (yyvsc77)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs77")
			end
			yyvsc77 := yyvsc77 + yyInitial_yyvs_size
			yyvs77 := yyspecial_routines77.resize (yyvs77, yyvsc77)
		end
	end
	yyvs77.put (yyval77, yyvsp77)
end
		end

	yy_do_action_378 is
			--|#line 2211 "eiffel.y"
		local
			yyval77: PAIR [ROUTINE_CREATION_AS, LOCATION_AS]
		do
--|#line 2211 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2211")
end

			if yyvs79.item (yyvsp79) /= Void then
				yyvs79.item (yyvsp79).set_lcurly_symbol (yyvs4.item (yyvsp4 - 1))
			end
			yyval77 := ast_factory.new_old_routine_creation_as (yyvs79.item (yyvsp79), ast_factory.new_operand_as (yyvs79.item (yyvsp79), Void, Void), yyvs2.item (yyvsp2), yyvs105.item (yyvsp105), True, yyvs4.item (yyvsp4))
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp77 := yyvsp77 + 1
	yyvsp4 := yyvsp4 -2
	yyvsp79 := yyvsp79 -1
	yyvsp2 := yyvsp2 -1
	yyvsp105 := yyvsp105 -1
	if yyvsp77 >= yyvsc77 then
		if yyvs77 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs77")
			end
			create yyspecial_routines77
			yyvsc77 := yyInitial_yyvs_size
			yyvs77 := yyspecial_routines77.make (yyvsc77)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs77")
			end
			yyvsc77 := yyvsc77 + yyInitial_yyvs_size
			yyvs77 := yyspecial_routines77.resize (yyvs77, yyvsc77)
		end
	end
	yyvs77.put (yyval77, yyvsp77)
end
		end

	yy_do_action_379 is
			--|#line 2218 "eiffel.y"
		local
			yyval77: PAIR [ROUTINE_CREATION_AS, LOCATION_AS]
		do
--|#line 2218 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2218")
end

			temp_operand_as := ast_factory.new_operand_as (Void, Void, Void)
			if temp_operand_as /= Void then
				temp_operand_as.set_question_mark_symbol (yyvs4.item (yyvsp4 - 1))
			end
			yyval77 := ast_factory.new_old_routine_creation_as (yyvs2.item (yyvsp2), temp_operand_as, yyvs2.item (yyvsp2), yyvs105.item (yyvsp105), True, yyvs4.item (yyvsp4))
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp77 := yyvsp77 + 1
	yyvsp4 := yyvsp4 -2
	yyvsp2 := yyvsp2 -1
	yyvsp105 := yyvsp105 -1
	if yyvsp77 >= yyvsc77 then
		if yyvs77 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs77")
			end
			create yyspecial_routines77
			yyvsc77 := yyInitial_yyvs_size
			yyvs77 := yyspecial_routines77.make (yyvsc77)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs77")
			end
			yyvsc77 := yyvsc77 + yyInitial_yyvs_size
			yyvs77 := yyspecial_routines77.resize (yyvs77, yyvsc77)
		end
	end
	yyvs77.put (yyval77, yyvsp77)
end
		end

	yy_do_action_380 is
			--|#line 2228 "eiffel.y"
		local
			yyval24: AGENT_TARGET_TRIPLE
		do
--|#line 2228 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2228")
end

yyval24 := ast_factory.new_agent_target_triple (Void, Void, ast_factory.new_operand_as (Void, ast_factory.new_access_id_as (yyvs2.item (yyvsp2), Void), Void)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp24 := yyvsp24 + 1
	yyvsp2 := yyvsp2 -1
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
		end

	yy_do_action_381 is
			--|#line 2230 "eiffel.y"
		local
			yyval24: AGENT_TARGET_TRIPLE
		do
--|#line 2230 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2230")
end

yyval24 := ast_factory.new_agent_target_triple (yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4), ast_factory.new_operand_as (Void, Void, yyvs48.item (yyvsp48))) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp24 := yyvsp24 + 1
	yyvsp4 := yyvsp4 -2
	yyvsp48 := yyvsp48 -1
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
		end

	yy_do_action_382 is
			--|#line 2232 "eiffel.y"
		local
			yyval24: AGENT_TARGET_TRIPLE
		do
--|#line 2232 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2232")
end

yyval24 := ast_factory.new_agent_target_triple (Void, Void, ast_factory.new_operand_as (Void, yyvs6.item (yyvsp6), Void)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp24 := yyvsp24 + 1
	yyvsp6 := yyvsp6 -1
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
		end

	yy_do_action_383 is
			--|#line 2234 "eiffel.y"
		local
			yyval24: AGENT_TARGET_TRIPLE
		do
--|#line 2234 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2234")
end

yyval24 := ast_factory.new_agent_target_triple (Void, Void, ast_factory.new_operand_as (Void, yyvs9.item (yyvsp9), Void)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp24 := yyvsp24 + 1
	yyvsp9 := yyvsp9 -1
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
		end

	yy_do_action_384 is
			--|#line 2236 "eiffel.y"
		local
			yyval24: AGENT_TARGET_TRIPLE
		do
--|#line 2236 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2236")
end

yyval24 := ast_factory.new_agent_target_triple (Void, Void, ast_factory.new_operand_as (yyvs79.item (yyvsp79), Void, Void))
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp24 := yyvsp24 + 1
	yyvsp79 := yyvsp79 -1
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
		end

	yy_do_action_385 is
			--|#line 2238 "eiffel.y"
		local
			yyval24: AGENT_TARGET_TRIPLE
		do
--|#line 2238 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2238")
end

			temp_operand_as := ast_factory.new_operand_as (Void, Void, Void)
			if temp_operand_as /= Void then
				temp_operand_as.set_question_mark_symbol (yyvs4.item (yyvsp4))
			end
			yyval24 := ast_factory.new_agent_target_triple (Void, Void, temp_operand_as)
		
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp24 := yyvsp24 + 1
	yyvsp4 := yyvsp4 -1
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
		end

	yy_do_action_386 is
			--|#line 2248 "eiffel.y"
		local
			yyval105: DELAYED_ACTUAL_LIST_AS
		do
--|#line 2248 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2248")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp105 := yyvsp105 + 1
	if yyvsp105 >= yyvsc105 then
		if yyvs105 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs105")
			end
			create yyspecial_routines105
			yyvsc105 := yyInitial_yyvs_size
			yyvs105 := yyspecial_routines105.make (yyvsc105)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs105")
			end
			yyvsc105 := yyvsc105 + yyInitial_yyvs_size
			yyvs105 := yyspecial_routines105.resize (yyvs105, yyvsc105)
		end
	end
	yyvs105.put (yyval105, yyvsp105)
end
		end

	yy_do_action_387 is
			--|#line 2250 "eiffel.y"
		local
			yyval105: DELAYED_ACTUAL_LIST_AS
		do
--|#line 2250 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2250")
end

				yyval105 := ast_factory.new_delayed_actual_list_as (Void, yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4)) 
				report_warning (parser_errors.empty_parenthesis_warning, yyvs4.item (yyvsp4 - 1))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp105 := yyvsp105 + 1
	yyvsp4 := yyvsp4 -2
	if yyvsp105 >= yyvsc105 then
		if yyvs105 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs105")
			end
			create yyspecial_routines105
			yyvsc105 := yyInitial_yyvs_size
			yyvs105 := yyspecial_routines105.make (yyvsc105)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs105")
			end
			yyvsc105 := yyvsc105 + yyInitial_yyvs_size
			yyvs105 := yyspecial_routines105.resize (yyvs105, yyvsc105)
		end
	end
	yyvs105.put (yyval105, yyvsp105)
end
		end

	yy_do_action_388 is
			--|#line 2255 "eiffel.y"
		local
			yyval105: DELAYED_ACTUAL_LIST_AS
		do
--|#line 2255 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2255")
end

yyval105 := ast_factory.new_delayed_actual_list_as (yyvs104.item (yyvsp104), yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp105 := yyvsp105 + 1
	yyvsp4 := yyvsp4 -2
	yyvsp1 := yyvsp1 -2
	yyvsp104 := yyvsp104 -1
	if yyvsp105 >= yyvsc105 then
		if yyvs105 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs105")
			end
			create yyspecial_routines105
			yyvsc105 := yyInitial_yyvs_size
			yyvs105 := yyspecial_routines105.make (yyvsc105)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs105")
			end
			yyvsc105 := yyvsc105 + yyInitial_yyvs_size
			yyvs105 := yyspecial_routines105.resize (yyvs105, yyvsc105)
		end
	end
	yyvs105.put (yyval105, yyvsp105)
end
		end

	yy_do_action_389 is
			--|#line 2259 "eiffel.y"
		local
			yyval104: EIFFEL_LIST [OPERAND_AS]
		do
--|#line 2259 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2259")
end

				yyval104 := ast_factory.new_eiffel_list_operand_as (counter_value + 1)
				if yyval104 /= Void and yyvs65.item (yyvsp65) /= Void then
					yyval104.reverse_extend (yyvs65.item (yyvsp65))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp104 := yyvsp104 + 1
	yyvsp65 := yyvsp65 -1
	if yyvsp104 >= yyvsc104 then
		if yyvs104 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs104")
			end
			create yyspecial_routines104
			yyvsc104 := yyInitial_yyvs_size
			yyvs104 := yyspecial_routines104.make (yyvsc104)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs104")
			end
			yyvsc104 := yyvsc104 + yyInitial_yyvs_size
			yyvs104 := yyspecial_routines104.resize (yyvs104, yyvsc104)
		end
	end
	yyvs104.put (yyval104, yyvsp104)
end
		end

	yy_do_action_390 is
			--|#line 2266 "eiffel.y"
		local
			yyval104: EIFFEL_LIST [OPERAND_AS]
		do
--|#line 2266 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2266")
end

				yyval104 := yyvs104.item (yyvsp104)
				if yyval104 /= Void and yyvs65.item (yyvsp65) /= Void then
					yyval104.reverse_extend (yyvs65.item (yyvsp65))
					ast_factory.reverse_extend_separator (yyval104, yyvs4.item (yyvsp4))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp104 := yyvsp104 -1
	yyvsp65 := yyvsp65 -1
	yyvsp4 := yyvsp4 -1
	yyvs104.put (yyval104, yyvsp104)
end
		end

	yy_do_action_391 is
			--|#line 2266 "eiffel.y"
		local
			yyval104: EIFFEL_LIST [OPERAND_AS]
		do
--|#line 2266 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2266")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp104 := yyvsp104 + 1
	if yyvsp104 >= yyvsc104 then
		if yyvs104 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs104")
			end
			create yyspecial_routines104
			yyvsc104 := yyInitial_yyvs_size
			yyvs104 := yyspecial_routines104.make (yyvsc104)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs104")
			end
			yyvsc104 := yyvsc104 + yyInitial_yyvs_size
			yyvs104 := yyspecial_routines104.resize (yyvs104, yyvsc104)
		end
	end
	yyvs104.put (yyval104, yyvsp104)
end
		end

	yy_do_action_392 is
			--|#line 2276 "eiffel.y"
		local
			yyval65: OPERAND_AS
		do
--|#line 2276 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2276")
end

yyval65 := ast_factory.new_operand_as (Void, Void, Void)
				if yyval65 /= Void then
					yyval65.set_question_mark_symbol (yyvs4.item (yyvsp4))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp65 := yyvsp65 + 1
	yyvsp4 := yyvsp4 -1
	if yyvsp65 >= yyvsc65 then
		if yyvs65 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs65")
			end
			create yyspecial_routines65
			yyvsc65 := yyInitial_yyvs_size
			yyvs65 := yyspecial_routines65.make (yyvsc65)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs65")
			end
			yyvsc65 := yyvsc65 + yyInitial_yyvs_size
			yyvs65 := yyspecial_routines65.resize (yyvs65, yyvsc65)
		end
	end
	yyvs65.put (yyval65, yyvsp65)
end
		end

	yy_do_action_393 is
			--|#line 2286 "eiffel.y"
		local
			yyval65: OPERAND_AS
		do
--|#line 2286 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2286")
end

yyval65 := ast_factory.new_operand_as (yyvs79.item (yyvsp79), Void, Void)
				if yyval65 /= Void then
					yyval65.set_question_mark_symbol (yyvs4.item (yyvsp4))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp65 := yyvsp65 + 1
	yyvsp79 := yyvsp79 -1
	yyvsp4 := yyvsp4 -1
	if yyvsp65 >= yyvsc65 then
		if yyvs65 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs65")
			end
			create yyspecial_routines65
			yyvsc65 := yyInitial_yyvs_size
			yyvs65 := yyspecial_routines65.make (yyvsc65)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs65")
			end
			yyvsc65 := yyvsc65 + yyInitial_yyvs_size
			yyvs65 := yyspecial_routines65.resize (yyvs65, yyvsc65)
		end
	end
	yyvs65.put (yyval65, yyvsp65)
end
		end

	yy_do_action_394 is
			--|#line 2292 "eiffel.y"
		local
			yyval65: OPERAND_AS
		do
--|#line 2292 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2292")
end

yyval65 := ast_factory.new_operand_as (Void, Void, yyvs48.item (yyvsp48)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp65 := yyvsp65 + 1
	yyvsp48 := yyvsp48 -1
	if yyvsp65 >= yyvsc65 then
		if yyvs65 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs65")
			end
			create yyspecial_routines65
			yyvsc65 := yyInitial_yyvs_size
			yyvs65 := yyspecial_routines65.make (yyvsc65)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs65")
			end
			yyvsc65 := yyvsc65 + yyInitial_yyvs_size
			yyvs65 := yyspecial_routines65.resize (yyvs65, yyvsc65)
		end
	end
	yyvs65.put (yyval65, yyvsp65)
end
		end

	yy_do_action_395 is
			--|#line 2296 "eiffel.y"
		local
			yyval42: CREATION_AS
		do
--|#line 2296 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2296")
end

				yyval42 := ast_factory.new_bang_creation_as (Void, yyvs25.item (yyvsp25), yyvs27.item (yyvsp27), yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4))
				report_warning (parser_errors.bang_bang_use_warning, yyvs4.item (yyvsp4 - 1))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp42 := yyvsp42 + 1
	yyvsp4 := yyvsp4 -2
	yyvsp25 := yyvsp25 -1
	yyvsp27 := yyvsp27 -1
	if yyvsp42 >= yyvsc42 then
		if yyvs42 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs42")
			end
			create yyspecial_routines42
			yyvsc42 := yyInitial_yyvs_size
			yyvs42 := yyspecial_routines42.make (yyvsc42)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs42")
			end
			yyvsc42 := yyvsc42 + yyInitial_yyvs_size
			yyvs42 := yyspecial_routines42.resize (yyvs42, yyvsc42)
		end
	end
	yyvs42.put (yyval42, yyvsp42)
end
		end

	yy_do_action_396 is
			--|#line 2301 "eiffel.y"
		local
			yyval42: CREATION_AS
		do
--|#line 2301 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2301")
end

				yyval42 := ast_factory.new_bang_creation_as (yyvs79.item (yyvsp79), yyvs25.item (yyvsp25), yyvs27.item (yyvsp27), yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4))
				report_warning (parser_errors.bang_type_bang_use_warning, yyvs4.item (yyvsp4 - 1))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp42 := yyvsp42 + 1
	yyvsp4 := yyvsp4 -2
	yyvsp79 := yyvsp79 -1
	yyvsp25 := yyvsp25 -1
	yyvsp27 := yyvsp27 -1
	if yyvsp42 >= yyvsc42 then
		if yyvs42 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs42")
			end
			create yyspecial_routines42
			yyvsc42 := yyInitial_yyvs_size
			yyvs42 := yyspecial_routines42.make (yyvsc42)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs42")
			end
			yyvsc42 := yyvsc42 + yyInitial_yyvs_size
			yyvs42 := yyspecial_routines42.resize (yyvs42, yyvsc42)
		end
	end
	yyvs42.put (yyval42, yyvsp42)
end
		end

	yy_do_action_397 is
			--|#line 2306 "eiffel.y"
		local
			yyval42: CREATION_AS
		do
--|#line 2306 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2306")
end

yyval42 := ast_factory.new_create_creation_as (Void, yyvs25.item (yyvsp25), yyvs27.item (yyvsp27), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp42 := yyvsp42 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp25 := yyvsp25 -1
	yyvsp27 := yyvsp27 -1
	if yyvsp42 >= yyvsc42 then
		if yyvs42 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs42")
			end
			create yyspecial_routines42
			yyvsc42 := yyInitial_yyvs_size
			yyvs42 := yyspecial_routines42.make (yyvsc42)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs42")
			end
			yyvsc42 := yyvsc42 + yyInitial_yyvs_size
			yyvs42 := yyspecial_routines42.resize (yyvs42, yyvsc42)
		end
	end
	yyvs42.put (yyval42, yyvsp42)
end
		end

	yy_do_action_398 is
			--|#line 2308 "eiffel.y"
		local
			yyval42: CREATION_AS
		do
--|#line 2308 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2308")
end

yyval42 := ast_factory.new_create_creation_as (yyvs79.item (yyvsp79), yyvs25.item (yyvsp25), yyvs27.item (yyvsp27), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp42 := yyvsp42 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp79 := yyvsp79 -1
	yyvsp25 := yyvsp25 -1
	yyvsp27 := yyvsp27 -1
	if yyvsp42 >= yyvsc42 then
		if yyvs42 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs42")
			end
			create yyspecial_routines42
			yyvsc42 := yyInitial_yyvs_size
			yyvs42 := yyspecial_routines42.make (yyvsc42)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs42")
			end
			yyvsc42 := yyvsc42 + yyInitial_yyvs_size
			yyvs42 := yyspecial_routines42.resize (yyvs42, yyvsc42)
		end
	end
	yyvs42.put (yyval42, yyvsp42)
end
		end

	yy_do_action_399 is
			--|#line 2312 "eiffel.y"
		local
			yyval43: CREATION_EXPR_AS
		do
--|#line 2312 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2312")
end

yyval43 := ast_factory.new_create_creation_expr_as (yyvs79.item (yyvsp79), yyvs27.item (yyvsp27), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp43 := yyvsp43 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp79 := yyvsp79 -1
	yyvsp27 := yyvsp27 -1
	if yyvsp43 >= yyvsc43 then
		if yyvs43 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs43")
			end
			create yyspecial_routines43
			yyvsc43 := yyInitial_yyvs_size
			yyvs43 := yyspecial_routines43.make (yyvsc43)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs43")
			end
			yyvsc43 := yyvsc43 + yyInitial_yyvs_size
			yyvs43 := yyspecial_routines43.resize (yyvs43, yyvsc43)
		end
	end
	yyvs43.put (yyval43, yyvsp43)
end
		end

	yy_do_action_400 is
			--|#line 2314 "eiffel.y"
		local
			yyval43: CREATION_EXPR_AS
		do
--|#line 2314 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2314")
end

				yyval43 := ast_factory.new_bang_creation_expr_as (yyvs79.item (yyvsp79), yyvs27.item (yyvsp27), yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4))
				report_warning (parser_errors.bang_type_bang_use_warning, yyvs4.item (yyvsp4 - 1))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp43 := yyvsp43 + 1
	yyvsp4 := yyvsp4 -2
	yyvsp79 := yyvsp79 -1
	yyvsp27 := yyvsp27 -1
	if yyvsp43 >= yyvsc43 then
		if yyvs43 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs43")
			end
			create yyspecial_routines43
			yyvsc43 := yyInitial_yyvs_size
			yyvs43 := yyspecial_routines43.make (yyvsc43)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs43")
			end
			yyvsc43 := yyvsc43 + yyInitial_yyvs_size
			yyvs43 := yyspecial_routines43.resize (yyvs43, yyvsc43)
		end
	end
	yyvs43.put (yyval43, yyvsp43)
end
		end

	yy_do_action_401 is
			--|#line 2321 "eiffel.y"
		local
			yyval25: ACCESS_AS
		do
--|#line 2321 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2321")
end

yyval25 := ast_factory.new_access_id_as (yyvs2.item (yyvsp2), Void) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp25 := yyvsp25 + 1
	yyvsp2 := yyvsp2 -1
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
		end

	yy_do_action_402 is
			--|#line 2323 "eiffel.y"
		local
			yyval25: ACCESS_AS
		do
--|#line 2323 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2323")
end

yyval25 := yyvs6.item (yyvsp6) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp25 := yyvsp25 + 1
	yyvsp6 := yyvsp6 -1
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
		end

	yy_do_action_403 is
			--|#line 2327 "eiffel.y"
		local
			yyval27: ACCESS_INV_AS
		do
--|#line 2327 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2327")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp27 := yyvsp27 + 1
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
		end

	yy_do_action_404 is
			--|#line 2329 "eiffel.y"
		local
			yyval27: ACCESS_INV_AS
		do
--|#line 2329 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2329")
end

yyval27 := ast_factory.new_access_inv_as (yyvs2.item (yyvsp2), yyvs92.item (yyvsp92), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp27 := yyvsp27 + 1
	yyvsp4 := yyvsp4 -1
	yyvsp2 := yyvsp2 -1
	yyvsp92 := yyvsp92 -1
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
		end

	yy_do_action_405 is
			--|#line 2337 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2337 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2337")
end

yyval35 := yyvs25.item (yyvsp25) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp35 := yyvsp35 + 1
	yyvsp25 := yyvsp25 -1
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
		end

	yy_do_action_406 is
			--|#line 2339 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2339 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2339")
end

yyval35 := yyvs67.item (yyvsp67) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp35 := yyvsp35 + 1
	yyvsp67 := yyvsp67 -1
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
		end

	yy_do_action_407 is
			--|#line 2341 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2341 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2341")
end

yyval35 := yyvs68.item (yyvsp68) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp35 := yyvsp35 + 1
	yyvsp68 := yyvsp68 -1
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
		end

	yy_do_action_408 is
			--|#line 2343 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2343 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2343")
end

yyval35 := yyvs35.item (yyvsp35) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs35.put (yyval35, yyvsp35)
end
		end

	yy_do_action_409 is
			--|#line 2347 "eiffel.y"
		local
			yyval37: CHECK_AS
		do
--|#line 2347 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2347")
end

yyval37 := ast_factory.new_check_as (yyvs22.item (yyvsp22), yyvs12.item (yyvsp12 - 1), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp37 := yyvsp37 + 1
	yyvsp12 := yyvsp12 -2
	yyvsp22 := yyvsp22 -1
	if yyvsp37 >= yyvsc37 then
		if yyvs37 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs37")
			end
			create yyspecial_routines37
			yyvsc37 := yyInitial_yyvs_size
			yyvs37 := yyspecial_routines37.make (yyvsc37)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs37")
			end
			yyvsc37 := yyvsc37 + yyInitial_yyvs_size
			yyvs37 := yyspecial_routines37.resize (yyvs37, yyvsc37)
		end
	end
	yyvs37.put (yyval37, yyvsp37)
end
		end

	yy_do_action_410 is
			--|#line 2354 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 2354 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2354")
end

yyval79 := yyvs79.item (yyvsp79)
				if yyval79 /= Void then
					yyval79.set_lcurly_symbol (yyvs4.item (yyvsp4 - 1))
					yyval79.set_rcurly_symbol (yyvs4.item (yyvsp4))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp4 := yyvsp4 -2
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_411 is
			--|#line 2363 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2363 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2363")
end

yyval48 := yyvs59.item (yyvsp59); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp48 := yyvsp48 + 1
	yyvsp59 := yyvsp59 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_412 is
			--|#line 2366 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2366 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2366")
end

yyval48 := yyvs69.item (yyvsp69); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp48 := yyvsp48 + 1
	yyvsp69 := yyvsp69 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_413 is
			--|#line 2368 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2368 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2368")
end

yyval48 := yyvs48.item (yyvsp48) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_414 is
			--|#line 2370 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2370 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2370")
end

yyval48 := yyvs48.item (yyvsp48); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_415 is
			--|#line 2372 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2372 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2372")
end

yyval48 := ast_factory.new_bin_eq_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp48 := yyvsp48 -1
	yyvsp4 := yyvsp4 -1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_416 is
			--|#line 2374 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2374 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2374")
end

yyval48 := ast_factory.new_bin_ne_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp48 := yyvsp48 -1
	yyvsp4 := yyvsp4 -1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_417 is
			--|#line 2376 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2376 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2376")
end

yyval48 := yyvs32.item (yyvsp32); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp48 := yyvsp48 + 1
	yyvsp32 := yyvsp32 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_418 is
			--|#line 2380 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2380 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2380")
end

yyval32 := ast_factory.new_bin_plus_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp32 := yyvsp32 + 1
	yyvsp48 := yyvsp48 -2
	yyvsp4 := yyvsp4 -1
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
		end

	yy_do_action_419 is
			--|#line 2383 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2383 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2383")
end

yyval32 := ast_factory.new_bin_minus_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp32 := yyvsp32 + 1
	yyvsp48 := yyvsp48 -2
	yyvsp4 := yyvsp4 -1
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
		end

	yy_do_action_420 is
			--|#line 2385 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2385 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2385")
end

yyval32 := ast_factory.new_bin_star_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp32 := yyvsp32 + 1
	yyvsp48 := yyvsp48 -2
	yyvsp4 := yyvsp4 -1
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
		end

	yy_do_action_421 is
			--|#line 2387 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2387 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2387")
end

yyval32 := ast_factory.new_bin_slash_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp32 := yyvsp32 + 1
	yyvsp48 := yyvsp48 -2
	yyvsp4 := yyvsp4 -1
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
		end

	yy_do_action_422 is
			--|#line 2389 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2389 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2389")
end

yyval32 := ast_factory.new_bin_mod_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp32 := yyvsp32 + 1
	yyvsp48 := yyvsp48 -2
	yyvsp4 := yyvsp4 -1
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
		end

	yy_do_action_423 is
			--|#line 2391 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2391 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2391")
end

yyval32 := ast_factory.new_bin_div_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp32 := yyvsp32 + 1
	yyvsp48 := yyvsp48 -2
	yyvsp4 := yyvsp4 -1
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
		end

	yy_do_action_424 is
			--|#line 2393 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2393 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2393")
end

yyval32 := ast_factory.new_bin_power_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp32 := yyvsp32 + 1
	yyvsp48 := yyvsp48 -2
	yyvsp4 := yyvsp4 -1
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
		end

	yy_do_action_425 is
			--|#line 2395 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2395 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2395")
end

yyval32 := ast_factory.new_bin_and_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp32 := yyvsp32 + 1
	yyvsp48 := yyvsp48 -2
	yyvsp12 := yyvsp12 -1
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
		end

	yy_do_action_426 is
			--|#line 2397 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2397 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2397")
end

yyval32 := ast_factory.new_bin_and_then_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs12.item (yyvsp12 - 1), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp32 := yyvsp32 + 1
	yyvsp48 := yyvsp48 -2
	yyvsp12 := yyvsp12 -2
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
		end

	yy_do_action_427 is
			--|#line 2399 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2399 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2399")
end

yyval32 := ast_factory.new_bin_or_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp32 := yyvsp32 + 1
	yyvsp48 := yyvsp48 -2
	yyvsp12 := yyvsp12 -1
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
		end

	yy_do_action_428 is
			--|#line 2401 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2401 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2401")
end

yyval32 := ast_factory.new_bin_or_else_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48),yyvs12.item (yyvsp12 - 1), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp32 := yyvsp32 + 1
	yyvsp48 := yyvsp48 -2
	yyvsp12 := yyvsp12 -2
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
		end

	yy_do_action_429 is
			--|#line 2403 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2403 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2403")
end

yyval32 := ast_factory.new_bin_implies_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp32 := yyvsp32 + 1
	yyvsp48 := yyvsp48 -2
	yyvsp12 := yyvsp12 -1
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
		end

	yy_do_action_430 is
			--|#line 2405 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2405 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2405")
end

yyval32 := ast_factory.new_bin_xor_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp32 := yyvsp32 + 1
	yyvsp48 := yyvsp48 -2
	yyvsp12 := yyvsp12 -1
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
		end

	yy_do_action_431 is
			--|#line 2407 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2407 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2407")
end

yyval32 := ast_factory.new_bin_ge_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp32 := yyvsp32 + 1
	yyvsp48 := yyvsp48 -2
	yyvsp4 := yyvsp4 -1
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
		end

	yy_do_action_432 is
			--|#line 2409 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2409 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2409")
end

yyval32 := ast_factory.new_bin_gt_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp32 := yyvsp32 + 1
	yyvsp48 := yyvsp48 -2
	yyvsp4 := yyvsp4 -1
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
		end

	yy_do_action_433 is
			--|#line 2411 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2411 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2411")
end

yyval32 := ast_factory.new_bin_le_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp32 := yyvsp32 + 1
	yyvsp48 := yyvsp48 -2
	yyvsp4 := yyvsp4 -1
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
		end

	yy_do_action_434 is
			--|#line 2413 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2413 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2413")
end

yyval32 := ast_factory.new_bin_lt_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp32 := yyvsp32 + 1
	yyvsp48 := yyvsp48 -2
	yyvsp4 := yyvsp4 -1
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
		end

	yy_do_action_435 is
			--|#line 2415 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2415 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2415")
end

yyval32 := ast_factory.new_bin_free_as (yyvs48.item (yyvsp48 - 1), yyvs2.item (yyvsp2), yyvs48.item (yyvsp48)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp32 := yyvsp32 + 1
	yyvsp48 := yyvsp48 -2
	yyvsp2 := yyvsp2 -1
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
		end

	yy_do_action_436 is
			--|#line 2419 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2419 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2419")
end

yyval48 := yyvs11.item (yyvsp11); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp48 := yyvsp48 + 1
	yyvsp11 := yyvsp11 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_437 is
			--|#line 2421 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2421 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2421")
end

yyval48 := yyvs28.item (yyvsp28); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp48 := yyvsp48 + 1
	yyvsp28 := yyvsp28 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_438 is
			--|#line 2423 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2423 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2423")
end

yyval48 := yyvs75.item (yyvsp75); has_type := False 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp48 := yyvsp48 + 1
	yyvsp75 := yyvsp75 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_439 is
			--|#line 2425 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2425 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2425")
end

yyval48 := ast_factory.new_un_old_as (yyvs48.item (yyvsp48), yyvs12.item (yyvsp12)); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp12 := yyvsp12 -1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_440 is
			--|#line 2427 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2427 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2427")
end

				yyval48 := ast_factory.new_un_strip_as (yyvs20.item (yyvsp20), yyvs12.item (yyvsp12), yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4)); has_type := True
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp48 := yyvsp48 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp4 := yyvsp4 -2
	yyvsp20 := yyvsp20 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_441 is
			--|#line 2431 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2431 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2431")
end

yyval48 := ast_factory.new_address_as (yyvs83.item (yyvsp83), yyvs4.item (yyvsp4)); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp48 := yyvsp48 + 1
	yyvsp4 := yyvsp4 -1
	yyvsp83 := yyvsp83 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_442 is
			--|#line 2433 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2433 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2433")
end

				yyval48 := ast_factory.new_expr_address_as (yyvs48.item (yyvsp48), yyvs4.item (yyvsp4 - 2), yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4)); has_type := True
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp4 := yyvsp4 -3
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_443 is
			--|#line 2437 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2437 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2437")
end

				yyval48 := ast_factory.new_address_current_as (yyvs9.item (yyvsp9), yyvs4.item (yyvsp4)); has_type := True
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp48 := yyvsp48 + 1
	yyvsp4 := yyvsp4 -1
	yyvsp9 := yyvsp9 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_444 is
			--|#line 2441 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2441 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2441")
end

				yyval48 := ast_factory.new_address_result_as (yyvs6.item (yyvsp6), yyvs4.item (yyvsp4)); has_type := True
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp48 := yyvsp48 + 1
	yyvsp4 := yyvsp4 -1
	yyvsp6 := yyvsp6 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_445 is
			--|#line 2445 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2445 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2445")
end

yyval48 := yyvs48.item (yyvsp48) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_446 is
			--|#line 2447 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2447 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2447")
end

yyval48 := yyvs48.item (yyvsp48); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_447 is
			--|#line 2451 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2451 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2451")
end

yyval48 := ast_factory.new_bracket_as (yyvs48.item (yyvsp48), yyvs91.item (yyvsp91), yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 6
	yyvsp4 := yyvsp4 -2
	yyvsp1 := yyvsp1 -2
	yyvsp91 := yyvsp91 -1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_448 is
			--|#line 2454 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2454 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2454")
end

yyval48 := ast_factory.new_un_minus_as (yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp4 := yyvsp4 -1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_449 is
			--|#line 2456 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2456 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2456")
end

yyval48 := ast_factory.new_un_plus_as (yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp4 := yyvsp4 -1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_450 is
			--|#line 2458 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2458 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2458")
end

yyval48 := ast_factory.new_un_not_as (yyvs48.item (yyvsp48), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp12 := yyvsp12 -1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_451 is
			--|#line 2460 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2460 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2460")
end

yyval48 := ast_factory.new_un_free_as (yyvs2.item (yyvsp2), yyvs48.item (yyvsp48)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp2 := yyvsp2 -1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_452 is
			--|#line 2464 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2464 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2464")
end

yyval48 := ast_factory.new_type_expr_as (yyvs79.item (yyvsp79)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp48 := yyvsp48 + 1
	yyvsp79 := yyvsp79 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_453 is
			--|#line 2467 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2467 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2467")
end

yyval48 := yyvs59.item (yyvsp59) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp48 := yyvsp48 + 1
	yyvsp59 := yyvsp59 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_454 is
			--|#line 2469 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2469 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2469")
end

yyval48 := yyvs69.item (yyvsp69) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp48 := yyvsp48 + 1
	yyvsp69 := yyvsp69 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_455 is
			--|#line 2473 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2473 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2473")
end

				if not case_sensitive and yyvs2.item (yyvsp2) /= Void then
					yyvs2.item (yyvsp2).to_lower
				end
				yyval2 := yyvs2.item (yyvsp2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
		end

	yy_do_action_456 is
			--|#line 2485 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2485 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2485")
end

yyval35 := ast_factory.new_nested_as (yyvs9.item (yyvsp9), yyvs35.item (yyvsp35), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 -1
	yyvsp4 := yyvsp4 -1
	yyvs35.put (yyval35, yyvsp35)
end
		end

	yy_do_action_457 is
			--|#line 2488 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2488 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2488")
end

yyval35 := ast_factory.new_nested_as (yyvs6.item (yyvsp6), yyvs35.item (yyvsp35), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp6 := yyvsp6 -1
	yyvsp4 := yyvsp4 -1
	yyvs35.put (yyval35, yyvsp35)
end
		end

	yy_do_action_458 is
			--|#line 2490 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2490 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2490")
end

yyval35 := ast_factory.new_nested_as (yyvs25.item (yyvsp25), yyvs35.item (yyvsp35), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp25 := yyvsp25 -1
	yyvsp4 := yyvsp4 -1
	yyvs35.put (yyval35, yyvsp35)
end
		end

	yy_do_action_459 is
			--|#line 2492 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2492 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2492")
end

yyval35 := ast_factory.new_nested_expr_as (yyvs48.item (yyvsp48), yyvs35.item (yyvsp35), yyvs4.item (yyvsp4), yyvs4.item (yyvsp4 - 2), yyvs4.item (yyvsp4 - 1)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp4 := yyvsp4 -3
	yyvsp48 := yyvsp48 -1
	yyvs35.put (yyval35, yyvsp35)
end
		end

	yy_do_action_460 is
			--|#line 2494 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2494 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2494")
end

yyval35 := ast_factory.new_nested_as (yyvs67.item (yyvsp67), yyvs35.item (yyvsp35), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp67 := yyvsp67 -1
	yyvsp4 := yyvsp4 -1
	yyvs35.put (yyval35, yyvsp35)
end
		end

	yy_do_action_461 is
			--|#line 2496 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2496 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2496")
end

yyval35 := ast_factory.new_nested_as (yyvs68.item (yyvsp68), yyvs35.item (yyvsp35), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp68 := yyvsp68 -1
	yyvsp4 := yyvsp4 -1
	yyvs35.put (yyval35, yyvsp35)
end
		end

	yy_do_action_462 is
			--|#line 2500 "eiffel.y"
		local
			yyval67: PRECURSOR_AS
		do
--|#line 2500 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2500")
end

yyval67 := ast_factory.new_precursor_as (yyvs12.item (yyvsp12), Void, yyvs92.item (yyvsp92)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp67 := yyvsp67 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp92 := yyvsp92 -1
	if yyvsp67 >= yyvsc67 then
		if yyvs67 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs67")
			end
			create yyspecial_routines67
			yyvsc67 := yyInitial_yyvs_size
			yyvs67 := yyspecial_routines67.make (yyvsc67)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs67")
			end
			yyvsc67 := yyvsc67 + yyInitial_yyvs_size
			yyvs67 := yyspecial_routines67.resize (yyvs67, yyvsc67)
		end
	end
	yyvs67.put (yyval67, yyvsp67)
end
		end

	yy_do_action_463 is
			--|#line 2502 "eiffel.y"
		local
			yyval67: PRECURSOR_AS
		do
--|#line 2502 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2502")
end

				temp_class_type_as := ast_factory.new_class_type_as (yyvs2.item (yyvsp2), Void)
				if temp_class_type_as /= Void then
					temp_class_type_as.set_lcurly_symbol (yyvs4.item (yyvsp4 - 1))
					temp_class_type_as.set_rcurly_symbol (yyvs4.item (yyvsp4))
				end
				yyval67 := ast_factory.new_precursor_as (yyvs12.item (yyvsp12), temp_class_type_as, yyvs92.item (yyvsp92))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp67 := yyvsp67 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp4 := yyvsp4 -2
	yyvsp2 := yyvsp2 -1
	yyvsp92 := yyvsp92 -1
	if yyvsp67 >= yyvsc67 then
		if yyvs67 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs67")
			end
			create yyspecial_routines67
			yyvsc67 := yyInitial_yyvs_size
			yyvs67 := yyspecial_routines67.make (yyvsc67)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs67")
			end
			yyvsc67 := yyvsc67 + yyInitial_yyvs_size
			yyvs67 := yyspecial_routines67.resize (yyvs67, yyvsc67)
		end
	end
	yyvs67.put (yyval67, yyvsp67)
end
		end

	yy_do_action_464 is
			--|#line 2513 "eiffel.y"
		local
			yyval68: STATIC_ACCESS_AS
		do
--|#line 2513 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2513")
end

yyval68 := yyvs68.item (yyvsp68) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs68.put (yyval68, yyvsp68)
end
		end

	yy_do_action_465 is
			--|#line 2515 "eiffel.y"
		local
			yyval68: STATIC_ACCESS_AS
		do
--|#line 2515 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2515")
end

yyval68 := yyvs68.item (yyvsp68) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs68.put (yyval68, yyvsp68)
end
		end

	yy_do_action_466 is
			--|#line 2519 "eiffel.y"
		local
			yyval68: STATIC_ACCESS_AS
		do
--|#line 2519 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2519")
end

yyval68 := ast_factory.new_static_access_as (yyvs79.item (yyvsp79), yyvs2.item (yyvsp2), yyvs92.item (yyvsp92), Void, yyvs4.item (yyvsp4)); 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp68 := yyvsp68 + 1
	yyvsp79 := yyvsp79 -1
	yyvsp4 := yyvsp4 -1
	yyvsp2 := yyvsp2 -1
	yyvsp92 := yyvsp92 -1
	if yyvsp68 >= yyvsc68 then
		if yyvs68 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs68")
			end
			create yyspecial_routines68
			yyvsc68 := yyInitial_yyvs_size
			yyvs68 := yyspecial_routines68.make (yyvsc68)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs68")
			end
			yyvsc68 := yyvsc68 + yyInitial_yyvs_size
			yyvs68 := yyspecial_routines68.resize (yyvs68, yyvsc68)
		end
	end
	yyvs68.put (yyval68, yyvsp68)
end
		end

	yy_do_action_467 is
			--|#line 2524 "eiffel.y"
		local
			yyval68: STATIC_ACCESS_AS
		do
--|#line 2524 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2524")
end

				report_warning (parser_errors.static_feature_use_warning, yyvs12.item (yyvsp12))
				yyval68 := ast_factory.new_static_access_as (yyvs79.item (yyvsp79), yyvs2.item (yyvsp2), yyvs92.item (yyvsp92), yyvs12.item (yyvsp12), yyvs4.item (yyvsp4));
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp68 := yyvsp68 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp79 := yyvsp79 -1
	yyvsp4 := yyvsp4 -1
	yyvsp2 := yyvsp2 -1
	yyvsp92 := yyvsp92 -1
	if yyvsp68 >= yyvsc68 then
		if yyvs68 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs68")
			end
			create yyspecial_routines68
			yyvsc68 := yyInitial_yyvs_size
			yyvs68 := yyspecial_routines68.make (yyvsc68)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs68")
			end
			yyvsc68 := yyvsc68 + yyInitial_yyvs_size
			yyvs68 := yyspecial_routines68.resize (yyvs68, yyvsc68)
		end
	end
	yyvs68.put (yyval68, yyvsp68)
end
		end

	yy_do_action_468 is
			--|#line 2532 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2532 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2532")
end

yyval35 := yyvs64.item (yyvsp64) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp35 := yyvsp35 + 1
	yyvsp64 := yyvsp64 -1
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
		end

	yy_do_action_469 is
			--|#line 2534 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2534 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2534")
end

yyval35 := yyvs26.item (yyvsp26) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp35 := yyvsp35 + 1
	yyvsp26 := yyvsp26 -1
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
		end

	yy_do_action_470 is
			--|#line 2538 "eiffel.y"
		local
			yyval64: NESTED_AS
		do
--|#line 2538 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2538")
end

yyval64 := ast_factory.new_nested_as (yyvs26.item (yyvsp26 - 1), yyvs26.item (yyvsp26), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp64 := yyvsp64 + 1
	yyvsp26 := yyvsp26 -2
	yyvsp4 := yyvsp4 -1
	if yyvsp64 >= yyvsc64 then
		if yyvs64 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs64")
			end
			create yyspecial_routines64
			yyvsc64 := yyInitial_yyvs_size
			yyvs64 := yyspecial_routines64.make (yyvsc64)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs64")
			end
			yyvsc64 := yyvsc64 + yyInitial_yyvs_size
			yyvs64 := yyspecial_routines64.resize (yyvs64, yyvsc64)
		end
	end
	yyvs64.put (yyval64, yyvsp64)
end
		end

	yy_do_action_471 is
			--|#line 2540 "eiffel.y"
		local
			yyval64: NESTED_AS
		do
--|#line 2540 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2540")
end

yyval64 := ast_factory.new_nested_as (yyvs26.item (yyvsp26), yyvs64.item (yyvsp64), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp26 := yyvsp26 -1
	yyvsp4 := yyvsp4 -1
	yyvs64.put (yyval64, yyvsp64)
end
		end

	yy_do_action_472 is
			--|#line 2544 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2544 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2544")
end

yyval2 := yyvs2.item (yyvsp2)
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
		end

	yy_do_action_473 is
			--|#line 2546 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2546 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2546")
end

				if yyvs83.item (yyvsp83) /= Void then
					yyval2 := yyvs83.item (yyvsp83).internal_name
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp2 := yyvsp2 + 1
	yyvsp83 := yyvsp83 -1
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
	yyvs2.put (yyval2, yyvsp2)
end
		end

	yy_do_action_474 is
			--|#line 2552 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2552 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2552")
end

				if yyvs83.item (yyvsp83) /= Void then
					yyval2 := yyvs83.item (yyvsp83).internal_name
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp2 := yyvsp2 + 1
	yyvsp83 := yyvsp83 -1
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
	yyvs2.put (yyval2, yyvsp2)
end
		end

	yy_do_action_475 is
			--|#line 2560 "eiffel.y"
		local
			yyval25: ACCESS_AS
		do
--|#line 2560 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2560")
end

				inspect id_level
				when Normal_level then
					yyval25 := ast_factory.new_access_id_as (yyvs2.item (yyvsp2), yyvs92.item (yyvsp92))
				when Assert_level then
					yyval25 := ast_factory.new_access_assert_as (yyvs2.item (yyvsp2), yyvs92.item (yyvsp92))
				when Invariant_level then
					yyval25 := ast_factory.new_access_inv_as (yyvs2.item (yyvsp2), yyvs92.item (yyvsp92), Void)
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp25 := yyvsp25 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp92 := yyvsp92 -1
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
		end

	yy_do_action_476 is
			--|#line 2573 "eiffel.y"
		local
			yyval26: ACCESS_FEAT_AS
		do
--|#line 2573 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2573")
end

yyval26 := ast_factory.new_access_feat_as (yyvs2.item (yyvsp2), yyvs92.item (yyvsp92)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp26 := yyvsp26 + 1
	yyvsp2 := yyvsp2 -1
	yyvsp92 := yyvsp92 -1
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
		end

	yy_do_action_477 is
			--|#line 2577 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2577 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2577")
end

yyval48 := yyvs31.item (yyvsp31); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp48 := yyvsp48 + 1
	yyvsp31 := yyvsp31 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_478 is
			--|#line 2580 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2580 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2580")
end

yyval48 := yyvs78.item (yyvsp78); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp48 := yyvsp48 + 1
	yyvsp78 := yyvsp78 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_479 is
			--|#line 2582 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2582 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2582")
end

yyval48 := ast_factory.new_expr_call_as (yyvs9.item (yyvsp9)); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp48 := yyvsp48 + 1
	yyvsp9 := yyvsp9 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_480 is
			--|#line 2584 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2584 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2584")
end

yyval48 := ast_factory.new_expr_call_as (yyvs6.item (yyvsp6)); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp48 := yyvsp48 + 1
	yyvsp6 := yyvsp6 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_481 is
			--|#line 2586 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2586 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2586")
end

yyval48 := ast_factory.new_expr_call_as (yyvs35.item (yyvsp35)); has_type := False 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp48 := yyvsp48 + 1
	yyvsp35 := yyvsp35 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_482 is
			--|#line 2588 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2588 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2588")
end

yyval48 := ast_factory.new_expr_call_as (yyvs43.item (yyvsp43)); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp48 := yyvsp48 + 1
	yyvsp43 := yyvsp43 -1
	if yyvsp48 >= yyvsc48 then
		if yyvs48 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs48")
			end
			create yyspecial_routines48
			yyvsc48 := yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.make (yyvsc48)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs48")
			end
			yyvsc48 := yyvsc48 + yyInitial_yyvs_size
			yyvs48 := yyspecial_routines48.resize (yyvs48, yyvsc48)
		end
	end
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_483 is
			--|#line 2590 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2590 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2590")
end

yyval48 := ast_factory.new_paran_as (yyvs48.item (yyvsp48), yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4)); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp4 := yyvsp4 -2
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_484 is
			--|#line 2594 "eiffel.y"
		local
			yyval92: PARAMETER_LIST_AS
		do
--|#line 2594 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2594")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp92 := yyvsp92 + 1
	if yyvsp92 >= yyvsc92 then
		if yyvs92 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs92")
			end
			create yyspecial_routines92
			yyvsc92 := yyInitial_yyvs_size
			yyvs92 := yyspecial_routines92.make (yyvsc92)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs92")
			end
			yyvsc92 := yyvsc92 + yyInitial_yyvs_size
			yyvs92 := yyspecial_routines92.resize (yyvs92, yyvsc92)
		end
	end
	yyvs92.put (yyval92, yyvsp92)
end
		end

	yy_do_action_485 is
			--|#line 2596 "eiffel.y"
		local
			yyval92: PARAMETER_LIST_AS
		do
--|#line 2596 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2596")
end

				yyval92 := ast_factory.new_parameter_list_as (Void, yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4)) 
				report_warning (parser_errors.empty_parenthesis_warning, yyvs4.item (yyvsp4 - 1))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp92 := yyvsp92 + 1
	yyvsp4 := yyvsp4 -2
	if yyvsp92 >= yyvsc92 then
		if yyvs92 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs92")
			end
			create yyspecial_routines92
			yyvsc92 := yyInitial_yyvs_size
			yyvs92 := yyspecial_routines92.make (yyvsc92)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs92")
			end
			yyvsc92 := yyvsc92 + yyInitial_yyvs_size
			yyvs92 := yyspecial_routines92.resize (yyvs92, yyvsc92)
		end
	end
	yyvs92.put (yyval92, yyvsp92)
end
		end

	yy_do_action_486 is
			--|#line 2601 "eiffel.y"
		local
			yyval92: PARAMETER_LIST_AS
		do
--|#line 2601 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2601")
end

yyval92 := ast_factory.new_parameter_list_as (yyvs91.item (yyvsp91), yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp92 := yyvsp92 + 1
	yyvsp4 := yyvsp4 -2
	yyvsp1 := yyvsp1 -2
	yyvsp91 := yyvsp91 -1
	if yyvsp92 >= yyvsc92 then
		if yyvs92 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs92")
			end
			create yyspecial_routines92
			yyvsc92 := yyInitial_yyvs_size
			yyvs92 := yyspecial_routines92.make (yyvsc92)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs92")
			end
			yyvsc92 := yyvsc92 + yyInitial_yyvs_size
			yyvs92 := yyspecial_routines92.resize (yyvs92, yyvsc92)
		end
	end
	yyvs92.put (yyval92, yyvsp92)
end
		end

	yy_do_action_487 is
			--|#line 2605 "eiffel.y"
		local
			yyval91: EIFFEL_LIST [EXPR_AS]
		do
--|#line 2605 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2605")
end

				yyval91 := ast_factory.new_eiffel_list_expr_as (counter_value + 1)
				if yyval91 /= Void and yyvs48.item (yyvsp48) /= Void then
					yyval91.reverse_extend (yyvs48.item (yyvsp48))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp91 := yyvsp91 + 1
	yyvsp48 := yyvsp48 -1
	if yyvsp91 >= yyvsc91 then
		if yyvs91 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs91")
			end
			create yyspecial_routines91
			yyvsc91 := yyInitial_yyvs_size
			yyvs91 := yyspecial_routines91.make (yyvsc91)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs91")
			end
			yyvsc91 := yyvsc91 + yyInitial_yyvs_size
			yyvs91 := yyspecial_routines91.resize (yyvs91, yyvsc91)
		end
	end
	yyvs91.put (yyval91, yyvsp91)
end
		end

	yy_do_action_488 is
			--|#line 2612 "eiffel.y"
		local
			yyval91: EIFFEL_LIST [EXPR_AS]
		do
--|#line 2612 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2612")
end

				yyval91 := yyvs91.item (yyvsp91)
				if yyval91 /= Void and yyvs48.item (yyvsp48) /= Void then
					yyval91.reverse_extend (yyvs48.item (yyvsp48))
					ast_factory.reverse_extend_separator (yyval91, yyvs4.item (yyvsp4))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp91 := yyvsp91 -1
	yyvsp48 := yyvsp48 -1
	yyvsp4 := yyvsp4 -1
	yyvs91.put (yyval91, yyvsp91)
end
		end

	yy_do_action_489 is
			--|#line 2612 "eiffel.y"
		local
			yyval91: EIFFEL_LIST [EXPR_AS]
		do
--|#line 2612 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2612")
end

increment_counter 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 0
	yyvsp91 := yyvsp91 + 1
	if yyvsp91 >= yyvsc91 then
		if yyvs91 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs91")
			end
			create yyspecial_routines91
			yyvsc91 := yyInitial_yyvs_size
			yyvs91 := yyspecial_routines91.make (yyvsc91)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs91")
			end
			yyvsc91 := yyvsc91 + yyInitial_yyvs_size
			yyvs91 := yyspecial_routines91.resize (yyvs91, yyvsc91)
		end
	end
	yyvs91.put (yyval91, yyvsp91)
end
		end

	yy_do_action_490 is
			--|#line 2622 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2622 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2622")
end

				if not case_sensitive and yyvs2.item (yyvsp2) /= Void then
					yyvs2.item (yyvsp2).to_upper
				end
				yyval2 := yyvs2.item (yyvsp2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
		end

	yy_do_action_491 is
			--|#line 2629 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2629 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2629")
end

				yyval2 := yyvs2.item (yyvsp2);
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
		end

	yy_do_action_492 is
			--|#line 2635 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2635 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2635")
end

				if not case_sensitive and yyvs2.item (yyvsp2) /= Void then
					yyvs2.item (yyvsp2).to_upper		
				end
				yyval2 := yyvs2.item (yyvsp2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
		end

	yy_do_action_493 is
			--|#line 2642 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2642 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2642")
end

					-- Keyword used as identifier
				process_id_as_with_existing_stub (last_keyword_as_id_index)
				report_warning (parser_errors.assign_keyword_warning, yyvs12.item (yyvsp12))

				if not case_sensitive and last_id_as_value /= Void then
					last_id_as_value.to_upper
				end
				yyval2 := last_id_as_value
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp2 := yyvsp2 + 1
	yyvsp12 := yyvsp12 -1
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
	yyvs2.put (yyval2, yyvsp2)
end
		end

	yy_do_action_494 is
			--|#line 2653 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2653 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2653")
end

report_expected_error (parser_errors.valid_eiffel_class_name, True, Void, False) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
		end

	yy_do_action_495 is
			--|#line 2657 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2657 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2657")
end

				if not case_sensitive and yyvs2.item (yyvsp2) /= Void then
					yyvs2.item (yyvsp2).to_lower
				end
				yyval2 := yyvs2.item (yyvsp2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
		end

	yy_do_action_496 is
			--|#line 2664 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2664 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2664")
end

				if not case_sensitive and yyvs2.item (yyvsp2) /= Void then
					yyvs2.item (yyvsp2).to_lower
				end
				yyval2 := yyvs2.item (yyvsp2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
		end

	yy_do_action_497 is
			--|#line 2671 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2671 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2671")
end

					-- Keyword used as identifier
				process_id_as_with_existing_stub (last_keyword_as_id_index)
				report_warning (parser_errors.assign_keyword_warning, yyvs12.item (yyvsp12))
				if not case_sensitive and last_id_as_value /= Void then
					last_id_as_value.to_lower
				end
				yyval2 := last_id_as_value
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp2 := yyvsp2 + 1
	yyvsp12 := yyvsp12 -1
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
	yyvs2.put (yyval2, yyvsp2)
end
		end

	yy_do_action_498 is
			--|#line 2681 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2681 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2681")
end

report_expected_error (parser_errors.a_valid_feature_name, True, Void, False) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
		end

	yy_do_action_499 is
			--|#line 2685 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2685 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2685")
end

yyval31 := yyvs5.item (yyvsp5) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp31 := yyvsp31 + 1
	yyvsp5 := yyvsp5 -1
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
		end

	yy_do_action_500 is
			--|#line 2687 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2687 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2687")
end

yyval31 := yyvs3.item (yyvsp3) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp31 := yyvsp31 + 1
	yyvsp3 := yyvsp3 -1
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
		end

	yy_do_action_501 is
			--|#line 2689 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2689 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2689")
end

yyval31 := yyvs59.item (yyvsp59) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp31 := yyvsp31 + 1
	yyvsp59 := yyvsp59 -1
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
		end

	yy_do_action_502 is
			--|#line 2691 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2691 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2691")
end

yyval31 := yyvs69.item (yyvsp69) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp31 := yyvsp31 + 1
	yyvsp69 := yyvsp69 -1
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
		end

	yy_do_action_503 is
			--|#line 2693 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2693 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2693")
end

yyval31 := yyvs33.item (yyvsp33) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp31 := yyvsp31 + 1
	yyvsp33 := yyvsp33 -1
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
		end

	yy_do_action_504 is
			--|#line 2695 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2695 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2695")
end

yyval31 := yyvs18.item (yyvsp18) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp31 := yyvsp31 + 1
	yyvsp18 := yyvsp18 -1
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
		end

	yy_do_action_505 is
			--|#line 2700 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2700 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2700")
end

yyval31 := yyvs5.item (yyvsp5) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp31 := yyvsp31 + 1
	yyvsp5 := yyvsp5 -1
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
		end

	yy_do_action_506 is
			--|#line 2703 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2703 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2703")
end

yyval31 := yyvs59.item (yyvsp59) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp31 := yyvsp31 + 1
	yyvsp59 := yyvsp59 -1
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
		end

	yy_do_action_507 is
			--|#line 2705 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2705 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2705")
end

yyval31 := yyvs59.item (yyvsp59) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp31 := yyvsp31 + 1
	yyvsp59 := yyvsp59 -1
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
		end

	yy_do_action_508 is
			--|#line 2707 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2707 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2707")
end

yyval31 := yyvs69.item (yyvsp69) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp31 := yyvsp31 + 1
	yyvsp69 := yyvsp69 -1
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
		end

	yy_do_action_509 is
			--|#line 2709 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2709 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2709")
end

yyval31 := yyvs69.item (yyvsp69) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp31 := yyvsp31 + 1
	yyvsp69 := yyvsp69 -1
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
		end

	yy_do_action_510 is
			--|#line 2711 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2711 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2711")
end

yyval31 := yyvs3.item (yyvsp3) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp31 := yyvsp31 + 1
	yyvsp3 := yyvsp3 -1
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
		end

	yy_do_action_511 is
			--|#line 2713 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2713 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2713")
end

yyval31 := yyvs33.item (yyvsp33) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp31 := yyvsp31 + 1
	yyvsp33 := yyvsp33 -1
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
		end

	yy_do_action_512 is
			--|#line 2715 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2715 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2715")
end

yyval31 := yyvs18.item (yyvsp18) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp31 := yyvsp31 + 1
	yyvsp18 := yyvsp18 -1
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
		end

	yy_do_action_513 is
			--|#line 2717 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2717 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2717")
end

				if yyvs18.item (yyvsp18) /= Void then
					yyvs18.item (yyvsp18).set_is_once_string (True)
					yyvs18.item (yyvsp18).set_once_string_keyword (yyvs12.item (yyvsp12))
				end
				once_manifest_string_count := once_manifest_string_count + 1
				yyval31 := yyvs18.item (yyvsp18)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp31 := yyvsp31 + 1
	yyvsp12 := yyvsp12 -1
	yyvsp18 := yyvsp18 -1
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
		end

	yy_do_action_514 is
			--|#line 2728 "eiffel.y"
		local
			yyval5: BOOL_AS
		do
--|#line 2728 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2728")
end

yyval5 := yyvs5.item (yyvsp5) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs5.put (yyval5, yyvsp5)
end
		end

	yy_do_action_515 is
			--|#line 2730 "eiffel.y"
		local
			yyval5: BOOL_AS
		do
--|#line 2730 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2730")
end

yyval5 := yyvs5.item (yyvsp5) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs5.put (yyval5, yyvsp5)
end
		end

	yy_do_action_516 is
			--|#line 2734 "eiffel.y"
		local
			yyval3: CHAR_AS
		do
--|#line 2734 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2734")
end

				check is_character: not token_buffer.is_empty end
				yyval3 := ast_factory.new_character_as (token_buffer.item (1), line, column, position, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs3.put (yyval3, yyvsp3)
end
		end

	yy_do_action_517 is
			--|#line 2739 "eiffel.y"
		local
			yyval3: CHAR_AS
		do
--|#line 2739 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2739")
end

				check is_character: not token_buffer.is_empty end
				fixme (once "We should handle `Type' instead of ignoring it.")
				yyval3 := ast_factory.new_typed_char_as (yyvs79.item (yyvsp79), token_buffer.item (1), line, column, position, 1, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp79 := yyvsp79 -1
	yyvs3.put (yyval3, yyvsp3)
end
		end

	yy_do_action_518 is
			--|#line 2750 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2750 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2750")
end

yyval59 := yyvs59.item (yyvsp59) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs59.put (yyval59, yyvsp59)
end
		end

	yy_do_action_519 is
			--|#line 2753 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2753 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2753")
end

yyval59 := yyvs59.item (yyvsp59) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs59.put (yyval59, yyvsp59)
end
		end

	yy_do_action_520 is
			--|#line 2755 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2755 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2755")
end

yyval59 := yyvs59.item (yyvsp59) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs59.put (yyval59, yyvsp59)
end
		end

	yy_do_action_521 is
			--|#line 2759 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2759 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2759")
end

				yyval59 := ast_factory.new_integer_value (Current, '+', Void, token_buffer, yyvs4.item (yyvsp4))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp59 := yyvsp59 + 1
	yyvsp4 := yyvsp4 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp59 >= yyvsc59 then
		if yyvs59 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs59")
			end
			create yyspecial_routines59
			yyvsc59 := yyInitial_yyvs_size
			yyvs59 := yyspecial_routines59.make (yyvsc59)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs59")
			end
			yyvsc59 := yyvsc59 + yyInitial_yyvs_size
			yyvs59 := yyspecial_routines59.resize (yyvs59, yyvsc59)
		end
	end
	yyvs59.put (yyval59, yyvsp59)
end
		end

	yy_do_action_522 is
			--|#line 2763 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2763 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2763")
end

				yyval59 := ast_factory.new_integer_value (Current, '-', Void, token_buffer, yyvs4.item (yyvsp4))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp59 := yyvsp59 + 1
	yyvsp4 := yyvsp4 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp59 >= yyvsc59 then
		if yyvs59 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs59")
			end
			create yyspecial_routines59
			yyvsc59 := yyInitial_yyvs_size
			yyvs59 := yyspecial_routines59.make (yyvsc59)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs59")
			end
			yyvsc59 := yyvsc59 + yyInitial_yyvs_size
			yyvs59 := yyspecial_routines59.resize (yyvs59, yyvsc59)
		end
	end
	yyvs59.put (yyval59, yyvsp59)
end
		end

	yy_do_action_523 is
			--|#line 2769 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2769 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2769")
end

				yyval59 := ast_factory.new_integer_value (Current, '%U', Void, token_buffer, Void)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp59 := yyvsp59 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp59 >= yyvsc59 then
		if yyvs59 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs59")
			end
			create yyspecial_routines59
			yyvsc59 := yyInitial_yyvs_size
			yyvs59 := yyspecial_routines59.make (yyvsc59)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs59")
			end
			yyvsc59 := yyvsc59 + yyInitial_yyvs_size
			yyvs59 := yyspecial_routines59.resize (yyvs59, yyvsc59)
		end
	end
	yyvs59.put (yyval59, yyvsp59)
end
		end

	yy_do_action_524 is
			--|#line 2775 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2775 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2775")
end

yyval59 := yyvs59.item (yyvsp59) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs59.put (yyval59, yyvsp59)
end
		end

	yy_do_action_525 is
			--|#line 2777 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2777 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2777")
end

yyval59 := yyvs59.item (yyvsp59) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs59.put (yyval59, yyvsp59)
end
		end

	yy_do_action_526 is
			--|#line 2781 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2781 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2781")
end

				yyval59 := ast_factory.new_integer_value (Current, '%U', yyvs79.item (yyvsp79), token_buffer, Void)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp59 := yyvsp59 + 1
	yyvsp79 := yyvsp79 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp59 >= yyvsc59 then
		if yyvs59 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs59")
			end
			create yyspecial_routines59
			yyvsc59 := yyInitial_yyvs_size
			yyvs59 := yyspecial_routines59.make (yyvsc59)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs59")
			end
			yyvsc59 := yyvsc59 + yyInitial_yyvs_size
			yyvs59 := yyspecial_routines59.resize (yyvs59, yyvsc59)
		end
	end
	yyvs59.put (yyval59, yyvsp59)
end
		end

	yy_do_action_527 is
			--|#line 2787 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2787 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2787")
end

				yyval59 := ast_factory.new_integer_value (Current, '+', yyvs79.item (yyvsp79), token_buffer, yyvs4.item (yyvsp4))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp59 := yyvsp59 + 1
	yyvsp79 := yyvsp79 -1
	yyvsp4 := yyvsp4 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp59 >= yyvsc59 then
		if yyvs59 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs59")
			end
			create yyspecial_routines59
			yyvsc59 := yyInitial_yyvs_size
			yyvs59 := yyspecial_routines59.make (yyvsc59)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs59")
			end
			yyvsc59 := yyvsc59 + yyInitial_yyvs_size
			yyvs59 := yyspecial_routines59.resize (yyvs59, yyvsc59)
		end
	end
	yyvs59.put (yyval59, yyvsp59)
end
		end

	yy_do_action_528 is
			--|#line 2791 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2791 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2791")
end

				yyval59 := ast_factory.new_integer_value (Current, '-', yyvs79.item (yyvsp79), token_buffer, yyvs4.item (yyvsp4))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp59 := yyvsp59 + 1
	yyvsp79 := yyvsp79 -1
	yyvsp4 := yyvsp4 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp59 >= yyvsc59 then
		if yyvs59 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs59")
			end
			create yyspecial_routines59
			yyvsc59 := yyInitial_yyvs_size
			yyvs59 := yyspecial_routines59.make (yyvsc59)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs59")
			end
			yyvsc59 := yyvsc59 + yyInitial_yyvs_size
			yyvs59 := yyspecial_routines59.resize (yyvs59, yyvsc59)
		end
	end
	yyvs59.put (yyval59, yyvsp59)
end
		end

	yy_do_action_529 is
			--|#line 2800 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2800 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2800")
end

yyval69 := yyvs69.item (yyvsp69) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs69.put (yyval69, yyvsp69)
end
		end

	yy_do_action_530 is
			--|#line 2802 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2802 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2802")
end

yyval69 := yyvs69.item (yyvsp69) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs69.put (yyval69, yyvsp69)
end
		end

	yy_do_action_531 is
			--|#line 2804 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2804 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2804")
end

yyval69 := yyvs69.item (yyvsp69) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs69.put (yyval69, yyvsp69)
end
		end

	yy_do_action_532 is
			--|#line 2808 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2808 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2808")
end

				yyval69 := ast_factory.new_real_value (Current, False, '%U', Void, token_buffer, Void)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp69 := yyvsp69 + 1
	yyvsp1 := yyvsp1 -1
	if yyvsp69 >= yyvsc69 then
		if yyvs69 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs69")
			end
			create yyspecial_routines69
			yyvsc69 := yyInitial_yyvs_size
			yyvs69 := yyspecial_routines69.make (yyvsc69)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs69")
			end
			yyvsc69 := yyvsc69 + yyInitial_yyvs_size
			yyvs69 := yyspecial_routines69.resize (yyvs69, yyvsc69)
		end
	end
	yyvs69.put (yyval69, yyvsp69)
end
		end

	yy_do_action_533 is
			--|#line 2814 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2814 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2814")
end

				yyval69 := ast_factory.new_real_value (Current, True, '+', Void, token_buffer, yyvs4.item (yyvsp4))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp69 := yyvsp69 + 1
	yyvsp4 := yyvsp4 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp69 >= yyvsc69 then
		if yyvs69 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs69")
			end
			create yyspecial_routines69
			yyvsc69 := yyInitial_yyvs_size
			yyvs69 := yyspecial_routines69.make (yyvsc69)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs69")
			end
			yyvsc69 := yyvsc69 + yyInitial_yyvs_size
			yyvs69 := yyspecial_routines69.resize (yyvs69, yyvsc69)
		end
	end
	yyvs69.put (yyval69, yyvsp69)
end
		end

	yy_do_action_534 is
			--|#line 2818 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2818 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2818")
end

				yyval69 := ast_factory.new_real_value (Current, True, '-', Void, token_buffer, yyvs4.item (yyvsp4))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp69 := yyvsp69 + 1
	yyvsp4 := yyvsp4 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp69 >= yyvsc69 then
		if yyvs69 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs69")
			end
			create yyspecial_routines69
			yyvsc69 := yyInitial_yyvs_size
			yyvs69 := yyspecial_routines69.make (yyvsc69)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs69")
			end
			yyvsc69 := yyvsc69 + yyInitial_yyvs_size
			yyvs69 := yyspecial_routines69.resize (yyvs69, yyvsc69)
		end
	end
	yyvs69.put (yyval69, yyvsp69)
end
		end

	yy_do_action_535 is
			--|#line 2824 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2824 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2824")
end

yyval69 := yyvs69.item (yyvsp69) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs69.put (yyval69, yyvsp69)
end
		end

	yy_do_action_536 is
			--|#line 2826 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2826 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2826")
end

yyval69 := yyvs69.item (yyvsp69) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs69.put (yyval69, yyvsp69)
end
		end

	yy_do_action_537 is
			--|#line 2830 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2830 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2830")
end

				yyval69 := ast_factory.new_real_value (Current, False, '%U', yyvs79.item (yyvsp79), token_buffer, Void)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp69 := yyvsp69 + 1
	yyvsp79 := yyvsp79 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp69 >= yyvsc69 then
		if yyvs69 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs69")
			end
			create yyspecial_routines69
			yyvsc69 := yyInitial_yyvs_size
			yyvs69 := yyspecial_routines69.make (yyvsc69)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs69")
			end
			yyvsc69 := yyvsc69 + yyInitial_yyvs_size
			yyvs69 := yyspecial_routines69.resize (yyvs69, yyvsc69)
		end
	end
	yyvs69.put (yyval69, yyvsp69)
end
		end

	yy_do_action_538 is
			--|#line 2836 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2836 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2836")
end

				yyval69 := ast_factory.new_real_value (Current, True, '+', yyvs79.item (yyvsp79), token_buffer, yyvs4.item (yyvsp4))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp69 := yyvsp69 + 1
	yyvsp79 := yyvsp79 -1
	yyvsp4 := yyvsp4 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp69 >= yyvsc69 then
		if yyvs69 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs69")
			end
			create yyspecial_routines69
			yyvsc69 := yyInitial_yyvs_size
			yyvs69 := yyspecial_routines69.make (yyvsc69)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs69")
			end
			yyvsc69 := yyvsc69 + yyInitial_yyvs_size
			yyvs69 := yyspecial_routines69.resize (yyvs69, yyvsc69)
		end
	end
	yyvs69.put (yyval69, yyvsp69)
end
		end

	yy_do_action_539 is
			--|#line 2840 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2840 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2840")
end

				yyval69 := ast_factory.new_real_value (Current, True, '-', yyvs79.item (yyvsp79), token_buffer, yyvs4.item (yyvsp4))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp69 := yyvsp69 + 1
	yyvsp79 := yyvsp79 -1
	yyvsp4 := yyvsp4 -1
	yyvsp1 := yyvsp1 -1
	if yyvsp69 >= yyvsc69 then
		if yyvs69 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs69")
			end
			create yyspecial_routines69
			yyvsc69 := yyInitial_yyvs_size
			yyvs69 := yyspecial_routines69.make (yyvsc69)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs69")
			end
			yyvsc69 := yyvsc69 + yyInitial_yyvs_size
			yyvs69 := yyspecial_routines69.resize (yyvs69, yyvsc69)
		end
	end
	yyvs69.put (yyval69, yyvsp69)
end
		end

	yy_do_action_540 is
			--|#line 2849 "eiffel.y"
		local
			yyval33: BIT_CONST_AS
		do
--|#line 2849 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2849")
end

yyval33 := ast_factory.new_bit_const_as (yyvs2.item (yyvsp2)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp33 := yyvsp33 + 1
	yyvsp2 := yyvsp2 -1
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
		end

	yy_do_action_541 is
			--|#line 2856 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2856 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2856")
end

yyval18 := yyvs18.item (yyvsp18) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs18.put (yyval18, yyvsp18)
end
		end

	yy_do_action_542 is
			--|#line 2858 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2858 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2858")
end

yyval18 := yyvs18.item (yyvsp18) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs18.put (yyval18, yyvsp18)
end
		end

	yy_do_action_543 is
			--|#line 2862 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2862 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2862")
end

yyval18 := yyvs18.item (yyvsp18) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs18.put (yyval18, yyvsp18)
end
		end

	yy_do_action_544 is
			--|#line 2864 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2864 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2864")
end

				yyval18 := ast_factory.new_string_as ("", line, column, string_position, position + text_count - string_position, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_545 is
			--|#line 2868 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2868 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2868")
end

				yyval18 := ast_factory.new_verbatim_string_as ("", verbatim_marker.substring (2, verbatim_marker.count), not has_old_verbatim_strings and then verbatim_marker.item (1) = ']', line, column, string_position, position + text_count - string_position, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_546 is
			--|#line 2874 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2874 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2874")
end

				fixme (once "We should handle `Type' instead of ignoring it.")
				yyval18 := yyvs18.item (yyvsp18)
				if yyvs79.item (yyvsp79) /= Void then
					yyvs79.item (yyvsp79).set_lcurly_symbol (yyvs4.item (yyvsp4 - 1))
					yyvs79.item (yyvsp79).set_rcurly_symbol (yyvs4.item (yyvsp4))
				end
				if yyval18 /= Void then
					yyval18.set_type (yyvs79.item (yyvsp79))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp4 := yyvsp4 -2
	yyvsp79 := yyvsp79 -1
	yyvs18.put (yyval18, yyvsp18)
end
		end

	yy_do_action_547 is
			--|#line 2888 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2888 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2888")
end

				yyval18 := ast_factory.new_string_as (cloned_string (token_buffer), line, column, string_position, position + text_count - string_position, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_548 is
			--|#line 2892 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2892 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2892")
end

				yyval18 := ast_factory.new_verbatim_string_as (cloned_string (token_buffer), verbatim_marker.substring (2, verbatim_marker.count), not has_old_verbatim_strings and then verbatim_marker.item (1) = ']', line, column, string_position, position + text_count - string_position, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_549 is
			--|#line 2896 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2896 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2896")
end

				yyval18 := ast_factory.new_string_as ("<", line, column, position, 3, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_550 is
			--|#line 2900 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2900 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2900")
end

				yyval18 := ast_factory.new_string_as ("<=", line, column, position, 4, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_551 is
			--|#line 2904 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2904 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2904")
end

				yyval18 := ast_factory.new_string_as (">", line, column, position, 3, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_552 is
			--|#line 2908 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2908 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2908")
end

				yyval18 := ast_factory.new_string_as (">=", line, column, position, 4, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_553 is
			--|#line 2912 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2912 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2912")
end

				yyval18 := ast_factory.new_string_as ("-", line, column, position, 3, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_554 is
			--|#line 2916 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2916 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2916")
end

				yyval18 := ast_factory.new_string_as ("+", line, column, position, 3, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_555 is
			--|#line 2920 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2920 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2920")
end

				yyval18 := ast_factory.new_string_as ("*", line, column, position, 3, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_556 is
			--|#line 2924 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2924 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2924")
end

				yyval18 := ast_factory.new_string_as ("/", line, column, position, 3, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_557 is
			--|#line 2928 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2928 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2928")
end

				yyval18 := ast_factory.new_string_as ("\\", line, column, position, 4, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_558 is
			--|#line 2932 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2932 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2932")
end

				yyval18 := ast_factory.new_string_as ("//", line, column, position, 4, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_559 is
			--|#line 2936 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2936 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2936")
end

				yyval18 := ast_factory.new_string_as ("^", line, column, position, 3, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_560 is
			--|#line 2940 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2940 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2940")
end

				yyval18 := ast_factory.new_string_as ("[]", line, column, position, 4, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_561 is
			--|#line 2944 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2944 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2944")
end

				yyval18 := ast_factory.new_string_as (cloned_string (token_buffer), line, column, position, 5, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_562 is
			--|#line 2948 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2948 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2948")
end

				yyval18 := ast_factory.new_string_as (cloned_string (token_buffer), line, column, position, 10, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_563 is
			--|#line 2952 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2952 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2952")
end

				yyval18 := ast_factory.new_string_as (cloned_string (token_buffer), line, column, position, 9, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_564 is
			--|#line 2956 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2956 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2956")
end

				yyval18 := ast_factory.new_string_as (cloned_string (token_buffer), line, column, position, 4, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_565 is
			--|#line 2960 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2960 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2960")
end

				yyval18 := ast_factory.new_string_as (cloned_string (token_buffer), line, column, position, 9, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_566 is
			--|#line 2964 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2964 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2964")
end

				yyval18 := ast_factory.new_string_as (cloned_string (token_buffer), line, column, position, 5, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_567 is
			--|#line 2968 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2968 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2968")
end

				yyval18 := ast_factory.new_string_as (cloned_string (token_buffer), line, column, position, 5, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_568 is
			--|#line 2972 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2972 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2972")
end

				yyval18 := ast_factory.new_string_as (cloned_string (token_buffer), line, column, position, token_buffer.count + 2, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_569 is
			--|#line 2978 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2978 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2978")
end

				yyval18 := ast_factory.new_string_as ("-", line, column, position, 3, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_570 is
			--|#line 2982 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2982 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2982")
end

				yyval18 := ast_factory.new_string_as ("+", line, column, position, 3, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_571 is
			--|#line 2986 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2986 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2986")
end

				yyval18 := ast_factory.new_string_as ("not", line, column, position, 5, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_572 is
			--|#line 2990 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2990 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2990")
end

				yyval18 := ast_factory.new_string_as (cloned_lower_string (token_buffer), line, column, position, token_buffer.count + 2, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_573 is
			--|#line 2996 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2996 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2996")
end

				yyval18 := ast_factory.new_string_as ("<", line, column, position, 3, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_574 is
			--|#line 3000 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3000 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3000")
end

				yyval18 := ast_factory.new_string_as ("<=", line, column, position, 4, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_575 is
			--|#line 3004 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3004 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3004")
end

				yyval18 := ast_factory.new_string_as (">", line, column, position, 3, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_576 is
			--|#line 3008 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3008 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3008")
end

				yyval18 := ast_factory.new_string_as (">=", line, column, position, 4, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_577 is
			--|#line 3012 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3012 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3012")
end

				yyval18 := ast_factory.new_string_as ("-", line, column, position, 3, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_578 is
			--|#line 3016 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3016 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3016")
end

				yyval18 := ast_factory.new_string_as ("+", line, column, position, 3, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_579 is
			--|#line 3020 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3020 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3020")
end

				yyval18 := ast_factory.new_string_as ("*", line, column, position, 3, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_580 is
			--|#line 3024 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3024 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3024")
end

				yyval18 := ast_factory.new_string_as ("/", line, column, position, 3, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_581 is
			--|#line 3028 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3028 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3028")
end

				yyval18 := ast_factory.new_string_as ("\\", line, column, position, 4, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_582 is
			--|#line 3032 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3032 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3032")
end

				yyval18 := ast_factory.new_string_as ("//", line, column, position, 4, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_583 is
			--|#line 3036 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3036 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3036")
end

				yyval18 := ast_factory.new_string_as ("^", line, column, position, 3, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_584 is
			--|#line 3040 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3040 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3040")
end

				yyval18 := ast_factory.new_string_as ("and", line, column, position, 5, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_585 is
			--|#line 3044 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3044 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3044")
end

				yyval18 := ast_factory.new_string_as ("and then", line, column, position, 10, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_586 is
			--|#line 3048 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3048 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3048")
end

				yyval18 := ast_factory.new_string_as ("implies", line, column, position, 9, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_587 is
			--|#line 3052 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3052 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3052")
end

				yyval18 := ast_factory.new_string_as ("or", line, column, position, 4, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_588 is
			--|#line 3056 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3056 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3056")
end

				yyval18 := ast_factory.new_string_as ("or else", line, column, position, 9, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_589 is
			--|#line 3060 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3060 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3060")
end

				yyval18 := ast_factory.new_string_as ("xor", line, column, position, 5, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_590 is
			--|#line 3064 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3064 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3064")
end

				yyval18 := ast_factory.new_string_as (cloned_lower_string (token_buffer), line, column, position, token_buffer.count + 2, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvsp18 := yyvsp18 + 1
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
		end

	yy_do_action_591 is
			--|#line 3070 "eiffel.y"
		local
			yyval28: ARRAY_AS
		do
--|#line 3070 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3070")
end

				yyval28 := ast_factory.new_array_as (ast_factory.new_eiffel_list_expr_as (0), yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4))
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp28 := yyvsp28 + 1
	yyvsp4 := yyvsp4 -2
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
		end

	yy_do_action_592 is
			--|#line 3074 "eiffel.y"
		local
			yyval28: ARRAY_AS
		do
--|#line 3074 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3074")
end

yyval28 := ast_factory.new_array_as (yyvs91.item (yyvsp91), yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp28 := yyvsp28 + 1
	yyvsp4 := yyvsp4 -2
	yyvsp1 := yyvsp1 -2
	yyvsp91 := yyvsp91 -1
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
		end

	yy_do_action_593 is
			--|#line 3078 "eiffel.y"
		local
			yyval78: TUPLE_AS
		do
--|#line 3078 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3078")
end

yyval78 := ast_factory.new_tuple_as (ast_factory.new_eiffel_list_expr_as (0), yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp78 := yyvsp78 + 1
	yyvsp4 := yyvsp4 -2
	if yyvsp78 >= yyvsc78 then
		if yyvs78 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs78")
			end
			create yyspecial_routines78
			yyvsc78 := yyInitial_yyvs_size
			yyvs78 := yyspecial_routines78.make (yyvsc78)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs78")
			end
			yyvsc78 := yyvsc78 + yyInitial_yyvs_size
			yyvs78 := yyspecial_routines78.resize (yyvs78, yyvsc78)
		end
	end
	yyvs78.put (yyval78, yyvsp78)
end
		end

	yy_do_action_594 is
			--|#line 3080 "eiffel.y"
		local
			yyval78: TUPLE_AS
		do
--|#line 3080 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3080")
end

yyval78 := ast_factory.new_tuple_as (yyvs91.item (yyvsp91), yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp78 := yyvsp78 + 1
	yyvsp4 := yyvsp4 -2
	yyvsp1 := yyvsp1 -2
	yyvsp91 := yyvsp91 -1
	if yyvsp78 >= yyvsc78 then
		if yyvs78 = Void then
			debug ("GEYACC")
				std.error.put_line ("Create yyvs78")
			end
			create yyspecial_routines78
			yyvsc78 := yyInitial_yyvs_size
			yyvs78 := yyspecial_routines78.make (yyvsc78)
		else
			debug ("GEYACC")
				std.error.put_line ("Resize yyvs78")
			end
			yyvsc78 := yyvsc78 + yyInitial_yyvs_size
			yyvs78 := yyspecial_routines78.resize (yyvs78, yyvsc78)
		end
	end
	yyvs78.put (yyval78, yyvsp78)
end
		end

	yy_do_action_595 is
			--|#line 3084 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 3084 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3084")
end

add_counter 
if yy_parsing_status = yyContinue then
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
		end

	yy_do_action_596 is
			--|#line 3087 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 3087 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3087")
end

add_counter2 
if yy_parsing_status = yyContinue then
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
		end

	yy_do_action_597 is
			--|#line 3090 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 3090 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3090")
end

increment_counter 
if yy_parsing_status = yyContinue then
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
		end

	yy_do_action_598 is
			--|#line 3093 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 3093 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3093")
end

increment_counter2 
if yy_parsing_status = yyContinue then
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
		end

	yy_do_action_599 is
			--|#line 3096 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 3096 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3096")
end

remove_counter 
if yy_parsing_status = yyContinue then
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
		end

	yy_do_error_action (yy_act: INTEGER) is
			-- Execute error action.
		do
			if yy_act <= 199 then
				yy_do_error_action_0_199 (yy_act)
			elseif yy_act <= 399 then
				yy_do_error_action_200_399 (yy_act)
			elseif yy_act <= 599 then
				yy_do_error_action_400_599 (yy_act)
			elseif yy_act <= 799 then
				yy_do_error_action_600_799 (yy_act)
			elseif yy_act <= 999 then
				yy_do_error_action_800_999 (yy_act)
			else
					-- Default action.
				report_error ("parse error")
			end
		end

	yy_do_error_action_0_199 (yy_act: INTEGER) is
			-- Execute error action.
		do
			inspect yy_act
			else
					-- Default action.
				report_error ("parse error")
			end
		end

	yy_do_error_action_200_399 (yy_act: INTEGER) is
			-- Execute error action.
		do
			inspect yy_act
			else
					-- Default action.
				report_error ("parse error")
			end
		end

	yy_do_error_action_400_599 (yy_act: INTEGER) is
			-- Execute error action.
		do
			inspect yy_act
			else
					-- Default action.
				report_error ("parse error")
			end
		end

	yy_do_error_action_600_799 (yy_act: INTEGER) is
			-- Execute error action.
		do
			inspect yy_act
			else
					-- Default action.
				report_error ("parse error")
			end
		end

	yy_do_error_action_800_999 (yy_act: INTEGER) is
			-- Execute error action.
		do
			inspect yy_act
			when 977 then
					-- End-of-file expected action.
				report_eof_expected_error
			else
					-- Default action.
				report_error ("parse error")
			end
		end

feature {NONE} -- Table templates

	yytranslate_template: SPECIAL [INTEGER] is
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
			   25,   26,   27,   28,   29,   30,   31,   32,   33,   34,
			   35,   36,   37,   38,   39,   40,   41,   42,   43,   44,

			   45,   46,   47,   48,   49,   50,   51,   52,   53,   54,
			   55,   56,   57,   58,   59,   60,   61,   62,   63,   64,
			   65,   66,   67,   68,   69,   70,   71,   72,   73,   74,
			   75,   76,   77,   78,   79,   80,   81,   82,   83,   84,
			   85,   86,   87,   88,   89,   90,   91,   92,   93,   94,
			   95,   96,   97,   98,   99,  100,  101,  102,  103,  104,
			  105,  106,  107,  108,  109,  110,  111,  112,  113,  114,
			  115,  116,  117,  118,  119,  120,  121,  122,  123,  124,
			  125,  126,  127,  128,  129,  130,  131,  132,  133,  134, yyDummy>>)
		end

	yyr1_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			    0,  319,  319,  319,  319,  319,  319,  319,  319,  320,
			  324,  325,  326,  293,  293,  327,  293,  295,  295,  295,
			  328,  294,  294,  329,  200,  201,  201,  261,  261,  330,
			  261,  155,  155,  155,  155,  323,  323,  323,  323,  331,
			  331,  332,  332,  168,  168,  142,  142,  276,  276,  277,
			  277,  333,  189,  189,  170,  334,  169,  169,  291,  291,
			  292,  292,  335,  275,  275,  336,  135,  135,  188,  280,
			  280,  281,  281,  281,  260,  338,  338,  259,  259,  258,
			  258,  257,  257,  257,  255,  256,  137,  242,  242,  242,
			  136,  136,  160,  160,  160,  160,  160,  160,  160,  160,

			  160,  160,  160,  160,  160,  160,  160,  140,  140,  140,
			  171,  171,  301,  301,  301,  302,  302,  339,  217,  252,
			  218,  218,  218,  218,  218,  218,  304,  304,  303,  303,
			  340,  229,  272,  272,  271,  271,  270,  270,  341,  179,
			  190,  190,  190,  265,  265,  264,  264,  342,  172,  172,
			  278,  279,  279,  343,  284,  284,  283,  283,  286,  286,
			  285,  285,  288,  288,  287,  287,  317,  317,  317,  317,
			  314,  314,  344,  314,  253,  253,  253,  253,  143,  143,
			  144,  144,  345,  144,  196,  346,  346,  145,  145,  233,
			  347,  232,  232,  232,  186,  348,  187,  141,  141,  211,

			  211,  316,  316,  316,  296,  296,  297,  297,  349,  203,
			  337,  337,  204,  204,  204,  204,  204,  204,  204,  204,
			  204,  204,  204,  230,  230,  350,  230,  351,  178,  178,
			  352,  178,  353,  307,  307,  308,  308,  354,  243,  243,
			  243,  245,  245,  251,  251,  251,  246,  246,  246,  246,
			  246,  246,  248,  248,  249,  310,  310,  309,  309,  311,
			  312,  312,  355,  250,  250,  250,  250,  313,  313,  313,
			  315,  315,  315,  289,  289,  289,  290,  290,  359,  191,
			  191,  191,  192,  360,  318,  318,  282,  282,  199,  199,
			  199,  199,  268,  268,  269,  269,  361,  269,  177,  177,

			  177,  177,  138,  202,  202,  262,  262,  263,  263,  362,
			  165,  298,  298,  363,  212,  212,  212,  212,  212,  212,
			  212,  212,  212,  212,  212,  212,  212,  212,  212,  212,
			  212,  212,  214,  146,  146,  213,  213,  364,  254,  254,
			  254,  176,  306,  306,  306,  305,  305,  365,  139,  139,
			  183,  183,  183,  183,  154,  153,  153,  231,  231,  266,
			  266,  267,  267,  366,  173,  173,  173,  173,  173,  173,
			  234,  234,  234,  235,  235,  235,  235,  235,  235,  235,
			  147,  147,  147,  147,  147,  147,  300,  300,  300,  299,
			  299,  367,  216,  216,  216,  174,  174,  174,  174,  175,

			  175,  149,  149,  151,  151,  162,  162,  162,  162,  167,
			  247,  181,  181,  181,  181,  181,  181,  181,  158,  158,
			  158,  158,  158,  158,  158,  158,  158,  158,  158,  158,
			  158,  158,  158,  158,  158,  158,  182,  182,  182,  182,
			  182,  182,  182,  182,  182,  182,  182,  184,  184,  184,
			  184,  184,  185,  185,  185,  197,  164,  164,  164,  164,
			  164,  164,  219,  219,  220,  220,  222,  221,  163,  163,
			  215,  215,  198,  198,  198,  148,  150,  180,  180,  180,
			  180,  180,  180,  180,  274,  274,  274,  273,  273,  368,
			  193,  193,  194,  194,  194,  195,  195,  195,  195,  156,

			  156,  156,  156,  156,  156,  157,  157,  157,  157,  157,
			  157,  157,  157,  157,  161,  161,  166,  166,  205,  205,
			  205,  206,  206,  207,  208,  208,  209,  210,  210,  223,
			  223,  223,  225,  224,  224,  226,  226,  227,  228,  228,
			  159,  236,  236,  238,  238,  238,  239,  237,  237,  237,
			  237,  237,  237,  237,  237,  237,  237,  237,  237,  237,
			  237,  237,  237,  237,  237,  237,  237,  237,  237,  241,
			  241,  241,  241,  240,  240,  240,  240,  240,  240,  240,
			  240,  240,  240,  240,  240,  240,  240,  240,  240,  240,
			  240,  152,  152,  244,  244,  321,  356,  357,  358,  322, yyDummy>>)
		end

	yytypes1_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			    1,   12,   12,   12,   12,   12,   12,    2,    2,    2,
			    2,  102,    1,    1,   12,   62,  102,   51,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,   12,   12,   12,   12,   12,   12,   12,
			   11,    9,    6,    5,    5,    4,    4,    4,    4,    4,
			    4,    4,    4,    3,    1,    1,    2,    4,   12,   12,
			   12,    2,    4,    4,   25,   28,   31,   32,   33,    5,
			   35,   35,    3,   43,   48,   48,   48,   48,   48,    2,
			    2,    2,   59,   59,   59,   59,   67,   68,   68,   68,

			   69,   69,   69,   69,   75,   77,   18,   18,   18,   18,
			   78,   79,   83,   83,   12,   12,   12,   12,   12,    2,
			    2,    2,    2,   79,   79,   79,   79,   79,   12,   10,
			    1,    1,   20,   81,  112,    1,   62,    1,   12,    2,
			   83,   83,   83,   83,   83,   83,   95,   95,   18,    4,
			   79,   79,    9,    6,    4,    4,   24,    2,    2,   79,
			    1,    1,    1,    1,   18,    4,    4,   92,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,   18,    4,    4,    4,
			    4,    2,    4,   79,   79,   79,    4,    1,    9,    6,

			    4,    2,   83,    4,    1,   48,   48,    4,   48,    1,
			    1,   48,   79,    1,    1,   48,    4,    4,    4,    4,
			    4,    4,    4,    4,    4,    4,    4,    4,    4,    4,
			    4,   12,   12,   12,   12,    2,    4,   48,   92,    4,
			    4,    3,    1,    1,    4,    4,    4,   79,    9,    2,
			   79,    4,    4,    2,   59,   59,   59,   59,   59,   59,
			   79,    1,    4,  111,  111,   12,    1,   12,   12,   12,
			   12,   12,    1,    4,    4,    4,   79,    1,  112,    1,
			   20,    2,    2,   22,    1,   57,  102,    1,   83,   12,
			   13,    4,    1,    1,   95,    1,    1,   79,    4,    4,

			   27,   48,    4,    4,  105,    2,    4,    1,    2,   26,
			   35,    2,    2,   64,    2,   35,  105,    2,    4,    4,
			    4,    4,   48,   91,   48,   91,    4,   20,    1,   35,
			    1,   48,   48,   48,   48,   48,   48,   48,   48,   48,
			   48,   48,   48,   48,   12,   48,   48,   12,   48,   48,
			   48,    2,   35,   35,    2,    1,    1,    1,    1,    4,
			    4,    1,    4,  111,    1,    2,    2,    2,    1,    1,
			    4,   79,    1,    4,  112,    1,    1,    4,    1,    1,
			   20,   48,    2,   21,   22,  102,    1,    4,    4,    4,
			   31,   31,   33,    5,    3,   43,    2,   57,   59,   69,

			   69,   69,   69,   69,   69,   18,   79,   84,    1,    1,
			   18,   18,    1,   12,    4,    4,   34,  114,    2,    2,
			    4,    2,    4,    1,    4,   91,  105,    4,   92,  105,
			  105,   27,   18,    2,   91,    1,    4,    1,    4,    4,
			    4,   20,   91,   48,   48,  105,   92,    4,    4,   79,
			  111,    4,  100,    1,    4,    1,    1,    1,   20,    4,
			    4,   22,    1,  102,   84,   12,   78,    4,    1,    4,
			   12,   12,  102,   12,   79,  102,    4,    1,    1,    1,
			   12,    4,  102,   92,   92,  105,    4,   48,   65,   79,
			  104,   92,    1,   26,   64,  105,    4,    4,    4,    2,

			   35,    1,    1,    4,    2,    2,   79,   79,   79,   79,
			  111,  112,  111,    1,    4,    1,   12,   19,    4,   48,
			   22,    4,   12,    2,   84,   12,    1,   19,   74,  102,
			   12,   17,    1,  112,    4,  102,   12,   79,  102,    1,
			  104,    4,    1,    4,   91,  105,    4,    4,    4,  111,
			    4,    4,    4,   12,   12,   54,   55,    2,  100,   18,
			   19,    4,   84,    4,   18,   74,    1,    1,    2,   12,
			   12,  102,    1,    1,   74,  102,   17,    1,    4,    4,
			    1,   79,    1,  111,    2,    2,   55,  100,    1,   12,
			  106,   12,   71,   12,  102,    8,   31,   39,  102,    4,

			    1,    1,   12,  104,  111,  112,    4,    4,    2,  111,
			    4,  115,    4,    4,    4,    1,    1,   12,   71,   12,
			  113,    1,  102,    1,   74,  102,    1,    4,   79,  100,
			    2,   66,   66,   80,  106,   87,    1,   71,   22,    1,
			   12,   12,   12,   10,   49,   60,   73,  102,    1,   74,
			    2,  112,    1,   12,   96,  111,  106,    4,   12,   12,
			   12,   12,   12,   90,   97,   98,   99,  108,    1,   12,
			   86,   12,   12,   41,   87,   22,  112,   15,    1,   49,
			   15,   12,   46,    1,    4,   95,    1,  106,   95,   95,
			    1,   95,    4,    1,   97,   97,   98,   98,   99,   99,

			   12,   90,   90,    1,   94,    1,    4,   38,  101,   38,
			  101,   87,    1,    1,    1,   50,   18,   12,   46,   12,
			   16,   12,    1,   12,   83,   95,   70,   83,  107,   47,
			   89,  101,   98,   99,   12,   97,   40,   83,   86,    1,
			   12,   38,   52,   94,    4,    1,   95,   95,   87,   12,
			   12,   12,   12,   12,   12,    7,    6,    4,   29,   30,
			   32,   35,   37,   42,   44,   48,   48,   48,    2,   56,
			   58,   14,   14,   63,   68,   72,   15,   19,   46,   22,
			   15,   12,   95,    1,  107,   12,    1,   89,    1,   12,
			   53,   95,   99,   12,   98,   86,    4,    4,    1,   62,

			   38,    1,    1,   94,    1,    2,  101,   48,   48,   15,
			    4,  110,    6,   25,    2,   79,   22,    4,    4,    4,
			   79,    4,    4,    4,   15,    1,    1,   22,    4,    4,
			   83,   89,    4,   12,   99,    4,    4,    4,  102,   38,
			  101,   51,   93,   94,  101,    1,   85,    1,   12,   12,
			   23,    4,    1,   15,   27,   25,   12,   48,   48,   25,
			    4,   48,   48,   48,   15,   95,  107,   12,   86,  111,
			  111,   12,   93,    1,    4,    4,   12,   12,   12,   36,
			   85,   15,   22,   12,   82,   18,  109,   12,   27,   27,
			   25,    4,    4,   93,    1,  101,   15,    1,   85,    1,

			   12,   12,   16,   88,    1,   48,    2,   12,  109,    1,
			   27,    4,   12,    3,    2,   59,   61,   68,   79,  103,
			   85,   15,   12,   12,   16,   12,   45,   88,    4,   48,
			    4,    4,    4,    4,    4,  103,    4,    1,   12,   12,
			    1,   48,    1,   88,    1,   48,   12,  109,    3,    2,
			   68,   79,    3,    2,   59,   68,    2,   59,   68,   79,
			    4,    3,    2,   59,   68,   12,   15,   12,    1,   88,
			    1,   15,  103,   15,    1,   15,   12,    1,    1,    1, yyDummy>>)
		end

	yytypes2_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			    1,    1,    1,    4,    4,   12,   12,   12,   12,    4,
			    4,    4,    4,    4,    4,    4,    4,    4,    4,    4,
			    4,    4,    2,   12,   12,   12,    4,    4,    2,    2,
			    2,    2,    1,    1,    3,    4,    4,    4,    4,    4,
			    4,    4,    4,    4,    4,    4,    4,    4,    4,    4,
			    4,    4,    5,    5,    6,    7,    8,    9,   10,   11,
			   12,   12,   12,   12,   12,   12,   12,   12,   12,   12,
			   12,   12,   12,   12,   12,   12,   12,   12,   12,   12,
			   12,   12,   12,   12,   12,   12,   12,   12,   12,   12,
			   12,   12,   12,   12,   12,   12,   12,   12,   12,   12,

			   12,   12,   12,   12,   12,   12,   12,   12,   12,   12,
			   12,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1, yyDummy>>)
		end

	yydefact_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			   13,  595,  335,   16,  595,    0,  497,  498,  496,  495,
			    0,   39,    1,  595,  337,    6,  595,    3,    0,  560,
			  568,  567,  566,  565,  564,  563,  562,  561,  559,  558,
			  557,  556,  555,  554,  553,  552,  551,  550,  549,  545,
			  548,  544,  547,    0,    0,    0,    0,    0,  484,    0,
			  436,  479,  480,  515,  514,    0,    0,    0,    0,    0,
			  595,    0,  595,  516,  532,  523,  540,    0,    0,    0,
			    0,  455,    0,    0,  405,  437,  477,  417,  511,  505,
			  481,  408,  510,  482,  445,    4,  413,  446,  414,  472,
			    0,  484,  506,  411,  453,  507,  406,  407,  465,  464,

			  508,  412,  454,  509,  438,  372,  512,  543,  541,  542,
			  478,  452,  473,  474,    0,    0,    0,    0,  493,  494,
			  595,  492,  255,    2,  242,  241,  252,  253,   40,   41,
			    0,   41,   66,    0,  599,    0,  595,  595,    0,   81,
			   82,   83,   79,   77,   71,    0,  599,    0,  513,    0,
			    0,  403,  383,  382,  385,    0,    0,  472,  386,  384,
			  572,  571,  570,  569,   85,    0,  595,  462,  590,  589,
			  588,  587,  586,  585,  584,  583,  582,  581,  580,  579,
			  578,  577,  576,  575,  574,  573,   84,    0,    0,    0,
			    0,  386,    0,    0,    0,    0,  591,    0,  443,  444,

			    0,   81,  441,  593,    0,    0,  439,  595,  450,  534,
			  522,  448,    0,  533,  521,  449,    0,  595,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,  451,  475,    0,
			    0,  517,  537,  526,    0,    0,    0,  247,  251,  250,
			  246,    0,    0,  249,  248,  518,  519,  520,  524,  525,
			    0,  596,  595,  256,  254,   42,   36,   43,   44,    0,
			   41,   41,   35,   66,   67,    0,   66,  173,  595,    8,
			    0,  180,    0,  336,    0,   23,  599,    0,   78,    0,
			   80,   75,   74,   73,   72,    0,   70,    0,    0,    0,

			  399,    0,    0,  595,  370,    0,  485,    0,  386,  469,
			  456,  472,  484,  468,  386,  457,  373,  386,  403,    0,
			  410,    0,  489,  599,    0,  599,  483,    0,  595,  458,
			    0,  424,  423,  422,  421,  420,  419,  418,  431,  433,
			  432,  434,  415,  416,    0,  425,  430,    0,  427,  429,
			  435,  386,  460,  461,  484,  539,  528,  538,  527,    0,
			    0,    0,  258,    0,    0,  490,  273,  491,   38,   37,
			    0,   66,  177,    0,  171,  599,  178,  185,  184,  183,
			  595,   66,  472,  237,  599,  595,   14,   30,    0,    0,
			   29,   32,  503,  499,  500,    0,   31,  599,  501,  502,

			  529,  530,  531,  535,  536,  504,    0,   66,   89,   88,
			   87,   90,   76,   13,   13,    0,  210,   13,  484,  484,
			  381,  386,  387,    0,  484,  599,  377,    0,  476,  376,
			  379,  400,  546,  386,    0,    0,  442,    0,    0,    0,
			  440,  599,  599,  426,  428,  374,  466,    0,  257,  262,
			  599,  595,  197,  175,  174,  176,  179,  186,  181,  238,
			   66,    0,  234,   22,    0,   33,    0,    0,   24,   26,
			   91,   86,    0,   13,  107,    0,  166,  169,  595,   68,
			   13,   13,    0,  467,  404,  371,  392,  394,  391,  452,
			  599,  463,    0,  470,  471,  378,    0,  592,  594,  386,

			  459,  188,    0,  264,  492,  255,    0,  245,  253,    0,
			  265,  266,    0,  259,  274,    0,    0,   45,  240,   66,
			  236,    0,   34,   31,   66,    0,   95,  190,   94,    0,
			    0,   17,   99,  599,  211,    0,   13,  107,    0,  106,
			    0,  393,    0,  486,  488,  375,  447,  597,    0,  256,
			  267,  597,    0,    0,    0,  283,  278,  281,  599,  198,
			  112,  239,   28,   25,   46,  223,   98,  109,  108,   20,
			   13,   92,    0,  101,  100,    0,    0,  105,    0,  388,
			    0,   66,    0,  261,  279,  280,  284,    0,    0,  595,
			   10,  225,  201,   18,  595,  111,  110,   17,    0,  167,

			  168,  104,   13,  390,  268,  271,  270,  598,  492,  269,
			    0,  282,    0,  275,  113,    0,  595,  227,  595,  595,
			    0,  595,   93,   97,   96,    0,    0,  597,  286,  277,
			  255,  117,   66,  120,  599,  143,    0,  595,  224,  595,
			  210,  195,  210,  193,  192,  191,  228,  599,  103,  102,
			    0,  272,    0,  595,  285,  119,    0,  118,  595,  595,
			  595,  595,  595,  154,  158,  162,    0,  132,  114,  595,
			  595,  364,  367,  363,  599,  226,  599,  200,  595,    0,
			  199,  230,  348,    0,  597,    0,    0,  116,  157,  165,
			    0,  161,  135,    0,  155,  158,  159,  162,  163,    0,

			  121,  133,  154,    0,   11,    0,  595,  595,  366,  595,
			  369,    0,  360,  203,    0,  197,  196,  232,  595,  210,
			    0,   19,    0,  287,  153,  599,  130,    0,  599,  138,
			  599,  595,  162,    0,  122,  158,  147,    0,  599,  335,
			   55,  595,   51,  599,   58,    0,  365,  368,  362,    0,
			    0,  210,  342,    0,  595,  222,  480,    0,  215,  214,
			  417,  408,  221,  212,  220,  213,    0,  446,  472,  217,
			  218,  208,  210,  219,  407,  216,  599,  194,  595,  229,
			  349,  189,    0,  150,    0,    0,  127,    0,  134,  141,
			   66,  142,    0,  123,  162,    0,    0,    0,  144,   13,

			   56,  595,   52,    0,   48,   62,  599,  595,    0,  333,
			  595,  210,  402,  403,  401,  403,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,  209,  205,  231,    0,    0,
			  131,  137,  139,  124,    0,    0,  595,  595,    0,   54,
			   57,   65,  599,   50,    0,    0,    0,    0,  210,  595,
			  338,  343,    0,    0,  397,  403,  409,  358,  356,  403,
			  403,  354,  357,  355,  207,  152,  129,  125,  146,    0,
			    0,    9,  595,   12,    0,   59,  210,  303,  595,  309,
			  599,  595,  334,    0,    0,  347,  599,  341,  398,  395,
			  403,  149,    0,   64,   53,   61,    0,    0,    0,  306,

			  210,  288,    0,    0,    0,  340,  472,    0,    0,    0,
			  396,  148,  304,  316,  318,  314,  313,  324,    0,  599,
			  308,  302,  289,  290,    0,    0,    0,  599,    0,    0,
			    0,  344,    0,    0,    0,    0,    0,    0,  291,  210,
			  301,    0,  297,    0,    0,  339,  210,  346,  317,  323,
			  331,    0,  322,  319,  320,  326,  321,  315,  329,    0,
			    0,  330,  325,  328,  327,  210,    0,  210,  299,  295,
			  293,    0,  312,  310,  300,  298,  332,    0,    0,    0, yyDummy>>)
		end

	yydefgoto_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			  275,  471,  290,  902,  720,  531,  517,  527,  132,  280,
			  327,  850,  156,   74,  813,  309,  300,   75,  758,  759,
			  390,  391,   76,   77,   78,  416,   79,   80,  310,   81,
			  879,   82,  762,  269,  707,  741,  597,  736,  673,  763,
			   83,  764,  926,  682,  729,   84,  322,   86,  766,   87,
			   88,  644,  715,  841,  742,  790,  555,  556,  805,  122,
			   89,  282,   90,   91,  769,  285,  397,  770,  771,  772,
			  398,   92,   93,  257,   94,   95,  645,  916,   15,  773,
			  313,  488,  631,  632,   96,   97,   98,   99,  399,  100,
			  101,  402,  102,  103,  726,  592,  775,  646,  528,  104,

			  105,  106,  107,  108,  109,  186,  164,  411,  383,  110,
			  506,  124,  111,  125,  126,  127,  509,  633,  133,  884,
			  112,  113,  142,  143,  144,  145,  407,  846,  880,  738,
			  670,  635,  674,  903,  927,  730,  663,  702,  323,  167,
			  842,  704,  743,  685,  725,  146,  147,  654,  694,  695,
			  696,  697,  698,  699,  452,  558,  731,  806,   11,  286,
			  571,  677,  776,  919,  490,  304,  590,  634,  728,  667,
			  886,  811,  283,  384,  263,  264,  363,  450,  604,  134,
			  605,  620,  417,  611,  977,   12,  284,  279,  130,  616,
			  739,  802,   16,  594,  385,  464,  131,  266,  803,  800,

			  844,  872,  678,  292,  656,  784,  787,  795,  782,  278,
			  380,  378,  565,  679,  824,  618,  637,  718,  778,  461,
			  512,  361,  580,  626,  587,  586,  943,  898,  935,  136,
			  908,  711,  540,  434, yyDummy>>)
		end

	yypact_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			 1199, 1070,  580, 2438, -32768, 1838, -32768, -32768, -32768, -32768,
			 2612,   52, -32768, -32768, -32768, -32768, -32768, -32768, 1083, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, 2291, 1024, 1024, 1511,  436,  413, 2860,
			 -32768,  268,  250, -32768, -32768,  765,  862, 2612, 2612, 2612,
			 1030, 1631, 1029, -32768, -32768, -32768, -32768, 1838, 1838, 1028,
			 1838, -32768, 2198, 2078, 1026, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, 1025, 3058, -32768, -32768, -32768,  999,
			 1838,  910, -32768, -32768, -32768, -32768, 1020, 1017, -32768, -32768,

			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, 1410, -32768, -32768,  731,  559,  165, 1406, -32768, -32768,
			 2591, -32768,  729, -32768, -32768, -32768, -32768, -32768, -32768,  911,
			  228,  319, 1033, 2631, -32768,  765,   27, -32768, 1132,  975,
			 -32768, -32768, -32768, -32768,  939,  704, -32768,  119, -32768, 2612,
			 1016,  387, -32768, -32768, -32768, 1838, 1012, 1006,  864, -32768,
			 -32768, -32768, -32768, -32768, -32768,  165,  988, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768,  765, 1132,  765,
			 1132,  864,  765,  983,  978,  128, -32768, 1838, -32768, -32768,

			 1838, -32768, -32768, -32768, 1838, 2952, -32768,  967, -32768, -32768,
			 -32768, -32768,  310, -32768, -32768, -32768, 1132, -32768, 1838, 1838,
			 1838, 1838, 1838, 1838, 1838, 1838, 1838, 1838, 1838, 1838,
			 1838, 1718, 1838, 1598, 1838, 1838,  765, -32768, -32768, 1132,
			 1132, -32768, -32768, -32768,  765,  543,  531, -32768, -32768, -32768,
			 -32768,  982,  974, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			  588, -32768,  962, -32768, -32768, -32768, -32768, -32768, -32768,  699,
			  911,  911, -32768, 2619, -32768,  994,  575, -32768, -32768, -32768,
			  379,  914,  551, -32768, 1838,  903, -32768, 2318, -32768, 2928,
			 -32768,  939, -32768, -32768, -32768,  168, -32768,  950,  765,  765,

			 -32768, 2914, 1132,  947, -32768,  949, -32768, 1838,  864,  867,
			 -32768, -32768,  910, -32768,  864, -32768, -32768,  864,  387, 2884,
			 -32768,  765, 2858, -32768, 2896, -32768,  154,  943, -32768, -32768,
			 1838,  524,  524,  524,  524,  524,  790,  790, 1781, 1781,
			 1781, 1781, 1781, 1781, 1838, 3103, 3089, 1838, 3074, 2933,
			 -32768,  864, -32768, -32768,  910, -32768, -32768, -32768, -32768,  952,
			  951,  945, -32768,  940, 2612, -32768,  938, -32768, -32768, -32768,
			  971,  575, -32768,  965, -32768, -32768, -32768,  914, -32768, -32768,
			 -32768, 2840,  266,  566, -32768, -32768, -32768, -32768,  495,  448,
			 1057, -32768, -32768, -32768, -32768,   74,  891, -32768, -32768, -32768,

			 -32768, -32768, -32768, -32768, -32768, -32768,  677,  575, -32768, -32768,
			 -32768,  881, -32768,  500, 2430,  519, -32768,  200,  910,  910,
			 -32768,  864, -32768, 1958,  910, -32768, -32768, 1132, -32768, -32768,
			 -32768, -32768, -32768,  864,  882,  885, -32768,  889,  765, 1132,
			 -32768, -32768, -32768, 3103, 3074, -32768, -32768, 2551, -32768,   70,
			 -32768,  887,  648, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 1478, 1838, -32768, -32768,  873, -32768,  849, 2318, -32768, -32768,
			 -32768, -32768,  805,  500,  797,  919, -32768, -32768, -32768,  478,
			  500,  946,  917, -32768, -32768, -32768,  862, 3058,  870, 1537,
			 -32768, -32768,  858,  867, -32768, -32768, 1838, -32768, -32768,  864,

			 -32768, -32768,  853, -32768,  384,  729,  851,  844,  830,  829,
			 -32768, -32768,  825, -32768, -32768,  251, 2908,  775, -32768, 2840,
			 -32768, 2318, -32768, -32768,  575, 2291, -32768, -32768, -32768,  869,
			  383,   32, -32768, -32768, -32768,  703,  500,  797,  865, -32768,
			  817, -32768,  811, -32768, -32768, -32768, -32768, -32768, 2612,  808,
			 -32768, -32768, 2612,  165,  165, -32768,  815, -32768, -32768, -32768,
			  757, -32768, -32768, -32768, -32768,  744, -32768, -32768, -32768,  782,
			 2484, -32768,  100, -32768, -32768,  837,  747, -32768, 1958, -32768,
			  886,  166,  361, -32768, -32768, -32768,  787,  754,  762,  977,
			 -32768,  711,  687, -32768, -32768, -32768, -32768,  684,  678, -32768,

			 -32768, -32768,  500, -32768, -32768, -32768, -32768, -32768,  720, -32768,
			  731, -32768,  251, -32768, -32768,  165,  450, -32768, 1181,  391,
			  351, -32768, -32768, -32768, -32768,  627,  667, -32768,  689, -32768,
			  729, 1496,  575, 1148, -32768,  679,  186, 1181, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768,  672, -32768, -32768, -32768,
			  339, -32768,  361, -32768, -32768, -32768,  165, -32768,  -16,  691,
			  908,   15,  225,  618,  577,  463,  683,  657, -32768, -32768,
			  226, 1454, 1454,   92, -32768, -32768, -32768, -32768,  491, 2908,
			 -32768,  636,  635,  674, -32768,  671, 1132, -32768, -32768, -32768,
			 1132, -32768, -32768,  535, -32768,  577, -32768,  463, -32768,  666,

			 -32768, -32768,  618, 1132, -32768,  479,  676, -32768, 1267, -32768,
			 1267,  186, -32768, -32768, 1341,  648, -32768, -32768,   24, -32768,
			  642, -32768,  667, -32768, 2732, -32768,  574,  623, -32768,  375,
			 -32768,  549,  463,  620, -32768,  577,  989,  354, -32768,  580,
			 -32768,  819,   36, -32768, -32768,  699, -32768, -32768, -32768, 1838,
			 1838, -32768,  639,  973,  611, -32768,   60, 1255, -32768, -32768,
			  662,  659, -32768, -32768, -32768, 3058,  644,  641,   67, -32768,
			 -32768,  533, -32768, -32768,   69, -32768, -32768, -32768,   24, -32768,
			 -32768, -32768,  589, -32768,  585, 1132, -32768,  535, -32768, -32768,
			  575, -32768,  542, -32768,  463,  564,  562,  554, -32768,  500,

			  535, -32768, -32768,  479, -32768,  513, -32768, 2742, 2367,  451,
			  496, -32768, -32768,  387, -32768, 1094,  481, 1838, 1838, 1005,
			  490, 1838, 1838, 1838, 1341,  478, -32768, -32768, 1132, 1132,
			 -32768, -32768, -32768, -32768,  462, 1132, -32768, -32768,  457, -32768,
			 -32768,  578, -32768, -32768,  445,  446,  315,  283, -32768,  230,
			  360, -32768, 2908,  405, -32768,  387, -32768, 3058, 3058,  387,
			 1094, 3058, 3058, 3058, -32768, -32768, -32768, -32768, -32768,  419,
			  414, -32768, -32768, -32768,  699, -32768, -32768, -32768, -32768,  282,
			 -32768,  275, -32768, 1838,  338,  363, -32768, -32768, -32768, -32768,
			  387, -32768,  340, -32768, -32768, -32768,  316, 2751,  283, -32768,

			 -32768, -32768,  303,  213,  110, 3058,  123, 1838,  324,  272,
			 -32768, -32768, -32768,  345,  300,  291,  175,  260,  724, -32768,
			 -32768, -32768, -32768, -32768,  202, 1191,   81, -32768, 1838, 2724,
			 2908, -32768,  758, 2751, 2758,  204, 2751,  107, -32768, -32768,
			 -32768,  934, -32768,  110,   64, 3058, -32768, -32768, -32768, -32768,
			 -32768,   42, -32768, -32768, -32768, -32768, -32768, -32768, -32768,  614,
			 2751, -32768, -32768, -32768, -32768, -32768,  178, -32768, -32768, -32768,
			 -32768,  116, -32768, -32768, -32768, -32768, -32768,  153,  129, -32768, yyDummy>>)
		end

	yypgoto_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			 -259, -32768, -32768,  306, -32768,  668,  488,  685, -287, -32768,
			 -32768, -32768, -32768, -32768, -755,  774, -306, -32768, -32768, -32768,
			 -32768,  630, -32768, -684, -193, -32768, -209, -32768, -159, -685,
			 -32768, -214, -32768, -32768, -640, -32768, -32768, -32768, -32768, -32768,
			 -229, -32768, -32768, -32768, -32768, -32768,   -1,  545, -32768, -691,
			 -32768, -32768, -32768, 1195, -32768, -32768, -32768, -32768,  927, -137,
			    0, -32768,  163,  -33, -32768, -32768, -32768, -32768, -32768, -32768,
			  -72,  -79,  -84, -32768,  -93, -102, -32768, -32768,  458, -32768,
			  767, -32768, -32768, -32768, -32768, -374, -32768, -32768, -32768, -210,
			 -213, -32768, -216, -225, -32768, -32768, -32768, -32768, -495, -32768,

			 -32768,    4, -515,  874, -32768,  878, -32768, -32768, -32768,  770,
			   33, -321,  -38,  -92, 1041, -411, -32768, -32768, -32768, -32768,
			  182,   -2,  -51, -136, -32768, -32768, -414, -32768,  258,  312,
			 -32768, -32768,  447, -32768,  207,  365,  474, -32768, -199,  -66,
			  271, -32768,  342, -311,  305,  992, -32768, -32768,  502,  426,
			  498, -572,  497, -647, -32768,  515, -623,  247, -203, -365,
			  527, -278,  289,  147,  521,  -42, -32768,  441,  269, -32768,
			  164, -32768, -581,  632,  590,  453, -226,  532, -426, -269,
			 -428, -32768, -32768, -32768, -32768, -32768,   38,  606, -32768, -32768,
			 -32768,  209, -32768, -32768, -32768, -32768, -32768, -120, -32768, -32768,

			 -32768, -32768, -413,  785, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768,  697, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -525, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, yyDummy>>)
		end

	yytable_template: SPECIAL [INTEGER] is
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make (0, 3125)
			yytable_template_1 (an_array)
			yytable_template_2 (an_array)
			Result := yyfixed_array (an_array)
		end

	yytable_template_1 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			   10,  559,  288,  479,   85,  325,  150,  151,  159,  374,
			  202,  272,  431,  158,  370,  259,  141,  373,  139,  511,
			  463,  510,  247,  767,  258,  238,  582, -233,  305,  761,
			  760,  315,  709,  256,  212,  212,  508,  638,  255,   13,
			  574,  441,   18,  123, -156,  254,  157,  148,  708,  710,
			  733,  135,   -5,  524,  137,  191,  675,  329,  395,  141,
			  855,  201,  404,  818,  859,  970,  205,  206,  244,  208,
			  823,  403, -353,  394,  401, -160,  241,  400,  393,  260,
			  352,  353,  942, -156, -233,  792,  190, -233, -156,  237,
			  193,  194,  195,  458,  392,  240,  -49,  817,  197,  570,

			  204,  600,  652,  624,  822,  890, -260,  562,  425,   62,
			  129,  189,  454,  128, -260,  249, -233,  253,  236, -160,
			  296,  569,  459,  732, -292,  -49,  507, -233,  -49,  979,
			  649,  442,  367,  767,  465,  281,  141,  779,  139,  761,
			  760, -294,  599,  141, -292,  139,  -69,  834,  469,  316,
			  368,  369, -361,  978,  301,  312,  609,  312,  261,  722,
			  839, -294, -296,  794,  716,  276,  -69,  321, -361,  508,
			  928,  508,  320,  816,  236,  287,  976,  840, -361,  974,
			  439, -361,  297,  312, -361,  259,  -69,  308,  311,  314,
			  311,  925,  317,  121,  258,  415,  119,  827,  651,  324,

			  140,  518,  606,  256,  307,  438,  312,  312,  255,  533,
			  472,  475,  274,  965,  482,  414,  311,  331,  332,  333,
			  334,  335,  336,  337,  338,  339,  340,  341,  342,  343,
			  345,  346,  348,  349,  350,  413,  351,  118,  395,  311,
			  311,  508,  404,  140,  354,  328,  428,  481,  235,  406,
			  672,  403,  960,  394,  401,  330,  647,  400,  393,  507,
			  561,  507,  938,  671,  936,  563,  426,  480,  882,  421,
			  529,  274,  429,  923,  392,  430,  190,  535,  538,  121,
			  500, -311,  119,  381,  382,  -66,  -47,  396,  446,    3,
			  268,  405,  395,  900,  188,  934,  404,  544,  418,  419,

			  364,  189,  311,  267,  933,  403,  371,  394,  401,  445,
			  505,  400,  393,  460,  931,  -47,  135,  236,  -47,  187,
			  140,  433,  607,  118,  -66,  246,  245,  140,  392,  -66,
			  614,  507,  -66,  575,  554,  901,  244,  885, -233, -233,
			  774,  423, -307,  443,  241,  404,  444,  688,  689,  932,
			  691,  553,  483,  484,  403,  900,  394,  401,  491,  825,
			  400,  393, -307,  922,  680,  259,  135,  598,  235,  235,
			  676,  235,  930,  657,  258,  877,  912,  392,  557,  485,
			  375,  797,  911,  256,  567,  489,  548,  684,  255,  608,
			  120,  495,  119,  878,  312,  876,  746,  449,  747,  625,

			  235,  796,  271,  692,  265, -345,  312, -599, -599,  643,
			 -599,    9,    8,  299,    7,  885,  584,  585,  135,  259,
			  791, -599,  487,  287,  270, -599, -599,  311,  258,  406,
			  642,  548,  547,  118,  117, -136,  641,  256,  499,  311,
			  166,  780,  255,  505,  116,  505,  907,  474,  640, -202,
			  774, -599, -599,  478,  115,    6,  165,  545,  892,  519,
			  381,  382, -599,  891,  235,  887,  114,  523,  259,  883,
			 -202,  405, -599,  809, -136,  557, -202,  258,  630, -136,
			  214,  213, -136,  406, -599,  235,  256,  235, -202,  515,
			  875,  255, -204,  874,  235,  235,  235,  235,  235,  235,

			  235,  235,  235,  235,  235,  235,  235,  854,  235,  235,
			 -359,  235,  235,  235,  537,  505,  135,  871,  628,  630,
			  477,  523,  867,  917,  534,  405, -359,  210,  209,  564,
			  568,  832,  406,  853, -206,  860, -359,  534,  851, -359,
			  489,  856, -359,  849,  235,  218,   71, -595, -595,  888,
			 -595, -204,  379,  889,  431,  163,  162,  -60,  950,  955,
			  958,  476,  964,  358,  357,  740, -235,  659,  161,  160,
			  881, -204, -204, -204,  405,  356,  355,  487,  706, -182,
			 -182,  581, -182, -204,  910,  449,  917,    9,    8,    3,
			    7, -595, -140, -206, -204, -140,  838,  837,  896, -204,

			 -204, -204,  833,  360,  359,  836,  235,  235,  367, -140,
			  869,  870,  835, -206, -206, -206,  248,  211,  215,  789,
			  243,  274,  921, -182, -235, -206, -235,  615,  648,  360,
			  359,    6,  621,  829, -128,  724, -206,  828,  -63,  727,
			  244, -206, -206, -206, -351, -235,  243,  821, -140,  830,
			  235, -235,  737, -140,  636, -235, -140,  639, -128,  287,
			 -235,  966, -352, -235,  -63, -350,  810,  -63,  971, -235,
			  -63, -233,   14, -128, -235, -235,  661,  135, -128,  623,
			  793, -128,  235,  913,  141,  -45,  201,  973,  141,  975,
			  201,  686,  246,  245,  785,  650,  686,  686,  690,  686,

			  693,  141,  781,  201,  573,  293,  -45,  703,  705,  243,
			  242,  241,  -45,  765,  768,  815,  714,  516,  948,  952,
			  744,  -45,  961,  525,  -45,  658,  734,  121,  365,  -45,
			  119,  723,    9,    8,  721,    7,  -45,  367,  719,  360,
			  359,  662,  717,  700,  745,  686,  913,  686,  807,  808,
			  244, -164,  295,  814,  681,  669,  243,  -45,  241,  121,
			  120,  -45,  119,  -45,  262,  138,  653,   49,  627,  686,
			   47,  118,  -45,  569,  525,  -45,    6,  724,  727,  801,
			  -45,  619,  -45,  141,  737,  139,    9,    8,  -45,    7,
			  820,  617,   63,    9,    8,  259,    7,  -45,  613,  525,

			  -45,  149,  612,  118,  258,  -45,  526,  222,  221,  220,
			  219,  218,   71,  256,  602,  814,  857,  858,  255,  814,
			  861,  862,  863,  765,  768,  915,  141,  141,  201,  201,
			    6,  259,  259,  141,  259,  201,  610,    6,  601,   18,
			  258,  258,  593,  258,   44,  847,  591,  589,  852,  256,
			  256, -276,  256,  579,  255,  255, -243,  255,  259,  918,
			  814,  954,  957,  -45,  963,  578,  577,  258,  140,  530,
			  566,  525,  140,  552,  364,  364,  256,  551, -244,  -12,
			 -242,  255,  905,  906,  -45,  140,  376,  550,  915,  546,
			  -45,  303,  386,  427,  951,  918,  959,  914,  918,  -45,

			  543,  525,  -45,  -21,  -21,  -12,  929,  -45,  -12,  522,
			   18,  -12, -389,  192,  504,  120,  897,  119,  539,  904,
			  532,  521,  918,  514,  941,  498,  497,  945,  235,  435,
			  496,  437,  949,  953,  956,  968,  962,  166,  467,  234,
			  233,  232,  231,  230,  229,  228,  227,  226,  225,  224,
			  223,  222,  221,  220,  219,  218,   71,  470,  118,  117,
			  914,  -21,  377,  -21,  -21,  -21,  455,  140, -126,  116,
			  235,  235,  453,  451,  121,  120,  448,  119,  -21,  115,
			  447,  456,  -21,  358,  356,  440,  -21,  291,  -21,  422,
			  462,  114, -126,  424,  320,  372,  265,  -21,  362,  -21,

			  -21,    9,    8,  468,    7,  -21,  214, -126,  -21, -187,
			  140,  140, -126,  536,  210, -126,  149,  140,  118,  117,
			  235,  235,  319,  274,  235,  235,  235,  812,  318,  116,
			  306,  492, -380,    9,    8,    3,    7,  -66,  302,  115,
			  967,  -66,  298,  240,  289,    6,  239,  501,  502, -145,
			  236,  114,  216,  -66,  -66,  207,  513,  -27,  -27,  812,
			  217,  121,  120,  -66,  119,  203,  -66,  149,  235,  -66,
			   -7,  196,  -27,  -27,  457, -145,  412,    6, -145,  274,
			  273, -145,  894,  655,  583,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  235,  520,  947,  549,  542,  687,  866,  603,

			  -27,  -27,  -27,  -27,  235,  118,  117,  972,  235,  -27,
			  -27,    9,    8,  864,    7,  -27,  116,  -27,  -27,  -27,
			  299,  895,    9,    8,  622,    7,  115,  629,  735,  -27,
			  666,  665,  -27,  865,  -27,  664,  -27,  294,  114,  572,
			  -27,  701,  -27,  893,  138,  843,   49,  868,  812,   47,
			  969,  -27,  831,  -27,  -27,    6,  920,  250,  748,  -27,
			    9,    8,  -27,    7,  588,  466,    6,  410,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  940,  432,  494,   49,  366,  799,   47,   17,

			  596,  493,  560,  777,    6,  576,   73,   72,    0,  924,
			    0,    0,    0,   71,   70,   69,   68,    0,   67,    9,
			    8,   66,    7,   65,   64,   63,   62,    9,    8,   61,
			    7,   60,  662,    0,   59,   58,   57,    0,    0, -233,
			  668,   56,   55,   54,   53,   52,    0,  661,   51,  660,
			   50,    0,  659,  683,   49,  658,   48,   47,    0,   46,
			 -233,    0,    0,    6,    0,    0, -233,    0,   45,    0,
			    0,    6,    0,    5,    0, -233,    0,   44, -233,    0,
			  712,    0,  713,  121,  120,    4,  119,    0,    3,   43,
			    0,    2,    0,    1,    0,  -57,  -57,  939,  -57,    0,

			  819,    0,   42,   41,   40,   39,   38,   37,   36,   35,
			   34,   33,   32,   31,   30,   29,   28,   27,   26,   25,
			   24,   23,   22,   21,   20,   19,    0,  118,  117,    0,
			  -57,  783,    0,  -57,  786,    0,  788,    0,  116,  -57,
			    0,    0,    0,    0,  798,    0,    0,    0,  115,  804,
			    0,    0,    0,    0,    0,    0,   73,   72,    0,    0,
			  114,    0,    0,   71,   70,   69,   68,    0,   67,    9,
			    8,   66,    7,   65,   64,   63,   62,    0,    0,   61,
			    0,   60,  826,    0,   59,   58,  757,    0,    0,    0,
			    0,   56,   55,   54,   53,  756,  755,    0,   51,    0,

			   50,    0,    0,    0,   49,    0,   48,   47,    0,   46,
			    0,    0,  845,    6,    0,  754,    0,    0,  753,  752,
			    0,  252,  251,    0,    0,  246,  245,   44,  751,  750,
			    0,    0,  749,    0,    9,    8,  244,    7,   65,   43,
			    0,    0,  243,  242,  241,    0,    0,    0,  873,  149,
			    0,    0,   42,   41,   40,   39,   38,   37,   36,   35,
			   34,   33,   32,   31,   30,   29,   28,   27,   26,   25,
			   24,   23,   22,   21,   20,   19,    0,    0,    6,    0,
			    0,    0,  -56,  -56,    0,  -56,  899,    0,    0,    0,
			    0,    0,  909,   73,   72,    0,    0,  706,    0,    0,

			   71,   70,   69,   68,    0,   67,    9,    8,   66,    7,
			   65,   64,   63,   62,    0,    0,   61,  -56,   60,    0,
			  -56,   59,   58,   57,  274,  937,  -56,    0,   56,   55,
			   54,   53,   52,  944,    0,   51,    0,   50,  155,    9,
			    8,   49,    7,   48,   47,    0,   46,    0,    0,    0,
			    6,    0,  246,  245,  149,   45, -115,    0,    0,    0,
			 -115,  154,    0,  244,   44,  153,    0,    0,  152,  243,
			  242,  241, -115, -115,   49,    0,   43,   47,    0,    0,
			    0,    0, -115,    6,    0, -115,    0,  541, -115,   42,
			   41,   40,   39,   38,   37,   36,   35,   34,   33,   32,

			   31,   30,   29,   28,   27,   26,   25,   24,   23,   22,
			   21,   20,   19,   73,   72,    0,    0,    0,    0,    0,
			   71,   70,   69,   68,    0,   67,    9,    8,   66,    7,
			   65,   64,   63,   62,    0,    0,   61,    0,   60,    0,
			    0,   59,   58,   57,    0,    0,    0,    0,   56,   55,
			   54,   53,   52,    0,    0,   51,    0,   50,  200,    9,
			    8,   49,    7,   48,   47,    0,   46,    0,    0,    0,
			    6,    0,    0,    0,    0,   45,    0,    0,  347,    0,
			    0,    0,    0,    0,   44,  199,    0,    0,  198,    0,
			    0,    0,    0,    0,   49,    0,   43,   47,    0,    0,

			    0,    0,    0,    6,    0,    0,    0,    0,    0,   42,
			   41,   40,   39,   38,   37,   36,   35,   34,   33,   32,
			   31,   30,   29,   28,   27,   26,   25,   24,   23,   22,
			   21,   20,   19,   73,   72,    0,    0,    0,    0,    0,
			   71,   70,   69,   68,    0,   67,    9,    8,   66,    7,
			   65,   64,   63,   62,    0,    0,   61,    0,   60,    0,
			    0,   59,   58,   57,    0,    0,    0,    0,   56,   55,
			   54,   53,   52,    0,    0,   51,    0,   50,    0,    0,
			    0,   49,    0,   48,   47,    0,   46,    0,    0,    0,
			    6,    0,    0,    0,    0,   45,  224,  223,  222,  221,

			  220,  219,  218,   71,   44,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,   43,    0,    0,    0,
			    0,    0,    0,    0,  344,    0,    0,    0,    0,   42,
			   41,   40,   39,   38,   37,   36,   35,   34,   33,   32,
			   31,   30,   29,   28,   27,   26,   25,   24,   23,   22,
			   21,   20,   19,   73,   72,    0,    0,    0,    0,    0,
			   71,   70,   69,   68,    0,   67,    9,    8,   66,    7,
			   65,   64,   63,   62,    0,    0,   61,    0,   60,    0,
			    0,   59,   58,   57,    0,    0,    0,    0,   56,   55,
			   54,   53,   52,    0,    0,   51,    0,   50,    0,    0,

			    0,   49,    0,   48,   47,    0,   46,    0,    0,    0,
			    6,    0,    0,    0,    0,   45,    0,    0,    0,    0,
			    0,    0,    0,    0,   44,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,   43,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,   42,
			   41,   40,   39,   38,   37,   36,   35,   34,   33,   32,
			   31,   30,   29,   28,   27,   26,   25,   24,   23,   22,
			   21,   20,   19,   73,   72,    0,    0,    0,    0,    0,
			   71,   70,   69,   68,    0,   67,    9,    8,   66,    7,
			   65,   64,   63,   62,    0,    0,   61,    0,   60,    0,

			    0,   59,   58,   57,    0,    0,    0,    0,  486,   55,
			   54,   53,   52,    0,    0,   51,    0,   50,    0,    0,
			    0,   49,    0,   48,   47,    0,   46,    0,    0,    0,
			    6,    0,    0,    0,    0,   45,    0,    0,    0,    0,
			    0,    0,    0,    0,   44,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,   43,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,   42,
			   41,   40,   39,   38,   37,   36,   35,   34,   33,   32,
			   31,   30,   29,   28,   27,   26,   25,   24,   23,   22,
			   21,   20,   19,   73,   72,    0,    0,    0,    0,    0,

			   71,   70,   69,   68,    0,   67,    9,    8,   66,    7,
			  214,  213,   63,   62,    0,    0,   61,    0,   60,    0,
			    0,   59,   58,   57,    0,    0,    0,    0,   56,   55,
			   54,   53,   52,    0,    0,   51,    0,   50,    0,    0,
			    0,   49,    0,   48,   47,    0,   46,    0,    0,    0,
			    6,    0,    0,    0,    0,   45,    0,    0,    0,    0,
			    0,    0,    0,    0,   44,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,   43,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,   42,
			   41,   40,   39,   38,   37,   36,   35,   34,   33,   32,

			   31,   30,   29,   28,   27,   26,   25,   24,   23,   22,
			   21,   20,   19,   73,   72,    0,    0,    0,    0,    0,
			   71,   70,   69,   68,    0,   67,    9,    8,   66,    7,
			  210,  209,   63,   62,    0,    0,   61,    0,   60,    0,
			    0,   59,   58,   57,    0,    0,    0,    0,   56,   55,
			   54,   53,   52,    0,    0,   51,    0,   50,    0,    0,
			    0,   49,    0,   48,   47,    0,   46,    0,    0,    0,
			    6,    0,    0,    0,    0,   45,    0,    0,    0,    0,
			    0,    0,    0,    0,   44,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,   43,    0,    0,    0,

			    0,    0,    0,    0,    0,    0,    0,    0,    0,   42,
			   41,   40,   39,   38,   37,   36,   35,   34,   33,   32,
			   31,   30,   29,   28,   27,   26,   25,   24,   23,   22,
			   21,   20,   19,  389,  388,   58,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    9,    8,   66,    7,
			   65,   64,   63,    0,    0,    0,    0,    0,    0,    0,
			    0,  149,   58,   57,  387,    0,    0,    0,    0,    0,
			   54,   53,  234,  233,  232,  231,  230,  229,  228,  227,
			  226,  225,  224,  223,  222,  221,  220,  219,  218,   71,
			    6,    0,    0,    0,    0,   45,    0,    0,    0,    0,

			    0,    0,   42,   41,   40,   39,   38,   37,   36,   35,
			   34,   33,   32,   31,   30,   29,   28,   27,   26,   25,
			   24,   23,   22,   21,   20,   19,    0,    0,    0,   42,
			   41,   40,   39,   38,   37,   36,   35,   34,   33,   32,
			   31,   30,   29,   28,   27,   26,   25,   24,   23,   22,
			   21,   20,   19,  -15,  -15,    0,    0,    0,  121,  120,
			    0,  119,    0,    0,    0,    0,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  848,    0,    0,    0,    0,    0,    0,
			    0,  -15,  -15,  -15,  -15,    0,    0,    0,    0,    0,
			  -15,  -15,    0,    0,    0,    0,    0,  473,    0,  389,

			  388,    0,  118,  117,    0,    0,    0,    0,    0,    0,
			  -15,    0,    0,  116,   66,  -15,   65,   64,   63,    3,
			    0,    0,    0,  115,    0,    0,    0,  149,   58,    0,
			    0,    0,    0,    0,    0,  114,   54,   53,    0,    0,
			  595,    0,    0,    0,    0,    0,    0,    0,    0,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,    3,    0,    0,    0,    0,    0,  504,
			  120,    0,  119,    0,    0,    0,    0,  503,    0,    0,
			    0, -263, -263,    0,    0,   42,   41,   40,   39,   38,

			   37,   36,   35,   34,   33,   32,   31,   30,   29,   28,
			   27,   26,   25,   24,   23,   22,   21,   20,   19, -263,
			 -263,    0, -263,  118,  117,    0,    0, -263,    0,    0,
			 -263, -170,  277, -263,  116, -263, -263, -263,    0, -263,
			  121,  120,    0,  119,  115,    0,    0,  121,  120, -263,
			  119, -263, -263,    0, -263,    0,  114, -263, -263, -172,
			 -172,    0, -172, -263,    0,  274,    0,    0, -263,    0,
			 -263,    0,    0, -170,    0,    0, -263, -263,    0,    0,
			 -263,    0,    0, -263,  118,  117,    0,    0, -263, -170,
			    0,  118,  117,    0,    0,  116,    0,    0,    0,    0,

			    0,    0,  116, -172,    0,  115,    0,    0,    0,    0,
			 -170,    0,  115,    0,    0,    0, -170,  114,    0,    0,
			    0,    0,    0,    0,  114,    0,    0,    0, -170,  234,
			  233,  232,  231,  230,  229,  228,  227,  226,  225,  224,
			  223,  222,  221,  220,  219,  218,   71,  234,  233,  232,
			  231,  230,  229,  228,  227,  226,  225,  224,  223,  222,
			  221,  220,  219,  218,   71,    0,  252,  251,    0,    0,
			    0,    0,    0,  252,  251, -151,    0,    0, -151,    9,
			    8,    0,    7,   65,    0,   63,    9,    8,    0,    7,
			   65,    0, -151,    0,  149,    0, -151,    0,    0,    0,

			    0,  149, -305,    0,    0,    0,    0,    0, -151, -151,
			    0,    0,    0,    0,    0,    0,    0,    0, -151,  946,
			    0, -151, -305,    6, -151,    0,    0,    0,    0,    0,
			    6, -151,    0,    0,    0,    0, -151,   44,    0, -151,
			    0,    0,    0,    0,   44,  234,  233,  232,  231,  230,
			  229,  228,  227,  226,  225,  224,  223,  222,  221,  220,
			  219,  218,   71,  234,  233,  232,  231,  230,  229,  228,
			  227,  226,  225,  224,  223,  222,  221,  220,  219,  218,
			   71,    0,    0,    0,    0,    0,  274,    0,    0,    0,
			    0,    0,    0,    0, -487,    0,    0,    0,    0, -487,

			 -487,  234,  233,  232,  231,  230,  229,  228,  227,  226,
			  225,  224,  223,  222,  221,  220,  219,  218,   71,  234,
			  233,  232,  231,  230,  229,  228,  227,  226,  225,  224,
			  223,  222,  221,  220,  219,  218,   71,    0,  436,  233,
			  232,  231,  230,  229,  228,  227,  226,  225,  224,  223,
			  222,  221,  220,  219,  218,   71,  420,  234,  233,  232,
			  231,  230,  229,  228,  227,  226,  225,  224,  223,  222,
			  221,  220,  219,  218,   71,  185,  184,  183,  182,  181,
			  180,  179,  178,  177,  176,  175,  174,  173,  172,  171,
			  170,  169,    0,  168,  326,   42,   41,   40,   39,   38, yyDummy>>,
			1, 3000, 0)
		end

	yytable_template_2 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			   37,   36,   35,   34,   33,   32,   31,   30,   29,   28,
			   27,   26,   25,   24,   23,   22,   21,   20,   19,   42,
			    0,   40,    0,   38,   37,   36,   35,   34,   33,   32,
			   31,   30,   29,   28,   27,   26,   25,   24,   23,   22,
			   21,   20,   19,  185,  184,  183,  182,  181,  180,  179,
			  178,  177,  176,  175,  174,  173,  172,  171,  170,  169,
			  409,  168,  408,  234,  233,  232,  231,  230,  229,  228,
			  227,  226,  225,  224,  223,  222,  221,  220,  219,  218,
			   71,  232,  231,  230,  229,  228,  227,  226,  225,  224,
			  223,  222,  221,  220,  219,  218,   71,  231,  230,  229,

			  228,  227,  226,  225,  224,  223,  222,  221,  220,  219,
			  218,   71,  230,  229,  228,  227,  226,  225,  224,  223,
			  222,  221,  220,  219,  218,   71, yyDummy>>,
			1, 126, 3000)
		end

	yycheck_template: SPECIAL [INTEGER] is
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make (0, 3125)
			yycheck_template_1 (an_array)
			yycheck_template_2 (an_array)
			Result := yyfixed_array (an_array)
		end

	yycheck_template_1 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			    0,  516,  138,  416,    5,  204,   44,   45,   46,  278,
			   61,  131,  318,   46,  273,  117,   18,  276,   18,  447,
			  385,  447,  114,  714,  117,   91,  551,    0,  165,  714,
			  714,  190,  672,  117,   72,   73,  447,  618,  117,    1,
			  535,  328,    4,   10,   60,  117,   46,   43,  671,  672,
			  697,   13,    0,  467,   16,   55,  637,  216,  287,   61,
			  815,   61,  287,    3,  819,    1,   67,   68,   26,   70,
			    3,  287,    3,  287,  287,   60,   34,  287,  287,  117,
			  239,  240,    1,   99,   60,  732,   26,   60,  104,   90,
			   57,   58,   59,  380,  287,   26,   60,   37,   60,   67,

			   62,    1,  627,  598,   37,  860,   36,  521,  307,   35,
			   58,   51,  371,   61,   44,  115,   89,  117,   51,  104,
			    1,   89,  381,  695,   60,   89,  447,  103,   92,    0,
			  625,  330,  269,  824,   60,  135,  138,  718,  138,  824,
			  824,   60,   42,  145,   80,  145,   27,  794,  407,  191,
			  270,  271,   60,    0,  155,  188,  582,  190,  120,  684,
			  800,   80,   81,  735,  679,  132,   47,   39,   76,  580,
			   47,  582,   44,  754,   51,  137,   60,  800,   86,    1,
			   26,   89,  149,  216,   92,  287,   67,  187,  188,  189,
			  190,   81,  192,   28,  287,   27,   31,  778,  626,  200,

			   18,  460,   36,  287,  166,   51,  239,  240,  287,  478,
			  413,  414,   46,  106,  417,   47,  216,  218,  219,  220,
			  221,  222,  223,  224,  225,  226,  227,  228,  229,  230,
			  231,  232,  233,  234,  235,   67,  236,   72,  467,  239,
			  240,  652,  467,   61,  244,  207,  312,   47,   85,  287,
			   64,  467,   48,  467,  467,  217,  621,  467,  467,  580,
			  519,  582,   60,   77,    4,  524,  308,   67,  849,  302,
			  473,   46,  314,   60,  467,  317,   26,  480,  481,   28,
			  439,  106,   31,  284,  284,   60,   60,  287,  354,   89,
			   62,  287,  521,   80,   26,    4,  521,  496,  298,  299,

			  262,   51,  302,   75,    4,  521,  273,  521,  521,  351,
			  447,  521,  521,   47,   42,   89,  278,   51,   92,   51,
			  138,  321,  581,   72,   99,   15,   16,  145,  521,  104,
			  589,  652,  107,  536,   83,   60,   26,  852,  108,  109,
			  714,  303,   60,  344,   34,  570,  347,  658,  659,    4,
			  661,  100,  418,  419,  570,   80,  570,  570,  424,  772,
			  570,  570,   80,   60,  642,  467,  328,  570,  205,  206,
			  639,  208,   48,  632,  467,   60,   60,  570,  515,  421,
			    1,   27,   42,  467,    1,  423,   47,   48,  467,   28,
			   29,  433,   31,  110,  427,   80,  707,  364,  709,  602,

			  237,   47,   83,  662,   85,   42,  439,   28,   29,   58,
			   31,   28,   29,   26,   31,  930,  553,  554,  380,  521,
			  731,   42,  423,  385,  105,   46,   47,  427,  521,  467,
			   79,   47,   48,   72,   73,   60,   85,  521,  438,  439,
			   27,  719,  521,  580,   83,  582,  108,  414,   97,   58,
			  824,   72,   73,  415,   93,   72,   43,  499,   44,  460,
			  461,  461,   83,   44,  301,   60,  105,  467,  570,  109,
			   79,  467,   93,  751,   99,  612,   85,  570,  615,  104,
			   32,   33,  107,  521,  105,  322,  570,  324,   97,  451,
			   44,  570,    1,   48,  331,  332,  333,  334,  335,  336,

			  337,  338,  339,  340,  341,  342,  343,  813,  345,  346,
			   60,  348,  349,  350,  481,  652,  478,   60,  610,  656,
			    1,  521,   60,  897,   46,  521,   76,   32,   33,  525,
			  530,  790,  570,  811,    1,   45,   86,   46,   42,   89,
			  578,   60,   92,   92,  381,   21,   22,   28,   29,  855,
			   31,   60,    1,  859,  860,  119,  120,   44,  932,  933,
			  934,   42,  936,   32,   33,   86,    0,  104,  132,  133,
			  848,   80,   81,   82,  570,   32,   33,  578,   43,   28,
			   29,  548,   31,   92,  890,  552,  960,   28,   29,   89,
			   31,   72,   43,   60,  103,   46,  799,   43,  876,  108,

			  109,  110,   60,   15,   16,   43,  443,  444,  745,   60,
			  836,  837,   48,   80,   81,   82,   57,   72,   73,   70,
			   32,   46,  900,   72,   58,   92,   60,  589,    1,   15,
			   16,   72,  594,   48,   60,  686,  103,   48,   60,  690,
			   26,  108,  109,  110,    3,   79,   32,    3,   99,  785,
			  487,   85,  703,  104,  616,   89,  107,  619,   84,  621,
			   94,  939,    3,   97,   86,    3,   27,   89,  946,  103,
			   92,   60,   92,   99,  108,  109,   99,  639,  104,    1,
			   60,  107,  519,  897,  686,   58,  686,  965,  690,  967,
			  690,  653,   15,   16,   71,   28,  658,  659,  660,  661,

			  662,  703,   60,  703,    1,    1,   79,  669,  670,   32,
			   33,   34,   85,  714,  714,  753,  678,   69,  932,  933,
			   44,   94,  936,   96,   97,  107,   60,   28,   29,  102,
			   31,   60,   28,   29,   60,   31,   58,  874,  103,   15,
			   16,   84,  106,   60,  706,  707,  960,  709,  749,  750,
			   26,   60,  146,  753,   82,   76,   32,   79,   34,   28,
			   29,   58,   31,   85,   35,   61,   77,   63,   48,  731,
			   66,   72,   94,   89,   96,   97,   72,  828,  829,  741,
			  102,   94,   79,  785,  835,  785,   28,   29,   85,   31,
			  757,   80,   34,   28,   29,  897,   31,   94,   36,   96,

			   97,   43,   48,   72,  897,  102,    1,   17,   18,   19,
			   20,   21,   22,  897,   67,  815,  817,  818,  897,  819,
			  821,  822,  823,  824,  824,  897,  828,  829,  828,  829,
			   72,  933,  934,  835,  936,  835,   49,   72,    1,  801,
			  933,  934,   60,  936,   86,  807,  102,   90,  810,  933,
			  934,   36,  936,   42,  933,  934,   48,  936,  960,  897,
			  860,  933,  934,   58,  936,   48,    1,  960,  686,   72,
			    1,   96,  690,   48,  836,  837,  960,   48,   48,   60,
			   36,  960,  883,  883,   79,  703,  280,   36,  960,   36,
			   85,   27,  286,   26,  932,  933,  934,  897,  936,   94,

			   42,   96,   97,    0,    1,   86,  907,  102,   89,   60,
			  872,   92,   42,   51,   28,   29,  878,   31,    1,  881,
			    1,   48,  960,   36,  925,   36,   41,  928,  765,  323,
			   48,  325,  932,  933,  934,    1,  936,   27,   47,    5,
			    6,    7,    8,    9,   10,   11,   12,   13,   14,   15,
			   16,   17,   18,   19,   20,   21,   22,   76,   72,   73,
			  960,   58,   48,   60,   61,   62,    1,  785,   60,   83,
			  807,  808,    1,   35,   28,   29,   36,   31,   75,   93,
			   35,  375,   79,   32,   32,   42,   83,   48,   85,   42,
			  384,  105,   84,   44,   44,    1,   85,   94,   36,   96,

			   97,   28,   29,  397,   31,  102,   32,   99,  105,   42,
			  828,  829,  104,   67,   32,  107,   43,  835,   72,   73,
			  857,  858,   44,   46,  861,  862,  863,   54,   45,   83,
			   42,  425,   26,   28,   29,   89,   31,   60,   26,   93,
			  106,   64,   26,   26,   69,   72,   26,  441,  442,   60,
			   51,  105,   26,   76,   77,   27,  450,    0,    1,   54,
			   35,   28,   29,   86,   31,   36,   89,   43,  905,   92,
			    0,   41,   15,   16,  377,   86,  291,   72,   89,   46,
			   47,   92,  873,  630,  552,   28,   29,   30,   31,   32,
			   33,   34,  929,  461,  930,  505,  490,  656,  829,  578,

			   43,   44,   45,   46,  941,   72,   73,  960,  945,   52,
			   53,   28,   29,  824,   31,   58,   83,   60,   61,   62,
			   26,  874,   28,   29,  597,   31,   93,  612,  702,   72,
			  633,  633,   75,  828,   77,  633,   79,  145,  105,  533,
			   83,  667,   85,  872,   61,  803,   63,  835,   54,   66,
			  943,   94,  787,   96,   97,   72,  898,  116,  711,  102,
			   28,   29,  105,   31,  558,  395,   72,  289,  111,  112,
			  113,  114,  115,  116,  117,  118,  119,  120,  121,  122,
			  123,  124,  125,  126,  127,  128,  129,  130,  131,  132,
			  133,  134,    1,  319,  427,   63,  269,  739,   66,    4,

			  570,  427,  517,  715,   72,  537,   15,   16,   -1,  903,
			   -1,   -1,   -1,   22,   23,   24,   25,   -1,   27,   28,
			   29,   30,   31,   32,   33,   34,   35,   28,   29,   38,
			   31,   40,   84,   -1,   43,   44,   45,   -1,   -1,   58,
			  634,   50,   51,   52,   53,   54,   -1,   99,   57,  101,
			   59,   -1,  104,  647,   63,  107,   65,   66,   -1,   68,
			   79,   -1,   -1,   72,   -1,   -1,   85,   -1,   77,   -1,
			   -1,   72,   -1,   74,   -1,   94,   -1,   86,   97,   -1,
			  674,   -1,  676,   28,   29,   86,   31,   -1,   89,   98,
			   -1,   92,   -1,   94,   -1,   28,   29,  106,   31,   -1,

			   45,   -1,  111,  112,  113,  114,  115,  116,  117,  118,
			  119,  120,  121,  122,  123,  124,  125,  126,  127,  128,
			  129,  130,  131,  132,  133,  134,   -1,   72,   73,   -1,
			   63,  725,   -1,   66,  728,   -1,  730,   -1,   83,   72,
			   -1,   -1,   -1,   -1,  738,   -1,   -1,   -1,   93,  743,
			   -1,   -1,   -1,   -1,   -1,   -1,   15,   16,   -1,   -1,
			  105,   -1,   -1,   22,   23,   24,   25,   -1,   27,   28,
			   29,   30,   31,   32,   33,   34,   35,   -1,   -1,   38,
			   -1,   40,  776,   -1,   43,   44,   45,   -1,   -1,   -1,
			   -1,   50,   51,   52,   53,   54,   55,   -1,   57,   -1,

			   59,   -1,   -1,   -1,   63,   -1,   65,   66,   -1,   68,
			   -1,   -1,  806,   72,   -1,   74,   -1,   -1,   77,   78,
			   -1,   15,   16,   -1,   -1,   15,   16,   86,   87,   88,
			   -1,   -1,   91,   -1,   28,   29,   26,   31,   32,   98,
			   -1,   -1,   32,   33,   34,   -1,   -1,   -1,  842,   43,
			   -1,   -1,  111,  112,  113,  114,  115,  116,  117,  118,
			  119,  120,  121,  122,  123,  124,  125,  126,  127,  128,
			  129,  130,  131,  132,  133,  134,   -1,   -1,   72,   -1,
			   -1,   -1,   28,   29,   -1,   31,  880,   -1,   -1,   -1,
			   -1,   -1,  886,   15,   16,   -1,   -1,   43,   -1,   -1,

			   22,   23,   24,   25,   -1,   27,   28,   29,   30,   31,
			   32,   33,   34,   35,   -1,   -1,   38,   63,   40,   -1,
			   66,   43,   44,   45,   46,  919,   72,   -1,   50,   51,
			   52,   53,   54,  927,   -1,   57,   -1,   59,   27,   28,
			   29,   63,   31,   65,   66,   -1,   68,   -1,   -1,   -1,
			   72,   -1,   15,   16,   43,   77,   60,   -1,   -1,   -1,
			   64,   50,   -1,   26,   86,   54,   -1,   -1,   57,   32,
			   33,   34,   76,   77,   63,   -1,   98,   66,   -1,   -1,
			   -1,   -1,   86,   72,   -1,   89,   -1,   50,   92,  111,
			  112,  113,  114,  115,  116,  117,  118,  119,  120,  121,

			  122,  123,  124,  125,  126,  127,  128,  129,  130,  131,
			  132,  133,  134,   15,   16,   -1,   -1,   -1,   -1,   -1,
			   22,   23,   24,   25,   -1,   27,   28,   29,   30,   31,
			   32,   33,   34,   35,   -1,   -1,   38,   -1,   40,   -1,
			   -1,   43,   44,   45,   -1,   -1,   -1,   -1,   50,   51,
			   52,   53,   54,   -1,   -1,   57,   -1,   59,   27,   28,
			   29,   63,   31,   65,   66,   -1,   68,   -1,   -1,   -1,
			   72,   -1,   -1,   -1,   -1,   77,   -1,   -1,   80,   -1,
			   -1,   -1,   -1,   -1,   86,   54,   -1,   -1,   57,   -1,
			   -1,   -1,   -1,   -1,   63,   -1,   98,   66,   -1,   -1,

			   -1,   -1,   -1,   72,   -1,   -1,   -1,   -1,   -1,  111,
			  112,  113,  114,  115,  116,  117,  118,  119,  120,  121,
			  122,  123,  124,  125,  126,  127,  128,  129,  130,  131,
			  132,  133,  134,   15,   16,   -1,   -1,   -1,   -1,   -1,
			   22,   23,   24,   25,   -1,   27,   28,   29,   30,   31,
			   32,   33,   34,   35,   -1,   -1,   38,   -1,   40,   -1,
			   -1,   43,   44,   45,   -1,   -1,   -1,   -1,   50,   51,
			   52,   53,   54,   -1,   -1,   57,   -1,   59,   -1,   -1,
			   -1,   63,   -1,   65,   66,   -1,   68,   -1,   -1,   -1,
			   72,   -1,   -1,   -1,   -1,   77,   15,   16,   17,   18,

			   19,   20,   21,   22,   86,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   98,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,  106,   -1,   -1,   -1,   -1,  111,
			  112,  113,  114,  115,  116,  117,  118,  119,  120,  121,
			  122,  123,  124,  125,  126,  127,  128,  129,  130,  131,
			  132,  133,  134,   15,   16,   -1,   -1,   -1,   -1,   -1,
			   22,   23,   24,   25,   -1,   27,   28,   29,   30,   31,
			   32,   33,   34,   35,   -1,   -1,   38,   -1,   40,   -1,
			   -1,   43,   44,   45,   -1,   -1,   -1,   -1,   50,   51,
			   52,   53,   54,   -1,   -1,   57,   -1,   59,   -1,   -1,

			   -1,   63,   -1,   65,   66,   -1,   68,   -1,   -1,   -1,
			   72,   -1,   -1,   -1,   -1,   77,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   86,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   98,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  111,
			  112,  113,  114,  115,  116,  117,  118,  119,  120,  121,
			  122,  123,  124,  125,  126,  127,  128,  129,  130,  131,
			  132,  133,  134,   15,   16,   -1,   -1,   -1,   -1,   -1,
			   22,   23,   24,   25,   -1,   27,   28,   29,   30,   31,
			   32,   33,   34,   35,   -1,   -1,   38,   -1,   40,   -1,

			   -1,   43,   44,   45,   -1,   -1,   -1,   -1,   50,   51,
			   52,   53,   54,   -1,   -1,   57,   -1,   59,   -1,   -1,
			   -1,   63,   -1,   65,   66,   -1,   68,   -1,   -1,   -1,
			   72,   -1,   -1,   -1,   -1,   77,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   86,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   98,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  111,
			  112,  113,  114,  115,  116,  117,  118,  119,  120,  121,
			  122,  123,  124,  125,  126,  127,  128,  129,  130,  131,
			  132,  133,  134,   15,   16,   -1,   -1,   -1,   -1,   -1,

			   22,   23,   24,   25,   -1,   27,   28,   29,   30,   31,
			   32,   33,   34,   35,   -1,   -1,   38,   -1,   40,   -1,
			   -1,   43,   44,   45,   -1,   -1,   -1,   -1,   50,   51,
			   52,   53,   54,   -1,   -1,   57,   -1,   59,   -1,   -1,
			   -1,   63,   -1,   65,   66,   -1,   68,   -1,   -1,   -1,
			   72,   -1,   -1,   -1,   -1,   77,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   86,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   98,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  111,
			  112,  113,  114,  115,  116,  117,  118,  119,  120,  121,

			  122,  123,  124,  125,  126,  127,  128,  129,  130,  131,
			  132,  133,  134,   15,   16,   -1,   -1,   -1,   -1,   -1,
			   22,   23,   24,   25,   -1,   27,   28,   29,   30,   31,
			   32,   33,   34,   35,   -1,   -1,   38,   -1,   40,   -1,
			   -1,   43,   44,   45,   -1,   -1,   -1,   -1,   50,   51,
			   52,   53,   54,   -1,   -1,   57,   -1,   59,   -1,   -1,
			   -1,   63,   -1,   65,   66,   -1,   68,   -1,   -1,   -1,
			   72,   -1,   -1,   -1,   -1,   77,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   86,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   98,   -1,   -1,   -1,

			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  111,
			  112,  113,  114,  115,  116,  117,  118,  119,  120,  121,
			  122,  123,  124,  125,  126,  127,  128,  129,  130,  131,
			  132,  133,  134,   15,   16,   44,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   28,   29,   30,   31,
			   32,   33,   34,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   -1,   43,   44,   45,   46,   -1,   -1,   -1,   -1,   -1,
			   52,   53,    5,    6,    7,    8,    9,   10,   11,   12,
			   13,   14,   15,   16,   17,   18,   19,   20,   21,   22,
			   72,   -1,   -1,   -1,   -1,   77,   -1,   -1,   -1,   -1,

			   -1,   -1,  111,  112,  113,  114,  115,  116,  117,  118,
			  119,  120,  121,  122,  123,  124,  125,  126,  127,  128,
			  129,  130,  131,  132,  133,  134,   -1,   -1,   -1,  111,
			  112,  113,  114,  115,  116,  117,  118,  119,  120,  121,
			  122,  123,  124,  125,  126,  127,  128,  129,  130,  131,
			  132,  133,  134,   15,   16,   -1,   -1,   -1,   28,   29,
			   -1,   31,   -1,   -1,   -1,   -1,   28,   29,   30,   31,
			   32,   33,   34,  106,   -1,   -1,   -1,   -1,   -1,   -1,
			   -1,   43,   44,   45,   46,   -1,   -1,   -1,   -1,   -1,
			   52,   53,   -1,   -1,   -1,   -1,   -1,   67,   -1,   15,

			   16,   -1,   72,   73,   -1,   -1,   -1,   -1,   -1,   -1,
			   72,   -1,   -1,   83,   30,   77,   32,   33,   34,   89,
			   -1,   -1,   -1,   93,   -1,   -1,   -1,   43,   44,   -1,
			   -1,   -1,   -1,   -1,   -1,  105,   52,   53,   -1,   -1,
			   56,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  111,
			  112,  113,  114,  115,  116,  117,  118,  119,  120,  121,
			  122,  123,  124,  125,  126,  127,  128,  129,  130,  131,
			  132,  133,  134,   89,   -1,   -1,   -1,   -1,   -1,   28,
			   29,   -1,   31,   -1,   -1,   -1,   -1,   36,   -1,   -1,
			   -1,    0,    1,   -1,   -1,  111,  112,  113,  114,  115,

			  116,  117,  118,  119,  120,  121,  122,  123,  124,  125,
			  126,  127,  128,  129,  130,  131,  132,  133,  134,   28,
			   29,   -1,   31,   72,   73,   -1,   -1,   36,   -1,   -1,
			   39,    0,    1,   42,   83,   44,   45,   46,   -1,   48,
			   28,   29,   -1,   31,   93,   -1,   -1,   28,   29,   58,
			   31,   60,   61,   -1,   63,   -1,  105,   66,   67,   28,
			   29,   -1,   31,   72,   -1,   46,   -1,   -1,   77,   -1,
			   79,   -1,   -1,   42,   -1,   -1,   85,   86,   -1,   -1,
			   89,   -1,   -1,   92,   72,   73,   -1,   -1,   97,   58,
			   -1,   72,   73,   -1,   -1,   83,   -1,   -1,   -1,   -1,

			   -1,   -1,   83,   72,   -1,   93,   -1,   -1,   -1,   -1,
			   79,   -1,   93,   -1,   -1,   -1,   85,  105,   -1,   -1,
			   -1,   -1,   -1,   -1,  105,   -1,   -1,   -1,   97,    5,
			    6,    7,    8,    9,   10,   11,   12,   13,   14,   15,
			   16,   17,   18,   19,   20,   21,   22,    5,    6,    7,
			    8,    9,   10,   11,   12,   13,   14,   15,   16,   17,
			   18,   19,   20,   21,   22,   -1,   15,   16,   -1,   -1,
			   -1,   -1,   -1,   15,   16,   43,   -1,   -1,   46,   28,
			   29,   -1,   31,   32,   -1,   34,   28,   29,   -1,   31,
			   32,   -1,   60,   -1,   43,   -1,   64,   -1,   -1,   -1,

			   -1,   43,   60,   -1,   -1,   -1,   -1,   -1,   76,   77,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   86,   95,
			   -1,   89,   80,   72,   92,   -1,   -1,   -1,   -1,   -1,
			   72,   99,   -1,   -1,   -1,   -1,  104,   86,   -1,  107,
			   -1,   -1,   -1,   -1,   86,    5,    6,    7,    8,    9,
			   10,   11,   12,   13,   14,   15,   16,   17,   18,   19,
			   20,   21,   22,    5,    6,    7,    8,    9,   10,   11,
			   12,   13,   14,   15,   16,   17,   18,   19,   20,   21,
			   22,   -1,   -1,   -1,   -1,   -1,   46,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   36,   -1,   -1,   -1,   -1,   41,

			   42,    5,    6,    7,    8,    9,   10,   11,   12,   13,
			   14,   15,   16,   17,   18,   19,   20,   21,   22,    5,
			    6,    7,    8,    9,   10,   11,   12,   13,   14,   15,
			   16,   17,   18,   19,   20,   21,   22,   -1,   42,    6,
			    7,    8,    9,   10,   11,   12,   13,   14,   15,   16,
			   17,   18,   19,   20,   21,   22,   42,    5,    6,    7,
			    8,    9,   10,   11,   12,   13,   14,   15,   16,   17,
			   18,   19,   20,   21,   22,  115,  116,  117,  118,  119,
			  120,  121,  122,  123,  124,  125,  126,  127,  128,  129,
			  130,  131,   -1,  133,   42,  111,  112,  113,  114,  115, yyDummy>>,
			1, 3000, 0)
		end

	yycheck_template_2 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  116,  117,  118,  119,  120,  121,  122,  123,  124,  125,
			  126,  127,  128,  129,  130,  131,  132,  133,  134,  111,
			   -1,  113,   -1,  115,  116,  117,  118,  119,  120,  121,
			  122,  123,  124,  125,  126,  127,  128,  129,  130,  131,
			  132,  133,  134,  115,  116,  117,  118,  119,  120,  121,
			  122,  123,  124,  125,  126,  127,  128,  129,  130,  131,
			  132,  133,  134,    5,    6,    7,    8,    9,   10,   11,
			   12,   13,   14,   15,   16,   17,   18,   19,   20,   21,
			   22,    7,    8,    9,   10,   11,   12,   13,   14,   15,
			   16,   17,   18,   19,   20,   21,   22,    8,    9,   10,

			   11,   12,   13,   14,   15,   16,   17,   18,   19,   20,
			   21,   22,    9,   10,   11,   12,   13,   14,   15,   16,
			   17,   18,   19,   20,   21,   22, yyDummy>>,
			1, 126, 3000)
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

	yyvs2: SPECIAL [ID_AS]
			-- Stack for semantic values of type ID_AS

	yyvsc2: INTEGER
			-- Capacity of semantic value stack `yyvs2'

	yyvsp2: INTEGER
			-- Top of semantic value stack `yyvs2'

	yyspecial_routines2: KL_SPECIAL_ROUTINES [ID_AS]
			-- Routines that ought to be in SPECIAL [ID_AS]

	yyvs3: SPECIAL [CHAR_AS]
			-- Stack for semantic values of type CHAR_AS

	yyvsc3: INTEGER
			-- Capacity of semantic value stack `yyvs3'

	yyvsp3: INTEGER
			-- Top of semantic value stack `yyvs3'

	yyspecial_routines3: KL_SPECIAL_ROUTINES [CHAR_AS]
			-- Routines that ought to be in SPECIAL [CHAR_AS]

	yyvs4: SPECIAL [SYMBOL_AS]
			-- Stack for semantic values of type SYMBOL_AS

	yyvsc4: INTEGER
			-- Capacity of semantic value stack `yyvs4'

	yyvsp4: INTEGER
			-- Top of semantic value stack `yyvs4'

	yyspecial_routines4: KL_SPECIAL_ROUTINES [SYMBOL_AS]
			-- Routines that ought to be in SPECIAL [SYMBOL_AS]

	yyvs5: SPECIAL [BOOL_AS]
			-- Stack for semantic values of type BOOL_AS

	yyvsc5: INTEGER
			-- Capacity of semantic value stack `yyvs5'

	yyvsp5: INTEGER
			-- Top of semantic value stack `yyvs5'

	yyspecial_routines5: KL_SPECIAL_ROUTINES [BOOL_AS]
			-- Routines that ought to be in SPECIAL [BOOL_AS]

	yyvs6: SPECIAL [RESULT_AS]
			-- Stack for semantic values of type RESULT_AS

	yyvsc6: INTEGER
			-- Capacity of semantic value stack `yyvs6'

	yyvsp6: INTEGER
			-- Top of semantic value stack `yyvs6'

	yyspecial_routines6: KL_SPECIAL_ROUTINES [RESULT_AS]
			-- Routines that ought to be in SPECIAL [RESULT_AS]

	yyvs7: SPECIAL [RETRY_AS]
			-- Stack for semantic values of type RETRY_AS

	yyvsc7: INTEGER
			-- Capacity of semantic value stack `yyvs7'

	yyvsp7: INTEGER
			-- Top of semantic value stack `yyvs7'

	yyspecial_routines7: KL_SPECIAL_ROUTINES [RETRY_AS]
			-- Routines that ought to be in SPECIAL [RETRY_AS]

	yyvs8: SPECIAL [UNIQUE_AS]
			-- Stack for semantic values of type UNIQUE_AS

	yyvsc8: INTEGER
			-- Capacity of semantic value stack `yyvs8'

	yyvsp8: INTEGER
			-- Top of semantic value stack `yyvs8'

	yyspecial_routines8: KL_SPECIAL_ROUTINES [UNIQUE_AS]
			-- Routines that ought to be in SPECIAL [UNIQUE_AS]

	yyvs9: SPECIAL [CURRENT_AS]
			-- Stack for semantic values of type CURRENT_AS

	yyvsc9: INTEGER
			-- Capacity of semantic value stack `yyvs9'

	yyvsp9: INTEGER
			-- Top of semantic value stack `yyvs9'

	yyspecial_routines9: KL_SPECIAL_ROUTINES [CURRENT_AS]
			-- Routines that ought to be in SPECIAL [CURRENT_AS]

	yyvs10: SPECIAL [DEFERRED_AS]
			-- Stack for semantic values of type DEFERRED_AS

	yyvsc10: INTEGER
			-- Capacity of semantic value stack `yyvs10'

	yyvsp10: INTEGER
			-- Top of semantic value stack `yyvs10'

	yyspecial_routines10: KL_SPECIAL_ROUTINES [DEFERRED_AS]
			-- Routines that ought to be in SPECIAL [DEFERRED_AS]

	yyvs11: SPECIAL [VOID_AS]
			-- Stack for semantic values of type VOID_AS

	yyvsc11: INTEGER
			-- Capacity of semantic value stack `yyvs11'

	yyvsp11: INTEGER
			-- Top of semantic value stack `yyvs11'

	yyspecial_routines11: KL_SPECIAL_ROUTINES [VOID_AS]
			-- Routines that ought to be in SPECIAL [VOID_AS]

	yyvs12: SPECIAL [KEYWORD_AS]
			-- Stack for semantic values of type KEYWORD_AS

	yyvsc12: INTEGER
			-- Capacity of semantic value stack `yyvs12'

	yyvsp12: INTEGER
			-- Top of semantic value stack `yyvs12'

	yyspecial_routines12: KL_SPECIAL_ROUTINES [KEYWORD_AS]
			-- Routines that ought to be in SPECIAL [KEYWORD_AS]

	yyvs13: SPECIAL [ALIAS_TRIPLE]
			-- Stack for semantic values of type ALIAS_TRIPLE

	yyvsc13: INTEGER
			-- Capacity of semantic value stack `yyvs13'

	yyvsp13: INTEGER
			-- Top of semantic value stack `yyvs13'

	yyspecial_routines13: KL_SPECIAL_ROUTINES [ALIAS_TRIPLE]
			-- Routines that ought to be in SPECIAL [ALIAS_TRIPLE]

	yyvs14: SPECIAL [INSTRUCTION_AS]
			-- Stack for semantic values of type INSTRUCTION_AS

	yyvsc14: INTEGER
			-- Capacity of semantic value stack `yyvs14'

	yyvsp14: INTEGER
			-- Top of semantic value stack `yyvs14'

	yyspecial_routines14: KL_SPECIAL_ROUTINES [INSTRUCTION_AS]
			-- Routines that ought to be in SPECIAL [INSTRUCTION_AS]

	yyvs15: SPECIAL [EIFFEL_LIST [INSTRUCTION_AS]]
			-- Stack for semantic values of type EIFFEL_LIST [INSTRUCTION_AS]

	yyvsc15: INTEGER
			-- Capacity of semantic value stack `yyvs15'

	yyvsp15: INTEGER
			-- Top of semantic value stack `yyvs15'

	yyspecial_routines15: KL_SPECIAL_ROUTINES [EIFFEL_LIST [INSTRUCTION_AS]]
			-- Routines that ought to be in SPECIAL [EIFFEL_LIST [INSTRUCTION_AS]]

	yyvs16: SPECIAL [PAIR [KEYWORD_AS, EIFFEL_LIST [INSTRUCTION_AS]]]
			-- Stack for semantic values of type PAIR [KEYWORD_AS, EIFFEL_LIST [INSTRUCTION_AS]]

	yyvsc16: INTEGER
			-- Capacity of semantic value stack `yyvs16'

	yyvsp16: INTEGER
			-- Top of semantic value stack `yyvs16'

	yyspecial_routines16: KL_SPECIAL_ROUTINES [PAIR [KEYWORD_AS, EIFFEL_LIST [INSTRUCTION_AS]]]
			-- Routines that ought to be in SPECIAL [PAIR [KEYWORD_AS, EIFFEL_LIST [INSTRUCTION_AS]]]

	yyvs17: SPECIAL [PAIR [KEYWORD_AS, ID_AS]]
			-- Stack for semantic values of type PAIR [KEYWORD_AS, ID_AS]

	yyvsc17: INTEGER
			-- Capacity of semantic value stack `yyvs17'

	yyvsp17: INTEGER
			-- Top of semantic value stack `yyvs17'

	yyspecial_routines17: KL_SPECIAL_ROUTINES [PAIR [KEYWORD_AS, ID_AS]]
			-- Routines that ought to be in SPECIAL [PAIR [KEYWORD_AS, ID_AS]]

	yyvs18: SPECIAL [STRING_AS]
			-- Stack for semantic values of type STRING_AS

	yyvsc18: INTEGER
			-- Capacity of semantic value stack `yyvs18'

	yyvsp18: INTEGER
			-- Top of semantic value stack `yyvs18'

	yyspecial_routines18: KL_SPECIAL_ROUTINES [STRING_AS]
			-- Routines that ought to be in SPECIAL [STRING_AS]

	yyvs19: SPECIAL [PAIR [KEYWORD_AS, STRING_AS]]
			-- Stack for semantic values of type PAIR [KEYWORD_AS, STRING_AS]

	yyvsc19: INTEGER
			-- Capacity of semantic value stack `yyvs19'

	yyvsp19: INTEGER
			-- Top of semantic value stack `yyvs19'

	yyspecial_routines19: KL_SPECIAL_ROUTINES [PAIR [KEYWORD_AS, STRING_AS]]
			-- Routines that ought to be in SPECIAL [PAIR [KEYWORD_AS, STRING_AS]]

	yyvs20: SPECIAL [IDENTIFIER_LIST]
			-- Stack for semantic values of type IDENTIFIER_LIST

	yyvsc20: INTEGER
			-- Capacity of semantic value stack `yyvs20'

	yyvsp20: INTEGER
			-- Top of semantic value stack `yyvs20'

	yyspecial_routines20: KL_SPECIAL_ROUTINES [IDENTIFIER_LIST]
			-- Routines that ought to be in SPECIAL [IDENTIFIER_LIST]

	yyvs21: SPECIAL [TAGGED_AS]
			-- Stack for semantic values of type TAGGED_AS

	yyvsc21: INTEGER
			-- Capacity of semantic value stack `yyvs21'

	yyvsp21: INTEGER
			-- Top of semantic value stack `yyvs21'

	yyspecial_routines21: KL_SPECIAL_ROUTINES [TAGGED_AS]
			-- Routines that ought to be in SPECIAL [TAGGED_AS]

	yyvs22: SPECIAL [EIFFEL_LIST [TAGGED_AS]]
			-- Stack for semantic values of type EIFFEL_LIST [TAGGED_AS]

	yyvsc22: INTEGER
			-- Capacity of semantic value stack `yyvs22'

	yyvsp22: INTEGER
			-- Top of semantic value stack `yyvs22'

	yyspecial_routines22: KL_SPECIAL_ROUTINES [EIFFEL_LIST [TAGGED_AS]]
			-- Routines that ought to be in SPECIAL [EIFFEL_LIST [TAGGED_AS]]

	yyvs23: SPECIAL [PAIR [KEYWORD_AS, EIFFEL_LIST [TAGGED_AS]]]
			-- Stack for semantic values of type PAIR [KEYWORD_AS, EIFFEL_LIST [TAGGED_AS]]

	yyvsc23: INTEGER
			-- Capacity of semantic value stack `yyvs23'

	yyvsp23: INTEGER
			-- Top of semantic value stack `yyvs23'

	yyspecial_routines23: KL_SPECIAL_ROUTINES [PAIR [KEYWORD_AS, EIFFEL_LIST [TAGGED_AS]]]
			-- Routines that ought to be in SPECIAL [PAIR [KEYWORD_AS, EIFFEL_LIST [TAGGED_AS]]]

	yyvs24: SPECIAL [AGENT_TARGET_TRIPLE]
			-- Stack for semantic values of type AGENT_TARGET_TRIPLE

	yyvsc24: INTEGER
			-- Capacity of semantic value stack `yyvs24'

	yyvsp24: INTEGER
			-- Top of semantic value stack `yyvs24'

	yyspecial_routines24: KL_SPECIAL_ROUTINES [AGENT_TARGET_TRIPLE]
			-- Routines that ought to be in SPECIAL [AGENT_TARGET_TRIPLE]

	yyvs25: SPECIAL [ACCESS_AS]
			-- Stack for semantic values of type ACCESS_AS

	yyvsc25: INTEGER
			-- Capacity of semantic value stack `yyvs25'

	yyvsp25: INTEGER
			-- Top of semantic value stack `yyvs25'

	yyspecial_routines25: KL_SPECIAL_ROUTINES [ACCESS_AS]
			-- Routines that ought to be in SPECIAL [ACCESS_AS]

	yyvs26: SPECIAL [ACCESS_FEAT_AS]
			-- Stack for semantic values of type ACCESS_FEAT_AS

	yyvsc26: INTEGER
			-- Capacity of semantic value stack `yyvs26'

	yyvsp26: INTEGER
			-- Top of semantic value stack `yyvs26'

	yyspecial_routines26: KL_SPECIAL_ROUTINES [ACCESS_FEAT_AS]
			-- Routines that ought to be in SPECIAL [ACCESS_FEAT_AS]

	yyvs27: SPECIAL [ACCESS_INV_AS]
			-- Stack for semantic values of type ACCESS_INV_AS

	yyvsc27: INTEGER
			-- Capacity of semantic value stack `yyvs27'

	yyvsp27: INTEGER
			-- Top of semantic value stack `yyvs27'

	yyspecial_routines27: KL_SPECIAL_ROUTINES [ACCESS_INV_AS]
			-- Routines that ought to be in SPECIAL [ACCESS_INV_AS]

	yyvs28: SPECIAL [ARRAY_AS]
			-- Stack for semantic values of type ARRAY_AS

	yyvsc28: INTEGER
			-- Capacity of semantic value stack `yyvs28'

	yyvsp28: INTEGER
			-- Top of semantic value stack `yyvs28'

	yyspecial_routines28: KL_SPECIAL_ROUTINES [ARRAY_AS]
			-- Routines that ought to be in SPECIAL [ARRAY_AS]

	yyvs29: SPECIAL [ASSIGN_AS]
			-- Stack for semantic values of type ASSIGN_AS

	yyvsc29: INTEGER
			-- Capacity of semantic value stack `yyvs29'

	yyvsp29: INTEGER
			-- Top of semantic value stack `yyvs29'

	yyspecial_routines29: KL_SPECIAL_ROUTINES [ASSIGN_AS]
			-- Routines that ought to be in SPECIAL [ASSIGN_AS]

	yyvs30: SPECIAL [ASSIGNER_CALL_AS]
			-- Stack for semantic values of type ASSIGNER_CALL_AS

	yyvsc30: INTEGER
			-- Capacity of semantic value stack `yyvs30'

	yyvsp30: INTEGER
			-- Top of semantic value stack `yyvs30'

	yyspecial_routines30: KL_SPECIAL_ROUTINES [ASSIGNER_CALL_AS]
			-- Routines that ought to be in SPECIAL [ASSIGNER_CALL_AS]

	yyvs31: SPECIAL [ATOMIC_AS]
			-- Stack for semantic values of type ATOMIC_AS

	yyvsc31: INTEGER
			-- Capacity of semantic value stack `yyvs31'

	yyvsp31: INTEGER
			-- Top of semantic value stack `yyvs31'

	yyspecial_routines31: KL_SPECIAL_ROUTINES [ATOMIC_AS]
			-- Routines that ought to be in SPECIAL [ATOMIC_AS]

	yyvs32: SPECIAL [BINARY_AS]
			-- Stack for semantic values of type BINARY_AS

	yyvsc32: INTEGER
			-- Capacity of semantic value stack `yyvs32'

	yyvsp32: INTEGER
			-- Top of semantic value stack `yyvs32'

	yyspecial_routines32: KL_SPECIAL_ROUTINES [BINARY_AS]
			-- Routines that ought to be in SPECIAL [BINARY_AS]

	yyvs33: SPECIAL [BIT_CONST_AS]
			-- Stack for semantic values of type BIT_CONST_AS

	yyvsc33: INTEGER
			-- Capacity of semantic value stack `yyvs33'

	yyvsp33: INTEGER
			-- Top of semantic value stack `yyvs33'

	yyspecial_routines33: KL_SPECIAL_ROUTINES [BIT_CONST_AS]
			-- Routines that ought to be in SPECIAL [BIT_CONST_AS]

	yyvs34: SPECIAL [BODY_AS]
			-- Stack for semantic values of type BODY_AS

	yyvsc34: INTEGER
			-- Capacity of semantic value stack `yyvs34'

	yyvsp34: INTEGER
			-- Top of semantic value stack `yyvs34'

	yyspecial_routines34: KL_SPECIAL_ROUTINES [BODY_AS]
			-- Routines that ought to be in SPECIAL [BODY_AS]

	yyvs35: SPECIAL [CALL_AS]
			-- Stack for semantic values of type CALL_AS

	yyvsc35: INTEGER
			-- Capacity of semantic value stack `yyvs35'

	yyvsp35: INTEGER
			-- Top of semantic value stack `yyvs35'

	yyspecial_routines35: KL_SPECIAL_ROUTINES [CALL_AS]
			-- Routines that ought to be in SPECIAL [CALL_AS]

	yyvs36: SPECIAL [CASE_AS]
			-- Stack for semantic values of type CASE_AS

	yyvsc36: INTEGER
			-- Capacity of semantic value stack `yyvs36'

	yyvsp36: INTEGER
			-- Top of semantic value stack `yyvs36'

	yyspecial_routines36: KL_SPECIAL_ROUTINES [CASE_AS]
			-- Routines that ought to be in SPECIAL [CASE_AS]

	yyvs37: SPECIAL [CHECK_AS]
			-- Stack for semantic values of type CHECK_AS

	yyvsc37: INTEGER
			-- Capacity of semantic value stack `yyvs37'

	yyvsp37: INTEGER
			-- Top of semantic value stack `yyvs37'

	yyspecial_routines37: KL_SPECIAL_ROUTINES [CHECK_AS]
			-- Routines that ought to be in SPECIAL [CHECK_AS]

	yyvs38: SPECIAL [CLIENT_AS]
			-- Stack for semantic values of type CLIENT_AS

	yyvsc38: INTEGER
			-- Capacity of semantic value stack `yyvs38'

	yyvsp38: INTEGER
			-- Top of semantic value stack `yyvs38'

	yyspecial_routines38: KL_SPECIAL_ROUTINES [CLIENT_AS]
			-- Routines that ought to be in SPECIAL [CLIENT_AS]

	yyvs39: SPECIAL [CONSTANT_AS]
			-- Stack for semantic values of type CONSTANT_AS

	yyvsc39: INTEGER
			-- Capacity of semantic value stack `yyvs39'

	yyvsp39: INTEGER
			-- Top of semantic value stack `yyvs39'

	yyspecial_routines39: KL_SPECIAL_ROUTINES [CONSTANT_AS]
			-- Routines that ought to be in SPECIAL [CONSTANT_AS]

	yyvs40: SPECIAL [CONVERT_FEAT_AS]
			-- Stack for semantic values of type CONVERT_FEAT_AS

	yyvsc40: INTEGER
			-- Capacity of semantic value stack `yyvs40'

	yyvsp40: INTEGER
			-- Top of semantic value stack `yyvs40'

	yyspecial_routines40: KL_SPECIAL_ROUTINES [CONVERT_FEAT_AS]
			-- Routines that ought to be in SPECIAL [CONVERT_FEAT_AS]

	yyvs41: SPECIAL [CREATE_AS]
			-- Stack for semantic values of type CREATE_AS

	yyvsc41: INTEGER
			-- Capacity of semantic value stack `yyvs41'

	yyvsp41: INTEGER
			-- Top of semantic value stack `yyvs41'

	yyspecial_routines41: KL_SPECIAL_ROUTINES [CREATE_AS]
			-- Routines that ought to be in SPECIAL [CREATE_AS]

	yyvs42: SPECIAL [CREATION_AS]
			-- Stack for semantic values of type CREATION_AS

	yyvsc42: INTEGER
			-- Capacity of semantic value stack `yyvs42'

	yyvsp42: INTEGER
			-- Top of semantic value stack `yyvs42'

	yyspecial_routines42: KL_SPECIAL_ROUTINES [CREATION_AS]
			-- Routines that ought to be in SPECIAL [CREATION_AS]

	yyvs43: SPECIAL [CREATION_EXPR_AS]
			-- Stack for semantic values of type CREATION_EXPR_AS

	yyvsc43: INTEGER
			-- Capacity of semantic value stack `yyvs43'

	yyvsp43: INTEGER
			-- Top of semantic value stack `yyvs43'

	yyspecial_routines43: KL_SPECIAL_ROUTINES [CREATION_EXPR_AS]
			-- Routines that ought to be in SPECIAL [CREATION_EXPR_AS]

	yyvs44: SPECIAL [DEBUG_AS]
			-- Stack for semantic values of type DEBUG_AS

	yyvsc44: INTEGER
			-- Capacity of semantic value stack `yyvs44'

	yyvsp44: INTEGER
			-- Top of semantic value stack `yyvs44'

	yyspecial_routines44: KL_SPECIAL_ROUTINES [DEBUG_AS]
			-- Routines that ought to be in SPECIAL [DEBUG_AS]

	yyvs45: SPECIAL [ELSIF_AS]
			-- Stack for semantic values of type ELSIF_AS

	yyvsc45: INTEGER
			-- Capacity of semantic value stack `yyvs45'

	yyvsp45: INTEGER
			-- Top of semantic value stack `yyvs45'

	yyspecial_routines45: KL_SPECIAL_ROUTINES [ELSIF_AS]
			-- Routines that ought to be in SPECIAL [ELSIF_AS]

	yyvs46: SPECIAL [ENSURE_AS]
			-- Stack for semantic values of type ENSURE_AS

	yyvsc46: INTEGER
			-- Capacity of semantic value stack `yyvs46'

	yyvsp46: INTEGER
			-- Top of semantic value stack `yyvs46'

	yyspecial_routines46: KL_SPECIAL_ROUTINES [ENSURE_AS]
			-- Routines that ought to be in SPECIAL [ENSURE_AS]

	yyvs47: SPECIAL [EXPORT_ITEM_AS]
			-- Stack for semantic values of type EXPORT_ITEM_AS

	yyvsc47: INTEGER
			-- Capacity of semantic value stack `yyvs47'

	yyvsp47: INTEGER
			-- Top of semantic value stack `yyvs47'

	yyspecial_routines47: KL_SPECIAL_ROUTINES [EXPORT_ITEM_AS]
			-- Routines that ought to be in SPECIAL [EXPORT_ITEM_AS]

	yyvs48: SPECIAL [EXPR_AS]
			-- Stack for semantic values of type EXPR_AS

	yyvsc48: INTEGER
			-- Capacity of semantic value stack `yyvs48'

	yyvsp48: INTEGER
			-- Top of semantic value stack `yyvs48'

	yyspecial_routines48: KL_SPECIAL_ROUTINES [EXPR_AS]
			-- Routines that ought to be in SPECIAL [EXPR_AS]

	yyvs49: SPECIAL [EXTERNAL_AS]
			-- Stack for semantic values of type EXTERNAL_AS

	yyvsc49: INTEGER
			-- Capacity of semantic value stack `yyvs49'

	yyvsp49: INTEGER
			-- Top of semantic value stack `yyvs49'

	yyspecial_routines49: KL_SPECIAL_ROUTINES [EXTERNAL_AS]
			-- Routines that ought to be in SPECIAL [EXTERNAL_AS]

	yyvs50: SPECIAL [EXTERNAL_LANG_AS]
			-- Stack for semantic values of type EXTERNAL_LANG_AS

	yyvsc50: INTEGER
			-- Capacity of semantic value stack `yyvs50'

	yyvsp50: INTEGER
			-- Top of semantic value stack `yyvs50'

	yyspecial_routines50: KL_SPECIAL_ROUTINES [EXTERNAL_LANG_AS]
			-- Routines that ought to be in SPECIAL [EXTERNAL_LANG_AS]

	yyvs51: SPECIAL [FEATURE_AS]
			-- Stack for semantic values of type FEATURE_AS

	yyvsc51: INTEGER
			-- Capacity of semantic value stack `yyvs51'

	yyvsp51: INTEGER
			-- Top of semantic value stack `yyvs51'

	yyspecial_routines51: KL_SPECIAL_ROUTINES [FEATURE_AS]
			-- Routines that ought to be in SPECIAL [FEATURE_AS]

	yyvs52: SPECIAL [FEATURE_CLAUSE_AS]
			-- Stack for semantic values of type FEATURE_CLAUSE_AS

	yyvsc52: INTEGER
			-- Capacity of semantic value stack `yyvs52'

	yyvsp52: INTEGER
			-- Top of semantic value stack `yyvs52'

	yyspecial_routines52: KL_SPECIAL_ROUTINES [FEATURE_CLAUSE_AS]
			-- Routines that ought to be in SPECIAL [FEATURE_CLAUSE_AS]

	yyvs53: SPECIAL [FEATURE_SET_AS]
			-- Stack for semantic values of type FEATURE_SET_AS

	yyvsc53: INTEGER
			-- Capacity of semantic value stack `yyvs53'

	yyvsp53: INTEGER
			-- Top of semantic value stack `yyvs53'

	yyspecial_routines53: KL_SPECIAL_ROUTINES [FEATURE_SET_AS]
			-- Routines that ought to be in SPECIAL [FEATURE_SET_AS]

	yyvs54: SPECIAL [FORMAL_AS]
			-- Stack for semantic values of type FORMAL_AS

	yyvsc54: INTEGER
			-- Capacity of semantic value stack `yyvs54'

	yyvsp54: INTEGER
			-- Top of semantic value stack `yyvs54'

	yyspecial_routines54: KL_SPECIAL_ROUTINES [FORMAL_AS]
			-- Routines that ought to be in SPECIAL [FORMAL_AS]

	yyvs55: SPECIAL [FORMAL_DEC_AS]
			-- Stack for semantic values of type FORMAL_DEC_AS

	yyvsc55: INTEGER
			-- Capacity of semantic value stack `yyvs55'

	yyvsp55: INTEGER
			-- Top of semantic value stack `yyvs55'

	yyspecial_routines55: KL_SPECIAL_ROUTINES [FORMAL_DEC_AS]
			-- Routines that ought to be in SPECIAL [FORMAL_DEC_AS]

	yyvs56: SPECIAL [IF_AS]
			-- Stack for semantic values of type IF_AS

	yyvsc56: INTEGER
			-- Capacity of semantic value stack `yyvs56'

	yyvsp56: INTEGER
			-- Top of semantic value stack `yyvs56'

	yyspecial_routines56: KL_SPECIAL_ROUTINES [IF_AS]
			-- Routines that ought to be in SPECIAL [IF_AS]

	yyvs57: SPECIAL [INDEX_AS]
			-- Stack for semantic values of type INDEX_AS

	yyvsc57: INTEGER
			-- Capacity of semantic value stack `yyvs57'

	yyvsp57: INTEGER
			-- Top of semantic value stack `yyvs57'

	yyspecial_routines57: KL_SPECIAL_ROUTINES [INDEX_AS]
			-- Routines that ought to be in SPECIAL [INDEX_AS]

	yyvs58: SPECIAL [INSPECT_AS]
			-- Stack for semantic values of type INSPECT_AS

	yyvsc58: INTEGER
			-- Capacity of semantic value stack `yyvs58'

	yyvsp58: INTEGER
			-- Top of semantic value stack `yyvs58'

	yyspecial_routines58: KL_SPECIAL_ROUTINES [INSPECT_AS]
			-- Routines that ought to be in SPECIAL [INSPECT_AS]

	yyvs59: SPECIAL [INTEGER_AS]
			-- Stack for semantic values of type INTEGER_AS

	yyvsc59: INTEGER
			-- Capacity of semantic value stack `yyvs59'

	yyvsp59: INTEGER
			-- Top of semantic value stack `yyvs59'

	yyspecial_routines59: KL_SPECIAL_ROUTINES [INTEGER_AS]
			-- Routines that ought to be in SPECIAL [INTEGER_AS]

	yyvs60: SPECIAL [INTERNAL_AS]
			-- Stack for semantic values of type INTERNAL_AS

	yyvsc60: INTEGER
			-- Capacity of semantic value stack `yyvs60'

	yyvsp60: INTEGER
			-- Top of semantic value stack `yyvs60'

	yyspecial_routines60: KL_SPECIAL_ROUTINES [INTERNAL_AS]
			-- Routines that ought to be in SPECIAL [INTERNAL_AS]

	yyvs61: SPECIAL [INTERVAL_AS]
			-- Stack for semantic values of type INTERVAL_AS

	yyvsc61: INTEGER
			-- Capacity of semantic value stack `yyvs61'

	yyvsp61: INTEGER
			-- Top of semantic value stack `yyvs61'

	yyspecial_routines61: KL_SPECIAL_ROUTINES [INTERVAL_AS]
			-- Routines that ought to be in SPECIAL [INTERVAL_AS]

	yyvs62: SPECIAL [INVARIANT_AS]
			-- Stack for semantic values of type INVARIANT_AS

	yyvsc62: INTEGER
			-- Capacity of semantic value stack `yyvs62'

	yyvsp62: INTEGER
			-- Top of semantic value stack `yyvs62'

	yyspecial_routines62: KL_SPECIAL_ROUTINES [INVARIANT_AS]
			-- Routines that ought to be in SPECIAL [INVARIANT_AS]

	yyvs63: SPECIAL [LOOP_AS]
			-- Stack for semantic values of type LOOP_AS

	yyvsc63: INTEGER
			-- Capacity of semantic value stack `yyvs63'

	yyvsp63: INTEGER
			-- Top of semantic value stack `yyvs63'

	yyspecial_routines63: KL_SPECIAL_ROUTINES [LOOP_AS]
			-- Routines that ought to be in SPECIAL [LOOP_AS]

	yyvs64: SPECIAL [NESTED_AS]
			-- Stack for semantic values of type NESTED_AS

	yyvsc64: INTEGER
			-- Capacity of semantic value stack `yyvs64'

	yyvsp64: INTEGER
			-- Top of semantic value stack `yyvs64'

	yyspecial_routines64: KL_SPECIAL_ROUTINES [NESTED_AS]
			-- Routines that ought to be in SPECIAL [NESTED_AS]

	yyvs65: SPECIAL [OPERAND_AS]
			-- Stack for semantic values of type OPERAND_AS

	yyvsc65: INTEGER
			-- Capacity of semantic value stack `yyvs65'

	yyvsp65: INTEGER
			-- Top of semantic value stack `yyvs65'

	yyspecial_routines65: KL_SPECIAL_ROUTINES [OPERAND_AS]
			-- Routines that ought to be in SPECIAL [OPERAND_AS]

	yyvs66: SPECIAL [PARENT_AS]
			-- Stack for semantic values of type PARENT_AS

	yyvsc66: INTEGER
			-- Capacity of semantic value stack `yyvs66'

	yyvsp66: INTEGER
			-- Top of semantic value stack `yyvs66'

	yyspecial_routines66: KL_SPECIAL_ROUTINES [PARENT_AS]
			-- Routines that ought to be in SPECIAL [PARENT_AS]

	yyvs67: SPECIAL [PRECURSOR_AS]
			-- Stack for semantic values of type PRECURSOR_AS

	yyvsc67: INTEGER
			-- Capacity of semantic value stack `yyvs67'

	yyvsp67: INTEGER
			-- Top of semantic value stack `yyvs67'

	yyspecial_routines67: KL_SPECIAL_ROUTINES [PRECURSOR_AS]
			-- Routines that ought to be in SPECIAL [PRECURSOR_AS]

	yyvs68: SPECIAL [STATIC_ACCESS_AS]
			-- Stack for semantic values of type STATIC_ACCESS_AS

	yyvsc68: INTEGER
			-- Capacity of semantic value stack `yyvs68'

	yyvsp68: INTEGER
			-- Top of semantic value stack `yyvs68'

	yyspecial_routines68: KL_SPECIAL_ROUTINES [STATIC_ACCESS_AS]
			-- Routines that ought to be in SPECIAL [STATIC_ACCESS_AS]

	yyvs69: SPECIAL [REAL_AS]
			-- Stack for semantic values of type REAL_AS

	yyvsc69: INTEGER
			-- Capacity of semantic value stack `yyvs69'

	yyvsp69: INTEGER
			-- Top of semantic value stack `yyvs69'

	yyspecial_routines69: KL_SPECIAL_ROUTINES [REAL_AS]
			-- Routines that ought to be in SPECIAL [REAL_AS]

	yyvs70: SPECIAL [RENAME_AS]
			-- Stack for semantic values of type RENAME_AS

	yyvsc70: INTEGER
			-- Capacity of semantic value stack `yyvs70'

	yyvsp70: INTEGER
			-- Top of semantic value stack `yyvs70'

	yyspecial_routines70: KL_SPECIAL_ROUTINES [RENAME_AS]
			-- Routines that ought to be in SPECIAL [RENAME_AS]

	yyvs71: SPECIAL [REQUIRE_AS]
			-- Stack for semantic values of type REQUIRE_AS

	yyvsc71: INTEGER
			-- Capacity of semantic value stack `yyvs71'

	yyvsp71: INTEGER
			-- Top of semantic value stack `yyvs71'

	yyspecial_routines71: KL_SPECIAL_ROUTINES [REQUIRE_AS]
			-- Routines that ought to be in SPECIAL [REQUIRE_AS]

	yyvs72: SPECIAL [REVERSE_AS]
			-- Stack for semantic values of type REVERSE_AS

	yyvsc72: INTEGER
			-- Capacity of semantic value stack `yyvs72'

	yyvsp72: INTEGER
			-- Top of semantic value stack `yyvs72'

	yyspecial_routines72: KL_SPECIAL_ROUTINES [REVERSE_AS]
			-- Routines that ought to be in SPECIAL [REVERSE_AS]

	yyvs73: SPECIAL [ROUT_BODY_AS]
			-- Stack for semantic values of type ROUT_BODY_AS

	yyvsc73: INTEGER
			-- Capacity of semantic value stack `yyvs73'

	yyvsp73: INTEGER
			-- Top of semantic value stack `yyvs73'

	yyspecial_routines73: KL_SPECIAL_ROUTINES [ROUT_BODY_AS]
			-- Routines that ought to be in SPECIAL [ROUT_BODY_AS]

	yyvs74: SPECIAL [ROUTINE_AS]
			-- Stack for semantic values of type ROUTINE_AS

	yyvsc74: INTEGER
			-- Capacity of semantic value stack `yyvs74'

	yyvsp74: INTEGER
			-- Top of semantic value stack `yyvs74'

	yyspecial_routines74: KL_SPECIAL_ROUTINES [ROUTINE_AS]
			-- Routines that ought to be in SPECIAL [ROUTINE_AS]

	yyvs75: SPECIAL [ROUTINE_CREATION_AS]
			-- Stack for semantic values of type ROUTINE_CREATION_AS

	yyvsc75: INTEGER
			-- Capacity of semantic value stack `yyvs75'

	yyvsp75: INTEGER
			-- Top of semantic value stack `yyvs75'

	yyspecial_routines75: KL_SPECIAL_ROUTINES [ROUTINE_CREATION_AS]
			-- Routines that ought to be in SPECIAL [ROUTINE_CREATION_AS]

	yyvs76: SPECIAL [LOCATION_AS]
			-- Stack for semantic values of type LOCATION_AS

	yyvsc76: INTEGER
			-- Capacity of semantic value stack `yyvs76'

	yyvsp76: INTEGER
			-- Top of semantic value stack `yyvs76'

	yyspecial_routines76: KL_SPECIAL_ROUTINES [LOCATION_AS]
			-- Routines that ought to be in SPECIAL [LOCATION_AS]

	yyvs77: SPECIAL [PAIR [ROUTINE_CREATION_AS, LOCATION_AS]]
			-- Stack for semantic values of type PAIR [ROUTINE_CREATION_AS, LOCATION_AS]

	yyvsc77: INTEGER
			-- Capacity of semantic value stack `yyvs77'

	yyvsp77: INTEGER
			-- Top of semantic value stack `yyvs77'

	yyspecial_routines77: KL_SPECIAL_ROUTINES [PAIR [ROUTINE_CREATION_AS, LOCATION_AS]]
			-- Routines that ought to be in SPECIAL [PAIR [ROUTINE_CREATION_AS, LOCATION_AS]]

	yyvs78: SPECIAL [TUPLE_AS]
			-- Stack for semantic values of type TUPLE_AS

	yyvsc78: INTEGER
			-- Capacity of semantic value stack `yyvs78'

	yyvsp78: INTEGER
			-- Top of semantic value stack `yyvs78'

	yyspecial_routines78: KL_SPECIAL_ROUTINES [TUPLE_AS]
			-- Routines that ought to be in SPECIAL [TUPLE_AS]

	yyvs79: SPECIAL [TYPE_AS]
			-- Stack for semantic values of type TYPE_AS

	yyvsc79: INTEGER
			-- Capacity of semantic value stack `yyvs79'

	yyvsp79: INTEGER
			-- Top of semantic value stack `yyvs79'

	yyspecial_routines79: KL_SPECIAL_ROUTINES [TYPE_AS]
			-- Routines that ought to be in SPECIAL [TYPE_AS]

	yyvs80: SPECIAL [CLASS_TYPE_AS]
			-- Stack for semantic values of type CLASS_TYPE_AS

	yyvsc80: INTEGER
			-- Capacity of semantic value stack `yyvs80'

	yyvsp80: INTEGER
			-- Top of semantic value stack `yyvs80'

	yyspecial_routines80: KL_SPECIAL_ROUTINES [CLASS_TYPE_AS]
			-- Routines that ought to be in SPECIAL [CLASS_TYPE_AS]

	yyvs81: SPECIAL [TYPE_DEC_AS]
			-- Stack for semantic values of type TYPE_DEC_AS

	yyvsc81: INTEGER
			-- Capacity of semantic value stack `yyvs81'

	yyvsp81: INTEGER
			-- Top of semantic value stack `yyvs81'

	yyspecial_routines81: KL_SPECIAL_ROUTINES [TYPE_DEC_AS]
			-- Routines that ought to be in SPECIAL [TYPE_DEC_AS]

	yyvs82: SPECIAL [VARIANT_AS]
			-- Stack for semantic values of type VARIANT_AS

	yyvsc82: INTEGER
			-- Capacity of semantic value stack `yyvs82'

	yyvsp82: INTEGER
			-- Top of semantic value stack `yyvs82'

	yyspecial_routines82: KL_SPECIAL_ROUTINES [VARIANT_AS]
			-- Routines that ought to be in SPECIAL [VARIANT_AS]

	yyvs83: SPECIAL [FEATURE_NAME]
			-- Stack for semantic values of type FEATURE_NAME

	yyvsc83: INTEGER
			-- Capacity of semantic value stack `yyvs83'

	yyvsp83: INTEGER
			-- Top of semantic value stack `yyvs83'

	yyspecial_routines83: KL_SPECIAL_ROUTINES [FEATURE_NAME]
			-- Routines that ought to be in SPECIAL [FEATURE_NAME]

	yyvs84: SPECIAL [EIFFEL_LIST [ATOMIC_AS]]
			-- Stack for semantic values of type EIFFEL_LIST [ATOMIC_AS]

	yyvsc84: INTEGER
			-- Capacity of semantic value stack `yyvs84'

	yyvsp84: INTEGER
			-- Top of semantic value stack `yyvs84'

	yyspecial_routines84: KL_SPECIAL_ROUTINES [EIFFEL_LIST [ATOMIC_AS]]
			-- Routines that ought to be in SPECIAL [EIFFEL_LIST [ATOMIC_AS]]

	yyvs85: SPECIAL [EIFFEL_LIST [CASE_AS]]
			-- Stack for semantic values of type EIFFEL_LIST [CASE_AS]

	yyvsc85: INTEGER
			-- Capacity of semantic value stack `yyvs85'

	yyvsp85: INTEGER
			-- Top of semantic value stack `yyvs85'

	yyspecial_routines85: KL_SPECIAL_ROUTINES [EIFFEL_LIST [CASE_AS]]
			-- Routines that ought to be in SPECIAL [EIFFEL_LIST [CASE_AS]]

	yyvs86: SPECIAL [CONVERT_FEAT_LIST_AS]
			-- Stack for semantic values of type CONVERT_FEAT_LIST_AS

	yyvsc86: INTEGER
			-- Capacity of semantic value stack `yyvs86'

	yyvsp86: INTEGER
			-- Top of semantic value stack `yyvs86'

	yyspecial_routines86: KL_SPECIAL_ROUTINES [CONVERT_FEAT_LIST_AS]
			-- Routines that ought to be in SPECIAL [CONVERT_FEAT_LIST_AS]

	yyvs87: SPECIAL [EIFFEL_LIST [CREATE_AS]]
			-- Stack for semantic values of type EIFFEL_LIST [CREATE_AS]

	yyvsc87: INTEGER
			-- Capacity of semantic value stack `yyvs87'

	yyvsp87: INTEGER
			-- Top of semantic value stack `yyvs87'

	yyspecial_routines87: KL_SPECIAL_ROUTINES [EIFFEL_LIST [CREATE_AS]]
			-- Routines that ought to be in SPECIAL [EIFFEL_LIST [CREATE_AS]]

	yyvs88: SPECIAL [EIFFEL_LIST [ELSIF_AS]]
			-- Stack for semantic values of type EIFFEL_LIST [ELSIF_AS]

	yyvsc88: INTEGER
			-- Capacity of semantic value stack `yyvs88'

	yyvsp88: INTEGER
			-- Top of semantic value stack `yyvs88'

	yyspecial_routines88: KL_SPECIAL_ROUTINES [EIFFEL_LIST [ELSIF_AS]]
			-- Routines that ought to be in SPECIAL [EIFFEL_LIST [ELSIF_AS]]

	yyvs89: SPECIAL [EIFFEL_LIST [EXPORT_ITEM_AS]]
			-- Stack for semantic values of type EIFFEL_LIST [EXPORT_ITEM_AS]

	yyvsc89: INTEGER
			-- Capacity of semantic value stack `yyvs89'

	yyvsp89: INTEGER
			-- Top of semantic value stack `yyvs89'

	yyspecial_routines89: KL_SPECIAL_ROUTINES [EIFFEL_LIST [EXPORT_ITEM_AS]]
			-- Routines that ought to be in SPECIAL [EIFFEL_LIST [EXPORT_ITEM_AS]]

	yyvs90: SPECIAL [EXPORT_CLAUSE_AS]
			-- Stack for semantic values of type EXPORT_CLAUSE_AS

	yyvsc90: INTEGER
			-- Capacity of semantic value stack `yyvs90'

	yyvsp90: INTEGER
			-- Top of semantic value stack `yyvs90'

	yyspecial_routines90: KL_SPECIAL_ROUTINES [EXPORT_CLAUSE_AS]
			-- Routines that ought to be in SPECIAL [EXPORT_CLAUSE_AS]

	yyvs91: SPECIAL [EIFFEL_LIST [EXPR_AS]]
			-- Stack for semantic values of type EIFFEL_LIST [EXPR_AS]

	yyvsc91: INTEGER
			-- Capacity of semantic value stack `yyvs91'

	yyvsp91: INTEGER
			-- Top of semantic value stack `yyvs91'

	yyspecial_routines91: KL_SPECIAL_ROUTINES [EIFFEL_LIST [EXPR_AS]]
			-- Routines that ought to be in SPECIAL [EIFFEL_LIST [EXPR_AS]]

	yyvs92: SPECIAL [PARAMETER_LIST_AS]
			-- Stack for semantic values of type PARAMETER_LIST_AS

	yyvsc92: INTEGER
			-- Capacity of semantic value stack `yyvs92'

	yyvsp92: INTEGER
			-- Top of semantic value stack `yyvs92'

	yyspecial_routines92: KL_SPECIAL_ROUTINES [PARAMETER_LIST_AS]
			-- Routines that ought to be in SPECIAL [PARAMETER_LIST_AS]

	yyvs93: SPECIAL [EIFFEL_LIST [FEATURE_AS]]
			-- Stack for semantic values of type EIFFEL_LIST [FEATURE_AS]

	yyvsc93: INTEGER
			-- Capacity of semantic value stack `yyvs93'

	yyvsp93: INTEGER
			-- Top of semantic value stack `yyvs93'

	yyspecial_routines93: KL_SPECIAL_ROUTINES [EIFFEL_LIST [FEATURE_AS]]
			-- Routines that ought to be in SPECIAL [EIFFEL_LIST [FEATURE_AS]]

	yyvs94: SPECIAL [EIFFEL_LIST [FEATURE_CLAUSE_AS]]
			-- Stack for semantic values of type EIFFEL_LIST [FEATURE_CLAUSE_AS]

	yyvsc94: INTEGER
			-- Capacity of semantic value stack `yyvs94'

	yyvsp94: INTEGER
			-- Top of semantic value stack `yyvs94'

	yyspecial_routines94: KL_SPECIAL_ROUTINES [EIFFEL_LIST [FEATURE_CLAUSE_AS]]
			-- Routines that ought to be in SPECIAL [EIFFEL_LIST [FEATURE_CLAUSE_AS]]

	yyvs95: SPECIAL [EIFFEL_LIST [FEATURE_NAME]]
			-- Stack for semantic values of type EIFFEL_LIST [FEATURE_NAME]

	yyvsc95: INTEGER
			-- Capacity of semantic value stack `yyvs95'

	yyvsp95: INTEGER
			-- Top of semantic value stack `yyvs95'

	yyspecial_routines95: KL_SPECIAL_ROUTINES [EIFFEL_LIST [FEATURE_NAME]]
			-- Routines that ought to be in SPECIAL [EIFFEL_LIST [FEATURE_NAME]]

	yyvs96: SPECIAL [CREATION_CONSTRAIN_TRIPLE]
			-- Stack for semantic values of type CREATION_CONSTRAIN_TRIPLE

	yyvsc96: INTEGER
			-- Capacity of semantic value stack `yyvs96'

	yyvsp96: INTEGER
			-- Top of semantic value stack `yyvs96'

	yyspecial_routines96: KL_SPECIAL_ROUTINES [CREATION_CONSTRAIN_TRIPLE]
			-- Routines that ought to be in SPECIAL [CREATION_CONSTRAIN_TRIPLE]

	yyvs97: SPECIAL [UNDEFINE_CLAUSE_AS]
			-- Stack for semantic values of type UNDEFINE_CLAUSE_AS

	yyvsc97: INTEGER
			-- Capacity of semantic value stack `yyvs97'

	yyvsp97: INTEGER
			-- Top of semantic value stack `yyvs97'

	yyspecial_routines97: KL_SPECIAL_ROUTINES [UNDEFINE_CLAUSE_AS]
			-- Routines that ought to be in SPECIAL [UNDEFINE_CLAUSE_AS]

	yyvs98: SPECIAL [REDEFINE_CLAUSE_AS]
			-- Stack for semantic values of type REDEFINE_CLAUSE_AS

	yyvsc98: INTEGER
			-- Capacity of semantic value stack `yyvs98'

	yyvsp98: INTEGER
			-- Top of semantic value stack `yyvs98'

	yyspecial_routines98: KL_SPECIAL_ROUTINES [REDEFINE_CLAUSE_AS]
			-- Routines that ought to be in SPECIAL [REDEFINE_CLAUSE_AS]

	yyvs99: SPECIAL [SELECT_CLAUSE_AS]
			-- Stack for semantic values of type SELECT_CLAUSE_AS

	yyvsc99: INTEGER
			-- Capacity of semantic value stack `yyvs99'

	yyvsp99: INTEGER
			-- Top of semantic value stack `yyvs99'

	yyspecial_routines99: KL_SPECIAL_ROUTINES [SELECT_CLAUSE_AS]
			-- Routines that ought to be in SPECIAL [SELECT_CLAUSE_AS]

	yyvs100: SPECIAL [FORMAL_GENERIC_LIST_AS]
			-- Stack for semantic values of type FORMAL_GENERIC_LIST_AS

	yyvsc100: INTEGER
			-- Capacity of semantic value stack `yyvs100'

	yyvsp100: INTEGER
			-- Top of semantic value stack `yyvs100'

	yyspecial_routines100: KL_SPECIAL_ROUTINES [FORMAL_GENERIC_LIST_AS]
			-- Routines that ought to be in SPECIAL [FORMAL_GENERIC_LIST_AS]

	yyvs101: SPECIAL [CLASS_LIST_AS]
			-- Stack for semantic values of type CLASS_LIST_AS

	yyvsc101: INTEGER
			-- Capacity of semantic value stack `yyvs101'

	yyvsp101: INTEGER
			-- Top of semantic value stack `yyvs101'

	yyspecial_routines101: KL_SPECIAL_ROUTINES [CLASS_LIST_AS]
			-- Routines that ought to be in SPECIAL [CLASS_LIST_AS]

	yyvs102: SPECIAL [INDEXING_CLAUSE_AS]
			-- Stack for semantic values of type INDEXING_CLAUSE_AS

	yyvsc102: INTEGER
			-- Capacity of semantic value stack `yyvs102'

	yyvsp102: INTEGER
			-- Top of semantic value stack `yyvs102'

	yyspecial_routines102: KL_SPECIAL_ROUTINES [INDEXING_CLAUSE_AS]
			-- Routines that ought to be in SPECIAL [INDEXING_CLAUSE_AS]

	yyvs103: SPECIAL [EIFFEL_LIST [INTERVAL_AS]]
			-- Stack for semantic values of type EIFFEL_LIST [INTERVAL_AS]

	yyvsc103: INTEGER
			-- Capacity of semantic value stack `yyvs103'

	yyvsp103: INTEGER
			-- Top of semantic value stack `yyvs103'

	yyspecial_routines103: KL_SPECIAL_ROUTINES [EIFFEL_LIST [INTERVAL_AS]]
			-- Routines that ought to be in SPECIAL [EIFFEL_LIST [INTERVAL_AS]]

	yyvs104: SPECIAL [EIFFEL_LIST [OPERAND_AS]]
			-- Stack for semantic values of type EIFFEL_LIST [OPERAND_AS]

	yyvsc104: INTEGER
			-- Capacity of semantic value stack `yyvs104'

	yyvsp104: INTEGER
			-- Top of semantic value stack `yyvs104'

	yyspecial_routines104: KL_SPECIAL_ROUTINES [EIFFEL_LIST [OPERAND_AS]]
			-- Routines that ought to be in SPECIAL [EIFFEL_LIST [OPERAND_AS]]

	yyvs105: SPECIAL [DELAYED_ACTUAL_LIST_AS]
			-- Stack for semantic values of type DELAYED_ACTUAL_LIST_AS

	yyvsc105: INTEGER
			-- Capacity of semantic value stack `yyvs105'

	yyvsp105: INTEGER
			-- Top of semantic value stack `yyvs105'

	yyspecial_routines105: KL_SPECIAL_ROUTINES [DELAYED_ACTUAL_LIST_AS]
			-- Routines that ought to be in SPECIAL [DELAYED_ACTUAL_LIST_AS]

	yyvs106: SPECIAL [PARENT_LIST_AS]
			-- Stack for semantic values of type PARENT_LIST_AS

	yyvsc106: INTEGER
			-- Capacity of semantic value stack `yyvs106'

	yyvsp106: INTEGER
			-- Top of semantic value stack `yyvs106'

	yyspecial_routines106: KL_SPECIAL_ROUTINES [PARENT_LIST_AS]
			-- Routines that ought to be in SPECIAL [PARENT_LIST_AS]

	yyvs107: SPECIAL [EIFFEL_LIST [RENAME_AS]]
			-- Stack for semantic values of type EIFFEL_LIST [RENAME_AS]

	yyvsc107: INTEGER
			-- Capacity of semantic value stack `yyvs107'

	yyvsp107: INTEGER
			-- Top of semantic value stack `yyvs107'

	yyspecial_routines107: KL_SPECIAL_ROUTINES [EIFFEL_LIST [RENAME_AS]]
			-- Routines that ought to be in SPECIAL [EIFFEL_LIST [RENAME_AS]]

	yyvs108: SPECIAL [RENAME_CLAUSE_AS]
			-- Stack for semantic values of type RENAME_CLAUSE_AS

	yyvsc108: INTEGER
			-- Capacity of semantic value stack `yyvs108'

	yyvsp108: INTEGER
			-- Top of semantic value stack `yyvs108'

	yyspecial_routines108: KL_SPECIAL_ROUTINES [RENAME_CLAUSE_AS]
			-- Routines that ought to be in SPECIAL [RENAME_CLAUSE_AS]

	yyvs109: SPECIAL [EIFFEL_LIST [STRING_AS]]
			-- Stack for semantic values of type EIFFEL_LIST [STRING_AS]

	yyvsc109: INTEGER
			-- Capacity of semantic value stack `yyvs109'

	yyvsp109: INTEGER
			-- Top of semantic value stack `yyvs109'

	yyspecial_routines109: KL_SPECIAL_ROUTINES [EIFFEL_LIST [STRING_AS]]
			-- Routines that ought to be in SPECIAL [EIFFEL_LIST [STRING_AS]]

	yyvs110: SPECIAL [DEBUG_KEY_LIST_AS]
			-- Stack for semantic values of type DEBUG_KEY_LIST_AS

	yyvsc110: INTEGER
			-- Capacity of semantic value stack `yyvs110'

	yyvsp110: INTEGER
			-- Top of semantic value stack `yyvs110'

	yyspecial_routines110: KL_SPECIAL_ROUTINES [DEBUG_KEY_LIST_AS]
			-- Routines that ought to be in SPECIAL [DEBUG_KEY_LIST_AS]

	yyvs111: SPECIAL [TYPE_LIST_AS]
			-- Stack for semantic values of type TYPE_LIST_AS

	yyvsc111: INTEGER
			-- Capacity of semantic value stack `yyvs111'

	yyvsp111: INTEGER
			-- Top of semantic value stack `yyvs111'

	yyspecial_routines111: KL_SPECIAL_ROUTINES [TYPE_LIST_AS]
			-- Routines that ought to be in SPECIAL [TYPE_LIST_AS]

	yyvs112: SPECIAL [TYPE_DEC_LIST_AS]
			-- Stack for semantic values of type TYPE_DEC_LIST_AS

	yyvsc112: INTEGER
			-- Capacity of semantic value stack `yyvs112'

	yyvsp112: INTEGER
			-- Top of semantic value stack `yyvs112'

	yyspecial_routines112: KL_SPECIAL_ROUTINES [TYPE_DEC_LIST_AS]
			-- Routines that ought to be in SPECIAL [TYPE_DEC_LIST_AS]

	yyvs113: SPECIAL [LOCAL_DEC_LIST_AS]
			-- Stack for semantic values of type LOCAL_DEC_LIST_AS

	yyvsc113: INTEGER
			-- Capacity of semantic value stack `yyvs113'

	yyvsp113: INTEGER
			-- Top of semantic value stack `yyvs113'

	yyspecial_routines113: KL_SPECIAL_ROUTINES [LOCAL_DEC_LIST_AS]
			-- Routines that ought to be in SPECIAL [LOCAL_DEC_LIST_AS]

	yyvs114: SPECIAL [FORMAL_ARGU_DEC_LIST_AS]
			-- Stack for semantic values of type FORMAL_ARGU_DEC_LIST_AS

	yyvsc114: INTEGER
			-- Capacity of semantic value stack `yyvs114'

	yyvsp114: INTEGER
			-- Top of semantic value stack `yyvs114'

	yyspecial_routines114: KL_SPECIAL_ROUTINES [FORMAL_ARGU_DEC_LIST_AS]
			-- Routines that ought to be in SPECIAL [FORMAL_ARGU_DEC_LIST_AS]

	yyvs115: SPECIAL [CONSTRAINT_TRIPLE]
			-- Stack for semantic values of type CONSTRAINT_TRIPLE

	yyvsc115: INTEGER
			-- Capacity of semantic value stack `yyvs115'

	yyvsp115: INTEGER
			-- Top of semantic value stack `yyvs115'

	yyspecial_routines115: KL_SPECIAL_ROUTINES [CONSTRAINT_TRIPLE]
			-- Routines that ought to be in SPECIAL [CONSTRAINT_TRIPLE]

feature {NONE} -- Constants

	yyFinal: INTEGER is 979
			-- Termination state id

	yyFlag: INTEGER is -32768
			-- Most negative INTEGER

	yyNtbase: INTEGER is 135
			-- Number of tokens

	yyLast: INTEGER is 3125
			-- Upper bound of `yytable' and `yycheck'

	yyMax_token: INTEGER is 389
			-- Maximum token id
			-- (upper bound of `yytranslate'.)

	yyNsyms: INTEGER is 369
			-- Number of symbols
			-- (terminal and nonterminal)

feature -- User-defined features



indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end -- class EIFFEL_PARSER



