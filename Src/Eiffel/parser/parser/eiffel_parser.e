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
					--|#line 831 "eiffel.y"
				yy_do_action_96
			when 97 then
					--|#line 837 "eiffel.y"
				yy_do_action_97
			when 98 then
					--|#line 849 "eiffel.y"
				yy_do_action_98
			when 99 then
					--|#line 853 "eiffel.y"
				yy_do_action_99
			when 100 then
					--|#line 859 "eiffel.y"
				yy_do_action_100
			when 101 then
					--|#line 861 "eiffel.y"
				yy_do_action_101
			when 102 then
					--|#line 868 "eiffel.y"
				yy_do_action_102
			when 103 then
					--|#line 870 "eiffel.y"
				yy_do_action_103
			when 104 then
					--|#line 878 "eiffel.y"
				yy_do_action_104
			when 105 then
					--|#line 887 "eiffel.y"
				yy_do_action_105
			when 106 then
					--|#line 894 "eiffel.y"
				yy_do_action_106
			when 107 then
					--|#line 894 "eiffel.y"
				yy_do_action_107
			when 108 then
					--|#line 903 "eiffel.y"
				yy_do_action_108
			when 109 then
					--|#line 907 "eiffel.y"
				yy_do_action_109
			when 110 then
					--|#line 911 "eiffel.y"
				yy_do_action_110
			when 111 then
					--|#line 915 "eiffel.y"
				yy_do_action_111
			when 112 then
					--|#line 919 "eiffel.y"
				yy_do_action_112
			when 113 then
					--|#line 923 "eiffel.y"
				yy_do_action_113
			when 114 then
					--|#line 927 "eiffel.y"
				yy_do_action_114
			when 115 then
					--|#line 931 "eiffel.y"
				yy_do_action_115
			when 116 then
					--|#line 937 "eiffel.y"
				yy_do_action_116
			when 117 then
					--|#line 939 "eiffel.y"
				yy_do_action_117
			when 118 then
					--|#line 943 "eiffel.y"
				yy_do_action_118
			when 119 then
					--|#line 950 "eiffel.y"
				yy_do_action_119
			when 120 then
					--|#line 950 "eiffel.y"
				yy_do_action_120
			when 121 then
					--|#line 960 "eiffel.y"
				yy_do_action_121
			when 122 then
					--|#line 964 "eiffel.y"
				yy_do_action_122
			when 123 then
					--|#line 966 "eiffel.y"
				yy_do_action_123
			when 124 then
					--|#line 970 "eiffel.y"
				yy_do_action_124
			when 125 then
					--|#line 972 "eiffel.y"
				yy_do_action_125
			when 126 then
					--|#line 976 "eiffel.y"
				yy_do_action_126
			when 127 then
					--|#line 983 "eiffel.y"
				yy_do_action_127
			when 128 then
					--|#line 983 "eiffel.y"
				yy_do_action_128
			when 129 then
					--|#line 992 "eiffel.y"
				yy_do_action_129
			when 130 then
					--|#line 998 "eiffel.y"
				yy_do_action_130
			when 131 then
					--|#line 1000 "eiffel.y"
				yy_do_action_131
			when 132 then
					--|#line 1002 "eiffel.y"
				yy_do_action_132
			when 133 then
					--|#line 1006 "eiffel.y"
				yy_do_action_133
			when 134 then
					--|#line 1008 "eiffel.y"
				yy_do_action_134
			when 135 then
					--|#line 1017 "eiffel.y"
				yy_do_action_135
			when 136 then
					--|#line 1024 "eiffel.y"
				yy_do_action_136
			when 137 then
					--|#line 1024 "eiffel.y"
				yy_do_action_137
			when 138 then
					--|#line 1035 "eiffel.y"
				yy_do_action_138
			when 139 then
					--|#line 1041 "eiffel.y"
				yy_do_action_139
			when 140 then
					--|#line 1049 "eiffel.y"
				yy_do_action_140
			when 141 then
					--|#line 1053 "eiffel.y"
				yy_do_action_141
			when 142 then
					--|#line 1060 "eiffel.y"
				yy_do_action_142
			when 143 then
					--|#line 1060 "eiffel.y"
				yy_do_action_143
			when 144 then
					--|#line 1070 "eiffel.y"
				yy_do_action_144
			when 145 then
					--|#line 1072 "eiffel.y"
				yy_do_action_145
			when 146 then
					--|#line 1076 "eiffel.y"
				yy_do_action_146
			when 147 then
					--|#line 1081 "eiffel.y"
				yy_do_action_147
			when 148 then
					--|#line 1087 "eiffel.y"
				yy_do_action_148
			when 149 then
					--|#line 1089 "eiffel.y"
				yy_do_action_149
			when 150 then
					--|#line 1093 "eiffel.y"
				yy_do_action_150
			when 151 then
					--|#line 1098 "eiffel.y"
				yy_do_action_151
			when 152 then
					--|#line 1104 "eiffel.y"
				yy_do_action_152
			when 153 then
					--|#line 1106 "eiffel.y"
				yy_do_action_153
			when 154 then
					--|#line 1110 "eiffel.y"
				yy_do_action_154
			when 155 then
					--|#line 1115 "eiffel.y"
				yy_do_action_155
			when 156 then
					--|#line 1125 "eiffel.y"
				yy_do_action_156
			when 157 then
					--|#line 1130 "eiffel.y"
				yy_do_action_157
			when 158 then
					--|#line 1132 "eiffel.y"
				yy_do_action_158
			when 159 then
					--|#line 1134 "eiffel.y"
				yy_do_action_159
			when 160 then
					--|#line 1138 "eiffel.y"
				yy_do_action_160
			when 161 then
					--|#line 1145 "eiffel.y"
				yy_do_action_161
			when 162 then
					--|#line 1145 "eiffel.y"
				yy_do_action_162
			when 163 then
					--|#line 1152 "eiffel.y"
				yy_do_action_163
			when 164 then
					--|#line 1156 "eiffel.y"
				yy_do_action_164
			when 165 then
					--|#line 1159 "eiffel.y"
				yy_do_action_165
			when 166 then
					--|#line 1161 "eiffel.y"
				yy_do_action_166
			when 167 then
					--|#line 1163 "eiffel.y"
				yy_do_action_167
			when 168 then
					--|#line 1167 "eiffel.y"
				yy_do_action_168
			when 169 then
					--|#line 1170 "eiffel.y"
				yy_do_action_169
			when 170 then
					--|#line 1176 "eiffel.y"
				yy_do_action_170
			when 171 then
					--|#line 1185 "eiffel.y"
				yy_do_action_171
			when 172 then
					--|#line 1185 "eiffel.y"
				yy_do_action_172
			when 173 then
					--|#line 1195 "eiffel.y"
				yy_do_action_173
			when 174 then
					--|#line 1199 "eiffel.y"
				yy_do_action_174
			when 175 then
					--|#line 1206 "eiffel.y"
				yy_do_action_175
			when 176 then
					--|#line 1207 "eiffel.y"
				yy_do_action_176
			when 177 then
					--|#line 1211 "eiffel.y"
				yy_do_action_177
			when 178 then
					--|#line 1213 "eiffel.y"
				yy_do_action_178
			when 179 then
					--|#line 1217 "eiffel.y"
				yy_do_action_179
			when 180 then
					--|#line 1217 "eiffel.y"
				yy_do_action_180
			when 181 then
					--|#line 1243 "eiffel.y"
				yy_do_action_181
			when 182 then
					--|#line 1245 "eiffel.y"
				yy_do_action_182
			when 183 then
					--|#line 1247 "eiffel.y"
				yy_do_action_183
			when 184 then
					--|#line 1251 "eiffel.y"
				yy_do_action_184
			when 185 then
					--|#line 1251 "eiffel.y"
				yy_do_action_185
			when 186 then
					--|#line 1269 "eiffel.y"
				yy_do_action_186
			when 187 then
					--|#line 1274 "eiffel.y"
				yy_do_action_187
			when 188 then
					--|#line 1276 "eiffel.y"
				yy_do_action_188
			when 189 then
					--|#line 1282 "eiffel.y"
				yy_do_action_189
			when 190 then
					--|#line 1284 "eiffel.y"
				yy_do_action_190
			when 191 then
					--|#line 1288 "eiffel.y"
				yy_do_action_191
			when 192 then
					--|#line 1290 "eiffel.y"
				yy_do_action_192
			when 193 then
					--|#line 1292 "eiffel.y"
				yy_do_action_193
			when 194 then
					--|#line 1296 "eiffel.y"
				yy_do_action_194
			when 195 then
					--|#line 1298 "eiffel.y"
				yy_do_action_195
			when 196 then
					--|#line 1302 "eiffel.y"
				yy_do_action_196
			when 197 then
					--|#line 1309 "eiffel.y"
				yy_do_action_197
			when 198 then
					--|#line 1309 "eiffel.y"
				yy_do_action_198
			when 199 then
					--|#line 1318 "eiffel.y"
				yy_do_action_199
			when 200 then
					--|#line 1327 "eiffel.y"
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
					--|#line 1328 "eiffel.y"
				yy_do_action_201
			when 202 then
					--|#line 1331 "eiffel.y"
				yy_do_action_202
			when 203 then
					--|#line 1333 "eiffel.y"
				yy_do_action_203
			when 204 then
					--|#line 1344 "eiffel.y"
				yy_do_action_204
			when 205 then
					--|#line 1346 "eiffel.y"
				yy_do_action_205
			when 206 then
					--|#line 1348 "eiffel.y"
				yy_do_action_206
			when 207 then
					--|#line 1350 "eiffel.y"
				yy_do_action_207
			when 208 then
					--|#line 1352 "eiffel.y"
				yy_do_action_208
			when 209 then
					--|#line 1354 "eiffel.y"
				yy_do_action_209
			when 210 then
					--|#line 1356 "eiffel.y"
				yy_do_action_210
			when 211 then
					--|#line 1358 "eiffel.y"
				yy_do_action_211
			when 212 then
					--|#line 1360 "eiffel.y"
				yy_do_action_212
			when 213 then
					--|#line 1364 "eiffel.y"
				yy_do_action_213
			when 214 then
					--|#line 1366 "eiffel.y"
				yy_do_action_214
			when 215 then
					--|#line 1366 "eiffel.y"
				yy_do_action_215
			when 216 then
					--|#line 1373 "eiffel.y"
				yy_do_action_216
			when 217 then
					--|#line 1373 "eiffel.y"
				yy_do_action_217
			when 218 then
					--|#line 1382 "eiffel.y"
				yy_do_action_218
			when 219 then
					--|#line 1384 "eiffel.y"
				yy_do_action_219
			when 220 then
					--|#line 1384 "eiffel.y"
				yy_do_action_220
			when 221 then
					--|#line 1391 "eiffel.y"
				yy_do_action_221
			when 222 then
					--|#line 1391 "eiffel.y"
				yy_do_action_222
			when 223 then
					--|#line 1400 "eiffel.y"
				yy_do_action_223
			when 224 then
					--|#line 1402 "eiffel.y"
				yy_do_action_224
			when 225 then
					--|#line 1411 "eiffel.y"
				yy_do_action_225
			when 226 then
					--|#line 1424 "eiffel.y"
				yy_do_action_226
			when 227 then
					--|#line 1424 "eiffel.y"
				yy_do_action_227
			when 228 then
					--|#line 1440 "eiffel.y"
				yy_do_action_228
			when 229 then
					--|#line 1442 "eiffel.y"
				yy_do_action_229
			when 230 then
					--|#line 1444 "eiffel.y"
				yy_do_action_230
			when 231 then
					--|#line 1457 "eiffel.y"
				yy_do_action_231
			when 232 then
					--|#line 1459 "eiffel.y"
				yy_do_action_232
			when 233 then
					--|#line 1463 "eiffel.y"
				yy_do_action_233
			when 234 then
					--|#line 1466 "eiffel.y"
				yy_do_action_234
			when 235 then
					--|#line 1468 "eiffel.y"
				yy_do_action_235
			when 236 then
					--|#line 1472 "eiffel.y"
				yy_do_action_236
			when 237 then
					--|#line 1478 "eiffel.y"
				yy_do_action_237
			when 238 then
					--|#line 1487 "eiffel.y"
				yy_do_action_238
			when 239 then
					--|#line 1489 "eiffel.y"
				yy_do_action_239
			when 240 then
					--|#line 1491 "eiffel.y"
				yy_do_action_240
			when 241 then
					--|#line 1493 "eiffel.y"
				yy_do_action_241
			when 242 then
					--|#line 1497 "eiffel.y"
				yy_do_action_242
			when 243 then
					--|#line 1499 "eiffel.y"
				yy_do_action_243
			when 244 then
					--|#line 1503 "eiffel.y"
				yy_do_action_244
			when 245 then
					--|#line 1507 "eiffel.y"
				yy_do_action_245
			when 246 then
					--|#line 1509 "eiffel.y"
				yy_do_action_246
			when 247 then
					--|#line 1515 "eiffel.y"
				yy_do_action_247
			when 248 then
					--|#line 1522 "eiffel.y"
				yy_do_action_248
			when 249 then
					--|#line 1531 "eiffel.y"
				yy_do_action_249
			when 250 then
					--|#line 1535 "eiffel.y"
				yy_do_action_250
			when 251 then
					--|#line 1542 "eiffel.y"
				yy_do_action_251
			when 252 then
					--|#line 1542 "eiffel.y"
				yy_do_action_252
			when 253 then
					--|#line 1552 "eiffel.y"
				yy_do_action_253
			when 254 then
					--|#line 1554 "eiffel.y"
				yy_do_action_254
			when 255 then
					--|#line 1565 "eiffel.y"
				yy_do_action_255
			when 256 then
					--|#line 1574 "eiffel.y"
				yy_do_action_256
			when 257 then
					--|#line 1585 "eiffel.y"
				yy_do_action_257
			when 258 then
					--|#line 1593 "eiffel.y"
				yy_do_action_258
			when 259 then
					--|#line 1604 "eiffel.y"
				yy_do_action_259
			when 260 then
					--|#line 1614 "eiffel.y"
				yy_do_action_260
			when 261 then
					--|#line 1631 "eiffel.y"
				yy_do_action_261
			when 262 then
					--|#line 1648 "eiffel.y"
				yy_do_action_262
			when 263 then
					--|#line 1672 "eiffel.y"
				yy_do_action_263
			when 264 then
					--|#line 1677 "eiffel.y"
				yy_do_action_264
			when 265 then
					--|#line 1686 "eiffel.y"
				yy_do_action_265
			when 266 then
					--|#line 1696 "eiffel.y"
				yy_do_action_266
			when 267 then
					--|#line 1703 "eiffel.y"
				yy_do_action_267
			when 268 then
					--|#line 1703 "eiffel.y"
				yy_do_action_268
			when 269 then
					--|#line 1713 "eiffel.y"
				yy_do_action_269
			when 270 then
					--|#line 1727 "eiffel.y"
				yy_do_action_270
			when 271 then
					--|#line 1742 "eiffel.y"
				yy_do_action_271
			when 272 then
					--|#line 1758 "eiffel.y"
				yy_do_action_272
			when 273 then
					--|#line 1758 "eiffel.y"
				yy_do_action_273
			when 274 then
					--|#line 1781 "eiffel.y"
				yy_do_action_274
			when 275 then
					--|#line 1783 "eiffel.y"
				yy_do_action_275
			when 276 then
					--|#line 1789 "eiffel.y"
				yy_do_action_276
			when 277 then
					--|#line 1791 "eiffel.y"
				yy_do_action_277
			when 278 then
					--|#line 1801 "eiffel.y"
				yy_do_action_278
			when 279 then
					--|#line 1803 "eiffel.y"
				yy_do_action_279
			when 280 then
					--|#line 1812 "eiffel.y"
				yy_do_action_280
			when 281 then
					--|#line 1814 "eiffel.y"
				yy_do_action_281
			when 282 then
					--|#line 1824 "eiffel.y"
				yy_do_action_282
			when 283 then
					--|#line 1828 "eiffel.y"
				yy_do_action_283
			when 284 then
					--|#line 1835 "eiffel.y"
				yy_do_action_284
			when 285 then
					--|#line 1835 "eiffel.y"
				yy_do_action_285
			when 286 then
					--|#line 1844 "eiffel.y"
				yy_do_action_286
			when 287 then
					--|#line 1848 "eiffel.y"
				yy_do_action_287
			when 288 then
					--|#line 1852 "eiffel.y"
				yy_do_action_288
			when 289 then
					--|#line 1854 "eiffel.y"
				yy_do_action_289
			when 290 then
					--|#line 1865 "eiffel.y"
				yy_do_action_290
			when 291 then
					--|#line 1867 "eiffel.y"
				yy_do_action_291
			when 292 then
					--|#line 1871 "eiffel.y"
				yy_do_action_292
			when 293 then
					--|#line 1878 "eiffel.y"
				yy_do_action_293
			when 294 then
					--|#line 1878 "eiffel.y"
				yy_do_action_294
			when 295 then
					--|#line 1887 "eiffel.y"
				yy_do_action_295
			when 296 then
					--|#line 1891 "eiffel.y"
				yy_do_action_296
			when 297 then
					--|#line 1898 "eiffel.y"
				yy_do_action_297
			when 298 then
					--|#line 1898 "eiffel.y"
				yy_do_action_298
			when 299 then
					--|#line 1908 "eiffel.y"
				yy_do_action_299
			when 300 then
					--|#line 1910 "eiffel.y"
				yy_do_action_300
			when 301 then
					--|#line 1912 "eiffel.y"
				yy_do_action_301
			when 302 then
					--|#line 1914 "eiffel.y"
				yy_do_action_302
			when 303 then
					--|#line 1916 "eiffel.y"
				yy_do_action_303
			when 304 then
					--|#line 1918 "eiffel.y"
				yy_do_action_304
			when 305 then
					--|#line 1920 "eiffel.y"
				yy_do_action_305
			when 306 then
					--|#line 1922 "eiffel.y"
				yy_do_action_306
			when 307 then
					--|#line 1924 "eiffel.y"
				yy_do_action_307
			when 308 then
					--|#line 1926 "eiffel.y"
				yy_do_action_308
			when 309 then
					--|#line 1928 "eiffel.y"
				yy_do_action_309
			when 310 then
					--|#line 1930 "eiffel.y"
				yy_do_action_310
			when 311 then
					--|#line 1932 "eiffel.y"
				yy_do_action_311
			when 312 then
					--|#line 1934 "eiffel.y"
				yy_do_action_312
			when 313 then
					--|#line 1936 "eiffel.y"
				yy_do_action_313
			when 314 then
					--|#line 1938 "eiffel.y"
				yy_do_action_314
			when 315 then
					--|#line 1940 "eiffel.y"
				yy_do_action_315
			when 316 then
					--|#line 1942 "eiffel.y"
				yy_do_action_316
			when 317 then
					--|#line 1947 "eiffel.y"
				yy_do_action_317
			when 318 then
					--|#line 1957 "eiffel.y"
				yy_do_action_318
			when 319 then
					--|#line 1959 "eiffel.y"
				yy_do_action_319
			when 320 then
					--|#line 1963 "eiffel.y"
				yy_do_action_320
			when 321 then
					--|#line 1965 "eiffel.y"
				yy_do_action_321
			when 322 then
					--|#line 1965 "eiffel.y"
				yy_do_action_322
			when 323 then
					--|#line 1975 "eiffel.y"
				yy_do_action_323
			when 324 then
					--|#line 1977 "eiffel.y"
				yy_do_action_324
			when 325 then
					--|#line 1979 "eiffel.y"
				yy_do_action_325
			when 326 then
					--|#line 1983 "eiffel.y"
				yy_do_action_326
			when 327 then
					--|#line 1987 "eiffel.y"
				yy_do_action_327
			when 328 then
					--|#line 1989 "eiffel.y"
				yy_do_action_328
			when 329 then
					--|#line 1994 "eiffel.y"
				yy_do_action_329
			when 330 then
					--|#line 1998 "eiffel.y"
				yy_do_action_330
			when 331 then
					--|#line 2005 "eiffel.y"
				yy_do_action_331
			when 332 then
					--|#line 2005 "eiffel.y"
				yy_do_action_332
			when 333 then
					--|#line 2015 "eiffel.y"
				yy_do_action_333
			when 334 then
					--|#line 2017 "eiffel.y"
				yy_do_action_334
			when 335 then
					--|#line 2027 "eiffel.y"
				yy_do_action_335
			when 336 then
					--|#line 2030 "eiffel.y"
				yy_do_action_336
			when 337 then
					--|#line 2032 "eiffel.y"
				yy_do_action_337
			when 338 then
					--|#line 2034 "eiffel.y"
				yy_do_action_338
			when 339 then
					--|#line 2038 "eiffel.y"
				yy_do_action_339
			when 340 then
					--|#line 2042 "eiffel.y"
				yy_do_action_340
			when 341 then
					--|#line 2044 "eiffel.y"
				yy_do_action_341
			when 342 then
					--|#line 2048 "eiffel.y"
				yy_do_action_342
			when 343 then
					--|#line 2050 "eiffel.y"
				yy_do_action_343
			when 344 then
					--|#line 2054 "eiffel.y"
				yy_do_action_344
			when 345 then
					--|#line 2056 "eiffel.y"
				yy_do_action_345
			when 346 then
					--|#line 2060 "eiffel.y"
				yy_do_action_346
			when 347 then
					--|#line 2067 "eiffel.y"
				yy_do_action_347
			when 348 then
					--|#line 2067 "eiffel.y"
				yy_do_action_348
			when 349 then
					--|#line 2076 "eiffel.y"
				yy_do_action_349
			when 350 then
					--|#line 2081 "eiffel.y"
				yy_do_action_350
			when 351 then
					--|#line 2085 "eiffel.y"
				yy_do_action_351
			when 352 then
					--|#line 2089 "eiffel.y"
				yy_do_action_352
			when 353 then
					--|#line 2094 "eiffel.y"
				yy_do_action_353
			when 354 then
					--|#line 2099 "eiffel.y"
				yy_do_action_354
			when 355 then
					--|#line 2106 "eiffel.y"
				yy_do_action_355
			when 356 then
					--|#line 2111 "eiffel.y"
				yy_do_action_356
			when 357 then
					--|#line 2123 "eiffel.y"
				yy_do_action_357
			when 358 then
					--|#line 2139 "eiffel.y"
				yy_do_action_358
			when 359 then
					--|#line 2143 "eiffel.y"
				yy_do_action_359
			when 360 then
					--|#line 2147 "eiffel.y"
				yy_do_action_360
			when 361 then
					--|#line 2155 "eiffel.y"
				yy_do_action_361
			when 362 then
					--|#line 2159 "eiffel.y"
				yy_do_action_362
			when 363 then
					--|#line 2163 "eiffel.y"
				yy_do_action_363
			when 364 then
					--|#line 2170 "eiffel.y"
				yy_do_action_364
			when 365 then
					--|#line 2180 "eiffel.y"
				yy_do_action_365
			when 366 then
					--|#line 2182 "eiffel.y"
				yy_do_action_366
			when 367 then
					--|#line 2184 "eiffel.y"
				yy_do_action_367
			when 368 then
					--|#line 2186 "eiffel.y"
				yy_do_action_368
			when 369 then
					--|#line 2188 "eiffel.y"
				yy_do_action_369
			when 370 then
					--|#line 2190 "eiffel.y"
				yy_do_action_370
			when 371 then
					--|#line 2200 "eiffel.y"
				yy_do_action_371
			when 372 then
					--|#line 2202 "eiffel.y"
				yy_do_action_372
			when 373 then
					--|#line 2207 "eiffel.y"
				yy_do_action_373
			when 374 then
					--|#line 2211 "eiffel.y"
				yy_do_action_374
			when 375 then
					--|#line 2218 "eiffel.y"
				yy_do_action_375
			when 376 then
					--|#line 2218 "eiffel.y"
				yy_do_action_376
			when 377 then
					--|#line 2228 "eiffel.y"
				yy_do_action_377
			when 378 then
					--|#line 2238 "eiffel.y"
				yy_do_action_378
			when 379 then
					--|#line 2244 "eiffel.y"
				yy_do_action_379
			when 380 then
					--|#line 2248 "eiffel.y"
				yy_do_action_380
			when 381 then
					--|#line 2253 "eiffel.y"
				yy_do_action_381
			when 382 then
					--|#line 2258 "eiffel.y"
				yy_do_action_382
			when 383 then
					--|#line 2260 "eiffel.y"
				yy_do_action_383
			when 384 then
					--|#line 2264 "eiffel.y"
				yy_do_action_384
			when 385 then
					--|#line 2266 "eiffel.y"
				yy_do_action_385
			when 386 then
					--|#line 2273 "eiffel.y"
				yy_do_action_386
			when 387 then
					--|#line 2275 "eiffel.y"
				yy_do_action_387
			when 388 then
					--|#line 2279 "eiffel.y"
				yy_do_action_388
			when 389 then
					--|#line 2281 "eiffel.y"
				yy_do_action_389
			when 390 then
					--|#line 2289 "eiffel.y"
				yy_do_action_390
			when 391 then
					--|#line 2291 "eiffel.y"
				yy_do_action_391
			when 392 then
					--|#line 2293 "eiffel.y"
				yy_do_action_392
			when 393 then
					--|#line 2295 "eiffel.y"
				yy_do_action_393
			when 394 then
					--|#line 2299 "eiffel.y"
				yy_do_action_394
			when 395 then
					--|#line 2306 "eiffel.y"
				yy_do_action_395
			when 396 then
					--|#line 2315 "eiffel.y"
				yy_do_action_396
			when 397 then
					--|#line 2318 "eiffel.y"
				yy_do_action_397
			when 398 then
					--|#line 2320 "eiffel.y"
				yy_do_action_398
			when 399 then
					--|#line 2322 "eiffel.y"
				yy_do_action_399
			when 400 then
					--|#line 2324 "eiffel.y"
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
					--|#line 2326 "eiffel.y"
				yy_do_action_401
			when 402 then
					--|#line 2328 "eiffel.y"
				yy_do_action_402
			when 403 then
					--|#line 2332 "eiffel.y"
				yy_do_action_403
			when 404 then
					--|#line 2335 "eiffel.y"
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
					--|#line 2345 "eiffel.y"
				yy_do_action_409
			when 410 then
					--|#line 2347 "eiffel.y"
				yy_do_action_410
			when 411 then
					--|#line 2349 "eiffel.y"
				yy_do_action_411
			when 412 then
					--|#line 2351 "eiffel.y"
				yy_do_action_412
			when 413 then
					--|#line 2353 "eiffel.y"
				yy_do_action_413
			when 414 then
					--|#line 2355 "eiffel.y"
				yy_do_action_414
			when 415 then
					--|#line 2357 "eiffel.y"
				yy_do_action_415
			when 416 then
					--|#line 2359 "eiffel.y"
				yy_do_action_416
			when 417 then
					--|#line 2361 "eiffel.y"
				yy_do_action_417
			when 418 then
					--|#line 2363 "eiffel.y"
				yy_do_action_418
			when 419 then
					--|#line 2365 "eiffel.y"
				yy_do_action_419
			when 420 then
					--|#line 2367 "eiffel.y"
				yy_do_action_420
			when 421 then
					--|#line 2371 "eiffel.y"
				yy_do_action_421
			when 422 then
					--|#line 2373 "eiffel.y"
				yy_do_action_422
			when 423 then
					--|#line 2375 "eiffel.y"
				yy_do_action_423
			when 424 then
					--|#line 2377 "eiffel.y"
				yy_do_action_424
			when 425 then
					--|#line 2379 "eiffel.y"
				yy_do_action_425
			when 426 then
					--|#line 2383 "eiffel.y"
				yy_do_action_426
			when 427 then
					--|#line 2385 "eiffel.y"
				yy_do_action_427
			when 428 then
					--|#line 2389 "eiffel.y"
				yy_do_action_428
			when 429 then
					--|#line 2393 "eiffel.y"
				yy_do_action_429
			when 430 then
					--|#line 2397 "eiffel.y"
				yy_do_action_430
			when 431 then
					--|#line 2399 "eiffel.y"
				yy_do_action_431
			when 432 then
					--|#line 2403 "eiffel.y"
				yy_do_action_432
			when 433 then
					--|#line 2406 "eiffel.y"
				yy_do_action_433
			when 434 then
					--|#line 2408 "eiffel.y"
				yy_do_action_434
			when 435 then
					--|#line 2410 "eiffel.y"
				yy_do_action_435
			when 436 then
					--|#line 2412 "eiffel.y"
				yy_do_action_436
			when 437 then
					--|#line 2416 "eiffel.y"
				yy_do_action_437
			when 438 then
					--|#line 2419 "eiffel.y"
				yy_do_action_438
			when 439 then
					--|#line 2421 "eiffel.y"
				yy_do_action_439
			when 440 then
					--|#line 2425 "eiffel.y"
				yy_do_action_440
			when 441 then
					--|#line 2437 "eiffel.y"
				yy_do_action_441
			when 442 then
					--|#line 2440 "eiffel.y"
				yy_do_action_442
			when 443 then
					--|#line 2442 "eiffel.y"
				yy_do_action_443
			when 444 then
					--|#line 2444 "eiffel.y"
				yy_do_action_444
			when 445 then
					--|#line 2446 "eiffel.y"
				yy_do_action_445
			when 446 then
					--|#line 2448 "eiffel.y"
				yy_do_action_446
			when 447 then
					--|#line 2452 "eiffel.y"
				yy_do_action_447
			when 448 then
					--|#line 2454 "eiffel.y"
				yy_do_action_448
			when 449 then
					--|#line 2465 "eiffel.y"
				yy_do_action_449
			when 450 then
					--|#line 2467 "eiffel.y"
				yy_do_action_450
			when 451 then
					--|#line 2471 "eiffel.y"
				yy_do_action_451
			when 452 then
					--|#line 2476 "eiffel.y"
				yy_do_action_452
			when 453 then
					--|#line 2484 "eiffel.y"
				yy_do_action_453
			when 454 then
					--|#line 2486 "eiffel.y"
				yy_do_action_454
			when 455 then
					--|#line 2490 "eiffel.y"
				yy_do_action_455
			when 456 then
					--|#line 2492 "eiffel.y"
				yy_do_action_456
			when 457 then
					--|#line 2496 "eiffel.y"
				yy_do_action_457
			when 458 then
					--|#line 2498 "eiffel.y"
				yy_do_action_458
			when 459 then
					--|#line 2504 "eiffel.y"
				yy_do_action_459
			when 460 then
					--|#line 2512 "eiffel.y"
				yy_do_action_460
			when 461 then
					--|#line 2525 "eiffel.y"
				yy_do_action_461
			when 462 then
					--|#line 2529 "eiffel.y"
				yy_do_action_462
			when 463 then
					--|#line 2532 "eiffel.y"
				yy_do_action_463
			when 464 then
					--|#line 2534 "eiffel.y"
				yy_do_action_464
			when 465 then
					--|#line 2536 "eiffel.y"
				yy_do_action_465
			when 466 then
					--|#line 2538 "eiffel.y"
				yy_do_action_466
			when 467 then
					--|#line 2540 "eiffel.y"
				yy_do_action_467
			when 468 then
					--|#line 2542 "eiffel.y"
				yy_do_action_468
			when 469 then
					--|#line 2546 "eiffel.y"
				yy_do_action_469
			when 470 then
					--|#line 2548 "eiffel.y"
				yy_do_action_470
			when 471 then
					--|#line 2553 "eiffel.y"
				yy_do_action_471
			when 472 then
					--|#line 2557 "eiffel.y"
				yy_do_action_472
			when 473 then
					--|#line 2564 "eiffel.y"
				yy_do_action_473
			when 474 then
					--|#line 2564 "eiffel.y"
				yy_do_action_474
			when 475 then
					--|#line 2574 "eiffel.y"
				yy_do_action_475
			when 476 then
					--|#line 2581 "eiffel.y"
				yy_do_action_476
			when 477 then
					--|#line 2587 "eiffel.y"
				yy_do_action_477
			when 478 then
					--|#line 2594 "eiffel.y"
				yy_do_action_478
			when 479 then
					--|#line 2605 "eiffel.y"
				yy_do_action_479
			when 480 then
					--|#line 2609 "eiffel.y"
				yy_do_action_480
			when 481 then
					--|#line 2616 "eiffel.y"
				yy_do_action_481
			when 482 then
					--|#line 2623 "eiffel.y"
				yy_do_action_482
			when 483 then
					--|#line 2633 "eiffel.y"
				yy_do_action_483
			when 484 then
					--|#line 2637 "eiffel.y"
				yy_do_action_484
			when 485 then
					--|#line 2639 "eiffel.y"
				yy_do_action_485
			when 486 then
					--|#line 2641 "eiffel.y"
				yy_do_action_486
			when 487 then
					--|#line 2643 "eiffel.y"
				yy_do_action_487
			when 488 then
					--|#line 2645 "eiffel.y"
				yy_do_action_488
			when 489 then
					--|#line 2647 "eiffel.y"
				yy_do_action_489
			when 490 then
					--|#line 2652 "eiffel.y"
				yy_do_action_490
			when 491 then
					--|#line 2655 "eiffel.y"
				yy_do_action_491
			when 492 then
					--|#line 2657 "eiffel.y"
				yy_do_action_492
			when 493 then
					--|#line 2659 "eiffel.y"
				yy_do_action_493
			when 494 then
					--|#line 2661 "eiffel.y"
				yy_do_action_494
			when 495 then
					--|#line 2663 "eiffel.y"
				yy_do_action_495
			when 496 then
					--|#line 2665 "eiffel.y"
				yy_do_action_496
			when 497 then
					--|#line 2667 "eiffel.y"
				yy_do_action_497
			when 498 then
					--|#line 2669 "eiffel.y"
				yy_do_action_498
			when 499 then
					--|#line 2680 "eiffel.y"
				yy_do_action_499
			when 500 then
					--|#line 2682 "eiffel.y"
				yy_do_action_500
			when 501 then
					--|#line 2686 "eiffel.y"
				yy_do_action_501
			when 502 then
					--|#line 2691 "eiffel.y"
				yy_do_action_502
			when 503 then
					--|#line 2702 "eiffel.y"
				yy_do_action_503
			when 504 then
					--|#line 2705 "eiffel.y"
				yy_do_action_504
			when 505 then
					--|#line 2707 "eiffel.y"
				yy_do_action_505
			when 506 then
					--|#line 2711 "eiffel.y"
				yy_do_action_506
			when 507 then
					--|#line 2715 "eiffel.y"
				yy_do_action_507
			when 508 then
					--|#line 2721 "eiffel.y"
				yy_do_action_508
			when 509 then
					--|#line 2727 "eiffel.y"
				yy_do_action_509
			when 510 then
					--|#line 2729 "eiffel.y"
				yy_do_action_510
			when 511 then
					--|#line 2733 "eiffel.y"
				yy_do_action_511
			when 512 then
					--|#line 2739 "eiffel.y"
				yy_do_action_512
			when 513 then
					--|#line 2743 "eiffel.y"
				yy_do_action_513
			when 514 then
					--|#line 2752 "eiffel.y"
				yy_do_action_514
			when 515 then
					--|#line 2754 "eiffel.y"
				yy_do_action_515
			when 516 then
					--|#line 2756 "eiffel.y"
				yy_do_action_516
			when 517 then
					--|#line 2760 "eiffel.y"
				yy_do_action_517
			when 518 then
					--|#line 2766 "eiffel.y"
				yy_do_action_518
			when 519 then
					--|#line 2770 "eiffel.y"
				yy_do_action_519
			when 520 then
					--|#line 2776 "eiffel.y"
				yy_do_action_520
			when 521 then
					--|#line 2778 "eiffel.y"
				yy_do_action_521
			when 522 then
					--|#line 2782 "eiffel.y"
				yy_do_action_522
			when 523 then
					--|#line 2788 "eiffel.y"
				yy_do_action_523
			when 524 then
					--|#line 2792 "eiffel.y"
				yy_do_action_524
			when 525 then
					--|#line 2801 "eiffel.y"
				yy_do_action_525
			when 526 then
					--|#line 2808 "eiffel.y"
				yy_do_action_526
			when 527 then
					--|#line 2810 "eiffel.y"
				yy_do_action_527
			when 528 then
					--|#line 2814 "eiffel.y"
				yy_do_action_528
			when 529 then
					--|#line 2816 "eiffel.y"
				yy_do_action_529
			when 530 then
					--|#line 2820 "eiffel.y"
				yy_do_action_530
			when 531 then
					--|#line 2826 "eiffel.y"
				yy_do_action_531
			when 532 then
					--|#line 2840 "eiffel.y"
				yy_do_action_532
			when 533 then
					--|#line 2844 "eiffel.y"
				yy_do_action_533
			when 534 then
					--|#line 2848 "eiffel.y"
				yy_do_action_534
			when 535 then
					--|#line 2852 "eiffel.y"
				yy_do_action_535
			when 536 then
					--|#line 2856 "eiffel.y"
				yy_do_action_536
			when 537 then
					--|#line 2860 "eiffel.y"
				yy_do_action_537
			when 538 then
					--|#line 2864 "eiffel.y"
				yy_do_action_538
			when 539 then
					--|#line 2868 "eiffel.y"
				yy_do_action_539
			when 540 then
					--|#line 2872 "eiffel.y"
				yy_do_action_540
			when 541 then
					--|#line 2876 "eiffel.y"
				yy_do_action_541
			when 542 then
					--|#line 2880 "eiffel.y"
				yy_do_action_542
			when 543 then
					--|#line 2884 "eiffel.y"
				yy_do_action_543
			when 544 then
					--|#line 2888 "eiffel.y"
				yy_do_action_544
			when 545 then
					--|#line 2892 "eiffel.y"
				yy_do_action_545
			when 546 then
					--|#line 2896 "eiffel.y"
				yy_do_action_546
			when 547 then
					--|#line 2900 "eiffel.y"
				yy_do_action_547
			when 548 then
					--|#line 2904 "eiffel.y"
				yy_do_action_548
			when 549 then
					--|#line 2908 "eiffel.y"
				yy_do_action_549
			when 550 then
					--|#line 2912 "eiffel.y"
				yy_do_action_550
			when 551 then
					--|#line 2916 "eiffel.y"
				yy_do_action_551
			when 552 then
					--|#line 2920 "eiffel.y"
				yy_do_action_552
			when 553 then
					--|#line 2924 "eiffel.y"
				yy_do_action_553
			when 554 then
					--|#line 2930 "eiffel.y"
				yy_do_action_554
			when 555 then
					--|#line 2934 "eiffel.y"
				yy_do_action_555
			when 556 then
					--|#line 2938 "eiffel.y"
				yy_do_action_556
			when 557 then
					--|#line 2942 "eiffel.y"
				yy_do_action_557
			when 558 then
					--|#line 2948 "eiffel.y"
				yy_do_action_558
			when 559 then
					--|#line 2952 "eiffel.y"
				yy_do_action_559
			when 560 then
					--|#line 2956 "eiffel.y"
				yy_do_action_560
			when 561 then
					--|#line 2960 "eiffel.y"
				yy_do_action_561
			when 562 then
					--|#line 2964 "eiffel.y"
				yy_do_action_562
			when 563 then
					--|#line 2968 "eiffel.y"
				yy_do_action_563
			when 564 then
					--|#line 2972 "eiffel.y"
				yy_do_action_564
			when 565 then
					--|#line 2976 "eiffel.y"
				yy_do_action_565
			when 566 then
					--|#line 2980 "eiffel.y"
				yy_do_action_566
			when 567 then
					--|#line 2984 "eiffel.y"
				yy_do_action_567
			when 568 then
					--|#line 2988 "eiffel.y"
				yy_do_action_568
			when 569 then
					--|#line 2992 "eiffel.y"
				yy_do_action_569
			when 570 then
					--|#line 2996 "eiffel.y"
				yy_do_action_570
			when 571 then
					--|#line 3000 "eiffel.y"
				yy_do_action_571
			when 572 then
					--|#line 3004 "eiffel.y"
				yy_do_action_572
			when 573 then
					--|#line 3008 "eiffel.y"
				yy_do_action_573
			when 574 then
					--|#line 3012 "eiffel.y"
				yy_do_action_574
			when 575 then
					--|#line 3016 "eiffel.y"
				yy_do_action_575
			when 576 then
					--|#line 3022 "eiffel.y"
				yy_do_action_576
			when 577 then
					--|#line 3026 "eiffel.y"
				yy_do_action_577
			when 578 then
					--|#line 3030 "eiffel.y"
				yy_do_action_578
			when 579 then
					--|#line 3032 "eiffel.y"
				yy_do_action_579
			when 580 then
					--|#line 3036 "eiffel.y"
				yy_do_action_580
			when 581 then
					--|#line 3039 "eiffel.y"
				yy_do_action_581
			when 582 then
					--|#line 3042 "eiffel.y"
				yy_do_action_582
			when 583 then
					--|#line 3045 "eiffel.y"
				yy_do_action_583
			when 584 then
					--|#line 3048 "eiffel.y"
				yy_do_action_584
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

	yy_do_action_96 is
			--|#line 831 "eiffel.y"
		local
			yyval34: BODY_AS
		do
--|#line 831 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 831")
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

	yy_do_action_97 is
			--|#line 837 "eiffel.y"
		local
			yyval34: BODY_AS
		do
--|#line 837 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 837")
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

	yy_do_action_98 is
			--|#line 849 "eiffel.y"
		local
			yyval17: PAIR [KEYWORD_AS, ID_AS]
		do
--|#line 849 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 849")
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

	yy_do_action_99 is
			--|#line 853 "eiffel.y"
		local
			yyval17: PAIR [KEYWORD_AS, ID_AS]
		do
--|#line 853 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 853")
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

	yy_do_action_100 is
			--|#line 859 "eiffel.y"
		local
			yyval39: CONSTANT_AS
		do
--|#line 859 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 859")
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

	yy_do_action_101 is
			--|#line 861 "eiffel.y"
		local
			yyval39: CONSTANT_AS
		do
--|#line 861 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 861")
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

	yy_do_action_102 is
			--|#line 868 "eiffel.y"
		local
			yyval106: PARENT_LIST_AS
		do
--|#line 868 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 868")
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

	yy_do_action_103 is
			--|#line 870 "eiffel.y"
		local
			yyval106: PARENT_LIST_AS
		do
--|#line 870 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 870")
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

	yy_do_action_104 is
			--|#line 878 "eiffel.y"
		local
			yyval106: PARENT_LIST_AS
		do
--|#line 878 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 878")
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

	yy_do_action_105 is
			--|#line 887 "eiffel.y"
		local
			yyval106: PARENT_LIST_AS
		do
--|#line 887 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 887")
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

	yy_do_action_106 is
			--|#line 894 "eiffel.y"
		local
			yyval106: PARENT_LIST_AS
		do
--|#line 894 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 894")
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

	yy_do_action_107 is
			--|#line 894 "eiffel.y"
		local
			yyval106: PARENT_LIST_AS
		do
--|#line 894 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 894")
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

	yy_do_action_108 is
			--|#line 903 "eiffel.y"
		local
			yyval66: PARENT_AS
		do
--|#line 903 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 903")
end

yyval66 := yyvs66.item (yyvsp66) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp4 := yyvsp4 -1
	yyvs66.put (yyval66, yyvsp66)
end
		end

	yy_do_action_109 is
			--|#line 907 "eiffel.y"
		local
			yyval80: CLASS_TYPE_AS
		do
--|#line 907 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 907")
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

	yy_do_action_110 is
			--|#line 911 "eiffel.y"
		local
			yyval66: PARENT_AS
		do
--|#line 911 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 911")
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

	yy_do_action_111 is
			--|#line 915 "eiffel.y"
		local
			yyval66: PARENT_AS
		do
--|#line 915 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 915")
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

	yy_do_action_112 is
			--|#line 919 "eiffel.y"
		local
			yyval66: PARENT_AS
		do
--|#line 919 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 919")
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

	yy_do_action_113 is
			--|#line 923 "eiffel.y"
		local
			yyval66: PARENT_AS
		do
--|#line 923 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 923")
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

	yy_do_action_114 is
			--|#line 927 "eiffel.y"
		local
			yyval66: PARENT_AS
		do
--|#line 927 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 927")
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

	yy_do_action_115 is
			--|#line 931 "eiffel.y"
		local
			yyval66: PARENT_AS
		do
--|#line 931 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 931")
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

	yy_do_action_116 is
			--|#line 937 "eiffel.y"
		local
			yyval108: RENAME_CLAUSE_AS
		do
--|#line 937 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 937")
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

	yy_do_action_117 is
			--|#line 939 "eiffel.y"
		local
			yyval108: RENAME_CLAUSE_AS
		do
--|#line 939 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 939")
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

	yy_do_action_118 is
			--|#line 943 "eiffel.y"
		local
			yyval107: EIFFEL_LIST [RENAME_AS]
		do
--|#line 943 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 943")
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

	yy_do_action_119 is
			--|#line 950 "eiffel.y"
		local
			yyval107: EIFFEL_LIST [RENAME_AS]
		do
--|#line 950 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 950")
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

	yy_do_action_120 is
			--|#line 950 "eiffel.y"
		local
			yyval107: EIFFEL_LIST [RENAME_AS]
		do
--|#line 950 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 950")
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

	yy_do_action_121 is
			--|#line 960 "eiffel.y"
		local
			yyval70: RENAME_AS
		do
--|#line 960 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 960")
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

	yy_do_action_122 is
			--|#line 964 "eiffel.y"
		local
			yyval90: EXPORT_CLAUSE_AS
		do
--|#line 964 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 964")
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

	yy_do_action_123 is
			--|#line 966 "eiffel.y"
		local
			yyval90: EXPORT_CLAUSE_AS
		do
--|#line 966 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 966")
end

yyval90 := yyvs90.item (yyvsp90) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs90.put (yyval90, yyvsp90)
end
		end

	yy_do_action_124 is
			--|#line 970 "eiffel.y"
		local
			yyval90: EXPORT_CLAUSE_AS
		do
--|#line 970 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 970")
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

	yy_do_action_125 is
			--|#line 972 "eiffel.y"
		local
			yyval90: EXPORT_CLAUSE_AS
		do
--|#line 972 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 972")
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

	yy_do_action_126 is
			--|#line 976 "eiffel.y"
		local
			yyval89: EIFFEL_LIST [EXPORT_ITEM_AS]
		do
--|#line 976 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 976")
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

	yy_do_action_127 is
			--|#line 983 "eiffel.y"
		local
			yyval89: EIFFEL_LIST [EXPORT_ITEM_AS]
		do
--|#line 983 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 983")
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

	yy_do_action_128 is
			--|#line 983 "eiffel.y"
		local
			yyval89: EIFFEL_LIST [EXPORT_ITEM_AS]
		do
--|#line 983 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 983")
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

	yy_do_action_129 is
			--|#line 992 "eiffel.y"
		local
			yyval47: EXPORT_ITEM_AS
		do
--|#line 992 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 992")
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

	yy_do_action_130 is
			--|#line 998 "eiffel.y"
		local
			yyval53: FEATURE_SET_AS
		do
--|#line 998 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 998")
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

	yy_do_action_131 is
			--|#line 1000 "eiffel.y"
		local
			yyval53: FEATURE_SET_AS
		do
--|#line 1000 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1000")
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

	yy_do_action_132 is
			--|#line 1002 "eiffel.y"
		local
			yyval53: FEATURE_SET_AS
		do
--|#line 1002 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1002")
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

	yy_do_action_133 is
			--|#line 1006 "eiffel.y"
		local
			yyval86: CONVERT_FEAT_LIST_AS
		do
--|#line 1006 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1006")
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

	yy_do_action_134 is
			--|#line 1008 "eiffel.y"
		local
			yyval86: CONVERT_FEAT_LIST_AS
		do
--|#line 1008 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1008")
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

	yy_do_action_135 is
			--|#line 1017 "eiffel.y"
		local
			yyval86: CONVERT_FEAT_LIST_AS
		do
--|#line 1017 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1017")
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

	yy_do_action_136 is
			--|#line 1024 "eiffel.y"
		local
			yyval86: CONVERT_FEAT_LIST_AS
		do
--|#line 1024 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1024")
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

	yy_do_action_137 is
			--|#line 1024 "eiffel.y"
		local
			yyval86: CONVERT_FEAT_LIST_AS
		do
--|#line 1024 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1024")
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

	yy_do_action_138 is
			--|#line 1035 "eiffel.y"
		local
			yyval40: CONVERT_FEAT_AS
		do
--|#line 1035 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1035")
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

	yy_do_action_139 is
			--|#line 1041 "eiffel.y"
		local
			yyval40: CONVERT_FEAT_AS
		do
--|#line 1041 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1041")
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

	yy_do_action_140 is
			--|#line 1049 "eiffel.y"
		local
			yyval95: EIFFEL_LIST [FEATURE_NAME]
		do
--|#line 1049 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1049")
end

yyval95 := yyvs95.item (yyvsp95) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs95.put (yyval95, yyvsp95)
end
		end

	yy_do_action_141 is
			--|#line 1053 "eiffel.y"
		local
			yyval95: EIFFEL_LIST [FEATURE_NAME]
		do
--|#line 1053 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1053")
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

	yy_do_action_142 is
			--|#line 1060 "eiffel.y"
		local
			yyval95: EIFFEL_LIST [FEATURE_NAME]
		do
--|#line 1060 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1060")
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

	yy_do_action_143 is
			--|#line 1060 "eiffel.y"
		local
			yyval95: EIFFEL_LIST [FEATURE_NAME]
		do
--|#line 1060 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1060")
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

	yy_do_action_144 is
			--|#line 1070 "eiffel.y"
		local
			yyval97: UNDEFINE_CLAUSE_AS
		do
--|#line 1070 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1070")
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

	yy_do_action_145 is
			--|#line 1072 "eiffel.y"
		local
			yyval97: UNDEFINE_CLAUSE_AS
		do
--|#line 1072 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1072")
end

yyval97 := yyvs97.item (yyvsp97) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs97.put (yyval97, yyvsp97)
end
		end

	yy_do_action_146 is
			--|#line 1076 "eiffel.y"
		local
			yyval97: UNDEFINE_CLAUSE_AS
		do
--|#line 1076 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1076")
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

	yy_do_action_147 is
			--|#line 1081 "eiffel.y"
		local
			yyval97: UNDEFINE_CLAUSE_AS
		do
--|#line 1081 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1081")
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

	yy_do_action_148 is
			--|#line 1087 "eiffel.y"
		local
			yyval98: REDEFINE_CLAUSE_AS
		do
--|#line 1087 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1087")
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

	yy_do_action_149 is
			--|#line 1089 "eiffel.y"
		local
			yyval98: REDEFINE_CLAUSE_AS
		do
--|#line 1089 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1089")
end

yyval98 := yyvs98.item (yyvsp98) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs98.put (yyval98, yyvsp98)
end
		end

	yy_do_action_150 is
			--|#line 1093 "eiffel.y"
		local
			yyval98: REDEFINE_CLAUSE_AS
		do
--|#line 1093 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1093")
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

	yy_do_action_151 is
			--|#line 1098 "eiffel.y"
		local
			yyval98: REDEFINE_CLAUSE_AS
		do
--|#line 1098 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1098")
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

	yy_do_action_152 is
			--|#line 1104 "eiffel.y"
		local
			yyval99: SELECT_CLAUSE_AS
		do
--|#line 1104 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1104")
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

	yy_do_action_153 is
			--|#line 1106 "eiffel.y"
		local
			yyval99: SELECT_CLAUSE_AS
		do
--|#line 1106 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1106")
end

yyval99 := yyvs99.item (yyvsp99) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs99.put (yyval99, yyvsp99)
end
		end

	yy_do_action_154 is
			--|#line 1110 "eiffel.y"
		local
			yyval99: SELECT_CLAUSE_AS
		do
--|#line 1110 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1110")
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

	yy_do_action_155 is
			--|#line 1115 "eiffel.y"
		local
			yyval99: SELECT_CLAUSE_AS
		do
--|#line 1115 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1115")
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

	yy_do_action_156 is
			--|#line 1125 "eiffel.y"
		local
			yyval114: FORMAL_ARGU_DEC_LIST_AS
		do
--|#line 1125 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1125")
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

	yy_do_action_157 is
			--|#line 1130 "eiffel.y"
		local
			yyval114: FORMAL_ARGU_DEC_LIST_AS
		do
--|#line 1130 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1130")
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

	yy_do_action_158 is
			--|#line 1132 "eiffel.y"
		local
			yyval114: FORMAL_ARGU_DEC_LIST_AS
		do
--|#line 1132 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1132")
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

	yy_do_action_159 is
			--|#line 1134 "eiffel.y"
		local
			yyval114: FORMAL_ARGU_DEC_LIST_AS
		do
--|#line 1134 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1134")
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

	yy_do_action_160 is
			--|#line 1138 "eiffel.y"
		local
			yyval112: TYPE_DEC_LIST_AS
		do
--|#line 1138 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1138")
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

	yy_do_action_161 is
			--|#line 1145 "eiffel.y"
		local
			yyval112: TYPE_DEC_LIST_AS
		do
--|#line 1145 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1145")
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

	yy_do_action_162 is
			--|#line 1145 "eiffel.y"
		local
			yyval112: TYPE_DEC_LIST_AS
		do
--|#line 1145 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1145")
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

	yy_do_action_163 is
			--|#line 1152 "eiffel.y"
		local
			yyval112: TYPE_DEC_LIST_AS
		do
--|#line 1152 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1152")
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

	yy_do_action_164 is
			--|#line 1156 "eiffel.y"
		local
			yyval81: TYPE_DEC_AS
		do
--|#line 1156 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1156")
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

	yy_do_action_165 is
			--|#line 1159 "eiffel.y"
		local
			yyval81: TYPE_DEC_AS
		do
--|#line 1159 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1159")
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

	yy_do_action_166 is
			--|#line 1161 "eiffel.y"
		local
			yyval81: TYPE_DEC_AS
		do
--|#line 1161 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1161")
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

	yy_do_action_167 is
			--|#line 1163 "eiffel.y"
		local
			yyval81: TYPE_DEC_AS
		do
--|#line 1163 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1163")
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

	yy_do_action_168 is
			--|#line 1167 "eiffel.y"
		local
			yyval20: IDENTIFIER_LIST
		do
--|#line 1167 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1167")
end

yyval20 := yyvs20.item (yyvsp20) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs20.put (yyval20, yyvsp20)
end
		end

	yy_do_action_169 is
			--|#line 1170 "eiffel.y"
		local
			yyval20: IDENTIFIER_LIST
		do
--|#line 1170 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1170")
end

				report_unexpected_error (text, Void, True) 
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp1 := yyvsp1 -3
	yyvs20.put (yyval20, yyvsp20)
end
		end

	yy_do_action_170 is
			--|#line 1176 "eiffel.y"
		local
			yyval20: IDENTIFIER_LIST
		do
--|#line 1176 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1176")
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

	yy_do_action_171 is
			--|#line 1185 "eiffel.y"
		local
			yyval20: IDENTIFIER_LIST
		do
--|#line 1185 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1185")
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

	yy_do_action_172 is
			--|#line 1185 "eiffel.y"
		local
			yyval20: IDENTIFIER_LIST
		do
--|#line 1185 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1185")
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

	yy_do_action_173 is
			--|#line 1195 "eiffel.y"
		local
			yyval20: IDENTIFIER_LIST
		do
--|#line 1195 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1195")
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

	yy_do_action_174 is
			--|#line 1199 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 1199 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1199")
end

				increment_counter
				yyval2 := yyvs2.item (yyvsp2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp1 := yyvsp1 -1
	yyvs2.put (yyval2, yyvsp2)
end
		end

	yy_do_action_175 is
			--|#line 1206 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 1206 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1206")
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

	yy_do_action_176 is
			--|#line 1207 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 1207 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1207")
end

report_expected_after_error (parser_errors.comma_symbol, yyvs4.item (yyvsp4), parser_errors.an_identifier, False) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp4 := yyvsp4 -1
	yyvs1.put (yyval1, yyvsp1)
end
		end

	yy_do_action_177 is
			--|#line 1211 "eiffel.y"
		local
			yyval20: IDENTIFIER_LIST
		do
--|#line 1211 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1211")
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

	yy_do_action_178 is
			--|#line 1213 "eiffel.y"
		local
			yyval20: IDENTIFIER_LIST
		do
--|#line 1213 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1213")
end

yyval20 := yyvs20.item (yyvsp20) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs20.put (yyval20, yyvsp20)
end
		end

	yy_do_action_179 is
			--|#line 1217 "eiffel.y"
		local
			yyval74: ROUTINE_AS
		do
--|#line 1217 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1217")
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

	yy_do_action_180 is
			--|#line 1217 "eiffel.y"
		local
			yyval74: ROUTINE_AS
		do
--|#line 1217 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1217")
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

	yy_do_action_181 is
			--|#line 1243 "eiffel.y"
		local
			yyval73: ROUT_BODY_AS
		do
--|#line 1243 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1243")
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

	yy_do_action_182 is
			--|#line 1245 "eiffel.y"
		local
			yyval73: ROUT_BODY_AS
		do
--|#line 1245 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1245")
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

	yy_do_action_183 is
			--|#line 1247 "eiffel.y"
		local
			yyval73: ROUT_BODY_AS
		do
--|#line 1247 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1247")
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

	yy_do_action_184 is
			--|#line 1251 "eiffel.y"
		local
			yyval49: EXTERNAL_AS
		do
--|#line 1251 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1251")
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

	yy_do_action_185 is
			--|#line 1251 "eiffel.y"
		local
			yyval49: EXTERNAL_AS
		do
--|#line 1251 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1251")
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

	yy_do_action_186 is
			--|#line 1269 "eiffel.y"
		local
			yyval50: EXTERNAL_LANG_AS
		do
--|#line 1269 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1269")
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

	yy_do_action_187 is
			--|#line 1274 "eiffel.y"
		local
			yyval19: PAIR [KEYWORD_AS, STRING_AS]
		do
--|#line 1274 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1274")
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

	yy_do_action_188 is
			--|#line 1276 "eiffel.y"
		local
			yyval19: PAIR [KEYWORD_AS, STRING_AS]
		do
--|#line 1276 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1276")
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

	yy_do_action_189 is
			--|#line 1282 "eiffel.y"
		local
			yyval60: INTERNAL_AS
		do
--|#line 1282 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1282")
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

	yy_do_action_190 is
			--|#line 1284 "eiffel.y"
		local
			yyval60: INTERNAL_AS
		do
--|#line 1284 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1284")
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

	yy_do_action_191 is
			--|#line 1288 "eiffel.y"
		local
			yyval113: LOCAL_DEC_LIST_AS
		do
--|#line 1288 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1288")
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

	yy_do_action_192 is
			--|#line 1290 "eiffel.y"
		local
			yyval113: LOCAL_DEC_LIST_AS
		do
--|#line 1290 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1290")
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

	yy_do_action_193 is
			--|#line 1292 "eiffel.y"
		local
			yyval113: LOCAL_DEC_LIST_AS
		do
--|#line 1292 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1292")
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

	yy_do_action_194 is
			--|#line 1296 "eiffel.y"
		local
			yyval15: EIFFEL_LIST [INSTRUCTION_AS]
		do
--|#line 1296 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1296")
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

	yy_do_action_195 is
			--|#line 1298 "eiffel.y"
		local
			yyval15: EIFFEL_LIST [INSTRUCTION_AS]
		do
--|#line 1298 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1298")
end

yyval15 := yyvs15.item (yyvsp15) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp1 := yyvsp1 -3
	yyvs15.put (yyval15, yyvsp15)
end
		end

	yy_do_action_196 is
			--|#line 1302 "eiffel.y"
		local
			yyval15: EIFFEL_LIST [INSTRUCTION_AS]
		do
--|#line 1302 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1302")
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

	yy_do_action_197 is
			--|#line 1309 "eiffel.y"
		local
			yyval15: EIFFEL_LIST [INSTRUCTION_AS]
		do
--|#line 1309 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1309")
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

	yy_do_action_198 is
			--|#line 1309 "eiffel.y"
		local
			yyval15: EIFFEL_LIST [INSTRUCTION_AS]
		do
--|#line 1309 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1309")
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

	yy_do_action_199 is
			--|#line 1318 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1318 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1318")
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

	yy_do_action_200 is
			--|#line 1327 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 1327 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1327")
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

	yy_do_action_201 is
			--|#line 1328 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 1328 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1328")
end


if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp4 := yyvsp4 -1
	yyvs1.put (yyval1, yyvsp1)
end
		end

	yy_do_action_202 is
			--|#line 1331 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1331 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1331")
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

	yy_do_action_203 is
			--|#line 1333 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1333 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1333")
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

	yy_do_action_204 is
			--|#line 1344 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1344 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1344")
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

	yy_do_action_205 is
			--|#line 1346 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1346 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1346")
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

	yy_do_action_206 is
			--|#line 1348 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1348 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1348")
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

	yy_do_action_207 is
			--|#line 1350 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1350 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1350")
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

	yy_do_action_208 is
			--|#line 1352 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1352 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1352")
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

	yy_do_action_209 is
			--|#line 1354 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1354 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1354")
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

	yy_do_action_210 is
			--|#line 1356 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1356 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1356")
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

	yy_do_action_211 is
			--|#line 1358 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1358 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1358")
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

	yy_do_action_212 is
			--|#line 1360 "eiffel.y"
		local
			yyval14: INSTRUCTION_AS
		do
--|#line 1360 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1360")
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

	yy_do_action_213 is
			--|#line 1364 "eiffel.y"
		local
			yyval71: REQUIRE_AS
		do
--|#line 1364 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1364")
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

	yy_do_action_214 is
			--|#line 1366 "eiffel.y"
		local
			yyval71: REQUIRE_AS
		do
--|#line 1366 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1366")
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

	yy_do_action_215 is
			--|#line 1366 "eiffel.y"
		local
			yyval71: REQUIRE_AS
		do
--|#line 1366 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1366")
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

	yy_do_action_216 is
			--|#line 1373 "eiffel.y"
		local
			yyval71: REQUIRE_AS
		do
--|#line 1373 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1373")
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

	yy_do_action_217 is
			--|#line 1373 "eiffel.y"
		local
			yyval71: REQUIRE_AS
		do
--|#line 1373 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1373")
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

	yy_do_action_218 is
			--|#line 1382 "eiffel.y"
		local
			yyval46: ENSURE_AS
		do
--|#line 1382 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1382")
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

	yy_do_action_219 is
			--|#line 1384 "eiffel.y"
		local
			yyval46: ENSURE_AS
		do
--|#line 1384 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1384")
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

	yy_do_action_220 is
			--|#line 1384 "eiffel.y"
		local
			yyval46: ENSURE_AS
		do
--|#line 1384 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1384")
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

	yy_do_action_221 is
			--|#line 1391 "eiffel.y"
		local
			yyval46: ENSURE_AS
		do
--|#line 1391 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1391")
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

	yy_do_action_222 is
			--|#line 1391 "eiffel.y"
		local
			yyval46: ENSURE_AS
		do
--|#line 1391 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1391")
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

	yy_do_action_223 is
			--|#line 1400 "eiffel.y"
		local
			yyval22: EIFFEL_LIST [TAGGED_AS]
		do
--|#line 1400 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1400")
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

	yy_do_action_224 is
			--|#line 1402 "eiffel.y"
		local
			yyval22: EIFFEL_LIST [TAGGED_AS]
		do
--|#line 1402 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1402")
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

	yy_do_action_225 is
			--|#line 1411 "eiffel.y"
		local
			yyval22: EIFFEL_LIST [TAGGED_AS]
		do
--|#line 1411 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1411")
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

	yy_do_action_226 is
			--|#line 1424 "eiffel.y"
		local
			yyval22: EIFFEL_LIST [TAGGED_AS]
		do
--|#line 1424 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1424")
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

	yy_do_action_227 is
			--|#line 1424 "eiffel.y"
		local
			yyval22: EIFFEL_LIST [TAGGED_AS]
		do
--|#line 1424 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1424")
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

	yy_do_action_228 is
			--|#line 1440 "eiffel.y"
		local
			yyval21: TAGGED_AS
		do
--|#line 1440 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1440")
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

	yy_do_action_229 is
			--|#line 1442 "eiffel.y"
		local
			yyval21: TAGGED_AS
		do
--|#line 1442 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1442")
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

	yy_do_action_230 is
			--|#line 1444 "eiffel.y"
		local
			yyval21: TAGGED_AS
		do
--|#line 1444 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1444")
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

	yy_do_action_231 is
			--|#line 1457 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1457 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1457")
end

yyval79 := yyvs79.item (yyvsp79) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_232 is
			--|#line 1459 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1459 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1459")
end

yyval79 := yyvs79.item (yyvsp79) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_233 is
			--|#line 1463 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1463 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1463")
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

	yy_do_action_234 is
			--|#line 1466 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1466 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1466")
end

yyval79 := yyvs79.item (yyvsp79) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_235 is
			--|#line 1468 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1468 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1468")
end

yyval79 := yyvs79.item (yyvsp79) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_236 is
			--|#line 1472 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1472 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1472")
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

	yy_do_action_237 is
			--|#line 1478 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1478 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1478")
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

	yy_do_action_238 is
			--|#line 1487 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1487 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1487")
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

	yy_do_action_239 is
			--|#line 1489 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1489 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1489")
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

	yy_do_action_240 is
			--|#line 1491 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1491 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1491")
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

	yy_do_action_241 is
			--|#line 1493 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1493 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1493")
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

	yy_do_action_242 is
			--|#line 1497 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1497 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1497")
end

yyval79 := yyvs79.item (yyvsp79) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_243 is
			--|#line 1499 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1499 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1499")
end

yyval79 := yyvs79.item (yyvsp79) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs79.put (yyval79, yyvsp79)
end
		end

	yy_do_action_244 is
			--|#line 1503 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1503 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1503")
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

	yy_do_action_245 is
			--|#line 1507 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1507 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1507")
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

	yy_do_action_246 is
			--|#line 1509 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1509 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1509")
end

				yyval111 := yyvs111.item (yyvsp111)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs111.put (yyval111, yyvsp111)
end
		end

	yy_do_action_247 is
			--|#line 1515 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1515 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1515")
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

	yy_do_action_248 is
			--|#line 1522 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1522 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1522")
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

	yy_do_action_249 is
			--|#line 1531 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1531 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1531")
end

yyval111 := yyvs111.item (yyvsp111) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs111.put (yyval111, yyvsp111)
end
		end

	yy_do_action_250 is
			--|#line 1535 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1535 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1535")
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

	yy_do_action_251 is
			--|#line 1542 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1542 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1542")
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

	yy_do_action_252 is
			--|#line 1542 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1542 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1542")
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

	yy_do_action_253 is
			--|#line 1552 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1552 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1552")
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

	yy_do_action_254 is
			--|#line 1554 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1554 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1554")
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

	yy_do_action_255 is
			--|#line 1565 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1565 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1565")
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

	yy_do_action_256 is
			--|#line 1574 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 1574 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1574")
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

	yy_do_action_257 is
			--|#line 1585 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1585 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1585")
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

	yy_do_action_258 is
			--|#line 1593 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1593 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1593")
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

	yy_do_action_259 is
			--|#line 1604 "eiffel.y"
		local
			yyval111: TYPE_LIST_AS
		do
--|#line 1604 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1604")
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

	yy_do_action_260 is
			--|#line 1614 "eiffel.y"
		local
			yyval112: TYPE_DEC_LIST_AS
		do
--|#line 1614 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1614")
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

	yy_do_action_261 is
			--|#line 1631 "eiffel.y"
		local
			yyval112: TYPE_DEC_LIST_AS
		do
--|#line 1631 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1631")
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

	yy_do_action_262 is
			--|#line 1648 "eiffel.y"
		local
			yyval112: TYPE_DEC_LIST_AS
		do
--|#line 1648 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1648")
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

	yy_do_action_263 is
			--|#line 1672 "eiffel.y"
		local
			yyval100: FORMAL_GENERIC_LIST_AS
		do
--|#line 1672 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1672")
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

	yy_do_action_264 is
			--|#line 1677 "eiffel.y"
		local
			yyval100: FORMAL_GENERIC_LIST_AS
		do
--|#line 1677 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1677")
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

	yy_do_action_265 is
			--|#line 1686 "eiffel.y"
		local
			yyval100: FORMAL_GENERIC_LIST_AS
		do
--|#line 1686 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1686")
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

	yy_do_action_266 is
			--|#line 1696 "eiffel.y"
		local
			yyval100: FORMAL_GENERIC_LIST_AS
		do
--|#line 1696 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1696")
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

	yy_do_action_267 is
			--|#line 1703 "eiffel.y"
		local
			yyval100: FORMAL_GENERIC_LIST_AS
		do
--|#line 1703 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1703")
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

	yy_do_action_268 is
			--|#line 1703 "eiffel.y"
		local
			yyval100: FORMAL_GENERIC_LIST_AS
		do
--|#line 1703 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1703")
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

	yy_do_action_269 is
			--|#line 1713 "eiffel.y"
		local
			yyval54: FORMAL_AS
		do
--|#line 1713 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1713")
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

	yy_do_action_270 is
			--|#line 1727 "eiffel.y"
		local
			yyval54: FORMAL_AS
		do
--|#line 1727 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1727")
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

	yy_do_action_271 is
			--|#line 1742 "eiffel.y"
		local
			yyval54: FORMAL_AS
		do
--|#line 1742 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1742")
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

	yy_do_action_272 is
			--|#line 1758 "eiffel.y"
		local
			yyval55: FORMAL_DEC_AS
		do
--|#line 1758 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1758")
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

	yy_do_action_273 is
			--|#line 1758 "eiffel.y"
		local
			yyval55: FORMAL_DEC_AS
		do
--|#line 1758 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1758")
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

	yy_do_action_274 is
			--|#line 1781 "eiffel.y"
		local
			yyval115: CONSTRAINT_TRIPLE
		do
--|#line 1781 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1781")
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

	yy_do_action_275 is
			--|#line 1783 "eiffel.y"
		local
			yyval115: CONSTRAINT_TRIPLE
		do
--|#line 1783 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1783")
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

	yy_do_action_276 is
			--|#line 1789 "eiffel.y"
		local
			yyval96: CREATION_CONSTRAIN_TRIPLE
		do
--|#line 1789 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1789")
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

	yy_do_action_277 is
			--|#line 1791 "eiffel.y"
		local
			yyval96: CREATION_CONSTRAIN_TRIPLE
		do
--|#line 1791 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1791")
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

	yy_do_action_278 is
			--|#line 1801 "eiffel.y"
		local
			yyval56: IF_AS
		do
--|#line 1801 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1801")
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

	yy_do_action_279 is
			--|#line 1803 "eiffel.y"
		local
			yyval56: IF_AS
		do
--|#line 1803 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1803")
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

	yy_do_action_280 is
			--|#line 1812 "eiffel.y"
		local
			yyval56: IF_AS
		do
--|#line 1812 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1812")
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

	yy_do_action_281 is
			--|#line 1814 "eiffel.y"
		local
			yyval56: IF_AS
		do
--|#line 1814 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1814")
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

	yy_do_action_282 is
			--|#line 1824 "eiffel.y"
		local
			yyval88: EIFFEL_LIST [ELSIF_AS]
		do
--|#line 1824 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1824")
end

yyval88 := yyvs88.item (yyvsp88) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs88.put (yyval88, yyvsp88)
end
		end

	yy_do_action_283 is
			--|#line 1828 "eiffel.y"
		local
			yyval88: EIFFEL_LIST [ELSIF_AS]
		do
--|#line 1828 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1828")
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

	yy_do_action_284 is
			--|#line 1835 "eiffel.y"
		local
			yyval88: EIFFEL_LIST [ELSIF_AS]
		do
--|#line 1835 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1835")
end

				yyval88 := yyvs88.item (yyvsp88)
				if yyval88 /= Void and yyvs45.item (yyvsp45) /= Void then
					yyval88.reverse_extend (yyvs45.item (yyvsp45))
				end
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp88 := yyvsp88 -1
	yyvsp45 := yyvsp45 -1
	yyvs88.put (yyval88, yyvsp88)
end
		end

	yy_do_action_285 is
			--|#line 1835 "eiffel.y"
		local
			yyval88: EIFFEL_LIST [ELSIF_AS]
		do
--|#line 1835 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1835")
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

	yy_do_action_286 is
			--|#line 1844 "eiffel.y"
		local
			yyval45: ELSIF_AS
		do
--|#line 1844 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1844")
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

	yy_do_action_287 is
			--|#line 1848 "eiffel.y"
		local
			yyval16: PAIR [KEYWORD_AS, EIFFEL_LIST [INSTRUCTION_AS]]
		do
--|#line 1848 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1848")
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

	yy_do_action_288 is
			--|#line 1852 "eiffel.y"
		local
			yyval58: INSPECT_AS
		do
--|#line 1852 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1852")
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

	yy_do_action_289 is
			--|#line 1854 "eiffel.y"
		local
			yyval58: INSPECT_AS
		do
--|#line 1854 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1854")
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

	yy_do_action_290 is
			--|#line 1865 "eiffel.y"
		local
			yyval85: EIFFEL_LIST [CASE_AS]
		do
--|#line 1865 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1865")
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

	yy_do_action_291 is
			--|#line 1867 "eiffel.y"
		local
			yyval85: EIFFEL_LIST [CASE_AS]
		do
--|#line 1867 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1867")
end

yyval85 := yyvs85.item (yyvsp85) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs85.put (yyval85, yyvsp85)
end
		end

	yy_do_action_292 is
			--|#line 1871 "eiffel.y"
		local
			yyval85: EIFFEL_LIST [CASE_AS]
		do
--|#line 1871 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1871")
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

	yy_do_action_293 is
			--|#line 1878 "eiffel.y"
		local
			yyval85: EIFFEL_LIST [CASE_AS]
		do
--|#line 1878 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1878")
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

	yy_do_action_294 is
			--|#line 1878 "eiffel.y"
		local
			yyval85: EIFFEL_LIST [CASE_AS]
		do
--|#line 1878 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1878")
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

	yy_do_action_295 is
			--|#line 1887 "eiffel.y"
		local
			yyval36: CASE_AS
		do
--|#line 1887 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1887")
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

	yy_do_action_296 is
			--|#line 1891 "eiffel.y"
		local
			yyval103: EIFFEL_LIST [INTERVAL_AS]
		do
--|#line 1891 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1891")
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

	yy_do_action_297 is
			--|#line 1898 "eiffel.y"
		local
			yyval103: EIFFEL_LIST [INTERVAL_AS]
		do
--|#line 1898 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1898")
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

	yy_do_action_298 is
			--|#line 1898 "eiffel.y"
		local
			yyval103: EIFFEL_LIST [INTERVAL_AS]
		do
--|#line 1898 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1898")
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

	yy_do_action_299 is
			--|#line 1908 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1908 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1908")
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

	yy_do_action_300 is
			--|#line 1910 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1910 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1910")
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

	yy_do_action_301 is
			--|#line 1912 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1912 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1912")
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

	yy_do_action_302 is
			--|#line 1914 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1914 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1914")
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

	yy_do_action_303 is
			--|#line 1916 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1916 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1916")
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

	yy_do_action_304 is
			--|#line 1918 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1918 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1918")
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

	yy_do_action_305 is
			--|#line 1920 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1920 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1920")
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

	yy_do_action_306 is
			--|#line 1922 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1922 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1922")
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

	yy_do_action_307 is
			--|#line 1924 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1924 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1924")
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

	yy_do_action_308 is
			--|#line 1926 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1926 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1926")
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

	yy_do_action_309 is
			--|#line 1928 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1928 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1928")
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

	yy_do_action_310 is
			--|#line 1930 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1930 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1930")
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

	yy_do_action_311 is
			--|#line 1932 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1932 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1932")
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

	yy_do_action_312 is
			--|#line 1934 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1934 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1934")
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

	yy_do_action_313 is
			--|#line 1936 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1936 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1936")
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

	yy_do_action_314 is
			--|#line 1938 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1938 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1938")
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

	yy_do_action_315 is
			--|#line 1940 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1940 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1940")
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

	yy_do_action_316 is
			--|#line 1942 "eiffel.y"
		local
			yyval61: INTERVAL_AS
		do
--|#line 1942 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1942")
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

	yy_do_action_317 is
			--|#line 1947 "eiffel.y"
		local
			yyval63: LOOP_AS
		do
--|#line 1947 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1947")
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

	yy_do_action_318 is
			--|#line 1957 "eiffel.y"
		local
			yyval23: PAIR [KEYWORD_AS, EIFFEL_LIST [TAGGED_AS]]
		do
--|#line 1957 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1957")
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

	yy_do_action_319 is
			--|#line 1959 "eiffel.y"
		local
			yyval23: PAIR [KEYWORD_AS, EIFFEL_LIST [TAGGED_AS]]
		do
--|#line 1959 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1959")
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

	yy_do_action_320 is
			--|#line 1963 "eiffel.y"
		local
			yyval62: INVARIANT_AS
		do
--|#line 1963 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1963")
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

	yy_do_action_321 is
			--|#line 1965 "eiffel.y"
		local
			yyval62: INVARIANT_AS
		do
--|#line 1965 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1965")
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

	yy_do_action_322 is
			--|#line 1965 "eiffel.y"
		local
			yyval62: INVARIANT_AS
		do
--|#line 1965 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1965")
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

	yy_do_action_323 is
			--|#line 1975 "eiffel.y"
		local
			yyval82: VARIANT_AS
		do
--|#line 1975 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1975")
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

	yy_do_action_324 is
			--|#line 1977 "eiffel.y"
		local
			yyval82: VARIANT_AS
		do
--|#line 1977 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1977")
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

	yy_do_action_325 is
			--|#line 1979 "eiffel.y"
		local
			yyval82: VARIANT_AS
		do
--|#line 1979 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1979")
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

	yy_do_action_326 is
			--|#line 1983 "eiffel.y"
		local
			yyval44: DEBUG_AS
		do
--|#line 1983 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1983")
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

	yy_do_action_327 is
			--|#line 1987 "eiffel.y"
		local
			yyval110: DEBUG_KEY_LIST_AS
		do
--|#line 1987 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1987")
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

	yy_do_action_328 is
			--|#line 1989 "eiffel.y"
		local
			yyval110: DEBUG_KEY_LIST_AS
		do
--|#line 1989 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1989")
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

	yy_do_action_329 is
			--|#line 1994 "eiffel.y"
		local
			yyval110: DEBUG_KEY_LIST_AS
		do
--|#line 1994 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1994")
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

	yy_do_action_330 is
			--|#line 1998 "eiffel.y"
		local
			yyval109: EIFFEL_LIST [STRING_AS]
		do
--|#line 1998 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 1998")
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

	yy_do_action_331 is
			--|#line 2005 "eiffel.y"
		local
			yyval109: EIFFEL_LIST [STRING_AS]
		do
--|#line 2005 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2005")
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

	yy_do_action_332 is
			--|#line 2005 "eiffel.y"
		local
			yyval109: EIFFEL_LIST [STRING_AS]
		do
--|#line 2005 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2005")
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

	yy_do_action_333 is
			--|#line 2015 "eiffel.y"
		local
			yyval16: PAIR [KEYWORD_AS, EIFFEL_LIST [INSTRUCTION_AS]]
		do
--|#line 2015 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2015")
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

	yy_do_action_334 is
			--|#line 2017 "eiffel.y"
		local
			yyval16: PAIR [KEYWORD_AS, EIFFEL_LIST [INSTRUCTION_AS]]
		do
--|#line 2017 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2017")
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

	yy_do_action_335 is
			--|#line 2027 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2027 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2027")
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

	yy_do_action_336 is
			--|#line 2030 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2030 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2030")
end

yyval48 := yyvs48.item (yyvsp48) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_337 is
			--|#line 2032 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2032 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2032")
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

	yy_do_action_338 is
			--|#line 2034 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2034 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2034")
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

	yy_do_action_339 is
			--|#line 2038 "eiffel.y"
		local
			yyval30: ASSIGNER_CALL_AS
		do
--|#line 2038 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2038")
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

	yy_do_action_340 is
			--|#line 2042 "eiffel.y"
		local
			yyval29: ASSIGN_AS
		do
--|#line 2042 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2042")
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

	yy_do_action_341 is
			--|#line 2044 "eiffel.y"
		local
			yyval29: ASSIGN_AS
		do
--|#line 2044 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2044")
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

	yy_do_action_342 is
			--|#line 2048 "eiffel.y"
		local
			yyval72: REVERSE_AS
		do
--|#line 2048 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2048")
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

	yy_do_action_343 is
			--|#line 2050 "eiffel.y"
		local
			yyval72: REVERSE_AS
		do
--|#line 2050 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2050")
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

	yy_do_action_344 is
			--|#line 2054 "eiffel.y"
		local
			yyval87: EIFFEL_LIST [CREATE_AS]
		do
--|#line 2054 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2054")
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

	yy_do_action_345 is
			--|#line 2056 "eiffel.y"
		local
			yyval87: EIFFEL_LIST [CREATE_AS]
		do
--|#line 2056 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2056")
end

yyval87 := yyvs87.item (yyvsp87) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp1 := yyvsp1 -2
	yyvs87.put (yyval87, yyvsp87)
end
		end

	yy_do_action_346 is
			--|#line 2060 "eiffel.y"
		local
			yyval87: EIFFEL_LIST [CREATE_AS]
		do
--|#line 2060 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2060")
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

	yy_do_action_347 is
			--|#line 2067 "eiffel.y"
		local
			yyval87: EIFFEL_LIST [CREATE_AS]
		do
--|#line 2067 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2067")
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

	yy_do_action_348 is
			--|#line 2067 "eiffel.y"
		local
			yyval87: EIFFEL_LIST [CREATE_AS]
		do
--|#line 2067 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2067")
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

	yy_do_action_349 is
			--|#line 2076 "eiffel.y"
		local
			yyval41: CREATE_AS
		do
--|#line 2076 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2076")
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

	yy_do_action_350 is
			--|#line 2081 "eiffel.y"
		local
			yyval41: CREATE_AS
		do
--|#line 2081 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2081")
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

	yy_do_action_351 is
			--|#line 2085 "eiffel.y"
		local
			yyval41: CREATE_AS
		do
--|#line 2085 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2085")
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

	yy_do_action_352 is
			--|#line 2089 "eiffel.y"
		local
			yyval41: CREATE_AS
		do
--|#line 2089 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2089")
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

	yy_do_action_353 is
			--|#line 2094 "eiffel.y"
		local
			yyval41: CREATE_AS
		do
--|#line 2094 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2094")
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

	yy_do_action_354 is
			--|#line 2099 "eiffel.y"
		local
			yyval41: CREATE_AS
		do
--|#line 2099 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2099")
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

	yy_do_action_355 is
			--|#line 2106 "eiffel.y"
		local
			yyval75: ROUTINE_CREATION_AS
		do
--|#line 2106 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2106")
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

	yy_do_action_356 is
			--|#line 2111 "eiffel.y"
		local
			yyval75: ROUTINE_CREATION_AS
		do
--|#line 2111 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2111")
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

	yy_do_action_357 is
			--|#line 2123 "eiffel.y"
		local
			yyval75: ROUTINE_CREATION_AS
		do
--|#line 2123 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2123")
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

	yy_do_action_358 is
			--|#line 2139 "eiffel.y"
		local
			yyval77: PAIR [ROUTINE_CREATION_AS, LOCATION_AS]
		do
--|#line 2139 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2139")
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

	yy_do_action_359 is
			--|#line 2143 "eiffel.y"
		local
			yyval77: PAIR [ROUTINE_CREATION_AS, LOCATION_AS]
		do
--|#line 2143 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2143")
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

	yy_do_action_360 is
			--|#line 2147 "eiffel.y"
		local
			yyval77: PAIR [ROUTINE_CREATION_AS, LOCATION_AS]
		do
--|#line 2147 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2147")
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

	yy_do_action_361 is
			--|#line 2155 "eiffel.y"
		local
			yyval77: PAIR [ROUTINE_CREATION_AS, LOCATION_AS]
		do
--|#line 2155 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2155")
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

	yy_do_action_362 is
			--|#line 2159 "eiffel.y"
		local
			yyval77: PAIR [ROUTINE_CREATION_AS, LOCATION_AS]
		do
--|#line 2159 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2159")
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

	yy_do_action_363 is
			--|#line 2163 "eiffel.y"
		local
			yyval77: PAIR [ROUTINE_CREATION_AS, LOCATION_AS]
		do
--|#line 2163 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2163")
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

	yy_do_action_364 is
			--|#line 2170 "eiffel.y"
		local
			yyval77: PAIR [ROUTINE_CREATION_AS, LOCATION_AS]
		do
--|#line 2170 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2170")
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

	yy_do_action_365 is
			--|#line 2180 "eiffel.y"
		local
			yyval24: AGENT_TARGET_TRIPLE
		do
--|#line 2180 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2180")
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

	yy_do_action_366 is
			--|#line 2182 "eiffel.y"
		local
			yyval24: AGENT_TARGET_TRIPLE
		do
--|#line 2182 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2182")
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

	yy_do_action_367 is
			--|#line 2184 "eiffel.y"
		local
			yyval24: AGENT_TARGET_TRIPLE
		do
--|#line 2184 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2184")
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

	yy_do_action_368 is
			--|#line 2186 "eiffel.y"
		local
			yyval24: AGENT_TARGET_TRIPLE
		do
--|#line 2186 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2186")
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

	yy_do_action_369 is
			--|#line 2188 "eiffel.y"
		local
			yyval24: AGENT_TARGET_TRIPLE
		do
--|#line 2188 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2188")
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

	yy_do_action_370 is
			--|#line 2190 "eiffel.y"
		local
			yyval24: AGENT_TARGET_TRIPLE
		do
--|#line 2190 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2190")
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

	yy_do_action_371 is
			--|#line 2200 "eiffel.y"
		local
			yyval105: DELAYED_ACTUAL_LIST_AS
		do
--|#line 2200 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2200")
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

	yy_do_action_372 is
			--|#line 2202 "eiffel.y"
		local
			yyval105: DELAYED_ACTUAL_LIST_AS
		do
--|#line 2202 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2202")
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

	yy_do_action_373 is
			--|#line 2207 "eiffel.y"
		local
			yyval105: DELAYED_ACTUAL_LIST_AS
		do
--|#line 2207 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2207")
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

	yy_do_action_374 is
			--|#line 2211 "eiffel.y"
		local
			yyval104: EIFFEL_LIST [OPERAND_AS]
		do
--|#line 2211 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2211")
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

	yy_do_action_375 is
			--|#line 2218 "eiffel.y"
		local
			yyval104: EIFFEL_LIST [OPERAND_AS]
		do
--|#line 2218 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2218")
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

	yy_do_action_376 is
			--|#line 2218 "eiffel.y"
		local
			yyval104: EIFFEL_LIST [OPERAND_AS]
		do
--|#line 2218 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2218")
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

	yy_do_action_377 is
			--|#line 2228 "eiffel.y"
		local
			yyval65: OPERAND_AS
		do
--|#line 2228 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2228")
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

	yy_do_action_378 is
			--|#line 2238 "eiffel.y"
		local
			yyval65: OPERAND_AS
		do
--|#line 2238 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2238")
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

	yy_do_action_379 is
			--|#line 2244 "eiffel.y"
		local
			yyval65: OPERAND_AS
		do
--|#line 2244 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2244")
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

	yy_do_action_380 is
			--|#line 2248 "eiffel.y"
		local
			yyval42: CREATION_AS
		do
--|#line 2248 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2248")
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

	yy_do_action_381 is
			--|#line 2253 "eiffel.y"
		local
			yyval42: CREATION_AS
		do
--|#line 2253 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2253")
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

	yy_do_action_382 is
			--|#line 2258 "eiffel.y"
		local
			yyval42: CREATION_AS
		do
--|#line 2258 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2258")
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

	yy_do_action_383 is
			--|#line 2260 "eiffel.y"
		local
			yyval42: CREATION_AS
		do
--|#line 2260 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2260")
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

	yy_do_action_384 is
			--|#line 2264 "eiffel.y"
		local
			yyval43: CREATION_EXPR_AS
		do
--|#line 2264 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2264")
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

	yy_do_action_385 is
			--|#line 2266 "eiffel.y"
		local
			yyval43: CREATION_EXPR_AS
		do
--|#line 2266 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2266")
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

	yy_do_action_386 is
			--|#line 2273 "eiffel.y"
		local
			yyval25: ACCESS_AS
		do
--|#line 2273 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2273")
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

	yy_do_action_387 is
			--|#line 2275 "eiffel.y"
		local
			yyval25: ACCESS_AS
		do
--|#line 2275 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2275")
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

	yy_do_action_388 is
			--|#line 2279 "eiffel.y"
		local
			yyval27: ACCESS_INV_AS
		do
--|#line 2279 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2279")
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

	yy_do_action_389 is
			--|#line 2281 "eiffel.y"
		local
			yyval27: ACCESS_INV_AS
		do
--|#line 2281 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2281")
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

	yy_do_action_390 is
			--|#line 2289 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2289 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2289")
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

	yy_do_action_391 is
			--|#line 2291 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2291 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2291")
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

	yy_do_action_392 is
			--|#line 2293 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2293 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2293")
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

	yy_do_action_393 is
			--|#line 2295 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2295 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2295")
end

yyval35 := yyvs35.item (yyvsp35) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs35.put (yyval35, yyvsp35)
end
		end

	yy_do_action_394 is
			--|#line 2299 "eiffel.y"
		local
			yyval37: CHECK_AS
		do
--|#line 2299 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2299")
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

	yy_do_action_395 is
			--|#line 2306 "eiffel.y"
		local
			yyval79: TYPE_AS
		do
--|#line 2306 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2306")
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

	yy_do_action_396 is
			--|#line 2315 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2315 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2315")
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

	yy_do_action_397 is
			--|#line 2318 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2318 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2318")
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

	yy_do_action_398 is
			--|#line 2320 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2320 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2320")
end

yyval48 := yyvs48.item (yyvsp48) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_399 is
			--|#line 2322 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2322 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2322")
end

yyval48 := yyvs48.item (yyvsp48); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_400 is
			--|#line 2324 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2324 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2324")
end

yyval48 := ast_factory.new_bin_eq_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp48 := yyvsp48 -1
	yyvsp4 := yyvsp4 -1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_401 is
			--|#line 2326 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2326 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2326")
end

yyval48 := ast_factory.new_bin_ne_as (yyvs48.item (yyvsp48 - 1), yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp48 := yyvsp48 -1
	yyvsp4 := yyvsp4 -1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_402 is
			--|#line 2328 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2328 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2328")
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

	yy_do_action_403 is
			--|#line 2332 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2332 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2332")
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

	yy_do_action_404 is
			--|#line 2335 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2335 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2335")
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

	yy_do_action_405 is
			--|#line 2337 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2337 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2337")
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

	yy_do_action_406 is
			--|#line 2339 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2339 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2339")
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

	yy_do_action_407 is
			--|#line 2341 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2341 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2341")
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

	yy_do_action_408 is
			--|#line 2343 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2343 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2343")
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

	yy_do_action_409 is
			--|#line 2345 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2345 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2345")
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

	yy_do_action_410 is
			--|#line 2347 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2347 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2347")
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

	yy_do_action_411 is
			--|#line 2349 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2349 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2349")
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

	yy_do_action_412 is
			--|#line 2351 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2351 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2351")
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

	yy_do_action_413 is
			--|#line 2353 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2353 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2353")
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

	yy_do_action_414 is
			--|#line 2355 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2355 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2355")
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

	yy_do_action_415 is
			--|#line 2357 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2357 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2357")
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

	yy_do_action_416 is
			--|#line 2359 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2359 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2359")
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

	yy_do_action_417 is
			--|#line 2361 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2361 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2361")
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

	yy_do_action_418 is
			--|#line 2363 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2363 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2363")
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

	yy_do_action_419 is
			--|#line 2365 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2365 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2365")
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

	yy_do_action_420 is
			--|#line 2367 "eiffel.y"
		local
			yyval32: BINARY_AS
		do
--|#line 2367 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2367")
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

	yy_do_action_421 is
			--|#line 2371 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2371 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2371")
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

	yy_do_action_422 is
			--|#line 2373 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2373 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2373")
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

	yy_do_action_423 is
			--|#line 2375 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2375 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2375")
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

	yy_do_action_424 is
			--|#line 2377 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2377 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2377")
end

yyval48 := ast_factory.new_un_old_as (yyvs48.item (yyvsp48), yyvs12.item (yyvsp12)); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp12 := yyvsp12 -1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_425 is
			--|#line 2379 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2379 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2379")
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

	yy_do_action_426 is
			--|#line 2383 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2383 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2383")
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

	yy_do_action_427 is
			--|#line 2385 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2385 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2385")
end

				yyval48 := ast_factory.new_expr_address_as (yyvs48.item (yyvsp48), yyvs4.item (yyvsp4 - 2), yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4)); has_type := True
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 4
	yyvsp4 := yyvsp4 -3
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_428 is
			--|#line 2389 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2389 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2389")
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

	yy_do_action_429 is
			--|#line 2393 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2393 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2393")
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

	yy_do_action_430 is
			--|#line 2397 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2397 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2397")
end

yyval48 := yyvs48.item (yyvsp48) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_431 is
			--|#line 2399 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2399 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2399")
end

yyval48 := yyvs48.item (yyvsp48); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_432 is
			--|#line 2403 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2403 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2403")
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

	yy_do_action_433 is
			--|#line 2406 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2406 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2406")
end

yyval48 := ast_factory.new_un_minus_as (yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp4 := yyvsp4 -1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_434 is
			--|#line 2408 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2408 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2408")
end

yyval48 := ast_factory.new_un_plus_as (yyvs48.item (yyvsp48), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp4 := yyvsp4 -1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_435 is
			--|#line 2410 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2410 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2410")
end

yyval48 := ast_factory.new_un_not_as (yyvs48.item (yyvsp48), yyvs12.item (yyvsp12)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp12 := yyvsp12 -1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_436 is
			--|#line 2412 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2412 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2412")
end

yyval48 := ast_factory.new_un_free_as (yyvs2.item (yyvsp2), yyvs48.item (yyvsp48)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 2
	yyvsp2 := yyvsp2 -1
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_437 is
			--|#line 2416 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2416 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2416")
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

	yy_do_action_438 is
			--|#line 2419 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2419 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2419")
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

	yy_do_action_439 is
			--|#line 2421 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2421 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2421")
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

	yy_do_action_440 is
			--|#line 2425 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2425 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2425")
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

	yy_do_action_441 is
			--|#line 2437 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2437 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2437")
end

yyval35 := ast_factory.new_nested_as (yyvs9.item (yyvsp9), yyvs35.item (yyvsp35), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp9 := yyvsp9 -1
	yyvsp4 := yyvsp4 -1
	yyvs35.put (yyval35, yyvsp35)
end
		end

	yy_do_action_442 is
			--|#line 2440 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2440 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2440")
end

yyval35 := ast_factory.new_nested_as (yyvs6.item (yyvsp6), yyvs35.item (yyvsp35), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp6 := yyvsp6 -1
	yyvsp4 := yyvsp4 -1
	yyvs35.put (yyval35, yyvsp35)
end
		end

	yy_do_action_443 is
			--|#line 2442 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2442 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2442")
end

yyval35 := ast_factory.new_nested_as (yyvs25.item (yyvsp25), yyvs35.item (yyvsp35), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp25 := yyvsp25 -1
	yyvsp4 := yyvsp4 -1
	yyvs35.put (yyval35, yyvsp35)
end
		end

	yy_do_action_444 is
			--|#line 2444 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2444 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2444")
end

yyval35 := ast_factory.new_nested_expr_as (yyvs48.item (yyvsp48), yyvs35.item (yyvsp35), yyvs4.item (yyvsp4), yyvs4.item (yyvsp4 - 2), yyvs4.item (yyvsp4 - 1)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 5
	yyvsp4 := yyvsp4 -3
	yyvsp48 := yyvsp48 -1
	yyvs35.put (yyval35, yyvsp35)
end
		end

	yy_do_action_445 is
			--|#line 2446 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2446 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2446")
end

yyval35 := ast_factory.new_nested_as (yyvs67.item (yyvsp67), yyvs35.item (yyvsp35), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp67 := yyvsp67 -1
	yyvsp4 := yyvsp4 -1
	yyvs35.put (yyval35, yyvsp35)
end
		end

	yy_do_action_446 is
			--|#line 2448 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2448 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2448")
end

yyval35 := ast_factory.new_nested_as (yyvs68.item (yyvsp68), yyvs35.item (yyvsp35), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp68 := yyvsp68 -1
	yyvsp4 := yyvsp4 -1
	yyvs35.put (yyval35, yyvsp35)
end
		end

	yy_do_action_447 is
			--|#line 2452 "eiffel.y"
		local
			yyval67: PRECURSOR_AS
		do
--|#line 2452 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2452")
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

	yy_do_action_448 is
			--|#line 2454 "eiffel.y"
		local
			yyval67: PRECURSOR_AS
		do
--|#line 2454 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2454")
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

	yy_do_action_449 is
			--|#line 2465 "eiffel.y"
		local
			yyval68: STATIC_ACCESS_AS
		do
--|#line 2465 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2465")
end

yyval68 := yyvs68.item (yyvsp68) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs68.put (yyval68, yyvsp68)
end
		end

	yy_do_action_450 is
			--|#line 2467 "eiffel.y"
		local
			yyval68: STATIC_ACCESS_AS
		do
--|#line 2467 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2467")
end

yyval68 := yyvs68.item (yyvsp68) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs68.put (yyval68, yyvsp68)
end
		end

	yy_do_action_451 is
			--|#line 2471 "eiffel.y"
		local
			yyval68: STATIC_ACCESS_AS
		do
--|#line 2471 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2471")
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

	yy_do_action_452 is
			--|#line 2476 "eiffel.y"
		local
			yyval68: STATIC_ACCESS_AS
		do
--|#line 2476 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2476")
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

	yy_do_action_453 is
			--|#line 2484 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2484 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2484")
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

	yy_do_action_454 is
			--|#line 2486 "eiffel.y"
		local
			yyval35: CALL_AS
		do
--|#line 2486 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2486")
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

	yy_do_action_455 is
			--|#line 2490 "eiffel.y"
		local
			yyval64: NESTED_AS
		do
--|#line 2490 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2490")
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

	yy_do_action_456 is
			--|#line 2492 "eiffel.y"
		local
			yyval64: NESTED_AS
		do
--|#line 2492 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2492")
end

yyval64 := ast_factory.new_nested_as (yyvs26.item (yyvsp26), yyvs64.item (yyvsp64), yyvs4.item (yyvsp4)) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp26 := yyvsp26 -1
	yyvsp4 := yyvsp4 -1
	yyvs64.put (yyval64, yyvsp64)
end
		end

	yy_do_action_457 is
			--|#line 2496 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2496 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2496")
end

yyval2 := yyvs2.item (yyvsp2)
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
		end

	yy_do_action_458 is
			--|#line 2498 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2498 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2498")
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

	yy_do_action_459 is
			--|#line 2504 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2504 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2504")
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

	yy_do_action_460 is
			--|#line 2512 "eiffel.y"
		local
			yyval25: ACCESS_AS
		do
--|#line 2512 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2512")
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

	yy_do_action_461 is
			--|#line 2525 "eiffel.y"
		local
			yyval26: ACCESS_FEAT_AS
		do
--|#line 2525 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2525")
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

	yy_do_action_462 is
			--|#line 2529 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2529 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2529")
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

	yy_do_action_463 is
			--|#line 2532 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2532 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2532")
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

	yy_do_action_464 is
			--|#line 2534 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2534 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2534")
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

	yy_do_action_465 is
			--|#line 2536 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2536 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2536")
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

	yy_do_action_466 is
			--|#line 2538 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2538 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2538")
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

	yy_do_action_467 is
			--|#line 2540 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2540 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2540")
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

	yy_do_action_468 is
			--|#line 2542 "eiffel.y"
		local
			yyval48: EXPR_AS
		do
--|#line 2542 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2542")
end

yyval48 := ast_factory.new_paran_as (yyvs48.item (yyvsp48), yyvs4.item (yyvsp4 - 1), yyvs4.item (yyvsp4)); has_type := True 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 3
	yyvsp4 := yyvsp4 -2
	yyvs48.put (yyval48, yyvsp48)
end
		end

	yy_do_action_469 is
			--|#line 2546 "eiffel.y"
		local
			yyval92: PARAMETER_LIST_AS
		do
--|#line 2546 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2546")
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

	yy_do_action_470 is
			--|#line 2548 "eiffel.y"
		local
			yyval92: PARAMETER_LIST_AS
		do
--|#line 2548 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2548")
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

	yy_do_action_471 is
			--|#line 2553 "eiffel.y"
		local
			yyval92: PARAMETER_LIST_AS
		do
--|#line 2553 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2553")
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

	yy_do_action_472 is
			--|#line 2557 "eiffel.y"
		local
			yyval91: EIFFEL_LIST [EXPR_AS]
		do
--|#line 2557 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2557")
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

	yy_do_action_473 is
			--|#line 2564 "eiffel.y"
		local
			yyval91: EIFFEL_LIST [EXPR_AS]
		do
--|#line 2564 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2564")
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

	yy_do_action_474 is
			--|#line 2564 "eiffel.y"
		local
			yyval91: EIFFEL_LIST [EXPR_AS]
		do
--|#line 2564 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2564")
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

	yy_do_action_475 is
			--|#line 2574 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2574 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2574")
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

	yy_do_action_476 is
			--|#line 2581 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2581 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2581")
end

				yyval2 := yyvs2.item (yyvsp2);
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
		end

	yy_do_action_477 is
			--|#line 2587 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2587 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2587")
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

	yy_do_action_478 is
			--|#line 2594 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2594 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2594")
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

	yy_do_action_479 is
			--|#line 2605 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2605 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2605")
end

report_expected_error (parser_errors.valid_eiffel_class_name, True, Void, False) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
		end

	yy_do_action_480 is
			--|#line 2609 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2609 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2609")
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

	yy_do_action_481 is
			--|#line 2616 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2616 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2616")
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

	yy_do_action_482 is
			--|#line 2623 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2623 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2623")
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

	yy_do_action_483 is
			--|#line 2633 "eiffel.y"
		local
			yyval2: ID_AS
		do
--|#line 2633 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2633")
end

report_expected_error (parser_errors.a_valid_feature_name, True, Void, False) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs2.put (yyval2, yyvsp2)
end
		end

	yy_do_action_484 is
			--|#line 2637 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2637 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2637")
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

	yy_do_action_485 is
			--|#line 2639 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2639 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2639")
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

	yy_do_action_486 is
			--|#line 2641 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2641 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2641")
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

	yy_do_action_487 is
			--|#line 2643 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2643 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2643")
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

	yy_do_action_488 is
			--|#line 2645 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2645 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2645")
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

	yy_do_action_489 is
			--|#line 2647 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2647 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2647")
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

	yy_do_action_490 is
			--|#line 2652 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2652 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2652")
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

	yy_do_action_491 is
			--|#line 2655 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2655 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2655")
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

	yy_do_action_492 is
			--|#line 2657 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2657 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2657")
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

	yy_do_action_493 is
			--|#line 2659 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2659 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2659")
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

	yy_do_action_494 is
			--|#line 2661 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2661 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2661")
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

	yy_do_action_495 is
			--|#line 2663 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2663 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2663")
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

	yy_do_action_496 is
			--|#line 2665 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2665 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2665")
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

	yy_do_action_497 is
			--|#line 2667 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2667 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2667")
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

	yy_do_action_498 is
			--|#line 2669 "eiffel.y"
		local
			yyval31: ATOMIC_AS
		do
--|#line 2669 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2669")
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

	yy_do_action_499 is
			--|#line 2680 "eiffel.y"
		local
			yyval5: BOOL_AS
		do
--|#line 2680 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2680")
end

yyval5 := yyvs5.item (yyvsp5) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs5.put (yyval5, yyvsp5)
end
		end

	yy_do_action_500 is
			--|#line 2682 "eiffel.y"
		local
			yyval5: BOOL_AS
		do
--|#line 2682 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2682")
end

yyval5 := yyvs5.item (yyvsp5) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs5.put (yyval5, yyvsp5)
end
		end

	yy_do_action_501 is
			--|#line 2686 "eiffel.y"
		local
			yyval3: CHAR_AS
		do
--|#line 2686 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2686")
end

				check is_character: not token_buffer.is_empty end
				yyval3 := ast_factory.new_character_as (token_buffer.item (1), line, column, position, token_buffer2)
			
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs3.put (yyval3, yyvsp3)
end
		end

	yy_do_action_502 is
			--|#line 2691 "eiffel.y"
		local
			yyval3: CHAR_AS
		do
--|#line 2691 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2691")
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

	yy_do_action_503 is
			--|#line 2702 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2702 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2702")
end

yyval59 := yyvs59.item (yyvsp59) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs59.put (yyval59, yyvsp59)
end
		end

	yy_do_action_504 is
			--|#line 2705 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2705 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2705")
end

yyval59 := yyvs59.item (yyvsp59) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs59.put (yyval59, yyvsp59)
end
		end

	yy_do_action_505 is
			--|#line 2707 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2707 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2707")
end

yyval59 := yyvs59.item (yyvsp59) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs59.put (yyval59, yyvsp59)
end
		end

	yy_do_action_506 is
			--|#line 2711 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2711 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2711")
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

	yy_do_action_507 is
			--|#line 2715 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2715 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2715")
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

	yy_do_action_508 is
			--|#line 2721 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2721 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2721")
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

	yy_do_action_509 is
			--|#line 2727 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2727 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2727")
end

yyval59 := yyvs59.item (yyvsp59) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs59.put (yyval59, yyvsp59)
end
		end

	yy_do_action_510 is
			--|#line 2729 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2729 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2729")
end

yyval59 := yyvs59.item (yyvsp59) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs59.put (yyval59, yyvsp59)
end
		end

	yy_do_action_511 is
			--|#line 2733 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2733 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2733")
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

	yy_do_action_512 is
			--|#line 2739 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2739 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2739")
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

	yy_do_action_513 is
			--|#line 2743 "eiffel.y"
		local
			yyval59: INTEGER_AS
		do
--|#line 2743 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2743")
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

	yy_do_action_514 is
			--|#line 2752 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2752 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2752")
end

yyval69 := yyvs69.item (yyvsp69) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs69.put (yyval69, yyvsp69)
end
		end

	yy_do_action_515 is
			--|#line 2754 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2754 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2754")
end

yyval69 := yyvs69.item (yyvsp69) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs69.put (yyval69, yyvsp69)
end
		end

	yy_do_action_516 is
			--|#line 2756 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2756 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2756")
end

yyval69 := yyvs69.item (yyvsp69) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs69.put (yyval69, yyvsp69)
end
		end

	yy_do_action_517 is
			--|#line 2760 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2760 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2760")
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

	yy_do_action_518 is
			--|#line 2766 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2766 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2766")
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

	yy_do_action_519 is
			--|#line 2770 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2770 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2770")
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

	yy_do_action_520 is
			--|#line 2776 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2776 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2776")
end

yyval69 := yyvs69.item (yyvsp69) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs69.put (yyval69, yyvsp69)
end
		end

	yy_do_action_521 is
			--|#line 2778 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2778 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2778")
end

yyval69 := yyvs69.item (yyvsp69) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs69.put (yyval69, yyvsp69)
end
		end

	yy_do_action_522 is
			--|#line 2782 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2782 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2782")
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

	yy_do_action_523 is
			--|#line 2788 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2788 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2788")
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

	yy_do_action_524 is
			--|#line 2792 "eiffel.y"
		local
			yyval69: REAL_AS
		do
--|#line 2792 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2792")
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

	yy_do_action_525 is
			--|#line 2801 "eiffel.y"
		local
			yyval33: BIT_CONST_AS
		do
--|#line 2801 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2801")
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

	yy_do_action_526 is
			--|#line 2808 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2808 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2808")
end

yyval18 := yyvs18.item (yyvsp18) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs18.put (yyval18, yyvsp18)
end
		end

	yy_do_action_527 is
			--|#line 2810 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2810 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2810")
end

yyval18 := yyvs18.item (yyvsp18) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs18.put (yyval18, yyvsp18)
end
		end

	yy_do_action_528 is
			--|#line 2814 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2814 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2814")
end

yyval18 := yyvs18.item (yyvsp18) 
if yy_parsing_status = yyContinue then
	yyssp := yyssp - 1
	yyvs18.put (yyval18, yyvsp18)
end
		end

	yy_do_action_529 is
			--|#line 2816 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2816 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2816")
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

	yy_do_action_530 is
			--|#line 2820 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2820 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2820")
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

	yy_do_action_531 is
			--|#line 2826 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2826 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2826")
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

	yy_do_action_532 is
			--|#line 2840 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2840 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2840")
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

	yy_do_action_533 is
			--|#line 2844 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2844 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2844")
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

	yy_do_action_534 is
			--|#line 2848 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2848 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2848")
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

	yy_do_action_535 is
			--|#line 2852 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2852 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2852")
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

	yy_do_action_536 is
			--|#line 2856 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2856 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2856")
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

	yy_do_action_537 is
			--|#line 2860 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2860 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2860")
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

	yy_do_action_538 is
			--|#line 2864 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2864 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2864")
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

	yy_do_action_539 is
			--|#line 2868 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2868 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2868")
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

	yy_do_action_540 is
			--|#line 2872 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2872 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2872")
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

	yy_do_action_541 is
			--|#line 2876 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2876 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2876")
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

	yy_do_action_542 is
			--|#line 2880 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2880 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2880")
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

	yy_do_action_543 is
			--|#line 2884 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2884 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2884")
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

	yy_do_action_544 is
			--|#line 2888 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2888 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2888")
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

	yy_do_action_545 is
			--|#line 2892 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2892 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2892")
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

	yy_do_action_546 is
			--|#line 2896 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2896 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2896")
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

	yy_do_action_547 is
			--|#line 2900 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2900 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2900")
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

	yy_do_action_548 is
			--|#line 2904 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2904 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2904")
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

	yy_do_action_549 is
			--|#line 2908 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2908 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2908")
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

	yy_do_action_550 is
			--|#line 2912 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2912 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2912")
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

	yy_do_action_551 is
			--|#line 2916 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2916 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2916")
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

	yy_do_action_552 is
			--|#line 2920 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2920 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2920")
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

	yy_do_action_553 is
			--|#line 2924 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2924 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2924")
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

	yy_do_action_554 is
			--|#line 2930 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2930 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2930")
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

	yy_do_action_555 is
			--|#line 2934 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2934 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2934")
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

	yy_do_action_556 is
			--|#line 2938 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2938 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2938")
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

	yy_do_action_557 is
			--|#line 2942 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2942 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2942")
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

	yy_do_action_558 is
			--|#line 2948 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2948 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2948")
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

	yy_do_action_559 is
			--|#line 2952 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2952 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2952")
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

	yy_do_action_560 is
			--|#line 2956 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2956 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2956")
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

	yy_do_action_561 is
			--|#line 2960 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2960 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2960")
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

	yy_do_action_562 is
			--|#line 2964 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2964 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2964")
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

	yy_do_action_563 is
			--|#line 2968 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2968 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2968")
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

	yy_do_action_564 is
			--|#line 2972 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2972 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2972")
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

	yy_do_action_565 is
			--|#line 2976 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2976 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2976")
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

	yy_do_action_566 is
			--|#line 2980 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2980 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2980")
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

	yy_do_action_567 is
			--|#line 2984 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2984 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2984")
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

	yy_do_action_568 is
			--|#line 2988 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2988 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2988")
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

	yy_do_action_569 is
			--|#line 2992 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2992 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2992")
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

	yy_do_action_570 is
			--|#line 2996 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 2996 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 2996")
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

	yy_do_action_571 is
			--|#line 3000 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3000 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3000")
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

	yy_do_action_572 is
			--|#line 3004 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3004 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3004")
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

	yy_do_action_573 is
			--|#line 3008 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3008 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3008")
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

	yy_do_action_574 is
			--|#line 3012 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3012 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3012")
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

	yy_do_action_575 is
			--|#line 3016 "eiffel.y"
		local
			yyval18: STRING_AS
		do
--|#line 3016 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3016")
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

	yy_do_action_576 is
			--|#line 3022 "eiffel.y"
		local
			yyval28: ARRAY_AS
		do
--|#line 3022 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3022")
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

	yy_do_action_577 is
			--|#line 3026 "eiffel.y"
		local
			yyval28: ARRAY_AS
		do
--|#line 3026 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3026")
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

	yy_do_action_578 is
			--|#line 3030 "eiffel.y"
		local
			yyval78: TUPLE_AS
		do
--|#line 3030 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3030")
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

	yy_do_action_579 is
			--|#line 3032 "eiffel.y"
		local
			yyval78: TUPLE_AS
		do
--|#line 3032 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3032")
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

	yy_do_action_580 is
			--|#line 3036 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 3036 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3036")
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

	yy_do_action_581 is
			--|#line 3039 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 3039 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3039")
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

	yy_do_action_582 is
			--|#line 3042 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 3042 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3042")
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

	yy_do_action_583 is
			--|#line 3045 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 3045 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3045")
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

	yy_do_action_584 is
			--|#line 3048 "eiffel.y"
		local
			yyval1: ANY
		do
--|#line 3048 "eiffel.y"
debug ("GEYACC")
	std.error.put_line ("Executing parser user-code from file 'eiffel.y' at line 3048")
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
			when 953 then
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
			  136,  136,  160,  160,  160,  160,  160,  160,  140,  140,

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
			  199,  199,  268,  269,  269,  361,  177,  138,  202,  202,
			  262,  262,  263,  263,  362,  165,  298,  298,  363,  212,

			  212,  212,  212,  212,  212,  212,  212,  212,  212,  212,
			  212,  212,  212,  212,  212,  212,  212,  214,  146,  146,
			  213,  213,  364,  254,  254,  254,  176,  306,  306,  306,
			  305,  305,  365,  139,  139,  183,  183,  183,  183,  154,
			  153,  153,  231,  231,  266,  266,  267,  267,  366,  173,
			  173,  173,  173,  173,  173,  234,  234,  234,  235,  235,
			  235,  235,  235,  235,  235,  147,  147,  147,  147,  147,
			  147,  300,  300,  300,  299,  299,  367,  216,  216,  216,
			  174,  174,  174,  174,  175,  175,  149,  149,  151,  151,
			  162,  162,  162,  162,  167,  247,  181,  181,  181,  181,

			  181,  181,  181,  158,  158,  158,  158,  158,  158,  158,
			  158,  158,  158,  158,  158,  158,  158,  158,  158,  158,
			  158,  182,  182,  182,  182,  182,  182,  182,  182,  182,
			  182,  182,  184,  184,  184,  184,  184,  185,  185,  185,
			  197,  164,  164,  164,  164,  164,  164,  219,  219,  220,
			  220,  222,  221,  163,  163,  215,  215,  198,  198,  198,
			  148,  150,  180,  180,  180,  180,  180,  180,  180,  274,
			  274,  274,  273,  273,  368,  193,  193,  194,  194,  194,
			  195,  195,  195,  195,  156,  156,  156,  156,  156,  156,
			  157,  157,  157,  157,  157,  157,  157,  157,  157,  161,

			  161,  166,  166,  205,  205,  205,  206,  206,  207,  208,
			  208,  209,  210,  210,  223,  223,  223,  225,  224,  224,
			  226,  226,  227,  228,  228,  159,  236,  236,  238,  238,
			  238,  239,  237,  237,  237,  237,  237,  237,  237,  237,
			  237,  237,  237,  237,  237,  237,  237,  237,  237,  237,
			  237,  237,  237,  237,  241,  241,  241,  241,  240,  240,
			  240,  240,  240,  240,  240,  240,  240,  240,  240,  240,
			  240,  240,  240,  240,  240,  240,  152,  152,  244,  244,
			  321,  356,  357,  358,  322, yyDummy>>)
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
			   12,   12,  102,   79,    4,    1,    1,    1,   12,    4,
			   92,   92,  105,    4,   48,   65,   79,  104,   92,    1,
			   26,   64,  105,    4,    4,    4,    2,   35,    1,    1,

			    4,    2,    2,   79,   79,   79,   79,  111,  112,  111,
			    1,    4,    1,   12,   19,    4,   48,   22,    4,   12,
			    2,   84,   12,   19,   74,   12,   17,  112,    4,  102,
			   79,  104,    4,    1,    4,   91,  105,    4,    4,    4,
			  111,    4,    4,    4,   12,   12,   54,   55,    2,  100,
			   18,   19,    4,   84,    4,   18,   74,    2,   12,   12,
			  102,    1,   74,   17,    4,    4,    1,   79,    1,  111,
			    2,    2,   55,  100,    1,   12,  106,   12,   71,   12,
			  102,    8,   31,   39,  102,    4,    1,   12,  104,  111,
			  112,    4,    4,    2,  111,    4,  115,    4,    4,    4,

			    1,    1,   12,   71,   12,  113,    1,  102,   74,  102,
			    1,    4,   79,  100,    2,   66,   66,   80,  106,   87,
			    1,   71,   22,    1,   12,   12,   12,   10,   49,   60,
			   73,  102,   74,    2,  112,    1,   12,   96,  111,  106,
			    4,   12,   12,   12,   12,   12,   90,   97,   98,   99,
			  108,    1,   12,   86,   12,   12,   41,   87,   22,  112,
			   15,    1,   49,   15,   12,   46,    1,    4,   95,    1,
			  106,   95,   95,    1,   95,    4,    1,   97,   97,   98,
			   98,   99,   99,   12,   90,   90,    1,   94,    1,    4,
			   38,  101,   38,  101,   87,    1,    1,    1,   50,   18,

			   12,   46,   12,   16,   12,    1,   12,   83,   95,   70,
			   83,  107,   47,   89,  101,   98,   99,   12,   97,   40,
			   83,   86,    1,   12,   38,   52,   94,    4,    1,   95,
			   95,   87,   12,   12,   12,   12,   12,   12,    7,    6,
			    4,   29,   30,   32,   35,   37,   42,   44,   48,   48,
			   48,    2,   56,   58,   14,   14,   63,   68,   72,   15,
			   19,   46,   22,   15,   12,   95,    1,  107,   12,    1,
			   89,    1,   12,   53,   95,   99,   12,   98,   86,    4,
			    4,    1,   62,   38,    1,    1,   94,    1,    2,  101,
			   48,   48,   15,    4,  110,    6,   25,    2,   79,   22,

			    4,    4,    4,   79,    4,    4,    4,   15,    1,    1,
			   22,    4,    4,   83,   89,    4,   12,   99,    4,    4,
			    4,  102,   38,  101,   51,   93,   94,  101,    1,   85,
			    1,   12,   12,   23,    4,    1,   15,   27,   25,   12,
			   48,   48,   25,    4,   48,   48,   48,   15,   95,  107,
			   12,   86,  111,  111,   12,   93,    1,    4,    4,   12,
			   12,   12,   36,   85,   15,   22,   12,   82,   18,  109,
			   12,   27,   27,   25,    4,    4,   93,    1,  101,   15,
			    1,   85,    1,   12,   12,   16,   88,    1,   48,    2,
			   12,  109,    1,   27,    4,   12,    3,    2,   59,   61,

			   68,   79,  103,   85,   15,   12,   12,   16,   12,   45,
			   88,    4,   48,    4,    4,    4,    4,    4,  103,    4,
			    1,   12,   48,   88,    1,   48,   12,  109,    3,    2,
			   68,   79,    3,    2,   59,   68,    2,   59,   68,   79,
			    4,    3,    2,   59,   68,   12,   12,   88,   15,  103,
			   15,   15,   12,    1,    1,    1, yyDummy>>)
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
			   13,  580,  320,   16,  580,    0,  482,  483,  481,  480,
			    0,   39,    1,  580,  322,    6,  580,    3,    0,  545,
			  553,  552,  551,  550,  549,  548,  547,  546,  544,  543,
			  542,  541,  540,  539,  538,  537,  536,  535,  534,  530,
			  533,  529,  532,    0,    0,    0,    0,    0,  469,    0,
			  421,  464,  465,  500,  499,    0,    0,    0,    0,    0,
			  580,    0,  580,  501,  517,  508,  525,    0,    0,    0,
			    0,  440,    0,    0,  390,  422,  462,  402,  496,  490,
			  466,  393,  495,  467,  430,    4,  398,  431,  399,  457,
			    0,  469,  491,  396,  438,  492,  391,  392,  450,  449,

			  493,  397,  439,  494,  423,  357,  497,  528,  526,  527,
			  463,  437,  458,  459,    0,    0,    0,    0,  478,  479,
			  580,  477,  245,    2,  232,  231,  242,  243,   40,   41,
			    0,   41,   66,    0,  584,    0,  580,  580,    0,   81,
			   82,   83,   79,   77,   71,    0,  584,    0,  498,    0,
			    0,  388,  368,  367,  370,    0,    0,  457,  371,  369,
			  557,  556,  555,  554,   85,    0,  580,  447,  575,  574,
			  573,  572,  571,  570,  569,  568,  567,  566,  565,  564,
			  563,  562,  561,  560,  559,  558,   84,    0,    0,    0,
			    0,  371,    0,    0,    0,    0,  576,    0,  428,  429,

			    0,   81,  426,  578,    0,    0,  424,  580,  435,  519,
			  507,  433,    0,  518,  506,  434,    0,  580,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,  436,  460,    0,
			    0,  502,  522,  511,    0,    0,    0,  237,  241,  240,
			  236,    0,    0,  239,  238,  503,  504,  505,  509,  510,
			    0,  581,  580,  246,  244,   42,   36,   43,   44,    0,
			   41,   41,   35,   66,   67,    0,   66,  163,  580,    8,
			    0,  170,    0,  321,    0,   23,  584,    0,   78,    0,
			   80,   75,   74,   73,   72,    0,   70,    0,    0,    0,

			  384,    0,    0,  580,  355,    0,  470,    0,  371,  454,
			  441,  457,  469,  453,  371,  442,  358,  371,  388,    0,
			  395,    0,  474,  584,    0,  584,  468,    0,  580,  443,
			    0,  409,  408,  407,  406,  405,  404,  403,  416,  418,
			  417,  419,  400,  401,    0,  410,  415,    0,  412,  414,
			  420,  371,  445,  446,  469,  524,  513,  523,  512,    0,
			    0,    0,  248,    0,    0,  475,  263,  476,   38,   37,
			    0,   66,  167,    0,  161,  584,  168,  175,  174,  173,
			  580,   66,  457,  227,  584,  580,   14,   30,    0,    0,
			   29,   32,  488,  484,  485,    0,   31,  584,  486,  487,

			  514,  515,  516,  520,  521,  489,    0,   66,   89,   88,
			   87,   90,   76,   13,    0,    0,  200,    0,  469,  469,
			  366,  371,  372,    0,  469,  584,  362,    0,  461,  361,
			  364,  385,  531,  371,    0,    0,  427,    0,    0,    0,
			  425,  584,  584,  411,  413,  359,  451,    0,  247,  252,
			  584,  580,  187,  165,  164,  166,  169,  176,  171,  228,
			   66,    0,  224,   22,    0,   33,    0,    0,   24,   26,
			   91,   86,   45,   98,  156,  159,  580,   68,   13,    0,
			  452,  389,  356,  377,  379,  376,  437,  584,  448,    0,
			  455,  456,  363,    0,  577,  579,  371,  444,  178,    0,

			  254,  477,  245,    0,  235,  243,    0,  255,  256,    0,
			  249,  264,    0,    0,   45,  230,   66,  226,    0,   34,
			   31,   66,    0,  180,   94,    0,   17,  584,  201,   45,
			   98,    0,  378,    0,  471,  473,  360,  432,  582,    0,
			  246,  257,  582,    0,    0,    0,  273,  268,  271,  584,
			  188,  102,  229,   28,   25,   46,  213,   99,   20,   13,
			   92,    0,   96,    0,    0,  373,    0,   66,    0,  251,
			  269,  270,  274,    0,    0,  580,   10,  215,  191,   18,
			  580,  101,  100,   17,   45,  157,  158,   13,  375,  258,
			  261,  260,  583,  477,  259,    0,  272,    0,  265,  103,

			    0,  580,  217,  580,  580,    0,  580,   93,   95,   45,
			    0,  582,  276,  267,  245,  107,   66,  110,  584,  133,
			    0,  580,  214,  580,  200,  185,  200,  183,  182,  181,
			  218,  584,   97,    0,  262,    0,  580,  275,  109,    0,
			  108,  580,  580,  580,  580,  580,  144,  148,  152,    0,
			  122,  104,  580,  580,  349,  352,  348,  584,  216,  584,
			  190,  580,    0,  189,  220,  333,    0,  582,    0,    0,
			  106,  147,  155,    0,  151,  125,    0,  145,  148,  149,
			  152,  153,    0,  111,  123,  144,    0,   11,    0,  580,
			  580,  351,  580,  354,    0,  345,  193,    0,  187,  186,

			  222,  580,  200,    0,   19,    0,  277,  143,  584,  120,
			    0,  584,  128,  584,  580,  152,    0,  112,  148,  137,
			    0,  584,  320,   55,  580,   51,  584,   58,    0,  350,
			  353,  347,    0,    0,  200,  327,    0,  580,  212,  465,
			    0,  205,  204,  402,  393,  211,  202,  210,  203,    0,
			  431,  457,  207,  208,  198,  200,  209,  392,  206,  584,
			  184,  580,  219,  334,  179,    0,  140,    0,    0,  117,
			    0,  124,  131,   66,  132,    0,  113,  152,    0,    0,
			    0,  134,   13,   56,  580,   52,    0,   48,   62,  584,
			  580,    0,  318,  580,  200,  387,  388,  386,  388,    0,

			    0,    0,    0,    0,    0,    0,    0,    0,  199,  195,
			  221,    0,    0,  121,  127,  129,  114,    0,    0,  580,
			  580,    0,   54,   57,   65,  584,   50,    0,    0,    0,
			    0,  200,  580,  323,  328,    0,    0,  382,  388,  394,
			  343,  341,  388,  388,  339,  342,  340,  197,  142,  119,
			  115,  136,    0,    0,    9,  580,   12,    0,   59,  200,
			  288,  580,  294,  584,  580,  319,    0,    0,  332,  584,
			  326,  383,  380,  388,  139,    0,   64,   53,   61,    0,
			    0,    0,  291,  200,  278,    0,    0,    0,  325,  457,
			    0,    0,    0,  381,  138,  289,  301,  303,  299,  298,

			  309,    0,  584,  293,  287,  279,  280,    0,    0,  285,
			  584,    0,    0,    0,  329,    0,    0,    0,    0,    0,
			    0,  281,    0,    0,  282,  324,  200,  331,  302,  308,
			  316,    0,  307,  304,  305,  311,  306,  300,  314,    0,
			    0,  315,  310,  313,  312,  200,  200,  284,    0,  297,
			  295,  286,  317,    0,    0,    0, yyDummy>>)
		end

	yydefgoto_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			  275,  471,  290,  885,  703,  526,  514,  523,  132,  280,
			  327,  833,  156,   74,  796,  309,  300,   75,  741,  742,
			  390,  391,   76,   77,   78,  416,   79,   80,  310,   81,
			  862,   82,  745,  269,  690,  724,  583,  719,  656,  746,
			   83,  747,  909,  665,  712,   84,  322,   86,  749,   87,
			   88,  628,  698,  824,  725,  773,  546,  547,  788,  122,
			   89,  282,   90,   91,  752,  285,  397,  753,  754,  755,
			  398,   92,   93,  257,   94,   95,  629,  899,   15,  756,
			  313,  485,  615,  616,   96,   97,   98,   99,  399,  100,
			  101,  402,  102,  103,  709,  578,  758,  630,  524,  104,

			  105,  106,  107,  108,  109,  186,  164,  411,  383,  110,
			  503,  124,  111,  125,  126,  127,  506,  617,  133,  867,
			  112,  113,  142,  143,  144,  145,  407,  829,  863,  721,
			  653,  619,  657,  886,  910,  713,  646,  685,  323,  167,
			  825,  687,  726,  668,  708,  146,  147,  637,  677,  678,
			  679,  680,  681,  682,  452,  549,  714,  789,   11,  286,
			  560,  660,  759,  902,  487,  304,  576,  618,  711,  650,
			  869,  794,  283,  384,  263,  264,  363,  450,  589,  134,
			  590,  605,  417,  596,  953,   12,  284,  279,  130,  601,
			  722,  785,   16,  580,  385,  464,  131,  266,  786,  783,

			  827,  855,  661,  292,  639,  767,  770,  778,  765,  278,
			  380,  378,  556,  662,  807,  603,  621,  701,  761,  461,
			  509,  361,  566,  610,  573,  572,  923,  881,  918,  136,
			  891,  694,  531,  434, yyDummy>>)
		end

	yypact_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			 1262, 1138,  621, 2352, -32768, 1752, -32768, -32768, -32768, -32768,
			 1135,   51, -32768, -32768, -32768, -32768, -32768, -32768,  709, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, 2205, 1091, 1091, 1665,  623,  164, 2701,
			 -32768,  269,  267, -32768, -32768,  810,  906, 1135, 1135, 1135,
			 1089,  539, 1093, -32768, -32768, -32768, -32768, 1752, 1752, 1100,
			 1752, -32768, 2112, 1992, 1099, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, 1088, 2899, -32768, -32768, -32768, 1070,
			 1752,  959, -32768, -32768, -32768, -32768, 1092, 1073, -32768, -32768,

			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, 1200, -32768, -32768,  688,  764,   49,  989, -32768, -32768,
			 2505, -32768,  802, -32768, -32768, -32768, -32768, -32768, -32768,  956,
			  189,    5,  469,  435, -32768,  810,   47, -32768,  719, 1022,
			 -32768, -32768, -32768, -32768,  983,  947, -32768,   64, -32768, 1135,
			 1072,  371, -32768, -32768, -32768, 1752, 1071, 1066,  884, -32768,
			 -32768, -32768, -32768, -32768, -32768,   49, 1046, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, -32768, -32768, -32768,  810,  719,  810,
			  719,  884,  810, 1011, 1016,  324, -32768, 1752, -32768, -32768,

			 1752, -32768, -32768, -32768, 1752, 2793, -32768, 1013, -32768, -32768,
			 -32768, -32768,  875, -32768, -32768, -32768,  719, -32768, 1752, 1752,
			 1752, 1752, 1752, 1752, 1752, 1752, 1752, 1752, 1752, 1752,
			 1752, 1632, 1752, 1512, 1752, 1752,  810, -32768, -32768,  719,
			  719, -32768, -32768, -32768,  810,  676,  631, -32768, -32768, -32768,
			 -32768, 1014, 1012, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			  487, -32768, 1002, -32768, -32768, -32768, -32768, -32768, -32768,  300,
			  956,  956, -32768,  575, -32768, 1032,  583, -32768, -32768, -32768,
			  942,  954,   94, -32768, 1752,  862, -32768, 2232, -32768, 2769,
			 -32768,  983, -32768, -32768, -32768,  136, -32768,  993,  810,  810,

			 -32768, 2755,  719,  994, -32768,  985, -32768, 1752,  884,  910,
			 -32768, -32768,  959, -32768,  884, -32768, -32768,  884,  371, 2725,
			 -32768,  810, 2699, -32768, 2737, -32768,  246,  984, -32768, -32768,
			 1752,  617,  617,  617,  617,  617, 1065, 1065, 1356, 1356,
			 1356, 1356, 1356, 1356, 1752, 2928, 2914, 1752, 2773, 2482,
			 -32768,  884, -32768, -32768,  959, -32768, -32768, -32768, -32768,  992,
			  991,  987, -32768,  976, 1135, -32768,  981, -32768, -32768, -32768,
			 1006,  583, -32768, 1005, -32768, -32768, -32768,  954, -32768, -32768,
			 -32768, 2681,  513,  322, -32768, -32768, -32768, -32768,  612,  582,
			 1152, -32768, -32768, -32768, -32768,   22,  953, -32768, -32768, -32768,

			 -32768, -32768, -32768, -32768, -32768, -32768, 1226,  583, -32768, -32768,
			 -32768,  911, -32768,  521, 1135,  281, -32768,  302,  959,  959,
			 -32768,  884, -32768, 1872,  959, -32768, -32768,  719, -32768, -32768,
			 -32768, -32768, -32768,  884,  937,  931, -32768,  929,  810,  719,
			 -32768, -32768, -32768, 2928, 2773, -32768, -32768,  412, -32768,  455,
			 -32768,  926,  694, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 1392, 1752, -32768, -32768,  912, -32768,  889, 2232, -32768, -32768,
			 -32768, -32768,  760,  836, -32768, -32768, -32768,  498,  521, 1135,
			 -32768, -32768, -32768,  906, 2899,  904,  418, -32768, -32768,  896,
			  910, -32768, -32768, 1752, -32768, -32768,  884, -32768, -32768,  898,

			 -32768,  483,  802,  895,  870,  882,  877, -32768, -32768,  864,
			 -32768, -32768,   85, 2749,  760, -32768, 2681, -32768, 2232, -32768,
			 -32768,  583, 2205, -32768, -32768,  810,  238, -32768, -32768,  760,
			  836,  857, -32768,  858, -32768, -32768, -32768, -32768, -32768, 1135,
			  849, -32768, -32768, 1135,   49,   49, -32768,  863, -32768, -32768,
			 -32768,  806, -32768, -32768, -32768, -32768,  790, -32768,  834, 2398,
			 -32768,   92, -32768,  821, 1872, -32768,  656,  138,  606, -32768,
			 -32768, -32768,  844,  839,  848, 1526, -32768,  795,  778, -32768,
			 -32768, -32768, -32768,  780,  760, -32768, -32768,  521, -32768, -32768,
			 -32768, -32768, -32768,  803, -32768,  688, -32768,   85, -32768, -32768,

			   49, 1064, -32768,  454,  770,  543, -32768, -32768, -32768,  760,
			  698, -32768,  771, -32768,  802,  307,  583,  950, -32768,  759,
			  171,  454, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			  750, -32768, -32768,  355, -32768,  606, -32768, -32768, -32768,   49,
			 -32768,   43,  755,  670,   10,  316,  659,  616,  527,  753,
			  689, -32768, -32768,  909,  628,  628,  225, -32768, -32768, -32768,
			 -32768,  573, 2749, -32768,  714,  707,  723, -32768,  716,  719,
			 -32768, -32768, -32768,  719, -32768, -32768,  565, -32768,  616, -32768,
			  527, -32768,  711, -32768, -32768,  659,  719, -32768,  475,  713,
			 -32768,  832, -32768,  832,  171, -32768, -32768, 1272,  694, -32768,

			 -32768,   72, -32768,  686, -32768,  698, -32768, 2578, -32768,  660,
			  651, -32768,  314, -32768,  436,  527,  645, -32768,  616,  843,
			  359, -32768,  621, -32768,  615,  861, -32768, -32768,  300, -32768,
			 -32768, -32768, 1752, 1752, -32768,  675,  923,  635, -32768,  289,
			   56, -32768, -32768,  687,  685, -32768, -32768, -32768, 2899,  674,
			  667,   46, -32768, -32768, 1390, -32768, -32768,   68, -32768, -32768,
			 -32768,   72, -32768, -32768, -32768,  613, -32768,  588,  719, -32768,
			  565, -32768, -32768,  583, -32768,  592, -32768,  527,  576,  577,
			  569, -32768,  521,  565, -32768, -32768,  475, -32768,  525, -32768,
			 2598, 1095,  473,  517, -32768, -32768,  371, -32768,  482,  489,

			 1752, 1752,  142,  502, 1752, 1752, 1752, 1272,  498, -32768,
			 -32768,  719,  719, -32768, -32768, -32768, -32768,  464,  719, -32768,
			 -32768,  449, -32768, -32768,  486, -32768, -32768,  453,  445,  290,
			  304, -32768,  270,  353, -32768, 2749,  396, -32768,  371, -32768,
			 2899, 2899,  371,  482, 2899, 2899, 2899, -32768, -32768, -32768,
			 -32768, -32768,  434,  427, -32768, -32768, -32768,  300, -32768, -32768,
			 -32768, -32768,  278, -32768,  276, -32768, 1752,  341,  405, -32768,
			 -32768, -32768, -32768,  371, -32768,  384, -32768, -32768, -32768,  357,
			  842,  304, -32768, -32768, -32768,  348,  228,   67, 2899,  425,
			 1752,  293,  232, -32768, -32768, -32768,  360,  287,  273,  152,

			  194,  977, -32768, -32768, -32768, -32768, -32768,  186, 1752,  181,
			 -32768, 1752, 2281, 2749, -32768,  247,  842, 1104,  124,  842,
			   59, -32768, 1059,   67, -32768, 2899, -32768, -32768, -32768, -32768,
			 -32768,  419, -32768, -32768, -32768, -32768, -32768, -32768, -32768, 1027,
			  842, -32768, -32768, -32768, -32768, -32768, -32768, -32768,   44, -32768,
			 -32768, -32768, -32768,   98,   62, -32768, yyDummy>>)
		end

	yypgoto_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			 -251, -32768, -32768,  358, -32768,  715,  540,  729, -280, -32768,
			 -32768, -32768, -32768, -32768, -738,  809, -315, -32768, -32768, -32768,
			 -32768,  666, -32768, -655, -211, -32768, -212, -32768, -166, -656,
			 -32768, -273, -32768, -32768, -619, -32768, -32768, -32768, -32768, -32768,
			 -255, -32768, -32768, -32768, -32768, -32768,   -1,  724, -32768, -657,
			 -32768, -32768, -32768, 1218, -32768, -32768, -32768, -32768,  961,  106,
			    0, -32768,  249,  -35, -32768, -32768, -32768, -32768, -32768, -32768,
			 -100,  -72,  -86, -32768,  -90,  -94, -32768, -32768,  501, -32768,
			  794, -32768, -32768, -32768, -32768, -528, -32768, -32768, -32768, -215,
			 -224, -32768, -229, -259, -32768, -32768, -32768, -32768, -485, -32768,

			 -32768,  -30, -503,  901, -32768,  930, -32768, -32768, -32768,  816,
			   -5, -355,  -38, -105, 1101, -366, -32768, -32768, -32768, -32768,
			  115,   41,  -60, -136, -32768, -32768, -399, -32768,  328,  385,
			 -32768, -32768,  500, -32768,  266,  422,  541, -32768, -189,  -58,
			  333, -32768,  401,  -65,  368, 1033, -32768, -32768,  560,  488,
			  555, -622,  553, -637, -32768,  578, -625,  303, -392, -359,
			  586, -389,  352,  215,  590, -171, -32768,  510,  336, -32768,
			  233, -32768, -495,  690,  643,  530,  -95,  600, -408, -266,
			 -428, -32768, -32768, -32768, -32768, -32768,  338,  337, -32768, -32768,
			 -32768,  286, -32768, -32768, -32768, -32768, -32768,  -93, -32768, -32768,

			 -32768, -32768, -400,  850, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768,  762, -32768, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -505, -32768, -32768, -32768, -32768, -32768, -32768, -32768,
			 -32768, -32768, -32768, -32768, yyDummy>>)
		end

	yytable_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			   10,  202,  288,  431,   85,  123,  150,  151,  159,  247,
			  550,  158,  374,  148,  394,  325,  477,  254,  139,  508,
			  316,  472,  370,  259,  315,  373,  463,  258,  404,  691,
			  693,  256,  395,  238,  212,  212,  692,  568,  272,  507,
			  750,  744,  743,  716,  562,  255,  157, -223,  441,  806,
			  329,   -5,  193,  194,  195,  191,  715,   62,  403,  141,
			  838,  201,  955,  401,  842,  296,  205,  206,  521,  208,
			 -150, -338,  400,  352,  353,  393,  392,  121,  775,  260,
			  119,  505,  465,  805,  121,  120,  529,  119,  271,  237,
			  265,  -69,  504,  586,  240,  379,  777,  236,  954,  608,

			  458,  802,  141, -146,  952,  873,  635, -223,  622,  129,
			  270,  -69,  128,  121, -150,  249,  119,  253,  425,  553,
			  454,  118, -172, -172,  632, -172,  658,  276,  118,  117,
			  459,  -69, -223,  140,  585,  281, -223,  426,  139,  116,
			  817,  442, -146,  429,  297,  139,  430, -146,  908,  115,
			  750,  744,  743,  312,  301,  312,  469,  118,  823,  699,
			  594,  114,  705,  415,  822,  945, -172,  584,  545,  757,
			    9,    8,  940,    7,  591, -223,  140,  368,  369,  141,
			  445,  312,  634,  414,  274,  544,  141,  308,  311,  314,
			  311,  166,  317,  259,  394,  609,  795,  258,  919,  324,

			  505,  256,  505,  413,  312,  312,  762,  165,  404,  515,
			  527,  504,  395,  504,    6,  255,  311,  331,  332,  333,
			  334,  335,  336,  337,  338,  339,  340,  341,  342,  343,
			  345,  346,  348,  349,  350,  655,  351,  663,  403,  311,
			  311, -283,  799,  401,  354,  394,  921,  631,  654,  406,
			  482,  268,  400,  140,  428,  393,  392,  405, -296,  404,
			  140, -283,  492,  395,  267,  552,  810,  421,  371,  505,
			  554,  305,  439,  497,  914,    9,    8,  917,    7,  757,
			  504,   63,  475,  381,  382, -346,  394,  396,  906,  403,
			  149,  916,  801,  190,  401,  188,  446,  438,  418,  419,

			  404, -346,  311,  400,  535,  559,  393,  392,  883, -580,
			 -580, -346, -580,  763, -346,  190,  592, -346,  189,    6,
			  187,  433, -225,  474,  599,  536,  800,  558,  121,  365,
			  403,  119,  868,   44,  235,  401,  884,  865, -292,   13,
			  189,  913,   18,  443,  400,  792,  444,  393,  392,  479,
			  860,  135,  900, -580,  137,  808,  883,  659, -292,  449,
			  480,  481,  274,  321,  915,  640,  488, -105,  320,  478,
			  859, -105,  118,  259, -126,  367,  -66,  258, -223, -223,
			 -225,  256, -225, -105, -105,  486,  780,  930,  935,  938,
			  821,  944,  312, -105,  675,  255, -105,  299,  197, -105,

			  204, -225,  539,  667,  312,  836,  779, -225,  905,  473,
			  868, -225,  900, -126,  861,  -66, -225,  895, -126, -225,
			  -66, -126,  484,  -66,  259, -225,  894,  311,  258,  406,
			 -225, -225,  256,  246,  245, -160,  277,  405,  496,  311,
			  501,  120,  864,  119,  244,  244,  255, -330,  500,  890,
			  243,  242,  241,  241,  235,  235,  870,  235,  261,  516,
			  381,  382,  866, -162, -162,  259, -162,  520,  532,  258,
			  879,  875,  911,  256,  530,  287,  236, -160,  874, -130,
			  406,  837, -130,  295,  118,  117,  235,  255,  405,  858,
			  612, -250,  555, -160,  904,  116, -130,  121,  120, -250,

			  119,  857,  360,  359,  307,  115,  772, -162,  299,  854,
			    9,    8, -223,    7, -160,  274,  273,  114,  520,  243,
			 -160,  406,  815,  871,  850,  557,  486,  872,  431,  405,
			  539,  538, -160, -223,  567, -130,  795,  948,  449, -223,
			 -130,  118,  117, -130,  528,  328,  -63,  843, -223,  839,
			  235, -223,  116,  502,    6,  330,  950,  951,  893,  834,
			  460,  723,  115,  484,  236,  832,  200,    9,    8,  -60,
			    7,  235,  -63,  235,  114,  -63,  671,  672,  -63,  674,
			  235,  235,  235,  235,  235,  235,  235,  235,  235,  235,
			  235,  235,  235,  199,  235,  235,  198,  235,  235,  235,

			  364,  627,   49,  121,  120,   47,  119,  896,  689,  707,
			    3,    6,  820,  710,  214,  213,  135,  376,  548,  528,
			  819,  274,  626,  386,  818,  729,  720,  730,  625,  274,
			  235,  642,  813, -194,  593,  120,  812,  119,  218,   71,
			  624,  423,  928,  932,  210,  209,  941,  118,  117,  774,
			  570,  571,  816, -194, -194, -194,  -56,  -56,  116,  -56,
			  435,  811,  437,  358,  357, -194,  135,  896,  115,  201,
			 -336,  689,  502,  201,  502,  -12, -194,  804,  118,  117,
			  114, -194, -194, -194,  501,  120,  201,  119, -337,  116,
			 -335,  -56,  235,  235,  -56, -223,  748,  751,  798,  115,

			  -56,  -12,  793,  548,  -12,  776,  614,  -12,  356,  355,
			  141,  114,  456,   14,  141,  644,  121,  120,  135,  119,
			 -118,  462,  768,  287,  852,  853,  633,  141,  118,  117,
			 -116,  790,  791,  235,  468,  803,  797,    9,    8,  116,
			    7,  502,  163,  162, -118,  614,  764,    9,    8,  115,
			    7,  707,  710,  476, -116,  161,  160,  727,  720, -118,
			  118,  114,  489,  513, -118,  235,  641, -118,  139, -116,
			  138,  717,   49,  645, -116,   47,  706, -116,  498,  499,
			  898,    6,   49,  704,  140,   47,  259,  510,  140,  512,
			  258,    6,    9,    8,  256,    7,  211,  215,  797,  840,

			  841,  140,  797,  844,  845,  846,  748,  751,  255,  141,
			  702,  201,  201,  683,  135, -154,  934,  937,  201,  943,
			  700,  248,  259,  259,  533,  259,  258,  258, -192,  258,
			  256,  256,  664,  256,  367,  652,    6,  262,    9,    8,
			  898,    7,  901,  797,  255,  255,  259,  255,  636, -192,
			  258,  611,  141,  141,  256, -192,  522,  252,  251,  141,
			  -57,  -57,  -21,  -57,  561,  888,  889, -192,  255,  558,
			    9,    8,  604,    7,   65,  602,   63,  931,  901,  939,
			  897,  901,    6,  140,  598,  149,  574,  597,  587,  912,
			  246,  245,  577,  595,  579,  -57,  575, -233,  -57, -266,

			  565,  244,  901, -135,  -57,  564, -232,  922,  525,  241,
			  925,  303,  543,  600,    6,  929,  933,  936,  606,  942,
			  -21,  -49,  -21,  -21,  -21,  542,  140,  140,   44, -135,
			 -234,  541, -135,  140,  537, -135,  427,  -21,  534,  620,
			  897,  -21,  623,  375,  287,  -21, -374,  -21,  293,  519,
			  -49,    9,    8,  -49,    7,  651,  -21,  192,  -21,  -21,
			  518,  135,  511,  367,  -21,  495,  149,  -21,  666,  -47,
			 -584, -584,  494, -584,  669,    9,    8,  795,    7,  669,
			  669,  673,  669,  676, -584,  493,  166,  470, -584, -584,
			  686,  688,  360,  359,  695,    6,  696,  235,  -47,  697,

			  467,  -47,  377,  244,  252,  251,  455,  453,  138,  243,
			   49,  241,  448,   47, -584, -584,  451,    9,    8,    6,
			    7,   65,  447,  358,  356, -584,  440,  728,  669,  424,
			  669,  291,  149,  372,  645, -584,  422,  320,  362,  235,
			  235,  265,  360,  359,  214,  766,  210, -584,  769,  644,
			  771,  643,  669,  244,  642, -177,  318,  641,  781,  243,
			  319,    6,  784,  787,  234,  233,  232,  231,  230,  229,
			  228,  227,  226,  225,  224,  223,  222,  221,  220,  219,
			  218,   71,  222,  221,  220,  219,  218,   71,  306,  235,
			  235,  289, -365,  235,  235,  235,  809,  302,  298,  240,

			  234,  233,  232,  231,  230,  229,  228,  227,  226,  225,
			  224,  223,  222,  221,  220,  219,  218,   71,  239,  252,
			  251,  236,   18,  217, -344,  216,  828,  207,  830,  203,
			  196,  835,    9,    8,  149,    7,   65,  235,   -7,  457,
			 -344,  412,  877,  569,  638,  540,  927,  149,  849,  670,
			 -344,  517,  -27, -344,  588,  949, -344,  364,  364,  847,
			  878,  235,  856,  121,  120,  946,  119,  -27,  -27,  607,
			  649,  235,  648,  718,  235,  613,    6,  647,  294,  848,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  826,  876,  947,
			   44,  684,  814,   18,  731,  -27,  -27,  -27,  -27,  880,

			  882,  831,  887,  851,  -27,  -27,  892,  118,  117,  903,
			  -27,  466,  -27,  -27,  -27,  246,  245,  250,  116,  410,
			  432,  491,   17,  782,  -27,  582,  244,  -27,  115,  -27,
			  366,  -27,  243,  242,  241,  -27,  490,  -27,  760,  920,
			  114,  246,  245,  551,  907,  563,  -27,  924,  -27,  -27,
			    0,    0,    0,    0,  -27,    0,    0,  -27,  243,  242,
			  241,    0,    0,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,   73,   72,    0,
			    9,    8,    0,    7,   71,   70,   69,   68,    0,   67,

			    9,    8,   66,    7,   65,   64,   63,   62,    0,    0,
			   61,    0,   60,    0,    0,   59,   58,  740,    0,    0,
			    0,    0,   56,   55,   54,   53,  739,  738,    0,   51,
			    0,   50,    0,    0,    6,   49,    5,   48,   47,    0,
			   46,    0,    0,    0,    6,    0,  737,    0,    4,  736,
			  735,    3,    0,    0,    2,    0,    1,    0,   44,  734,
			  733,    0,    0,  732,    0,    0,    0,    0,    0,    0,
			   43,  224,  223,  222,  221,  220,  219,  218,   71,    0,
			    0,    0,    0,   42,   41,   40,   39,   38,   37,   36,
			   35,   34,   33,   32,   31,   30,   29,   28,   27,   26,

			   25,   24,   23,   22,   21,   20,   19,   73,   72,    0,
			    0,    0,    0,    0,   71,   70,   69,   68,    0,   67,
			    9,    8,   66,    7,   65,   64,   63,   62,    0,    0,
			   61,    0,   60,    0,    0,   59,   58,   57,  274,    0,
			    0,    0,   56,   55,   54,   53,   52,    0,    0,   51,
			 -196,   50,    0,    0,    0,   49,    0,   48,   47,    0,
			   46,    0,    0,    0,    6,    0,    0,    0,    0,   45,
			 -196, -196, -196,    0,    0,    0,    0,    0,   44,    0,
			    0,    0, -196,    0,    0,    0,    0,    0,    0,    0,
			   43,    0,    0, -196,    0,    0,    0,    0, -196, -196,

			 -196,    0,    0,   42,   41,   40,   39,   38,   37,   36,
			   35,   34,   33,   32,   31,   30,   29,   28,   27,   26,
			   25,   24,   23,   22,   21,   20,   19,   73,   72,    0,
			    0,    0,    0,    0,   71,   70,   69,   68,    0,   67,
			    9,    8,   66,    7,   65,   64,   63,   62,    0,    0,
			   61,    0,   60,    0,    0,   59,   58,   57,    0,    0,
			    0,    0,   56,   55,   54,   53,   52,    0,    0,   51,
			    0,   50,  274,    0,    0,   49,    0,   48,   47,    0,
			   46,    0,    0,    0,    6,    0,  -66,    0,    0,   45,
			  -66,    0,  347,    0,    0,    0,    0,    0,   44,    0,

			    0,    0,  -66,  -66,    0,    0,    0,    0,    0,    0,
			   43,    0,  -66,    0,    0,  -66,    0,    0,  -66,    0,
			    0,    0,    0,   42,   41,   40,   39,   38,   37,   36,
			   35,   34,   33,   32,   31,   30,   29,   28,   27,   26,
			   25,   24,   23,   22,   21,   20,   19,   73,   72,    0,
			    0,    0,    0,    0,   71,   70,   69,   68,    0,   67,
			    9,    8,   66,    7,   65,   64,   63,   62,    0,    0,
			   61,    0,   60,    0,    0,   59,   58,   57,    0,    0,
			    0,    0,   56,   55,   54,   53,   52,    0,    0,   51,
			    0,   50,  155,    9,    8,   49,    7,   48,   47,    0,

			   46,    0,    0,    0,    6,    0,    0,    0,  149,   45,
			    0,    0,    0,    0,    0,  154,    0,    0,   44,  153,
			    0,    0,  152,    0,    0,    0,    0,    0,   49,    0,
			   43,   47,    0,    0,    0,    0,    0,    6,  344,    0,
			    0,    0,    0,   42,   41,   40,   39,   38,   37,   36,
			   35,   34,   33,   32,   31,   30,   29,   28,   27,   26,
			   25,   24,   23,   22,   21,   20,   19,   73,   72,    0,
			    0,    0,    0,    0,   71,   70,   69,   68,    0,   67,
			    9,    8,   66,    7,   65,   64,   63,   62,    0,    0,
			   61,    0,   60,    0,    0,   59,   58,   57,    0,    0,

			    0,    0,   56,   55,   54,   53,   52,    0,    0,   51,
			    0,   50,    0,    0,    0,   49,    0,   48,   47,    0,
			   46,    0,    0,    0,    6,    0,    0,    0,    0,   45,
			    0,    0,    0,    0,    0,    0,    0,    0,   44,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			   43,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,   42,   41,   40,   39,   38,   37,   36,
			   35,   34,   33,   32,   31,   30,   29,   28,   27,   26,
			   25,   24,   23,   22,   21,   20,   19,   73,   72,    0,
			    0,    0,    0,    0,   71,   70,   69,   68,    0,   67,

			    9,    8,   66,    7,   65,   64,   63,   62,    0,    0,
			   61,    0,   60,    0,    0,   59,   58,   57,    0,    0,
			    0,    0,  483,   55,   54,   53,   52,    0,    0,   51,
			    0,   50,    0,    0,    0,   49,    0,   48,   47,    0,
			   46,    0,    0,    0,    6,    0,    0,    0,    0,   45,
			    0,    0,    0,    0,    0,    0,    0,    0,   44,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			   43,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,   42,   41,   40,   39,   38,   37,   36,
			   35,   34,   33,   32,   31,   30,   29,   28,   27,   26,

			   25,   24,   23,   22,   21,   20,   19,   73,   72,    0,
			    0,    0,    0,    0,   71,   70,   69,   68,    0,   67,
			    9,    8,   66,    7,  214,  213,   63,   62,    0,    0,
			   61,    0,   60,    0,    0,   59,   58,   57,    0,    0,
			    0,    0,   56,   55,   54,   53,   52,    0,    0,   51,
			    0,   50,    0,    0,    0,   49,    0,   48,   47,    0,
			   46,    0,    0,    0,    6,    0,    0,    0,    0,   45,
			    0,    0,    0,    0,    0,    0,    0,    0,   44,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			   43,    0,    0,    0,    0,    0,    0,    0,    0,    0,

			    0,    0,    0,   42,   41,   40,   39,   38,   37,   36,
			   35,   34,   33,   32,   31,   30,   29,   28,   27,   26,
			   25,   24,   23,   22,   21,   20,   19,   73,   72,    0,
			    0,    0,    0,    0,   71,   70,   69,   68,    0,   67,
			    9,    8,   66,    7,  210,  209,   63,   62,    0,    0,
			   61,    0,   60,    0,    0,   59,   58,   57,    0,    0,
			    0,    0,   56,   55,   54,   53,   52,    0,    0,   51,
			    0,   50,    0,    0,    0,   49,    0,   48,   47,    0,
			   46,    0,    0,    0,    6,    0,    0,    0,    0,   45,
			    0,    0,    0,    0,    0,    0,    0,    0,   44,    0,

			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			   43,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,   42,   41,   40,   39,   38,   37,   36,
			   35,   34,   33,   32,   31,   30,   29,   28,   27,   26,
			   25,   24,   23,   22,   21,   20,   19,  389,  388,   58,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    9,    8,   66,    7,   65,   64,   63,    0,    0,    0,
			    0,    0,    0,    0,    0,  149,   58,   57,  387,    0,
			    0,    0,    0,    0,   54,   53,  234,  233,  232,  231,
			  230,  229,  228,  227,  226,  225,  224,  223,  222,  221,

			  220,  219,  218,   71,    6,    0,    0,    0,    0,   45,
			    0,    0,    0,    0,    0,    0,   42,   41,   40,   39,
			   38,   37,   36,   35,   34,   33,   32,   31,   30,   29,
			   28,   27,   26,   25,   24,   23,   22,   21,   20,   19,
			    0,    0,    0,   42,   41,   40,   39,   38,   37,   36,
			   35,   34,   33,   32,   31,   30,   29,   28,   27,   26,
			   25,   24,   23,   22,   21,   20,   19,  -15,  -15,    0,
			    0,    0,    0,    0,    0,    0,  926,    0,    0,    0,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,    0,    0,    0,
			    0,    0,    0,    0,    0,  -15,  -15,  -15,  -15,    0,

			    0,    0,    0,    0,  -15,  -15,    0,    0,    0,    0,
			    0,    0,    0,  389,  388,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,  -15,    0,    0,    0,   66,  -15,
			   65,   64,   63,    0,    0,    0,    0,    0,    0,    0,
			    0,  149,   58,    0,    0,    0,    0,    0,    0,    0,
			   54,   53,    0,    0,  581,    0,    0,    0,    0,    0,
			    0,    0,    0,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,    3,  233,  232,
			  231,  230,  229,  228,  227,  226,  225,  224,  223,  222,

			  221,  220,  219,  218,   71, -253, -253,    0,    0,   42,
			   41,   40,   39,   38,   37,   36,   35,   34,   33,   32,
			   31,   30,   29,   28,   27,   26,   25,   24,   23,   22,
			   21,   20,   19, -253, -253,    0, -253,    0,    0,    0,
			    0, -253,    0,    0, -253,    0,    0, -253,    0, -253,
			 -253, -253,    0, -253,    0,    0,    0,    0,    0,    0,
			    0,    0,    0, -253,    0, -253, -253,    0, -253,    0,
			    0, -253, -253,    0,    0,    0,    0, -253,    0,    0,
			    0,    0, -253,    0, -253,    0,    0,    0,    0,    0,
			 -253, -253,    0,    0, -253,    0,    0, -253,    0,    0,

			    0,    0, -253,  234,  233,  232,  231,  230,  229,  228,
			  227,  226,  225,  224,  223,  222,  221,  220,  219,  218,
			   71, -141,    0,    0, -141,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0, -141,    0,
			    0,    0, -141,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0, -141, -141,    0,    0, -290,    0,
			    0,    0,    0,    0, -141,    0,    0, -141,    0,    0,
			 -141,    0,    0,    0,    0,    0,    0, -141, -290,    0,
			    0,    0, -141,    0,    0, -141,  234,  233,  232,  231,
			  230,  229,  228,  227,  226,  225,  224,  223,  222,  221,

			  220,  219,  218,   71,  234,  233,  232,  231,  230,  229,
			  228,  227,  226,  225,  224,  223,  222,  221,  220,  219,
			  218,   71,    0,    0,    0,    0,    0,  274,    0,    0,
			    0,    0,    0,    0,    0, -472,    0,    0,    0,    0,
			 -472, -472,  234,  233,  232,  231,  230,  229,  228,  227,
			  226,  225,  224,  223,  222,  221,  220,  219,  218,   71,
			  234,  233,  232,  231,  230,  229,  228,  227,  226,  225,
			  224,  223,  222,  221,  220,  219,  218,   71,    0,  436,
			  232,  231,  230,  229,  228,  227,  226,  225,  224,  223,
			  222,  221,  220,  219,  218,   71,    0,  420,  234,  233,

			  232,  231,  230,  229,  228,  227,  226,  225,  224,  223,
			  222,  221,  220,  219,  218,   71,  185,  184,  183,  182,
			  181,  180,  179,  178,  177,  176,  175,  174,  173,  172,
			  171,  170,  169,    0,  168,  326,   42,   41,   40,   39,
			   38,   37,   36,   35,   34,   33,   32,   31,   30,   29,
			   28,   27,   26,   25,   24,   23,   22,   21,   20,   19,
			   42,    0,   40,    0,   38,   37,   36,   35,   34,   33,
			   32,   31,   30,   29,   28,   27,   26,   25,   24,   23,
			   22,   21,   20,   19,  185,  184,  183,  182,  181,  180,
			  179,  178,  177,  176,  175,  174,  173,  172,  171,  170,

			  169,  409,  168,  408,  234,  233,  232,  231,  230,  229,
			  228,  227,  226,  225,  224,  223,  222,  221,  220,  219,
			  218,   71,  231,  230,  229,  228,  227,  226,  225,  224,
			  223,  222,  221,  220,  219,  218,   71,  230,  229,  228,
			  227,  226,  225,  224,  223,  222,  221,  220,  219,  218,
			   71, yyDummy>>)
		end

	yycheck_template: SPECIAL [INTEGER] is
		once
			Result := yyfixed_array (<<
			    0,   61,  138,  318,    5,   10,   44,   45,   46,  114,
			  513,   46,  278,   43,  287,  204,  416,  117,   18,  447,
			  191,  413,  273,  117,  190,  276,  385,  117,  287,  654,
			  655,  117,  287,   91,   72,   73,  655,  542,  131,  447,
			  697,  697,  697,  680,  529,  117,   46,    0,  328,    3,
			  216,    0,   57,   58,   59,   55,  678,   35,  287,   18,
			  798,   61,    0,  287,  802,    1,   67,   68,  467,   70,
			   60,    3,  287,  239,  240,  287,  287,   28,  715,  117,
			   31,  447,   60,   37,   28,   29,  478,   31,   83,   90,
			   85,   27,  447,    1,   26,    1,  718,   51,    0,  584,

			  380,   45,   61,   60,   60,  843,  611,   60,  603,   58,
			  105,   47,   61,   28,  104,  115,   31,  117,  307,  518,
			  371,   72,   28,   29,  609,   31,  621,  132,   72,   73,
			  381,   67,   60,   18,   42,  135,   89,  308,  138,   83,
			  777,  330,   99,  314,  149,  145,  317,  104,   81,   93,
			  807,  807,  807,  188,  155,  190,  407,   72,  783,  662,
			  568,  105,  667,   27,  783,  106,   72,  559,   83,  697,
			   28,   29,   48,   31,   36,  103,   61,  270,  271,  138,
			  351,  216,  610,   47,   46,  100,  145,  187,  188,  189,
			  190,   27,  192,  287,  467,  587,   54,  287,    4,  200,

			  566,  287,  568,   67,  239,  240,  701,   43,  467,  460,
			  476,  566,  467,  568,   72,  287,  216,  218,  219,  220,
			  221,  222,  223,  224,  225,  226,  227,  228,  229,  230,
			  231,  232,  233,  234,  235,   64,  236,  626,  467,  239,
			  240,   60,  737,  467,  244,  518,   60,  606,   77,  287,
			  421,   62,  467,  138,  312,  467,  467,  287,  106,  518,
			  145,   80,  433,  518,   75,  516,  761,  302,  273,  635,
			  521,  165,   26,  439,   42,   28,   29,    4,   31,  807,
			  635,   34,    1,  284,  284,   60,  559,  287,   60,  518,
			   43,    4,    3,   26,  518,   26,  354,   51,  298,  299,

			  559,   76,  302,  518,  493,   67,  518,  518,   80,   28,
			   29,   86,   31,  702,   89,   26,  567,   92,   51,   72,
			   51,  321,    0,   42,  575,  496,   37,   89,   28,   29,
			  559,   31,  835,   86,   85,  559,   60,  832,   60,    1,
			   51,   48,    4,  344,  559,  734,  347,  559,  559,   47,
			   60,   13,  880,   72,   16,  755,   80,  623,   80,  364,
			  418,  419,   46,   39,    4,  616,  424,   60,   44,   67,
			   80,   64,   72,  467,   60,  269,   60,  467,  108,  109,
			   58,  467,   60,   76,   77,  423,   27,  915,  916,  917,
			  782,  919,  427,   86,  645,  467,   89,   26,   60,   92,

			   62,   79,   47,   48,  439,  794,   47,   85,   60,  414,
			  913,   89,  940,   99,  110,   99,   94,   60,  104,   97,
			  104,  107,  423,  107,  518,  103,   42,  427,  518,  467,
			  108,  109,  518,   15,   16,    0,    1,  467,  438,  439,
			   28,   29,  831,   31,   26,   26,  518,   42,   36,  108,
			   32,   33,   34,   34,  205,  206,   60,  208,  120,  460,
			  461,  461,  109,   28,   29,  559,   31,  467,   50,  559,
			  859,   44,   47,  559,  479,  137,   51,   42,   44,   43,
			  518,  796,   46,  146,   72,   73,  237,  559,  518,   44,
			  595,   36,  522,   58,  883,   83,   60,   28,   29,   44,

			   31,   48,   15,   16,  166,   93,   70,   72,   26,   60,
			   28,   29,   58,   31,   79,   46,   47,  105,  518,   32,
			   85,  559,  773,  838,   60,  525,  564,  842,  843,  559,
			   47,   48,   97,   79,  539,   99,   54,  926,  543,   85,
			  104,   72,   73,  107,   46,  207,   60,   45,   94,   60,
			  301,   97,   83,  447,   72,  217,  945,  946,  873,   42,
			   47,   86,   93,  564,   51,   92,   27,   28,   29,   44,
			   31,  322,   86,  324,  105,   89,  641,  642,   92,  644,
			  331,  332,  333,  334,  335,  336,  337,  338,  339,  340,
			  341,  342,  343,   54,  345,  346,   57,  348,  349,  350,

			  262,   58,   63,   28,   29,   66,   31,  880,   43,  669,
			   89,   72,   43,  673,   32,   33,  278,  280,  512,   46,
			   43,   46,   79,  286,   48,  690,  686,  692,   85,   46,
			  381,  104,  768,   60,   28,   29,   48,   31,   21,   22,
			   97,  303,  915,  916,   32,   33,  919,   72,   73,  714,
			  544,  545,   60,   80,   81,   82,   28,   29,   83,   31,
			  323,   48,  325,   32,   33,   92,  328,  940,   93,  669,
			    3,   43,  566,  673,  568,   60,  103,    3,   72,   73,
			  105,  108,  109,  110,   28,   29,  686,   31,    3,   83,
			    3,   63,  443,  444,   66,   60,  697,  697,  736,   93,

			   72,   86,   27,  597,   89,   60,  600,   92,   32,   33,
			  669,  105,  375,   92,  673,   99,   28,   29,  380,   31,
			   60,  384,   71,  385,  819,  820,   28,  686,   72,   73,
			   60,  732,  733,  484,  397,  740,  736,   28,   29,   83,
			   31,  635,  119,  120,   84,  639,   60,   28,   29,   93,
			   31,  811,  812,  415,   84,  132,  133,   44,  818,   99,
			   72,  105,  425,   69,  104,  516,  107,  107,  768,   99,
			   61,   60,   63,   84,  104,   66,   60,  107,  441,  442,
			  880,   72,   63,   60,  669,   66,  880,  450,  673,  451,
			  880,   72,   28,   29,  880,   31,   72,   73,  798,  800,

			  801,  686,  802,  804,  805,  806,  807,  807,  880,  768,
			  103,  811,  812,   60,  476,   60,  916,  917,  818,  919,
			  106,   57,  916,  917,  487,  919,  916,  917,   58,  919,
			  916,  917,   82,  919,  728,   76,   72,   35,   28,   29,
			  940,   31,  880,  843,  916,  917,  940,  919,   77,   79,
			  940,   48,  811,  812,  940,   85,   96,   15,   16,  818,
			   28,   29,    0,   31,  527,  866,  866,   97,  940,   89,
			   28,   29,   94,   31,   32,   80,   34,  915,  916,  917,
			  880,  919,   72,  768,   36,   43,  549,   48,   67,  890,
			   15,   16,  102,   49,   60,   63,   90,   48,   66,   36,

			   42,   26,  940,   60,   72,   48,   36,  908,   72,   34,
			  911,   27,   48,  575,   72,  915,  916,  917,  580,  919,
			   58,   60,   60,   61,   62,   48,  811,  812,   86,   86,
			   48,   36,   89,  818,   36,   92,   26,   75,   42,  601,
			  940,   79,  604,    1,  606,   83,   42,   85,    1,   60,
			   89,   28,   29,   92,   31,  618,   94,   51,   96,   97,
			   48,  623,   36,  857,  102,   36,   43,  105,  631,   60,
			   28,   29,   41,   31,  636,   28,   29,   54,   31,  641,
			  642,  643,  644,  645,   42,   48,   27,   76,   46,   47,
			  652,  653,   15,   16,  657,   72,  659,  748,   89,  661,

			   47,   92,   48,   26,   15,   16,    1,    1,   61,   32,
			   63,   34,   36,   66,   72,   73,   35,   28,   29,   72,
			   31,   32,   35,   32,   32,   83,   42,  689,  690,   44,
			  692,   48,   43,    1,   84,   93,   42,   44,   36,  790,
			  791,   85,   15,   16,   32,  708,   32,  105,  711,   99,
			  713,  101,  714,   26,  104,   42,   45,  107,  721,   32,
			   44,   72,  724,  726,    5,    6,    7,    8,    9,   10,
			   11,   12,   13,   14,   15,   16,   17,   18,   19,   20,
			   21,   22,   17,   18,   19,   20,   21,   22,   42,  840,
			  841,   69,   26,  844,  845,  846,  759,   26,   26,   26,

			    5,    6,    7,    8,    9,   10,   11,   12,   13,   14,
			   15,   16,   17,   18,   19,   20,   21,   22,   26,   15,
			   16,   51,  784,   35,   60,   26,  789,   27,  790,   36,
			   41,  793,   28,   29,   43,   31,   32,  888,    0,  377,
			   76,  291,  856,  543,  614,  502,  913,   43,  812,  639,
			   86,  461,    0,   89,  564,  940,   92,  819,  820,  807,
			  857,  912,  825,   28,   29,  106,   31,   15,   16,  583,
			  617,  922,  617,  685,  925,  597,   72,  617,  145,  811,
			   28,   29,   30,   31,   32,   33,   34,  786,  855,  923,
			   86,  650,  770,  855,  694,   43,   44,   45,   46,  861,

			  863,  106,  864,  818,   52,   53,  869,   72,   73,  881,
			   58,  395,   60,   61,   62,   15,   16,  116,   83,  289,
			  319,  427,    4,  722,   72,  559,   26,   75,   93,   77,
			  269,   79,   32,   33,   34,   83,  427,   85,  698,  902,
			  105,   15,   16,  514,  886,  530,   94,  910,   96,   97,
			   -1,   -1,   -1,   -1,  102,   -1,   -1,  105,   32,   33,
			   34,   -1,   -1,  111,  112,  113,  114,  115,  116,  117,
			  118,  119,  120,  121,  122,  123,  124,  125,  126,  127,
			  128,  129,  130,  131,  132,  133,  134,   15,   16,   -1,
			   28,   29,   -1,   31,   22,   23,   24,   25,   -1,   27,

			   28,   29,   30,   31,   32,   33,   34,   35,   -1,   -1,
			   38,   -1,   40,   -1,   -1,   43,   44,   45,   -1,   -1,
			   -1,   -1,   50,   51,   52,   53,   54,   55,   -1,   57,
			   -1,   59,   -1,   -1,   72,   63,   74,   65,   66,   -1,
			   68,   -1,   -1,   -1,   72,   -1,   74,   -1,   86,   77,
			   78,   89,   -1,   -1,   92,   -1,   94,   -1,   86,   87,
			   88,   -1,   -1,   91,   -1,   -1,   -1,   -1,   -1,   -1,
			   98,   15,   16,   17,   18,   19,   20,   21,   22,   -1,
			   -1,   -1,   -1,  111,  112,  113,  114,  115,  116,  117,
			  118,  119,  120,  121,  122,  123,  124,  125,  126,  127,

			  128,  129,  130,  131,  132,  133,  134,   15,   16,   -1,
			   -1,   -1,   -1,   -1,   22,   23,   24,   25,   -1,   27,
			   28,   29,   30,   31,   32,   33,   34,   35,   -1,   -1,
			   38,   -1,   40,   -1,   -1,   43,   44,   45,   46,   -1,
			   -1,   -1,   50,   51,   52,   53,   54,   -1,   -1,   57,
			   60,   59,   -1,   -1,   -1,   63,   -1,   65,   66,   -1,
			   68,   -1,   -1,   -1,   72,   -1,   -1,   -1,   -1,   77,
			   80,   81,   82,   -1,   -1,   -1,   -1,   -1,   86,   -1,
			   -1,   -1,   92,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   98,   -1,   -1,  103,   -1,   -1,   -1,   -1,  108,  109,

			  110,   -1,   -1,  111,  112,  113,  114,  115,  116,  117,
			  118,  119,  120,  121,  122,  123,  124,  125,  126,  127,
			  128,  129,  130,  131,  132,  133,  134,   15,   16,   -1,
			   -1,   -1,   -1,   -1,   22,   23,   24,   25,   -1,   27,
			   28,   29,   30,   31,   32,   33,   34,   35,   -1,   -1,
			   38,   -1,   40,   -1,   -1,   43,   44,   45,   -1,   -1,
			   -1,   -1,   50,   51,   52,   53,   54,   -1,   -1,   57,
			   -1,   59,   46,   -1,   -1,   63,   -1,   65,   66,   -1,
			   68,   -1,   -1,   -1,   72,   -1,   60,   -1,   -1,   77,
			   64,   -1,   80,   -1,   -1,   -1,   -1,   -1,   86,   -1,

			   -1,   -1,   76,   77,   -1,   -1,   -1,   -1,   -1,   -1,
			   98,   -1,   86,   -1,   -1,   89,   -1,   -1,   92,   -1,
			   -1,   -1,   -1,  111,  112,  113,  114,  115,  116,  117,
			  118,  119,  120,  121,  122,  123,  124,  125,  126,  127,
			  128,  129,  130,  131,  132,  133,  134,   15,   16,   -1,
			   -1,   -1,   -1,   -1,   22,   23,   24,   25,   -1,   27,
			   28,   29,   30,   31,   32,   33,   34,   35,   -1,   -1,
			   38,   -1,   40,   -1,   -1,   43,   44,   45,   -1,   -1,
			   -1,   -1,   50,   51,   52,   53,   54,   -1,   -1,   57,
			   -1,   59,   27,   28,   29,   63,   31,   65,   66,   -1,

			   68,   -1,   -1,   -1,   72,   -1,   -1,   -1,   43,   77,
			   -1,   -1,   -1,   -1,   -1,   50,   -1,   -1,   86,   54,
			   -1,   -1,   57,   -1,   -1,   -1,   -1,   -1,   63,   -1,
			   98,   66,   -1,   -1,   -1,   -1,   -1,   72,  106,   -1,
			   -1,   -1,   -1,  111,  112,  113,  114,  115,  116,  117,
			  118,  119,  120,  121,  122,  123,  124,  125,  126,  127,
			  128,  129,  130,  131,  132,  133,  134,   15,   16,   -1,
			   -1,   -1,   -1,   -1,   22,   23,   24,   25,   -1,   27,
			   28,   29,   30,   31,   32,   33,   34,   35,   -1,   -1,
			   38,   -1,   40,   -1,   -1,   43,   44,   45,   -1,   -1,

			   -1,   -1,   50,   51,   52,   53,   54,   -1,   -1,   57,
			   -1,   59,   -1,   -1,   -1,   63,   -1,   65,   66,   -1,
			   68,   -1,   -1,   -1,   72,   -1,   -1,   -1,   -1,   77,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   86,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   98,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,  111,  112,  113,  114,  115,  116,  117,
			  118,  119,  120,  121,  122,  123,  124,  125,  126,  127,
			  128,  129,  130,  131,  132,  133,  134,   15,   16,   -1,
			   -1,   -1,   -1,   -1,   22,   23,   24,   25,   -1,   27,

			   28,   29,   30,   31,   32,   33,   34,   35,   -1,   -1,
			   38,   -1,   40,   -1,   -1,   43,   44,   45,   -1,   -1,
			   -1,   -1,   50,   51,   52,   53,   54,   -1,   -1,   57,
			   -1,   59,   -1,   -1,   -1,   63,   -1,   65,   66,   -1,
			   68,   -1,   -1,   -1,   72,   -1,   -1,   -1,   -1,   77,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   86,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   98,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,  111,  112,  113,  114,  115,  116,  117,
			  118,  119,  120,  121,  122,  123,  124,  125,  126,  127,

			  128,  129,  130,  131,  132,  133,  134,   15,   16,   -1,
			   -1,   -1,   -1,   -1,   22,   23,   24,   25,   -1,   27,
			   28,   29,   30,   31,   32,   33,   34,   35,   -1,   -1,
			   38,   -1,   40,   -1,   -1,   43,   44,   45,   -1,   -1,
			   -1,   -1,   50,   51,   52,   53,   54,   -1,   -1,   57,
			   -1,   59,   -1,   -1,   -1,   63,   -1,   65,   66,   -1,
			   68,   -1,   -1,   -1,   72,   -1,   -1,   -1,   -1,   77,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   86,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   98,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,

			   -1,   -1,   -1,  111,  112,  113,  114,  115,  116,  117,
			  118,  119,  120,  121,  122,  123,  124,  125,  126,  127,
			  128,  129,  130,  131,  132,  133,  134,   15,   16,   -1,
			   -1,   -1,   -1,   -1,   22,   23,   24,   25,   -1,   27,
			   28,   29,   30,   31,   32,   33,   34,   35,   -1,   -1,
			   38,   -1,   40,   -1,   -1,   43,   44,   45,   -1,   -1,
			   -1,   -1,   50,   51,   52,   53,   54,   -1,   -1,   57,
			   -1,   59,   -1,   -1,   -1,   63,   -1,   65,   66,   -1,
			   68,   -1,   -1,   -1,   72,   -1,   -1,   -1,   -1,   77,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   86,   -1,

			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   98,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,  111,  112,  113,  114,  115,  116,  117,
			  118,  119,  120,  121,  122,  123,  124,  125,  126,  127,
			  128,  129,  130,  131,  132,  133,  134,   15,   16,   44,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   28,   29,   30,   31,   32,   33,   34,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   43,   44,   45,   46,   -1,
			   -1,   -1,   -1,   -1,   52,   53,    5,    6,    7,    8,
			    9,   10,   11,   12,   13,   14,   15,   16,   17,   18,

			   19,   20,   21,   22,   72,   -1,   -1,   -1,   -1,   77,
			   -1,   -1,   -1,   -1,   -1,   -1,  111,  112,  113,  114,
			  115,  116,  117,  118,  119,  120,  121,  122,  123,  124,
			  125,  126,  127,  128,  129,  130,  131,  132,  133,  134,
			   -1,   -1,   -1,  111,  112,  113,  114,  115,  116,  117,
			  118,  119,  120,  121,  122,  123,  124,  125,  126,  127,
			  128,  129,  130,  131,  132,  133,  134,   15,   16,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   95,   -1,   -1,   -1,
			   28,   29,   30,   31,   32,   33,   34,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   43,   44,   45,   46,   -1,

			   -1,   -1,   -1,   -1,   52,   53,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   15,   16,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   72,   -1,   -1,   -1,   30,   77,
			   32,   33,   34,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   -1,   43,   44,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   52,   53,   -1,   -1,   56,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,  111,  112,  113,  114,  115,  116,  117,
			  118,  119,  120,  121,  122,  123,  124,  125,  126,  127,
			  128,  129,  130,  131,  132,  133,  134,   89,    6,    7,
			    8,    9,   10,   11,   12,   13,   14,   15,   16,   17,

			   18,   19,   20,   21,   22,    0,    1,   -1,   -1,  111,
			  112,  113,  114,  115,  116,  117,  118,  119,  120,  121,
			  122,  123,  124,  125,  126,  127,  128,  129,  130,  131,
			  132,  133,  134,   28,   29,   -1,   31,   -1,   -1,   -1,
			   -1,   36,   -1,   -1,   39,   -1,   -1,   42,   -1,   44,
			   45,   46,   -1,   48,   -1,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   58,   -1,   60,   61,   -1,   63,   -1,
			   -1,   66,   67,   -1,   -1,   -1,   -1,   72,   -1,   -1,
			   -1,   -1,   77,   -1,   79,   -1,   -1,   -1,   -1,   -1,
			   85,   86,   -1,   -1,   89,   -1,   -1,   92,   -1,   -1,

			   -1,   -1,   97,    5,    6,    7,    8,    9,   10,   11,
			   12,   13,   14,   15,   16,   17,   18,   19,   20,   21,
			   22,   43,   -1,   -1,   46,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   60,   -1,
			   -1,   -1,   64,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
			   -1,   -1,   -1,   -1,   76,   77,   -1,   -1,   60,   -1,
			   -1,   -1,   -1,   -1,   86,   -1,   -1,   89,   -1,   -1,
			   92,   -1,   -1,   -1,   -1,   -1,   -1,   99,   80,   -1,
			   -1,   -1,  104,   -1,   -1,  107,    5,    6,    7,    8,
			    9,   10,   11,   12,   13,   14,   15,   16,   17,   18,

			   19,   20,   21,   22,    5,    6,    7,    8,    9,   10,
			   11,   12,   13,   14,   15,   16,   17,   18,   19,   20,
			   21,   22,   -1,   -1,   -1,   -1,   -1,   46,   -1,   -1,
			   -1,   -1,   -1,   -1,   -1,   36,   -1,   -1,   -1,   -1,
			   41,   42,    5,    6,    7,    8,    9,   10,   11,   12,
			   13,   14,   15,   16,   17,   18,   19,   20,   21,   22,
			    5,    6,    7,    8,    9,   10,   11,   12,   13,   14,
			   15,   16,   17,   18,   19,   20,   21,   22,   -1,   42,
			    7,    8,    9,   10,   11,   12,   13,   14,   15,   16,
			   17,   18,   19,   20,   21,   22,   -1,   42,    5,    6,

			    7,    8,    9,   10,   11,   12,   13,   14,   15,   16,
			   17,   18,   19,   20,   21,   22,  115,  116,  117,  118,
			  119,  120,  121,  122,  123,  124,  125,  126,  127,  128,
			  129,  130,  131,   -1,  133,   42,  111,  112,  113,  114,
			  115,  116,  117,  118,  119,  120,  121,  122,  123,  124,
			  125,  126,  127,  128,  129,  130,  131,  132,  133,  134,
			  111,   -1,  113,   -1,  115,  116,  117,  118,  119,  120,
			  121,  122,  123,  124,  125,  126,  127,  128,  129,  130,
			  131,  132,  133,  134,  115,  116,  117,  118,  119,  120,
			  121,  122,  123,  124,  125,  126,  127,  128,  129,  130,

			  131,  132,  133,  134,    5,    6,    7,    8,    9,   10,
			   11,   12,   13,   14,   15,   16,   17,   18,   19,   20,
			   21,   22,    8,    9,   10,   11,   12,   13,   14,   15,
			   16,   17,   18,   19,   20,   21,   22,    9,   10,   11,
			   12,   13,   14,   15,   16,   17,   18,   19,   20,   21,
			   22, yyDummy>>)
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

	yyFinal: INTEGER is 955
			-- Termination state id

	yyFlag: INTEGER is -32768
			-- Most negative INTEGER

	yyNtbase: INTEGER is 135
			-- Number of tokens

	yyLast: INTEGER is 2950
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



