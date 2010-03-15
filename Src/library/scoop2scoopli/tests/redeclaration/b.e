note
	description: "Summary description for {B}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	B

inherit
	A
	redefine f, g, d_attr, x_attr end
create
	make

feature -- Access
	make is
			-- bla
		do
			create d_object.make
		end


	d_object: D


	f(a: D): D is

	     do
	     	result := a
			result.do_it

	     end

	g(a,b: separate D;c: separate D): D is

	     do
		result.do_it

	     end

	d_attr: D is
		do
		end

	x_attr: D

end
