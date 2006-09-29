indexing
	description: "Tools for handling plural forms"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_PLURAL_TOOLS

	feature
		-- reduction
		reduce(plural_form: INTEGER; quantity: INTEGER):INTEGER is
				--
			require
				valid_plural_form(plural_form)
			do
				--Ugly
				if plural_form = unknown_plural_form then
					--no plural form, can't reduce
					Result := quantity
				elseif plural_form = one_plural_form then
					-- In this case there is no distinction between singular and plural.
					-- Hungarian, Japanese, Chinese, Korean, Turkish. These are nice languages!
					Result := 0
				elseif plural_form = two_plural_forms_singular_one then
					-- Here the singular form is used for 1 and for everything else one plural form is used.
					-- English, most Germanic languages, lots more. Well-behaved!
					if  quantity = 1 then
						Result := 0
					else
						Result := 1
					end
				elseif plural_form = two_plural_forms_singular_one_zero then
					-- Two forms, and the singular is used for one and zero
					-- French and Brazilian Portugese do this. Not that bad.
					if quantity > 1 then
						Result := 1
					else
						Result := 0
					end
				elseif plural_form = three_plural_forms_special_zero then
					-- Three plural forms: there's a special case for zero
					-- Latvian does this - they like life complicated, it seems.

					--  plural=     (n%10==1      &&     n%100!=11) ? 0 : (n != 0 ? 1 : 2);

					-- this makes no sense to me, to be honest.

					if  (quantity \\ 10 = 1) and (quantity \\ 100 /= 11) then
						Result := 0
					elseif quantity /= 0 then
						Result := 1
					else
						Result := 2
					end
				elseif plural_form = three_plural_forms_special_one_two then
					-- Three plural forms with special cases for one and two.
					-- Arabic and Celtic languages like Irish do this (explains why Irish is almost dead)

					-- Plural-Forms: nplurals=3; plural= n==1 ? 0 : n==2 ? 1 : 2;

					if quantity = 1 then
						Result := 0
					elseif quantity = 2 then
						Result := 1
					else
						Result := 2
					end

				elseif plural_form = three_plural_forms_special_twelve_to_nineteen then
					-- Three forms, with a special case for numbers ending in 12 to 19.
					-- This sort of plural is used by Lithuania. Why??

					-- plural=        n%10==1 && n%100!=11 ? 0 :n%10>=2 && (n%100<10 || n%100>=20) ? 1 : 2;

					if  (quantity \\ 10 = 1) and (quantity \\ 100 /= 11) then
						Result := 0
					elseif (quantity \\ 10 >= 2) and ((quantity \\ 100 <10) or (quantity \\ 100 >= 20)) then
						Result := 1
					else
						Result := 2
					end

				elseif plural_form = three_plural_forms_special_slavic then
					-- Three forms, with special cases for numbers that end in 1, 2, 3 and 4 _except_
					-- those that end in 11 to 14. I am _not_ making this up.
					-- A lot of slavic languages do this; no wonder russians drink so much.

					--plural=n%10==1 && n%100!=11 ? 0 :n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2;

					if  (quantity \\ 10 = 1) and (quantity \\ 100 /= 11) then
						Result := 0
					elseif
							(quantity \\ 10 >= 2) and (quantity \\ 10 <= 4)
							and ((quantity \\ 100 <10) or (quantity \\ 100 >= 20))
					then
						Result := 1
					else
						Result := 2
					end

				elseif plural_form = three_plural_forms_special_polish then
					-- Three p

					--         plural=n==1 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2;
					if quantity = 1 then
						Result := 0
					elseif (quantity \\ 10 >= 2) and (quantity\\10 <=4) and ((quantity \\ 100 <10) or (quantity \\ 100 >= 20)) then
						Result := 1
					else
						Result := 2
					end

				elseif plural_form = four_plural_forms_special_slovenian then
					---plural=n%100==1 ? 0 : n%100==2 ? 1 : n%100==3 || n%100==4 ? 2 : 3;
					if (quantity \\ 100 =1) then
						Result := 0
					elseif (quantity \\ 100 = 2) then
						Result := 1
					elseif (quantity \\ 100 = 3) then
						Result := 2
					else
						Result := 3
					end
				end
			end

		valid_plural_form(i:INTEGER):BOOLEAN is
				--
			do
				Result := i <= max_plural_form and i >= min_plural_form
			end

		c_conditional_to_plural_form(conditional:STRING_32):INTEGER is
				-- ugly ugly ugly
			require
				argument_not_void: conditional /= Void
			do
				--remove all spaces from conditional; remove end ";" if present

				if conditional.is_equal ("0") then

				elseif conditional.is_equal ("n!=1") then

				elseif conditional.is_equal ("n>1") then

				elseif conditional.is_equal ("n%10==1&&n%100!=11?0:n!=0?1:2") then

				elseif conditional.is_equal ("n==1?0:n==2?1:2") then

				elseif conditional.is_equal ("n%10==1&&n%100!=11?0:n%10>=2&&(n%100<10||n%100>=20)?1:2") then

				end

			end


	feature
		-- constants
		max_plural_form: INTEGER is 9
		min_plural_form: INTEGER is 0
		unknown_plural_form: INTEGER is 0
		one_plural_form:INTEGER is 1
		two_plural_forms_singular_one:INTEGER is 2
		two_plural_forms_singular_one_zero:INTEGER is 3
		three_plural_forms_special_zero:INTEGER is 4
		three_plural_forms_special_one_two:INTEGER is 5
		three_plural_forms_special_twelve_to_nineteen:INTEGER is 6 --baltic family, ex: lithuanian
		three_plural_forms_special_slavic:INTEGER is 7 --this and below are simplified names because slavic languages are beserk
		three_plural_forms_special_polish:INTEGER is 8 -- I give up on the naming. It's only so we don't have magic numbers.
		four_plural_forms_special_slovenian:INTEGER is 9




end
