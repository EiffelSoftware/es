indexing
	description	: "Byte code for a frame specification."
	author: "Raphael Mack"
	date		: "$Date$"
	revision	: "$Revision$"
	license:	"GPL version 2 or later"

class FRAME_B

inherit
	EXPR_B
		redefine
			analyze, generate, unanalyze, enlarged,
			is_unsafe, optimized_byte_node, calls_special_features,
			size, pre_inlined_code, inlined_byte_code,
			line_number, set_line_number
		end

	ASSERT_TYPE
		export
			{NONE} generate_assertion_code, buffer
		end

feature -- Visitor

	process (v: BYTE_NODE_VISITOR) is
			-- Process current element.
		do
-- TODO: add feature to `v'
--			v.process_frame_b (Current)
		end

feature -- Access

	tag: STRING
			-- Assertion tag: can be Void

	expr: EXPR_B
			-- Assertion expression which returns a boolean

	line_number : INTEGER

feature -- Line number setting

	set_line_number (lnr : INTEGER) is
		do
			line_number := lnr
		ensure then
			line_number_set: line_number = lnr
		end


	set_tag (s: STRING) is
			-- Assign `s' to `tag'.
		do
			tag := s
		end

	set_expr (e: EXPR_B) is
			-- Assign `e' to `expr'.
		do
			expr := e
		end

	type: TYPE_A is
			-- Expression type
		do
			Result := expr.type
		end

	used (r: REGISTRABLE): BOOLEAN is
			-- False
		do
		end

	analyze is
			-- Analyze assertion
		do
			context.init_propagation
			expr.propagate (No_register)
			expr.analyze
			expr.free_register
		end

	generate is
			-- Generate assertion C code.
		do
			-- no dynamic frame checks implemented so far
			-- TODO
		end

	generate_success (buf: like buffer) is
			-- Generate a success in assertion
		do
			-- no dynamic frame checks implemented so far
			-- TODO
		end

	generate_failure (buf: like buffer) is
			-- Generate a failure in assertion
		do
			-- no dynamic frame checks implemented so far
			-- TODO
		end

	unanalyze is
			-- Undo the analysis
		do
			expr.unanalyze
		end

	enlarged: FRAME_B is
			-- Tree enlarging
		do
			expr := expr.enlarged
			-- Make sure the expression has never been analyzed before,
			-- which it could be if the assertion retrieved was in
			-- the cache
			expr.unanalyze
			Result := Current
		end;

feature -- Array optimization

	calls_special_features (array_desc: INTEGER): BOOLEAN is
		do
			Result := expr.calls_special_features (array_desc)
		end

	is_unsafe: BOOLEAN is
		do
			Result := expr.is_unsafe
		end

	optimized_byte_node: like Current is
		do
			Result := Current
			expr := expr.optimized_byte_node
		end

feature -- Inlining

	size: INTEGER is
			-- Size of the assertion.
		do
			Result := expr.size
		end

	pre_inlined_code: like Current is
		do
			Result := Current;
			expr := expr.pre_inlined_code
		end

	inlined_byte_code: like Current is
		do
			Result := Current
			expr := expr.inlined_byte_code
		end

end
