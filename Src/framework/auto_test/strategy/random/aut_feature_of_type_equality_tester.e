note

	description:

		"Equality tester for AUT_FEATURE_OF_TYPE"

	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"


class AUT_FEATURE_OF_TYPE_EQUALITY_TESTER

inherit

	KL_EQUALITY_TESTER [AUT_FEATURE_OF_TYPE]
		redefine
			test
		end

create

	make,
	make_with_creator_flag

feature {NONE} -- Initialization

	make
			-- Create new tester.
			-- `a_feature' of type `a_type'.
		do
			is_creator_checked := True
		end

	make_with_creator_flag (b: BOOLEAN) is
			-- Initialize `is_creator_checked' with `b'.
		do
			is_creator_checked := b
		ensure
			is_creator_checked_set: is_creator_checked = b
		end


feature -- Status report

	test (v, u: AUT_FEATURE_OF_TYPE): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result := v.feature_.equiv (u.feature_) and
							v.type.is_equivalent (u.type) and
							(is_creator_checked implies v.is_creator = u.is_creator)

			end
		end

	is_creator_checked: BOOLEAN;
			-- Is `{AUT_FEATURE_OF_TYPE}.is_creator' checked during equality comparison?
			-- Default: True

end
