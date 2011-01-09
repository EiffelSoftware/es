note
	description: "Summary description for {AST_REPLACE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SSA_REPLACEMENT

create
	make

feature
	make (a_type: TYPE_A;
	      a_var: STRING;
	      a_text: STRING;
        a_targ: STRING;
        a_args: LIST [STRING]
	      a_feat: FEATURE_I)
		do
			type := a_type
			var := a_var
			repl_text := a_text
      args := a_args
      target := a_targ
			feat := a_feat
		end


  target: STRING
      -- Target of the call, if there is one.

	type: TYPE_A
      -- Type of the replacement
  
	var: STRING
      -- Resulting variable this is placed into

  repl_text: STRING
      -- Text of the replacement call


  feat: FEATURE_I
      -- Feature being called

  args: LIST [STRING]
      -- List of variable names instantiating arguments to the call.
  
  req: REQUIRE_AS
      -- Requires clause for associated with the cal
end
