indexing
	description	: "Test application for the internationalization library"
	author: "i18n Team, ETH Zurich"

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
			names.i18n_set_resources_path ("." +
				Operating_environment.directory_separator.out + "mo_files")
			names.i18n_set_language ("")
			names.i18n_use_mo_file
			names.i18n_use_binary_search
			names.i18n_load
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
			arabic.select_actions.extend (agent update_language ("ar"))
			create chinese.make_with_text (names.chinese)
			chinese.set_data (agent names.chinese)
			chinese.select_actions.extend (agent update_language ("zh_CN"))
			create english.make_with_text (names.english)
			english.set_data (agent names.english)
			english.select_actions.extend (agent update_language ("en"))
			create greek.make_with_text (names.greek)
			greek.set_data (agent names.greek)
			greek.select_actions.extend (agent update_language ("gr"))
			create hebrew.make_with_text (names.hebrew)
			hebrew.set_data (agent names.hebrew)
			hebrew.select_actions.extend (agent update_language ("he"))
			create italian.make_with_text (names.italian)
			italian.set_data (agent names.italian)
			italian.select_actions.extend (agent update_language ("it"))
			create japanese.make_with_text (names.japanese)
			japanese.set_data (agent names.japanese)
			japanese.select_actions.extend (agent update_language ("ja"))
			create russian.make_with_text (names.russian)
			russian.set_data (agent names.russian)
			russian.select_actions.extend (agent update_language ("ru"))

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
			--
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
		end

	update_labels is
			--
		do
			label.set_text (formatter.solve_template(names.now_equal, [n]))
			simple_label.set_text (names.simple)
			simple_comp_label.set_text (names.this_singular_plural (n))
			plural_comp_label.set_text (formatter.solve_template (names.there_are_n_files (n), [n]))
			first_window.refresh_now
		end

	increment is
			--
		do
			n := n + 1
		end

	decrement is
			--
		do
			if n > 1 then
				n := n - 1
			end
		end

	update_language (a_lang: STRING) is
			-- Reload strings in a new language
		do
			names.i18n_set_language (a_lang)
			names.i18n_use_mo_file
			names.i18n_use_binary_search
			names.i18n_load
			first_window.set_title (names.application)
			update_menu_bar
			update_labels
		end

	update_menu (a_menu: EV_MENU_ITEM) is
			--
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
			--
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
	plural_comp_label  : EV_LABEL

	formatter: I18N_TEMPLATE_FORMATTER is
		once
			create Result.make
		end


end -- class APPLICATION
