indexing
	description: "Strings used in the interface"
	author: "i18m team"
	date: "$Date$"
	revision: "$Revision$"

class
	NAMES

inherit
	SHARED_I18N_LOCALIZATOR


feature -- text

	application: STRING_32 is
		do
			Result := i18n ("Application");
		end
	file: STRING_32 is
		do
			Result := i18n ("File");
		end
	increase: STRING_32 is
		do
			Result := i18n("Increase n");
		end
	decrease: STRING_32 is
		do
			Result := i18n("Decrease n");
		end
	save: STRING_32 is
		do
			Result := i18n("Save");
		end
	simple: STRING_32 is
		do
			Result := i18n ("Simple label");
		end

end
