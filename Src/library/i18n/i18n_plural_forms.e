indexing
	description: "Class containing the functions to determine which plural form should be used for every language, used by I18N_DATASTRUCTURE"
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_PLURAL_FORMS

create {I18N_DATASTRUCTURE}

	make_with_identifier

feature {NONE} -- Initialization

	make_with_identifier (a_n: INTEGER; a_identifier: STRING_32) is
			-- Initialize `Current'.
			-- NOTE: Should check the identifiers!
			-- PLEASE: see the wiki page for this purpose (http://eiffelsoftware.origo.ethz.ch/index.php/Internationalization)!
		require
			valid_identifier: a_identifier /= Void
			valid_form_number: a_n >= 1 and a_n <= 4
		do
			if a_n = 1 then
				plural_function_agent := agent one_form(?)
			elseif a_n = 2 then
				if a_identifier.is_equal("n != 1;") then
					plural_function_agent := agent two_forms_spec1(?)
				else
					plural_function_agent := agent two_forms_spec01(?)
				end
			elseif a_n = 3 then
				if a_identifier.has_substring("!=") and not a_identifier.has_substring("4") and not a_identifier.has_substring("20") then
					plural_function_agent := agent three_forms_spec0(?)
				elseif not a_identifier.has_substring("!=") and not a_identifier.has_substring("4") then
					plural_function_agent := agent three_forms_spec1_spec2(?)
				elseif a_identifier.has_substring("20") and not a_identifier.has_substring("4") then
					plural_function_agent := agent three_forms_spec1_spec1_29(?)
				elseif a_identifier.has_substring("!=") then
					plural_function_agent := agent three_forms_spec1_spec24_spec1_14(?)
				else
					plural_function_agent := agent three_forms_spec1_spec24(?)
				end
			elseif a_n = 4 then
				plural_function_agent := agent four_forms_spec1_spec02_spec0304(?)
			else
				plural_function_agent := agent two_forms_spec1(?)
			end
		ensure
			plural_function_agent_set: plural_function_agent /= Void
		end

feature -- Access

	get_plural_form (a_n: INTEGER): INTEGER is
			-- Which plural form should be used for the number a_n?
		do
			Result := plural_function_agent.item([a_n])
		ensure
			Result >= 1 and Result <= 4
		end

feature {NONE} -- Conversion

	one_form (a_n: INTEGER): INTEGER is
			-- Which form of plural should be used?
			-- Languages: Finno-Ugric family, Hungarian, Asian family,
			--            Japanese, Korean Turkic/Altaic family, Turkish
		do
			Result := 1
		ensure
			Result = 1
		end

	two_forms_spec1 (a_n: INTEGER): INTEGER is
			-- Which form of plural should be used?
			-- Languages: Germanic family, Danish, Dutch, English, German,
			--            Norwegian, Swedish, Finno-Ugric family, Estonian,
			--            Finnish, Latin/Greek family, Greek, Semitic family,
			--            Hebrew, Romanic family, Italian, Portuguese, Spanish,
			--            Artificial, Esperanto
		do
			if a_n = 1 then
				Result := 1
			else
				Result := 2
			end
		ensure
			Result >= 1 and Result <= 2
		end

	two_forms_spec01 (a_n: INTEGER): INTEGER is
			-- Which form of plural should be used?
			-- Languages: Romanic family, French, Brazilian Portuguese
		do
			if a_n > 1 then
				Result := 1
			else
				Result := 2
			end
		ensure
			Result >= 1 and Result <= 2
		end

	three_forms_spec0 (a_n: INTEGER): INTEGER is
			-- Which form of plural should be used?
			-- Languages: Baltic family, Latvian
		do
			if a_n \\ 10 = 1 and a_n \\ 100 /= 11 then
				Result := 1
			elseif a_n /= 0 then
				Result := 2
			else
				Result := 3
			end
		ensure
			Result >= 1 and Result <= 3
		end

	three_forms_spec1_spec2 (a_n: INTEGER): INTEGER is
			-- Which form of plural should be used?
			-- Languages: Celtic, Gaeilge (Irish)
		do
			if a_n = 1 then
				Result := 1
			elseif a_n = 2 then
				Result := 2
			else
				Result := 3
			end
		ensure
			Result >= 1 and Result <= 3
		end

	three_forms_spec1_spec1_29 (a_n: INTEGER): INTEGER is
			-- Which form of plural should be used?
			-- Languages: Baltic family, Lithuanian
		do
			if a_n \\ 10 = 1 and a_n \\ 100 /= 11 then
				Result := 1
			elseif a_n \\ 10 >= 2 and (a_n \\ 100 < 10 or a_n \\ 100 >= 20) then
				Result := 2
			else
				Result := 3
			end
		ensure
			Result >= 1 and Result <= 3
		end

	three_forms_spec1_spec24_spec1_14 (a_n: INTEGER): INTEGER is
			-- Which form of plural should be used?
			-- Languages: Slavic family, Croatian, Czech, Russian, Slovak, Ukrainian
		do
			if a_n \\ 10 = 1 and a_n \\ 100 /= 11 then
				Result := 1
			elseif a_n \\ 10 >= 2 and a_n \\ 10 <= 4 and (a_n \\ 100 < 10 or a_n \\ 100 >= 20) then
				Result := 2
			else
				Result := 3
			end
		ensure
			Result >= 1 and Result <= 3
		end

	three_forms_spec1_spec24 (a_n: INTEGER): INTEGER is
			-- Which form of plural should be used?
			-- Languages: Slavic family, Polish
		do
			if a_n = 1 then
				Result := 1
			elseif a_n \\ 10 >= 2 and a_n \\ 10 <= 4 and (a_n \\ 100 < 10 or a_n \\ 100 >= 20) then
				Result := 2
			else
				Result := 3
			end
		ensure
			Result >= 1 and Result <= 3
		end

	four_forms_spec1_spec02_spec0304 (a_n: INTEGER): INTEGER is
			-- Which form of plural should be used?
			-- Languages: Slavic family, Slovenian
		do
			if a_n \\ 100 = 1 then
				Result := 1
			elseif a_n \\ 100 = 2 then
				Result := 2
			elseif a_n \\ 100 = 3 or a_n \\ 100 = 4 then
				Result := 3
			else
				Result := 4
			end
		ensure
			Result >= 1 and Result <= 4
		end

feature {NONE} -- Implementation

	plural_function_agent: FUNCTION[I18N_PLURAL_FORMS, TUPLE[INTEGER], INTEGER]
		-- Agent to plural form function

invariant

	plural_function_agent_set: plural_function_agent /= Void
		-- Should always be set

end
