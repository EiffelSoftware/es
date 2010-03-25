indexing
	description : "project application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Used to test redeclaration in various situations.
			-- Redeclared features and attributes from class A in classes B and D

		local
			d_sep_class: separate D
			d: D
			b: B
			y_class: Y
			y_sep_class: separate Y


		do
			create b.make
			create d.make
			create d_sep_class.make
			create y_sep_class
			create y_class

			d := b.d_object.f(d)
			d := b.f(d)

			d := d.g(d_sep_class,d_sep_class,d_sep_class)

			d_sep_class := b.d_object.f(d)
			d_sep_class := b.f(d)



		end

end
