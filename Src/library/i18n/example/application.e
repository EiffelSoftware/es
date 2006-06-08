indexing
	description	: "Test application for the internationalization library"
	author		: "Etienne Reichenbach and Somainiii Ivano"

class
	APPLICATION

inherit
	EV_APPLICATION
	SHARED_I18N_LOCALIZATOR
		undefine
			default_create,	--How to avoid this ?
			copy
		end

create
	make_and_launch

feature {NONE} -- Initialization

	make_and_launch is
			-- Initialize and launch application
		do
			n := 1
			default_create
			prepare
			launch
		end

	prepare is
		do
			create first_window.make_with_title (i18n ("Application"))
			first_window.close_request_actions.extend (agent destroy)
			first_window.set_size (500,500)
			build_menu_bar
			first_window.set_menu_bar (standard_menu_bar)
			first_window.show
		end


feature -- Create window elements


	build_menu_bar is
			-- build the menu bar
		local
			open,close,save, plural, plural_2:EV_MENU_ITEM
			m_item_1,m_item_2:EV_MENU_ITEM
			first, file: EV_MENU
		do
			create standard_menu_bar.default_create
			create file.make_with_text (i18n ("File"))
			create first.make_with_text (i18n("Do you count?"))
			create open.make_with_text (i18n("Open"))
			create close.make_with_text (i18n("Close"))
			create save.make_with_text (i18n("Save"))
			create plural.make_with_text (i18n_comp_pl (["singular: \1","plura: \1"], [n], n))
			plural.select_actions.extend (agent increment)
			plural.select_actions.extend (agent disp)
			close.select_actions.extend (agent io.put_string (i18n_comp_pl (["singular: \1","plura: \1"], [n], n)+"%N"))
			create plural_2.make_with_text (i18n_pl (["singular","plural"], n))
			plural_2.select_actions.extend (agent disp_2)
			create m_item_1.make_with_text (i18n("Inglish version?"))
			create m_item_2.make_with_text (i18n("Copirighted by Kiwiz"))
			file.extend (open)
			file.extend (close)
			file.extend (save)
			first.extend (m_item_1)
			first.extend (plural)
			first.extend (plural_2)
			first.extend (m_item_2)
			standard_menu_bar.extend (file)
			standard_menu_bar.extend (first)
		end

	increment is
			--
		do
			n := n + 1
		end

	disp is
			--
		do
			io.put_string (n.out+"%N")
		end

	disp_2 is
			--
		do
			io.put_string (i18n_pl (["singular","plural"], n)+"%N")
		end



	n : INTEGER


feature {NONE} -- Implementation
	first_window: EV_TITLED_WINDOW
			-- Main window.
	standard_menu_bar: EV_MENU_BAR
			-- Menu bar
end -- class APPLICATION
