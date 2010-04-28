note
	description: "Summary description for {B}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	D
inherit
	B
	redefine f,g , make, d_attr, x_attr
	 end

create
	make,
	make_empty

feature -- Access

	make is
		-- bla
		local
			d: D
			d_sep: separate D
		do
			create d.make_empty
			create d_sep.make_empty


			d := f(d_attr)
			d := f(d)
			d := g(d_sep,d_sep,d_sep).f(d).d_attr
		end

	make_empty is
			do

			end



	f(a:D): D is

	     do
	     	result := a
			result.do_it

	     end

	g(a,b: attached separate D;c: separate D): D is
		require else
			is_true: a.assert(b)
	     do
			sep := non_sep
			a.do_it
		   	result := j(a)
			result.do_it
			io.put_string("nice")

		ensure then
			is_true: b.assert(a) or b.assert(a)
	    end

	lo(a,b: attached separate D;c: separate D): D is
		require
			is_true: a.assert(b)
		do
			-- Assertion testing
		ensure
			is_true: b.assert(a) or b.assert(a)
		end

	h(x: D): D is
		do
		end

	j(x: separate D): D is
		do
		end


	do_it is
		-- bla
		do
		end

	d_attr: D is
		do
			result := create {D}.make_empty
		end

	x_attr: D

	sep: separate D

	non_sep: D

	assert(a: separate D): BOOLEAN is
			-- do some
			do
				Result := True
			end

	generics(a: separate D): X[D] is
		-- generics testing
		do
		end




end
