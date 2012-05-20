%{
note
	description:"Scanners for textual BON parsers."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author:     "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk> based on work by Arnaud Pichery and Eric Bezault"
	date:       "$Date: 2011-10-14 13:57:27 +0200 (Fre, 14 Okt 2011) $"
	revision:   "$Revision: 87470 $"

class EDITOR_TEXTUAL_BON_SCANNER

inherit

	EDITOR_TEXTUAL_BON_SCANNER_SKELETON	

create
	make
%}

%x VERBATIM_STR1
%option outfile="editor_textual_bon_scanner.e"

D		([0-9])
B		([0-1])
O		([0-7])
H		([0-9A-Fa-f])
A		([0-9A-Za-z])

-- NON_ASCII: Identical to all code points of Unicode excluding 0 - 127.

UTF8_char	{UTF8_1}|{UTF8_2}|{UTF8_3}|{UTF8_4}
NON_ASCII	{UTF8_2}|{UTF8_3}|{UTF8_4}
UTF8_1		[\x00-\x7F]
UTF8_2		[\xC2-\xDF]{UTF8_tail}
UTF8_3		\xE0[\xA0-\xBF]{UTF8_tail})|([\xE1-\xEC]({UTF8_tail}{2,2}))|(\xED[\x80-\x9F]{UTF8_tail})|([\xEE-\xEF]({UTF8_tail}{2,2})
UTF8_4		\xF4[\x80-\x8F]({UTF8_tail}{2,2}))|([\xF1-\xF3]({UTF8_tail}{3,3}))|(\xF4[\x80-\x8F]({UTF8_tail}{2,2})
UTF8_tail	[\x80-\xBF]

%%

----------/** Separators **/----------------------------------------------------

[\r]+				-- Ignore carriage return
[ ]+				{
					curr_token := new_space (text_count)
					update_token_list
					}
[\t]+				{
					if not in_comments then
						curr_token := new_tabulation (text_count)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					}
\n+					{
					from i_ := 1 until i_ > text_count loop
						curr_token := new_eol
						update_token_list
						i_ := i_ + 1
					end
					in_comments := False
					}


----------/** BON comments **/-----------------------------------------------

"--"				{ 
						-- comments
					curr_token := new_comment (text)
					in_comments := True	
					update_token_list					
				}

----------/** BON symbols **/------------------------------------------------

"."					|
";"					|
","					|
":"					|
"!"					|
"("					|
")"					|
"{"					|
"}"					|
"["					|
"]"					|
"$"					{
						-- Symbols
					if not in_comments then
						curr_token := new_text (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					}

"//"				|
"\\\\"				|
"/="				|
">="				|
"<="				|
"->"				|
"-"					|
"+"					|
"*"					|
"/"					|
"^"					|
"="					|
">"					|
"<"					|
"<->"				{ 
						-- Operator Symbol
					if not in_comments then
						curr_token := new_operator (text)					
					else
						curr_token := new_comment (text)
					end
					update_token_list
					}

----------/** Reserved words **/------------------------------------------------

action					|
and					    |
calls					|
class					|
class_chart				|
client				    |
cluster					|
cluster_chart			|
command					|
component			    |
concatenator			|
constraint		        |
creates			        |
creation_chart			|
creator		            |
Current					|
deferred				|
delta				    |
description				|
dictionary				|
dynamic_diagram		    |
effective				|
end		                |
ensure					|
event			        |
event_chart				|
exists				    |
explanation				|
false			        |
feature				    |
for_all			        |
incoming			    |
indexing	            |
infix					|
inherit					|
interfaced				|
invariant				|
involves		        |
it_holds				|
keyword_prefix			|
member_of				|
nameless	            |
not		                |
object	                |
object_group		    |
object_stack			|
old			            |
or				        |
outgoing				|
part					|
persistent				|
prefix		            |
query					|
require					|
Result		            |
reused				    |
root					|
scenario			    |
scenario_chart			|
static_diagram			|
string_marks			|				
such_that               |
system_chart            |
true                    |
Void                    |
xor                     {
										-- Keyword
										if not in_comments then
											curr_token := new_keyword (text)
										else
											curr_token := new_comment (text)
										end
										update_token_list
										}


----------/** Eiffel identifiers **/--------------------------------------------

([A-Z]|{NON_ASCII})([A-Z0-9_]|{NON_ASCII})*							{
										if not in_comments then
											if is_current_group_valid then
												tmp_classes := current_group.class_by_name (text, True)
												if not tmp_classes.is_empty then
													curr_token := new_class (text)
													curr_token.set_pebble (stone_of_class (tmp_classes.first))
												else
													curr_token := new_text (text)
												end
											else
												curr_token := new_text (text)
											end							
										else
											curr_token := new_comment (text)
										end
										update_token_list
										}


([a-zA-Z]|{NON_ASCII})([a-zA-Z0-9_]|{NON_ASCII})*					{
										if not in_comments then
											curr_token := new_text (text)											
										else
											curr_token := new_comment (text)
										end
										update_token_list
										}


----------/** Eiffel free operators **/-----------------------------------------

[@#|&][^%" \t\r\n]*						{
										if not in_comments then
											curr_token := new_text (text)										
										else
											curr_token := new_comment (text)
										end
										update_token_list
										}
	-- Note: Accepts non-printable characters as well,
	-- provided that they are not break characters.


----------/** Eiffel characters **/---------------------------------------------

\'([^%\n']|{NON_ASCII})\'	|
\'%A\'				|
\'%B\'				|
\'%C\'				|
\'%D\'				|
\'%F\'				|
\'%H\'				|
\'%L\'				|
\'%N\'				|
\'%Q\'				|
\'%R\'				|
\'%S\'				|
\'%T\'				|
\'%U\'				|
\'%V\'				|
\'%%\'				|
\'%\'\'				|
\'%\"\'				|
\'%\(\'				|
\'%\)\'				|
\'%<\'				|
\'%>\'				{
					if not in_comments then
						curr_token := new_character (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					}

\'%\/[0-9]+\/\'		{
					if not in_comments then
						code_ := text_substring (4, text_count - 2).to_integer
						if code_ > {CHARACTER}.Max_value then
							-- Character error. Consedered as text.
							curr_token := new_text (text)
						else
							curr_token := new_character (text)
						end						
					else
						curr_token := new_comment (text)
					end
					update_token_list
					}

\'([^' \t\r\n]|{NON_ASCII})+		{
					-- Character error. Catch-all rules (no backing up)
					if not in_comments then
						curr_token := new_text (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					}


----------/** Eiffel strings **/------------------------------------------------

-- We accept here a fully formed Eiffel string which is complete, i.e:
-- 1 - whatever but `"' and '\n' except '%"' which is enclosed in
--     between (","), (",%), (%,%) or (%,")
-- We also accept beginning of a string, i.e:
-- 2 - whatever that start with either `"' or `%' and that does
--     not finishes with a `"' or `%'. Because we needed to support
--     the special character such as %N, %T,... we have to list all of
--     them in the second expression.

 \"([^\n"%]|{NON_ASCII})*\[/[ \t\r]*	{
 				if not in_comments then
						-- Verbatim string opener.
					curr_token := new_string (text)
					update_token_list
					in_verbatim_string := True
					start_of_verbatim_string := True
					set_start_condition (VERBATIM_STR1)
				else
					curr_token := new_comment (text)
					update_token_list
				end
			}

\"([^\n"%]|{NON_ASCII})*\{/[ \t\r]*	{
				if not in_comments then
						-- Verbatim string opener.
					curr_token := new_string (text)
					update_token_list
					in_verbatim_string := True
					start_of_verbatim_string := True
					set_start_condition (VERBATIM_STR1)
				else
					curr_token := new_comment (text)
					update_token_list
				end				
			}

<VERBATIM_STR1>{
	[\r]+					-- Ignore carriage return
	[ \t\r]*\]([^%\n"]|{NON_ASCII})*\" 	{
							-- Verbatim string closer, possibly.
						curr_token := new_string (text)						
						end_of_verbatim_string := True
						in_verbatim_string := False
						set_start_condition (INITIAL)
						update_token_list
					}
	
	[ \t\r]*\}([^%\n"]|{NON_ASCII})*\" 	{
							-- Verbatim string closer, possibly.
						curr_token := new_string (text)						
						end_of_verbatim_string := True
						in_verbatim_string := False
						set_start_condition (INITIAL)
						update_token_list
					}	
	
	[ ]+				{
						curr_token := new_space (text_count)
						update_token_list						
					}
					
	[\t]+				{						
						curr_token := new_tabulation (text_count)
						update_token_list						
					}
					
	\n+				{
						from i_ := 1 until i_ > text_count loop
							curr_token := new_eol
							update_token_list
							i_ := i_ + 1
						end						
					}
					
	([^\n\ \t]|{NON_ASCII})*			{
						curr_token := new_string (text)
						update_token_list
					}
	}

[%\"]([^\n\"]|{NON_ASCII}|%\")*(\"|%)	|
[%\"]([^\n\"\%]|{NON_ASCII}|%\"|%A|%B|%C\%D|%F|%H|%L|%N|%Q|%R|%S|%T|%U|%V|%%|%\'|%\(|%\)|%<|%>|%\/[0-9]{1,3}\/)*		{
					-- Eiffel String
					if not in_comments then						
						curr_token := new_string (text)
					else
						curr_token := new_comment (text)
					end
					update_token_list
					}

----------/** Eiffel bits **/---------------------------------------------------

[0-1]+[bB]			{
					-- Eiffel Bit
					if not in_comments then
						curr_token := new_number (text)						
					else
						curr_token := new_comment (text)
					end
					update_token_list
					}
						
----------/** Eiffel integers **/-----------------------------------------------

{D}(({D}|_)*{D})?			|
0[xX]{H}(({H}|_)*{H})?			|
0[cC]{O}(({O}|_)*{O})?			|
0[bB]{B}(({B}|_)*{B})?			{
						-- Eiffel Integer
						if not in_comments then
							curr_token := new_number (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						}


0[xX]{A}(({A}|_)*{A})?			|
0[cC]{A}(({A}|_)*{A})?			|
0[bB]{A}(({A}|_)*{A})?			|
{D}(({A}|_)*{A})?			{
						-- Bad Eiffel Integer
						if not in_comments then
							curr_token := new_text (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						}

---------/** Eiffel reals **/---------------------------------------------------

[0-9]+\./[^.0-9]					|
[0-9]+\.[0-9]*[eE][+-]?[0-9]+		|
[0-9]*\.[0-9]+([eE][+-]?[0-9]+)?	|
[0-9]{1,3}(_[0-9]{3})+\./[^.0-9]	|
[0-9]{1,3}(_[0-9]{3})*\.([0-9]{1,3}(_[0-9]{3})*)?[eE][+-]?[0-9]{1,3}(_[0-9]{3})*	|
([0-9]{1,3}(_[0-9]{3})*)?\.[0-9]{1,3}(_[0-9]{3})*([eE][+-]?[0-9]{1,3}(_[0-9]{3})*)?	{
							-- Eiffel reals & doubles
						if not in_comments then		
							curr_token := new_number (text)
						else
							curr_token := new_comment (text)
						end
						update_token_list
						}

		-- The first and fourth expressions use a trailing context
		-- to make sure that an integer followed by two dots is
		-- not recognized as a real followed by a dot.

----------/** Comments enable/disable **/-----------------------------------------

\`([^%\n']|{NON_ASCII})+\'					{
					curr_token := new_text (text)
					update_token_list
					}

--------------------------------------------------------------------------------

<<EOF>>			terminate
.				{
					-- Error (considered as text)
				if not in_comments then
					curr_token := new_text (text)
				else
					curr_token := new_comment (text)
				end
				update_token_list
				}

--------------------------------------------------------------------------------
%%

note
	copyright:	"Copyright (c) 1984-2011, Eiffel Software"
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
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end -- EDITOR_TEXTUAL_BON_SCANNER
