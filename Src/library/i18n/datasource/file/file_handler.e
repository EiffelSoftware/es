indexing
	description: "[
				Abstract representation of a link in a chain-of-responsability 
				pattern that knows how to handle one particular type of dictionary file
					]"
	author: "ES-i18n team (es-i18n@origo.ethz.ch)"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	I18N_FILE_HANDLER


feature -- chain-of-responsability

		next: I18N_FILE_HANDLER

		set_next(next_handler: I18N_FILE_HANDLER) is
				-- set next handler in chain
				do
					next := next_handler
				ensure
					next_set: next = next_handler
				end

		can_handle(a_path:STRING_32):BOOLEAN is
				-- can this class handle the file pointed to? Check extension, magic number, doctype or whatever you have to.
			deferred
			end

		handled: BOOLEAN


feature -- locale

	get_file_locale (a_path: STRING_GENERAL): I18N_LOCALE_ID is
			--
		do
			if can_handle(a_path.as_string_32) then
				Result := extract_locale(a_path)
				handled := True
			else
				if next /= Void then
					Result := next.get_file_locale(a_path)
					handled := next.handled
				else
					handled := False
				end
			end
		ensure
			can_handle(a_path) implies handled
			not (can_handle(a_path) and then next /= Void) implies handled = next.handled
			not (can_handle(a_path) and then next = Void) implies not handled
		end

	extract_locale(a_path: STRING_32):I18N_LOCALE_ID is
			--
		require
			can_handle(a_path)
		deferred
		end



feature -- dictionary

	get_file_dictionary (a_path: STRING_32): I18N_DICTIONARY is
			--
		do
			if can_handle(a_path.as_string_32) then
				Result := extract_dictionary(a_path)
				handled := True
			else
				if next /= Void then
					Result := next.get_file_dictionary(a_path)
					handled := next.handled
				else
					handled := False
				end
			end
		ensure
			can_handle(a_path) implies handled
			not (can_handle(a_path) and then next /= Void) implies handled = next.handled
			not (can_handle(a_path) and then next = Void) implies not handled
		end


	extract_dictionary(a_path: STRING_32):I18N_DICTIONARY is
			--
		require
			can_handle(a_path)
		deferred
		end



 feature {NONE}
 	-- Implementation
	file: I18N_FILE



end
