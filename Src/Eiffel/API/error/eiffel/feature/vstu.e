indexing
    description: "VSTU (SCOOP Target Uncontrolled) error."
    author: "Scott West"
    date: "$Date: 2009-07-17$"
    revision: "$Revision$"

class
    VSTU

inherit
    FEATURE_ERROR

create
    make


feature
    code : STRING is "VSTU"


feature {NONE} -- Implementation
    make (ctx         : AST_CONTEXT;
          target_type : TYPE_A;
          loc         : LOCATION_AS
          )
        do
            ctx.init_error (Current)
            targ_type := target_type
            set_location (loc)
        end

    targ_type : TYPE_A;

end
 
