indexing
	description: "Strings used in the interface"
	author: "i18n Team, ETH Zurich"
	date: "$Date$"
	revision: "$Revision$"

class
	NAMES
inherit
		SHARED_LOCALE


feature -- text

	application: STRING_32 is
		do
			Result := locale.translate("Application")
		end
	file: STRING_32 is
		do
			Result := locale.translate("File")
		end
	increase: STRING_32 is
		do
			Result := locale.translate("Increase n")
		end
	decrease: STRING_32 is
		do
			Result := locale.translate("Decrease n")
		end
	about: STRING_32 is
		do
			Result := locale.translate("About")
		end
	simple: STRING_32 is
		do
			Result := locale.translate("Simple label")
		end


	now_equal (n: INTEGER): STRING_32 is
		do
			Result := locale.translate("n is now equal $1")
			Result := locale.format_string (Result, [n])
		end

	this_singular_plural (n: INTEGER): STRING_32 is
		do
			Result := locale.translate_plural ("This is singular","This is plural", n)
		end

	there_are_n_files (n: INTEGER): STRING_32 is
		do
			Result := locale.translate_plural ("There is 1 file","There are $1 files", n)
			Result := locale.format_string (Result, [n])
		end

	language : STRING_32 is
		do
			Result := locale.translate("Select language")
		end

	italian : STRING_32 is
		do
			Result := locale.translate("italian")
		end


	arabic : STRING_32 is
		do
			Result := locale.translate("arabic")
		end

	greek : STRING_32 is
		do
			Result := locale.translate("greek")
		end

	hebrew : STRING_32 is
		do
			Result := locale.translate("hebrew")
		end

	japanese : STRING_32 is
		do
			Result := locale.translate("japanese")
		end

	russian : STRING_32 is
		do
			Result := locale.translate("russian")
		end

	chinese : STRING_32 is
		do
			Result := locale.translate("chinese")
		end

	english : STRING_32 is
		do
			Result := locale.translate("english")
		end

feature -- about dialog

	button_ok_item : STRING_32 is
		do
			Result := locale.translate("OK")
		end

	message : STRING_32 is
		do
			Result := locale.translate("Demo application made by i18n Team ETHZ%N%N%
										%For bugs, suggestions or other,%
										% please write a mail to: es-i18n@origo.ethz.ch%N%N")
		end

	team : STRING_32 is
		do
			Result := locale.translate("Members of the team:%N%
										%   - Leo Fellmann%N%
										%   - Etienne Reichenbach%N%
										%   - Bernd Schoeller%N%
										%   - Martino Trosi%N%
										%   - Hong Zhang")
		end


	default_title: STRING_32 is
			-- Default title for the dialog window.
		do
			Result := locale.translate("About Dialog")
		end

end
