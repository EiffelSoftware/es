indexing
	description	: "An example application for internatioaliztion"
	author		: "i18n-team (es-i18n@origo.ethz.ch)"
	date		: "$Date$"
	revision	: "1.0.0"

class
	APPLICATION

inherit
	EV_APPLICATION
	SHARED_NAMES
		undefine
			default_create, copy
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
		local
			pixmap : EV_PIXMAP
		do
			create first_window.make_with_title (names.application)
			first_window.close_request_actions.extend (agent destroy)
			first_window.set_size (500,500)
			create pixmap
			pixmap.set_with_named_file (Operating_environment.current_directory_name_representation
					+ Operating_environment.directory_separator.out + "logo.png")
			first_window.set_icon_pixmap (pixmap)
			build_menu_bar
			build_lables
			first_window.set_menu_bar (standard_menu_bar)
			first_window.extend (vertical_box)
			first_window.show
		end


feature -- Create window elements


	build_menu_bar is
			-- build the menu bar
		local
			increase,decrease,about,
			italian, arabic, greek, hebrew, japanese, russian, chinese, english : EV_MENU_ITEM
			file, language_selection: EV_MENU
		do
			create standard_menu_bar.default_create
		-- File
			create file.make_with_text (names.file)
			file.set_data (agent names.file)

			create increase.make_with_text (names.increase)
			increase.set_data (agent names.increase)
			increase.select_actions.extend (agent increment)
			increase.select_actions.extend (agent update_labels)

			create decrease.make_with_text (names.decrease)
			decrease.set_data (agent names.decrease)
			decrease.select_actions.extend (agent decrement)
			decrease.select_actions.extend (agent update_labels)

			create about.make_with_text (names.about)
			about.set_data (agent names.about)
			about.select_actions.extend (agent on_about)

			file.extend (increase)
			file.extend (decrease)
			file.extend (about)
			standard_menu_bar.extend (file)

		-- Language selection
			create language_selection.make_with_text (names.language)
			language_selection.set_data (agent names.language)

			create arabic.make_with_text (names.arabic)
			arabic.set_data (agent names.arabic)
			arabic.select_actions.extend (agent update_language ("ar_SA"))
			create chinese.make_with_text (names.chinese)
			chinese.set_data (agent names.chinese)
			chinese.select_actions.extend (agent update_language ("zh_CN"))
			create english.make_with_text (names.english)
			english.set_data (agent names.english)
			english.select_actions.extend (agent update_language ("en_GB"))
			create greek.make_with_text (names.greek)
			greek.set_data (agent names.greek)
			greek.select_actions.extend (agent update_language ("el_GR"))
			create hebrew.make_with_text (names.hebrew)
			hebrew.set_data (agent names.hebrew)
			hebrew.select_actions.extend (agent update_language ("he_IL"))
			create italian.make_with_text (names.italian)
			italian.set_data (agent names.italian)
			italian.select_actions.extend (agent update_language ("it_IT"))
			create japanese.make_with_text (names.japanese)
			japanese.set_data (agent names.japanese)
			japanese.select_actions.extend (agent update_language ("ja_JP"))
			create russian.make_with_text (names.russian)
			russian.set_data (agent names.russian)
			russian.select_actions.extend (agent update_language ("ru_RU"))

			language_selection.extend (arabic)
			language_selection.extend (chinese)
			language_selection.extend (english)
			language_selection.extend (greek)
			language_selection.extend (hebrew)
			language_selection.extend (italian)
			language_selection.extend (japanese)
			language_selection.extend (russian)
			standard_menu_bar.extend (language_selection)

		end

	build_lables is
			-- create, initialize and add the labels
		do
			create vertical_box
			create label
			create simple_label
			create simple_comp_label
			create plural_comp_label
			update_labels
			vertical_box.extend (label)
			vertical_box.extend (simple_label)
			vertical_box.extend (simple_comp_label)
			vertical_box.extend (plural_comp_label)

			create date_label
			create time_label
			create date_time_label
			update_date_time_labels
			vertical_box.extend (date_label)
			vertical_box.extend (time_label)
			vertical_box.extend (date_time_label)
		end

	update_labels is
			-- update all labels
		do
			label.set_text (names.now_equal (n))
			simple_label.set_text (names.simple)
			simple_comp_label.set_text (names.this_singular_plural (n))
			plural_comp_label.set_text (names.there_are_n_files (n))
			first_window.refresh_now
		end

	update_date_time_labels is
			-- update the date/time labels
		do
			date_label.set_text (names.date)
			time_label.set_text (names.time)
			date_time_label.set_text (names.date_time)
		end


	increment is
			-- increment `n'
		do
			n := n + 1
		end

	decrement is
			-- decrement `n'
		do
			if n > 1 then
				n := n - 1
			end
		end

	update_language (a_lang: STRING) is
			-- Reload strings in a new language
		do
			names.set_locale (a_lang)
			first_window.set_title (names.application)
			update_menu_bar
			update_labels
			update_date_time_labels
		end

	update_menu (a_menu: EV_MENU_ITEM) is
			-- update the menu
		local
			sub_menu: EV_MENU
			text: FUNCTION [ANY, TUPLE, STRING_32]
		do
			text ?= a_menu.data
			if text /= Void then
				a_menu.set_text (text.item([]))
			end
			sub_menu ?= a_menu
			if sub_menu /= Void then
				-- means sub_menu is not just an item but a submenu
				sub_menu.do_all (agent update_menu (?))
			end
		end

	update_menu_bar is
			-- uprate the menu bar
		do
			standard_menu_bar.do_all (agent update_menu(?))
		end


	n : INTEGER

feature {NONE} -- About Dialog Implementation

	on_about is
			-- Display the About dialog.
		local
			about_dialog: ABOUT_DIALOG
		do
			create about_dialog
			about_dialog.show
		end

feature {NONE} -- Implementation

	first_window: EV_TITLED_WINDOW
			-- Main window.
	standard_menu_bar: EV_MENU_BAR
			-- Menu bar

	vertical_box : EV_VERTICAL_BOX

	label,
	simple_label,
	simple_comp_label,
	plural_comp_label,
	date_label,
	time_label,
	date_time_label  : EV_LABEL


end -- class APPLICATION
