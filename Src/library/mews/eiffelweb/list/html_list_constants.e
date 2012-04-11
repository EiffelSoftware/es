indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HTML_LIST_CONSTANTS

feature

	unordered_list_start: STRING is "<ul "
	unordered_list_end:	STRING is "</ul>"
	ordered_list_start: STRING is "<ol "
	ordered_list_end: STRING is "</ol>"
	definition_list_start: STRING is "<dl "
	definition_list_end: STRING is "</dl>"


	def_d_entry_start: STRING is "<dd>"
	def_d_entry_end: STRING is "</dd>"
	def_t_entry_start: STRING is "<dt>"
	def_t_entry_end: STRING is "</dt>"
	entry_start: STRING is "<li>"
	entry_end:	STRING is "</li>"

	tag_start: STRING is "<"
	tag_end: STRING is ">"

	NewLine: STRING is "%N";


invariant
	invariant_clause: True -- Your invariant here

end
