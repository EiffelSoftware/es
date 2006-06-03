indexing
	description: "Provides functions for translation and templates solving."
	status: "NOTE: This class is NOT production ready, we reccommend that you don't use it!"
	author: "Skeleton created by Martino Trosi, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_LOCALIZATOR

create {SHARED_I18N_LOCALIZATOR}
	make

feature {NONE} -- Initialization
	make is
			-- Creation procedure.
		local
			path_to_file: STRING
				-- Remove this!
		do
			-- NOTE: For the moment, should set path manually!
			path_to_file := ""
			create datastructure.make_with_file(path_to_file)
		ensure
			valid_datastructure: datastructure /= Void
		end

feature {SHARED_I18N_LOCALIZATOR} -- Basic operations
	translate(a_string: STRING_GENERAL): STRING_32 is
			-- What's the translated version of the string?
		require
			valid_string: a_string /= Void
		do
			Result := datastructure.translate(a_string, 1)
		ensure
			valid_result: Result /= Void
		end

	translate_plural(a_string: TUPLE[STRING_GENERAL, STRING_GENERAL]; a_num: INTEGER): STRING_32 is
			-- What's the a_num-th translated plural of the string?
		require
			valid_string: a_string /= Void
		local
			temp_string: STRING_GENERAL
				-- Temporary string
		do
			temp_string ?= a_string.item(1)
			if temp_string /= Void then
				Result := datastructure.translate(temp_string, a_num)
			end
		ensure
			valid_result: Result /= Void
		end

	translate_template(a_string: STRING_GENERAL; a_args: TUPLE): STRING_32 is
			-- What's the completed form of the template?
			-- NOTE: this feature doesn't connect to the datastructure!
		require
			valid_string: a_string /= Void
			valid_args: a_args /= Void
		do

		ensure
			valid_result: Result /= Void
		end

feature {NONE} -- Implementation
	datastructure: I18N_DATASTRUCTURE
		-- Reference to the datastructure

invariant
	invariant_clause: True -- Your invariant here

end
