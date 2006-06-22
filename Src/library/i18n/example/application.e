indexing
	description	: "Test application for the internationalization library"
	author		: "Etienne Reichenbach and Somainiii Ivano"

class
	APPLICATION

inherit
	EV_APPLICATION

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
			create first_window.make_with_title (names.application)
			first_window.close_request_actions.extend (agent destroy)
			first_window.set_size (500,500)
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
			increase,decrease,save,
			italian, arabic, greek, hebrew, japanese, russian, chinese, english : EV_MENU_ITEM
			file, language_selection: EV_MENU
		do
			create standard_menu_bar.default_create
		-- File
			create file.make_with_text (names.file)

			create increase.make_with_text (names.increase)
			increase.select_actions.extend (agent increment)
			increase.select_actions.extend (agent update_labels)

			create decrease.make_with_text (names.decrease)
			decrease.select_actions.extend (agent decrement)
			decrease.select_actions.extend (agent update_labels)

			create save.make_with_text (names.save)

			file.extend (increase)
			file.extend (decrease)
			file.extend (save)
			standard_menu_bar.extend (file)

		-- Language selection
			create language_selection.make_with_text (names.language)

			create arabic.make_with_text (names.arabic)
			create chinese.make_with_text (names.chinese)
			create english.make_with_text (names.english)
			create greek.make_with_text (names.greek)
			create hebrew.make_with_text (names.hebrew)
			create italian.make_with_text (names.italian)
			create japanese.make_with_text (names.japanese)
			create russian.make_with_text (names.russian)

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

	n : INTEGER


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

	names: NAMES is
		once
			create Result.make ("it")
		end

	formatter: I18N_TEMPLATE_FORMATTER is
		once
			create Result.make
		end


end -- class APPLICATION
