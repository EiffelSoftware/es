note
	description: "Summary description for {SCOOP_INFIX_PREFIX}."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_INFIX_PREFIX

feature -- infix and prefix text names

	non_infix_text (a_symbol: STRING): STRING is
			-- Literal text of this token
		require
			a_symbol_not_void: a_symbol /= Void
		local
			l_str: STRING
		do
			if a_symbol.is_equal (te_semicolon) then Result := once "te_semicolon"
			elseif a_symbol.is_equal (te_colon) then Result := once "te_colon"
			elseif a_symbol.is_equal (te_comma) then Result := once "te_comma"
			elseif a_symbol.is_equal (te_dotdot) then Result := once "te_dotdot"
			elseif a_symbol.is_equal (te_question) then Result := once "te_question"
			elseif a_symbol.is_equal (te_tilde) then Result := once "te_tilde"
			elseif a_symbol.is_equal (te_not_tilde) then Result := once "te_not_tilde"
			elseif a_symbol.is_equal (te_curlytilde) then Result := once "te_curlytilde"
			elseif a_symbol.is_equal (te_dot) then Result := once "te_dot"
			elseif a_symbol.is_equal (te_address) then Result := once "te_address"
			elseif a_symbol.is_equal (te_assignment) then Result := once "te_assignment"
			elseif a_symbol.is_equal (te_accept) then Result := once "te_accept"
			elseif a_symbol.is_equal (te_eq) then Result := once "te_eq"
			elseif a_symbol.is_equal (te_lt) then Result := once "te_lt"
			elseif a_symbol.is_equal (te_gt) then Result := once "te_gt"
			elseif a_symbol.is_equal (te_le) then Result := once "te_le"
			elseif a_symbol.is_equal (te_ge) then Result := once "te_ge"
			elseif a_symbol.is_equal (te_ne) then Result := once "te_ne"
			elseif a_symbol.is_equal (te_lparan) then Result := once "te_lparan"
			elseif a_symbol.is_equal (te_rparan) then Result := once "te_rparan"
			elseif a_symbol.is_equal (te_lcurly) then Result := once "te_lcurly"
			elseif a_symbol.is_equal (te_rcurly) then Result := once "te_rcurly"
			elseif a_symbol.is_equal (te_lsqure) then Result := once "te_lsqure"
			elseif a_symbol.is_equal (te_rsqure) then Result := once "te_rsqure"
			elseif a_symbol.is_equal (te_plus) then Result := once "te_plus"
			elseif a_symbol.is_equal (te_minus) then Result := once "te_minus"
			elseif a_symbol.is_equal (te_star) then Result := once "te_star"
			elseif a_symbol.is_equal (te_slash) then Result := once "te_slash"
			elseif a_symbol.is_equal (te_power) then Result := once "te_power"
			elseif a_symbol.is_equal (te_constrain) then Result := once "te_constrain"
			elseif a_symbol.is_equal (te_bang) then Result := once "te_bang"
			elseif a_symbol.is_equal (te_larray) then Result := once "te_larray"
			elseif a_symbol.is_equal (te_rarray) then Result := once "te_rarray"
			elseif a_symbol.is_equal (te_div) then Result := once "te_div"
			elseif a_symbol.is_equal (te_mod) then Result := once "te_mod"
			elseif a_symbol.is_equal (te_underscore) then Result := once "te_underscore"
			elseif a_symbol.is_equal (te_at_symbol) then Result := once "te_at_symbol"
			elseif a_symbol.is_equal (te_number_sign) then Result := once "te_number_sign"
			elseif a_symbol.is_equal (te_backslash) then Result := once "te_backslash"
			elseif a_symbol.is_equal (te_vertical_bar) then Result := once "te_vertical_bar"
			elseif a_symbol.is_equal (te_ampersand) then Result := once "te_ampersand"
			elseif a_symbol.is_equal (te_dollar_sign) then Result := once "te_dollar_sign"
			elseif a_symbol.is_equal (te_single_quote) then Result := once "te_single_quote"
			elseif a_symbol.is_equal (te_grave_accent) then Result := once "te_grave_accent"
			else
				-- `a_symbol' might be a string like "and", so just return it.
				-- E.g. "and" results in "infix__and (other ..)" or "prefix__and".
				-- `a_symbol' might contain special characters -> replace it!
				-- E.g. "|..|" results in "infix__te_vertical_bar_te_dotdot_te_vertical_bar (other ..)"

				create l_str.make_from_string (a_symbol)

				-- replace substrings of length 2
				if l_str.has_substring (te_dotdot) then l_str.replace_substring_all (te_dotdot, "te_dotdot_") end
				if l_str.has_substring (te_not_tilde) then l_str.replace_substring_all (te_not_tilde, "te_not_tilde_") end
				if l_str.has_substring (te_curlytilde) then l_str.replace_substring_all (te_curlytilde, "te_curlytilde_") end
				if l_str.has_substring (te_assignment) then l_str.replace_substring_all (te_assignment, "te_assignment_") end
				if l_str.has_substring (te_accept) then l_str.replace_substring_all (te_accept, "te_accept_") end
				if l_str.has_substring (te_le) then l_str.replace_substring_all (te_le, "te_le_") end
				if l_str.has_substring (te_ge) then l_str.replace_substring_all (te_ge, "te_ge_") end
				if l_str.has_substring (te_ne) then l_str.replace_substring_all (te_ne, "te_ne_") end
				if l_str.has_substring (te_constrain) then l_str.replace_substring_all (te_constrain, "te_constrain_") end
				if l_str.has_substring (te_larray) then l_str.replace_substring_all (te_larray, "te_larray_") end
				if l_str.has_substring (te_rarray) then l_str.replace_substring_all (te_rarray, "te_rarray_") end
				if l_str.has_substring (te_div) then l_str.replace_substring_all (te_div, "te_div_") end
				if l_str.has_substring (te_mod) then l_str.replace_substring_all (te_mod, "te_mod_")  end

				-- replace substrings of length 1
				if l_str.has_substring (te_space) then l_str.replace_substring_all (te_space, "te_space_") end
				if l_str.has_substring (te_semicolon) then l_str.replace_substring_all (te_semicolon, "te_semicolon_") end
				if l_str.has_substring (te_colon) then l_str.replace_substring_all (te_colon, "te_colon_") end
				if l_str.has_substring (te_comma) then l_str.replace_substring_all (te_comma, "te_comma_") end
				if l_str.has_substring (te_question) then l_str.replace_substring_all (te_question, "te_question_") end
				if l_str.has_substring (te_tilde) then l_str.replace_substring_all (te_tilde, "te_tilde_") end
				if l_str.has_substring (te_dot) then l_str.replace_substring_all (te_dot, "te_dot_") end
				if l_str.has_substring (te_address) then l_str.replace_substring_all (te_address, "te_address_") end
				if l_str.has_substring (te_eq) then l_str.replace_substring_all (te_eq, "te_eq_") end
				if l_str.has_substring (te_lparan) then l_str.replace_substring_all (te_lparan, "te_lparan_") end
				if l_str.has_substring (te_rparan) then l_str.replace_substring_all (te_rparan, "te_rparan_") end
				if l_str.has_substring (te_lcurly) then l_str.replace_substring_all (te_lcurly, "te_lcurly_") end
				if l_str.has_substring (te_rcurly) then l_str.replace_substring_all (te_rcurly, "te_rcurly_") end
				if l_str.has_substring (te_lsqure) then l_str.replace_substring_all (te_lsqure, "te_lsqure_") end
				if l_str.has_substring (te_rsqure) then l_str.replace_substring_all (te_rsqure, "te_rsqure_") end
				if l_str.has_substring (te_plus) then l_str.replace_substring_all (te_plus, "te_plus_") end
				if l_str.has_substring (te_minus) then l_str.replace_substring_all (te_minus, "te_minus_") end
				if l_str.has_substring (te_star) then l_str.replace_substring_all (te_star, "te_star_") end
				if l_str.has_substring (te_slash) then l_str.replace_substring_all (te_slash, "te_slash_") end
				if l_str.has_substring (te_power) then l_str.replace_substring_all (te_power, "te_power_") end
				if l_str.has_substring (te_bang) then l_str.replace_substring_all (te_bang, "te_bang_") end
				if l_str.has_substring (te_lt) then l_str.replace_substring_all (te_lt, "te_lt_") end
				if l_str.has_substring (te_gt) then l_str.replace_substring_all (te_gt, "te_gt_") end
				if l_str.has_substring (te_underscore) then l_str.replace_substring_all (te_underscore, "te_underscore_") end
				if l_str.has_substring (te_at_symbol) then l_str.replace_substring_all (te_at_symbol, "te_at_symbol_") end
				if l_str.has_substring (te_number_sign) then l_str.replace_substring_all (te_number_sign, "te_number_sign_") end
				if l_str.has_substring (te_backslash) then l_str.replace_substring_all (te_backslash, "te_backslash_") end
				if l_str.has_substring (te_vertical_bar) then l_str.replace_substring_all (te_vertical_bar, "te_vertical_bar_") end
				if l_str.has_substring (te_ampersand) then l_str.replace_substring_all (te_ampersand, "te_ampersand_") end
				if l_str.has_substring (te_dollar_sign) then l_str.replace_substring_all (te_dollar_sign, "te_dollar_sign_") end
				if l_str.has_substring (te_single_quote) then l_str.replace_substring_all (te_single_quote, "te_single_quote_") end
				if l_str.has_substring (te_grave_accent) then l_str.replace_substring_all (te_grave_accent, "te_grave_accent_") end

				Result := l_str
			end
		end

feature {NONE} -- String constants

	te_semicolon: STRING is
			-- `Result' is STRING constant named te_semicolon.
		once
			Result := ";"
		end

	te_colon: STRING is
			-- `Result' is STRING constant named te_colon.
		once
			Result := ":"
		end

	te_comma: STRING is
			-- `Result' is STRING constant named te_comma.
		once
			Result := ","
		end

	te_dotdot: STRING is
			-- `Result' is STRING constant named te_dotdot.
		once
			Result := ".."
		end

	te_question: STRING is
			-- `Result' is STRING constant named te_question.
		once
			Result := "?"
		end

	te_tilde: STRING is
			-- `Result' is STRING constant named te_tilde.
		once
			Result := "~"
		end

	te_not_tilde: STRING is
			-- `Result' is STRING constant named te_not_tilde.
		once
			Result := "/~"
		end

	te_curlytilde: STRING is
			-- `Result' is STRING constant named te_curlytilde.
		once
			Result := "}~"
		end

	te_dot: STRING is
			-- `Result' is STRING constant named te_dot.
		once
			Result := "."
		end

	te_address: STRING is
			-- `Result' is STRING constant named te_address.
		once
			Result := "$"
		end

	te_assignment: STRING is
			-- `Result' is STRING constant named te_assignment.
		once
			Result := ":="
		end

	te_accept: STRING is
			-- `Result' is STRING constant named te_accept.
		once
			Result := "?="
		end

	te_eq: STRING is
			-- `Result' is STRING constant named te_eq.
		once
			Result := "="
		end

	te_lt: STRING is
			-- `Result' is STRING constant named te_lt.
		once
			Result := "<"
		end

	te_gt: STRING is
			-- `Result' is STRING constant named te_gt.
		once
			Result := ">"
		end

	te_le: STRING is
			-- `Result' is STRING constant named te_le.
		once
			Result := "<="
		end

	te_ge: STRING is
			-- `Result' is STRING constant named te_ge.
		once
			Result := ">="
		end

	te_ne: STRING is
			-- `Result' is STRING constant named te_ne.
		once
			Result := "/="
		end

	te_lparan: STRING is
			-- `Result' is STRING constant named te_lparan.
		once
			Result := "("
		end

	te_rparan: STRING is
			-- `Result' is STRING constant named te_rparan.
		once
			Result := ")"
		end

	te_lcurly: STRING is
			-- `Result' is STRING constant named te_lcurly.
		once
			Result := "{"
		end

	te_rcurly: STRING is
			-- `Result' is STRING constant named te_rcurly.
		once
			Result := "}"
		end

	te_lsqure: STRING is
			-- `Result' is STRING constant named te_lsqure.
		once
			Result := "["
		end

	te_rsqure: STRING is
			-- `Result' is STRING constant named te_rsqure.
		once
			Result := "]"
		end

	te_plus: STRING is
			-- `Result' is STRING constant named te_plus.
		once
			Result := "+"
		end

	te_minus: STRING is
			-- `Result' is STRING constant named te_minus.
		once
			Result := "-"
		end

	te_star: STRING is
			-- `Result' is STRING constant named te_star.
		once
			Result := "*"
		end

	te_slash: STRING is
			-- `Result' is STRING constant named te_slash.
		once
			Result := "/"
		end

	te_power: STRING is
			-- `Result' is STRING constant named te_power.
		once
			Result := "^"
		end

	te_constrain: STRING is
			-- `Result' is STRING constant named te_constrain.
		once
			Result := "->"
		end

	te_bang: STRING is
			-- `Result' is STRING constant named te_bang.
		once
			Result := "!"
		end

	te_larray: STRING is
			-- `Result' is STRING constant named te_larray.
		once
			Result := "<<"
		end

	te_rarray: STRING is
			-- `Result' is STRING constant named te_rarray.
		once
			Result := ">>"
		end

	te_div: STRING is
			-- `Result' is STRING constant named te_div.
		once
			Result := "//"
		end

	te_mod: STRING is
			-- `Result' is STRING constant named te_mod.
		once
			Result := "\\"
		end

	te_underscore: STRING is
			-- `Result' is STRING constant named te_underscore.
		once
			Result := "_"
		end

	te_at_symbol: STRING is
			-- `Result' is STRING constant named te_at_symbol.
		once
			Result := "@"
		end

	te_number_sign: STRING is
			-- `Result' is STRING constant named te_number_sign.
		once
			Result := "#"
		end

	te_backslash: STRING is
			-- `Result' is STRING constant named te_backslash.
		once
			Result := "\"
		end

	te_vertical_bar: STRING is
			-- `Result' is STRING constant named te_vertical_bar.
		once
			Result := "|"
		end

	te_ampersand: STRING is
			-- `Result' is STRING constant named te_ampersand.
		once
			Result := "&"
		end

	te_dollar_sign: STRING is
			-- `Result' is STRING constant named te_dollar_sign.
		once
			Result := "$"
		end

	te_single_quote: STRING is
			-- `Result' is STRING constant named te_single_quote.
		once
			Result := "'"
		end

	te_grave_accent: STRING is
			-- `Result' is STRING constant named te_grave_accent.
		once
			Result := "`"
		end

	te_space: STRING is
			-- `Result' is STRING constant named te_space.
		once
			Result := " "
		end

-- List of all symbols:
-- --------------------
--	te_semicolon
--	te_colon
--	te_comma
--	te_dotdot
--	te_question
--	te_tilde
--	te_not_tilde
--	te_curlytilde
--	te_dot
--	te_address
--	te_assignment
--	te_accept
--	te_eq
--	te_lt
--	te_gt
--	te_le
--	te_ge
--	te_ne
--	te_lparan
--	te_rparan
--	te_lcurly
--	te_rcurly
--	te_lsqure
--	te_rsqure
--	te_plus
--	te_minus
--	te_star
--	te_slash
--	te_power
--	te_constrain
--	te_bang
--	te_larray
--	te_rarray
--	te_div
--	te_mod
--	te_underscore
--	te_at_symbol
--	te_number_sign
--	te_backslash
--	te_vertical_bar
--	te_ampersand
--	te_dollar_sign
--	te_single_quote
--	te_grave_accent

note
	copyright:	"Copyright (c) 1984-2010, Eiffel Software"
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
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end -- class SCOOP_INFIX_PREFIX
