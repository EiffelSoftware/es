indexing
	legal: "See notice at end of class."
	status: "See notice at end of class."
class
	HTML_TABLE_CONSTANTS

feature

	Table_start: STRING is "<table";
	Table_end  : STRING is "</table>";

	Caption_start: STRING is "<caption";
	Caption_end  : STRING is "</caption>";

	Colspan: STRING is " COLSPAN=";
	Rowspan: STRING is " ROWSPAN=";
	Border : STRING is " border=";

	Col_start: STRING is "<td";
	Col_end  : STRING is "</td>";

	Row_start: STRING is "<tr";
	Row_end  : STRING is "</tr>";

	Tag_start: STRING is "<";
	Tag_end  : STRING is ">";

	NewLine: STRING is "%N";

	Top   : STRING is "TOP";
	Bottom: STRING is "BOTTOM";
	Left  : STRING is "LEFT";
	Right : STRING is "RIGHT";
	Center: STRING is "CENTER";

	Width : STRING is " WIDTH=";
	Align : STRING is " ALIGN=";
	Valign: STRING is " VALIGN=";
	NoWrap: STRING is " NOWRAP";

	BgColor   : STRING is " BGCOLOR=";
	BackGround: STRING is " BACKGROUND=";
	BorderColor     : STRING is " BORDERCOLOR=";
	BorderColorLight: STRING is " BORDERCOLORLIGHT=";
	BorderColorDark : STRING is " BORDERCOLORDARK=";;

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class HTML_TABLE_CONSTANTS

