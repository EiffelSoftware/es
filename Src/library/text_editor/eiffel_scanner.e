indexing

	description:

		"Scanners for Eiffel parsers"

	author:     "Eric Bezault <ericb@gobo.demon.co.uk>"
	copyright:  "Copyright (c) 1998, Eric Bezault"
	date:       "$Date$"
	revision:   "$Revision$"

	note: "there are still some problems with this scanner %
			%to be resolved. (especially with manifest strings). - Andreas Leitner"

class EIFFEL_SCANNER

inherit

	YY_FULL_SCANNER_SKELETON
		rename
			make as make_compressed_scanner_skeleton,
			reset as reset_compressed_scanner_skeleton
		end

	EIFFEL_TOKENS
		export
			{NONE} all
		end

	UT_CHARACTER_CODES
		export
			{NONE} all
		end

	KL_IMPORTED_INTEGER_ROUTINES
	KL_IMPORTED_STRING_ROUTINES
	KL_SHARED_PLATFORM
	KL_SHARED_EXCEPTIONS
	KL_SHARED_ARGUMENTS

creation

	make, execute, benchmark

feature -- Status report

	valid_start_condition (sc: INTEGER): BOOLEAN is
			-- Is `sc' a valid start condition?
		do
			Result := (INITIAL <= sc and sc <= IN_STR)
		end

feature {NONE} -- Implementation

	yy_build_tables is
			-- Build scanner tables.
		do
			yy_nxt := yy_nxt_template
			yy_accept := yy_accept_template
		end

	yy_execute_action (yy_act: INTEGER) is
			-- Execute semantic action.
		do
if yy_act <= 94 then
if yy_act <= 47 then
if yy_act <= 24 then
if yy_act <= 12 then
if yy_act <= 6 then
if yy_act <= 3 then
if yy_act <= 2 then
if yy_act = 1 then
--|#line 54 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 54")
end
move (text_count) -- Ignore separators
else
--|#line 55 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 55")
end
move (text_count); eif_lineno := eif_lineno + text_count
end
else
--|#line 60 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 60")
end
move (text_count); last_token := E_COMMENT -- Ignore comments
end
else
if yy_act <= 5 then
if yy_act = 4 then
--|#line 61 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 61")
end
move (text_count); last_token := E_COMMENT; eif_lineno := eif_lineno + 1
else
--|#line 66 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 66")
end
move (text_count); last_token := Minus_code
end
else
--|#line 67 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 67")
end
move (text_count); last_token := Plus_code
end
end
else
if yy_act <= 9 then
if yy_act <= 8 then
if yy_act = 7 then
--|#line 68 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 68")
end
move (text_count); last_token := Star_code
else
--|#line 69 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 69")
end
move (text_count); last_token := Slash_code
end
else
--|#line 70 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 70")
end
move (text_count); last_token := Caret_code
end
else
if yy_act <= 11 then
if yy_act = 10 then
--|#line 71 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 71")
end
move (text_count); last_token := Equal_code
else
--|#line 72 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 72")
end
move (text_count); last_token := Greater_than_code
end
else
--|#line 73 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 73")
end
move (text_count); last_token := Less_than_code
end
end
end
else
if yy_act <= 18 then
if yy_act <= 15 then
if yy_act <= 14 then
if yy_act = 13 then
--|#line 74 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 74")
end
move (text_count); last_token := Dot_code
else
--|#line 75 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 75")
end
move (text_count); last_token := Semicolon_code
end
else
--|#line 76 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 76")
end
move (text_count); last_token := Comma_code
end
else
if yy_act <= 17 then
if yy_act = 16 then
--|#line 77 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 77")
end
move (text_count); last_token := Colon_code
else
--|#line 78 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 78")
end
move (text_count); last_token := Exclamation_code
end
else
--|#line 79 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 79")
end
move (text_count); last_token := Left_parenthesis_code
end
end
else
if yy_act <= 21 then
if yy_act <= 20 then
if yy_act = 19 then
--|#line 80 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 80")
end
move (text_count); last_token := Right_parenthesis_code
else
--|#line 81 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 81")
end
move (text_count); last_token := Left_brace_code
end
else
--|#line 82 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 82")
end
move (text_count); last_token := Right_brace_code
end
else
if yy_act <= 23 then
if yy_act = 22 then
--|#line 83 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 83")
end
move (text_count); last_token := Left_bracket_code
else
--|#line 84 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 84")
end
move (text_count); last_token := Right_bracket_code
end
else
--|#line 85 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 85")
end
move (text_count); last_token := Dollar_code
end
end
end
end
else
if yy_act <= 36 then
if yy_act <= 30 then
if yy_act <= 27 then
if yy_act <= 26 then
if yy_act = 25 then
--|#line 86 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 86")
end
move (text_count); last_token := E_DIV
else
--|#line 87 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 87")
end
move (text_count); last_token := E_MOD
end
else
--|#line 88 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 88")
end
move (text_count); last_token := E_NE
end
else
if yy_act <= 29 then
if yy_act = 28 then
--|#line 89 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 89")
end
move (text_count); last_token := E_GE
else
--|#line 90 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 90")
end
move (text_count); last_token := E_LE
end
else
--|#line 91 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 91")
end
move (text_count); last_token := E_BANGBANG
end
end
else
if yy_act <= 33 then
if yy_act <= 32 then
if yy_act = 31 then
--|#line 92 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 92")
end
move (text_count); last_token := E_ARROW
else
--|#line 93 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 93")
end
move (text_count); last_token := E_DOTDOT
end
else
--|#line 94 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 94")
end
move (text_count); last_token := E_LARRAY
end
else
if yy_act <= 35 then
if yy_act = 34 then
--|#line 95 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 95")
end
move (text_count); last_token := E_RARRAY
else
--|#line 96 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 96")
end
move (text_count); last_token := E_ASSIGN
end
else
--|#line 97 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 97")
end
move (text_count); last_token := E_REVERSE
end
end
end
else
if yy_act <= 42 then
if yy_act <= 39 then
if yy_act <= 38 then
if yy_act = 37 then
--|#line 102 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 102")
end
move (text_count); last_token := E_ALIAS 
else
--|#line 103 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 103")
end
move (text_count); last_token := E_ALL
end
else
--|#line 104 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 104")
end
last_token := E_AND;move (text_count)
end
else
if yy_act <= 41 then
if yy_act = 40 then
--|#line 105 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 105")
end
last_token := E_AS;move (text_count)
else
--|#line 106 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 106")
end
last_token := E_BITTYPE;move (text_count)
end
else
--|#line 107 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 107")
end
last_token := E_CHECK;move (text_count)
end
end
else
if yy_act <= 45 then
if yy_act <= 44 then
if yy_act = 43 then
--|#line 108 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 108")
end
last_token := E_CLASS;move (text_count)
else
--|#line 109 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 109")
end
last_token := E_CREATION;move (text_count)
end
else
--|#line 110 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 110")
end
last_token := E_CONFINED;move (text_count)
end
else
if yy_act = 46 then
--|#line 111 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 111")
end
last_token := E_CURRENT;move (text_count)
else
--|#line 112 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 112")
end
last_token := E_DEBUG;move (text_count)
end
end
end
end
end
else
if yy_act <= 71 then
if yy_act <= 59 then
if yy_act <= 53 then
if yy_act <= 50 then
if yy_act <= 49 then
if yy_act = 48 then
--|#line 113 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 113")
end
last_token := E_DEFERRED;move (text_count)
else
--|#line 114 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 114")
end
last_token := E_DO;move (text_count)
end
else
--|#line 115 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 115")
end
last_token := E_ELSE;move (text_count)
end
else
if yy_act <= 52 then
if yy_act = 51 then
--|#line 116 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 116")
end
last_token := E_ELSEIF;move (text_count)
else
--|#line 117 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 117")
end
last_token := E_END;move (text_count)
end
else
--|#line 118 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 118")
end
last_token := E_ENSURE;move (text_count)
end
end
else
if yy_act <= 56 then
if yy_act <= 55 then
if yy_act = 54 then
--|#line 119 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 119")
end
last_token := E_EXPANDED;move (text_count)
else
--|#line 120 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 120")
end
last_token := E_EXPORT;move (text_count)
end
else
--|#line 121 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 121")
end
last_token := E_EXTERNAL;move (text_count)
end
else
if yy_act <= 58 then
if yy_act = 57 then
--|#line 122 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 122")
end
last_token := E_FALSE;move (text_count)
else
--|#line 123 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 123")
end
last_token := E_FEATURE;move (text_count)
end
else
--|#line 124 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 124")
end
last_token := E_FROM;move (text_count)
end
end
end
else
if yy_act <= 65 then
if yy_act <= 62 then
if yy_act <= 61 then
if yy_act = 60 then
--|#line 125 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 125")
end
last_token := E_FROZEN;move (text_count)
else
--|#line 126 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 126")
end
last_token := E_IF;move (text_count)
end
else
--|#line 127 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 127")
end
last_token := E_IMPLIES;move (text_count)
end
else
if yy_act <= 64 then
if yy_act = 63 then
--|#line 128 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 128")
end
last_token := E_INDEXING;move (text_count)
else
--|#line 129 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 129")
end

										is_operator := True
										last_token := E_INFIX;move (text_count)
									
end
else
--|#line 133 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 133")
end
last_token := E_INHERIT;move (text_count)
end
end
else
if yy_act <= 68 then
if yy_act <= 67 then
if yy_act = 66 then
--|#line 134 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 134")
end
last_token := E_INSPECT;move (text_count)
else
--|#line 135 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 135")
end
last_token := E_INVARIANT;move (text_count)
end
else
--|#line 136 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 136")
end
last_token := E_IS;move (text_count)
end
else
if yy_act <= 70 then
if yy_act = 69 then
--|#line 137 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 137")
end
last_token := E_LIKE;move (text_count)
else
--|#line 138 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 138")
end
last_token := E_LOCAL;move (text_count)
end
else
--|#line 139 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 139")
end
last_token := E_LOOP;move (text_count)
end
end
end
end
else
if yy_act <= 83 then
if yy_act <= 77 then
if yy_act <= 74 then
if yy_act <= 73 then
if yy_act = 72 then
--|#line 140 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 140")
end
last_token := E_MODIFY;move (text_count)
else
--|#line 141 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 141")
end
last_token := E_NOT;move (text_count)
end
else
--|#line 142 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 142")
end
last_token := E_OBSOLETE;move (text_count)
end
else
if yy_act <= 76 then
if yy_act = 75 then
--|#line 143 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 143")
end
last_token := E_OLD;move (text_count)
else
--|#line 144 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 144")
end
last_token := E_ONCE;move (text_count)
end
else
--|#line 145 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 145")
end
last_token := E_OR;move (text_count)
end
end
else
if yy_act <= 80 then
if yy_act <= 79 then
if yy_act = 78 then
--|#line 146 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 146")
end
last_token := E_PRECURSOR;move (text_count)
else
--|#line 147 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 147")
end

										is_operator := True
										last_token := E_PREFIX;move (text_count)
									
end
else
--|#line 151 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 151")
end
last_token := E_REDEFINE;move (text_count)
end
else
if yy_act <= 82 then
if yy_act = 81 then
--|#line 152 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 152")
end
last_token := E_RENAME;move (text_count)
else
--|#line 153 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 153")
end
last_token := E_REQUIRE;move (text_count)
end
else
--|#line 154 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 154")
end
last_token := E_RESCUE;move (text_count)
end
end
end
else
if yy_act <= 89 then
if yy_act <= 86 then
if yy_act <= 85 then
if yy_act = 84 then
--|#line 155 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 155")
end
last_token := E_RESULT;move (text_count)
else
--|#line 156 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 156")
end
last_token := E_RETRY;move (text_count)
end
else
--|#line 157 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 157")
end
last_token := E_SELECT;move (text_count)
end
else
if yy_act <= 88 then
if yy_act = 87 then
--|#line 158 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 158")
end
last_token := E_SEPARATE;move (text_count)
else
--|#line 159 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 159")
end
last_token := E_STRIP;move (text_count)
end
else
--|#line 160 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 160")
end
last_token := E_THEN;move (text_count)
end
end
else
if yy_act <= 92 then
if yy_act <= 91 then
if yy_act = 90 then
--|#line 161 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 161")
end
last_token := E_TRUE;move (text_count)
else
--|#line 162 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 162")
end
last_token := E_USE;move (text_count)
end
else
--|#line 163 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 163")
end
last_token := E_UNDEFINE;move (text_count)
end
else
if yy_act = 93 then
--|#line 164 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 164")
end
last_token := E_UNIQUE;move (text_count)
else
--|#line 165 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 165")
end
last_token := E_UNTIL;move (text_count)
end
end
end
end
end
end
else
if yy_act <= 141 then
if yy_act <= 118 then
if yy_act <= 106 then
if yy_act <= 100 then
if yy_act <= 97 then
if yy_act <= 96 then
if yy_act = 95 then
--|#line 166 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 166")
end
last_token := E_VARIANT;move (text_count)
else
--|#line 167 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 167")
end
last_token := E_WHEN;move (text_count)
end
else
--|#line 168 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 168")
end
last_token := E_XOR;move (text_count)
end
else
if yy_act <= 99 then
if yy_act = 98 then
--|#line 173 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 173")
end

				last_token := E_IDENTIFIER
				last_value := text;move (text_count)
			
else
--|#line 181 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 181")
end

				last_token := E_FREEOP
				last_value := text;move (text_count)
			
end
else
--|#line 192 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 192")
end
last_token := E_CHARACTER; last_value := text_item (2);move (text_count)
end
end
else
if yy_act <= 103 then
if yy_act <= 102 then
if yy_act = 101 then
--|#line 195 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 195")
end
last_token := E_CHARACTER; last_value := '%'';move (text_count)
else
--|#line 196 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 196")
end
last_token := E_CHARACTER; last_value := '%A';move (text_count)
end
else
--|#line 197 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 197")
end
last_token := E_CHARACTER; last_value := '%B';move (text_count)
end
else
if yy_act <= 105 then
if yy_act = 104 then
--|#line 198 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 198")
end
last_token := E_CHARACTER; last_value := '%C';move (text_count)
else
--|#line 199 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 199")
end
last_token := E_CHARACTER; last_value := '%D';move (text_count)
end
else
--|#line 200 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 200")
end
last_token := E_CHARACTER; last_value := '%F';move (text_count)
end
end
end
else
if yy_act <= 112 then
if yy_act <= 109 then
if yy_act <= 108 then
if yy_act = 107 then
--|#line 201 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 201")
end
last_token := E_CHARACTER; last_value := '%H';move (text_count)
else
--|#line 202 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 202")
end
last_token := E_CHARACTER; last_value := '%L';move (text_count)
end
else
--|#line 203 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 203")
end
last_token := E_CHARACTER; last_value := '%N';move (text_count)
end
else
if yy_act <= 111 then
if yy_act = 110 then
--|#line 204 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 204")
end
last_token := E_CHARACTER; last_value := '%Q';move (text_count)
else
--|#line 205 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 205")
end
last_token := E_CHARACTER; last_value := '%R';move (text_count)
end
else
--|#line 206 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 206")
end
last_token := E_CHARACTER; last_value := '%S';move (text_count)
end
end
else
if yy_act <= 115 then
if yy_act <= 114 then
if yy_act = 113 then
--|#line 207 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 207")
end
last_token := E_CHARACTER; last_value := '%T';move (text_count)
else
--|#line 208 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 208")
end
last_token := E_CHARACTER; last_value := '%U';move (text_count)
end
else
--|#line 209 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 209")
end
last_token := E_CHARACTER; last_value := '%V';move (text_count)
end
else
if yy_act <= 117 then
if yy_act = 116 then
--|#line 210 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 210")
end
last_token := E_CHARACTER; last_value := '%%';move (text_count)
else
--|#line 211 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 211")
end
last_token := E_CHARACTER; last_value := '%'';move (text_count)
end
else
--|#line 212 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 212")
end
last_token := E_CHARACTER; last_value := '%"';move (text_count)
end
end
end
end
else
if yy_act <= 130 then
if yy_act <= 124 then
if yy_act <= 121 then
if yy_act <= 120 then
if yy_act = 119 then
--|#line 213 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 213")
end
last_token := E_CHARACTER; last_value := '%(';move (text_count)
else
--|#line 214 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 214")
end
last_token := E_CHARACTER; last_value := '%)';move (text_count)
end
else
--|#line 215 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 215")
end
last_token := E_CHARACTER; last_value := '%<';move (text_count)
end
else
if yy_act <= 123 then
if yy_act = 122 then
--|#line 216 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 216")
end
last_token := E_CHARACTER; last_value := '%>';move (text_count)
else
--|#line 217 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 217")
end

						code_ := text_substring (4, text_count - 2).to_integer
						if code_ > Platform.Maximum_character_code then
							last_token := E_CHARERR
						else
							last_token := E_CHARACTER
							last_value := INTEGER_.to_character (code_)
						end
						move (text_count)
					
end
else
--|#line 229 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 229")
end
last_token := E_CHARACTER; last_value := text_item (3);move (text_count)
end
end
else
if yy_act <= 127 then
if yy_act <= 126 then
if yy_act = 125 then
--|#line 231 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 231")
end
last_token := E_CHARERR;move (text_count)	-- Catch-all rules (no backing up)
else
--|#line 232 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 232")
end
last_token := E_CHARERR;move (text_count)	-- Catch-all rules (no backing up)
end
else
--|#line 237 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 237")
end
last_token := process_operator (E_STRPLUS);move (text_count)
end
else
if yy_act <= 129 then
if yy_act = 128 then
--|#line 238 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 238")
end
last_token := process_operator (E_STRMINUS);move (text_count)
else
--|#line 239 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 239")
end
last_token := process_operator (E_STRSTAR);move (text_count)
end
else
--|#line 240 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 240")
end
last_token := process_operator (E_STRSLASH);move (text_count)
end
end
end
else
if yy_act <= 136 then
if yy_act <= 133 then
if yy_act <= 132 then
if yy_act = 131 then
--|#line 241 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 241")
end
last_token := process_operator (E_STRDIV);move (text_count)
else
--|#line 242 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 242")
end
last_token := process_operator (E_STRMOD);move (text_count)
end
else
--|#line 243 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 243")
end
last_token := process_operator (E_STRPOWER);move (text_count)
end
else
if yy_act <= 135 then
if yy_act = 134 then
--|#line 244 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 244")
end
last_token := process_operator (E_STRLT);move (text_count)
else
--|#line 245 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 245")
end
last_token := process_operator (E_STRLE);move (text_count)
end
else
--|#line 246 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 246")
end
last_token := process_operator (E_STRGT);move (text_count)
end
end
else
if yy_act <= 139 then
if yy_act <= 138 then
if yy_act = 137 then
--|#line 247 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 247")
end
last_token := process_operator (E_STRGE);move (text_count)
else
--|#line 248 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 248")
end
last_token := process_operator (E_STRNOT);move (text_count)
end
else
--|#line 249 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 249")
end
last_token := process_operator (E_STRAND);move (text_count)
end
else
if yy_act = 140 then
--|#line 250 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 250")
end
last_token := process_operator (E_STROR);move (text_count)
else
--|#line 251 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 251")
end
last_token := process_operator (E_STRXOR);move (text_count)
end
end
end
end
end
else
if yy_act <= 165 then
if yy_act <= 153 then
if yy_act <= 147 then
if yy_act <= 144 then
if yy_act <= 143 then
if yy_act = 142 then
--|#line 252 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 252")
end
last_token := process_operator (E_STRANDTHEN);move (text_count)
else
--|#line 253 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 253")
end
last_token := process_operator (E_STRORELSE);move (text_count)
end
else
--|#line 254 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 254")
end
last_token := process_operator (E_STRIMPLIES);move (text_count)
end
else
if yy_act <= 146 then
if yy_act = 145 then
--|#line 255 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 255")
end

			if is_operator then
				is_operator := False
				last_token := E_STRFREEOP
			else
				last_token := E_STRING
			end
			last_value := text_substring (2, text_count - 1);move (text_count)
		
else
--|#line 264 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 264")
end

				last_token := E_STRING
				last_value := text_substring (2, text_count - 1);move (text_count)
			
end
else
--|#line 268 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 268")
end

				if text_count > 1 then
					eif_buffer.append_string (text_substring (2, text_count))
				end
				set_start_condition (IN_STR);move (text_count)
			
end
end
else
if yy_act <= 150 then
if yy_act <= 149 then
if yy_act = 148 then
--|#line 274 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 274")
end
eif_buffer.append_string (text);move (text_count)
else
--|#line 275 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 275")
end
eif_buffer.append_character ('%A');move (text_count)
end
else
--|#line 276 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 276")
end
eif_buffer.append_character ('%B');move (text_count)
end
else
if yy_act <= 152 then
if yy_act = 151 then
--|#line 277 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 277")
end
eif_buffer.append_character ('%C');move (text_count)
else
--|#line 278 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 278")
end
eif_buffer.append_character ('%D');move (text_count)
end
else
--|#line 279 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 279")
end
eif_buffer.append_character ('%F');move (text_count)
end
end
end
else
if yy_act <= 159 then
if yy_act <= 156 then
if yy_act <= 155 then
if yy_act = 154 then
--|#line 280 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 280")
end
eif_buffer.append_character ('%H');move (text_count)
else
--|#line 281 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 281")
end
eif_buffer.append_character ('%L');move (text_count)
end
else
--|#line 282 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 282")
end
eif_buffer.append_character ('%N');move (text_count)
end
else
if yy_act <= 158 then
if yy_act = 157 then
--|#line 283 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 283")
end
eif_buffer.append_character ('%Q');move (text_count)
else
--|#line 284 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 284")
end
eif_buffer.append_character ('%R');move (text_count)
end
else
--|#line 285 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 285")
end
eif_buffer.append_character ('%S');move (text_count)
end
end
else
if yy_act <= 162 then
if yy_act <= 161 then
if yy_act = 160 then
--|#line 286 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 286")
end
eif_buffer.append_character ('%T');move (text_count)
else
--|#line 287 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 287")
end
eif_buffer.append_character ('%U');move (text_count)
end
else
--|#line 288 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 288")
end
eif_buffer.append_character ('%V');move (text_count)
end
else
if yy_act <= 164 then
if yy_act = 163 then
--|#line 289 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 289")
end
eif_buffer.append_character ('%%');move (text_count)
else
--|#line 290 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 290")
end
eif_buffer.append_character ('%'');move (text_count)
end
else
--|#line 291 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 291")
end
eif_buffer.append_character ('%"');move (text_count)
end
end
end
end
else
if yy_act <= 177 then
if yy_act <= 171 then
if yy_act <= 168 then
if yy_act <= 167 then
if yy_act = 166 then
--|#line 292 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 292")
end
eif_buffer.append_character ('%(');move (text_count)
else
--|#line 293 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 293")
end
eif_buffer.append_character ('%)');move (text_count)
end
else
--|#line 294 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 294")
end
eif_buffer.append_character ('%<');move (text_count)
end
else
if yy_act <= 170 then
if yy_act = 169 then
--|#line 295 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 295")
end
eif_buffer.append_character ('%>');move (text_count)
else
--|#line 296 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 296")
end

			code_ := text_substring (3, text_count - 1).to_integer
			if (code_ > Platform.Maximum_character_code) then
				last_token := E_STRERR
				set_start_condition (INITIAL)
			else
				eif_buffer.append_character (INTEGER_.to_character (code_))
			end;move (text_count)
		
end
else
--|#line 309 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 309")
end
eif_lineno := eif_lineno + 1;move (text_count)
end
end
else
if yy_act <= 174 then
if yy_act <= 173 then
if yy_act = 172 then
--|#line 310 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 310")
end

			last_token := E_STRING
			if text_count > 1 then
				eif_buffer.append_string (text_substring (1, text_count - 1))
			end
			str_ := STRING_.make (eif_buffer.count)
			str_.append_string (eif_buffer)
			eif_buffer.wipe_out
			last_value := str_
			set_start_condition (INITIAL);move (text_count)
		
else
--|#line 323 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 323")
end
eif_buffer.append_character (text_item (2));move (text_count)
end
else
--|#line 325 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 325")
end
	-- Catch-all rules (no backing up)
							last_token := E_STRERR
							set_start_condition (INITIAL);move (text_count)
						
end
else
if yy_act <= 176 then
if yy_act = 175 then
--|#line 326 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 326")
end
	-- Catch-all rules (no backing up)
							last_token := E_STRERR
							set_start_condition (INITIAL);move (text_count)
						
else
--|#line 327 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 327")
end
	-- Catch-all rules (no backing up)
							last_token := E_STRERR
							set_start_condition (INITIAL);move (text_count)
						
end
else
--|#line 336 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 336")
end
last_token := E_BIT; last_value := text;move (text_count)
end
end
end
else
if yy_act <= 183 then
if yy_act <= 180 then
if yy_act <= 179 then
if yy_act = 178 then
--|#line 341 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 341")
end

						last_token := E_INTEGER
						last_value := text.to_integer;move (text_count)
					
else
--|#line 345 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 345")
end

						last_token := E_INTEGER
						str_ := text
						nb_ := text_count
						from i_ := 1 until i_ > nb_ loop
							char_ := str_.item (i_)
							if char_ /= '_' then
								eif_buffer.append_character (char_)
							end 
							i_ := i_ + 1
						end
						last_value := eif_buffer.to_integer
						eif_buffer.wipe_out;move (text_count)
					
end
else
--|#line 359 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 359")
end
last_token := E_INTERR	;move (text_count)-- Catch-all rule (no backing up)
end
else
if yy_act <= 182 then
if yy_act = 181 then
	yy_end := yy_end - 1
--|#line 364 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 364")
end

						last_token := E_REAL
						last_value := text.to_double;move (text_count)
					
else
--|#line 365 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 365")
end

						last_token := E_REAL
						last_value := text.to_double;move (text_count)
					
end
else
--|#line 366 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 366")
end

						last_token := E_REAL
						last_value := text.to_double;move (text_count)
					
end
end
else
if yy_act <= 186 then
if yy_act <= 185 then
if yy_act = 184 then
	yy_end := yy_end - 1
--|#line 370 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 370")
end

						last_token := E_REAL
						str_ := text
						nb_ := text_count
						from i_ := 1 until i_ > nb_ loop
							char_ := str_.item (i_)
							if char_ /= '_' then
								eif_buffer.append_character (char_)
							end
							i_ := i_ + 1
						end
						last_value := eif_buffer.to_double
						eif_buffer.wipe_out;move (text_count)
					
else
--|#line 371 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 371")
end

						last_token := E_REAL
						str_ := text
						nb_ := text_count
						from i_ := 1 until i_ > nb_ loop
							char_ := str_.item (i_)
							if char_ /= '_' then
								eif_buffer.append_character (char_)
							end
							i_ := i_ + 1
						end
						last_value := eif_buffer.to_double
						eif_buffer.wipe_out;move (text_count)
					
end
else
--|#line 372 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 372")
end

						last_token := E_REAL
						str_ := text
						nb_ := text_count
						from i_ := 1 until i_ > nb_ loop
							char_ := str_.item (i_)
							if char_ /= '_' then
								eif_buffer.append_character (char_)
							end
							i_ := i_ + 1
						end
						last_value := eif_buffer.to_double
						eif_buffer.wipe_out;move (text_count)
					
end
else
if yy_act = 187 then
--|#line 394 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 394")
end
last_token := text_item (1).code;move (text_count)
else
--|#line 0 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 0")
end
last_token := yyError_token
fatal_error ("scanner jammed")
end
end
end
end
end
end
end
		end

	yy_execute_eof_action (yy_sc: INTEGER) is
			-- Execute EOF semantic action.
		do
			inspect yy_sc
when 0 then
--|#line 0 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 0")
end
terminate
when 1 then
--|#line 0 "eiffel_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'eiffel_scanner.l' at line 0")
end
	-- Catch-all rules (no backing up)
							last_token := E_STRERR
							set_start_condition (INITIAL);move (text_count)
						
			else
				terminate
			end
		end

feature {NONE} -- Table templates

	yy_nxt_template: SPECIAL [INTEGER] is
		local
			an_array: ARRAY [INTEGER]
		once
			create an_array.make (0, 141349)
			yy_nxt_template_1 (an_array)
			yy_nxt_template_2 (an_array)
			yy_nxt_template_3 (an_array)
			yy_nxt_template_4 (an_array)
			yy_nxt_template_5 (an_array)
			yy_nxt_template_6 (an_array)
			yy_nxt_template_7 (an_array)
			yy_nxt_template_8 (an_array)
			yy_nxt_template_9 (an_array)
			yy_nxt_template_10 (an_array)
			yy_nxt_template_11 (an_array)
			yy_nxt_template_12 (an_array)
			yy_nxt_template_13 (an_array)
			yy_nxt_template_14 (an_array)
			yy_nxt_template_15 (an_array)
			yy_nxt_template_16 (an_array)
			yy_nxt_template_17 (an_array)
			yy_nxt_template_18 (an_array)
			yy_nxt_template_19 (an_array)
			yy_nxt_template_20 (an_array)
			yy_nxt_template_21 (an_array)
			yy_nxt_template_22 (an_array)
			yy_nxt_template_23 (an_array)
			yy_nxt_template_24 (an_array)
			yy_nxt_template_25 (an_array)
			yy_nxt_template_26 (an_array)
			yy_nxt_template_27 (an_array)
			yy_nxt_template_28 (an_array)
			yy_nxt_template_29 (an_array)
			yy_nxt_template_30 (an_array)
			yy_nxt_template_31 (an_array)
			yy_nxt_template_32 (an_array)
			yy_nxt_template_33 (an_array)
			yy_nxt_template_34 (an_array)
			yy_nxt_template_35 (an_array)
			yy_nxt_template_36 (an_array)
			yy_nxt_template_37 (an_array)
			yy_nxt_template_38 (an_array)
			yy_nxt_template_39 (an_array)
			yy_nxt_template_40 (an_array)
			yy_nxt_template_41 (an_array)
			yy_nxt_template_42 (an_array)
			yy_nxt_template_43 (an_array)
			yy_nxt_template_44 (an_array)
			yy_nxt_template_45 (an_array)
			yy_nxt_template_46 (an_array)
			yy_nxt_template_47 (an_array)
			yy_nxt_template_48 (an_array)
			Result := yy_fixed_array (an_array)
		end

	yy_nxt_template_1 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,

			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,

			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,    0,    0,    0,    0,    0,    0,    5,    6,    6,
			    6,    6,    6,    6,    6,    6,    7,    8,    6,    6,
			    7,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    7,
			    9,   10,   11,   12,    6,   11,   13,   14,   15,   16,

			   17,   18,   19,   20,   21,   22,   22,   23,   23,   23,
			   23,   23,   23,   23,   23,   24,   25,   26,   27,   28,
			   29,   11,   30,   31,   32,   33,   34,   35,   36,   36,
			   37,   36,   36,   38,   39,   40,   41,   42,   36,   43,
			   44,   45,   46,   47,   48,   49,   36,   36,   50,   51,
			   52,   53,   54,    6,   30,   31,   32,   33,   34,   35,
			   36,   36,   37,   36,   36,   38,   39,   40,   41,   42,
			   36,   43,   44,   45,   46,   47,   48,   49,   36,   36,
			   55,   11,   56,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,

			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,

			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    5,    6,    6,    6,    6,    6,
			    6,    6,    6,    7,    8,    6,    6,    7,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    7,    9,   10,   11,
			   12,    6,   11,   13,   14,   15,   16,   17,   18,   19,
			   20,   21,   22,   22,   23,   23,   23,   23,   23,   23,
			   23,   23,   24,   25,   26,   27,   28,   29,   11,   30,
			   31,   32,   33,   34,   35,   36,   36,   37,   36,   36,
			   38,   39,   40,   41,   42,   36,   43,   44,   45,   46,

			   47,   48,   49,   36,   36,   50,   51,   52,   53,   54,
			    6,   30,   31,   32,   33,   34,   35,   36,   36,   37,
			   36,   36,   38,   39,   40,   41,   42,   36,   43,   44,
			   45,   46,   47,   48,   49,   36,   36,   55,   11,   56,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,

			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
			    6,    5,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   58,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,

			   57,   57,   57,   57,   57,   59,   57,   57,   60,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,

			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,

			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,    5,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   58,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   59,   57,   57,   60,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,

			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,

			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   57,   57,   57,   57,   57,
			   57,   57,   57,   57,   57,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,

			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,

			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,

			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,   -5,
			   -5,   -5,    5,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,

			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,

			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,
			   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,   -6,    5,

			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   61,   -7,
			   -7,   -7,   61,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   61,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,

			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,

			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,   -7,
			   -7,   -7,   -7,   -7,   -7,   -7,    5,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   62,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,

			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,

			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,

			   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,   -8,
			   -8,   -8,   -8,    5,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   63,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,

			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,

			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,   -9,
			    5,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			  -10,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   65,   66,   64,  -10,   66,   64,
			   64,   64,   67,   68,   64,   69,   64,   70,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   71,   64,   72,   64,   66,   73,   64,   64,   64,   64,
			   64,   64,   64,   74,   64,   64,   64,   64,   75,   76,
			   64,   64,   64,   64,   64,   64,   64,   64,   77,   64,
			   64,   64,   78,   64,   79,   64,   64,   73,   64,   64,
			   64,   64,   64,   64,   64,   74,   64,   64,   64,   64,
			   75,   76,   64,   64,   64,   64,   64,   64,   64,   64,
			   77,   64,   64,   64,   66,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,    5,   80,   80,
			   80,   80,   80,   80,   80,   80,  -11,  -11,   80,   80,
			  -11,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,  -11,
			   80,  -11,   80,   80,  -11,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,

			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80, yy_Dummy>>,
			1, 3000, 0)
		end

	yy_nxt_template_2 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,    5,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,

			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,

			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,

			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,  -12,
			  -12,    5,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,  -13,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   82,   81,
			   83,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,

			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,

			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,   81,   81,
			   81,   81,   81,   81,   81,   81,   81,   81,    5,  -14,

			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,

			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,

			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,  -14,
			  -14,  -14,  -14,  -14,  -14,    5,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,

			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,

			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,

			  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,  -15,
			  -15,  -15,    5,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,

			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,

			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,
			  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,  -16,    5,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,

			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,

			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,

			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,  -17,
			  -17,  -17,  -17,  -17,  -17,  -17,    5,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,

			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,

			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,  -18,
			  -18,  -18,  -18,    5,  -19,  -19,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,

			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,   84,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,   85,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,

			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,

			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,
			  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,  -19,
			    5,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,   86,  -20,   87,   87,
			   87,   87,   87,   87,   87,   87,   87,   87,  -20,  -20,

			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,

			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,  -20,
			  -20,  -20,  -20,  -20,  -20,  -20,  -20,    5,  -21,  -21,

			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,   88,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,   89,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,

			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,

			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,  -21,
			  -21,  -21,  -21,  -21,    5,  -22,  -22,  -22,  -22,  -22,
			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,
			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,
			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,
			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,

			   90,  -22,   91,   91,   92,   92,   92,   92,   92,   92,
			   92,   92,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,
			   93,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,
			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,
			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,   94,
			  -22,  -22,   93,  -22,  -22,  -22,  -22,  -22,  -22,  -22,
			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,
			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,
			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,
			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,

			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,
			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,
			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,
			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,
			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,
			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,
			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,
			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,
			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,
			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,

			  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,  -22,
			  -22,    5,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,   90,  -23,   92,
			   92,   92,   92,   92,   92,   92,   92,   92,   92,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23, yy_Dummy>>,
			1, 3000, 3000)
		end

	yy_nxt_template_3 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  -23,  -23,  -23,  -23,  -23,  -23,   94,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,

			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,
			  -23,  -23,  -23,  -23,  -23,  -23,  -23,  -23,    5,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,

			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,   95,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,

			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,

			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,  -24,
			  -24,  -24,  -24,  -24,  -24,    5,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,

			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,

			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,  -25,
			  -25,  -25,    5,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,

			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,   96,   97,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,

			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,

			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,
			  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,  -26,    5,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,

			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,

			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,  -27,
			  -27,  -27,  -27,  -27,  -27,  -27,    5,  -28,  -28,  -28,

			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,   98,   99,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,

			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,

			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,  -28,
			  -28,  -28,  -28,    5,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,

			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  100,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,

			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,

			  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,  -29,
			    5,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,
			  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,
			  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,
			  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,
			  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  -30,  -30,
			  -30,  -30,  -30,  -30,  -30,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  102,  101,  103,  101,
			  101,  101,  101,  104,  101,  101,  101,  101,  101,  101,

			  101,  -30,  -30,  -30,  -30,  101,  -30,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  102,  101,
			  103,  101,  101,  101,  101,  104,  101,  101,  101,  101,
			  101,  101,  101,  -30,  -30,  -30,  -30,  -30,  -30,  -30,
			  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,
			  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,
			  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,
			  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,
			  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,
			  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,

			  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,
			  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,
			  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,
			  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,
			  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,
			  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,  -30,
			  -30,  -30,  -30,  -30,  -30,  -30,  -30,    5,  -31,  -31,
			  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,
			  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,
			  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,

			  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,
			  -31,  -31,  -31,  -31,  -31,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  -31,  -31,  -31,  -31,  -31,
			  -31,  -31,  101,  101,  101,  101,  101,  101,  101,  101,
			  105,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  -31,  -31,
			  -31,  -31,  101,  -31,  101,  101,  101,  101,  101,  101,
			  101,  101,  105,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,

			  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,
			  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,
			  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,
			  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,
			  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,
			  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,
			  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,
			  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,
			  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,
			  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,

			  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,
			  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,  -31,
			  -31,  -31,  -31,  -31,    5,  -32,  -32,  -32,  -32,  -32,
			  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,
			  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,
			  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,
			  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,
			  -32,  -32,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  101,
			  101,  101,  101,  101,  101,  101,  106,  101,  101,  101,

			  107,  101,  101,  108,  101,  101,  109,  101,  101,  110,
			  101,  101,  101,  101,  101,  -32,  -32,  -32,  -32,  101,
			  -32,  101,  101,  101,  101,  101,  101,  101,  106,  101,
			  101,  101,  107,  101,  101,  108,  101,  101,  109,  101,
			  101,  110,  101,  101,  101,  101,  101,  -32,  -32,  -32,
			  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,
			  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,
			  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,
			  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,
			  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,

			  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,
			  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,
			  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,
			  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,
			  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,
			  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,
			  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,
			  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,
			  -32,    5,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,
			  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,

			  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,
			  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,
			  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  -33,
			  -33,  -33,  -33,  -33,  -33,  -33,  101,  101,  101,  101,
			  111,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  112,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  -33,  -33,  -33,  -33,  101,  -33,  101,  101,
			  101,  101,  111,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  112,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  -33,  -33,  -33,  -33,  -33,  -33,
			  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,
			  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,
			  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,
			  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,
			  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,
			  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,
			  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,
			  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,
			  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,

			  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,
			  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,
			  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,
			  -33,  -33,  -33,  -33,  -33,  -33,  -33,  -33,    5,  -34,
			  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,
			  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,
			  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,
			  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,
			  -34,  -34,  -34,  -34,  -34,  -34,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  -34,  -34,  -34,  -34,

			  -34,  -34,  -34,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  113,  101,  114,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  115,  101,  101,  -34,
			  -34,  -34,  -34,  101,  -34,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  113,  101,  114,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  115,  101,
			  101,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,
			  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,
			  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,
			  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,

			  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,
			  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,
			  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,
			  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,
			  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,
			  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,
			  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,
			  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,
			  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,  -34,
			  -34,  -34,  -34,  -34,  -34,    5,  -35,  -35,  -35,  -35, yy_Dummy>>,
			1, 3000, 6000)
		end

	yy_nxt_template_4 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,
			  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,
			  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,
			  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,
			  -35,  -35,  -35,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  -35,  -35,  -35,  -35,  -35,  -35,  -35,
			  116,  101,  101,  101,  117,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  118,  101,  101,
			  101,  101,  101,  101,  101,  101,  -35,  -35,  -35,  -35,
			  101,  -35,  116,  101,  101,  101,  117,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  118,
			  101,  101,  101,  101,  101,  101,  101,  101,  -35,  -35,
			  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,
			  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,
			  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,
			  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,
			  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,
			  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,
			  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,
			  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,

			  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,
			  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,
			  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,
			  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,
			  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,  -35,
			  -35,  -35,    5,  -36,  -36,  -36,  -36,  -36,  -36,  -36,
			  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,
			  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,
			  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,
			  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  -36,  -36,  -36,  -36,  -36,  -36,  -36,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  -36,  -36,  -36,  -36,  101,  -36,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  -36,  -36,  -36,  -36,  -36,
			  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,
			  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,

			  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,
			  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,
			  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,
			  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,
			  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,
			  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,
			  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,
			  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,
			  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,
			  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,

			  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,  -36,    5,
			  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,
			  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,
			  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,
			  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,
			  -37,  -37,  -37,  -37,  -37,  -37,  -37,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  -37,  -37,  -37,
			  -37,  -37,  -37,  -37,  101,  101,  101,  101,  101,  119,
			  101,  101,  101,  101,  101,  101,  120,  121,  101,  101,
			  101,  101,  122,  101,  101,  101,  101,  101,  101,  101,

			  -37,  -37,  -37,  -37,  101,  -37,  101,  101,  101,  101,
			  101,  119,  101,  101,  101,  101,  101,  101,  120,  121,
			  101,  101,  101,  101,  122,  101,  101,  101,  101,  101,
			  101,  101,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,
			  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,
			  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,
			  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,
			  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,
			  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,
			  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,

			  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,
			  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,
			  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,
			  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,
			  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,
			  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,  -37,
			  -37,  -37,  -37,  -37,  -37,  -37,    5,  -38,  -38,  -38,
			  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,
			  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,
			  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,

			  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,
			  -38,  -38,  -38,  -38,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  -38,  -38,  -38,  -38,  -38,  -38,
			  -38,  101,  101,  101,  101,  101,  101,  101,  101,  123,
			  101,  101,  101,  101,  101,  124,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  -38,  -38,  -38,
			  -38,  101,  -38,  101,  101,  101,  101,  101,  101,  101,
			  101,  123,  101,  101,  101,  101,  101,  124,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  -38,
			  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,

			  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,
			  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,
			  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,
			  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,
			  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,
			  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,
			  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,
			  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,
			  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,
			  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,

			  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,
			  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,  -38,
			  -38,  -38,  -38,    5,  -39,  -39,  -39,  -39,  -39,  -39,
			  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,
			  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,
			  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,
			  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,
			  -39,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  125,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  -39,  -39,  -39,  -39,  101,  -39,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  125,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  -39,  -39,  -39,  -39,
			  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,
			  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,
			  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,
			  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,
			  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,

			  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,
			  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,
			  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,
			  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,
			  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,
			  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,
			  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,
			  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,  -39,
			    5,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,
			  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,

			  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,
			  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,
			  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  -40,  -40,
			  -40,  -40,  -40,  -40,  -40,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  126,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  -40,  -40,  -40,  -40,  101,  -40,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  126,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  -40,  -40,  -40,  -40,  -40,  -40,  -40,
			  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,
			  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,
			  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,
			  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,
			  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,
			  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,
			  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,
			  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,
			  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,

			  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,
			  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,
			  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,  -40,
			  -40,  -40,  -40,  -40,  -40,  -40,  -40,    5,  -41,  -41,
			  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,
			  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,
			  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,
			  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,
			  -41,  -41,  -41,  -41,  -41,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  -41,  -41,  -41,  -41,  -41,

			  -41,  -41,  101,  127,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  128,  101,  129,  101,  101,  101,  130,
			  101,  101,  101,  101,  101,  101,  101,  101,  -41,  -41,
			  -41,  -41,  101,  -41,  101,  127,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  128,  101,  129,  101,  101,
			  101,  130,  101,  101,  101,  101,  101,  101,  101,  101,
			  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,
			  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,
			  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,
			  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,

			  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,
			  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,
			  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,
			  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,
			  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,
			  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,
			  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,
			  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,
			  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,  -41,
			  -41,  -41,  -41,  -41,    5,  -42,  -42,  -42,  -42,  -42,

			  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,
			  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,
			  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,
			  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,
			  -42,  -42,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  131,  101,  101,  101,
			  101,  101,  101,  101,  101,  -42,  -42,  -42,  -42,  101,
			  -42,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  131,  101,
			  101,  101,  101,  101,  101,  101,  101,  -42,  -42,  -42,
			  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,
			  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,
			  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,
			  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,
			  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,
			  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,
			  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,
			  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,

			  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,
			  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,
			  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,
			  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,
			  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,  -42,
			  -42,    5,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,
			  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,
			  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,
			  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,
			  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  -43,
			  -43,  -43,  -43,  -43,  -43,  -43,  101,  101,  101,  101,
			  132,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  -43,  -43,  -43,  -43,  101,  -43,  101,  101,
			  101,  101,  132,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  -43,  -43,  -43,  -43,  -43,  -43,
			  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,
			  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,

			  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,
			  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,
			  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,
			  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,
			  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,
			  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,
			  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,
			  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,
			  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,
			  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,

			  -43,  -43,  -43,  -43,  -43,  -43,  -43,  -43,    5,  -44,
			  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,
			  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,
			  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,
			  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,
			  -44,  -44,  -44,  -44,  -44,  -44,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  -44,  -44,  -44,  -44,
			  -44,  -44,  -44,  101,  101,  101,  101,  133,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  134,  101,  101,  101,  101,  101,  101,  -44,

			  -44,  -44,  -44,  101,  -44,  101,  101,  101,  101,  133,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  134,  101,  101,  101,  101,  101,
			  101,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,
			  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,
			  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,
			  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,
			  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,
			  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,
			  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,

			  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,
			  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,
			  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,
			  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,
			  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,
			  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,  -44,
			  -44,  -44,  -44,  -44,  -44,    5,  -45,  -45,  -45,  -45,
			  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,
			  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,
			  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,

			  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,
			  -45,  -45,  -45,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  -45,  -45,  -45,  -45,  -45,  -45,  -45,
			  101,  101,  101,  101,  101,  101,  101,  135,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  136,  101,  101,
			  101,  101,  101,  101,  101,  101,  -45,  -45,  -45,  -45,
			  101,  -45,  101,  101,  101,  101,  101,  101,  101,  135,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  136,
			  101,  101,  101,  101,  101,  101,  101,  101,  -45,  -45,
			  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,

			  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,
			  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,
			  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,
			  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,
			  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,
			  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,
			  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,
			  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,
			  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,
			  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,

			  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,
			  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,  -45,
			  -45,  -45,    5,  -46,  -46,  -46,  -46,  -46,  -46,  -46,
			  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,
			  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,
			  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,
			  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  -46,  -46,  -46,  -46,  -46,  -46,  -46,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  137,  101,  101,  101,  101,  138,  101,  101,  101,  101,
			  101,  101,  101,  -46,  -46,  -46,  -46,  101,  -46,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  137,  101,  101,  101,  101,  138,  101,  101,
			  101,  101,  101,  101,  101,  -46,  -46,  -46,  -46,  -46,
			  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,
			  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,
			  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,
			  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,
			  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46, yy_Dummy>>,
			1, 3000, 9000)
		end

	yy_nxt_template_5 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,
			  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,
			  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,
			  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,
			  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,
			  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,
			  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,
			  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,  -46,    5,
			  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,
			  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,

			  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,
			  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,
			  -47,  -47,  -47,  -47,  -47,  -47,  -47,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  -47,  -47,  -47,
			  -47,  -47,  -47,  -47,  139,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  -47,  -47,  -47,  -47,  101,  -47,  139,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,
			  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,
			  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,
			  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,
			  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,
			  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,
			  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,
			  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,
			  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,
			  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,

			  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,
			  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,
			  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,  -47,
			  -47,  -47,  -47,  -47,  -47,  -47,    5,  -48,  -48,  -48,
			  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,
			  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,
			  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,
			  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,
			  -48,  -48,  -48,  -48,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  -48,  -48,  -48,  -48,  -48,  -48,

			  -48,  101,  101,  101,  101,  101,  101,  101,  140,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  -48,  -48,  -48,
			  -48,  101,  -48,  101,  101,  101,  101,  101,  101,  101,
			  140,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  -48,
			  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,
			  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,
			  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,
			  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,

			  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,
			  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,
			  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,
			  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,
			  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,
			  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,
			  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,
			  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,
			  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,  -48,
			  -48,  -48,  -48,    5,  -49,  -49,  -49,  -49,  -49,  -49,

			  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,
			  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,
			  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,
			  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,
			  -49,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  141,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  -49,  -49,  -49,  -49,  101,  -49,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  141,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  -49,  -49,  -49,  -49,
			  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,
			  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,
			  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,
			  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,
			  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,
			  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,
			  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,
			  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,

			  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,
			  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,
			  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,
			  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,
			  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,  -49,
			    5,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,

			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,

			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,
			  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,  -50,

			  -50,  -50,  -50,  -50,  -50,  -50,  -50,    5,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  142,

			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,

			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,  -51,
			  -51,  -51,  -51,  -51,    5,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,

			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,

			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,

			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,  -52,
			  -52,    5,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,

			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,

			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,
			  -53,  -53,  -53,  -53,  -53,  -53,  -53,  -53,    5,  -54,
			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,

			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  -54,  -54,  -54,  143,  143,  143,  143,
			  143,  143,  143,  143,  143,  143,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  143,  -54,  -54,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,

			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,

			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,  -54,
			  -54,  -54,  -54,  -54,  -54,    5,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,

			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,

			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,  -55,
			  -55,  -55,    5,  -56,  -56,  -56,  -56,  -56,  -56,  -56,

			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,

			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,

			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,
			  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,  -56,    5,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  -57,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  145,  144,  144,  -57,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,

			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,

			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,

			  144,  144,  144,  144,  144,  144,    5,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58, yy_Dummy>>,
			1, 3000, 12000)
		end

	yy_nxt_template_6 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,

			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,  -58,
			  -58,  -58,  -58,    5,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,

			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,

			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,

			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,  -59,
			    5,  146,  146,  146,  146,  146,  146,  146,  146,  147,
			  148,  146,  146,  147,  146,  146,  146,  146,  146,  146,
			  146,  146,  146,  146,  146,  146,  146,  146,  146,  146,
			  146,  146,  147,  146,  149,  146,  146,  150,  146,  151,
			  152,  153,  146,  146,  146,  146,  146,  154,  146,  146,
			  146,  146,  146,  146,  146,  146,  146,  146,  146,  146,
			  155,  146,  156,  146,  146,  157,  158,  159,  160,  146,
			  161,  146,  162,  146,  146,  146,  163,  146,  164,  146,

			  146,  165,  166,  167,  168,  169,  170,  146,  146,  146,
			  146,  146,  146,  146,  146,  146,  146,  146,  146,  146,
			  146,  146,  146,  146,  146,  146,  146,  146,  146,  146,
			  146,  146,  146,  146,  146,  146,  146,  146,  146,  146,
			  146,  146,  146,  146,  146,  146,  146,  146,  146,  146,
			  146,  146,  146,  146,  146,  146,  146,  146,  146,  146,
			  146,  146,  146,  146,  146,  146,  146,  146,  146,  146,
			  146,  146,  146,  146,  146,  146,  146,  146,  146,  146,
			  146,  146,  146,  146,  146,  146,  146,  146,  146,  146,
			  146,  146,  146,  146,  146,  146,  146,  146,  146,  146,

			  146,  146,  146,  146,  146,  146,  146,  146,  146,  146,
			  146,  146,  146,  146,  146,  146,  146,  146,  146,  146,
			  146,  146,  146,  146,  146,  146,  146,  146,  146,  146,
			  146,  146,  146,  146,  146,  146,  146,  146,  146,  146,
			  146,  146,  146,  146,  146,  146,  146,  146,  146,  146,
			  146,  146,  146,  146,  146,  146,  146,  146,  146,  146,
			  146,  146,  146,  146,  146,  146,  146,  146,  146,  146,
			  146,  146,  146,  146,  146,  146,  146,    5,  -61,  -61,
			  -61,  -61,  -61,  -61,  -61,  -61,   61,  -61,  -61,  -61,
			   61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,

			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,   61,
			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,
			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,
			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,
			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,
			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,
			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,
			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,
			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,
			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,

			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,
			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,
			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,
			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,
			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,
			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,
			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,
			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,
			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,
			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,

			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,
			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,
			  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,  -61,
			  -61,  -61,  -61,  -61,    5,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,   62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,

			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,

			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,  -62,
			  -62,    5,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,

			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,

			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,

			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,
			  -63,  -63,  -63,  -63,  -63,  -63,  -63,  -63,    5,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,  -64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   65,   64,   64,  -64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,    5,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,

			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,

			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,  -65,
			  -65,  -65,    5,   66,   66,   66,   66,   66,   66,   66,
			   66,   64,  -66,   66,   66,   64,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   64,   66,  171,   66,   66,  -66,

			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,

			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,

			   66,   66,   66,   66,   66,   66,   66,   66,   66,   66,
			   66,   66,   66,   66,   66,   66,   66,   66,   66,    5,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,  -67,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,  172,   64,   64,  -67,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,    5,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,  -68,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			  173,   64,   64,  -68,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,    5,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,  -69,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,  174,   64,   64,
			  -69,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			    5,   64,   64,   64,   64,   64,   64,   64,   64,   64, yy_Dummy>>,
			1, 3000, 15000)
		end

	yy_nxt_template_7 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  -70,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,  175,   64,   64,  -70,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,  176,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,    5,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,  -71,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,  177,   64,   64,  -71,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,  178,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,    5,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,  -72,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,  179,   64,
			   64,  -72,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,  180,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,    5,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,  -73,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   65,   64,   64,  -73,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,  181,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,  181,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,    5,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,  -74,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   65,   64,   64,  -74,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,  182,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,  182,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,    5,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,  -75,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   65,
			   64,   64,  -75,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,  183,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,  183,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,    5,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,  -76,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   65,   64,   64,  -76,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,  184,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,  184,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,    5,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,  -77,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   65,   64,   64,  -77,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,  185,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			  185,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,    5,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,  -78,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   65,   64,   64,  -78,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,  186,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,    5,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,  -79,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,  187,   64,   64,
			  -79,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			    5,   80,   80,   80,   80,   80,   80,   80,   80,  -80,
			  -80,   80,   80,  -80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,  -80,   80,  -80,   80,   80,  -80,   80,   80,

			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,

			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,

			   80,   80,   80,   80,   80,   80,   80,   80,   80,   80,
			   80,   80,   80,   80,   80,   80,   80,    5,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  -81,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  189,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,

			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188, yy_Dummy>>,
			1, 3000, 18000)
		end

	yy_nxt_template_8 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,    5,  190,  190,  190,  190,  190,
			  190,  190,  190,  190,  -82,  190,  190,  190,  190,  190,
			  190,  190,  190,  190,  190,  190,  190,  190,  190,  190,

			  190,  190,  190,  190,  190,  190,  190,  190,  191,  190,
			  190,  192,  190,  193,  194,  195,  190,  190,  190,  190,
			  190,  196,  190,  190,  190,  190,  190,  190,  190,  190,
			  190,  190,  190,  190,  197,  190,  198,  190,  190,  199,
			  200,  201,  202,  190,  203,  190,  204,  190,  190,  190,
			  205,  190,  206,  190,  190,  207,  208,  209,  210,  211,
			  212,  190,  190,  190,  190,  190,  190,  190,  190,  190,
			  190,  190,  190,  190,  190,  190,  190,  190,  190,  190,
			  190,  190,  190,  190,  190,  190,  190,  190,  190,  190,
			  190,  190,  190,  190,  190,  190,  190,  190,  190,  190,

			  190,  190,  190,  190,  190,  190,  190,  190,  190,  190,
			  190,  190,  190,  190,  190,  190,  190,  190,  190,  190,
			  190,  190,  190,  190,  190,  190,  190,  190,  190,  190,
			  190,  190,  190,  190,  190,  190,  190,  190,  190,  190,
			  190,  190,  190,  190,  190,  190,  190,  190,  190,  190,
			  190,  190,  190,  190,  190,  190,  190,  190,  190,  190,
			  190,  190,  190,  190,  190,  190,  190,  190,  190,  190,
			  190,  190,  190,  190,  190,  190,  190,  190,  190,  190,
			  190,  190,  190,  190,  190,  190,  190,  190,  190,  190,
			  190,  190,  190,  190,  190,  190,  190,  190,  190,  190,

			  190,  190,  190,  190,  190,  190,  190,  190,  190,  190,
			  190,  190,  190,  190,  190,  190,  190,  190,  190,  190,
			  190,  190,  190,  190,  190,  190,  190,  190,  190,  190,
			  190,    5,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  -83,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  213,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,

			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,

			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,  188,  188,
			  188,  188,  188,  188,  188,  188,  188,  188,    5,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,  214,   84,

			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,

			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,

			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,   84,   84,   84,   84,   84,
			   84,   84,   84,   84,   84,    5,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,

			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,

			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,
			  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,  -85,

			  -85,  -85,    5,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,

			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,

			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,
			  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,  -86,    5,
			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,
			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,
			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,
			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,

			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  215,  215,  215,
			  215,  215,  215,  215,  215,  215,  215,  -87,  -87,  -87,
			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  216,  -87,
			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,
			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,
			  -87,  -87,  -87,  -87,  217,  -87,  -87,  -87,  -87,  -87,
			  216,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,
			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,
			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,
			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,

			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,
			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,
			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,
			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,
			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,
			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,
			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,
			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,
			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,
			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,

			  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,  -87,
			  -87,  -87,  -87,  -87,  -87,  -87,    5,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,

			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,

			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,  -88,
			  -88,  -88,  -88,    5,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,

			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,

			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,

			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,  -89,
			    5,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  -90,  218,  219,  219,
			  219,  219,  219,  219,  219,  219,  219,  219,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  220,

			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  220,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,

			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,    5,  -91,  -91,
			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,

			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,
			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,
			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,
			  -91,  -91,  -91,   90,  -91,  221,  221,  222,  222,  222,
			  222,  222,  222,  222,  222,  -91,  -91,  -91,  -91,  -91,
			  -91,  -91,  -91,   93,  -91,  -91,  -91,  -91,  -91,  -91,
			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,
			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,
			  -91,  -91,   94,  -91,  -91,   93,  -91,  -91,  -91,  -91,
			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,

			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,
			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,
			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,
			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,
			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,
			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,
			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,
			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,
			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,
			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,

			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,
			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,
			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,
			  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,  -91,
			  -91,  -91,  -91,  -91,    5,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			   90,  -92,  222,  222,  222,  222,  222,  222,  222,  222,

			  222,  222,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,   94,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,

			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,
			  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,  -92,

			  -92,    5,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93, yy_Dummy>>,
			1, 3000, 21000)
		end

	yy_nxt_template_9 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,

			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,
			  -93,  -93,  -93,  -93,  -93,  -93,  -93,  -93,    5,  -94,
			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,

			  -94,  -94,  -94,  -94,  -94,  -94,  223,  223,  223,  223,
			  223,  223,  223,  223,  223,  223,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  143,  -94,  -94,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,

			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,

			  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,  -94,
			  -94,  -94,  -94,  -94,  -94,    5,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,

			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,

			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,  -95,
			  -95,  -95,    5,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,

			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,

			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,

			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,
			  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,  -96,    5,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,

			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,

			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,  -97,
			  -97,  -97,  -97,  -97,  -97,  -97,    5,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,

			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,

			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,

			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,  -98,
			  -98,  -98,  -98,    5,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,

			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,

			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,
			  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,  -99,

			    5, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,

			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,

			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100, -100, -100, -100,
			 -100, -100, -100, -100, -100, -100, -100,    5, -101, -101,
			 -101, -101, -101, -101, -101, -101, -101, -101, -101, -101,
			 -101, -101, -101, -101, -101, -101, -101, -101, -101, -101,
			 -101, -101, -101, -101, -101, -101, -101, -101, -101, -101,
			 -101, -101, -101, -101, -101, -101, -101, -101, -101, -101,

			 -101, -101, -101, -101, -101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -101, -101, -101, -101, -101,
			 -101, -101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -101, -101,
			 -101, -101,  101, -101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -101, -101, -101, -101, -101, -101, -101, -101, -101, -101,
			 -101, -101, -101, -101, -101, -101, -101, -101, -101, -101,

			 -101, -101, -101, -101, -101, -101, -101, -101, -101, -101,
			 -101, -101, -101, -101, -101, -101, -101, -101, -101, -101,
			 -101, -101, -101, -101, -101, -101, -101, -101, -101, -101,
			 -101, -101, -101, -101, -101, -101, -101, -101, -101, -101,
			 -101, -101, -101, -101, -101, -101, -101, -101, -101, -101,
			 -101, -101, -101, -101, -101, -101, -101, -101, -101, -101,
			 -101, -101, -101, -101, -101, -101, -101, -101, -101, -101,
			 -101, -101, -101, -101, -101, -101, -101, -101, -101, -101,
			 -101, -101, -101, -101, -101, -101, -101, -101, -101, -101,
			 -101, -101, -101, -101, -101, -101, -101, -101, -101, -101,

			 -101, -101, -101, -101, -101, -101, -101, -101, -101, -101,
			 -101, -101, -101, -101,    5, -102, -102, -102, -102, -102,
			 -102, -102, -102, -102, -102, -102, -102, -102, -102, -102,
			 -102, -102, -102, -102, -102, -102, -102, -102, -102, -102,
			 -102, -102, -102, -102, -102, -102, -102, -102, -102, -102,
			 -102, -102, -102, -102, -102, -102, -102, -102, -102, -102,
			 -102, -102,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -102, -102, -102, -102, -102, -102, -102,  101,
			  101,  101,  101,  101,  101,  101,  101,  224,  101,  101,
			  225,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101, -102, -102, -102, -102,  101,
			 -102,  101,  101,  101,  101,  101,  101,  101,  101,  224,
			  101,  101,  225,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -102, -102, -102,
			 -102, -102, -102, -102, -102, -102, -102, -102, -102, -102,
			 -102, -102, -102, -102, -102, -102, -102, -102, -102, -102,
			 -102, -102, -102, -102, -102, -102, -102, -102, -102, -102,
			 -102, -102, -102, -102, -102, -102, -102, -102, -102, -102,
			 -102, -102, -102, -102, -102, -102, -102, -102, -102, -102,
			 -102, -102, -102, -102, -102, -102, -102, -102, -102, -102,

			 -102, -102, -102, -102, -102, -102, -102, -102, -102, -102,
			 -102, -102, -102, -102, -102, -102, -102, -102, -102, -102,
			 -102, -102, -102, -102, -102, -102, -102, -102, -102, -102,
			 -102, -102, -102, -102, -102, -102, -102, -102, -102, -102,
			 -102, -102, -102, -102, -102, -102, -102, -102, -102, -102,
			 -102, -102, -102, -102, -102, -102, -102, -102, -102, -102,
			 -102, -102, -102, -102, -102, -102, -102, -102, -102, -102,
			 -102,    5, -103, -103, -103, -103, -103, -103, -103, -103,
			 -103, -103, -103, -103, -103, -103, -103, -103, -103, -103,
			 -103, -103, -103, -103, -103, -103, -103, -103, -103, -103,

			 -103, -103, -103, -103, -103, -103, -103, -103, -103, -103,
			 -103, -103, -103, -103, -103, -103, -103, -103, -103,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -103,
			 -103, -103, -103, -103, -103, -103,  101,  101,  101,  226,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -103, -103, -103, -103,  101, -103,  101,  101,
			  101,  226,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -103, -103, -103, -103, -103, -103,

			 -103, -103, -103, -103, -103, -103, -103, -103, -103, -103,
			 -103, -103, -103, -103, -103, -103, -103, -103, -103, -103,
			 -103, -103, -103, -103, -103, -103, -103, -103, -103, -103,
			 -103, -103, -103, -103, -103, -103, -103, -103, -103, -103,
			 -103, -103, -103, -103, -103, -103, -103, -103, -103, -103,
			 -103, -103, -103, -103, -103, -103, -103, -103, -103, -103,
			 -103, -103, -103, -103, -103, -103, -103, -103, -103, -103,
			 -103, -103, -103, -103, -103, -103, -103, -103, -103, -103,
			 -103, -103, -103, -103, -103, -103, -103, -103, -103, -103,
			 -103, -103, -103, -103, -103, -103, -103, -103, -103, -103,

			 -103, -103, -103, -103, -103, -103, -103, -103, -103, -103,
			 -103, -103, -103, -103, -103, -103, -103, -103, -103, -103,
			 -103, -103, -103, -103, -103, -103, -103, -103,    5, -104,
			 -104, -104, -104, -104, -104, -104, -104, -104, -104, -104,
			 -104, -104, -104, -104, -104, -104, -104, -104, -104, -104,
			 -104, -104, -104, -104, -104, -104, -104, -104, -104, -104,
			 -104, -104, -104, -104, -104, -104, -104, -104, -104, -104,
			 -104, -104, -104, -104, -104, -104,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -104, -104, -104, -104,
			 -104, -104, -104,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -104,
			 -104, -104, -104,  101, -104,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -104, -104, -104, -104, -104, -104, -104, -104, -104,
			 -104, -104, -104, -104, -104, -104, -104, -104, -104, -104,
			 -104, -104, -104, -104, -104, -104, -104, -104, -104, -104,
			 -104, -104, -104, -104, -104, -104, -104, -104, -104, -104,
			 -104, -104, -104, -104, -104, -104, -104, -104, -104, -104,

			 -104, -104, -104, -104, -104, -104, -104, -104, -104, -104,
			 -104, -104, -104, -104, -104, -104, -104, -104, -104, -104,
			 -104, -104, -104, -104, -104, -104, -104, -104, -104, -104,
			 -104, -104, -104, -104, -104, -104, -104, -104, -104, -104,
			 -104, -104, -104, -104, -104, -104, -104, -104, -104, -104,
			 -104, -104, -104, -104, -104, -104, -104, -104, -104, -104,
			 -104, -104, -104, -104, -104, -104, -104, -104, -104, -104,
			 -104, -104, -104, -104, -104, -104, -104, -104, -104, -104,
			 -104, -104, -104, -104, -104,    5, -105, -105, -105, -105,
			 -105, -105, -105, -105, -105, -105, -105, -105, -105, -105, yy_Dummy>>,
			1, 3000, 24000)
		end

	yy_nxt_template_10 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -105, -105, -105, -105, -105, -105, -105, -105, -105, -105,
			 -105, -105, -105, -105, -105, -105, -105, -105, -105, -105,
			 -105, -105, -105, -105, -105, -105, -105, -105, -105, -105,
			 -105, -105, -105,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -105, -105, -105, -105, -105, -105, -105,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  227,
			  101,  101,  101,  101,  101,  101, -105, -105, -105, -105,
			  101, -105,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  227,  101,  101,  101,  101,  101,  101, -105, -105,
			 -105, -105, -105, -105, -105, -105, -105, -105, -105, -105,
			 -105, -105, -105, -105, -105, -105, -105, -105, -105, -105,
			 -105, -105, -105, -105, -105, -105, -105, -105, -105, -105,
			 -105, -105, -105, -105, -105, -105, -105, -105, -105, -105,
			 -105, -105, -105, -105, -105, -105, -105, -105, -105, -105,
			 -105, -105, -105, -105, -105, -105, -105, -105, -105, -105,
			 -105, -105, -105, -105, -105, -105, -105, -105, -105, -105,
			 -105, -105, -105, -105, -105, -105, -105, -105, -105, -105,
			 -105, -105, -105, -105, -105, -105, -105, -105, -105, -105,

			 -105, -105, -105, -105, -105, -105, -105, -105, -105, -105,
			 -105, -105, -105, -105, -105, -105, -105, -105, -105, -105,
			 -105, -105, -105, -105, -105, -105, -105, -105, -105, -105,
			 -105, -105, -105, -105, -105, -105, -105, -105, -105, -105,
			 -105, -105,    5, -106, -106, -106, -106, -106, -106, -106,
			 -106, -106, -106, -106, -106, -106, -106, -106, -106, -106,
			 -106, -106, -106, -106, -106, -106, -106, -106, -106, -106,
			 -106, -106, -106, -106, -106, -106, -106, -106, -106, -106,
			 -106, -106, -106, -106, -106, -106, -106, -106, -106, -106,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			 -106, -106, -106, -106, -106, -106, -106,  101,  101,  101,
			  101,  228,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -106, -106, -106, -106,  101, -106,  101,
			  101,  101,  101,  228,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -106, -106, -106, -106, -106,
			 -106, -106, -106, -106, -106, -106, -106, -106, -106, -106,
			 -106, -106, -106, -106, -106, -106, -106, -106, -106, -106,
			 -106, -106, -106, -106, -106, -106, -106, -106, -106, -106,

			 -106, -106, -106, -106, -106, -106, -106, -106, -106, -106,
			 -106, -106, -106, -106, -106, -106, -106, -106, -106, -106,
			 -106, -106, -106, -106, -106, -106, -106, -106, -106, -106,
			 -106, -106, -106, -106, -106, -106, -106, -106, -106, -106,
			 -106, -106, -106, -106, -106, -106, -106, -106, -106, -106,
			 -106, -106, -106, -106, -106, -106, -106, -106, -106, -106,
			 -106, -106, -106, -106, -106, -106, -106, -106, -106, -106,
			 -106, -106, -106, -106, -106, -106, -106, -106, -106, -106,
			 -106, -106, -106, -106, -106, -106, -106, -106, -106, -106,
			 -106, -106, -106, -106, -106, -106, -106, -106, -106,    5,

			 -107, -107, -107, -107, -107, -107, -107, -107, -107, -107,
			 -107, -107, -107, -107, -107, -107, -107, -107, -107, -107,
			 -107, -107, -107, -107, -107, -107, -107, -107, -107, -107,
			 -107, -107, -107, -107, -107, -107, -107, -107, -107, -107,
			 -107, -107, -107, -107, -107, -107, -107,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -107, -107, -107,
			 -107, -107, -107, -107,  229,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -107, -107, -107, -107,  101, -107,  229,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -107, -107, -107, -107, -107, -107, -107, -107,
			 -107, -107, -107, -107, -107, -107, -107, -107, -107, -107,
			 -107, -107, -107, -107, -107, -107, -107, -107, -107, -107,
			 -107, -107, -107, -107, -107, -107, -107, -107, -107, -107,
			 -107, -107, -107, -107, -107, -107, -107, -107, -107, -107,
			 -107, -107, -107, -107, -107, -107, -107, -107, -107, -107,
			 -107, -107, -107, -107, -107, -107, -107, -107, -107, -107,
			 -107, -107, -107, -107, -107, -107, -107, -107, -107, -107,

			 -107, -107, -107, -107, -107, -107, -107, -107, -107, -107,
			 -107, -107, -107, -107, -107, -107, -107, -107, -107, -107,
			 -107, -107, -107, -107, -107, -107, -107, -107, -107, -107,
			 -107, -107, -107, -107, -107, -107, -107, -107, -107, -107,
			 -107, -107, -107, -107, -107, -107, -107, -107, -107, -107,
			 -107, -107, -107, -107, -107, -107,    5, -108, -108, -108,
			 -108, -108, -108, -108, -108, -108, -108, -108, -108, -108,
			 -108, -108, -108, -108, -108, -108, -108, -108, -108, -108,
			 -108, -108, -108, -108, -108, -108, -108, -108, -108, -108,
			 -108, -108, -108, -108, -108, -108, -108, -108, -108, -108,

			 -108, -108, -108, -108,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -108, -108, -108, -108, -108, -108,
			 -108,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  230,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -108, -108, -108,
			 -108,  101, -108,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  230,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -108,
			 -108, -108, -108, -108, -108, -108, -108, -108, -108, -108,
			 -108, -108, -108, -108, -108, -108, -108, -108, -108, -108,

			 -108, -108, -108, -108, -108, -108, -108, -108, -108, -108,
			 -108, -108, -108, -108, -108, -108, -108, -108, -108, -108,
			 -108, -108, -108, -108, -108, -108, -108, -108, -108, -108,
			 -108, -108, -108, -108, -108, -108, -108, -108, -108, -108,
			 -108, -108, -108, -108, -108, -108, -108, -108, -108, -108,
			 -108, -108, -108, -108, -108, -108, -108, -108, -108, -108,
			 -108, -108, -108, -108, -108, -108, -108, -108, -108, -108,
			 -108, -108, -108, -108, -108, -108, -108, -108, -108, -108,
			 -108, -108, -108, -108, -108, -108, -108, -108, -108, -108,
			 -108, -108, -108, -108, -108, -108, -108, -108, -108, -108,

			 -108, -108, -108, -108, -108, -108, -108, -108, -108, -108,
			 -108, -108, -108,    5, -109, -109, -109, -109, -109, -109,
			 -109, -109, -109, -109, -109, -109, -109, -109, -109, -109,
			 -109, -109, -109, -109, -109, -109, -109, -109, -109, -109,
			 -109, -109, -109, -109, -109, -109, -109, -109, -109, -109,
			 -109, -109, -109, -109, -109, -109, -109, -109, -109, -109,
			 -109,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -109, -109, -109, -109, -109, -109, -109,  101,  101,
			  101,  101,  231,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101, -109, -109, -109, -109,  101, -109,
			  101,  101,  101,  101,  231,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -109, -109, -109, -109,
			 -109, -109, -109, -109, -109, -109, -109, -109, -109, -109,
			 -109, -109, -109, -109, -109, -109, -109, -109, -109, -109,
			 -109, -109, -109, -109, -109, -109, -109, -109, -109, -109,
			 -109, -109, -109, -109, -109, -109, -109, -109, -109, -109,
			 -109, -109, -109, -109, -109, -109, -109, -109, -109, -109,
			 -109, -109, -109, -109, -109, -109, -109, -109, -109, -109,

			 -109, -109, -109, -109, -109, -109, -109, -109, -109, -109,
			 -109, -109, -109, -109, -109, -109, -109, -109, -109, -109,
			 -109, -109, -109, -109, -109, -109, -109, -109, -109, -109,
			 -109, -109, -109, -109, -109, -109, -109, -109, -109, -109,
			 -109, -109, -109, -109, -109, -109, -109, -109, -109, -109,
			 -109, -109, -109, -109, -109, -109, -109, -109, -109, -109,
			 -109, -109, -109, -109, -109, -109, -109, -109, -109, -109,
			    5, -110, -110, -110, -110, -110, -110, -110, -110, -110,
			 -110, -110, -110, -110, -110, -110, -110, -110, -110, -110,
			 -110, -110, -110, -110, -110, -110, -110, -110, -110, -110,

			 -110, -110, -110, -110, -110, -110, -110, -110, -110, -110,
			 -110, -110, -110, -110, -110, -110, -110, -110,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -110, -110,
			 -110, -110, -110, -110, -110,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  232,  101,  101,  101,  101,  101,  101,  101,
			  101, -110, -110, -110, -110,  101, -110,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  232,  101,  101,  101,  101,  101,
			  101,  101,  101, -110, -110, -110, -110, -110, -110, -110,

			 -110, -110, -110, -110, -110, -110, -110, -110, -110, -110,
			 -110, -110, -110, -110, -110, -110, -110, -110, -110, -110,
			 -110, -110, -110, -110, -110, -110, -110, -110, -110, -110,
			 -110, -110, -110, -110, -110, -110, -110, -110, -110, -110,
			 -110, -110, -110, -110, -110, -110, -110, -110, -110, -110,
			 -110, -110, -110, -110, -110, -110, -110, -110, -110, -110,
			 -110, -110, -110, -110, -110, -110, -110, -110, -110, -110,
			 -110, -110, -110, -110, -110, -110, -110, -110, -110, -110,
			 -110, -110, -110, -110, -110, -110, -110, -110, -110, -110,
			 -110, -110, -110, -110, -110, -110, -110, -110, -110, -110,

			 -110, -110, -110, -110, -110, -110, -110, -110, -110, -110,
			 -110, -110, -110, -110, -110, -110, -110, -110, -110, -110,
			 -110, -110, -110, -110, -110, -110, -110,    5, -111, -111,
			 -111, -111, -111, -111, -111, -111, -111, -111, -111, -111,
			 -111, -111, -111, -111, -111, -111, -111, -111, -111, -111,
			 -111, -111, -111, -111, -111, -111, -111, -111, -111, -111,
			 -111, -111, -111, -111, -111, -111, -111, -111, -111, -111,
			 -111, -111, -111, -111, -111,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -111, -111, -111, -111, -111,
			 -111, -111,  101,  233,  101,  101,  101,  234,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -111, -111,
			 -111, -111,  101, -111,  101,  233,  101,  101,  101,  234,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -111, -111, -111, -111, -111, -111, -111, -111, -111, -111,
			 -111, -111, -111, -111, -111, -111, -111, -111, -111, -111,
			 -111, -111, -111, -111, -111, -111, -111, -111, -111, -111,
			 -111, -111, -111, -111, -111, -111, -111, -111, -111, -111,
			 -111, -111, -111, -111, -111, -111, -111, -111, -111, -111,

			 -111, -111, -111, -111, -111, -111, -111, -111, -111, -111,
			 -111, -111, -111, -111, -111, -111, -111, -111, -111, -111,
			 -111, -111, -111, -111, -111, -111, -111, -111, -111, -111,
			 -111, -111, -111, -111, -111, -111, -111, -111, -111, -111,
			 -111, -111, -111, -111, -111, -111, -111, -111, -111, -111,
			 -111, -111, -111, -111, -111, -111, -111, -111, -111, -111,
			 -111, -111, -111, -111, -111, -111, -111, -111, -111, -111,
			 -111, -111, -111, -111, -111, -111, -111, -111, -111, -111,
			 -111, -111, -111, -111,    5, -112, -112, -112, -112, -112,
			 -112, -112, -112, -112, -112, -112, -112, -112, -112, -112,

			 -112, -112, -112, -112, -112, -112, -112, -112, -112, -112,
			 -112, -112, -112, -112, -112, -112, -112, -112, -112, -112,
			 -112, -112, -112, -112, -112, -112, -112, -112, -112, -112,
			 -112, -112,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -112, -112, -112, -112, -112, -112, -112,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -112, -112, -112, -112,  101,
			 -112,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101, -112, -112, -112,
			 -112, -112, -112, -112, -112, -112, -112, -112, -112, -112,
			 -112, -112, -112, -112, -112, -112, -112, -112, -112, -112,
			 -112, -112, -112, -112, -112, -112, -112, -112, -112, -112,
			 -112, -112, -112, -112, -112, -112, -112, -112, -112, -112,
			 -112, -112, -112, -112, -112, -112, -112, -112, -112, -112,
			 -112, -112, -112, -112, -112, -112, -112, -112, -112, -112,
			 -112, -112, -112, -112, -112, -112, -112, -112, -112, -112,
			 -112, -112, -112, -112, -112, -112, -112, -112, -112, -112,
			 -112, -112, -112, -112, -112, -112, -112, -112, -112, -112,

			 -112, -112, -112, -112, -112, -112, -112, -112, -112, -112,
			 -112, -112, -112, -112, -112, -112, -112, -112, -112, -112,
			 -112, -112, -112, -112, -112, -112, -112, -112, -112, -112,
			 -112, -112, -112, -112, -112, -112, -112, -112, -112, -112,
			 -112,    5, -113, -113, -113, -113, -113, -113, -113, -113,
			 -113, -113, -113, -113, -113, -113, -113, -113, -113, -113,
			 -113, -113, -113, -113, -113, -113, -113, -113, -113, -113,
			 -113, -113, -113, -113, -113, -113, -113, -113, -113, -113,
			 -113, -113, -113, -113, -113, -113, -113, -113, -113,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -113,

			 -113, -113, -113, -113, -113, -113,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  235,  101,  101,  101,  101,  101,
			  101,  101, -113, -113, -113, -113,  101, -113,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  235,  101,  101,  101,
			  101,  101,  101,  101, -113, -113, -113, -113, -113, -113,
			 -113, -113, -113, -113, -113, -113, -113, -113, -113, -113,
			 -113, -113, -113, -113, -113, -113, -113, -113, -113, -113,
			 -113, -113, -113, -113, -113, -113, -113, -113, -113, -113,

			 -113, -113, -113, -113, -113, -113, -113, -113, -113, -113,
			 -113, -113, -113, -113, -113, -113, -113, -113, -113, -113,
			 -113, -113, -113, -113, -113, -113, -113, -113, -113, -113,
			 -113, -113, -113, -113, -113, -113, -113, -113, -113, -113,
			 -113, -113, -113, -113, -113, -113, -113, -113, -113, -113,
			 -113, -113, -113, -113, -113, -113, -113, -113, -113, -113,
			 -113, -113, -113, -113, -113, -113, -113, -113, -113, -113,
			 -113, -113, -113, -113, -113, -113, -113, -113, -113, -113,
			 -113, -113, -113, -113, -113, -113, -113, -113, -113, -113,
			 -113, -113, -113, -113, -113, -113, -113, -113,    5, -114,

			 -114, -114, -114, -114, -114, -114, -114, -114, -114, -114,
			 -114, -114, -114, -114, -114, -114, -114, -114, -114, -114,
			 -114, -114, -114, -114, -114, -114, -114, -114, -114, -114,
			 -114, -114, -114, -114, -114, -114, -114, -114, -114, -114,
			 -114, -114, -114, -114, -114, -114,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -114, -114, -114, -114,
			 -114, -114, -114,  101,  101,  101,  236,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  237,  101,  101,  101,  101,  101,  101,  101, -114,
			 -114, -114, -114,  101, -114,  101,  101,  101,  236,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  237,  101,  101,  101,  101,  101,  101,
			  101, -114, -114, -114, -114, -114, -114, -114, -114, -114,
			 -114, -114, -114, -114, -114, -114, -114, -114, -114, -114,
			 -114, -114, -114, -114, -114, -114, -114, -114, -114, -114,
			 -114, -114, -114, -114, -114, -114, -114, -114, -114, -114,
			 -114, -114, -114, -114, -114, -114, -114, -114, -114, -114,
			 -114, -114, -114, -114, -114, -114, -114, -114, -114, -114,
			 -114, -114, -114, -114, -114, -114, -114, -114, -114, -114,
			 -114, -114, -114, -114, -114, -114, -114, -114, -114, -114,

			 -114, -114, -114, -114, -114, -114, -114, -114, -114, -114,
			 -114, -114, -114, -114, -114, -114, -114, -114, -114, -114,
			 -114, -114, -114, -114, -114, -114, -114, -114, -114, -114,
			 -114, -114, -114, -114, -114, -114, -114, -114, -114, -114,
			 -114, -114, -114, -114, -114, -114, -114, -114, -114, -114,
			 -114, -114, -114, -114, -114,    5, -115, -115, -115, -115,
			 -115, -115, -115, -115, -115, -115, -115, -115, -115, -115,
			 -115, -115, -115, -115, -115, -115, -115, -115, -115, -115,
			 -115, -115, -115, -115, -115, -115, -115, -115, -115, -115,
			 -115, -115, -115, -115, -115, -115, -115, -115, -115, -115,

			 -115, -115, -115,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -115, -115, -115, -115, -115, -115, -115,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  238,  101,  101,  101,  239,
			  101,  101,  101,  101,  101,  101, -115, -115, -115, -115,
			  101, -115,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  238,  101,  101,
			  101,  239,  101,  101,  101,  101,  101,  101, -115, -115,
			 -115, -115, -115, -115, -115, -115, -115, -115, -115, -115,
			 -115, -115, -115, -115, -115, -115, -115, -115, -115, -115,

			 -115, -115, -115, -115, -115, -115, -115, -115, -115, -115,
			 -115, -115, -115, -115, -115, -115, -115, -115, -115, -115,
			 -115, -115, -115, -115, -115, -115, -115, -115, -115, -115,
			 -115, -115, -115, -115, -115, -115, -115, -115, -115, -115,
			 -115, -115, -115, -115, -115, -115, -115, -115, -115, -115,
			 -115, -115, -115, -115, -115, -115, -115, -115, -115, -115,
			 -115, -115, -115, -115, -115, -115, -115, -115, -115, -115,
			 -115, -115, -115, -115, -115, -115, -115, -115, -115, -115,
			 -115, -115, -115, -115, -115, -115, -115, -115, -115, -115,
			 -115, -115, -115, -115, -115, -115, -115, -115, -115, -115,

			 -115, -115, -115, -115, -115, -115, -115, -115, -115, -115,
			 -115, -115,    5, -116, -116, -116, -116, -116, -116, -116,
			 -116, -116, -116, -116, -116, -116, -116, -116, -116, -116,
			 -116, -116, -116, -116, -116, -116, -116, -116, -116, -116,
			 -116, -116, -116, -116, -116, -116, -116, -116, -116, -116,
			 -116, -116, -116, -116, -116, -116, -116, -116, -116, -116,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -116, -116, -116, -116, -116, -116, -116,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  240,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101, -116, -116, -116, -116,  101, -116,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  240,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -116, -116, -116, -116, -116,
			 -116, -116, -116, -116, -116, -116, -116, -116, -116, -116,
			 -116, -116, -116, -116, -116, -116, -116, -116, -116, -116,
			 -116, -116, -116, -116, -116, -116, -116, -116, -116, -116,
			 -116, -116, -116, -116, -116, -116, -116, -116, -116, -116,
			 -116, -116, -116, -116, -116, -116, -116, -116, -116, -116,
			 -116, -116, -116, -116, -116, -116, -116, -116, -116, -116, yy_Dummy>>,
			1, 3000, 27000)
		end

	yy_nxt_template_11 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -116, -116, -116, -116, -116, -116, -116, -116, -116, -116,
			 -116, -116, -116, -116, -116, -116, -116, -116, -116, -116,
			 -116, -116, -116, -116, -116, -116, -116, -116, -116, -116,
			 -116, -116, -116, -116, -116, -116, -116, -116, -116, -116,
			 -116, -116, -116, -116, -116, -116, -116, -116, -116, -116,
			 -116, -116, -116, -116, -116, -116, -116, -116, -116, -116,
			 -116, -116, -116, -116, -116, -116, -116, -116, -116,    5,
			 -117, -117, -117, -117, -117, -117, -117, -117, -117, -117,
			 -117, -117, -117, -117, -117, -117, -117, -117, -117, -117,
			 -117, -117, -117, -117, -117, -117, -117, -117, -117, -117,

			 -117, -117, -117, -117, -117, -117, -117, -117, -117, -117,
			 -117, -117, -117, -117, -117, -117, -117,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -117, -117, -117,
			 -117, -117, -117, -117,  241,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -117, -117, -117, -117,  101, -117,  241,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -117, -117, -117, -117, -117, -117, -117, -117,

			 -117, -117, -117, -117, -117, -117, -117, -117, -117, -117,
			 -117, -117, -117, -117, -117, -117, -117, -117, -117, -117,
			 -117, -117, -117, -117, -117, -117, -117, -117, -117, -117,
			 -117, -117, -117, -117, -117, -117, -117, -117, -117, -117,
			 -117, -117, -117, -117, -117, -117, -117, -117, -117, -117,
			 -117, -117, -117, -117, -117, -117, -117, -117, -117, -117,
			 -117, -117, -117, -117, -117, -117, -117, -117, -117, -117,
			 -117, -117, -117, -117, -117, -117, -117, -117, -117, -117,
			 -117, -117, -117, -117, -117, -117, -117, -117, -117, -117,
			 -117, -117, -117, -117, -117, -117, -117, -117, -117, -117,

			 -117, -117, -117, -117, -117, -117, -117, -117, -117, -117,
			 -117, -117, -117, -117, -117, -117, -117, -117, -117, -117,
			 -117, -117, -117, -117, -117, -117,    5, -118, -118, -118,
			 -118, -118, -118, -118, -118, -118, -118, -118, -118, -118,
			 -118, -118, -118, -118, -118, -118, -118, -118, -118, -118,
			 -118, -118, -118, -118, -118, -118, -118, -118, -118, -118,
			 -118, -118, -118, -118, -118, -118, -118, -118, -118, -118,
			 -118, -118, -118, -118,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -118, -118, -118, -118, -118, -118,
			 -118,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  242,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -118, -118, -118,
			 -118,  101, -118,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  242,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -118,
			 -118, -118, -118, -118, -118, -118, -118, -118, -118, -118,
			 -118, -118, -118, -118, -118, -118, -118, -118, -118, -118,
			 -118, -118, -118, -118, -118, -118, -118, -118, -118, -118,
			 -118, -118, -118, -118, -118, -118, -118, -118, -118, -118,
			 -118, -118, -118, -118, -118, -118, -118, -118, -118, -118,

			 -118, -118, -118, -118, -118, -118, -118, -118, -118, -118,
			 -118, -118, -118, -118, -118, -118, -118, -118, -118, -118,
			 -118, -118, -118, -118, -118, -118, -118, -118, -118, -118,
			 -118, -118, -118, -118, -118, -118, -118, -118, -118, -118,
			 -118, -118, -118, -118, -118, -118, -118, -118, -118, -118,
			 -118, -118, -118, -118, -118, -118, -118, -118, -118, -118,
			 -118, -118, -118, -118, -118, -118, -118, -118, -118, -118,
			 -118, -118, -118, -118, -118, -118, -118, -118, -118, -118,
			 -118, -118, -118,    5, -119, -119, -119, -119, -119, -119,
			 -119, -119, -119, -119, -119, -119, -119, -119, -119, -119,

			 -119, -119, -119, -119, -119, -119, -119, -119, -119, -119,
			 -119, -119, -119, -119, -119, -119, -119, -119, -119, -119,
			 -119, -119, -119, -119, -119, -119, -119, -119, -119, -119,
			 -119,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -119, -119, -119, -119, -119, -119, -119,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -119, -119, -119, -119,  101, -119,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101, -119, -119, -119, -119,
			 -119, -119, -119, -119, -119, -119, -119, -119, -119, -119,
			 -119, -119, -119, -119, -119, -119, -119, -119, -119, -119,
			 -119, -119, -119, -119, -119, -119, -119, -119, -119, -119,
			 -119, -119, -119, -119, -119, -119, -119, -119, -119, -119,
			 -119, -119, -119, -119, -119, -119, -119, -119, -119, -119,
			 -119, -119, -119, -119, -119, -119, -119, -119, -119, -119,
			 -119, -119, -119, -119, -119, -119, -119, -119, -119, -119,
			 -119, -119, -119, -119, -119, -119, -119, -119, -119, -119,
			 -119, -119, -119, -119, -119, -119, -119, -119, -119, -119,

			 -119, -119, -119, -119, -119, -119, -119, -119, -119, -119,
			 -119, -119, -119, -119, -119, -119, -119, -119, -119, -119,
			 -119, -119, -119, -119, -119, -119, -119, -119, -119, -119,
			 -119, -119, -119, -119, -119, -119, -119, -119, -119, -119,
			    5, -120, -120, -120, -120, -120, -120, -120, -120, -120,
			 -120, -120, -120, -120, -120, -120, -120, -120, -120, -120,
			 -120, -120, -120, -120, -120, -120, -120, -120, -120, -120,
			 -120, -120, -120, -120, -120, -120, -120, -120, -120, -120,
			 -120, -120, -120, -120, -120, -120, -120, -120,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -120, -120,

			 -120, -120, -120, -120, -120,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  243,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -120, -120, -120, -120,  101, -120,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  243,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -120, -120, -120, -120, -120, -120, -120,
			 -120, -120, -120, -120, -120, -120, -120, -120, -120, -120,
			 -120, -120, -120, -120, -120, -120, -120, -120, -120, -120,
			 -120, -120, -120, -120, -120, -120, -120, -120, -120, -120,

			 -120, -120, -120, -120, -120, -120, -120, -120, -120, -120,
			 -120, -120, -120, -120, -120, -120, -120, -120, -120, -120,
			 -120, -120, -120, -120, -120, -120, -120, -120, -120, -120,
			 -120, -120, -120, -120, -120, -120, -120, -120, -120, -120,
			 -120, -120, -120, -120, -120, -120, -120, -120, -120, -120,
			 -120, -120, -120, -120, -120, -120, -120, -120, -120, -120,
			 -120, -120, -120, -120, -120, -120, -120, -120, -120, -120,
			 -120, -120, -120, -120, -120, -120, -120, -120, -120, -120,
			 -120, -120, -120, -120, -120, -120, -120, -120, -120, -120,
			 -120, -120, -120, -120, -120, -120, -120,    5, -121, -121,

			 -121, -121, -121, -121, -121, -121, -121, -121, -121, -121,
			 -121, -121, -121, -121, -121, -121, -121, -121, -121, -121,
			 -121, -121, -121, -121, -121, -121, -121, -121, -121, -121,
			 -121, -121, -121, -121, -121, -121, -121, -121, -121, -121,
			 -121, -121, -121, -121, -121,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -121, -121, -121, -121, -121,
			 -121, -121,  101,  101,  101,  244,  101,  245,  101,  246,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  247,  101,  101,  248,  101,  101,  101,  101, -121, -121,
			 -121, -121,  101, -121,  101,  101,  101,  244,  101,  245,

			  101,  246,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  247,  101,  101,  248,  101,  101,  101,  101,
			 -121, -121, -121, -121, -121, -121, -121, -121, -121, -121,
			 -121, -121, -121, -121, -121, -121, -121, -121, -121, -121,
			 -121, -121, -121, -121, -121, -121, -121, -121, -121, -121,
			 -121, -121, -121, -121, -121, -121, -121, -121, -121, -121,
			 -121, -121, -121, -121, -121, -121, -121, -121, -121, -121,
			 -121, -121, -121, -121, -121, -121, -121, -121, -121, -121,
			 -121, -121, -121, -121, -121, -121, -121, -121, -121, -121,
			 -121, -121, -121, -121, -121, -121, -121, -121, -121, -121,

			 -121, -121, -121, -121, -121, -121, -121, -121, -121, -121,
			 -121, -121, -121, -121, -121, -121, -121, -121, -121, -121,
			 -121, -121, -121, -121, -121, -121, -121, -121, -121, -121,
			 -121, -121, -121, -121, -121, -121, -121, -121, -121, -121,
			 -121, -121, -121, -121, -121, -121, -121, -121, -121, -121,
			 -121, -121, -121, -121,    5, -122, -122, -122, -122, -122,
			 -122, -122, -122, -122, -122, -122, -122, -122, -122, -122,
			 -122, -122, -122, -122, -122, -122, -122, -122, -122, -122,
			 -122, -122, -122, -122, -122, -122, -122, -122, -122, -122,
			 -122, -122, -122, -122, -122, -122, -122, -122, -122, -122,

			 -122, -122,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -122, -122, -122, -122, -122, -122, -122,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -122, -122, -122, -122,  101,
			 -122,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -122, -122, -122,
			 -122, -122, -122, -122, -122, -122, -122, -122, -122, -122,
			 -122, -122, -122, -122, -122, -122, -122, -122, -122, -122,

			 -122, -122, -122, -122, -122, -122, -122, -122, -122, -122,
			 -122, -122, -122, -122, -122, -122, -122, -122, -122, -122,
			 -122, -122, -122, -122, -122, -122, -122, -122, -122, -122,
			 -122, -122, -122, -122, -122, -122, -122, -122, -122, -122,
			 -122, -122, -122, -122, -122, -122, -122, -122, -122, -122,
			 -122, -122, -122, -122, -122, -122, -122, -122, -122, -122,
			 -122, -122, -122, -122, -122, -122, -122, -122, -122, -122,
			 -122, -122, -122, -122, -122, -122, -122, -122, -122, -122,
			 -122, -122, -122, -122, -122, -122, -122, -122, -122, -122,
			 -122, -122, -122, -122, -122, -122, -122, -122, -122, -122,

			 -122, -122, -122, -122, -122, -122, -122, -122, -122, -122,
			 -122,    5, -123, -123, -123, -123, -123, -123, -123, -123,
			 -123, -123, -123, -123, -123, -123, -123, -123, -123, -123,
			 -123, -123, -123, -123, -123, -123, -123, -123, -123, -123,
			 -123, -123, -123, -123, -123, -123, -123, -123, -123, -123,
			 -123, -123, -123, -123, -123, -123, -123, -123, -123,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -123,
			 -123, -123, -123, -123, -123, -123,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  249,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101, -123, -123, -123, -123,  101, -123,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  249,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -123, -123, -123, -123, -123, -123,
			 -123, -123, -123, -123, -123, -123, -123, -123, -123, -123,
			 -123, -123, -123, -123, -123, -123, -123, -123, -123, -123,
			 -123, -123, -123, -123, -123, -123, -123, -123, -123, -123,
			 -123, -123, -123, -123, -123, -123, -123, -123, -123, -123,
			 -123, -123, -123, -123, -123, -123, -123, -123, -123, -123,
			 -123, -123, -123, -123, -123, -123, -123, -123, -123, -123,

			 -123, -123, -123, -123, -123, -123, -123, -123, -123, -123,
			 -123, -123, -123, -123, -123, -123, -123, -123, -123, -123,
			 -123, -123, -123, -123, -123, -123, -123, -123, -123, -123,
			 -123, -123, -123, -123, -123, -123, -123, -123, -123, -123,
			 -123, -123, -123, -123, -123, -123, -123, -123, -123, -123,
			 -123, -123, -123, -123, -123, -123, -123, -123, -123, -123,
			 -123, -123, -123, -123, -123, -123, -123, -123,    5, -124,
			 -124, -124, -124, -124, -124, -124, -124, -124, -124, -124,
			 -124, -124, -124, -124, -124, -124, -124, -124, -124, -124,
			 -124, -124, -124, -124, -124, -124, -124, -124, -124, -124,

			 -124, -124, -124, -124, -124, -124, -124, -124, -124, -124,
			 -124, -124, -124, -124, -124, -124,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -124, -124, -124, -124,
			 -124, -124, -124,  101,  101,  250,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  251,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -124,
			 -124, -124, -124,  101, -124,  101,  101,  250,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  251,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -124, -124, -124, -124, -124, -124, -124, -124, -124,

			 -124, -124, -124, -124, -124, -124, -124, -124, -124, -124,
			 -124, -124, -124, -124, -124, -124, -124, -124, -124, -124,
			 -124, -124, -124, -124, -124, -124, -124, -124, -124, -124,
			 -124, -124, -124, -124, -124, -124, -124, -124, -124, -124,
			 -124, -124, -124, -124, -124, -124, -124, -124, -124, -124,
			 -124, -124, -124, -124, -124, -124, -124, -124, -124, -124,
			 -124, -124, -124, -124, -124, -124, -124, -124, -124, -124,
			 -124, -124, -124, -124, -124, -124, -124, -124, -124, -124,
			 -124, -124, -124, -124, -124, -124, -124, -124, -124, -124,
			 -124, -124, -124, -124, -124, -124, -124, -124, -124, -124,

			 -124, -124, -124, -124, -124, -124, -124, -124, -124, -124,
			 -124, -124, -124, -124, -124, -124, -124, -124, -124, -124,
			 -124, -124, -124, -124, -124,    5, -125, -125, -125, -125,
			 -125, -125, -125, -125, -125, -125, -125, -125, -125, -125,
			 -125, -125, -125, -125, -125, -125, -125, -125, -125, -125,
			 -125, -125, -125, -125, -125, -125, -125, -125, -125, -125,
			 -125, -125, -125, -125, -125, -125, -125, -125, -125, -125,
			 -125, -125, -125,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -125, -125, -125, -125, -125, -125, -125,
			  101,  101,  101,  252,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -125, -125, -125, -125,
			  101, -125,  101,  101,  101,  252,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -125, -125,
			 -125, -125, -125, -125, -125, -125, -125, -125, -125, -125,
			 -125, -125, -125, -125, -125, -125, -125, -125, -125, -125,
			 -125, -125, -125, -125, -125, -125, -125, -125, -125, -125,
			 -125, -125, -125, -125, -125, -125, -125, -125, -125, -125,
			 -125, -125, -125, -125, -125, -125, -125, -125, -125, -125,

			 -125, -125, -125, -125, -125, -125, -125, -125, -125, -125,
			 -125, -125, -125, -125, -125, -125, -125, -125, -125, -125,
			 -125, -125, -125, -125, -125, -125, -125, -125, -125, -125,
			 -125, -125, -125, -125, -125, -125, -125, -125, -125, -125,
			 -125, -125, -125, -125, -125, -125, -125, -125, -125, -125,
			 -125, -125, -125, -125, -125, -125, -125, -125, -125, -125,
			 -125, -125, -125, -125, -125, -125, -125, -125, -125, -125,
			 -125, -125, -125, -125, -125, -125, -125, -125, -125, -125,
			 -125, -125,    5, -126, -126, -126, -126, -126, -126, -126,
			 -126, -126, -126, -126, -126, -126, -126, -126, -126, -126,

			 -126, -126, -126, -126, -126, -126, -126, -126, -126, -126,
			 -126, -126, -126, -126, -126, -126, -126, -126, -126, -126,
			 -126, -126, -126, -126, -126, -126, -126, -126, -126, -126,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -126, -126, -126, -126, -126, -126, -126,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  253,  101,  101,  101,
			  101,  101,  101, -126, -126, -126, -126,  101, -126,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  253,  101,

			  101,  101,  101,  101,  101, -126, -126, -126, -126, -126,
			 -126, -126, -126, -126, -126, -126, -126, -126, -126, -126,
			 -126, -126, -126, -126, -126, -126, -126, -126, -126, -126,
			 -126, -126, -126, -126, -126, -126, -126, -126, -126, -126,
			 -126, -126, -126, -126, -126, -126, -126, -126, -126, -126,
			 -126, -126, -126, -126, -126, -126, -126, -126, -126, -126,
			 -126, -126, -126, -126, -126, -126, -126, -126, -126, -126,
			 -126, -126, -126, -126, -126, -126, -126, -126, -126, -126,
			 -126, -126, -126, -126, -126, -126, -126, -126, -126, -126,
			 -126, -126, -126, -126, -126, -126, -126, -126, -126, -126,

			 -126, -126, -126, -126, -126, -126, -126, -126, -126, -126,
			 -126, -126, -126, -126, -126, -126, -126, -126, -126, -126,
			 -126, -126, -126, -126, -126, -126, -126, -126, -126, -126,
			 -126, -126, -126, -126, -126, -126, -126, -126, -126,    5,
			 -127, -127, -127, -127, -127, -127, -127, -127, -127, -127,
			 -127, -127, -127, -127, -127, -127, -127, -127, -127, -127,
			 -127, -127, -127, -127, -127, -127, -127, -127, -127, -127,
			 -127, -127, -127, -127, -127, -127, -127, -127, -127, -127,
			 -127, -127, -127, -127, -127, -127, -127,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -127, -127, -127,

			 -127, -127, -127, -127,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  254,  101,  101,  101,  101,  101,  101,  101,
			 -127, -127, -127, -127,  101, -127,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  254,  101,  101,  101,  101,  101,
			  101,  101, -127, -127, -127, -127, -127, -127, -127, -127,
			 -127, -127, -127, -127, -127, -127, -127, -127, -127, -127,
			 -127, -127, -127, -127, -127, -127, -127, -127, -127, -127,
			 -127, -127, -127, -127, -127, -127, -127, -127, -127, -127,

			 -127, -127, -127, -127, -127, -127, -127, -127, -127, -127,
			 -127, -127, -127, -127, -127, -127, -127, -127, -127, -127,
			 -127, -127, -127, -127, -127, -127, -127, -127, -127, -127,
			 -127, -127, -127, -127, -127, -127, -127, -127, -127, -127,
			 -127, -127, -127, -127, -127, -127, -127, -127, -127, -127,
			 -127, -127, -127, -127, -127, -127, -127, -127, -127, -127,
			 -127, -127, -127, -127, -127, -127, -127, -127, -127, -127,
			 -127, -127, -127, -127, -127, -127, -127, -127, -127, -127,
			 -127, -127, -127, -127, -127, -127, -127, -127, -127, -127,
			 -127, -127, -127, -127, -127, -127,    5, -128, -128, -128,

			 -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
			 -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
			 -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
			 -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
			 -128, -128, -128, -128,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -128, -128, -128, -128, -128, -128,
			 -128,  101,  101,  101,  255,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -128, -128, -128,
			 -128,  101, -128,  101,  101,  101,  255,  101,  101,  101, yy_Dummy>>,
			1, 3000, 30000)
		end

	yy_nxt_template_12 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -128,
			 -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
			 -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
			 -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
			 -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
			 -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
			 -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
			 -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
			 -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,

			 -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
			 -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
			 -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
			 -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
			 -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
			 -128, -128, -128,    5, -129, -129, -129, -129, -129, -129,
			 -129, -129, -129, -129, -129, -129, -129, -129, -129, -129,
			 -129, -129, -129, -129, -129, -129, -129, -129, -129, -129,
			 -129, -129, -129, -129, -129, -129, -129, -129, -129, -129,
			 -129, -129, -129, -129, -129, -129, -129, -129, -129, -129,

			 -129,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -129, -129, -129, -129, -129, -129, -129,  101,  101,
			  256,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -129, -129, -129, -129,  101, -129,
			  101,  101,  256,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -129, -129, -129, -129,
			 -129, -129, -129, -129, -129, -129, -129, -129, -129, -129,
			 -129, -129, -129, -129, -129, -129, -129, -129, -129, -129,

			 -129, -129, -129, -129, -129, -129, -129, -129, -129, -129,
			 -129, -129, -129, -129, -129, -129, -129, -129, -129, -129,
			 -129, -129, -129, -129, -129, -129, -129, -129, -129, -129,
			 -129, -129, -129, -129, -129, -129, -129, -129, -129, -129,
			 -129, -129, -129, -129, -129, -129, -129, -129, -129, -129,
			 -129, -129, -129, -129, -129, -129, -129, -129, -129, -129,
			 -129, -129, -129, -129, -129, -129, -129, -129, -129, -129,
			 -129, -129, -129, -129, -129, -129, -129, -129, -129, -129,
			 -129, -129, -129, -129, -129, -129, -129, -129, -129, -129,
			 -129, -129, -129, -129, -129, -129, -129, -129, -129, -129,

			 -129, -129, -129, -129, -129, -129, -129, -129, -129, -129,
			    5, -130, -130, -130, -130, -130, -130, -130, -130, -130,
			 -130, -130, -130, -130, -130, -130, -130, -130, -130, -130,
			 -130, -130, -130, -130, -130, -130, -130, -130, -130, -130,
			 -130, -130, -130, -130, -130, -130, -130, -130, -130, -130,
			 -130, -130, -130, -130, -130, -130, -130, -130,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -130, -130,
			 -130, -130, -130, -130, -130,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101, -130, -130, -130, -130,  101, -130,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -130, -130, -130, -130, -130, -130, -130,
			 -130, -130, -130, -130, -130, -130, -130, -130, -130, -130,
			 -130, -130, -130, -130, -130, -130, -130, -130, -130, -130,
			 -130, -130, -130, -130, -130, -130, -130, -130, -130, -130,
			 -130, -130, -130, -130, -130, -130, -130, -130, -130, -130,
			 -130, -130, -130, -130, -130, -130, -130, -130, -130, -130,
			 -130, -130, -130, -130, -130, -130, -130, -130, -130, -130,

			 -130, -130, -130, -130, -130, -130, -130, -130, -130, -130,
			 -130, -130, -130, -130, -130, -130, -130, -130, -130, -130,
			 -130, -130, -130, -130, -130, -130, -130, -130, -130, -130,
			 -130, -130, -130, -130, -130, -130, -130, -130, -130, -130,
			 -130, -130, -130, -130, -130, -130, -130, -130, -130, -130,
			 -130, -130, -130, -130, -130, -130, -130, -130, -130, -130,
			 -130, -130, -130, -130, -130, -130, -130,    5, -131, -131,
			 -131, -131, -131, -131, -131, -131, -131, -131, -131, -131,
			 -131, -131, -131, -131, -131, -131, -131, -131, -131, -131,
			 -131, -131, -131, -131, -131, -131, -131, -131, -131, -131,

			 -131, -131, -131, -131, -131, -131, -131, -131, -131, -131,
			 -131, -131, -131, -131, -131,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -131, -131, -131, -131, -131,
			 -131, -131,  101,  101,  101,  101,  257,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -131, -131,
			 -131, -131,  101, -131,  101,  101,  101,  101,  257,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -131, -131, -131, -131, -131, -131, -131, -131, -131, -131,

			 -131, -131, -131, -131, -131, -131, -131, -131, -131, -131,
			 -131, -131, -131, -131, -131, -131, -131, -131, -131, -131,
			 -131, -131, -131, -131, -131, -131, -131, -131, -131, -131,
			 -131, -131, -131, -131, -131, -131, -131, -131, -131, -131,
			 -131, -131, -131, -131, -131, -131, -131, -131, -131, -131,
			 -131, -131, -131, -131, -131, -131, -131, -131, -131, -131,
			 -131, -131, -131, -131, -131, -131, -131, -131, -131, -131,
			 -131, -131, -131, -131, -131, -131, -131, -131, -131, -131,
			 -131, -131, -131, -131, -131, -131, -131, -131, -131, -131,
			 -131, -131, -131, -131, -131, -131, -131, -131, -131, -131,

			 -131, -131, -131, -131, -131, -131, -131, -131, -131, -131,
			 -131, -131, -131, -131, -131, -131, -131, -131, -131, -131,
			 -131, -131, -131, -131,    5, -132, -132, -132, -132, -132,
			 -132, -132, -132, -132, -132, -132, -132, -132, -132, -132,
			 -132, -132, -132, -132, -132, -132, -132, -132, -132, -132,
			 -132, -132, -132, -132, -132, -132, -132, -132, -132, -132,
			 -132, -132, -132, -132, -132, -132, -132, -132, -132, -132,
			 -132, -132,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -132, -132, -132, -132, -132, -132, -132,  101,
			  101,  101,  258,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  259,  101,  101,  260,  101,  261,  262,  101,
			  101,  101,  101,  101,  101, -132, -132, -132, -132,  101,
			 -132,  101,  101,  101,  258,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  259,  101,  101,  260,  101,  261,
			  262,  101,  101,  101,  101,  101,  101, -132, -132, -132,
			 -132, -132, -132, -132, -132, -132, -132, -132, -132, -132,
			 -132, -132, -132, -132, -132, -132, -132, -132, -132, -132,
			 -132, -132, -132, -132, -132, -132, -132, -132, -132, -132,
			 -132, -132, -132, -132, -132, -132, -132, -132, -132, -132,
			 -132, -132, -132, -132, -132, -132, -132, -132, -132, -132,

			 -132, -132, -132, -132, -132, -132, -132, -132, -132, -132,
			 -132, -132, -132, -132, -132, -132, -132, -132, -132, -132,
			 -132, -132, -132, -132, -132, -132, -132, -132, -132, -132,
			 -132, -132, -132, -132, -132, -132, -132, -132, -132, -132,
			 -132, -132, -132, -132, -132, -132, -132, -132, -132, -132,
			 -132, -132, -132, -132, -132, -132, -132, -132, -132, -132,
			 -132, -132, -132, -132, -132, -132, -132, -132, -132, -132,
			 -132, -132, -132, -132, -132, -132, -132, -132, -132, -132,
			 -132,    5, -133, -133, -133, -133, -133, -133, -133, -133,
			 -133, -133, -133, -133, -133, -133, -133, -133, -133, -133,

			 -133, -133, -133, -133, -133, -133, -133, -133, -133, -133,
			 -133, -133, -133, -133, -133, -133, -133, -133, -133, -133,
			 -133, -133, -133, -133, -133, -133, -133, -133, -133,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -133,
			 -133, -133, -133, -133, -133, -133,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  263,  101,  101,
			  101,  264,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -133, -133, -133, -133,  101, -133,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  263,
			  101,  101,  101,  264,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101, -133, -133, -133, -133, -133, -133,
			 -133, -133, -133, -133, -133, -133, -133, -133, -133, -133,
			 -133, -133, -133, -133, -133, -133, -133, -133, -133, -133,
			 -133, -133, -133, -133, -133, -133, -133, -133, -133, -133,
			 -133, -133, -133, -133, -133, -133, -133, -133, -133, -133,
			 -133, -133, -133, -133, -133, -133, -133, -133, -133, -133,
			 -133, -133, -133, -133, -133, -133, -133, -133, -133, -133,
			 -133, -133, -133, -133, -133, -133, -133, -133, -133, -133,
			 -133, -133, -133, -133, -133, -133, -133, -133, -133, -133,
			 -133, -133, -133, -133, -133, -133, -133, -133, -133, -133,

			 -133, -133, -133, -133, -133, -133, -133, -133, -133, -133,
			 -133, -133, -133, -133, -133, -133, -133, -133, -133, -133,
			 -133, -133, -133, -133, -133, -133, -133, -133, -133, -133,
			 -133, -133, -133, -133, -133, -133, -133, -133,    5, -134,
			 -134, -134, -134, -134, -134, -134, -134, -134, -134, -134,
			 -134, -134, -134, -134, -134, -134, -134, -134, -134, -134,
			 -134, -134, -134, -134, -134, -134, -134, -134, -134, -134,
			 -134, -134, -134, -134, -134, -134, -134, -134, -134, -134,
			 -134, -134, -134, -134, -134, -134,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -134, -134, -134, -134,

			 -134, -134, -134,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  265,  101,  101,  101,  101,  101,  101,  101,  101, -134,
			 -134, -134, -134,  101, -134,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  265,  101,  101,  101,  101,  101,  101,  101,
			  101, -134, -134, -134, -134, -134, -134, -134, -134, -134,
			 -134, -134, -134, -134, -134, -134, -134, -134, -134, -134,
			 -134, -134, -134, -134, -134, -134, -134, -134, -134, -134,
			 -134, -134, -134, -134, -134, -134, -134, -134, -134, -134,

			 -134, -134, -134, -134, -134, -134, -134, -134, -134, -134,
			 -134, -134, -134, -134, -134, -134, -134, -134, -134, -134,
			 -134, -134, -134, -134, -134, -134, -134, -134, -134, -134,
			 -134, -134, -134, -134, -134, -134, -134, -134, -134, -134,
			 -134, -134, -134, -134, -134, -134, -134, -134, -134, -134,
			 -134, -134, -134, -134, -134, -134, -134, -134, -134, -134,
			 -134, -134, -134, -134, -134, -134, -134, -134, -134, -134,
			 -134, -134, -134, -134, -134, -134, -134, -134, -134, -134,
			 -134, -134, -134, -134, -134, -134, -134, -134, -134, -134,
			 -134, -134, -134, -134, -134,    5, -135, -135, -135, -135,

			 -135, -135, -135, -135, -135, -135, -135, -135, -135, -135,
			 -135, -135, -135, -135, -135, -135, -135, -135, -135, -135,
			 -135, -135, -135, -135, -135, -135, -135, -135, -135, -135,
			 -135, -135, -135, -135, -135, -135, -135, -135, -135, -135,
			 -135, -135, -135,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -135, -135, -135, -135, -135, -135, -135,
			  101,  101,  101,  101,  266,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -135, -135, -135, -135,
			  101, -135,  101,  101,  101,  101,  266,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -135, -135,
			 -135, -135, -135, -135, -135, -135, -135, -135, -135, -135,
			 -135, -135, -135, -135, -135, -135, -135, -135, -135, -135,
			 -135, -135, -135, -135, -135, -135, -135, -135, -135, -135,
			 -135, -135, -135, -135, -135, -135, -135, -135, -135, -135,
			 -135, -135, -135, -135, -135, -135, -135, -135, -135, -135,
			 -135, -135, -135, -135, -135, -135, -135, -135, -135, -135,
			 -135, -135, -135, -135, -135, -135, -135, -135, -135, -135,
			 -135, -135, -135, -135, -135, -135, -135, -135, -135, -135,

			 -135, -135, -135, -135, -135, -135, -135, -135, -135, -135,
			 -135, -135, -135, -135, -135, -135, -135, -135, -135, -135,
			 -135, -135, -135, -135, -135, -135, -135, -135, -135, -135,
			 -135, -135, -135, -135, -135, -135, -135, -135, -135, -135,
			 -135, -135, -135, -135, -135, -135, -135, -135, -135, -135,
			 -135, -135,    5, -136, -136, -136, -136, -136, -136, -136,
			 -136, -136, -136, -136, -136, -136, -136, -136, -136, -136,
			 -136, -136, -136, -136, -136, -136, -136, -136, -136, -136,
			 -136, -136, -136, -136, -136, -136, -136, -136, -136, -136,
			 -136, -136, -136, -136, -136, -136, -136, -136, -136, -136,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -136, -136, -136, -136, -136, -136, -136,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  267,  101,  101,
			  101,  101,  101, -136, -136, -136, -136,  101, -136,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  267,
			  101,  101,  101,  101,  101, -136, -136, -136, -136, -136,
			 -136, -136, -136, -136, -136, -136, -136, -136, -136, -136,
			 -136, -136, -136, -136, -136, -136, -136, -136, -136, -136,

			 -136, -136, -136, -136, -136, -136, -136, -136, -136, -136,
			 -136, -136, -136, -136, -136, -136, -136, -136, -136, -136,
			 -136, -136, -136, -136, -136, -136, -136, -136, -136, -136,
			 -136, -136, -136, -136, -136, -136, -136, -136, -136, -136,
			 -136, -136, -136, -136, -136, -136, -136, -136, -136, -136,
			 -136, -136, -136, -136, -136, -136, -136, -136, -136, -136,
			 -136, -136, -136, -136, -136, -136, -136, -136, -136, -136,
			 -136, -136, -136, -136, -136, -136, -136, -136, -136, -136,
			 -136, -136, -136, -136, -136, -136, -136, -136, -136, -136,
			 -136, -136, -136, -136, -136, -136, -136, -136, -136, -136,

			 -136, -136, -136, -136, -136, -136, -136, -136, -136,    5,
			 -137, -137, -137, -137, -137, -137, -137, -137, -137, -137,
			 -137, -137, -137, -137, -137, -137, -137, -137, -137, -137,
			 -137, -137, -137, -137, -137, -137, -137, -137, -137, -137,
			 -137, -137, -137, -137, -137, -137, -137, -137, -137, -137,
			 -137, -137, -137, -137, -137, -137, -137,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -137, -137, -137,
			 -137, -137, -137, -137,  101,  101,  101,  268,  101,  101,
			  101,  101,  269,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  270,  101,  101,  101,  101,  101,  101,

			 -137, -137, -137, -137,  101, -137,  101,  101,  101,  268,
			  101,  101,  101,  101,  269,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  270,  101,  101,  101,  101,
			  101,  101, -137, -137, -137, -137, -137, -137, -137, -137,
			 -137, -137, -137, -137, -137, -137, -137, -137, -137, -137,
			 -137, -137, -137, -137, -137, -137, -137, -137, -137, -137,
			 -137, -137, -137, -137, -137, -137, -137, -137, -137, -137,
			 -137, -137, -137, -137, -137, -137, -137, -137, -137, -137,
			 -137, -137, -137, -137, -137, -137, -137, -137, -137, -137,
			 -137, -137, -137, -137, -137, -137, -137, -137, -137, -137,

			 -137, -137, -137, -137, -137, -137, -137, -137, -137, -137,
			 -137, -137, -137, -137, -137, -137, -137, -137, -137, -137,
			 -137, -137, -137, -137, -137, -137, -137, -137, -137, -137,
			 -137, -137, -137, -137, -137, -137, -137, -137, -137, -137,
			 -137, -137, -137, -137, -137, -137, -137, -137, -137, -137,
			 -137, -137, -137, -137, -137, -137, -137, -137, -137, -137,
			 -137, -137, -137, -137, -137, -137,    5, -138, -138, -138,
			 -138, -138, -138, -138, -138, -138, -138, -138, -138, -138,
			 -138, -138, -138, -138, -138, -138, -138, -138, -138, -138,
			 -138, -138, -138, -138, -138, -138, -138, -138, -138, -138,

			 -138, -138, -138, -138, -138, -138, -138, -138, -138, -138,
			 -138, -138, -138, -138,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -138, -138, -138, -138, -138, -138,
			 -138,  101,  101,  101,  101,  271,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -138, -138, -138,
			 -138,  101, -138,  101,  101,  101,  101,  271,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -138,
			 -138, -138, -138, -138, -138, -138, -138, -138, -138, -138,

			 -138, -138, -138, -138, -138, -138, -138, -138, -138, -138,
			 -138, -138, -138, -138, -138, -138, -138, -138, -138, -138,
			 -138, -138, -138, -138, -138, -138, -138, -138, -138, -138,
			 -138, -138, -138, -138, -138, -138, -138, -138, -138, -138,
			 -138, -138, -138, -138, -138, -138, -138, -138, -138, -138,
			 -138, -138, -138, -138, -138, -138, -138, -138, -138, -138,
			 -138, -138, -138, -138, -138, -138, -138, -138, -138, -138,
			 -138, -138, -138, -138, -138, -138, -138, -138, -138, -138,
			 -138, -138, -138, -138, -138, -138, -138, -138, -138, -138,
			 -138, -138, -138, -138, -138, -138, -138, -138, -138, -138,

			 -138, -138, -138, -138, -138, -138, -138, -138, -138, -138,
			 -138, -138, -138, -138, -138, -138, -138, -138, -138, -138,
			 -138, -138, -138,    5, -139, -139, -139, -139, -139, -139,
			 -139, -139, -139, -139, -139, -139, -139, -139, -139, -139,
			 -139, -139, -139, -139, -139, -139, -139, -139, -139, -139,
			 -139, -139, -139, -139, -139, -139, -139, -139, -139, -139,
			 -139, -139, -139, -139, -139, -139, -139, -139, -139, -139,
			 -139,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -139, -139, -139, -139, -139, -139, -139,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  272,  101,  101,  101,  101,
			  101,  101,  101,  101, -139, -139, -139, -139,  101, -139,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  272,  101,  101,
			  101,  101,  101,  101,  101,  101, -139, -139, -139, -139,
			 -139, -139, -139, -139, -139, -139, -139, -139, -139, -139,
			 -139, -139, -139, -139, -139, -139, -139, -139, -139, -139,
			 -139, -139, -139, -139, -139, -139, -139, -139, -139, -139,
			 -139, -139, -139, -139, -139, -139, -139, -139, -139, -139,
			 -139, -139, -139, -139, -139, -139, -139, -139, -139, -139,

			 -139, -139, -139, -139, -139, -139, -139, -139, -139, -139,
			 -139, -139, -139, -139, -139, -139, -139, -139, -139, -139,
			 -139, -139, -139, -139, -139, -139, -139, -139, -139, -139,
			 -139, -139, -139, -139, -139, -139, -139, -139, -139, -139,
			 -139, -139, -139, -139, -139, -139, -139, -139, -139, -139,
			 -139, -139, -139, -139, -139, -139, -139, -139, -139, -139,
			 -139, -139, -139, -139, -139, -139, -139, -139, -139, -139,
			 -139, -139, -139, -139, -139, -139, -139, -139, -139, -139,
			    5, -140, -140, -140, -140, -140, -140, -140, -140, -140,
			 -140, -140, -140, -140, -140, -140, -140, -140, -140, -140, yy_Dummy>>,
			1, 3000, 33000)
		end

	yy_nxt_template_13 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -140, -140, -140, -140, -140, -140, -140, -140, -140, -140,
			 -140, -140, -140, -140, -140, -140, -140, -140, -140, -140,
			 -140, -140, -140, -140, -140, -140, -140, -140,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -140, -140,
			 -140, -140, -140, -140, -140,  101,  101,  101,  101,  273,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -140, -140, -140, -140,  101, -140,  101,  101,  101,
			  101,  273,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101, -140, -140, -140, -140, -140, -140, -140,
			 -140, -140, -140, -140, -140, -140, -140, -140, -140, -140,
			 -140, -140, -140, -140, -140, -140, -140, -140, -140, -140,
			 -140, -140, -140, -140, -140, -140, -140, -140, -140, -140,
			 -140, -140, -140, -140, -140, -140, -140, -140, -140, -140,
			 -140, -140, -140, -140, -140, -140, -140, -140, -140, -140,
			 -140, -140, -140, -140, -140, -140, -140, -140, -140, -140,
			 -140, -140, -140, -140, -140, -140, -140, -140, -140, -140,
			 -140, -140, -140, -140, -140, -140, -140, -140, -140, -140,
			 -140, -140, -140, -140, -140, -140, -140, -140, -140, -140,

			 -140, -140, -140, -140, -140, -140, -140, -140, -140, -140,
			 -140, -140, -140, -140, -140, -140, -140, -140, -140, -140,
			 -140, -140, -140, -140, -140, -140, -140, -140, -140, -140,
			 -140, -140, -140, -140, -140, -140, -140,    5, -141, -141,
			 -141, -141, -141, -141, -141, -141, -141, -141, -141, -141,
			 -141, -141, -141, -141, -141, -141, -141, -141, -141, -141,
			 -141, -141, -141, -141, -141, -141, -141, -141, -141, -141,
			 -141, -141, -141, -141, -141, -141, -141, -141, -141, -141,
			 -141, -141, -141, -141, -141,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -141, -141, -141, -141, -141,

			 -141, -141,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  274,
			  101,  101,  101,  101,  101,  101,  101,  101, -141, -141,
			 -141, -141,  101, -141,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  274,  101,  101,  101,  101,  101,  101,  101,  101,
			 -141, -141, -141, -141, -141, -141, -141, -141, -141, -141,
			 -141, -141, -141, -141, -141, -141, -141, -141, -141, -141,
			 -141, -141, -141, -141, -141, -141, -141, -141, -141, -141,
			 -141, -141, -141, -141, -141, -141, -141, -141, -141, -141,

			 -141, -141, -141, -141, -141, -141, -141, -141, -141, -141,
			 -141, -141, -141, -141, -141, -141, -141, -141, -141, -141,
			 -141, -141, -141, -141, -141, -141, -141, -141, -141, -141,
			 -141, -141, -141, -141, -141, -141, -141, -141, -141, -141,
			 -141, -141, -141, -141, -141, -141, -141, -141, -141, -141,
			 -141, -141, -141, -141, -141, -141, -141, -141, -141, -141,
			 -141, -141, -141, -141, -141, -141, -141, -141, -141, -141,
			 -141, -141, -141, -141, -141, -141, -141, -141, -141, -141,
			 -141, -141, -141, -141, -141, -141, -141, -141, -141, -141,
			 -141, -141, -141, -141,    5, -142, -142, -142, -142, -142,

			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,

			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,

			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142, -142, -142, -142, -142, -142, -142, -142, -142, -142,
			 -142,    5, -143, -143, -143, -143, -143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143,  143,

			  143,  143,  143,  143,  143,  143,  143,  143,  143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143,  143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,

			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,
			 -143, -143, -143, -143, -143, -143, -143, -143, -143, -143,

			 -143, -143, -143, -143, -143, -143, -143, -143,    5,  144,
			  144,  144,  144,  144,  144,  144,  144,  144, -144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  145,  144,  144, -144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,

			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,

			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,  144,  144,  144,  144,  144,
			  144,  144,  144,  144,  144,    5, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,

			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,

			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,

			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145, -145, -145, -145, -145, -145, -145, -145, -145,
			 -145, -145,    5, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,

			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,

			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146, -146,
			 -146, -146, -146, -146, -146, -146, -146, -146, -146,    5,
			 -147, -147, -147, -147, -147, -147, -147, -147,  275,  148,
			 -147, -147,  275, -147, -147, -147, -147, -147, -147, -147,

			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147,  275, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,

			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,

			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147, -147, -147, -147, -147, -147, -147, -147, -147, -147,
			 -147, -147, -147, -147, -147, -147,    5, -148, -148, -148,
			 -148, -148, -148, -148, -148,  148, -148, -148, -148,  148,
			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148, -148, -148, -148, -148, -148,  148, -148,
			 -148, -148, -148,  276, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,

			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,

			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148, -148, -148, -148, -148, -148, -148, -148,
			 -148, -148, -148,    5, -149, -149, -149, -149, -149, -149,

			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,

			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,

			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			 -149, -149, -149, -149, -149, -149, -149, -149, -149, -149,
			    5, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,

			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,

			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,
			 -150, -150, -150, -150, -150, -150, -150, -150, -150, -150,

			 -150, -150, -150, -150, -150, -150, -150,    5, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,

			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151, yy_Dummy>>,
			1, 3000, 36000)
		end

	yy_nxt_template_14 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151, -151, -151, -151, -151, -151, -151,
			 -151, -151, -151, -151,    5, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,

			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,

			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,

			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152, -152, -152, -152, -152, -152, -152, -152, -152, -152,
			 -152,    5, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,

			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,

			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153, -153, -153,
			 -153, -153, -153, -153, -153, -153, -153, -153,    5, -154,
			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,

			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154, -154,  277,  277,  277,  277,
			  277,  277,  277,  277,  277,  277, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,

			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,

			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154, -154, -154, -154, -154, -154,
			 -154, -154, -154, -154, -154,    5, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,

			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,

			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155, -155, -155, -155, -155, -155, -155, -155, -155,
			 -155, -155,    5, -156, -156, -156, -156, -156, -156, -156,

			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,

			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,

			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156, -156,
			 -156, -156, -156, -156, -156, -156, -156, -156, -156,    5,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,

			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,

			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,
			 -157, -157, -157, -157, -157, -157, -157, -157, -157, -157,

			 -157, -157, -157, -157, -157, -157,    5, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,

			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,

			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158, -158, -158, -158, -158, -158, -158, -158,
			 -158, -158, -158,    5, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,

			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,

			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,

			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			 -159, -159, -159, -159, -159, -159, -159, -159, -159, -159,
			    5, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,

			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,

			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160, -160, -160, -160,
			 -160, -160, -160, -160, -160, -160, -160,    5, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,

			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,

			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,

			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161, -161, -161, -161, -161, -161, -161,
			 -161, -161, -161, -161,    5, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,

			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,

			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162, -162, -162, -162, -162, -162, -162, -162, -162, -162,
			 -162,    5, -163, -163, -163, -163, -163, -163, -163, -163,

			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163, yy_Dummy>>,
			1, 3000, 39000)
		end

	yy_nxt_template_15 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,

			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163, -163, -163,
			 -163, -163, -163, -163, -163, -163, -163, -163,    5, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,

			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,

			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,
			 -164, -164, -164, -164, -164, -164, -164, -164, -164, -164,

			 -164, -164, -164, -164, -164,    5, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,

			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,

			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165, -165, -165, -165, -165, -165, -165, -165, -165,
			 -165, -165,    5, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,

			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,

			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,

			 -166, -166, -166, -166, -166, -166, -166, -166, -166, -166,
			 -166, -166, -166, -166, -166, -166, -166, -166, -166,    5,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,

			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,

			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167, -167, -167, -167, -167,
			 -167, -167, -167, -167, -167, -167,    5, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,

			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,

			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,

			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168, -168, -168, -168, -168, -168, -168, -168,
			 -168, -168, -168,    5, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,

			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,

			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			 -169, -169, -169, -169, -169, -169, -169, -169, -169, -169,
			    5, -170, -170, -170, -170, -170, -170, -170, -170, -170,

			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,

			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,

			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170, -170, -170, -170,
			 -170, -170, -170, -170, -170, -170, -170,    5, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,

			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,

			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,
			 -171, -171, -171, -171, -171, -171, -171, -171, -171, -171,

			 -171, -171, -171, -171,    5, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,

			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,

			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172, -172, -172, -172, -172, -172, -172, -172, -172, -172,
			 -172,    5, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,

			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,

			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,

			 -173, -173, -173, -173, -173, -173, -173, -173, -173, -173,
			 -173, -173, -173, -173, -173, -173, -173, -173,    5, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,

			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,

			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174, -174, -174, -174, -174, -174,
			 -174, -174, -174, -174, -174,    5, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175, yy_Dummy>>,
			1, 3000, 42000)
		end

	yy_nxt_template_16 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,

			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,

			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175, -175, -175, -175, -175, -175, -175, -175, -175,
			 -175, -175,    5,   64,   64,   64,   64,   64,   64,   64,
			   64,   64, -176,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,  278,   64,   64, -176,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,    5,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,

			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,

			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,

			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177, -177, -177, -177, -177,
			 -177, -177, -177, -177, -177, -177,    5,   64,   64,   64,
			   64,   64,   64,   64,   64,   64, -178,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			  279,   64,   64, -178,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,    5, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,

			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,

			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			 -179, -179, -179, -179, -179, -179, -179, -179, -179, -179,
			    5,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			 -180,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,  280,   64,   64, -180,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,    5,   64,   64,
			   64,   64,   64,   64,   64,   64,   64, -181,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   65,   64,   64, -181,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,  281,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,  281,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,    5,   64,   64,   64,   64,   64,
			   64,   64,   64,   64, -182,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   65,   64,
			   64, -182,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,  282,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,  282,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,    5,   64,   64,   64,   64,   64,   64,   64,   64,
			   64, -183,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   65,   64,   64, -183,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,  283,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,  283,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,    5,   64,
			   64,   64,   64,   64,   64,   64,   64,   64, -184,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			  284,   64,  285,   64,   64, -184,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,    5,   64,   64,   64,   64,
			   64,   64,   64,   64,   64, -185,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   65,
			   64,   64, -185,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,  286,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,  286,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,    5,   64,   64,   64,   64,   64,   64,   64,
			   64,   64, -186,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,  287,   64,   64, -186,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64, yy_Dummy>>,
			1, 3000, 45000)
		end

	yy_nxt_template_17 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,    5,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,

			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,

			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,

			 -187, -187, -187, -187, -187, -187, -187, -187, -187, -187,
			 -187, -187, -187, -187, -187, -187,    5, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,

			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,

			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188, -188, -188, -188, -188, -188, -188, -188,
			 -188, -188, -188,    5, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,

			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,

			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,

			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			 -189, -189, -189, -189, -189, -189, -189, -189, -189, -189,
			    5, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190,  288,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,

			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,

			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190, -190, -190, -190,
			 -190, -190, -190, -190, -190, -190, -190,    5, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,

			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191,  289, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,

			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,

			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191, -191, -191, -191, -191, -191, -191,
			 -191, -191, -191, -191,    5, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192,  290, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,

			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,

			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,
			 -192, -192, -192, -192, -192, -192, -192, -192, -192, -192,

			 -192,    5, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			  291, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,

			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,

			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193, -193, -193,
			 -193, -193, -193, -193, -193, -193, -193, -193,    5, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194,  292, -194, -194,

			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,

			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,

			 -194, -194, -194, -194, -194, -194, -194, -194, -194, -194,
			 -194, -194, -194, -194, -194,    5, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195,  293, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,

			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,

			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195, -195, -195, -195, -195, -195, -195, -195, -195,
			 -195, -195,    5, -196, -196, -196, -196, -196, -196, -196,
			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,
			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,

			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,
			 -196,  288, -196, -196, -196, -196, -196, -196, -196, -196,
			  294,  294,  294,  294,  294,  294,  294,  294,  294,  294,
			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,
			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,
			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,
			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,
			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,
			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,
			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,

			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,
			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,
			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,
			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,
			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,
			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,
			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,
			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,
			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,
			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,

			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,
			 -196, -196, -196, -196, -196, -196, -196, -196, -196, -196,
			 -196, -196, -196, -196, -196, -196, -196, -196, -196,    5,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197,  295, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,

			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,

			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197, -197, -197, -197, -197,
			 -197, -197, -197, -197, -197, -197,    5, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,

			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198,  296, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198, yy_Dummy>>,
			1, 3000, 48000)
		end

	yy_nxt_template_18 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,

			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198, -198, -198, -198, -198, -198, -198, -198,
			 -198, -198, -198,    5, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199,  297, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,

			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,

			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,
			 -199, -199, -199, -199, -199, -199, -199, -199, -199, -199,

			    5, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200,  298,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,

			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,

			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200, -200, -200, -200,
			 -200, -200, -200, -200, -200, -200, -200,    5, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201,  299, -201, -201, -201,

			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,

			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,

			 -201, -201, -201, -201, -201, -201, -201, -201, -201, -201,
			 -201, -201, -201, -201,    5, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202,  300, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,

			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,

			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202, -202, -202, -202, -202, -202, -202, -202, -202, -202,
			 -202,    5, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,

			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			  301, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,

			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,

			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203, -203, -203,
			 -203, -203, -203, -203, -203, -203, -203, -203,    5, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204,  302, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,

			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,

			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204, -204, -204, -204, -204, -204,
			 -204, -204, -204, -204, -204,    5, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,

			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205,  303, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,

			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,

			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205, -205, -205, -205, -205, -205, -205, -205, -205,
			 -205, -205,    5, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206,  304, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,

			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,

			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206, -206,
			 -206, -206, -206, -206, -206, -206, -206, -206, -206,    5,

			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207,  305, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,

			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,

			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207, -207, -207, -207, -207,
			 -207, -207, -207, -207, -207, -207,    5, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208,  306, -208, -208, -208, -208,

			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,

			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,

			 -208, -208, -208, -208, -208, -208, -208, -208, -208, -208,
			 -208, -208, -208,    5, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209,  307, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,

			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,

			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			 -209, -209, -209, -209, -209, -209, -209, -209, -209, -209,
			    5, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210, yy_Dummy>>,
			1, 3000, 51000)
		end

	yy_nxt_template_19 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -210, -210, -210, -210, -210, -210, -210, -210, -210,  308,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,

			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,

			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210, -210, -210, -210,
			 -210, -210, -210, -210, -210, -210, -210,    5, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211,  309, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,

			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,

			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211, -211, -211, -211, -211, -211, -211,
			 -211, -211, -211, -211,    5, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,

			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212,  310, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,

			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,

			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212, -212, -212, -212, -212, -212, -212, -212, -212, -212,
			 -212,    5, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,

			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,

			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213, -213, -213,
			 -213, -213, -213, -213, -213, -213, -213, -213,    5, -214,

			 -214, -214, -214, -214, -214, -214, -214,  214, -214, -214,
			 -214,  214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			  214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,

			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,

			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214, -214, -214, -214, -214, -214,
			 -214, -214, -214, -214, -214,    5, -215, -215, -215, -215,
			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,
			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,
			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,
			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,

			 -215, -215, -215,  311,  311,  311,  311,  311,  311,  311,
			  311,  311,  311, -215, -215, -215, -215, -215, -215, -215,
			 -215, -215, -215, -215,  216, -215, -215, -215, -215, -215,
			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,
			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,
			  217, -215, -215, -215, -215, -215,  216, -215, -215, -215,
			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,
			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,
			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,
			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,

			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,
			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,
			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,
			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,
			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,
			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,
			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,
			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,
			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,
			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,

			 -215, -215, -215, -215, -215, -215, -215, -215, -215, -215,
			 -215, -215,    5, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216,  312, -216,  312, -216, -216,
			  313,  313,  313,  313,  313,  313,  313,  313,  313,  313,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,

			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,

			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216, -216,
			 -216, -216, -216, -216, -216, -216, -216, -216, -216,    5,
			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,

			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217, -217,  314,  314,  314,
			  314,  314,  314,  314,  314,  314,  314, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,

			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,

			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217, -217, -217, -217, -217,
			 -217, -217, -217, -217, -217, -217,    5, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,

			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,

			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218, -218, -218, -218, -218, -218, -218, -218,
			 -218, -218, -218,    5, -219, -219, -219, -219, -219, -219,
			 -219, -219, -219, -219, -219, -219, -219, -219, -219, -219,

			 -219, -219, -219, -219, -219, -219, -219, -219, -219, -219,
			 -219, -219, -219, -219, -219, -219, -219, -219, -219, -219,
			 -219, -219, -219, -219, -219, -219, -219, -219, -219, -219,
			 -219,  315,  315,  315,  315,  315,  315,  315,  315,  315,
			  315, -219, -219, -219, -219, -219, -219, -219, -219, -219,
			 -219, -219,  316, -219, -219, -219, -219, -219, -219, -219,
			 -219, -219, -219, -219, -219, -219, -219, -219, -219, -219,
			 -219, -219, -219, -219, -219, -219, -219, -219,  317, -219,
			 -219, -219, -219, -219,  316, -219, -219, -219, -219, -219,
			 -219, -219, -219, -219, -219, -219, -219, -219, -219, -219,

			 -219, -219, -219, -219, -219, -219, -219, -219, -219, -219,
			 -219, -219, -219, -219, -219, -219, -219, -219, -219, -219,
			 -219, -219, -219, -219, -219, -219, -219, -219, -219, -219,
			 -219, -219, -219, -219, -219, -219, -219, -219, -219, -219,
			 -219, -219, -219, -219, -219, -219, -219, -219, -219, -219,
			 -219, -219, -219, -219, -219, -219, -219, -219, -219, -219,
			 -219, -219, -219, -219, -219, -219, -219, -219, -219, -219,
			 -219, -219, -219, -219, -219, -219, -219, -219, -219, -219,
			 -219, -219, -219, -219, -219, -219, -219, -219, -219, -219,
			 -219, -219, -219, -219, -219, -219, -219, -219, -219, -219,

			 -219, -219, -219, -219, -219, -219, -219, -219, -219, -219,
			 -219, -219, -219, -219, -219, -219, -219, -219, -219, -219,
			 -219, -219, -219, -219, -219, -219, -219, -219, -219, -219,
			 -219, -219, -219, -219, -219, -219, -219, -219, -219, -219,
			    5, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220,  318, -220,  318, -220, -220,  319,  319,
			  319,  319,  319,  319,  319,  319,  319,  319, -220, -220,

			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,

			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220, -220, -220, -220,
			 -220, -220, -220, -220, -220, -220, -220,    5, -221, -221,

			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221,
			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221,
			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221,
			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221,
			 -221, -221, -221,   90, -221,  320,  320,  321,  321,  321,
			  321,  321,  321,  321,  321, -221, -221, -221, -221, -221,
			 -221, -221, -221,   93, -221, -221, -221, -221, -221, -221,
			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221,
			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221,
			 -221, -221,   94, -221, -221,   93, -221, -221, -221, -221,

			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221,
			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221,
			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221,
			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221,
			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221,
			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221,
			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221,
			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221,
			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221,
			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221, yy_Dummy>>,
			1, 3000, 54000)
		end

	yy_nxt_template_20 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221,
			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221,
			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221,
			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221,
			 -221, -221, -221, -221, -221, -221, -221, -221, -221, -221,
			 -221, -221, -221, -221,    5, -222, -222, -222, -222, -222,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,

			   90, -222,  321,  321,  321,  321,  321,  321,  321,  321,
			  321,  321, -222, -222, -222, -222, -222, -222, -222, -222,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222,   94,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,

			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,
			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,

			 -222, -222, -222, -222, -222, -222, -222, -222, -222, -222,
			 -222,    5, -223, -223, -223, -223, -223, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223,  322,
			  322,  322,  322,  322,  322,  322,  322,  322,  322, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,

			 -223, -223, -223, -223, -223, -223,  143, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,

			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223, -223, -223,
			 -223, -223, -223, -223, -223, -223, -223, -223,    5, -224,
			 -224, -224, -224, -224, -224, -224, -224, -224, -224, -224,
			 -224, -224, -224, -224, -224, -224, -224, -224, -224, -224,
			 -224, -224, -224, -224, -224, -224, -224, -224, -224, -224,

			 -224, -224, -224, -224, -224, -224, -224, -224, -224, -224,
			 -224, -224, -224, -224, -224, -224,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -224, -224, -224, -224,
			 -224, -224, -224,  323,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -224,
			 -224, -224, -224,  101, -224,  323,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -224, -224, -224, -224, -224, -224, -224, -224, -224,

			 -224, -224, -224, -224, -224, -224, -224, -224, -224, -224,
			 -224, -224, -224, -224, -224, -224, -224, -224, -224, -224,
			 -224, -224, -224, -224, -224, -224, -224, -224, -224, -224,
			 -224, -224, -224, -224, -224, -224, -224, -224, -224, -224,
			 -224, -224, -224, -224, -224, -224, -224, -224, -224, -224,
			 -224, -224, -224, -224, -224, -224, -224, -224, -224, -224,
			 -224, -224, -224, -224, -224, -224, -224, -224, -224, -224,
			 -224, -224, -224, -224, -224, -224, -224, -224, -224, -224,
			 -224, -224, -224, -224, -224, -224, -224, -224, -224, -224,
			 -224, -224, -224, -224, -224, -224, -224, -224, -224, -224,

			 -224, -224, -224, -224, -224, -224, -224, -224, -224, -224,
			 -224, -224, -224, -224, -224, -224, -224, -224, -224, -224,
			 -224, -224, -224, -224, -224,    5, -225, -225, -225, -225,
			 -225, -225, -225, -225, -225, -225, -225, -225, -225, -225,
			 -225, -225, -225, -225, -225, -225, -225, -225, -225, -225,
			 -225, -225, -225, -225, -225, -225, -225, -225, -225, -225,
			 -225, -225, -225, -225, -225, -225, -225, -225, -225, -225,
			 -225, -225, -225,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -225, -225, -225, -225, -225, -225, -225,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -225, -225, -225, -225,
			  101, -225,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -225, -225,
			 -225, -225, -225, -225, -225, -225, -225, -225, -225, -225,
			 -225, -225, -225, -225, -225, -225, -225, -225, -225, -225,
			 -225, -225, -225, -225, -225, -225, -225, -225, -225, -225,
			 -225, -225, -225, -225, -225, -225, -225, -225, -225, -225,
			 -225, -225, -225, -225, -225, -225, -225, -225, -225, -225,

			 -225, -225, -225, -225, -225, -225, -225, -225, -225, -225,
			 -225, -225, -225, -225, -225, -225, -225, -225, -225, -225,
			 -225, -225, -225, -225, -225, -225, -225, -225, -225, -225,
			 -225, -225, -225, -225, -225, -225, -225, -225, -225, -225,
			 -225, -225, -225, -225, -225, -225, -225, -225, -225, -225,
			 -225, -225, -225, -225, -225, -225, -225, -225, -225, -225,
			 -225, -225, -225, -225, -225, -225, -225, -225, -225, -225,
			 -225, -225, -225, -225, -225, -225, -225, -225, -225, -225,
			 -225, -225,    5, -226, -226, -226, -226, -226, -226, -226,
			 -226, -226, -226, -226, -226, -226, -226, -226, -226, -226,

			 -226, -226, -226, -226, -226, -226, -226, -226, -226, -226,
			 -226, -226, -226, -226, -226, -226, -226, -226, -226, -226,
			 -226, -226, -226, -226, -226, -226, -226, -226, -226, -226,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -226, -226, -226, -226, -226, -226, -226,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -226, -226, -226, -226,  101, -226,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101, -226, -226, -226, -226, -226,
			 -226, -226, -226, -226, -226, -226, -226, -226, -226, -226,
			 -226, -226, -226, -226, -226, -226, -226, -226, -226, -226,
			 -226, -226, -226, -226, -226, -226, -226, -226, -226, -226,
			 -226, -226, -226, -226, -226, -226, -226, -226, -226, -226,
			 -226, -226, -226, -226, -226, -226, -226, -226, -226, -226,
			 -226, -226, -226, -226, -226, -226, -226, -226, -226, -226,
			 -226, -226, -226, -226, -226, -226, -226, -226, -226, -226,
			 -226, -226, -226, -226, -226, -226, -226, -226, -226, -226,
			 -226, -226, -226, -226, -226, -226, -226, -226, -226, -226,

			 -226, -226, -226, -226, -226, -226, -226, -226, -226, -226,
			 -226, -226, -226, -226, -226, -226, -226, -226, -226, -226,
			 -226, -226, -226, -226, -226, -226, -226, -226, -226, -226,
			 -226, -226, -226, -226, -226, -226, -226, -226, -226,    5,
			 -227, -227, -227, -227, -227, -227, -227, -227, -227, -227,
			 -227, -227, -227, -227, -227, -227, -227, -227, -227, -227,
			 -227, -227, -227, -227, -227, -227, -227, -227, -227, -227,
			 -227, -227, -227, -227, -227, -227, -227, -227, -227, -227,
			 -227, -227, -227, -227, -227, -227, -227,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -227, -227, -227,

			 -227, -227, -227, -227,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -227, -227, -227, -227,  101, -227,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -227, -227, -227, -227, -227, -227, -227, -227,
			 -227, -227, -227, -227, -227, -227, -227, -227, -227, -227,
			 -227, -227, -227, -227, -227, -227, -227, -227, -227, -227,
			 -227, -227, -227, -227, -227, -227, -227, -227, -227, -227,

			 -227, -227, -227, -227, -227, -227, -227, -227, -227, -227,
			 -227, -227, -227, -227, -227, -227, -227, -227, -227, -227,
			 -227, -227, -227, -227, -227, -227, -227, -227, -227, -227,
			 -227, -227, -227, -227, -227, -227, -227, -227, -227, -227,
			 -227, -227, -227, -227, -227, -227, -227, -227, -227, -227,
			 -227, -227, -227, -227, -227, -227, -227, -227, -227, -227,
			 -227, -227, -227, -227, -227, -227, -227, -227, -227, -227,
			 -227, -227, -227, -227, -227, -227, -227, -227, -227, -227,
			 -227, -227, -227, -227, -227, -227, -227, -227, -227, -227,
			 -227, -227, -227, -227, -227, -227,    5, -228, -228, -228,

			 -228, -228, -228, -228, -228, -228, -228, -228, -228, -228,
			 -228, -228, -228, -228, -228, -228, -228, -228, -228, -228,
			 -228, -228, -228, -228, -228, -228, -228, -228, -228, -228,
			 -228, -228, -228, -228, -228, -228, -228, -228, -228, -228,
			 -228, -228, -228, -228,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -228, -228, -228, -228, -228, -228,
			 -228,  101,  101,  324,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -228, -228, -228,
			 -228,  101, -228,  101,  101,  324,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -228,
			 -228, -228, -228, -228, -228, -228, -228, -228, -228, -228,
			 -228, -228, -228, -228, -228, -228, -228, -228, -228, -228,
			 -228, -228, -228, -228, -228, -228, -228, -228, -228, -228,
			 -228, -228, -228, -228, -228, -228, -228, -228, -228, -228,
			 -228, -228, -228, -228, -228, -228, -228, -228, -228, -228,
			 -228, -228, -228, -228, -228, -228, -228, -228, -228, -228,
			 -228, -228, -228, -228, -228, -228, -228, -228, -228, -228,
			 -228, -228, -228, -228, -228, -228, -228, -228, -228, -228,

			 -228, -228, -228, -228, -228, -228, -228, -228, -228, -228,
			 -228, -228, -228, -228, -228, -228, -228, -228, -228, -228,
			 -228, -228, -228, -228, -228, -228, -228, -228, -228, -228,
			 -228, -228, -228, -228, -228, -228, -228, -228, -228, -228,
			 -228, -228, -228, -228, -228, -228, -228, -228, -228, -228,
			 -228, -228, -228,    5, -229, -229, -229, -229, -229, -229,
			 -229, -229, -229, -229, -229, -229, -229, -229, -229, -229,
			 -229, -229, -229, -229, -229, -229, -229, -229, -229, -229,
			 -229, -229, -229, -229, -229, -229, -229, -229, -229, -229,
			 -229, -229, -229, -229, -229, -229, -229, -229, -229, -229,

			 -229,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -229, -229, -229, -229, -229, -229, -229,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  325,  101,  101,  101,
			  101,  101,  101,  101, -229, -229, -229, -229,  101, -229,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  325,  101,
			  101,  101,  101,  101,  101,  101, -229, -229, -229, -229,
			 -229, -229, -229, -229, -229, -229, -229, -229, -229, -229,
			 -229, -229, -229, -229, -229, -229, -229, -229, -229, -229,

			 -229, -229, -229, -229, -229, -229, -229, -229, -229, -229,
			 -229, -229, -229, -229, -229, -229, -229, -229, -229, -229,
			 -229, -229, -229, -229, -229, -229, -229, -229, -229, -229,
			 -229, -229, -229, -229, -229, -229, -229, -229, -229, -229,
			 -229, -229, -229, -229, -229, -229, -229, -229, -229, -229,
			 -229, -229, -229, -229, -229, -229, -229, -229, -229, -229,
			 -229, -229, -229, -229, -229, -229, -229, -229, -229, -229,
			 -229, -229, -229, -229, -229, -229, -229, -229, -229, -229,
			 -229, -229, -229, -229, -229, -229, -229, -229, -229, -229,
			 -229, -229, -229, -229, -229, -229, -229, -229, -229, -229,

			 -229, -229, -229, -229, -229, -229, -229, -229, -229, -229,
			    5, -230, -230, -230, -230, -230, -230, -230, -230, -230,
			 -230, -230, -230, -230, -230, -230, -230, -230, -230, -230,
			 -230, -230, -230, -230, -230, -230, -230, -230, -230, -230,
			 -230, -230, -230, -230, -230, -230, -230, -230, -230, -230,
			 -230, -230, -230, -230, -230, -230, -230, -230,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -230, -230,
			 -230, -230, -230, -230, -230,  101,  101,  101,  101,  101,
			  326,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101, -230, -230, -230, -230,  101, -230,  101,  101,  101,
			  101,  101,  326,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -230, -230, -230, -230, -230, -230, -230,
			 -230, -230, -230, -230, -230, -230, -230, -230, -230, -230,
			 -230, -230, -230, -230, -230, -230, -230, -230, -230, -230,
			 -230, -230, -230, -230, -230, -230, -230, -230, -230, -230,
			 -230, -230, -230, -230, -230, -230, -230, -230, -230, -230,
			 -230, -230, -230, -230, -230, -230, -230, -230, -230, -230,
			 -230, -230, -230, -230, -230, -230, -230, -230, -230, -230,

			 -230, -230, -230, -230, -230, -230, -230, -230, -230, -230,
			 -230, -230, -230, -230, -230, -230, -230, -230, -230, -230,
			 -230, -230, -230, -230, -230, -230, -230, -230, -230, -230,
			 -230, -230, -230, -230, -230, -230, -230, -230, -230, -230,
			 -230, -230, -230, -230, -230, -230, -230, -230, -230, -230,
			 -230, -230, -230, -230, -230, -230, -230, -230, -230, -230,
			 -230, -230, -230, -230, -230, -230, -230,    5, -231, -231,
			 -231, -231, -231, -231, -231, -231, -231, -231, -231, -231,
			 -231, -231, -231, -231, -231, -231, -231, -231, -231, -231,
			 -231, -231, -231, -231, -231, -231, -231, -231, -231, -231,

			 -231, -231, -231, -231, -231, -231, -231, -231, -231, -231,
			 -231, -231, -231, -231, -231,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -231, -231, -231, -231, -231,
			 -231, -231,  327,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -231, -231,
			 -231, -231,  101, -231,  327,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -231, -231, -231, -231, -231, -231, -231, -231, -231, -231,

			 -231, -231, -231, -231, -231, -231, -231, -231, -231, -231,
			 -231, -231, -231, -231, -231, -231, -231, -231, -231, -231,
			 -231, -231, -231, -231, -231, -231, -231, -231, -231, -231,
			 -231, -231, -231, -231, -231, -231, -231, -231, -231, -231,
			 -231, -231, -231, -231, -231, -231, -231, -231, -231, -231,
			 -231, -231, -231, -231, -231, -231, -231, -231, -231, -231,
			 -231, -231, -231, -231, -231, -231, -231, -231, -231, -231,
			 -231, -231, -231, -231, -231, -231, -231, -231, -231, -231,
			 -231, -231, -231, -231, -231, -231, -231, -231, -231, -231,
			 -231, -231, -231, -231, -231, -231, -231, -231, -231, -231,

			 -231, -231, -231, -231, -231, -231, -231, -231, -231, -231,
			 -231, -231, -231, -231, -231, -231, -231, -231, -231, -231,
			 -231, -231, -231, -231,    5, -232, -232, -232, -232, -232,
			 -232, -232, -232, -232, -232, -232, -232, -232, -232, -232,
			 -232, -232, -232, -232, -232, -232, -232, -232, -232, -232,
			 -232, -232, -232, -232, -232, -232, -232, -232, -232, -232,
			 -232, -232, -232, -232, -232, -232, -232, -232, -232, -232,
			 -232, -232,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -232, -232, -232, -232, -232, -232, -232,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  328,  101,  101,  101,
			  101,  101,  101,  101,  101, -232, -232, -232, -232,  101,
			 -232,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  328,  101,
			  101,  101,  101,  101,  101,  101,  101, -232, -232, -232,
			 -232, -232, -232, -232, -232, -232, -232, -232, -232, -232,
			 -232, -232, -232, -232, -232, -232, -232, -232, -232, -232,
			 -232, -232, -232, -232, -232, -232, -232, -232, -232, -232,
			 -232, -232, -232, -232, -232, -232, -232, -232, -232, -232,
			 -232, -232, -232, -232, -232, -232, -232, -232, -232, -232,

			 -232, -232, -232, -232, -232, -232, -232, -232, -232, -232,
			 -232, -232, -232, -232, -232, -232, -232, -232, -232, -232,
			 -232, -232, -232, -232, -232, -232, -232, -232, -232, -232,
			 -232, -232, -232, -232, -232, -232, -232, -232, -232, -232,
			 -232, -232, -232, -232, -232, -232, -232, -232, -232, -232,
			 -232, -232, -232, -232, -232, -232, -232, -232, -232, -232,
			 -232, -232, -232, -232, -232, -232, -232, -232, -232, -232,
			 -232, -232, -232, -232, -232, -232, -232, -232, -232, -232,
			 -232,    5, -233, -233, -233, -233, -233, -233, -233, -233,
			 -233, -233, -233, -233, -233, -233, -233, -233, -233, -233,

			 -233, -233, -233, -233, -233, -233, -233, -233, -233, -233,
			 -233, -233, -233, -233, -233, -233, -233, -233, -233, -233,
			 -233, -233, -233, -233, -233, -233, -233, -233, -233,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -233,
			 -233, -233, -233, -233, -233, -233,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  329,  101,  101,  101,
			  101,  101, -233, -233, -233, -233,  101, -233,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  329,  101, yy_Dummy>>,
			1, 3000, 57000)
		end

	yy_nxt_template_21 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  101,  101,  101,  101, -233, -233, -233, -233, -233, -233,
			 -233, -233, -233, -233, -233, -233, -233, -233, -233, -233,
			 -233, -233, -233, -233, -233, -233, -233, -233, -233, -233,
			 -233, -233, -233, -233, -233, -233, -233, -233, -233, -233,
			 -233, -233, -233, -233, -233, -233, -233, -233, -233, -233,
			 -233, -233, -233, -233, -233, -233, -233, -233, -233, -233,
			 -233, -233, -233, -233, -233, -233, -233, -233, -233, -233,
			 -233, -233, -233, -233, -233, -233, -233, -233, -233, -233,
			 -233, -233, -233, -233, -233, -233, -233, -233, -233, -233,
			 -233, -233, -233, -233, -233, -233, -233, -233, -233, -233,

			 -233, -233, -233, -233, -233, -233, -233, -233, -233, -233,
			 -233, -233, -233, -233, -233, -233, -233, -233, -233, -233,
			 -233, -233, -233, -233, -233, -233, -233, -233, -233, -233,
			 -233, -233, -233, -233, -233, -233, -233, -233,    5, -234,
			 -234, -234, -234, -234, -234, -234, -234, -234, -234, -234,
			 -234, -234, -234, -234, -234, -234, -234, -234, -234, -234,
			 -234, -234, -234, -234, -234, -234, -234, -234, -234, -234,
			 -234, -234, -234, -234, -234, -234, -234, -234, -234, -234,
			 -234, -234, -234, -234, -234, -234,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -234, -234, -234, -234,

			 -234, -234, -234,  101,  101,  101,  101,  330,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -234,
			 -234, -234, -234,  101, -234,  101,  101,  101,  101,  330,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -234, -234, -234, -234, -234, -234, -234, -234, -234,
			 -234, -234, -234, -234, -234, -234, -234, -234, -234, -234,
			 -234, -234, -234, -234, -234, -234, -234, -234, -234, -234,
			 -234, -234, -234, -234, -234, -234, -234, -234, -234, -234,

			 -234, -234, -234, -234, -234, -234, -234, -234, -234, -234,
			 -234, -234, -234, -234, -234, -234, -234, -234, -234, -234,
			 -234, -234, -234, -234, -234, -234, -234, -234, -234, -234,
			 -234, -234, -234, -234, -234, -234, -234, -234, -234, -234,
			 -234, -234, -234, -234, -234, -234, -234, -234, -234, -234,
			 -234, -234, -234, -234, -234, -234, -234, -234, -234, -234,
			 -234, -234, -234, -234, -234, -234, -234, -234, -234, -234,
			 -234, -234, -234, -234, -234, -234, -234, -234, -234, -234,
			 -234, -234, -234, -234, -234, -234, -234, -234, -234, -234,
			 -234, -234, -234, -234, -234,    5, -235, -235, -235, -235,

			 -235, -235, -235, -235, -235, -235, -235, -235, -235, -235,
			 -235, -235, -235, -235, -235, -235, -235, -235, -235, -235,
			 -235, -235, -235, -235, -235, -235, -235, -235, -235, -235,
			 -235, -235, -235, -235, -235, -235, -235, -235, -235, -235,
			 -235, -235, -235,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -235, -235, -235, -235, -235, -235, -235,
			  101,  101,  101,  101,  331,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -235, -235, -235, -235,
			  101, -235,  101,  101,  101,  101,  331,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -235, -235,
			 -235, -235, -235, -235, -235, -235, -235, -235, -235, -235,
			 -235, -235, -235, -235, -235, -235, -235, -235, -235, -235,
			 -235, -235, -235, -235, -235, -235, -235, -235, -235, -235,
			 -235, -235, -235, -235, -235, -235, -235, -235, -235, -235,
			 -235, -235, -235, -235, -235, -235, -235, -235, -235, -235,
			 -235, -235, -235, -235, -235, -235, -235, -235, -235, -235,
			 -235, -235, -235, -235, -235, -235, -235, -235, -235, -235,
			 -235, -235, -235, -235, -235, -235, -235, -235, -235, -235,

			 -235, -235, -235, -235, -235, -235, -235, -235, -235, -235,
			 -235, -235, -235, -235, -235, -235, -235, -235, -235, -235,
			 -235, -235, -235, -235, -235, -235, -235, -235, -235, -235,
			 -235, -235, -235, -235, -235, -235, -235, -235, -235, -235,
			 -235, -235, -235, -235, -235, -235, -235, -235, -235, -235,
			 -235, -235,    5, -236, -236, -236, -236, -236, -236, -236,
			 -236, -236, -236, -236, -236, -236, -236, -236, -236, -236,
			 -236, -236, -236, -236, -236, -236, -236, -236, -236, -236,
			 -236, -236, -236, -236, -236, -236, -236, -236, -236, -236,
			 -236, -236, -236, -236, -236, -236, -236, -236, -236, -236,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -236, -236, -236, -236, -236, -236, -236,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -236, -236, -236, -236,  101, -236,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -236, -236, -236, -236, -236,
			 -236, -236, -236, -236, -236, -236, -236, -236, -236, -236,
			 -236, -236, -236, -236, -236, -236, -236, -236, -236, -236,

			 -236, -236, -236, -236, -236, -236, -236, -236, -236, -236,
			 -236, -236, -236, -236, -236, -236, -236, -236, -236, -236,
			 -236, -236, -236, -236, -236, -236, -236, -236, -236, -236,
			 -236, -236, -236, -236, -236, -236, -236, -236, -236, -236,
			 -236, -236, -236, -236, -236, -236, -236, -236, -236, -236,
			 -236, -236, -236, -236, -236, -236, -236, -236, -236, -236,
			 -236, -236, -236, -236, -236, -236, -236, -236, -236, -236,
			 -236, -236, -236, -236, -236, -236, -236, -236, -236, -236,
			 -236, -236, -236, -236, -236, -236, -236, -236, -236, -236,
			 -236, -236, -236, -236, -236, -236, -236, -236, -236, -236,

			 -236, -236, -236, -236, -236, -236, -236, -236, -236,    5,
			 -237, -237, -237, -237, -237, -237, -237, -237, -237, -237,
			 -237, -237, -237, -237, -237, -237, -237, -237, -237, -237,
			 -237, -237, -237, -237, -237, -237, -237, -237, -237, -237,
			 -237, -237, -237, -237, -237, -237, -237, -237, -237, -237,
			 -237, -237, -237, -237, -237, -237, -237,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -237, -237, -237,
			 -237, -237, -237, -237,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  332,  101,  101,  101,  101,  101,

			 -237, -237, -237, -237,  101, -237,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  332,  101,  101,  101,
			  101,  101, -237, -237, -237, -237, -237, -237, -237, -237,
			 -237, -237, -237, -237, -237, -237, -237, -237, -237, -237,
			 -237, -237, -237, -237, -237, -237, -237, -237, -237, -237,
			 -237, -237, -237, -237, -237, -237, -237, -237, -237, -237,
			 -237, -237, -237, -237, -237, -237, -237, -237, -237, -237,
			 -237, -237, -237, -237, -237, -237, -237, -237, -237, -237,
			 -237, -237, -237, -237, -237, -237, -237, -237, -237, -237,

			 -237, -237, -237, -237, -237, -237, -237, -237, -237, -237,
			 -237, -237, -237, -237, -237, -237, -237, -237, -237, -237,
			 -237, -237, -237, -237, -237, -237, -237, -237, -237, -237,
			 -237, -237, -237, -237, -237, -237, -237, -237, -237, -237,
			 -237, -237, -237, -237, -237, -237, -237, -237, -237, -237,
			 -237, -237, -237, -237, -237, -237, -237, -237, -237, -237,
			 -237, -237, -237, -237, -237, -237,    5, -238, -238, -238,
			 -238, -238, -238, -238, -238, -238, -238, -238, -238, -238,
			 -238, -238, -238, -238, -238, -238, -238, -238, -238, -238,
			 -238, -238, -238, -238, -238, -238, -238, -238, -238, -238,

			 -238, -238, -238, -238, -238, -238, -238, -238, -238, -238,
			 -238, -238, -238, -238,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -238, -238, -238, -238, -238, -238,
			 -238,  333,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  334,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -238, -238, -238,
			 -238,  101, -238,  333,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  334,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -238,
			 -238, -238, -238, -238, -238, -238, -238, -238, -238, -238,

			 -238, -238, -238, -238, -238, -238, -238, -238, -238, -238,
			 -238, -238, -238, -238, -238, -238, -238, -238, -238, -238,
			 -238, -238, -238, -238, -238, -238, -238, -238, -238, -238,
			 -238, -238, -238, -238, -238, -238, -238, -238, -238, -238,
			 -238, -238, -238, -238, -238, -238, -238, -238, -238, -238,
			 -238, -238, -238, -238, -238, -238, -238, -238, -238, -238,
			 -238, -238, -238, -238, -238, -238, -238, -238, -238, -238,
			 -238, -238, -238, -238, -238, -238, -238, -238, -238, -238,
			 -238, -238, -238, -238, -238, -238, -238, -238, -238, -238,
			 -238, -238, -238, -238, -238, -238, -238, -238, -238, -238,

			 -238, -238, -238, -238, -238, -238, -238, -238, -238, -238,
			 -238, -238, -238, -238, -238, -238, -238, -238, -238, -238,
			 -238, -238, -238,    5, -239, -239, -239, -239, -239, -239,
			 -239, -239, -239, -239, -239, -239, -239, -239, -239, -239,
			 -239, -239, -239, -239, -239, -239, -239, -239, -239, -239,
			 -239, -239, -239, -239, -239, -239, -239, -239, -239, -239,
			 -239, -239, -239, -239, -239, -239, -239, -239, -239, -239,
			 -239,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -239, -239, -239, -239, -239, -239, -239,  101,  101,
			  101,  101,  335,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -239, -239, -239, -239,  101, -239,
			  101,  101,  101,  101,  335,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -239, -239, -239, -239,
			 -239, -239, -239, -239, -239, -239, -239, -239, -239, -239,
			 -239, -239, -239, -239, -239, -239, -239, -239, -239, -239,
			 -239, -239, -239, -239, -239, -239, -239, -239, -239, -239,
			 -239, -239, -239, -239, -239, -239, -239, -239, -239, -239,
			 -239, -239, -239, -239, -239, -239, -239, -239, -239, -239,

			 -239, -239, -239, -239, -239, -239, -239, -239, -239, -239,
			 -239, -239, -239, -239, -239, -239, -239, -239, -239, -239,
			 -239, -239, -239, -239, -239, -239, -239, -239, -239, -239,
			 -239, -239, -239, -239, -239, -239, -239, -239, -239, -239,
			 -239, -239, -239, -239, -239, -239, -239, -239, -239, -239,
			 -239, -239, -239, -239, -239, -239, -239, -239, -239, -239,
			 -239, -239, -239, -239, -239, -239, -239, -239, -239, -239,
			 -239, -239, -239, -239, -239, -239, -239, -239, -239, -239,
			    5, -240, -240, -240, -240, -240, -240, -240, -240, -240,
			 -240, -240, -240, -240, -240, -240, -240, -240, -240, -240,

			 -240, -240, -240, -240, -240, -240, -240, -240, -240, -240,
			 -240, -240, -240, -240, -240, -240, -240, -240, -240, -240,
			 -240, -240, -240, -240, -240, -240, -240, -240,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -240, -240,
			 -240, -240, -240, -240, -240,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  336,  101,  101,  101,  101,  101,  101,
			  101, -240, -240, -240, -240,  101, -240,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  336,  101,  101,  101,  101,

			  101,  101,  101, -240, -240, -240, -240, -240, -240, -240,
			 -240, -240, -240, -240, -240, -240, -240, -240, -240, -240,
			 -240, -240, -240, -240, -240, -240, -240, -240, -240, -240,
			 -240, -240, -240, -240, -240, -240, -240, -240, -240, -240,
			 -240, -240, -240, -240, -240, -240, -240, -240, -240, -240,
			 -240, -240, -240, -240, -240, -240, -240, -240, -240, -240,
			 -240, -240, -240, -240, -240, -240, -240, -240, -240, -240,
			 -240, -240, -240, -240, -240, -240, -240, -240, -240, -240,
			 -240, -240, -240, -240, -240, -240, -240, -240, -240, -240,
			 -240, -240, -240, -240, -240, -240, -240, -240, -240, -240,

			 -240, -240, -240, -240, -240, -240, -240, -240, -240, -240,
			 -240, -240, -240, -240, -240, -240, -240, -240, -240, -240,
			 -240, -240, -240, -240, -240, -240, -240, -240, -240, -240,
			 -240, -240, -240, -240, -240, -240, -240,    5, -241, -241,
			 -241, -241, -241, -241, -241, -241, -241, -241, -241, -241,
			 -241, -241, -241, -241, -241, -241, -241, -241, -241, -241,
			 -241, -241, -241, -241, -241, -241, -241, -241, -241, -241,
			 -241, -241, -241, -241, -241, -241, -241, -241, -241, -241,
			 -241, -241, -241, -241, -241,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -241, -241, -241, -241, -241,

			 -241, -241,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  337,  101,  101,  101,  101,  101,  101, -241, -241,
			 -241, -241,  101, -241,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  337,  101,  101,  101,  101,  101,  101,
			 -241, -241, -241, -241, -241, -241, -241, -241, -241, -241,
			 -241, -241, -241, -241, -241, -241, -241, -241, -241, -241,
			 -241, -241, -241, -241, -241, -241, -241, -241, -241, -241,
			 -241, -241, -241, -241, -241, -241, -241, -241, -241, -241,

			 -241, -241, -241, -241, -241, -241, -241, -241, -241, -241,
			 -241, -241, -241, -241, -241, -241, -241, -241, -241, -241,
			 -241, -241, -241, -241, -241, -241, -241, -241, -241, -241,
			 -241, -241, -241, -241, -241, -241, -241, -241, -241, -241,
			 -241, -241, -241, -241, -241, -241, -241, -241, -241, -241,
			 -241, -241, -241, -241, -241, -241, -241, -241, -241, -241,
			 -241, -241, -241, -241, -241, -241, -241, -241, -241, -241,
			 -241, -241, -241, -241, -241, -241, -241, -241, -241, -241,
			 -241, -241, -241, -241, -241, -241, -241, -241, -241, -241,
			 -241, -241, -241, -241,    5, -242, -242, -242, -242, -242,

			 -242, -242, -242, -242, -242, -242, -242, -242, -242, -242,
			 -242, -242, -242, -242, -242, -242, -242, -242, -242, -242,
			 -242, -242, -242, -242, -242, -242, -242, -242, -242, -242,
			 -242, -242, -242, -242, -242, -242, -242, -242, -242, -242,
			 -242, -242,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -242, -242, -242, -242, -242, -242, -242,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  338,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  339, -242, -242, -242, -242,  101,
			 -242,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  338,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  339, -242, -242, -242,
			 -242, -242, -242, -242, -242, -242, -242, -242, -242, -242,
			 -242, -242, -242, -242, -242, -242, -242, -242, -242, -242,
			 -242, -242, -242, -242, -242, -242, -242, -242, -242, -242,
			 -242, -242, -242, -242, -242, -242, -242, -242, -242, -242,
			 -242, -242, -242, -242, -242, -242, -242, -242, -242, -242,
			 -242, -242, -242, -242, -242, -242, -242, -242, -242, -242,
			 -242, -242, -242, -242, -242, -242, -242, -242, -242, -242,
			 -242, -242, -242, -242, -242, -242, -242, -242, -242, -242,

			 -242, -242, -242, -242, -242, -242, -242, -242, -242, -242,
			 -242, -242, -242, -242, -242, -242, -242, -242, -242, -242,
			 -242, -242, -242, -242, -242, -242, -242, -242, -242, -242,
			 -242, -242, -242, -242, -242, -242, -242, -242, -242, -242,
			 -242, -242, -242, -242, -242, -242, -242, -242, -242, -242,
			 -242,    5, -243, -243, -243, -243, -243, -243, -243, -243,
			 -243, -243, -243, -243, -243, -243, -243, -243, -243, -243,
			 -243, -243, -243, -243, -243, -243, -243, -243, -243, -243,
			 -243, -243, -243, -243, -243, -243, -243, -243, -243, -243,
			 -243, -243, -243, -243, -243, -243, -243, -243, -243,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101, -243,
			 -243, -243, -243, -243, -243, -243,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  340,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -243, -243, -243, -243,  101, -243,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  340,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -243, -243, -243, -243, -243, -243,
			 -243, -243, -243, -243, -243, -243, -243, -243, -243, -243,
			 -243, -243, -243, -243, -243, -243, -243, -243, -243, -243,

			 -243, -243, -243, -243, -243, -243, -243, -243, -243, -243,
			 -243, -243, -243, -243, -243, -243, -243, -243, -243, -243,
			 -243, -243, -243, -243, -243, -243, -243, -243, -243, -243,
			 -243, -243, -243, -243, -243, -243, -243, -243, -243, -243,
			 -243, -243, -243, -243, -243, -243, -243, -243, -243, -243,
			 -243, -243, -243, -243, -243, -243, -243, -243, -243, -243,
			 -243, -243, -243, -243, -243, -243, -243, -243, -243, -243,
			 -243, -243, -243, -243, -243, -243, -243, -243, -243, -243,
			 -243, -243, -243, -243, -243, -243, -243, -243, -243, -243,
			 -243, -243, -243, -243, -243, -243, -243, -243, -243, -243,

			 -243, -243, -243, -243, -243, -243, -243, -243,    5, -244,
			 -244, -244, -244, -244, -244, -244, -244, -244, -244, -244,
			 -244, -244, -244, -244, -244, -244, -244, -244, -244, -244,
			 -244, -244, -244, -244, -244, -244, -244, -244, -244, -244,
			 -244, -244, -244, -244, -244, -244, -244, -244, -244, -244,
			 -244, -244, -244, -244, -244, -244,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -244, -244, -244, -244,
			 -244, -244, -244,  101,  101,  101,  101,  341,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -244,

			 -244, -244, -244,  101, -244,  101,  101,  101,  101,  341,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -244, -244, -244, -244, -244, -244, -244, -244, -244,
			 -244, -244, -244, -244, -244, -244, -244, -244, -244, -244,
			 -244, -244, -244, -244, -244, -244, -244, -244, -244, -244,
			 -244, -244, -244, -244, -244, -244, -244, -244, -244, -244,
			 -244, -244, -244, -244, -244, -244, -244, -244, -244, -244,
			 -244, -244, -244, -244, -244, -244, -244, -244, -244, -244,
			 -244, -244, -244, -244, -244, -244, -244, -244, -244, -244,

			 -244, -244, -244, -244, -244, -244, -244, -244, -244, -244,
			 -244, -244, -244, -244, -244, -244, -244, -244, -244, -244,
			 -244, -244, -244, -244, -244, -244, -244, -244, -244, -244,
			 -244, -244, -244, -244, -244, -244, -244, -244, -244, -244,
			 -244, -244, -244, -244, -244, -244, -244, -244, -244, -244,
			 -244, -244, -244, -244, -244, -244, -244, -244, -244, -244,
			 -244, -244, -244, -244, -244,    5, -245, -245, -245, -245,
			 -245, -245, -245, -245, -245, -245, -245, -245, -245, -245,
			 -245, -245, -245, -245, -245, -245, -245, -245, -245, -245,
			 -245, -245, -245, -245, -245, -245, -245, -245, -245, -245, yy_Dummy>>,
			1, 3000, 60000)
		end

	yy_nxt_template_22 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -245, -245, -245, -245, -245, -245, -245, -245, -245, -245,
			 -245, -245, -245,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -245, -245, -245, -245, -245, -245, -245,
			  101,  101,  101,  101,  101,  101,  101,  101,  342,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -245, -245, -245, -245,
			  101, -245,  101,  101,  101,  101,  101,  101,  101,  101,
			  342,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -245, -245,
			 -245, -245, -245, -245, -245, -245, -245, -245, -245, -245,

			 -245, -245, -245, -245, -245, -245, -245, -245, -245, -245,
			 -245, -245, -245, -245, -245, -245, -245, -245, -245, -245,
			 -245, -245, -245, -245, -245, -245, -245, -245, -245, -245,
			 -245, -245, -245, -245, -245, -245, -245, -245, -245, -245,
			 -245, -245, -245, -245, -245, -245, -245, -245, -245, -245,
			 -245, -245, -245, -245, -245, -245, -245, -245, -245, -245,
			 -245, -245, -245, -245, -245, -245, -245, -245, -245, -245,
			 -245, -245, -245, -245, -245, -245, -245, -245, -245, -245,
			 -245, -245, -245, -245, -245, -245, -245, -245, -245, -245,
			 -245, -245, -245, -245, -245, -245, -245, -245, -245, -245,

			 -245, -245, -245, -245, -245, -245, -245, -245, -245, -245,
			 -245, -245, -245, -245, -245, -245, -245, -245, -245, -245,
			 -245, -245,    5, -246, -246, -246, -246, -246, -246, -246,
			 -246, -246, -246, -246, -246, -246, -246, -246, -246, -246,
			 -246, -246, -246, -246, -246, -246, -246, -246, -246, -246,
			 -246, -246, -246, -246, -246, -246, -246, -246, -246, -246,
			 -246, -246, -246, -246, -246, -246, -246, -246, -246, -246,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -246, -246, -246, -246, -246, -246, -246,  101,  101,  101,
			  101,  343,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -246, -246, -246, -246,  101, -246,  101,
			  101,  101,  101,  343,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -246, -246, -246, -246, -246,
			 -246, -246, -246, -246, -246, -246, -246, -246, -246, -246,
			 -246, -246, -246, -246, -246, -246, -246, -246, -246, -246,
			 -246, -246, -246, -246, -246, -246, -246, -246, -246, -246,
			 -246, -246, -246, -246, -246, -246, -246, -246, -246, -246,
			 -246, -246, -246, -246, -246, -246, -246, -246, -246, -246,

			 -246, -246, -246, -246, -246, -246, -246, -246, -246, -246,
			 -246, -246, -246, -246, -246, -246, -246, -246, -246, -246,
			 -246, -246, -246, -246, -246, -246, -246, -246, -246, -246,
			 -246, -246, -246, -246, -246, -246, -246, -246, -246, -246,
			 -246, -246, -246, -246, -246, -246, -246, -246, -246, -246,
			 -246, -246, -246, -246, -246, -246, -246, -246, -246, -246,
			 -246, -246, -246, -246, -246, -246, -246, -246, -246, -246,
			 -246, -246, -246, -246, -246, -246, -246, -246, -246,    5,
			 -247, -247, -247, -247, -247, -247, -247, -247, -247, -247,
			 -247, -247, -247, -247, -247, -247, -247, -247, -247, -247,

			 -247, -247, -247, -247, -247, -247, -247, -247, -247, -247,
			 -247, -247, -247, -247, -247, -247, -247, -247, -247, -247,
			 -247, -247, -247, -247, -247, -247, -247,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -247, -247, -247,
			 -247, -247, -247, -247,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  344,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -247, -247, -247, -247,  101, -247,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  344,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101, -247, -247, -247, -247, -247, -247, -247, -247,
			 -247, -247, -247, -247, -247, -247, -247, -247, -247, -247,
			 -247, -247, -247, -247, -247, -247, -247, -247, -247, -247,
			 -247, -247, -247, -247, -247, -247, -247, -247, -247, -247,
			 -247, -247, -247, -247, -247, -247, -247, -247, -247, -247,
			 -247, -247, -247, -247, -247, -247, -247, -247, -247, -247,
			 -247, -247, -247, -247, -247, -247, -247, -247, -247, -247,
			 -247, -247, -247, -247, -247, -247, -247, -247, -247, -247,
			 -247, -247, -247, -247, -247, -247, -247, -247, -247, -247,
			 -247, -247, -247, -247, -247, -247, -247, -247, -247, -247,

			 -247, -247, -247, -247, -247, -247, -247, -247, -247, -247,
			 -247, -247, -247, -247, -247, -247, -247, -247, -247, -247,
			 -247, -247, -247, -247, -247, -247, -247, -247, -247, -247,
			 -247, -247, -247, -247, -247, -247,    5, -248, -248, -248,
			 -248, -248, -248, -248, -248, -248, -248, -248, -248, -248,
			 -248, -248, -248, -248, -248, -248, -248, -248, -248, -248,
			 -248, -248, -248, -248, -248, -248, -248, -248, -248, -248,
			 -248, -248, -248, -248, -248, -248, -248, -248, -248, -248,
			 -248, -248, -248, -248,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -248, -248, -248, -248, -248, -248,

			 -248,  345,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -248, -248, -248,
			 -248,  101, -248,  345,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -248,
			 -248, -248, -248, -248, -248, -248, -248, -248, -248, -248,
			 -248, -248, -248, -248, -248, -248, -248, -248, -248, -248,
			 -248, -248, -248, -248, -248, -248, -248, -248, -248, -248,
			 -248, -248, -248, -248, -248, -248, -248, -248, -248, -248,

			 -248, -248, -248, -248, -248, -248, -248, -248, -248, -248,
			 -248, -248, -248, -248, -248, -248, -248, -248, -248, -248,
			 -248, -248, -248, -248, -248, -248, -248, -248, -248, -248,
			 -248, -248, -248, -248, -248, -248, -248, -248, -248, -248,
			 -248, -248, -248, -248, -248, -248, -248, -248, -248, -248,
			 -248, -248, -248, -248, -248, -248, -248, -248, -248, -248,
			 -248, -248, -248, -248, -248, -248, -248, -248, -248, -248,
			 -248, -248, -248, -248, -248, -248, -248, -248, -248, -248,
			 -248, -248, -248, -248, -248, -248, -248, -248, -248, -248,
			 -248, -248, -248,    5, -249, -249, -249, -249, -249, -249,

			 -249, -249, -249, -249, -249, -249, -249, -249, -249, -249,
			 -249, -249, -249, -249, -249, -249, -249, -249, -249, -249,
			 -249, -249, -249, -249, -249, -249, -249, -249, -249, -249,
			 -249, -249, -249, -249, -249, -249, -249, -249, -249, -249,
			 -249,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -249, -249, -249, -249, -249, -249, -249,  101,  101,
			  101,  101,  346,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -249, -249, -249, -249,  101, -249,
			  101,  101,  101,  101,  346,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -249, -249, -249, -249,
			 -249, -249, -249, -249, -249, -249, -249, -249, -249, -249,
			 -249, -249, -249, -249, -249, -249, -249, -249, -249, -249,
			 -249, -249, -249, -249, -249, -249, -249, -249, -249, -249,
			 -249, -249, -249, -249, -249, -249, -249, -249, -249, -249,
			 -249, -249, -249, -249, -249, -249, -249, -249, -249, -249,
			 -249, -249, -249, -249, -249, -249, -249, -249, -249, -249,
			 -249, -249, -249, -249, -249, -249, -249, -249, -249, -249,
			 -249, -249, -249, -249, -249, -249, -249, -249, -249, -249,

			 -249, -249, -249, -249, -249, -249, -249, -249, -249, -249,
			 -249, -249, -249, -249, -249, -249, -249, -249, -249, -249,
			 -249, -249, -249, -249, -249, -249, -249, -249, -249, -249,
			 -249, -249, -249, -249, -249, -249, -249, -249, -249, -249,
			 -249, -249, -249, -249, -249, -249, -249, -249, -249, -249,
			    5, -250, -250, -250, -250, -250, -250, -250, -250, -250,
			 -250, -250, -250, -250, -250, -250, -250, -250, -250, -250,
			 -250, -250, -250, -250, -250, -250, -250, -250, -250, -250,
			 -250, -250, -250, -250, -250, -250, -250, -250, -250, -250,
			 -250, -250, -250, -250, -250, -250, -250, -250,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101, -250, -250,
			 -250, -250, -250, -250, -250,  347,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -250, -250, -250, -250,  101, -250,  347,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -250, -250, -250, -250, -250, -250, -250,
			 -250, -250, -250, -250, -250, -250, -250, -250, -250, -250,
			 -250, -250, -250, -250, -250, -250, -250, -250, -250, -250,

			 -250, -250, -250, -250, -250, -250, -250, -250, -250, -250,
			 -250, -250, -250, -250, -250, -250, -250, -250, -250, -250,
			 -250, -250, -250, -250, -250, -250, -250, -250, -250, -250,
			 -250, -250, -250, -250, -250, -250, -250, -250, -250, -250,
			 -250, -250, -250, -250, -250, -250, -250, -250, -250, -250,
			 -250, -250, -250, -250, -250, -250, -250, -250, -250, -250,
			 -250, -250, -250, -250, -250, -250, -250, -250, -250, -250,
			 -250, -250, -250, -250, -250, -250, -250, -250, -250, -250,
			 -250, -250, -250, -250, -250, -250, -250, -250, -250, -250,
			 -250, -250, -250, -250, -250, -250, -250, -250, -250, -250,

			 -250, -250, -250, -250, -250, -250, -250,    5, -251, -251,
			 -251, -251, -251, -251, -251, -251, -251, -251, -251, -251,
			 -251, -251, -251, -251, -251, -251, -251, -251, -251, -251,
			 -251, -251, -251, -251, -251, -251, -251, -251, -251, -251,
			 -251, -251, -251, -251, -251, -251, -251, -251, -251, -251,
			 -251, -251, -251, -251, -251,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -251, -251, -251, -251, -251,
			 -251, -251,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  348,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -251, -251,

			 -251, -251,  101, -251,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  348,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -251, -251, -251, -251, -251, -251, -251, -251, -251, -251,
			 -251, -251, -251, -251, -251, -251, -251, -251, -251, -251,
			 -251, -251, -251, -251, -251, -251, -251, -251, -251, -251,
			 -251, -251, -251, -251, -251, -251, -251, -251, -251, -251,
			 -251, -251, -251, -251, -251, -251, -251, -251, -251, -251,
			 -251, -251, -251, -251, -251, -251, -251, -251, -251, -251,
			 -251, -251, -251, -251, -251, -251, -251, -251, -251, -251,

			 -251, -251, -251, -251, -251, -251, -251, -251, -251, -251,
			 -251, -251, -251, -251, -251, -251, -251, -251, -251, -251,
			 -251, -251, -251, -251, -251, -251, -251, -251, -251, -251,
			 -251, -251, -251, -251, -251, -251, -251, -251, -251, -251,
			 -251, -251, -251, -251, -251, -251, -251, -251, -251, -251,
			 -251, -251, -251, -251, -251, -251, -251, -251, -251, -251,
			 -251, -251, -251, -251,    5, -252, -252, -252, -252, -252,
			 -252, -252, -252, -252, -252, -252, -252, -252, -252, -252,
			 -252, -252, -252, -252, -252, -252, -252, -252, -252, -252,
			 -252, -252, -252, -252, -252, -252, -252, -252, -252, -252,

			 -252, -252, -252, -252, -252, -252, -252, -252, -252, -252,
			 -252, -252,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -252, -252, -252, -252, -252, -252, -252,  101,
			  101,  101,  101,  101,  101,  101,  101,  349,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -252, -252, -252, -252,  101,
			 -252,  101,  101,  101,  101,  101,  101,  101,  101,  349,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -252, -252, -252,
			 -252, -252, -252, -252, -252, -252, -252, -252, -252, -252,

			 -252, -252, -252, -252, -252, -252, -252, -252, -252, -252,
			 -252, -252, -252, -252, -252, -252, -252, -252, -252, -252,
			 -252, -252, -252, -252, -252, -252, -252, -252, -252, -252,
			 -252, -252, -252, -252, -252, -252, -252, -252, -252, -252,
			 -252, -252, -252, -252, -252, -252, -252, -252, -252, -252,
			 -252, -252, -252, -252, -252, -252, -252, -252, -252, -252,
			 -252, -252, -252, -252, -252, -252, -252, -252, -252, -252,
			 -252, -252, -252, -252, -252, -252, -252, -252, -252, -252,
			 -252, -252, -252, -252, -252, -252, -252, -252, -252, -252,
			 -252, -252, -252, -252, -252, -252, -252, -252, -252, -252,

			 -252, -252, -252, -252, -252, -252, -252, -252, -252, -252,
			 -252, -252, -252, -252, -252, -252, -252, -252, -252, -252,
			 -252,    5, -253, -253, -253, -253, -253, -253, -253, -253,
			 -253, -253, -253, -253, -253, -253, -253, -253, -253, -253,
			 -253, -253, -253, -253, -253, -253, -253, -253, -253, -253,
			 -253, -253, -253, -253, -253, -253, -253, -253, -253, -253,
			 -253, -253, -253, -253, -253, -253, -253, -253, -253,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -253,
			 -253, -253, -253, -253, -253, -253,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -253, -253, -253, -253,  101, -253,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -253, -253, -253, -253, -253, -253,
			 -253, -253, -253, -253, -253, -253, -253, -253, -253, -253,
			 -253, -253, -253, -253, -253, -253, -253, -253, -253, -253,
			 -253, -253, -253, -253, -253, -253, -253, -253, -253, -253,
			 -253, -253, -253, -253, -253, -253, -253, -253, -253, -253,
			 -253, -253, -253, -253, -253, -253, -253, -253, -253, -253,

			 -253, -253, -253, -253, -253, -253, -253, -253, -253, -253,
			 -253, -253, -253, -253, -253, -253, -253, -253, -253, -253,
			 -253, -253, -253, -253, -253, -253, -253, -253, -253, -253,
			 -253, -253, -253, -253, -253, -253, -253, -253, -253, -253,
			 -253, -253, -253, -253, -253, -253, -253, -253, -253, -253,
			 -253, -253, -253, -253, -253, -253, -253, -253, -253, -253,
			 -253, -253, -253, -253, -253, -253, -253, -253, -253, -253,
			 -253, -253, -253, -253, -253, -253, -253, -253,    5, -254,
			 -254, -254, -254, -254, -254, -254, -254, -254, -254, -254,
			 -254, -254, -254, -254, -254, -254, -254, -254, -254, -254,

			 -254, -254, -254, -254, -254, -254, -254, -254, -254, -254,
			 -254, -254, -254, -254, -254, -254, -254, -254, -254, -254,
			 -254, -254, -254, -254, -254, -254,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -254, -254, -254, -254,
			 -254, -254, -254,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  350,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -254,
			 -254, -254, -254,  101, -254,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  350,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101, -254, -254, -254, -254, -254, -254, -254, -254, -254,
			 -254, -254, -254, -254, -254, -254, -254, -254, -254, -254,
			 -254, -254, -254, -254, -254, -254, -254, -254, -254, -254,
			 -254, -254, -254, -254, -254, -254, -254, -254, -254, -254,
			 -254, -254, -254, -254, -254, -254, -254, -254, -254, -254,
			 -254, -254, -254, -254, -254, -254, -254, -254, -254, -254,
			 -254, -254, -254, -254, -254, -254, -254, -254, -254, -254,
			 -254, -254, -254, -254, -254, -254, -254, -254, -254, -254,
			 -254, -254, -254, -254, -254, -254, -254, -254, -254, -254,
			 -254, -254, -254, -254, -254, -254, -254, -254, -254, -254,

			 -254, -254, -254, -254, -254, -254, -254, -254, -254, -254,
			 -254, -254, -254, -254, -254, -254, -254, -254, -254, -254,
			 -254, -254, -254, -254, -254, -254, -254, -254, -254, -254,
			 -254, -254, -254, -254, -254,    5, -255, -255, -255, -255,
			 -255, -255, -255, -255, -255, -255, -255, -255, -255, -255,
			 -255, -255, -255, -255, -255, -255, -255, -255, -255, -255,
			 -255, -255, -255, -255, -255, -255, -255, -255, -255, -255,
			 -255, -255, -255, -255, -255, -255, -255, -255, -255, -255,
			 -255, -255, -255,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -255, -255, -255, -255, -255, -255, -255,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -255, -255, -255, -255,
			  101, -255,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -255, -255,
			 -255, -255, -255, -255, -255, -255, -255, -255, -255, -255,
			 -255, -255, -255, -255, -255, -255, -255, -255, -255, -255,
			 -255, -255, -255, -255, -255, -255, -255, -255, -255, -255,
			 -255, -255, -255, -255, -255, -255, -255, -255, -255, -255,

			 -255, -255, -255, -255, -255, -255, -255, -255, -255, -255,
			 -255, -255, -255, -255, -255, -255, -255, -255, -255, -255,
			 -255, -255, -255, -255, -255, -255, -255, -255, -255, -255,
			 -255, -255, -255, -255, -255, -255, -255, -255, -255, -255,
			 -255, -255, -255, -255, -255, -255, -255, -255, -255, -255,
			 -255, -255, -255, -255, -255, -255, -255, -255, -255, -255,
			 -255, -255, -255, -255, -255, -255, -255, -255, -255, -255,
			 -255, -255, -255, -255, -255, -255, -255, -255, -255, -255,
			 -255, -255, -255, -255, -255, -255, -255, -255, -255, -255,
			 -255, -255,    5, -256, -256, -256, -256, -256, -256, -256,

			 -256, -256, -256, -256, -256, -256, -256, -256, -256, -256,
			 -256, -256, -256, -256, -256, -256, -256, -256, -256, -256,
			 -256, -256, -256, -256, -256, -256, -256, -256, -256, -256,
			 -256, -256, -256, -256, -256, -256, -256, -256, -256, -256,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -256, -256, -256, -256, -256, -256, -256,  101,  101,  101,
			  101,  351,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -256, -256, -256, -256,  101, -256,  101,
			  101,  101,  101,  351,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -256, -256, -256, -256, -256,
			 -256, -256, -256, -256, -256, -256, -256, -256, -256, -256,
			 -256, -256, -256, -256, -256, -256, -256, -256, -256, -256,
			 -256, -256, -256, -256, -256, -256, -256, -256, -256, -256,
			 -256, -256, -256, -256, -256, -256, -256, -256, -256, -256,
			 -256, -256, -256, -256, -256, -256, -256, -256, -256, -256,
			 -256, -256, -256, -256, -256, -256, -256, -256, -256, -256,
			 -256, -256, -256, -256, -256, -256, -256, -256, -256, -256,
			 -256, -256, -256, -256, -256, -256, -256, -256, -256, -256, yy_Dummy>>,
			1, 3000, 63000)
		end

	yy_nxt_template_23 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -256, -256, -256, -256, -256, -256, -256, -256, -256, -256,
			 -256, -256, -256, -256, -256, -256, -256, -256, -256, -256,
			 -256, -256, -256, -256, -256, -256, -256, -256, -256, -256,
			 -256, -256, -256, -256, -256, -256, -256, -256, -256, -256,
			 -256, -256, -256, -256, -256, -256, -256, -256, -256,    5,
			 -257, -257, -257, -257, -257, -257, -257, -257, -257, -257,
			 -257, -257, -257, -257, -257, -257, -257, -257, -257, -257,
			 -257, -257, -257, -257, -257, -257, -257, -257, -257, -257,
			 -257, -257, -257, -257, -257, -257, -257, -257, -257, -257,
			 -257, -257, -257, -257, -257, -257, -257,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101, -257, -257, -257,
			 -257, -257, -257, -257,  101,  101,  352,  101,  101,  353,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -257, -257, -257, -257,  101, -257,  101,  101,  352,  101,
			  101,  353,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -257, -257, -257, -257, -257, -257, -257, -257,
			 -257, -257, -257, -257, -257, -257, -257, -257, -257, -257,
			 -257, -257, -257, -257, -257, -257, -257, -257, -257, -257,

			 -257, -257, -257, -257, -257, -257, -257, -257, -257, -257,
			 -257, -257, -257, -257, -257, -257, -257, -257, -257, -257,
			 -257, -257, -257, -257, -257, -257, -257, -257, -257, -257,
			 -257, -257, -257, -257, -257, -257, -257, -257, -257, -257,
			 -257, -257, -257, -257, -257, -257, -257, -257, -257, -257,
			 -257, -257, -257, -257, -257, -257, -257, -257, -257, -257,
			 -257, -257, -257, -257, -257, -257, -257, -257, -257, -257,
			 -257, -257, -257, -257, -257, -257, -257, -257, -257, -257,
			 -257, -257, -257, -257, -257, -257, -257, -257, -257, -257,
			 -257, -257, -257, -257, -257, -257, -257, -257, -257, -257,

			 -257, -257, -257, -257, -257, -257,    5, -258, -258, -258,
			 -258, -258, -258, -258, -258, -258, -258, -258, -258, -258,
			 -258, -258, -258, -258, -258, -258, -258, -258, -258, -258,
			 -258, -258, -258, -258, -258, -258, -258, -258, -258, -258,
			 -258, -258, -258, -258, -258, -258, -258, -258, -258, -258,
			 -258, -258, -258, -258,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -258, -258, -258, -258, -258, -258,
			 -258,  101,  101,  101,  101,  354,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -258, -258, -258,

			 -258,  101, -258,  101,  101,  101,  101,  354,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -258,
			 -258, -258, -258, -258, -258, -258, -258, -258, -258, -258,
			 -258, -258, -258, -258, -258, -258, -258, -258, -258, -258,
			 -258, -258, -258, -258, -258, -258, -258, -258, -258, -258,
			 -258, -258, -258, -258, -258, -258, -258, -258, -258, -258,
			 -258, -258, -258, -258, -258, -258, -258, -258, -258, -258,
			 -258, -258, -258, -258, -258, -258, -258, -258, -258, -258,
			 -258, -258, -258, -258, -258, -258, -258, -258, -258, -258,

			 -258, -258, -258, -258, -258, -258, -258, -258, -258, -258,
			 -258, -258, -258, -258, -258, -258, -258, -258, -258, -258,
			 -258, -258, -258, -258, -258, -258, -258, -258, -258, -258,
			 -258, -258, -258, -258, -258, -258, -258, -258, -258, -258,
			 -258, -258, -258, -258, -258, -258, -258, -258, -258, -258,
			 -258, -258, -258, -258, -258, -258, -258, -258, -258, -258,
			 -258, -258, -258,    5, -259, -259, -259, -259, -259, -259,
			 -259, -259, -259, -259, -259, -259, -259, -259, -259, -259,
			 -259, -259, -259, -259, -259, -259, -259, -259, -259, -259,
			 -259, -259, -259, -259, -259, -259, -259, -259, -259, -259,

			 -259, -259, -259, -259, -259, -259, -259, -259, -259, -259,
			 -259,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -259, -259, -259, -259, -259, -259, -259,  355,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -259, -259, -259, -259,  101, -259,
			  355,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -259, -259, -259, -259,
			 -259, -259, -259, -259, -259, -259, -259, -259, -259, -259,

			 -259, -259, -259, -259, -259, -259, -259, -259, -259, -259,
			 -259, -259, -259, -259, -259, -259, -259, -259, -259, -259,
			 -259, -259, -259, -259, -259, -259, -259, -259, -259, -259,
			 -259, -259, -259, -259, -259, -259, -259, -259, -259, -259,
			 -259, -259, -259, -259, -259, -259, -259, -259, -259, -259,
			 -259, -259, -259, -259, -259, -259, -259, -259, -259, -259,
			 -259, -259, -259, -259, -259, -259, -259, -259, -259, -259,
			 -259, -259, -259, -259, -259, -259, -259, -259, -259, -259,
			 -259, -259, -259, -259, -259, -259, -259, -259, -259, -259,
			 -259, -259, -259, -259, -259, -259, -259, -259, -259, -259,

			 -259, -259, -259, -259, -259, -259, -259, -259, -259, -259,
			 -259, -259, -259, -259, -259, -259, -259, -259, -259, -259,
			    5, -260, -260, -260, -260, -260, -260, -260, -260, -260,
			 -260, -260, -260, -260, -260, -260, -260, -260, -260, -260,
			 -260, -260, -260, -260, -260, -260, -260, -260, -260, -260,
			 -260, -260, -260, -260, -260, -260, -260, -260, -260, -260,
			 -260, -260, -260, -260, -260, -260, -260, -260,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -260, -260,
			 -260, -260, -260, -260, -260,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  356,  101,  101,  101,  101,
			  101, -260, -260, -260, -260,  101, -260,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  356,  101,  101,
			  101,  101,  101, -260, -260, -260, -260, -260, -260, -260,
			 -260, -260, -260, -260, -260, -260, -260, -260, -260, -260,
			 -260, -260, -260, -260, -260, -260, -260, -260, -260, -260,
			 -260, -260, -260, -260, -260, -260, -260, -260, -260, -260,
			 -260, -260, -260, -260, -260, -260, -260, -260, -260, -260,
			 -260, -260, -260, -260, -260, -260, -260, -260, -260, -260,

			 -260, -260, -260, -260, -260, -260, -260, -260, -260, -260,
			 -260, -260, -260, -260, -260, -260, -260, -260, -260, -260,
			 -260, -260, -260, -260, -260, -260, -260, -260, -260, -260,
			 -260, -260, -260, -260, -260, -260, -260, -260, -260, -260,
			 -260, -260, -260, -260, -260, -260, -260, -260, -260, -260,
			 -260, -260, -260, -260, -260, -260, -260, -260, -260, -260,
			 -260, -260, -260, -260, -260, -260, -260, -260, -260, -260,
			 -260, -260, -260, -260, -260, -260, -260,    5, -261, -261,
			 -261, -261, -261, -261, -261, -261, -261, -261, -261, -261,
			 -261, -261, -261, -261, -261, -261, -261, -261, -261, -261,

			 -261, -261, -261, -261, -261, -261, -261, -261, -261, -261,
			 -261, -261, -261, -261, -261, -261, -261, -261, -261, -261,
			 -261, -261, -261, -261, -261,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -261, -261, -261, -261, -261,
			 -261, -261,  101,  101,  357,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  358,  101,  101,  101,  101,  101, -261, -261,
			 -261, -261,  101, -261,  101,  101,  357,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  358,  101,  101,  101,  101,  101,

			 -261, -261, -261, -261, -261, -261, -261, -261, -261, -261,
			 -261, -261, -261, -261, -261, -261, -261, -261, -261, -261,
			 -261, -261, -261, -261, -261, -261, -261, -261, -261, -261,
			 -261, -261, -261, -261, -261, -261, -261, -261, -261, -261,
			 -261, -261, -261, -261, -261, -261, -261, -261, -261, -261,
			 -261, -261, -261, -261, -261, -261, -261, -261, -261, -261,
			 -261, -261, -261, -261, -261, -261, -261, -261, -261, -261,
			 -261, -261, -261, -261, -261, -261, -261, -261, -261, -261,
			 -261, -261, -261, -261, -261, -261, -261, -261, -261, -261,
			 -261, -261, -261, -261, -261, -261, -261, -261, -261, -261,

			 -261, -261, -261, -261, -261, -261, -261, -261, -261, -261,
			 -261, -261, -261, -261, -261, -261, -261, -261, -261, -261,
			 -261, -261, -261, -261, -261, -261, -261, -261, -261, -261,
			 -261, -261, -261, -261,    5, -262, -262, -262, -262, -262,
			 -262, -262, -262, -262, -262, -262, -262, -262, -262, -262,
			 -262, -262, -262, -262, -262, -262, -262, -262, -262, -262,
			 -262, -262, -262, -262, -262, -262, -262, -262, -262, -262,
			 -262, -262, -262, -262, -262, -262, -262, -262, -262, -262,
			 -262, -262,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -262, -262, -262, -262, -262, -262, -262,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  359,  101,  101,  101,
			  101,  101,  101,  101,  101, -262, -262, -262, -262,  101,
			 -262,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  359,  101,
			  101,  101,  101,  101,  101,  101,  101, -262, -262, -262,
			 -262, -262, -262, -262, -262, -262, -262, -262, -262, -262,
			 -262, -262, -262, -262, -262, -262, -262, -262, -262, -262,
			 -262, -262, -262, -262, -262, -262, -262, -262, -262, -262,
			 -262, -262, -262, -262, -262, -262, -262, -262, -262, -262,

			 -262, -262, -262, -262, -262, -262, -262, -262, -262, -262,
			 -262, -262, -262, -262, -262, -262, -262, -262, -262, -262,
			 -262, -262, -262, -262, -262, -262, -262, -262, -262, -262,
			 -262, -262, -262, -262, -262, -262, -262, -262, -262, -262,
			 -262, -262, -262, -262, -262, -262, -262, -262, -262, -262,
			 -262, -262, -262, -262, -262, -262, -262, -262, -262, -262,
			 -262, -262, -262, -262, -262, -262, -262, -262, -262, -262,
			 -262, -262, -262, -262, -262, -262, -262, -262, -262, -262,
			 -262, -262, -262, -262, -262, -262, -262, -262, -262, -262,
			 -262,    5, -263, -263, -263, -263, -263, -263, -263, -263,

			 -263, -263, -263, -263, -263, -263, -263, -263, -263, -263,
			 -263, -263, -263, -263, -263, -263, -263, -263, -263, -263,
			 -263, -263, -263, -263, -263, -263, -263, -263, -263, -263,
			 -263, -263, -263, -263, -263, -263, -263, -263, -263,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -263,
			 -263, -263, -263, -263, -263, -263,  101,  101,  101,  101,
			  360,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -263, -263, -263, -263,  101, -263,  101,  101,
			  101,  101,  360,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -263, -263, -263, -263, -263, -263,
			 -263, -263, -263, -263, -263, -263, -263, -263, -263, -263,
			 -263, -263, -263, -263, -263, -263, -263, -263, -263, -263,
			 -263, -263, -263, -263, -263, -263, -263, -263, -263, -263,
			 -263, -263, -263, -263, -263, -263, -263, -263, -263, -263,
			 -263, -263, -263, -263, -263, -263, -263, -263, -263, -263,
			 -263, -263, -263, -263, -263, -263, -263, -263, -263, -263,
			 -263, -263, -263, -263, -263, -263, -263, -263, -263, -263,
			 -263, -263, -263, -263, -263, -263, -263, -263, -263, -263,

			 -263, -263, -263, -263, -263, -263, -263, -263, -263, -263,
			 -263, -263, -263, -263, -263, -263, -263, -263, -263, -263,
			 -263, -263, -263, -263, -263, -263, -263, -263, -263, -263,
			 -263, -263, -263, -263, -263, -263, -263, -263, -263, -263,
			 -263, -263, -263, -263, -263, -263, -263, -263,    5, -264,
			 -264, -264, -264, -264, -264, -264, -264, -264, -264, -264,
			 -264, -264, -264, -264, -264, -264, -264, -264, -264, -264,
			 -264, -264, -264, -264, -264, -264, -264, -264, -264, -264,
			 -264, -264, -264, -264, -264, -264, -264, -264, -264, -264,
			 -264, -264, -264, -264, -264, -264,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101, -264, -264, -264, -264,
			 -264, -264, -264,  361,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -264,
			 -264, -264, -264,  101, -264,  361,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -264, -264, -264, -264, -264, -264, -264, -264, -264,
			 -264, -264, -264, -264, -264, -264, -264, -264, -264, -264,
			 -264, -264, -264, -264, -264, -264, -264, -264, -264, -264,

			 -264, -264, -264, -264, -264, -264, -264, -264, -264, -264,
			 -264, -264, -264, -264, -264, -264, -264, -264, -264, -264,
			 -264, -264, -264, -264, -264, -264, -264, -264, -264, -264,
			 -264, -264, -264, -264, -264, -264, -264, -264, -264, -264,
			 -264, -264, -264, -264, -264, -264, -264, -264, -264, -264,
			 -264, -264, -264, -264, -264, -264, -264, -264, -264, -264,
			 -264, -264, -264, -264, -264, -264, -264, -264, -264, -264,
			 -264, -264, -264, -264, -264, -264, -264, -264, -264, -264,
			 -264, -264, -264, -264, -264, -264, -264, -264, -264, -264,
			 -264, -264, -264, -264, -264, -264, -264, -264, -264, -264,

			 -264, -264, -264, -264, -264,    5, -265, -265, -265, -265,
			 -265, -265, -265, -265, -265, -265, -265, -265, -265, -265,
			 -265, -265, -265, -265, -265, -265, -265, -265, -265, -265,
			 -265, -265, -265, -265, -265, -265, -265, -265, -265, -265,
			 -265, -265, -265, -265, -265, -265, -265, -265, -265, -265,
			 -265, -265, -265,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -265, -265, -265, -265, -265, -265, -265,
			  101,  101,  101,  101,  101,  101,  101,  101,  362,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -265, -265, -265, -265,

			  101, -265,  101,  101,  101,  101,  101,  101,  101,  101,
			  362,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -265, -265,
			 -265, -265, -265, -265, -265, -265, -265, -265, -265, -265,
			 -265, -265, -265, -265, -265, -265, -265, -265, -265, -265,
			 -265, -265, -265, -265, -265, -265, -265, -265, -265, -265,
			 -265, -265, -265, -265, -265, -265, -265, -265, -265, -265,
			 -265, -265, -265, -265, -265, -265, -265, -265, -265, -265,
			 -265, -265, -265, -265, -265, -265, -265, -265, -265, -265,
			 -265, -265, -265, -265, -265, -265, -265, -265, -265, -265,

			 -265, -265, -265, -265, -265, -265, -265, -265, -265, -265,
			 -265, -265, -265, -265, -265, -265, -265, -265, -265, -265,
			 -265, -265, -265, -265, -265, -265, -265, -265, -265, -265,
			 -265, -265, -265, -265, -265, -265, -265, -265, -265, -265,
			 -265, -265, -265, -265, -265, -265, -265, -265, -265, -265,
			 -265, -265, -265, -265, -265, -265, -265, -265, -265, -265,
			 -265, -265,    5, -266, -266, -266, -266, -266, -266, -266,
			 -266, -266, -266, -266, -266, -266, -266, -266, -266, -266,
			 -266, -266, -266, -266, -266, -266, -266, -266, -266, -266,
			 -266, -266, -266, -266, -266, -266, -266, -266, -266, -266,

			 -266, -266, -266, -266, -266, -266, -266, -266, -266, -266,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -266, -266, -266, -266, -266, -266, -266,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  363,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -266, -266, -266, -266,  101, -266,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  363,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -266, -266, -266, -266, -266,
			 -266, -266, -266, -266, -266, -266, -266, -266, -266, -266,

			 -266, -266, -266, -266, -266, -266, -266, -266, -266, -266,
			 -266, -266, -266, -266, -266, -266, -266, -266, -266, -266,
			 -266, -266, -266, -266, -266, -266, -266, -266, -266, -266,
			 -266, -266, -266, -266, -266, -266, -266, -266, -266, -266,
			 -266, -266, -266, -266, -266, -266, -266, -266, -266, -266,
			 -266, -266, -266, -266, -266, -266, -266, -266, -266, -266,
			 -266, -266, -266, -266, -266, -266, -266, -266, -266, -266,
			 -266, -266, -266, -266, -266, -266, -266, -266, -266, -266,
			 -266, -266, -266, -266, -266, -266, -266, -266, -266, -266,
			 -266, -266, -266, -266, -266, -266, -266, -266, -266, -266,

			 -266, -266, -266, -266, -266, -266, -266, -266, -266, -266,
			 -266, -266, -266, -266, -266, -266, -266, -266, -266,    5,
			 -267, -267, -267, -267, -267, -267, -267, -267, -267, -267,
			 -267, -267, -267, -267, -267, -267, -267, -267, -267, -267,
			 -267, -267, -267, -267, -267, -267, -267, -267, -267, -267,
			 -267, -267, -267, -267, -267, -267, -267, -267, -267, -267,
			 -267, -267, -267, -267, -267, -267, -267,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -267, -267, -267,
			 -267, -267, -267, -267,  101,  101,  101,  101,  364,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -267, -267, -267, -267,  101, -267,  101,  101,  101,  101,
			  364,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -267, -267, -267, -267, -267, -267, -267, -267,
			 -267, -267, -267, -267, -267, -267, -267, -267, -267, -267,
			 -267, -267, -267, -267, -267, -267, -267, -267, -267, -267,
			 -267, -267, -267, -267, -267, -267, -267, -267, -267, -267,
			 -267, -267, -267, -267, -267, -267, -267, -267, -267, -267,
			 -267, -267, -267, -267, -267, -267, -267, -267, -267, -267,

			 -267, -267, -267, -267, -267, -267, -267, -267, -267, -267,
			 -267, -267, -267, -267, -267, -267, -267, -267, -267, -267,
			 -267, -267, -267, -267, -267, -267, -267, -267, -267, -267,
			 -267, -267, -267, -267, -267, -267, -267, -267, -267, -267,
			 -267, -267, -267, -267, -267, -267, -267, -267, -267, -267,
			 -267, -267, -267, -267, -267, -267, -267, -267, -267, -267,
			 -267, -267, -267, -267, -267, -267, -267, -267, -267, -267,
			 -267, -267, -267, -267, -267, -267,    5, -268, -268, -268,
			 -268, -268, -268, -268, -268, -268, -268, -268, -268, -268,
			 -268, -268, -268, -268, -268, -268, -268, -268, -268, -268,

			 -268, -268, -268, -268, -268, -268, -268, -268, -268, -268,
			 -268, -268, -268, -268, -268, -268, -268, -268, -268, -268,
			 -268, -268, -268, -268,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -268, -268, -268, -268, -268, -268,
			 -268,  101,  101,  101,  101,  365,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -268, -268, -268,
			 -268,  101, -268,  101,  101,  101,  101,  365,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -268, yy_Dummy>>,
			1, 3000, 66000)
		end

	yy_nxt_template_24 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -268, -268, -268, -268, -268, -268, -268, -268, -268, -268,
			 -268, -268, -268, -268, -268, -268, -268, -268, -268, -268,
			 -268, -268, -268, -268, -268, -268, -268, -268, -268, -268,
			 -268, -268, -268, -268, -268, -268, -268, -268, -268, -268,
			 -268, -268, -268, -268, -268, -268, -268, -268, -268, -268,
			 -268, -268, -268, -268, -268, -268, -268, -268, -268, -268,
			 -268, -268, -268, -268, -268, -268, -268, -268, -268, -268,
			 -268, -268, -268, -268, -268, -268, -268, -268, -268, -268,
			 -268, -268, -268, -268, -268, -268, -268, -268, -268, -268,
			 -268, -268, -268, -268, -268, -268, -268, -268, -268, -268,

			 -268, -268, -268, -268, -268, -268, -268, -268, -268, -268,
			 -268, -268, -268, -268, -268, -268, -268, -268, -268, -268,
			 -268, -268, -268, -268, -268, -268, -268, -268, -268, -268,
			 -268, -268, -268,    5, -269, -269, -269, -269, -269, -269,
			 -269, -269, -269, -269, -269, -269, -269, -269, -269, -269,
			 -269, -269, -269, -269, -269, -269, -269, -269, -269, -269,
			 -269, -269, -269, -269, -269, -269, -269, -269, -269, -269,
			 -269, -269, -269, -269, -269, -269, -269, -269, -269, -269,
			 -269,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -269, -269, -269, -269, -269, -269, -269,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  366,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -269, -269, -269, -269,  101, -269,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  366,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -269, -269, -269, -269,
			 -269, -269, -269, -269, -269, -269, -269, -269, -269, -269,
			 -269, -269, -269, -269, -269, -269, -269, -269, -269, -269,
			 -269, -269, -269, -269, -269, -269, -269, -269, -269, -269,
			 -269, -269, -269, -269, -269, -269, -269, -269, -269, -269,

			 -269, -269, -269, -269, -269, -269, -269, -269, -269, -269,
			 -269, -269, -269, -269, -269, -269, -269, -269, -269, -269,
			 -269, -269, -269, -269, -269, -269, -269, -269, -269, -269,
			 -269, -269, -269, -269, -269, -269, -269, -269, -269, -269,
			 -269, -269, -269, -269, -269, -269, -269, -269, -269, -269,
			 -269, -269, -269, -269, -269, -269, -269, -269, -269, -269,
			 -269, -269, -269, -269, -269, -269, -269, -269, -269, -269,
			 -269, -269, -269, -269, -269, -269, -269, -269, -269, -269,
			 -269, -269, -269, -269, -269, -269, -269, -269, -269, -269,
			    5, -270, -270, -270, -270, -270, -270, -270, -270, -270,

			 -270, -270, -270, -270, -270, -270, -270, -270, -270, -270,
			 -270, -270, -270, -270, -270, -270, -270, -270, -270, -270,
			 -270, -270, -270, -270, -270, -270, -270, -270, -270, -270,
			 -270, -270, -270, -270, -270, -270, -270, -270,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -270, -270,
			 -270, -270, -270, -270, -270,  101,  101,  101,  101,  101,
			  101,  101,  101,  367,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -270, -270, -270, -270,  101, -270,  101,  101,  101,
			  101,  101,  101,  101,  101,  367,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -270, -270, -270, -270, -270, -270, -270,
			 -270, -270, -270, -270, -270, -270, -270, -270, -270, -270,
			 -270, -270, -270, -270, -270, -270, -270, -270, -270, -270,
			 -270, -270, -270, -270, -270, -270, -270, -270, -270, -270,
			 -270, -270, -270, -270, -270, -270, -270, -270, -270, -270,
			 -270, -270, -270, -270, -270, -270, -270, -270, -270, -270,
			 -270, -270, -270, -270, -270, -270, -270, -270, -270, -270,
			 -270, -270, -270, -270, -270, -270, -270, -270, -270, -270,
			 -270, -270, -270, -270, -270, -270, -270, -270, -270, -270,

			 -270, -270, -270, -270, -270, -270, -270, -270, -270, -270,
			 -270, -270, -270, -270, -270, -270, -270, -270, -270, -270,
			 -270, -270, -270, -270, -270, -270, -270, -270, -270, -270,
			 -270, -270, -270, -270, -270, -270, -270, -270, -270, -270,
			 -270, -270, -270, -270, -270, -270, -270,    5, -271, -271,
			 -271, -271, -271, -271, -271, -271, -271, -271, -271, -271,
			 -271, -271, -271, -271, -271, -271, -271, -271, -271, -271,
			 -271, -271, -271, -271, -271, -271, -271, -271, -271, -271,
			 -271, -271, -271, -271, -271, -271, -271, -271, -271, -271,
			 -271, -271, -271, -271, -271,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101, -271, -271, -271, -271, -271,
			 -271, -271,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -271, -271,
			 -271, -271,  101, -271,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -271, -271, -271, -271, -271, -271, -271, -271, -271, -271,
			 -271, -271, -271, -271, -271, -271, -271, -271, -271, -271,
			 -271, -271, -271, -271, -271, -271, -271, -271, -271, -271,

			 -271, -271, -271, -271, -271, -271, -271, -271, -271, -271,
			 -271, -271, -271, -271, -271, -271, -271, -271, -271, -271,
			 -271, -271, -271, -271, -271, -271, -271, -271, -271, -271,
			 -271, -271, -271, -271, -271, -271, -271, -271, -271, -271,
			 -271, -271, -271, -271, -271, -271, -271, -271, -271, -271,
			 -271, -271, -271, -271, -271, -271, -271, -271, -271, -271,
			 -271, -271, -271, -271, -271, -271, -271, -271, -271, -271,
			 -271, -271, -271, -271, -271, -271, -271, -271, -271, -271,
			 -271, -271, -271, -271, -271, -271, -271, -271, -271, -271,
			 -271, -271, -271, -271, -271, -271, -271, -271, -271, -271,

			 -271, -271, -271, -271,    5, -272, -272, -272, -272, -272,
			 -272, -272, -272, -272, -272, -272, -272, -272, -272, -272,
			 -272, -272, -272, -272, -272, -272, -272, -272, -272, -272,
			 -272, -272, -272, -272, -272, -272, -272, -272, -272, -272,
			 -272, -272, -272, -272, -272, -272, -272, -272, -272, -272,
			 -272, -272,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -272, -272, -272, -272, -272, -272, -272,  101,
			  101,  101,  101,  101,  101,  101,  101,  368,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -272, -272, -272, -272,  101,

			 -272,  101,  101,  101,  101,  101,  101,  101,  101,  368,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -272, -272, -272,
			 -272, -272, -272, -272, -272, -272, -272, -272, -272, -272,
			 -272, -272, -272, -272, -272, -272, -272, -272, -272, -272,
			 -272, -272, -272, -272, -272, -272, -272, -272, -272, -272,
			 -272, -272, -272, -272, -272, -272, -272, -272, -272, -272,
			 -272, -272, -272, -272, -272, -272, -272, -272, -272, -272,
			 -272, -272, -272, -272, -272, -272, -272, -272, -272, -272,
			 -272, -272, -272, -272, -272, -272, -272, -272, -272, -272,

			 -272, -272, -272, -272, -272, -272, -272, -272, -272, -272,
			 -272, -272, -272, -272, -272, -272, -272, -272, -272, -272,
			 -272, -272, -272, -272, -272, -272, -272, -272, -272, -272,
			 -272, -272, -272, -272, -272, -272, -272, -272, -272, -272,
			 -272, -272, -272, -272, -272, -272, -272, -272, -272, -272,
			 -272, -272, -272, -272, -272, -272, -272, -272, -272, -272,
			 -272,    5, -273, -273, -273, -273, -273, -273, -273, -273,
			 -273, -273, -273, -273, -273, -273, -273, -273, -273, -273,
			 -273, -273, -273, -273, -273, -273, -273, -273, -273, -273,
			 -273, -273, -273, -273, -273, -273, -273, -273, -273, -273,

			 -273, -273, -273, -273, -273, -273, -273, -273, -273,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -273,
			 -273, -273, -273, -273, -273, -273,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  369,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -273, -273, -273, -273,  101, -273,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  369,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -273, -273, -273, -273, -273, -273,
			 -273, -273, -273, -273, -273, -273, -273, -273, -273, -273,

			 -273, -273, -273, -273, -273, -273, -273, -273, -273, -273,
			 -273, -273, -273, -273, -273, -273, -273, -273, -273, -273,
			 -273, -273, -273, -273, -273, -273, -273, -273, -273, -273,
			 -273, -273, -273, -273, -273, -273, -273, -273, -273, -273,
			 -273, -273, -273, -273, -273, -273, -273, -273, -273, -273,
			 -273, -273, -273, -273, -273, -273, -273, -273, -273, -273,
			 -273, -273, -273, -273, -273, -273, -273, -273, -273, -273,
			 -273, -273, -273, -273, -273, -273, -273, -273, -273, -273,
			 -273, -273, -273, -273, -273, -273, -273, -273, -273, -273,
			 -273, -273, -273, -273, -273, -273, -273, -273, -273, -273,

			 -273, -273, -273, -273, -273, -273, -273, -273, -273, -273,
			 -273, -273, -273, -273, -273, -273, -273, -273,    5, -274,
			 -274, -274, -274, -274, -274, -274, -274, -274, -274, -274,
			 -274, -274, -274, -274, -274, -274, -274, -274, -274, -274,
			 -274, -274, -274, -274, -274, -274, -274, -274, -274, -274,
			 -274, -274, -274, -274, -274, -274, -274, -274, -274, -274,
			 -274, -274, -274, -274, -274, -274,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -274, -274, -274, -274,
			 -274, -274, -274,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101, -274,
			 -274, -274, -274,  101, -274,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -274, -274, -274, -274, -274, -274, -274, -274, -274,
			 -274, -274, -274, -274, -274, -274, -274, -274, -274, -274,
			 -274, -274, -274, -274, -274, -274, -274, -274, -274, -274,
			 -274, -274, -274, -274, -274, -274, -274, -274, -274, -274,
			 -274, -274, -274, -274, -274, -274, -274, -274, -274, -274,
			 -274, -274, -274, -274, -274, -274, -274, -274, -274, -274,

			 -274, -274, -274, -274, -274, -274, -274, -274, -274, -274,
			 -274, -274, -274, -274, -274, -274, -274, -274, -274, -274,
			 -274, -274, -274, -274, -274, -274, -274, -274, -274, -274,
			 -274, -274, -274, -274, -274, -274, -274, -274, -274, -274,
			 -274, -274, -274, -274, -274, -274, -274, -274, -274, -274,
			 -274, -274, -274, -274, -274, -274, -274, -274, -274, -274,
			 -274, -274, -274, -274, -274, -274, -274, -274, -274, -274,
			 -274, -274, -274, -274, -274,    5, -275, -275, -275, -275,
			 -275, -275, -275, -275,  275,  148, -275, -275,  275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,

			 -275, -275, -275, -275, -275, -275, -275,  275, -275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,

			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,

			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,
			 -275, -275, -275, -275, -275, -275, -275, -275, -275, -275,
			 -275, -275,    5, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,

			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,

			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276, -276,
			 -276, -276, -276, -276, -276, -276, -276, -276, -276,    5,
			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,

			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277,  370,  277,  277,  277,
			  277,  277,  277,  277,  277,  277,  277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,

			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,

			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277, -277, -277, -277, -277,
			 -277, -277, -277, -277, -277, -277,    5, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,

			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,

			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,
			 -278, -278, -278, -278, -278, -278, -278, -278, -278, -278,

			 -278, -278, -278,    5, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,

			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,

			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			 -279, -279, -279, -279, -279, -279, -279, -279, -279, -279,
			    5, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280, yy_Dummy>>,
			1, 3000, 69000)
		end

	yy_nxt_template_25 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,

			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,

			 -280, -280, -280, -280, -280, -280, -280, -280, -280, -280,
			 -280, -280, -280, -280, -280, -280, -280,    5,   64,   64,
			   64,   64,   64,   64,   64,   64,   64, -281,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,  371,
			   64,  372,   64,   64, -281,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,    5,   64,   64,   64,   64,   64,
			   64,   64,   64,   64, -282,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   65,   64,
			   64, -282,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			  373,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,  373,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,    5,   64,   64,   64,   64,   64,   64,   64,   64,
			   64, -283,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,  374,   64,   64, -283,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,    5,   64,
			   64,   64,   64,   64,   64,   64,   64,   64, -284,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   65,   64,   64, -284,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,  375,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,  375,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,    5, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,

			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,

			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,
			 -285, -285, -285, -285, -285, -285, -285, -285, -285, -285,

			 -285, -285,    5,   64,   64,   64,   64,   64,   64,   64,
			   64,   64, -286,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,  376,   64,   64, -286,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,    5,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,

			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,

			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,

			 -287, -287, -287, -287, -287, -287, -287, -287, -287, -287,
			 -287, -287, -287, -287, -287, -287,    5, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,

			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,

			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288, -288, -288, -288, -288, -288, -288, -288,
			 -288, -288, -288,    5, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,

			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,

			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,

			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			 -289, -289, -289, -289, -289, -289, -289, -289, -289, -289,
			    5, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,

			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,

			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290, -290, -290, -290,
			 -290, -290, -290, -290, -290, -290, -290,    5, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,

			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,

			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291, yy_Dummy>>,
			1, 3000, 72000)
		end

	yy_nxt_template_26 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291, -291, -291, -291, -291, -291, -291,
			 -291, -291, -291, -291,    5, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,

			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,

			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,
			 -292, -292, -292, -292, -292, -292, -292, -292, -292, -292,

			 -292,    5, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,

			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,

			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293, -293, -293,
			 -293, -293, -293, -293, -293, -293, -293, -293,    5, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,

			 -294, -294, -294, -294, -294,  377,  294,  294,  294,  294,
			  294,  294,  294,  294,  294,  294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,

			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,

			 -294, -294, -294, -294, -294, -294, -294, -294, -294, -294,
			 -294, -294, -294, -294, -294,    5, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,

			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,

			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295, -295, -295, -295, -295, -295, -295, -295, -295,
			 -295, -295,    5, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,

			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,

			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,

			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296, -296,
			 -296, -296, -296, -296, -296, -296, -296, -296, -296,    5,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,

			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,

			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297, -297, -297, -297, -297,
			 -297, -297, -297, -297, -297, -297,    5, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,

			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,

			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,

			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298, -298, -298, -298, -298, -298, -298, -298,
			 -298, -298, -298,    5, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,

			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,

			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,
			 -299, -299, -299, -299, -299, -299, -299, -299, -299, -299,

			    5, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,

			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,

			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300, -300, -300, -300,
			 -300, -300, -300, -300, -300, -300, -300,    5, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,

			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,

			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,

			 -301, -301, -301, -301, -301, -301, -301, -301, -301, -301,
			 -301, -301, -301, -301,    5, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,

			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,

			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302, -302, -302, -302, -302, -302, -302, -302, -302, -302,
			 -302,    5, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,

			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303, yy_Dummy>>,
			1, 3000, 75000)
		end

	yy_nxt_template_27 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,

			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303, -303, -303,
			 -303, -303, -303, -303, -303, -303, -303, -303,    5, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,

			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,

			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304, -304, -304, -304, -304, -304,
			 -304, -304, -304, -304, -304,    5, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,

			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,

			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,

			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305, -305, -305, -305, -305, -305, -305, -305, -305,
			 -305, -305,    5, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,

			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,

			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306, -306,
			 -306, -306, -306, -306, -306, -306, -306, -306, -306,    5,

			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,

			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,

			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307, -307, -307, -307, -307,
			 -307, -307, -307, -307, -307, -307,    5, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,

			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,

			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,

			 -308, -308, -308, -308, -308, -308, -308, -308, -308, -308,
			 -308, -308, -308,    5, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,

			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,

			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			 -309, -309, -309, -309, -309, -309, -309, -309, -309, -309,
			    5, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,

			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,

			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,

			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310, -310, -310, -310,
			 -310, -310, -310, -310, -310, -310, -310,    5, -311, -311,
			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,
			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,
			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,
			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,
			 -311, -311, -311, -311, -311,  378,  378,  378,  378,  378,
			  378,  378,  378,  378,  378, -311, -311, -311, -311, -311,
			 -311, -311, -311, -311, -311, -311,  216, -311, -311, -311,

			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,
			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,
			 -311, -311,  217, -311, -311, -311, -311, -311,  216, -311,
			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,
			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,
			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,
			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,
			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,
			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,
			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,

			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,
			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,
			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,
			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,
			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,
			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,
			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,
			 -311, -311, -311, -311, -311, -311, -311, -311, -311, -311,
			 -311, -311, -311, -311,    5, -312, -312, -312, -312, -312,
			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,

			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312, -312,  313,  313,  313,  313,  313,  313,  313,  313,
			  313,  313, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,

			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,

			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312, -312, -312, -312, -312, -312, -312, -312, -312, -312,
			 -312,    5, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313, -313,  379,
			  379,  379,  379,  379,  379,  379,  379,  379,  379, -313,

			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313,  380, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,

			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313, -313, -313,
			 -313, -313, -313, -313, -313, -313, -313, -313,    5, -314,

			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314,  381,  381,  381,  381,
			  381,  381,  381,  381,  381,  381, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,

			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,

			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314, -314, -314, -314, -314, -314,
			 -314, -314, -314, -314, -314,    5, -315, -315, -315, -315,
			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315,
			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315,
			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315,
			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315, yy_Dummy>>,
			1, 3000, 78000)
		end

	yy_nxt_template_28 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -315, -315, -315,  382,  382,  382,  382,  382,  382,  382,
			  382,  382,  382, -315, -315, -315, -315, -315, -315, -315,
			 -315, -315, -315, -315,  316, -315, -315, -315, -315, -315,
			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315,
			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315,
			  317, -315, -315, -315, -315, -315,  316, -315, -315, -315,
			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315,
			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315,
			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315,
			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315,

			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315,
			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315,
			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315,
			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315,
			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315,
			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315,
			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315,
			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315,
			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315,
			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315,

			 -315, -315, -315, -315, -315, -315, -315, -315, -315, -315,
			 -315, -315,    5, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316,  383, -316,  383, -316, -316,
			  384,  384,  384,  384,  384,  384,  384,  384,  384,  384,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,

			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,

			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316, -316,
			 -316, -316, -316, -316, -316, -316, -316, -316, -316,    5,
			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,

			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317, -317,  385,  385,  385,
			  385,  385,  385,  385,  385,  385,  385, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,

			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,

			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317, -317, -317, -317, -317,
			 -317, -317, -317, -317, -317, -317,    5, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318,  319,  319,  319,  319,  319,  319,
			  319,  319,  319,  319, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,

			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,

			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318, -318, -318, -318, -318, -318, -318, -318,
			 -318, -318, -318,    5, -319, -319, -319, -319, -319, -319,
			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,

			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,
			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,
			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,
			 -319,  386,  386,  386,  386,  386,  386,  386,  386,  386,
			  386, -319, -319, -319, -319, -319, -319, -319, -319, -319,
			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,
			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,
			 -319, -319, -319, -319, -319, -319, -319, -319,  387, -319,
			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,
			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,

			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,
			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,
			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,
			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,
			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,
			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,
			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,
			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,
			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,
			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,

			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,
			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,
			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,
			 -319, -319, -319, -319, -319, -319, -319, -319, -319, -319,
			    5, -320, -320, -320, -320, -320, -320, -320, -320, -320,
			 -320, -320, -320, -320, -320, -320, -320, -320, -320, -320,
			 -320, -320, -320, -320, -320, -320, -320, -320, -320, -320,
			 -320, -320, -320, -320, -320, -320, -320, -320, -320, -320,
			 -320, -320, -320, -320, -320, -320,  388, -320,  320,  320,
			  321,  321,  321,  321,  321,  321,  321,  321, -320, -320,

			 -320, -320, -320, -320, -320, -320,   93, -320, -320, -320,
			 -320, -320, -320, -320, -320, -320, -320, -320, -320, -320,
			 -320, -320, -320, -320, -320, -320, -320, -320, -320, -320,
			 -320, -320, -320, -320, -320,  143, -320, -320,   93, -320,
			 -320, -320, -320, -320, -320, -320, -320, -320, -320, -320,
			 -320, -320, -320, -320, -320, -320, -320, -320, -320, -320,
			 -320, -320, -320, -320, -320, -320, -320, -320, -320, -320,
			 -320, -320, -320, -320, -320, -320, -320, -320, -320, -320,
			 -320, -320, -320, -320, -320, -320, -320, -320, -320, -320,
			 -320, -320, -320, -320, -320, -320, -320, -320, -320, -320,

			 -320, -320, -320, -320, -320, -320, -320, -320, -320, -320,
			 -320, -320, -320, -320, -320, -320, -320, -320, -320, -320,
			 -320, -320, -320, -320, -320, -320, -320, -320, -320, -320,
			 -320, -320, -320, -320, -320, -320, -320, -320, -320, -320,
			 -320, -320, -320, -320, -320, -320, -320, -320, -320, -320,
			 -320, -320, -320, -320, -320, -320, -320, -320, -320, -320,
			 -320, -320, -320, -320, -320, -320, -320, -320, -320, -320,
			 -320, -320, -320, -320, -320, -320, -320, -320, -320, -320,
			 -320, -320, -320, -320, -320, -320, -320, -320, -320, -320,
			 -320, -320, -320, -320, -320, -320, -320,    5, -321, -321,

			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321, -321,  388, -321,  321,  321,  321,  321,  321,
			  321,  321,  321,  321,  321, -321, -321, -321, -321, -321,
			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321,  143, -321, -321, -321, -321, -321, -321, -321,

			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,

			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321, -321, -321, -321, -321, -321, -321, -321, -321,
			 -321, -321, -321, -321,    5, -322, -322, -322, -322, -322,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,

			 -322, -322,  389,  389,  389,  389,  389,  389,  389,  389,
			  389,  389, -322, -322, -322, -322, -322, -322, -322, -322,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322,  143,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,

			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,
			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,

			 -322, -322, -322, -322, -322, -322, -322, -322, -322, -322,
			 -322,    5, -323, -323, -323, -323, -323, -323, -323, -323,
			 -323, -323, -323, -323, -323, -323, -323, -323, -323, -323,
			 -323, -323, -323, -323, -323, -323, -323, -323, -323, -323,
			 -323, -323, -323, -323, -323, -323, -323, -323, -323, -323,
			 -323, -323, -323, -323, -323, -323, -323, -323, -323,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -323,
			 -323, -323, -323, -323, -323, -323,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  390,  101,  101,  101,  101,  101,

			  101,  101, -323, -323, -323, -323,  101, -323,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  390,  101,  101,  101,
			  101,  101,  101,  101, -323, -323, -323, -323, -323, -323,
			 -323, -323, -323, -323, -323, -323, -323, -323, -323, -323,
			 -323, -323, -323, -323, -323, -323, -323, -323, -323, -323,
			 -323, -323, -323, -323, -323, -323, -323, -323, -323, -323,
			 -323, -323, -323, -323, -323, -323, -323, -323, -323, -323,
			 -323, -323, -323, -323, -323, -323, -323, -323, -323, -323,
			 -323, -323, -323, -323, -323, -323, -323, -323, -323, -323,

			 -323, -323, -323, -323, -323, -323, -323, -323, -323, -323,
			 -323, -323, -323, -323, -323, -323, -323, -323, -323, -323,
			 -323, -323, -323, -323, -323, -323, -323, -323, -323, -323,
			 -323, -323, -323, -323, -323, -323, -323, -323, -323, -323,
			 -323, -323, -323, -323, -323, -323, -323, -323, -323, -323,
			 -323, -323, -323, -323, -323, -323, -323, -323, -323, -323,
			 -323, -323, -323, -323, -323, -323, -323, -323,    5, -324,
			 -324, -324, -324, -324, -324, -324, -324, -324, -324, -324,
			 -324, -324, -324, -324, -324, -324, -324, -324, -324, -324,
			 -324, -324, -324, -324, -324, -324, -324, -324, -324, -324,

			 -324, -324, -324, -324, -324, -324, -324, -324, -324, -324,
			 -324, -324, -324, -324, -324, -324,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -324, -324, -324, -324,
			 -324, -324, -324,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  391,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -324,
			 -324, -324, -324,  101, -324,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  391,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -324, -324, -324, -324, -324, -324, -324, -324, -324,

			 -324, -324, -324, -324, -324, -324, -324, -324, -324, -324,
			 -324, -324, -324, -324, -324, -324, -324, -324, -324, -324,
			 -324, -324, -324, -324, -324, -324, -324, -324, -324, -324,
			 -324, -324, -324, -324, -324, -324, -324, -324, -324, -324,
			 -324, -324, -324, -324, -324, -324, -324, -324, -324, -324,
			 -324, -324, -324, -324, -324, -324, -324, -324, -324, -324,
			 -324, -324, -324, -324, -324, -324, -324, -324, -324, -324,
			 -324, -324, -324, -324, -324, -324, -324, -324, -324, -324,
			 -324, -324, -324, -324, -324, -324, -324, -324, -324, -324,
			 -324, -324, -324, -324, -324, -324, -324, -324, -324, -324,

			 -324, -324, -324, -324, -324, -324, -324, -324, -324, -324,
			 -324, -324, -324, -324, -324, -324, -324, -324, -324, -324,
			 -324, -324, -324, -324, -324,    5, -325, -325, -325, -325,
			 -325, -325, -325, -325, -325, -325, -325, -325, -325, -325,
			 -325, -325, -325, -325, -325, -325, -325, -325, -325, -325,
			 -325, -325, -325, -325, -325, -325, -325, -325, -325, -325,
			 -325, -325, -325, -325, -325, -325, -325, -325, -325, -325,
			 -325, -325, -325,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -325, -325, -325, -325, -325, -325, -325,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  392,  101,
			  101,  101,  101,  101,  101,  101, -325, -325, -325, -325,
			  101, -325,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  392,  101,  101,  101,  101,  101,  101,  101, -325, -325,
			 -325, -325, -325, -325, -325, -325, -325, -325, -325, -325,
			 -325, -325, -325, -325, -325, -325, -325, -325, -325, -325,
			 -325, -325, -325, -325, -325, -325, -325, -325, -325, -325,
			 -325, -325, -325, -325, -325, -325, -325, -325, -325, -325,
			 -325, -325, -325, -325, -325, -325, -325, -325, -325, -325,

			 -325, -325, -325, -325, -325, -325, -325, -325, -325, -325,
			 -325, -325, -325, -325, -325, -325, -325, -325, -325, -325,
			 -325, -325, -325, -325, -325, -325, -325, -325, -325, -325,
			 -325, -325, -325, -325, -325, -325, -325, -325, -325, -325,
			 -325, -325, -325, -325, -325, -325, -325, -325, -325, -325,
			 -325, -325, -325, -325, -325, -325, -325, -325, -325, -325,
			 -325, -325, -325, -325, -325, -325, -325, -325, -325, -325,
			 -325, -325, -325, -325, -325, -325, -325, -325, -325, -325,
			 -325, -325,    5, -326, -326, -326, -326, -326, -326, -326,
			 -326, -326, -326, -326, -326, -326, -326, -326, -326, -326,

			 -326, -326, -326, -326, -326, -326, -326, -326, -326, -326,
			 -326, -326, -326, -326, -326, -326, -326, -326, -326, -326,
			 -326, -326, -326, -326, -326, -326, -326, -326, -326, -326,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -326, -326, -326, -326, -326, -326, -326,  101,  101,  101,
			  101,  101,  101,  101,  101,  393,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -326, -326, -326, -326,  101, -326,  101,
			  101,  101,  101,  101,  101,  101,  101,  393,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101, -326, -326, -326, -326, -326,
			 -326, -326, -326, -326, -326, -326, -326, -326, -326, -326,
			 -326, -326, -326, -326, -326, -326, -326, -326, -326, -326,
			 -326, -326, -326, -326, -326, -326, -326, -326, -326, -326,
			 -326, -326, -326, -326, -326, -326, -326, -326, -326, -326,
			 -326, -326, -326, -326, -326, -326, -326, -326, -326, -326,
			 -326, -326, -326, -326, -326, -326, -326, -326, -326, -326,
			 -326, -326, -326, -326, -326, -326, -326, -326, -326, -326,
			 -326, -326, -326, -326, -326, -326, -326, -326, -326, -326,
			 -326, -326, -326, -326, -326, -326, -326, -326, -326, -326, yy_Dummy>>,
			1, 3000, 81000)
		end

	yy_nxt_template_29 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -326, -326, -326, -326, -326, -326, -326, -326, -326, -326,
			 -326, -326, -326, -326, -326, -326, -326, -326, -326, -326,
			 -326, -326, -326, -326, -326, -326, -326, -326, -326, -326,
			 -326, -326, -326, -326, -326, -326, -326, -326, -326,    5,
			 -327, -327, -327, -327, -327, -327, -327, -327, -327, -327,
			 -327, -327, -327, -327, -327, -327, -327, -327, -327, -327,
			 -327, -327, -327, -327, -327, -327, -327, -327, -327, -327,
			 -327, -327, -327, -327, -327, -327, -327, -327, -327, -327,
			 -327, -327, -327, -327, -327, -327, -327,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -327, -327, -327,

			 -327, -327, -327, -327,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  394,  101,  101,  101,  101,  101,  101,
			 -327, -327, -327, -327,  101, -327,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  394,  101,  101,  101,  101,
			  101,  101, -327, -327, -327, -327, -327, -327, -327, -327,
			 -327, -327, -327, -327, -327, -327, -327, -327, -327, -327,
			 -327, -327, -327, -327, -327, -327, -327, -327, -327, -327,
			 -327, -327, -327, -327, -327, -327, -327, -327, -327, -327,

			 -327, -327, -327, -327, -327, -327, -327, -327, -327, -327,
			 -327, -327, -327, -327, -327, -327, -327, -327, -327, -327,
			 -327, -327, -327, -327, -327, -327, -327, -327, -327, -327,
			 -327, -327, -327, -327, -327, -327, -327, -327, -327, -327,
			 -327, -327, -327, -327, -327, -327, -327, -327, -327, -327,
			 -327, -327, -327, -327, -327, -327, -327, -327, -327, -327,
			 -327, -327, -327, -327, -327, -327, -327, -327, -327, -327,
			 -327, -327, -327, -327, -327, -327, -327, -327, -327, -327,
			 -327, -327, -327, -327, -327, -327, -327, -327, -327, -327,
			 -327, -327, -327, -327, -327, -327,    5, -328, -328, -328,

			 -328, -328, -328, -328, -328, -328, -328, -328, -328, -328,
			 -328, -328, -328, -328, -328, -328, -328, -328, -328, -328,
			 -328, -328, -328, -328, -328, -328, -328, -328, -328, -328,
			 -328, -328, -328, -328, -328, -328, -328, -328, -328, -328,
			 -328, -328, -328, -328,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -328, -328, -328, -328, -328, -328,
			 -328,  101,  101,  101,  101,  395,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -328, -328, -328,
			 -328,  101, -328,  101,  101,  101,  101,  395,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -328,
			 -328, -328, -328, -328, -328, -328, -328, -328, -328, -328,
			 -328, -328, -328, -328, -328, -328, -328, -328, -328, -328,
			 -328, -328, -328, -328, -328, -328, -328, -328, -328, -328,
			 -328, -328, -328, -328, -328, -328, -328, -328, -328, -328,
			 -328, -328, -328, -328, -328, -328, -328, -328, -328, -328,
			 -328, -328, -328, -328, -328, -328, -328, -328, -328, -328,
			 -328, -328, -328, -328, -328, -328, -328, -328, -328, -328,
			 -328, -328, -328, -328, -328, -328, -328, -328, -328, -328,

			 -328, -328, -328, -328, -328, -328, -328, -328, -328, -328,
			 -328, -328, -328, -328, -328, -328, -328, -328, -328, -328,
			 -328, -328, -328, -328, -328, -328, -328, -328, -328, -328,
			 -328, -328, -328, -328, -328, -328, -328, -328, -328, -328,
			 -328, -328, -328, -328, -328, -328, -328, -328, -328, -328,
			 -328, -328, -328,    5, -329, -329, -329, -329, -329, -329,
			 -329, -329, -329, -329, -329, -329, -329, -329, -329, -329,
			 -329, -329, -329, -329, -329, -329, -329, -329, -329, -329,
			 -329, -329, -329, -329, -329, -329, -329, -329, -329, -329,
			 -329, -329, -329, -329, -329, -329, -329, -329, -329, -329,

			 -329,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -329, -329, -329, -329, -329, -329, -329,  101,  101,
			  101,  101,  101,  101,  396,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -329, -329, -329, -329,  101, -329,
			  101,  101,  101,  101,  101,  101,  396,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -329, -329, -329, -329,
			 -329, -329, -329, -329, -329, -329, -329, -329, -329, -329,
			 -329, -329, -329, -329, -329, -329, -329, -329, -329, -329,

			 -329, -329, -329, -329, -329, -329, -329, -329, -329, -329,
			 -329, -329, -329, -329, -329, -329, -329, -329, -329, -329,
			 -329, -329, -329, -329, -329, -329, -329, -329, -329, -329,
			 -329, -329, -329, -329, -329, -329, -329, -329, -329, -329,
			 -329, -329, -329, -329, -329, -329, -329, -329, -329, -329,
			 -329, -329, -329, -329, -329, -329, -329, -329, -329, -329,
			 -329, -329, -329, -329, -329, -329, -329, -329, -329, -329,
			 -329, -329, -329, -329, -329, -329, -329, -329, -329, -329,
			 -329, -329, -329, -329, -329, -329, -329, -329, -329, -329,
			 -329, -329, -329, -329, -329, -329, -329, -329, -329, -329,

			 -329, -329, -329, -329, -329, -329, -329, -329, -329, -329,
			    5, -330, -330, -330, -330, -330, -330, -330, -330, -330,
			 -330, -330, -330, -330, -330, -330, -330, -330, -330, -330,
			 -330, -330, -330, -330, -330, -330, -330, -330, -330, -330,
			 -330, -330, -330, -330, -330, -330, -330, -330, -330, -330,
			 -330, -330, -330, -330, -330, -330, -330, -330,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -330, -330,
			 -330, -330, -330, -330, -330,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  397,  101,  101,  101,  101,  101,  101,  101,

			  101, -330, -330, -330, -330,  101, -330,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  397,  101,  101,  101,  101,  101,
			  101,  101,  101, -330, -330, -330, -330, -330, -330, -330,
			 -330, -330, -330, -330, -330, -330, -330, -330, -330, -330,
			 -330, -330, -330, -330, -330, -330, -330, -330, -330, -330,
			 -330, -330, -330, -330, -330, -330, -330, -330, -330, -330,
			 -330, -330, -330, -330, -330, -330, -330, -330, -330, -330,
			 -330, -330, -330, -330, -330, -330, -330, -330, -330, -330,
			 -330, -330, -330, -330, -330, -330, -330, -330, -330, -330,

			 -330, -330, -330, -330, -330, -330, -330, -330, -330, -330,
			 -330, -330, -330, -330, -330, -330, -330, -330, -330, -330,
			 -330, -330, -330, -330, -330, -330, -330, -330, -330, -330,
			 -330, -330, -330, -330, -330, -330, -330, -330, -330, -330,
			 -330, -330, -330, -330, -330, -330, -330, -330, -330, -330,
			 -330, -330, -330, -330, -330, -330, -330, -330, -330, -330,
			 -330, -330, -330, -330, -330, -330, -330,    5, -331, -331,
			 -331, -331, -331, -331, -331, -331, -331, -331, -331, -331,
			 -331, -331, -331, -331, -331, -331, -331, -331, -331, -331,
			 -331, -331, -331, -331, -331, -331, -331, -331, -331, -331,

			 -331, -331, -331, -331, -331, -331, -331, -331, -331, -331,
			 -331, -331, -331, -331, -331,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -331, -331, -331, -331, -331,
			 -331, -331,  101,  101,  101,  101,  101,  101,  101,  101,
			  398,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -331, -331,
			 -331, -331,  101, -331,  101,  101,  101,  101,  101,  101,
			  101,  101,  398,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -331, -331, -331, -331, -331, -331, -331, -331, -331, -331,

			 -331, -331, -331, -331, -331, -331, -331, -331, -331, -331,
			 -331, -331, -331, -331, -331, -331, -331, -331, -331, -331,
			 -331, -331, -331, -331, -331, -331, -331, -331, -331, -331,
			 -331, -331, -331, -331, -331, -331, -331, -331, -331, -331,
			 -331, -331, -331, -331, -331, -331, -331, -331, -331, -331,
			 -331, -331, -331, -331, -331, -331, -331, -331, -331, -331,
			 -331, -331, -331, -331, -331, -331, -331, -331, -331, -331,
			 -331, -331, -331, -331, -331, -331, -331, -331, -331, -331,
			 -331, -331, -331, -331, -331, -331, -331, -331, -331, -331,
			 -331, -331, -331, -331, -331, -331, -331, -331, -331, -331,

			 -331, -331, -331, -331, -331, -331, -331, -331, -331, -331,
			 -331, -331, -331, -331, -331, -331, -331, -331, -331, -331,
			 -331, -331, -331, -331,    5, -332, -332, -332, -332, -332,
			 -332, -332, -332, -332, -332, -332, -332, -332, -332, -332,
			 -332, -332, -332, -332, -332, -332, -332, -332, -332, -332,
			 -332, -332, -332, -332, -332, -332, -332, -332, -332, -332,
			 -332, -332, -332, -332, -332, -332, -332, -332, -332, -332,
			 -332, -332,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -332, -332, -332, -332, -332, -332, -332,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  399,  101,  101,  101,
			  101,  101,  101,  101,  101, -332, -332, -332, -332,  101,
			 -332,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  399,  101,
			  101,  101,  101,  101,  101,  101,  101, -332, -332, -332,
			 -332, -332, -332, -332, -332, -332, -332, -332, -332, -332,
			 -332, -332, -332, -332, -332, -332, -332, -332, -332, -332,
			 -332, -332, -332, -332, -332, -332, -332, -332, -332, -332,
			 -332, -332, -332, -332, -332, -332, -332, -332, -332, -332,
			 -332, -332, -332, -332, -332, -332, -332, -332, -332, -332,

			 -332, -332, -332, -332, -332, -332, -332, -332, -332, -332,
			 -332, -332, -332, -332, -332, -332, -332, -332, -332, -332,
			 -332, -332, -332, -332, -332, -332, -332, -332, -332, -332,
			 -332, -332, -332, -332, -332, -332, -332, -332, -332, -332,
			 -332, -332, -332, -332, -332, -332, -332, -332, -332, -332,
			 -332, -332, -332, -332, -332, -332, -332, -332, -332, -332,
			 -332, -332, -332, -332, -332, -332, -332, -332, -332, -332,
			 -332, -332, -332, -332, -332, -332, -332, -332, -332, -332,
			 -332,    5, -333, -333, -333, -333, -333, -333, -333, -333,
			 -333, -333, -333, -333, -333, -333, -333, -333, -333, -333,

			 -333, -333, -333, -333, -333, -333, -333, -333, -333, -333,
			 -333, -333, -333, -333, -333, -333, -333, -333, -333, -333,
			 -333, -333, -333, -333, -333, -333, -333, -333, -333,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -333,
			 -333, -333, -333, -333, -333, -333,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  400,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -333, -333, -333, -333,  101, -333,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  400,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101, -333, -333, -333, -333, -333, -333,
			 -333, -333, -333, -333, -333, -333, -333, -333, -333, -333,
			 -333, -333, -333, -333, -333, -333, -333, -333, -333, -333,
			 -333, -333, -333, -333, -333, -333, -333, -333, -333, -333,
			 -333, -333, -333, -333, -333, -333, -333, -333, -333, -333,
			 -333, -333, -333, -333, -333, -333, -333, -333, -333, -333,
			 -333, -333, -333, -333, -333, -333, -333, -333, -333, -333,
			 -333, -333, -333, -333, -333, -333, -333, -333, -333, -333,
			 -333, -333, -333, -333, -333, -333, -333, -333, -333, -333,
			 -333, -333, -333, -333, -333, -333, -333, -333, -333, -333,

			 -333, -333, -333, -333, -333, -333, -333, -333, -333, -333,
			 -333, -333, -333, -333, -333, -333, -333, -333, -333, -333,
			 -333, -333, -333, -333, -333, -333, -333, -333, -333, -333,
			 -333, -333, -333, -333, -333, -333, -333, -333,    5, -334,
			 -334, -334, -334, -334, -334, -334, -334, -334, -334, -334,
			 -334, -334, -334, -334, -334, -334, -334, -334, -334, -334,
			 -334, -334, -334, -334, -334, -334, -334, -334, -334, -334,
			 -334, -334, -334, -334, -334, -334, -334, -334, -334, -334,
			 -334, -334, -334, -334, -334, -334,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -334, -334, -334, -334,

			 -334, -334, -334,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  401,  101,  101,  101,  101,  101,  101,  101,  101, -334,
			 -334, -334, -334,  101, -334,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  401,  101,  101,  101,  101,  101,  101,  101,
			  101, -334, -334, -334, -334, -334, -334, -334, -334, -334,
			 -334, -334, -334, -334, -334, -334, -334, -334, -334, -334,
			 -334, -334, -334, -334, -334, -334, -334, -334, -334, -334,
			 -334, -334, -334, -334, -334, -334, -334, -334, -334, -334,

			 -334, -334, -334, -334, -334, -334, -334, -334, -334, -334,
			 -334, -334, -334, -334, -334, -334, -334, -334, -334, -334,
			 -334, -334, -334, -334, -334, -334, -334, -334, -334, -334,
			 -334, -334, -334, -334, -334, -334, -334, -334, -334, -334,
			 -334, -334, -334, -334, -334, -334, -334, -334, -334, -334,
			 -334, -334, -334, -334, -334, -334, -334, -334, -334, -334,
			 -334, -334, -334, -334, -334, -334, -334, -334, -334, -334,
			 -334, -334, -334, -334, -334, -334, -334, -334, -334, -334,
			 -334, -334, -334, -334, -334, -334, -334, -334, -334, -334,
			 -334, -334, -334, -334, -334,    5, -335, -335, -335, -335,

			 -335, -335, -335, -335, -335, -335, -335, -335, -335, -335,
			 -335, -335, -335, -335, -335, -335, -335, -335, -335, -335,
			 -335, -335, -335, -335, -335, -335, -335, -335, -335, -335,
			 -335, -335, -335, -335, -335, -335, -335, -335, -335, -335,
			 -335, -335, -335,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -335, -335, -335, -335, -335, -335, -335,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  402,  101,  101,
			  101,  101,  101,  101,  101,  101, -335, -335, -335, -335,
			  101, -335,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  402,
			  101,  101,  101,  101,  101,  101,  101,  101, -335, -335,
			 -335, -335, -335, -335, -335, -335, -335, -335, -335, -335,
			 -335, -335, -335, -335, -335, -335, -335, -335, -335, -335,
			 -335, -335, -335, -335, -335, -335, -335, -335, -335, -335,
			 -335, -335, -335, -335, -335, -335, -335, -335, -335, -335,
			 -335, -335, -335, -335, -335, -335, -335, -335, -335, -335,
			 -335, -335, -335, -335, -335, -335, -335, -335, -335, -335,
			 -335, -335, -335, -335, -335, -335, -335, -335, -335, -335,
			 -335, -335, -335, -335, -335, -335, -335, -335, -335, -335,

			 -335, -335, -335, -335, -335, -335, -335, -335, -335, -335,
			 -335, -335, -335, -335, -335, -335, -335, -335, -335, -335,
			 -335, -335, -335, -335, -335, -335, -335, -335, -335, -335,
			 -335, -335, -335, -335, -335, -335, -335, -335, -335, -335,
			 -335, -335, -335, -335, -335, -335, -335, -335, -335, -335,
			 -335, -335,    5, -336, -336, -336, -336, -336, -336, -336,
			 -336, -336, -336, -336, -336, -336, -336, -336, -336, -336,
			 -336, -336, -336, -336, -336, -336, -336, -336, -336, -336,
			 -336, -336, -336, -336, -336, -336, -336, -336, -336, -336,
			 -336, -336, -336, -336, -336, -336, -336, -336, -336, -336,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -336, -336, -336, -336, -336, -336, -336,  101,  101,  101,
			  101,  403,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -336, -336, -336, -336,  101, -336,  101,
			  101,  101,  101,  403,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -336, -336, -336, -336, -336,
			 -336, -336, -336, -336, -336, -336, -336, -336, -336, -336,
			 -336, -336, -336, -336, -336, -336, -336, -336, -336, -336,

			 -336, -336, -336, -336, -336, -336, -336, -336, -336, -336,
			 -336, -336, -336, -336, -336, -336, -336, -336, -336, -336,
			 -336, -336, -336, -336, -336, -336, -336, -336, -336, -336,
			 -336, -336, -336, -336, -336, -336, -336, -336, -336, -336,
			 -336, -336, -336, -336, -336, -336, -336, -336, -336, -336,
			 -336, -336, -336, -336, -336, -336, -336, -336, -336, -336,
			 -336, -336, -336, -336, -336, -336, -336, -336, -336, -336,
			 -336, -336, -336, -336, -336, -336, -336, -336, -336, -336,
			 -336, -336, -336, -336, -336, -336, -336, -336, -336, -336,
			 -336, -336, -336, -336, -336, -336, -336, -336, -336, -336,

			 -336, -336, -336, -336, -336, -336, -336, -336, -336,    5,
			 -337, -337, -337, -337, -337, -337, -337, -337, -337, -337,
			 -337, -337, -337, -337, -337, -337, -337, -337, -337, -337,
			 -337, -337, -337, -337, -337, -337, -337, -337, -337, -337,
			 -337, -337, -337, -337, -337, -337, -337, -337, -337, -337,
			 -337, -337, -337, -337, -337, -337, -337,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -337, -337, -337,
			 -337, -337, -337, -337,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  404,  101,  101,  101,  101,  101,

			 -337, -337, -337, -337,  101, -337,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  404,  101,  101,  101,
			  101,  101, -337, -337, -337, -337, -337, -337, -337, -337,
			 -337, -337, -337, -337, -337, -337, -337, -337, -337, -337,
			 -337, -337, -337, -337, -337, -337, -337, -337, -337, -337,
			 -337, -337, -337, -337, -337, -337, -337, -337, -337, -337,
			 -337, -337, -337, -337, -337, -337, -337, -337, -337, -337,
			 -337, -337, -337, -337, -337, -337, -337, -337, -337, -337,
			 -337, -337, -337, -337, -337, -337, -337, -337, -337, -337,

			 -337, -337, -337, -337, -337, -337, -337, -337, -337, -337,
			 -337, -337, -337, -337, -337, -337, -337, -337, -337, -337,
			 -337, -337, -337, -337, -337, -337, -337, -337, -337, -337,
			 -337, -337, -337, -337, -337, -337, -337, -337, -337, -337,
			 -337, -337, -337, -337, -337, -337, -337, -337, -337, -337,
			 -337, -337, -337, -337, -337, -337, -337, -337, -337, -337,
			 -337, -337, -337, -337, -337, -337,    5, -338, -338, -338,
			 -338, -338, -338, -338, -338, -338, -338, -338, -338, -338,
			 -338, -338, -338, -338, -338, -338, -338, -338, -338, -338,
			 -338, -338, -338, -338, -338, -338, -338, -338, -338, -338,

			 -338, -338, -338, -338, -338, -338, -338, -338, -338, -338,
			 -338, -338, -338, -338,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -338, -338, -338, -338, -338, -338,
			 -338,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -338, -338, -338,
			 -338,  101, -338,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -338,
			 -338, -338, -338, -338, -338, -338, -338, -338, -338, -338, yy_Dummy>>,
			1, 3000, 84000)
		end

	yy_nxt_template_30 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -338, -338, -338, -338, -338, -338, -338, -338, -338, -338,
			 -338, -338, -338, -338, -338, -338, -338, -338, -338, -338,
			 -338, -338, -338, -338, -338, -338, -338, -338, -338, -338,
			 -338, -338, -338, -338, -338, -338, -338, -338, -338, -338,
			 -338, -338, -338, -338, -338, -338, -338, -338, -338, -338,
			 -338, -338, -338, -338, -338, -338, -338, -338, -338, -338,
			 -338, -338, -338, -338, -338, -338, -338, -338, -338, -338,
			 -338, -338, -338, -338, -338, -338, -338, -338, -338, -338,
			 -338, -338, -338, -338, -338, -338, -338, -338, -338, -338,
			 -338, -338, -338, -338, -338, -338, -338, -338, -338, -338,

			 -338, -338, -338, -338, -338, -338, -338, -338, -338, -338,
			 -338, -338, -338, -338, -338, -338, -338, -338, -338, -338,
			 -338, -338, -338,    5, -339, -339, -339, -339, -339, -339,
			 -339, -339, -339, -339, -339, -339, -339, -339, -339, -339,
			 -339, -339, -339, -339, -339, -339, -339, -339, -339, -339,
			 -339, -339, -339, -339, -339, -339, -339, -339, -339, -339,
			 -339, -339, -339, -339, -339, -339, -339, -339, -339, -339,
			 -339,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -339, -339, -339, -339, -339, -339, -339,  101,  101,
			  101,  101,  405,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -339, -339, -339, -339,  101, -339,
			  101,  101,  101,  101,  405,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -339, -339, -339, -339,
			 -339, -339, -339, -339, -339, -339, -339, -339, -339, -339,
			 -339, -339, -339, -339, -339, -339, -339, -339, -339, -339,
			 -339, -339, -339, -339, -339, -339, -339, -339, -339, -339,
			 -339, -339, -339, -339, -339, -339, -339, -339, -339, -339,
			 -339, -339, -339, -339, -339, -339, -339, -339, -339, -339,

			 -339, -339, -339, -339, -339, -339, -339, -339, -339, -339,
			 -339, -339, -339, -339, -339, -339, -339, -339, -339, -339,
			 -339, -339, -339, -339, -339, -339, -339, -339, -339, -339,
			 -339, -339, -339, -339, -339, -339, -339, -339, -339, -339,
			 -339, -339, -339, -339, -339, -339, -339, -339, -339, -339,
			 -339, -339, -339, -339, -339, -339, -339, -339, -339, -339,
			 -339, -339, -339, -339, -339, -339, -339, -339, -339, -339,
			 -339, -339, -339, -339, -339, -339, -339, -339, -339, -339,
			    5, -340, -340, -340, -340, -340, -340, -340, -340, -340,
			 -340, -340, -340, -340, -340, -340, -340, -340, -340, -340,

			 -340, -340, -340, -340, -340, -340, -340, -340, -340, -340,
			 -340, -340, -340, -340, -340, -340, -340, -340, -340, -340,
			 -340, -340, -340, -340, -340, -340, -340, -340,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -340, -340,
			 -340, -340, -340, -340, -340,  101,  101,  101,  101,  101,
			  101,  101,  101,  406,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -340, -340, -340, -340,  101, -340,  101,  101,  101,
			  101,  101,  101,  101,  101,  406,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101, -340, -340, -340, -340, -340, -340, -340,
			 -340, -340, -340, -340, -340, -340, -340, -340, -340, -340,
			 -340, -340, -340, -340, -340, -340, -340, -340, -340, -340,
			 -340, -340, -340, -340, -340, -340, -340, -340, -340, -340,
			 -340, -340, -340, -340, -340, -340, -340, -340, -340, -340,
			 -340, -340, -340, -340, -340, -340, -340, -340, -340, -340,
			 -340, -340, -340, -340, -340, -340, -340, -340, -340, -340,
			 -340, -340, -340, -340, -340, -340, -340, -340, -340, -340,
			 -340, -340, -340, -340, -340, -340, -340, -340, -340, -340,
			 -340, -340, -340, -340, -340, -340, -340, -340, -340, -340,

			 -340, -340, -340, -340, -340, -340, -340, -340, -340, -340,
			 -340, -340, -340, -340, -340, -340, -340, -340, -340, -340,
			 -340, -340, -340, -340, -340, -340, -340, -340, -340, -340,
			 -340, -340, -340, -340, -340, -340, -340,    5, -341, -341,
			 -341, -341, -341, -341, -341, -341, -341, -341, -341, -341,
			 -341, -341, -341, -341, -341, -341, -341, -341, -341, -341,
			 -341, -341, -341, -341, -341, -341, -341, -341, -341, -341,
			 -341, -341, -341, -341, -341, -341, -341, -341, -341, -341,
			 -341, -341, -341, -341, -341,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -341, -341, -341, -341, -341,

			 -341, -341,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  407,  101,  101, -341, -341,
			 -341, -341,  101, -341,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  407,  101,  101,
			 -341, -341, -341, -341, -341, -341, -341, -341, -341, -341,
			 -341, -341, -341, -341, -341, -341, -341, -341, -341, -341,
			 -341, -341, -341, -341, -341, -341, -341, -341, -341, -341,
			 -341, -341, -341, -341, -341, -341, -341, -341, -341, -341,

			 -341, -341, -341, -341, -341, -341, -341, -341, -341, -341,
			 -341, -341, -341, -341, -341, -341, -341, -341, -341, -341,
			 -341, -341, -341, -341, -341, -341, -341, -341, -341, -341,
			 -341, -341, -341, -341, -341, -341, -341, -341, -341, -341,
			 -341, -341, -341, -341, -341, -341, -341, -341, -341, -341,
			 -341, -341, -341, -341, -341, -341, -341, -341, -341, -341,
			 -341, -341, -341, -341, -341, -341, -341, -341, -341, -341,
			 -341, -341, -341, -341, -341, -341, -341, -341, -341, -341,
			 -341, -341, -341, -341, -341, -341, -341, -341, -341, -341,
			 -341, -341, -341, -341,    5, -342, -342, -342, -342, -342,

			 -342, -342, -342, -342, -342, -342, -342, -342, -342, -342,
			 -342, -342, -342, -342, -342, -342, -342, -342, -342, -342,
			 -342, -342, -342, -342, -342, -342, -342, -342, -342, -342,
			 -342, -342, -342, -342, -342, -342, -342, -342, -342, -342,
			 -342, -342,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -342, -342, -342, -342, -342, -342, -342,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  408,  101,  101, -342, -342, -342, -342,  101,
			 -342,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  408,  101,  101, -342, -342, -342,
			 -342, -342, -342, -342, -342, -342, -342, -342, -342, -342,
			 -342, -342, -342, -342, -342, -342, -342, -342, -342, -342,
			 -342, -342, -342, -342, -342, -342, -342, -342, -342, -342,
			 -342, -342, -342, -342, -342, -342, -342, -342, -342, -342,
			 -342, -342, -342, -342, -342, -342, -342, -342, -342, -342,
			 -342, -342, -342, -342, -342, -342, -342, -342, -342, -342,
			 -342, -342, -342, -342, -342, -342, -342, -342, -342, -342,
			 -342, -342, -342, -342, -342, -342, -342, -342, -342, -342,

			 -342, -342, -342, -342, -342, -342, -342, -342, -342, -342,
			 -342, -342, -342, -342, -342, -342, -342, -342, -342, -342,
			 -342, -342, -342, -342, -342, -342, -342, -342, -342, -342,
			 -342, -342, -342, -342, -342, -342, -342, -342, -342, -342,
			 -342, -342, -342, -342, -342, -342, -342, -342, -342, -342,
			 -342,    5, -343, -343, -343, -343, -343, -343, -343, -343,
			 -343, -343, -343, -343, -343, -343, -343, -343, -343, -343,
			 -343, -343, -343, -343, -343, -343, -343, -343, -343, -343,
			 -343, -343, -343, -343, -343, -343, -343, -343, -343, -343,
			 -343, -343, -343, -343, -343, -343, -343, -343, -343,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101, -343,
			 -343, -343, -343, -343, -343, -343,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  409,  101,  101,  101,  101,  101,  101,
			  101,  101, -343, -343, -343, -343,  101, -343,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  409,  101,  101,  101,  101,
			  101,  101,  101,  101, -343, -343, -343, -343, -343, -343,
			 -343, -343, -343, -343, -343, -343, -343, -343, -343, -343,
			 -343, -343, -343, -343, -343, -343, -343, -343, -343, -343,

			 -343, -343, -343, -343, -343, -343, -343, -343, -343, -343,
			 -343, -343, -343, -343, -343, -343, -343, -343, -343, -343,
			 -343, -343, -343, -343, -343, -343, -343, -343, -343, -343,
			 -343, -343, -343, -343, -343, -343, -343, -343, -343, -343,
			 -343, -343, -343, -343, -343, -343, -343, -343, -343, -343,
			 -343, -343, -343, -343, -343, -343, -343, -343, -343, -343,
			 -343, -343, -343, -343, -343, -343, -343, -343, -343, -343,
			 -343, -343, -343, -343, -343, -343, -343, -343, -343, -343,
			 -343, -343, -343, -343, -343, -343, -343, -343, -343, -343,
			 -343, -343, -343, -343, -343, -343, -343, -343, -343, -343,

			 -343, -343, -343, -343, -343, -343, -343, -343,    5, -344,
			 -344, -344, -344, -344, -344, -344, -344, -344, -344, -344,
			 -344, -344, -344, -344, -344, -344, -344, -344, -344, -344,
			 -344, -344, -344, -344, -344, -344, -344, -344, -344, -344,
			 -344, -344, -344, -344, -344, -344, -344, -344, -344, -344,
			 -344, -344, -344, -344, -344, -344,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -344, -344, -344, -344,
			 -344, -344, -344,  101,  101,  101,  101,  410,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -344,

			 -344, -344, -344,  101, -344,  101,  101,  101,  101,  410,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -344, -344, -344, -344, -344, -344, -344, -344, -344,
			 -344, -344, -344, -344, -344, -344, -344, -344, -344, -344,
			 -344, -344, -344, -344, -344, -344, -344, -344, -344, -344,
			 -344, -344, -344, -344, -344, -344, -344, -344, -344, -344,
			 -344, -344, -344, -344, -344, -344, -344, -344, -344, -344,
			 -344, -344, -344, -344, -344, -344, -344, -344, -344, -344,
			 -344, -344, -344, -344, -344, -344, -344, -344, -344, -344,

			 -344, -344, -344, -344, -344, -344, -344, -344, -344, -344,
			 -344, -344, -344, -344, -344, -344, -344, -344, -344, -344,
			 -344, -344, -344, -344, -344, -344, -344, -344, -344, -344,
			 -344, -344, -344, -344, -344, -344, -344, -344, -344, -344,
			 -344, -344, -344, -344, -344, -344, -344, -344, -344, -344,
			 -344, -344, -344, -344, -344, -344, -344, -344, -344, -344,
			 -344, -344, -344, -344, -344,    5, -345, -345, -345, -345,
			 -345, -345, -345, -345, -345, -345, -345, -345, -345, -345,
			 -345, -345, -345, -345, -345, -345, -345, -345, -345, -345,
			 -345, -345, -345, -345, -345, -345, -345, -345, -345, -345,

			 -345, -345, -345, -345, -345, -345, -345, -345, -345, -345,
			 -345, -345, -345,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -345, -345, -345, -345, -345, -345, -345,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  411,  101,  101,
			  101,  101,  101,  101,  101,  101, -345, -345, -345, -345,
			  101, -345,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  411,
			  101,  101,  101,  101,  101,  101,  101,  101, -345, -345,
			 -345, -345, -345, -345, -345, -345, -345, -345, -345, -345,

			 -345, -345, -345, -345, -345, -345, -345, -345, -345, -345,
			 -345, -345, -345, -345, -345, -345, -345, -345, -345, -345,
			 -345, -345, -345, -345, -345, -345, -345, -345, -345, -345,
			 -345, -345, -345, -345, -345, -345, -345, -345, -345, -345,
			 -345, -345, -345, -345, -345, -345, -345, -345, -345, -345,
			 -345, -345, -345, -345, -345, -345, -345, -345, -345, -345,
			 -345, -345, -345, -345, -345, -345, -345, -345, -345, -345,
			 -345, -345, -345, -345, -345, -345, -345, -345, -345, -345,
			 -345, -345, -345, -345, -345, -345, -345, -345, -345, -345,
			 -345, -345, -345, -345, -345, -345, -345, -345, -345, -345,

			 -345, -345, -345, -345, -345, -345, -345, -345, -345, -345,
			 -345, -345, -345, -345, -345, -345, -345, -345, -345, -345,
			 -345, -345,    5, -346, -346, -346, -346, -346, -346, -346,
			 -346, -346, -346, -346, -346, -346, -346, -346, -346, -346,
			 -346, -346, -346, -346, -346, -346, -346, -346, -346, -346,
			 -346, -346, -346, -346, -346, -346, -346, -346, -346, -346,
			 -346, -346, -346, -346, -346, -346, -346, -346, -346, -346,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -346, -346, -346, -346, -346, -346, -346,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -346, -346, -346, -346,  101, -346,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -346, -346, -346, -346, -346,
			 -346, -346, -346, -346, -346, -346, -346, -346, -346, -346,
			 -346, -346, -346, -346, -346, -346, -346, -346, -346, -346,
			 -346, -346, -346, -346, -346, -346, -346, -346, -346, -346,
			 -346, -346, -346, -346, -346, -346, -346, -346, -346, -346,
			 -346, -346, -346, -346, -346, -346, -346, -346, -346, -346,

			 -346, -346, -346, -346, -346, -346, -346, -346, -346, -346,
			 -346, -346, -346, -346, -346, -346, -346, -346, -346, -346,
			 -346, -346, -346, -346, -346, -346, -346, -346, -346, -346,
			 -346, -346, -346, -346, -346, -346, -346, -346, -346, -346,
			 -346, -346, -346, -346, -346, -346, -346, -346, -346, -346,
			 -346, -346, -346, -346, -346, -346, -346, -346, -346, -346,
			 -346, -346, -346, -346, -346, -346, -346, -346, -346, -346,
			 -346, -346, -346, -346, -346, -346, -346, -346, -346,    5,
			 -347, -347, -347, -347, -347, -347, -347, -347, -347, -347,
			 -347, -347, -347, -347, -347, -347, -347, -347, -347, -347,

			 -347, -347, -347, -347, -347, -347, -347, -347, -347, -347,
			 -347, -347, -347, -347, -347, -347, -347, -347, -347, -347,
			 -347, -347, -347, -347, -347, -347, -347,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -347, -347, -347,
			 -347, -347, -347, -347,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  412,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -347, -347, -347, -347,  101, -347,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  412,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101, -347, -347, -347, -347, -347, -347, -347, -347,
			 -347, -347, -347, -347, -347, -347, -347, -347, -347, -347,
			 -347, -347, -347, -347, -347, -347, -347, -347, -347, -347,
			 -347, -347, -347, -347, -347, -347, -347, -347, -347, -347,
			 -347, -347, -347, -347, -347, -347, -347, -347, -347, -347,
			 -347, -347, -347, -347, -347, -347, -347, -347, -347, -347,
			 -347, -347, -347, -347, -347, -347, -347, -347, -347, -347,
			 -347, -347, -347, -347, -347, -347, -347, -347, -347, -347,
			 -347, -347, -347, -347, -347, -347, -347, -347, -347, -347,
			 -347, -347, -347, -347, -347, -347, -347, -347, -347, -347,

			 -347, -347, -347, -347, -347, -347, -347, -347, -347, -347,
			 -347, -347, -347, -347, -347, -347, -347, -347, -347, -347,
			 -347, -347, -347, -347, -347, -347, -347, -347, -347, -347,
			 -347, -347, -347, -347, -347, -347,    5, -348, -348, -348,
			 -348, -348, -348, -348, -348, -348, -348, -348, -348, -348,
			 -348, -348, -348, -348, -348, -348, -348, -348, -348, -348,
			 -348, -348, -348, -348, -348, -348, -348, -348, -348, -348,
			 -348, -348, -348, -348, -348, -348, -348, -348, -348, -348,
			 -348, -348, -348, -348,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -348, -348, -348, -348, -348, -348,

			 -348,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -348, -348, -348,
			 -348,  101, -348,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -348,
			 -348, -348, -348, -348, -348, -348, -348, -348, -348, -348,
			 -348, -348, -348, -348, -348, -348, -348, -348, -348, -348,
			 -348, -348, -348, -348, -348, -348, -348, -348, -348, -348,
			 -348, -348, -348, -348, -348, -348, -348, -348, -348, -348,

			 -348, -348, -348, -348, -348, -348, -348, -348, -348, -348,
			 -348, -348, -348, -348, -348, -348, -348, -348, -348, -348,
			 -348, -348, -348, -348, -348, -348, -348, -348, -348, -348,
			 -348, -348, -348, -348, -348, -348, -348, -348, -348, -348,
			 -348, -348, -348, -348, -348, -348, -348, -348, -348, -348,
			 -348, -348, -348, -348, -348, -348, -348, -348, -348, -348,
			 -348, -348, -348, -348, -348, -348, -348, -348, -348, -348,
			 -348, -348, -348, -348, -348, -348, -348, -348, -348, -348,
			 -348, -348, -348, -348, -348, -348, -348, -348, -348, -348,
			 -348, -348, -348,    5, -349, -349, -349, -349, -349, -349,

			 -349, -349, -349, -349, -349, -349, -349, -349, -349, -349,
			 -349, -349, -349, -349, -349, -349, -349, -349, -349, -349,
			 -349, -349, -349, -349, -349, -349, -349, -349, -349, -349,
			 -349, -349, -349, -349, -349, -349, -349, -349, -349, -349,
			 -349,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -349, -349, -349, -349, -349, -349, -349,  101,  101,
			  101,  101,  101,  413,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -349, -349, -349, -349,  101, -349,
			  101,  101,  101,  101,  101,  413,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -349, -349, -349, -349,
			 -349, -349, -349, -349, -349, -349, -349, -349, -349, -349,
			 -349, -349, -349, -349, -349, -349, -349, -349, -349, -349,
			 -349, -349, -349, -349, -349, -349, -349, -349, -349, -349,
			 -349, -349, -349, -349, -349, -349, -349, -349, -349, -349,
			 -349, -349, -349, -349, -349, -349, -349, -349, -349, -349,
			 -349, -349, -349, -349, -349, -349, -349, -349, -349, -349,
			 -349, -349, -349, -349, -349, -349, -349, -349, -349, -349,
			 -349, -349, -349, -349, -349, -349, -349, -349, -349, -349,

			 -349, -349, -349, -349, -349, -349, -349, -349, -349, -349,
			 -349, -349, -349, -349, -349, -349, -349, -349, -349, -349,
			 -349, -349, -349, -349, -349, -349, -349, -349, -349, -349,
			 -349, -349, -349, -349, -349, -349, -349, -349, -349, -349,
			 -349, -349, -349, -349, -349, -349, -349, -349, -349, -349,
			    5, -350, -350, -350, -350, -350, -350, -350, -350, -350,
			 -350, -350, -350, -350, -350, -350, -350, -350, -350, -350,
			 -350, -350, -350, -350, -350, -350, -350, -350, -350, -350,
			 -350, -350, -350, -350, -350, -350, -350, -350, -350, -350,
			 -350, -350, -350, -350, -350, -350, -350, -350,  101,  101, yy_Dummy>>,
			1, 3000, 87000)
		end

	yy_nxt_template_31 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  101,  101,  101,  101,  101,  101,  101,  101, -350, -350,
			 -350, -350, -350, -350, -350,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  414,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -350, -350, -350, -350,  101, -350,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  414,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -350, -350, -350, -350, -350, -350, -350,
			 -350, -350, -350, -350, -350, -350, -350, -350, -350, -350,
			 -350, -350, -350, -350, -350, -350, -350, -350, -350, -350,

			 -350, -350, -350, -350, -350, -350, -350, -350, -350, -350,
			 -350, -350, -350, -350, -350, -350, -350, -350, -350, -350,
			 -350, -350, -350, -350, -350, -350, -350, -350, -350, -350,
			 -350, -350, -350, -350, -350, -350, -350, -350, -350, -350,
			 -350, -350, -350, -350, -350, -350, -350, -350, -350, -350,
			 -350, -350, -350, -350, -350, -350, -350, -350, -350, -350,
			 -350, -350, -350, -350, -350, -350, -350, -350, -350, -350,
			 -350, -350, -350, -350, -350, -350, -350, -350, -350, -350,
			 -350, -350, -350, -350, -350, -350, -350, -350, -350, -350,
			 -350, -350, -350, -350, -350, -350, -350, -350, -350, -350,

			 -350, -350, -350, -350, -350, -350, -350,    5, -351, -351,
			 -351, -351, -351, -351, -351, -351, -351, -351, -351, -351,
			 -351, -351, -351, -351, -351, -351, -351, -351, -351, -351,
			 -351, -351, -351, -351, -351, -351, -351, -351, -351, -351,
			 -351, -351, -351, -351, -351, -351, -351, -351, -351, -351,
			 -351, -351, -351, -351, -351,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -351, -351, -351, -351, -351,
			 -351, -351,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -351, -351,

			 -351, -351,  101, -351,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -351, -351, -351, -351, -351, -351, -351, -351, -351, -351,
			 -351, -351, -351, -351, -351, -351, -351, -351, -351, -351,
			 -351, -351, -351, -351, -351, -351, -351, -351, -351, -351,
			 -351, -351, -351, -351, -351, -351, -351, -351, -351, -351,
			 -351, -351, -351, -351, -351, -351, -351, -351, -351, -351,
			 -351, -351, -351, -351, -351, -351, -351, -351, -351, -351,
			 -351, -351, -351, -351, -351, -351, -351, -351, -351, -351,

			 -351, -351, -351, -351, -351, -351, -351, -351, -351, -351,
			 -351, -351, -351, -351, -351, -351, -351, -351, -351, -351,
			 -351, -351, -351, -351, -351, -351, -351, -351, -351, -351,
			 -351, -351, -351, -351, -351, -351, -351, -351, -351, -351,
			 -351, -351, -351, -351, -351, -351, -351, -351, -351, -351,
			 -351, -351, -351, -351, -351, -351, -351, -351, -351, -351,
			 -351, -351, -351, -351,    5, -352, -352, -352, -352, -352,
			 -352, -352, -352, -352, -352, -352, -352, -352, -352, -352,
			 -352, -352, -352, -352, -352, -352, -352, -352, -352, -352,
			 -352, -352, -352, -352, -352, -352, -352, -352, -352, -352,

			 -352, -352, -352, -352, -352, -352, -352, -352, -352, -352,
			 -352, -352,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -352, -352, -352, -352, -352, -352, -352,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  415,
			  101,  101,  101,  101,  101, -352, -352, -352, -352,  101,
			 -352,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  415,  101,  101,  101,  101,  101, -352, -352, -352,
			 -352, -352, -352, -352, -352, -352, -352, -352, -352, -352,

			 -352, -352, -352, -352, -352, -352, -352, -352, -352, -352,
			 -352, -352, -352, -352, -352, -352, -352, -352, -352, -352,
			 -352, -352, -352, -352, -352, -352, -352, -352, -352, -352,
			 -352, -352, -352, -352, -352, -352, -352, -352, -352, -352,
			 -352, -352, -352, -352, -352, -352, -352, -352, -352, -352,
			 -352, -352, -352, -352, -352, -352, -352, -352, -352, -352,
			 -352, -352, -352, -352, -352, -352, -352, -352, -352, -352,
			 -352, -352, -352, -352, -352, -352, -352, -352, -352, -352,
			 -352, -352, -352, -352, -352, -352, -352, -352, -352, -352,
			 -352, -352, -352, -352, -352, -352, -352, -352, -352, -352,

			 -352, -352, -352, -352, -352, -352, -352, -352, -352, -352,
			 -352, -352, -352, -352, -352, -352, -352, -352, -352, -352,
			 -352,    5, -353, -353, -353, -353, -353, -353, -353, -353,
			 -353, -353, -353, -353, -353, -353, -353, -353, -353, -353,
			 -353, -353, -353, -353, -353, -353, -353, -353, -353, -353,
			 -353, -353, -353, -353, -353, -353, -353, -353, -353, -353,
			 -353, -353, -353, -353, -353, -353, -353, -353, -353,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -353,
			 -353, -353, -353, -353, -353, -353,  101,  101,  101,  101,
			  101,  101,  101,  101,  416,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -353, -353, -353, -353,  101, -353,  101,  101,
			  101,  101,  101,  101,  101,  101,  416,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -353, -353, -353, -353, -353, -353,
			 -353, -353, -353, -353, -353, -353, -353, -353, -353, -353,
			 -353, -353, -353, -353, -353, -353, -353, -353, -353, -353,
			 -353, -353, -353, -353, -353, -353, -353, -353, -353, -353,
			 -353, -353, -353, -353, -353, -353, -353, -353, -353, -353,
			 -353, -353, -353, -353, -353, -353, -353, -353, -353, -353,

			 -353, -353, -353, -353, -353, -353, -353, -353, -353, -353,
			 -353, -353, -353, -353, -353, -353, -353, -353, -353, -353,
			 -353, -353, -353, -353, -353, -353, -353, -353, -353, -353,
			 -353, -353, -353, -353, -353, -353, -353, -353, -353, -353,
			 -353, -353, -353, -353, -353, -353, -353, -353, -353, -353,
			 -353, -353, -353, -353, -353, -353, -353, -353, -353, -353,
			 -353, -353, -353, -353, -353, -353, -353, -353, -353, -353,
			 -353, -353, -353, -353, -353, -353, -353, -353,    5, -354,
			 -354, -354, -354, -354, -354, -354, -354, -354, -354, -354,
			 -354, -354, -354, -354, -354, -354, -354, -354, -354, -354,

			 -354, -354, -354, -354, -354, -354, -354, -354, -354, -354,
			 -354, -354, -354, -354, -354, -354, -354, -354, -354, -354,
			 -354, -354, -354, -354, -354, -354,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -354, -354, -354, -354,
			 -354, -354, -354,  101,  101,  101,  101,  101,  417,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -354,
			 -354, -354, -354,  101, -354,  101,  101,  101,  101,  101,
			  417,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101, -354, -354, -354, -354, -354, -354, -354, -354, -354,
			 -354, -354, -354, -354, -354, -354, -354, -354, -354, -354,
			 -354, -354, -354, -354, -354, -354, -354, -354, -354, -354,
			 -354, -354, -354, -354, -354, -354, -354, -354, -354, -354,
			 -354, -354, -354, -354, -354, -354, -354, -354, -354, -354,
			 -354, -354, -354, -354, -354, -354, -354, -354, -354, -354,
			 -354, -354, -354, -354, -354, -354, -354, -354, -354, -354,
			 -354, -354, -354, -354, -354, -354, -354, -354, -354, -354,
			 -354, -354, -354, -354, -354, -354, -354, -354, -354, -354,
			 -354, -354, -354, -354, -354, -354, -354, -354, -354, -354,

			 -354, -354, -354, -354, -354, -354, -354, -354, -354, -354,
			 -354, -354, -354, -354, -354, -354, -354, -354, -354, -354,
			 -354, -354, -354, -354, -354, -354, -354, -354, -354, -354,
			 -354, -354, -354, -354, -354,    5, -355, -355, -355, -355,
			 -355, -355, -355, -355, -355, -355, -355, -355, -355, -355,
			 -355, -355, -355, -355, -355, -355, -355, -355, -355, -355,
			 -355, -355, -355, -355, -355, -355, -355, -355, -355, -355,
			 -355, -355, -355, -355, -355, -355, -355, -355, -355, -355,
			 -355, -355, -355,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -355, -355, -355, -355, -355, -355, -355,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  418,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -355, -355, -355, -355,
			  101, -355,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  418,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -355, -355,
			 -355, -355, -355, -355, -355, -355, -355, -355, -355, -355,
			 -355, -355, -355, -355, -355, -355, -355, -355, -355, -355,
			 -355, -355, -355, -355, -355, -355, -355, -355, -355, -355,
			 -355, -355, -355, -355, -355, -355, -355, -355, -355, -355,

			 -355, -355, -355, -355, -355, -355, -355, -355, -355, -355,
			 -355, -355, -355, -355, -355, -355, -355, -355, -355, -355,
			 -355, -355, -355, -355, -355, -355, -355, -355, -355, -355,
			 -355, -355, -355, -355, -355, -355, -355, -355, -355, -355,
			 -355, -355, -355, -355, -355, -355, -355, -355, -355, -355,
			 -355, -355, -355, -355, -355, -355, -355, -355, -355, -355,
			 -355, -355, -355, -355, -355, -355, -355, -355, -355, -355,
			 -355, -355, -355, -355, -355, -355, -355, -355, -355, -355,
			 -355, -355, -355, -355, -355, -355, -355, -355, -355, -355,
			 -355, -355,    5, -356, -356, -356, -356, -356, -356, -356,

			 -356, -356, -356, -356, -356, -356, -356, -356, -356, -356,
			 -356, -356, -356, -356, -356, -356, -356, -356, -356, -356,
			 -356, -356, -356, -356, -356, -356, -356, -356, -356, -356,
			 -356, -356, -356, -356, -356, -356, -356, -356, -356, -356,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -356, -356, -356, -356, -356, -356, -356,  101,  101,  101,
			  101,  101,  101,  101,  101,  419,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -356, -356, -356, -356,  101, -356,  101,
			  101,  101,  101,  101,  101,  101,  101,  419,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -356, -356, -356, -356, -356,
			 -356, -356, -356, -356, -356, -356, -356, -356, -356, -356,
			 -356, -356, -356, -356, -356, -356, -356, -356, -356, -356,
			 -356, -356, -356, -356, -356, -356, -356, -356, -356, -356,
			 -356, -356, -356, -356, -356, -356, -356, -356, -356, -356,
			 -356, -356, -356, -356, -356, -356, -356, -356, -356, -356,
			 -356, -356, -356, -356, -356, -356, -356, -356, -356, -356,
			 -356, -356, -356, -356, -356, -356, -356, -356, -356, -356,
			 -356, -356, -356, -356, -356, -356, -356, -356, -356, -356,

			 -356, -356, -356, -356, -356, -356, -356, -356, -356, -356,
			 -356, -356, -356, -356, -356, -356, -356, -356, -356, -356,
			 -356, -356, -356, -356, -356, -356, -356, -356, -356, -356,
			 -356, -356, -356, -356, -356, -356, -356, -356, -356, -356,
			 -356, -356, -356, -356, -356, -356, -356, -356, -356,    5,
			 -357, -357, -357, -357, -357, -357, -357, -357, -357, -357,
			 -357, -357, -357, -357, -357, -357, -357, -357, -357, -357,
			 -357, -357, -357, -357, -357, -357, -357, -357, -357, -357,
			 -357, -357, -357, -357, -357, -357, -357, -357, -357, -357,
			 -357, -357, -357, -357, -357, -357, -357,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101, -357, -357, -357,
			 -357, -357, -357, -357,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  420,  101,  101,  101,  101,  101,
			 -357, -357, -357, -357,  101, -357,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  420,  101,  101,  101,
			  101,  101, -357, -357, -357, -357, -357, -357, -357, -357,
			 -357, -357, -357, -357, -357, -357, -357, -357, -357, -357,
			 -357, -357, -357, -357, -357, -357, -357, -357, -357, -357,

			 -357, -357, -357, -357, -357, -357, -357, -357, -357, -357,
			 -357, -357, -357, -357, -357, -357, -357, -357, -357, -357,
			 -357, -357, -357, -357, -357, -357, -357, -357, -357, -357,
			 -357, -357, -357, -357, -357, -357, -357, -357, -357, -357,
			 -357, -357, -357, -357, -357, -357, -357, -357, -357, -357,
			 -357, -357, -357, -357, -357, -357, -357, -357, -357, -357,
			 -357, -357, -357, -357, -357, -357, -357, -357, -357, -357,
			 -357, -357, -357, -357, -357, -357, -357, -357, -357, -357,
			 -357, -357, -357, -357, -357, -357, -357, -357, -357, -357,
			 -357, -357, -357, -357, -357, -357, -357, -357, -357, -357,

			 -357, -357, -357, -357, -357, -357,    5, -358, -358, -358,
			 -358, -358, -358, -358, -358, -358, -358, -358, -358, -358,
			 -358, -358, -358, -358, -358, -358, -358, -358, -358, -358,
			 -358, -358, -358, -358, -358, -358, -358, -358, -358, -358,
			 -358, -358, -358, -358, -358, -358, -358, -358, -358, -358,
			 -358, -358, -358, -358,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -358, -358, -358, -358, -358, -358,
			 -358,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  421,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -358, -358, -358,

			 -358,  101, -358,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  421,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -358,
			 -358, -358, -358, -358, -358, -358, -358, -358, -358, -358,
			 -358, -358, -358, -358, -358, -358, -358, -358, -358, -358,
			 -358, -358, -358, -358, -358, -358, -358, -358, -358, -358,
			 -358, -358, -358, -358, -358, -358, -358, -358, -358, -358,
			 -358, -358, -358, -358, -358, -358, -358, -358, -358, -358,
			 -358, -358, -358, -358, -358, -358, -358, -358, -358, -358,
			 -358, -358, -358, -358, -358, -358, -358, -358, -358, -358,

			 -358, -358, -358, -358, -358, -358, -358, -358, -358, -358,
			 -358, -358, -358, -358, -358, -358, -358, -358, -358, -358,
			 -358, -358, -358, -358, -358, -358, -358, -358, -358, -358,
			 -358, -358, -358, -358, -358, -358, -358, -358, -358, -358,
			 -358, -358, -358, -358, -358, -358, -358, -358, -358, -358,
			 -358, -358, -358, -358, -358, -358, -358, -358, -358, -358,
			 -358, -358, -358,    5, -359, -359, -359, -359, -359, -359,
			 -359, -359, -359, -359, -359, -359, -359, -359, -359, -359,
			 -359, -359, -359, -359, -359, -359, -359, -359, -359, -359,
			 -359, -359, -359, -359, -359, -359, -359, -359, -359, -359,

			 -359, -359, -359, -359, -359, -359, -359, -359, -359, -359,
			 -359,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -359, -359, -359, -359, -359, -359, -359,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  422,  101, -359, -359, -359, -359,  101, -359,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  422,  101, -359, -359, -359, -359,
			 -359, -359, -359, -359, -359, -359, -359, -359, -359, -359,

			 -359, -359, -359, -359, -359, -359, -359, -359, -359, -359,
			 -359, -359, -359, -359, -359, -359, -359, -359, -359, -359,
			 -359, -359, -359, -359, -359, -359, -359, -359, -359, -359,
			 -359, -359, -359, -359, -359, -359, -359, -359, -359, -359,
			 -359, -359, -359, -359, -359, -359, -359, -359, -359, -359,
			 -359, -359, -359, -359, -359, -359, -359, -359, -359, -359,
			 -359, -359, -359, -359, -359, -359, -359, -359, -359, -359,
			 -359, -359, -359, -359, -359, -359, -359, -359, -359, -359,
			 -359, -359, -359, -359, -359, -359, -359, -359, -359, -359,
			 -359, -359, -359, -359, -359, -359, -359, -359, -359, -359,

			 -359, -359, -359, -359, -359, -359, -359, -359, -359, -359,
			 -359, -359, -359, -359, -359, -359, -359, -359, -359, -359,
			    5, -360, -360, -360, -360, -360, -360, -360, -360, -360,
			 -360, -360, -360, -360, -360, -360, -360, -360, -360, -360,
			 -360, -360, -360, -360, -360, -360, -360, -360, -360, -360,
			 -360, -360, -360, -360, -360, -360, -360, -360, -360, -360,
			 -360, -360, -360, -360, -360, -360, -360, -360,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -360, -360,
			 -360, -360, -360, -360, -360,  101,  101,  423,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -360, -360, -360, -360,  101, -360,  101,  101,  423,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -360, -360, -360, -360, -360, -360, -360,
			 -360, -360, -360, -360, -360, -360, -360, -360, -360, -360,
			 -360, -360, -360, -360, -360, -360, -360, -360, -360, -360,
			 -360, -360, -360, -360, -360, -360, -360, -360, -360, -360,
			 -360, -360, -360, -360, -360, -360, -360, -360, -360, -360,
			 -360, -360, -360, -360, -360, -360, -360, -360, -360, -360,

			 -360, -360, -360, -360, -360, -360, -360, -360, -360, -360,
			 -360, -360, -360, -360, -360, -360, -360, -360, -360, -360,
			 -360, -360, -360, -360, -360, -360, -360, -360, -360, -360,
			 -360, -360, -360, -360, -360, -360, -360, -360, -360, -360,
			 -360, -360, -360, -360, -360, -360, -360, -360, -360, -360,
			 -360, -360, -360, -360, -360, -360, -360, -360, -360, -360,
			 -360, -360, -360, -360, -360, -360, -360, -360, -360, -360,
			 -360, -360, -360, -360, -360, -360, -360,    5, -361, -361,
			 -361, -361, -361, -361, -361, -361, -361, -361, -361, -361,
			 -361, -361, -361, -361, -361, -361, -361, -361, -361, -361,

			 -361, -361, -361, -361, -361, -361, -361, -361, -361, -361,
			 -361, -361, -361, -361, -361, -361, -361, -361, -361, -361,
			 -361, -361, -361, -361, -361,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -361, -361, -361, -361, -361,
			 -361, -361,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  424,
			  101,  101,  101,  101,  101,  101,  101,  101, -361, -361,
			 -361, -361,  101, -361,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  424,  101,  101,  101,  101,  101,  101,  101,  101,

			 -361, -361, -361, -361, -361, -361, -361, -361, -361, -361,
			 -361, -361, -361, -361, -361, -361, -361, -361, -361, -361,
			 -361, -361, -361, -361, -361, -361, -361, -361, -361, -361,
			 -361, -361, -361, -361, -361, -361, -361, -361, -361, -361,
			 -361, -361, -361, -361, -361, -361, -361, -361, -361, -361,
			 -361, -361, -361, -361, -361, -361, -361, -361, -361, -361,
			 -361, -361, -361, -361, -361, -361, -361, -361, -361, -361,
			 -361, -361, -361, -361, -361, -361, -361, -361, -361, -361,
			 -361, -361, -361, -361, -361, -361, -361, -361, -361, -361,
			 -361, -361, -361, -361, -361, -361, -361, -361, -361, -361, yy_Dummy>>,
			1, 3000, 90000)
		end

	yy_nxt_template_32 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -361, -361, -361, -361, -361, -361, -361, -361, -361, -361,
			 -361, -361, -361, -361, -361, -361, -361, -361, -361, -361,
			 -361, -361, -361, -361, -361, -361, -361, -361, -361, -361,
			 -361, -361, -361, -361,    5, -362, -362, -362, -362, -362,
			 -362, -362, -362, -362, -362, -362, -362, -362, -362, -362,
			 -362, -362, -362, -362, -362, -362, -362, -362, -362, -362,
			 -362, -362, -362, -362, -362, -362, -362, -362, -362, -362,
			 -362, -362, -362, -362, -362, -362, -362, -362, -362, -362,
			 -362, -362,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -362, -362, -362, -362, -362, -362, -362,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  425,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -362, -362, -362, -362,  101,
			 -362,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  425,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -362, -362, -362,
			 -362, -362, -362, -362, -362, -362, -362, -362, -362, -362,
			 -362, -362, -362, -362, -362, -362, -362, -362, -362, -362,
			 -362, -362, -362, -362, -362, -362, -362, -362, -362, -362,
			 -362, -362, -362, -362, -362, -362, -362, -362, -362, -362,

			 -362, -362, -362, -362, -362, -362, -362, -362, -362, -362,
			 -362, -362, -362, -362, -362, -362, -362, -362, -362, -362,
			 -362, -362, -362, -362, -362, -362, -362, -362, -362, -362,
			 -362, -362, -362, -362, -362, -362, -362, -362, -362, -362,
			 -362, -362, -362, -362, -362, -362, -362, -362, -362, -362,
			 -362, -362, -362, -362, -362, -362, -362, -362, -362, -362,
			 -362, -362, -362, -362, -362, -362, -362, -362, -362, -362,
			 -362, -362, -362, -362, -362, -362, -362, -362, -362, -362,
			 -362, -362, -362, -362, -362, -362, -362, -362, -362, -362,
			 -362,    5, -363, -363, -363, -363, -363, -363, -363, -363,

			 -363, -363, -363, -363, -363, -363, -363, -363, -363, -363,
			 -363, -363, -363, -363, -363, -363, -363, -363, -363, -363,
			 -363, -363, -363, -363, -363, -363, -363, -363, -363, -363,
			 -363, -363, -363, -363, -363, -363, -363, -363, -363,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -363,
			 -363, -363, -363, -363, -363, -363,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -363, -363, -363, -363,  101, -363,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -363, -363, -363, -363, -363, -363,
			 -363, -363, -363, -363, -363, -363, -363, -363, -363, -363,
			 -363, -363, -363, -363, -363, -363, -363, -363, -363, -363,
			 -363, -363, -363, -363, -363, -363, -363, -363, -363, -363,
			 -363, -363, -363, -363, -363, -363, -363, -363, -363, -363,
			 -363, -363, -363, -363, -363, -363, -363, -363, -363, -363,
			 -363, -363, -363, -363, -363, -363, -363, -363, -363, -363,
			 -363, -363, -363, -363, -363, -363, -363, -363, -363, -363,
			 -363, -363, -363, -363, -363, -363, -363, -363, -363, -363,

			 -363, -363, -363, -363, -363, -363, -363, -363, -363, -363,
			 -363, -363, -363, -363, -363, -363, -363, -363, -363, -363,
			 -363, -363, -363, -363, -363, -363, -363, -363, -363, -363,
			 -363, -363, -363, -363, -363, -363, -363, -363, -363, -363,
			 -363, -363, -363, -363, -363, -363, -363, -363,    5, -364,
			 -364, -364, -364, -364, -364, -364, -364, -364, -364, -364,
			 -364, -364, -364, -364, -364, -364, -364, -364, -364, -364,
			 -364, -364, -364, -364, -364, -364, -364, -364, -364, -364,
			 -364, -364, -364, -364, -364, -364, -364, -364, -364, -364,
			 -364, -364, -364, -364, -364, -364,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101, -364, -364, -364, -364,
			 -364, -364, -364,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -364,
			 -364, -364, -364,  101, -364,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -364, -364, -364, -364, -364, -364, -364, -364, -364,
			 -364, -364, -364, -364, -364, -364, -364, -364, -364, -364,
			 -364, -364, -364, -364, -364, -364, -364, -364, -364, -364,

			 -364, -364, -364, -364, -364, -364, -364, -364, -364, -364,
			 -364, -364, -364, -364, -364, -364, -364, -364, -364, -364,
			 -364, -364, -364, -364, -364, -364, -364, -364, -364, -364,
			 -364, -364, -364, -364, -364, -364, -364, -364, -364, -364,
			 -364, -364, -364, -364, -364, -364, -364, -364, -364, -364,
			 -364, -364, -364, -364, -364, -364, -364, -364, -364, -364,
			 -364, -364, -364, -364, -364, -364, -364, -364, -364, -364,
			 -364, -364, -364, -364, -364, -364, -364, -364, -364, -364,
			 -364, -364, -364, -364, -364, -364, -364, -364, -364, -364,
			 -364, -364, -364, -364, -364, -364, -364, -364, -364, -364,

			 -364, -364, -364, -364, -364,    5, -365, -365, -365, -365,
			 -365, -365, -365, -365, -365, -365, -365, -365, -365, -365,
			 -365, -365, -365, -365, -365, -365, -365, -365, -365, -365,
			 -365, -365, -365, -365, -365, -365, -365, -365, -365, -365,
			 -365, -365, -365, -365, -365, -365, -365, -365, -365, -365,
			 -365, -365, -365,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -365, -365, -365, -365, -365, -365, -365,
			  101,  101,  101,  101,  101,  426,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -365, -365, -365, -365,

			  101, -365,  101,  101,  101,  101,  101,  426,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -365, -365,
			 -365, -365, -365, -365, -365, -365, -365, -365, -365, -365,
			 -365, -365, -365, -365, -365, -365, -365, -365, -365, -365,
			 -365, -365, -365, -365, -365, -365, -365, -365, -365, -365,
			 -365, -365, -365, -365, -365, -365, -365, -365, -365, -365,
			 -365, -365, -365, -365, -365, -365, -365, -365, -365, -365,
			 -365, -365, -365, -365, -365, -365, -365, -365, -365, -365,
			 -365, -365, -365, -365, -365, -365, -365, -365, -365, -365,

			 -365, -365, -365, -365, -365, -365, -365, -365, -365, -365,
			 -365, -365, -365, -365, -365, -365, -365, -365, -365, -365,
			 -365, -365, -365, -365, -365, -365, -365, -365, -365, -365,
			 -365, -365, -365, -365, -365, -365, -365, -365, -365, -365,
			 -365, -365, -365, -365, -365, -365, -365, -365, -365, -365,
			 -365, -365, -365, -365, -365, -365, -365, -365, -365, -365,
			 -365, -365,    5, -366, -366, -366, -366, -366, -366, -366,
			 -366, -366, -366, -366, -366, -366, -366, -366, -366, -366,
			 -366, -366, -366, -366, -366, -366, -366, -366, -366, -366,
			 -366, -366, -366, -366, -366, -366, -366, -366, -366, -366,

			 -366, -366, -366, -366, -366, -366, -366, -366, -366, -366,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -366, -366, -366, -366, -366, -366, -366,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  427,  101,  101,
			  101,  101,  101, -366, -366, -366, -366,  101, -366,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  427,
			  101,  101,  101,  101,  101, -366, -366, -366, -366, -366,
			 -366, -366, -366, -366, -366, -366, -366, -366, -366, -366,

			 -366, -366, -366, -366, -366, -366, -366, -366, -366, -366,
			 -366, -366, -366, -366, -366, -366, -366, -366, -366, -366,
			 -366, -366, -366, -366, -366, -366, -366, -366, -366, -366,
			 -366, -366, -366, -366, -366, -366, -366, -366, -366, -366,
			 -366, -366, -366, -366, -366, -366, -366, -366, -366, -366,
			 -366, -366, -366, -366, -366, -366, -366, -366, -366, -366,
			 -366, -366, -366, -366, -366, -366, -366, -366, -366, -366,
			 -366, -366, -366, -366, -366, -366, -366, -366, -366, -366,
			 -366, -366, -366, -366, -366, -366, -366, -366, -366, -366,
			 -366, -366, -366, -366, -366, -366, -366, -366, -366, -366,

			 -366, -366, -366, -366, -366, -366, -366, -366, -366, -366,
			 -366, -366, -366, -366, -366, -366, -366, -366, -366,    5,
			 -367, -367, -367, -367, -367, -367, -367, -367, -367, -367,
			 -367, -367, -367, -367, -367, -367, -367, -367, -367, -367,
			 -367, -367, -367, -367, -367, -367, -367, -367, -367, -367,
			 -367, -367, -367, -367, -367, -367, -367, -367, -367, -367,
			 -367, -367, -367, -367, -367, -367, -367,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -367, -367, -367,
			 -367, -367, -367, -367,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  428,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -367, -367, -367, -367,  101, -367,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  428,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -367, -367, -367, -367, -367, -367, -367, -367,
			 -367, -367, -367, -367, -367, -367, -367, -367, -367, -367,
			 -367, -367, -367, -367, -367, -367, -367, -367, -367, -367,
			 -367, -367, -367, -367, -367, -367, -367, -367, -367, -367,
			 -367, -367, -367, -367, -367, -367, -367, -367, -367, -367,
			 -367, -367, -367, -367, -367, -367, -367, -367, -367, -367,

			 -367, -367, -367, -367, -367, -367, -367, -367, -367, -367,
			 -367, -367, -367, -367, -367, -367, -367, -367, -367, -367,
			 -367, -367, -367, -367, -367, -367, -367, -367, -367, -367,
			 -367, -367, -367, -367, -367, -367, -367, -367, -367, -367,
			 -367, -367, -367, -367, -367, -367, -367, -367, -367, -367,
			 -367, -367, -367, -367, -367, -367, -367, -367, -367, -367,
			 -367, -367, -367, -367, -367, -367, -367, -367, -367, -367,
			 -367, -367, -367, -367, -367, -367,    5, -368, -368, -368,
			 -368, -368, -368, -368, -368, -368, -368, -368, -368, -368,
			 -368, -368, -368, -368, -368, -368, -368, -368, -368, -368,

			 -368, -368, -368, -368, -368, -368, -368, -368, -368, -368,
			 -368, -368, -368, -368, -368, -368, -368, -368, -368, -368,
			 -368, -368, -368, -368,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -368, -368, -368, -368, -368, -368,
			 -368,  429,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -368, -368, -368,
			 -368,  101, -368,  429,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -368,

			 -368, -368, -368, -368, -368, -368, -368, -368, -368, -368,
			 -368, -368, -368, -368, -368, -368, -368, -368, -368, -368,
			 -368, -368, -368, -368, -368, -368, -368, -368, -368, -368,
			 -368, -368, -368, -368, -368, -368, -368, -368, -368, -368,
			 -368, -368, -368, -368, -368, -368, -368, -368, -368, -368,
			 -368, -368, -368, -368, -368, -368, -368, -368, -368, -368,
			 -368, -368, -368, -368, -368, -368, -368, -368, -368, -368,
			 -368, -368, -368, -368, -368, -368, -368, -368, -368, -368,
			 -368, -368, -368, -368, -368, -368, -368, -368, -368, -368,
			 -368, -368, -368, -368, -368, -368, -368, -368, -368, -368,

			 -368, -368, -368, -368, -368, -368, -368, -368, -368, -368,
			 -368, -368, -368, -368, -368, -368, -368, -368, -368, -368,
			 -368, -368, -368, -368, -368, -368, -368, -368, -368, -368,
			 -368, -368, -368,    5, -369, -369, -369, -369, -369, -369,
			 -369, -369, -369, -369, -369, -369, -369, -369, -369, -369,
			 -369, -369, -369, -369, -369, -369, -369, -369, -369, -369,
			 -369, -369, -369, -369, -369, -369, -369, -369, -369, -369,
			 -369, -369, -369, -369, -369, -369, -369, -369, -369, -369,
			 -369,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -369, -369, -369, -369, -369, -369, -369,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -369, -369, -369, -369,  101, -369,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -369, -369, -369, -369,
			 -369, -369, -369, -369, -369, -369, -369, -369, -369, -369,
			 -369, -369, -369, -369, -369, -369, -369, -369, -369, -369,
			 -369, -369, -369, -369, -369, -369, -369, -369, -369, -369,
			 -369, -369, -369, -369, -369, -369, -369, -369, -369, -369,

			 -369, -369, -369, -369, -369, -369, -369, -369, -369, -369,
			 -369, -369, -369, -369, -369, -369, -369, -369, -369, -369,
			 -369, -369, -369, -369, -369, -369, -369, -369, -369, -369,
			 -369, -369, -369, -369, -369, -369, -369, -369, -369, -369,
			 -369, -369, -369, -369, -369, -369, -369, -369, -369, -369,
			 -369, -369, -369, -369, -369, -369, -369, -369, -369, -369,
			 -369, -369, -369, -369, -369, -369, -369, -369, -369, -369,
			 -369, -369, -369, -369, -369, -369, -369, -369, -369, -369,
			 -369, -369, -369, -369, -369, -369, -369, -369, -369, -369,
			    5, -370, -370, -370, -370, -370, -370, -370, -370, -370,

			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,

			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,

			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370, -370, -370, -370,
			 -370, -370, -370, -370, -370, -370, -370,    5,   64,   64,
			   64,   64,   64,   64,   64,   64,   64, -371,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   65,   64,   64, -371,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,  430,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,  430,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,    5, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,

			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,

			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372, -372, -372, -372, -372, -372, -372, -372, -372, -372,
			 -372,    5,   64,   64,   64,   64,   64,   64,   64,   64,
			   64, -373,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   65,   64,   64, -373,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,  431,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,  431,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64, yy_Dummy>>,
			1, 3000, 93000)
		end

	yy_nxt_template_33 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,    5, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,

			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,

			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374, -374, -374, -374, -374, -374,
			 -374, -374, -374, -374, -374,    5,   64,   64,   64,   64,
			   64,   64,   64,   64,   64, -375,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   65,
			   64,   64, -375,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,  432,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,  432,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,    5, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,

			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,

			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376, -376,
			 -376, -376, -376, -376, -376, -376, -376, -376, -376,    5,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,

			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377,  433, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,

			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,

			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377, -377, -377, -377, -377,
			 -377, -377, -377, -377, -377, -377,    5, -378, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,
			 -378, -378, -378, -378,  378,  378,  378,  378,  378,  378,

			  378,  378,  378,  378, -378, -378, -378, -378, -378, -378,
			 -378, -378, -378, -378, -378,  434, -378, -378, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378,  434, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,

			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,
			 -378, -378, -378, -378, -378, -378, -378, -378, -378, -378,

			 -378, -378, -378,    5, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379,  435,  435,  435,  435,  435,  435,  435,  435,  435,
			  435, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379,  380, -379,

			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,

			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			 -379, -379, -379, -379, -379, -379, -379, -379, -379, -379,
			    5, -380, -380, -380, -380, -380, -380, -380, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,

			 -380, -380, -380, -380, -380, -380, -380, -380,  436,  436,
			  436,  436,  436,  436,  436,  436,  436,  436, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,

			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,

			 -380, -380, -380, -380, -380, -380, -380, -380, -380, -380,
			 -380, -380, -380, -380, -380, -380, -380,    5, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381,  437,  437,  437,  437,  437,
			  437,  437,  437,  437,  437, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,

			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,

			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381, -381, -381, -381, -381, -381, -381,
			 -381, -381, -381, -381,    5, -382, -382, -382, -382, -382,
			 -382, -382, -382, -382, -382, -382, -382, -382, -382, -382,
			 -382, -382, -382, -382, -382, -382, -382, -382, -382, -382,

			 -382, -382, -382, -382, -382, -382, -382, -382, -382, -382,
			 -382, -382, -382, -382, -382, -382, -382, -382, -382, -382,
			 -382, -382,  438,  438,  438,  438,  438,  438,  438,  438,
			  438,  438, -382, -382, -382, -382, -382, -382, -382, -382,
			 -382, -382, -382,  316, -382, -382, -382, -382, -382, -382,
			 -382, -382, -382, -382, -382, -382, -382, -382, -382, -382,
			 -382, -382, -382, -382, -382, -382, -382, -382, -382,  317,
			 -382, -382, -382, -382, -382,  316, -382, -382, -382, -382,
			 -382, -382, -382, -382, -382, -382, -382, -382, -382, -382,
			 -382, -382, -382, -382, -382, -382, -382, -382, -382, -382,

			 -382, -382, -382, -382, -382, -382, -382, -382, -382, -382,
			 -382, -382, -382, -382, -382, -382, -382, -382, -382, -382,
			 -382, -382, -382, -382, -382, -382, -382, -382, -382, -382,
			 -382, -382, -382, -382, -382, -382, -382, -382, -382, -382,
			 -382, -382, -382, -382, -382, -382, -382, -382, -382, -382,
			 -382, -382, -382, -382, -382, -382, -382, -382, -382, -382,
			 -382, -382, -382, -382, -382, -382, -382, -382, -382, -382,
			 -382, -382, -382, -382, -382, -382, -382, -382, -382, -382,
			 -382, -382, -382, -382, -382, -382, -382, -382, -382, -382,
			 -382, -382, -382, -382, -382, -382, -382, -382, -382, -382,

			 -382, -382, -382, -382, -382, -382, -382, -382, -382, -382,
			 -382, -382, -382, -382, -382, -382, -382, -382, -382, -382,
			 -382, -382, -382, -382, -382, -382, -382, -382, -382, -382,
			 -382,    5, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383,  384,
			  384,  384,  384,  384,  384,  384,  384,  384,  384, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,

			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,

			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383, -383, -383,
			 -383, -383, -383, -383, -383, -383, -383, -383,    5, -384,
			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,

			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,
			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,
			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,
			 -384, -384, -384, -384, -384, -384,  439,  439,  439,  439,
			  439,  439,  439,  439,  439,  439, -384, -384, -384, -384,
			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,
			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,
			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,
			 -384, -384, -384,  440, -384, -384, -384, -384, -384, -384,
			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,

			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,
			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,
			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,
			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,
			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,
			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,
			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,
			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,
			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,
			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,

			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,
			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,
			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,
			 -384, -384, -384, -384, -384, -384, -384, -384, -384, -384,
			 -384, -384, -384, -384, -384,    5, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385,  441,  441,  441,  441,  441,  441,  441, yy_Dummy>>,
			1, 3000, 96000)
		end

	yy_nxt_template_34 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  441,  441,  441, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,

			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,
			 -385, -385, -385, -385, -385, -385, -385, -385, -385, -385,

			 -385, -385,    5, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			  442,  442,  442,  442,  442,  442,  442,  442,  442,  442,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386,  387, -386, -386,

			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,

			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386, -386,
			 -386, -386, -386, -386, -386, -386, -386, -386, -386,    5,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,

			 -387, -387, -387, -387, -387, -387, -387,  443,  443,  443,
			  443,  443,  443,  443,  443,  443,  443, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,

			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,

			 -387, -387, -387, -387, -387, -387, -387, -387, -387, -387,
			 -387, -387, -387, -387, -387, -387,    5,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218, -388,  218,  438,  438,  438,  438,  438,  438,
			  438,  438,  438,  438,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  444,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,

			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  444,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,

			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,  218,  218,  218,  218,  218,  218,  218,
			  218,  218,  218,    5, -389, -389, -389, -389, -389, -389,
			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,
			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,

			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,
			 -389, -389, -389, -389, -389, -389, -389, -389, -389,  445,
			 -389,  143,  143,  143,  143,  143,  143,  143,  143,  143,
			  143, -389, -389, -389, -389, -389, -389, -389, -389, -389,
			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,
			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,
			 -389, -389, -389, -389, -389, -389, -389, -389,   94, -389,
			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,
			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,
			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,

			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,
			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,
			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,
			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,
			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,
			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,
			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,
			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,
			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,
			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,

			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,
			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,
			 -389, -389, -389, -389, -389, -389, -389, -389, -389, -389,
			    5, -390, -390, -390, -390, -390, -390, -390, -390, -390,
			 -390, -390, -390, -390, -390, -390, -390, -390, -390, -390,
			 -390, -390, -390, -390, -390, -390, -390, -390, -390, -390,
			 -390, -390, -390, -390, -390, -390, -390, -390, -390, -390,
			 -390, -390, -390, -390, -390, -390, -390, -390,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -390, -390,
			 -390, -390, -390, -390, -390,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -390, -390, -390, -390,  101, -390,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -390, -390, -390, -390, -390, -390, -390,
			 -390, -390, -390, -390, -390, -390, -390, -390, -390, -390,
			 -390, -390, -390, -390, -390, -390, -390, -390, -390, -390,
			 -390, -390, -390, -390, -390, -390, -390, -390, -390, -390,
			 -390, -390, -390, -390, -390, -390, -390, -390, -390, -390,

			 -390, -390, -390, -390, -390, -390, -390, -390, -390, -390,
			 -390, -390, -390, -390, -390, -390, -390, -390, -390, -390,
			 -390, -390, -390, -390, -390, -390, -390, -390, -390, -390,
			 -390, -390, -390, -390, -390, -390, -390, -390, -390, -390,
			 -390, -390, -390, -390, -390, -390, -390, -390, -390, -390,
			 -390, -390, -390, -390, -390, -390, -390, -390, -390, -390,
			 -390, -390, -390, -390, -390, -390, -390, -390, -390, -390,
			 -390, -390, -390, -390, -390, -390, -390, -390, -390, -390,
			 -390, -390, -390, -390, -390, -390, -390,    5, -391, -391,
			 -391, -391, -391, -391, -391, -391, -391, -391, -391, -391,

			 -391, -391, -391, -391, -391, -391, -391, -391, -391, -391,
			 -391, -391, -391, -391, -391, -391, -391, -391, -391, -391,
			 -391, -391, -391, -391, -391, -391, -391, -391, -391, -391,
			 -391, -391, -391, -391, -391,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -391, -391, -391, -391, -391,
			 -391, -391,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -391, -391,
			 -391, -391,  101, -391,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -391, -391, -391, -391, -391, -391, -391, -391, -391, -391,
			 -391, -391, -391, -391, -391, -391, -391, -391, -391, -391,
			 -391, -391, -391, -391, -391, -391, -391, -391, -391, -391,
			 -391, -391, -391, -391, -391, -391, -391, -391, -391, -391,
			 -391, -391, -391, -391, -391, -391, -391, -391, -391, -391,
			 -391, -391, -391, -391, -391, -391, -391, -391, -391, -391,
			 -391, -391, -391, -391, -391, -391, -391, -391, -391, -391,
			 -391, -391, -391, -391, -391, -391, -391, -391, -391, -391,
			 -391, -391, -391, -391, -391, -391, -391, -391, -391, -391,

			 -391, -391, -391, -391, -391, -391, -391, -391, -391, -391,
			 -391, -391, -391, -391, -391, -391, -391, -391, -391, -391,
			 -391, -391, -391, -391, -391, -391, -391, -391, -391, -391,
			 -391, -391, -391, -391, -391, -391, -391, -391, -391, -391,
			 -391, -391, -391, -391,    5, -392, -392, -392, -392, -392,
			 -392, -392, -392, -392, -392, -392, -392, -392, -392, -392,
			 -392, -392, -392, -392, -392, -392, -392, -392, -392, -392,
			 -392, -392, -392, -392, -392, -392, -392, -392, -392, -392,
			 -392, -392, -392, -392, -392, -392, -392, -392, -392, -392,
			 -392, -392,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101, -392, -392, -392, -392, -392, -392, -392,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -392, -392, -392, -392,  101,
			 -392,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -392, -392, -392,
			 -392, -392, -392, -392, -392, -392, -392, -392, -392, -392,
			 -392, -392, -392, -392, -392, -392, -392, -392, -392, -392,
			 -392, -392, -392, -392, -392, -392, -392, -392, -392, -392,

			 -392, -392, -392, -392, -392, -392, -392, -392, -392, -392,
			 -392, -392, -392, -392, -392, -392, -392, -392, -392, -392,
			 -392, -392, -392, -392, -392, -392, -392, -392, -392, -392,
			 -392, -392, -392, -392, -392, -392, -392, -392, -392, -392,
			 -392, -392, -392, -392, -392, -392, -392, -392, -392, -392,
			 -392, -392, -392, -392, -392, -392, -392, -392, -392, -392,
			 -392, -392, -392, -392, -392, -392, -392, -392, -392, -392,
			 -392, -392, -392, -392, -392, -392, -392, -392, -392, -392,
			 -392, -392, -392, -392, -392, -392, -392, -392, -392, -392,
			 -392, -392, -392, -392, -392, -392, -392, -392, -392, -392,

			 -392,    5, -393, -393, -393, -393, -393, -393, -393, -393,
			 -393, -393, -393, -393, -393, -393, -393, -393, -393, -393,
			 -393, -393, -393, -393, -393, -393, -393, -393, -393, -393,
			 -393, -393, -393, -393, -393, -393, -393, -393, -393, -393,
			 -393, -393, -393, -393, -393, -393, -393, -393, -393,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -393,
			 -393, -393, -393, -393, -393, -393,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  446,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -393, -393, -393, -393,  101, -393,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  446,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -393, -393, -393, -393, -393, -393,
			 -393, -393, -393, -393, -393, -393, -393, -393, -393, -393,
			 -393, -393, -393, -393, -393, -393, -393, -393, -393, -393,
			 -393, -393, -393, -393, -393, -393, -393, -393, -393, -393,
			 -393, -393, -393, -393, -393, -393, -393, -393, -393, -393,
			 -393, -393, -393, -393, -393, -393, -393, -393, -393, -393,
			 -393, -393, -393, -393, -393, -393, -393, -393, -393, -393,
			 -393, -393, -393, -393, -393, -393, -393, -393, -393, -393,

			 -393, -393, -393, -393, -393, -393, -393, -393, -393, -393,
			 -393, -393, -393, -393, -393, -393, -393, -393, -393, -393,
			 -393, -393, -393, -393, -393, -393, -393, -393, -393, -393,
			 -393, -393, -393, -393, -393, -393, -393, -393, -393, -393,
			 -393, -393, -393, -393, -393, -393, -393, -393, -393, -393,
			 -393, -393, -393, -393, -393, -393, -393, -393,    5, -394,
			 -394, -394, -394, -394, -394, -394, -394, -394, -394, -394,
			 -394, -394, -394, -394, -394, -394, -394, -394, -394, -394,
			 -394, -394, -394, -394, -394, -394, -394, -394, -394, -394,
			 -394, -394, -394, -394, -394, -394, -394, -394, -394, -394,

			 -394, -394, -394, -394, -394, -394,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -394, -394, -394, -394,
			 -394, -394, -394,  101,  101,  101,  101,  101,  101,  101,
			  101,  447,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -394,
			 -394, -394, -394,  101, -394,  101,  101,  101,  101,  101,
			  101,  101,  101,  447,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -394, -394, -394, -394, -394, -394, -394, -394, -394,
			 -394, -394, -394, -394, -394, -394, -394, -394, -394, -394,

			 -394, -394, -394, -394, -394, -394, -394, -394, -394, -394,
			 -394, -394, -394, -394, -394, -394, -394, -394, -394, -394,
			 -394, -394, -394, -394, -394, -394, -394, -394, -394, -394,
			 -394, -394, -394, -394, -394, -394, -394, -394, -394, -394,
			 -394, -394, -394, -394, -394, -394, -394, -394, -394, -394,
			 -394, -394, -394, -394, -394, -394, -394, -394, -394, -394,
			 -394, -394, -394, -394, -394, -394, -394, -394, -394, -394,
			 -394, -394, -394, -394, -394, -394, -394, -394, -394, -394,
			 -394, -394, -394, -394, -394, -394, -394, -394, -394, -394,
			 -394, -394, -394, -394, -394, -394, -394, -394, -394, -394,

			 -394, -394, -394, -394, -394, -394, -394, -394, -394, -394,
			 -394, -394, -394, -394, -394,    5, -395, -395, -395, -395,
			 -395, -395, -395, -395, -395, -395, -395, -395, -395, -395,
			 -395, -395, -395, -395, -395, -395, -395, -395, -395, -395,
			 -395, -395, -395, -395, -395, -395, -395, -395, -395, -395,
			 -395, -395, -395, -395, -395, -395, -395, -395, -395, -395,
			 -395, -395, -395,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -395, -395, -395, -395, -395, -395, -395,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  448,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101, -395, -395, -395, -395,
			  101, -395,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  448,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -395, -395,
			 -395, -395, -395, -395, -395, -395, -395, -395, -395, -395,
			 -395, -395, -395, -395, -395, -395, -395, -395, -395, -395,
			 -395, -395, -395, -395, -395, -395, -395, -395, -395, -395,
			 -395, -395, -395, -395, -395, -395, -395, -395, -395, -395,
			 -395, -395, -395, -395, -395, -395, -395, -395, -395, -395,
			 -395, -395, -395, -395, -395, -395, -395, -395, -395, -395,

			 -395, -395, -395, -395, -395, -395, -395, -395, -395, -395,
			 -395, -395, -395, -395, -395, -395, -395, -395, -395, -395,
			 -395, -395, -395, -395, -395, -395, -395, -395, -395, -395,
			 -395, -395, -395, -395, -395, -395, -395, -395, -395, -395,
			 -395, -395, -395, -395, -395, -395, -395, -395, -395, -395,
			 -395, -395, -395, -395, -395, -395, -395, -395, -395, -395,
			 -395, -395, -395, -395, -395, -395, -395, -395, -395, -395,
			 -395, -395,    5, -396, -396, -396, -396, -396, -396, -396,
			 -396, -396, -396, -396, -396, -396, -396, -396, -396, -396,
			 -396, -396, -396, -396, -396, -396, -396, -396, -396, -396,

			 -396, -396, -396, -396, -396, -396, -396, -396, -396, -396,
			 -396, -396, -396, -396, -396, -396, -396, -396, -396, -396,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -396, -396, -396, -396, -396, -396, -396,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -396, -396, -396, -396,  101, -396,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -396, -396, -396, -396, -396,

			 -396, -396, -396, -396, -396, -396, -396, -396, -396, -396,
			 -396, -396, -396, -396, -396, -396, -396, -396, -396, -396,
			 -396, -396, -396, -396, -396, -396, -396, -396, -396, -396,
			 -396, -396, -396, -396, -396, -396, -396, -396, -396, -396,
			 -396, -396, -396, -396, -396, -396, -396, -396, -396, -396,
			 -396, -396, -396, -396, -396, -396, -396, -396, -396, -396,
			 -396, -396, -396, -396, -396, -396, -396, -396, -396, -396,
			 -396, -396, -396, -396, -396, -396, -396, -396, -396, -396,
			 -396, -396, -396, -396, -396, -396, -396, -396, -396, -396,
			 -396, -396, -396, -396, -396, -396, -396, -396, -396, -396, yy_Dummy>>,
			1, 3000, 99000)
		end

	yy_nxt_template_35 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -396, -396, -396, -396, -396, -396, -396, -396, -396, -396,
			 -396, -396, -396, -396, -396, -396, -396, -396, -396, -396,
			 -396, -396, -396, -396, -396, -396, -396, -396, -396,    5,
			 -397, -397, -397, -397, -397, -397, -397, -397, -397, -397,
			 -397, -397, -397, -397, -397, -397, -397, -397, -397, -397,
			 -397, -397, -397, -397, -397, -397, -397, -397, -397, -397,
			 -397, -397, -397, -397, -397, -397, -397, -397, -397, -397,
			 -397, -397, -397, -397, -397, -397, -397,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -397, -397, -397,
			 -397, -397, -397, -397,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  449,  101,  101,  101,  101,  101,  101,  101,  101,
			 -397, -397, -397, -397,  101, -397,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  449,  101,  101,  101,  101,  101,  101,
			  101,  101, -397, -397, -397, -397, -397, -397, -397, -397,
			 -397, -397, -397, -397, -397, -397, -397, -397, -397, -397,
			 -397, -397, -397, -397, -397, -397, -397, -397, -397, -397,
			 -397, -397, -397, -397, -397, -397, -397, -397, -397, -397,
			 -397, -397, -397, -397, -397, -397, -397, -397, -397, -397,

			 -397, -397, -397, -397, -397, -397, -397, -397, -397, -397,
			 -397, -397, -397, -397, -397, -397, -397, -397, -397, -397,
			 -397, -397, -397, -397, -397, -397, -397, -397, -397, -397,
			 -397, -397, -397, -397, -397, -397, -397, -397, -397, -397,
			 -397, -397, -397, -397, -397, -397, -397, -397, -397, -397,
			 -397, -397, -397, -397, -397, -397, -397, -397, -397, -397,
			 -397, -397, -397, -397, -397, -397, -397, -397, -397, -397,
			 -397, -397, -397, -397, -397, -397, -397, -397, -397, -397,
			 -397, -397, -397, -397, -397, -397,    5, -398, -398, -398,
			 -398, -398, -398, -398, -398, -398, -398, -398, -398, -398,

			 -398, -398, -398, -398, -398, -398, -398, -398, -398, -398,
			 -398, -398, -398, -398, -398, -398, -398, -398, -398, -398,
			 -398, -398, -398, -398, -398, -398, -398, -398, -398, -398,
			 -398, -398, -398, -398,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -398, -398, -398, -398, -398, -398,
			 -398,  101,  101,  101,  101,  101,  450,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -398, -398, -398,
			 -398,  101, -398,  101,  101,  101,  101,  101,  450,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101, -398,
			 -398, -398, -398, -398, -398, -398, -398, -398, -398, -398,
			 -398, -398, -398, -398, -398, -398, -398, -398, -398, -398,
			 -398, -398, -398, -398, -398, -398, -398, -398, -398, -398,
			 -398, -398, -398, -398, -398, -398, -398, -398, -398, -398,
			 -398, -398, -398, -398, -398, -398, -398, -398, -398, -398,
			 -398, -398, -398, -398, -398, -398, -398, -398, -398, -398,
			 -398, -398, -398, -398, -398, -398, -398, -398, -398, -398,
			 -398, -398, -398, -398, -398, -398, -398, -398, -398, -398,
			 -398, -398, -398, -398, -398, -398, -398, -398, -398, -398,

			 -398, -398, -398, -398, -398, -398, -398, -398, -398, -398,
			 -398, -398, -398, -398, -398, -398, -398, -398, -398, -398,
			 -398, -398, -398, -398, -398, -398, -398, -398, -398, -398,
			 -398, -398, -398, -398, -398, -398, -398, -398, -398, -398,
			 -398, -398, -398,    5, -399, -399, -399, -399, -399, -399,
			 -399, -399, -399, -399, -399, -399, -399, -399, -399, -399,
			 -399, -399, -399, -399, -399, -399, -399, -399, -399, -399,
			 -399, -399, -399, -399, -399, -399, -399, -399, -399, -399,
			 -399, -399, -399, -399, -399, -399, -399, -399, -399, -399,
			 -399,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101, -399, -399, -399, -399, -399, -399, -399,  101,  101,
			  101,  101,  451,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -399, -399, -399, -399,  101, -399,
			  101,  101,  101,  101,  451,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -399, -399, -399, -399,
			 -399, -399, -399, -399, -399, -399, -399, -399, -399, -399,
			 -399, -399, -399, -399, -399, -399, -399, -399, -399, -399,
			 -399, -399, -399, -399, -399, -399, -399, -399, -399, -399,

			 -399, -399, -399, -399, -399, -399, -399, -399, -399, -399,
			 -399, -399, -399, -399, -399, -399, -399, -399, -399, -399,
			 -399, -399, -399, -399, -399, -399, -399, -399, -399, -399,
			 -399, -399, -399, -399, -399, -399, -399, -399, -399, -399,
			 -399, -399, -399, -399, -399, -399, -399, -399, -399, -399,
			 -399, -399, -399, -399, -399, -399, -399, -399, -399, -399,
			 -399, -399, -399, -399, -399, -399, -399, -399, -399, -399,
			 -399, -399, -399, -399, -399, -399, -399, -399, -399, -399,
			 -399, -399, -399, -399, -399, -399, -399, -399, -399, -399,
			 -399, -399, -399, -399, -399, -399, -399, -399, -399, -399,

			    5, -400, -400, -400, -400, -400, -400, -400, -400, -400,
			 -400, -400, -400, -400, -400, -400, -400, -400, -400, -400,
			 -400, -400, -400, -400, -400, -400, -400, -400, -400, -400,
			 -400, -400, -400, -400, -400, -400, -400, -400, -400, -400,
			 -400, -400, -400, -400, -400, -400, -400, -400,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -400, -400,
			 -400, -400, -400, -400, -400,  101,  101,  101,  452,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -400, -400, -400, -400,  101, -400,  101,  101,  101,

			  452,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -400, -400, -400, -400, -400, -400, -400,
			 -400, -400, -400, -400, -400, -400, -400, -400, -400, -400,
			 -400, -400, -400, -400, -400, -400, -400, -400, -400, -400,
			 -400, -400, -400, -400, -400, -400, -400, -400, -400, -400,
			 -400, -400, -400, -400, -400, -400, -400, -400, -400, -400,
			 -400, -400, -400, -400, -400, -400, -400, -400, -400, -400,
			 -400, -400, -400, -400, -400, -400, -400, -400, -400, -400,
			 -400, -400, -400, -400, -400, -400, -400, -400, -400, -400,

			 -400, -400, -400, -400, -400, -400, -400, -400, -400, -400,
			 -400, -400, -400, -400, -400, -400, -400, -400, -400, -400,
			 -400, -400, -400, -400, -400, -400, -400, -400, -400, -400,
			 -400, -400, -400, -400, -400, -400, -400, -400, -400, -400,
			 -400, -400, -400, -400, -400, -400, -400, -400, -400, -400,
			 -400, -400, -400, -400, -400, -400, -400,    5, -401, -401,
			 -401, -401, -401, -401, -401, -401, -401, -401, -401, -401,
			 -401, -401, -401, -401, -401, -401, -401, -401, -401, -401,
			 -401, -401, -401, -401, -401, -401, -401, -401, -401, -401,
			 -401, -401, -401, -401, -401, -401, -401, -401, -401, -401,

			 -401, -401, -401, -401, -401,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -401, -401, -401, -401, -401,
			 -401, -401,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  453,  101,  101,  101,  101,  101,  101, -401, -401,
			 -401, -401,  101, -401,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  453,  101,  101,  101,  101,  101,  101,
			 -401, -401, -401, -401, -401, -401, -401, -401, -401, -401,
			 -401, -401, -401, -401, -401, -401, -401, -401, -401, -401,

			 -401, -401, -401, -401, -401, -401, -401, -401, -401, -401,
			 -401, -401, -401, -401, -401, -401, -401, -401, -401, -401,
			 -401, -401, -401, -401, -401, -401, -401, -401, -401, -401,
			 -401, -401, -401, -401, -401, -401, -401, -401, -401, -401,
			 -401, -401, -401, -401, -401, -401, -401, -401, -401, -401,
			 -401, -401, -401, -401, -401, -401, -401, -401, -401, -401,
			 -401, -401, -401, -401, -401, -401, -401, -401, -401, -401,
			 -401, -401, -401, -401, -401, -401, -401, -401, -401, -401,
			 -401, -401, -401, -401, -401, -401, -401, -401, -401, -401,
			 -401, -401, -401, -401, -401, -401, -401, -401, -401, -401,

			 -401, -401, -401, -401, -401, -401, -401, -401, -401, -401,
			 -401, -401, -401, -401,    5, -402, -402, -402, -402, -402,
			 -402, -402, -402, -402, -402, -402, -402, -402, -402, -402,
			 -402, -402, -402, -402, -402, -402, -402, -402, -402, -402,
			 -402, -402, -402, -402, -402, -402, -402, -402, -402, -402,
			 -402, -402, -402, -402, -402, -402, -402, -402, -402, -402,
			 -402, -402,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -402, -402, -402, -402, -402, -402, -402,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  454,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101, -402, -402, -402, -402,  101,
			 -402,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  454,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -402, -402, -402,
			 -402, -402, -402, -402, -402, -402, -402, -402, -402, -402,
			 -402, -402, -402, -402, -402, -402, -402, -402, -402, -402,
			 -402, -402, -402, -402, -402, -402, -402, -402, -402, -402,
			 -402, -402, -402, -402, -402, -402, -402, -402, -402, -402,
			 -402, -402, -402, -402, -402, -402, -402, -402, -402, -402,
			 -402, -402, -402, -402, -402, -402, -402, -402, -402, -402,

			 -402, -402, -402, -402, -402, -402, -402, -402, -402, -402,
			 -402, -402, -402, -402, -402, -402, -402, -402, -402, -402,
			 -402, -402, -402, -402, -402, -402, -402, -402, -402, -402,
			 -402, -402, -402, -402, -402, -402, -402, -402, -402, -402,
			 -402, -402, -402, -402, -402, -402, -402, -402, -402, -402,
			 -402, -402, -402, -402, -402, -402, -402, -402, -402, -402,
			 -402, -402, -402, -402, -402, -402, -402, -402, -402, -402,
			 -402,    5, -403, -403, -403, -403, -403, -403, -403, -403,
			 -403, -403, -403, -403, -403, -403, -403, -403, -403, -403,
			 -403, -403, -403, -403, -403, -403, -403, -403, -403, -403,

			 -403, -403, -403, -403, -403, -403, -403, -403, -403, -403,
			 -403, -403, -403, -403, -403, -403, -403, -403, -403,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -403,
			 -403, -403, -403, -403, -403, -403,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -403, -403, -403, -403,  101, -403,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -403, -403, -403, -403, -403, -403,

			 -403, -403, -403, -403, -403, -403, -403, -403, -403, -403,
			 -403, -403, -403, -403, -403, -403, -403, -403, -403, -403,
			 -403, -403, -403, -403, -403, -403, -403, -403, -403, -403,
			 -403, -403, -403, -403, -403, -403, -403, -403, -403, -403,
			 -403, -403, -403, -403, -403, -403, -403, -403, -403, -403,
			 -403, -403, -403, -403, -403, -403, -403, -403, -403, -403,
			 -403, -403, -403, -403, -403, -403, -403, -403, -403, -403,
			 -403, -403, -403, -403, -403, -403, -403, -403, -403, -403,
			 -403, -403, -403, -403, -403, -403, -403, -403, -403, -403,
			 -403, -403, -403, -403, -403, -403, -403, -403, -403, -403,

			 -403, -403, -403, -403, -403, -403, -403, -403, -403, -403,
			 -403, -403, -403, -403, -403, -403, -403, -403, -403, -403,
			 -403, -403, -403, -403, -403, -403, -403, -403,    5, -404,
			 -404, -404, -404, -404, -404, -404, -404, -404, -404, -404,
			 -404, -404, -404, -404, -404, -404, -404, -404, -404, -404,
			 -404, -404, -404, -404, -404, -404, -404, -404, -404, -404,
			 -404, -404, -404, -404, -404, -404, -404, -404, -404, -404,
			 -404, -404, -404, -404, -404, -404,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -404, -404, -404, -404,
			 -404, -404, -404,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  455,  101,  101,  101,  101,  101,  101,  101,  101, -404,
			 -404, -404, -404,  101, -404,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  455,  101,  101,  101,  101,  101,  101,  101,
			  101, -404, -404, -404, -404, -404, -404, -404, -404, -404,
			 -404, -404, -404, -404, -404, -404, -404, -404, -404, -404,
			 -404, -404, -404, -404, -404, -404, -404, -404, -404, -404,
			 -404, -404, -404, -404, -404, -404, -404, -404, -404, -404,
			 -404, -404, -404, -404, -404, -404, -404, -404, -404, -404,

			 -404, -404, -404, -404, -404, -404, -404, -404, -404, -404,
			 -404, -404, -404, -404, -404, -404, -404, -404, -404, -404,
			 -404, -404, -404, -404, -404, -404, -404, -404, -404, -404,
			 -404, -404, -404, -404, -404, -404, -404, -404, -404, -404,
			 -404, -404, -404, -404, -404, -404, -404, -404, -404, -404,
			 -404, -404, -404, -404, -404, -404, -404, -404, -404, -404,
			 -404, -404, -404, -404, -404, -404, -404, -404, -404, -404,
			 -404, -404, -404, -404, -404, -404, -404, -404, -404, -404,
			 -404, -404, -404, -404, -404,    5, -405, -405, -405, -405,
			 -405, -405, -405, -405, -405, -405, -405, -405, -405, -405,

			 -405, -405, -405, -405, -405, -405, -405, -405, -405, -405,
			 -405, -405, -405, -405, -405, -405, -405, -405, -405, -405,
			 -405, -405, -405, -405, -405, -405, -405, -405, -405, -405,
			 -405, -405, -405,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -405, -405, -405, -405, -405, -405, -405,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  456,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -405, -405, -405, -405,
			  101, -405,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  456,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101, -405, -405,
			 -405, -405, -405, -405, -405, -405, -405, -405, -405, -405,
			 -405, -405, -405, -405, -405, -405, -405, -405, -405, -405,
			 -405, -405, -405, -405, -405, -405, -405, -405, -405, -405,
			 -405, -405, -405, -405, -405, -405, -405, -405, -405, -405,
			 -405, -405, -405, -405, -405, -405, -405, -405, -405, -405,
			 -405, -405, -405, -405, -405, -405, -405, -405, -405, -405,
			 -405, -405, -405, -405, -405, -405, -405, -405, -405, -405,
			 -405, -405, -405, -405, -405, -405, -405, -405, -405, -405,
			 -405, -405, -405, -405, -405, -405, -405, -405, -405, -405,

			 -405, -405, -405, -405, -405, -405, -405, -405, -405, -405,
			 -405, -405, -405, -405, -405, -405, -405, -405, -405, -405,
			 -405, -405, -405, -405, -405, -405, -405, -405, -405, -405,
			 -405, -405, -405, -405, -405, -405, -405, -405, -405, -405,
			 -405, -405,    5, -406, -406, -406, -406, -406, -406, -406,
			 -406, -406, -406, -406, -406, -406, -406, -406, -406, -406,
			 -406, -406, -406, -406, -406, -406, -406, -406, -406, -406,
			 -406, -406, -406, -406, -406, -406, -406, -406, -406, -406,
			 -406, -406, -406, -406, -406, -406, -406, -406, -406, -406,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			 -406, -406, -406, -406, -406, -406, -406,  101,  101,  101,
			  101,  457,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -406, -406, -406, -406,  101, -406,  101,
			  101,  101,  101,  457,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -406, -406, -406, -406, -406,
			 -406, -406, -406, -406, -406, -406, -406, -406, -406, -406,
			 -406, -406, -406, -406, -406, -406, -406, -406, -406, -406,
			 -406, -406, -406, -406, -406, -406, -406, -406, -406, -406,

			 -406, -406, -406, -406, -406, -406, -406, -406, -406, -406,
			 -406, -406, -406, -406, -406, -406, -406, -406, -406, -406,
			 -406, -406, -406, -406, -406, -406, -406, -406, -406, -406,
			 -406, -406, -406, -406, -406, -406, -406, -406, -406, -406,
			 -406, -406, -406, -406, -406, -406, -406, -406, -406, -406,
			 -406, -406, -406, -406, -406, -406, -406, -406, -406, -406,
			 -406, -406, -406, -406, -406, -406, -406, -406, -406, -406,
			 -406, -406, -406, -406, -406, -406, -406, -406, -406, -406,
			 -406, -406, -406, -406, -406, -406, -406, -406, -406, -406,
			 -406, -406, -406, -406, -406, -406, -406, -406, -406,    5,

			 -407, -407, -407, -407, -407, -407, -407, -407, -407, -407,
			 -407, -407, -407, -407, -407, -407, -407, -407, -407, -407,
			 -407, -407, -407, -407, -407, -407, -407, -407, -407, -407,
			 -407, -407, -407, -407, -407, -407, -407, -407, -407, -407,
			 -407, -407, -407, -407, -407, -407, -407,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -407, -407, -407,
			 -407, -407, -407, -407,  101,  101,  101,  101,  101,  101,
			  101,  101,  458,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -407, -407, -407, -407,  101, -407,  101,  101,  101,  101,

			  101,  101,  101,  101,  458,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -407, -407, -407, -407, -407, -407, -407, -407,
			 -407, -407, -407, -407, -407, -407, -407, -407, -407, -407,
			 -407, -407, -407, -407, -407, -407, -407, -407, -407, -407,
			 -407, -407, -407, -407, -407, -407, -407, -407, -407, -407,
			 -407, -407, -407, -407, -407, -407, -407, -407, -407, -407,
			 -407, -407, -407, -407, -407, -407, -407, -407, -407, -407,
			 -407, -407, -407, -407, -407, -407, -407, -407, -407, -407,
			 -407, -407, -407, -407, -407, -407, -407, -407, -407, -407,

			 -407, -407, -407, -407, -407, -407, -407, -407, -407, -407,
			 -407, -407, -407, -407, -407, -407, -407, -407, -407, -407,
			 -407, -407, -407, -407, -407, -407, -407, -407, -407, -407,
			 -407, -407, -407, -407, -407, -407, -407, -407, -407, -407,
			 -407, -407, -407, -407, -407, -407, -407, -407, -407, -407,
			 -407, -407, -407, -407, -407, -407,    5, -408, -408, -408,
			 -408, -408, -408, -408, -408, -408, -408, -408, -408, -408,
			 -408, -408, -408, -408, -408, -408, -408, -408, -408, -408,
			 -408, -408, -408, -408, -408, -408, -408, -408, -408, -408,
			 -408, -408, -408, -408, -408, -408, -408, -408, -408, -408,

			 -408, -408, -408, -408,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -408, -408, -408, -408, -408, -408,
			 -408,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -408, -408, -408,
			 -408,  101, -408,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -408,
			 -408, -408, -408, -408, -408, -408, -408, -408, -408, -408,
			 -408, -408, -408, -408, -408, -408, -408, -408, -408, -408, yy_Dummy>>,
			1, 3000, 102000)
		end

	yy_nxt_template_36 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -408, -408, -408, -408, -408, -408, -408, -408, -408, -408,
			 -408, -408, -408, -408, -408, -408, -408, -408, -408, -408,
			 -408, -408, -408, -408, -408, -408, -408, -408, -408, -408,
			 -408, -408, -408, -408, -408, -408, -408, -408, -408, -408,
			 -408, -408, -408, -408, -408, -408, -408, -408, -408, -408,
			 -408, -408, -408, -408, -408, -408, -408, -408, -408, -408,
			 -408, -408, -408, -408, -408, -408, -408, -408, -408, -408,
			 -408, -408, -408, -408, -408, -408, -408, -408, -408, -408,
			 -408, -408, -408, -408, -408, -408, -408, -408, -408, -408,
			 -408, -408, -408, -408, -408, -408, -408, -408, -408, -408,

			 -408, -408, -408, -408, -408, -408, -408, -408, -408, -408,
			 -408, -408, -408,    5, -409, -409, -409, -409, -409, -409,
			 -409, -409, -409, -409, -409, -409, -409, -409, -409, -409,
			 -409, -409, -409, -409, -409, -409, -409, -409, -409, -409,
			 -409, -409, -409, -409, -409, -409, -409, -409, -409, -409,
			 -409, -409, -409, -409, -409, -409, -409, -409, -409, -409,
			 -409,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -409, -409, -409, -409, -409, -409, -409,  101,  101,
			  101,  101,  101,  101,  101,  101,  459,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101, -409, -409, -409, -409,  101, -409,
			  101,  101,  101,  101,  101,  101,  101,  101,  459,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -409, -409, -409, -409,
			 -409, -409, -409, -409, -409, -409, -409, -409, -409, -409,
			 -409, -409, -409, -409, -409, -409, -409, -409, -409, -409,
			 -409, -409, -409, -409, -409, -409, -409, -409, -409, -409,
			 -409, -409, -409, -409, -409, -409, -409, -409, -409, -409,
			 -409, -409, -409, -409, -409, -409, -409, -409, -409, -409,
			 -409, -409, -409, -409, -409, -409, -409, -409, -409, -409,

			 -409, -409, -409, -409, -409, -409, -409, -409, -409, -409,
			 -409, -409, -409, -409, -409, -409, -409, -409, -409, -409,
			 -409, -409, -409, -409, -409, -409, -409, -409, -409, -409,
			 -409, -409, -409, -409, -409, -409, -409, -409, -409, -409,
			 -409, -409, -409, -409, -409, -409, -409, -409, -409, -409,
			 -409, -409, -409, -409, -409, -409, -409, -409, -409, -409,
			 -409, -409, -409, -409, -409, -409, -409, -409, -409, -409,
			    5, -410, -410, -410, -410, -410, -410, -410, -410, -410,
			 -410, -410, -410, -410, -410, -410, -410, -410, -410, -410,
			 -410, -410, -410, -410, -410, -410, -410, -410, -410, -410,

			 -410, -410, -410, -410, -410, -410, -410, -410, -410, -410,
			 -410, -410, -410, -410, -410, -410, -410, -410,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -410, -410,
			 -410, -410, -410, -410, -410,  101,  101,  460,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -410, -410, -410, -410,  101, -410,  101,  101,  460,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -410, -410, -410, -410, -410, -410, -410,

			 -410, -410, -410, -410, -410, -410, -410, -410, -410, -410,
			 -410, -410, -410, -410, -410, -410, -410, -410, -410, -410,
			 -410, -410, -410, -410, -410, -410, -410, -410, -410, -410,
			 -410, -410, -410, -410, -410, -410, -410, -410, -410, -410,
			 -410, -410, -410, -410, -410, -410, -410, -410, -410, -410,
			 -410, -410, -410, -410, -410, -410, -410, -410, -410, -410,
			 -410, -410, -410, -410, -410, -410, -410, -410, -410, -410,
			 -410, -410, -410, -410, -410, -410, -410, -410, -410, -410,
			 -410, -410, -410, -410, -410, -410, -410, -410, -410, -410,
			 -410, -410, -410, -410, -410, -410, -410, -410, -410, -410,

			 -410, -410, -410, -410, -410, -410, -410, -410, -410, -410,
			 -410, -410, -410, -410, -410, -410, -410, -410, -410, -410,
			 -410, -410, -410, -410, -410, -410, -410,    5, -411, -411,
			 -411, -411, -411, -411, -411, -411, -411, -411, -411, -411,
			 -411, -411, -411, -411, -411, -411, -411, -411, -411, -411,
			 -411, -411, -411, -411, -411, -411, -411, -411, -411, -411,
			 -411, -411, -411, -411, -411, -411, -411, -411, -411, -411,
			 -411, -411, -411, -411, -411,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -411, -411, -411, -411, -411,
			 -411, -411,  101,  101,  101,  101,  101,  101,  101,  101,

			  461,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -411, -411,
			 -411, -411,  101, -411,  101,  101,  101,  101,  101,  101,
			  101,  101,  461,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -411, -411, -411, -411, -411, -411, -411, -411, -411, -411,
			 -411, -411, -411, -411, -411, -411, -411, -411, -411, -411,
			 -411, -411, -411, -411, -411, -411, -411, -411, -411, -411,
			 -411, -411, -411, -411, -411, -411, -411, -411, -411, -411,
			 -411, -411, -411, -411, -411, -411, -411, -411, -411, -411,

			 -411, -411, -411, -411, -411, -411, -411, -411, -411, -411,
			 -411, -411, -411, -411, -411, -411, -411, -411, -411, -411,
			 -411, -411, -411, -411, -411, -411, -411, -411, -411, -411,
			 -411, -411, -411, -411, -411, -411, -411, -411, -411, -411,
			 -411, -411, -411, -411, -411, -411, -411, -411, -411, -411,
			 -411, -411, -411, -411, -411, -411, -411, -411, -411, -411,
			 -411, -411, -411, -411, -411, -411, -411, -411, -411, -411,
			 -411, -411, -411, -411, -411, -411, -411, -411, -411, -411,
			 -411, -411, -411, -411,    5, -412, -412, -412, -412, -412,
			 -412, -412, -412, -412, -412, -412, -412, -412, -412, -412,

			 -412, -412, -412, -412, -412, -412, -412, -412, -412, -412,
			 -412, -412, -412, -412, -412, -412, -412, -412, -412, -412,
			 -412, -412, -412, -412, -412, -412, -412, -412, -412, -412,
			 -412, -412,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -412, -412, -412, -412, -412, -412, -412,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -412, -412, -412, -412,  101,
			 -412,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101, -412, -412, -412,
			 -412, -412, -412, -412, -412, -412, -412, -412, -412, -412,
			 -412, -412, -412, -412, -412, -412, -412, -412, -412, -412,
			 -412, -412, -412, -412, -412, -412, -412, -412, -412, -412,
			 -412, -412, -412, -412, -412, -412, -412, -412, -412, -412,
			 -412, -412, -412, -412, -412, -412, -412, -412, -412, -412,
			 -412, -412, -412, -412, -412, -412, -412, -412, -412, -412,
			 -412, -412, -412, -412, -412, -412, -412, -412, -412, -412,
			 -412, -412, -412, -412, -412, -412, -412, -412, -412, -412,
			 -412, -412, -412, -412, -412, -412, -412, -412, -412, -412,

			 -412, -412, -412, -412, -412, -412, -412, -412, -412, -412,
			 -412, -412, -412, -412, -412, -412, -412, -412, -412, -412,
			 -412, -412, -412, -412, -412, -412, -412, -412, -412, -412,
			 -412, -412, -412, -412, -412, -412, -412, -412, -412, -412,
			 -412,    5, -413, -413, -413, -413, -413, -413, -413, -413,
			 -413, -413, -413, -413, -413, -413, -413, -413, -413, -413,
			 -413, -413, -413, -413, -413, -413, -413, -413, -413, -413,
			 -413, -413, -413, -413, -413, -413, -413, -413, -413, -413,
			 -413, -413, -413, -413, -413, -413, -413, -413, -413,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -413,

			 -413, -413, -413, -413, -413, -413,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  462,  101, -413, -413, -413, -413,  101, -413,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  462,  101, -413, -413, -413, -413, -413, -413,
			 -413, -413, -413, -413, -413, -413, -413, -413, -413, -413,
			 -413, -413, -413, -413, -413, -413, -413, -413, -413, -413,
			 -413, -413, -413, -413, -413, -413, -413, -413, -413, -413,

			 -413, -413, -413, -413, -413, -413, -413, -413, -413, -413,
			 -413, -413, -413, -413, -413, -413, -413, -413, -413, -413,
			 -413, -413, -413, -413, -413, -413, -413, -413, -413, -413,
			 -413, -413, -413, -413, -413, -413, -413, -413, -413, -413,
			 -413, -413, -413, -413, -413, -413, -413, -413, -413, -413,
			 -413, -413, -413, -413, -413, -413, -413, -413, -413, -413,
			 -413, -413, -413, -413, -413, -413, -413, -413, -413, -413,
			 -413, -413, -413, -413, -413, -413, -413, -413, -413, -413,
			 -413, -413, -413, -413, -413, -413, -413, -413, -413, -413,
			 -413, -413, -413, -413, -413, -413, -413, -413,    5, -414,

			 -414, -414, -414, -414, -414, -414, -414, -414, -414, -414,
			 -414, -414, -414, -414, -414, -414, -414, -414, -414, -414,
			 -414, -414, -414, -414, -414, -414, -414, -414, -414, -414,
			 -414, -414, -414, -414, -414, -414, -414, -414, -414, -414,
			 -414, -414, -414, -414, -414, -414,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -414, -414, -414, -414,
			 -414, -414, -414,  101,  101,  101,  101,  463,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -414,
			 -414, -414, -414,  101, -414,  101,  101,  101,  101,  463,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -414, -414, -414, -414, -414, -414, -414, -414, -414,
			 -414, -414, -414, -414, -414, -414, -414, -414, -414, -414,
			 -414, -414, -414, -414, -414, -414, -414, -414, -414, -414,
			 -414, -414, -414, -414, -414, -414, -414, -414, -414, -414,
			 -414, -414, -414, -414, -414, -414, -414, -414, -414, -414,
			 -414, -414, -414, -414, -414, -414, -414, -414, -414, -414,
			 -414, -414, -414, -414, -414, -414, -414, -414, -414, -414,
			 -414, -414, -414, -414, -414, -414, -414, -414, -414, -414,

			 -414, -414, -414, -414, -414, -414, -414, -414, -414, -414,
			 -414, -414, -414, -414, -414, -414, -414, -414, -414, -414,
			 -414, -414, -414, -414, -414, -414, -414, -414, -414, -414,
			 -414, -414, -414, -414, -414, -414, -414, -414, -414, -414,
			 -414, -414, -414, -414, -414, -414, -414, -414, -414, -414,
			 -414, -414, -414, -414, -414,    5, -415, -415, -415, -415,
			 -415, -415, -415, -415, -415, -415, -415, -415, -415, -415,
			 -415, -415, -415, -415, -415, -415, -415, -415, -415, -415,
			 -415, -415, -415, -415, -415, -415, -415, -415, -415, -415,
			 -415, -415, -415, -415, -415, -415, -415, -415, -415, -415,

			 -415, -415, -415,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -415, -415, -415, -415, -415, -415, -415,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  464,  101,  101,
			  101,  101,  101,  101,  101,  101, -415, -415, -415, -415,
			  101, -415,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  464,
			  101,  101,  101,  101,  101,  101,  101,  101, -415, -415,
			 -415, -415, -415, -415, -415, -415, -415, -415, -415, -415,
			 -415, -415, -415, -415, -415, -415, -415, -415, -415, -415,

			 -415, -415, -415, -415, -415, -415, -415, -415, -415, -415,
			 -415, -415, -415, -415, -415, -415, -415, -415, -415, -415,
			 -415, -415, -415, -415, -415, -415, -415, -415, -415, -415,
			 -415, -415, -415, -415, -415, -415, -415, -415, -415, -415,
			 -415, -415, -415, -415, -415, -415, -415, -415, -415, -415,
			 -415, -415, -415, -415, -415, -415, -415, -415, -415, -415,
			 -415, -415, -415, -415, -415, -415, -415, -415, -415, -415,
			 -415, -415, -415, -415, -415, -415, -415, -415, -415, -415,
			 -415, -415, -415, -415, -415, -415, -415, -415, -415, -415,
			 -415, -415, -415, -415, -415, -415, -415, -415, -415, -415,

			 -415, -415, -415, -415, -415, -415, -415, -415, -415, -415,
			 -415, -415,    5, -416, -416, -416, -416, -416, -416, -416,
			 -416, -416, -416, -416, -416, -416, -416, -416, -416, -416,
			 -416, -416, -416, -416, -416, -416, -416, -416, -416, -416,
			 -416, -416, -416, -416, -416, -416, -416, -416, -416, -416,
			 -416, -416, -416, -416, -416, -416, -416, -416, -416, -416,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -416, -416, -416, -416, -416, -416, -416,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  465,  101,  101, -416, -416, -416, -416,  101, -416,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  465,  101,  101, -416, -416, -416, -416, -416,
			 -416, -416, -416, -416, -416, -416, -416, -416, -416, -416,
			 -416, -416, -416, -416, -416, -416, -416, -416, -416, -416,
			 -416, -416, -416, -416, -416, -416, -416, -416, -416, -416,
			 -416, -416, -416, -416, -416, -416, -416, -416, -416, -416,
			 -416, -416, -416, -416, -416, -416, -416, -416, -416, -416,
			 -416, -416, -416, -416, -416, -416, -416, -416, -416, -416,

			 -416, -416, -416, -416, -416, -416, -416, -416, -416, -416,
			 -416, -416, -416, -416, -416, -416, -416, -416, -416, -416,
			 -416, -416, -416, -416, -416, -416, -416, -416, -416, -416,
			 -416, -416, -416, -416, -416, -416, -416, -416, -416, -416,
			 -416, -416, -416, -416, -416, -416, -416, -416, -416, -416,
			 -416, -416, -416, -416, -416, -416, -416, -416, -416, -416,
			 -416, -416, -416, -416, -416, -416, -416, -416, -416,    5,
			 -417, -417, -417, -417, -417, -417, -417, -417, -417, -417,
			 -417, -417, -417, -417, -417, -417, -417, -417, -417, -417,
			 -417, -417, -417, -417, -417, -417, -417, -417, -417, -417,

			 -417, -417, -417, -417, -417, -417, -417, -417, -417, -417,
			 -417, -417, -417, -417, -417, -417, -417,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -417, -417, -417,
			 -417, -417, -417, -417,  101,  101,  101,  101,  101,  101,
			  101,  101,  466,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -417, -417, -417, -417,  101, -417,  101,  101,  101,  101,
			  101,  101,  101,  101,  466,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -417, -417, -417, -417, -417, -417, -417, -417,

			 -417, -417, -417, -417, -417, -417, -417, -417, -417, -417,
			 -417, -417, -417, -417, -417, -417, -417, -417, -417, -417,
			 -417, -417, -417, -417, -417, -417, -417, -417, -417, -417,
			 -417, -417, -417, -417, -417, -417, -417, -417, -417, -417,
			 -417, -417, -417, -417, -417, -417, -417, -417, -417, -417,
			 -417, -417, -417, -417, -417, -417, -417, -417, -417, -417,
			 -417, -417, -417, -417, -417, -417, -417, -417, -417, -417,
			 -417, -417, -417, -417, -417, -417, -417, -417, -417, -417,
			 -417, -417, -417, -417, -417, -417, -417, -417, -417, -417,
			 -417, -417, -417, -417, -417, -417, -417, -417, -417, -417,

			 -417, -417, -417, -417, -417, -417, -417, -417, -417, -417,
			 -417, -417, -417, -417, -417, -417, -417, -417, -417, -417,
			 -417, -417, -417, -417, -417, -417,    5, -418, -418, -418,
			 -418, -418, -418, -418, -418, -418, -418, -418, -418, -418,
			 -418, -418, -418, -418, -418, -418, -418, -418, -418, -418,
			 -418, -418, -418, -418, -418, -418, -418, -418, -418, -418,
			 -418, -418, -418, -418, -418, -418, -418, -418, -418, -418,
			 -418, -418, -418, -418,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -418, -418, -418, -418, -418, -418,
			 -418,  101,  101,  101,  101,  467,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -418, -418, -418,
			 -418,  101, -418,  101,  101,  101,  101,  467,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -418,
			 -418, -418, -418, -418, -418, -418, -418, -418, -418, -418,
			 -418, -418, -418, -418, -418, -418, -418, -418, -418, -418,
			 -418, -418, -418, -418, -418, -418, -418, -418, -418, -418,
			 -418, -418, -418, -418, -418, -418, -418, -418, -418, -418,
			 -418, -418, -418, -418, -418, -418, -418, -418, -418, -418,

			 -418, -418, -418, -418, -418, -418, -418, -418, -418, -418,
			 -418, -418, -418, -418, -418, -418, -418, -418, -418, -418,
			 -418, -418, -418, -418, -418, -418, -418, -418, -418, -418,
			 -418, -418, -418, -418, -418, -418, -418, -418, -418, -418,
			 -418, -418, -418, -418, -418, -418, -418, -418, -418, -418,
			 -418, -418, -418, -418, -418, -418, -418, -418, -418, -418,
			 -418, -418, -418, -418, -418, -418, -418, -418, -418, -418,
			 -418, -418, -418, -418, -418, -418, -418, -418, -418, -418,
			 -418, -418, -418,    5, -419, -419, -419, -419, -419, -419,
			 -419, -419, -419, -419, -419, -419, -419, -419, -419, -419,

			 -419, -419, -419, -419, -419, -419, -419, -419, -419, -419,
			 -419, -419, -419, -419, -419, -419, -419, -419, -419, -419,
			 -419, -419, -419, -419, -419, -419, -419, -419, -419, -419,
			 -419,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -419, -419, -419, -419, -419, -419, -419,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  468,  101,  101,  101,  101,
			  101,  101,  101,  101, -419, -419, -419, -419,  101, -419,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  468,  101,  101,

			  101,  101,  101,  101,  101,  101, -419, -419, -419, -419,
			 -419, -419, -419, -419, -419, -419, -419, -419, -419, -419,
			 -419, -419, -419, -419, -419, -419, -419, -419, -419, -419,
			 -419, -419, -419, -419, -419, -419, -419, -419, -419, -419,
			 -419, -419, -419, -419, -419, -419, -419, -419, -419, -419,
			 -419, -419, -419, -419, -419, -419, -419, -419, -419, -419,
			 -419, -419, -419, -419, -419, -419, -419, -419, -419, -419,
			 -419, -419, -419, -419, -419, -419, -419, -419, -419, -419,
			 -419, -419, -419, -419, -419, -419, -419, -419, -419, -419,
			 -419, -419, -419, -419, -419, -419, -419, -419, -419, -419,

			 -419, -419, -419, -419, -419, -419, -419, -419, -419, -419,
			 -419, -419, -419, -419, -419, -419, -419, -419, -419, -419,
			 -419, -419, -419, -419, -419, -419, -419, -419, -419, -419,
			 -419, -419, -419, -419, -419, -419, -419, -419, -419, -419,
			    5, -420, -420, -420, -420, -420, -420, -420, -420, -420,
			 -420, -420, -420, -420, -420, -420, -420, -420, -420, -420,
			 -420, -420, -420, -420, -420, -420, -420, -420, -420, -420,
			 -420, -420, -420, -420, -420, -420, -420, -420, -420, -420,
			 -420, -420, -420, -420, -420, -420, -420, -420,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -420, -420, yy_Dummy>>,
			1, 3000, 105000)
		end

	yy_nxt_template_37 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -420, -420, -420, -420, -420,  101,  101,  101,  101,  469,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -420, -420, -420, -420,  101, -420,  101,  101,  101,
			  101,  469,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -420, -420, -420, -420, -420, -420, -420,
			 -420, -420, -420, -420, -420, -420, -420, -420, -420, -420,
			 -420, -420, -420, -420, -420, -420, -420, -420, -420, -420,
			 -420, -420, -420, -420, -420, -420, -420, -420, -420, -420,

			 -420, -420, -420, -420, -420, -420, -420, -420, -420, -420,
			 -420, -420, -420, -420, -420, -420, -420, -420, -420, -420,
			 -420, -420, -420, -420, -420, -420, -420, -420, -420, -420,
			 -420, -420, -420, -420, -420, -420, -420, -420, -420, -420,
			 -420, -420, -420, -420, -420, -420, -420, -420, -420, -420,
			 -420, -420, -420, -420, -420, -420, -420, -420, -420, -420,
			 -420, -420, -420, -420, -420, -420, -420, -420, -420, -420,
			 -420, -420, -420, -420, -420, -420, -420, -420, -420, -420,
			 -420, -420, -420, -420, -420, -420, -420, -420, -420, -420,
			 -420, -420, -420, -420, -420, -420, -420,    5, -421, -421,

			 -421, -421, -421, -421, -421, -421, -421, -421, -421, -421,
			 -421, -421, -421, -421, -421, -421, -421, -421, -421, -421,
			 -421, -421, -421, -421, -421, -421, -421, -421, -421, -421,
			 -421, -421, -421, -421, -421, -421, -421, -421, -421, -421,
			 -421, -421, -421, -421, -421,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -421, -421, -421, -421, -421,
			 -421, -421,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  470,  101,  101,  101,  101,  101,  101, -421, -421,
			 -421, -421,  101, -421,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  470,  101,  101,  101,  101,  101,  101,
			 -421, -421, -421, -421, -421, -421, -421, -421, -421, -421,
			 -421, -421, -421, -421, -421, -421, -421, -421, -421, -421,
			 -421, -421, -421, -421, -421, -421, -421, -421, -421, -421,
			 -421, -421, -421, -421, -421, -421, -421, -421, -421, -421,
			 -421, -421, -421, -421, -421, -421, -421, -421, -421, -421,
			 -421, -421, -421, -421, -421, -421, -421, -421, -421, -421,
			 -421, -421, -421, -421, -421, -421, -421, -421, -421, -421,
			 -421, -421, -421, -421, -421, -421, -421, -421, -421, -421,

			 -421, -421, -421, -421, -421, -421, -421, -421, -421, -421,
			 -421, -421, -421, -421, -421, -421, -421, -421, -421, -421,
			 -421, -421, -421, -421, -421, -421, -421, -421, -421, -421,
			 -421, -421, -421, -421, -421, -421, -421, -421, -421, -421,
			 -421, -421, -421, -421, -421, -421, -421, -421, -421, -421,
			 -421, -421, -421, -421,    5, -422, -422, -422, -422, -422,
			 -422, -422, -422, -422, -422, -422, -422, -422, -422, -422,
			 -422, -422, -422, -422, -422, -422, -422, -422, -422, -422,
			 -422, -422, -422, -422, -422, -422, -422, -422, -422, -422,
			 -422, -422, -422, -422, -422, -422, -422, -422, -422, -422,

			 -422, -422,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -422, -422, -422, -422, -422, -422, -422,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -422, -422, -422, -422,  101,
			 -422,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -422, -422, -422,
			 -422, -422, -422, -422, -422, -422, -422, -422, -422, -422,
			 -422, -422, -422, -422, -422, -422, -422, -422, -422, -422,

			 -422, -422, -422, -422, -422, -422, -422, -422, -422, -422,
			 -422, -422, -422, -422, -422, -422, -422, -422, -422, -422,
			 -422, -422, -422, -422, -422, -422, -422, -422, -422, -422,
			 -422, -422, -422, -422, -422, -422, -422, -422, -422, -422,
			 -422, -422, -422, -422, -422, -422, -422, -422, -422, -422,
			 -422, -422, -422, -422, -422, -422, -422, -422, -422, -422,
			 -422, -422, -422, -422, -422, -422, -422, -422, -422, -422,
			 -422, -422, -422, -422, -422, -422, -422, -422, -422, -422,
			 -422, -422, -422, -422, -422, -422, -422, -422, -422, -422,
			 -422, -422, -422, -422, -422, -422, -422, -422, -422, -422,

			 -422, -422, -422, -422, -422, -422, -422, -422, -422, -422,
			 -422,    5, -423, -423, -423, -423, -423, -423, -423, -423,
			 -423, -423, -423, -423, -423, -423, -423, -423, -423, -423,
			 -423, -423, -423, -423, -423, -423, -423, -423, -423, -423,
			 -423, -423, -423, -423, -423, -423, -423, -423, -423, -423,
			 -423, -423, -423, -423, -423, -423, -423, -423, -423,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -423,
			 -423, -423, -423, -423, -423, -423,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  471,  101,  101,  101,  101,

			  101,  101, -423, -423, -423, -423,  101, -423,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  471,  101,  101,
			  101,  101,  101,  101, -423, -423, -423, -423, -423, -423,
			 -423, -423, -423, -423, -423, -423, -423, -423, -423, -423,
			 -423, -423, -423, -423, -423, -423, -423, -423, -423, -423,
			 -423, -423, -423, -423, -423, -423, -423, -423, -423, -423,
			 -423, -423, -423, -423, -423, -423, -423, -423, -423, -423,
			 -423, -423, -423, -423, -423, -423, -423, -423, -423, -423,
			 -423, -423, -423, -423, -423, -423, -423, -423, -423, -423,

			 -423, -423, -423, -423, -423, -423, -423, -423, -423, -423,
			 -423, -423, -423, -423, -423, -423, -423, -423, -423, -423,
			 -423, -423, -423, -423, -423, -423, -423, -423, -423, -423,
			 -423, -423, -423, -423, -423, -423, -423, -423, -423, -423,
			 -423, -423, -423, -423, -423, -423, -423, -423, -423, -423,
			 -423, -423, -423, -423, -423, -423, -423, -423, -423, -423,
			 -423, -423, -423, -423, -423, -423, -423, -423,    5, -424,
			 -424, -424, -424, -424, -424, -424, -424, -424, -424, -424,
			 -424, -424, -424, -424, -424, -424, -424, -424, -424, -424,
			 -424, -424, -424, -424, -424, -424, -424, -424, -424, -424,

			 -424, -424, -424, -424, -424, -424, -424, -424, -424, -424,
			 -424, -424, -424, -424, -424, -424,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -424, -424, -424, -424,
			 -424, -424, -424,  472,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -424,
			 -424, -424, -424,  101, -424,  472,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -424, -424, -424, -424, -424, -424, -424, -424, -424,

			 -424, -424, -424, -424, -424, -424, -424, -424, -424, -424,
			 -424, -424, -424, -424, -424, -424, -424, -424, -424, -424,
			 -424, -424, -424, -424, -424, -424, -424, -424, -424, -424,
			 -424, -424, -424, -424, -424, -424, -424, -424, -424, -424,
			 -424, -424, -424, -424, -424, -424, -424, -424, -424, -424,
			 -424, -424, -424, -424, -424, -424, -424, -424, -424, -424,
			 -424, -424, -424, -424, -424, -424, -424, -424, -424, -424,
			 -424, -424, -424, -424, -424, -424, -424, -424, -424, -424,
			 -424, -424, -424, -424, -424, -424, -424, -424, -424, -424,
			 -424, -424, -424, -424, -424, -424, -424, -424, -424, -424,

			 -424, -424, -424, -424, -424, -424, -424, -424, -424, -424,
			 -424, -424, -424, -424, -424, -424, -424, -424, -424, -424,
			 -424, -424, -424, -424, -424,    5, -425, -425, -425, -425,
			 -425, -425, -425, -425, -425, -425, -425, -425, -425, -425,
			 -425, -425, -425, -425, -425, -425, -425, -425, -425, -425,
			 -425, -425, -425, -425, -425, -425, -425, -425, -425, -425,
			 -425, -425, -425, -425, -425, -425, -425, -425, -425, -425,
			 -425, -425, -425,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -425, -425, -425, -425, -425, -425, -425,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -425, -425, -425, -425,
			  101, -425,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -425, -425,
			 -425, -425, -425, -425, -425, -425, -425, -425, -425, -425,
			 -425, -425, -425, -425, -425, -425, -425, -425, -425, -425,
			 -425, -425, -425, -425, -425, -425, -425, -425, -425, -425,
			 -425, -425, -425, -425, -425, -425, -425, -425, -425, -425,
			 -425, -425, -425, -425, -425, -425, -425, -425, -425, -425,

			 -425, -425, -425, -425, -425, -425, -425, -425, -425, -425,
			 -425, -425, -425, -425, -425, -425, -425, -425, -425, -425,
			 -425, -425, -425, -425, -425, -425, -425, -425, -425, -425,
			 -425, -425, -425, -425, -425, -425, -425, -425, -425, -425,
			 -425, -425, -425, -425, -425, -425, -425, -425, -425, -425,
			 -425, -425, -425, -425, -425, -425, -425, -425, -425, -425,
			 -425, -425, -425, -425, -425, -425, -425, -425, -425, -425,
			 -425, -425, -425, -425, -425, -425, -425, -425, -425, -425,
			 -425, -425,    5, -426, -426, -426, -426, -426, -426, -426,
			 -426, -426, -426, -426, -426, -426, -426, -426, -426, -426,

			 -426, -426, -426, -426, -426, -426, -426, -426, -426, -426,
			 -426, -426, -426, -426, -426, -426, -426, -426, -426, -426,
			 -426, -426, -426, -426, -426, -426, -426, -426, -426, -426,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -426, -426, -426, -426, -426, -426, -426,  101,  101,  101,
			  101,  101,  101,  101,  101,  473,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -426, -426, -426, -426,  101, -426,  101,
			  101,  101,  101,  101,  101,  101,  101,  473,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101, -426, -426, -426, -426, -426,
			 -426, -426, -426, -426, -426, -426, -426, -426, -426, -426,
			 -426, -426, -426, -426, -426, -426, -426, -426, -426, -426,
			 -426, -426, -426, -426, -426, -426, -426, -426, -426, -426,
			 -426, -426, -426, -426, -426, -426, -426, -426, -426, -426,
			 -426, -426, -426, -426, -426, -426, -426, -426, -426, -426,
			 -426, -426, -426, -426, -426, -426, -426, -426, -426, -426,
			 -426, -426, -426, -426, -426, -426, -426, -426, -426, -426,
			 -426, -426, -426, -426, -426, -426, -426, -426, -426, -426,
			 -426, -426, -426, -426, -426, -426, -426, -426, -426, -426,

			 -426, -426, -426, -426, -426, -426, -426, -426, -426, -426,
			 -426, -426, -426, -426, -426, -426, -426, -426, -426, -426,
			 -426, -426, -426, -426, -426, -426, -426, -426, -426, -426,
			 -426, -426, -426, -426, -426, -426, -426, -426, -426,    5,
			 -427, -427, -427, -427, -427, -427, -427, -427, -427, -427,
			 -427, -427, -427, -427, -427, -427, -427, -427, -427, -427,
			 -427, -427, -427, -427, -427, -427, -427, -427, -427, -427,
			 -427, -427, -427, -427, -427, -427, -427, -427, -427, -427,
			 -427, -427, -427, -427, -427, -427, -427,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -427, -427, -427,

			 -427, -427, -427, -427,  101,  101,  101,  101,  474,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -427, -427, -427, -427,  101, -427,  101,  101,  101,  101,
			  474,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -427, -427, -427, -427, -427, -427, -427, -427,
			 -427, -427, -427, -427, -427, -427, -427, -427, -427, -427,
			 -427, -427, -427, -427, -427, -427, -427, -427, -427, -427,
			 -427, -427, -427, -427, -427, -427, -427, -427, -427, -427,

			 -427, -427, -427, -427, -427, -427, -427, -427, -427, -427,
			 -427, -427, -427, -427, -427, -427, -427, -427, -427, -427,
			 -427, -427, -427, -427, -427, -427, -427, -427, -427, -427,
			 -427, -427, -427, -427, -427, -427, -427, -427, -427, -427,
			 -427, -427, -427, -427, -427, -427, -427, -427, -427, -427,
			 -427, -427, -427, -427, -427, -427, -427, -427, -427, -427,
			 -427, -427, -427, -427, -427, -427, -427, -427, -427, -427,
			 -427, -427, -427, -427, -427, -427, -427, -427, -427, -427,
			 -427, -427, -427, -427, -427, -427, -427, -427, -427, -427,
			 -427, -427, -427, -427, -427, -427,    5, -428, -428, -428,

			 -428, -428, -428, -428, -428, -428, -428, -428, -428, -428,
			 -428, -428, -428, -428, -428, -428, -428, -428, -428, -428,
			 -428, -428, -428, -428, -428, -428, -428, -428, -428, -428,
			 -428, -428, -428, -428, -428, -428, -428, -428, -428, -428,
			 -428, -428, -428, -428,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -428, -428, -428, -428, -428, -428,
			 -428,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -428, -428, -428,
			 -428,  101, -428,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -428,
			 -428, -428, -428, -428, -428, -428, -428, -428, -428, -428,
			 -428, -428, -428, -428, -428, -428, -428, -428, -428, -428,
			 -428, -428, -428, -428, -428, -428, -428, -428, -428, -428,
			 -428, -428, -428, -428, -428, -428, -428, -428, -428, -428,
			 -428, -428, -428, -428, -428, -428, -428, -428, -428, -428,
			 -428, -428, -428, -428, -428, -428, -428, -428, -428, -428,
			 -428, -428, -428, -428, -428, -428, -428, -428, -428, -428,
			 -428, -428, -428, -428, -428, -428, -428, -428, -428, -428,

			 -428, -428, -428, -428, -428, -428, -428, -428, -428, -428,
			 -428, -428, -428, -428, -428, -428, -428, -428, -428, -428,
			 -428, -428, -428, -428, -428, -428, -428, -428, -428, -428,
			 -428, -428, -428, -428, -428, -428, -428, -428, -428, -428,
			 -428, -428, -428, -428, -428, -428, -428, -428, -428, -428,
			 -428, -428, -428,    5, -429, -429, -429, -429, -429, -429,
			 -429, -429, -429, -429, -429, -429, -429, -429, -429, -429,
			 -429, -429, -429, -429, -429, -429, -429, -429, -429, -429,
			 -429, -429, -429, -429, -429, -429, -429, -429, -429, -429,
			 -429, -429, -429, -429, -429, -429, -429, -429, -429, -429,

			 -429,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -429, -429, -429, -429, -429, -429, -429,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  475,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -429, -429, -429, -429,  101, -429,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  475,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -429, -429, -429, -429,
			 -429, -429, -429, -429, -429, -429, -429, -429, -429, -429,
			 -429, -429, -429, -429, -429, -429, -429, -429, -429, -429,

			 -429, -429, -429, -429, -429, -429, -429, -429, -429, -429,
			 -429, -429, -429, -429, -429, -429, -429, -429, -429, -429,
			 -429, -429, -429, -429, -429, -429, -429, -429, -429, -429,
			 -429, -429, -429, -429, -429, -429, -429, -429, -429, -429,
			 -429, -429, -429, -429, -429, -429, -429, -429, -429, -429,
			 -429, -429, -429, -429, -429, -429, -429, -429, -429, -429,
			 -429, -429, -429, -429, -429, -429, -429, -429, -429, -429,
			 -429, -429, -429, -429, -429, -429, -429, -429, -429, -429,
			 -429, -429, -429, -429, -429, -429, -429, -429, -429, -429,
			 -429, -429, -429, -429, -429, -429, -429, -429, -429, -429,

			 -429, -429, -429, -429, -429, -429, -429, -429, -429, -429,
			    5,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			 -430,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   65,   64,   64, -430,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,  476,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,  476,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,    5,   64,   64,
			   64,   64,   64,   64,   64,   64,   64, -431,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   65,   64,   64, -431,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,  477,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,  477,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64, yy_Dummy>>,
			1, 3000, 108000)
		end

	yy_nxt_template_38 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,    5,   64,   64,   64,   64,   64,
			   64,   64,   64,   64, -432,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   65,   64,
			   64, -432,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,  478,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,  478,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,    5, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,

			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,

			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,

			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433, -433, -433,
			 -433, -433, -433, -433, -433, -433, -433, -433,    5, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434,  479, -434,  479, -434, -434,  480,  480,  480,  480,
			  480,  480,  480,  480,  480,  480, -434, -434, -434, -434,

			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,

			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434, -434, -434, -434, -434, -434,
			 -434, -434, -434, -434, -434,    5, -435, -435, -435, -435,

			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435, -435,  480,  480,  480,  480,  480,  480,  480,
			  480,  480,  480, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			  380, -435, -435, -435, -435, -435, -435, -435, -435, -435,

			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,

			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435, -435, -435, -435, -435, -435, -435, -435, -435,
			 -435, -435,    5, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,

			  481,  481,  481,  481,  481,  481,  481,  481,  481,  481,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,

			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,
			 -436, -436, -436, -436, -436, -436, -436, -436, -436, -436,

			 -436, -436, -436, -436, -436, -436, -436, -436, -436,    5,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437,  482, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,

			 -437, -437, -437, -437,  217, -437, -437, -437, -437, -437,
			  482, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,

			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437, -437, -437, -437, -437,
			 -437, -437, -437, -437, -437, -437,    5, -438, -438, -438,
			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,
			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,
			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,

			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,
			 -438, -438, -438, -438,  438,  438,  438,  438,  438,  438,
			  438,  438,  438,  438, -438, -438, -438, -438, -438, -438,
			 -438, -438, -438, -438, -438,  483, -438, -438, -438, -438,
			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,
			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,
			 -438, -438, -438, -438, -438, -438, -438,  483, -438, -438,
			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,
			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,
			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,

			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,
			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,
			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,
			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,
			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,
			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,
			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,
			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,
			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,
			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,

			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,
			 -438, -438, -438, -438, -438, -438, -438, -438, -438, -438,
			 -438, -438, -438,    5, -439, -439, -439, -439, -439, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			 -439,  484,  484,  484,  484,  484,  484,  484,  484,  484,
			  484, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,

			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439,  440, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,

			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			 -439, -439, -439, -439, -439, -439, -439, -439, -439, -439,
			    5, -440, -440, -440, -440, -440, -440, -440, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,

			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440, -440,  485,  485,
			  485,  485,  485,  485,  485,  485,  485,  485, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,

			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,

			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440, -440, -440, -440,
			 -440, -440, -440, -440, -440, -440, -440,    5, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441,  486,  486,  486,  486,  486,
			  486,  486,  486,  486,  486, -441, -441, -441, -441, -441,

			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,

			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441, -441, -441, -441, -441, -441, -441,
			 -441, -441, -441, -441,    5, -442, -442, -442, -442, -442,

			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442, -442,  487,  487,  487,  487,  487,  487,  487,  487,
			  487,  487, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442, -442, -442, -442, -442, -442, -442, -442, -442,  387,
			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,

			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,

			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442, -442, -442, -442, -442, -442, -442, -442, -442, -442,
			 -442,    5, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443,  488,

			  488,  488,  488,  488,  488,  488,  488,  488,  488, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443, yy_Dummy>>,
			1, 3000, 111000)
		end

	yy_nxt_template_39 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,
			 -443, -443, -443, -443, -443, -443, -443, -443, -443, -443,

			 -443, -443, -443, -443, -443, -443, -443, -443,    5, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444,  489, -444,  489, -444, -444,  487,  487,  487,  487,
			  487,  487,  487,  487,  487,  487, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,

			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,

			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444, -444, -444, -444, -444, -444,
			 -444, -444, -444, -444, -444,    5,  490,  490,  490,  490,
			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,
			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,
			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,

			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,
			  490, -445,  490,  491,  491,  491,  491,  491,  491,  491,
			  491,  491,  491,  490,  490,  490,  490,  490,  490,  490,
			  490,  490,  490,  490,  492,  490,  490,  490,  490,  490,
			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,
			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,
			  490,  490,  490,  490,  490,  490,  492,  490,  490,  490,
			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,
			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,
			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,

			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,
			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,
			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,
			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,
			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,
			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,
			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,
			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,
			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,
			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,

			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,
			  490,  490,  490,  490,  490,  490,  490,  490,  490,  490,
			  490,  490,    5, -446, -446, -446, -446, -446, -446, -446,
			 -446, -446, -446, -446, -446, -446, -446, -446, -446, -446,
			 -446, -446, -446, -446, -446, -446, -446, -446, -446, -446,
			 -446, -446, -446, -446, -446, -446, -446, -446, -446, -446,
			 -446, -446, -446, -446, -446, -446, -446, -446, -446, -446,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -446, -446, -446, -446, -446, -446, -446,  101,  101,  101,
			  101,  493,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -446, -446, -446, -446,  101, -446,  101,
			  101,  101,  101,  493,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -446, -446, -446, -446, -446,
			 -446, -446, -446, -446, -446, -446, -446, -446, -446, -446,
			 -446, -446, -446, -446, -446, -446, -446, -446, -446, -446,
			 -446, -446, -446, -446, -446, -446, -446, -446, -446, -446,
			 -446, -446, -446, -446, -446, -446, -446, -446, -446, -446,
			 -446, -446, -446, -446, -446, -446, -446, -446, -446, -446,

			 -446, -446, -446, -446, -446, -446, -446, -446, -446, -446,
			 -446, -446, -446, -446, -446, -446, -446, -446, -446, -446,
			 -446, -446, -446, -446, -446, -446, -446, -446, -446, -446,
			 -446, -446, -446, -446, -446, -446, -446, -446, -446, -446,
			 -446, -446, -446, -446, -446, -446, -446, -446, -446, -446,
			 -446, -446, -446, -446, -446, -446, -446, -446, -446, -446,
			 -446, -446, -446, -446, -446, -446, -446, -446, -446, -446,
			 -446, -446, -446, -446, -446, -446, -446, -446, -446,    5,
			 -447, -447, -447, -447, -447, -447, -447, -447, -447, -447,
			 -447, -447, -447, -447, -447, -447, -447, -447, -447, -447,

			 -447, -447, -447, -447, -447, -447, -447, -447, -447, -447,
			 -447, -447, -447, -447, -447, -447, -447, -447, -447, -447,
			 -447, -447, -447, -447, -447, -447, -447,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -447, -447, -447,
			 -447, -447, -447, -447,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  494,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -447, -447, -447, -447,  101, -447,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  494,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101, -447, -447, -447, -447, -447, -447, -447, -447,
			 -447, -447, -447, -447, -447, -447, -447, -447, -447, -447,
			 -447, -447, -447, -447, -447, -447, -447, -447, -447, -447,
			 -447, -447, -447, -447, -447, -447, -447, -447, -447, -447,
			 -447, -447, -447, -447, -447, -447, -447, -447, -447, -447,
			 -447, -447, -447, -447, -447, -447, -447, -447, -447, -447,
			 -447, -447, -447, -447, -447, -447, -447, -447, -447, -447,
			 -447, -447, -447, -447, -447, -447, -447, -447, -447, -447,
			 -447, -447, -447, -447, -447, -447, -447, -447, -447, -447,
			 -447, -447, -447, -447, -447, -447, -447, -447, -447, -447,

			 -447, -447, -447, -447, -447, -447, -447, -447, -447, -447,
			 -447, -447, -447, -447, -447, -447, -447, -447, -447, -447,
			 -447, -447, -447, -447, -447, -447, -447, -447, -447, -447,
			 -447, -447, -447, -447, -447, -447,    5, -448, -448, -448,
			 -448, -448, -448, -448, -448, -448, -448, -448, -448, -448,
			 -448, -448, -448, -448, -448, -448, -448, -448, -448, -448,
			 -448, -448, -448, -448, -448, -448, -448, -448, -448, -448,
			 -448, -448, -448, -448, -448, -448, -448, -448, -448, -448,
			 -448, -448, -448, -448,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -448, -448, -448, -448, -448, -448,

			 -448,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  495,  101,  101,  101,  101,  101,  101, -448, -448, -448,
			 -448,  101, -448,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  495,  101,  101,  101,  101,  101,  101, -448,
			 -448, -448, -448, -448, -448, -448, -448, -448, -448, -448,
			 -448, -448, -448, -448, -448, -448, -448, -448, -448, -448,
			 -448, -448, -448, -448, -448, -448, -448, -448, -448, -448,
			 -448, -448, -448, -448, -448, -448, -448, -448, -448, -448,

			 -448, -448, -448, -448, -448, -448, -448, -448, -448, -448,
			 -448, -448, -448, -448, -448, -448, -448, -448, -448, -448,
			 -448, -448, -448, -448, -448, -448, -448, -448, -448, -448,
			 -448, -448, -448, -448, -448, -448, -448, -448, -448, -448,
			 -448, -448, -448, -448, -448, -448, -448, -448, -448, -448,
			 -448, -448, -448, -448, -448, -448, -448, -448, -448, -448,
			 -448, -448, -448, -448, -448, -448, -448, -448, -448, -448,
			 -448, -448, -448, -448, -448, -448, -448, -448, -448, -448,
			 -448, -448, -448, -448, -448, -448, -448, -448, -448, -448,
			 -448, -448, -448,    5, -449, -449, -449, -449, -449, -449,

			 -449, -449, -449, -449, -449, -449, -449, -449, -449, -449,
			 -449, -449, -449, -449, -449, -449, -449, -449, -449, -449,
			 -449, -449, -449, -449, -449, -449, -449, -449, -449, -449,
			 -449, -449, -449, -449, -449, -449, -449, -449, -449, -449,
			 -449,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -449, -449, -449, -449, -449, -449, -449,  101,  101,
			  101,  101,  496,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -449, -449, -449, -449,  101, -449,
			  101,  101,  101,  101,  496,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -449, -449, -449, -449,
			 -449, -449, -449, -449, -449, -449, -449, -449, -449, -449,
			 -449, -449, -449, -449, -449, -449, -449, -449, -449, -449,
			 -449, -449, -449, -449, -449, -449, -449, -449, -449, -449,
			 -449, -449, -449, -449, -449, -449, -449, -449, -449, -449,
			 -449, -449, -449, -449, -449, -449, -449, -449, -449, -449,
			 -449, -449, -449, -449, -449, -449, -449, -449, -449, -449,
			 -449, -449, -449, -449, -449, -449, -449, -449, -449, -449,
			 -449, -449, -449, -449, -449, -449, -449, -449, -449, -449,

			 -449, -449, -449, -449, -449, -449, -449, -449, -449, -449,
			 -449, -449, -449, -449, -449, -449, -449, -449, -449, -449,
			 -449, -449, -449, -449, -449, -449, -449, -449, -449, -449,
			 -449, -449, -449, -449, -449, -449, -449, -449, -449, -449,
			 -449, -449, -449, -449, -449, -449, -449, -449, -449, -449,
			    5, -450, -450, -450, -450, -450, -450, -450, -450, -450,
			 -450, -450, -450, -450, -450, -450, -450, -450, -450, -450,
			 -450, -450, -450, -450, -450, -450, -450, -450, -450, -450,
			 -450, -450, -450, -450, -450, -450, -450, -450, -450, -450,
			 -450, -450, -450, -450, -450, -450, -450, -450,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101, -450, -450,
			 -450, -450, -450, -450, -450,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -450, -450, -450, -450,  101, -450,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -450, -450, -450, -450, -450, -450, -450,
			 -450, -450, -450, -450, -450, -450, -450, -450, -450, -450,
			 -450, -450, -450, -450, -450, -450, -450, -450, -450, -450,

			 -450, -450, -450, -450, -450, -450, -450, -450, -450, -450,
			 -450, -450, -450, -450, -450, -450, -450, -450, -450, -450,
			 -450, -450, -450, -450, -450, -450, -450, -450, -450, -450,
			 -450, -450, -450, -450, -450, -450, -450, -450, -450, -450,
			 -450, -450, -450, -450, -450, -450, -450, -450, -450, -450,
			 -450, -450, -450, -450, -450, -450, -450, -450, -450, -450,
			 -450, -450, -450, -450, -450, -450, -450, -450, -450, -450,
			 -450, -450, -450, -450, -450, -450, -450, -450, -450, -450,
			 -450, -450, -450, -450, -450, -450, -450, -450, -450, -450,
			 -450, -450, -450, -450, -450, -450, -450, -450, -450, -450,

			 -450, -450, -450, -450, -450, -450, -450,    5, -451, -451,
			 -451, -451, -451, -451, -451, -451, -451, -451, -451, -451,
			 -451, -451, -451, -451, -451, -451, -451, -451, -451, -451,
			 -451, -451, -451, -451, -451, -451, -451, -451, -451, -451,
			 -451, -451, -451, -451, -451, -451, -451, -451, -451, -451,
			 -451, -451, -451, -451, -451,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -451, -451, -451, -451, -451,
			 -451, -451,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -451, -451,

			 -451, -451,  101, -451,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -451, -451, -451, -451, -451, -451, -451, -451, -451, -451,
			 -451, -451, -451, -451, -451, -451, -451, -451, -451, -451,
			 -451, -451, -451, -451, -451, -451, -451, -451, -451, -451,
			 -451, -451, -451, -451, -451, -451, -451, -451, -451, -451,
			 -451, -451, -451, -451, -451, -451, -451, -451, -451, -451,
			 -451, -451, -451, -451, -451, -451, -451, -451, -451, -451,
			 -451, -451, -451, -451, -451, -451, -451, -451, -451, -451,

			 -451, -451, -451, -451, -451, -451, -451, -451, -451, -451,
			 -451, -451, -451, -451, -451, -451, -451, -451, -451, -451,
			 -451, -451, -451, -451, -451, -451, -451, -451, -451, -451,
			 -451, -451, -451, -451, -451, -451, -451, -451, -451, -451,
			 -451, -451, -451, -451, -451, -451, -451, -451, -451, -451,
			 -451, -451, -451, -451, -451, -451, -451, -451, -451, -451,
			 -451, -451, -451, -451,    5, -452, -452, -452, -452, -452,
			 -452, -452, -452, -452, -452, -452, -452, -452, -452, -452,
			 -452, -452, -452, -452, -452, -452, -452, -452, -452, -452,
			 -452, -452, -452, -452, -452, -452, -452, -452, -452, -452,

			 -452, -452, -452, -452, -452, -452, -452, -452, -452, -452,
			 -452, -452,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -452, -452, -452, -452, -452, -452, -452,  101,
			  101,  101,  101,  497,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -452, -452, -452, -452,  101,
			 -452,  101,  101,  101,  101,  497,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -452, -452, -452,
			 -452, -452, -452, -452, -452, -452, -452, -452, -452, -452,

			 -452, -452, -452, -452, -452, -452, -452, -452, -452, -452,
			 -452, -452, -452, -452, -452, -452, -452, -452, -452, -452,
			 -452, -452, -452, -452, -452, -452, -452, -452, -452, -452,
			 -452, -452, -452, -452, -452, -452, -452, -452, -452, -452,
			 -452, -452, -452, -452, -452, -452, -452, -452, -452, -452,
			 -452, -452, -452, -452, -452, -452, -452, -452, -452, -452,
			 -452, -452, -452, -452, -452, -452, -452, -452, -452, -452,
			 -452, -452, -452, -452, -452, -452, -452, -452, -452, -452,
			 -452, -452, -452, -452, -452, -452, -452, -452, -452, -452,
			 -452, -452, -452, -452, -452, -452, -452, -452, -452, -452,

			 -452, -452, -452, -452, -452, -452, -452, -452, -452, -452,
			 -452, -452, -452, -452, -452, -452, -452, -452, -452, -452,
			 -452,    5, -453, -453, -453, -453, -453, -453, -453, -453,
			 -453, -453, -453, -453, -453, -453, -453, -453, -453, -453,
			 -453, -453, -453, -453, -453, -453, -453, -453, -453, -453,
			 -453, -453, -453, -453, -453, -453, -453, -453, -453, -453,
			 -453, -453, -453, -453, -453, -453, -453, -453, -453,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -453,
			 -453, -453, -453, -453, -453, -453,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -453, -453, -453, -453,  101, -453,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -453, -453, -453, -453, -453, -453,
			 -453, -453, -453, -453, -453, -453, -453, -453, -453, -453,
			 -453, -453, -453, -453, -453, -453, -453, -453, -453, -453,
			 -453, -453, -453, -453, -453, -453, -453, -453, -453, -453,
			 -453, -453, -453, -453, -453, -453, -453, -453, -453, -453,
			 -453, -453, -453, -453, -453, -453, -453, -453, -453, -453,

			 -453, -453, -453, -453, -453, -453, -453, -453, -453, -453,
			 -453, -453, -453, -453, -453, -453, -453, -453, -453, -453,
			 -453, -453, -453, -453, -453, -453, -453, -453, -453, -453,
			 -453, -453, -453, -453, -453, -453, -453, -453, -453, -453,
			 -453, -453, -453, -453, -453, -453, -453, -453, -453, -453,
			 -453, -453, -453, -453, -453, -453, -453, -453, -453, -453,
			 -453, -453, -453, -453, -453, -453, -453, -453, -453, -453,
			 -453, -453, -453, -453, -453, -453, -453, -453,    5, -454,
			 -454, -454, -454, -454, -454, -454, -454, -454, -454, -454,
			 -454, -454, -454, -454, -454, -454, -454, -454, -454, -454,

			 -454, -454, -454, -454, -454, -454, -454, -454, -454, -454,
			 -454, -454, -454, -454, -454, -454, -454, -454, -454, -454,
			 -454, -454, -454, -454, -454, -454,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -454, -454, -454, -454,
			 -454, -454, -454,  498,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -454,
			 -454, -454, -454,  101, -454,  498,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101, -454, -454, -454, -454, -454, -454, -454, -454, -454,
			 -454, -454, -454, -454, -454, -454, -454, -454, -454, -454,
			 -454, -454, -454, -454, -454, -454, -454, -454, -454, -454,
			 -454, -454, -454, -454, -454, -454, -454, -454, -454, -454,
			 -454, -454, -454, -454, -454, -454, -454, -454, -454, -454,
			 -454, -454, -454, -454, -454, -454, -454, -454, -454, -454,
			 -454, -454, -454, -454, -454, -454, -454, -454, -454, -454,
			 -454, -454, -454, -454, -454, -454, -454, -454, -454, -454,
			 -454, -454, -454, -454, -454, -454, -454, -454, -454, -454,
			 -454, -454, -454, -454, -454, -454, -454, -454, -454, -454,

			 -454, -454, -454, -454, -454, -454, -454, -454, -454, -454,
			 -454, -454, -454, -454, -454, -454, -454, -454, -454, -454,
			 -454, -454, -454, -454, -454, -454, -454, -454, -454, -454,
			 -454, -454, -454, -454, -454,    5, -455, -455, -455, -455,
			 -455, -455, -455, -455, -455, -455, -455, -455, -455, -455,
			 -455, -455, -455, -455, -455, -455, -455, -455, -455, -455,
			 -455, -455, -455, -455, -455, -455, -455, -455, -455, -455,
			 -455, -455, -455, -455, -455, -455, -455, -455, -455, -455,
			 -455, -455, -455,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -455, -455, -455, -455, -455, -455, -455, yy_Dummy>>,
			1, 3000, 114000)
		end

	yy_nxt_template_40 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			  101,  101,  101,  101,  499,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -455, -455, -455, -455,
			  101, -455,  101,  101,  101,  101,  499,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -455, -455,
			 -455, -455, -455, -455, -455, -455, -455, -455, -455, -455,
			 -455, -455, -455, -455, -455, -455, -455, -455, -455, -455,
			 -455, -455, -455, -455, -455, -455, -455, -455, -455, -455,
			 -455, -455, -455, -455, -455, -455, -455, -455, -455, -455,

			 -455, -455, -455, -455, -455, -455, -455, -455, -455, -455,
			 -455, -455, -455, -455, -455, -455, -455, -455, -455, -455,
			 -455, -455, -455, -455, -455, -455, -455, -455, -455, -455,
			 -455, -455, -455, -455, -455, -455, -455, -455, -455, -455,
			 -455, -455, -455, -455, -455, -455, -455, -455, -455, -455,
			 -455, -455, -455, -455, -455, -455, -455, -455, -455, -455,
			 -455, -455, -455, -455, -455, -455, -455, -455, -455, -455,
			 -455, -455, -455, -455, -455, -455, -455, -455, -455, -455,
			 -455, -455, -455, -455, -455, -455, -455, -455, -455, -455,
			 -455, -455,    5, -456, -456, -456, -456, -456, -456, -456,

			 -456, -456, -456, -456, -456, -456, -456, -456, -456, -456,
			 -456, -456, -456, -456, -456, -456, -456, -456, -456, -456,
			 -456, -456, -456, -456, -456, -456, -456, -456, -456, -456,
			 -456, -456, -456, -456, -456, -456, -456, -456, -456, -456,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -456, -456, -456, -456, -456, -456, -456,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -456, -456, -456, -456,  101, -456,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -456, -456, -456, -456, -456,
			 -456, -456, -456, -456, -456, -456, -456, -456, -456, -456,
			 -456, -456, -456, -456, -456, -456, -456, -456, -456, -456,
			 -456, -456, -456, -456, -456, -456, -456, -456, -456, -456,
			 -456, -456, -456, -456, -456, -456, -456, -456, -456, -456,
			 -456, -456, -456, -456, -456, -456, -456, -456, -456, -456,
			 -456, -456, -456, -456, -456, -456, -456, -456, -456, -456,
			 -456, -456, -456, -456, -456, -456, -456, -456, -456, -456,
			 -456, -456, -456, -456, -456, -456, -456, -456, -456, -456,

			 -456, -456, -456, -456, -456, -456, -456, -456, -456, -456,
			 -456, -456, -456, -456, -456, -456, -456, -456, -456, -456,
			 -456, -456, -456, -456, -456, -456, -456, -456, -456, -456,
			 -456, -456, -456, -456, -456, -456, -456, -456, -456, -456,
			 -456, -456, -456, -456, -456, -456, -456, -456, -456,    5,
			 -457, -457, -457, -457, -457, -457, -457, -457, -457, -457,
			 -457, -457, -457, -457, -457, -457, -457, -457, -457, -457,
			 -457, -457, -457, -457, -457, -457, -457, -457, -457, -457,
			 -457, -457, -457, -457, -457, -457, -457, -457, -457, -457,
			 -457, -457, -457, -457, -457, -457, -457,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101, -457, -457, -457,
			 -457, -457, -457, -457,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  500,  101,  101,  101,  101,  101,  101,  101,
			 -457, -457, -457, -457,  101, -457,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  500,  101,  101,  101,  101,  101,
			  101,  101, -457, -457, -457, -457, -457, -457, -457, -457,
			 -457, -457, -457, -457, -457, -457, -457, -457, -457, -457,
			 -457, -457, -457, -457, -457, -457, -457, -457, -457, -457,

			 -457, -457, -457, -457, -457, -457, -457, -457, -457, -457,
			 -457, -457, -457, -457, -457, -457, -457, -457, -457, -457,
			 -457, -457, -457, -457, -457, -457, -457, -457, -457, -457,
			 -457, -457, -457, -457, -457, -457, -457, -457, -457, -457,
			 -457, -457, -457, -457, -457, -457, -457, -457, -457, -457,
			 -457, -457, -457, -457, -457, -457, -457, -457, -457, -457,
			 -457, -457, -457, -457, -457, -457, -457, -457, -457, -457,
			 -457, -457, -457, -457, -457, -457, -457, -457, -457, -457,
			 -457, -457, -457, -457, -457, -457, -457, -457, -457, -457,
			 -457, -457, -457, -457, -457, -457, -457, -457, -457, -457,

			 -457, -457, -457, -457, -457, -457,    5, -458, -458, -458,
			 -458, -458, -458, -458, -458, -458, -458, -458, -458, -458,
			 -458, -458, -458, -458, -458, -458, -458, -458, -458, -458,
			 -458, -458, -458, -458, -458, -458, -458, -458, -458, -458,
			 -458, -458, -458, -458, -458, -458, -458, -458, -458, -458,
			 -458, -458, -458, -458,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -458, -458, -458, -458, -458, -458,
			 -458,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  501,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -458, -458, -458,

			 -458,  101, -458,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  501,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -458,
			 -458, -458, -458, -458, -458, -458, -458, -458, -458, -458,
			 -458, -458, -458, -458, -458, -458, -458, -458, -458, -458,
			 -458, -458, -458, -458, -458, -458, -458, -458, -458, -458,
			 -458, -458, -458, -458, -458, -458, -458, -458, -458, -458,
			 -458, -458, -458, -458, -458, -458, -458, -458, -458, -458,
			 -458, -458, -458, -458, -458, -458, -458, -458, -458, -458,
			 -458, -458, -458, -458, -458, -458, -458, -458, -458, -458,

			 -458, -458, -458, -458, -458, -458, -458, -458, -458, -458,
			 -458, -458, -458, -458, -458, -458, -458, -458, -458, -458,
			 -458, -458, -458, -458, -458, -458, -458, -458, -458, -458,
			 -458, -458, -458, -458, -458, -458, -458, -458, -458, -458,
			 -458, -458, -458, -458, -458, -458, -458, -458, -458, -458,
			 -458, -458, -458, -458, -458, -458, -458, -458, -458, -458,
			 -458, -458, -458,    5, -459, -459, -459, -459, -459, -459,
			 -459, -459, -459, -459, -459, -459, -459, -459, -459, -459,
			 -459, -459, -459, -459, -459, -459, -459, -459, -459, -459,
			 -459, -459, -459, -459, -459, -459, -459, -459, -459, -459,

			 -459, -459, -459, -459, -459, -459, -459, -459, -459, -459,
			 -459,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -459, -459, -459, -459, -459, -459, -459,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  502,  101,  101,
			  101,  101,  101,  101, -459, -459, -459, -459,  101, -459,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  502,
			  101,  101,  101,  101,  101,  101, -459, -459, -459, -459,
			 -459, -459, -459, -459, -459, -459, -459, -459, -459, -459,

			 -459, -459, -459, -459, -459, -459, -459, -459, -459, -459,
			 -459, -459, -459, -459, -459, -459, -459, -459, -459, -459,
			 -459, -459, -459, -459, -459, -459, -459, -459, -459, -459,
			 -459, -459, -459, -459, -459, -459, -459, -459, -459, -459,
			 -459, -459, -459, -459, -459, -459, -459, -459, -459, -459,
			 -459, -459, -459, -459, -459, -459, -459, -459, -459, -459,
			 -459, -459, -459, -459, -459, -459, -459, -459, -459, -459,
			 -459, -459, -459, -459, -459, -459, -459, -459, -459, -459,
			 -459, -459, -459, -459, -459, -459, -459, -459, -459, -459,
			 -459, -459, -459, -459, -459, -459, -459, -459, -459, -459,

			 -459, -459, -459, -459, -459, -459, -459, -459, -459, -459,
			 -459, -459, -459, -459, -459, -459, -459, -459, -459, -459,
			    5, -460, -460, -460, -460, -460, -460, -460, -460, -460,
			 -460, -460, -460, -460, -460, -460, -460, -460, -460, -460,
			 -460, -460, -460, -460, -460, -460, -460, -460, -460, -460,
			 -460, -460, -460, -460, -460, -460, -460, -460, -460, -460,
			 -460, -460, -460, -460, -460, -460, -460, -460,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -460, -460,
			 -460, -460, -460, -460, -460,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  503,  101,  101,  101,  101,  101,
			  101, -460, -460, -460, -460,  101, -460,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  503,  101,  101,  101,
			  101,  101,  101, -460, -460, -460, -460, -460, -460, -460,
			 -460, -460, -460, -460, -460, -460, -460, -460, -460, -460,
			 -460, -460, -460, -460, -460, -460, -460, -460, -460, -460,
			 -460, -460, -460, -460, -460, -460, -460, -460, -460, -460,
			 -460, -460, -460, -460, -460, -460, -460, -460, -460, -460,
			 -460, -460, -460, -460, -460, -460, -460, -460, -460, -460,

			 -460, -460, -460, -460, -460, -460, -460, -460, -460, -460,
			 -460, -460, -460, -460, -460, -460, -460, -460, -460, -460,
			 -460, -460, -460, -460, -460, -460, -460, -460, -460, -460,
			 -460, -460, -460, -460, -460, -460, -460, -460, -460, -460,
			 -460, -460, -460, -460, -460, -460, -460, -460, -460, -460,
			 -460, -460, -460, -460, -460, -460, -460, -460, -460, -460,
			 -460, -460, -460, -460, -460, -460, -460, -460, -460, -460,
			 -460, -460, -460, -460, -460, -460, -460,    5, -461, -461,
			 -461, -461, -461, -461, -461, -461, -461, -461, -461, -461,
			 -461, -461, -461, -461, -461, -461, -461, -461, -461, -461,

			 -461, -461, -461, -461, -461, -461, -461, -461, -461, -461,
			 -461, -461, -461, -461, -461, -461, -461, -461, -461, -461,
			 -461, -461, -461, -461, -461,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -461, -461, -461, -461, -461,
			 -461, -461,  504,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -461, -461,
			 -461, -461,  101, -461,  504,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			 -461, -461, -461, -461, -461, -461, -461, -461, -461, -461,
			 -461, -461, -461, -461, -461, -461, -461, -461, -461, -461,
			 -461, -461, -461, -461, -461, -461, -461, -461, -461, -461,
			 -461, -461, -461, -461, -461, -461, -461, -461, -461, -461,
			 -461, -461, -461, -461, -461, -461, -461, -461, -461, -461,
			 -461, -461, -461, -461, -461, -461, -461, -461, -461, -461,
			 -461, -461, -461, -461, -461, -461, -461, -461, -461, -461,
			 -461, -461, -461, -461, -461, -461, -461, -461, -461, -461,
			 -461, -461, -461, -461, -461, -461, -461, -461, -461, -461,
			 -461, -461, -461, -461, -461, -461, -461, -461, -461, -461,

			 -461, -461, -461, -461, -461, -461, -461, -461, -461, -461,
			 -461, -461, -461, -461, -461, -461, -461, -461, -461, -461,
			 -461, -461, -461, -461, -461, -461, -461, -461, -461, -461,
			 -461, -461, -461, -461,    5, -462, -462, -462, -462, -462,
			 -462, -462, -462, -462, -462, -462, -462, -462, -462, -462,
			 -462, -462, -462, -462, -462, -462, -462, -462, -462, -462,
			 -462, -462, -462, -462, -462, -462, -462, -462, -462, -462,
			 -462, -462, -462, -462, -462, -462, -462, -462, -462, -462,
			 -462, -462,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -462, -462, -462, -462, -462, -462, -462,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -462, -462, -462, -462,  101,
			 -462,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -462, -462, -462,
			 -462, -462, -462, -462, -462, -462, -462, -462, -462, -462,
			 -462, -462, -462, -462, -462, -462, -462, -462, -462, -462,
			 -462, -462, -462, -462, -462, -462, -462, -462, -462, -462,
			 -462, -462, -462, -462, -462, -462, -462, -462, -462, -462,

			 -462, -462, -462, -462, -462, -462, -462, -462, -462, -462,
			 -462, -462, -462, -462, -462, -462, -462, -462, -462, -462,
			 -462, -462, -462, -462, -462, -462, -462, -462, -462, -462,
			 -462, -462, -462, -462, -462, -462, -462, -462, -462, -462,
			 -462, -462, -462, -462, -462, -462, -462, -462, -462, -462,
			 -462, -462, -462, -462, -462, -462, -462, -462, -462, -462,
			 -462, -462, -462, -462, -462, -462, -462, -462, -462, -462,
			 -462, -462, -462, -462, -462, -462, -462, -462, -462, -462,
			 -462, -462, -462, -462, -462, -462, -462, -462, -462, -462,
			 -462,    5, -463, -463, -463, -463, -463, -463, -463, -463,

			 -463, -463, -463, -463, -463, -463, -463, -463, -463, -463,
			 -463, -463, -463, -463, -463, -463, -463, -463, -463, -463,
			 -463, -463, -463, -463, -463, -463, -463, -463, -463, -463,
			 -463, -463, -463, -463, -463, -463, -463, -463, -463,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -463,
			 -463, -463, -463, -463, -463, -463,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  505,  101,  101,  101,  101,
			  101,  101, -463, -463, -463, -463,  101, -463,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  505,  101,  101,
			  101,  101,  101,  101, -463, -463, -463, -463, -463, -463,
			 -463, -463, -463, -463, -463, -463, -463, -463, -463, -463,
			 -463, -463, -463, -463, -463, -463, -463, -463, -463, -463,
			 -463, -463, -463, -463, -463, -463, -463, -463, -463, -463,
			 -463, -463, -463, -463, -463, -463, -463, -463, -463, -463,
			 -463, -463, -463, -463, -463, -463, -463, -463, -463, -463,
			 -463, -463, -463, -463, -463, -463, -463, -463, -463, -463,
			 -463, -463, -463, -463, -463, -463, -463, -463, -463, -463,
			 -463, -463, -463, -463, -463, -463, -463, -463, -463, -463,

			 -463, -463, -463, -463, -463, -463, -463, -463, -463, -463,
			 -463, -463, -463, -463, -463, -463, -463, -463, -463, -463,
			 -463, -463, -463, -463, -463, -463, -463, -463, -463, -463,
			 -463, -463, -463, -463, -463, -463, -463, -463, -463, -463,
			 -463, -463, -463, -463, -463, -463, -463, -463,    5, -464,
			 -464, -464, -464, -464, -464, -464, -464, -464, -464, -464,
			 -464, -464, -464, -464, -464, -464, -464, -464, -464, -464,
			 -464, -464, -464, -464, -464, -464, -464, -464, -464, -464,
			 -464, -464, -464, -464, -464, -464, -464, -464, -464, -464,
			 -464, -464, -464, -464, -464, -464,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101, -464, -464, -464, -464,
			 -464, -464, -464,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  506,  101,  101,  101,  101,  101,  101,  101, -464,
			 -464, -464, -464,  101, -464,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  506,  101,  101,  101,  101,  101,  101,
			  101, -464, -464, -464, -464, -464, -464, -464, -464, -464,
			 -464, -464, -464, -464, -464, -464, -464, -464, -464, -464,
			 -464, -464, -464, -464, -464, -464, -464, -464, -464, -464,

			 -464, -464, -464, -464, -464, -464, -464, -464, -464, -464,
			 -464, -464, -464, -464, -464, -464, -464, -464, -464, -464,
			 -464, -464, -464, -464, -464, -464, -464, -464, -464, -464,
			 -464, -464, -464, -464, -464, -464, -464, -464, -464, -464,
			 -464, -464, -464, -464, -464, -464, -464, -464, -464, -464,
			 -464, -464, -464, -464, -464, -464, -464, -464, -464, -464,
			 -464, -464, -464, -464, -464, -464, -464, -464, -464, -464,
			 -464, -464, -464, -464, -464, -464, -464, -464, -464, -464,
			 -464, -464, -464, -464, -464, -464, -464, -464, -464, -464,
			 -464, -464, -464, -464, -464, -464, -464, -464, -464, -464,

			 -464, -464, -464, -464, -464,    5, -465, -465, -465, -465,
			 -465, -465, -465, -465, -465, -465, -465, -465, -465, -465,
			 -465, -465, -465, -465, -465, -465, -465, -465, -465, -465,
			 -465, -465, -465, -465, -465, -465, -465, -465, -465, -465,
			 -465, -465, -465, -465, -465, -465, -465, -465, -465, -465,
			 -465, -465, -465,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -465, -465, -465, -465, -465, -465, -465,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -465, -465, -465, -465,

			  101, -465,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -465, -465,
			 -465, -465, -465, -465, -465, -465, -465, -465, -465, -465,
			 -465, -465, -465, -465, -465, -465, -465, -465, -465, -465,
			 -465, -465, -465, -465, -465, -465, -465, -465, -465, -465,
			 -465, -465, -465, -465, -465, -465, -465, -465, -465, -465,
			 -465, -465, -465, -465, -465, -465, -465, -465, -465, -465,
			 -465, -465, -465, -465, -465, -465, -465, -465, -465, -465,
			 -465, -465, -465, -465, -465, -465, -465, -465, -465, -465,

			 -465, -465, -465, -465, -465, -465, -465, -465, -465, -465,
			 -465, -465, -465, -465, -465, -465, -465, -465, -465, -465,
			 -465, -465, -465, -465, -465, -465, -465, -465, -465, -465,
			 -465, -465, -465, -465, -465, -465, -465, -465, -465, -465,
			 -465, -465, -465, -465, -465, -465, -465, -465, -465, -465,
			 -465, -465, -465, -465, -465, -465, -465, -465, -465, -465,
			 -465, -465,    5, -466, -466, -466, -466, -466, -466, -466,
			 -466, -466, -466, -466, -466, -466, -466, -466, -466, -466,
			 -466, -466, -466, -466, -466, -466, -466, -466, -466, -466,
			 -466, -466, -466, -466, -466, -466, -466, -466, -466, -466,

			 -466, -466, -466, -466, -466, -466, -466, -466, -466, -466,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -466, -466, -466, -466, -466, -466, -466,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  507,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -466, -466, -466, -466,  101, -466,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  507,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -466, -466, -466, -466, -466,
			 -466, -466, -466, -466, -466, -466, -466, -466, -466, -466,

			 -466, -466, -466, -466, -466, -466, -466, -466, -466, -466,
			 -466, -466, -466, -466, -466, -466, -466, -466, -466, -466,
			 -466, -466, -466, -466, -466, -466, -466, -466, -466, -466,
			 -466, -466, -466, -466, -466, -466, -466, -466, -466, -466,
			 -466, -466, -466, -466, -466, -466, -466, -466, -466, -466,
			 -466, -466, -466, -466, -466, -466, -466, -466, -466, -466,
			 -466, -466, -466, -466, -466, -466, -466, -466, -466, -466,
			 -466, -466, -466, -466, -466, -466, -466, -466, -466, -466,
			 -466, -466, -466, -466, -466, -466, -466, -466, -466, -466,
			 -466, -466, -466, -466, -466, -466, -466, -466, -466, -466, yy_Dummy>>,
			1, 3000, 117000)
		end

	yy_nxt_template_41 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -466, -466, -466, -466, -466, -466, -466, -466, -466, -466,
			 -466, -466, -466, -466, -466, -466, -466, -466, -466,    5,
			 -467, -467, -467, -467, -467, -467, -467, -467, -467, -467,
			 -467, -467, -467, -467, -467, -467, -467, -467, -467, -467,
			 -467, -467, -467, -467, -467, -467, -467, -467, -467, -467,
			 -467, -467, -467, -467, -467, -467, -467, -467, -467, -467,
			 -467, -467, -467, -467, -467, -467, -467,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -467, -467, -467,
			 -467, -467, -467, -467,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -467, -467, -467, -467,  101, -467,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -467, -467, -467, -467, -467, -467, -467, -467,
			 -467, -467, -467, -467, -467, -467, -467, -467, -467, -467,
			 -467, -467, -467, -467, -467, -467, -467, -467, -467, -467,
			 -467, -467, -467, -467, -467, -467, -467, -467, -467, -467,
			 -467, -467, -467, -467, -467, -467, -467, -467, -467, -467,
			 -467, -467, -467, -467, -467, -467, -467, -467, -467, -467,

			 -467, -467, -467, -467, -467, -467, -467, -467, -467, -467,
			 -467, -467, -467, -467, -467, -467, -467, -467, -467, -467,
			 -467, -467, -467, -467, -467, -467, -467, -467, -467, -467,
			 -467, -467, -467, -467, -467, -467, -467, -467, -467, -467,
			 -467, -467, -467, -467, -467, -467, -467, -467, -467, -467,
			 -467, -467, -467, -467, -467, -467, -467, -467, -467, -467,
			 -467, -467, -467, -467, -467, -467, -467, -467, -467, -467,
			 -467, -467, -467, -467, -467, -467,    5, -468, -468, -468,
			 -468, -468, -468, -468, -468, -468, -468, -468, -468, -468,
			 -468, -468, -468, -468, -468, -468, -468, -468, -468, -468,

			 -468, -468, -468, -468, -468, -468, -468, -468, -468, -468,
			 -468, -468, -468, -468, -468, -468, -468, -468, -468, -468,
			 -468, -468, -468, -468,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -468, -468, -468, -468, -468, -468,
			 -468,  101,  101,  101,  101,  508,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -468, -468, -468,
			 -468,  101, -468,  101,  101,  101,  101,  508,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -468,

			 -468, -468, -468, -468, -468, -468, -468, -468, -468, -468,
			 -468, -468, -468, -468, -468, -468, -468, -468, -468, -468,
			 -468, -468, -468, -468, -468, -468, -468, -468, -468, -468,
			 -468, -468, -468, -468, -468, -468, -468, -468, -468, -468,
			 -468, -468, -468, -468, -468, -468, -468, -468, -468, -468,
			 -468, -468, -468, -468, -468, -468, -468, -468, -468, -468,
			 -468, -468, -468, -468, -468, -468, -468, -468, -468, -468,
			 -468, -468, -468, -468, -468, -468, -468, -468, -468, -468,
			 -468, -468, -468, -468, -468, -468, -468, -468, -468, -468,
			 -468, -468, -468, -468, -468, -468, -468, -468, -468, -468,

			 -468, -468, -468, -468, -468, -468, -468, -468, -468, -468,
			 -468, -468, -468, -468, -468, -468, -468, -468, -468, -468,
			 -468, -468, -468, -468, -468, -468, -468, -468, -468, -468,
			 -468, -468, -468,    5, -469, -469, -469, -469, -469, -469,
			 -469, -469, -469, -469, -469, -469, -469, -469, -469, -469,
			 -469, -469, -469, -469, -469, -469, -469, -469, -469, -469,
			 -469, -469, -469, -469, -469, -469, -469, -469, -469, -469,
			 -469, -469, -469, -469, -469, -469, -469, -469, -469, -469,
			 -469,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -469, -469, -469, -469, -469, -469, -469,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -469, -469, -469, -469,  101, -469,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -469, -469, -469, -469,
			 -469, -469, -469, -469, -469, -469, -469, -469, -469, -469,
			 -469, -469, -469, -469, -469, -469, -469, -469, -469, -469,
			 -469, -469, -469, -469, -469, -469, -469, -469, -469, -469,
			 -469, -469, -469, -469, -469, -469, -469, -469, -469, -469,

			 -469, -469, -469, -469, -469, -469, -469, -469, -469, -469,
			 -469, -469, -469, -469, -469, -469, -469, -469, -469, -469,
			 -469, -469, -469, -469, -469, -469, -469, -469, -469, -469,
			 -469, -469, -469, -469, -469, -469, -469, -469, -469, -469,
			 -469, -469, -469, -469, -469, -469, -469, -469, -469, -469,
			 -469, -469, -469, -469, -469, -469, -469, -469, -469, -469,
			 -469, -469, -469, -469, -469, -469, -469, -469, -469, -469,
			 -469, -469, -469, -469, -469, -469, -469, -469, -469, -469,
			 -469, -469, -469, -469, -469, -469, -469, -469, -469, -469,
			    5, -470, -470, -470, -470, -470, -470, -470, -470, -470,

			 -470, -470, -470, -470, -470, -470, -470, -470, -470, -470,
			 -470, -470, -470, -470, -470, -470, -470, -470, -470, -470,
			 -470, -470, -470, -470, -470, -470, -470, -470, -470, -470,
			 -470, -470, -470, -470, -470, -470, -470, -470,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -470, -470,
			 -470, -470, -470, -470, -470,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -470, -470, -470, -470,  101, -470,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -470, -470, -470, -470, -470, -470, -470,
			 -470, -470, -470, -470, -470, -470, -470, -470, -470, -470,
			 -470, -470, -470, -470, -470, -470, -470, -470, -470, -470,
			 -470, -470, -470, -470, -470, -470, -470, -470, -470, -470,
			 -470, -470, -470, -470, -470, -470, -470, -470, -470, -470,
			 -470, -470, -470, -470, -470, -470, -470, -470, -470, -470,
			 -470, -470, -470, -470, -470, -470, -470, -470, -470, -470,
			 -470, -470, -470, -470, -470, -470, -470, -470, -470, -470,
			 -470, -470, -470, -470, -470, -470, -470, -470, -470, -470,

			 -470, -470, -470, -470, -470, -470, -470, -470, -470, -470,
			 -470, -470, -470, -470, -470, -470, -470, -470, -470, -470,
			 -470, -470, -470, -470, -470, -470, -470, -470, -470, -470,
			 -470, -470, -470, -470, -470, -470, -470, -470, -470, -470,
			 -470, -470, -470, -470, -470, -470, -470,    5, -471, -471,
			 -471, -471, -471, -471, -471, -471, -471, -471, -471, -471,
			 -471, -471, -471, -471, -471, -471, -471, -471, -471, -471,
			 -471, -471, -471, -471, -471, -471, -471, -471, -471, -471,
			 -471, -471, -471, -471, -471, -471, -471, -471, -471, -471,
			 -471, -471, -471, -471, -471,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101, -471, -471, -471, -471, -471,
			 -471, -471,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -471, -471,
			 -471, -471,  101, -471,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -471, -471, -471, -471, -471, -471, -471, -471, -471, -471,
			 -471, -471, -471, -471, -471, -471, -471, -471, -471, -471,
			 -471, -471, -471, -471, -471, -471, -471, -471, -471, -471,

			 -471, -471, -471, -471, -471, -471, -471, -471, -471, -471,
			 -471, -471, -471, -471, -471, -471, -471, -471, -471, -471,
			 -471, -471, -471, -471, -471, -471, -471, -471, -471, -471,
			 -471, -471, -471, -471, -471, -471, -471, -471, -471, -471,
			 -471, -471, -471, -471, -471, -471, -471, -471, -471, -471,
			 -471, -471, -471, -471, -471, -471, -471, -471, -471, -471,
			 -471, -471, -471, -471, -471, -471, -471, -471, -471, -471,
			 -471, -471, -471, -471, -471, -471, -471, -471, -471, -471,
			 -471, -471, -471, -471, -471, -471, -471, -471, -471, -471,
			 -471, -471, -471, -471, -471, -471, -471, -471, -471, -471,

			 -471, -471, -471, -471,    5, -472, -472, -472, -472, -472,
			 -472, -472, -472, -472, -472, -472, -472, -472, -472, -472,
			 -472, -472, -472, -472, -472, -472, -472, -472, -472, -472,
			 -472, -472, -472, -472, -472, -472, -472, -472, -472, -472,
			 -472, -472, -472, -472, -472, -472, -472, -472, -472, -472,
			 -472, -472,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -472, -472, -472, -472, -472, -472, -472,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  509,  101,
			  101,  101,  101,  101,  101, -472, -472, -472, -472,  101,

			 -472,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  509,  101,  101,  101,  101,  101,  101, -472, -472, -472,
			 -472, -472, -472, -472, -472, -472, -472, -472, -472, -472,
			 -472, -472, -472, -472, -472, -472, -472, -472, -472, -472,
			 -472, -472, -472, -472, -472, -472, -472, -472, -472, -472,
			 -472, -472, -472, -472, -472, -472, -472, -472, -472, -472,
			 -472, -472, -472, -472, -472, -472, -472, -472, -472, -472,
			 -472, -472, -472, -472, -472, -472, -472, -472, -472, -472,
			 -472, -472, -472, -472, -472, -472, -472, -472, -472, -472,

			 -472, -472, -472, -472, -472, -472, -472, -472, -472, -472,
			 -472, -472, -472, -472, -472, -472, -472, -472, -472, -472,
			 -472, -472, -472, -472, -472, -472, -472, -472, -472, -472,
			 -472, -472, -472, -472, -472, -472, -472, -472, -472, -472,
			 -472, -472, -472, -472, -472, -472, -472, -472, -472, -472,
			 -472, -472, -472, -472, -472, -472, -472, -472, -472, -472,
			 -472,    5, -473, -473, -473, -473, -473, -473, -473, -473,
			 -473, -473, -473, -473, -473, -473, -473, -473, -473, -473,
			 -473, -473, -473, -473, -473, -473, -473, -473, -473, -473,
			 -473, -473, -473, -473, -473, -473, -473, -473, -473, -473,

			 -473, -473, -473, -473, -473, -473, -473, -473, -473,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -473,
			 -473, -473, -473, -473, -473, -473,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  510,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -473, -473, -473, -473,  101, -473,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  510,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -473, -473, -473, -473, -473, -473,
			 -473, -473, -473, -473, -473, -473, -473, -473, -473, -473,

			 -473, -473, -473, -473, -473, -473, -473, -473, -473, -473,
			 -473, -473, -473, -473, -473, -473, -473, -473, -473, -473,
			 -473, -473, -473, -473, -473, -473, -473, -473, -473, -473,
			 -473, -473, -473, -473, -473, -473, -473, -473, -473, -473,
			 -473, -473, -473, -473, -473, -473, -473, -473, -473, -473,
			 -473, -473, -473, -473, -473, -473, -473, -473, -473, -473,
			 -473, -473, -473, -473, -473, -473, -473, -473, -473, -473,
			 -473, -473, -473, -473, -473, -473, -473, -473, -473, -473,
			 -473, -473, -473, -473, -473, -473, -473, -473, -473, -473,
			 -473, -473, -473, -473, -473, -473, -473, -473, -473, -473,

			 -473, -473, -473, -473, -473, -473, -473, -473, -473, -473,
			 -473, -473, -473, -473, -473, -473, -473, -473,    5, -474,
			 -474, -474, -474, -474, -474, -474, -474, -474, -474, -474,
			 -474, -474, -474, -474, -474, -474, -474, -474, -474, -474,
			 -474, -474, -474, -474, -474, -474, -474, -474, -474, -474,
			 -474, -474, -474, -474, -474, -474, -474, -474, -474, -474,
			 -474, -474, -474, -474, -474, -474,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -474, -474, -474, -474,
			 -474, -474, -474,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101, -474,
			 -474, -474, -474,  101, -474,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -474, -474, -474, -474, -474, -474, -474, -474, -474,
			 -474, -474, -474, -474, -474, -474, -474, -474, -474, -474,
			 -474, -474, -474, -474, -474, -474, -474, -474, -474, -474,
			 -474, -474, -474, -474, -474, -474, -474, -474, -474, -474,
			 -474, -474, -474, -474, -474, -474, -474, -474, -474, -474,
			 -474, -474, -474, -474, -474, -474, -474, -474, -474, -474,

			 -474, -474, -474, -474, -474, -474, -474, -474, -474, -474,
			 -474, -474, -474, -474, -474, -474, -474, -474, -474, -474,
			 -474, -474, -474, -474, -474, -474, -474, -474, -474, -474,
			 -474, -474, -474, -474, -474, -474, -474, -474, -474, -474,
			 -474, -474, -474, -474, -474, -474, -474, -474, -474, -474,
			 -474, -474, -474, -474, -474, -474, -474, -474, -474, -474,
			 -474, -474, -474, -474, -474, -474, -474, -474, -474, -474,
			 -474, -474, -474, -474, -474,    5, -475, -475, -475, -475,
			 -475, -475, -475, -475, -475, -475, -475, -475, -475, -475,
			 -475, -475, -475, -475, -475, -475, -475, -475, -475, -475,

			 -475, -475, -475, -475, -475, -475, -475, -475, -475, -475,
			 -475, -475, -475, -475, -475, -475, -475, -475, -475, -475,
			 -475, -475, -475,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -475, -475, -475, -475, -475, -475, -475,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  511,
			  101,  101,  101,  101,  101,  101, -475, -475, -475, -475,
			  101, -475,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  511,  101,  101,  101,  101,  101,  101, -475, -475,

			 -475, -475, -475, -475, -475, -475, -475, -475, -475, -475,
			 -475, -475, -475, -475, -475, -475, -475, -475, -475, -475,
			 -475, -475, -475, -475, -475, -475, -475, -475, -475, -475,
			 -475, -475, -475, -475, -475, -475, -475, -475, -475, -475,
			 -475, -475, -475, -475, -475, -475, -475, -475, -475, -475,
			 -475, -475, -475, -475, -475, -475, -475, -475, -475, -475,
			 -475, -475, -475, -475, -475, -475, -475, -475, -475, -475,
			 -475, -475, -475, -475, -475, -475, -475, -475, -475, -475,
			 -475, -475, -475, -475, -475, -475, -475, -475, -475, -475,
			 -475, -475, -475, -475, -475, -475, -475, -475, -475, -475,

			 -475, -475, -475, -475, -475, -475, -475, -475, -475, -475,
			 -475, -475, -475, -475, -475, -475, -475, -475, -475, -475,
			 -475, -475, -475, -475, -475, -475, -475, -475, -475, -475,
			 -475, -475,    5,   64,   64,   64,   64,   64,   64,   64,
			   64,   64, -476,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   65,   64,   64, -476,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,  512,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,  512,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,    5,
			   64,   64,   64,   64,   64,   64,   64,   64,   64, -477,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   65,   64,   64, -477,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,  513,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,  513,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,    5,   64,   64,   64,
			   64,   64,   64,   64,   64,   64, -478,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   65,   64,   64, -478,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,  514,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,  514,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64, yy_Dummy>>,
			1, 3000, 120000)
		end

	yy_nxt_template_42 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,    5, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479,  480,  480,  480,  480,  480,  480,  480,  480,  480,
			  480, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,

			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,

			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			 -479, -479, -479, -479, -479, -479, -479, -479, -479, -479,
			    5, -480, -480, -480, -480, -480, -480, -480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,

			 -480, -480, -480, -480, -480, -480, -480, -480,  480,  480,
			  480,  480,  480,  480,  480,  480,  480,  480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,

			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,

			 -480, -480, -480, -480, -480, -480, -480, -480, -480, -480,
			 -480, -480, -480, -480, -480, -480, -480,    5, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481,  515,  515,  515,  515,  515,
			  515,  515,  515,  515,  515, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,

			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,

			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481, -481, -481, -481, -481, -481, -481,
			 -481, -481, -481, -481,    5, -482, -482, -482, -482, -482,
			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,
			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,

			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,
			 -482, -482, -482, -482, -482, -482, -482,  516, -482,  516,
			 -482, -482,  517,  517,  517,  517,  517,  517,  517,  517,
			  517,  517, -482, -482, -482, -482, -482, -482, -482, -482,
			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,
			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,
			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,
			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,
			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,
			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,

			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,
			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,
			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,
			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,
			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,
			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,
			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,
			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,
			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,
			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,

			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,
			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,
			 -482, -482, -482, -482, -482, -482, -482, -482, -482, -482,
			 -482,    5, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483,  518, -483,  518, -483, -483,  519,
			  519,  519,  519,  519,  519,  519,  519,  519,  519, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,

			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,

			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483, -483, -483,
			 -483, -483, -483, -483, -483, -483, -483, -483,    5, -484,
			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,

			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,
			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,
			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,
			 -484, -484, -484, -484, -484, -484,  519,  519,  519,  519,
			  519,  519,  519,  519,  519,  519, -484, -484, -484, -484,
			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,
			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,
			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,
			 -484, -484, -484,  440, -484, -484, -484, -484, -484, -484,
			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,

			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,
			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,
			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,
			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,
			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,
			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,
			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,
			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,
			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,
			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,

			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,
			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,
			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,
			 -484, -484, -484, -484, -484, -484, -484, -484, -484, -484,
			 -484, -484, -484, -484, -484,    5, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485,  520,  520,  520,  520,  520,  520,  520,

			  520,  520,  520, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,

			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,
			 -485, -485, -485, -485, -485, -485, -485, -485, -485, -485,

			 -485, -485,    5, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486,  521, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486,  317, -486, -486,

			 -486, -486, -486,  521, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,

			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486, -486,
			 -486, -486, -486, -486, -486, -486, -486, -486, -486,    5,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,

			 -487, -487, -487, -487, -487, -487, -487,  487,  487,  487,
			  487,  487,  487,  487,  487,  487,  487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,

			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,

			 -487, -487, -487, -487, -487, -487, -487, -487, -487, -487,
			 -487, -487, -487, -487, -487, -487,    5, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488,  522,  522,  522,  522,  522,  522,
			  522,  522,  522,  522, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,

			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,

			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488, -488, -488, -488, -488, -488, -488, -488,
			 -488, -488, -488,    5, -489, -489, -489, -489, -489, -489,
			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,

			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			 -489,  487,  487,  487,  487,  487,  487,  487,  487,  487,
			  487, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,

			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,

			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			 -489, -489, -489, -489, -489, -489, -489, -489, -489, -489,
			    5, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490, yy_Dummy>>,
			1, 3000, 123000)
		end

	yy_nxt_template_43 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,

			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490, -490, -490, -490,
			 -490, -490, -490, -490, -490, -490, -490,    5, -491, -491,
			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,

			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,
			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,
			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,
			 -491, -491, -491, -491, -491,  523,  523,  523,  523,  523,
			  523,  523,  523,  523,  523, -491, -491, -491, -491, -491,
			 -491, -491, -491, -491, -491, -491,  521, -491, -491, -491,
			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,
			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,
			 -491, -491,  317, -491, -491, -491, -491, -491,  521, -491,
			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,

			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,
			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,
			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,
			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,
			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,
			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,
			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,
			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,
			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,
			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,

			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,
			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,
			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,
			 -491, -491, -491, -491, -491, -491, -491, -491, -491, -491,
			 -491, -491, -491, -491,    5, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492,  524, -492,  524,
			 -492, -492,  525,  525,  525,  525,  525,  525,  525,  525,

			  525,  525, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,

			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,
			 -492, -492, -492, -492, -492, -492, -492, -492, -492, -492,

			 -492,    5, -493, -493, -493, -493, -493, -493, -493, -493,
			 -493, -493, -493, -493, -493, -493, -493, -493, -493, -493,
			 -493, -493, -493, -493, -493, -493, -493, -493, -493, -493,
			 -493, -493, -493, -493, -493, -493, -493, -493, -493, -493,
			 -493, -493, -493, -493, -493, -493, -493, -493, -493,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -493,
			 -493, -493, -493, -493, -493, -493,  101,  101,  101,  526,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -493, -493, -493, -493,  101, -493,  101,  101,

			  101,  526,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -493, -493, -493, -493, -493, -493,
			 -493, -493, -493, -493, -493, -493, -493, -493, -493, -493,
			 -493, -493, -493, -493, -493, -493, -493, -493, -493, -493,
			 -493, -493, -493, -493, -493, -493, -493, -493, -493, -493,
			 -493, -493, -493, -493, -493, -493, -493, -493, -493, -493,
			 -493, -493, -493, -493, -493, -493, -493, -493, -493, -493,
			 -493, -493, -493, -493, -493, -493, -493, -493, -493, -493,
			 -493, -493, -493, -493, -493, -493, -493, -493, -493, -493,

			 -493, -493, -493, -493, -493, -493, -493, -493, -493, -493,
			 -493, -493, -493, -493, -493, -493, -493, -493, -493, -493,
			 -493, -493, -493, -493, -493, -493, -493, -493, -493, -493,
			 -493, -493, -493, -493, -493, -493, -493, -493, -493, -493,
			 -493, -493, -493, -493, -493, -493, -493, -493, -493, -493,
			 -493, -493, -493, -493, -493, -493, -493, -493,    5, -494,
			 -494, -494, -494, -494, -494, -494, -494, -494, -494, -494,
			 -494, -494, -494, -494, -494, -494, -494, -494, -494, -494,
			 -494, -494, -494, -494, -494, -494, -494, -494, -494, -494,
			 -494, -494, -494, -494, -494, -494, -494, -494, -494, -494,

			 -494, -494, -494, -494, -494, -494,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -494, -494, -494, -494,
			 -494, -494, -494,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  527,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -494,
			 -494, -494, -494,  101, -494,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  527,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -494, -494, -494, -494, -494, -494, -494, -494, -494,
			 -494, -494, -494, -494, -494, -494, -494, -494, -494, -494,

			 -494, -494, -494, -494, -494, -494, -494, -494, -494, -494,
			 -494, -494, -494, -494, -494, -494, -494, -494, -494, -494,
			 -494, -494, -494, -494, -494, -494, -494, -494, -494, -494,
			 -494, -494, -494, -494, -494, -494, -494, -494, -494, -494,
			 -494, -494, -494, -494, -494, -494, -494, -494, -494, -494,
			 -494, -494, -494, -494, -494, -494, -494, -494, -494, -494,
			 -494, -494, -494, -494, -494, -494, -494, -494, -494, -494,
			 -494, -494, -494, -494, -494, -494, -494, -494, -494, -494,
			 -494, -494, -494, -494, -494, -494, -494, -494, -494, -494,
			 -494, -494, -494, -494, -494, -494, -494, -494, -494, -494,

			 -494, -494, -494, -494, -494, -494, -494, -494, -494, -494,
			 -494, -494, -494, -494, -494,    5, -495, -495, -495, -495,
			 -495, -495, -495, -495, -495, -495, -495, -495, -495, -495,
			 -495, -495, -495, -495, -495, -495, -495, -495, -495, -495,
			 -495, -495, -495, -495, -495, -495, -495, -495, -495, -495,
			 -495, -495, -495, -495, -495, -495, -495, -495, -495, -495,
			 -495, -495, -495,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -495, -495, -495, -495, -495, -495, -495,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101, -495, -495, -495, -495,
			  101, -495,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -495, -495,
			 -495, -495, -495, -495, -495, -495, -495, -495, -495, -495,
			 -495, -495, -495, -495, -495, -495, -495, -495, -495, -495,
			 -495, -495, -495, -495, -495, -495, -495, -495, -495, -495,
			 -495, -495, -495, -495, -495, -495, -495, -495, -495, -495,
			 -495, -495, -495, -495, -495, -495, -495, -495, -495, -495,
			 -495, -495, -495, -495, -495, -495, -495, -495, -495, -495,

			 -495, -495, -495, -495, -495, -495, -495, -495, -495, -495,
			 -495, -495, -495, -495, -495, -495, -495, -495, -495, -495,
			 -495, -495, -495, -495, -495, -495, -495, -495, -495, -495,
			 -495, -495, -495, -495, -495, -495, -495, -495, -495, -495,
			 -495, -495, -495, -495, -495, -495, -495, -495, -495, -495,
			 -495, -495, -495, -495, -495, -495, -495, -495, -495, -495,
			 -495, -495, -495, -495, -495, -495, -495, -495, -495, -495,
			 -495, -495,    5, -496, -496, -496, -496, -496, -496, -496,
			 -496, -496, -496, -496, -496, -496, -496, -496, -496, -496,
			 -496, -496, -496, -496, -496, -496, -496, -496, -496, -496,

			 -496, -496, -496, -496, -496, -496, -496, -496, -496, -496,
			 -496, -496, -496, -496, -496, -496, -496, -496, -496, -496,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -496, -496, -496, -496, -496, -496, -496,  101,  101,  101,
			  528,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -496, -496, -496, -496,  101, -496,  101,
			  101,  101,  528,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -496, -496, -496, -496, -496,

			 -496, -496, -496, -496, -496, -496, -496, -496, -496, -496,
			 -496, -496, -496, -496, -496, -496, -496, -496, -496, -496,
			 -496, -496, -496, -496, -496, -496, -496, -496, -496, -496,
			 -496, -496, -496, -496, -496, -496, -496, -496, -496, -496,
			 -496, -496, -496, -496, -496, -496, -496, -496, -496, -496,
			 -496, -496, -496, -496, -496, -496, -496, -496, -496, -496,
			 -496, -496, -496, -496, -496, -496, -496, -496, -496, -496,
			 -496, -496, -496, -496, -496, -496, -496, -496, -496, -496,
			 -496, -496, -496, -496, -496, -496, -496, -496, -496, -496,
			 -496, -496, -496, -496, -496, -496, -496, -496, -496, -496,

			 -496, -496, -496, -496, -496, -496, -496, -496, -496, -496,
			 -496, -496, -496, -496, -496, -496, -496, -496, -496, -496,
			 -496, -496, -496, -496, -496, -496, -496, -496, -496,    5,
			 -497, -497, -497, -497, -497, -497, -497, -497, -497, -497,
			 -497, -497, -497, -497, -497, -497, -497, -497, -497, -497,
			 -497, -497, -497, -497, -497, -497, -497, -497, -497, -497,
			 -497, -497, -497, -497, -497, -497, -497, -497, -497, -497,
			 -497, -497, -497, -497, -497, -497, -497,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -497, -497, -497,
			 -497, -497, -497, -497,  101,  101,  101,  529,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -497, -497, -497, -497,  101, -497,  101,  101,  101,  529,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -497, -497, -497, -497, -497, -497, -497, -497,
			 -497, -497, -497, -497, -497, -497, -497, -497, -497, -497,
			 -497, -497, -497, -497, -497, -497, -497, -497, -497, -497,
			 -497, -497, -497, -497, -497, -497, -497, -497, -497, -497,
			 -497, -497, -497, -497, -497, -497, -497, -497, -497, -497,

			 -497, -497, -497, -497, -497, -497, -497, -497, -497, -497,
			 -497, -497, -497, -497, -497, -497, -497, -497, -497, -497,
			 -497, -497, -497, -497, -497, -497, -497, -497, -497, -497,
			 -497, -497, -497, -497, -497, -497, -497, -497, -497, -497,
			 -497, -497, -497, -497, -497, -497, -497, -497, -497, -497,
			 -497, -497, -497, -497, -497, -497, -497, -497, -497, -497,
			 -497, -497, -497, -497, -497, -497, -497, -497, -497, -497,
			 -497, -497, -497, -497, -497, -497, -497, -497, -497, -497,
			 -497, -497, -497, -497, -497, -497,    5, -498, -498, -498,
			 -498, -498, -498, -498, -498, -498, -498, -498, -498, -498,

			 -498, -498, -498, -498, -498, -498, -498, -498, -498, -498,
			 -498, -498, -498, -498, -498, -498, -498, -498, -498, -498,
			 -498, -498, -498, -498, -498, -498, -498, -498, -498, -498,
			 -498, -498, -498, -498,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -498, -498, -498, -498, -498, -498,
			 -498,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  530,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -498, -498, -498,
			 -498,  101, -498,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  530,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101, -498,
			 -498, -498, -498, -498, -498, -498, -498, -498, -498, -498,
			 -498, -498, -498, -498, -498, -498, -498, -498, -498, -498,
			 -498, -498, -498, -498, -498, -498, -498, -498, -498, -498,
			 -498, -498, -498, -498, -498, -498, -498, -498, -498, -498,
			 -498, -498, -498, -498, -498, -498, -498, -498, -498, -498,
			 -498, -498, -498, -498, -498, -498, -498, -498, -498, -498,
			 -498, -498, -498, -498, -498, -498, -498, -498, -498, -498,
			 -498, -498, -498, -498, -498, -498, -498, -498, -498, -498,
			 -498, -498, -498, -498, -498, -498, -498, -498, -498, -498,

			 -498, -498, -498, -498, -498, -498, -498, -498, -498, -498,
			 -498, -498, -498, -498, -498, -498, -498, -498, -498, -498,
			 -498, -498, -498, -498, -498, -498, -498, -498, -498, -498,
			 -498, -498, -498, -498, -498, -498, -498, -498, -498, -498,
			 -498, -498, -498,    5, -499, -499, -499, -499, -499, -499,
			 -499, -499, -499, -499, -499, -499, -499, -499, -499, -499,
			 -499, -499, -499, -499, -499, -499, -499, -499, -499, -499,
			 -499, -499, -499, -499, -499, -499, -499, -499, -499, -499,
			 -499, -499, -499, -499, -499, -499, -499, -499, -499, -499,
			 -499,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101, -499, -499, -499, -499, -499, -499, -499,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -499, -499, -499, -499,  101, -499,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -499, -499, -499, -499,
			 -499, -499, -499, -499, -499, -499, -499, -499, -499, -499,
			 -499, -499, -499, -499, -499, -499, -499, -499, -499, -499,
			 -499, -499, -499, -499, -499, -499, -499, -499, -499, -499,

			 -499, -499, -499, -499, -499, -499, -499, -499, -499, -499,
			 -499, -499, -499, -499, -499, -499, -499, -499, -499, -499,
			 -499, -499, -499, -499, -499, -499, -499, -499, -499, -499,
			 -499, -499, -499, -499, -499, -499, -499, -499, -499, -499,
			 -499, -499, -499, -499, -499, -499, -499, -499, -499, -499,
			 -499, -499, -499, -499, -499, -499, -499, -499, -499, -499,
			 -499, -499, -499, -499, -499, -499, -499, -499, -499, -499,
			 -499, -499, -499, -499, -499, -499, -499, -499, -499, -499,
			 -499, -499, -499, -499, -499, -499, -499, -499, -499, -499,
			 -499, -499, -499, -499, -499, -499, -499, -499, -499, -499,

			    5, -500, -500, -500, -500, -500, -500, -500, -500, -500,
			 -500, -500, -500, -500, -500, -500, -500, -500, -500, -500,
			 -500, -500, -500, -500, -500, -500, -500, -500, -500, -500,
			 -500, -500, -500, -500, -500, -500, -500, -500, -500, -500,
			 -500, -500, -500, -500, -500, -500, -500, -500,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -500, -500,
			 -500, -500, -500, -500, -500,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -500, -500, -500, -500,  101, -500,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -500, -500, -500, -500, -500, -500, -500,
			 -500, -500, -500, -500, -500, -500, -500, -500, -500, -500,
			 -500, -500, -500, -500, -500, -500, -500, -500, -500, -500,
			 -500, -500, -500, -500, -500, -500, -500, -500, -500, -500,
			 -500, -500, -500, -500, -500, -500, -500, -500, -500, -500,
			 -500, -500, -500, -500, -500, -500, -500, -500, -500, -500,
			 -500, -500, -500, -500, -500, -500, -500, -500, -500, -500,
			 -500, -500, -500, -500, -500, -500, -500, -500, -500, -500,

			 -500, -500, -500, -500, -500, -500, -500, -500, -500, -500,
			 -500, -500, -500, -500, -500, -500, -500, -500, -500, -500,
			 -500, -500, -500, -500, -500, -500, -500, -500, -500, -500,
			 -500, -500, -500, -500, -500, -500, -500, -500, -500, -500,
			 -500, -500, -500, -500, -500, -500, -500, -500, -500, -500,
			 -500, -500, -500, -500, -500, -500, -500,    5, -501, -501,
			 -501, -501, -501, -501, -501, -501, -501, -501, -501, -501,
			 -501, -501, -501, -501, -501, -501, -501, -501, -501, -501,
			 -501, -501, -501, -501, -501, -501, -501, -501, -501, -501,
			 -501, -501, -501, -501, -501, -501, -501, -501, -501, -501,

			 -501, -501, -501, -501, -501,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -501, -501, -501, -501, -501,
			 -501, -501,  101,  101,  101,  101,  101,  101,  531,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -501, -501,
			 -501, -501,  101, -501,  101,  101,  101,  101,  101,  101,
			  531,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -501, -501, -501, -501, -501, -501, -501, -501, -501, -501,
			 -501, -501, -501, -501, -501, -501, -501, -501, -501, -501,

			 -501, -501, -501, -501, -501, -501, -501, -501, -501, -501,
			 -501, -501, -501, -501, -501, -501, -501, -501, -501, -501,
			 -501, -501, -501, -501, -501, -501, -501, -501, -501, -501,
			 -501, -501, -501, -501, -501, -501, -501, -501, -501, -501,
			 -501, -501, -501, -501, -501, -501, -501, -501, -501, -501,
			 -501, -501, -501, -501, -501, -501, -501, -501, -501, -501,
			 -501, -501, -501, -501, -501, -501, -501, -501, -501, -501,
			 -501, -501, -501, -501, -501, -501, -501, -501, -501, -501,
			 -501, -501, -501, -501, -501, -501, -501, -501, -501, -501,
			 -501, -501, -501, -501, -501, -501, -501, -501, -501, -501, yy_Dummy>>,
			1, 3000, 126000)
		end

	yy_nxt_template_44 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -501, -501, -501, -501, -501, -501, -501, -501, -501, -501,
			 -501, -501, -501, -501,    5, -502, -502, -502, -502, -502,
			 -502, -502, -502, -502, -502, -502, -502, -502, -502, -502,
			 -502, -502, -502, -502, -502, -502, -502, -502, -502, -502,
			 -502, -502, -502, -502, -502, -502, -502, -502, -502, -502,
			 -502, -502, -502, -502, -502, -502, -502, -502, -502, -502,
			 -502, -502,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -502, -502, -502, -502, -502, -502, -502,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101, -502, -502, -502, -502,  101,
			 -502,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -502, -502, -502,
			 -502, -502, -502, -502, -502, -502, -502, -502, -502, -502,
			 -502, -502, -502, -502, -502, -502, -502, -502, -502, -502,
			 -502, -502, -502, -502, -502, -502, -502, -502, -502, -502,
			 -502, -502, -502, -502, -502, -502, -502, -502, -502, -502,
			 -502, -502, -502, -502, -502, -502, -502, -502, -502, -502,
			 -502, -502, -502, -502, -502, -502, -502, -502, -502, -502,

			 -502, -502, -502, -502, -502, -502, -502, -502, -502, -502,
			 -502, -502, -502, -502, -502, -502, -502, -502, -502, -502,
			 -502, -502, -502, -502, -502, -502, -502, -502, -502, -502,
			 -502, -502, -502, -502, -502, -502, -502, -502, -502, -502,
			 -502, -502, -502, -502, -502, -502, -502, -502, -502, -502,
			 -502, -502, -502, -502, -502, -502, -502, -502, -502, -502,
			 -502, -502, -502, -502, -502, -502, -502, -502, -502, -502,
			 -502,    5, -503, -503, -503, -503, -503, -503, -503, -503,
			 -503, -503, -503, -503, -503, -503, -503, -503, -503, -503,
			 -503, -503, -503, -503, -503, -503, -503, -503, -503, -503,

			 -503, -503, -503, -503, -503, -503, -503, -503, -503, -503,
			 -503, -503, -503, -503, -503, -503, -503, -503, -503,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -503,
			 -503, -503, -503, -503, -503, -503,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -503, -503, -503, -503,  101, -503,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -503, -503, -503, -503, -503, -503,

			 -503, -503, -503, -503, -503, -503, -503, -503, -503, -503,
			 -503, -503, -503, -503, -503, -503, -503, -503, -503, -503,
			 -503, -503, -503, -503, -503, -503, -503, -503, -503, -503,
			 -503, -503, -503, -503, -503, -503, -503, -503, -503, -503,
			 -503, -503, -503, -503, -503, -503, -503, -503, -503, -503,
			 -503, -503, -503, -503, -503, -503, -503, -503, -503, -503,
			 -503, -503, -503, -503, -503, -503, -503, -503, -503, -503,
			 -503, -503, -503, -503, -503, -503, -503, -503, -503, -503,
			 -503, -503, -503, -503, -503, -503, -503, -503, -503, -503,
			 -503, -503, -503, -503, -503, -503, -503, -503, -503, -503,

			 -503, -503, -503, -503, -503, -503, -503, -503, -503, -503,
			 -503, -503, -503, -503, -503, -503, -503, -503, -503, -503,
			 -503, -503, -503, -503, -503, -503, -503, -503,    5, -504,
			 -504, -504, -504, -504, -504, -504, -504, -504, -504, -504,
			 -504, -504, -504, -504, -504, -504, -504, -504, -504, -504,
			 -504, -504, -504, -504, -504, -504, -504, -504, -504, -504,
			 -504, -504, -504, -504, -504, -504, -504, -504, -504, -504,
			 -504, -504, -504, -504, -504, -504,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -504, -504, -504, -504,
			 -504, -504, -504,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  532,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -504,
			 -504, -504, -504,  101, -504,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  532,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -504, -504, -504, -504, -504, -504, -504, -504, -504,
			 -504, -504, -504, -504, -504, -504, -504, -504, -504, -504,
			 -504, -504, -504, -504, -504, -504, -504, -504, -504, -504,
			 -504, -504, -504, -504, -504, -504, -504, -504, -504, -504,
			 -504, -504, -504, -504, -504, -504, -504, -504, -504, -504,

			 -504, -504, -504, -504, -504, -504, -504, -504, -504, -504,
			 -504, -504, -504, -504, -504, -504, -504, -504, -504, -504,
			 -504, -504, -504, -504, -504, -504, -504, -504, -504, -504,
			 -504, -504, -504, -504, -504, -504, -504, -504, -504, -504,
			 -504, -504, -504, -504, -504, -504, -504, -504, -504, -504,
			 -504, -504, -504, -504, -504, -504, -504, -504, -504, -504,
			 -504, -504, -504, -504, -504, -504, -504, -504, -504, -504,
			 -504, -504, -504, -504, -504, -504, -504, -504, -504, -504,
			 -504, -504, -504, -504, -504,    5, -505, -505, -505, -505,
			 -505, -505, -505, -505, -505, -505, -505, -505, -505, -505,

			 -505, -505, -505, -505, -505, -505, -505, -505, -505, -505,
			 -505, -505, -505, -505, -505, -505, -505, -505, -505, -505,
			 -505, -505, -505, -505, -505, -505, -505, -505, -505, -505,
			 -505, -505, -505,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -505, -505, -505, -505, -505, -505, -505,
			  101,  101,  101,  101,  533,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -505, -505, -505, -505,
			  101, -505,  101,  101,  101,  101,  533,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101, -505, -505,
			 -505, -505, -505, -505, -505, -505, -505, -505, -505, -505,
			 -505, -505, -505, -505, -505, -505, -505, -505, -505, -505,
			 -505, -505, -505, -505, -505, -505, -505, -505, -505, -505,
			 -505, -505, -505, -505, -505, -505, -505, -505, -505, -505,
			 -505, -505, -505, -505, -505, -505, -505, -505, -505, -505,
			 -505, -505, -505, -505, -505, -505, -505, -505, -505, -505,
			 -505, -505, -505, -505, -505, -505, -505, -505, -505, -505,
			 -505, -505, -505, -505, -505, -505, -505, -505, -505, -505,
			 -505, -505, -505, -505, -505, -505, -505, -505, -505, -505,

			 -505, -505, -505, -505, -505, -505, -505, -505, -505, -505,
			 -505, -505, -505, -505, -505, -505, -505, -505, -505, -505,
			 -505, -505, -505, -505, -505, -505, -505, -505, -505, -505,
			 -505, -505, -505, -505, -505, -505, -505, -505, -505, -505,
			 -505, -505,    5, -506, -506, -506, -506, -506, -506, -506,
			 -506, -506, -506, -506, -506, -506, -506, -506, -506, -506,
			 -506, -506, -506, -506, -506, -506, -506, -506, -506, -506,
			 -506, -506, -506, -506, -506, -506, -506, -506, -506, -506,
			 -506, -506, -506, -506, -506, -506, -506, -506, -506, -506,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			 -506, -506, -506, -506, -506, -506, -506,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  534,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -506, -506, -506, -506,  101, -506,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  534,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -506, -506, -506, -506, -506,
			 -506, -506, -506, -506, -506, -506, -506, -506, -506, -506,
			 -506, -506, -506, -506, -506, -506, -506, -506, -506, -506,
			 -506, -506, -506, -506, -506, -506, -506, -506, -506, -506,

			 -506, -506, -506, -506, -506, -506, -506, -506, -506, -506,
			 -506, -506, -506, -506, -506, -506, -506, -506, -506, -506,
			 -506, -506, -506, -506, -506, -506, -506, -506, -506, -506,
			 -506, -506, -506, -506, -506, -506, -506, -506, -506, -506,
			 -506, -506, -506, -506, -506, -506, -506, -506, -506, -506,
			 -506, -506, -506, -506, -506, -506, -506, -506, -506, -506,
			 -506, -506, -506, -506, -506, -506, -506, -506, -506, -506,
			 -506, -506, -506, -506, -506, -506, -506, -506, -506, -506,
			 -506, -506, -506, -506, -506, -506, -506, -506, -506, -506,
			 -506, -506, -506, -506, -506, -506, -506, -506, -506,    5,

			 -507, -507, -507, -507, -507, -507, -507, -507, -507, -507,
			 -507, -507, -507, -507, -507, -507, -507, -507, -507, -507,
			 -507, -507, -507, -507, -507, -507, -507, -507, -507, -507,
			 -507, -507, -507, -507, -507, -507, -507, -507, -507, -507,
			 -507, -507, -507, -507, -507, -507, -507,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -507, -507, -507,
			 -507, -507, -507, -507,  101,  101,  101,  101,  535,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -507, -507, -507, -507,  101, -507,  101,  101,  101,  101,

			  535,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -507, -507, -507, -507, -507, -507, -507, -507,
			 -507, -507, -507, -507, -507, -507, -507, -507, -507, -507,
			 -507, -507, -507, -507, -507, -507, -507, -507, -507, -507,
			 -507, -507, -507, -507, -507, -507, -507, -507, -507, -507,
			 -507, -507, -507, -507, -507, -507, -507, -507, -507, -507,
			 -507, -507, -507, -507, -507, -507, -507, -507, -507, -507,
			 -507, -507, -507, -507, -507, -507, -507, -507, -507, -507,
			 -507, -507, -507, -507, -507, -507, -507, -507, -507, -507,

			 -507, -507, -507, -507, -507, -507, -507, -507, -507, -507,
			 -507, -507, -507, -507, -507, -507, -507, -507, -507, -507,
			 -507, -507, -507, -507, -507, -507, -507, -507, -507, -507,
			 -507, -507, -507, -507, -507, -507, -507, -507, -507, -507,
			 -507, -507, -507, -507, -507, -507, -507, -507, -507, -507,
			 -507, -507, -507, -507, -507, -507,    5, -508, -508, -508,
			 -508, -508, -508, -508, -508, -508, -508, -508, -508, -508,
			 -508, -508, -508, -508, -508, -508, -508, -508, -508, -508,
			 -508, -508, -508, -508, -508, -508, -508, -508, -508, -508,
			 -508, -508, -508, -508, -508, -508, -508, -508, -508, -508,

			 -508, -508, -508, -508,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -508, -508, -508, -508, -508, -508,
			 -508,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -508, -508, -508,
			 -508,  101, -508,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -508,
			 -508, -508, -508, -508, -508, -508, -508, -508, -508, -508,
			 -508, -508, -508, -508, -508, -508, -508, -508, -508, -508,

			 -508, -508, -508, -508, -508, -508, -508, -508, -508, -508,
			 -508, -508, -508, -508, -508, -508, -508, -508, -508, -508,
			 -508, -508, -508, -508, -508, -508, -508, -508, -508, -508,
			 -508, -508, -508, -508, -508, -508, -508, -508, -508, -508,
			 -508, -508, -508, -508, -508, -508, -508, -508, -508, -508,
			 -508, -508, -508, -508, -508, -508, -508, -508, -508, -508,
			 -508, -508, -508, -508, -508, -508, -508, -508, -508, -508,
			 -508, -508, -508, -508, -508, -508, -508, -508, -508, -508,
			 -508, -508, -508, -508, -508, -508, -508, -508, -508, -508,
			 -508, -508, -508, -508, -508, -508, -508, -508, -508, -508,

			 -508, -508, -508, -508, -508, -508, -508, -508, -508, -508,
			 -508, -508, -508,    5, -509, -509, -509, -509, -509, -509,
			 -509, -509, -509, -509, -509, -509, -509, -509, -509, -509,
			 -509, -509, -509, -509, -509, -509, -509, -509, -509, -509,
			 -509, -509, -509, -509, -509, -509, -509, -509, -509, -509,
			 -509, -509, -509, -509, -509, -509, -509, -509, -509, -509,
			 -509,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -509, -509, -509, -509, -509, -509, -509,  101,  101,
			  101,  101,  536,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101, -509, -509, -509, -509,  101, -509,
			  101,  101,  101,  101,  536,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -509, -509, -509, -509,
			 -509, -509, -509, -509, -509, -509, -509, -509, -509, -509,
			 -509, -509, -509, -509, -509, -509, -509, -509, -509, -509,
			 -509, -509, -509, -509, -509, -509, -509, -509, -509, -509,
			 -509, -509, -509, -509, -509, -509, -509, -509, -509, -509,
			 -509, -509, -509, -509, -509, -509, -509, -509, -509, -509,
			 -509, -509, -509, -509, -509, -509, -509, -509, -509, -509,

			 -509, -509, -509, -509, -509, -509, -509, -509, -509, -509,
			 -509, -509, -509, -509, -509, -509, -509, -509, -509, -509,
			 -509, -509, -509, -509, -509, -509, -509, -509, -509, -509,
			 -509, -509, -509, -509, -509, -509, -509, -509, -509, -509,
			 -509, -509, -509, -509, -509, -509, -509, -509, -509, -509,
			 -509, -509, -509, -509, -509, -509, -509, -509, -509, -509,
			 -509, -509, -509, -509, -509, -509, -509, -509, -509, -509,
			    5, -510, -510, -510, -510, -510, -510, -510, -510, -510,
			 -510, -510, -510, -510, -510, -510, -510, -510, -510, -510,
			 -510, -510, -510, -510, -510, -510, -510, -510, -510, -510,

			 -510, -510, -510, -510, -510, -510, -510, -510, -510, -510,
			 -510, -510, -510, -510, -510, -510, -510, -510,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -510, -510,
			 -510, -510, -510, -510, -510,  101,  101,  101,  101,  537,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -510, -510, -510, -510,  101, -510,  101,  101,  101,
			  101,  537,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -510, -510, -510, -510, -510, -510, -510,

			 -510, -510, -510, -510, -510, -510, -510, -510, -510, -510,
			 -510, -510, -510, -510, -510, -510, -510, -510, -510, -510,
			 -510, -510, -510, -510, -510, -510, -510, -510, -510, -510,
			 -510, -510, -510, -510, -510, -510, -510, -510, -510, -510,
			 -510, -510, -510, -510, -510, -510, -510, -510, -510, -510,
			 -510, -510, -510, -510, -510, -510, -510, -510, -510, -510,
			 -510, -510, -510, -510, -510, -510, -510, -510, -510, -510,
			 -510, -510, -510, -510, -510, -510, -510, -510, -510, -510,
			 -510, -510, -510, -510, -510, -510, -510, -510, -510, -510,
			 -510, -510, -510, -510, -510, -510, -510, -510, -510, -510,

			 -510, -510, -510, -510, -510, -510, -510, -510, -510, -510,
			 -510, -510, -510, -510, -510, -510, -510, -510, -510, -510,
			 -510, -510, -510, -510, -510, -510, -510,    5, -511, -511,
			 -511, -511, -511, -511, -511, -511, -511, -511, -511, -511,
			 -511, -511, -511, -511, -511, -511, -511, -511, -511, -511,
			 -511, -511, -511, -511, -511, -511, -511, -511, -511, -511,
			 -511, -511, -511, -511, -511, -511, -511, -511, -511, -511,
			 -511, -511, -511, -511, -511,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -511, -511, -511, -511, -511,
			 -511, -511,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -511, -511,
			 -511, -511,  101, -511,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -511, -511, -511, -511, -511, -511, -511, -511, -511, -511,
			 -511, -511, -511, -511, -511, -511, -511, -511, -511, -511,
			 -511, -511, -511, -511, -511, -511, -511, -511, -511, -511,
			 -511, -511, -511, -511, -511, -511, -511, -511, -511, -511,
			 -511, -511, -511, -511, -511, -511, -511, -511, -511, -511,

			 -511, -511, -511, -511, -511, -511, -511, -511, -511, -511,
			 -511, -511, -511, -511, -511, -511, -511, -511, -511, -511,
			 -511, -511, -511, -511, -511, -511, -511, -511, -511, -511,
			 -511, -511, -511, -511, -511, -511, -511, -511, -511, -511,
			 -511, -511, -511, -511, -511, -511, -511, -511, -511, -511,
			 -511, -511, -511, -511, -511, -511, -511, -511, -511, -511,
			 -511, -511, -511, -511, -511, -511, -511, -511, -511, -511,
			 -511, -511, -511, -511, -511, -511, -511, -511, -511, -511,
			 -511, -511, -511, -511,    5,   64,   64,   64,   64,   64,
			   64,   64,   64,   64, -512,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   65,   64,
			   64, -512,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,  538,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,  538,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,    5,   64,   64,   64,   64,   64,   64,   64,   64,
			   64, -513,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,  539,   64,   64, -513,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64, yy_Dummy>>,
			1, 3000, 129000)
		end

	yy_nxt_template_45 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,    5,   64,

			   64,   64,   64,   64,   64,   64,   64,   64, -514,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,  540,   64,   64, -514,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,    5, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,

			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			  380, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,

			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,

			 -515, -515, -515, -515, -515, -515, -515, -515, -515, -515,
			 -515, -515,    5, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			  517,  517,  517,  517,  517,  517,  517,  517,  517,  517,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,

			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,

			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516, -516,
			 -516, -516, -516, -516, -516, -516, -516, -516, -516,    5,
			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,
			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,
			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,

			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,
			 -517, -517, -517, -517, -517, -517, -517,  541,  541,  541,
			  541,  541,  541,  541,  541,  541,  541, -517, -517, -517,
			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,
			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,
			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,
			 -517, -517, -517, -517,  380, -517, -517, -517, -517, -517,
			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,
			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,
			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,

			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,
			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,
			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,
			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,
			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,
			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,
			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,
			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,
			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,
			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,

			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,
			 -517, -517, -517, -517, -517, -517, -517, -517, -517, -517,
			 -517, -517, -517, -517, -517, -517,    5, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518,  519,  519,  519,  519,  519,  519,
			  519,  519,  519,  519, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,

			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,

			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518, -518, -518, -518, -518, -518, -518, -518,
			 -518, -518, -518,    5, -519, -519, -519, -519, -519, -519,
			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,

			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			 -519,  519,  519,  519,  519,  519,  519,  519,  519,  519,
			  519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,

			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,

			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			 -519, -519, -519, -519, -519, -519, -519, -519, -519, -519,
			    5, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520,  542,  542,
			  542,  542,  542,  542,  542,  542,  542,  542, -520, -520,

			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,

			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520, -520, -520, -520,
			 -520, -520, -520, -520, -520, -520, -520,    5, -521, -521,

			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			  543, -521,  543, -521, -521,  544,  544,  544,  544,  544,
			  544,  544,  544,  544,  544, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,

			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,

			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521, -521, -521, -521, -521, -521, -521,
			 -521, -521, -521, -521,    5, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,

			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522,  387,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,

			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,

			 -522, -522, -522, -522, -522, -522, -522, -522, -522, -522,
			 -522,    5, -523, -523, -523, -523, -523, -523, -523, -523,
			 -523, -523, -523, -523, -523, -523, -523, -523, -523, -523,
			 -523, -523, -523, -523, -523, -523, -523, -523, -523, -523,
			 -523, -523, -523, -523, -523, -523, -523, -523, -523, -523,
			 -523, -523, -523, -523, -523, -523, -523, -523, -523,  486,
			  486,  486,  486,  486,  486,  486,  486,  486,  486, -523,
			 -523, -523, -523, -523, -523, -523, -523, -523, -523, -523,
			  521, -523, -523, -523, -523, -523, -523, -523, -523, -523,
			 -523, -523, -523, -523, -523, -523, -523, -523, -523, -523,

			 -523, -523, -523, -523, -523, -523,  317, -523, -523, -523,
			 -523, -523,  521, -523, -523, -523, -523, -523, -523, -523,
			 -523, -523, -523, -523, -523, -523, -523, -523, -523, -523,
			 -523, -523, -523, -523, -523, -523, -523, -523, -523, -523,
			 -523, -523, -523, -523, -523, -523, -523, -523, -523, -523,
			 -523, -523, -523, -523, -523, -523, -523, -523, -523, -523,
			 -523, -523, -523, -523, -523, -523, -523, -523, -523, -523,
			 -523, -523, -523, -523, -523, -523, -523, -523, -523, -523,
			 -523, -523, -523, -523, -523, -523, -523, -523, -523, -523,
			 -523, -523, -523, -523, -523, -523, -523, -523, -523, -523,

			 -523, -523, -523, -523, -523, -523, -523, -523, -523, -523,
			 -523, -523, -523, -523, -523, -523, -523, -523, -523, -523,
			 -523, -523, -523, -523, -523, -523, -523, -523, -523, -523,
			 -523, -523, -523, -523, -523, -523, -523, -523, -523, -523,
			 -523, -523, -523, -523, -523, -523, -523, -523, -523, -523,
			 -523, -523, -523, -523, -523, -523, -523, -523, -523, -523,
			 -523, -523, -523, -523, -523, -523, -523, -523,    5, -524,
			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,

			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524, -524,  525,  525,  525,  525,
			  525,  525,  525,  525,  525,  525, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,

			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,

			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524, -524, -524, -524, -524, -524,
			 -524, -524, -524, -524, -524,    5, -525, -525, -525, -525,
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525, -525,  545,  545,  545,  545,  545,  545,  545,
			  545,  545,  545, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525, yy_Dummy>>,
			1, 3000, 132000)
		end

	yy_nxt_template_46 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			  387, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,

			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525, -525, -525, -525, -525, -525, -525, -525, -525,
			 -525, -525,    5, -526, -526, -526, -526, -526, -526, -526,
			 -526, -526, -526, -526, -526, -526, -526, -526, -526, -526,

			 -526, -526, -526, -526, -526, -526, -526, -526, -526, -526,
			 -526, -526, -526, -526, -526, -526, -526, -526, -526, -526,
			 -526, -526, -526, -526, -526, -526, -526, -526, -526, -526,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -526, -526, -526, -526, -526, -526, -526,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -526, -526, -526, -526,  101, -526,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101, -526, -526, -526, -526, -526,
			 -526, -526, -526, -526, -526, -526, -526, -526, -526, -526,
			 -526, -526, -526, -526, -526, -526, -526, -526, -526, -526,
			 -526, -526, -526, -526, -526, -526, -526, -526, -526, -526,
			 -526, -526, -526, -526, -526, -526, -526, -526, -526, -526,
			 -526, -526, -526, -526, -526, -526, -526, -526, -526, -526,
			 -526, -526, -526, -526, -526, -526, -526, -526, -526, -526,
			 -526, -526, -526, -526, -526, -526, -526, -526, -526, -526,
			 -526, -526, -526, -526, -526, -526, -526, -526, -526, -526,
			 -526, -526, -526, -526, -526, -526, -526, -526, -526, -526,

			 -526, -526, -526, -526, -526, -526, -526, -526, -526, -526,
			 -526, -526, -526, -526, -526, -526, -526, -526, -526, -526,
			 -526, -526, -526, -526, -526, -526, -526, -526, -526, -526,
			 -526, -526, -526, -526, -526, -526, -526, -526, -526,    5,
			 -527, -527, -527, -527, -527, -527, -527, -527, -527, -527,
			 -527, -527, -527, -527, -527, -527, -527, -527, -527, -527,
			 -527, -527, -527, -527, -527, -527, -527, -527, -527, -527,
			 -527, -527, -527, -527, -527, -527, -527, -527, -527, -527,
			 -527, -527, -527, -527, -527, -527, -527,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -527, -527, -527,

			 -527, -527, -527, -527,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -527, -527, -527, -527,  101, -527,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -527, -527, -527, -527, -527, -527, -527, -527,
			 -527, -527, -527, -527, -527, -527, -527, -527, -527, -527,
			 -527, -527, -527, -527, -527, -527, -527, -527, -527, -527,
			 -527, -527, -527, -527, -527, -527, -527, -527, -527, -527,

			 -527, -527, -527, -527, -527, -527, -527, -527, -527, -527,
			 -527, -527, -527, -527, -527, -527, -527, -527, -527, -527,
			 -527, -527, -527, -527, -527, -527, -527, -527, -527, -527,
			 -527, -527, -527, -527, -527, -527, -527, -527, -527, -527,
			 -527, -527, -527, -527, -527, -527, -527, -527, -527, -527,
			 -527, -527, -527, -527, -527, -527, -527, -527, -527, -527,
			 -527, -527, -527, -527, -527, -527, -527, -527, -527, -527,
			 -527, -527, -527, -527, -527, -527, -527, -527, -527, -527,
			 -527, -527, -527, -527, -527, -527, -527, -527, -527, -527,
			 -527, -527, -527, -527, -527, -527,    5, -528, -528, -528,

			 -528, -528, -528, -528, -528, -528, -528, -528, -528, -528,
			 -528, -528, -528, -528, -528, -528, -528, -528, -528, -528,
			 -528, -528, -528, -528, -528, -528, -528, -528, -528, -528,
			 -528, -528, -528, -528, -528, -528, -528, -528, -528, -528,
			 -528, -528, -528, -528,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -528, -528, -528, -528, -528, -528,
			 -528,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -528, -528, -528,
			 -528,  101, -528,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -528,
			 -528, -528, -528, -528, -528, -528, -528, -528, -528, -528,
			 -528, -528, -528, -528, -528, -528, -528, -528, -528, -528,
			 -528, -528, -528, -528, -528, -528, -528, -528, -528, -528,
			 -528, -528, -528, -528, -528, -528, -528, -528, -528, -528,
			 -528, -528, -528, -528, -528, -528, -528, -528, -528, -528,
			 -528, -528, -528, -528, -528, -528, -528, -528, -528, -528,
			 -528, -528, -528, -528, -528, -528, -528, -528, -528, -528,
			 -528, -528, -528, -528, -528, -528, -528, -528, -528, -528,

			 -528, -528, -528, -528, -528, -528, -528, -528, -528, -528,
			 -528, -528, -528, -528, -528, -528, -528, -528, -528, -528,
			 -528, -528, -528, -528, -528, -528, -528, -528, -528, -528,
			 -528, -528, -528, -528, -528, -528, -528, -528, -528, -528,
			 -528, -528, -528, -528, -528, -528, -528, -528, -528, -528,
			 -528, -528, -528,    5, -529, -529, -529, -529, -529, -529,
			 -529, -529, -529, -529, -529, -529, -529, -529, -529, -529,
			 -529, -529, -529, -529, -529, -529, -529, -529, -529, -529,
			 -529, -529, -529, -529, -529, -529, -529, -529, -529, -529,
			 -529, -529, -529, -529, -529, -529, -529, -529, -529, -529,

			 -529,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101, -529, -529, -529, -529, -529, -529, -529,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101, -529, -529, -529, -529,  101, -529,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -529, -529, -529, -529,
			 -529, -529, -529, -529, -529, -529, -529, -529, -529, -529,
			 -529, -529, -529, -529, -529, -529, -529, -529, -529, -529,

			 -529, -529, -529, -529, -529, -529, -529, -529, -529, -529,
			 -529, -529, -529, -529, -529, -529, -529, -529, -529, -529,
			 -529, -529, -529, -529, -529, -529, -529, -529, -529, -529,
			 -529, -529, -529, -529, -529, -529, -529, -529, -529, -529,
			 -529, -529, -529, -529, -529, -529, -529, -529, -529, -529,
			 -529, -529, -529, -529, -529, -529, -529, -529, -529, -529,
			 -529, -529, -529, -529, -529, -529, -529, -529, -529, -529,
			 -529, -529, -529, -529, -529, -529, -529, -529, -529, -529,
			 -529, -529, -529, -529, -529, -529, -529, -529, -529, -529,
			 -529, -529, -529, -529, -529, -529, -529, -529, -529, -529,

			 -529, -529, -529, -529, -529, -529, -529, -529, -529, -529,
			    5, -530, -530, -530, -530, -530, -530, -530, -530, -530,
			 -530, -530, -530, -530, -530, -530, -530, -530, -530, -530,
			 -530, -530, -530, -530, -530, -530, -530, -530, -530, -530,
			 -530, -530, -530, -530, -530, -530, -530, -530, -530, -530,
			 -530, -530, -530, -530, -530, -530, -530, -530,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -530, -530,
			 -530, -530, -530, -530, -530,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101, -530, -530, -530, -530,  101, -530,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -530, -530, -530, -530, -530, -530, -530,
			 -530, -530, -530, -530, -530, -530, -530, -530, -530, -530,
			 -530, -530, -530, -530, -530, -530, -530, -530, -530, -530,
			 -530, -530, -530, -530, -530, -530, -530, -530, -530, -530,
			 -530, -530, -530, -530, -530, -530, -530, -530, -530, -530,
			 -530, -530, -530, -530, -530, -530, -530, -530, -530, -530,
			 -530, -530, -530, -530, -530, -530, -530, -530, -530, -530,

			 -530, -530, -530, -530, -530, -530, -530, -530, -530, -530,
			 -530, -530, -530, -530, -530, -530, -530, -530, -530, -530,
			 -530, -530, -530, -530, -530, -530, -530, -530, -530, -530,
			 -530, -530, -530, -530, -530, -530, -530, -530, -530, -530,
			 -530, -530, -530, -530, -530, -530, -530, -530, -530, -530,
			 -530, -530, -530, -530, -530, -530, -530, -530, -530, -530,
			 -530, -530, -530, -530, -530, -530, -530,    5, -531, -531,
			 -531, -531, -531, -531, -531, -531, -531, -531, -531, -531,
			 -531, -531, -531, -531, -531, -531, -531, -531, -531, -531,
			 -531, -531, -531, -531, -531, -531, -531, -531, -531, -531,

			 -531, -531, -531, -531, -531, -531, -531, -531, -531, -531,
			 -531, -531, -531, -531, -531,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -531, -531, -531, -531, -531,
			 -531, -531,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -531, -531,
			 -531, -531,  101, -531,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -531, -531, -531, -531, -531, -531, -531, -531, -531, -531,

			 -531, -531, -531, -531, -531, -531, -531, -531, -531, -531,
			 -531, -531, -531, -531, -531, -531, -531, -531, -531, -531,
			 -531, -531, -531, -531, -531, -531, -531, -531, -531, -531,
			 -531, -531, -531, -531, -531, -531, -531, -531, -531, -531,
			 -531, -531, -531, -531, -531, -531, -531, -531, -531, -531,
			 -531, -531, -531, -531, -531, -531, -531, -531, -531, -531,
			 -531, -531, -531, -531, -531, -531, -531, -531, -531, -531,
			 -531, -531, -531, -531, -531, -531, -531, -531, -531, -531,
			 -531, -531, -531, -531, -531, -531, -531, -531, -531, -531,
			 -531, -531, -531, -531, -531, -531, -531, -531, -531, -531,

			 -531, -531, -531, -531, -531, -531, -531, -531, -531, -531,
			 -531, -531, -531, -531, -531, -531, -531, -531, -531, -531,
			 -531, -531, -531, -531,    5, -532, -532, -532, -532, -532,
			 -532, -532, -532, -532, -532, -532, -532, -532, -532, -532,
			 -532, -532, -532, -532, -532, -532, -532, -532, -532, -532,
			 -532, -532, -532, -532, -532, -532, -532, -532, -532, -532,
			 -532, -532, -532, -532, -532, -532, -532, -532, -532, -532,
			 -532, -532,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -532, -532, -532, -532, -532, -532, -532,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  546,  101,
			  101,  101,  101,  101,  101, -532, -532, -532, -532,  101,
			 -532,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  546,  101,  101,  101,  101,  101,  101, -532, -532, -532,
			 -532, -532, -532, -532, -532, -532, -532, -532, -532, -532,
			 -532, -532, -532, -532, -532, -532, -532, -532, -532, -532,
			 -532, -532, -532, -532, -532, -532, -532, -532, -532, -532,
			 -532, -532, -532, -532, -532, -532, -532, -532, -532, -532,
			 -532, -532, -532, -532, -532, -532, -532, -532, -532, -532,

			 -532, -532, -532, -532, -532, -532, -532, -532, -532, -532,
			 -532, -532, -532, -532, -532, -532, -532, -532, -532, -532,
			 -532, -532, -532, -532, -532, -532, -532, -532, -532, -532,
			 -532, -532, -532, -532, -532, -532, -532, -532, -532, -532,
			 -532, -532, -532, -532, -532, -532, -532, -532, -532, -532,
			 -532, -532, -532, -532, -532, -532, -532, -532, -532, -532,
			 -532, -532, -532, -532, -532, -532, -532, -532, -532, -532,
			 -532, -532, -532, -532, -532, -532, -532, -532, -532, -532,
			 -532,    5, -533, -533, -533, -533, -533, -533, -533, -533,
			 -533, -533, -533, -533, -533, -533, -533, -533, -533, -533,

			 -533, -533, -533, -533, -533, -533, -533, -533, -533, -533,
			 -533, -533, -533, -533, -533, -533, -533, -533, -533, -533,
			 -533, -533, -533, -533, -533, -533, -533, -533, -533,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101, -533,
			 -533, -533, -533, -533, -533, -533,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -533, -533, -533, -533,  101, -533,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101, -533, -533, -533, -533, -533, -533,
			 -533, -533, -533, -533, -533, -533, -533, -533, -533, -533,
			 -533, -533, -533, -533, -533, -533, -533, -533, -533, -533,
			 -533, -533, -533, -533, -533, -533, -533, -533, -533, -533,
			 -533, -533, -533, -533, -533, -533, -533, -533, -533, -533,
			 -533, -533, -533, -533, -533, -533, -533, -533, -533, -533,
			 -533, -533, -533, -533, -533, -533, -533, -533, -533, -533,
			 -533, -533, -533, -533, -533, -533, -533, -533, -533, -533,
			 -533, -533, -533, -533, -533, -533, -533, -533, -533, -533,
			 -533, -533, -533, -533, -533, -533, -533, -533, -533, -533,

			 -533, -533, -533, -533, -533, -533, -533, -533, -533, -533,
			 -533, -533, -533, -533, -533, -533, -533, -533, -533, -533,
			 -533, -533, -533, -533, -533, -533, -533, -533, -533, -533,
			 -533, -533, -533, -533, -533, -533, -533, -533,    5, -534,
			 -534, -534, -534, -534, -534, -534, -534, -534, -534, -534,
			 -534, -534, -534, -534, -534, -534, -534, -534, -534, -534,
			 -534, -534, -534, -534, -534, -534, -534, -534, -534, -534,
			 -534, -534, -534, -534, -534, -534, -534, -534, -534, -534,
			 -534, -534, -534, -534, -534, -534,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -534, -534, -534, -534,

			 -534, -534, -534,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  547,  101,  101,  101,  101,  101,  101,  101,  101, -534,
			 -534, -534, -534,  101, -534,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  547,  101,  101,  101,  101,  101,  101,  101,
			  101, -534, -534, -534, -534, -534, -534, -534, -534, -534,
			 -534, -534, -534, -534, -534, -534, -534, -534, -534, -534,
			 -534, -534, -534, -534, -534, -534, -534, -534, -534, -534,
			 -534, -534, -534, -534, -534, -534, -534, -534, -534, -534,

			 -534, -534, -534, -534, -534, -534, -534, -534, -534, -534,
			 -534, -534, -534, -534, -534, -534, -534, -534, -534, -534,
			 -534, -534, -534, -534, -534, -534, -534, -534, -534, -534,
			 -534, -534, -534, -534, -534, -534, -534, -534, -534, -534,
			 -534, -534, -534, -534, -534, -534, -534, -534, -534, -534,
			 -534, -534, -534, -534, -534, -534, -534, -534, -534, -534,
			 -534, -534, -534, -534, -534, -534, -534, -534, -534, -534,
			 -534, -534, -534, -534, -534, -534, -534, -534, -534, -534,
			 -534, -534, -534, -534, -534, -534, -534, -534, -534, -534,
			 -534, -534, -534, -534, -534,    5, -535, -535, -535, -535,

			 -535, -535, -535, -535, -535, -535, -535, -535, -535, -535,
			 -535, -535, -535, -535, -535, -535, -535, -535, -535, -535,
			 -535, -535, -535, -535, -535, -535, -535, -535, -535, -535,
			 -535, -535, -535, -535, -535, -535, -535, -535, -535, -535,
			 -535, -535, -535,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -535, -535, -535, -535, -535, -535, -535,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101, -535, -535, -535, -535,
			  101, -535,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101, -535, -535,
			 -535, -535, -535, -535, -535, -535, -535, -535, -535, -535,
			 -535, -535, -535, -535, -535, -535, -535, -535, -535, -535,
			 -535, -535, -535, -535, -535, -535, -535, -535, -535, -535,
			 -535, -535, -535, -535, -535, -535, -535, -535, -535, -535,
			 -535, -535, -535, -535, -535, -535, -535, -535, -535, -535,
			 -535, -535, -535, -535, -535, -535, -535, -535, -535, -535,
			 -535, -535, -535, -535, -535, -535, -535, -535, -535, -535,
			 -535, -535, -535, -535, -535, -535, -535, -535, -535, -535,

			 -535, -535, -535, -535, -535, -535, -535, -535, -535, -535,
			 -535, -535, -535, -535, -535, -535, -535, -535, -535, -535,
			 -535, -535, -535, -535, -535, -535, -535, -535, -535, -535,
			 -535, -535, -535, -535, -535, -535, -535, -535, -535, -535,
			 -535, -535, -535, -535, -535, -535, -535, -535, -535, -535,
			 -535, -535,    5, -536, -536, -536, -536, -536, -536, -536,
			 -536, -536, -536, -536, -536, -536, -536, -536, -536, -536,
			 -536, -536, -536, -536, -536, -536, -536, -536, -536, -536,
			 -536, -536, -536, -536, -536, -536, -536, -536, -536, -536,
			 -536, -536, -536, -536, -536, -536, -536, -536, -536, -536,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -536, -536, -536, -536, -536, -536, -536,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -536, -536, -536, -536,  101, -536,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -536, -536, -536, -536, -536,
			 -536, -536, -536, -536, -536, -536, -536, -536, -536, -536,
			 -536, -536, -536, -536, -536, -536, -536, -536, -536, -536,

			 -536, -536, -536, -536, -536, -536, -536, -536, -536, -536,
			 -536, -536, -536, -536, -536, -536, -536, -536, -536, -536,
			 -536, -536, -536, -536, -536, -536, -536, -536, -536, -536,
			 -536, -536, -536, -536, -536, -536, -536, -536, -536, -536,
			 -536, -536, -536, -536, -536, -536, -536, -536, -536, -536,
			 -536, -536, -536, -536, -536, -536, -536, -536, -536, -536,
			 -536, -536, -536, -536, -536, -536, -536, -536, -536, -536,
			 -536, -536, -536, -536, -536, -536, -536, -536, -536, -536,
			 -536, -536, -536, -536, -536, -536, -536, -536, -536, -536,
			 -536, -536, -536, -536, -536, -536, -536, -536, -536, -536, yy_Dummy>>,
			1, 3000, 135000)
		end

	yy_nxt_template_47 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -536, -536, -536, -536, -536, -536, -536, -536, -536,    5,
			 -537, -537, -537, -537, -537, -537, -537, -537, -537, -537,
			 -537, -537, -537, -537, -537, -537, -537, -537, -537, -537,
			 -537, -537, -537, -537, -537, -537, -537, -537, -537, -537,
			 -537, -537, -537, -537, -537, -537, -537, -537, -537, -537,
			 -537, -537, -537, -537, -537, -537, -537,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -537, -537, -537,
			 -537, -537, -537, -537,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			 -537, -537, -537, -537,  101, -537,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101, -537, -537, -537, -537, -537, -537, -537, -537,
			 -537, -537, -537, -537, -537, -537, -537, -537, -537, -537,
			 -537, -537, -537, -537, -537, -537, -537, -537, -537, -537,
			 -537, -537, -537, -537, -537, -537, -537, -537, -537, -537,
			 -537, -537, -537, -537, -537, -537, -537, -537, -537, -537,
			 -537, -537, -537, -537, -537, -537, -537, -537, -537, -537,
			 -537, -537, -537, -537, -537, -537, -537, -537, -537, -537,

			 -537, -537, -537, -537, -537, -537, -537, -537, -537, -537,
			 -537, -537, -537, -537, -537, -537, -537, -537, -537, -537,
			 -537, -537, -537, -537, -537, -537, -537, -537, -537, -537,
			 -537, -537, -537, -537, -537, -537, -537, -537, -537, -537,
			 -537, -537, -537, -537, -537, -537, -537, -537, -537, -537,
			 -537, -537, -537, -537, -537, -537, -537, -537, -537, -537,
			 -537, -537, -537, -537, -537, -537,    5,   64,   64,   64,
			   64,   64,   64,   64,   64,   64, -538,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			  548,   64,   64, -538,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,

			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,   64,   64,   64,   64,   64,   64,   64,
			   64,   64,   64,    5, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,

			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,

			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			 -539, -539, -539, -539, -539, -539, -539, -539, -539, -539,
			    5, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,

			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,

			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,

			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540, -540, -540, -540,
			 -540, -540, -540, -540, -540, -540, -540,    5, -541, -541,
			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541, -541,  515,  515,  515,  515,  515,
			  515,  515,  515,  515,  515, -541, -541, -541, -541, -541,

			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541,  380, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,

			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541, -541, -541, -541, -541, -541, -541,
			 -541, -541, -541, -541,    5, -542, -542, -542, -542, -542,

			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542,  440,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,

			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,

			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542, -542, -542, -542, -542, -542, -542, -542, -542, -542,
			 -542,    5, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543,  544,

			  544,  544,  544,  544,  544,  544,  544,  544,  544, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,

			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,
			 -543, -543, -543, -543, -543, -543, -543, -543, -543, -543,

			 -543, -543, -543, -543, -543, -543, -543, -543,    5, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544,  549,  549,  549,  549,
			  549,  549,  549,  549,  549,  549, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,

			 -544, -544, -544,  440, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,

			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544, -544, -544, -544, -544, -544,
			 -544, -544, -544, -544, -544,    5, -545, -545, -545, -545,
			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,
			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,
			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,

			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,
			 -545, -545, -545,  522,  522,  522,  522,  522,  522,  522,
			  522,  522,  522, -545, -545, -545, -545, -545, -545, -545,
			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,
			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,
			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,
			  387, -545, -545, -545, -545, -545, -545, -545, -545, -545,
			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,
			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,
			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,

			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,
			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,
			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,
			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,
			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,
			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,
			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,
			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,
			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,
			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,

			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,
			 -545, -545, -545, -545, -545, -545, -545, -545, -545, -545,
			 -545, -545,    5, -546, -546, -546, -546, -546, -546, -546,
			 -546, -546, -546, -546, -546, -546, -546, -546, -546, -546,
			 -546, -546, -546, -546, -546, -546, -546, -546, -546, -546,
			 -546, -546, -546, -546, -546, -546, -546, -546, -546, -546,
			 -546, -546, -546, -546, -546, -546, -546, -546, -546, -546,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -546, -546, -546, -546, -546, -546, -546,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101, -546, -546, -546, -546,  101, -546,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101, -546, -546, -546, -546, -546,
			 -546, -546, -546, -546, -546, -546, -546, -546, -546, -546,
			 -546, -546, -546, -546, -546, -546, -546, -546, -546, -546,
			 -546, -546, -546, -546, -546, -546, -546, -546, -546, -546,
			 -546, -546, -546, -546, -546, -546, -546, -546, -546, -546,
			 -546, -546, -546, -546, -546, -546, -546, -546, -546, -546,

			 -546, -546, -546, -546, -546, -546, -546, -546, -546, -546,
			 -546, -546, -546, -546, -546, -546, -546, -546, -546, -546,
			 -546, -546, -546, -546, -546, -546, -546, -546, -546, -546,
			 -546, -546, -546, -546, -546, -546, -546, -546, -546, -546,
			 -546, -546, -546, -546, -546, -546, -546, -546, -546, -546,
			 -546, -546, -546, -546, -546, -546, -546, -546, -546, -546,
			 -546, -546, -546, -546, -546, -546, -546, -546, -546, -546,
			 -546, -546, -546, -546, -546, -546, -546, -546, -546,    5,
			 -547, -547, -547, -547, -547, -547, -547, -547, -547, -547,
			 -547, -547, -547, -547, -547, -547, -547, -547, -547, -547,

			 -547, -547, -547, -547, -547, -547, -547, -547, -547, -547,
			 -547, -547, -547, -547, -547, -547, -547, -547, -547, -547,
			 -547, -547, -547, -547, -547, -547, -547,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101, -547, -547, -547,
			 -547, -547, -547, -547,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			 -547, -547, -547, -547,  101, -547,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,
			  101,  101,  101,  101,  101,  101,  101,  101,  101,  101,

			  101,  101, -547, -547, -547, -547, -547, -547, -547, -547,
			 -547, -547, -547, -547, -547, -547, -547, -547, -547, -547,
			 -547, -547, -547, -547, -547, -547, -547, -547, -547, -547,
			 -547, -547, -547, -547, -547, -547, -547, -547, -547, -547,
			 -547, -547, -547, -547, -547, -547, -547, -547, -547, -547,
			 -547, -547, -547, -547, -547, -547, -547, -547, -547, -547,
			 -547, -547, -547, -547, -547, -547, -547, -547, -547, -547,
			 -547, -547, -547, -547, -547, -547, -547, -547, -547, -547,
			 -547, -547, -547, -547, -547, -547, -547, -547, -547, -547,
			 -547, -547, -547, -547, -547, -547, -547, -547, -547, -547,

			 -547, -547, -547, -547, -547, -547, -547, -547, -547, -547,
			 -547, -547, -547, -547, -547, -547, -547, -547, -547, -547,
			 -547, -547, -547, -547, -547, -547, -547, -547, -547, -547,
			 -547, -547, -547, -547, -547, -547,    5, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,

			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548, yy_Dummy>>,
			1, 3000, 138000)
		end

	yy_nxt_template_48 (an_array: ARRAY [INTEGER]) is
		do
			yy_array_subcopy (an_array, <<
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548, -548, -548, -548, -548, -548, -548, -548,
			 -548, -548, -548,    5, -549, -549, -549, -549, -549, -549,

			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,
			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,
			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,
			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,
			 -549,  542,  542,  542,  542,  542,  542,  542,  542,  542,
			  542, -549, -549, -549, -549, -549, -549, -549, -549, -549,
			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,
			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,
			 -549, -549, -549, -549, -549, -549, -549, -549,  440, -549,
			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,

			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,
			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,
			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,
			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,
			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,
			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,
			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,
			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,
			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,
			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,

			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,
			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,
			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,
			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549,
			 -549, -549, -549, -549, -549, -549, -549, -549, -549, -549, yy_Dummy>>,
			1, 350, 141000)
		end

	yy_accept_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,    0,    0,  189,  187,    1,    2,   17,
			  147,   99,   24,  187,   18,   19,    7,    6,   15,    5,
			   13,    8,  178,  178,   16,   14,   12,   10,   11,  187,
			   98,   98,   98,   98,   98,   98,   98,   98,   98,   98,
			   98,   98,   98,   98,   98,   98,   98,   98,   98,   98,
			   22,  187,   23,    9,  180,   20,   21,  148,  174,  172,
			  174,    1,    2,   30,  147,  146,  147,  147,  147,  147,
			  147,  147,  147,  147,  147,  147,  147,  147,  147,  147,
			   99,  125,  125,  125,    3,   31,   32,  183,   25,   27,
			    0,  178,  178,  177,  180,   35,   33,   29,   28,   34,

			   36,   98,   98,   98,   40,   98,   98,   98,   98,   98,
			   98,   98,   49,   98,   98,   98,   98,   98,   98,   61,
			   98,   98,   68,   98,   98,   98,   98,   98,   98,   98,
			   77,   98,   98,   98,   98,   98,   98,   98,   98,   98,
			   98,   98,   26,  180,  148,  172,  173,  173,  175,  165,
			  163,  164,  166,  167,  173,  168,  169,  149,  150,  151,
			  152,  153,  154,  155,  156,  157,  158,  159,  160,  161,
			  162,  145,  129,  127,  128,  130,  147,  134,  147,  136,
			  147,  147,  147,  147,  147,  147,  147,  133,  125,  100,
			  125,  125,  125,  125,  125,  125,  125,  125,  125,  125,

			  125,  125,  125,  125,  125,  125,  125,  125,  125,  125,
			  125,  125,  125,  101,    4,  183,    0,    0,  181,  183,
			  181,  178,  178,  180,   98,   38,   39,   41,   98,   98,
			   98,   98,   98,   98,   98,   98,   52,   98,   98,   98,
			   98,   98,   98,   98,   98,   98,   98,   98,   98,   98,
			   98,   98,   98,   73,   98,   75,   98,   98,   98,   98,
			   98,   98,   98,   98,   98,   98,   98,   98,   98,   98,
			   98,   91,   98,   98,   97,    0,  171,  176,  131,  135,
			  137,  147,  147,  147,  147,  140,  147,  132,  124,  118,
			  116,  117,  119,  120,  126,  121,  122,  102,  103,  104,

			  105,  106,  107,  108,  109,  110,  111,  112,  113,  114,
			  115,  183,    0,  183,    0,  183,    0,    0,    0,  182,
			  178,  178,  180,   98,   98,   98,   98,   98,   98,   98,
			   98,   50,   98,   98,   98,   98,   98,   98,   59,   98,
			   98,   98,   98,   98,   98,   98,   69,   98,   71,   98,
			   98,   76,   98,   98,   98,   98,   98,   98,   98,   98,
			   98,   98,   98,   89,   90,   98,   98,   98,   98,   96,
			  170,  147,  139,  147,  138,  147,  141,  126,  183,  183,
			    0,    0,  183,    0,  182,    0,  182,    0,    0,  179,
			   37,   42,   43,   98,   98,   98,   47,   98,   98,   98,

			   98,   98,   98,   57,   98,   98,   98,   98,   64,   98,
			   98,   98,   70,   98,   98,   98,   98,   98,   98,   98,
			   98,   98,   85,   98,   98,   88,   98,   98,   94,   98,
			  147,  147,  147,  123,    0,  183,    0,  186,  183,  182,
			    0,    0,  182,    0,  181,    0,   98,   98,   98,   98,
			   51,   53,   98,   55,   98,   98,   60,   98,   98,   98,
			   98,   98,   72,   98,   98,   79,   98,   81,   98,   83,
			   84,   86,   98,   98,   93,   98,  147,  147,  147,    0,
			  183,    0,    0,    0,  182,    0,  186,  182,    0,    0,
			  184,  186,  184,   98,   98,   46,   98,   98,   98,   58,

			   62,   98,   65,   66,   98,   98,   98,   98,   82,   98,
			   98,   95,  147,  147,  147,  186,    0,  186,    0,  182,
			    0,    0,  185,  186,    0,  185,   45,   44,   48,   54,
			   56,   63,   98,   74,   98,   80,   87,   92,  147,  144,
			  143,  186,  185,    0,  185,  185,   67,   78,  142,  185, yy_Dummy>>)
		end

feature {NONE} -- Constants

	yyNull_equiv_class: INTEGER is 256
			-- Equivalence code for NULL character

	yyNb_rows: INTEGER is 257
			-- Number of rows in `yy_nxt'

	yyBacking_up: BOOLEAN is true
			-- Does current scanner back up?
			-- (i.e. does it have non-accepting states)

	yyNb_rules: INTEGER is 188
			-- Number of rules

	yyEnd_of_buffer: INTEGER is 189
			-- End of buffer rule code

	yyLine_used: BOOLEAN is false
			-- Are line and column numbers used?

	yyPosition_used: BOOLEAN is false
			-- Is `position' used?

	INITIAL: INTEGER is 0
	IN_STR: INTEGER is 1
			-- Start condition codes

feature -- User-defined features



feature {NONE} -- Local variables

	i_, nb_: INTEGER
	char_: CHARACTER
	str_: STRING
	code_: INTEGER

feature {NONE} -- Initialization

	make is
			-- Create a new Eiffel scanner.
		do
			make_with_buffer (Empty_buffer)
			eif_buffer := STRING_.make (Init_buffer_size)
			eif_lineno := 1
		end

	execute is
			-- Analyze Eiffel files `arguments (1..argument_count)'.
		local
			j, n: INTEGER
			a_filename: STRING
			a_file: like INPUT_STREAM_TYPE
		do
			make
			n := Arguments.argument_count
			if n = 0 then
				std.error.put_string ("usage: eiffel_scanner filename ...%N")
				Exceptions.die (1)
			else
				from j := 1 until j > n loop
					a_filename := Arguments.argument (j)
					a_file := INPUT_STREAM_.make_file_open_read (a_filename)
					if INPUT_STREAM_.is_open_read (a_file) then
						set_input_buffer (new_file_buffer (a_file))
						scan
						INPUT_STREAM_.close (a_file)
					else
						std.error.put_string ("eiffel_scanner: cannot read %'")
						std.error.put_string (a_filename)
						std.error.put_string ("%'%N")
					end
					j := j + 1
				end
			end
		end

	benchmark is
			-- Analyze Eiffel file `argument (2)' `argument (1)' times.
		local
			j, n: INTEGER
			a_filename: STRING
			a_file: like INPUT_STREAM_TYPE
		do
			make
			if
				Arguments.argument_count < 2 or else
				not STRING_.is_integer (Arguments.argument (1))
			then
				std.error.put_string ("usage: eiffel_scanner nb filename%N")
				Exceptions.die (1)
			else
				n := Arguments.argument (1).to_integer
				a_filename := Arguments.argument (2)
				from j := 1 until j > n loop
					a_file := INPUT_STREAM_.make_file_open_read (a_filename)
					if INPUT_STREAM_.is_open_read (a_file) then
						set_input_buffer (new_file_buffer (a_file))
						scan
						INPUT_STREAM_.close (a_file)
					else
						std.error.put_string ("eiffel_scanner: cannot read %'")
						std.error.put_string (a_filename)
						std.error.put_string ("%'%N")
						Exceptions.die (1)
					end
					j := j + 1
				end
			end
		end
		
	scan_string (a_text: STRING) is
		require
			a_text /= Void
		do
			reset
			set_input_buffer (new_string_buffer (a_text))

			from
				read_token
			until
				last_token <= 0
			loop
				on_token_found
				read_token
			end
			
		end

	on_token_found is
		require
--			consistent_positions: token_first_pos <= token_last_pos
		do
			print ("found a token%N")
		end
feature -- Initialization

	reset is
			-- Reset scanner before scanning next input.
		do
			reset_compressed_scanner_skeleton
			eif_lineno := 1
			eif_buffer.wipe_out
			eif_position := 1
		end

feature -- Access

	eif_position: INTEGER
	
	token_first_pos: INTEGER is
		do
				--| Because of an error in the analyzer we need to check
				--| the size of text_count for validity
			if text_count = 0 then
				Result := token_last_pos
			else
				Result := token_last_pos - text_count + 1
			end
		end

	token_last_pos: INTEGER is
		do
				--| Because of an error in the analyzer we need to assure `Result'
				--| will be ok.
			Result := (1).max (eif_position - 1)
		ensure
			valid_result: Result >= 1
		end
	
	last_value: ANY
			-- Semantic value to be passed to the parser

	eif_buffer: STRING
			-- Buffer for lexial tokens

	eif_lineno: INTEGER
			-- Current line number

	is_operator: BOOLEAN
			-- Parsing an operator declaration?

feature {NONE} -- Processing

	move (i: INTEGER) is
		do
			eif_position := eif_position + i
		end
		
	process_operator (op: INTEGER): INTEGER is
			-- Process current token as operator `op' or as
			-- an Eiffel string depending on the context
		require
			text_count_large_enough: text_count > 2
		do
			if is_operator then
				is_operator := False
				Result := op
			else
				Result := E_STRING
				last_value := text_substring (2, text_count - 1)
			end
		end

feature {NONE} -- Constants

	Init_buffer_size: INTEGER is 256
				-- Initial size for `eif_buffer'

invariant

	eif_buffer_not_void: eif_buffer /= Void
	
	
end -- class EIFFEL_SCANNER
