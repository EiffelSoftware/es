-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:UserDataHandler"
class
	JS_USER_DATA_HANDLER

feature -- Introduced in DOM Level 3:

feature -- OperationType

	NODE_CLONED: INTEGER
			-- The node is cloned, using Node.cloneNode().
		external "C" alias "#1" end

	NODE_IMPORTED: INTEGER
			-- The node is imported, using Document.importNode().
		external "C" alias "#2" end

	NODE_DELETED: INTEGER
			-- The node is deleted.
		external "C" alias "#3" end

	NODE_RENAMED: INTEGER
			-- The node is renamed, using Document.renameNode().
		external "C" alias "#4" end

	NODE_ADOPTED: INTEGER
			-- The node is adopted, using Document.adoptNode().
		external "C" alias "#5" end

	handle (a_operation: INTEGER; a_key: STRING; a_data: ANY; a_src: JS_NODE; a_dst: JS_NODE)
			-- This method is called whenever the node for which this handler is registered
			-- is imported or cloned. DOM applications must not raise exceptions in a
			-- UserDataHandler. The effect of throwing exceptions from the handler is DOM
			-- implementation dependent.
		external "C" alias "handle($a_operation, $a_key, $a_data, $a_src, $a_dst)" end
end
