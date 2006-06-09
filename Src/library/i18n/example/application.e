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
			build_lables
			first_window.set_menu_bar (standard_menu_bar)
			first_window.extend (vertical_box)
			first_window.show
		end


feature -- Create window elements


	build_menu_bar is
			-- build the menu bar
		local
			increase,decrease,save : EV_MENU_ITEM
			file: EV_MENU
		do
			create standard_menu_bar.default_create
			create file.make_with_text (i18n ("File"))

			create increase.make_with_text (i18n("Increase n"))
			increase.select_actions.extend (agent increment)
			increase.select_actions.extend (agent update_labels)

			create decrease.make_with_text (i18n("Decrease n"))
			decrease.select_actions.extend (agent decrement)
			decrease.select_actions.extend (agent update_labels)
			decrease.select_actions.extend (agent disp_3)

			create save.make_with_text (i18n("Save"))

			file.extend (increase)
			file.extend (decrease)
			file.extend (save)
			standard_menu_bar.extend (file)
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
			label.set_text (i18n_comp ("n is now equal $1", [n]))
			simple_label.set_text (i18n ("Simple label"))
			simple_comp_label.set_text (i18n_pl (["This is singular","This is plural"],n))
			plural_comp_label.set_text (i18n_comp_pl (["There is 1 file","There are $1 files"], [n], n))
			first_window.refresh_now
			io.put_string (label.text+"%N"+simple_label.text+"%N"+simple_comp_label.text+"%N"+plural_comp_label.text+"%N")
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

	disp_3 is
			--
		do
			io.put_string (i18n_comp_pl (["singular: $1","plura: $1"], [n], n)+"%N")
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


end -- class APPLICATION
