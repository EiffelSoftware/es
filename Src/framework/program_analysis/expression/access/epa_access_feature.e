note
	description: "Summary description for {AFX_ACCESS_FEATURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_ACCESS_FEATURE

inherit
	EPA_ACCESS
		redefine
			length,
			is_feature
		end

create
	make

feature{NONE} -- Initialization

	make (a_context_class: like context_class; a_context_feature: like context_feature; a_feat: like feature_; a_args: like arguments; a_written_class: like written_class)
			-- Initialize Current with accessed feature `a_feat'.
		require
			a_args_valid: a_args.count = a_feat.argument_count
		do
			make_with_class_feature (a_context_class, a_context_feature, a_written_class)
			feature_ := a_feat
			arguments := a_args
		ensure
			feature_set: feature_ = a_feat
			arguments_set: arguments = a_args
		end

feature -- Access

	feature_: FEATURE_I
			-- Feature of current access

	arguments: LIST [EPA_ACCESS]
			-- List of arguments

	type: TYPE_A
			-- Type of current access
		do
			Result := actual_type_from_formal_type (feature_.type, feature_.access_class)
		end

	text: STRING
			-- Text of current access
		local
			l_cursor: CURSOR
		do
			create Result.make (32)
			Result.append (feature_.feature_name)
			if not arguments.is_empty then
				Result.append (once " (")
				l_cursor := arguments.cursor
				from
					arguments.start
				until
					arguments.after
				loop
					Result.append (arguments.item_for_iteration.text)
					if arguments.index < arguments.count then
						Result.append (once ", ")
					end
					arguments.forth
				end
				arguments.go_to (l_cursor)
				Result.append_character (')')
			end
		end

	length: INTEGER
			-- Length of current access
		do
			Result := 1
		end

feature -- Status report

	is_feature: BOOLEAN = True
			-- Is Current access a feature?

end
