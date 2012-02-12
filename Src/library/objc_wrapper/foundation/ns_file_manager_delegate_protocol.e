note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	NS_FILE_MANAGER_DELEGATE_PROTOCOL

inherit
	NS_OBJECT_PROTOCOL

feature -- Optional Methods

	file_manager__should_copy_item_at_path__to_path_ (a_file_manager: detachable NS_FILE_MANAGER; a_src_path: detachable NS_STRING; a_dst_path: detachable NS_STRING): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_file_manager__should_copy_item_at_path__to_path_: has_file_manager__should_copy_item_at_path__to_path_
		local
			a_file_manager__item: POINTER
			a_src_path__item: POINTER
			a_dst_path__item: POINTER
		do
			if attached a_file_manager as a_file_manager_attached then
				a_file_manager__item := a_file_manager_attached.item
			end
			if attached a_src_path as a_src_path_attached then
				a_src_path__item := a_src_path_attached.item
			end
			if attached a_dst_path as a_dst_path_attached then
				a_dst_path__item := a_dst_path_attached.item
			end
			Result := objc_file_manager__should_copy_item_at_path__to_path_ (item, a_file_manager__item, a_src_path__item, a_dst_path__item)
		end

	file_manager__should_copy_item_at_ur_l__to_ur_l_ (a_file_manager: detachable NS_FILE_MANAGER; a_src_url: detachable NS_URL; a_dst_url: detachable NS_URL): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_file_manager__should_copy_item_at_ur_l__to_ur_l_: has_file_manager__should_copy_item_at_ur_l__to_ur_l_
		local
			a_file_manager__item: POINTER
			a_src_url__item: POINTER
			a_dst_url__item: POINTER
		do
			if attached a_file_manager as a_file_manager_attached then
				a_file_manager__item := a_file_manager_attached.item
			end
			if attached a_src_url as a_src_url_attached then
				a_src_url__item := a_src_url_attached.item
			end
			if attached a_dst_url as a_dst_url_attached then
				a_dst_url__item := a_dst_url_attached.item
			end
			Result := objc_file_manager__should_copy_item_at_ur_l__to_ur_l_ (item, a_file_manager__item, a_src_url__item, a_dst_url__item)
		end

	file_manager__should_proceed_after_error__copying_item_at_path__to_path_ (a_file_manager: detachable NS_FILE_MANAGER; a_error: detachable NS_ERROR; a_src_path: detachable NS_STRING; a_dst_path: detachable NS_STRING): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_file_manager__should_proceed_after_error__copying_item_at_path__to_path_: has_file_manager__should_proceed_after_error__copying_item_at_path__to_path_
		local
			a_file_manager__item: POINTER
			a_error__item: POINTER
			a_src_path__item: POINTER
			a_dst_path__item: POINTER
		do
			if attached a_file_manager as a_file_manager_attached then
				a_file_manager__item := a_file_manager_attached.item
			end
			if attached a_error as a_error_attached then
				a_error__item := a_error_attached.item
			end
			if attached a_src_path as a_src_path_attached then
				a_src_path__item := a_src_path_attached.item
			end
			if attached a_dst_path as a_dst_path_attached then
				a_dst_path__item := a_dst_path_attached.item
			end
			Result := objc_file_manager__should_proceed_after_error__copying_item_at_path__to_path_ (item, a_file_manager__item, a_error__item, a_src_path__item, a_dst_path__item)
		end

	file_manager__should_proceed_after_error__copying_item_at_ur_l__to_ur_l_ (a_file_manager: detachable NS_FILE_MANAGER; a_error: detachable NS_ERROR; a_src_url: detachable NS_URL; a_dst_url: detachable NS_URL): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_file_manager__should_proceed_after_error__copying_item_at_ur_l__to_ur_l_: has_file_manager__should_proceed_after_error__copying_item_at_ur_l__to_ur_l_
		local
			a_file_manager__item: POINTER
			a_error__item: POINTER
			a_src_url__item: POINTER
			a_dst_url__item: POINTER
		do
			if attached a_file_manager as a_file_manager_attached then
				a_file_manager__item := a_file_manager_attached.item
			end
			if attached a_error as a_error_attached then
				a_error__item := a_error_attached.item
			end
			if attached a_src_url as a_src_url_attached then
				a_src_url__item := a_src_url_attached.item
			end
			if attached a_dst_url as a_dst_url_attached then
				a_dst_url__item := a_dst_url_attached.item
			end
			Result := objc_file_manager__should_proceed_after_error__copying_item_at_ur_l__to_ur_l_ (item, a_file_manager__item, a_error__item, a_src_url__item, a_dst_url__item)
		end

	file_manager__should_move_item_at_path__to_path_ (a_file_manager: detachable NS_FILE_MANAGER; a_src_path: detachable NS_STRING; a_dst_path: detachable NS_STRING): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_file_manager__should_move_item_at_path__to_path_: has_file_manager__should_move_item_at_path__to_path_
		local
			a_file_manager__item: POINTER
			a_src_path__item: POINTER
			a_dst_path__item: POINTER
		do
			if attached a_file_manager as a_file_manager_attached then
				a_file_manager__item := a_file_manager_attached.item
			end
			if attached a_src_path as a_src_path_attached then
				a_src_path__item := a_src_path_attached.item
			end
			if attached a_dst_path as a_dst_path_attached then
				a_dst_path__item := a_dst_path_attached.item
			end
			Result := objc_file_manager__should_move_item_at_path__to_path_ (item, a_file_manager__item, a_src_path__item, a_dst_path__item)
		end

	file_manager__should_move_item_at_ur_l__to_ur_l_ (a_file_manager: detachable NS_FILE_MANAGER; a_src_url: detachable NS_URL; a_dst_url: detachable NS_URL): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_file_manager__should_move_item_at_ur_l__to_ur_l_: has_file_manager__should_move_item_at_ur_l__to_ur_l_
		local
			a_file_manager__item: POINTER
			a_src_url__item: POINTER
			a_dst_url__item: POINTER
		do
			if attached a_file_manager as a_file_manager_attached then
				a_file_manager__item := a_file_manager_attached.item
			end
			if attached a_src_url as a_src_url_attached then
				a_src_url__item := a_src_url_attached.item
			end
			if attached a_dst_url as a_dst_url_attached then
				a_dst_url__item := a_dst_url_attached.item
			end
			Result := objc_file_manager__should_move_item_at_ur_l__to_ur_l_ (item, a_file_manager__item, a_src_url__item, a_dst_url__item)
		end

	file_manager__should_proceed_after_error__moving_item_at_path__to_path_ (a_file_manager: detachable NS_FILE_MANAGER; a_error: detachable NS_ERROR; a_src_path: detachable NS_STRING; a_dst_path: detachable NS_STRING): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_file_manager__should_proceed_after_error__moving_item_at_path__to_path_: has_file_manager__should_proceed_after_error__moving_item_at_path__to_path_
		local
			a_file_manager__item: POINTER
			a_error__item: POINTER
			a_src_path__item: POINTER
			a_dst_path__item: POINTER
		do
			if attached a_file_manager as a_file_manager_attached then
				a_file_manager__item := a_file_manager_attached.item
			end
			if attached a_error as a_error_attached then
				a_error__item := a_error_attached.item
			end
			if attached a_src_path as a_src_path_attached then
				a_src_path__item := a_src_path_attached.item
			end
			if attached a_dst_path as a_dst_path_attached then
				a_dst_path__item := a_dst_path_attached.item
			end
			Result := objc_file_manager__should_proceed_after_error__moving_item_at_path__to_path_ (item, a_file_manager__item, a_error__item, a_src_path__item, a_dst_path__item)
		end

	file_manager__should_proceed_after_error__moving_item_at_ur_l__to_ur_l_ (a_file_manager: detachable NS_FILE_MANAGER; a_error: detachable NS_ERROR; a_src_url: detachable NS_URL; a_dst_url: detachable NS_URL): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_file_manager__should_proceed_after_error__moving_item_at_ur_l__to_ur_l_: has_file_manager__should_proceed_after_error__moving_item_at_ur_l__to_ur_l_
		local
			a_file_manager__item: POINTER
			a_error__item: POINTER
			a_src_url__item: POINTER
			a_dst_url__item: POINTER
		do
			if attached a_file_manager as a_file_manager_attached then
				a_file_manager__item := a_file_manager_attached.item
			end
			if attached a_error as a_error_attached then
				a_error__item := a_error_attached.item
			end
			if attached a_src_url as a_src_url_attached then
				a_src_url__item := a_src_url_attached.item
			end
			if attached a_dst_url as a_dst_url_attached then
				a_dst_url__item := a_dst_url_attached.item
			end
			Result := objc_file_manager__should_proceed_after_error__moving_item_at_ur_l__to_ur_l_ (item, a_file_manager__item, a_error__item, a_src_url__item, a_dst_url__item)
		end

	file_manager__should_link_item_at_path__to_path_ (a_file_manager: detachable NS_FILE_MANAGER; a_src_path: detachable NS_STRING; a_dst_path: detachable NS_STRING): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_file_manager__should_link_item_at_path__to_path_: has_file_manager__should_link_item_at_path__to_path_
		local
			a_file_manager__item: POINTER
			a_src_path__item: POINTER
			a_dst_path__item: POINTER
		do
			if attached a_file_manager as a_file_manager_attached then
				a_file_manager__item := a_file_manager_attached.item
			end
			if attached a_src_path as a_src_path_attached then
				a_src_path__item := a_src_path_attached.item
			end
			if attached a_dst_path as a_dst_path_attached then
				a_dst_path__item := a_dst_path_attached.item
			end
			Result := objc_file_manager__should_link_item_at_path__to_path_ (item, a_file_manager__item, a_src_path__item, a_dst_path__item)
		end

	file_manager__should_link_item_at_ur_l__to_ur_l_ (a_file_manager: detachable NS_FILE_MANAGER; a_src_url: detachable NS_URL; a_dst_url: detachable NS_URL): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_file_manager__should_link_item_at_ur_l__to_ur_l_: has_file_manager__should_link_item_at_ur_l__to_ur_l_
		local
			a_file_manager__item: POINTER
			a_src_url__item: POINTER
			a_dst_url__item: POINTER
		do
			if attached a_file_manager as a_file_manager_attached then
				a_file_manager__item := a_file_manager_attached.item
			end
			if attached a_src_url as a_src_url_attached then
				a_src_url__item := a_src_url_attached.item
			end
			if attached a_dst_url as a_dst_url_attached then
				a_dst_url__item := a_dst_url_attached.item
			end
			Result := objc_file_manager__should_link_item_at_ur_l__to_ur_l_ (item, a_file_manager__item, a_src_url__item, a_dst_url__item)
		end

	file_manager__should_proceed_after_error__linking_item_at_path__to_path_ (a_file_manager: detachable NS_FILE_MANAGER; a_error: detachable NS_ERROR; a_src_path: detachable NS_STRING; a_dst_path: detachable NS_STRING): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_file_manager__should_proceed_after_error__linking_item_at_path__to_path_: has_file_manager__should_proceed_after_error__linking_item_at_path__to_path_
		local
			a_file_manager__item: POINTER
			a_error__item: POINTER
			a_src_path__item: POINTER
			a_dst_path__item: POINTER
		do
			if attached a_file_manager as a_file_manager_attached then
				a_file_manager__item := a_file_manager_attached.item
			end
			if attached a_error as a_error_attached then
				a_error__item := a_error_attached.item
			end
			if attached a_src_path as a_src_path_attached then
				a_src_path__item := a_src_path_attached.item
			end
			if attached a_dst_path as a_dst_path_attached then
				a_dst_path__item := a_dst_path_attached.item
			end
			Result := objc_file_manager__should_proceed_after_error__linking_item_at_path__to_path_ (item, a_file_manager__item, a_error__item, a_src_path__item, a_dst_path__item)
		end

	file_manager__should_proceed_after_error__linking_item_at_ur_l__to_ur_l_ (a_file_manager: detachable NS_FILE_MANAGER; a_error: detachable NS_ERROR; a_src_url: detachable NS_URL; a_dst_url: detachable NS_URL): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_file_manager__should_proceed_after_error__linking_item_at_ur_l__to_ur_l_: has_file_manager__should_proceed_after_error__linking_item_at_ur_l__to_ur_l_
		local
			a_file_manager__item: POINTER
			a_error__item: POINTER
			a_src_url__item: POINTER
			a_dst_url__item: POINTER
		do
			if attached a_file_manager as a_file_manager_attached then
				a_file_manager__item := a_file_manager_attached.item
			end
			if attached a_error as a_error_attached then
				a_error__item := a_error_attached.item
			end
			if attached a_src_url as a_src_url_attached then
				a_src_url__item := a_src_url_attached.item
			end
			if attached a_dst_url as a_dst_url_attached then
				a_dst_url__item := a_dst_url_attached.item
			end
			Result := objc_file_manager__should_proceed_after_error__linking_item_at_ur_l__to_ur_l_ (item, a_file_manager__item, a_error__item, a_src_url__item, a_dst_url__item)
		end

	file_manager__should_remove_item_at_path_ (a_file_manager: detachable NS_FILE_MANAGER; a_path: detachable NS_STRING): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_file_manager__should_remove_item_at_path_: has_file_manager__should_remove_item_at_path_
		local
			a_file_manager__item: POINTER
			a_path__item: POINTER
		do
			if attached a_file_manager as a_file_manager_attached then
				a_file_manager__item := a_file_manager_attached.item
			end
			if attached a_path as a_path_attached then
				a_path__item := a_path_attached.item
			end
			Result := objc_file_manager__should_remove_item_at_path_ (item, a_file_manager__item, a_path__item)
		end

	file_manager__should_remove_item_at_ur_l_ (a_file_manager: detachable NS_FILE_MANAGER; a_url: detachable NS_URL): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_file_manager__should_remove_item_at_ur_l_: has_file_manager__should_remove_item_at_ur_l_
		local
			a_file_manager__item: POINTER
			a_url__item: POINTER
		do
			if attached a_file_manager as a_file_manager_attached then
				a_file_manager__item := a_file_manager_attached.item
			end
			if attached a_url as a_url_attached then
				a_url__item := a_url_attached.item
			end
			Result := objc_file_manager__should_remove_item_at_ur_l_ (item, a_file_manager__item, a_url__item)
		end

	file_manager__should_proceed_after_error__removing_item_at_path_ (a_file_manager: detachable NS_FILE_MANAGER; a_error: detachable NS_ERROR; a_path: detachable NS_STRING): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_file_manager__should_proceed_after_error__removing_item_at_path_: has_file_manager__should_proceed_after_error__removing_item_at_path_
		local
			a_file_manager__item: POINTER
			a_error__item: POINTER
			a_path__item: POINTER
		do
			if attached a_file_manager as a_file_manager_attached then
				a_file_manager__item := a_file_manager_attached.item
			end
			if attached a_error as a_error_attached then
				a_error__item := a_error_attached.item
			end
			if attached a_path as a_path_attached then
				a_path__item := a_path_attached.item
			end
			Result := objc_file_manager__should_proceed_after_error__removing_item_at_path_ (item, a_file_manager__item, a_error__item, a_path__item)
		end

	file_manager__should_proceed_after_error__removing_item_at_ur_l_ (a_file_manager: detachable NS_FILE_MANAGER; a_error: detachable NS_ERROR; a_url: detachable NS_URL): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_file_manager__should_proceed_after_error__removing_item_at_ur_l_: has_file_manager__should_proceed_after_error__removing_item_at_ur_l_
		local
			a_file_manager__item: POINTER
			a_error__item: POINTER
			a_url__item: POINTER
		do
			if attached a_file_manager as a_file_manager_attached then
				a_file_manager__item := a_file_manager_attached.item
			end
			if attached a_error as a_error_attached then
				a_error__item := a_error_attached.item
			end
			if attached a_url as a_url_attached then
				a_url__item := a_url_attached.item
			end
			Result := objc_file_manager__should_proceed_after_error__removing_item_at_ur_l_ (item, a_file_manager__item, a_error__item, a_url__item)
		end

feature -- Status Report

	has_file_manager__should_copy_item_at_path__to_path_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_file_manager__should_copy_item_at_path__to_path_ (item)
		end

	has_file_manager__should_copy_item_at_ur_l__to_ur_l_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_file_manager__should_copy_item_at_ur_l__to_ur_l_ (item)
		end

	has_file_manager__should_proceed_after_error__copying_item_at_path__to_path_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_file_manager__should_proceed_after_error__copying_item_at_path__to_path_ (item)
		end

	has_file_manager__should_proceed_after_error__copying_item_at_ur_l__to_ur_l_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_file_manager__should_proceed_after_error__copying_item_at_ur_l__to_ur_l_ (item)
		end

	has_file_manager__should_move_item_at_path__to_path_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_file_manager__should_move_item_at_path__to_path_ (item)
		end

	has_file_manager__should_move_item_at_ur_l__to_ur_l_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_file_manager__should_move_item_at_ur_l__to_ur_l_ (item)
		end

	has_file_manager__should_proceed_after_error__moving_item_at_path__to_path_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_file_manager__should_proceed_after_error__moving_item_at_path__to_path_ (item)
		end

	has_file_manager__should_proceed_after_error__moving_item_at_ur_l__to_ur_l_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_file_manager__should_proceed_after_error__moving_item_at_ur_l__to_ur_l_ (item)
		end

	has_file_manager__should_link_item_at_path__to_path_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_file_manager__should_link_item_at_path__to_path_ (item)
		end

	has_file_manager__should_link_item_at_ur_l__to_ur_l_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_file_manager__should_link_item_at_ur_l__to_ur_l_ (item)
		end

	has_file_manager__should_proceed_after_error__linking_item_at_path__to_path_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_file_manager__should_proceed_after_error__linking_item_at_path__to_path_ (item)
		end

	has_file_manager__should_proceed_after_error__linking_item_at_ur_l__to_ur_l_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_file_manager__should_proceed_after_error__linking_item_at_ur_l__to_ur_l_ (item)
		end

	has_file_manager__should_remove_item_at_path_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_file_manager__should_remove_item_at_path_ (item)
		end

	has_file_manager__should_remove_item_at_ur_l_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_file_manager__should_remove_item_at_ur_l_ (item)
		end

	has_file_manager__should_proceed_after_error__removing_item_at_path_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_file_manager__should_proceed_after_error__removing_item_at_path_ (item)
		end

	has_file_manager__should_proceed_after_error__removing_item_at_ur_l_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_file_manager__should_proceed_after_error__removing_item_at_ur_l_ (item)
		end

feature -- Status Report Externals

	objc_has_file_manager__should_copy_item_at_path__to_path_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(fileManager:shouldCopyItemAtPath:toPath:)];
			 ]"
		end

	objc_has_file_manager__should_copy_item_at_ur_l__to_ur_l_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(fileManager:shouldCopyItemAtURL:toURL:)];
			 ]"
		end

	objc_has_file_manager__should_proceed_after_error__copying_item_at_path__to_path_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(fileManager:shouldProceedAfterError:copyingItemAtPath:toPath:)];
			 ]"
		end

	objc_has_file_manager__should_proceed_after_error__copying_item_at_ur_l__to_ur_l_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(fileManager:shouldProceedAfterError:copyingItemAtURL:toURL:)];
			 ]"
		end

	objc_has_file_manager__should_move_item_at_path__to_path_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(fileManager:shouldMoveItemAtPath:toPath:)];
			 ]"
		end

	objc_has_file_manager__should_move_item_at_ur_l__to_ur_l_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(fileManager:shouldMoveItemAtURL:toURL:)];
			 ]"
		end

	objc_has_file_manager__should_proceed_after_error__moving_item_at_path__to_path_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(fileManager:shouldProceedAfterError:movingItemAtPath:toPath:)];
			 ]"
		end

	objc_has_file_manager__should_proceed_after_error__moving_item_at_ur_l__to_ur_l_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(fileManager:shouldProceedAfterError:movingItemAtURL:toURL:)];
			 ]"
		end

	objc_has_file_manager__should_link_item_at_path__to_path_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(fileManager:shouldLinkItemAtPath:toPath:)];
			 ]"
		end

	objc_has_file_manager__should_link_item_at_ur_l__to_ur_l_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(fileManager:shouldLinkItemAtURL:toURL:)];
			 ]"
		end

	objc_has_file_manager__should_proceed_after_error__linking_item_at_path__to_path_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(fileManager:shouldProceedAfterError:linkingItemAtPath:toPath:)];
			 ]"
		end

	objc_has_file_manager__should_proceed_after_error__linking_item_at_ur_l__to_ur_l_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(fileManager:shouldProceedAfterError:linkingItemAtURL:toURL:)];
			 ]"
		end

	objc_has_file_manager__should_remove_item_at_path_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(fileManager:shouldRemoveItemAtPath:)];
			 ]"
		end

	objc_has_file_manager__should_remove_item_at_ur_l_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(fileManager:shouldRemoveItemAtURL:)];
			 ]"
		end

	objc_has_file_manager__should_proceed_after_error__removing_item_at_path_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(fileManager:shouldProceedAfterError:removingItemAtPath:)];
			 ]"
		end

	objc_has_file_manager__should_proceed_after_error__removing_item_at_ur_l_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(fileManager:shouldProceedAfterError:removingItemAtURL:)];
			 ]"
		end

feature {NONE} -- Optional Methods Externals

	objc_file_manager__should_copy_item_at_path__to_path_ (an_item: POINTER; a_file_manager: POINTER; a_src_path: POINTER; a_dst_path: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSFileManagerDelegate>)$an_item fileManager:$a_file_manager shouldCopyItemAtPath:$a_src_path toPath:$a_dst_path];
			 ]"
		end

	objc_file_manager__should_copy_item_at_ur_l__to_ur_l_ (an_item: POINTER; a_file_manager: POINTER; a_src_url: POINTER; a_dst_url: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSFileManagerDelegate>)$an_item fileManager:$a_file_manager shouldCopyItemAtURL:$a_src_url toURL:$a_dst_url];
			 ]"
		end

	objc_file_manager__should_proceed_after_error__copying_item_at_path__to_path_ (an_item: POINTER; a_file_manager: POINTER; a_error: POINTER; a_src_path: POINTER; a_dst_path: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSFileManagerDelegate>)$an_item fileManager:$a_file_manager shouldProceedAfterError:$a_error copyingItemAtPath:$a_src_path toPath:$a_dst_path];
			 ]"
		end

	objc_file_manager__should_proceed_after_error__copying_item_at_ur_l__to_ur_l_ (an_item: POINTER; a_file_manager: POINTER; a_error: POINTER; a_src_url: POINTER; a_dst_url: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSFileManagerDelegate>)$an_item fileManager:$a_file_manager shouldProceedAfterError:$a_error copyingItemAtURL:$a_src_url toURL:$a_dst_url];
			 ]"
		end

	objc_file_manager__should_move_item_at_path__to_path_ (an_item: POINTER; a_file_manager: POINTER; a_src_path: POINTER; a_dst_path: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSFileManagerDelegate>)$an_item fileManager:$a_file_manager shouldMoveItemAtPath:$a_src_path toPath:$a_dst_path];
			 ]"
		end

	objc_file_manager__should_move_item_at_ur_l__to_ur_l_ (an_item: POINTER; a_file_manager: POINTER; a_src_url: POINTER; a_dst_url: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSFileManagerDelegate>)$an_item fileManager:$a_file_manager shouldMoveItemAtURL:$a_src_url toURL:$a_dst_url];
			 ]"
		end

	objc_file_manager__should_proceed_after_error__moving_item_at_path__to_path_ (an_item: POINTER; a_file_manager: POINTER; a_error: POINTER; a_src_path: POINTER; a_dst_path: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSFileManagerDelegate>)$an_item fileManager:$a_file_manager shouldProceedAfterError:$a_error movingItemAtPath:$a_src_path toPath:$a_dst_path];
			 ]"
		end

	objc_file_manager__should_proceed_after_error__moving_item_at_ur_l__to_ur_l_ (an_item: POINTER; a_file_manager: POINTER; a_error: POINTER; a_src_url: POINTER; a_dst_url: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSFileManagerDelegate>)$an_item fileManager:$a_file_manager shouldProceedAfterError:$a_error movingItemAtURL:$a_src_url toURL:$a_dst_url];
			 ]"
		end

	objc_file_manager__should_link_item_at_path__to_path_ (an_item: POINTER; a_file_manager: POINTER; a_src_path: POINTER; a_dst_path: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSFileManagerDelegate>)$an_item fileManager:$a_file_manager shouldLinkItemAtPath:$a_src_path toPath:$a_dst_path];
			 ]"
		end

	objc_file_manager__should_link_item_at_ur_l__to_ur_l_ (an_item: POINTER; a_file_manager: POINTER; a_src_url: POINTER; a_dst_url: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSFileManagerDelegate>)$an_item fileManager:$a_file_manager shouldLinkItemAtURL:$a_src_url toURL:$a_dst_url];
			 ]"
		end

	objc_file_manager__should_proceed_after_error__linking_item_at_path__to_path_ (an_item: POINTER; a_file_manager: POINTER; a_error: POINTER; a_src_path: POINTER; a_dst_path: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSFileManagerDelegate>)$an_item fileManager:$a_file_manager shouldProceedAfterError:$a_error linkingItemAtPath:$a_src_path toPath:$a_dst_path];
			 ]"
		end

	objc_file_manager__should_proceed_after_error__linking_item_at_ur_l__to_ur_l_ (an_item: POINTER; a_file_manager: POINTER; a_error: POINTER; a_src_url: POINTER; a_dst_url: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSFileManagerDelegate>)$an_item fileManager:$a_file_manager shouldProceedAfterError:$a_error linkingItemAtURL:$a_src_url toURL:$a_dst_url];
			 ]"
		end

	objc_file_manager__should_remove_item_at_path_ (an_item: POINTER; a_file_manager: POINTER; a_path: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSFileManagerDelegate>)$an_item fileManager:$a_file_manager shouldRemoveItemAtPath:$a_path];
			 ]"
		end

	objc_file_manager__should_remove_item_at_ur_l_ (an_item: POINTER; a_file_manager: POINTER; a_url: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSFileManagerDelegate>)$an_item fileManager:$a_file_manager shouldRemoveItemAtURL:$a_url];
			 ]"
		end

	objc_file_manager__should_proceed_after_error__removing_item_at_path_ (an_item: POINTER; a_file_manager: POINTER; a_error: POINTER; a_path: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSFileManagerDelegate>)$an_item fileManager:$a_file_manager shouldProceedAfterError:$a_error removingItemAtPath:$a_path];
			 ]"
		end

	objc_file_manager__should_proceed_after_error__removing_item_at_ur_l_ (an_item: POINTER; a_file_manager: POINTER; a_error: POINTER; a_url: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSFileManagerDelegate>)$an_item fileManager:$a_file_manager shouldProceedAfterError:$a_error removingItemAtURL:$a_url];
			 ]"
		end

end