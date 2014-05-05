note
	description: "Summary description for {EV_AUTOLAYOUT_TOKENS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_AUTOLAYOUT_TOKENS

feature -- Access

	al_LAYOUT_OPEN: CHARACTER = '{'
	al_WIDGET_OPEN: CHARACTER = '['
	al_SIZE_OPEN: CHARACTER = '('
	al_LAYOUT_CLOSE: CHARACTER = '}'
	al_WIDGET_CLOSE: CHARACTER = ']'
	al_SIZE_CLOSE: CHARACTER = ')'

	al_DASH: CHARACTER = '-'
	al_COLON: CHARACTER = ':'
	al_HORIZONTAL: CHARACTER = 'H'
	al_VERTICAL: CHARACTER = 'V'

	al_DEFAULT_SPACING: INTEGER = 8

feature -- Status report

	is_open_token (c: CHARACTER): BOOLEAN
			-- Characters which open a type	
		do
			inspect c
			when al_LAYOUT_OPEN, al_WIDGET_OPEN, al_SIZE_OPEN, al_DASH, al_COLON, al_HORIZONTAL, al_VERTICAL then
				Result := True
			end
		end

	is_close_token (c: CHARACTER): BOOLEAN
			-- Characters which close a type	
		do
			inspect c
			when al_LAYOUT_CLOSE, al_WIDGET_CLOSE, al_SIZE_CLOSE then
				Result := True
			end
		end

note
	copyright: "Copyright (c) 1984-2014, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
