indexing
	description: "Wizard starting point."
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	WIZARD_PROJECT_MANAGER
		redefine
			Wizard_title
		end
	WIZARD_PROJECT_SHARED
		undefine
			copy,
			default_create
		end

create
	make_and_launch

feature -- Initialization

	Wizard_title: STRING is
			-- Window title for this wizard.
		once
			Result := "Add user Wizard"
		end

	wizard_factory: APPLICATION_FACTORY is
		once
			create Result
		end

feature -- Helper Routines

	add_label (a_box: EV_BOX; a_caption: STRING; min_width: INTEGER) is
			-- create and add a label to the box.
		local
			a_label: EV_LABEL
		do
			create a_label.make_with_text (a_caption)
			a_label.align_text_right
			a_label.set_minimum_width (min_width)
			a_box.extend (a_label)
			a_box.disable_item_expand (a_label)
		end
	
	add_without_expand (a_box: EV_BOX; a_widget: EV_WIDGET) is
			-- create and add a EV_text field to the box.
		do
			a_box.extend (a_widget)
			a_box.disable_item_expand (a_widget)
		end


end
