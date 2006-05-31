indexing
	description: "Shared class to load always the same localizator."
	status: "NOTE: This class is NOT production ready, we reccommend that you don't use it!"
	author: "Originally created by Martino Trosi, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_I18N_LOCALIZATOR

feature {NONE} -- Basic operations
	i18n(a_string: STRING_GENERAL): STRING_32 is
			-- What's the localized version of the string?
			-- NOTE: Should change the name?
		require
			valid_string: a_string /= Void
		do
			Result := localizator.translate(a_string)
		ensure
			valid_result: Result /= Void
		end

	i18n_pl(a_string: TUPLE[STRING_GENERAL, STRING_GENERAL]; a_num: INTEGER): STRING_32 is
			-- What's the a_num-th plural of the string?
			-- NOTE: Should change the name?
		require
			valid_string: a_string /= Void
		do
			Result := localizator.translate_plural(a_string, a_num)
		ensure
			valid_result: Result /= Void
		end

	i18n_comp(a_string: STRING; a_args: TUPLE): STRING_32 is
			-- What's the completed form of the template?
			-- NOTE: Should change the name!
		require
			valid_string: a_string /= Void
			valid_args: a_args /= Void
		do
			Result := localizator.translate_template(a_string, a_args)
		ensure
			valid_result: Result /= Void
		end

	i18n_comp_pl(a_string: TUPLE[STRING_GENERAL, STRING_GENERAL]; i_th: INTEGER; a_args: TUPLE): STRING_32 is
			-- What's the i_th completed form of the template?
			-- NOTE: Should change the name!
		require
			valid_string: a_string /= Void
			valid_args: a_args /= Void
		local
			temp_string: STRING
				-- Temporary string
		do
			temp_string := localizator.translate_plural(a_string, i_th)
			Result := localizator.translate_template(temp_string, a_args)
		ensure
			valid_result: Result /= Void
		end



feature {NONE} -- Implementation
	localizator: I18N_LOCALIZATOR is
			-- Unique instance of the localizator
		once
			create Result.make
		end


invariant
	invariant_clause: True -- Your invariant here

end
