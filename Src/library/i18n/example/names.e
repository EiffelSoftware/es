indexing
	description: "Strings used in the interface"
	author: "i18n Team, ETH Zurich"
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
	about: STRING_32 is
		do
			Result := i18n("About");
		end
	simple: STRING_32 is
		do
			Result := i18n ("Simple label");
		end


	now_equal: STRING_32 is
		do
			Result := i18n ("n is now equal $1")
		end

	this_singular_plural (n: INTEGER): STRING_32 is
		do
			Result := i18n_pl ("This is singular","This is plural", n)
		end

	there_are_n_files (n: INTEGER): STRING_32 is
		do
			Result := i18n_pl ("There is 1 file","There are $1 files", n)
		end

	language : STRING_32 is
		do
			Result := i18n ("Select language")
		end

	italian : STRING_32 is
		do
			Result := i18n ("italian")
		end


	arabic : STRING_32 is
		do
			Result := i18n ("arabic")
		end

	greek : STRING_32 is
		do
			Result := i18n ("greek")
		end

	hebrew : STRING_32 is
		do
			Result := i18n ("hebrew")
		end

	japanese : STRING_32 is
		do
			Result := i18n ("japanese")
		end

	russian : STRING_32 is
		do
			Result := i18n ("russian")
		end

	chinese : STRING_32 is
		do
			Result := i18n ("chinese")
		end

	english : STRING_32 is
		do
			Result := i18n ("english")
		end

feature -- about dialog

	button_ok_item : STRING_32 is
		do
			Result := i18n ("OK")
		end

	message : STRING_32 is
		do
			Result := i18n ("Demo application made by i18n Team ETHZ%N%N%
							%For bugs, suggestions or other, please write a mail to: es-i18n@origo.ethz.ch%N%N")
		end

	team : STRING_32 is
		do
			Result := i18n ("Members of the team:%N%
							%   - Christian Conti%N%
							%   - Leo Fellmann%N%
							%   - Andreas Murbach%N%
							%   - Etienne Reichenbach%N%
							%   - Bernd Schoeller%N%
							%   - Ivano Somaini%N%
							%   - Martino Trosi%N%
							%   - Carlo Vanini%N%
							%   - Hong Zhang")
		end


	default_title: STRING_32 is
			-- Default title for the dialog window.
		do
			Result := i18n ("About Dialog")
		end

end
