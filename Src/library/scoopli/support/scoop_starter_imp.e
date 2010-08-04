indexing
	description: "Objects that initialize SCOOP applications."
	author: "Piotr Nienaltowski"
	date: "$Date$"
	revision: "$Revision$"
	build_number: "0.4.4000"

class SCOOP_STARTER_IMP

inherit
	SCOOP_SEPARATE_CLIENT
		redefine
			proxy_
		end

	ANY

create
	make

feature {NONE} -- Not to be used

	proxy_: SCOOP_SEPARATE__ANY
		do
			result := void
		end


feature {NONE} -- Implementation

	make is
		-- Creation procedure.
		do
			io.put_new_line
			processor_ := scoop_scheduler.new_processor_
			create root_object.set_processor_ (scoop_scheduler.new_processor_)
			separate_execute_routine ([root_object.processor_], agent execute (root_object), Void, Void, Void)
			scoop_scheduler.all_processors_finished.wait_one
		end

	execute (a_root_object: like root_object) is
		do
			-- Insert call to root creation procedure here.
			-- Attention: root creation procedure should be called without `create' keyword, just like a normal routine.
			-- e.g. `root_object.make'
		end

	root_object: SCOOP_SEPARATE__ANY
		-- Root object on which root creation procedure is called.
		-- Redefine `root_object' to be _of the type specified as root class in Ace file.
		-- Attention: always decorate the type with keyword `separate'.

end
