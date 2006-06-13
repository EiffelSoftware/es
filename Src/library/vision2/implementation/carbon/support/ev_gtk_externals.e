indexing
	legal: "See notice at end of class."
	status: "See notice at end of class."
class
	EV_GTK_EXTERNALS

inherit
	EV_GTK_DEPENDENT_EXTERNALS

feature -- MACROS

	frozen gtk_maj_ver: INTEGER is
		do
		end

	frozen gtk_min_ver: INTEGER is
		do
		end

	frozen gtk_mic_ver: INTEGER is
		do
		end

	frozen gtk_signal_emit_by_name (a_object: POINTER; a_signal: POINTER) is
		do
		end

	frozen gtk_widget_set_flags (a_widget: POINTER; a_flag: INTEGER) is
		do
		end

	frozen gtk_widget_unset_flags (a_widget: POINTER; a_flag: INTEGER) is
		do
		end

	frozen gtk_widget_no_window (a_wid: POINTER): BOOLEAN is
		do
		end

feature -- Measurement

	frozen c_gdk_color_struct_size: INTEGER is
			-- Size of GdkColor in bytes.
			-- (from C_GDK_COLOR_STRUCT)
		do
		end

	frozen c_gdk_rectangle_struct_size: INTEGER is
			-- Size of GdkRectangle in bytes.
			-- (from C_GDK_RECTANGLE_STRUCT)
		do
		end

	frozen c_gtk_menu_bar_struct_size: INTEGER is
			-- Size of GtkMenuBar in bytes.
			-- (from C_GTK_MENU_BAR_STRUCT)
		do
		end

	frozen c_gtk_menu_item_struct_size: INTEGER is
			-- Size of GtkMenuItem in bytes.
			-- (from C_GTK_MENU_ITEM_STRUCT)
		do
		end

	frozen c_gtk_menu_shell_struct_size: INTEGER is
			-- Size of GtkMenuShell in bytes.
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen c_gtk_menu_struct_size: INTEGER is
			-- Size of GtkMenu in bytes.
			-- (from C_GTK_MENU_STRUCT)
		do
		end

	frozen c_gtk_misc_struct_size: INTEGER is
			-- Size of GtkMisc in bytes.
			-- (from C_GTK_MISC_STRUCT)
		do
		end

	frozen c_gtk_notebook_struct_size: INTEGER is
			-- Size of GtkNotebook in bytes.
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen c_gtk_object_struct_size: INTEGER is
			-- Size of GtkObject in bytes.
			-- (from C_GTK_OBJECT_STRUCT)
		do
		end

	frozen c_gtk_paned_struct_size: INTEGER is
			-- Size of GtkPaned in bytes.
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen c_gtk_pixmap_struct_size: INTEGER is
			-- Size of GtkPixmap in bytes.
			-- (from C_GTK_PIXMAP_STRUCT)
		do
		end

	frozen c_gtk_progress_bar_struct_size: INTEGER is
			-- Size of GtkProgressBar in bytes.
			-- (from C_GTK_PROGRESS_BAR_STRUCT)
		do
		end

	frozen c_gtk_progress_struct_size: INTEGER is
			-- Size of GtkProgress in bytes.
			-- (from C_GTK_PROGRESS_STRUCT)
		do
		end

	frozen c_gtk_radio_button_struct_size: INTEGER is
			-- Size of GtkRadioButton in bytes.
			-- (from C_GTK_RADIO_BUTTON_STRUCT)
		do
		end

	frozen c_gtk_radio_menu_item_struct_size: INTEGER is
			-- Size of GtkRadioMenuItem in bytes.
			-- (from C_GTK_RADIO_MENU_ITEM_STRUCT)
		do
		end

	frozen c_gtk_range_struct_size: INTEGER is
			-- Size of GtkRange in bytes.
			-- (from C_GTK_RANGE_STRUCT)
		do
		end

	frozen c_gtk_requisition_struct_size: INTEGER is
			-- Size of GtkRequisition in bytes.
			-- (from C_GTK_REQUISITION_STRUCT)
		do
		end

	frozen c_gtk_scale_struct_size: INTEGER is
			-- Size of GtkScale in bytes.
			-- (from C_GTK_SCALE_STRUCT)
		do
		end

	frozen c_gtk_scrollbar_struct_size: INTEGER is
			-- Size of GtkScrollbar in bytes.
			-- (from C_GTK_SCROLLBAR_STRUCT)
		do
		end

	frozen c_gtk_scrolled_window_struct_size: INTEGER is
			-- Size of GtkScrolledwindow in bytes.
			-- (from C_GTK_SCROLLED_window_STRUCT)
		do
		end

	frozen c_gtk_separator_struct_size: INTEGER is
			-- Size of GtkSeparator in bytes.
			-- (from C_GTK_SEPARATOR_STRUCT)
		do
		end

	frozen c_gtk_spin_button_struct_size: INTEGER is
			-- Size of GtkSpinButton in bytes.
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen c_gtk_style_struct_size: INTEGER is
			-- Size of GtkStyle in bytes.
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen c_gtk_table_struct_size: INTEGER is
			-- Size of GtkTable in bytes.
			-- (from C_GTK_TABLE_STRUCT)
		do
		end

	frozen c_gtk_toggle_button_struct_size: INTEGER is
			-- Size of GtkToggleButton in bytes.
			-- (from C_GTK_TOGGLE_BUTTON_STRUCT)
		do
		end

	frozen c_gtk_tooltips_data_struct_size: INTEGER is
			-- Size of GtkTooltipsData in bytes.
			-- (from C_GTK_TOOLTIPS_DATA_STRUCT)
		do
		end

	frozen c_gtk_tooltips_struct_size: INTEGER is
			-- Size of GtkTooltips in bytes.
			-- (from C_GTK_TOOLTIPS_STRUCT)
		do
		end

	frozen c_gtk_vbox_struct_size: INTEGER is
			-- Size of GtkVBox in bytes.
			-- (from C_GTK_VBOX_STRUCT)
		do
		end

	frozen c_gtk_viewport_struct_size: INTEGER is
			-- Size of GtkViewport in bytes.
			-- (from C_GTK_VIEWPORT_STRUCT)
		do
		end

	frozen c_gtk_vpaned_struct_size: INTEGER is
			-- Size of GtkVPaned in bytes.
			-- (from C_GTK_VPANED_STRUCT)
		do
		end

	frozen c_gtk_vscale_struct_size: INTEGER is
			-- Size of GtkVScale in bytes.
			-- (from C_GTK_VSCALE_STRUCT)
		do
		end

	frozen c_gtk_vscrollbar_struct_size: INTEGER is
			-- Size of GtkVScrollbar in bytes.
			-- (from C_GTK_VSCROLLBAR_STRUCT)
		do
		end

	frozen c_gtk_vseparator_struct_size: INTEGER is
			-- Size of GtkVSeparator in bytes.
			-- (from C_GTK_VSEPARATOR_STRUCT)
		do
		end

	frozen c_gtk_widget_aux_info_struct_size: INTEGER is
			-- Size of GtkWidgetAuxInfo in bytes.
			-- (from C_GTK_WIDGET_AUX_INFO_STRUCT)
		do
		end

	frozen c_gtk_widget_struct_size: INTEGER is
			-- Size of GtkWidget in bytes.
			-- (from C_GTK_WIDGET_STRUCT)
		do
		end

	frozen c_gtk_window_struct_size: INTEGER is
			-- Size of Gtkwindow in bytes.
			-- (from C_GTK_window_STRUCT)
		do
		end

feature -- GTK Macros

	frozen c_gtk_widget_can_focus (w: POINTER): BOOLEAN is
			-- (from EV_GTK_WIDGETS_EXTERNALS)
		do
		end

	frozen c_gtk_widget_has_focus (w: POINTER): BOOLEAN is
			-- (from EV_GTK_WIDGETS_EXTERNALS)
		do
		end

	frozen gdk_root_parent: POINTER is
			-- (from EV_GTK_WIDGETS_EXTERNALS)
		do
		end

	frozen gtk_is_container (w: POINTER): BOOLEAN is
			-- (from EV_GTK_WIDGETS_EXTERNALS)
		do
		end

	frozen gtk_is_widget (w: POINTER): BOOLEAN is
			-- (from EV_GTK_WIDGETS_EXTERNALS)
		do
		end

	frozen gtk_is_window (w: POINTER): BOOLEAN is
			-- (from EV_GTK_WIDGETS_EXTERNALS)
		do
		end

feature -- C enums

	frozen gdk_control_mask_enum: INTEGER is
		do
		end

	frozen gdk_mod1_mask_enum: INTEGER is
		do
		end

	frozen gdk_shift_mask_enum: INTEGER is
		do
		end

	frozen gdk_button_press_enum: INTEGER is
		do
		end

	frozen gdk_2button_press_enum: INTEGER is
		do
		end

	frozen gdk_3button_press_enum: INTEGER is
		do
		end

	frozen gdk_button_release_enum: INTEGER is
		do
		end

	frozen gtk_state_normal_enum: INTEGER is
		do
		end

	frozen gtk_state_prelight_enum: INTEGER is
		do
		end

	frozen gtk_state_selected_enum: INTEGER is
		do
		end

	frozen gtk_state_active_enum: INTEGER is
		do
		end

	frozen gtk_state_insensitive_enum: INTEGER is
		do
		end

	frozen gtk_sensitive_enum: INTEGER is
		do
		end

	frozen gtk_mapped_enum: INTEGER is
		do
		end

	frozen gdk_invert_enum: INTEGER is
		do
		end

	frozen gdk_include_inferiors_enum: INTEGER is
		do
		end

	frozen gtk_justify_center_enum: INTEGER is
		do
		end

	frozen gtk_justify_left_enum: INTEGER is
		do
		end

	frozen gtk_justify_right_enum: INTEGER is
		do
		end

	frozen gtk_justify_fill_enum: INTEGER is
		do
		end

	frozen gtk_shadow_none_enum: INTEGER is
		do
		end

	frozen gtk_shadow_etched_in_enum: INTEGER is
		do
		end

	frozen gtk_shadow_etched_out_enum: INTEGER is
		do
		end

	frozen gtk_shadow_in_enum: INTEGER is
		do
		end

	frozen gtk_shadow_out_enum: INTEGER is
		do
		end

	frozen gdk_exposure_mask_enum: INTEGER is
		do
		end

	frozen gdk_pointer_motion_mask_enum: INTEGER is
		do
		end

	frozen gdk_pointer_motion_hint_mask_enum: INTEGER is
		do
		end

	frozen gdk_button1_mask_enum: INTEGER is
		do
		end

	frozen gdk_button2_mask_enum: INTEGER is
		do
		end

	frozen gdk_button3_mask_enum: INTEGER is
		do
		end

	frozen gdk_button_press_mask_enum: INTEGER is
		do
		end

	frozen gdk_button_release_mask_enum: INTEGER is
		do
		end

	frozen gdk_button_motion_mask_enum: INTEGER is
		do
		end

	frozen gdk_key_press_enum: INTEGER is
		do
		end

	frozen gdk_key_release_enum: INTEGER is
		do
		end

	frozen gdk_key_press_mask_enum: INTEGER is
		do
		end

	frozen gdk_key_release_mask_enum: INTEGER is
		do
		end

	frozen gdk_enter_notify_mask_enum: INTEGER is
		do
		end

	frozen gdk_leave_notify_mask_enum: INTEGER is
		do
		end

	frozen gdk_focus_change_mask_enum: INTEGER is
		do
		end

	frozen gdk_visibility_notify_mask_enum: INTEGER is
		do
		end

	frozen gtk_has_focus_enum: INTEGER is
		do
		end

	frozen gtk_has_grab_enum: INTEGER is
		do
		end

	frozen gtk_visible_enum: INTEGER is
		do
		end

	frozen gtk_window_toplevel_enum: INTEGER is
		do
		end

	frozen gtk_window_popup_enum: INTEGER is
		do
		end

	frozen gdk_decor_all_enum: INTEGER is
		do
		end

	frozen gdk_decor_border_enum: INTEGER is
		do
		end

	frozen gdk_hint_max_size_enum: INTEGER is
		do
		end

	frozen gtk_realized_enum: INTEGER is
		do
		end

	frozen gtk_win_pos_center_enum: INTEGER is
		do
		end

	frozen gtk_win_pos_none_enum: INTEGER is
		do
		end

	frozen gdk_func_close_enum: INTEGER is
		do
		end

	frozen gdk_func_move_enum: INTEGER is
		do
		end

	frozen gdk_func_resize_enum: INTEGER is
		do
		end

	frozen gtk_can_focus_enum: INTEGER is
		do
		end

	frozen gtk_policy_automatic_enum: INTEGER is
		do
		end

	frozen gtk_policy_always_enum: INTEGER is
		do
		end

	frozen gtk_policy_never_enum: INTEGER is
		do
		end

	frozen gtk_corner_top_left_enum: INTEGER is
		do
		end

	frozen gtk_selection_browse_enum: INTEGER is
		do
		end

	frozen gtk_selection_single_enum: INTEGER is
		do
		end

	frozen gtk_selection_multiple_enum: INTEGER is
		do
		end

	frozen gtk_selection_extended_enum: INTEGER is
		do
		end

	frozen gtk_relief_normal_enum: INTEGER is
		do
		end

	frozen gtk_relief_none_enum: INTEGER is
		do
		end

	frozen gdk_copy_enum: INTEGER is
		do
		end

	frozen gdk_copy_invert_enum: INTEGER is
		do
		end

	frozen gdk_xor_enum: INTEGER is
		do
		end

	frozen gdk_and_enum: INTEGER is
		do
		end

	frozen gdk_or_enum: INTEGER is
		do
		end

	frozen gdk_line_on_off_dash_enum: INTEGER is
		do
		end

	frozen gdk_line_solid_enum: INTEGER is
		do
		end

	frozen gdk_tiled_enum: INTEGER is
		do
		end

	frozen gdk_solid_enum: INTEGER is
		do
		end

	frozen gdk_cap_butt_enum: INTEGER is
		do
		end

	frozen gdk_cap_round_enum: INTEGER is
		do
		end

	frozen gdk_join_bevel_enum: INTEGER is
		do
		end

	frozen gdk_rgb_dither_normal_enum: INTEGER is
		do
		end

feature -- External C functions

	frozen g_allocator_free (a_allocator: POINTER) is
			-- void        g_allocator_free  (GAllocator   *allocator);
			-- (from C_GLIB)
		do
		end

	frozen g_allocator_new (a_name: POINTER; a_n_preallocs: INTEGER): POINTER is
			-- GAllocator* g_allocator_new   (const gchar  *name,
			-- 			       guint         n_preallocs);
			-- (from C_GLIB)
		do
		end

	frozen g_array_append_vals (a_array: POINTER; a_data: POINTER; a_len: INTEGER): POINTER is
			-- GArray* g_array_append_vals       (GArray	   *array,
			-- 				   gconstpointer    data,
			-- 				   guint	    len);
			-- (from C_GLIB)
		do
		end

	frozen g_array_free (a_array: POINTER; a_free_segment: BOOLEAN) is
			-- void	g_array_free	          (GArray	   *array,
			-- 				   gboolean	    free_segment);
			-- (from C_GLIB)
		do
		end

	frozen g_array_insert_vals (a_array: POINTER; a_index: INTEGER; a_data: POINTER; a_len: INTEGER): POINTER is
			-- GArray* g_array_insert_vals       (GArray          *array,
			-- 				   guint            index,
			-- 				   gconstpointer    data,
			-- 				   guint            len);
			-- (from C_GLIB)
		do
		end

	frozen g_array_new (a_zero_terminated: BOOLEAN; a_clear: BOOLEAN; a_element_size: INTEGER): POINTER is
			-- GArray* g_array_new	          (gboolean	    zero_terminated,
			-- 				   gboolean	    clear,
			-- 				   guint	    element_size);
			-- (from C_GLIB)
		do
		end

	frozen g_array_prepend_vals (a_array: POINTER; a_data: POINTER; a_len: INTEGER): POINTER is
			-- GArray* g_array_prepend_vals      (GArray	   *array,
			-- 				   gconstpointer    data,
			-- 				   guint	    len);
			-- (from C_GLIB)
		do
		end

	frozen g_array_remove_index (a_array: POINTER; a_index: INTEGER): POINTER is
			-- GArray* g_array_remove_index	  (GArray	   *array,
			-- 				   guint	    index);
			-- (from C_GLIB)
		do
		end

	frozen g_array_remove_index_fast (a_array: POINTER; a_index: INTEGER): POINTER is
			-- GArray* g_array_remove_index_fast (GArray	   *array,
			-- 				   guint	    index);
			-- (from C_GLIB)
		do
		end

	frozen g_array_set_size (a_array: POINTER; a_length: INTEGER): POINTER is
			-- GArray* g_array_set_size          (GArray	   *array,
			-- 				   guint	    length);
			-- (from C_GLIB)
		do
		end

	frozen g_atexit (a_func: POINTER) is
			-- void	g_atexit		(GVoidFunc    func);
			-- (from C_GLIB)
		do
		end

	frozen g_basename (a_file_name: POINTER): POINTER is
			-- gchar*	g_basename		(const gchar *file_name);
			-- (from C_GLIB)
		do
		end

	frozen g_bit_nth_lsf (a_mask: INTEGER; a_nth_bit: INTEGER): INTEGER is
			-- extern  gint	g_bit_nth_lsf (guint32 mask,
			-- 				       gint    nth_bit);
			-- (from C_GLIB)
		do
		end

	frozen g_bit_nth_msf (a_mask: INTEGER; a_nth_bit: INTEGER): INTEGER is
			-- extern  gint	g_bit_nth_msf (guint32 mask,
			-- 				       gint    nth_bit);
			-- (from C_GLIB)
		do
		end

	frozen g_bit_storage (a_number: INTEGER): INTEGER is
			-- extern  guint	g_bit_storage (guint number);
			-- (from C_GLIB)
		do
		end

	frozen g_blow_chunks is
			-- void g_blow_chunks (void);
			-- (from C_GLIB)
		do
		end

	frozen g_byte_array_append (a_array: POINTER; a_data: POINTER; a_len: INTEGER): POINTER is
			-- GByteArray* g_byte_array_append	           (GByteArray	 *array,
			-- 					    const guint8 *data,
			-- 					    guint	  len);
			-- (from C_GLIB)
		do
		end

	frozen g_byte_array_free (a_array: POINTER; a_free_segment: BOOLEAN) is
			-- void	    g_byte_array_free	           (GByteArray	 *array,
			-- 					    gboolean	  free_segment);
			-- (from C_GLIB)
		do
		end

	frozen g_byte_array_new: POINTER is
			-- GByteArray* g_byte_array_new	           (void);
			-- (from C_GLIB)
		do
		end

	frozen g_byte_array_prepend (a_array: POINTER; a_data: POINTER; a_len: INTEGER): POINTER is
			-- GByteArray* g_byte_array_prepend           (GByteArray	 *array,
			-- 					    const guint8 *data,
			-- 					    guint	  len);
			-- (from C_GLIB)
		do
		end

	frozen g_byte_array_remove_index (a_array: POINTER; a_index: INTEGER): POINTER is
			-- GByteArray* g_byte_array_remove_index	   (GByteArray	 *array,
			-- 					    guint	  index);
			-- (from C_GLIB)
		do
		end

	frozen g_byte_array_remove_index_fast (a_array: POINTER; a_index: INTEGER): POINTER is
			-- GByteArray* g_byte_array_remove_index_fast (GByteArray	 *array,
			-- 					    guint	  index);
			-- (from C_GLIB)
		do
		end

	frozen g_byte_array_set_size (a_array: POINTER; a_length: INTEGER): POINTER is
			-- GByteArray* g_byte_array_set_size          (GByteArray	 *array,
			-- 					    guint	  length);
			-- (from C_GLIB)
		do
		end

	frozen g_cache_destroy (a_cache: POINTER) is
			-- void	 g_cache_destroy       (GCache		  *cache);
			-- (from C_GLIB)
		do
		end

	frozen g_cache_insert (a_cache: POINTER; a_key: POINTER): POINTER is
			-- gpointer g_cache_insert	       (GCache		  *cache,
			-- 				gpointer	   key);
			-- (from C_GLIB)
		do
		end

	frozen g_cache_key_foreach (a_cache: POINTER; a_func: POINTER; a_user_data: POINTER) is
			-- void	 g_cache_key_foreach   (GCache		  *cache,
			-- 				GHFunc		   func,
			-- 				gpointer	   user_data);
			-- (from C_GLIB)
		do
		end

	frozen g_cache_new (a_value_new_func: POINTER; a_value_destroy_func: POINTER; a_key_dup_func: POINTER; a_key_destroy_func: POINTER; a_hash_key_func: POINTER; a_hash_value_func: POINTER; a_key_compare_func: POINTER): POINTER is
			-- GCache*	 g_cache_new	       (GCacheNewFunc	   value_new_func,
			-- 				GCacheDestroyFunc  value_destroy_func,
			-- 				GCacheDupFunc	   key_dup_func,
			-- 				GCacheDestroyFunc  key_destroy_func,
			-- 				GHashFunc	   hash_key_func,
			-- 				GHashFunc	   hash_value_func,
			-- 				GCompareFunc	   key_compare_func);
			-- (from C_GLIB)
		do
		end

	frozen g_cache_remove (a_cache: POINTER; a_value: POINTER) is
			-- void	 g_cache_remove	       (GCache		  *cache,
			-- 				gpointer	   value);
			-- (from C_GLIB)
		do
		end

	frozen g_cache_value_foreach (a_cache: POINTER; a_func: POINTER; a_user_data: POINTER) is
			-- void	 g_cache_value_foreach (GCache		  *cache,
			-- 				GHFunc		   func,
			-- 				gpointer	   user_data);
			-- (from C_GLIB)
		do
		end

	frozen g_completion_add_items (a_cmp: POINTER; a_items: POINTER) is
			-- void	     g_completion_add_items    (GCompletion*	cmp,
			-- 					GList*		items);
			-- (from C_GLIB)
		do
		end

	frozen g_completion_clear_items (a_cmp: POINTER) is
			-- void	     g_completion_clear_items  (GCompletion*	cmp);
			-- (from C_GLIB)
		do
		end

	frozen g_completion_complete (a_cmp: POINTER; a_prefix: POINTER; a_new_prefix: POINTER): POINTER is
			-- GList*	     g_completion_complete     (GCompletion*	cmp,
			-- 					gchar*		prefix,
			-- 					gchar**		new_prefix);
			-- (from C_GLIB)
		do
		end

	frozen g_completion_free (a_cmp: POINTER) is
			-- void	     g_completion_free	       (GCompletion*	cmp);
			-- (from C_GLIB)
		do
		end

	frozen g_completion_new (a_func: POINTER): POINTER is
			-- GCompletion* g_completion_new	       (GCompletionFunc func);
			-- (from C_GLIB)
		do
		end

	frozen g_completion_remove_items (a_cmp: POINTER; a_items: POINTER) is
			-- void	     g_completion_remove_items (GCompletion*	cmp,
			-- 					GList*		items);
			-- (from C_GLIB)
		do
		end

	frozen g_datalist_clear (a_datalist: POINTER) is
			-- void	  g_datalist_clear		 (GData		 **datalist);
			-- (from C_GLIB)
		do
		end

	frozen g_datalist_foreach (a_datalist: POINTER; a_func: POINTER; a_user_data: POINTER) is
			-- void	  g_datalist_foreach		 (GData		 **datalist,
			-- 					  GDataForeachFunc func,
			-- 					  gpointer	   user_data);
			-- (from C_GLIB)
		do
		end

	frozen g_datalist_id_get_data (a_datalist: POINTER; a_key_id: INTEGER): POINTER is
			-- gpointer  g_datalist_id_get_data	 (GData		 **datalist,
			-- 					  GQuark	   key_id);
			-- (from C_GLIB)
		do
		end

	frozen g_datalist_id_remove_no_notify (a_datalist: POINTER; a_key_id: INTEGER) is
			-- void	  g_datalist_id_remove_no_notify (GData		 **datalist,
			-- 					  GQuark	   key_id);
			-- (from C_GLIB)
		do
		end

	frozen g_datalist_id_set_data_full (a_datalist: POINTER; a_key_id: INTEGER; a_data: POINTER; a_destroy_func: POINTER) is
			-- void	  g_datalist_id_set_data_full	 (GData		 **datalist,
			-- 					  GQuark	   key_id,
			-- 					  gpointer	   data,
			-- 					  GDestroyNotify   destroy_func);
			-- (from C_GLIB)
		do
		end

	frozen g_datalist_init (a_datalist: POINTER) is
			-- void	  g_datalist_init		 (GData		 **datalist);
			-- (from C_GLIB)
		do
		end

	frozen g_dataset_destroy (a_dataset_location: POINTER) is
			-- void	  g_dataset_destroy		(gconstpointer	  dataset_location);
			-- (from C_GLIB)
		do
		end

	frozen g_dataset_foreach (a_dataset_location: POINTER; a_func: POINTER; a_user_data: POINTER) is
			-- void	  g_dataset_foreach		(gconstpointer	  dataset_location,
			-- 					 GDataForeachFunc func,
			-- 					 gpointer	  user_data);
			-- (from C_GLIB)
		do
		end

	frozen g_dataset_id_get_data (a_dataset_location: POINTER; a_key_id: INTEGER): POINTER is
			-- gpointer  g_dataset_id_get_data		(gconstpointer	  dataset_location,
			-- 					 GQuark		  key_id);
			-- (from C_GLIB)
		do
		end

	frozen g_dataset_id_remove_no_notify (a_dataset_location: POINTER; a_key_id: INTEGER) is
			-- void	  g_dataset_id_remove_no_notify	(gconstpointer	  dataset_location,
			-- 					 GQuark		  key_id);
			-- (from C_GLIB)
		do
		end

	frozen g_dataset_id_set_data_full (a_dataset_location: POINTER; a_key_id: INTEGER; a_data: POINTER; a_destroy_func: POINTER) is
			-- void	  g_dataset_id_set_data_full	(gconstpointer	  dataset_location,
			-- 					 GQuark		  key_id,
			-- 					 gpointer	  data,
			-- 					 GDestroyNotify	  destroy_func);
			-- (from C_GLIB)
		do
		end

	frozen g_date_add_days (a_date: POINTER; a_n_days: INTEGER) is
			-- void         g_date_add_days              (GDate       *date,
			--                                            guint        n_days);
			-- (from C_GLIB)
		do
		end

	frozen g_date_add_months (a_date: POINTER; a_n_months: INTEGER) is
			-- void         g_date_add_months            (GDate       *date,
			--                                            guint        n_months);
			-- (from C_GLIB)
		do
		end

	frozen g_date_add_years (a_date: POINTER; a_n_years: INTEGER) is
			-- void         g_date_add_years             (GDate       *date,
			--                                            guint        n_years);
			-- (from C_GLIB)
		do
		end

	frozen g_date_clear (a_date: POINTER; a_n_dates: INTEGER) is
			-- void         g_date_clear                 (GDate       *date,
			--                                            guint        n_dates);
			-- (from C_GLIB)
		do
		end

	frozen g_date_compare (a_lhs: POINTER; a_rhs: POINTER): INTEGER is
			-- gint         g_date_compare               (GDate       *lhs,
			--                                            GDate       *rhs);
			-- (from C_GLIB)
		do
		end

	frozen g_date_day (a_date: POINTER): INTEGER is
			-- GDateDay     g_date_day                   (GDate       *date);
			-- (from C_GLIB)
		do
		end

	frozen g_date_day_of_year (a_date: POINTER): INTEGER is
			-- guint        g_date_day_of_year           (GDate       *date);
			-- (from C_GLIB)
		do
		end

	frozen g_date_days_in_month (a_month: INTEGER; a_year: INTEGER): INTEGER is
			-- guint8       g_date_days_in_month         (GDateMonth   month,
			--                                            GDateYear    year);
			-- (from C_GLIB)
		do
		end

	frozen g_date_free (a_date: POINTER) is
			-- void         g_date_free                  (GDate       *date);
			-- (from C_GLIB)
		do
		end

	frozen g_date_is_first_of_month (a_date: POINTER): BOOLEAN is
			-- gboolean     g_date_is_first_of_month     (GDate       *date);
			-- (from C_GLIB)
		do
		end

	frozen g_date_is_last_of_month (a_date: POINTER): BOOLEAN is
			-- gboolean     g_date_is_last_of_month      (GDate       *date);
			-- (from C_GLIB)
		do
		end

	frozen g_date_is_leap_year (a_year: INTEGER): BOOLEAN is
			-- gboolean     g_date_is_leap_year          (GDateYear    year);
			-- (from C_GLIB)
		do
		end

	frozen g_date_julian (a_date: POINTER): NATURAL_32 is
			-- guint32      g_date_julian                (GDate       *date);
			-- (from C_GLIB)
		do
		end

	frozen g_date_monday_week_of_year (a_date: POINTER): INTEGER is
			-- guint        g_date_monday_week_of_year   (GDate      *date);
			-- (from C_GLIB)
		do
		end

	frozen g_date_monday_weeks_in_year (a_year: INTEGER): INTEGER is
			-- guint8       g_date_monday_weeks_in_year  (GDateYear    year);
			-- (from C_GLIB)
		do
		end

	frozen g_date_month (a_date: POINTER): INTEGER is
			-- GDateMonth   g_date_month                 (GDate       *date);
			-- (from C_GLIB)
		do
		end

	frozen g_date_new: POINTER is
			-- GDate*       g_date_new                   (void);
			-- (from C_GLIB)
		do
		end

	frozen g_date_new_dmy (a_day: INTEGER; a_month: INTEGER; a_year: INTEGER): POINTER is
			-- GDate*       g_date_new_dmy               (GDateDay     day,
			--                                            GDateMonth   month,
			--                                            GDateYear    year);
			-- (from C_GLIB)
		do
		end

	frozen g_date_new_julian (a_julian_day: INTEGER): POINTER is
			-- GDate*       g_date_new_julian            (guint32      julian_day);
			-- (from C_GLIB)
		do
		end

	frozen g_date_set_day (a_date: POINTER; a_day: INTEGER) is
			-- void         g_date_set_day               (GDate       *date,
			--                                            GDateDay     day);
			-- (from C_GLIB)
		do
		end

	frozen g_date_set_dmy (a_date: POINTER; a_day: INTEGER; a_month: INTEGER; a_y: INTEGER) is
			-- void         g_date_set_dmy               (GDate       *date,
			--                                            GDateDay     day,
			--                                            GDateMonth   month,
			--                                            GDateYear    y);
			-- (from C_GLIB)
		do
		end

	frozen g_date_set_julian (a_date: POINTER; a_julian_date: INTEGER) is
			-- void         g_date_set_julian            (GDate       *date,
			--                                            guint32      julian_date);
			-- (from C_GLIB)
		do
		end

	frozen g_date_set_month (a_date: POINTER; a_month: INTEGER) is
			-- void         g_date_set_month             (GDate       *date,
			--                                            GDateMonth   month);
			-- (from C_GLIB)
		do
		end

	frozen g_date_set_parse (a_date: POINTER; a_str: POINTER) is
			-- void         g_date_set_parse             (GDate       *date,
			--                                            const gchar *str);
			-- (from C_GLIB)
		do
		end

	frozen g_date_set_time (a_date: POINTER; a_time: INTEGER) is
			-- void         g_date_set_time              (GDate       *date,
			--                                            GTime        time);
			-- (from C_GLIB)
		do
		end

	frozen g_date_set_year (a_date: POINTER; a_year: INTEGER) is
			-- void         g_date_set_year              (GDate       *date,
			--                                            GDateYear    year);
			-- (from C_GLIB)
		do
		end

	frozen g_date_strftime (a_s: POINTER; a_slen: INTEGER; a_format: POINTER; a_date: POINTER): INTEGER is
			-- gsize        g_date_strftime              (gchar       *s,
			--                                            gsize        slen,
			--                                            const gchar *format,
			--                                            GDate       *date);
			-- (from C_GLIB)
		do
		end

	frozen g_date_subtract_days (a_date: POINTER; a_n_days: INTEGER) is
			-- void         g_date_subtract_days         (GDate       *date,
			--                                            guint        n_days);
			-- (from C_GLIB)
		do
		end

	frozen g_date_subtract_months (a_date: POINTER; a_n_months: INTEGER) is
			-- void         g_date_subtract_months       (GDate       *date,
			--                                            guint        n_months);
			-- (from C_GLIB)
		do
		end

	frozen g_date_subtract_years (a_date: POINTER; a_n_years: INTEGER) is
			-- void         g_date_subtract_years        (GDate       *date,
			--                                            guint        n_years);
			-- (from C_GLIB)
		do
		end

	frozen g_date_sunday_week_of_year (a_date: POINTER): INTEGER is
			-- guint        g_date_sunday_week_of_year   (GDate      *date);
			-- (from C_GLIB)
		do
		end

	frozen g_date_sunday_weeks_in_year (a_year: INTEGER): INTEGER is
			-- guint8       g_date_sunday_weeks_in_year  (GDateYear    year);
			-- (from C_GLIB)
		do
		end

	frozen g_date_to_struct_tm (a_date: POINTER; a_tm: POINTER) is
			-- void         g_date_to_struct_tm          (GDate       *date,
			--                                            struct tm   *tm);
			-- (from C_GLIB)
		do
		end

	frozen g_date_valid (a_date: POINTER): BOOLEAN is
			-- gboolean     g_date_valid                 (GDate       *date);
			-- (from C_GLIB)
		do
		end

	frozen g_date_valid_day (a_day: INTEGER): BOOLEAN is
			-- gboolean     g_date_valid_day             (GDateDay     day);
			-- (from C_GLIB)
		do
		end

	frozen g_date_valid_dmy (a_day: INTEGER; a_month: INTEGER; a_year: INTEGER): BOOLEAN is
			-- gboolean     g_date_valid_dmy             (GDateDay     day,
			--                                            GDateMonth   month,
			--                                            GDateYear    year);
			-- (from C_GLIB)
		do
		end

	frozen g_date_valid_julian (a_julian_date: INTEGER): BOOLEAN is
			-- gboolean     g_date_valid_julian          (guint32      julian_date);
			-- (from C_GLIB)
		do
		end

	frozen g_date_valid_month (a_month: INTEGER): BOOLEAN is
			-- gboolean     g_date_valid_month           (GDateMonth   month);
			-- (from C_GLIB)
		do
		end

	frozen g_date_valid_weekday (a_weekday: INTEGER): BOOLEAN is
			-- gboolean     g_date_valid_weekday         (GDateWeekday weekday);
			-- (from C_GLIB)
		do
		end

	frozen g_date_valid_year (a_year: INTEGER): BOOLEAN is
			-- gboolean     g_date_valid_year            (GDateYear    year);
			-- (from C_GLIB)
		do
		end

	frozen g_date_weekday (a_date: POINTER): INTEGER is
			-- GDateWeekday g_date_weekday               (GDate       *date);
			-- (from C_GLIB)
		do
		end

	frozen g_date_year (a_date: POINTER): INTEGER is
			-- GDateYear    g_date_year                  (GDate       *date);
			-- (from C_GLIB)
		do
		end

	frozen g_direct_equal (a_v: POINTER; a_v2: POINTER): INTEGER is
			-- gint  g_direct_equal (gconstpointer v,
			-- 		      gconstpointer v2);
			-- (from C_GLIB)
		do
		end

	frozen g_direct_hash (a_v: POINTER): INTEGER is
			-- guint g_direct_hash  (gconstpointer v);
			-- (from C_GLIB)
		do
		end

	frozen g_dirname (a_file_name: POINTER): POINTER is
			-- gchar*	g_dirname		(const gchar *file_name);
			-- (from C_GLIB)
		do
		end

	frozen g_free (a_mem: POINTER) is
			-- void	 g_free	       (gpointer  mem);
			-- (from C_GLIB)
		do
		end

	frozen g_get_current_dir: POINTER is
			-- gchar*	g_get_current_dir	(void);
			-- (from C_GLIB)
		do
		end

	frozen g_get_current_time (a_result: POINTER) is
			-- void g_get_current_time		        (GTimeVal	*result);
			-- (from C_GLIB)
		do
		end

	frozen g_get_home_dir: POINTER is
			-- gchar*	g_get_home_dir		(void);
			-- (from C_GLIB)
		do
		end

	frozen g_get_prgname: POINTER is
			-- gchar*	g_get_prgname		(void);
			-- (from C_GLIB)
		do
		end

	frozen g_get_real_name: POINTER is
			-- gchar*	g_get_real_name		(void);
			-- (from C_GLIB)
		do
		end

	frozen g_get_tmp_dir: POINTER is
			-- gchar*	g_get_tmp_dir		(void);
			-- (from C_GLIB)
		do
		end

	frozen g_get_user_name: POINTER is
			-- gchar*	g_get_user_name		(void);
			-- (from C_GLIB)
		do
		end

	frozen g_getenv (a_variable: POINTER): POINTER is
			-- gchar*  g_getenv		(const gchar *variable);
			-- (from C_GLIB)
		do
		end

	frozen g_hash_table_destroy (a_hash_table: POINTER) is
			-- void	    g_hash_table_destroy	(GHashTable	*hash_table);
			-- (from C_GLIB)
		do
		end

	frozen g_hash_table_foreach (a_hash_table: POINTER; a_func: POINTER; a_user_data: POINTER) is
			-- void	    g_hash_table_foreach	(GHashTable	*hash_table,
			-- 					 GHFunc		 func,
			-- 					 gpointer	 user_data);
			-- (from C_GLIB)
		do
		end

	frozen g_hash_table_foreach_remove (a_hash_table: POINTER; a_func: POINTER; a_user_data: POINTER): INTEGER is
			-- guint	    g_hash_table_foreach_remove	(GHashTable	*hash_table,
			-- 					 GHRFunc	 func,
			-- 					 gpointer	 user_data);
			-- (from C_GLIB)
		do
		end

	frozen g_hash_table_insert (a_hash_table: POINTER; a_key: POINTER; a_value: POINTER) is
			-- void	    g_hash_table_insert		(GHashTable	*hash_table,
			-- 					 gpointer	 key,
			-- 					 gpointer	 value);
			-- (from C_GLIB)
		do
		end

	frozen g_hash_table_lookup (a_hash_table: POINTER; a_key: POINTER): POINTER is
			-- gpointer    g_hash_table_lookup		(GHashTable	*hash_table,
			-- 					 gconstpointer	 key);
			-- (from C_GLIB)
		do
		end

	frozen g_hash_table_lookup_extended (a_hash_table: POINTER; a_lookup_key: POINTER; a_orig_key: POINTER; a_value: POINTER): BOOLEAN is
			-- gboolean    g_hash_table_lookup_extended(GHashTable	*hash_table,
			-- 					 gconstpointer	 lookup_key,
			-- 					 gpointer	*orig_key,
			-- 					 gpointer	*value);
			-- (from C_GLIB)
		do
		end

	frozen g_hash_table_new (a_hash_func: POINTER; a_key_compare_func: POINTER): POINTER is
			-- GHashTable* g_hash_table_new		(GHashFunc	 hash_func,
			-- 					 GCompareFunc	 key_compare_func);
			-- (from C_GLIB)
		do
		end

	frozen g_hash_table_remove (a_hash_table: POINTER; a_key: POINTER) is
			-- void	    g_hash_table_remove		(GHashTable	*hash_table,
			-- 					 gconstpointer	 key);
			-- (from C_GLIB)
		do
		end

	frozen g_hash_table_size (a_hash_table: POINTER): INTEGER is
			-- guint	    g_hash_table_size		(GHashTable	*hash_table);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_alloc (a_hook_list: POINTER): POINTER is
			-- GHook*	 g_hook_alloc			(GHookList		*hook_list);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_compare_ids (a_new_hook: POINTER; a_sibling: POINTER): INTEGER is
			-- gint	 g_hook_compare_ids		(GHook			*new_hook,
			-- 					 GHook			*sibling);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_destroy (a_hook_list: POINTER; a_hook_id: INTEGER): BOOLEAN is
			-- gboolean g_hook_destroy			(GHookList		*hook_list,
			-- 					 guint			 hook_id);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_destroy_link (a_hook_list: POINTER; a_hook: POINTER) is
			-- void	 g_hook_destroy_link		(GHookList		*hook_list,
			-- 					 GHook			*hook);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_find (a_hook_list: POINTER; a_need_valids: BOOLEAN; a_func: POINTER; a_data: POINTER): POINTER is
			-- GHook*	 g_hook_find			(GHookList		*hook_list,
			-- 					 gboolean		 need_valids,
			-- 					 GHookFindFunc		 func,
			-- 					 gpointer		 data);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_find_data (a_hook_list: POINTER; a_need_valids: BOOLEAN; a_data: POINTER): POINTER is
			-- GHook*	 g_hook_find_data		(GHookList		*hook_list,
			-- 					 gboolean		 need_valids,
			-- 					 gpointer		 data);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_find_func (a_hook_list: POINTER; a_need_valids: BOOLEAN; a_func: POINTER): POINTER is
			-- GHook*	 g_hook_find_func		(GHookList		*hook_list,
			-- 					 gboolean		 need_valids,
			-- 					 gpointer		 func);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_find_func_data (a_hook_list: POINTER; a_need_valids: BOOLEAN; a_func: POINTER; a_data: POINTER): POINTER is
			-- GHook*	 g_hook_find_func_data		(GHookList		*hook_list,
			-- 					 gboolean		 need_valids,
			-- 					 gpointer		 func,
			-- 					 gpointer		 data);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_first_valid (a_hook_list: POINTER; a_may_be_in_call: BOOLEAN): POINTER is
			-- GHook*	 g_hook_first_valid		(GHookList		*hook_list,
			-- 					 gboolean		 may_be_in_call);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_free (a_hook_list: POINTER; a_hook: POINTER) is
			-- void	 g_hook_free			(GHookList		*hook_list,
			-- 					 GHook			*hook);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_get (a_hook_list: POINTER; a_hook_id: INTEGER): POINTER is
			-- GHook*	 g_hook_get			(GHookList		*hook_list,
			-- 					 guint			 hook_id);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_insert_before (a_hook_list: POINTER; a_sibling: POINTER; a_hook: POINTER) is
			-- void	 g_hook_insert_before		(GHookList		*hook_list,
			-- 					 GHook			*sibling,
			-- 					 GHook			*hook);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_insert_sorted (a_hook_list: POINTER; a_hook: POINTER; a_func: POINTER) is
			-- void	 g_hook_insert_sorted		(GHookList		*hook_list,
			-- 					 GHook			*hook,
			-- 					 GHookCompareFunc	 func);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_list_clear (a_hook_list: POINTER) is
			-- void	 g_hook_list_clear		(GHookList		*hook_list);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_list_init (a_hook_list: POINTER; a_hook_size: INTEGER) is
			-- void	 g_hook_list_init		(GHookList		*hook_list,
			-- 					 guint			 hook_size);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_list_invoke (a_hook_list: POINTER; a_may_recurse: BOOLEAN) is
			-- void	 g_hook_list_invoke		(GHookList		*hook_list,
			-- 					 gboolean		 may_recurse);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_list_invoke_check (a_hook_list: POINTER; a_may_recurse: BOOLEAN) is
			-- void	 g_hook_list_invoke_check	(GHookList		*hook_list,
			-- 					 gboolean		 may_recurse);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_list_marshal (a_hook_list: POINTER; a_may_recurse: BOOLEAN; a_marshaller: POINTER; a_data: POINTER) is
			-- void	 g_hook_list_marshal		(GHookList		*hook_list,
			-- 					 gboolean		 may_recurse,
			-- 					 GHookMarshaller	 marshaller,
			-- 					 gpointer		 data);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_list_marshal_check (a_hook_list: POINTER; a_may_recurse: BOOLEAN; a_marshaller: POINTER; a_data: POINTER) is
			-- void	 g_hook_list_marshal_check	(GHookList		*hook_list,
			-- 					 gboolean		 may_recurse,
			-- 					 GHookCheckMarshaller	 marshaller,
			-- 					 gpointer		 data);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_next_valid (a_hook_list: POINTER; a_hook: POINTER; a_may_be_in_call: BOOLEAN): POINTER is
			-- GHook*	 g_hook_next_valid		(GHookList		*hook_list,
			-- 					 GHook			*hook,
			-- 					 gboolean		 may_be_in_call);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_prepend (a_hook_list: POINTER; a_hook: POINTER) is
			-- void	 g_hook_prepend			(GHookList		*hook_list,
			-- 					 GHook			*hook);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_ref (a_hook_list: POINTER; a_hook: POINTER) is
			-- void	 g_hook_ref			(GHookList		*hook_list,
			-- 					 GHook			*hook);
			-- (from C_GLIB)
		do
		end

	frozen g_hook_unref (a_hook_list: POINTER; a_hook: POINTER) is
			-- void	 g_hook_unref			(GHookList		*hook_list,
			-- 					 GHook			*hook);
			-- (from C_GLIB)
		do
		end

	frozen g_idle_add (a_function: POINTER; a_data: POINTER): INTEGER is
			-- guint		g_idle_add	   	(GSourceFunc	function,
			-- 					 gpointer	data);
			-- (from C_GLIB)
		do
		end

	frozen g_idle_add_full (a_priority: INTEGER; a_function: POINTER; a_data: POINTER; a_destroy: POINTER): INTEGER is
			-- guint	   	g_idle_add_full		(gint   	priority,
			-- 					 GSourceFunc	function,
			-- 					 gpointer	data,
			-- 					 GDestroyNotify destroy);
			-- (from C_GLIB)
		do
		end

	frozen g_idle_remove_by_data (a_data: POINTER): BOOLEAN is
			-- gboolean	g_idle_remove_by_data	(gpointer	data);
			-- (from C_GLIB)
		do
		end

	frozen g_list_alloc: POINTER is
			-- GList* g_list_alloc		(void);
			-- (from C_GLIB)
		do
		end

	frozen g_list_append (a_list: POINTER; a_data: POINTER): POINTER is
			-- GList* g_list_append		(GList		*list,
			-- 				 gpointer	 data);
			-- (from C_GLIB)
		do
		end

	frozen g_list_concat (a_list1: POINTER; a_list2: POINTER): POINTER is
			-- GList* g_list_concat		(GList		*list1,
			-- 				 GList		*list2);
			-- (from C_GLIB)
		do
		end

	frozen g_list_copy (a_list: POINTER): POINTER is
			-- GList* g_list_copy		(GList		*list);
			-- (from C_GLIB)
		do
		end

	frozen g_list_find (a_list: POINTER; a_data: POINTER): POINTER is
			-- GList* g_list_find		(GList		*list,
			-- 				 gpointer	 data);
			-- (from C_GLIB)
		do
		end

	frozen g_list_find_custom (a_list: POINTER; a_data: POINTER; a_func: POINTER): POINTER is
			-- GList* g_list_find_custom	(GList		*list,
			-- 				 gpointer	 data,
			-- 				 GCompareFunc	 func);
			-- (from C_GLIB)
		do
		end

	frozen g_list_first (a_list: POINTER): POINTER is
			-- GList* g_list_first		(GList		*list);
			-- (from C_GLIB)
		do
		end

	frozen g_list_foreach (a_list: POINTER; a_func: POINTER; a_user_data: POINTER) is
			-- void   g_list_foreach		(GList		*list,
			-- 				 GFunc		 func,
			-- 				 gpointer	 user_data);
			-- (from C_GLIB)
		do
		end

	frozen g_list_free (a_list: POINTER) is
			-- void   g_list_free		(GList		*list);
			-- (from C_GLIB)
		do
		end

	frozen g_list_free_1 (a_list: POINTER) is
			-- void   g_list_free_1		(GList		*list);
			-- (from C_GLIB)
		do
		end

	frozen g_list_index (a_list: POINTER; a_data: POINTER): INTEGER is
			-- gint   g_list_index		(GList		*list,
			-- 				 gpointer	 data);
			-- (from C_GLIB)
		do
		end

	frozen g_list_insert (a_list: POINTER; a_data: POINTER; a_position: INTEGER): POINTER is
			-- GList* g_list_insert		(GList		*list,
			-- 				 gpointer	 data,
			-- 				 gint		 position);
			-- (from C_GLIB)
		do
		end

	frozen g_list_insert_sorted (a_list: POINTER; a_data: POINTER; a_func: POINTER): POINTER is
			-- GList* g_list_insert_sorted	(GList		*list,
			-- 				 gpointer	 data,
			-- 				 GCompareFunc	 func);
			-- (from C_GLIB)
		do
		end

	frozen g_list_last (a_list: POINTER): POINTER is
			-- GList* g_list_last		(GList		*list);
			-- (from C_GLIB)
		do
		end

	frozen g_list_length (a_list: POINTER): INTEGER is
			-- guint  g_list_length		(GList		*list);
			-- (from C_GLIB)
		do
		end

	frozen g_list_nth (a_list: POINTER; a_n: INTEGER): POINTER is
			-- GList* g_list_nth		(GList		*list,
			-- 				 guint		 n);
			-- (from C_GLIB)
		do
		end

	frozen g_list_nth_data (a_list: POINTER; a_n: INTEGER): POINTER is
			-- gpointer g_list_nth_data	(GList		*list,
			-- 				 guint		 n);
			-- (from C_GLIB)
		do
		end

	frozen g_list_pop_allocator is
			-- void   g_list_pop_allocator     (void);
			-- (from C_GLIB)
		do
		end

	frozen g_list_position (a_list: POINTER; a_llink: POINTER): INTEGER is
			-- gint   g_list_position		(GList		*list,
			-- 				 GList		*llink);
			-- (from C_GLIB)
		do
		end

	frozen g_list_prepend (a_list: POINTER; a_data: POINTER): POINTER is
			-- GList* g_list_prepend		(GList		*list,
			-- 				 gpointer	 data);
			-- (from C_GLIB)
		do
		end

	frozen g_list_push_allocator (a_allocator: POINTER) is
			-- void   g_list_push_allocator    (GAllocator     *allocator);
			-- (from C_GLIB)
		do
		end

	frozen g_list_remove (a_list: POINTER; a_data: POINTER): POINTER is
			-- GList* g_list_remove		(GList		*list,
			-- 				 gpointer	 data);
			-- (from C_GLIB)
		do
		end

	frozen g_list_remove_link (a_list: POINTER; a_llink: POINTER): POINTER is
			-- GList* g_list_remove_link	(GList		*list,
			-- 				 GList		*llink);
			-- (from C_GLIB)
		do
		end

	frozen g_list_reverse (a_list: POINTER): POINTER is
			-- GList* g_list_reverse		(GList		*list);
			-- (from C_GLIB)
		do
		end

	frozen g_list_sort (a_list: POINTER; a_compare_func: POINTER): POINTER is
			-- GList* g_list_sort              (GList          *list,
			-- 		                 GCompareFunc    compare_func);
			-- (from C_GLIB)
		do
		end

	frozen g_log_default_handler (a_log_domain: POINTER; a_log_level: INTEGER; a_message: POINTER; a_unused_data: POINTER) is
			-- void		g_log_default_handler	(const gchar	*log_domain,
			-- 					 GLogLevelFlags	 log_level,
			-- 					 const gchar	*message,
			-- 					 gpointer	 unused_data);
			-- (from C_GLIB)
		do
		end

	frozen g_log_remove_handler (a_log_domain: POINTER; a_handler_id: INTEGER) is
			-- void		g_log_remove_handler	(const gchar	*log_domain,
			-- 					 guint		 handler_id);
			-- (from C_GLIB)
		do
		end

	frozen g_log_set_always_fatal (a_fatal_mask: INTEGER): INTEGER is
			-- GLogLevelFlags	g_log_set_always_fatal	(GLogLevelFlags	 fatal_mask);
			-- (from C_GLIB)
		do
		end

	frozen g_log_set_fatal_mask (a_log_domain: POINTER; a_fatal_mask: INTEGER): INTEGER is
			-- GLogLevelFlags	g_log_set_fatal_mask	(const gchar	*log_domain,
			-- 					 GLogLevelFlags	 fatal_mask);
			-- (from C_GLIB)
		do
		end

	frozen g_log_set_handler (a_log_domain: POINTER; a_log_levels: INTEGER; a_log_func: POINTER; a_user_data: POINTER): INTEGER is
			-- guint		g_log_set_handler	(const gchar	*log_domain,
			-- 					 GLogLevelFlags	 log_levels,
			-- 					 GLogFunc	 log_func,
			-- 					 gpointer	 user_data);
			-- (from C_GLIB)
		do
		end

	frozen g_main_iteration (a_may_block: BOOLEAN): BOOLEAN is
			-- gboolean	g_main_iteration	(gboolean	may_block);
			-- (from C_GLIB)
		do
		end

	frozen g_malloc (a_size: INTEGER): POINTER is
			-- gpointer g_malloc      (gulong	  size);
			-- (from C_GLIB)
		do
		end

	frozen g_malloc0 (a_size: INTEGER): POINTER is
			-- gpointer g_malloc0     (gulong	  size);
			-- (from C_GLIB)
		do
		end

	frozen g_mem_chunk_alloc (a_mem_chunk: POINTER): POINTER is
			-- gpointer   g_mem_chunk_alloc   (GMemChunk *mem_chunk);
			-- (from C_GLIB)
		do
		end

	frozen g_mem_chunk_alloc0 (a_mem_chunk: POINTER): POINTER is
			-- gpointer   g_mem_chunk_alloc0  (GMemChunk *mem_chunk);
			-- (from C_GLIB)
		do
		end

	frozen g_mem_chunk_clean (a_mem_chunk: POINTER) is
			-- void	   g_mem_chunk_clean   (GMemChunk *mem_chunk);
			-- (from C_GLIB)
		do
		end

	frozen g_mem_chunk_destroy (a_mem_chunk: POINTER) is
			-- void	   g_mem_chunk_destroy (GMemChunk *mem_chunk);
			-- (from C_GLIB)
		do
		end

	frozen g_mem_chunk_free (a_mem_chunk: POINTER; a_mem: POINTER) is
			-- void	   g_mem_chunk_free    (GMemChunk *mem_chunk,
			-- 				gpointer   mem);
			-- (from C_GLIB)
		do
		end

	frozen g_mem_chunk_info is
			-- void	   g_mem_chunk_info    (void);
			-- (from C_GLIB)
		do
		end

	frozen g_mem_chunk_new (a_name: POINTER; a_atom_size: INTEGER; a_area_size: INTEGER; a_type: INTEGER): POINTER is
			-- GMemChunk* g_mem_chunk_new     (gchar	  *name,
			-- 				gint	   atom_size,
			-- 				gulong	   area_size,
			-- 				gint	   type);
			-- (from C_GLIB)
		do
		end

	frozen g_mem_chunk_print (a_mem_chunk: POINTER) is
			-- void	   g_mem_chunk_print   (GMemChunk *mem_chunk);
			-- (from C_GLIB)
		do
		end

	frozen g_mem_chunk_reset (a_mem_chunk: POINTER) is
			-- void	   g_mem_chunk_reset   (GMemChunk *mem_chunk);
			-- (from C_GLIB)
		do
		end

	frozen g_mem_profile is
			-- void	 g_mem_profile (void);
			-- (from C_GLIB)
		do
		end

	frozen g_memdup (a_mem: POINTER; a_byte_size: INTEGER): POINTER is
			-- gpointer g_memdup		(gconstpointer mem,
			-- 				 guint	       byte_size);
			-- (from C_GLIB)
		do
		end

	frozen g_node_child_index (a_node: POINTER; a_data: POINTER): INTEGER is
			-- gint	 g_node_child_index	 (GNode		  *node,
			-- 				  gpointer	   data);
			-- (from C_GLIB)
		do
		end

	frozen g_node_child_position (a_node: POINTER; a_child: POINTER): INTEGER is
			-- gint	 g_node_child_position	 (GNode		  *node,
			-- 				  GNode		  *child);
			-- (from C_GLIB)
		do
		end

	frozen g_node_children_foreach (a_node: POINTER; a_flags: INTEGER; a_func: POINTER; a_data: POINTER) is
			-- void	 g_node_children_foreach (GNode		  *node,
			-- 				  GTraverseFlags   flags,
			-- 				  GNodeForeachFunc func,
			-- 				  gpointer	   data);
			-- (from C_GLIB)
		do
		end

	frozen g_node_depth (a_node: POINTER): INTEGER is
			-- guint	 g_node_depth		(GNode		  *node);
			-- (from C_GLIB)
		do
		end

	frozen g_node_destroy (a_root: POINTER) is
			-- void	 g_node_destroy		(GNode		  *root);
			-- (from C_GLIB)
		do
		end

	frozen g_node_find (a_root: POINTER; a_order: INTEGER; a_flags: INTEGER; a_data: POINTER): POINTER is
			-- GNode*	 g_node_find		(GNode		  *root,
			-- 				 GTraverseType	   order,
			-- 				 GTraverseFlags	   flags,
			-- 				 gpointer	   data);
			-- (from C_GLIB)
		do
		end

	frozen g_node_find_child (a_node: POINTER; a_flags: INTEGER; a_data: POINTER): POINTER is
			-- GNode*	 g_node_find_child	 (GNode		  *node,
			-- 				  GTraverseFlags   flags,
			-- 				  gpointer	   data);
			-- (from C_GLIB)
		do
		end

	frozen g_node_first_sibling (a_node: POINTER): POINTER is
			-- GNode*	 g_node_first_sibling	 (GNode		  *node);
			-- (from C_GLIB)
		do
		end

	frozen g_node_get_root (a_node: POINTER): POINTER is
			-- GNode*	 g_node_get_root	(GNode		  *node);
			-- (from C_GLIB)
		do
		end

	frozen g_node_insert (a_parent: POINTER; a_position: INTEGER; a_node: POINTER): POINTER is
			-- GNode*	 g_node_insert		(GNode		  *parent,
			-- 				 gint		   position,
			-- 				 GNode		  *node);
			-- (from C_GLIB)
		do
		end

	frozen g_node_insert_before (a_parent: POINTER; a_sibling: POINTER; a_node: POINTER): POINTER is
			-- GNode*	 g_node_insert_before	(GNode		  *parent,
			-- 				 GNode		  *sibling,
			-- 				 GNode		  *node);
			-- (from C_GLIB)
		do
		end

	frozen g_node_is_ancestor (a_node: POINTER; a_descendant: POINTER): BOOLEAN is
			-- gboolean g_node_is_ancestor	(GNode		  *node,
			-- 				 GNode		  *descendant);
			-- (from C_GLIB)
		do
		end

	frozen g_node_last_child (a_node: POINTER): POINTER is
			-- GNode*	 g_node_last_child	 (GNode		  *node);
			-- (from C_GLIB)
		do
		end

	frozen g_node_last_sibling (a_node: POINTER): POINTER is
			-- GNode*	 g_node_last_sibling	 (GNode		  *node);
			-- (from C_GLIB)
		do
		end

	frozen g_node_max_height (a_root: POINTER): INTEGER is
			-- guint	 g_node_max_height	 (GNode *root);
			-- (from C_GLIB)
		do
		end

	frozen g_node_n_children (a_node: POINTER): INTEGER is
			-- guint	 g_node_n_children	 (GNode		  *node);
			-- (from C_GLIB)
		do
		end

	frozen g_node_n_nodes (a_root: POINTER; a_flags: INTEGER): INTEGER is
			-- guint	 g_node_n_nodes		(GNode		  *root,
			-- 				 GTraverseFlags	   flags);
			-- (from C_GLIB)
		do
		end

	frozen g_node_new (a_data: POINTER): POINTER is
			-- GNode*	 g_node_new		(gpointer	   data);
			-- (from C_GLIB)
		do
		end

	frozen g_node_nth_child (a_node: POINTER; a_n: INTEGER): POINTER is
			-- GNode*	 g_node_nth_child	 (GNode		  *node,
			-- 				  guint		   n);
			-- (from C_GLIB)
		do
		end

	frozen g_node_pop_allocator is
			-- void     g_node_pop_allocator   (void);
			-- (from C_GLIB)
		do
		end

	frozen g_node_prepend (a_parent: POINTER; a_node: POINTER): POINTER is
			-- GNode*	 g_node_prepend		(GNode		  *parent,
			-- 				 GNode		  *node);
			-- (from C_GLIB)
		do
		end

	frozen g_node_push_allocator (a_allocator: POINTER) is
			-- void     g_node_push_allocator  (GAllocator       *allocator);
			-- (from C_GLIB)
		do
		end

	frozen g_node_reverse_children (a_node: POINTER) is
			-- void	 g_node_reverse_children (GNode		  *node);
			-- (from C_GLIB)
		do
		end

	frozen g_node_traverse (a_root: POINTER; a_order: INTEGER; a_flags: INTEGER; a_max_depth: INTEGER; a_func: POINTER; a_data: POINTER) is
			-- void	 g_node_traverse	(GNode		  *root,
			-- 				 GTraverseType	   order,
			-- 				 GTraverseFlags	   flags,
			-- 				 gint		   max_depth,
			-- 				 GNodeTraverseFunc func,
			-- 				 gpointer	   data);
			-- (from C_GLIB)
		do
		end

	frozen g_node_unlink (a_node: POINTER) is
			-- void	 g_node_unlink		(GNode		  *node);
			-- (from C_GLIB)
		do
		end

	frozen g_on_error_query (a_prg_name: POINTER) is
			-- void g_on_error_query (const gchar *prg_name);
			-- (from C_GLIB)
		do
		end

	frozen g_on_error_stack_trace (a_prg_name: POINTER) is
			-- void g_on_error_stack_trace (const gchar *prg_name);
			-- (from C_GLIB)
		do
		end

	frozen g_parse_debug_string (a_string: POINTER; a_keys: POINTER; a_nkeys: INTEGER): INTEGER is
			-- guint	g_parse_debug_string	(const gchar *string,
			-- 				 GDebugKey   *keys,
			-- 				 guint	      nkeys);
			-- (from C_GLIB)
		do
		end

	frozen g_path_is_absolute (a_file_name: POINTER): BOOLEAN is
			-- gboolean g_path_is_absolute	(const gchar *file_name);
			-- (from C_GLIB)
		do
		end

	frozen g_path_skip_root (a_file_name: POINTER): POINTER is
			-- gchar*  g_path_skip_root	(gchar       *file_name);
			-- (from C_GLIB)
		do
		end

	frozen g_ptr_array_add (a_array: POINTER; a_data: POINTER) is
			-- void	    g_ptr_array_add		   (GPtrArray	*array,
			-- 					    gpointer	 data);
			-- (from C_GLIB)
		do
		end

	frozen g_ptr_array_free (a_array: POINTER; a_free_seg: BOOLEAN) is
			-- void	    g_ptr_array_free		   (GPtrArray	*array,
			-- 					    gboolean	 free_seg);
			-- (from C_GLIB)
		do
		end

	frozen g_ptr_array_new: POINTER is
			-- GPtrArray*  g_ptr_array_new		   (void);
			-- (from C_GLIB)
		do
		end

	frozen g_ptr_array_remove (a_array: POINTER; a_data: POINTER): BOOLEAN is
			-- gboolean    g_ptr_array_remove		   (GPtrArray	*array,
			-- 					    gpointer	 data);
			-- (from C_GLIB)
		do
		end

	frozen g_ptr_array_remove_fast (a_array: POINTER; a_data: POINTER): BOOLEAN is
			-- gboolean    g_ptr_array_remove_fast        (GPtrArray	*array,
			-- 					    gpointer	 data);
			-- (from C_GLIB)
		do
		end

	frozen g_ptr_array_remove_index (a_array: POINTER; a_index: INTEGER): POINTER is
			-- gpointer    g_ptr_array_remove_index	   (GPtrArray	*array,
			-- 					    guint	 index);
			-- (from C_GLIB)
		do
		end

	frozen g_ptr_array_remove_index_fast (a_array: POINTER; a_index: INTEGER): POINTER is
			-- gpointer    g_ptr_array_remove_index_fast  (GPtrArray	*array,
			-- 					    guint	 index);
			-- (from C_GLIB)
		do
		end

	frozen g_ptr_array_set_size (a_array: POINTER; a_length: INTEGER) is
			-- void	    g_ptr_array_set_size	   (GPtrArray	*array,
			-- 					    gint	 length);
			-- (from C_GLIB)
		do
		end

	frozen g_quark_from_static_string (a_string: POINTER): INTEGER is
			-- GQuark	  g_quark_from_static_string	(const gchar	*string);
			-- (from C_GLIB)
		do
		end

	frozen g_quark_from_string (a_string: POINTER): INTEGER is
			-- GQuark	  g_quark_from_string		(const gchar	*string);
			-- (from C_GLIB)
		do
		end

	frozen g_quark_to_string (a_quark: INTEGER): POINTER is
			-- gchar*	  g_quark_to_string		(GQuark		 quark);
			-- (from C_GLIB)
		do
		end

	frozen g_quark_try_string (a_string: POINTER): INTEGER is
			-- GQuark	  g_quark_try_string		(const gchar	*string);
			-- (from C_GLIB)
		do
		end

	frozen g_realloc (a_mem: POINTER; a_size: INTEGER): POINTER is
			-- gpointer g_realloc     (gpointer  mem,
			-- 			gulong	  size);
			-- (from C_GLIB)
		do
		end

	frozen g_relation_count (a_relation: POINTER; a_key: POINTER; a_field: INTEGER): INTEGER is
			-- gint	   g_relation_count   (GRelation   *relation,
			-- 			       gconstpointer  key,
			-- 			       gint	    field);
			-- (from C_GLIB)
		do
		end

	frozen g_relation_delete (a_relation: POINTER; a_key: POINTER; a_field: INTEGER): INTEGER is
			-- gint	   g_relation_delete  (GRelation   *relation,
			-- 			       gconstpointer  key,
			-- 			       gint	    field);
			-- (from C_GLIB)
		do
		end

	frozen g_relation_destroy (a_relation: POINTER) is
			-- void	   g_relation_destroy (GRelation   *relation);
			-- (from C_GLIB)
		do
		end

	frozen g_relation_index (a_relation: POINTER; a_field: INTEGER; a_hash_func: POINTER; a_key_compare_func: POINTER) is
			-- void	   g_relation_index   (GRelation   *relation,
			-- 			       gint	    field,
			-- 			       GHashFunc    hash_func,
			-- 			       GCompareFunc key_compare_func);
			-- (from C_GLIB)
		do
		end

	frozen g_relation_new (a_fields: INTEGER): POINTER is
			-- GRelation* g_relation_new     (gint	    fields);
			-- (from C_GLIB)
		do
		end

	frozen g_relation_print (a_relation: POINTER) is
			-- void	   g_relation_print   (GRelation   *relation);
			-- (from C_GLIB)
		do
		end

	frozen g_relation_select (a_relation: POINTER; a_key: POINTER; a_field: INTEGER): POINTER is
			-- GTuples*   g_relation_select  (GRelation   *relation,
			-- 			       gconstpointer  key,
			-- 			       gint	    field);
			-- (from C_GLIB)
		do
		end

	frozen g_scanner_cur_line (a_scanner: POINTER): INTEGER is
			-- guint		g_scanner_cur_line		(GScanner	*scanner);
			-- (from C_GLIB)
		do
		end

	frozen g_scanner_cur_position (a_scanner: POINTER): INTEGER is
			-- guint		g_scanner_cur_position		(GScanner	*scanner);
			-- (from C_GLIB)
		do
		end

	frozen g_scanner_cur_token (a_scanner: POINTER): INTEGER is
			-- GTokenType	g_scanner_cur_token		(GScanner	*scanner);
			-- (from C_GLIB)
		do
		end

	frozen g_scanner_destroy (a_scanner: POINTER) is
			-- void		g_scanner_destroy		(GScanner	*scanner);
			-- (from C_GLIB)
		do
		end

	frozen g_scanner_eof (a_scanner: POINTER): BOOLEAN is
			-- gboolean	g_scanner_eof			(GScanner	*scanner);
			-- (from C_GLIB)
		do
		end

	frozen g_scanner_get_next_token (a_scanner: POINTER): INTEGER is
			-- GTokenType	g_scanner_get_next_token	(GScanner	*scanner);
			-- (from C_GLIB)
		do
		end

	frozen g_scanner_input_file (a_scanner: POINTER; a_input_fd: INTEGER) is
			-- void		g_scanner_input_file		(GScanner	*scanner,
			-- 						 gint		input_fd);
			-- (from C_GLIB)
		do
		end

	frozen g_scanner_input_text (a_scanner: POINTER; a_text: POINTER; a_text_len: INTEGER) is
			-- void		g_scanner_input_text		(GScanner	*scanner,
			-- 						 const	gchar	*text,
			-- 						 guint		text_len);
			-- (from C_GLIB)
		do
		end

	frozen g_scanner_lookup_symbol (a_scanner: POINTER; a_symbol: POINTER): POINTER is
			-- gpointer	g_scanner_lookup_symbol		(GScanner	*scanner,
			-- 						 const gchar	*symbol);
			-- (from C_GLIB)
		do
		end

	frozen g_scanner_new (a_config_templ: POINTER): POINTER is
			-- GScanner*	g_scanner_new			(GScannerConfig *config_templ);
			-- (from C_GLIB)
		do
		end

	frozen g_scanner_peek_next_token (a_scanner: POINTER): INTEGER is
			-- GTokenType	g_scanner_peek_next_token	(GScanner	*scanner);
			-- (from C_GLIB)
		do
		end

	frozen g_scanner_scope_add_symbol (a_scanner: POINTER; a_scope_id: INTEGER; a_symbol: POINTER; a_value: POINTER) is
			-- void		g_scanner_scope_add_symbol	(GScanner	*scanner,
			-- 						 guint		 scope_id,
			-- 						 const gchar	*symbol,
			-- 						 gpointer	value);
			-- (from C_GLIB)
		do
		end

	frozen g_scanner_scope_foreach_symbol (a_scanner: POINTER; a_scope_id: INTEGER; a_func: POINTER; a_user_data: POINTER) is
			-- void		g_scanner_scope_foreach_symbol	(GScanner	*scanner,
			-- 						 guint		 scope_id,
			-- 						 GHFunc		 func,
			-- 						 gpointer	 user_data);
			-- (from C_GLIB)
		do
		end

	frozen g_scanner_scope_lookup_symbol (a_scanner: POINTER; a_scope_id: INTEGER; a_symbol: POINTER): POINTER is
			-- gpointer	g_scanner_scope_lookup_symbol	(GScanner	*scanner,
			-- 						 guint		 scope_id,
			-- 						 const gchar	*symbol);
			-- (from C_GLIB)
		do
		end

	frozen g_scanner_scope_remove_symbol (a_scanner: POINTER; a_scope_id: INTEGER; a_symbol: POINTER) is
			-- void		g_scanner_scope_remove_symbol	(GScanner	*scanner,
			-- 						 guint		 scope_id,
			-- 						 const gchar	*symbol);
			-- (from C_GLIB)
		do
		end

	frozen g_scanner_set_scope (a_scanner: POINTER; a_scope_id: INTEGER): INTEGER is
			-- guint		g_scanner_set_scope		(GScanner	*scanner,
			-- 						 guint		 scope_id);
			-- (from C_GLIB)
		do
		end

	frozen g_scanner_sync_file_offset (a_scanner: POINTER) is
			-- void		g_scanner_sync_file_offset	(GScanner	*scanner);
			-- (from C_GLIB)
		do
		end

	frozen g_scanner_unexp_token (a_scanner: POINTER; a_expected_token: INTEGER; a_identifier_spec: POINTER; a_symbol_spec: POINTER; a_symbol_name: POINTER; a_message: POINTER; a_is_error: INTEGER) is
			-- void		g_scanner_unexp_token		(GScanner	*scanner,
			-- 						 GTokenType	expected_token,
			-- 						 const gchar	*identifier_spec,
			-- 						 const gchar	*symbol_spec,
			-- 						 const gchar	*symbol_name,
			-- 						 const gchar	*message,
			-- 						 gint		 is_error);
			-- (from C_GLIB)
		do
		end

	frozen g_set_prgname (a_prgname: POINTER) is
			-- void	g_set_prgname		(const gchar *prgname);
			-- (from C_GLIB)
		do
		end

	frozen g_set_print_handler (a_func: POINTER): POINTER is
			-- GPrintFunc	g_set_print_handler	(GPrintFunc	 func);
			-- (from C_GLIB)
		do
		end

	frozen g_set_printerr_handler (a_func: POINTER): POINTER is
			-- GPrintFunc	g_set_printerr_handler	(GPrintFunc	 func);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_alloc: POINTER is
			-- GSList* g_slist_alloc		(void);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_append (a_list: POINTER; a_data: POINTER): POINTER is
			-- GSList* g_slist_append		(GSList		*list,
			-- 				 gpointer	 data);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_concat (a_list1: POINTER; a_list2: POINTER): POINTER is
			-- GSList* g_slist_concat		(GSList		*list1,
			-- 				 GSList		*list2);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_copy (a_list: POINTER): POINTER is
			-- GSList*	g_slist_copy		(GSList		*list);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_find (a_list: POINTER; a_data: POINTER): POINTER is
			-- GSList* g_slist_find		(GSList		*list,
			-- 				 gpointer	 data);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_find_custom (a_list: POINTER; a_data: POINTER; a_func: POINTER): POINTER is
			-- GSList* g_slist_find_custom	(GSList		*list,
			-- 				 gpointer	 data,
			-- 				 GCompareFunc	 func);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_foreach (a_list: POINTER; a_func: POINTER; a_user_data: POINTER) is
			-- void	g_slist_foreach		(GSList		*list,
			-- 				 GFunc		 func,
			-- 				 gpointer	 user_data);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_free (a_list: POINTER) is
			-- void	g_slist_free		(GSList		*list);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_free_1 (a_list: POINTER) is
			-- void	g_slist_free_1		(GSList		*list);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_index (a_list: POINTER; a_data: POINTER): INTEGER is
			-- gint	g_slist_index		(GSList		*list,
			-- 				 gpointer	 data);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_insert (a_list: POINTER; a_data: POINTER; a_position: INTEGER): POINTER is
			-- GSList* g_slist_insert		(GSList		*list,
			-- 				 gpointer	 data,
			-- 				 gint		 position);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_insert_sorted (a_list: POINTER; a_data: POINTER; a_func: POINTER): POINTER is
			-- GSList* g_slist_insert_sorted	(GSList		*list,
			-- 				 gpointer	 data,
			-- 				 GCompareFunc	 func);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_last (a_list: POINTER): POINTER is
			-- GSList* g_slist_last		(GSList		*list);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_length (a_list: POINTER): INTEGER is
			-- guint	g_slist_length		(GSList		*list);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_nth (a_list: POINTER; a_n: INTEGER): POINTER is
			-- GSList* g_slist_nth		(GSList		*list,
			-- 				 guint		 n);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_nth_data (a_list: POINTER; a_n: INTEGER): POINTER is
			-- gpointer g_slist_nth_data	(GSList		*list,
			-- 				 guint		 n);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_pop_allocator is
			-- void    g_slist_pop_allocator   (void);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_position (a_list: POINTER; a_llink: POINTER): INTEGER is
			-- gint	g_slist_position	(GSList		*list,
			-- 				 GSList		*llink);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_prepend (a_list: POINTER; a_data: POINTER): POINTER is
			-- GSList* g_slist_prepend		(GSList		*list,
			-- 				 gpointer	 data);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_push_allocator (a_allocator: POINTER) is
			-- void    g_slist_push_allocator  (GAllocator     *allocator);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_remove (a_list: POINTER; a_data: POINTER): POINTER is
			-- GSList* g_slist_remove		(GSList		*list,
			-- 				 gpointer	 data);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_remove_link (a_list: POINTER; a_llink: POINTER): POINTER is
			-- GSList* g_slist_remove_link	(GSList		*list,
			-- 				 GSList		*llink);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_reverse (a_list: POINTER): POINTER is
			-- GSList* g_slist_reverse		(GSList		*list);
			-- (from C_GLIB)
		do
		end

	frozen g_slist_sort (a_list: POINTER; a_compare_func: POINTER): POINTER is
			-- GSList*  g_slist_sort           (GSList          *list,
			-- 		                 GCompareFunc    compare_func);
			-- (from C_GLIB)
		do
		end

	frozen g_source_remove (a_tag: INTEGER): BOOLEAN is
			-- gboolean g_source_remove                     (guint          tag);
			-- (from C_GLIB)
		do
		end

	frozen g_source_remove_by_funcs_user_data (a_funcs: POINTER; a_user_data: POINTER): BOOLEAN is
			-- gboolean g_source_remove_by_funcs_user_data  (GSourceFuncs  *funcs,
			-- 					      gpointer       user_data);
			-- (from C_GLIB)
		do
		end

	frozen g_source_remove_by_user_data (a_user_data: POINTER): BOOLEAN is
			-- gboolean g_source_remove_by_user_data        (gpointer       user_data);
			-- (from C_GLIB)
		do
		end

	frozen g_spaced_primes_closest (a_num: INTEGER): INTEGER is
			-- guint	   g_spaced_primes_closest (guint num);
			-- (from C_GLIB)
		do
		end

	frozen g_static_mutex_get_mutex_impl (a_mutex: POINTER): POINTER is
			-- GMutex*	g_static_mutex_get_mutex_impl	(GMutex	**mutex);
			-- (from C_GLIB)
		do
		end

	frozen g_static_private_get (a_private_key: POINTER): POINTER is
			-- gpointer g_static_private_get (GStaticPrivate	*private_key);
			-- (from C_GLIB)
		do
		end

	frozen g_static_private_set (a_private_key: POINTER; a_data: POINTER; a_notify: POINTER) is
			-- void     g_static_private_set (GStaticPrivate	*private_key,
			-- 			       gpointer        	 data,
			-- 			       GDestroyNotify    notify);
			-- (from C_GLIB)
		do
		end

	frozen g_str_equal (a_v: POINTER; a_v2: POINTER): INTEGER is
			-- gint  g_str_equal (gconstpointer   v,
			-- 		   gconstpointer   v2);
			-- (from C_GLIB)
		do
		end

	frozen g_str_hash (a_v: POINTER): INTEGER is
			-- guint g_str_hash  (gconstpointer   v);
			-- (from C_GLIB)
		do
		end

	frozen g_strcasecmp (a_s1: POINTER; a_s2: POINTER): INTEGER is
			-- gint	 g_strcasecmp		(const gchar *s1,
			-- 				 const gchar *s2);
			-- (from C_GLIB)
		do
		end

	frozen g_strchomp (a_string: POINTER): POINTER is
			-- gchar*  g_strchomp              (gchar        *string);
			-- (from C_GLIB)
		do
		end

	frozen g_strchug (a_string: POINTER): POINTER is
			-- gchar*   g_strchug              (gchar        *string);
			-- (from C_GLIB)
		do
		end

	frozen g_strdelimit (a_string: POINTER; a_delimiters: POINTER; a_new_delimiter: INTEGER): POINTER is
			-- gchar*	 g_strdelimit		(gchar	     *string,
			-- 				 const gchar *delimiters,
			-- 				 gchar	      new_delimiter);
			-- (from C_GLIB)
		do
		end

	frozen g_strdown (a_string: POINTER) is
			-- void	 g_strdown		(gchar	     *string);
			-- (from C_GLIB)
		do
		end

	frozen g_strdup (a_str: POINTER): POINTER is
			-- gchar*	 g_strdup		(const gchar *str);
			-- (from C_GLIB)
		do
		end

	frozen g_strerror (a_errnum: INTEGER): POINTER is
			-- gchar*	 g_strerror		(gint	      errnum);
			-- (from C_GLIB)
		do
		end

	frozen g_strfreev (a_str_array: POINTER) is
			-- void     g_strfreev		(gchar       **str_array);
			-- (from C_GLIB)
		do
		end

	frozen g_string_append (a_string: POINTER; a_val: POINTER): POINTER is
			-- GString* g_string_append    (GString	 *string,
			-- 			     const gchar *val);
			-- (from C_GLIB)
		do
		end

	frozen g_string_append_c (a_string: POINTER; a_c: INTEGER): POINTER is
			-- GString* g_string_append_c  (GString	 *string,
			-- 			     gchar	  c);
			-- (from C_GLIB)
		do
		end

	frozen g_string_assign (a_lval: POINTER; a_rval: POINTER): POINTER is
			-- GString* g_string_assign    (GString	 *lval,
			-- 			     const gchar *rval);
			-- (from C_GLIB)
		do
		end

	frozen g_string_chunk_free (a_chunk: POINTER) is
			-- void	      g_string_chunk_free	   (GStringChunk *chunk);
			-- (from C_GLIB)
		do
		end

	frozen g_string_chunk_insert (a_chunk: POINTER; a_string: POINTER): POINTER is
			-- gchar*	      g_string_chunk_insert	   (GStringChunk *chunk,
			-- 					    const gchar	 *string);
			-- (from C_GLIB)
		do
		end

	frozen g_string_chunk_insert_const (a_chunk: POINTER; a_string: POINTER): POINTER is
			-- gchar*	      g_string_chunk_insert_const  (GStringChunk *chunk,
			-- 					    const gchar	 *string);
			-- (from C_GLIB)
		do
		end

	frozen g_string_chunk_new (a_size: INTEGER): POINTER is
			-- GStringChunk* g_string_chunk_new	   (gint size);
			-- (from C_GLIB)
		do
		end

	frozen g_string_down (a_string: POINTER): POINTER is
			-- GString* g_string_down	    (GString	 *string);
			-- (from C_GLIB)
		do
		end

	frozen g_string_erase (a_string: POINTER; a_pos: INTEGER; a_len: INTEGER): POINTER is
			-- GString* g_string_erase	    (GString	 *string,
			-- 			     gint	  pos,
			-- 			     gint	  len);
			-- (from C_GLIB)
		do
		end

	frozen g_string_free (a_string: POINTER; a_free_segment: INTEGER) is
			-- void	 g_string_free	    (GString	 *string,
			-- 			     gint	  free_segment);
			-- (from C_GLIB)
		do
		end

	frozen g_string_insert (a_string: POINTER; a_pos: INTEGER; a_val: POINTER): POINTER is
			-- GString* g_string_insert    (GString	 *string,
			-- 			     gint	  pos,
			-- 			     const gchar *val);
			-- (from C_GLIB)
		do
		end

	frozen g_string_insert_c (a_string: POINTER; a_pos: INTEGER; a_c: INTEGER): POINTER is
			-- GString* g_string_insert_c  (GString	 *string,
			-- 			     gint	  pos,
			-- 			     gchar	  c);
			-- (from C_GLIB)
		do
		end

	frozen g_string_new (a_init: POINTER): POINTER is
			-- GString* g_string_new	    (const gchar *init);
			-- (from C_GLIB)
		do
		end

	frozen g_string_prepend (a_string: POINTER; a_val: POINTER): POINTER is
			-- GString* g_string_prepend   (GString	 *string,
			-- 			     const gchar *val);
			-- (from C_GLIB)
		do
		end

	frozen g_string_prepend_c (a_string: POINTER; a_c: INTEGER): POINTER is
			-- GString* g_string_prepend_c (GString	 *string,
			-- 			     gchar	  c);
			-- (from C_GLIB)
		do
		end

	frozen g_string_sized_new (a_dfl_size: INTEGER): POINTER is
			-- GString* g_string_sized_new (guint	  dfl_size);
			-- (from C_GLIB)
		do
		end

	frozen g_string_truncate (a_string: POINTER; a_len: INTEGER): POINTER is
			-- GString* g_string_truncate  (GString	 *string,
			-- 			     gint	  len);
			-- (from C_GLIB)
		do
		end

	frozen g_string_up (a_string: POINTER): POINTER is
			-- GString* g_string_up	    (GString	 *string);
			-- (from C_GLIB)
		do
		end

	frozen g_strjoinv (a_separator: POINTER; a_str_array: POINTER): POINTER is
			-- gchar*   g_strjoinv		(const gchar  *separator,
			-- 				 gchar       **str_array);
			-- (from C_GLIB)
		do
		end

	frozen g_strncasecmp (a_s1: POINTER; a_s2: POINTER; a_n: INTEGER): INTEGER is
			-- gint	 g_strncasecmp		(const gchar *s1,
			-- 				 const gchar *s2,
			-- 				 guint 	      n);
			-- (from C_GLIB)
		do
		end

	frozen g_strndup (a_str: POINTER; a_n: INTEGER): POINTER is
			-- gchar*	 g_strndup		(const gchar *str,
			-- 				 guint	      n);
			-- (from C_GLIB)
		do
		end

	frozen g_strnfill (a_length: INTEGER; a_fill_char: INTEGER): POINTER is
			-- gchar*	 g_strnfill		(guint	      length,
			-- 				 gchar	      fill_char);
			-- (from C_GLIB)
		do
		end

	frozen g_strreverse (a_string: POINTER) is
			-- void	 g_strreverse		(gchar	     *string);
			-- (from C_GLIB)
		do
		end

	frozen g_strsignal (a_signum: INTEGER): POINTER is
			-- gchar*	 g_strsignal		(gint	      signum);
			-- (from C_GLIB)
		do
		end

	frozen g_strsplit (a_string: POINTER; a_delimiter: POINTER; a_max_tokens: INTEGER): POINTER is
			-- gchar**	 g_strsplit		(const gchar  *string,
			-- 				 const gchar  *delimiter,
			-- 				 gint          max_tokens);
			-- (from C_GLIB)
		do
		end

	frozen g_strtod (a_nptr: POINTER; a_endptr: POINTER): 		doUBLE is
			-- g		double	 g_strtod		(const gchar *nptr,
			-- 				 gchar	    **endptr);
			-- (from C_GLIB)
		do
		end

	frozen g_strup (a_string: POINTER) is
			-- void	 g_strup		(gchar	     *string);
			-- (from C_GLIB)
		do
		end

	frozen g_timeout_add (a_interval: INTEGER; a_function: POINTER; a_data: POINTER): INTEGER is
			-- guint		g_timeout_add		(guint          interval,
			-- 					 GSourceFunc    function,
			-- 					 gpointer       data);
			-- (from C_GLIB)
		do
		end

	frozen g_timeout_add_full (a_priority: INTEGER; a_interval: INTEGER; a_function: POINTER; a_data: POINTER; a_notify: POINTER): INTEGER is
			-- guint		g_timeout_add_full	(gint           priority,
			-- 					 guint          interval,
			-- 					 GSourceFunc    function,
			-- 					 gpointer       data,
			-- 					 GDestroyNotify notify);
			-- (from C_GLIB)
		do
		end

	frozen g_timer_destroy (a_timer: POINTER) is
			-- void	g_timer_destroy (GTimer	 *timer);
			-- (from C_GLIB)
		do
		end

	frozen g_timer_elapsed (a_timer: POINTER; a_microseconds: POINTER): 		doUBLE is
			-- g		double g_timer_elapsed (GTimer	 *timer,
			-- 			 gulong	 *microseconds);
			-- (from C_GLIB)
		do
		end

	frozen g_timer_new: POINTER is
			-- GTimer* g_timer_new	(void);
			-- (from C_GLIB)
		do
		end

	frozen g_timer_reset (a_timer: POINTER) is
			-- void	g_timer_reset	(GTimer	 *timer);
			-- (from C_GLIB)
		do
		end

	frozen g_timer_start (a_timer: POINTER) is
			-- void	g_timer_start	(GTimer	 *timer);
			-- (from C_GLIB)
		do
		end

	frozen g_timer_stop (a_timer: POINTER) is
			-- void	g_timer_stop	(GTimer	 *timer);
			-- (from C_GLIB)
		do
		end

	frozen g_tree_destroy (a_tree: POINTER) is
			-- void	 g_tree_destroy	 (GTree		*tree);
			-- (from C_GLIB)
		do
		end

	frozen g_tree_height (a_tree: POINTER): INTEGER is
			-- gint	 g_tree_height	 (GTree		*tree);
			-- (from C_GLIB)
		do
		end

	frozen g_tree_insert (a_tree: POINTER; a_key: POINTER; a_value: POINTER) is
			-- void	 g_tree_insert	 (GTree		*tree,
			-- 			  gpointer	 key,
			-- 			  gpointer	 value);
			-- (from C_GLIB)
		do
		end

	frozen g_tree_lookup (a_tree: POINTER; a_key: POINTER): POINTER is
			-- gpointer g_tree_lookup	 (GTree		*tree,
			-- 			  gpointer	 key);
			-- (from C_GLIB)
		do
		end

	frozen g_tree_new (a_key_compare_func: POINTER): POINTER is
			-- GTree*	 g_tree_new	 (GCompareFunc	 key_compare_func);
			-- (from C_GLIB)
		do
		end

	frozen g_tree_nnodes (a_tree: POINTER): INTEGER is
			-- gint	 g_tree_nnodes	 (GTree		*tree);
			-- (from C_GLIB)
		do
		end

	frozen g_tree_remove (a_tree: POINTER; a_key: POINTER) is
			-- void	 g_tree_remove	 (GTree		*tree,
			-- 			  gpointer	 key);
			-- (from C_GLIB)
		do
		end

	frozen g_tree_traverse (a_tree: POINTER; a_traverse_func: POINTER; a_traverse_type: INTEGER; a_data: POINTER) is
			-- void	 g_tree_traverse (GTree		*tree,
			-- 			  GTraverseFunc	 traverse_func,
			-- 			  GTraverseType	 traverse_type,
			-- 			  gpointer	 data);
			-- (from C_GLIB)
		do
		end

	frozen g_tuples_destroy (a_tuples: POINTER) is
			-- void	   g_tuples_destroy   (GTuples	   *tuples);
			-- (from C_GLIB)
		do
		end

	frozen g_tuples_index (a_tuples: POINTER; a_index: INTEGER; a_field: INTEGER): POINTER is
			-- gpointer   g_tuples_index     (GTuples	   *tuples,
			-- 			       gint	    index,
			-- 			       gint	    field);
			-- (from C_GLIB)
		do
		end

	frozen gdk_beep is
			-- void gdk_beep (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_bitmap_create_from_data (a_window: POINTER; a_data: POINTER; a_width: INTEGER; a_height: INTEGER): POINTER is
			-- GdkBitmap* gdk_bitmap_create_from_data	(Gdkwindow   *window,
			-- 					 const gchar *data,
			-- 					 gint	      width,
			-- 					 gint	      height);
			-- (from C_GDK)
		do
		end

	frozen gdk_bitmap_ref (a_pixmap: POINTER): POINTER is
			-- GdkBitmap *gdk_bitmap_ref		(GdkBitmap  *pixmap);
			-- (from C_GDK)
		do
		end

	frozen gdk_bitmap_unref (a_pixmap: POINTER) is
			-- void	   gdk_bitmap_unref		(GdkBitmap  *pixmap);
			-- (from C_GDK)
		do
		end

	frozen gdk_char_height (a_font: POINTER; a_character: INTEGER): INTEGER is
			-- gint	 gdk_char_height    (GdkFont        *font,
			-- 			     gchar           character);
			-- (from C_GDK)
		do
		end

	frozen gdk_char_measure (a_font: POINTER; a_character: INTEGER): INTEGER is
			-- gint	 gdk_char_measure   (GdkFont        *font,
			-- 			     gchar           character);
			-- (from C_GDK)
		do
		end

	frozen gdk_char_width (a_font: POINTER; a_character: INTEGER): INTEGER is
			-- gint	 gdk_char_width	    (GdkFont        *font,
			-- 			     gchar           character);
			-- (from C_GDK)
		do
		end

	frozen gdk_char_width_wc (a_font: POINTER; a_character: INTEGER): INTEGER is
			-- gint	 gdk_char_width_wc  (GdkFont        *font,
			-- 			     GdkWChar        character);
			-- (from C_GDK)
		do
		end

	frozen gdk_color_alloc (a_colormap: POINTER; a_color: POINTER): BOOLEAN is
			-- gboolean gdk_color_alloc  (GdkColormap	*colormap,
			-- 			   GdkColor	*color);
			-- (from C_GDK)
		do
		end

	frozen gdk_color_black (a_colormap: POINTER; a_color: POINTER): BOOLEAN is
			-- gboolean gdk_color_black  (GdkColormap	*colormap,
			-- 			   GdkColor	*color);
			-- (from C_GDK)
		do
		end

	frozen gdk_color_change (a_colormap: POINTER; a_color: POINTER): BOOLEAN is
			-- gboolean gdk_color_change (GdkColormap	*colormap,
			-- 			   GdkColor	*color);
			-- (from C_GDK)
		do
		end

	frozen gdk_atom_intern (a_atom_name: POINTER; a_only_if_exists: INTEGER): POINTER is
			-- GdkAtom  gdk_atom_intern     (const gchar  *atom_name,
			--                               gint          only_if_exists);
			-- (from C_GDK)
		do
		end

	frozen gdk_atom_name (a_atom: POINTER): POINTER is
		do
		end

	frozen gdk_color_copy (a_color: POINTER): POINTER is
			-- GdkColor*    gdk_color_copy               (const GdkColor *color);
			-- (from C_GDK)
		do
		end

	frozen gdk_color_equal (a_colora: POINTER; a_colorb: POINTER): BOOLEAN is
			-- gboolean     gdk_color_equal	          (const GdkColor *colora,
			-- 					   const GdkColor *colorb);
			-- (from C_GDK)
		do
		end

	frozen gdk_color_free (a_color: POINTER) is
			-- void         gdk_color_free               (GdkColor       *color);
			-- (from C_GDK)
		do
		end

	frozen gdk_color_parse (a_spec: POINTER; a_color: POINTER): BOOLEAN is
			-- gboolean     gdk_color_parse	          (const gchar    *spec,
			-- 					   GdkColor       *color);
			-- (from C_GDK)
		do
		end

	frozen gdk_color_white (a_colormap: POINTER; a_color: POINTER): BOOLEAN is
			-- gboolean gdk_color_white  (GdkColormap	*colormap,
			-- 			   GdkColor	*color);
			-- (from C_GDK)
		do
		end

	frozen gdk_colormap_alloc_color (a_colormap: POINTER; a_color: POINTER; a_writeable: BOOLEAN; a_best_match: BOOLEAN): BOOLEAN is
			-- gboolean     gdk_colormap_alloc_color     (GdkColormap    *colormap,
			-- 					   GdkColor       *color,
			-- 					   gboolean        writeable,
			-- 					   gboolean        best_match);
			-- (from C_GDK)
		do
		end

	frozen gdk_colormap_alloc_colors (a_colormap: POINTER; a_colors: POINTER; a_ncolors: INTEGER; a_writeable: BOOLEAN; a_best_match: BOOLEAN; a_success: POINTER): INTEGER is
			-- gint         gdk_colormap_alloc_colors    (GdkColormap    *colormap,
			-- 					   GdkColor       *colors,
			-- 					   gint            ncolors,
			-- 					   gboolean        writeable,
			-- 					   gboolean        best_match,
			-- 					   gboolean       *success);
			-- (from C_GDK)
		do
		end

	frozen gdk_colormap_change (a_colormap: POINTER; a_ncolors: INTEGER) is
			-- void         gdk_colormap_change          (GdkColormap    *colormap,
			-- 					   gint		   ncolors);
			-- (from C_GDK)
		do
		end

	frozen gdk_colormap_free_colors (a_colormap: POINTER; a_colors: POINTER; a_ncolors: INTEGER) is
			-- void         gdk_colormap_free_colors     (GdkColormap    *colormap,
			-- 					   GdkColor       *colors,
			-- 					   gint            ncolors);
			-- (from C_GDK)
		do
		end

	frozen gdk_colormap_get_system: POINTER is
			-- GdkColormap* gdk_colormap_get_system	  (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_colormap_get_system_size: INTEGER is
			-- gint	     gdk_colormap_get_system_size (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_colormap_get_visual (a_colormap: POINTER): POINTER is
			-- GdkVisual*   gdk_colormap_get_visual      (GdkColormap    *colormap);
			-- (from C_GDK)
		do
		end

	frozen gdk_colormap_new (a_visual: POINTER; a_allocate: BOOLEAN): POINTER is
			-- GdkColormap* gdk_colormap_new	          (GdkVisual      *visual,
			-- 					   gboolean        allocate);
			-- (from C_GDK)
		do
		end

	frozen gdk_colormap_ref (a_cmap: POINTER): POINTER is
			-- GdkColormap* gdk_colormap_ref	          (GdkColormap    *cmap);
			-- (from C_GDK)
		do
		end

	frozen gdk_colormap_unref (a_cmap: POINTER) is
			-- void	     gdk_colormap_unref	          (GdkColormap    *cmap);
			-- (from C_GDK)
		do
		end

	frozen gdk_colors_alloc (a_colormap: POINTER; a_contiguous: BOOLEAN; a_planes: POINTER; a_nplanes: INTEGER; a_pixels: POINTER; a_npixels: INTEGER): BOOLEAN is
			-- gboolean gdk_colors_alloc (GdkColormap	*colormap,
			-- 			   gboolean      contiguous,
			-- 			   gulong	*planes,
			-- 			   gint		 nplanes,
			-- 			   gulong	*pixels,
			-- 			   gint		 npixels);
			-- (from C_GDK)
		do
		end

	frozen gdk_colors_free (a_colormap: POINTER; a_pixels: POINTER; a_npixels: INTEGER; a_planes: INTEGER) is
			-- void     gdk_colors_free  (GdkColormap	*colormap,
			-- 			   gulong	*pixels,
			-- 			   gint		 npixels,
			-- 			   gulong	 planes);
			-- (from C_GDK)
		do
		end

	frozen gdk_colors_store (a_colormap: POINTER; a_colors: POINTER; a_ncolors: INTEGER) is
			-- void     gdk_colors_store (GdkColormap	*colormap,
			-- 			   GdkColor	*colors,
			-- 			   gint		 ncolors);
			-- (from C_GDK)
		do
		end

	frozen gdk_cursor_destroy (a_cursor: POINTER) is
			-- void	   gdk_cursor_destroy		 (GdkCursor	 *cursor);
			-- (from C_GDK)
		do
		end

	frozen gdk_cursor_new (a_cursor_type: INTEGER): POINTER is
			-- GdkCursor* gdk_cursor_new		 (GdkCursorType	  cursor_type);
			-- (from C_GDK)
		do
		end

	frozen gdk_cursor_new_from_pixmap (a_source: POINTER; a_mask: POINTER; a_fg: POINTER; a_bg: POINTER; a_x: INTEGER; a_y: INTEGER): POINTER is
			-- GdkCursor* gdk_cursor_new_from_pixmap	 (GdkPixmap	  *source,
			-- 					  GdkPixmap	  *mask,
			-- 					  GdkColor	  *fg,
			-- 					  GdkColor	  *bg,
			-- 					  gint		   x,
			-- 					  gint		   y);
			-- (from C_GDK)
		do
		end

	frozen gdk_drag_abort (a_context: POINTER; a_time: INTEGER) is
			-- void            gdk_drag_abort       (GdkDragContext *context,
			-- 				      guint32         time);
			-- (from C_GDK)
		do
		end

	frozen gdk_drag_begin (a_window: POINTER; a_targets: POINTER): POINTER is
			-- GdkDragContext * gdk_drag_begin      (Gdkwindow      *window,
			-- 				      GList          *targets);
			-- (from C_GDK)
		do
		end

	frozen gdk_drag_context_new: POINTER is
			-- GdkDragContext * gdk_drag_context_new        (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_drag_context_ref (a_context: POINTER) is
			-- void             gdk_drag_context_ref        (GdkDragContext *context);
			-- (from C_GDK)
		do
		end

	frozen gdk_drag_context_unref (a_context: POINTER) is
			-- void             gdk_drag_context_unref      (GdkDragContext *context);
			-- (from C_GDK)
		do
		end

	frozen gdk_drag_drop (a_context: POINTER; a_time: INTEGER) is
			-- void            gdk_drag_drop        (GdkDragContext *context,
			-- 				      guint32         time);
			-- (from C_GDK)
		do
		end

	frozen gdk_drag_find_window (a_context: POINTER; a_drag_window: POINTER; a_x_root: INTEGER; a_y_root: INTEGER; a_dest_window: POINTER; a_protocol: POINTER) is
			-- void             gdk_drag_find_window (GdkDragContext   *context,
			-- 				       Gdkwindow       *drag_window,
			-- 			 	       gint             x_root,
			-- 				       gint             y_root,
			-- 				       Gdkwindow      **dest_window,
			-- 				       GdkDragProtocol *protocol);
			-- (from C_GDK)
		do
		end

	frozen gdk_drag_get_protocol (a_xid: INTEGER; a_protocol: POINTER): NATURAL_32 is
			-- guint32         gdk_drag_get_protocol (guint32          xid,
			-- 				       GdkDragProtocol *protocol);
			-- (from C_GDK)
		do
		end

	frozen gdk_drag_get_selection (a_context: POINTER): POINTER is
			-- GdkAtom          gdk_drag_get_selection (GdkDragContext   *context);
			-- (from C_GDK)
		do
		end

	frozen gdk_drag_motion (a_context: POINTER; a_dest_window: POINTER; a_protocol: INTEGER; a_x_root: INTEGER; a_y_root: INTEGER; a_suggested_action: INTEGER; a_possible_actions: INTEGER; a_time: INTEGER): BOOLEAN is
			-- gboolean        gdk_drag_motion      (GdkDragContext *context,
			-- 				      Gdkwindow      *dest_window,
			-- 				      GdkDragProtocol protocol,
			-- 				      gint            x_root,
			-- 				      gint            y_root,
			-- 				      GdkDragAction   suggested_action,
			-- 				      GdkDragAction   possible_actions,
			-- 				      guint32         time);
			-- (from C_GDK)
		do
		end

	frozen gdk_drag_status (a_context: POINTER; a_action: INTEGER; a_time: INTEGER) is
			-- void             gdk_drag_status        (GdkDragContext   *context,
			-- 				         GdkDragAction     action,
			-- 					 guint32           time);
			-- (from C_GDK)
		do
		end

	frozen gdk_draw_arc (a_drawable: POINTER; a_gc: POINTER; a_filled: INTEGER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER; a_angle1: INTEGER; a_angle2: INTEGER) is
			-- void gdk_draw_arc	 (GdkDrawable  *drawable,
			-- 			  GdkGC	       *gc,
			-- 			  gint		filled,
			-- 			  gint		x,
			-- 			  gint		y,
			-- 			  gint		width,
			-- 			  gint		height,
			-- 			  gint		angle1,
			-- 			  gint		angle2);
			-- (from C_GDK)
		do
		end

	frozen gdk_draw_gray_image (a_drawable: POINTER; a_gc: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER; a_dith: INTEGER; a_buf: POINTER; a_rowstride: INTEGER) is
			-- void
			-- gdk_draw_gray_image (GdkDrawable *drawable,
			-- 		     GdkGC *gc,
			-- 		     gint x,
			-- 		     gint y,
			-- 		     gint width,
			-- 		     gint height,
			-- 		     GdkRgbDither dith,
			-- 		     guchar *buf,
			-- 		     gint rowstride);
			-- (from C_GDK)
		do
		end

	frozen gdk_draw_image (a_drawable: POINTER; a_gc: POINTER; a_image: POINTER; a_xsrc: INTEGER; a_ysrc: INTEGER; a_xdest: INTEGER; a_ydest: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void gdk_draw_image	 (GdkDrawable  *drawable,
			-- 			  GdkGC	       *gc,
			-- 			  GdkImage     *image,
			-- 			  gint		xsrc,
			-- 			  gint		ysrc,
			-- 			  gint		xdest,
			-- 			  gint		ydest,
			-- 			  gint		width,
			-- 			  gint		height);
			-- (from C_GDK)
		do
		end

	frozen gdk_draw_indexed_image (a_drawable: POINTER; a_gc: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER; a_dith: INTEGER; a_buf: POINTER; a_rowstride: INTEGER; a_cmap: POINTER) is
			-- void
			-- gdk_draw_indexed_image (GdkDrawable *drawable,
			-- 			GdkGC *gc,
			-- 			gint x,
			-- 			gint y,
			-- 			gint width,
			-- 			gint height,
			-- 			GdkRgbDither dith,
			-- 			guchar *buf,
			-- 			gint rowstride,
			-- 			GdkRgbCmap *cmap);
			-- (from C_GDK)
		do
		end

	frozen gdk_draw_line (a_drawable: POINTER; a_gc: POINTER; a_x1: INTEGER; a_y1: INTEGER; a_x2: INTEGER; a_y2: INTEGER) is
			-- void gdk_draw_line	 (GdkDrawable  *drawable,
			-- 			  GdkGC	       *gc,
			-- 			  gint		x1,
			-- 			  gint		y1,
			-- 			  gint		x2,
			-- 			  gint		y2);
			-- (from C_GDK)
		do
		end

	frozen gdk_draw_lines (a_drawable: POINTER; a_gc: POINTER; a_points: POINTER; a_npoints: INTEGER) is
			-- void gdk_draw_lines      (GdkDrawable  *drawable,
			--                           GdkGC        *gc,
			--                           GdkPoint     *points,
			--                           gint          npoints);
			-- (from C_GDK)
		do
		end

	frozen gdk_draw_pixmap (a_drawable: POINTER; a_gc: POINTER; a_src: POINTER; a_xsrc: INTEGER; a_ysrc: INTEGER; a_xdest: INTEGER; a_ydest: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void gdk_draw_pixmap	 (GdkDrawable  *drawable,
			-- 			  GdkGC	       *gc,
			-- 			  GdkDrawable  *src,
			-- 			  gint		xsrc,
			-- 			  gint		ysrc,
			-- 			  gint		xdest,
			-- 			  gint		ydest,
			-- 			  gint		width,
			-- 			  gint		height);
			-- (from C_GDK)
		do
		end

	frozen gdk_draw_point (a_drawable: POINTER; a_gc: POINTER; a_x: INTEGER; a_y: INTEGER) is
			-- void gdk_draw_point	 (GdkDrawable  *drawable,
			-- 			  GdkGC	       *gc,
			-- 			  gint		x,
			-- 			  gint		y);
			-- (from C_GDK)
		do
		end

	frozen gdk_draw_points (a_drawable: POINTER; a_gc: POINTER; a_points: POINTER; a_npoints: INTEGER) is
			-- void gdk_draw_points	 (GdkDrawable  *drawable,
			-- 			  GdkGC	       *gc,
			-- 			  GdkPoint     *points,
			-- 			  gint		npoints);
			-- (from C_GDK)
		do
		end

	frozen gdk_draw_polygon (a_drawable: POINTER; a_gc: POINTER; a_filled: INTEGER; a_points: POINTER; a_npoints: INTEGER) is
			-- void gdk_draw_polygon	 (GdkDrawable  *drawable,
			-- 			  GdkGC	       *gc,
			-- 			  gint		filled,
			-- 			  GdkPoint     *points,
			-- 			  gint		npoints);
			-- (from C_GDK)
		do
		end

	frozen gdk_draw_rectangle (a_drawable: POINTER; a_gc: POINTER; a_filled: INTEGER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void gdk_draw_rectangle	 (GdkDrawable  *drawable,
			-- 			  GdkGC	       *gc,
			-- 			  gint		filled,
			-- 			  gint		x,
			-- 			  gint		y,
			-- 			  gint		width,
			-- 			  gint		height);
			-- (from C_GDK)
		do
		end

	frozen gdk_draw_rgb_32_image (a_drawable: POINTER; a_gc: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER; a_dith: INTEGER; a_buf: POINTER; a_rowstride: INTEGER) is
			-- void
			-- gdk_draw_rgb_32_image (GdkDrawable *drawable,
			-- 		       GdkGC *gc,
			-- 		       gint x,
			-- 		       gint y,
			-- 		       gint width,
			-- 		       gint height,
			-- 		       GdkRgbDither dith,
			-- 		       guchar *buf,
			-- 		       gint rowstride);
			-- (from C_GDK)
		do
		end

	frozen gdk_draw_rgb_image (a_drawable: POINTER; a_gc: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER; a_dith: INTEGER; a_rgb_buf: POINTER; a_rowstride: INTEGER) is
			-- void
			-- gdk_draw_rgb_image (GdkDrawable *drawable,
			-- 		    GdkGC *gc,
			-- 		    gint x,
			-- 		    gint y,
			-- 		    gint width,
			-- 		    gint height,
			-- 		    GdkRgbDither dith,
			-- 		    guchar *rgb_buf,
			-- 		    gint rowstride);
			-- (from C_GDK)
		do
		end

	frozen gdk_draw_rgb_image_dithalign (a_drawable: POINTER; a_gc: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER; a_dith: INTEGER; a_rgb_buf: POINTER; a_rowstride: INTEGER; a_xdith: INTEGER; a_ydith: INTEGER) is
			-- void
			-- gdk_draw_rgb_image_dithalign (GdkDrawable *drawable,
			-- 			      GdkGC *gc,
			-- 			      gint x,
			-- 			      gint y,
			-- 			      gint width,
			-- 			      gint height,
			-- 			      GdkRgbDither dith,
			-- 			      guchar *rgb_buf,
			-- 			      gint rowstride,
			-- 			      gint xdith,
			-- 			      gint ydith);
			-- (from C_GDK)
		do
		end

	frozen gdk_draw_segments (a_drawable: POINTER; a_gc: POINTER; a_segs: POINTER; a_nsegs: INTEGER) is
			-- void gdk_draw_segments	 (GdkDrawable  *drawable,
			-- 			  GdkGC	       *gc,
			-- 			  GdkSegment   *segs,
			-- 			  gint		nsegs);
			-- (from C_GDK)
		do
		end

	frozen gdk_draw_string (a_drawable: POINTER; a_font: POINTER; a_gc: POINTER; a_x: INTEGER; a_y: INTEGER; a_string: POINTER) is
			-- void gdk_draw_string	 (GdkDrawable  *drawable,
			-- 			  GdkFont      *font,
			-- 			  GdkGC	       *gc,
			-- 			  gint		x,
			-- 			  gint		y,
			-- 			  const gchar  *string);
			-- (from C_GDK)
		do
		end

	frozen gdk_draw_text (a_drawable: POINTER; a_font: POINTER; a_gc: POINTER; a_x: INTEGER; a_y: INTEGER; a_text: POINTER; a_text_length: INTEGER) is
			-- void gdk_draw_text	 (GdkDrawable  *drawable,
			-- 			  GdkFont      *font,
			-- 			  GdkGC	       *gc,
			-- 			  gint		x,
			-- 			  gint		y,
			-- 			  const gchar  *text,
			-- 			  gint		text_length);
			-- (from C_GDK)
		do
		end

	frozen gdk_draw_text_wc (a_drawable: POINTER; a_font: POINTER; a_gc: POINTER; a_x: INTEGER; a_y: INTEGER; a_text: POINTER; a_text_length: INTEGER) is
			-- void gdk_draw_text_wc	 (GdkDrawable	 *drawable,
			-- 			  GdkFont	 *font,
			-- 			  GdkGC		 *gc,
			-- 			  gint		  x,
			-- 			  gint		  y,
			-- 			  const GdkWChar *text,
			-- 			  gint		  text_length);
			-- (from C_GDK)
		do
		end

	frozen gdk_drawable_set_data (a_drawable: POINTER; a_key: POINTER; a_data: POINTER; a_destroy_func: POINTER) is
			-- void          gdk_drawable_set_data      (GdkDrawable     *drawable,
			-- 					  const gchar     *key,
			-- 					  gpointer	   data,
			-- 					  GDestroyNotify   destroy_func);
			-- (from C_GDK)
		do
		end

	frozen gdk_drop_finish (a_context: POINTER; a_success: BOOLEAN; a_time: NATURAL_32) is
		do
		end

	frozen gdk_drop_reply (a_context: POINTER; a_ok: BOOLEAN; a_time: INTEGER) is
			-- void             gdk_drop_reply         (GdkDragContext   *context,
			-- 					 gboolean          ok,
			-- 					 guint32           time);
			-- (from C_GDK)
		do
		end

	frozen gdk_error_trap_pop: INTEGER is
			-- gint      gdk_error_trap_pop            (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_error_trap_push is
			-- void      gdk_error_trap_push           (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_event_copy (a_event: POINTER): POINTER is
			-- GdkEvent* gdk_event_copy     		(GdkEvent 	*event);
			-- (from C_GDK)
		do
		end

	frozen gdk_event_free (a_event: POINTER) is
			-- void	  gdk_event_free     		(GdkEvent 	*event);
			-- (from C_GDK)
		do
		end

	frozen gdk_event_get: POINTER is
			-- GdkEvent* gdk_event_get			(void);
			-- (from C_GDK)
		do
		end

	frozen gdk_event_get_graphics_expose (a_window: POINTER): POINTER is
			-- GdkEvent* gdk_event_get_graphics_expose (Gdkwindow 	*window);
			-- (from C_GDK)
		do
		end

	frozen gdk_event_get_time (a_event: POINTER): NATURAL_32 is
			-- guint32   gdk_event_get_time 		(GdkEvent 	*event);
			-- (from C_GDK)
		do
		end

	frozen gdk_event_handler_set (a_func: POINTER; a_data: POINTER; a_notify: POINTER) is
			-- void	  gdk_event_handler_set 	(GdkEventFunc    func,
			-- 					 gpointer        data,
			-- 					 GDestroyNotify  notify);
			-- (from C_GDK)
		do
		end

	frozen gdk_event_peek: POINTER is
			-- GdkEvent* gdk_event_peek                (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_event_put (a_event: POINTER) is
			-- void      gdk_event_put	 		(GdkEvent  	*event);
			-- (from C_GDK)
		do
		end

	frozen gdk_event_send_client_message (a_event: POINTER; a_xid: INTEGER): BOOLEAN is
			-- gboolean gdk_event_send_client_message (GdkEvent    *event,
			-- 					guint32      xid);
			-- (from C_GDK)
		do
		end

	frozen gdk_event_send_clientmessage_toall (a_event: POINTER) is
			-- void     gdk_event_send_clientmessage_toall (GdkEvent    *event);
			-- (from C_GDK)
		do
		end

	frozen gdk_events_pending: BOOLEAN is
			-- gboolean  gdk_events_pending	 	(void);
			-- (from C_GDK)
		do
		end

	frozen gdk_exit (a_error_code: INTEGER) is
			-- void  	  gdk_exit		   	(gint	    	 error_code);
			-- (from C_GDK)
		do
		end

	frozen gdk_flush is
			-- void gdk_flush (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_font_equal (a_fonta: POINTER; a_fontb: POINTER): BOOLEAN is
			-- gboolean gdk_font_equal	    (const GdkFont  *fonta,
			-- 			     const GdkFont  *fontb);
			-- (from C_GDK)
		do
		end

	frozen gdk_font_id (a_font: POINTER): INTEGER is
			-- gint	 gdk_font_id	    (const GdkFont  *font);
			-- (from C_GDK)
		do
		end

	frozen gdk_font_load (a_font_name: POINTER): POINTER is
			-- GdkFont* gdk_font_load	    (const gchar    *font_name);
			-- (from C_GDK)
		do
		end

	frozen gdk_font_ref (a_font: POINTER): POINTER is
			-- GdkFont* gdk_font_ref	    (GdkFont        *font);
			-- (from C_GDK)
		do
		end

	frozen gdk_font_unref (a_font: POINTER) is
			-- void	 gdk_font_unref	    (GdkFont        *font);
			-- (from C_GDK)
		do
		end

	frozen gdk_fontset_load (a_fontset_name: POINTER): POINTER is
			-- GdkFont* gdk_fontset_load   (const gchar    *fontset_name);
			-- (from C_GDK)
		do
		end

	frozen gdk_free_compound_text (a_ctext: POINTER) is
			-- void	   gdk_free_compound_text	  (guchar *ctext);
			-- (from C_GDK)
		do
		end

	frozen gdk_free_text_list (a_list: POINTER) is
			-- void	   gdk_free_text_list		  (gchar **list);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_copy (a_dst_gc: POINTER; a_src_gc: POINTER) is
			-- void   gdk_gc_copy		  (GdkGC	     *dst_gc,
			-- 				   GdkGC	     *src_gc);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_destroy (a_gc: POINTER) is
			-- void   gdk_gc_destroy		  (GdkGC	    *gc);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_get_values (a_gc: POINTER; a_values: POINTER) is
			-- void   gdk_gc_get_values	  (GdkGC	    *gc,
			-- 				   GdkGCValues	    *values);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_new (a_window: POINTER): POINTER is
			-- GdkGC* gdk_gc_new		  (Gdkwindow	    *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_new_with_values (a_window: POINTER; a_values: POINTER; a_values_mask: INTEGER): POINTER is
			-- GdkGC* gdk_gc_new_with_values	  (Gdkwindow	    *window,
			-- 				   GdkGCValues	    *values,
			-- 				   GdkGCValuesMask   values_mask);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_ref (a_gc: POINTER): POINTER is
			-- GdkGC* gdk_gc_ref		  (GdkGC	    *gc);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_set_background (a_gc: POINTER; a_color: POINTER) is
			-- void   gdk_gc_set_background	  (GdkGC	    *gc,
			-- 				   GdkColor	    *color);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_set_clip_mask (a_gc: POINTER; a_mask: POINTER) is
			-- void   gdk_gc_set_clip_mask	  (GdkGC	    *gc,
			-- 				   GdkBitmap	    *mask);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_set_clip_origin (a_gc: POINTER; a_x: INTEGER; a_y: INTEGER) is
			-- void   gdk_gc_set_clip_origin	  (GdkGC	    *gc,
			-- 				   gint		     x,
			-- 				   gint		     y);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_set_clip_rectangle (a_gc: POINTER; a_rectangle: POINTER) is
			-- void   gdk_gc_set_clip_rectangle  (GdkGC	    *gc,
			-- 				   GdkRectangle	    *rectangle);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_set_clip_region (a_gc: POINTER; a_region: POINTER) is
			-- void   gdk_gc_set_clip_region	  (GdkGC	    *gc,
			-- 				   GdkRegion	    *region);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_set_dashes (a_gc: POINTER; a_dash_offset: INTEGER; a_dash_list: POINTER; a_n: INTEGER) is
			-- void   gdk_gc_set_dashes          (GdkGC            *gc,
			-- 				   gint	             dash_offset,
			-- 				   gint8             dash_list[],
			-- 				   gint              n);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_set_exposures (a_gc: POINTER; a_exposures: BOOLEAN) is
			-- void   gdk_gc_set_exposures	  (GdkGC	    *gc,
			-- 				   gboolean          exposures);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_set_fill (a_gc: POINTER; a_fill: INTEGER) is
			-- void   gdk_gc_set_fill		  (GdkGC	    *gc,
			-- 				   GdkFill	     fill);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_set_font (a_gc: POINTER; a_font: POINTER) is
			-- void   gdk_gc_set_font		  (GdkGC	    *gc,
			-- 				   GdkFont	    *font);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_set_foreground (a_gc: POINTER; a_color: POINTER) is
			-- void   gdk_gc_set_foreground	  (GdkGC	    *gc,
			-- 				   GdkColor	    *color);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_set_function (a_gc: POINTER; a_function: INTEGER) is
			-- void   gdk_gc_set_function	  (GdkGC	    *gc,
			-- 				   GdkFunction	     function);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_set_line_attributes (a_gc: POINTER; a_line_width: INTEGER; a_line_style: INTEGER; a_cap_style: INTEGER; a_join_style: INTEGER) is
			-- void   gdk_gc_set_line_attributes (GdkGC	    *gc,
			-- 				   gint		     line_width,
			-- 				   GdkLineStyle	     line_style,
			-- 				   GdkCapStyle	     cap_style,
			-- 				   GdkJoinStyle	     join_style);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_set_stipple (a_gc: POINTER; a_stipple: POINTER) is
			-- void   gdk_gc_set_stipple	  (GdkGC	    *gc,
			-- 				   GdkPixmap	    *stipple);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_set_subwindow (a_gc: POINTER; a_mode: INTEGER) is
			-- void   gdk_gc_set_subwindow	  (GdkGC	    *gc,
			-- 				   GdkSubwindowMode  mode);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_set_tile (a_gc: POINTER; a_tile: POINTER) is
			-- void   gdk_gc_set_tile		  (GdkGC	    *gc,
			-- 				   GdkPixmap	    *tile);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_set_ts_origin (a_gc: POINTER; a_x: INTEGER; a_y: INTEGER) is
			-- void   gdk_gc_set_ts_origin	  (GdkGC	    *gc,
			-- 				   gint		     x,
			-- 				   gint		     y);
			-- (from C_GDK)
		do
		end

	frozen gdk_gc_unref (a_gc: POINTER) is
			-- void   gdk_gc_unref		  (GdkGC	    *gc);
			-- (from C_GDK)
		do
		end

	frozen gdk_get_display: POINTER is
			-- gchar*	  gdk_get_display		(void);
			-- (from C_GDK)
		do
		end

	frozen gdk_get_show_events: BOOLEAN is
			-- gboolean  gdk_get_show_events		(void);
			-- (from C_GDK)
		do
		end

	frozen gdk_get_use_xshm: BOOLEAN is
			-- gboolean  gdk_get_use_xshm		(void);
			-- (from C_GDK)
		do
		end

	frozen gdk_image_destroy (a_image: POINTER) is
			-- void	   gdk_image_destroy   (GdkImage     *image);
			-- (from C_GDK)
		do
		end

	frozen gdk_image_get (a_window: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER): POINTER is
			-- GdkImage*  gdk_image_get       (Gdkwindow    *window,
			-- 				gint	      x,
			-- 				gint	      y,
			-- 				gint	      width,
			-- 				gint	      height);
			-- (from C_GDK)
		do
		end

	frozen gdk_image_get_pixel (a_image: POINTER; a_x: INTEGER; a_y: INTEGER): INTEGER is
			-- guint32	   gdk_image_get_pixel (GdkImage     *image,
			-- 				gint	      x,
			-- 				gint	      y);
			-- (from C_GDK)
		do
		end

	frozen gdk_image_new (a_type: INTEGER; a_visual: POINTER; a_width: INTEGER; a_height: INTEGER): POINTER is
			-- GdkImage*  gdk_image_new       (GdkImageType  type,
			-- 				GdkVisual    *visual,
			-- 				gint	      width,
			-- 				gint	      height);
			-- (from C_GDK)
		do
		end

	frozen gdk_image_put_pixel (a_image: POINTER; a_x: INTEGER; a_y: INTEGER; a_pixel: INTEGER) is
			-- void	   gdk_image_put_pixel (GdkImage     *image,
			-- 				gint	      x,
			-- 				gint	      y,
			-- 				guint32	      pixel);
			-- (from C_GDK)
		do
		end

	frozen gdk_init (a_argc: POINTER; a_argv: POINTER) is
			-- void 	  gdk_init		   	(gint	   	*argc,
			-- 					 gchar        ***argv);
			-- (from C_GDK)
		do
		end

	frozen gdk_init_check (a_argc: POINTER; a_argv: POINTER): BOOLEAN is
			-- gboolean  gdk_init_check   	        (gint	   	*argc,
			-- 					 gchar        ***argv);
			-- (from C_GDK)
		do
		end

	frozen gdk_input_add (a_source: INTEGER; a_condition: INTEGER; a_function: POINTER; a_data: POINTER): INTEGER is
			-- gint gdk_input_add	  (gint		     source,
			-- 			   GdkInputCondition condition,
			-- 			   GdkInputFunction  function,
			-- 			   gpointer	     data);
			-- (from C_GDK)
		do
		end

	frozen gdk_input_add_full (a_source: INTEGER; a_condition: INTEGER; a_function: POINTER; a_data: POINTER; a_destroy: POINTER): INTEGER is
			-- gint gdk_input_add_full	  (gint		     source,
			-- 			   GdkInputCondition condition,
			-- 			   GdkInputFunction  function,
			-- 			   gpointer	     data,
			-- 			   GdkDestroyNotify  destroy);
			-- (from C_GDK)
		do
		end

	frozen gdk_input_remove (a_tag: INTEGER) is
			-- void gdk_input_remove	  (gint		     tag);
			-- (from C_GDK)
		do
		end

	frozen gdk_input_set_extension_events (a_window: POINTER; a_mask: INTEGER; a_mode: INTEGER) is
			-- void          gdk_input_set_extension_events (Gdkwindow        *window,
			--                                               gint              mask,
			--                                               GdkExtensionMode  mode);
			-- (from C_GDK)
		do
		end

	frozen gdk_keyboard_grab (a_window: POINTER; a_owner_events: BOOLEAN; a_time: INTEGER): INTEGER is
			-- gint     gdk_keyboard_grab      (Gdkwindow    *window,
			--                                  gboolean      owner_events,
			--                                  guint32       time);
			-- (from C_GDK)
		do
		end

	frozen gdk_keyboard_ungrab (a_time: INTEGER) is
			-- void     gdk_keyboard_ungrab    (guint32       time);
			-- (from C_GDK)
		do
		end

	frozen gdk_keyval_from_name (a_keyval_name: POINTER): INTEGER is
			-- guint    gdk_keyval_from_name		  (const gchar *keyval_name);
			-- (from C_GDK)
		do
		end

	frozen gdk_keyval_is_lower (a_keyval: NATURAL_32): BOOLEAN is
			-- gboolean gdk_keyval_is_lower		  (guint	keyval);
			-- (from C_GDK)
		do
		end

	frozen gdk_keyval_is_upper (a_keyval: NATURAL_32): BOOLEAN is
			-- gboolean gdk_keyval_is_upper		  (guint	keyval);
			-- (from C_GDK)
		do
		end

	frozen gdk_keyval_name (a_keyval: NATURAL_32): POINTER is
			-- gchar*   gdk_keyval_name		  (guint	keyval);
			-- (from C_GDK)
		do
		end

	frozen gdk_keyval_to_lower (a_keyval: NATURAL_32): NATURAL_32 is
			-- guint    gdk_keyval_to_lower		  (guint	keyval);
			-- (from C_GDK)
		do
		end

	frozen gdk_keyval_to_upper (a_keyval: NATURAL_32): NATURAL_32 is
			-- guint    gdk_keyval_to_upper		  (guint	keyval);
			-- (from C_GDK)
		do
		end

	frozen gdk_list_visuals: POINTER is
			-- GList* gdk_list_visuals (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_mbstowcs (a_dest: POINTER; a_src: POINTER; a_dest_max: INTEGER): INTEGER is
			-- gint       gdk_mbstowcs          (GdkWChar         *dest,
			-- 				  const gchar      *src,
			-- 				  gint              dest_max);
			-- (from C_GDK)
		do
		end

	frozen gdk_pixmap_colormap_create_from_xpm (a_window: POINTER; a_colormap: POINTER; a_mask: POINTER; a_transparent_color: POINTER; a_filename: POINTER): POINTER is
			-- GdkPixmap* gdk_pixmap_colormap_create_from_xpm (
			-- 					 Gdkwindow   *window,
			-- 					 GdkColormap *colormap,
			-- 					 GdkBitmap  **mask,
			-- 					 GdkColor    *transparent_color,
			-- 					 const gchar *filename);
			-- (from C_GDK)
		do
		end

	frozen gdk_pixmap_colormap_create_from_xpm_d (a_window: POINTER; a_colormap: POINTER; a_mask: POINTER; a_transparent_color: POINTER; a_data: POINTER): POINTER is
			-- GdkPixmap* gdk_pixmap_colormap_create_from_xpm_d (
			-- 					 Gdkwindow   *window,
			-- 					 GdkColormap *colormap,
			-- 					 GdkBitmap  **mask,
			-- 					 GdkColor    *transparent_color,
			-- 					 gchar     **data);
			-- (from C_GDK)
		do
		end

	frozen gdk_pixmap_create_from_data (a_window: POINTER; a_data: POINTER; a_width: INTEGER; a_height: INTEGER; a_depth: INTEGER; a_fg: POINTER; a_bg: POINTER): POINTER is
			-- GdkPixmap* gdk_pixmap_create_from_data	(Gdkwindow   *window,
			-- 					 const gchar *data,
			-- 					 gint	      width,
			-- 					 gint	      height,
			-- 					 gint	      depth,
			-- 					 GdkColor    *fg,
			-- 					 GdkColor    *bg);
			-- (from C_GDK)
		do
		end

	frozen gdk_pixmap_create_from_xpm (a_window: POINTER; a_mask: POINTER; a_transparent_color: POINTER; a_filename: POINTER): POINTER is
			-- GdkPixmap* gdk_pixmap_create_from_xpm	(Gdkwindow  *window,
			-- 					 GdkBitmap **mask,
			-- 					 GdkColor   *transparent_color,
			-- 					 const gchar *filename);
			-- (from C_GDK)
		do
		end

	frozen gdk_pixmap_create_from_xpm_d (a_window: POINTER; a_mask: POINTER; a_transparent_color: POINTER; a_data: POINTER): POINTER is
			-- GdkPixmap* gdk_pixmap_create_from_xpm_d (Gdkwindow  *window,
			-- 					 GdkBitmap **mask,
			-- 					 GdkColor   *transparent_color,
			-- 					 gchar	   **data);
			-- (from C_GDK)
		do
		end

	frozen gdk_pixmap_new (a_window: POINTER; a_width: INTEGER; a_height: INTEGER; a_depth: INTEGER): POINTER is
			-- GdkPixmap* gdk_pixmap_new		(Gdkwindow  *window,
			-- 					 gint	     width,
			-- 					 gint	     height,
			-- 					 gint	     depth);
			-- (from C_GDK)
		do
		end

	frozen gdk_pixmap_ref (a_pixmap: POINTER): POINTER is
			-- GdkPixmap *gdk_pixmap_ref		(GdkPixmap  *pixmap);
			-- (from C_GDK)
		do
		end

	frozen gdk_pixmap_unref (a_pixmap: POINTER) is
			-- void	   gdk_pixmap_unref		(GdkPixmap  *pixmap);
			-- (from C_GDK)
		do
		end

	frozen gdk_pointer_grab (a_window: POINTER; a_owner_events: INTEGER; a_event_mask: INTEGER; a_confine_to: POINTER; a_cursor: POINTER; a_time: INTEGER): INTEGER is
			-- gint     gdk_pointer_grab       (Gdkwindow    *window,
			--                                  gint          owner_events,
			--                                  GdkEventMask  event_mask,
			--                                  Gdkwindow    *confine_to,
			--                                  GdkCursor    *cursor,
			--                                  guint32       time);
			-- (from C_GDK)
		do
		end

	frozen gdk_pointer_is_grabbed: BOOLEAN is
			-- gboolean gdk_pointer_is_grabbed (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_pointer_ungrab (a_time: INTEGER) is
			-- void     gdk_pointer_ungrab     (guint32       time);
			-- (from C_GDK)
		do
		end

	frozen gdk_query_visual_types (a_visual_types: POINTER; a_count: POINTER) is
			-- void gdk_query_visual_types (GdkVisualType  **visual_types,
			-- 			     gint	     *count);
			-- (from C_GDK)
		do
		end

	frozen gdk_rectangle_intersect (a_src1: POINTER; a_src2: POINTER; a_dest: POINTER): BOOLEAN is
			-- gboolean gdk_rectangle_intersect (GdkRectangle *src1,
			--                                   GdkRectangle *src2,
			--                                   GdkRectangle *dest);
			-- (from C_GDK)
		do
		end

	frozen gdk_rectangle_union (a_src1: POINTER; a_src2: POINTER; a_dest: POINTER) is
			-- void     gdk_rectangle_union     (GdkRectangle *src1,
			--                                   GdkRectangle *src2,
			--                                   GdkRectangle *dest);
			-- (from C_GDK)
		do
		end

	frozen gdk_region_destroy (a_region: POINTER) is
			-- void	       gdk_region_destroy   (GdkRegion	   *region);
			-- (from C_GDK)
		do
		end

	frozen gdk_region_empty (a_region: POINTER): BOOLEAN is
			-- gboolean       gdk_region_empty	    (GdkRegion	   *region);
			-- (from C_GDK)
		do
		end

	frozen gdk_region_equal (a_region1: POINTER; a_region2: POINTER): BOOLEAN is
			-- gboolean       gdk_region_equal	    (GdkRegion	   *region1,
			-- 				     GdkRegion	   *region2);
			-- (from C_GDK)
		do
		end

	frozen gdk_region_get_clipbox (a_region: POINTER; a_rectangle: POINTER) is
			-- void	       gdk_region_get_clipbox(GdkRegion    *region,
			-- 				      GdkRectangle *rectangle);
			-- (from C_GDK)
		do
		end

	frozen gdk_region_new: POINTER is
			-- GdkRegion*     gdk_region_new	    (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_region_offset (a_region: POINTER; a_dx: INTEGER; a_dy: INTEGER) is
			-- void	       gdk_region_offset   (GdkRegion	   *region,
			-- 				    gint	   dx,
			-- 				    gint	   dy);
			-- (from C_GDK)
		do
		end

	frozen gdk_region_point_in (a_region: POINTER; a_x: INTEGER; a_y: INTEGER): BOOLEAN is
			-- gboolean       gdk_region_point_in  (GdkRegion	   *region,
			-- 				     int		   x,
			-- 				     int		   y);
			-- (from C_GDK)
		do
		end

	frozen gdk_region_polygon (a_points: POINTER; a_npoints: INTEGER; a_fill_rule: INTEGER): POINTER is
			-- GdkRegion*     gdk_region_polygon   (GdkPoint      *points,
			-- 				     gint           npoints,
			-- 				     GdkFillRule    fill_rule);
			-- (from C_GDK)
		do
		end

	frozen gdk_region_rect_in (a_region: POINTER; a_rect: POINTER): INTEGER is
			-- GdkOverlapType gdk_region_rect_in   (GdkRegion	   *region,
			-- 				     GdkRectangle  *rect);
			-- (from C_GDK)
		do
		end

	frozen gdk_region_shrink (a_region: POINTER; a_dx: INTEGER; a_dy: INTEGER) is
			-- void	       gdk_region_shrink   (GdkRegion	   *region,
			-- 				    gint	   dx,
			-- 				    gint	   dy);
			-- (from C_GDK)
		do
		end

	frozen gdk_rgb_cmap_free (a_cmap: POINTER) is
			-- void
			-- gdk_rgb_cmap_free (GdkRgbCmap *cmap);
			-- (from C_GDK)
		do
		end

	frozen gdk_rgb_cmap_new (a_colors: POINTER; a_n_colors: INTEGER): POINTER is
			-- GdkRgbCmap *
			-- gdk_rgb_cmap_new (guint32 *colors, gint n_colors);
			-- (from C_GDK)
		do
		end

	frozen gdk_rgb_ditherable: BOOLEAN is
			-- gboolean
			-- gdk_rgb_ditherable (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_rgb_gc_set_background (a_gc: POINTER; a_rgb: INTEGER) is
			-- void
			-- gdk_rgb_gc_set_background (GdkGC *gc, guint32 rgb);
			-- (from C_GDK)
		do
		end

	frozen gdk_rgb_gc_set_foreground (a_gc: POINTER; a_rgb: INTEGER) is
			-- void
			-- gdk_rgb_gc_set_foreground (GdkGC *gc, guint32 rgb);
			-- (from C_GDK)
		do
		end

	frozen gdk_rgb_get_cmap: POINTER is
			-- GdkColormap *
			-- gdk_rgb_get_cmap (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_rgb_get_visual: POINTER is
			-- GdkVisual *
			-- gdk_rgb_get_visual (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_rgb_init is
			-- void
			-- gdk_rgb_init (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_rgb_set_install (a_install: BOOLEAN) is
			-- void
			-- gdk_rgb_set_install (gboolean install);
			-- (from C_GDK)
		do
		end

	frozen gdk_rgb_set_min_colors (a_min_colors: INTEGER) is
			-- void
			-- gdk_rgb_set_min_colors (gint min_colors);
			-- (from C_GDK)
		do
		end

	frozen gdk_rgb_set_verbose (a_verbose: BOOLEAN) is
			-- void
			-- gdk_rgb_set_verbose (gboolean verbose);
			-- (from C_GDK)
		do
		end

	frozen gdk_rgb_xpixel_from_rgb (a_rgb: INTEGER): INTEGER is
			-- gulong
			-- gdk_rgb_xpixel_from_rgb (guint32 rgb);
			-- (from C_GDK)
		do
		end

	frozen gdk_screen_height: INTEGER is
			-- gint gdk_screen_height (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_screen_height_mm: INTEGER is
			-- gint gdk_screen_height_mm (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_screen_width: INTEGER is
			-- gint gdk_screen_width  (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_screen_width_mm: INTEGER is
			-- gint gdk_screen_width_mm  (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_set_locale: POINTER is
			-- gchar*	  gdk_set_locale	   	(void);
			-- (from C_GDK)
		do
		end

	frozen gdk_set_show_events (a_show_events: BOOLEAN) is
			-- void	  gdk_set_show_events		(gboolean	 show_events);
			-- (from C_GDK)
		do
		end

	frozen gdk_set_sm_client_id (a_sm_client_id: POINTER) is
			-- void          gdk_set_sm_client_id         (const gchar *sm_client_id);
			-- (from C_GDK)
		do
		end

	frozen gdk_set_use_xshm (a_use_xshm: BOOLEAN) is
			-- void	  gdk_set_use_xshm		(gboolean	 use_xshm);
			-- (from C_GDK)
		do
		end

	frozen gdk_string_extents (a_font: POINTER; a_string: POINTER; a_lbearing: POINTER; a_rbearing: POINTER; a_width: POINTER; a_ascent: POINTER; a_descent: POINTER) is
			-- void     gdk_string_extents (GdkFont     *font,
			-- 			     const gchar *string,
			-- 			     gint        *lbearing,
			-- 			     gint        *rbearing,
			-- 			     gint        *width,
			-- 			     gint        *ascent,
			-- 			     gint        *descent);
			-- (from C_GDK)
		do
		end

	frozen gdk_string_height (a_font: POINTER; a_string: POINTER): INTEGER is
			-- gint	 gdk_string_height  (GdkFont        *font,
			-- 			     const gchar    *string);
			-- (from C_GDK)
		do
		end

	frozen gdk_string_measure (a_font: POINTER; a_string: POINTER): INTEGER is
			-- gint	 gdk_string_measure (GdkFont        *font,
			-- 			     const gchar    *string);
			-- (from C_GDK)
		do
		end

	frozen gdk_string_to_compound_text (a_str: POINTER; a_encoding: POINTER; a_format: POINTER; a_ctext: POINTER; a_length: POINTER): INTEGER is
			-- gint       gdk_string_to_compound_text	  (const gchar *str,
			-- 					   GdkAtom *encoding, gint *format,
			-- 					   guchar **ctext, gint *length);
			-- (from C_GDK)
		do
		end

	frozen gdk_string_width (a_font: POINTER; a_string: POINTER): INTEGER is
			-- gint	 gdk_string_width   (GdkFont        *font,
			-- 			     const gchar    *string);
			-- (from C_GDK)
		do
		end

	frozen gdk_text_extents (a_font: POINTER; a_text: POINTER; a_text_length: INTEGER; a_lbearing: POINTER; a_rbearing: POINTER; a_width: POINTER; a_ascent: POINTER; a_descent: POINTER) is
			-- void     gdk_text_extents   (GdkFont     *font,
			-- 			     const gchar *text,
			-- 			     gint         text_length,
			-- 			     gint        *lbearing,
			-- 			     gint        *rbearing,
			-- 			     gint        *width,
			-- 			     gint        *ascent,
			-- 			     gint        *descent);
			-- (from C_GDK)
		do
		end

	frozen gdk_text_extents_wc (a_font: POINTER; a_text: POINTER; a_text_length: INTEGER; a_lbearing: POINTER; a_rbearing: POINTER; a_width: POINTER; a_ascent: POINTER; a_descent: POINTER) is
			-- void    gdk_text_extents_wc (GdkFont        *font,
			-- 			     const GdkWChar *text,
			-- 			     gint            text_length,
			-- 			     gint           *lbearing,
			-- 			     gint           *rbearing,
			-- 			     gint           *width,
			-- 			     gint           *ascent,
			-- 			     gint           *descent);
			-- (from C_GDK)
		do
		end

	frozen gdk_text_height (a_font: POINTER; a_text: POINTER; a_text_length: INTEGER): INTEGER is
			-- gint	 gdk_text_height    (GdkFont        *font,
			-- 			     const gchar    *text,
			-- 			     gint            text_length);
			-- (from C_GDK)
		do
		end

	frozen gdk_text_measure (a_font: POINTER; a_text: POINTER; a_text_length: INTEGER): INTEGER is
			-- gint	 gdk_text_measure   (GdkFont        *font,
			-- 			     const gchar    *text,
			-- 			     gint            text_length);
			-- (from C_GDK)
		do
		end

	frozen gdk_text_width (a_font: POINTER; a_text: POINTER; a_text_length: INTEGER): INTEGER is
			-- gint	 gdk_text_width	    (GdkFont        *font,
			-- 			     const gchar    *text,
			-- 			     gint            text_length);
			-- (from C_GDK)
		do
		end

	frozen gdk_text_width_wc (a_font: POINTER; a_text: POINTER; a_text_length: INTEGER): INTEGER is
			-- gint	 gdk_text_width_wc  (GdkFont        *font,
			-- 			     const GdkWChar *text,
			-- 			     gint            text_length);
			-- (from C_GDK)
		do
		end

	frozen gdk_threads_enter is
			-- void     gdk_threads_enter                (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_threads_leave is
			-- void     gdk_threads_leave                (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_visual_get_best: POINTER is
			-- GdkVisual*    gdk_visual_get_best	     (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_visual_get_best_depth: INTEGER is
			-- gint	      gdk_visual_get_best_depth	     (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_visual_get_best_type: INTEGER is
			-- GdkVisualType gdk_visual_get_best_type	     (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_visual_get_best_with_both (a_depth: INTEGER; a_visual_type: INTEGER): POINTER is
			-- GdkVisual*    gdk_visual_get_best_with_both  (gint	     depth,
			-- 					      GdkVisualType  visual_type);
			-- (from C_GDK)
		do
		end

	frozen gdk_visual_get_best_with_depth (a_depth: INTEGER): POINTER is
			-- GdkVisual*    gdk_visual_get_best_with_depth (gint	     depth);
			-- (from C_GDK)
		do
		end

	frozen gdk_visual_get_best_with_type (a_visual_type: INTEGER): POINTER is
			-- GdkVisual*    gdk_visual_get_best_with_type  (GdkVisualType  visual_type);
			-- (from C_GDK)
		do
		end

	frozen gdk_visual_get_system: POINTER is
			-- GdkVisual*    gdk_visual_get_system	     (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_wcstombs (a_src: POINTER): POINTER is
			-- gchar     *gdk_wcstombs          (const GdkWChar   *src);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_add_filter (a_window: POINTER; a_function: POINTER; a_data: POINTER) is
			-- void	      gdk_window_add_filter	(Gdkwindow     *window,
			-- 					 GdkFilterFunc	function,
			-- 					 gpointer	data);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_at_pointer (a_win_x: POINTER; a_win_y: POINTER): POINTER is
			-- Gdkwindow*    gdk_window_at_pointer  (gint	   *win_x,
			-- 				      gint	   *win_y);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_clear (a_window: POINTER) is
			-- void	      gdk_window_clear	     (Gdkwindow	   *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_clear_area (a_window: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void	      gdk_window_clear_area  (Gdkwindow	   *window,
			-- 				      gint	    x,
			-- 				      gint	    y,
			-- 				      gint	    width,
			-- 				      gint	    height);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_clear_area_e (a_window: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void	      gdk_window_clear_area_e(Gdkwindow	   *window,
			-- 				      gint	    x,
			-- 				      gint	    y,
			-- 				      gint	    width,
			-- 				      gint	    height);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_destroy (a_window: POINTER) is
			-- void	      gdk_window_destroy     (Gdkwindow	    *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_get_children (a_window: POINTER): POINTER is
			-- GList*	      gdk_window_get_children	 (Gdkwindow	  *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_get_colormap (a_window: POINTER): POINTER is
			-- GdkColormap*  gdk_window_get_colormap	 (Gdkwindow	  *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_get_deskrelative_origin (a_window: POINTER; a_x: POINTER; a_y: POINTER): BOOLEAN is
			-- gboolean      gdk_window_get_deskrelative_origin (Gdkwindow	  *window,
			-- 					  gint		  *x,
			-- 					  gint		  *y);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_get_events (a_window: POINTER): INTEGER is
			-- GdkEventMask  gdk_window_get_events	 (Gdkwindow	  *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_get_geometry (a_window: POINTER; a_x: POINTER; a_y: POINTER; a_width: POINTER; a_height: POINTER; a_depth: POINTER) is
			-- void	      gdk_window_get_geometry	 (Gdkwindow	  *window,
			-- 					  gint		  *x,
			-- 					  gint		  *y,
			-- 					  gint		  *width,
			-- 					  gint		  *height,
			-- 					  gint		  *depth);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_get_origin (a_window: POINTER; a_x: POINTER; a_y: POINTER): INTEGER is
			-- gint	      gdk_window_get_origin	 (Gdkwindow	  *window,
			-- 					  gint		  *x,
			-- 					  gint		  *y);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_get_parent (a_window: POINTER): POINTER is
			-- Gdkwindow*    gdk_window_get_parent	 (Gdkwindow	  *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_get_pointer (a_window: POINTER; a_x: POINTER; a_y: POINTER; a_mask: POINTER): POINTER is
			-- Gdkwindow*    gdk_window_get_pointer	 (Gdkwindow	  *window,
			-- 					  gint		  *x,
			-- 					  gint		  *y,
			-- 					  GdkModifierType *mask);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_get_position (a_window: POINTER; a_x: POINTER; a_y: POINTER) is
			-- void	      gdk_window_get_position	 (Gdkwindow	  *window,
			-- 					  gint		  *x,
			-- 					  gint		  *y);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_get_root_origin (a_window: POINTER; a_x: POINTER; a_y: POINTER) is
			-- void	      gdk_window_get_root_origin (Gdkwindow	  *window,
			-- 					  gint		  *x,
			-- 					  gint		  *y);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_get_size (a_window: POINTER; a_width: POINTER; a_height: POINTER) is
			-- void	      gdk_window_get_size	 (Gdkwindow	  *window,
			-- 					  gint		  *width,
			-- 					  gint		  *height);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_get_toplevel (a_window: POINTER): POINTER is
			-- Gdkwindow*    gdk_window_get_toplevel	 (Gdkwindow	  *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_get_toplevels: POINTER is
			-- GList *       gdk_window_get_toplevels   (void);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_get_type (a_window: POINTER): INTEGER is
			-- GdkwindowType gdk_window_get_type	 (Gdkwindow	  *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_get_user_data (a_window: POINTER; a_data: POINTER) is
			-- void	      gdk_window_get_user_data	 (Gdkwindow	  *window,
			-- 					  gpointer	  *data);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_get_visual (a_window: POINTER): POINTER is
			-- GdkVisual*    gdk_window_get_visual	 (Gdkwindow	  *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_hide (a_window: POINTER) is
			-- void	      gdk_window_hide	     (Gdkwindow	   *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_is_viewable (a_window: POINTER): BOOLEAN is
			-- gboolean gdk_window_is_viewable    (Gdkwindow *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_is_visible (a_window: POINTER): BOOLEAN is
			-- gboolean gdk_window_is_visible     (Gdkwindow *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_lower (a_window: POINTER) is
			-- void	      gdk_window_lower	     (Gdkwindow	   *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_merge_child_shapes (a_window: POINTER) is
			-- void gdk_window_merge_child_shapes (Gdkwindow *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_move (a_window: POINTER; a_x: INTEGER; a_y: INTEGER) is
			-- void	      gdk_window_move	     (Gdkwindow	   *window,
			-- 				      gint	    x,
			-- 				      gint	    y);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_move_resize (a_window: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void	      gdk_window_move_resize (Gdkwindow	   *window,
			-- 				      gint	    x,
			-- 				      gint	    y,
			-- 				      gint	    width,
			-- 				      gint	    height);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_new (a_parent: POINTER; a_attributes: POINTER; a_attributes_mask: INTEGER): POINTER is
			-- Gdkwindow*    gdk_window_new	     (Gdkwindow	    *parent,
			-- 				      GdkwindowAttr *attributes,
			-- 				      gint	     attributes_mask);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_raise (a_window: POINTER) is
			-- void	      gdk_window_raise	     (Gdkwindow	   *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_ref (a_window: POINTER): POINTER is
			-- Gdkwindow*    gdk_window_ref	     (Gdkwindow	    *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_register_dnd (a_window: POINTER) is
			-- void          gdk_window_register_dnd    (Gdkwindow       *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_remove_filter (a_window: POINTER; a_function: POINTER; a_data: POINTER) is
			-- void	      gdk_window_remove_filter	(Gdkwindow     *window,
			-- 					 GdkFilterFunc	function,
			-- 					 gpointer	data);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_reparent (a_window: POINTER; a_new_parent: POINTER; a_x: INTEGER; a_y: INTEGER) is
			-- void	      gdk_window_reparent    (Gdkwindow	   *window,
			-- 				      Gdkwindow	   *new_parent,
			-- 				      gint	    x,
			-- 				      gint	    y);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_resize (a_window: POINTER; a_width: INTEGER; a_height: INTEGER) is
			-- void	      gdk_window_resize	     (Gdkwindow	   *window,
			-- 				      gint	    width,
			-- 				      gint	    height);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_set_back_pixmap (a_window: POINTER; a_pixmap: POINTER; a_parent_relative: BOOLEAN) is
			-- void	      gdk_window_set_back_pixmap (Gdkwindow	  *window,
			-- 					  GdkPixmap	  *pixmap,
			-- 					  gboolean         parent_relative);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_set_background (a_window: POINTER; a_color: POINTER) is
			-- void	      gdk_window_set_background	 (Gdkwindow	  *window,
			-- 					  GdkColor	  *color);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_set_child_shapes (a_window: POINTER) is
			-- void gdk_window_set_child_shapes (Gdkwindow *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_set_colormap (a_window: POINTER; a_colormap: POINTER) is
			-- void	      gdk_window_set_colormap	 (Gdkwindow	  *window,
			-- 					  GdkColormap	  *colormap);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_set_cursor (a_window: POINTER; a_cursor: POINTER) is
			-- void	      gdk_window_set_cursor	 (Gdkwindow	  *window,
			-- 					  GdkCursor	  *cursor);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_set_decorations (a_window: POINTER; a_decorations: INTEGER) is
			-- void	      gdk_window_set_decorations (Gdkwindow	  *window,
			-- 					  GdkWMDecoration  decorations);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_set_events (a_window: POINTER; a_event_mask: INTEGER) is
			-- void	      gdk_window_set_events	 (Gdkwindow	  *window,
			-- 					  GdkEventMask	   event_mask);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_set_functions (a_window: POINTER; a_functions: INTEGER) is
			-- void	      gdk_window_set_functions	 (Gdkwindow	  *window,
			-- 					  GdkWMFunction	   functions);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_set_geometry_hints (a_window: POINTER; a_geometry: POINTER; a_flags: INTEGER) is
			-- void          gdk_window_set_geometry_hints (Gdkwindow        *window,
			-- 					     GdkGeometry      *geometry,
			-- 					     GdkwindowHints    flags);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_set_group (a_window: POINTER; a_leader: POINTER) is
			-- void	      gdk_window_set_group	 (Gdkwindow	  *window,
			-- 					  Gdkwindow	  *leader);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_set_hints (a_window: POINTER; a_x: INTEGER; a_y: INTEGER; a_min_width: INTEGER; a_min_height: INTEGER; a_max_width: INTEGER; a_max_height: INTEGER; a_flags: INTEGER) is
			-- void	      gdk_window_set_hints	 (Gdkwindow	  *window,
			-- 					  gint		   x,
			-- 					  gint		   y,
			-- 					  gint		   min_width,
			-- 					  gint		   min_height,
			-- 					  gint		   max_width,
			-- 					  gint		   max_height,
			-- 					  gint		   flags);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_set_icon (a_window: POINTER; a_icon_window: POINTER; a_pixmap: POINTER; a_mask: POINTER) is
			-- void	      gdk_window_set_icon	 (Gdkwindow	  *window,
			-- 					  Gdkwindow	  *icon_window,
			-- 					  GdkPixmap	  *pixmap,
			-- 					  GdkBitmap	  *mask);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_set_icon_name (a_window: POINTER; a_name: POINTER) is
			-- void	      gdk_window_set_icon_name	 (Gdkwindow	  *window,
			-- 					  const gchar	  *name);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_set_override_redirect (a_window: POINTER; a_override_redirect: BOOLEAN) is
			-- void	      gdk_window_set_override_redirect(Gdkwindow  *window,
			-- 					       gboolean override_redirect);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_set_role (a_window: POINTER; a_role: POINTER) is
			-- void          gdk_window_set_role          (Gdkwindow       *window,
			-- 					    const gchar     *role);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_set_static_gravities (a_window: POINTER; a_use_static: BOOLEAN): BOOLEAN is
			-- gboolean gdk_window_set_static_gravities (Gdkwindow *window,
			-- 					  gboolean   use_static);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_set_title (a_window: POINTER; a_title: POINTER) is
			-- void	      gdk_window_set_title	   (Gdkwindow	  *window,
			-- 					    const gchar	  *title);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_set_transient_for (a_window: POINTER; a_leader: POINTER) is
			-- void          gdk_window_set_transient_for (Gdkwindow       *window,
			-- 					    Gdkwindow       *leader);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_set_user_data (a_window: POINTER; a_user_data: POINTER) is
			-- void	      gdk_window_set_user_data	 (Gdkwindow	  *window,
			-- 					  gpointer	   user_data);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_shape_combine_mask (a_window: POINTER; a_shape_mask: POINTER; a_offset_x: INTEGER; a_offset_y: INTEGER) is
			-- void gdk_window_shape_combine_mask (Gdkwindow	    *window,
			-- 				    GdkBitmap	    *shape_mask,
			-- 				    gint	     offset_x,
			-- 				    gint	     offset_y);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_show (a_window: POINTER) is
			-- void	      gdk_window_show	     (Gdkwindow	   *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_unref (a_window: POINTER) is
			-- void	      gdk_window_unref	     (Gdkwindow	    *window);
			-- (from C_GDK)
		do
		end

	frozen gdk_window_withdraw (a_window: POINTER) is
			-- void	      gdk_window_withdraw    (Gdkwindow	   *window);
			-- (from C_GDK)
		do
		end

	frozen gtk_accel_group_lock (a_accel_group: POINTER) is
			-- void		gtk_accel_group_lock		(GtkAccelGroup	*accel_group);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_accel_group_new: POINTER is
			-- GtkAccelGroup*  gtk_accel_group_new	      	(void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_accel_group_ref (a_accel_group: POINTER): POINTER is
			-- GtkAccelGroup*  gtk_accel_group_ref	     	(GtkAccelGroup	*accel_group);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_accel_group_unlock (a_accel_group: POINTER) is
			-- void		gtk_accel_group_unlock		(GtkAccelGroup	*accel_group);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_accel_group_unref (a_accel_group: POINTER) is
			-- void	        gtk_accel_group_unref	      	(GtkAccelGroup	*accel_group);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_accelerator_get_default_mod_mask: INTEGER is
			-- guint	 gtk_accelerator_get_default_mod_mask (void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_accelerator_name (a_accelerator_key: INTEGER; a_accelerator_mods: INTEGER): POINTER is
			-- gchar*	 gtk_accelerator_name		      (guint	        accelerator_key,
			-- 					       GdkModifierType  accelerator_mods);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_accelerator_parse (a_accelerator: POINTER; a_accelerator_key: POINTER; a_accelerator_mods: POINTER) is
			-- void	 gtk_accelerator_parse		      (const gchar     *accelerator,
			-- 					       guint	       *accelerator_key,
			-- 					       GdkModifierType *accelerator_mods);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_accelerator_set_default_mod_mask (a_default_mod_mask: INTEGER) is
			-- void	 gtk_accelerator_set_default_mod_mask (GdkModifierType  default_mod_mask);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_accelerator_valid (a_keyval: INTEGER; a_modifiers: INTEGER): BOOLEAN is
			-- gboolean gtk_accelerator_valid		      (guint	        keyval,
			-- 					       GdkModifierType  modifiers);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_adjustment_changed (a_adjustment: POINTER) is
			-- void	   gtk_adjustment_changed		(GtkAdjustment	 *adjustment);
			-- (from C_GTK_ADJUSTMENT)
		do
		end

	frozen gtk_adjustment_clamp_page (a_adjustment: POINTER; a_lower: REAL; a_upper: REAL) is
			-- void	   gtk_adjustment_clamp_page		(GtkAdjustment	 *adjustment,
			-- 						 gfloat		  lower,
			-- 						 gfloat		  upper);
			-- (from C_GTK_ADJUSTMENT)
		do
		end

	frozen gtk_adjustment_get_type: INTEGER is
			-- GtkType	   gtk_adjustment_get_type		(void);
			-- (from C_GTK_ADJUSTMENT)
		do
		end

	frozen gtk_adjustment_new (a_value: REAL; a_lower: REAL; a_upper: REAL; a_step_increment: REAL; a_page_increment: REAL; a_page_size: REAL): POINTER is
			-- GtkObject* gtk_adjustment_new			(gfloat		  value,
			-- 						 gfloat		  lower,
			-- 						 gfloat		  upper,
			-- 						 gfloat		  step_increment,
			-- 						 gfloat		  page_increment,
			-- 						 gfloat		  page_size);
			-- (from C_GTK_ADJUSTMENT)
		do
		end

	frozen gtk_adjustment_set_value (a_adjustment: POINTER; a_value: REAL) is
			-- void	   gtk_adjustment_set_value		(GtkAdjustment	 *adjustment,
			-- 						 gfloat		  value);
			-- (from C_GTK_ADJUSTMENT)
		do
		end

	frozen gtk_adjustment_value_changed (a_adjustment: POINTER) is
			-- void	   gtk_adjustment_value_changed		(GtkAdjustment	 *adjustment);
			-- (from C_GTK_ADJUSTMENT)
		do
		end

	frozen gtk_alignment_get_type: INTEGER is
			-- GtkType    gtk_alignment_get_type   (void);
			-- (from C_GTK_ALIGNMENT)
		do
		end

	frozen gtk_alignment_new (a_xalign: REAL; a_yalign: REAL; a_xscale: REAL; a_yscale: REAL): POINTER is
			-- GtkWidget* gtk_alignment_new        (gfloat             xalign,
			-- 				     gfloat             yalign,
			-- 				     gfloat             xscale,
			-- 				     gfloat             yscale);
			-- (from C_GTK_ALIGNMENT)
		do
		end

	frozen gtk_alignment_set (a_alignment: POINTER; a_xalign: REAL; a_yalign: REAL; a_xscale: REAL; a_yscale: REAL) is
			-- void       gtk_alignment_set        (GtkAlignment      *alignment,
			-- 				     gfloat             xalign,
			-- 				     gfloat             yalign,
			-- 				     gfloat             xscale,
			-- 				     gfloat             yscale);
			-- (from C_GTK_ALIGNMENT)
		do
		end

	frozen gtk_binding_entry_add_signall (a_binding_set: POINTER; a_keyval: INTEGER; a_modifiers: INTEGER; a_signal_name: POINTER; a_binding_args: POINTER) is
			-- void	 gtk_binding_entry_add_signall	(GtkBindingSet	*binding_set,
			-- 					 guint		 keyval,
			-- 					 guint		 modifiers,
			-- 					 const gchar	*signal_name,
			-- 					 GSList		*binding_args);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_binding_entry_clear (a_binding_set: POINTER; a_keyval: INTEGER; a_modifiers: INTEGER) is
			-- void	 gtk_binding_entry_clear	(GtkBindingSet	*binding_set,
			-- 					 guint		 keyval,
			-- 					 guint		 modifiers);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_binding_entry_remove (a_binding_set: POINTER; a_keyval: INTEGER; a_modifiers: INTEGER) is
			-- void	 gtk_binding_entry_remove	(GtkBindingSet	*binding_set,
			-- 					 guint		 keyval,
			-- 					 guint		 modifiers);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_binding_parse_binding (a_scanner: POINTER): INTEGER is
			-- guint	 gtk_binding_parse_binding	(GScanner	*scanner);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_binding_set_activate (a_binding_set: POINTER; a_keyval: INTEGER; a_modifiers: INTEGER; a_object: POINTER): BOOLEAN is
			-- gboolean gtk_binding_set_activate	(GtkBindingSet	*binding_set,
			-- 					 guint		 keyval,
			-- 					 guint		 modifiers,
			-- 					 GtkObject	*object);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_binding_set_add_path (a_binding_set: POINTER; a_path_type: INTEGER; a_path_pattern: POINTER; a_priority: INTEGER) is
			-- void	 gtk_binding_set_add_path	(GtkBindingSet	*binding_set,
			-- 					 GtkPathType	 path_type,
			-- 					 const gchar	*path_pattern,
			-- 					 GtkPathPriorityType priority);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_binding_set_by_class (a_object_class: POINTER): POINTER is
			-- GtkBindingSet*	gtk_binding_set_by_class(gpointer	 object_class);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_binding_set_find (a_set_name: POINTER): POINTER is
			-- GtkBindingSet*	gtk_binding_set_find	(const gchar	*set_name);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_binding_set_new (a_set_name: POINTER): POINTER is
			-- GtkBindingSet*	gtk_binding_set_new	(const gchar	*set_name);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_bindings_activate (a_object: POINTER; a_keyval: INTEGER; a_modifiers: INTEGER): BOOLEAN is
			-- gboolean gtk_bindings_activate		(GtkObject	*object,
			-- 					 guint		 keyval,
			-- 					 guint		 modifiers);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_box_get_type: INTEGER is
			-- GtkType	   gtk_box_get_type	       (void);
			-- (from C_GTK_BOX)
		do
		end

	frozen gtk_box_pack_end (a_box: POINTER; a_child: POINTER; a_expand: BOOLEAN; a_fill: BOOLEAN; a_padding: INTEGER) is
			-- void	   gtk_box_pack_end	       (GtkBox	     *box,
			-- 					GtkWidget    *child,
			-- 					gboolean      expand,
			-- 					gboolean      fill,
			-- 					guint	      padding);
			-- (from C_GTK_BOX)
		do
		end

	frozen gtk_box_pack_end_defaults (a_box: POINTER; a_widget: POINTER) is
			-- void	   gtk_box_pack_end_defaults   (GtkBox	     *box,
			-- 					GtkWidget    *widget);
			-- (from C_GTK_BOX)
		do
		end

	frozen gtk_box_pack_start (a_box: POINTER; a_child: POINTER; a_expand: BOOLEAN; a_fill: BOOLEAN; a_padding: INTEGER) is
			-- void	   gtk_box_pack_start	       (GtkBox	     *box,
			-- 					GtkWidget    *child,
			-- 					gboolean      expand,
			-- 					gboolean      fill,
			-- 					guint	      padding);
			-- (from C_GTK_BOX)
		do
		end

	frozen gtk_box_pack_start_defaults (a_box: POINTER; a_widget: POINTER) is
			-- void	   gtk_box_pack_start_defaults (GtkBox	     *box,
			-- 					GtkWidget    *widget);
			-- (from C_GTK_BOX)
		do
		end

	frozen gtk_box_query_child_packing (a_box: POINTER; a_child: POINTER; a_expand: POINTER; a_fill: POINTER; a_padding: POINTER; a_pack_type: POINTER) is
			-- void	   gtk_box_query_child_packing (GtkBox	     *box,
			-- 					GtkWidget    *child,
			-- 					gboolean     *expand,
			-- 					gboolean     *fill,
			-- 					guint	     *padding,
			-- 					GtkPackType  *pack_type);
			-- (from C_GTK_BOX)
		do
		end

	frozen gtk_box_reorder_child (a_box: POINTER; a_child: POINTER; a_position: INTEGER) is
			-- void	   gtk_box_reorder_child       (GtkBox	     *box,
			-- 					GtkWidget    *child,
			-- 					gint	      position);
			-- (from C_GTK_BOX)
		do
		end

	frozen gtk_box_set_child_packing (a_box: POINTER; a_child: POINTER; a_expand: BOOLEAN; a_fill: BOOLEAN; a_padding: INTEGER; a_pack_type: INTEGER) is
			-- void	   gtk_box_set_child_packing   (GtkBox	     *box,
			-- 					GtkWidget    *child,
			-- 					gboolean      expand,
			-- 					gboolean      fill,
			-- 					guint	      padding,
			-- 					GtkPackType   pack_type);
			-- (from C_GTK_BOX)
		do
		end

	frozen gtk_box_set_homogeneous (a_box: POINTER; a_homogeneous: BOOLEAN) is
			-- void	   gtk_box_set_homogeneous     (GtkBox	     *box,
			-- 					gboolean      homogeneous);
			-- (from C_GTK_BOX)
		do
		end

	frozen gtk_box_set_spacing (a_box: POINTER; a_spacing: INTEGER) is
			-- void	   gtk_box_set_spacing	       (GtkBox	     *box,
			-- 					gint	      spacing);
			-- (from C_GTK_BOX)
		do
		end

	frozen gtk_button_clicked (a_button: POINTER) is
			-- void           gtk_button_clicked        (GtkButton *button);
			-- (from C_GTK_BUTTON)
		do
		end

	frozen gtk_button_enter (a_button: POINTER) is
			-- void           gtk_button_enter          (GtkButton *button);
			-- (from C_GTK_BUTTON)
		do
		end

	frozen gtk_button_get_relief (a_button: POINTER): INTEGER is
			-- GtkReliefStyle gtk_button_get_relief      (GtkButton *button);
			-- (from C_GTK_BUTTON)
		do
		end

	frozen gtk_button_get_type: INTEGER is
			-- GtkType        gtk_button_get_type       (void);
			-- (from C_GTK_BUTTON)
		do
		end

	frozen gtk_button_leave (a_button: POINTER) is
			-- void           gtk_button_leave          (GtkButton *button);
			-- (from C_GTK_BUTTON)
		do
		end

	frozen gtk_button_new: POINTER is
			-- GtkWidget*     gtk_button_new            (void);
			-- (from C_GTK_BUTTON)
		do
		end

	frozen gtk_button_new_with_label (a_label: POINTER): POINTER is
			-- GtkWidget*     gtk_button_new_with_label (const gchar *label);
			-- (from C_GTK_BUTTON)
		do
		end

	frozen gtk_button_pressed (a_button: POINTER) is
			-- void           gtk_button_pressed        (GtkButton *button);
			-- (from C_GTK_BUTTON)
		do
		end

	frozen gtk_button_released (a_button: POINTER) is
			-- void           gtk_button_released       (GtkButton *button);
			-- (from C_GTK_BUTTON)
		do
		end

	frozen gtk_button_set_relief (a_button: POINTER; a_newstyle: INTEGER) is
			-- void           gtk_button_set_relief     (GtkButton *button,
			-- 					  GtkReliefStyle newstyle);
			-- (from C_GTK_BUTTON)
		do
		end

	frozen gtk_check_button_get_type: INTEGER is
			-- GtkType    gtk_check_button_get_type       (void);
			-- (from C_GTK_CHECK_BUTTON)
		do
		end

	frozen gtk_check_button_new: POINTER is
			-- GtkWidget* gtk_check_button_new            (void);
			-- (from C_GTK_CHECK_BUTTON)
		do
		end

	frozen gtk_check_button_new_with_label (a_label: POINTER): POINTER is
			-- GtkWidget* gtk_check_button_new_with_label (const gchar *label);
			-- (from C_GTK_CHECK_BUTTON)
		do
		end

	frozen gtk_check_menu_item_get_type: INTEGER is
			-- GtkType	   gtk_check_menu_item_get_type	       (void);
			-- (from C_GTK_CHECK_MENU_ITEM)
		do
		end

	frozen gtk_check_menu_item_new: POINTER is
			-- GtkWidget* gtk_check_menu_item_new	       (void);
			-- (from C_GTK_CHECK_MENU_ITEM)
		do
		end

	frozen gtk_check_menu_item_new_with_label (a_label: POINTER): POINTER is
			-- GtkWidget* gtk_check_menu_item_new_with_label  (const gchar	 *label);
			-- (from C_GTK_CHECK_MENU_ITEM)
		do
		end

	frozen gtk_check_menu_item_set_active (a_check_menu_item: POINTER; a_is_active: BOOLEAN) is
			-- void	   gtk_check_menu_item_set_active      (GtkCheckMenuItem *check_menu_item,
			-- 						gboolean	  is_active);
			-- (from C_GTK_CHECK_MENU_ITEM)
		do
		end

	frozen gtk_check_menu_item_set_show_toggle (a_menu_item: POINTER; a_always: BOOLEAN) is
			-- void	   gtk_check_menu_item_set_show_toggle (GtkCheckMenuItem *menu_item,
			-- 						gboolean	  always);
			-- (from C_GTK_CHECK_MENU_ITEM)
		do
		end

	frozen gtk_check_menu_item_toggled (a_check_menu_item: POINTER) is
			-- void	   gtk_check_menu_item_toggled	       (GtkCheckMenuItem *check_menu_item);
			-- (from C_GTK_CHECK_MENU_ITEM)
		do
		end

	frozen gtk_check_version (a_required_major: INTEGER; a_required_minor: INTEGER; a_required_micro: INTEGER): POINTER is
			-- gchar* gtk_check_version (guint	required_major,
			-- 			  guint	required_minor,
			-- 			  guint	required_micro);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_clist_append (a_clist: POINTER; a_text: POINTER): INTEGER is
			-- gint gtk_clist_append  (GtkCList    *clist,
			-- 			gchar       *text[]);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_clear (a_clist: POINTER) is
			-- void gtk_clist_clear (GtkCList *clist);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_column_title_active (a_clist: POINTER; a_column: INTEGER) is
			-- void gtk_clist_column_title_active   (GtkCList *clist,
			-- 				      gint      column);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_column_title_passive (a_clist: POINTER; a_column: INTEGER) is
			-- void gtk_clist_column_title_passive  (GtkCList *clist,
			-- 				      gint      column);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_column_titles_active (a_clist: POINTER) is
			-- void gtk_clist_column_titles_active  (GtkCList *clist);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_column_titles_hide (a_clist: POINTER) is
			-- void gtk_clist_column_titles_hide (GtkCList *clist);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_column_titles_passive (a_clist: POINTER) is
			-- void gtk_clist_column_titles_passive (GtkCList *clist);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_column_titles_show (a_clist: POINTER) is
			-- void gtk_clist_column_titles_show (GtkCList *clist);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_columns_autosize (a_clist: POINTER): INTEGER is
			-- gint gtk_clist_columns_autosize (GtkCList *clist);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_find_row_from_data (a_clist: POINTER; a_data: POINTER): INTEGER is
			-- gint gtk_clist_find_row_from_data (GtkCList *clist,
			-- 				   gpointer  data);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_freeze (a_clist: POINTER) is
			-- void gtk_clist_freeze (GtkCList *clist);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_get_cell_style (a_clist: POINTER; a_row: INTEGER; a_column: INTEGER): POINTER is
			-- GtkStyle *gtk_clist_get_cell_style (GtkCList *clist,
			-- 				    gint      row,
			-- 				    gint      column);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_get_cell_type (a_clist: POINTER; a_row: INTEGER; a_column: INTEGER): INTEGER is
			-- GtkCellType gtk_clist_get_cell_type (GtkCList *clist,
			-- 				     gint      row,
			-- 				     gint      column);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_get_column_title (a_clist: POINTER; a_column: INTEGER): POINTER is
			-- gchar * gtk_clist_get_column_title (GtkCList *clist,
			-- 				    gint      column);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_get_column_widget (a_clist: POINTER; a_column: INTEGER): POINTER is
			-- GtkWidget * gtk_clist_get_column_widget (GtkCList *clist,
			-- 					 gint      column);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_get_hadjustment (a_clist: POINTER): POINTER is
			-- GtkAdjustment* gtk_clist_get_hadjustment (GtkCList *clist);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_get_pixmap (a_clist: POINTER; a_row: INTEGER; a_column: INTEGER; a_pixmap: POINTER; a_mask: POINTER): INTEGER is
			-- gint gtk_clist_get_pixmap (GtkCList   *clist,
			-- 			   gint        row,
			-- 			   gint        column,
			-- 			   GdkPixmap **pixmap,
			-- 			   GdkBitmap **mask);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_get_pixtext (a_clist: POINTER; a_row: INTEGER; a_column: INTEGER; a_text: POINTER; a_spacing: POINTER; a_pixmap: POINTER; a_mask: POINTER): INTEGER is
			-- gint gtk_clist_get_pixtext (GtkCList   *clist,
			-- 			    gint        row,
			-- 			    gint        column,
			-- 			    gchar     **text,
			-- 			    guint8     *spacing,
			-- 			    GdkPixmap **pixmap,
			-- 			    GdkBitmap **mask);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_get_row_data (a_clist: POINTER; a_row: INTEGER): POINTER is
			-- gpointer gtk_clist_get_row_data (GtkCList *clist,
			-- 				 gint      row);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_get_row_style (a_clist: POINTER; a_row: INTEGER): POINTER is
			-- GtkStyle *gtk_clist_get_row_style (GtkCList *clist,
			-- 				   gint      row);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_get_selectable (a_clist: POINTER; a_row: INTEGER): BOOLEAN is
			-- gboolean gtk_clist_get_selectable (GtkCList *clist,
			-- 				   gint      row);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_get_selection_info (a_clist: POINTER; a_x: INTEGER; a_y: INTEGER; a_row: POINTER; a_column: POINTER): INTEGER is
			-- gint gtk_clist_get_selection_info (GtkCList *clist,
			-- 			     	   gint      x,
			-- 			     	   gint      y,
			-- 			     	   gint     *row,
			-- 			     	   gint     *column);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_get_text (a_clist: POINTER; a_row: INTEGER; a_column: INTEGER; a_text: POINTER): INTEGER is
			-- gint gtk_clist_get_text (GtkCList  *clist,
			-- 			 gint       row,
			-- 			 gint       column,
			-- 			 gchar    **text);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_get_type: INTEGER is
			-- GtkType gtk_clist_get_type (void);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_get_vadjustment (a_clist: POINTER): POINTER is
			-- GtkAdjustment* gtk_clist_get_vadjustment (GtkCList *clist);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_insert (a_clist: POINTER; a_row: INTEGER; a_text: POINTER): INTEGER is
			-- gint gtk_clist_insert (GtkCList    *clist,
			-- 		       gint         row,
			-- 		       gchar       *text[]);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_moveto (a_clist: POINTER; a_row: INTEGER; a_column: INTEGER; a_row_align: REAL; a_col_align: REAL) is
			-- void gtk_clist_moveto (GtkCList *clist,
			-- 		       gint      row,
			-- 		       gint      column,
			-- 		       gfloat    row_align,
			-- 		       gfloat    col_align);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_new (a_columns: INTEGER): POINTER is
			-- GtkWidget* gtk_clist_new             (gint   columns);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_new_with_titles (a_columns: INTEGER; a_titles: POINTER): POINTER is
			-- GtkWidget* gtk_clist_new_with_titles (gint   columns,
			-- 				      gchar *titles[]);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_optimal_column_width (a_clist: POINTER; a_column: INTEGER): INTEGER is
			-- gint gtk_clist_optimal_column_width (GtkCList *clist,
			-- 				     gint      column);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_prepend (a_clist: POINTER; a_text: POINTER): INTEGER is
			-- gint gtk_clist_prepend (GtkCList    *clist,
			-- 		        gchar       *text[]);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_remove (a_clist: POINTER; a_row: INTEGER) is
			-- void gtk_clist_remove (GtkCList *clist,
			-- 		       gint      row);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_row_is_visible (a_clist: POINTER; a_row: INTEGER): INTEGER is
			-- GtkVisibility gtk_clist_row_is_visible (GtkCList *clist,
			-- 					gint      row);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_row_move (a_clist: POINTER; a_source_row: INTEGER; a_dest_row: INTEGER) is
			-- void gtk_clist_row_move (GtkCList *clist,
			-- 			 gint      source_row,
			-- 			 gint      dest_row);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_select_all (a_clist: POINTER) is
			-- void gtk_clist_select_all (GtkCList *clist);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_select_row (a_clist: POINTER; a_row: INTEGER; a_column: INTEGER) is
			-- void gtk_clist_select_row (GtkCList *clist,
			-- 			   gint      row,
			-- 			   gint      column);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_auto_sort (a_clist: POINTER; a_auto_sort: BOOLEAN) is
			-- void gtk_clist_set_auto_sort (GtkCList *clist,
			-- 			      gboolean  auto_sort);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_background (a_clist: POINTER; a_row: INTEGER; a_color: POINTER) is
			-- void gtk_clist_set_background (GtkCList *clist,
			-- 			       gint      row,
			-- 			       GdkColor *color);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_button_actions (a_clist: POINTER; a_button: INTEGER; a_button_actions: INTEGER) is
			-- void gtk_clist_set_button_actions (GtkCList *clist,
			-- 				   guint     button,
			-- 				   guint8    button_actions);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_cell_style (a_clist: POINTER; a_row: INTEGER; a_column: INTEGER; a_style: POINTER) is
			-- void gtk_clist_set_cell_style (GtkCList *clist,
			-- 			       gint      row,
			-- 			       gint      column,
			-- 			       GtkStyle *style);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_column_auto_resize (a_clist: POINTER; a_column: INTEGER; a_auto_resize: BOOLEAN) is
			-- void gtk_clist_set_column_auto_resize (GtkCList *clist,
			-- 				       gint      column,
			-- 				       gboolean  auto_resize);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_column_justification (a_clist: POINTER; a_column: INTEGER; a_justification: INTEGER) is
			-- void gtk_clist_set_column_justification (GtkCList         *clist,
			-- 					 gint              column,
			-- 					 GtkJustification  justification);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_column_max_width (a_clist: POINTER; a_column: INTEGER; a_max_width: INTEGER) is
			-- void gtk_clist_set_column_max_width (GtkCList *clist,
			-- 				     gint      column,
			-- 				     gint      max_width);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_column_min_width (a_clist: POINTER; a_column: INTEGER; a_min_width: INTEGER) is
			-- void gtk_clist_set_column_min_width (GtkCList *clist,
			-- 				     gint      column,
			-- 				     gint      min_width);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_column_resizeable (a_clist: POINTER; a_column: INTEGER; a_resizeable: BOOLEAN) is
			-- void gtk_clist_set_column_resizeable (GtkCList *clist,
			-- 				      gint      column,
			-- 				      gboolean  resizeable);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_column_title (a_clist: POINTER; a_column: INTEGER; a_title: POINTER) is
			-- void gtk_clist_set_column_title (GtkCList    *clist,
			-- 				 gint         column,
			-- 				 const gchar *title);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_column_visibility (a_clist: POINTER; a_column: INTEGER; a_visible: BOOLEAN) is
			-- void gtk_clist_set_column_visibility (GtkCList *clist,
			-- 				      gint      column,
			-- 				      gboolean  visible);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_column_widget (a_clist: POINTER; a_column: INTEGER; a_widget: POINTER) is
			-- void gtk_clist_set_column_widget (GtkCList  *clist,
			-- 				  gint       column,
			-- 				  GtkWidget *widget);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_column_width (a_clist: POINTER; a_column: INTEGER; a_width: INTEGER) is
			-- void gtk_clist_set_column_width (GtkCList *clist,
			-- 				 gint      column,
			-- 				 gint      width);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_compare_func (a_clist: POINTER; a_cmp_func: POINTER) is
			-- void gtk_clist_set_compare_func (GtkCList            *clist,
			-- 				 GtkCListCompareFunc  cmp_func);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_foreground (a_clist: POINTER; a_row: INTEGER; a_color: POINTER) is
			-- void gtk_clist_set_foreground (GtkCList *clist,
			-- 			       gint      row,
			-- 			       GdkColor *color);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_hadjustment (a_clist: POINTER; a_adjustment: POINTER) is
			-- void gtk_clist_set_hadjustment (GtkCList      *clist,
			-- 				GtkAdjustment *adjustment);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_pixmap (a_clist: POINTER; a_row: INTEGER; a_column: INTEGER; a_pixmap: POINTER; a_mask: POINTER) is
			-- void gtk_clist_set_pixmap (GtkCList  *clist,
			-- 			   gint       row,
			-- 			   gint       column,
			-- 			   GdkPixmap *pixmap,
			-- 			   GdkBitmap *mask);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_pixtext (a_clist: POINTER; a_row: INTEGER; a_column: INTEGER; a_text: POINTER; a_spacing: INTEGER; a_pixmap: POINTER; a_mask: POINTER) is
			-- void gtk_clist_set_pixtext (GtkCList    *clist,
			-- 			    gint         row,
			-- 			    gint         column,
			-- 			    const gchar *text,
			-- 			    guint8       spacing,
			-- 			    GdkPixmap   *pixmap,
			-- 			    GdkBitmap   *mask);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_reorderable (a_clist: POINTER; a_reorderable: BOOLEAN) is
			-- void gtk_clist_set_reorderable (GtkCList *clist,
			-- 				gboolean  reorderable);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_row_data (a_clist: POINTER; a_row: INTEGER; a_data: POINTER) is
			-- void gtk_clist_set_row_data (GtkCList *clist,
			-- 			     gint      row,
			-- 			     gpointer  data);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_row_data_full (a_clist: POINTER; a_row: INTEGER; a_data: POINTER; a_destroy: POINTER) is
			-- void gtk_clist_set_row_data_full (GtkCList         *clist,
			-- 			          gint              row,
			-- 			          gpointer          data,
			-- 				  GtkDestroyNotify  destroy);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_row_height (a_clist: POINTER; a_height: INTEGER) is
			-- void gtk_clist_set_row_height (GtkCList *clist,
			-- 			       guint     height);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_row_style (a_clist: POINTER; a_row: INTEGER; a_style: POINTER) is
			-- void gtk_clist_set_row_style (GtkCList *clist,
			-- 			      gint      row,
			-- 			      GtkStyle *style);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_selectable (a_clist: POINTER; a_row: INTEGER; a_selectable: BOOLEAN) is
			-- void gtk_clist_set_selectable (GtkCList *clist,
			-- 			       gint      row,
			-- 			       gboolean  selectable);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_selection_mode (a_clist: POINTER; a_mode: INTEGER) is
			-- void gtk_clist_set_selection_mode (GtkCList         *clist,
			-- 				   GtkSelectionMode  mode);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_shadow_type (a_clist: POINTER; a_type: INTEGER) is
			-- void gtk_clist_set_shadow_type (GtkCList      *clist,
			-- 				GtkshadowType  type);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_shift (a_clist: POINTER; a_row: INTEGER; a_column: INTEGER; a_vertical: INTEGER; a_horizontal: INTEGER) is
			-- void gtk_clist_set_shift (GtkCList *clist,
			-- 			  gint      row,
			-- 			  gint      column,
			-- 			  gint      vertical,
			-- 			  gint      horizontal);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_sort_column (a_clist: POINTER; a_column: INTEGER) is
			-- void gtk_clist_set_sort_column (GtkCList *clist,
			-- 				gint      column);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_sort_type (a_clist: POINTER; a_sort_type: INTEGER) is
			-- void gtk_clist_set_sort_type (GtkCList    *clist,
			-- 			      GtkSortType  sort_type);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_text (a_clist: POINTER; a_row: INTEGER; a_column: INTEGER; a_text: POINTER) is
			-- void gtk_clist_set_text (GtkCList    *clist,
			-- 			 gint         row,
			-- 			 gint         column,
			-- 			 const gchar *text);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_use_drag_icons (a_clist: POINTER; a_use_icons: BOOLEAN) is
			-- void gtk_clist_set_use_drag_icons (GtkCList *clist,
			-- 				   gboolean  use_icons);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_set_vadjustment (a_clist: POINTER; a_adjustment: POINTER) is
			-- void gtk_clist_set_vadjustment (GtkCList      *clist,
			-- 				GtkAdjustment *adjustment);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_sort (a_clist: POINTER) is
			-- void gtk_clist_sort (GtkCList *clist);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_swap_rows (a_clist: POINTER; a_row1: INTEGER; a_row2: INTEGER) is
			-- void gtk_clist_swap_rows (GtkCList *clist,
			-- 			  gint      row1,
			-- 			  gint      row2);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_thaw (a_clist: POINTER) is
			-- void gtk_clist_thaw   (GtkCList *clist);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_undo_selection (a_clist: POINTER) is
			-- void gtk_clist_undo_selection (GtkCList *clist);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_unselect_all (a_clist: POINTER) is
			-- void gtk_clist_unselect_all (GtkCList *clist);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_clist_unselect_row (a_clist: POINTER; a_row: INTEGER; a_column: INTEGER) is
			-- void gtk_clist_unselect_row (GtkCList *clist,
			-- 			     gint      row,
			-- 			     gint      column);
			-- (from C_GTK_CLIST)
		do
		end

	frozen gtk_color_selection_dialog_get_type: INTEGER is
			-- GtkType    gtk_color_selection_dialog_get_type   (void);
			-- (from C_GTK_COLOR_SELECTION_DIALOG)
		do
		end

	frozen gtk_color_selection_dialog_new (a_title: POINTER): POINTER is
			-- GtkWidget* gtk_color_selection_dialog_new        (const gchar *title);
			-- (from C_GTK_COLOR_SELECTION_DIALOG)
		do
		end

	frozen gtk_color_selection_get_color (a_colorsel: POINTER; a_color: POINTER) is
			-- void       gtk_color_selection_get_color         (GtkColorSelection     *colorsel,
			--                                                   g		double               *color);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_color_selection_get_type: INTEGER is
			-- GtkType    gtk_color_selection_get_type          (void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_color_selection_new: POINTER is
			-- GtkWidget* gtk_color_selection_new               (void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_color_selection_set_color (a_colorsel: POINTER; a_color: POINTER) is
			-- void       gtk_color_selection_set_color         (GtkColorSelection     *colorsel,
			-- 					          g		double               *color);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_color_selection_set_update_policy (a_colorsel: POINTER; a_policy: INTEGER) is
			-- void       gtk_color_selection_set_update_policy (GtkColorSelection     *colorsel,
			--                                                   GtkUpdateType          policy);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_combo_disable_activate (a_combo: POINTER) is
			-- void       gtk_combo_disable_activate      (GtkCombo*    combo);
			-- (from C_GTK_COMBO)
		do
		end

	frozen gtk_combo_get_type: INTEGER is
			-- guint      gtk_combo_get_type              (void);
			-- (from C_GTK_COMBO)
		do
		end

	frozen gtk_combo_new: POINTER is
			-- GtkWidget *gtk_combo_new                   (void);
			-- (from C_GTK_COMBO)
		do
		end

	frozen gtk_combo_set_case_sensitive (a_combo: POINTER; a_val: INTEGER) is
			-- void       gtk_combo_set_case_sensitive    (GtkCombo*    combo,
			--                                             gint         val);
			-- (from C_GTK_COMBO)
		do
		end

	frozen gtk_combo_set_item_string (a_combo: POINTER; a_item: POINTER; a_item_value: POINTER) is
			-- void       gtk_combo_set_item_string       (GtkCombo*    combo,
			--                                             GtkItem*     item,
			--                                             const gchar* item_value);
			-- (from C_GTK_COMBO)
		do
		end

	frozen gtk_combo_set_popdown_strings (a_combo: POINTER; a_strings: POINTER) is
			-- void       gtk_combo_set_popdown_strings   (GtkCombo*    combo,
			--                                             GList        *strings);
			-- (from C_GTK_COMBO)
		do
		end

	frozen gtk_combo_set_use_arrows (a_combo: POINTER; a_val: INTEGER) is
			-- void       gtk_combo_set_use_arrows        (GtkCombo*    combo,
			--                                             gint         val);
			-- (from C_GTK_COMBO)
		do
		end

	frozen gtk_combo_set_use_arrows_always (a_combo: POINTER; a_val: INTEGER) is
			-- void       gtk_combo_set_use_arrows_always (GtkCombo*    combo,
			--                                             gint         val);
			-- (from C_GTK_COMBO)
		do
		end

	frozen gtk_combo_set_value_in_list (a_combo: POINTER; a_val: INTEGER; a_ok_if_empty: INTEGER) is
			-- void       gtk_combo_set_value_in_list     (GtkCombo*    combo,
			--                                             gint         val,
			--                                             gint         ok_if_empty);
			-- (from C_GTK_COMBO)
		do
		end

	frozen gtk_container_add (a_container: POINTER; a_widget: POINTER) is
			-- void    gtk_container_add		 (GtkContainer	   *container,
			-- 					  GtkWidget	   *widget);
			-- (from C_GTK_CONTAINER)
		do
		end

	frozen gtk_container_check_resize (a_container: POINTER) is
			-- void    gtk_container_check_resize       (GtkContainer     *container);
			-- (from C_GTK_CONTAINER)
		do
		end

	frozen gtk_container_children (a_container: POINTER): POINTER is
			-- GList* gtk_container_children		 (GtkContainer	   *container);
			-- (from C_GTK_CONTAINER)
		do
		end

	frozen gtk_container_forall (a_container: POINTER; a_callback: POINTER; a_callback_data: POINTER) is
			-- void    gtk_container_forall		     (GtkContainer *container,
			-- 					      GtkCallback   callback,
			-- 					      gpointer	    callback_data);
			-- (from C_GTK_CONTAINER)
		do
		end

	frozen gtk_container_foreach (a_container: POINTER; a_callback: POINTER; a_callback_data: POINTER) is
			-- void    gtk_container_foreach		 (GtkContainer	   *container,
			-- 					  GtkCallback	    callback,
			-- 					  gpointer	    callback_data);
			-- (from C_GTK_CONTAINER)
		do
		end

	frozen gtk_container_foreach_full (a_container: POINTER; a_callback: POINTER; a_marshal: POINTER; a_callback_data: POINTER; a_notify: POINTER) is
			-- void    gtk_container_foreach_full	 (GtkContainer	   *container,
			-- 					  GtkCallback	    callback,
			-- 					  GtkCallbackMarshal marshal,
			-- 					  gpointer	    callback_data,
			-- 					  GtkDestroyNotify  notify);
			-- (from C_GTK_CONTAINER)
		do
		end

	frozen gtk_container_get_type: INTEGER is
			-- GtkType gtk_container_get_type		 (void);
			-- (from C_GTK_CONTAINER)
		do
		end

	frozen gtk_container_remove (a_container: POINTER; a_widget: POINTER) is
			-- void    gtk_container_remove		 (GtkContainer	   *container,
			-- 					  GtkWidget	   *widget);
			-- (from C_GTK_CONTAINER)
		do
		end

	frozen gtk_container_resize_children (a_container: POINTER) is
			-- void    gtk_container_resize_children      (GtkContainer     *container);
			-- (from C_GTK_CONTAINER)
		do
		end

	frozen gtk_container_set_border_width (a_container: POINTER; a_border_width: INTEGER) is
			-- void    gtk_container_set_border_width	 (GtkContainer	   *container,
			-- 					  guint		    border_width);
			-- (from C_GTK_CONTAINER)
		do
		end

	frozen gtk_container_set_focus_child (a_container: POINTER; a_child: POINTER) is
			-- void   gtk_container_set_focus_child	   (GtkContainer     *container,
			-- 					    GtkWidget	     *child);
			-- (from C_GTK_CONTAINER)
		do
		end

	frozen gtk_container_set_focus_hadjustment (a_container: POINTER; a_adjustment: POINTER) is
			-- void   gtk_container_set_focus_hadjustment (GtkContainer     *container,
			-- 					    GtkAdjustment    *adjustment);
			-- (from C_GTK_CONTAINER)
		do
		end

	frozen gtk_container_set_focus_vadjustment (a_container: POINTER; a_adjustment: POINTER) is
			-- void   gtk_container_set_focus_vadjustment (GtkContainer     *container,
			-- 					    GtkAdjustment    *adjustment);
			-- (from C_GTK_CONTAINER)
		do
		end

	frozen gtk_container_set_reallocate_redraws (a_container: POINTER; a_needs_redraws: BOOLEAN) is
			-- void   gtk_container_set_reallocate_redraws (GtkContainer    *container,
			-- 					     gboolean         needs_redraws);
			-- (from C_GTK_CONTAINER)
		do
		end

	frozen gtk_container_set_resize_mode (a_container: POINTER; a_resize_mode: INTEGER) is
			-- void    gtk_container_set_resize_mode    (GtkContainer     *container,
			-- 					  GtkResizeMode     resize_mode);
			-- (from C_GTK_CONTAINER)
		do
		end

	frozen gtk_ctree_collapse (a_ctree: POINTER; a_node: POINTER) is
			-- void gtk_ctree_collapse                          (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_collapse_recursive (a_ctree: POINTER; a_node: POINTER) is
			-- void gtk_ctree_collapse_recursive                (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_collapse_to_depth (a_ctree: POINTER; a_node: POINTER; a_depth: INTEGER) is
			-- void gtk_ctree_collapse_to_depth                 (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gint          depth);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_expand (a_ctree: POINTER; a_node: POINTER) is
			-- void gtk_ctree_expand                            (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_expand_recursive (a_ctree: POINTER; a_node: POINTER) is
			-- void gtk_ctree_expand_recursive                  (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_expand_to_depth (a_ctree: POINTER; a_node: POINTER; a_depth: INTEGER) is
			-- void gtk_ctree_expand_to_depth                   (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gint          depth);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_export_to_gnode (a_ctree: POINTER; a_parent: POINTER; a_sibling: POINTER; a_node: POINTER; a_func: POINTER; a_data: POINTER): POINTER is
			-- GNode * gtk_ctree_export_to_gnode                (GtkCTree          *ctree,
			-- 						  GNode             *parent,
			-- 						  GNode             *sibling,
			-- 						  GtkCTreeNode      *node,
			-- 						  GtkCTreeGNodeFunc  func,
			-- 						  gpointer           data);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_find (a_ctree: POINTER; a_node: POINTER; a_child: POINTER): BOOLEAN is
			-- gboolean gtk_ctree_find                          (GtkCTree     *ctree,
			-- 					          GtkCTreeNode *node,
			-- 					          GtkCTreeNode *child);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_find_all_by_row_data (a_ctree: POINTER; a_node: POINTER; a_data: POINTER): POINTER is
			-- GList * gtk_ctree_find_all_by_row_data           (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gpointer      data);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_find_all_by_row_data_custom (a_ctree: POINTER; a_node: POINTER; a_data: POINTER; a_func: POINTER): POINTER is
			-- GList * gtk_ctree_find_all_by_row_data_custom    (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gpointer      data,
			-- 						  GCompareFunc  func);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_find_by_row_data (a_ctree: POINTER; a_node: POINTER; a_data: POINTER): POINTER is
			-- GtkCTreeNode * gtk_ctree_find_by_row_data        (GtkCTree     *ctree,
			-- 					          GtkCTreeNode *node,
			-- 					          gpointer      data);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_find_by_row_data_custom (a_ctree: POINTER; a_node: POINTER; a_data: POINTER; a_func: POINTER): POINTER is
			-- GtkCTreeNode * gtk_ctree_find_by_row_data_custom (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gpointer      data,
			-- 						  GCompareFunc  func);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_find_node_ptr (a_ctree: POINTER; a_ctree_row: POINTER): POINTER is
			-- GtkCTreeNode * gtk_ctree_find_node_ptr           (GtkCTree     *ctree,
			-- 					          GtkCTreeRow  *ctree_row);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_get_node_info (a_ctree: POINTER; a_node: POINTER; a_text: POINTER; a_spacing: POINTER; a_pixmap_closed: POINTER; a_mask_closed: POINTER; a_pixmap_opened: POINTER; a_mask_opened: POINTER; a_is_leaf: POINTER; a_expanded: POINTER): INTEGER is
			-- gint gtk_ctree_get_node_info                     (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gchar       **text,
			-- 						  guint8       *spacing,
			-- 						  GdkPixmap   **pixmap_closed,
			-- 						  GdkBitmap   **mask_closed,
			-- 						  GdkPixmap   **pixmap_opened,
			-- 						  GdkBitmap   **mask_opened,
			-- 						  gboolean     *is_leaf,
			-- 						  gboolean     *expanded);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_get_type: INTEGER is
			-- GtkType gtk_ctree_get_type                       (void);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_insert_gnode (a_ctree: POINTER; a_parent: POINTER; a_sibling: POINTER; a_gnode: POINTER; a_func: POINTER; a_data: POINTER): POINTER is
			-- GtkCTreeNode * gtk_ctree_insert_gnode            (GtkCTree          *ctree,
			-- 						  GtkCTreeNode      *parent,
			-- 						  GtkCTreeNode      *sibling,
			-- 						  GNode             *gnode,
			-- 						  GtkCTreeGNodeFunc  func,
			-- 						  gpointer           data);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_insert_node (a_ctree: POINTER; a_parent: POINTER; a_sibling: POINTER; a_text: POINTER; a_spacing: INTEGER; a_pixmap_closed: POINTER; a_mask_closed: POINTER; a_pixmap_opened: POINTER; a_mask_opened: POINTER; a_is_leaf: BOOLEAN; a_expanded: BOOLEAN): POINTER is
			-- GtkCTreeNode * gtk_ctree_insert_node             (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *parent,
			-- 						  GtkCTreeNode *sibling,
			-- 						  gchar        *text[],
			-- 						  guint8        spacing,
			-- 						  GdkPixmap    *pixmap_closed,
			-- 						  GdkBitmap    *mask_closed,
			-- 						  GdkPixmap    *pixmap_opened,
			-- 						  GdkBitmap    *mask_opened,
			-- 						  gboolean      is_leaf,
			-- 						  gboolean      expanded);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_is_ancestor (a_ctree: POINTER; a_node: POINTER; a_child: POINTER): BOOLEAN is
			-- gboolean gtk_ctree_is_ancestor                   (GtkCTree     *ctree,
			-- 					          GtkCTreeNode *node,
			-- 					          GtkCTreeNode *child);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_is_hot_spot (a_ctree: POINTER; a_x: INTEGER; a_y: INTEGER): BOOLEAN is
			-- gboolean gtk_ctree_is_hot_spot                   (GtkCTree     *ctree,
			-- 					          gint          x,
			-- 					          gint          y);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_is_viewable (a_ctree: POINTER; a_node: POINTER): BOOLEAN is
			-- gboolean gtk_ctree_is_viewable                   (GtkCTree     *ctree,
			-- 					          GtkCTreeNode *node);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_last (a_ctree: POINTER; a_node: POINTER): POINTER is
			-- GtkCTreeNode * gtk_ctree_last                    (GtkCTree     *ctree,
			-- 					          GtkCTreeNode *node);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_move (a_ctree: POINTER; a_node: POINTER; a_new_parent: POINTER; a_new_sibling: POINTER) is
			-- void gtk_ctree_move                              (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  GtkCTreeNode *new_parent,
			-- 						  GtkCTreeNode *new_sibling);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_new (a_columns: INTEGER; a_tree_column: INTEGER): POINTER is
			-- GtkWidget * gtk_ctree_new                        (gint          columns,
			-- 						  gint          tree_column);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_new_with_titles (a_columns: INTEGER; a_tree_column: INTEGER; a_titles: POINTER): POINTER is
			-- GtkWidget * gtk_ctree_new_with_titles            (gint          columns,
			-- 						  gint          tree_column,
			-- 						  gchar        *titles[]);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_get_cell_style (a_ctree: POINTER; a_node: POINTER; a_column: INTEGER): POINTER is
			-- GtkStyle * gtk_ctree_node_get_cell_style         (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gint          column);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_get_cell_type (a_ctree: POINTER; a_node: POINTER; a_column: INTEGER): INTEGER is
			-- GtkCellType gtk_ctree_node_get_cell_type         (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gint          column);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_get_pixmap (a_ctree: POINTER; a_node: POINTER; a_column: INTEGER; a_pixmap: POINTER; a_mask: POINTER): INTEGER is
			-- gint gtk_ctree_node_get_pixmap                   (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gint          column,
			-- 						  GdkPixmap   **pixmap,
			-- 						  GdkBitmap   **mask);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_get_pixtext (a_ctree: POINTER; a_node: POINTER; a_column: INTEGER; a_text: POINTER; a_spacing: POINTER; a_pixmap: POINTER; a_mask: POINTER): INTEGER is
			-- gint gtk_ctree_node_get_pixtext                  (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gint          column,
			-- 						  gchar       **text,
			-- 						  guint8       *spacing,
			-- 						  GdkPixmap   **pixmap,
			-- 						  GdkBitmap   **mask);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_get_row_data (a_ctree: POINTER; a_node: POINTER): POINTER is
			-- gpointer gtk_ctree_node_get_row_data             (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_get_row_style (a_ctree: POINTER; a_node: POINTER): POINTER is
			-- GtkStyle * gtk_ctree_node_get_row_style          (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_get_selectable (a_ctree: POINTER; a_node: POINTER): BOOLEAN is
			-- gboolean gtk_ctree_node_get_selectable           (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_get_text (a_ctree: POINTER; a_node: POINTER; a_column: INTEGER; a_text: POINTER): INTEGER is
			-- gint gtk_ctree_node_get_text                     (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gint          column,
			-- 						  gchar       **text);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_is_visible (a_ctree: POINTER; a_node: POINTER): INTEGER is
			-- GtkVisibility gtk_ctree_node_is_visible          (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_moveto (a_ctree: POINTER; a_node: POINTER; a_column: INTEGER; a_row_align: REAL; a_col_align: REAL) is
			-- void gtk_ctree_node_moveto                       (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gint          column,
			-- 						  gfloat        row_align,
			-- 						  gfloat        col_align);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_nth (a_ctree: POINTER; a_row: INTEGER): POINTER is
			-- GtkCTreeNode * gtk_ctree_node_nth                (GtkCTree     *ctree,
			-- 						  guint         row);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_set_background (a_ctree: POINTER; a_node: POINTER; a_color: POINTER) is
			-- void gtk_ctree_node_set_background               (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  GdkColor     *color);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_set_cell_style (a_ctree: POINTER; a_node: POINTER; a_column: INTEGER; a_style: POINTER) is
			-- void gtk_ctree_node_set_cell_style               (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gint          column,
			-- 						  GtkStyle     *style);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_set_foreground (a_ctree: POINTER; a_node: POINTER; a_color: POINTER) is
			-- void gtk_ctree_node_set_foreground               (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  GdkColor     *color);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_set_pixmap (a_ctree: POINTER; a_node: POINTER; a_column: INTEGER; a_pixmap: POINTER; a_mask: POINTER) is
			-- void gtk_ctree_node_set_pixmap                   (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gint          column,
			-- 						  GdkPixmap    *pixmap,
			-- 						  GdkBitmap    *mask);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_set_pixtext (a_ctree: POINTER; a_node: POINTER; a_column: INTEGER; a_text: POINTER; a_spacing: INTEGER; a_pixmap: POINTER; a_mask: POINTER) is
			-- void gtk_ctree_node_set_pixtext                  (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gint          column,
			-- 						  const gchar  *text,
			-- 						  guint8        spacing,
			-- 						  GdkPixmap    *pixmap,
			-- 						  GdkBitmap    *mask);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_set_row_data (a_ctree: POINTER; a_node: POINTER; a_data: POINTER) is
			-- void gtk_ctree_node_set_row_data                 (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gpointer      data);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_set_row_data_full (a_ctree: POINTER; a_node: POINTER; a_data: POINTER; a_destroy: POINTER) is
			-- void gtk_ctree_node_set_row_data_full            (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gpointer      data,
			-- 						  GtkDestroyNotify destroy);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_set_row_style (a_ctree: POINTER; a_node: POINTER; a_style: POINTER) is
			-- void gtk_ctree_node_set_row_style                (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  GtkStyle     *style);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_set_selectable (a_ctree: POINTER; a_node: POINTER; a_selectable: BOOLEAN) is
			-- void gtk_ctree_node_set_selectable               (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gboolean      selectable);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_set_shift (a_ctree: POINTER; a_node: POINTER; a_column: INTEGER; a_vertical: INTEGER; a_horizontal: INTEGER) is
			-- void gtk_ctree_node_set_shift                    (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gint          column,
			-- 						  gint          vertical,
			-- 						  gint          horizontal);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_node_set_text (a_ctree: POINTER; a_node: POINTER; a_column: INTEGER; a_text: POINTER) is
			-- void gtk_ctree_node_set_text                     (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gint          column,
			-- 						  const gchar  *text);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_post_recursive (a_ctree: POINTER; a_node: POINTER; a_func: POINTER; a_data: POINTER) is
			-- void gtk_ctree_post_recursive                    (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  GtkCTreeFunc  func,
			-- 						  gpointer      data);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_post_recursive_to_depth (a_ctree: POINTER; a_node: POINTER; a_depth: INTEGER; a_func: POINTER; a_data: POINTER) is
			-- void gtk_ctree_post_recursive_to_depth           (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gint          depth,
			-- 						  GtkCTreeFunc  func,
			-- 						  gpointer      data);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_pre_recursive (a_ctree: POINTER; a_node: POINTER; a_func: POINTER; a_data: POINTER) is
			-- void gtk_ctree_pre_recursive                     (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  GtkCTreeFunc  func,
			-- 						  gpointer      data);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_pre_recursive_to_depth (a_ctree: POINTER; a_node: POINTER; a_depth: INTEGER; a_func: POINTER; a_data: POINTER) is
			-- void gtk_ctree_pre_recursive_to_depth            (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gint          depth,
			-- 						  GtkCTreeFunc  func,
			-- 						  gpointer      data);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_real_select_recursive (a_ctree: POINTER; a_node: POINTER; a_state: INTEGER) is
			-- void gtk_ctree_real_select_recursive             (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  gint          state);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_remove_node (a_ctree: POINTER; a_node: POINTER) is
			-- void gtk_ctree_remove_node                       (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_select (a_ctree: POINTER; a_node: POINTER) is
			-- void gtk_ctree_select                            (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_select_recursive (a_ctree: POINTER; a_node: POINTER) is
			-- void gtk_ctree_select_recursive                  (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_set_drag_compare_func (a_ctree: POINTER; a_cmp_func: POINTER) is
			-- void gtk_ctree_set_drag_compare_func (GtkCTree     	      *ctree,
			-- 				      GtkCTreeCompareDragFunc  cmp_func);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_set_expander_style (a_ctree: POINTER; a_expander_style: INTEGER) is
			-- void gtk_ctree_set_expander_style    (GtkCTree                *ctree,
			-- 				      GtkCTreeExpanderStyle    expander_style);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_set_indent (a_ctree: POINTER; a_indent: INTEGER) is
			-- void gtk_ctree_set_indent            (GtkCTree                *ctree,
			-- 				      gint                     indent);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_set_line_style (a_ctree: POINTER; a_line_style: INTEGER) is
			-- void gtk_ctree_set_line_style        (GtkCTree                *ctree,
			-- 				      GtkCTreeLineStyle        line_style);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_set_node_info (a_ctree: POINTER; a_node: POINTER; a_text: POINTER; a_spacing: INTEGER; a_pixmap_closed: POINTER; a_mask_closed: POINTER; a_pixmap_opened: POINTER; a_mask_opened: POINTER; a_is_leaf: INTEGER; a_expanded: INTEGER) is
			-- void gtk_ctree_set_node_info                     (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node,
			-- 						  const gchar  *text,
			-- 						  guint8        spacing,
			-- 						  GdkPixmap    *pixmap_closed,
			-- 						  GdkBitmap    *mask_closed,
			-- 						  GdkPixmap    *pixmap_opened,
			-- 						  GdkBitmap    *mask_opened,
			-- 						  gboolean      is_leaf,
			-- 						  gboolean      expanded);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_set_show_stub (a_ctree: POINTER; a_show_stub: BOOLEAN) is
			-- void gtk_ctree_set_show_stub         (GtkCTree                *ctree,
			-- 				      gboolean                 show_stub);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_set_spacing (a_ctree: POINTER; a_spacing: INTEGER) is
			-- void gtk_ctree_set_spacing           (GtkCTree                *ctree,
			-- 				      gint                     spacing);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_sort_node (a_ctree: POINTER; a_node: POINTER) is
			-- void gtk_ctree_sort_node                         (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_sort_recursive (a_ctree: POINTER; a_node: POINTER) is
			-- void gtk_ctree_sort_recursive                    (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_toggle_expansion (a_ctree: POINTER; a_node: POINTER) is
			-- void gtk_ctree_toggle_expansion                  (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_toggle_expansion_recursive (a_ctree: POINTER; a_node: POINTER) is
			-- void gtk_ctree_toggle_expansion_recursive        (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_unselect (a_ctree: POINTER; a_node: POINTER) is
			-- void gtk_ctree_unselect                          (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_ctree_unselect_recursive (a_ctree: POINTER; a_node: POINTER) is
			-- void gtk_ctree_unselect_recursive                (GtkCTree     *ctree,
			-- 						  GtkCTreeNode *node);
			-- (from C_GTK_CTREE)
		do
		end

	frozen gtk_drag_begin (a_widget: POINTER; a_targets: POINTER; a_actions: INTEGER; a_button: INTEGER; a_event: POINTER): POINTER is
			-- GdkDragContext *gtk_drag_begin (GtkWidget         *widget,
			-- 				GtkTargetList     *targets,
			-- 				GdkDragAction      actions,
			-- 				gint               button,
			-- 				GdkEvent          *event);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_drag_dest_set (a_widget: POINTER; a_flags: INTEGER; a_targets: POINTER; a_n_targets: INTEGER; a_actions: INTEGER) is
			-- void gtk_drag_dest_set   (GtkWidget            *widget,
			-- 			  GtkDestDefaults       flags,
			--   		          const GtkTargetEntry *targets,
			-- 			  gint                  n_targets,
			-- 			  GdkDragAction         actions);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_drag_dest_set_proxy (a_widget: POINTER; a_proxy_window: POINTER; a_protocol: INTEGER; a_use_coordinates: BOOLEAN) is
			-- void gtk_drag_dest_set_proxy (GtkWidget      *widget,
			-- 			      Gdkwindow      *proxy_window,
			-- 			      GdkDragProtocol protocol,
			-- 			      gboolean        use_coordinates);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_drag_dest_unset (a_widget: POINTER) is
			-- void gtk_drag_dest_unset (GtkWidget          *widget);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_drag_finish (a_context: POINTER; a_success: BOOLEAN; a_del: BOOLEAN; a_time: INTEGER) is
			-- void gtk_drag_finish   (GdkDragContext *context,
			-- 			gboolean        success,
			-- 			gboolean        del,
			-- 			guint32         time);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_drag_get_data (a_widget: POINTER; a_context: POINTER; a_target: POINTER; a_time: NATURAL_32) is
			-- void gtk_drag_get_data (GtkWidget      *widget,
			-- 			GdkDragContext *context,
			-- 			GdkAtom         target,
			-- 			guint32         time);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_drag_get_source_widget (a_context: POINTER): POINTER is
			-- GtkWidget *gtk_drag_get_source_widget (GdkDragContext *context);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_drag_highlight (a_widget: POINTER) is
			-- void gtk_drag_highlight   (GtkWidget  *widget);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_drag_set_default_icon (a_colormap: POINTER; a_pixmap: POINTER; a_mask: POINTER; a_hot_x: INTEGER; a_hot_y: INTEGER) is
			-- void gtk_drag_set_default_icon (GdkColormap   *colormap,
			-- 				GdkPixmap     *pixmap,
			-- 				GdkBitmap     *mask,
			-- 			        gint           hot_x,
			-- 			        gint           hot_y);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_drag_set_icon_default (a_context: POINTER) is
			-- void gtk_drag_set_icon_default (GdkDragContext    *context);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_drag_set_icon_pixmap (a_context: POINTER; a_colormap: POINTER; a_pixmap: POINTER; a_mask: POINTER; a_hot_x: INTEGER; a_hot_y: INTEGER) is
			-- void gtk_drag_set_icon_pixmap  (GdkDragContext    *context,
			-- 				GdkColormap       *colormap,
			-- 				GdkPixmap         *pixmap,
			-- 				GdkBitmap         *mask,
			-- 				gint               hot_x,
			-- 				gint               hot_y);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_drag_set_icon_widget (a_context: POINTER; a_widget: POINTER; a_hot_x: INTEGER; a_hot_y: INTEGER) is
			-- void gtk_drag_set_icon_widget  (GdkDragContext    *context,
			-- 				GtkWidget         *widget,
			-- 				gint               hot_x,
			-- 				gint               hot_y);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_drag_source_set (a_widget: POINTER; a_start_button_mask: INTEGER; a_targets: POINTER; a_n_targets: INTEGER; a_actions: INTEGER) is
			-- void gtk_drag_source_set  (GtkWidget            *widget,
			-- 			   GdkModifierType       start_button_mask,
			-- 			   const GtkTargetEntry *targets,
			-- 			   gint                  n_targets,
			-- 			   GdkDragAction         actions);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_drag_source_set_icon (a_widget: POINTER; a_colormap: POINTER; a_pixmap: POINTER; a_mask: POINTER) is
			-- void gtk_drag_source_set_icon (GtkWidget     *widget,
			-- 			       GdkColormap   *colormap,
			-- 			       GdkPixmap     *pixmap,
			-- 			       GdkBitmap     *mask);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_drag_source_unset (a_widget: POINTER) is
			-- void gtk_drag_source_unset (GtkWidget        *widget);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_drag_unhighlight (a_widget: POINTER) is
			-- void gtk_drag_unhighlight (GtkWidget  *widget);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_draw_arrow (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_arrow_type: INTEGER; a_fill: BOOLEAN; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void gtk_draw_arrow   (GtkStyle	     *style,
			-- 		       Gdkwindow     *window,
			-- 		       GtkStateType   state_type,
			-- 		       GtkshadowType  shadow_type,
			-- 		       GtkArrowType   arrow_type,
			-- 		       gboolean	      fill,
			-- 		       gint	      x,
			-- 		       gint	      y,
			-- 		       gint	      width,
			-- 		       gint	      height);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_draw_box (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void gtk_draw_box     (GtkStyle	     *style,
			-- 		       Gdkwindow     *window,
			-- 		       GtkStateType   state_type,
			-- 		       GtkshadowType  shadow_type,
			-- 		       gint	      x,
			-- 		       gint	      y,
			-- 		       gint	      width,
			-- 		       gint	      height);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_draw_box_gap (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER; a_gap_side: INTEGER; a_gap_x: INTEGER; a_gap_width: INTEGER) is
			-- void gtk_draw_box_gap (GtkStyle	      *style,
			-- 		       Gdkwindow      *window,
			-- 		       GtkStateType    state_type,
			-- 		       GtkshadowType   shadow_type,
			-- 		       gint	       x,
			-- 		       gint	       y,
			-- 		       gint	       width,
			-- 		       gint	       height,
			-- 		       GtkPositionType gap_side,
			-- 		       gint	       gap_x,
			-- 		       gint	       gap_width);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_draw_check (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void gtk_draw_check   (GtkStyle	     *style,
			-- 		       Gdkwindow     *window,
			-- 		       GtkStateType   state_type,
			-- 		       GtkshadowType  shadow_type,
			-- 		       gint	      x,
			-- 		       gint	      y,
			-- 		       gint	      width,
			-- 		       gint	      height);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_draw_diamond (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void gtk_draw_diamond (GtkStyle	     *style,
			-- 		       Gdkwindow     *window,
			-- 		       GtkStateType   state_type,
			-- 		       GtkshadowType  shadow_type,
			-- 		       gint	      x,
			-- 		       gint	      y,
			-- 		       gint	      width,
			-- 		       gint	      height);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_draw_extension (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER; a_gap_side: INTEGER) is
			-- void gtk_draw_extension (GtkStyle	*style,
			-- 			 Gdkwindow	*window,
			-- 			 GtkStateType	 state_type,
			-- 			 GtkshadowType	 shadow_type,
			-- 			 gint		 x,
			-- 			 gint		 y,
			-- 			 gint		 width,
			-- 			 gint		 height,
			-- 			 GtkPositionType gap_side);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_draw_flat_box (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void gtk_draw_flat_box (GtkStyle      *style,
			-- 			Gdkwindow     *window,
			-- 			GtkStateType   state_type,
			-- 			GtkshadowType  shadow_type,
			-- 			gint	       x,
			-- 			gint	       y,
			-- 			gint	       width,
			-- 			gint	       height);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_draw_focus (a_style: POINTER; a_window: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void gtk_draw_focus   (GtkStyle	     *style,
			-- 		       Gdkwindow     *window,
			-- 		       gint	      x,
			-- 		       gint	      y,
			-- 		       gint	      width,
			-- 		       gint	      height);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_draw_handle (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER; a_orientation: INTEGER) is
			-- void gtk_draw_handle  (GtkStyle	     *style,
			-- 		       Gdkwindow     *window,
			-- 		       GtkStateType   state_type,
			-- 		       GtkshadowType  shadow_type,
			-- 		       gint	      x,
			-- 		       gint	      y,
			-- 		       gint	      width,
			-- 		       gint	      height,
			-- 		       GtkOrientation orientation);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_draw_hline (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_x1: INTEGER; a_x2: INTEGER; a_y: INTEGER) is
			-- void gtk_draw_hline   (GtkStyle	     *style,
			-- 		       Gdkwindow     *window,
			-- 		       GtkStateType   state_type,
			-- 		       gint	      x1,
			-- 		       gint	      x2,
			-- 		       gint	      y);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_draw_option (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void gtk_draw_option  (GtkStyle	     *style,
			-- 		       Gdkwindow     *window,
			-- 		       GtkStateType   state_type,
			-- 		       GtkshadowType  shadow_type,
			-- 		       gint	      x,
			-- 		       gint	      y,
			-- 		       gint	      width,
			-- 		       gint	      height);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_draw_polygon (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_points: POINTER; a_npoints: INTEGER; a_fill: BOOLEAN) is
			-- void gtk_draw_polygon (GtkStyle	     *style,
			-- 		       Gdkwindow     *window,
			-- 		       GtkStateType   state_type,
			-- 		       GtkshadowType  shadow_type,
			-- 		       GdkPoint	     *points,
			-- 		       gint	      npoints,
			-- 		       gboolean	      fill);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_draw_shadow (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void gtk_draw_shadow  (GtkStyle	     *style,
			-- 		       Gdkwindow     *window,
			-- 		       GtkStateType   state_type,
			-- 		       GtkshadowType  shadow_type,
			-- 		       gint	      x,
			-- 		       gint	      y,
			-- 		       gint	      width,
			-- 		       gint	      height);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_draw_shadow_gap (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER; a_gap_side: INTEGER; a_gap_x: INTEGER; a_gap_width: INTEGER) is
			-- void gtk_draw_shadow_gap (GtkStyle	 *style,
			-- 			  Gdkwindow	 *window,
			-- 			  GtkStateType	  state_type,
			-- 			  GtkshadowType	  shadow_type,
			-- 			  gint		  x,
			-- 			  gint		  y,
			-- 			  gint		  width,
			-- 			  gint		  height,
			-- 			  GtkPositionType gap_side,
			-- 			  gint		  gap_x,
			-- 			  gint		  gap_width);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_draw_slider (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER; a_orientation: INTEGER) is
			-- void gtk_draw_slider  (GtkStyle	     *style,
			-- 		       Gdkwindow     *window,
			-- 		       GtkStateType   state_type,
			-- 		       GtkshadowType  shadow_type,
			-- 		       gint	      x,
			-- 		       gint	      y,
			-- 		       gint	      width,
			-- 		       gint	      height,
			-- 		       GtkOrientation orientation);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_draw_string (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_x: INTEGER; a_y: INTEGER; a_string: POINTER) is
			-- void gtk_draw_string  (GtkStyle	     *style,
			-- 		       Gdkwindow     *window,
			-- 		       GtkStateType   state_type,
			-- 		       gint	      x,
			-- 		       gint	      y,
			-- 		       const gchar   *string);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_draw_tab (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void gtk_draw_tab     (GtkStyle	     *style,
			-- 		       Gdkwindow     *window,
			-- 		       GtkStateType   state_type,
			-- 		       GtkshadowType  shadow_type,
			-- 		       gint	      x,
			-- 		       gint	      y,
			-- 		       gint	      width,
			-- 		       gint	      height);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_draw_vline (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_y1: INTEGER; a_y2: INTEGER; a_x: INTEGER) is
			-- void gtk_draw_vline   (GtkStyle	     *style,
			-- 		       Gdkwindow     *window,
			-- 		       GtkStateType   state_type,
			-- 		       gint	      y1,
			-- 		       gint	      y2,
			-- 		       gint	      x);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_drawing_area_get_type: INTEGER is
			-- GtkType    gtk_drawing_area_get_type   (void);
			-- (from C_GTK_DRAWING_AREA)
		do
		end

	frozen gtk_drawing_area_new: POINTER is
			-- GtkWidget* gtk_drawing_area_new        (void);
			-- (from C_GTK_DRAWING_AREA)
		do
		end

	frozen gtk_drawing_area_size (a_darea: POINTER; a_width: INTEGER; a_height: INTEGER) is
			-- void       gtk_drawing_area_size       (GtkDrawingArea      *darea,
			-- 					gint                 width,
			-- 					gint                 height);
			-- (from C_GTK_DRAWING_AREA)
		do
		end

	frozen gtk_editable_copy_clipboard (a_editable: POINTER) is
			-- void       gtk_editable_copy_clipboard (GtkEditable      *editable);
			-- (from C_GTK_EDITABLE)
		do
		end

	frozen gtk_editable_cut_clipboard (a_editable: POINTER) is
			-- void       gtk_editable_cut_clipboard  (GtkEditable      *editable);
			-- (from C_GTK_EDITABLE)
		do
		end

	frozen gtk_editable_delete_selection (a_editable: POINTER) is
			-- void       gtk_editable_delete_selection (GtkEditable    *editable);
			-- (from C_GTK_EDITABLE)
		do
		end

	frozen gtk_editable_delete_text (a_editable: POINTER; a_start_pos: INTEGER; a_end_pos: INTEGER) is
			-- void       gtk_editable_delete_text    (GtkEditable      *editable,
			-- 					gint              start_pos,
			-- 					gint              end_pos);
			-- (from C_GTK_EDITABLE)
		do
		end

	frozen gtk_editable_get_chars (a_editable: POINTER; a_start_pos: INTEGER; a_end_pos: INTEGER): POINTER is
			-- gchar*     gtk_editable_get_chars      (GtkEditable      *editable,
			-- 					gint              start_pos,
			-- 					gint              end_pos);
			-- (from C_GTK_EDITABLE)
		do
		end

	frozen gtk_editable_get_position (a_editable: POINTER): INTEGER is
			-- gint       gtk_editable_get_position    (GtkEditable    *editable);
			-- (from C_GTK_EDITABLE)
		do
		end

	frozen gtk_editable_get_type: INTEGER is
			-- GtkType    gtk_editable_get_type       (void);
			-- (from C_GTK_EDITABLE)
		do
		end

	frozen gtk_editable_insert_text (a_editable: POINTER; a_new_text: POINTER; a_new_text_length: INTEGER; a_position: POINTER) is
			-- void       gtk_editable_insert_text   (GtkEditable       *editable,
			-- 					const gchar      *new_text,
			-- 					gint              new_text_length,
			-- 					gint             *position);
			-- (from C_GTK_EDITABLE)
		do
		end

	frozen gtk_editable_paste_clipboard (a_editable: POINTER) is
			-- void       gtk_editable_paste_clipboard (GtkEditable     *editable);
			-- (from C_GTK_EDITABLE)
		do
		end

	frozen gtk_editable_select_region (a_editable: POINTER; a_start: INTEGER; a_end: INTEGER) is
			-- void       gtk_editable_select_region  (GtkEditable      *editable,
			-- 					gint              start,
			-- 					gint              end);
			-- (from C_GTK_EDITABLE)
		do
		end

	frozen gtk_editable_set_editable (a_editable: POINTER; a_is_editable: BOOLEAN) is
			-- void       gtk_editable_set_editable    (GtkEditable    *editable,
			-- 					 gboolean        is_editable);
			-- (from C_GTK_EDITABLE)
		do
		end

	frozen gtk_editable_set_position (a_editable: POINTER; a_position: INTEGER) is
			-- void       gtk_editable_set_position    (GtkEditable    *editable,
			-- 					 gint            position);
			-- (from C_GTK_EDITABLE)
		do
		end

	frozen gtk_entry_append_text (a_entry: POINTER; a_text: POINTER) is
			-- void       gtk_entry_append_text    		(GtkEntry      *entry,
			-- 						 const gchar   *text);
			-- (from C_GTK_ENTRY)
		do
		end

	frozen gtk_entry_get_text (a_entry: POINTER): POINTER is
			-- gchar*     gtk_entry_get_text       		(GtkEntry      *entry);
			-- (from C_GTK_ENTRY)
		do
		end

	frozen gtk_entry_get_type: INTEGER is
			-- GtkType    gtk_entry_get_type       		(void);
			-- (from C_GTK_ENTRY)
		do
		end

	frozen gtk_entry_new: POINTER is
			-- GtkWidget* gtk_entry_new            		(void);
			-- (from C_GTK_ENTRY)
		do
		end

	frozen gtk_entry_prepend_text (a_entry: POINTER; a_text: POINTER) is
			-- void       gtk_entry_prepend_text   		(GtkEntry      *entry,
			-- 						 const gchar   *text);
			-- (from C_GTK_ENTRY)
		do
		end

	frozen gtk_entry_select_region (a_entry: POINTER; a_start: INTEGER; a_end: INTEGER) is
			-- void       gtk_entry_select_region  		(GtkEntry      *entry,
			-- 						 gint           start,
			-- 						 gint           end);
			-- (from C_GTK_ENTRY)
		do
		end

	frozen gtk_entry_set_editable (a_entry: POINTER; a_editable: BOOLEAN) is
			-- void       gtk_entry_set_editable   		(GtkEntry      *entry,
			-- 						 gboolean       editable);
			-- (from C_GTK_ENTRY)
		do
		end

	frozen gtk_entry_set_position (a_entry: POINTER; a_position: INTEGER) is
			-- void       gtk_entry_set_position   		(GtkEntry      *entry,
			-- 						 gint           position);
			-- (from C_GTK_ENTRY)
		do
		end

	frozen gtk_entry_set_text (a_entry: POINTER; a_text: POINTER) is
			-- void       gtk_entry_set_text       		(GtkEntry      *entry,
			-- 						 const gchar   *text);
			-- (from C_GTK_ENTRY)
		do
		end

	frozen gtk_entry_set_visibility (a_entry: POINTER; a_visible: BOOLEAN) is
			-- void       gtk_entry_set_visibility 		(GtkEntry      *entry,
			-- 						 gboolean       visible);
			-- (from C_GTK_ENTRY)
		do
		end

	frozen gtk_event_box_get_type: INTEGER is
			-- GtkType	       gtk_event_box_get_type	     (void);
			-- (from C_GTK_EVENT_BOX)
		do
		end

	frozen gtk_event_box_new: POINTER is
			-- GtkWidget*     gtk_event_box_new	     (void);
			-- (from C_GTK_EVENT_BOX)
		do
		end

	frozen gtk_events_pending: INTEGER is
			-- gint	   gtk_events_pending	 (void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_exit (a_error_code: INTEGER) is
			-- void	   gtk_exit		 (gint		error_code);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_false: INTEGER is
			-- gint	   gtk_false		   (void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_file_selection_complete (a_filesel: POINTER; a_pattern: POINTER) is
			-- void	   gtk_file_selection_complete		  (GtkFileSelection *filesel,
			-- 						   const gchar	    *pattern);
			-- (from C_GTK_FILE_SELECTION)
		do
		end

	frozen gtk_file_selection_get_filename (a_filesel: POINTER): POINTER is
			-- gchar*     gtk_file_selection_get_filename        (GtkFileSelection *filesel);
			-- (from C_GTK_FILE_SELECTION)
		do
		end

	frozen gtk_file_selection_get_type: INTEGER is
			-- GtkType    gtk_file_selection_get_type            (void);
			-- (from C_GTK_FILE_SELECTION)
		do
		end

	frozen gtk_file_selection_hide_fileop_buttons (a_filesel: POINTER) is
			-- void       gtk_file_selection_hide_fileop_buttons (GtkFileSelection *filesel);
			-- (from C_GTK_FILE_SELECTION)
		do
		end

	frozen gtk_file_selection_new (a_title: POINTER): POINTER is
			-- GtkWidget* gtk_file_selection_new                 (const gchar      *title);
			-- (from C_GTK_FILE_SELECTION)
		do
		end

	frozen gtk_file_selection_set_filename (a_filesel: POINTER; a_filename: POINTER) is
			-- void       gtk_file_selection_set_filename        (GtkFileSelection *filesel,
			-- 						   const gchar      *filename);
			-- (from C_GTK_FILE_SELECTION)
		do
		end

	frozen gtk_file_selection_show_fileop_buttons (a_filesel: POINTER) is
			-- void       gtk_file_selection_show_fileop_buttons (GtkFileSelection *filesel);
			-- (from C_GTK_FILE_SELECTION)
		do
		end

	frozen gtk_font_selection_dialog_get_font (a_fsd: POINTER): POINTER is
			-- GdkFont* gtk_font_selection_dialog_get_font	    (GtkFontSelectionDialog *fsd);
			-- (from C_GTK_FONT_SELECTION_DIALOG)
		do
		end

	frozen gtk_font_selection_dialog_get_font_name (a_fsd: POINTER): POINTER is
			-- gchar*	 gtk_font_selection_dialog_get_font_name    (GtkFontSelectionDialog *fsd);
			-- (from C_GTK_FONT_SELECTION_DIALOG)
		do
		end

	frozen gtk_font_selection_dialog_get_preview_text (a_fsd: POINTER): POINTER is
			-- gchar*	 gtk_font_selection_dialog_get_preview_text (GtkFontSelectionDialog *fsd);
			-- (from C_GTK_FONT_SELECTION_DIALOG)
		do
		end

	frozen gtk_font_selection_dialog_get_type: INTEGER is
			-- GtkType	   gtk_font_selection_dialog_get_type	(void);
			-- (from C_GTK_FONT_SELECTION_DIALOG)
		do
		end

	frozen gtk_font_selection_dialog_new (a_title: POINTER): POINTER is
			-- GtkWidget* gtk_font_selection_dialog_new	(const gchar	  *title);
			-- (from C_GTK_FONT_SELECTION_DIALOG)
		do
		end

	frozen gtk_font_selection_dialog_set_font_name (a_fsd: POINTER; a_fontname: POINTER): BOOLEAN is
			-- gboolean gtk_font_selection_dialog_set_font_name    (GtkFontSelectionDialog *fsd,
			-- 						     const gchar	*fontname);
			-- (from C_GTK_FONT_SELECTION_DIALOG)
		do
		end

	frozen gtk_font_selection_dialog_set_preview_text (a_fsd: POINTER; a_text: POINTER) is
			-- void	 gtk_font_selection_dialog_set_preview_text (GtkFontSelectionDialog *fsd,
			-- 						     const gchar	    *text);
			-- (from C_GTK_FONT_SELECTION_DIALOG)
		do
		end

	frozen gtk_font_selection_get_font (a_fontsel: POINTER): POINTER is
			-- GdkFont*   gtk_font_selection_get_font		(GtkFontSelection *fontsel);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_font_selection_get_font_name (a_fontsel: POINTER): POINTER is
			-- gchar*	   gtk_font_selection_get_font_name	(GtkFontSelection *fontsel);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_font_selection_get_preview_text (a_fontsel: POINTER): POINTER is
			-- gchar*	   gtk_font_selection_get_preview_text	(GtkFontSelection *fontsel);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_font_selection_get_type: INTEGER is
			-- GtkType	   gtk_font_selection_get_type		(void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_font_selection_new: POINTER is
			-- GtkWidget* gtk_font_selection_new		(void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_font_selection_set_font_name (a_fontsel: POINTER; a_fontname: POINTER): BOOLEAN is
			-- gboolean   gtk_font_selection_set_font_name	(GtkFontSelection *fontsel,
			-- 						 const gchar	  *fontname);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_font_selection_set_preview_text (a_fontsel: POINTER; a_text: POINTER) is
			-- void	   gtk_font_selection_set_preview_text	(GtkFontSelection *fontsel,
			-- 						 const gchar	  *text);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_frame_get_type: INTEGER is
			-- GtkType    gtk_frame_get_type        (void);
			-- (from C_GTK_FRAME)
		do
		end

	frozen gtk_frame_new (a_label: POINTER): POINTER is
			-- GtkWidget* gtk_frame_new             (const gchar   *label);
			-- (from C_GTK_FRAME)
		do
		end

	frozen gtk_frame_set_label (a_frame: POINTER; a_label: POINTER) is
			-- void       gtk_frame_set_label       (GtkFrame      *frame,
			-- 				      const gchar   *label);
			-- (from C_GTK_FRAME)
		do
		end

	frozen gtk_frame_set_label_align (a_frame: POINTER; a_xalign: REAL; a_yalign: REAL) is
			-- void       gtk_frame_set_label_align (GtkFrame      *frame,
			-- 				      gfloat         xalign,
			-- 				      gfloat         yalign);
			-- (from C_GTK_FRAME)
		do
		end

	frozen gtk_frame_set_shadow_type (a_frame: POINTER; a_type: INTEGER) is
			-- void       gtk_frame_set_shadow_type (GtkFrame      *frame,
			-- 				      GtkshadowType  type);
			-- (from C_GTK_FRAME)
		do
		end

	frozen gtk_gc_get (a_depth: INTEGER; a_colormap: POINTER; a_values: POINTER; a_values_mask: INTEGER): POINTER is
			-- GdkGC* gtk_gc_get     (gint             depth,
			-- 		       GdkColormap     *colormap,
			-- 		       GdkGCValues     *values,
			-- 		       GdkGCValuesMask  values_mask);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_gc_release (a_gc: POINTER) is
			-- void   gtk_gc_release (GdkGC           *gc);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_get_current_event: POINTER is
			-- GdkEvent*  gtk_get_current_event   (void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_get_event_widget (a_event: POINTER): POINTER is
			-- GtkWidget* gtk_get_event_widget	   (GdkEvent	   *event);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_grab_add (a_widget: POINTER) is
			-- void	   gtk_grab_add		   (GtkWidget	       *widget);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_grab_get_current: POINTER is
			-- GtkWidget* gtk_grab_get_current	   (void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_grab_remove (a_widget: POINTER) is
			-- void	   gtk_grab_remove	   (GtkWidget	       *widget);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_hbox_get_type: INTEGER is
			-- GtkType	   gtk_hbox_get_type (void);
			-- (from C_GTK_HBOX)
		do
		end

	frozen gtk_hbox_new (a_homogeneous: BOOLEAN; a_spacing: INTEGER): POINTER is
			-- GtkWidget* gtk_hbox_new	     (gboolean homogeneous,
			-- 			      gint spacing);
			-- (from C_GTK_HBOX)
		do
		end

	frozen gtk_hpaned_get_type: INTEGER is
			-- guint      gtk_hpaned_get_type (void);
			-- (from C_GTK_HPANED)
		do
		end

	frozen gtk_hpaned_new: POINTER is
			-- GtkWidget* gtk_hpaned_new      (void);
			-- (from C_GTK_HPANED)
		do
		end

	frozen gtk_hscale_get_type: INTEGER is
			-- GtkType    gtk_hscale_get_type (void);
			-- (from C_GTK_HSCALE)
		do
		end

	frozen gtk_hscale_new (a_adjustment: POINTER): POINTER is
			-- GtkWidget* gtk_hscale_new      (GtkAdjustment *adjustment);
			-- (from C_GTK_HSCALE)
		do
		end

	frozen gtk_hscrollbar_get_type: INTEGER is
			-- GtkType    gtk_hscrollbar_get_type (void);
			-- (from C_GTK_HSCROLLBAR)
		do
		end

	frozen gtk_hscrollbar_new (a_adjustment: POINTER): POINTER is
			-- GtkWidget* gtk_hscrollbar_new      (GtkAdjustment *adjustment);
			-- (from C_GTK_HSCROLLBAR)
		do
		end

	frozen gtk_hseparator_get_type: INTEGER is
			-- GtkType    gtk_hseparator_get_type (void);
			-- (from C_GTK_HSEPARATOR)
		do
		end

	frozen gtk_hseparator_new: POINTER is
			-- GtkWidget* gtk_hseparator_new      (void);
			-- (from C_GTK_HSEPARATOR)
		do
		end

	frozen gtk_identifier_get_type: INTEGER is
			-- GtkType		gtk_identifier_get_type		(void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_idle_add (a_function: POINTER; a_data: POINTER): INTEGER is
			-- guint	   gtk_idle_add		   (GtkFunction	       function,
			-- 				    gpointer	       data);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_idle_add_full (a_priority: INTEGER; a_function: POINTER; a_marshal: POINTER; a_data: POINTER; a_destroy: POINTER): INTEGER is
			-- guint	   gtk_idle_add_full	   (gint	       priority,
			-- 				    GtkFunction	       function,
			-- 				    GtkCallbackMarshal marshal,
			-- 				    gpointer	       data,
			-- 				    GtkDestroyNotify   destroy);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_idle_add_priority (a_priority: INTEGER; a_function: POINTER; a_data: POINTER): INTEGER is
			-- guint	   gtk_idle_add_priority   (gint	       priority,
			-- 				    GtkFunction	       function,
			-- 				    gpointer	       data);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_idle_remove (a_idle_handler_id: INTEGER) is
			-- void	   gtk_idle_remove	   (guint	       idle_handler_id);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_idle_remove_by_data (a_data: POINTER) is
			-- void	   gtk_idle_remove_by_data (gpointer	       data);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_init (a_argc: POINTER; a_argv: POINTER) is
			-- void	   gtk_init		 (int	       *argc,
			-- 				  char	     ***argv);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_init_add (a_function: POINTER; a_data: POINTER) is
			-- void	   gtk_init_add		   (GtkFunction	       function,
			-- 				    gpointer	       data);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_init_check (a_argc: POINTER; a_argv: POINTER): BOOLEAN is
			-- gboolean   gtk_init_check        (int	       *argc,
			-- 				  char	     ***argv);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_input_add_full (a_source: INTEGER; a_condition: INTEGER; a_function: POINTER; a_marshal: POINTER; a_data: POINTER; a_destroy: POINTER): INTEGER is
			-- guint	   gtk_input_add_full	   (gint	       source,
			-- 				    GdkInputCondition  condition,
			-- 				    GdkInputFunction   function,
			-- 				    GtkCallbackMarshal marshal,
			-- 				    gpointer	       data,
			-- 				    GtkDestroyNotify   destroy);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_input_dialog_get_type: INTEGER is
			-- GtkType    gtk_input_dialog_get_type     (void);
			-- (from C_GTK_INPUT_DIALOG)
		do
		end

	frozen gtk_input_dialog_new: POINTER is
			-- GtkWidget* gtk_input_dialog_new          (void);
			-- (from C_GTK_INPUT_DIALOG)
		do
		end

	frozen gtk_input_remove (a_input_handler_id: INTEGER) is
			-- void	   gtk_input_remove	   (guint	       input_handler_id);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_item_factories_path_delete (a_ifactory_path: POINTER; a_path: POINTER) is
			-- void	gtk_item_factories_path_delete	   (const gchar		*ifactory_path,
			-- 					    const gchar		*path);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_key_snooper_install (a_snooper: POINTER; a_func_data: POINTER): INTEGER is
			-- guint	   gtk_key_snooper_install (GtkKeySnoopFunc snooper,
			-- 				    gpointer	    func_data);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_key_snooper_remove (a_snooper_handler_id: INTEGER) is
			-- void	   gtk_key_snooper_remove  (guint	    snooper_handler_id);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_label_get (a_label: POINTER; a_str: POINTER) is
			-- void       gtk_label_get           (GtkLabel          *label,
			--                                     gchar            **str);
			-- (from C_GTK_LABEL)
		do
		end

	frozen gtk_label_get_type: INTEGER is
			-- GtkType    gtk_label_get_type      (void);
			-- (from C_GTK_LABEL)
		do
		end

	frozen gtk_label_new (a_str: POINTER): POINTER is
			-- GtkWidget* gtk_label_new           (const gchar       *str);
			-- (from C_GTK_LABEL)
		do
		end

	frozen gtk_label_parse_uline (a_label: POINTER; a_string: POINTER): INTEGER is
			-- guint      gtk_label_parse_uline    (GtkLabel         *label,
			-- 				     const gchar      *string);
			-- (from C_GTK_LABEL)
		do
		end

	frozen gtk_label_set_justify (a_label: POINTER; a_jtype: INTEGER) is
			-- void       gtk_label_set_justify   (GtkLabel          *label,
			--                                     GtkJustification   jtype);
			-- (from C_GTK_LABEL)
		do
		end

	frozen gtk_label_set_line_wrap (a_label: POINTER; a_wrap: BOOLEAN) is
			-- void	   gtk_label_set_line_wrap (GtkLabel	      *label,
			-- 				    gboolean           wrap);
			-- (from C_GTK_LABEL)
		do
		end

	frozen gtk_label_set_pattern (a_label: POINTER; a_pattern: POINTER) is
			-- void	   gtk_label_set_pattern   (GtkLabel	      *label,
			-- 				    const gchar	      *pattern);
			-- (from C_GTK_LABEL)
		do
		end

	frozen gtk_label_set_text (a_label: POINTER; a_str: POINTER) is
			-- void       gtk_label_set_text      (GtkLabel          *label,
			--                                     const gchar       *str);
			-- (from C_GTK_LABEL)
		do
		end

	frozen gtk_list_append_items (a_list: POINTER; a_items: POINTER) is
			-- void	   gtk_list_append_items	  (GtkList	    *list,
			-- 					   GList	    *items);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_child_position (a_list: POINTER; a_child: POINTER): INTEGER is
			-- gint	   gtk_list_child_position	  (GtkList	    *list,
			-- 					   GtkWidget	    *child);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_clear_items (a_list: POINTER; a_start: INTEGER; a_end: INTEGER) is
			-- void	   gtk_list_clear_items		  (GtkList	    *list,
			-- 					   gint		     start,
			-- 					   gint		     end);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_end_drag_selection (a_list: POINTER) is
			-- void       gtk_list_end_drag_selection    (GtkList          *list);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_end_selection (a_list: POINTER) is
			-- void       gtk_list_end_selection         (GtkList          *list);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_extend_selection (a_list: POINTER; a_scroll_type: INTEGER; a_position: REAL; a_auto_start_selection: BOOLEAN) is
			-- void       gtk_list_extend_selection      (GtkList          *list,
			-- 					   GtkScrollType     scroll_type,
			-- 					   gfloat            position,
			-- 					   gboolean          auto_start_selection);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_get_type: INTEGER is
			-- GtkType	   gtk_list_get_type		  (void);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_insert_items (a_list: POINTER; a_items: POINTER; a_position: INTEGER) is
			-- void	   gtk_list_insert_items	  (GtkList	    *list,
			-- 					   GList	    *items,
			-- 					   gint		     position);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_item_deselect (a_list_item: POINTER) is
			-- void       gtk_list_item_deselect       (GtkListItem      *list_item);
			-- (from C_GTK_LIST_ITEM)
		do
		end

	frozen gtk_list_item_get_type: INTEGER is
			-- GtkType    gtk_list_item_get_type       (void);
			-- (from C_GTK_LIST_ITEM)
		do
		end

	frozen gtk_list_item_new: POINTER is
			-- GtkWidget* gtk_list_item_new            (void);
			-- (from C_GTK_LIST_ITEM)
		do
		end

	frozen gtk_list_item_new_with_label (a_label: POINTER): POINTER is
			-- GtkWidget* gtk_list_item_new_with_label (const gchar      *label);
			-- (from C_GTK_LIST_ITEM)
		do
		end

	frozen gtk_list_item_select (a_list_item: POINTER) is
			-- void       gtk_list_item_select         (GtkListItem      *list_item);
			-- (from C_GTK_LIST_ITEM)
		do
		end

	frozen gtk_list_new: POINTER is
			-- GtkWidget* gtk_list_new			  (void);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_prepend_items (a_list: POINTER; a_items: POINTER) is
			-- void	   gtk_list_prepend_items	  (GtkList	    *list,
			-- 					   GList	    *items);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_remove_items (a_list: POINTER; a_items: POINTER) is
			-- void	   gtk_list_remove_items	  (GtkList	    *list,
			-- 					   GList	    *items);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_remove_items_no_unref (a_list: POINTER; a_items: POINTER) is
			-- void	   gtk_list_remove_items_no_unref (GtkList	    *list,
			-- 					   GList	    *items);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_scroll_horizontal (a_list: POINTER; a_scroll_type: INTEGER; a_position: REAL) is
			-- void       gtk_list_scroll_horizontal     (GtkList          *list,
			-- 					   GtkScrollType     scroll_type,
			-- 					   gfloat            position);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_scroll_vertical (a_list: POINTER; a_scroll_type: INTEGER; a_position: REAL) is
			-- void       gtk_list_scroll_vertical       (GtkList          *list,
			-- 					   GtkScrollType     scroll_type,
			-- 					   gfloat            position);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_select_all (a_list: POINTER) is
			-- void       gtk_list_select_all            (GtkList          *list);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_select_child (a_list: POINTER; a_child: POINTER) is
			-- void	   gtk_list_select_child	  (GtkList	    *list,
			-- 					   GtkWidget	    *child);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_select_item (a_list: POINTER; a_item: INTEGER) is
			-- void	   gtk_list_select_item		  (GtkList	    *list,
			-- 					   gint		     item);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_set_selection_mode (a_list: POINTER; a_mode: INTEGER) is
			-- void	   gtk_list_set_selection_mode	  (GtkList	    *list,
			-- 					   GtkSelectionMode  mode);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_start_selection (a_list: POINTER) is
			-- void       gtk_list_start_selection       (GtkList          *list);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_toggle_add_mode (a_list: POINTER) is
			-- void       gtk_list_toggle_add_mode       (GtkList          *list);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_toggle_focus_row (a_list: POINTER) is
			-- void       gtk_list_toggle_focus_row      (GtkList          *list);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_toggle_row (a_list: POINTER; a_item: POINTER) is
			-- void       gtk_list_toggle_row            (GtkList          *list,
			-- 					   GtkWidget        *item);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_undo_selection (a_list: POINTER) is
			-- void       gtk_list_undo_selection        (GtkList          *list);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_unselect_all (a_list: POINTER) is
			-- void       gtk_list_unselect_all          (GtkList          *list);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_unselect_child (a_list: POINTER; a_child: POINTER) is
			-- void	   gtk_list_unselect_child	  (GtkList	    *list,
			-- 					   GtkWidget	    *child);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_list_unselect_item (a_list: POINTER; a_item: INTEGER) is
			-- void	   gtk_list_unselect_item	  (GtkList	    *list,
			-- 					   gint		     item);
			-- (from C_GTK_LIST)
		do
		end

	frozen gtk_main is
			-- void	   gtk_main		 (void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_main_do_event (a_event: POINTER) is
			-- void  gtk_main_do_event          (GdkEvent           *event);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_main_iteration: INTEGER is
			-- gint	   gtk_main_iteration	 (void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_main_iteration_do (a_blocking: BOOLEAN): INTEGER is
			-- gint	   gtk_main_iteration_do (gboolean blocking);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_main_level: INTEGER is
			-- guint	   gtk_main_level	 (void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_main_quit is
			-- void	   gtk_main_quit	 (void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_menu_attach_to_widget (a_menu: POINTER; a_attach_widget: POINTER; a_detacher: POINTER) is
			-- void	   gtk_menu_attach_to_widget	  (GtkMenu	       *menu,
			-- 					   GtkWidget	       *attach_widget,
			-- 					   GtkMenuDetachFunc	detacher);
			-- (from C_GTK_MENU)
		do
		end

	frozen gtk_menu_bar_new: POINTER is
			-- GtkWidget* gtk_menu_bar_new             (void);
			-- (from C_GTK_MENU_BAR)
		do
		end

	frozen gtk_menu_detach (a_menu: POINTER) is
			-- void	   gtk_menu_detach		  (GtkMenu	       *menu);
			-- (from C_GTK_MENU)
		do
		end

	frozen gtk_menu_get_accel_group (a_menu: POINTER): POINTER is
			-- GtkAccelGroup* gtk_menu_get_accel_group	  (GtkMenu	       *menu);
			-- (from C_GTK_MENU)
		do
		end

	frozen gtk_menu_get_active (a_menu: POINTER): POINTER is
			-- GtkWidget* gtk_menu_get_active		  (GtkMenu	       *menu);
			-- (from C_GTK_MENU)
		do
		end

	frozen gtk_menu_get_attach_widget (a_menu: POINTER): POINTER is
			-- GtkWidget* gtk_menu_get_attach_widget	  (GtkMenu	       *menu);
			-- (from C_GTK_MENU)
		do
		end

	frozen gtk_menu_item_activate (a_menu_item: POINTER) is
			-- void	   gtk_menu_item_activate	  (GtkMenuItem	       *menu_item);
			-- (from C_GTK_MENU_ITEM)
		do
		end

	frozen gtk_menu_item_deselect (a_menu_item: POINTER) is
			-- void	   gtk_menu_item_deselect	  (GtkMenuItem	       *menu_item);
			-- (from C_GTK_MENU_ITEM)
		do
		end

	frozen gtk_menu_item_new: POINTER is
			-- GtkWidget* gtk_menu_item_new		  (void);
			-- (from C_GTK_MENU_ITEM)
		do
		end

	frozen gtk_menu_item_new_with_label (a_label: POINTER): POINTER is
			-- GtkWidget* gtk_menu_item_new_with_label	  (const gchar	       *label);
			-- (from C_GTK_MENU_ITEM)
		do
		end

	frozen gtk_menu_item_remove_submenu (a_menu_item: POINTER) is
			-- void	   gtk_menu_item_remove_submenu	  (GtkMenuItem	       *menu_item);
			-- (from C_GTK_MENU_ITEM)
		do
		end

	frozen gtk_menu_item_select (a_menu_item: POINTER) is
			-- void	   gtk_menu_item_select		  (GtkMenuItem	       *menu_item);
			-- (from C_GTK_MENU_ITEM)
		do
		end

	frozen gtk_menu_item_set_submenu (a_menu_item: POINTER; a_submenu: POINTER) is
			-- void	   gtk_menu_item_set_submenu	  (GtkMenuItem	       *menu_item,
			-- 					   GtkWidget	       *submenu);
			-- (from C_GTK_MENU_ITEM)
		do
		end

	frozen gtk_menu_new: POINTER is
			-- GtkWidget* gtk_menu_new			  (void);
			-- (from C_GTK_MENU)
		do
		end

	frozen gtk_menu_popdown (a_menu: POINTER) is
			-- void	   gtk_menu_popdown		  (GtkMenu	       *menu);
			-- (from C_GTK_MENU)
		do
		end

	frozen gtk_menu_popup (a_menu: POINTER; a_parent_menu_shell: POINTER; a_parent_menu_item: POINTER; a_func: POINTER; a_data: POINTER; a_button: INTEGER; a_activate_time: INTEGER) is
			-- void	   gtk_menu_popup		  (GtkMenu	       *menu,
			-- 					   GtkWidget	       *parent_menu_shell,
			-- 					   GtkWidget	       *parent_menu_item,
			-- 					   GtkMenuPositionFunc	func,
			-- 					   gpointer		data,
			-- 					   guint		button,
			-- 					   guint32		activate_time);
			-- (from C_GTK_MENU)
		do
		end

	frozen gtk_menu_reorder_child (a_menu: POINTER; a_child: POINTER; a_position: INTEGER) is
			-- void       gtk_menu_reorder_child         (GtkMenu             *menu,
			--                                            GtkWidget           *child,
			--                                            gint                position);
			-- (from C_GTK_MENU)
		do
		end

	frozen gtk_menu_reposition (a_menu: POINTER) is
			-- void	   gtk_menu_reposition		  (GtkMenu	       *menu);
			-- (from C_GTK_MENU)
		do
		end

	frozen gtk_menu_set_accel_group (a_menu: POINTER; a_accel_group: POINTER) is
			-- void	       gtk_menu_set_accel_group	  (GtkMenu	       *menu,
			-- 					   GtkAccelGroup       *accel_group);
			-- (from C_GTK_MENU)
		do
		end

	frozen gtk_menu_set_active (a_menu: POINTER; a_index: INTEGER) is
			-- void	   gtk_menu_set_active		  (GtkMenu	       *menu,
			-- 					   guint		index);
			-- (from C_GTK_MENU)
		do
		end

	frozen gtk_menu_set_tearoff_state (a_menu: POINTER; a_torn_off: BOOLEAN) is
			-- void       gtk_menu_set_tearoff_state     (GtkMenu             *menu,
			-- 					   gboolean             torn_off);
			-- (from C_GTK_MENU)
		do
		end

	frozen gtk_menu_set_title (a_menu: POINTER; a_title: POINTER) is
			-- void       gtk_menu_set_title             (GtkMenu             *menu,
			-- 					   const gchar         *title);
			-- (from C_GTK_MENU)
		do
		end

	frozen gtk_menu_shell_activate_item (a_menu_shell: POINTER; a_menu_item: POINTER; a_force_deactivate: BOOLEAN) is
			-- void    gtk_menu_shell_activate_item  (GtkMenuShell      *menu_shell,
			-- 				       GtkWidget         *menu_item,
			-- 				       gboolean           force_deactivate);
			-- (from C_GTK_MENU_SHELL)
		do
		end

	frozen gtk_menu_shell_append (a_menu_shell: POINTER; a_child: POINTER) is
			-- void	gtk_menu_shell_append	  (GtkMenuShell *menu_shell,
			-- 				   GtkWidget	*child);
			-- (from C_GTK_MENU_SHELL)
		do
		end

	frozen gtk_menu_shell_deactivate (a_menu_shell: POINTER) is
			-- void	gtk_menu_shell_deactivate (GtkMenuShell *menu_shell);
			-- (from C_GTK_MENU_SHELL)
		do
		end

	frozen gtk_menu_shell_deselect (a_menu_shell: POINTER) is
			-- void    gtk_menu_shell_deselect    (GtkMenuShell      *menu_shell);
			-- (from C_GTK_MENU_SHELL)
		do
		end

	frozen gtk_menu_shell_get_type: INTEGER is
			-- GtkType gtk_menu_shell_get_type	  (void);
			-- (from C_GTK_MENU_SHELL)
		do
		end

	frozen gtk_menu_shell_insert (a_menu_shell: POINTER; a_child: POINTER; a_position: INTEGER) is
			-- void	gtk_menu_shell_insert	  (GtkMenuShell *menu_shell,
			-- 				   GtkWidget	*child,
			-- 				   gint		 position);
			-- (from C_GTK_MENU_SHELL)
		do
		end

	frozen gtk_menu_shell_prepend (a_menu_shell: POINTER; a_child: POINTER) is
			-- void	gtk_menu_shell_prepend	  (GtkMenuShell *menu_shell,
			-- 				   GtkWidget	*child);
			-- (from C_GTK_MENU_SHELL)
		do
		end

	frozen gtk_menu_shell_select_item (a_menu_shell: POINTER; a_menu_item: POINTER) is
			-- void    gtk_menu_shell_select_item (GtkMenuShell      *menu_shell,
			-- 				    GtkWidget         *menu_item);
			-- (from C_GTK_MENU_SHELL)
		do
		end

	frozen gtk_misc_get_type: INTEGER is
			-- GtkType gtk_misc_get_type      (void);
			-- (from C_GTK_MISC)
		do
		end

	frozen gtk_misc_set_alignment (a_misc: POINTER; a_xalign: REAL; a_yalign: REAL) is
			-- void	gtk_misc_set_alignment (GtkMisc *misc,
			-- 				gfloat	 xalign,
			-- 				gfloat	 yalign);
			-- (from C_GTK_MISC)
		do
		end

	frozen gtk_misc_set_padding (a_misc: POINTER; a_xpad: INTEGER; a_ypad: INTEGER) is
			-- void	gtk_misc_set_padding   (GtkMisc *misc,
			-- 				gint	 xpad,
			-- 				gint	 ypad);
			-- (from C_GTK_MISC)
		do
		end

	frozen gtk_notebook_append_page (a_notebook: POINTER; a_child: POINTER; a_tab_label: POINTER) is
			-- void gtk_notebook_append_page       (GtkNotebook *notebook,
			-- 				     GtkWidget   *child,
			-- 				     GtkWidget   *tab_label);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_append_page_menu (a_notebook: POINTER; a_child: POINTER; a_tab_label: POINTER; a_menu_label: POINTER) is
			-- void gtk_notebook_append_page_menu  (GtkNotebook *notebook,
			-- 				     GtkWidget   *child,
			-- 				     GtkWidget   *tab_label,
			-- 				     GtkWidget   *menu_label);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_get_current_page (a_notebook: POINTER): INTEGER is
			-- gint gtk_notebook_get_current_page   (GtkNotebook *notebook);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_get_menu_label (a_notebook: POINTER; a_child: POINTER): POINTER is
			-- GtkWidget * gtk_notebook_get_menu_label   (GtkNotebook *notebook,
			-- 					   GtkWidget   *child);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_get_nth_page (a_notebook: POINTER; a_page_num: INTEGER): POINTER is
			-- GtkWidget* gtk_notebook_get_nth_page (GtkNotebook *notebook,
			-- 				      gint         page_num);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_get_tab_label (a_notebook: POINTER; a_child: POINTER): POINTER is
			-- GtkWidget * gtk_notebook_get_tab_label    (GtkNotebook *notebook,
			-- 					   GtkWidget   *child);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_get_type: INTEGER is
			-- GtkType gtk_notebook_get_type       (void);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_insert_page (a_notebook: POINTER; a_child: POINTER; a_tab_label: POINTER; a_position: INTEGER) is
			-- void gtk_notebook_insert_page       (GtkNotebook *notebook,
			-- 				     GtkWidget   *child,
			-- 				     GtkWidget   *tab_label,
			-- 				     gint         position);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_insert_page_menu (a_notebook: POINTER; a_child: POINTER; a_tab_label: POINTER; a_menu_label: POINTER; a_position: INTEGER) is
			-- void gtk_notebook_insert_page_menu  (GtkNotebook *notebook,
			-- 				     GtkWidget   *child,
			-- 				     GtkWidget   *tab_label,
			-- 				     GtkWidget   *menu_label,
			-- 				     gint         position);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_new: POINTER is
			-- GtkWidget * gtk_notebook_new        (void);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_next_page (a_notebook: POINTER) is
			-- void gtk_notebook_next_page        (GtkNotebook *notebook);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_page_num (a_notebook: POINTER; a_child: POINTER): INTEGER is
			-- gint gtk_notebook_page_num         (GtkNotebook *notebook,
			-- 				    GtkWidget   *child);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_popup_disable (a_notebook: POINTER) is
			-- void gtk_notebook_popup_disable (GtkNotebook *notebook);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_popup_enable (a_notebook: POINTER) is
			-- void gtk_notebook_popup_enable  (GtkNotebook *notebook);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_prepend_page (a_notebook: POINTER; a_child: POINTER; a_tab_label: POINTER) is
			-- void gtk_notebook_prepend_page      (GtkNotebook *notebook,
			-- 				     GtkWidget   *child,
			-- 				     GtkWidget   *tab_label);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_prepend_page_menu (a_notebook: POINTER; a_child: POINTER; a_tab_label: POINTER; a_menu_label: POINTER) is
			-- void gtk_notebook_prepend_page_menu (GtkNotebook *notebook,
			-- 				     GtkWidget   *child,
			-- 				     GtkWidget   *tab_label,
			-- 				     GtkWidget   *menu_label);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_prev_page (a_notebook: POINTER) is
			-- void gtk_notebook_prev_page        (GtkNotebook *notebook);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_query_tab_label_packing (a_notebook: POINTER; a_child: POINTER; a_expand: POINTER; a_fill: POINTER; a_pack_type: POINTER) is
			-- void gtk_notebook_query_tab_label_packing (GtkNotebook *notebook,
			-- 					   GtkWidget   *child,
			-- 					   gboolean    *expand,
			-- 					   gboolean    *fill,
			-- 					   GtkPackType *pack_type);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_remove_page (a_notebook: POINTER; a_page_num: INTEGER) is
			-- void gtk_notebook_remove_page       (GtkNotebook *notebook,
			-- 				     gint         page_num);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_reorder_child (a_notebook: POINTER; a_child: POINTER; a_position: INTEGER) is
			-- void gtk_notebook_reorder_child           (GtkNotebook *notebook,
			-- 					   GtkWidget   *child,
			-- 					   gint         position);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_set_homogeneous_tabs (a_notebook: POINTER; a_homogeneous: BOOLEAN) is
			-- void gtk_notebook_set_homogeneous_tabs (GtkNotebook     *notebook,
			-- 					gboolean         homogeneous);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_set_menu_label (a_notebook: POINTER; a_child: POINTER; a_menu_label: POINTER) is
			-- void gtk_notebook_set_menu_label          (GtkNotebook *notebook,
			-- 					   GtkWidget   *child,
			-- 					   GtkWidget   *menu_label);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_set_menu_label_text (a_notebook: POINTER; a_child: POINTER; a_menu_text: POINTER) is
			-- void gtk_notebook_set_menu_label_text     (GtkNotebook *notebook,
			-- 					   GtkWidget   *child,
			-- 					   const gchar *menu_text);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_set_page (a_notebook: POINTER; a_page_num: INTEGER) is
			-- void gtk_notebook_set_page         (GtkNotebook *notebook,
			-- 				    gint         page_num);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_set_scrollable (a_notebook: POINTER; a_scrollable: BOOLEAN) is
			-- void gtk_notebook_set_scrollable       (GtkNotebook     *notebook,
			-- 					gboolean         scrollable);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_set_show_border (a_notebook: POINTER; a_show_border: BOOLEAN) is
			-- void gtk_notebook_set_show_border      (GtkNotebook     *notebook,
			-- 					gboolean         show_border);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_set_show_tabs (a_notebook: POINTER; a_show_tabs: BOOLEAN) is
			-- void gtk_notebook_set_show_tabs        (GtkNotebook     *notebook,
			-- 					gboolean         show_tabs);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_set_tab_border (a_notebook: POINTER; a_border_width: INTEGER) is
			-- void gtk_notebook_set_tab_border       (GtkNotebook     *notebook,
			-- 					guint            border_width);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_set_tab_hborder (a_notebook: POINTER; a_tab_hborder: INTEGER) is
			-- void gtk_notebook_set_tab_hborder      (GtkNotebook     *notebook,
			-- 					guint            tab_hborder);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_set_tab_label (a_notebook: POINTER; a_child: POINTER; a_tab_label: POINTER) is
			-- void gtk_notebook_set_tab_label           (GtkNotebook *notebook,
			-- 					   GtkWidget   *child,
			-- 					   GtkWidget   *tab_label);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_set_tab_label_packing (a_notebook: POINTER; a_child: POINTER; a_expand: BOOLEAN; a_fill: BOOLEAN; a_pack_type: INTEGER) is
			-- void gtk_notebook_set_tab_label_packing   (GtkNotebook *notebook,
			-- 					   GtkWidget   *child,
			-- 					   gboolean     expand,
			-- 					   gboolean     fill,
			-- 					   GtkPackType  pack_type);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_set_tab_label_text (a_notebook: POINTER; a_child: POINTER; a_tab_text: POINTER) is
			-- void gtk_notebook_set_tab_label_text      (GtkNotebook *notebook,
			-- 					   GtkWidget   *child,
			-- 					   const gchar *tab_text);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_set_tab_pos (a_notebook: POINTER; a_pos: INTEGER) is
			-- void gtk_notebook_set_tab_pos          (GtkNotebook     *notebook,
			-- 				        GtkPositionType  pos);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_notebook_set_tab_vborder (a_notebook: POINTER; a_tab_vborder: INTEGER) is
			-- void gtk_notebook_set_tab_vborder      (GtkNotebook     *notebook,
			-- 					guint            tab_vborder);
			-- (from C_GTK_NOTEBOOK)
		do
		end

	frozen gtk_object_add_arg_type (a_arg_name: POINTER; a_arg_type: INTEGER; a_arg_flags: INTEGER; a_arg_id: INTEGER) is
			-- void	gtk_object_add_arg_type		(const gchar	*arg_name,
			-- 					 GtkType	 arg_type,
			-- 					 guint		 arg_flags,
			-- 					 guint		 arg_id);
			-- (from C_GTK_OBJECT)
		do
		end

	frozen gtk_object_get_data (a_object: POINTER; a_key: POINTER): POINTER is
			-- gpointer gtk_object_get_data	     (GtkObject	     *object,
			-- 				      const gchar    *key);
			-- (from C_GTK_OBJECT)
		do
		end

	frozen gtk_object_get_data_by_id (a_object: POINTER; a_data_id: INTEGER): POINTER is
			-- gpointer gtk_object_get_data_by_id	(GtkObject	 *object,
			-- 					 GQuark		  data_id);
			-- (from C_GTK_OBJECT)
		do
		end

	frozen gtk_object_get_type: INTEGER is
			-- GtkType	gtk_object_get_type		(void);
			-- (from C_GTK_OBJECT)
		do
		end

	frozen gtk_object_get_user_data (a_object: POINTER): POINTER is
			-- gpointer gtk_object_get_user_data (GtkObject	*object);
			-- (from C_GTK_OBJECT)
		do
		end

	frozen gtk_object_remove_data (a_object: POINTER; a_key: POINTER) is
			-- void	 gtk_object_remove_data	     (GtkObject	     *object,
			-- 				      const gchar    *key);
			-- (from C_GTK_OBJECT)
		do
		end

	frozen gtk_object_remove_data_by_id (a_object: POINTER; a_data_id: INTEGER) is
			-- void  gtk_object_remove_data_by_id	(GtkObject	 *object,
			-- 					 GQuark		  data_id);
			-- (from C_GTK_OBJECT)
		do
		end

	frozen gtk_object_remove_no_notify (a_object: POINTER; a_key: POINTER) is
			-- void	 gtk_object_remove_no_notify (GtkObject	     *object,
			-- 				      const gchar    *key);
			-- (from C_GTK_OBJECT)
		do
		end

	frozen gtk_object_remove_no_notify_by_id (a_object: POINTER; a_key_id: INTEGER) is
			-- void  gtk_object_remove_no_notify_by_id	(GtkObject	 *object,
			-- 					 GQuark		  key_id);
			-- (from C_GTK_OBJECT)
		do
		end

	frozen gtk_object_set_data (a_object: POINTER; a_key: POINTER; a_data: POINTER) is
			-- void	 gtk_object_set_data	     (GtkObject	     *object,
			-- 				      const gchar    *key,
			-- 				      gpointer	      data);
			-- (from C_GTK_OBJECT)
		do
		end

	frozen gtk_object_set_data_by_id (a_object: POINTER; a_data_id: INTEGER; a_data: POINTER) is
			-- void gtk_object_set_data_by_id		(GtkObject	 *object,
			-- 					 GQuark		  data_id,
			-- 					 gpointer	  data);
			-- (from C_GTK_OBJECT)
		do
		end

	frozen gtk_object_set_data_by_id_full (a_object: POINTER; a_data_id: INTEGER; a_data: POINTER; a_destroy: POINTER) is
			-- void gtk_object_set_data_by_id_full	(GtkObject	 *object,
			-- 					 GQuark		  data_id,
			-- 					 gpointer	  data,
			-- 					 GtkDestroyNotify destroy);
			-- (from C_GTK_OBJECT)
		do
		end

	frozen gtk_object_set_data_full (a_object: POINTER; a_key: POINTER; a_data: POINTER; a_destroy: POINTER) is
			-- void	 gtk_object_set_data_full    (GtkObject	     *object,
			-- 				      const gchar    *key,
			-- 				      gpointer	      data,
			-- 				      GtkDestroyNotify destroy);
			-- (from C_GTK_OBJECT)
		do
		end

	frozen gtk_object_set_user_data (a_object: POINTER; a_data: POINTER) is
			-- void	 gtk_object_set_user_data (GtkObject	*object,
			-- 				   gpointer	 data);
			-- (from C_GTK_OBJECT)
		do
		end

	frozen gtk_object_sink (a_object: POINTER) is
			-- void gtk_object_sink	  (GtkObject	    *object);
			-- (from C_GTK_OBJECT)
		do
		end

	frozen gtk_object_weakref (a_object: POINTER; a_notify: POINTER; a_data: POINTER) is
			-- void gtk_object_weakref	  (GtkObject	    *object,
			-- 			   GtkDestroyNotify  notify,
			-- 			   gpointer	     data);
			-- (from C_GTK_OBJECT)
		do
		end

	frozen gtk_object_weakunref (a_object: POINTER; a_notify: POINTER; a_data: POINTER) is
			-- void gtk_object_weakunref (GtkObject	    *object,
			-- 			   GtkDestroyNotify  notify,
			-- 			   gpointer	     data);
			-- (from C_GTK_OBJECT)
		do
		end

	frozen gtk_paint_arrow (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_area: POINTER; a_widget: POINTER; a_detail: POINTER; a_arrow_type: INTEGER; a_fill: BOOLEAN; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void gtk_paint_arrow   (GtkStyle      *style,
			-- 			Gdkwindow     *window,
			-- 			GtkStateType   state_type,
			-- 			GtkshadowType  shadow_type,
			-- 			GdkRectangle  *area,
			-- 			GtkWidget     *widget,
			-- 			gchar	      *detail,
			-- 			GtkArrowType   arrow_type,
			-- 			gboolean       fill,
			-- 			gint	       x,
			-- 			gint	       y,
			-- 			gint	       width,
			-- 			gint	       height);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_paint_box (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_area: POINTER; a_widget: POINTER; a_detail: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void gtk_paint_box     (GtkStyle      *style,
			-- 			Gdkwindow     *window,
			-- 			GtkStateType   state_type,
			-- 			GtkshadowType  shadow_type,
			-- 			GdkRectangle  *area,
			-- 			GtkWidget     *widget,
			-- 			gchar	      *detail,
			-- 			gint	       x,
			-- 			gint	       y,
			-- 			gint	       width,
			-- 			gint	       height);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_paint_box_gap (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_area: POINTER; a_widget: POINTER; a_detail: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER; a_gap_side: INTEGER; a_gap_x: INTEGER; a_gap_width: INTEGER) is
			-- void gtk_paint_box_gap (GtkStyle       *style,
			-- 			Gdkwindow      *window,
			-- 			GtkStateType	state_type,
			-- 			GtkshadowType	shadow_type,
			-- 			GdkRectangle   *area,
			-- 			GtkWidget      *widget,
			-- 			gchar	       *detail,
			-- 			gint		x,
			-- 			gint		y,
			-- 			gint		width,
			-- 			gint		height,
			-- 			GtkPositionType gap_side,
			-- 			gint		gap_x,
			-- 			gint		gap_width);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_paint_check (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_area: POINTER; a_widget: POINTER; a_detail: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void gtk_paint_check   (GtkStyle      *style,
			-- 			Gdkwindow     *window,
			-- 			GtkStateType   state_type,
			-- 			GtkshadowType  shadow_type,
			-- 			GdkRectangle  *area,
			-- 			GtkWidget     *widget,
			-- 			gchar	      *detail,
			-- 			gint	       x,
			-- 			gint	       y,
			-- 			gint	       width,
			-- 			gint	       height);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_paint_diamond (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_area: POINTER; a_widget: POINTER; a_detail: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void gtk_paint_diamond (GtkStyle      *style,
			-- 			Gdkwindow     *window,
			-- 			GtkStateType   state_type,
			-- 			GtkshadowType  shadow_type,
			-- 			GdkRectangle  *area,
			-- 			GtkWidget     *widget,
			-- 			gchar	      *detail,
			-- 			gint	       x,
			-- 			gint	       y,
			-- 			gint	       width,
			-- 			gint	       height);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_paint_extension (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_area: POINTER; a_widget: POINTER; a_detail: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER; a_gap_side: INTEGER) is
			-- void gtk_paint_extension (GtkStyle	 *style,
			-- 			  Gdkwindow	 *window,
			-- 			  GtkStateType	  state_type,
			-- 			  GtkshadowType	  shadow_type,
			-- 			  GdkRectangle	 *area,
			-- 			  GtkWidget	 *widget,
			-- 			  gchar		 *detail,
			-- 			  gint		  x,
			-- 			  gint		  y,
			-- 			  gint		  width,
			-- 			  gint		  height,
			-- 			  GtkPositionType gap_side);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_paint_flat_box (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_area: POINTER; a_widget: POINTER; a_detail: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void gtk_paint_flat_box (GtkStyle      *style,
			-- 			 Gdkwindow     *window,
			-- 			 GtkStateType	state_type,
			-- 			 GtkshadowType	shadow_type,
			-- 			 GdkRectangle  *area,
			-- 			 GtkWidget     *widget,
			-- 			 gchar	       *detail,
			-- 			 gint		x,
			-- 			 gint		y,
			-- 			 gint		width,
			-- 			 gint		height);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_paint_handle (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_area: POINTER; a_widget: POINTER; a_detail: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER; a_orientation: INTEGER) is
			-- void gtk_paint_handle  (GtkStyle      *style,
			-- 			Gdkwindow     *window,
			-- 			GtkStateType   state_type,
			-- 			GtkshadowType  shadow_type,
			-- 			GdkRectangle  *area,
			-- 			GtkWidget     *widget,
			-- 			gchar	      *detail,
			-- 			gint	       x,
			-- 			gint	       y,
			-- 			gint	       width,
			-- 			gint	       height,
			-- 			GtkOrientation orientation);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_paint_hline (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_area: POINTER; a_widget: POINTER; a_detail: POINTER; a_x1: INTEGER; a_x2: INTEGER; a_y: INTEGER) is
			-- void gtk_paint_hline   (GtkStyle      *style,
			-- 			Gdkwindow     *window,
			-- 			GtkStateType   state_type,
			-- 			GdkRectangle  *area,
			-- 			GtkWidget     *widget,
			-- 			gchar	      *detail,
			-- 			gint	       x1,
			-- 			gint	       x2,
			-- 			gint	       y);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_paint_option (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_area: POINTER; a_widget: POINTER; a_detail: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void gtk_paint_option  (GtkStyle      *style,
			-- 			Gdkwindow     *window,
			-- 			GtkStateType   state_type,
			-- 			GtkshadowType  shadow_type,
			-- 			GdkRectangle  *area,
			-- 			GtkWidget     *widget,
			-- 			gchar	      *detail,
			-- 			gint	       x,
			-- 			gint	       y,
			-- 			gint	       width,
			-- 			gint	       height);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_paint_polygon (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_area: POINTER; a_widget: POINTER; a_detail: POINTER; a_points: POINTER; a_npoints: INTEGER; a_fill: BOOLEAN) is
			-- void gtk_paint_polygon (GtkStyle      *style,
			-- 			Gdkwindow     *window,
			-- 			GtkStateType   state_type,
			-- 			GtkshadowType  shadow_type,
			-- 			GdkRectangle  *area,
			-- 			GtkWidget     *widget,
			-- 			gchar	      *detail,
			-- 			GdkPoint      *points,
			-- 			gint	       npoints,
			-- 			gboolean       fill);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_paint_shadow (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_area: POINTER; a_widget: POINTER; a_detail: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void gtk_paint_shadow  (GtkStyle     *style,
			-- 			Gdkwindow    *window,
			-- 			GtkStateType  state_type,
			-- 			GtkshadowType shadow_type,
			-- 			GdkRectangle  *area,
			-- 			GtkWidget     *widget,
			-- 			gchar	      *detail,
			-- 			gint	       x,
			-- 			gint	       y,
			-- 			gint	       width,
			-- 			gint	       height);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_paint_shadow_gap (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_area: POINTER; a_widget: POINTER; a_detail: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER; a_gap_side: INTEGER; a_gap_x: INTEGER; a_gap_width: INTEGER) is
			-- void gtk_paint_shadow_gap (GtkStyle	  *style,
			-- 			   Gdkwindow	  *window,
			-- 			   GtkStateType	   state_type,
			-- 			   GtkshadowType   shadow_type,
			-- 			   GdkRectangle	  *area,
			-- 			   GtkWidget	  *widget,
			-- 			   gchar	  *detail,
			-- 			   gint		   x,
			-- 			   gint		   y,
			-- 			   gint		   width,
			-- 			   gint		   height,
			-- 			   GtkPositionType gap_side,
			-- 			   gint		   gap_x,
			-- 			   gint		   gap_width);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_paint_slider (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_area: POINTER; a_widget: POINTER; a_detail: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER; a_orientation: INTEGER) is
			-- void gtk_paint_slider  (GtkStyle      *style,
			-- 			Gdkwindow     *window,
			-- 			GtkStateType   state_type,
			-- 			GtkshadowType  shadow_type,
			-- 			GdkRectangle  *area,
			-- 			GtkWidget     *widget,
			-- 			gchar	      *detail,
			-- 			gint	       x,
			-- 			gint	       y,
			-- 			gint	       width,
			-- 			gint	       height,
			-- 			GtkOrientation orientation);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_paint_string (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_area: POINTER; a_widget: POINTER; a_detail: POINTER; a_x: INTEGER; a_y: INTEGER; a_string: POINTER) is
			-- void gtk_paint_string  (GtkStyle      *style,
			-- 			Gdkwindow     *window,
			-- 			GtkStateType   state_type,
			-- 			GdkRectangle  *area,
			-- 			GtkWidget     *widget,
			-- 			gchar	      *detail,
			-- 			gint	       x,
			-- 			gint	       y,
			-- 			const gchar   *string);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_paint_tab (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_shadow_type: INTEGER; a_area: POINTER; a_widget: POINTER; a_detail: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void gtk_paint_tab     (GtkStyle      *style,
			-- 			Gdkwindow     *window,
			-- 			GtkStateType   state_type,
			-- 			GtkshadowType  shadow_type,
			-- 			GdkRectangle  *area,
			-- 			GtkWidget     *widget,
			-- 			gchar	      *detail,
			-- 			gint	       x,
			-- 			gint	       y,
			-- 			gint	       width,
			-- 			gint	       height);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_paint_vline (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER; a_area: POINTER; a_widget: POINTER; a_detail: POINTER; a_y1: INTEGER; a_y2: INTEGER; a_x: INTEGER) is
			-- void gtk_paint_vline   (GtkStyle      *style,
			-- 			Gdkwindow     *window,
			-- 			GtkStateType   state_type,
			-- 			GdkRectangle  *area,
			-- 			GtkWidget     *widget,
			-- 			gchar	      *detail,
			-- 			gint	       y1,
			-- 			gint	       y2,
			-- 			gint	       x);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_paned_add1 (a_paned: POINTER; a_child: POINTER) is
			-- void    gtk_paned_add1            (GtkPaned  *paned,
			-- 				   GtkWidget *child);
			-- (from C_GTK_PANED)
		do
		end

	frozen gtk_paned_add2 (a_paned: POINTER; a_child: POINTER) is
			-- void    gtk_paned_add2            (GtkPaned  *paned,
			-- 				   GtkWidget *child);
			-- (from C_GTK_PANED)
		do
		end

	frozen gtk_paned_compute_position (a_paned: POINTER; a_allocation: INTEGER; a_child1_req: INTEGER; a_child2_req: INTEGER) is
			-- void    gtk_paned_compute_position (GtkPaned *paned,
			-- 				    gint      allocation,
			-- 				    gint      child1_req,
			-- 				    gint      child2_req);
			-- (from C_GTK_PANED)
		do
		end

	frozen gtk_paned_get_type: INTEGER is
			-- GtkType gtk_paned_get_type        (void);
			-- (from C_GTK_PANED)
		do
		end

	frozen gtk_paned_pack1 (a_paned: POINTER; a_child: POINTER; a_resize: BOOLEAN; a_shrink: BOOLEAN) is
			-- void    gtk_paned_pack1           (GtkPaned  *paned,
			-- 				   GtkWidget *child,
			-- 				   gboolean   resize,
			-- 				   gboolean   shrink);
			-- (from C_GTK_PANED)
		do
		end

	frozen gtk_paned_pack2 (a_paned: POINTER; a_child: POINTER; a_resize: BOOLEAN; a_shrink: BOOLEAN) is
			-- void    gtk_paned_pack2           (GtkPaned  *paned,
			-- 				   GtkWidget *child,
			-- 				   gboolean   resize,
			-- 				   gboolean   shrink);
			-- (from C_GTK_PANED)
		do
		end

	frozen gtk_paned_set_position (a_paned: POINTER; a_position: INTEGER) is
			-- void    gtk_paned_set_position    (GtkPaned  *paned,
			-- 				   gint       position);
			-- (from C_GTK_PANED)
		do
		end

	frozen gtk_pixmap_get (a_pixmap: POINTER; a_val: POINTER; a_mask: POINTER) is
			-- void	   gtk_pixmap_get	 (GtkPixmap  *pixmap,
			-- 				  GdkPixmap **val,
			-- 				  GdkBitmap **mask);
			-- (from C_GTK_PIXMAP)
		do
		end

	frozen gtk_pixmap_get_type: INTEGER is
			-- GtkType	   gtk_pixmap_get_type	 (void);
			-- (from C_GTK_PIXMAP)
		do
		end

	frozen gtk_pixmap_new (a_pixmap: POINTER; a_mask: POINTER): POINTER is
			-- GtkWidget* gtk_pixmap_new	 (GdkPixmap  *pixmap,
			-- 				  GdkBitmap  *mask);
			-- (from C_GTK_PIXMAP)
		do
		end

	frozen gtk_pixmap_set (a_pixmap: POINTER; a_val: POINTER; a_mask: POINTER) is
			-- void	   gtk_pixmap_set	 (GtkPixmap  *pixmap,
			-- 				  GdkPixmap  *val,
			-- 				  GdkBitmap  *mask);
			-- (from C_GTK_PIXMAP)
		do
		end

	frozen gtk_pixmap_set_build_insensitive (a_pixmap: POINTER; a_build: INTEGER) is
			-- void       gtk_pixmap_set_build_insensitive (GtkPixmap *pixmap,
			-- 		                             guint build);
			-- (from C_GTK_PIXMAP)
		do
		end

	frozen gtk_progress_bar_get_type: INTEGER is
			-- GtkType    gtk_progress_bar_get_type             (void);
			-- (from C_GTK_PROGRESS_BAR)
		do
		end

	frozen gtk_progress_bar_new: POINTER is
			-- GtkWidget* gtk_progress_bar_new                  (void);
			-- (from C_GTK_PROGRESS_BAR)
		do
		end

	frozen gtk_progress_bar_new_with_adjustment (a_adjustment: POINTER): POINTER is
			-- GtkWidget* gtk_progress_bar_new_with_adjustment  (GtkAdjustment  *adjustment);
			-- (from C_GTK_PROGRESS_BAR)
		do
		end

	frozen gtk_progress_bar_set_activity_blocks (a_pbar: POINTER; a_blocks: INTEGER) is
			-- void       gtk_progress_bar_set_activity_blocks  (GtkProgressBar *pbar,
			-- 						  guint           blocks);
			-- (from C_GTK_PROGRESS_BAR)
		do
		end

	frozen gtk_progress_bar_set_activity_step (a_pbar: POINTER; a_step: INTEGER) is
			-- void       gtk_progress_bar_set_activity_step    (GtkProgressBar *pbar,
			--                                                   guint           step);
			-- (from C_GTK_PROGRESS_BAR)
		do
		end

	frozen gtk_progress_bar_set_bar_style (a_pbar: POINTER; a_style: INTEGER) is
			-- void       gtk_progress_bar_set_bar_style        (GtkProgressBar *pbar,
			-- 						  GtkProgressBarStyle style);
			-- (from C_GTK_PROGRESS_BAR)
		do
		end

	frozen gtk_progress_bar_set_discrete_blocks (a_pbar: POINTER; a_blocks: INTEGER) is
			-- void       gtk_progress_bar_set_discrete_blocks  (GtkProgressBar *pbar,
			-- 						  guint           blocks);
			-- (from C_GTK_PROGRESS_BAR)
		do
		end

	frozen gtk_progress_bar_set_orientation (a_pbar: POINTER; a_orientation: INTEGER) is
			-- void       gtk_progress_bar_set_orientation      (GtkProgressBar *pbar,
			-- 						  GtkProgressBarOrientation orientation);
			-- (from C_GTK_PROGRESS_BAR)
		do
		end

	frozen gtk_progress_bar_update (a_pbar: POINTER; a_percentage: REAL) is
			-- void       gtk_progress_bar_update               (GtkProgressBar *pbar,
			-- 						  gfloat          percentage);
			-- (from C_GTK_PROGRESS_BAR)
		do
		end

	frozen gtk_propagate_event (a_widget: POINTER; a_event: POINTER) is
			-- void       gtk_propagate_event     (GtkWidget         *widget,
			-- 				    GdkEvent          *event);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_quit_add (a_main_level: INTEGER; a_function: POINTER; a_data: POINTER): INTEGER is
			-- guint	   gtk_quit_add		   (guint	       main_level,
			-- 				    GtkFunction	       function,
			-- 				    gpointer	       data);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_quit_add_destroy (a_main_level: INTEGER; a_object: POINTER) is
			-- void	   gtk_quit_add_destroy	   (guint	       main_level,
			-- 				    GtkObject	      *object);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_quit_add_full (a_main_level: INTEGER; a_function: POINTER; a_marshal: POINTER; a_data: POINTER; a_destroy: POINTER): INTEGER is
			-- guint	   gtk_quit_add_full	   (guint	       main_level,
			-- 				    GtkFunction	       function,
			-- 				    GtkCallbackMarshal marshal,
			-- 				    gpointer	       data,
			-- 				    GtkDestroyNotify   destroy);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_quit_remove (a_quit_handler_id: INTEGER) is
			-- void	   gtk_quit_remove	   (guint	       quit_handler_id);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_quit_remove_by_data (a_data: POINTER) is
			-- void	   gtk_quit_remove_by_data (gpointer	       data);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_radio_button_get_type: INTEGER is
			-- GtkType	    gtk_radio_button_get_type	     (void);
			-- (from C_GTK_RADIO_BUTTON)
		do
		end

	frozen gtk_radio_button_group (a_radio_button: POINTER): POINTER is
			-- GSList*	    gtk_radio_button_group	     (GtkRadioButton *radio_button);
			-- (from C_GTK_RADIO_BUTTON)
		do
		end

	frozen gtk_radio_button_new (a_group: POINTER): POINTER is
			-- GtkWidget*  gtk_radio_button_new	     (GSList	     *group);
			-- (from C_GTK_RADIO_BUTTON)
		do
		end

	frozen gtk_radio_button_new_from_widget (a_group: POINTER): POINTER is
			-- GtkWidget*  gtk_radio_button_new_from_widget (GtkRadioButton *group);
			-- (from C_GTK_RADIO_BUTTON)
		do
		end

	frozen gtk_radio_button_new_with_label (a_group: POINTER; a_label: POINTER): POINTER is
			-- GtkWidget*  gtk_radio_button_new_with_label  (GSList	     *group,
			-- 					      const gchar    *label);
			-- (from C_GTK_RADIO_BUTTON)
		do
		end

	frozen gtk_radio_button_new_with_label_from_widget (a_group: POINTER; a_label: POINTER): POINTER is
			-- GtkWidget*  gtk_radio_button_new_with_label_from_widget (GtkRadioButton *group,
			-- 							 const gchar	*label);
			-- (from C_GTK_RADIO_BUTTON)
		do
		end

	frozen gtk_radio_button_set_group (a_radio_button: POINTER; a_group: POINTER) is
			-- void	    gtk_radio_button_set_group	     (GtkRadioButton *radio_button,
			-- 					      GSList	     *group);
			-- (from C_GTK_RADIO_BUTTON)
		do
		end

	frozen gtk_radio_menu_item_get_type: INTEGER is
			-- GtkType    gtk_radio_menu_item_get_type	      (void);
			-- (from C_GTK_RADIO_MENU_ITEM)
		do
		end

	frozen gtk_radio_menu_item_group (a_radio_menu_item: POINTER): POINTER is
			-- GSList*	   gtk_radio_menu_item_group	      (GtkRadioMenuItem *radio_menu_item);
			-- (from C_GTK_RADIO_MENU_ITEM)
		do
		end

	frozen gtk_radio_menu_item_new (a_group: POINTER): POINTER is
			-- GtkWidget* gtk_radio_menu_item_new	      (GSList		*group);
			-- (from C_GTK_RADIO_MENU_ITEM)
		do
		end

	frozen gtk_radio_menu_item_new_with_label (a_group: POINTER; a_label: POINTER): POINTER is
			-- GtkWidget* gtk_radio_menu_item_new_with_label (GSList		*group,
			-- 					       const gchar	*label);
			-- (from C_GTK_RADIO_MENU_ITEM)
		do
		end

	frozen gtk_radio_menu_item_set_group (a_radio_menu_item: POINTER; a_group: POINTER) is
			-- void	   gtk_radio_menu_item_set_group      (GtkRadioMenuItem *radio_menu_item,
			-- 					       GSList		*group);
			-- (from C_GTK_RADIO_MENU_ITEM)
		do
		end

	frozen gtk_rc_add_class_style (a_rc_style: POINTER; a_pattern: POINTER) is
			-- void	  gtk_rc_add_class_style	(GtkRcStyle  *rc_style,
			-- 					 const gchar *pattern);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_rc_add_default_file (a_filename: POINTER) is
			-- void      gtk_rc_add_default_file    (const gchar *filename);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_rc_add_widget_class_style (a_rc_style: POINTER; a_pattern: POINTER) is
			-- void	  gtk_rc_add_widget_class_style (GtkRcStyle  *rc_style,
			-- 					 const gchar *pattern);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_rc_add_widget_name_style (a_rc_style: POINTER; a_pattern: POINTER) is
			-- void	  gtk_rc_add_widget_name_style	(GtkRcStyle  *rc_style,
			-- 					 const gchar *pattern);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_rc_find_module_in_path (a_module_file: POINTER): POINTER is
			-- gchar*		gtk_rc_find_module_in_path	(const gchar 	*module_file);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_rc_get_default_files: POINTER is
			-- gchar**   gtk_rc_get_default_files      (void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_rc_get_module_dir: POINTER is
			-- gchar*		gtk_rc_get_module_dir		(void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_rc_get_style (a_widget: POINTER): POINTER is
			-- GtkStyle* gtk_rc_get_style		(GtkWidget   *widget);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_rc_get_theme_dir: POINTER is
			-- gchar*		gtk_rc_get_theme_dir		(void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_rc_parse (a_filename: POINTER) is
			-- void	  gtk_rc_parse			(const gchar *filename);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_rc_parse_color (a_scanner: POINTER; a_color: POINTER): INTEGER is
			-- guint	gtk_rc_parse_color	(GScanner	     *scanner,
			-- 				 GdkColor	     *color);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_rc_parse_priority (a_scanner: POINTER; a_priority: POINTER): INTEGER is
			-- guint	gtk_rc_parse_priority	(GScanner	     *scanner,
			-- 				 GtkPathPriorityType *priority);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_rc_parse_state (a_scanner: POINTER; a_state: POINTER): INTEGER is
			-- guint	gtk_rc_parse_state	(GScanner	     *scanner,
			-- 				 GtkStateType	     *state);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_rc_parse_string (a_rc_string: POINTER) is
			-- void	  gtk_rc_parse_string		(const gchar *rc_string);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_rc_reparse_all: BOOLEAN is
			-- gboolean  gtk_rc_reparse_all		(void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_rc_set_default_files (a_filenames: POINTER) is
			-- void      gtk_rc_set_default_files      (gchar **filenames);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_rc_style_new: POINTER is
			-- GtkRcStyle* gtk_rc_style_new              (void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_rc_style_ref (a_rc_style: POINTER) is
			-- void        gtk_rc_style_ref              (GtkRcStyle  *rc_style);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_rc_style_unref (a_rc_style: POINTER) is
			-- void        gtk_rc_style_unref            (GtkRcStyle  *rc_style);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_scale_set_digits (a_scale: POINTER; a_digits: INTEGER) is
			-- void    gtk_scale_set_digits      (GtkScale        *scale,
			-- 				   gint             digits);
			-- (from C_GTK_SCALE)
		do
		end

	frozen gtk_scale_set_draw_value (a_scale: POINTER; a_draw_value: BOOLEAN) is
			-- void    gtk_scale_set_draw_value  (GtkScale        *scale,
			-- 				   gboolean         draw_value);
			-- (from C_GTK_SCALE)
		do
		end

	frozen gtk_scale_set_value_pos (a_scale: POINTER; a_pos: INTEGER) is
			-- void    gtk_scale_set_value_pos   (GtkScale        *scale,
			-- 				   GtkPositionType  pos);
			-- (from C_GTK_SCALE)
		do
		end

	frozen gtk_scrolled_window_add_with_viewport (a_scrolled_window: POINTER; a_child: POINTER) is
			-- void	       gtk_scrolled_window_add_with_viewport (GtkScrolledwindow *scrolled_window,
			-- 						      GtkWidget		*child);
			-- (from C_GTK_SCROLLED_window)
		do
		end

	frozen gtk_scrolled_window_get_hadjustment (a_scrolled_window: POINTER): POINTER is
			-- GtkAdjustment* gtk_scrolled_window_get_hadjustment   (GtkScrolledwindow *scrolled_window);
			-- (from C_GTK_SCROLLED_window)
		do
		end

	frozen gtk_scrolled_window_get_type: INTEGER is
			-- GtkType        gtk_scrolled_window_get_type          (void);
			-- (from C_GTK_SCROLLED_window)
		do
		end

	frozen gtk_scrolled_window_get_vadjustment (a_scrolled_window: POINTER): POINTER is
			-- GtkAdjustment* gtk_scrolled_window_get_vadjustment   (GtkScrolledwindow *scrolled_window);
			-- (from C_GTK_SCROLLED_window)
		do
		end

	frozen gtk_scrolled_window_new (a_hadjustment: POINTER; a_vadjustment: POINTER): POINTER is
			-- GtkWidget*     gtk_scrolled_window_new               (GtkAdjustment     *hadjustment,
			-- 						      GtkAdjustment     *vadjustment);
			-- (from C_GTK_SCROLLED_window)
		do
		end

	frozen gtk_scrolled_window_set_hadjustment (a_scrolled_window: POINTER; a_hadjustment: POINTER) is
			-- void           gtk_scrolled_window_set_hadjustment   (GtkScrolledwindow *scrolled_window,
			-- 						      GtkAdjustment     *hadjustment);
			-- (from C_GTK_SCROLLED_window)
		do
		end

	frozen gtk_scrolled_window_set_placement (a_scrolled_window: POINTER; a_window_placement: INTEGER) is
			-- void           gtk_scrolled_window_set_placement     (GtkScrolledwindow *scrolled_window,
			-- 						      GtkCornerType      window_placement);
			-- (from C_GTK_SCROLLED_window)
		do
		end

	frozen gtk_scrolled_window_set_policy (a_scrolled_window: POINTER; a_hscrollbar_policy: INTEGER; a_vscrollbar_policy: INTEGER) is
			-- void           gtk_scrolled_window_set_policy        (GtkScrolledwindow *scrolled_window,
			-- 						      GtkPolicyType      hscrollbar_policy,
			-- 						      GtkPolicyType      vscrollbar_policy);
			-- (from C_GTK_SCROLLED_window)
		do
		end

	frozen gtk_scrolled_window_set_vadjustment (a_scrolled_window: POINTER; a_hadjustment: POINTER) is
			-- void           gtk_scrolled_window_set_vadjustment   (GtkScrolledwindow *scrolled_window,
			-- 						      GtkAdjustment     *hadjustment);
			-- (from C_GTK_SCROLLED_window)
		do
		end

	frozen gtk_selection_add_target (a_widget: POINTER; a_selection: POINTER; a_target: POINTER; a_info: NATURAL_32) is
			-- void gtk_selection_add_target (GtkWidget           *widget,
			-- 			       GdkAtom              selection,
			-- 			       GdkAtom              target,
			-- 			       guint                info);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_selection_add_targets (a_widget: POINTER; a_selection: POINTER; a_targets: POINTER; a_ntargets: NATURAL_32) is
			-- void gtk_selection_add_targets (GtkWidget            *widget,
			-- 				GdkAtom               selection,
			-- 				const GtkTargetEntry *targets,
			-- 				guint                 ntargets);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_selection_clear (a_widget: POINTER; a_event: POINTER): INTEGER is
			-- gint gtk_selection_clear           (GtkWidget 	      *widget,
			-- 				    GdkEventSelection *event);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_selection_convert (a_widget: POINTER; a_selection: POINTER; a_target: POINTER; a_time: NATURAL_32): INTEGER is
			-- gint gtk_selection_convert   (GtkWidget 	  *widget,
			-- 			      GdkAtom    	   selection,
			-- 			      GdkAtom    	   target,
			-- 			      guint32    	   time);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_selection_data_copy (a_data: POINTER): POINTER is
			-- GtkSelectioData *gtk_selection_data_copy (GtkSelectionData *data);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_selection_data_free (a_data: POINTER) is
			-- void		 gtk_selection_data_free (GtkSelectionData *data);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_selection_data_set (a_selection_data: POINTER; a_type: POINTER; a_format: INTEGER; a_data: POINTER; a_length: INTEGER) is
			-- void gtk_selection_data_set (GtkSelectionData *selection_data,
			-- 			     GdkAtom           type,
			-- 			     gint              format,
			-- 			     const guchar     *data,
			-- 			     gint              length);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_selection_owner_set (a_widget: POINTER; a_selection: POINTER; a_time: NATURAL_32): INTEGER is
			-- gint gtk_selection_owner_set (GtkWidget 	  *widget,
			-- 			      GdkAtom    	   selection,
			-- 			      guint32    	   time);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_selection_remove_all (a_widget: POINTER) is
			-- void gtk_selection_remove_all      (GtkWidget *widget);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_set_locale: POINTER is
			-- gchar*	   gtk_set_locale	 (void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_spin_button_configure (a_spin_button: POINTER; a_adjustment: POINTER; a_climb_rate: REAL; a_digits: INTEGER) is
			-- void		gtk_spin_button_configure	   (GtkSpinButton  *spin_button,
			-- 						    GtkAdjustment  *adjustment,
			-- 						    gfloat	    climb_rate,
			-- 						    guint	    digits);
			-- (from C_GTK_SPIN_BUTTON)
		do
		end

	frozen gtk_spin_button_get_adjustment (a_spin_button: POINTER): POINTER is
			-- GtkAdjustment*	gtk_spin_button_get_adjustment	   (GtkSpinButton  *spin_button);
			-- (from C_GTK_SPIN_BUTTON)
		do
		end

	frozen gtk_spin_button_get_type: INTEGER is
			-- GtkType		gtk_spin_button_get_type	   (void);
			-- (from C_GTK_SPIN_BUTTON)
		do
		end

	frozen gtk_spin_button_get_value_as_float (a_spin_button: POINTER): REAL is
			-- gfloat		gtk_spin_button_get_value_as_float (GtkSpinButton  *spin_button);
			-- (from C_GTK_SPIN_BUTTON)
		do
		end

	frozen gtk_spin_button_get_value_as_int (a_spin_button: POINTER): INTEGER is
			-- gint		gtk_spin_button_get_value_as_int   (GtkSpinButton  *spin_button);
			-- (from C_GTK_SPIN_BUTTON)
		do
		end

	frozen gtk_spin_button_new (a_adjustment: POINTER; a_climb_rate: REAL; a_digits: INTEGER): POINTER is
			-- GtkWidget*	gtk_spin_button_new		   (GtkAdjustment  *adjustment,
			-- 						    gfloat	    climb_rate,
			-- 						    guint	    digits);
			-- (from C_GTK_SPIN_BUTTON)
		do
		end

	frozen gtk_spin_button_set_adjustment (a_spin_button: POINTER; a_adjustment: POINTER) is
			-- void		gtk_spin_button_set_adjustment	   (GtkSpinButton  *spin_button,
			-- 						    GtkAdjustment  *adjustment);
			-- (from C_GTK_SPIN_BUTTON)
		do
		end

	frozen gtk_spin_button_set_digits (a_spin_button: POINTER; a_digits: INTEGER) is
			-- void		gtk_spin_button_set_digits	   (GtkSpinButton  *spin_button,
			-- 						    guint	    digits);
			-- (from C_GTK_SPIN_BUTTON)
		do
		end

	frozen gtk_spin_button_set_numeric (a_spin_button: POINTER; a_numeric: BOOLEAN) is
			-- void		gtk_spin_button_set_numeric	   (GtkSpinButton  *spin_button,
			-- 						    gboolean	    numeric);
			-- (from C_GTK_SPIN_BUTTON)
		do
		end

	frozen gtk_spin_button_set_snap_to_ticks (a_spin_button: POINTER; a_snap_to_ticks: BOOLEAN) is
			-- void		gtk_spin_button_set_snap_to_ticks  (GtkSpinButton  *spin_button,
			-- 						    gboolean	    snap_to_ticks);
			-- (from C_GTK_SPIN_BUTTON)
		do
		end

	frozen gtk_spin_button_set_update_policy (a_spin_button: POINTER; a_policy: INTEGER) is
			-- void		gtk_spin_button_set_update_policy  (GtkSpinButton  *spin_button,
			-- 						    GtkSpinButtonUpdatePolicy  policy);
			-- (from C_GTK_SPIN_BUTTON)
		do
		end

	frozen gtk_spin_button_set_value (a_spin_button: POINTER; a_value: REAL) is
			-- void		gtk_spin_button_set_value	   (GtkSpinButton  *spin_button,
			-- 						    gfloat	    value);
			-- (from C_GTK_SPIN_BUTTON)
		do
		end

	frozen gtk_spin_button_set_wrap (a_spin_button: POINTER; a_wrap: BOOLEAN) is
			-- void		gtk_spin_button_set_wrap	   (GtkSpinButton  *spin_button,
			-- 						    gboolean	    wrap);
			-- (from C_GTK_SPIN_BUTTON)
		do
		end

	frozen gtk_spin_button_spin (a_spin_button: POINTER; a_direction: INTEGER; a_increment: REAL) is
			-- void		gtk_spin_button_spin		   (GtkSpinButton  *spin_button,
			-- 						    GtkSpinType     direction,
			-- 						    gfloat	    increment);
			-- (from C_GTK_SPIN_BUTTON)
		do
		end

	frozen gtk_spin_button_update (a_spin_button: POINTER) is
			-- void            gtk_spin_button_update             (GtkSpinButton  *spin_button);
			-- (from C_GTK_SPIN_BUTTON)
		do
		end

	frozen gtk_style_apply_default_background (a_style: POINTER; a_window: POINTER; a_set_bg: BOOLEAN; a_state_type: INTEGER; a_area: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void	  gtk_style_apply_default_background (GtkStyle	   *style,
			-- 					      Gdkwindow	   *window,
			-- 					      gboolean	    set_bg,
			-- 					      GtkStateType  state_type,
			-- 					      GdkRectangle *area,
			-- 					      gint	    x,
			-- 					      gint	    y,
			-- 					      gint	    width,
			-- 					      gint	    height);
			-- (from C_GTK_STYLE)
		do
		end

	frozen gtk_style_attach (a_style: POINTER; a_window: POINTER): POINTER is
			-- GtkStyle* gtk_style_attach		     (GtkStyle	    *style,
			-- 					      Gdkwindow	    *window);
			-- (from C_GTK_STYLE)
		do
		end

	frozen gtk_style_copy (a_style: POINTER): POINTER is
			-- GtkStyle* gtk_style_copy		     (GtkStyle	    *style);
			-- (from C_GTK_STYLE)
		do
		end

	frozen gtk_style_detach (a_style: POINTER) is
			-- void	  gtk_style_detach		     (GtkStyle	   *style);
			-- (from C_GTK_STYLE)
		do
		end

	frozen gtk_style_new: POINTER is
			-- GtkStyle* gtk_style_new			     (void);
			-- (from C_GTK_STYLE)
		do
		end

	frozen gtk_style_ref (a_style: POINTER): POINTER is
			-- GtkStyle* gtk_style_ref			     (GtkStyle	   *style);
			-- (from C_GTK_STYLE)
		do
		end

	frozen gtk_style_set_background (a_style: POINTER; a_window: POINTER; a_state_type: INTEGER) is
			-- void	  gtk_style_set_background	     (GtkStyle	   *style,
			-- 					      Gdkwindow	   *window,
			-- 					      GtkStateType  state_type);
			-- (from C_GTK_STYLE)
		do
		end

	frozen gtk_style_unref (a_style: POINTER) is
			-- void	  gtk_style_unref		     (GtkStyle	   *style);
			-- (from C_GTK_STYLE)
		do
		end

	frozen gtk_table_attach (a_table: POINTER; a_child: POINTER; a_left_attach: INTEGER; a_right_attach: INTEGER; a_top_attach: INTEGER; a_bottom_attach: INTEGER; a_xoptions: INTEGER; a_yoptions: INTEGER; a_xpadding: INTEGER; a_ypadding: INTEGER) is
			-- void	   gtk_table_attach	      (GtkTable	       *table,
			-- 				       GtkWidget       *child,
			-- 				       guint		left_attach,
			-- 				       guint		right_attach,
			-- 				       guint		top_attach,
			-- 				       guint		bottom_attach,
			-- 				       GtkAttachOptions xoptions,
			-- 				       GtkAttachOptions yoptions,
			-- 				       guint		xpadding,
			-- 				       guint		ypadding);
			-- (from C_GTK_TABLE)
		do
		end

	frozen gtk_table_attach_defaults (a_table: POINTER; a_widget: POINTER; a_left_attach: INTEGER; a_right_attach: INTEGER; a_top_attach: INTEGER; a_bottom_attach: INTEGER) is
			-- void	   gtk_table_attach_defaults  (GtkTable	       *table,
			-- 				       GtkWidget       *widget,
			-- 				       guint		left_attach,
			-- 				       guint		right_attach,
			-- 				       guint		top_attach,
			-- 				       guint		bottom_attach);
			-- (from C_GTK_TABLE)
		do
		end

	frozen gtk_table_get_type: INTEGER is
			-- GtkType	   gtk_table_get_type	      (void);
			-- (from C_GTK_TABLE)
		do
		end

	frozen gtk_table_new (a_rows: INTEGER; a_columns: INTEGER; a_homogeneous: BOOLEAN): POINTER is
			-- GtkWidget* gtk_table_new	      (guint		rows,
			-- 				       guint		columns,
			-- 				       gboolean		homogeneous);
			-- (from C_GTK_TABLE)
		do
		end

	frozen gtk_table_resize (a_table: POINTER; a_rows: INTEGER; a_columns: INTEGER) is
			-- void	   gtk_table_resize	      (GtkTable	       *table,
			-- 				       guint            rows,
			-- 				       guint            columns);
			-- (from C_GTK_TABLE)
		do
		end

	frozen gtk_table_set_col_spacing (a_table: POINTER; a_column: INTEGER; a_spacing: INTEGER) is
			-- void	   gtk_table_set_col_spacing  (GtkTable	       *table,
			-- 				       guint		column,
			-- 				       guint		spacing);
			-- (from C_GTK_TABLE)
		do
		end

	frozen gtk_table_set_col_spacings (a_table: POINTER; a_spacing: INTEGER) is
			-- void	   gtk_table_set_col_spacings (GtkTable	       *table,
			-- 				       guint		spacing);
			-- (from C_GTK_TABLE)
		do
		end

	frozen gtk_table_set_homogeneous (a_table: POINTER; a_homogeneous: BOOLEAN) is
			-- void	   gtk_table_set_homogeneous  (GtkTable	       *table,
			-- 				       gboolean		homogeneous);
			-- (from C_GTK_TABLE)
		do
		end

	frozen gtk_table_set_row_spacing (a_table: POINTER; a_row: INTEGER; a_spacing: INTEGER) is
			-- void	   gtk_table_set_row_spacing  (GtkTable	       *table,
			-- 				       guint		row,
			-- 				       guint		spacing);
			-- (from C_GTK_TABLE)
		do
		end

	frozen gtk_table_set_row_spacings (a_table: POINTER; a_spacing: INTEGER) is
			-- void	   gtk_table_set_row_spacings (GtkTable	       *table,
			-- 				       guint		spacing);
			-- (from C_GTK_TABLE)
		do
		end

	frozen gtk_timeout_add (a_interval: INTEGER; a_function: POINTER; a_data: POINTER): INTEGER is
			-- guint	   gtk_timeout_add	   (guint32	       interval,
			-- 				    GtkFunction	       function,
			-- 				    gpointer	       data);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_timeout_add_full (a_interval: INTEGER; a_function: POINTER; a_marshal: POINTER; a_data: POINTER; a_destroy: POINTER): INTEGER is
			-- guint	   gtk_timeout_add_full	   (guint32	       interval,
			-- 				    GtkFunction	       function,
			-- 				    GtkCallbackMarshal marshal,
			-- 				    gpointer	       data,
			-- 				    GtkDestroyNotify   destroy);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_timeout_remove (a_timeout_handler_id: INTEGER) is
			-- void	   gtk_timeout_remove	   (guint	       timeout_handler_id);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_toggle_button_get_active (a_toggle_button: POINTER): BOOLEAN is
			-- gboolean   gtk_toggle_button_get_active	    (GtkToggleButton *toggle_button);
			-- (from C_GTK_TOGGLE_BUTTON)
		do
		end

	frozen gtk_toggle_button_get_type: INTEGER is
			-- GtkType    gtk_toggle_button_get_type       (void);
			-- (from C_GTK_TOGGLE_BUTTON)
		do
		end

	frozen gtk_toggle_button_new: POINTER is
			-- GtkWidget* gtk_toggle_button_new            (void);
			-- (from C_GTK_TOGGLE_BUTTON)
		do
		end

	frozen gtk_toggle_button_new_with_label (a_label: POINTER): POINTER is
			-- GtkWidget* gtk_toggle_button_new_with_label (const gchar     *label);
			-- (from C_GTK_TOGGLE_BUTTON)
		do
		end

	frozen gtk_toggle_button_set_active (a_toggle_button: POINTER; a_is_active: BOOLEAN) is
			-- void       gtk_toggle_button_set_active     (GtkToggleButton *toggle_button,
			-- 					     gboolean         is_active);
			-- (from C_GTK_TOGGLE_BUTTON)
		do
		end

	frozen gtk_toggle_button_set_mode (a_toggle_button: POINTER; a_draw_indicator: BOOLEAN) is
			-- void       gtk_toggle_button_set_mode       (GtkToggleButton *toggle_button,
			-- 					     gboolean         draw_indicator);
			-- (from C_GTK_TOGGLE_BUTTON)
		do
		end

	frozen gtk_toggle_button_toggled (a_toggle_button: POINTER) is
			-- void       gtk_toggle_button_toggled        (GtkToggleButton *toggle_button);
			-- (from C_GTK_TOGGLE_BUTTON)
		do
		end

	frozen gtk_tooltips_data_get (a_widget: POINTER): POINTER is
			-- GtkTooltipsData* gtk_tooltips_data_get	   (GtkWidget	  *widget);
			-- (from C_GTK_TOOLTIPS)
		do
		end

	frozen gtk_tooltips_disable (a_tooltips: POINTER) is
			-- void		 gtk_tooltips_disable	   (GtkTooltips   *tooltips);
			-- (from C_GTK_TOOLTIPS)
		do
		end

	frozen gtk_tooltips_enable (a_tooltips: POINTER) is
			-- void		 gtk_tooltips_enable	   (GtkTooltips   *tooltips);
			-- (from C_GTK_TOOLTIPS)
		do
		end

	frozen gtk_tooltips_force_window (a_tooltips: POINTER) is
			-- void             gtk_tooltips_force_window (GtkTooltips   *tooltips);
			-- (from C_GTK_TOOLTIPS)
		do
		end

	frozen gtk_tooltips_get_type: INTEGER is
			-- GtkType		 gtk_tooltips_get_type	   (void);
			-- (from C_GTK_TOOLTIPS)
		do
		end

	frozen gtk_tooltips_new: POINTER is
			-- GtkTooltips*	 gtk_tooltips_new	   (void);
			-- (from C_GTK_TOOLTIPS)
		do
		end

	frozen gtk_tooltips_set_delay (a_tooltips: POINTER; a_delay: INTEGER) is
			-- void		 gtk_tooltips_set_delay	   (GtkTooltips   *tooltips,
			-- 					    guint	   delay);
			-- (from C_GTK_TOOLTIPS)
		do
		end

	frozen gtk_tooltips_set_tip (a_tooltips: POINTER; a_widget: POINTER; a_tip_text: POINTER; a_tip_private: POINTER) is
			-- void		 gtk_tooltips_set_tip	   (GtkTooltips   *tooltips,
			-- 					    GtkWidget	  *widget,
			-- 					    const gchar   *tip_text,
			-- 					    const gchar   *tip_private);
			-- (from C_GTK_TOOLTIPS)
		do
		end

	frozen gtk_true: INTEGER is
			-- gint	   gtk_true		   (void);
			-- (from C_GTK_EXTERNALS)
		do
		end

	frozen gtk_statusbar_new: POINTER is
		do
		end

	frozen gtk_vbox_get_type: INTEGER is
			-- GtkType	   gtk_vbox_get_type (void);
			-- (from C_GTK_VBOX)
		do
		end

	frozen gtk_vbox_new (a_homogeneous: BOOLEAN; a_spacing: INTEGER): POINTER is
			-- GtkWidget* gtk_vbox_new	     (gboolean homogeneous,
			-- 			      gint spacing);
			-- (from C_GTK_VBOX)
		do
		end

	frozen gtk_viewport_get_hadjustment (a_viewport: POINTER): POINTER is
			-- GtkAdjustment* gtk_viewport_get_hadjustment (GtkViewport   *viewport);
			-- (from C_GTK_VIEWPORT)
		do
		end

	frozen gtk_viewport_get_type: INTEGER is
			-- GtkType        gtk_viewport_get_type        (void);
			-- (from C_GTK_VIEWPORT)
		do
		end

	frozen gtk_viewport_get_vadjustment (a_viewport: POINTER): POINTER is
			-- GtkAdjustment* gtk_viewport_get_vadjustment (GtkViewport   *viewport);
			-- (from C_GTK_VIEWPORT)
		do
		end

	frozen gtk_viewport_new (a_hadjustment: POINTER; a_vadjustment: POINTER): POINTER is
			-- GtkWidget*     gtk_viewport_new             (GtkAdjustment *hadjustment,
			-- 					     GtkAdjustment *vadjustment);
			-- (from C_GTK_VIEWPORT)
		do
		end

	frozen gtk_viewport_set_hadjustment (a_viewport: POINTER; a_adjustment: POINTER) is
			-- void           gtk_viewport_set_hadjustment (GtkViewport   *viewport,
			-- 					     GtkAdjustment *adjustment);
			-- (from C_GTK_VIEWPORT)
		do
		end

	frozen gtk_viewport_set_shadow_type (a_viewport: POINTER; a_type: INTEGER) is
			-- void           gtk_viewport_set_shadow_type (GtkViewport   *viewport,
			-- 					     GtkshadowType  type);
			-- (from C_GTK_VIEWPORT)
		do
		end

	frozen gtk_viewport_set_vadjustment (a_viewport: POINTER; a_adjustment: POINTER) is
			-- void           gtk_viewport_set_vadjustment (GtkViewport   *viewport,
			-- 					     GtkAdjustment *adjustment);
			-- (from C_GTK_VIEWPORT)
		do
		end

	frozen gtk_vpaned_get_type: INTEGER is
			-- guint      gtk_vpaned_get_type (void);
			-- (from C_GTK_VPANED)
		do
		end

	frozen gtk_vpaned_new: POINTER is
			-- GtkWidget* gtk_vpaned_new      (void);
			-- (from C_GTK_VPANED)
		do
		end

	frozen gtk_vscale_get_type: INTEGER is
			-- GtkType    gtk_vscale_get_type (void);
			-- (from C_GTK_VSCALE)
		do
		end

	frozen gtk_vscale_new (a_adjustment: POINTER): POINTER is
			-- GtkWidget* gtk_vscale_new      (GtkAdjustment *adjustment);
			-- (from C_GTK_VSCALE)
		do
		end

	frozen gtk_vscrollbar_get_type: INTEGER is
			-- GtkType    gtk_vscrollbar_get_type (void);
			-- (from C_GTK_VSCROLLBAR)
		do
		end

	frozen gtk_vscrollbar_new (a_adjustment: POINTER): POINTER is
			-- GtkWidget* gtk_vscrollbar_new      (GtkAdjustment *adjustment);
			-- (from C_GTK_VSCROLLBAR)
		do
		end

	frozen gtk_vseparator_get_type: INTEGER is
			-- GtkType    gtk_vseparator_get_type (void);
			-- (from C_GTK_VSEPARATOR)
		do
		end

	frozen gtk_vseparator_new: POINTER is
			-- GtkWidget* gtk_vseparator_new      (void);
			-- (from C_GTK_VSEPARATOR)
		do
		end

	frozen gtk_widget_activate (a_widget: POINTER): BOOLEAN is
			-- gboolean   gtk_widget_activate		     (GtkWidget	       *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_add_accelerator (a_widget: POINTER; a_accel_signal: POINTER; a_accel_group: POINTER; a_accel_key: NATURAL_32; a_accel_mods: INTEGER; a_accel_flags: INTEGER) is
			-- void	   gtk_widget_add_accelerator	  (GtkWidget           *widget,
			-- 					   const gchar         *accel_signal,
			-- 					   GtkAccelGroup       *accel_group,
			-- 					   guint                accel_key,
			-- 					   guint                accel_mods,
			-- 					   GtkAccelFlags        accel_flags);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_add_events (a_widget: POINTER; a_events: INTEGER) is
			-- void       gtk_widget_add_events          (GtkWidget           *widget,
			-- 					   gint	                events);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_class_path (a_widget: POINTER; a_path_length: POINTER; a_path: POINTER; a_path_reversed: POINTER) is
			-- void	     gtk_widget_class_path	   (GtkWidget *widget,
			-- 					    guint     *path_length,
			-- 					    gchar    **path,
			-- 					    gchar    **path_reversed);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_destroy (a_widget: POINTER) is
			-- void	   gtk_widget_destroy		  (GtkWidget	       *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_destroyed (a_widget: POINTER; a_widget_pointer: POINTER) is
			-- void	   gtk_widget_destroyed		  (GtkWidget	       *widget,
			-- 					   GtkWidget	      **widget_pointer);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_draw (a_widget: POINTER; a_area: POINTER) is
			-- void	   gtk_widget_draw		  (GtkWidget	       *widget,
			-- 					   GdkRectangle	       *area);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_ensure_style (a_widget: POINTER) is
			-- void	   gtk_widget_ensure_style	(GtkWidget	*widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_event (a_widget: POINTER; a_event: POINTER): BOOLEAN is
		do
		end

	frozen gtk_widget_get_ancestor (a_widget: POINTER; a_widget_type: INTEGER): POINTER is
			-- GtkWidget*   gtk_widget_get_ancestor	(GtkWidget	*widget,
			-- 					 GtkType	widget_type);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_get_child_requisition (a_widget: POINTER; a_requisition: POINTER) is
			-- void       gtk_widget_get_child_requisition (GtkWidget	       *widget,
			-- 					     GtkRequisition    *requisition);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_get_colormap (a_widget: POINTER): POINTER is
			-- GdkColormap* gtk_widget_get_colormap	(GtkWidget	*widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_get_composite_name (a_widget: POINTER): POINTER is
			-- gchar* gtk_widget_get_composite_name	(GtkWidget	*widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_get_default_colormap: POINTER is
			-- GdkColormap* gtk_widget_get_default_colormap (void);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_get_default_style: POINTER is
			-- GtkStyle*    gtk_widget_get_default_style    (void);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_get_default_visual: POINTER is
			-- GdkVisual*   gtk_widget_get_default_visual   (void);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_get_events (a_widget: POINTER): INTEGER is
			-- gint	     gtk_widget_get_events	(GtkWidget	*widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_get_extension_events (a_widget: POINTER): INTEGER is
			-- GdkExtensionMode gtk_widget_get_extension_events (GtkWidget	*widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_get_name (a_widget: POINTER): POINTER is
			-- gchar*	   gtk_widget_get_name		  (GtkWidget	       *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_get_parent_window (a_widget: POINTER): POINTER is
			-- Gdkwindow *gtk_widget_get_parent_window	  (GtkWidget	       *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_get_pointer (a_widget: POINTER; a_x: POINTER; a_y: POINTER) is
			-- void	     gtk_widget_get_pointer	(GtkWidget	*widget,
			-- 					 gint		*x,
			-- 					 gint		*y);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_get_style (a_widget: POINTER): POINTER is
			-- GtkStyle*  gtk_widget_get_style		(GtkWidget	*widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_get_toplevel (a_widget: POINTER): POINTER is
			-- GtkWidget*   gtk_widget_get_toplevel	(GtkWidget	*widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_get_type: INTEGER is
			-- GtkType	   gtk_widget_get_type		  (void);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_get_visual (a_widget: POINTER): POINTER is
			-- GdkVisual*   gtk_widget_get_visual	(GtkWidget	*widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_grab_default (a_widget: POINTER) is
			-- void	   gtk_widget_grab_default	  (GtkWidget	       *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_grab_focus (a_widget: POINTER) is
			-- void	   gtk_widget_grab_focus	  (GtkWidget	       *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_hide (a_widget: POINTER) is
			-- void	   gtk_widget_hide		  (GtkWidget	       *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_hide_all (a_widget: POINTER) is
			-- void	   gtk_widget_hide_all		  (GtkWidget	       *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_hide_on_delete (a_widget: POINTER): INTEGER is
			-- gint	   gtk_widget_hide_on_delete	(GtkWidget	*widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_intersect (a_widget: POINTER; a_area: POINTER; a_intersection: POINTER): INTEGER is
			-- gint	   gtk_widget_intersect		  (GtkWidget	       *widget,
			-- 					   GdkRectangle	       *area,
			-- 					   GdkRectangle	       *intersection);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_is_ancestor (a_widget: POINTER; a_ancestor: POINTER): INTEGER is
			-- gint	     gtk_widget_is_ancestor	(GtkWidget	*widget,
			-- 					 GtkWidget	*ancestor);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_map (a_widget: POINTER) is
			-- void	   gtk_widget_map		  (GtkWidget	       *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_modify_style (a_widget: POINTER; a_style: POINTER) is
			-- void       gtk_widget_modify_style      (GtkWidget      *widget,
			-- 					 GtkRcStyle     *style);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_path (a_widget: POINTER; a_path_length: POINTER; a_path: POINTER; a_path_reversed: POINTER) is
			-- void	     gtk_widget_path		   (GtkWidget *widget,
			-- 					    guint     *path_length,
			-- 					    gchar    **path,
			-- 					    gchar    **path_reversed);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_pop_colormap is
			-- void	     gtk_widget_pop_colormap	     (void);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_pop_composite_child is
			-- void	     gtk_widget_pop_composite_child  (void);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_push_colormap (a_cmap: POINTER) is
			-- void	     gtk_widget_push_colormap	     (GdkColormap *cmap);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_push_composite_child is
			-- void	     gtk_widget_push_composite_child (void);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_queue_clear (a_widget: POINTER) is
			-- void	   gtk_widget_queue_clear	  (GtkWidget	       *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_queue_clear_area (a_widget: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void	   gtk_widget_queue_clear_area	  (GtkWidget	       *widget,
			-- 					   gint                 x,
			-- 					   gint                 y,
			-- 					   gint                 width,
			-- 					   gint                 height);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_queue_draw (a_widget: POINTER) is
			-- void	   gtk_widget_queue_draw	  (GtkWidget	       *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_queue_draw_area (a_widget: POINTER; a_x: INTEGER; a_y: INTEGER; a_width: INTEGER; a_height: INTEGER) is
			-- void	   gtk_widget_queue_draw_area	  (GtkWidget	       *widget,
			-- 					   gint                 x,
			-- 					   gint                 y,
			-- 					   gint                 width,
			-- 					   gint                 height);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_queue_resize (a_widget: POINTER) is
			-- void	   gtk_widget_queue_resize	  (GtkWidget	       *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_realize (a_widget: POINTER) is
			-- void	   gtk_widget_realize		  (GtkWidget	       *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_ref (a_widget: POINTER) is
			-- void	   gtk_widget_ref		  (GtkWidget	       *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_remove_accelerator (a_widget: POINTER; a_accel_group: POINTER; a_accel_key: NATURAL_32; a_accel_mods: INTEGER) is
			-- void	   gtk_widget_remove_accelerator  (GtkWidget           *widget,
			-- 					   GtkAccelGroup       *accel_group,
			-- 					   guint                accel_key,
			-- 					   guint                accel_mods);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_reparent (a_widget: POINTER; a_new_parent: POINTER) is
			-- void	   gtk_widget_reparent		  (GtkWidget	       *widget,
			-- 					   GtkWidget	       *new_parent);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_reset_rc_styles (a_widget: POINTER) is
			-- void       gtk_widget_reset_rc_styles   (GtkWidget      *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_reset_shapes (a_widget: POINTER) is
			-- void	     gtk_widget_reset_shapes	   (GtkWidget *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_set_app_paintable (a_widget: POINTER; a_app_paintable: BOOLEAN) is
			-- void	   gtk_widget_set_app_paintable	  (GtkWidget	       *widget,
			-- 					   gboolean		app_paintable);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_set_colormap (a_widget: POINTER; a_colormap: POINTER) is
			-- void         gtk_widget_set_colormap    (GtkWidget      *widget,
			-- 					 GdkColormap    *colormap);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_set_composite_name (a_widget: POINTER; a_name: POINTER) is
			-- void   gtk_widget_set_composite_name	(GtkWidget	*widget,
			-- 					 const gchar   	*name);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_set_default_colormap (a_colormap: POINTER) is
			-- void	     gtk_widget_set_default_colormap (GdkColormap *colormap);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_set_events (a_widget: POINTER; a_events: INTEGER) is
			-- void	   gtk_widget_set_events	  (GtkWidget	       *widget,
			-- 					   gint			events);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_set_extension_events (a_widget: POINTER; a_mode: INTEGER) is
			-- void	   gtk_widget_set_extension_events (GtkWidget		*widget,
			-- 					    GdkExtensionMode	mode);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_set_name (a_widget: POINTER; a_name: POINTER) is
			-- void	   gtk_widget_set_name		  (GtkWidget	       *widget,
			-- 					   const gchar	       *name);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_set_parent (a_widget: POINTER; a_parent: POINTER) is
			-- void	   gtk_widget_set_parent	  (GtkWidget	       *widget,
			-- 					   GtkWidget	       *parent);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_set_parent_window (a_widget: POINTER; a_parent_window: POINTER) is
			-- void	   gtk_widget_set_parent_window	  (GtkWidget	       *widget,
			-- 					   Gdkwindow	       *parent_window);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_set_scroll_adjustments (a_widget: POINTER; a_hadjustment: POINTER; a_vadjustment: POINTER): BOOLEAN is
			-- gboolean   gtk_widget_set_scroll_adjustments (GtkWidget        *widget,
			-- 					      GtkAdjustment    *hadjustment,
			-- 					      GtkAdjustment    *vadjustment);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_set_sensitive (a_widget: POINTER; a_sensitive: BOOLEAN) is
			-- void	   gtk_widget_set_sensitive	  (GtkWidget	       *widget,
			-- 					   gboolean		sensitive);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_set_state (a_widget: POINTER; a_state: INTEGER) is
			-- void	   gtk_widget_set_state		  (GtkWidget	       *widget,
			-- 					   GtkStateType		state);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_set_style (a_widget: POINTER; a_style: POINTER) is
			-- void	   gtk_widget_set_style		(GtkWidget	*widget,
			-- 					 GtkStyle	*style);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_set_uposition (a_widget: POINTER; a_x: INTEGER; a_y: INTEGER) is
			-- void	   gtk_widget_set_uposition	  (GtkWidget	       *widget,
			-- 					   gint			x,
			-- 					   gint			y);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_set_usize (a_widget: POINTER; a_width: INTEGER; a_height: INTEGER) is
			-- void	   gtk_widget_set_usize		  (GtkWidget	       *widget,
			-- 					   gint			width,
			-- 					   gint			height);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_shape_combine_mask (a_widget: POINTER; a_shape_mask: POINTER; a_offset_x: INTEGER; a_offset_y: INTEGER) is
			-- void	     gtk_widget_shape_combine_mask (GtkWidget *widget,
			-- 					    GdkBitmap *shape_mask,
			-- 					    gint       offset_x,
			-- 					    gint       offset_y);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_show (a_widget: POINTER) is
			-- void	   gtk_widget_show		  (GtkWidget	       *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_show_all (a_widget: POINTER) is
			-- void	   gtk_widget_show_all		  (GtkWidget	       *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_show_now (a_widget: POINTER) is
			-- void       gtk_widget_show_now            (GtkWidget           *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_size_request (a_widget: POINTER; a_requisition: POINTER) is
			-- void	   gtk_widget_size_request	  (GtkWidget	       *widget,
			-- 					   GtkRequisition      *requisition);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_unmap (a_widget: POINTER) is
			-- void	   gtk_widget_unmap		  (GtkWidget	       *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_unparent (a_widget: POINTER) is
			-- void	   gtk_widget_unparent		  (GtkWidget	       *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_unrealize (a_widget: POINTER) is
			-- void	   gtk_widget_unrealize		  (GtkWidget	       *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_widget_unref (a_widget: POINTER) is
			-- void	   gtk_widget_unref		  (GtkWidget	       *widget);
			-- (from C_GTK_WIDGET)
		do
		end

	frozen gtk_window_activate_default (a_window: POINTER): INTEGER is
			-- gint	   gtk_window_activate_default	       (Gtkwindow           *window);
			-- (from C_GTK_window)
		do
		end

	frozen gtk_window_activate_focus (a_window: POINTER): INTEGER is
			-- gint	   gtk_window_activate_focus	       (Gtkwindow           *window);
			-- (from C_GTK_window)
		do
		end

	frozen gtk_window_add_accel_group (a_window: POINTER; a_accel_group: POINTER) is
			-- void       gtk_window_add_accel_group          (Gtkwindow           *window,
			-- 						GtkAccelGroup	    *accel_group);
			-- (from C_GTK_window)
		do
		end

	frozen gtk_window_add_embedded_xid (a_window: POINTER; a_xid: INTEGER) is
			-- void       gtk_window_add_embedded_xid         (Gtkwindow           *window,
			-- 						guint                xid);
			-- (from C_GTK_window)
		do
		end

	frozen gtk_window_get_type: INTEGER is
			-- GtkType    gtk_window_get_type                 (void);
			-- (from C_GTK_window)
		do
		end

	frozen gtk_window_new (a_type: INTEGER): POINTER is
			-- GtkWidget* gtk_window_new                      (GtkwindowType        type);
			-- (from C_GTK_window)
		do
		end

	frozen gtk_window_remove_accel_group (a_window: POINTER; a_accel_group: POINTER) is
			-- void       gtk_window_remove_accel_group       (Gtkwindow           *window,
			-- 						GtkAccelGroup	    *accel_group);
			-- (from C_GTK_window)
		do
		end

	frozen gtk_window_remove_embedded_xid (a_window: POINTER; a_xid: INTEGER) is
			-- void       gtk_window_remove_embedded_xid      (Gtkwindow           *window,
			-- 				                guint                xid);
			-- (from C_GTK_window)
		do
		end

	frozen gtk_window_set_default (a_window: POINTER; a_defaultw: POINTER) is
			-- void       gtk_window_set_default              (Gtkwindow           *window,
			-- 						GtkWidget           *defaultw);
			-- (from C_GTK_window)
		do
		end

	frozen gtk_window_set_default_size (a_window: POINTER; a_width: INTEGER; a_height: INTEGER) is
			-- void       gtk_window_set_default_size         (Gtkwindow           *window,
			-- 						gint                 width,
			-- 						gint                 height);
			-- (from C_GTK_window)
		do
		end

	frozen gtk_window_set_focus (a_window: POINTER; a_focus: POINTER) is
			-- void       gtk_window_set_focus                (Gtkwindow           *window,
			-- 						GtkWidget           *focus);
			-- (from C_GTK_window)
		do
		end

	frozen gtk_window_set_geometry_hints (a_window: POINTER; a_geometry_widget: POINTER; a_geometry: POINTER; a_geom_mask: INTEGER) is
			-- void       gtk_window_set_geometry_hints       (Gtkwindow           *window,
			-- 						GtkWidget           *geometry_widget,
			-- 						GdkGeometry         *geometry,
			-- 						GdkwindowHints       geom_mask);
			-- (from C_GTK_window)
		do
		end

	frozen gtk_window_set_modal (a_window: POINTER; a_modal: BOOLEAN) is
			-- void       gtk_window_set_modal                (Gtkwindow           *window,
			--                                                 gboolean             modal);
			-- (from C_GTK_window)
		do
		end

	frozen gtk_window_set_policy (a_window: POINTER; a_allow_shrink: INTEGER; a_allow_grow: INTEGER; a_auto_shrink: INTEGER) is
			-- void       gtk_window_set_policy               (Gtkwindow           *window,
			-- 						gint                 allow_shrink,
			-- 						gint                 allow_grow,
			-- 						gint                 auto_shrink);
			-- (from C_GTK_window)
		do
		end

	frozen gtk_window_set_position (a_window: POINTER; a_position: INTEGER) is
			-- void       gtk_window_set_position             (Gtkwindow           *window,
			-- 						GtkwindowPosition    position);
			-- (from C_GTK_window)
		do
		end

	frozen gtk_window_set_title (a_window: POINTER; a_title: POINTER) is
			-- void       gtk_window_set_title                (Gtkwindow           *window,
			-- 						const gchar         *title);
			-- (from C_GTK_window)
		do
		end

	frozen gtk_window_set_transient_for (a_window: POINTER; a_parent: POINTER) is
			-- void       gtk_window_set_transient_for        (Gtkwindow           *window,
			-- 						Gtkwindow           *parent);
			-- (from C_GTK_window)
		do
		end

	frozen gtk_window_set_wmclass (a_window: POINTER; a_wmclass_name: POINTER; a_wmclass_class: POINTER) is
			-- void       gtk_window_set_wmclass              (Gtkwindow           *window,
			-- 						const gchar         *wmclass_name,
			-- 						const gchar         *wmclass_class);
			-- (from C_GTK_window)
		do
		end

feature -- External C structs

	frozen gdk_color_struct_blue (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_COLOR_STRUCT)
		do
		end

	frozen gdk_color_struct_green (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_COLOR_STRUCT)
		do
		end

	frozen gdk_color_struct_pixel (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_COLOR_STRUCT)
		do
		end

	frozen gdk_color_struct_red (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_COLOR_STRUCT)
		do
		end

	frozen gdk_colormap_struct_colors (a_c_struct: POINTER): POINTER is
			-- (from C_GDK_COLORMAP_STRUCT)
		do
		end

	frozen gdk_colormap_struct_size (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_COLORMAP_STRUCT)
		do
		end

	frozen gdk_event_any_struct_send_event (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_ANY_STRUCT)
		do
		end

	frozen gdk_event_any_struct_type (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_ANY_STRUCT)
		do
		end

	frozen gdk_event_button_struct_button (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_BUTTON_STRUCT)
		do
		end

	frozen gdk_event_button_struct_window (a_c_struct: POINTER): POINTER is
		do
		end

	frozen gdk_event_button_struct_send_event (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_BUTTON_STRUCT)
		do
		end

	frozen gdk_event_button_struct_state (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_BUTTON_STRUCT)
		do
		end

	frozen gdk_event_button_struct_time (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_BUTTON_STRUCT)
		do
		end

	frozen gdk_event_button_struct_type (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_BUTTON_STRUCT)
		do
		end

	frozen gdk_event_button_struct_x (a_c_struct: POINTER): 		doUBLE is
			-- (from C_GDK_EVENT_BUTTON_STRUCT)
		do
		end

	frozen gdk_event_button_struct_x_root (a_c_struct: POINTER): 		doUBLE is
			-- (from C_GDK_EVENT_BUTTON_STRUCT)
		do
		end

	frozen gdk_event_button_struct_y (a_c_struct: POINTER): 		doUBLE is
			-- (from C_GDK_EVENT_BUTTON_STRUCT)
		do
		end

	frozen gdk_event_button_struct_y_root (a_c_struct: POINTER): 		doUBLE is
			-- (from C_GDK_EVENT_BUTTON_STRUCT)
		do
		end

	frozen gdk_event_configure_struct_height (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_CONFIGURE_STRUCT)
		do
		end

	frozen gdk_event_configure_struct_send_event (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_CONFIGURE_STRUCT)
		do
		end

	frozen gdk_event_configure_struct_type (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_CONFIGURE_STRUCT)
		do
		end

	frozen gdk_event_configure_struct_width (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_CONFIGURE_STRUCT)
		do
		end

	frozen gdk_event_configure_struct_window (a_c_struct: POINTER): POINTER is
			-- (from C_GDK_EVENT_CONFIGURE_STRUCT)
		do
		end

	frozen gdk_event_configure_struct_x (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_CONFIGURE_STRUCT)
		do
		end

	frozen gdk_event_configure_struct_y (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_CONFIGURE_STRUCT)
		do
		end

	frozen gdk_event_expose_struct_area (a_c_struct: POINTER): POINTER is
			-- Pointer to GdkRectangle.
			-- (from C_GDK_EVENT_EXPOSE_STRUCT)
		do
		end

	frozen gdk_event_expose_struct_count (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_EXPOSE_STRUCT)
		do
		end

	frozen gdk_event_expose_struct_send_event (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_EXPOSE_STRUCT)
		do
		end

	frozen gdk_event_expose_struct_type (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_EXPOSE_STRUCT)
		do
		end

	frozen gdk_event_expose_struct_window (a_c_struct: POINTER): POINTER is
			-- (from C_GDK_EVENT_EXPOSE_STRUCT)
		do
		end

	frozen gdk_event_key_struct_keyval (a_c_struct: POINTER): NATURAL_32 is
			-- (from C_GDK_EVENT_KEY_STRUCT)
		do
		end

	frozen gdk_event_key_struct_length (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_KEY_STRUCT)
		do
		end

	frozen gdk_event_key_struct_send_event (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_KEY_STRUCT)
		do
		end

	frozen gdk_event_key_struct_state (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_KEY_STRUCT)
		do
		end

	frozen gdk_event_key_struct_string (a_c_struct: POINTER): POINTER is
			-- (from C_GDK_EVENT_KEY_STRUCT)
		do
		end

	frozen gdk_event_key_struct_time (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_KEY_STRUCT)
		do
		end

	frozen gdk_event_key_struct_type (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_KEY_STRUCT)
		do
		end

	frozen gdk_event_key_struct_window (a_c_struct: POINTER): POINTER is
			-- (from C_GDK_EVENT_KEY_STRUCT)
		do
		end

	frozen gdk_event_motion_struct_is_hint (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_MOTION_STRUCT)
		do
		end

	frozen gdk_event_motion_struct_send_event (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_MOTION_STRUCT)
		do
		end

	frozen gdk_event_motion_struct_state (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_MOTION_STRUCT)
		do
		end

	frozen gdk_event_motion_struct_time (a_c_struct: POINTER): NATURAL_32 is
			-- (from C_GDK_EVENT_MOTION_STRUCT)
		do
		end

	frozen gdk_event_motion_struct_type (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_EVENT_MOTION_STRUCT)
		do
		end

	frozen gdk_event_motion_struct_window (a_c_struct: POINTER): POINTER is
			-- (from C_GDK_EVENT_MOTION_STRUCT)
		do
		end

	frozen gdk_event_motion_struct_x (a_c_struct: POINTER): 		doUBLE is
			-- (from C_GDK_EVENT_MOTION_STRUCT)
		do
		end

	frozen gdk_event_motion_struct_x_root (a_c_struct: POINTER): 		doUBLE is
			-- (from C_GDK_EVENT_MOTION_STRUCT)
		do
		end

	frozen gdk_event_motion_struct_y (a_c_struct: POINTER): 		doUBLE is
			-- (from C_GDK_EVENT_MOTION_STRUCT)
		do
		end

	frozen gdk_event_motion_struct_y_root (a_c_struct: POINTER): 		doUBLE is
			-- (from C_GDK_EVENT_MOTION_STRUCT)
		do
		end

	frozen gdk_event_dnd_struct_context (a_c_struct: POINTER): POINTER is
		do
		end

	frozen gdk_event_dnd_struct_time (a_c_struct: POINTER): NATURAL_32 is
		do
		end

	frozen gdk_font_struct_ascent (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_FONT_STRUCT)
		do
		end

	frozen gdk_font_struct_descent (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_FONT_STRUCT)
		do
		end

	frozen gdk_font_struct_type (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_FONT_STRUCT)
		do
		end

	frozen gdk_gcvalues_struct_background (a_c_struct: POINTER): POINTER is
			-- Pointer to GdkColor.
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen gdk_gcvalues_struct_cap_style (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen gdk_gcvalues_struct_clip_mask (a_c_struct: POINTER): POINTER is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen gdk_gcvalues_struct_clip_x_origin (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen gdk_gcvalues_struct_clip_y_origin (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen gdk_gcvalues_struct_fill (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen gdk_gcvalues_struct_font (a_c_struct: POINTER): POINTER is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen gdk_gcvalues_struct_foreground (a_c_struct: POINTER): POINTER is
			-- Pointer to GdkColor.
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen gdk_gcvalues_struct_function (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen gdk_gcvalues_struct_graphics_exposures (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen gdk_gcvalues_struct_join_style (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen gdk_gcvalues_struct_line_style (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen gdk_gcvalues_struct_line_width (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen gdk_gcvalues_struct_stipple (a_c_struct: POINTER): POINTER is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen gdk_gcvalues_struct_subwindow_mode (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen gdk_gcvalues_struct_tile (a_c_struct: POINTER): POINTER is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen gdk_gcvalues_struct_ts_x_origin (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen gdk_gcvalues_struct_ts_y_origin (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen gdk_geometry_struct_base_height (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_GEOMETRY_STRUCT)
		do
		end

	frozen gdk_geometry_struct_base_width (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_GEOMETRY_STRUCT)
		do
		end

	frozen gdk_geometry_struct_height_inc (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_GEOMETRY_STRUCT)
		do
		end

	frozen gdk_geometry_struct_max_aspect (a_c_struct: POINTER): 		doUBLE is
			-- (from C_GDK_GEOMETRY_STRUCT)
		do
		end

	frozen gdk_geometry_struct_max_height (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_GEOMETRY_STRUCT)
		do
		end

	frozen gdk_geometry_struct_max_width (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_GEOMETRY_STRUCT)
		do
		end

	frozen gdk_geometry_struct_min_aspect (a_c_struct: POINTER): 		doUBLE is
			-- (from C_GDK_GEOMETRY_STRUCT)
		do
		end

	frozen gdk_geometry_struct_min_height (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_GEOMETRY_STRUCT)
		do
		end

	frozen gdk_geometry_struct_min_width (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_GEOMETRY_STRUCT)
		do
		end

	frozen gdk_geometry_struct_width_inc (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_GEOMETRY_STRUCT)
		do
		end

	frozen gdk_point_struct_x (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_POINT_STRUCT)
		do
		end

	frozen gdk_point_struct_y (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_POINT_STRUCT)
		do
		end

	frozen gdk_rectangle_struct_height (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_RECTANGLE_STRUCT)
		do
		end

	frozen gdk_rectangle_struct_width (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_RECTANGLE_STRUCT)
		do
		end

	frozen gdk_rectangle_struct_x (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_RECTANGLE_STRUCT)
		do
		end

	frozen gdk_rectangle_struct_y (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_RECTANGLE_STRUCT)
		do
		end

	frozen gdk_visual_struct_bits_per_rgb (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen gdk_visual_struct_blue_mask (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen gdk_visual_struct_blue_prec (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen gdk_visual_struct_blue_shift (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen gdk_visual_struct_byte_order (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen gdk_visual_struct_colormap_size (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen gdk_visual_struct_depth (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen gdk_visual_struct_green_mask (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen gdk_visual_struct_green_prec (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen gdk_visual_struct_green_shift (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen gdk_visual_struct_red_mask (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen gdk_visual_struct_red_prec (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen gdk_visual_struct_red_shift (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen gdk_visual_struct_type (a_c_struct: POINTER): INTEGER is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen glist_struct_data (a_c_struct: POINTER): POINTER is
			-- (from C_GLIST_STRUCT)
		do
		end

	frozen glist_struct_next (a_c_struct: POINTER): POINTER is
			-- (from C_GLIST_STRUCT)
		do
		end

	frozen glist_struct_prev (a_c_struct: POINTER): POINTER is
			-- (from C_GLIST_STRUCT)
		do
		end

	frozen gslist_struct_data (a_c_struct: POINTER): POINTER is
			-- (from C_GSLIST_STRUCT)
		do
		end

	frozen gslist_struct_next (a_c_struct: POINTER): POINTER is
			-- (from C_GSLIST_STRUCT)
		do
		end

	frozen gtk_adjustment_struct_lower (a_c_struct: POINTER): REAL is
			-- (from C_GTK_ADJUSTMENT_STRUCT)
		do
		end

	frozen gtk_adjustment_struct_page_increment (a_c_struct: POINTER): REAL is
			-- (from C_GTK_ADJUSTMENT_STRUCT)
		do
		end

	frozen gtk_adjustment_struct_page_size (a_c_struct: POINTER): REAL is
			-- (from C_GTK_ADJUSTMENT_STRUCT)
		do
		end

	frozen gtk_adjustment_struct_step_increment (a_c_struct: POINTER): REAL is
			-- (from C_GTK_ADJUSTMENT_STRUCT)
		do
		end

	frozen gtk_adjustment_struct_upper (a_c_struct: POINTER): REAL is
			-- (from C_GTK_ADJUSTMENT_STRUCT)
		do
		end

	frozen gtk_adjustment_struct_value (a_c_struct: POINTER): REAL is
			-- (from C_GTK_ADJUSTMENT_STRUCT)
		do
		end

	frozen gtk_alignment_struct_bin (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkBin.
			-- (from C_GTK_ALIGNMENT_STRUCT)
		do
		end

	frozen gtk_alignment_struct_xalign (a_c_struct: POINTER): REAL is
			-- (from C_GTK_ALIGNMENT_STRUCT)
		do
		end

	frozen gtk_alignment_struct_xscale (a_c_struct: POINTER): REAL is
			-- (from C_GTK_ALIGNMENT_STRUCT)
		do
		end

	frozen gtk_alignment_struct_yalign (a_c_struct: POINTER): REAL is
			-- (from C_GTK_ALIGNMENT_STRUCT)
		do
		end

	frozen gtk_alignment_struct_yscale (a_c_struct: POINTER): REAL is
			-- (from C_GTK_ALIGNMENT_STRUCT)
		do
		end

	frozen gtk_allocation_struct_height (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_ALLOCATION_STRUCT)
		do
		end

	frozen gtk_allocation_struct_width (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_ALLOCATION_STRUCT)
		do
		end

	frozen gtk_allocation_struct_x (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_ALLOCATION_STRUCT)
		do
		end

	frozen gtk_allocation_struct_y (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_ALLOCATION_STRUCT)
		do
		end

	frozen gtk_bin_struct_child (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_BIN_STRUCT)
		do
		end

	frozen gtk_bin_struct_container (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkContainer.
			-- (from C_GTK_BIN_STRUCT)
		do
		end

	frozen gtk_box_struct_children (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_BOX_STRUCT)
		do
		end

	frozen gtk_box_struct_container (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkContainer.
			-- (from C_GTK_BOX_STRUCT)
		do
		end

	frozen gtk_box_struct_homogeneous (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_BOX_STRUCT)
		do
		end

	frozen gtk_box_struct_spacing (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_BOX_STRUCT)
		do
		end

	frozen gtk_button_struct_bin (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkBin.
			-- (from C_GTK_BUTTON_STRUCT)
		do
		end

	frozen gtk_button_struct_button_down (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_BUTTON_STRUCT)
		do
		end

	frozen gtk_button_struct_in_button (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_BUTTON_STRUCT)
		do
		end

	frozen gtk_button_struct_relief (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_BUTTON_STRUCT)
		do
		end

	frozen gtk_check_button_struct_toggle_button (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkToggleButton.
			-- (from C_GTK_CHECK_BUTTON_STRUCT)
		do
		end

	frozen gtk_check_menu_item_struct_active (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CHECK_MENU_ITEM_STRUCT)
		do
		end

	frozen gtk_check_menu_item_struct_always_show_toggle (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CHECK_MENU_ITEM_STRUCT)
		do
		end

	frozen gtk_check_menu_item_struct_menu_item (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkMenuItem.
			-- (from C_GTK_CHECK_MENU_ITEM_STRUCT)
		do
		end

	frozen gtk_clist_cell_info_struct_column (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_CELL_INFO_STRUCT)
		do
		end

	frozen gtk_clist_cell_info_struct_row (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_CELL_INFO_STRUCT)
		do
		end

	frozen gtk_clist_row_struct_background (a_c_struct: POINTER): POINTER is
			-- Pointer to GdkColor.
			-- (from C_GTK_CLIST_ROW_STRUCT)
		do
		end

	frozen gtk_clist_row_struct_bg_set (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_ROW_STRUCT)
		do
		end

	frozen gtk_clist_row_struct_cell (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_ROW_STRUCT)
		do
		end

	frozen gtk_clist_row_struct_data (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_ROW_STRUCT)
		do
		end

	frozen gtk_clist_row_struct_destroy (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_ROW_STRUCT)
		do
		end

	frozen gtk_clist_row_struct_fg_set (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_ROW_STRUCT)
		do
		end

	frozen gtk_clist_row_struct_foreground (a_c_struct: POINTER): POINTER is
			-- Pointer to GdkColor.
			-- (from C_GTK_CLIST_ROW_STRUCT)
		do
		end

	frozen gtk_clist_row_struct_selectable (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_ROW_STRUCT)
		do
		end

	frozen gtk_clist_row_struct_state (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_ROW_STRUCT)
		do
		end

	frozen gtk_clist_row_struct_style (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_ROW_STRUCT)
		do
		end

	frozen gtk_clist_struct_anchor (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_anchor_state (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_bg_gc (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_button_actions (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_cell_mem_chunk (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_click_cell (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkCListCellInfo.
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_clist_window (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_clist_window_height (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_clist_window_width (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_column (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_column_title_area (a_c_struct: POINTER): POINTER is
			-- Pointer to GdkRectangle.
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_columns (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_compare (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_container (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkContainer.
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_cursor_drag (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_drag_button (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_drag_pos (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_fg_gc (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_flags (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_focus_row (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_freeze_count (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_hadjustment (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_hoffset (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_htimer (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_internal_allocation (a_c_struct: POINTER): POINTER is
			-- Pointer to GdkRectangle.
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_row_height (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_row_list (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_row_list_end (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_row_mem_chunk (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_rows (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_selection (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_selection_end (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_selection_mode (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_shadow_type (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_sort_column (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_sort_type (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_title_window (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_undo_anchor (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_undo_selection (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_undo_unselection (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_vadjustment (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_voffset (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_vtimer (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_x_drag (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_clist_struct_xor_gc (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen gtk_color_selection_dialog_struct_cancel_button (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_COLOR_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen gtk_color_selection_dialog_struct_colorsel (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_COLOR_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen gtk_color_selection_dialog_struct_help_button (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_COLOR_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen gtk_color_selection_dialog_struct_ok_button (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_COLOR_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen gtk_combo_struct_activate_id (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen gtk_combo_struct_button (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen gtk_combo_struct_case_sensitive (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen gtk_combo_struct_current_button (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen gtk_combo_struct_entry (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen gtk_combo_struct_entry_change_id (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen gtk_combo_struct_hbox (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkHBox.
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen gtk_combo_struct_list (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen gtk_combo_struct_list_change_id (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen gtk_combo_struct_ok_if_empty (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen gtk_combo_struct_popup (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen gtk_combo_struct_popwin (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen gtk_combo_struct_use_arrows (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen gtk_combo_struct_use_arrows_always (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen gtk_combo_struct_value_in_list (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen gtk_container_struct_border_width (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CONTAINER_STRUCT)
		do
		end

	frozen gtk_container_struct_focus_child (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CONTAINER_STRUCT)
		do
		end

	frozen gtk_container_struct_need_resize (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CONTAINER_STRUCT)
		do
		end

	frozen gtk_container_struct_reallocate_redraws (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CONTAINER_STRUCT)
		do
		end

	frozen gtk_container_struct_resize_mode (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CONTAINER_STRUCT)
		do
		end

	frozen gtk_container_struct_widget (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkWidget.
			-- (from C_GTK_CONTAINER_STRUCT)
		do
		end

	frozen gtk_ctree_row_struct_children (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CTREE_ROW_STRUCT)
		do
		end

	frozen gtk_ctree_row_struct_expanded (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CTREE_ROW_STRUCT)
		do
		end

	frozen gtk_ctree_row_struct_is_leaf (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CTREE_ROW_STRUCT)
		do
		end

	frozen gtk_ctree_row_struct_level (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CTREE_ROW_STRUCT)
		do
		end

	frozen gtk_ctree_row_struct_mask_closed (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CTREE_ROW_STRUCT)
		do
		end

	frozen gtk_ctree_row_struct_mask_opened (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CTREE_ROW_STRUCT)
		do
		end

	frozen gtk_ctree_row_struct_parent (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CTREE_ROW_STRUCT)
		do
		end

	frozen gtk_ctree_row_struct_pixmap_closed (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CTREE_ROW_STRUCT)
		do
		end

	frozen gtk_ctree_row_struct_pixmap_opened (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CTREE_ROW_STRUCT)
		do
		end

	frozen gtk_ctree_row_struct_row (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkCListRow.
			-- (from C_GTK_CTREE_ROW_STRUCT)
		do
		end

	frozen gtk_ctree_row_struct_sibling (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CTREE_ROW_STRUCT)
		do
		end

	frozen gtk_ctree_struct_clist (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkCList.
			-- (from C_GTK_CTREE_STRUCT)
		do
		end

	frozen gtk_ctree_struct_drag_compare (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CTREE_STRUCT)
		do
		end

	frozen gtk_ctree_struct_expander_style (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CTREE_STRUCT)
		do
		end

	frozen gtk_ctree_struct_line_style (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CTREE_STRUCT)
		do
		end

	frozen gtk_ctree_struct_lines_gc (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_CTREE_STRUCT)
		do
		end

	frozen gtk_ctree_struct_show_stub (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CTREE_STRUCT)
		do
		end

	frozen gtk_ctree_struct_tree_column (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CTREE_STRUCT)
		do
		end

	frozen gtk_ctree_struct_tree_indent (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CTREE_STRUCT)
		do
		end

	frozen gtk_ctree_struct_tree_spacing (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_CTREE_STRUCT)
		do
		end

	frozen gtk_dialog_struct_action_area (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_DIALOG_STRUCT)
		do
		end

	frozen gtk_dialog_struct_vbox (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_DIALOG_STRUCT)
		do
		end

	frozen gtk_dialog_struct_window (a_c_struct: POINTER): POINTER is
			-- Pointer to Gtkwindow.
			-- (from C_GTK_DIALOG_STRUCT)
		do
		end

	frozen gtk_drawing_area_struct_draw_data (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_DRAWING_AREA_STRUCT)
		do
		end

	frozen gtk_drawing_area_struct_widget (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkWidget.
			-- (from C_GTK_DRAWING_AREA_STRUCT)
		do
		end

	frozen gtk_entry_struct_text_area (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_ENTRY_STRUCT)
		do
		end

	frozen gtk_entry_struct_text_max_length (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_ENTRY_STRUCT)
		do
		end

	frozen gtk_file_selection_struct_cancel_button (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen gtk_file_selection_struct_dir_list (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen gtk_file_selection_struct_file_list (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen gtk_file_selection_struct_fileop_del_file (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen gtk_file_selection_struct_fileop_ren_file (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen gtk_file_selection_struct_ok_button (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen gtk_file_selection_struct_selection_entry (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen gtk_file_selection_struct_selection_text (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen gtk_fixed_struct_children (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_FIXED_STRUCT)
		do
		end

	frozen gtk_fixed_struct_container (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkContainer.
			-- (from C_GTK_FIXED_STRUCT)
		do
		end

	frozen gtk_font_selection_dialog_struct_action_area (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_FONT_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen gtk_font_selection_dialog_struct_apply_button (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_FONT_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen gtk_font_selection_dialog_struct_auto_resize (a_c_struct: POINTER): BOOLEAN is
			-- (from C_GTK_FONT_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen gtk_font_selection_dialog_struct_cancel_button (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_FONT_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen gtk_font_selection_dialog_struct_dialog_width (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_FONT_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen gtk_font_selection_dialog_struct_fontsel (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_FONT_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen gtk_font_selection_dialog_struct_ok_button (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_FONT_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen gtk_frame_struct_shadow_type (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_FRAME_STRUCT)
		do
		end

	frozen gtk_hbox_struct_box (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkBox.
			-- (from C_GTK_HBOX_STRUCT)
		do
		end

	frozen gtk_hpaned_struct_paned (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkPaned.
			-- (from C_GTK_HPANED_STRUCT)
		do
		end

	frozen gtk_hscale_struct_scale (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkScale.
			-- (from C_GTK_HSCALE_STRUCT)
		do
		end

	frozen gtk_hscrollbar_struct_scrollbar (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkScrollbar.
			-- (from C_GTK_HSCROLLBAR_STRUCT)
		do
		end

	frozen gtk_hseparator_struct_separator (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkSeparator.
			-- (from C_GTK_HSEPARATOR_STRUCT)
		do
		end

	frozen gtk_input_dialog_struct_axis_items (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_INPUT_DIALOG_STRUCT)
		do
		end

	frozen gtk_input_dialog_struct_axis_list (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_INPUT_DIALOG_STRUCT)
		do
		end

	frozen gtk_input_dialog_struct_axis_listbox (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_INPUT_DIALOG_STRUCT)
		do
		end

	frozen gtk_input_dialog_struct_close_button (a_c_struct: POINTER): POINTER is
		do
		end

	frozen gtk_input_dialog_struct_current_device (a_c_struct: POINTER): POINTER is
		do
		end

	frozen gtk_input_dialog_struct_dialog (a_c_struct: POINTER): POINTER is
		do
		end

	frozen gtk_input_dialog_struct_keys_list (a_c_struct: POINTER): POINTER is
		do
		end

	frozen gtk_input_dialog_struct_keys_listbox (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_INPUT_DIALOG_STRUCT)
		do
		end

	frozen gtk_input_dialog_struct_mode_optionmenu (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_INPUT_DIALOG_STRUCT)
		do
		end

	frozen gtk_input_dialog_struct_save_button (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_INPUT_DIALOG_STRUCT)
		do
		end

	frozen gtk_item_struct_bin (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkBin.
			-- (from C_GTK_ITEM_STRUCT)
		do
		end

	frozen gtk_label_struct_jtype (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_LABEL_STRUCT)
		do
		end

	frozen gtk_label_struct_label (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_LABEL_STRUCT)
		do
		end

	frozen gtk_list_item_struct_item (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkItem.
			-- (from C_GTK_LIST_ITEM_STRUCT)
		do
		end

	frozen gtk_list_struct_add_mode (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen gtk_list_struct_anchor (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen gtk_list_struct_anchor_state (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen gtk_list_struct_children (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen gtk_list_struct_container (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkContainer.
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen gtk_list_struct_drag_pos (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen gtk_list_struct_drag_selection (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen gtk_list_struct_htimer (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen gtk_list_struct_last_focus_child (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen gtk_list_struct_selection (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen gtk_list_struct_selection_mode (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen gtk_list_struct_undo_focus_child (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen gtk_list_struct_undo_selection (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen gtk_list_struct_undo_unselection (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen gtk_list_struct_vtimer (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen gtk_menu_bar_struct_menu_shell (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkMenuShell.
			-- (from C_GTK_MENU_BAR_STRUCT)
		do
		end

	frozen gtk_menu_item_struct_accelerator_width (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_MENU_ITEM_STRUCT)
		do
		end

	frozen gtk_menu_item_struct_item (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkItem.
			-- (from C_GTK_MENU_ITEM_STRUCT)
		do
		end

	frozen gtk_menu_item_struct_right_justify (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_MENU_ITEM_STRUCT)
		do
		end

	frozen gtk_menu_item_struct_show_submenu_indicator (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_MENU_ITEM_STRUCT)
		do
		end

	frozen gtk_menu_item_struct_submenu (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_MENU_ITEM_STRUCT)
		do
		end

	frozen gtk_menu_item_struct_submenu_direction (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_MENU_ITEM_STRUCT)
		do
		end

	frozen gtk_menu_item_struct_submenu_placement (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_MENU_ITEM_STRUCT)
		do
		end

	frozen gtk_menu_item_struct_timer (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_MENU_ITEM_STRUCT)
		do
		end

	frozen gtk_menu_item_struct_toggle_size (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_MENU_ITEM_STRUCT)
		do
		end

	frozen gtk_menu_shell_struct_activate_time (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen gtk_menu_shell_struct_active (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen gtk_menu_shell_struct_active_menu_item (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen gtk_menu_shell_struct_button (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen gtk_menu_shell_struct_children (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen gtk_menu_shell_struct_container (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkContainer.
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen gtk_menu_shell_struct_have_grab (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen gtk_menu_shell_struct_have_xgrab (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen gtk_menu_shell_struct_ignore_enter (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen gtk_menu_shell_struct_ignore_leave (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen gtk_menu_shell_struct_menu_flag (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen gtk_menu_shell_struct_parent_menu_shell (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen gtk_menu_struct_accel_group (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_MENU_STRUCT)
		do
		end

	frozen gtk_menu_struct_menu_shell (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkMenuShell.
			-- (from C_GTK_MENU_STRUCT)
		do
		end

	frozen gtk_menu_struct_old_active_menu_item (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_MENU_STRUCT)
		do
		end

	frozen gtk_menu_struct_parent_menu_item (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_MENU_STRUCT)
		do
		end

	frozen gtk_menu_struct_position_func (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_MENU_STRUCT)
		do
		end

	frozen gtk_menu_struct_position_func_data (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_MENU_STRUCT)
		do
		end

	frozen gtk_menu_struct_tearoff_window (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_MENU_STRUCT)
		do
		end

	frozen gtk_menu_struct_toplevel (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_MENU_STRUCT)
		do
		end

	frozen gtk_menu_struct_torn_off (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_MENU_STRUCT)
		do
		end

	frozen gtk_misc_struct_widget (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkWidget.
			-- (from C_GTK_MISC_STRUCT)
		do
		end

	frozen gtk_misc_struct_xalign (a_c_struct: POINTER): REAL is
			-- (from C_GTK_MISC_STRUCT)
		do
		end

	frozen gtk_misc_struct_xpad (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_MISC_STRUCT)
		do
		end

	frozen gtk_misc_struct_yalign (a_c_struct: POINTER): REAL is
			-- (from C_GTK_MISC_STRUCT)
		do
		end

	frozen gtk_misc_struct_ypad (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_MISC_STRUCT)
		do
		end

	frozen c_g_timeval_struct_allocate: POINTER is
		do
		end

	frozen g_timeval_struct_tv_sec (a_c_struct: POINTER): INTEGER is
		do
		end

	frozen g_timeval_struct_tv_usec (a_c_struct: POINTER): INTEGER is
		do
		end

	frozen gtk_notebook_struct_button (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen gtk_notebook_struct_child_has_focus (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen gtk_notebook_struct_children (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen gtk_notebook_struct_container (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkContainer.
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen gtk_notebook_struct_cur_page (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen gtk_notebook_struct_first_tab (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen gtk_notebook_struct_focus_tab (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen gtk_notebook_struct_have_visible_child (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen gtk_notebook_struct_homogeneous (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen gtk_notebook_struct_menu (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen gtk_notebook_struct_need_timer (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen gtk_notebook_struct_scrollable (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen gtk_notebook_struct_show_border (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen gtk_notebook_struct_show_tabs (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen gtk_notebook_struct_tab_hborder (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen gtk_notebook_struct_tab_pos (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen gtk_notebook_struct_tab_vborder (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen gtk_notebook_struct_timer (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen gtk_object_struct_flags (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_OBJECT_STRUCT)
		do
		end

	frozen gtk_paned_struct_child1 (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen gtk_paned_struct_child1_resize (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen gtk_paned_struct_child1_shrink (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen gtk_paned_struct_child1_size (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen gtk_paned_struct_child2 (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen gtk_paned_struct_child2_resize (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen gtk_paned_struct_child2_shrink (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen gtk_paned_struct_container (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkContainer.
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen gtk_paned_struct_max_position (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen gtk_paned_struct_min_position (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen gtk_paned_struct_position_set (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen gtk_paned_struct_xor_gc (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen gtk_pixmap_struct_build_insensitive (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_PIXMAP_STRUCT)
		do
		end

	frozen gtk_pixmap_struct_mask (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_PIXMAP_STRUCT)
		do
		end

	frozen gtk_pixmap_struct_misc (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkMisc.
			-- (from C_GTK_PIXMAP_STRUCT)
		do
		end

	frozen gtk_pixmap_struct_pixmap (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_PIXMAP_STRUCT)
		do
		end

	frozen gtk_pixmap_struct_pixmap_insensitive (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_PIXMAP_STRUCT)
		do
		end

	frozen gtk_progress_bar_struct_activity_blocks (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_PROGRESS_BAR_STRUCT)
		do
		end

	frozen gtk_progress_bar_struct_activity_dir (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_PROGRESS_BAR_STRUCT)
		do
		end

	frozen gtk_progress_bar_struct_activity_pos (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_PROGRESS_BAR_STRUCT)
		do
		end

	frozen gtk_progress_bar_struct_activity_step (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_PROGRESS_BAR_STRUCT)
		do
		end

	frozen gtk_progress_bar_struct_bar_style (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_PROGRESS_BAR_STRUCT)
		do
		end

	frozen gtk_progress_bar_struct_blocks (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_PROGRESS_BAR_STRUCT)
		do
		end

	frozen gtk_progress_bar_struct_in_block (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_PROGRESS_BAR_STRUCT)
		do
		end

	frozen gtk_progress_bar_struct_orientation (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_PROGRESS_BAR_STRUCT)
		do
		end

	frozen gtk_progress_bar_struct_progress (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkProgress.
			-- (from C_GTK_PROGRESS_BAR_STRUCT)
		do
		end

	frozen gtk_progress_struct_activity_mode (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_PROGRESS_STRUCT)
		do
		end

	frozen gtk_progress_struct_adjustment (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_PROGRESS_STRUCT)
		do
		end

	frozen gtk_progress_struct_format (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_PROGRESS_STRUCT)
		do
		end

	frozen gtk_progress_struct_offscreen_pixmap (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_PROGRESS_STRUCT)
		do
		end

	frozen gtk_progress_struct_show_text (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_PROGRESS_STRUCT)
		do
		end

	frozen gtk_progress_struct_widget (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkWidget.
			-- (from C_GTK_PROGRESS_STRUCT)
		do
		end

	frozen gtk_progress_struct_x_align (a_c_struct: POINTER): REAL is
			-- (from C_GTK_PROGRESS_STRUCT)
		do
		end

	frozen gtk_progress_struct_y_align (a_c_struct: POINTER): REAL is
			-- (from C_GTK_PROGRESS_STRUCT)
		do
		end

	frozen gtk_radio_button_struct_check_button (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkCheckButton.
			-- (from C_GTK_RADIO_BUTTON_STRUCT)
		do
		end

	frozen gtk_radio_button_struct_group (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_RADIO_BUTTON_STRUCT)
		do
		end

	frozen gtk_radio_menu_item_struct_check_menu_item (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkCheckMenuItem.
			-- (from C_GTK_RADIO_MENU_ITEM_STRUCT)
		do
		end

	frozen gtk_radio_menu_item_struct_group (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_RADIO_MENU_ITEM_STRUCT)
		do
		end

	frozen gtk_range_struct_adjustment (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_RANGE_STRUCT)
		do
		end

	frozen gtk_requisition_struct_height (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_REQUISITION_STRUCT)
		do
		end

	frozen gtk_requisition_struct_width (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_REQUISITION_STRUCT)
		do
		end

	frozen gtk_scale_struct_draw_value (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_SCALE_STRUCT)
		do
		end

	frozen gtk_scale_struct_range (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkRange.
			-- (from C_GTK_SCALE_STRUCT)
		do
		end

	frozen gtk_scale_struct_value_pos (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_SCALE_STRUCT)
		do
		end

	frozen gtk_scrollbar_struct_range (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkRange.
			-- (from C_GTK_SCROLLBAR_STRUCT)
		do
		end

	frozen gtk_scrolled_window_struct_container (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkBin.
			-- (from C_GTK_SCROLLED_window_STRUCT)
		do
		end

	frozen gtk_scrolled_window_struct_hscrollbar (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_SCROLLED_window_STRUCT)
		do
		end

	frozen gtk_scrolled_window_struct_hscrollbar_policy (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_SCROLLED_window_STRUCT)
		do
		end

	frozen gtk_scrolled_window_struct_hscrollbar_visible (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_SCROLLED_window_STRUCT)
		do
		end

	frozen gtk_scrolled_window_struct_vscrollbar (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_SCROLLED_window_STRUCT)
		do
		end

	frozen gtk_scrolled_window_struct_vscrollbar_policy (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_SCROLLED_window_STRUCT)
		do
		end

	frozen gtk_scrolled_window_struct_vscrollbar_visible (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_SCROLLED_window_STRUCT)
		do
		end

	frozen gtk_scrolled_window_struct_window_placement (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_SCROLLED_window_STRUCT)
		do
		end

	frozen gtk_separator_struct_widget (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkWidget.
			-- (from C_GTK_SEPARATOR_STRUCT)
		do
		end

	frozen gtk_spin_button_struct_adjustment (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen gtk_spin_button_struct_button (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen gtk_spin_button_struct_climb_rate (a_c_struct: POINTER): REAL is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen gtk_spin_button_struct_entry (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkEntry.
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen gtk_spin_button_struct_need_timer (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen gtk_spin_button_struct_numeric (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen gtk_spin_button_struct_panel (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen gtk_spin_button_struct_snap_to_ticks (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen gtk_spin_button_struct_timer (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen gtk_spin_button_struct_timer_calls (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen gtk_spin_button_struct_timer_step (a_c_struct: POINTER): REAL is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen gtk_spin_button_struct_update_policy (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen gtk_spin_button_struct_wrap (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen gtk_style_struct_attach_count (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_base (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_base_gc (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_bg (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_bg_gc (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_bg_pixmap (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_black (a_c_struct: POINTER): POINTER is
			-- Pointer to GdkColor.
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_black_gc (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_colormap (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_dark (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_dark_gc (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_depth (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_fg (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_fg_gc (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_light (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_light_gc (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_mid (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_mid_gc (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_rc_style (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_styles (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_text (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_text_gc (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_white (a_c_struct: POINTER): POINTER is
			-- Pointer to GdkColor.
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_style_struct_white_gc (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen gtk_table_struct_children (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_TABLE_STRUCT)
		do
		end

	frozen gtk_table_struct_cols (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_TABLE_STRUCT)
		do
		end

	frozen gtk_table_struct_column_spacing (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_TABLE_STRUCT)
		do
		end

	frozen gtk_table_struct_container (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkContainer.
			-- (from C_GTK_TABLE_STRUCT)
		do
		end

	frozen gtk_table_struct_homogeneous (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_TABLE_STRUCT)
		do
		end

	frozen gtk_table_struct_ncols (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_TABLE_STRUCT)
		do
		end

	frozen gtk_table_struct_nrows (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_TABLE_STRUCT)
		do
		end

	frozen gtk_table_struct_row_spacing (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_TABLE_STRUCT)
		do
		end

	frozen gtk_table_struct_rows (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_TABLE_STRUCT)
		do
		end

	frozen gtk_toggle_button_struct_active (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_TOGGLE_BUTTON_STRUCT)
		do
		end

	frozen gtk_toggle_button_struct_button (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkButton.
			-- (from C_GTK_TOGGLE_BUTTON_STRUCT)
		do
		end

	frozen gtk_toggle_button_struct_draw_indicator (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_TOGGLE_BUTTON_STRUCT)
		do
		end

	frozen gtk_tooltips_data_struct_tip_text (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_TOOLTIPS_DATA_STRUCT)
		do
		end

	frozen gtk_tooltips_data_struct_tooltips (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_TOOLTIPS_DATA_STRUCT)
		do
		end

	frozen gtk_tooltips_data_struct_widget (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_TOOLTIPS_DATA_STRUCT)
		do
		end

	frozen gtk_tooltips_struct_active_tips_data (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_TOOLTIPS_STRUCT)
		do
		end

	frozen gtk_tooltips_struct_delay (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_TOOLTIPS_STRUCT)
		do
		end

	frozen gtk_tooltips_struct_enabled (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_TOOLTIPS_STRUCT)
		do
		end

	frozen gtk_tooltips_struct_timer_tag (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_TOOLTIPS_STRUCT)
		do
		end

	frozen gtk_tooltips_struct_tip_window (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_TOOLTIPS_STRUCT)
		do
		end

	frozen gtk_tooltips_struct_tips_data_list (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_TOOLTIPS_STRUCT)
		do
		end

	frozen gtk_vbox_struct_box (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkBox.
			-- (from C_GTK_VBOX_STRUCT)
		do
		end

	frozen gtk_viewport_struct_bin (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkBin.
			-- (from C_GTK_VIEWPORT_STRUCT)
		do
		end

	frozen gtk_viewport_struct_bin_window (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_VIEWPORT_STRUCT)
		do
		end

	frozen gtk_viewport_struct_hadjustment (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_VIEWPORT_STRUCT)
		do
		end

	frozen gtk_viewport_struct_shadow_type (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_VIEWPORT_STRUCT)
		do
		end

	frozen gtk_viewport_struct_vadjustment (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_VIEWPORT_STRUCT)
		do
		end

	frozen gtk_viewport_struct_view_window (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_VIEWPORT_STRUCT)
		do
		end

	frozen gtk_vpaned_struct_paned (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkPaned.
			-- (from C_GTK_VPANED_STRUCT)
		do
		end

	frozen gtk_vscale_struct_scale (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkScale.
			-- (from C_GTK_VSCALE_STRUCT)
		do
		end

	frozen gtk_vscrollbar_struct_scrollbar (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkScrollbar.
			-- (from C_GTK_VSCROLLBAR_STRUCT)
		do
		end

	frozen gtk_vseparator_struct_separator (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkSeparator.
			-- (from C_GTK_VSEPARATOR_STRUCT)
		do
		end

	frozen gtk_widget_aux_info_struct_height (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_WIDGET_AUX_INFO_STRUCT)
		do
		end

	frozen gtk_widget_aux_info_struct_width (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_WIDGET_AUX_INFO_STRUCT)
		do
		end

	frozen gtk_widget_aux_info_struct_x (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_WIDGET_AUX_INFO_STRUCT)
		do
		end

	frozen gtk_widget_aux_info_struct_y (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_WIDGET_AUX_INFO_STRUCT)
		do
		end

	frozen gtk_widget_struct_allocation (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkAllocation.
			-- (from C_GTK_WIDGET_STRUCT)
		do
		end

	frozen gtk_widget_struct_name (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_WIDGET_STRUCT)
		do
		end

	frozen gtk_widget_struct_object (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkObject.
			-- (from C_GTK_WIDGET_STRUCT)
		do
		end

	frozen gtk_widget_struct_parent (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_WIDGET_STRUCT)
		do
		end

	frozen gtk_widget_struct_private_flags (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_WIDGET_STRUCT)
		do
		end

	frozen gtk_widget_struct_requisition (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkRequisition.
			-- (from C_GTK_WIDGET_STRUCT)
		do
		end

	frozen gtk_widget_struct_saved_state (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_WIDGET_STRUCT)
		do
		end

	frozen gtk_widget_struct_state (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_WIDGET_STRUCT)
		do
		end

	frozen gtk_widget_struct_style (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_WIDGET_STRUCT)
		do
		end

	frozen gtk_widget_struct_window (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_WIDGET_STRUCT)
		do
		end

	frozen gtk_window_struct_allow_grow (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen gtk_window_struct_allow_shrink (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen gtk_window_struct_bin (a_c_struct: POINTER): POINTER is
			-- Pointer to GtkBin.
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen gtk_window_struct_default_widget (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen gtk_window_struct_focus_widget (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen gtk_window_struct_modal (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen gtk_window_struct_position (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen gtk_window_struct_title (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen gtk_window_struct_transient_parent (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen gtk_window_struct_type (a_c_struct: POINTER): INTEGER is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen gtk_window_struct_wmclass_class (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen gtk_window_struct_wmclass_name (a_c_struct: POINTER): POINTER is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen set_gdk_color_struct_blue (a_c_struct: POINTER; a_blue: INTEGER) is
			-- (from C_GDK_COLOR_STRUCT)
		do
		end

	frozen set_gdk_color_struct_green (a_c_struct: POINTER; a_green: INTEGER) is
			-- (from C_GDK_COLOR_STRUCT)
		do
		end

	frozen set_gdk_color_struct_pixel (a_c_struct: POINTER; a_pixel: INTEGER) is
			-- (from C_GDK_COLOR_STRUCT)
		do
		end

	frozen set_gdk_color_struct_red (a_c_struct: POINTER; a_red: INTEGER) is
			-- (from C_GDK_COLOR_STRUCT)
		do
		end

	frozen set_gdk_colormap_struct_colors (a_c_struct: POINTER; a_colors: POINTER) is
			-- (from C_GDK_COLORMAP_STRUCT)
		do
		end

	frozen set_gdk_colormap_struct_size (a_c_struct: POINTER; a_size: INTEGER) is
			-- (from C_GDK_COLORMAP_STRUCT)
		do
		end

	frozen set_gdk_event_any_struct_send_event (a_c_struct: POINTER; a_send_event: INTEGER) is
			-- (from C_GDK_EVENT_ANY_STRUCT)
		do
		end

	frozen set_gdk_event_any_struct_type (a_c_struct: POINTER; a_type: INTEGER) is
			-- (from C_GDK_EVENT_ANY_STRUCT)
		do
		end

	frozen set_gdk_event_any_struct_window (a_c_struct: POINTER; a_window: POINTER) is
			-- (from C_GDK_EVENT_ANY_STRUCT)
		do
		end

	frozen set_gdk_event_button_struct_button (a_c_struct: POINTER; a_button: INTEGER) is
			-- (from C_GDK_EVENT_BUTTON_STRUCT)
		do
		end

	frozen set_gdk_event_button_struct_send_event (a_c_struct: POINTER; a_send_event: INTEGER) is
			-- (from C_GDK_EVENT_BUTTON_STRUCT)
		do
		end

	frozen set_gdk_event_button_struct_state (a_c_struct: POINTER; a_state: INTEGER) is
			-- (from C_GDK_EVENT_BUTTON_STRUCT)
		do
		end

	frozen set_gdk_event_button_struct_time (a_c_struct: POINTER; a_time: INTEGER) is
			-- (from C_GDK_EVENT_BUTTON_STRUCT)
		do
		end

	frozen set_gdk_event_button_struct_type (a_c_struct: POINTER; a_type: INTEGER) is
			-- (from C_GDK_EVENT_BUTTON_STRUCT)
		do
		end

	frozen set_gdk_event_button_struct_window (a_c_struct: POINTER; a_window: POINTER) is
			-- (from C_GDK_EVENT_BUTTON_STRUCT)
		do
		end

	frozen set_gdk_event_button_struct_x (a_c_struct: POINTER; a_x: 		doUBLE) is
			-- (from C_GDK_EVENT_BUTTON_STRUCT)
		do
		end

	frozen set_gdk_event_button_struct_x_root (a_c_struct: POINTER; a_x_root: 		doUBLE) is
			-- (from C_GDK_EVENT_BUTTON_STRUCT)
		do
		end

	frozen set_gdk_event_button_struct_y (a_c_struct: POINTER; a_y: 		doUBLE) is
			-- (from C_GDK_EVENT_BUTTON_STRUCT)
		do
		end

	frozen set_gdk_event_button_struct_y_root (a_c_struct: POINTER; a_y_root: 		doUBLE) is
			-- (from C_GDK_EVENT_BUTTON_STRUCT)
		do
		end

	frozen set_gdk_event_configure_struct_send_event (a_c_struct: POINTER; a_send_event: INTEGER) is
			-- (from C_GDK_EVENT_CONFIGURE_STRUCT)
		do
		end

	frozen set_gdk_event_configure_struct_type (a_c_struct: POINTER; a_type: INTEGER) is
			-- (from C_GDK_EVENT_CONFIGURE_STRUCT)
		do
		end

	frozen set_gdk_event_configure_struct_window (a_c_struct: POINTER; a_window: POINTER) is
			-- (from C_GDK_EVENT_CONFIGURE_STRUCT)
		do
		end

	frozen set_gdk_event_expose_struct_send_event (a_c_struct: POINTER; a_send_event: INTEGER) is
			-- (from C_GDK_EVENT_EXPOSE_STRUCT)
		do
		end

	frozen set_gdk_event_expose_struct_type (a_c_struct: POINTER; a_type: INTEGER) is
			-- (from C_GDK_EVENT_EXPOSE_STRUCT)
		do
		end

	frozen set_gdk_event_expose_struct_window (a_c_struct: POINTER; a_window: POINTER) is
			-- (from C_GDK_EVENT_EXPOSE_STRUCT)
		do
		end

	frozen set_gdk_event_key_struct_keyval (a_c_struct: POINTER; a_keyval: INTEGER) is
			-- (from C_GDK_EVENT_KEY_STRUCT)
		do
		end

	frozen set_gdk_event_key_struct_length (a_c_struct: POINTER; a_length: INTEGER) is
			-- (from C_GDK_EVENT_KEY_STRUCT)
		do
		end

	frozen set_gdk_event_key_struct_send_event (a_c_struct: POINTER; a_send_event: INTEGER) is
			-- (from C_GDK_EVENT_KEY_STRUCT)
		do
		end

	frozen set_gdk_event_key_struct_state (a_c_struct: POINTER; a_state: INTEGER) is
			-- (from C_GDK_EVENT_KEY_STRUCT)
		do
		end

	frozen set_gdk_event_key_struct_string (a_c_struct: POINTER; a_string: POINTER) is
			-- (from C_GDK_EVENT_KEY_STRUCT)
		do
		end

	frozen set_gdk_event_key_struct_time (a_c_struct: POINTER; a_time: INTEGER) is
			-- (from C_GDK_EVENT_KEY_STRUCT)
		do
		end

	frozen set_gdk_event_key_struct_type (a_c_struct: POINTER; a_type: INTEGER) is
			-- (from C_GDK_EVENT_KEY_STRUCT)
		do
		end

	frozen set_gdk_event_key_struct_window (a_c_struct: POINTER; a_window: POINTER) is
			-- (from C_GDK_EVENT_KEY_STRUCT)
		do
		end

	frozen set_gdk_event_motion_struct_send_event (a_c_struct: POINTER; a_send_event: INTEGER) is
			-- (from C_GDK_EVENT_MOTION_STRUCT)
		do
		end

	frozen set_gdk_event_motion_struct_state (a_c_struct: POINTER; a_state: INTEGER) is
			-- (from C_GDK_EVENT_MOTION_STRUCT)
		do
		end

	frozen set_gdk_event_motion_struct_time (a_c_struct: POINTER; a_time: INTEGER) is
			-- (from C_GDK_EVENT_MOTION_STRUCT)
		do
		end

	frozen set_gdk_event_motion_struct_type (a_c_struct: POINTER; a_type: INTEGER) is
			-- (from C_GDK_EVENT_MOTION_STRUCT)
		do
		end

	frozen set_gdk_event_motion_struct_window (a_c_struct: POINTER; a_window: POINTER) is
			-- (from C_GDK_EVENT_MOTION_STRUCT)
		do
		end

	frozen set_gdk_event_motion_struct_x (a_c_struct: POINTER; a_x: 		doUBLE) is
			-- (from C_GDK_EVENT_MOTION_STRUCT)
		do
		end

	frozen set_gdk_event_motion_struct_x_root (a_c_struct: POINTER; a_x_root: 		doUBLE) is
			-- (from C_GDK_EVENT_MOTION_STRUCT)
		do
		end

	frozen set_gdk_event_motion_struct_y (a_c_struct: POINTER; a_y: 		doUBLE) is
			-- (from C_GDK_EVENT_MOTION_STRUCT)
		do
		end

	frozen set_gdk_event_motion_struct_y_root (a_c_struct: POINTER; a_y_root: 		doUBLE) is
			-- (from C_GDK_EVENT_MOTION_STRUCT)
		do
		end

	frozen set_gdk_font_struct_ascent (a_c_struct: POINTER; a_ascent: INTEGER) is
			-- (from C_GDK_FONT_STRUCT)
		do
		end

	frozen set_gdk_font_struct_descent (a_c_struct: POINTER; a_descent: INTEGER) is
			-- (from C_GDK_FONT_STRUCT)
		do
		end

	frozen set_gdk_font_struct_type (a_c_struct: POINTER; a_type: INTEGER) is
			-- (from C_GDK_FONT_STRUCT)
		do
		end

	frozen set_gdk_gcvalues_struct_cap_style (a_c_struct: POINTER; a_cap_style: INTEGER) is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen set_gdk_gcvalues_struct_clip_mask (a_c_struct: POINTER; a_clip_mask: POINTER) is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen set_gdk_gcvalues_struct_clip_x_origin (a_c_struct: POINTER; a_clip_x_origin: INTEGER) is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen set_gdk_gcvalues_struct_clip_y_origin (a_c_struct: POINTER; a_clip_y_origin: INTEGER) is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen set_gdk_gcvalues_struct_fill (a_c_struct: POINTER; a_fill: INTEGER) is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen set_gdk_gcvalues_struct_font (a_c_struct: POINTER; a_font: POINTER) is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen set_gdk_gcvalues_struct_function (a_c_struct: POINTER; a_function: INTEGER) is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen set_gdk_gcvalues_struct_graphics_exposures (a_c_struct: POINTER; a_graphics_exposures: INTEGER) is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen set_gdk_gcvalues_struct_join_style (a_c_struct: POINTER; a_join_style: INTEGER) is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen set_gdk_gcvalues_struct_line_style (a_c_struct: POINTER; a_line_style: INTEGER) is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen set_gdk_gcvalues_struct_line_width (a_c_struct: POINTER; a_line_width: INTEGER) is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen set_gdk_gcvalues_struct_stipple (a_c_struct: POINTER; a_stipple: POINTER) is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen set_gdk_gcvalues_struct_subwindow_mode (a_c_struct: POINTER; a_subwindow_mode: INTEGER) is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen set_gdk_gcvalues_struct_tile (a_c_struct: POINTER; a_tile: POINTER) is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen set_gdk_gcvalues_struct_ts_x_origin (a_c_struct: POINTER; a_ts_x_origin: INTEGER) is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen set_gdk_gcvalues_struct_ts_y_origin (a_c_struct: POINTER; a_ts_y_origin: INTEGER) is
			-- (from C_GDK_GCVALUES_STRUCT)
		do
		end

	frozen set_gdk_geometry_struct_base_height (a_c_struct: POINTER; a_base_height: INTEGER) is
			-- (from C_GDK_GEOMETRY_STRUCT)
		do
		end

	frozen set_gdk_geometry_struct_base_width (a_c_struct: POINTER; a_base_width: INTEGER) is
			-- (from C_GDK_GEOMETRY_STRUCT)
		do
		end

	frozen set_gdk_geometry_struct_height_inc (a_c_struct: POINTER; a_height_inc: INTEGER) is
			-- (from C_GDK_GEOMETRY_STRUCT)
		do
		end

	frozen set_gdk_geometry_struct_max_aspect (a_c_struct: POINTER; a_max_aspect: 		doUBLE) is
			-- (from C_GDK_GEOMETRY_STRUCT)
		do
		end

	frozen set_gdk_geometry_struct_max_height (a_c_struct: POINTER; a_max_height: INTEGER) is
			-- (from C_GDK_GEOMETRY_STRUCT)
		do
		end

	frozen set_gdk_geometry_struct_max_width (a_c_struct: POINTER; a_max_width: INTEGER) is
			-- (from C_GDK_GEOMETRY_STRUCT)
		do
		end

	frozen set_gdk_geometry_struct_min_aspect (a_c_struct: POINTER; a_min_aspect: 		doUBLE) is
			-- (from C_GDK_GEOMETRY_STRUCT)
		do
		end

	frozen set_gdk_geometry_struct_min_height (a_c_struct: POINTER; a_min_height: INTEGER) is
			-- (from C_GDK_GEOMETRY_STRUCT)
		do
		end

	frozen set_gdk_geometry_struct_min_width (a_c_struct: POINTER; a_min_width: INTEGER) is
			-- (from C_GDK_GEOMETRY_STRUCT)
		do
		end

	frozen set_gdk_geometry_struct_width_inc (a_c_struct: POINTER; a_width_inc: INTEGER) is
			-- (from C_GDK_GEOMETRY_STRUCT)
		do
		end

	frozen set_gdk_visual_struct_bits_per_rgb (a_c_struct: POINTER; a_bits_per_rgb: INTEGER) is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen set_gdk_visual_struct_blue_mask (a_c_struct: POINTER; a_blue_mask: INTEGER) is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen set_gdk_visual_struct_blue_prec (a_c_struct: POINTER; a_blue_prec: INTEGER) is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen set_gdk_visual_struct_blue_shift (a_c_struct: POINTER; a_blue_shift: INTEGER) is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen set_gdk_visual_struct_byte_order (a_c_struct: POINTER; a_byte_order: INTEGER) is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen set_gdk_visual_struct_colormap_size (a_c_struct: POINTER; a_colormap_size: INTEGER) is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen set_gdk_visual_struct_depth (a_c_struct: POINTER; a_depth: INTEGER) is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen set_gdk_visual_struct_green_mask (a_c_struct: POINTER; a_green_mask: INTEGER) is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen set_gdk_visual_struct_green_prec (a_c_struct: POINTER; a_green_prec: INTEGER) is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen set_gdk_visual_struct_green_shift (a_c_struct: POINTER; a_green_shift: INTEGER) is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen set_gdk_visual_struct_red_mask (a_c_struct: POINTER; a_red_mask: INTEGER) is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen set_gdk_visual_struct_red_prec (a_c_struct: POINTER; a_red_prec: INTEGER) is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen set_gdk_visual_struct_red_shift (a_c_struct: POINTER; a_red_shift: INTEGER) is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen set_gdk_visual_struct_type (a_c_struct: POINTER; a_type: INTEGER) is
			-- (from C_GDK_VISUAL_STRUCT)
		do
		end

	frozen set_glist_struct_data (a_c_struct: POINTER; a_data: POINTER) is
			-- (from C_GLIST_STRUCT)
		do
		end

	frozen set_glist_struct_next (a_c_struct: POINTER; a_next: POINTER) is
			-- (from C_GLIST_STRUCT)
		do
		end

	frozen set_glist_struct_prev (a_c_struct: POINTER; a_prev: POINTER) is
			-- (from C_GLIST_STRUCT)
		do
		end

	frozen set_gslist_struct_data (a_c_struct: POINTER; a_data: POINTER) is
			-- (from C_GSLIST_STRUCT)
		do
		end

	frozen set_gslist_struct_next (a_c_struct: POINTER; a_next: POINTER) is
			-- (from C_GSLIST_STRUCT)
		do
		end

	frozen set_gtk_adjustment_struct_lower (a_c_struct: POINTER; a_lower: REAL) is
			-- (from C_GTK_ADJUSTMENT_STRUCT)
		do
		end

	frozen set_gtk_adjustment_struct_page_increment (a_c_struct: POINTER; a_page_increment: REAL) is
			-- (from C_GTK_ADJUSTMENT_STRUCT)
		do
		end

	frozen set_gtk_adjustment_struct_page_size (a_c_struct: POINTER; a_page_size: REAL) is
			-- (from C_GTK_ADJUSTMENT_STRUCT)
		do
		end

	frozen set_gtk_adjustment_struct_step_increment (a_c_struct: POINTER; a_step_increment: REAL) is
			-- (from C_GTK_ADJUSTMENT_STRUCT)
		do
		end

	frozen set_gtk_adjustment_struct_upper (a_c_struct: POINTER; a_upper: REAL) is
			-- (from C_GTK_ADJUSTMENT_STRUCT)
		do
		end

	frozen set_gtk_adjustment_struct_value (a_c_struct: POINTER; a_value: REAL) is
			-- (from C_GTK_ADJUSTMENT_STRUCT)
		do
		end

	frozen set_gtk_alignment_struct_xalign (a_c_struct: POINTER; a_xalign: REAL) is
			-- (from C_GTK_ALIGNMENT_STRUCT)
		do
		end

	frozen set_gtk_alignment_struct_xscale (a_c_struct: POINTER; a_xscale: REAL) is
			-- (from C_GTK_ALIGNMENT_STRUCT)
		do
		end

	frozen set_gtk_alignment_struct_yalign (a_c_struct: POINTER; a_yalign: REAL) is
			-- (from C_GTK_ALIGNMENT_STRUCT)
		do
		end

	frozen set_gtk_alignment_struct_yscale (a_c_struct: POINTER; a_yscale: REAL) is
			-- (from C_GTK_ALIGNMENT_STRUCT)
		do
		end

	frozen set_gtk_bin_struct_child (a_c_struct: POINTER; a_child: POINTER) is
			-- (from C_GTK_BIN_STRUCT)
		do
		end

	frozen set_gtk_box_struct_children (a_c_struct: POINTER; a_children: POINTER) is
			-- (from C_GTK_BOX_STRUCT)
		do
		end

	frozen set_gtk_box_struct_homogeneous (a_c_struct: POINTER; a_homogeneous: INTEGER) is
			-- (from C_GTK_BOX_STRUCT)
		do
		end

	frozen set_gtk_button_struct_relief (a_c_struct: POINTER; a_relief: INTEGER) is
			-- (from C_GTK_BUTTON_STRUCT)
		do
		end

	frozen set_gtk_check_menu_item_struct_active (a_c_struct: POINTER; a_active: INTEGER) is
			-- (from C_GTK_CHECK_MENU_ITEM_STRUCT)
		do
		end

	frozen set_gtk_check_menu_item_struct_always_show_toggle (a_c_struct: POINTER; a_always_show_toggle: INTEGER) is
			-- (from C_GTK_CHECK_MENU_ITEM_STRUCT)
		do
		end

	frozen set_gtk_clist_cell_info_struct_column (a_c_struct: POINTER; a_column: INTEGER) is
			-- (from C_GTK_CLIST_CELL_INFO_STRUCT)
		do
		end

	frozen set_gtk_clist_cell_info_struct_row (a_c_struct: POINTER; a_row: INTEGER) is
			-- (from C_GTK_CLIST_CELL_INFO_STRUCT)
		do
		end

	frozen set_gtk_clist_row_struct_bg_set (a_c_struct: POINTER; a_bg_set: INTEGER) is
			-- (from C_GTK_CLIST_ROW_STRUCT)
		do
		end

	frozen set_gtk_clist_row_struct_cell (a_c_struct: POINTER; a_cell: POINTER) is
			-- (from C_GTK_CLIST_ROW_STRUCT)
		do
		end

	frozen set_gtk_clist_row_struct_data (a_c_struct: POINTER; a_data: POINTER) is
			-- (from C_GTK_CLIST_ROW_STRUCT)
		do
		end

	frozen set_gtk_clist_row_struct_destroy (a_c_struct: POINTER; a_destroy: POINTER) is
			-- (from C_GTK_CLIST_ROW_STRUCT)
		do
		end

	frozen set_gtk_clist_row_struct_fg_set (a_c_struct: POINTER; a_fg_set: INTEGER) is
			-- (from C_GTK_CLIST_ROW_STRUCT)
		do
		end

	frozen set_gtk_clist_row_struct_selectable (a_c_struct: POINTER; a_selectable: INTEGER) is
			-- (from C_GTK_CLIST_ROW_STRUCT)
		do
		end

	frozen set_gtk_clist_row_struct_state (a_c_struct: POINTER; a_state: INTEGER) is
			-- (from C_GTK_CLIST_ROW_STRUCT)
		do
		end

	frozen set_gtk_clist_row_struct_style (a_c_struct: POINTER; a_style: POINTER) is
			-- (from C_GTK_CLIST_ROW_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_anchor (a_c_struct: POINTER; a_anchor: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_anchor_state (a_c_struct: POINTER; a_anchor_state: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_bg_gc (a_c_struct: POINTER; a_bg_gc: POINTER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_cell_mem_chunk (a_c_struct: POINTER; a_cell_mem_chunk: POINTER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_clist_window (a_c_struct: POINTER; a_clist_window: POINTER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_clist_window_height (a_c_struct: POINTER; a_clist_window_height: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_clist_window_width (a_c_struct: POINTER; a_clist_window_width: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_column (a_c_struct: POINTER; a_column: POINTER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_columns (a_c_struct: POINTER; a_columns: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_compare (a_c_struct: POINTER; a_compare: POINTER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_cursor_drag (a_c_struct: POINTER; a_cursor_drag: POINTER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_drag_button (a_c_struct: POINTER; a_drag_button: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_drag_pos (a_c_struct: POINTER; a_drag_pos: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_fg_gc (a_c_struct: POINTER; a_fg_gc: POINTER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_focus_row (a_c_struct: POINTER; a_focus_row: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_freeze_count (a_c_struct: POINTER; a_freeze_count: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_hadjustment (a_c_struct: POINTER; a_hadjustment: POINTER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_hoffset (a_c_struct: POINTER; a_hoffset: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_htimer (a_c_struct: POINTER; a_htimer: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_row_height (a_c_struct: POINTER; a_row_height: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_row_list (a_c_struct: POINTER; a_row_list: POINTER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_row_list_end (a_c_struct: POINTER; a_row_list_end: POINTER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_row_mem_chunk (a_c_struct: POINTER; a_row_mem_chunk: POINTER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_rows (a_c_struct: POINTER; a_rows: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_selection (a_c_struct: POINTER; a_selection: POINTER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_selection_end (a_c_struct: POINTER; a_selection_end: POINTER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_selection_mode (a_c_struct: POINTER; a_selection_mode: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_shadow_type (a_c_struct: POINTER; a_shadow_type: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_sort_column (a_c_struct: POINTER; a_sort_column: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_sort_type (a_c_struct: POINTER; a_sort_type: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_title_window (a_c_struct: POINTER; a_title_window: POINTER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_undo_anchor (a_c_struct: POINTER; a_undo_anchor: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_undo_selection (a_c_struct: POINTER; a_undo_selection: POINTER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_undo_unselection (a_c_struct: POINTER; a_undo_unselection: POINTER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_vadjustment (a_c_struct: POINTER; a_vadjustment: POINTER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_voffset (a_c_struct: POINTER; a_voffset: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_vtimer (a_c_struct: POINTER; a_vtimer: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_x_drag (a_c_struct: POINTER; a_x_drag: INTEGER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_clist_struct_xor_gc (a_c_struct: POINTER; a_xor_gc: POINTER) is
			-- (from C_GTK_CLIST_STRUCT)
		do
		end

	frozen set_gtk_color_selection_dialog_struct_cancel_button (a_c_struct: POINTER; a_cancel_button: POINTER) is
			-- (from C_GTK_COLOR_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen set_gtk_color_selection_dialog_struct_colorsel (a_c_struct: POINTER; a_colorsel: POINTER) is
			-- (from C_GTK_COLOR_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen set_gtk_color_selection_dialog_struct_help_button (a_c_struct: POINTER; a_help_button: POINTER) is
			-- (from C_GTK_COLOR_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen set_gtk_color_selection_dialog_struct_ok_button (a_c_struct: POINTER; a_ok_button: POINTER) is
			-- (from C_GTK_COLOR_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen set_gtk_combo_struct_activate_id (a_c_struct: POINTER; a_activate_id: INTEGER) is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen set_gtk_combo_struct_button (a_c_struct: POINTER; a_button: POINTER) is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen set_gtk_combo_struct_case_sensitive (a_c_struct: POINTER; a_case_sensitive: INTEGER) is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen set_gtk_combo_struct_entry (a_c_struct: POINTER; a_entry: POINTER) is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen set_gtk_combo_struct_entry_change_id (a_c_struct: POINTER; a_entry_change_id: INTEGER) is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen set_gtk_combo_struct_list (a_c_struct: POINTER; a_list: POINTER) is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen set_gtk_combo_struct_list_change_id (a_c_struct: POINTER; a_list_change_id: INTEGER) is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen set_gtk_combo_struct_ok_if_empty (a_c_struct: POINTER; a_ok_if_empty: INTEGER) is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen set_gtk_combo_struct_popup (a_c_struct: POINTER; a_popup: POINTER) is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen set_gtk_combo_struct_popwin (a_c_struct: POINTER; a_popwin: POINTER) is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen set_gtk_combo_struct_use_arrows (a_c_struct: POINTER; a_use_arrows: INTEGER) is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen set_gtk_combo_struct_use_arrows_always (a_c_struct: POINTER; a_use_arrows_always: INTEGER) is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen set_gtk_combo_struct_value_in_list (a_c_struct: POINTER; a_value_in_list: INTEGER) is
			-- (from C_GTK_COMBO_STRUCT)
		do
		end

	frozen set_gtk_container_struct_border_width (a_c_struct: POINTER; a_border_width: INTEGER) is
			-- (from C_GTK_CONTAINER_STRUCT)
		do
		end

	frozen set_gtk_container_struct_focus_child (a_c_struct: POINTER; a_focus_child: POINTER) is
			-- (from C_GTK_CONTAINER_STRUCT)
		do
		end

	frozen set_gtk_container_struct_need_resize (a_c_struct: POINTER; a_need_resize: INTEGER) is
			-- (from C_GTK_CONTAINER_STRUCT)
		do
		end

	frozen set_gtk_container_struct_reallocate_redraws (a_c_struct: POINTER; a_reallocate_redraws: INTEGER) is
			-- (from C_GTK_CONTAINER_STRUCT)
		do
		end

	frozen set_gtk_container_struct_resize_mode (a_c_struct: POINTER; a_resize_mode: INTEGER) is
			-- (from C_GTK_CONTAINER_STRUCT)
		do
		end

	frozen set_gtk_ctree_row_struct_children (a_c_struct: POINTER; a_children: POINTER) is
			-- (from C_GTK_CTREE_ROW_STRUCT)
		do
		end

	frozen set_gtk_ctree_row_struct_expanded (a_c_struct: POINTER; a_expanded: INTEGER) is
			-- (from C_GTK_CTREE_ROW_STRUCT)
		do
		end

	frozen set_gtk_ctree_row_struct_is_leaf (a_c_struct: POINTER; a_is_leaf: INTEGER) is
			-- (from C_GTK_CTREE_ROW_STRUCT)
		do
		end

	frozen set_gtk_ctree_row_struct_mask_closed (a_c_struct: POINTER; a_mask_closed: POINTER) is
			-- (from C_GTK_CTREE_ROW_STRUCT)
		do
		end

	frozen set_gtk_ctree_row_struct_mask_opened (a_c_struct: POINTER; a_mask_opened: POINTER) is
			-- (from C_GTK_CTREE_ROW_STRUCT)
		do
		end

	frozen set_gtk_ctree_row_struct_parent (a_c_struct: POINTER; a_parent: POINTER) is
			-- (from C_GTK_CTREE_ROW_STRUCT)
		do
		end

	frozen set_gtk_ctree_row_struct_pixmap_closed (a_c_struct: POINTER; a_pixmap_closed: POINTER) is
			-- (from C_GTK_CTREE_ROW_STRUCT)
		do
		end

	frozen set_gtk_ctree_row_struct_pixmap_opened (a_c_struct: POINTER; a_pixmap_opened: POINTER) is
			-- (from C_GTK_CTREE_ROW_STRUCT)
		do
		end

	frozen set_gtk_ctree_row_struct_sibling (a_c_struct: POINTER; a_sibling: POINTER) is
			-- (from C_GTK_CTREE_ROW_STRUCT)
		do
		end

	frozen set_gtk_ctree_struct_drag_compare (a_c_struct: POINTER; a_drag_compare: POINTER) is
			-- (from C_GTK_CTREE_STRUCT)
		do
		end

	frozen set_gtk_ctree_struct_expander_style (a_c_struct: POINTER; a_expander_style: INTEGER) is
			-- (from C_GTK_CTREE_STRUCT)
		do
		end

	frozen set_gtk_ctree_struct_line_style (a_c_struct: POINTER; a_line_style: INTEGER) is
			-- (from C_GTK_CTREE_STRUCT)
		do
		end

	frozen set_gtk_ctree_struct_lines_gc (a_c_struct: POINTER; a_lines_gc: POINTER) is
			-- (from C_GTK_CTREE_STRUCT)
		do
		end

	frozen set_gtk_ctree_struct_show_stub (a_c_struct: POINTER; a_show_stub: INTEGER) is
			-- (from C_GTK_CTREE_STRUCT)
		do
		end

	frozen set_gtk_ctree_struct_tree_column (a_c_struct: POINTER; a_tree_column: INTEGER) is
			-- (from C_GTK_CTREE_STRUCT)
		do
		end

	frozen set_gtk_ctree_struct_tree_indent (a_c_struct: POINTER; a_tree_indent: INTEGER) is
			-- (from C_GTK_CTREE_STRUCT)
		do
		end

	frozen set_gtk_ctree_struct_tree_spacing (a_c_struct: POINTER; a_tree_spacing: INTEGER) is
			-- (from C_GTK_CTREE_STRUCT)
		do
		end

	frozen set_gtk_dialog_struct_action_area (a_c_struct: POINTER; a_action_area: POINTER) is
			-- (from C_GTK_DIALOG_STRUCT)
		do
		end

	frozen set_gtk_dialog_struct_vbox (a_c_struct: POINTER; a_vbox: POINTER) is
			-- (from C_GTK_DIALOG_STRUCT)
		do
		end

	frozen set_gtk_drawing_area_struct_draw_data (a_c_struct: POINTER; a_draw_data: POINTER) is
			-- (from C_GTK_DRAWING_AREA_STRUCT)
		do
		end

	frozen set_gtk_file_selection_struct_cancel_button (a_c_struct: POINTER; a_cancel_button: POINTER) is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen set_gtk_file_selection_struct_cmpl_state (a_c_struct: POINTER; a_cmpl_state: POINTER) is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen set_gtk_file_selection_struct_dir_list (a_c_struct: POINTER; a_dir_list: POINTER) is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen set_gtk_file_selection_struct_file_list (a_c_struct: POINTER; a_file_list: POINTER) is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen set_gtk_file_selection_struct_fileop_c_dir (a_c_struct: POINTER; a_fileop_c_dir: POINTER) is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen set_gtk_file_selection_struct_fileop_del_file (a_c_struct: POINTER; a_fileop_del_file: POINTER) is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen set_gtk_file_selection_struct_fileop_dialog (a_c_struct: POINTER; a_fileop_dialog: POINTER) is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen set_gtk_file_selection_struct_fileop_entry (a_c_struct: POINTER; a_fileop_entry: POINTER) is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen set_gtk_file_selection_struct_fileop_file (a_c_struct: POINTER; a_fileop_file: POINTER) is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen set_gtk_file_selection_struct_fileop_ren_file (a_c_struct: POINTER; a_fileop_ren_file: POINTER) is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen set_gtk_file_selection_struct_help_button (a_c_struct: POINTER; a_help_button: POINTER) is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen set_gtk_file_selection_struct_history_list (a_c_struct: POINTER; a_history_list: POINTER) is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen set_gtk_file_selection_struct_history_menu (a_c_struct: POINTER; a_history_menu: POINTER) is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen set_gtk_file_selection_struct_history_pulldown (a_c_struct: POINTER; a_history_pulldown: POINTER) is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen set_gtk_file_selection_struct_ok_button (a_c_struct: POINTER; a_ok_button: POINTER) is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen set_gtk_file_selection_struct_selection_entry (a_c_struct: POINTER; a_selection_entry: POINTER) is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen set_gtk_file_selection_struct_selection_text (a_c_struct: POINTER; a_selection_text: POINTER) is
			-- (from C_GTK_FILE_SELECTION_STRUCT)
		do
		end

	frozen set_gtk_fixed_struct_children (a_c_struct: POINTER; a_children: POINTER) is
			-- (from C_GTK_FIXED_STRUCT)
		do
		end

	frozen set_gtk_font_selection_dialog_struct_action_area (a_c_struct: POINTER; a_action_area: POINTER) is
			-- (from C_GTK_FONT_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen set_gtk_font_selection_dialog_struct_apply_button (a_c_struct: POINTER; a_apply_button: POINTER) is
			-- (from C_GTK_FONT_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen set_gtk_font_selection_dialog_struct_auto_resize (a_c_struct: POINTER; a_auto_resize: BOOLEAN) is
			-- (from C_GTK_FONT_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen set_gtk_font_selection_dialog_struct_cancel_button (a_c_struct: POINTER; a_cancel_button: POINTER) is
			-- (from C_GTK_FONT_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen set_gtk_font_selection_dialog_struct_dialog_width (a_c_struct: POINTER; a_dialog_width: INTEGER) is
			-- (from C_GTK_FONT_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen set_gtk_font_selection_dialog_struct_fontsel (a_c_struct: POINTER; a_fontsel: POINTER) is
			-- (from C_GTK_FONT_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen set_gtk_font_selection_dialog_struct_ok_button (a_c_struct: POINTER; a_ok_button: POINTER) is
			-- (from C_GTK_FONT_SELECTION_DIALOG_STRUCT)
		do
		end

	frozen set_gtk_input_dialog_struct_axis_list (a_c_struct: POINTER; a_axis_list: POINTER) is
			-- (from C_GTK_INPUT_DIALOG_STRUCT)
		do
		end

	frozen set_gtk_input_dialog_struct_axis_listbox (a_c_struct: POINTER; a_axis_listbox: POINTER) is
			-- (from C_GTK_INPUT_DIALOG_STRUCT)
		do
		end

	frozen set_gtk_input_dialog_struct_close_button (a_c_struct: POINTER; a_close_button: POINTER) is
			-- (from C_GTK_INPUT_DIALOG_STRUCT)
		do
		end

	frozen set_gtk_input_dialog_struct_keys_list (a_c_struct: POINTER; a_keys_list: POINTER) is
			-- (from C_GTK_INPUT_DIALOG_STRUCT)
		do
		end

	frozen set_gtk_input_dialog_struct_keys_listbox (a_c_struct: POINTER; a_keys_listbox: POINTER) is
			-- (from C_GTK_INPUT_DIALOG_STRUCT)
		do
		end

	frozen set_gtk_input_dialog_struct_mode_optionmenu (a_c_struct: POINTER; a_mode_optionmenu: POINTER) is
			-- (from C_GTK_INPUT_DIALOG_STRUCT)
		do
		end

	frozen set_gtk_input_dialog_struct_save_button (a_c_struct: POINTER; a_save_button: POINTER) is
			-- (from C_GTK_INPUT_DIALOG_STRUCT)
		do
		end

	frozen set_gtk_label_struct_jtype (a_c_struct: POINTER; a_jtype: INTEGER) is
			-- (from C_GTK_LABEL_STRUCT)
		do
		end

	frozen set_gtk_label_struct_label (a_c_struct: POINTER; a_label: POINTER) is
			-- (from C_GTK_LABEL_STRUCT)
		do
		end

	frozen set_gtk_label_struct_wrap (a_c_struct: POINTER; a_wrap: BOOLEAN) is
			-- (from C_GTK_LABEL_STRUCT)
		do
		end

	frozen set_gtk_list_struct_add_mode (a_c_struct: POINTER; a_add_mode: INTEGER) is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen set_gtk_list_struct_anchor (a_c_struct: POINTER; a_anchor: INTEGER) is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen set_gtk_list_struct_anchor_state (a_c_struct: POINTER; a_anchor_state: INTEGER) is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen set_gtk_list_struct_children (a_c_struct: POINTER; a_children: POINTER) is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen set_gtk_list_struct_drag_pos (a_c_struct: POINTER; a_drag_pos: INTEGER) is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen set_gtk_list_struct_drag_selection (a_c_struct: POINTER; a_drag_selection: INTEGER) is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen set_gtk_list_struct_htimer (a_c_struct: POINTER; a_htimer: INTEGER) is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen set_gtk_list_struct_last_focus_child (a_c_struct: POINTER; a_last_focus_child: POINTER) is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen set_gtk_list_struct_selection (a_c_struct: POINTER; a_selection: POINTER) is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen set_gtk_list_struct_selection_mode (a_c_struct: POINTER; a_selection_mode: INTEGER) is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen set_gtk_list_struct_undo_focus_child (a_c_struct: POINTER; a_undo_focus_child: POINTER) is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen set_gtk_list_struct_undo_selection (a_c_struct: POINTER; a_undo_selection: POINTER) is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen set_gtk_list_struct_undo_unselection (a_c_struct: POINTER; a_undo_unselection: POINTER) is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen set_gtk_list_struct_vtimer (a_c_struct: POINTER; a_vtimer: INTEGER) is
			-- (from C_GTK_LIST_STRUCT)
		do
		end

	frozen set_gtk_menu_item_struct_right_justify (a_c_struct: POINTER; a_right_justify: INTEGER) is
			-- (from C_GTK_MENU_ITEM_STRUCT)
		do
		end

	frozen set_gtk_menu_item_struct_show_submenu_indicator (a_c_struct: POINTER; a_show_submenu_indicator: INTEGER) is
			-- (from C_GTK_MENU_ITEM_STRUCT)
		do
		end

	frozen set_gtk_menu_item_struct_submenu (a_c_struct: POINTER; a_submenu: POINTER) is
			-- (from C_GTK_MENU_ITEM_STRUCT)
		do
		end

	frozen set_gtk_menu_item_struct_submenu_direction (a_c_struct: POINTER; a_submenu_direction: INTEGER) is
			-- (from C_GTK_MENU_ITEM_STRUCT)
		do
		end

	frozen set_gtk_menu_item_struct_submenu_placement (a_c_struct: POINTER; a_submenu_placement: INTEGER) is
			-- (from C_GTK_MENU_ITEM_STRUCT)
		do
		end

	frozen set_gtk_menu_item_struct_timer (a_c_struct: POINTER; a_timer: INTEGER) is
			-- (from C_GTK_MENU_ITEM_STRUCT)
		do
		end

	frozen set_gtk_menu_shell_struct_activate_time (a_c_struct: POINTER; a_activate_time: INTEGER) is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen set_gtk_menu_shell_struct_active (a_c_struct: POINTER; a_active: INTEGER) is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen set_gtk_menu_shell_struct_active_menu_item (a_c_struct: POINTER; a_active_menu_item: POINTER) is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen set_gtk_menu_shell_struct_button (a_c_struct: POINTER; a_button: INTEGER) is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen set_gtk_menu_shell_struct_children (a_c_struct: POINTER; a_children: POINTER) is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen set_gtk_menu_shell_struct_have_grab (a_c_struct: POINTER; a_have_grab: INTEGER) is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen set_gtk_menu_shell_struct_have_xgrab (a_c_struct: POINTER; a_have_xgrab: INTEGER) is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen set_gtk_menu_shell_struct_ignore_enter (a_c_struct: POINTER; a_ignore_enter: INTEGER) is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen set_gtk_menu_shell_struct_ignore_leave (a_c_struct: POINTER; a_ignore_leave: INTEGER) is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen set_gtk_menu_shell_struct_menu_flag (a_c_struct: POINTER; a_menu_flag: INTEGER) is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen set_gtk_menu_shell_struct_parent_menu_shell (a_c_struct: POINTER; a_parent_menu_shell: POINTER) is
			-- (from C_GTK_MENU_SHELL_STRUCT)
		do
		end

	frozen set_gtk_menu_struct_accel_group (a_c_struct: POINTER; a_accel_group: POINTER) is
			-- (from C_GTK_MENU_STRUCT)
		do
		end

	frozen set_gtk_menu_struct_old_active_menu_item (a_c_struct: POINTER; a_old_active_menu_item: POINTER) is
			-- (from C_GTK_MENU_STRUCT)
		do
		end

	frozen set_gtk_menu_struct_parent_menu_item (a_c_struct: POINTER; a_parent_menu_item: POINTER) is
			-- (from C_GTK_MENU_STRUCT)
		do
		end

	frozen set_gtk_menu_struct_position_func (a_c_struct: POINTER; a_position_func: POINTER) is
			-- (from C_GTK_MENU_STRUCT)
		do
		end

	frozen set_gtk_menu_struct_position_func_data (a_c_struct: POINTER; a_position_func_data: POINTER) is
			-- (from C_GTK_MENU_STRUCT)
		do
		end

	frozen set_gtk_menu_struct_tearoff_window (a_c_struct: POINTER; a_tearoff_window: POINTER) is
			-- (from C_GTK_MENU_STRUCT)
		do
		end

	frozen set_gtk_menu_struct_toplevel (a_c_struct: POINTER; a_toplevel: POINTER) is
			-- (from C_GTK_MENU_STRUCT)
		do
		end

	frozen set_gtk_menu_struct_torn_off (a_c_struct: POINTER; a_torn_off: INTEGER) is
			-- (from C_GTK_MENU_STRUCT)
		do
		end

	frozen set_gtk_misc_struct_xalign (a_c_struct: POINTER; a_xalign: REAL) is
			-- (from C_GTK_MISC_STRUCT)
		do
		end

	frozen set_gtk_misc_struct_yalign (a_c_struct: POINTER; a_yalign: REAL) is
			-- (from C_GTK_MISC_STRUCT)
		do
		end

	frozen set_gtk_notebook_struct_cur_page (a_c_struct: POINTER; a_cur_page: POINTER) is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen set_gtk_notebook_struct_first_tab (a_c_struct: POINTER; a_first_tab: POINTER) is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen set_gtk_notebook_struct_focus_tab (a_c_struct: POINTER; a_focus_tab: POINTER) is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen set_gtk_notebook_struct_have_visible_child (a_c_struct: POINTER; a_have_visible_child: INTEGER) is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen set_gtk_notebook_struct_homogeneous (a_c_struct: POINTER; a_homogeneous: INTEGER) is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen set_gtk_notebook_struct_show_tabs (a_c_struct: POINTER; a_show_tabs: INTEGER) is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen set_gtk_notebook_struct_tab_pos (a_c_struct: POINTER; a_tab_pos: INTEGER) is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen set_gtk_notebook_struct_timer (a_c_struct: POINTER; a_timer: INTEGER) is
			-- (from C_GTK_NOTEBOOK_STRUCT)
		do
		end

	frozen set_gtk_object_struct_flags (a_c_struct: POINTER; a_flags: INTEGER) is
			-- (from C_GTK_OBJECT_STRUCT)
		do
		end

	frozen set_gtk_paned_struct_child1 (a_c_struct: POINTER; a_child1: POINTER) is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen set_gtk_paned_struct_child1_resize (a_c_struct: POINTER; a_child1_resize: INTEGER) is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen set_gtk_paned_struct_child1_shrink (a_c_struct: POINTER; a_child1_shrink: INTEGER) is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen set_gtk_paned_struct_child1_size (a_c_struct: POINTER; a_child1_size: INTEGER) is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen set_gtk_paned_struct_child2 (a_c_struct: POINTER; a_child2: POINTER) is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen set_gtk_paned_struct_child2_resize (a_c_struct: POINTER; a_child2_resize: INTEGER) is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen set_gtk_paned_struct_child2_shrink (a_c_struct: POINTER; a_child2_shrink: INTEGER) is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen set_gtk_paned_struct_max_position (a_c_struct: POINTER; a_max_position: INTEGER) is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen set_gtk_paned_struct_min_position (a_c_struct: POINTER; a_min_position: INTEGER) is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen set_gtk_paned_struct_position_set (a_c_struct: POINTER; a_position_set: INTEGER) is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen set_gtk_paned_struct_xor_gc (a_c_struct: POINTER; a_xor_gc: POINTER) is
			-- (from C_GTK_PANED_STRUCT)
		do
		end

	frozen set_gtk_pixmap_struct_build_insensitive (a_c_struct: POINTER; a_build_insensitive: INTEGER) is
			-- (from C_GTK_PIXMAP_STRUCT)
		do
		end

	frozen set_gtk_pixmap_struct_mask (a_c_struct: POINTER; a_mask: POINTER) is
			-- (from C_GTK_PIXMAP_STRUCT)
		do
		end

	frozen set_gtk_pixmap_struct_pixmap (a_c_struct: POINTER; a_pixmap: POINTER) is
			-- (from C_GTK_PIXMAP_STRUCT)
		do
		end

	frozen set_gtk_pixmap_struct_pixmap_insensitive (a_c_struct: POINTER; a_pixmap_insensitive: POINTER) is
			-- (from C_GTK_PIXMAP_STRUCT)
		do
		end

	frozen set_gtk_progress_bar_struct_activity_blocks (a_c_struct: POINTER; a_activity_blocks: INTEGER) is
			-- (from C_GTK_PROGRESS_BAR_STRUCT)
		do
		end

	frozen set_gtk_progress_bar_struct_activity_dir (a_c_struct: POINTER; a_activity_dir: INTEGER) is
			-- (from C_GTK_PROGRESS_BAR_STRUCT)
		do
		end

	frozen set_gtk_progress_bar_struct_activity_pos (a_c_struct: POINTER; a_activity_pos: INTEGER) is
			-- (from C_GTK_PROGRESS_BAR_STRUCT)
		do
		end

	frozen set_gtk_progress_bar_struct_activity_step (a_c_struct: POINTER; a_activity_step: INTEGER) is
			-- (from C_GTK_PROGRESS_BAR_STRUCT)
		do
		end

	frozen set_gtk_progress_bar_struct_bar_style (a_c_struct: POINTER; a_bar_style: INTEGER) is
			-- (from C_GTK_PROGRESS_BAR_STRUCT)
		do
		end

	frozen set_gtk_progress_bar_struct_blocks (a_c_struct: POINTER; a_blocks: INTEGER) is
			-- (from C_GTK_PROGRESS_BAR_STRUCT)
		do
		end

	frozen set_gtk_progress_bar_struct_in_block (a_c_struct: POINTER; a_in_block: INTEGER) is
			-- (from C_GTK_PROGRESS_BAR_STRUCT)
		do
		end

	frozen set_gtk_progress_bar_struct_orientation (a_c_struct: POINTER; a_orientation: INTEGER) is
			-- (from C_GTK_PROGRESS_BAR_STRUCT)
		do
		end

	frozen set_gtk_progress_struct_activity_mode (a_c_struct: POINTER; a_activity_mode: INTEGER) is
			-- (from C_GTK_PROGRESS_STRUCT)
		do
		end

	frozen set_gtk_progress_struct_adjustment (a_c_struct: POINTER; a_adjustment: POINTER) is
			-- (from C_GTK_PROGRESS_STRUCT)
		do
		end

	frozen set_gtk_progress_struct_format (a_c_struct: POINTER; a_format: POINTER) is
			-- (from C_GTK_PROGRESS_STRUCT)
		do
		end

	frozen set_gtk_progress_struct_offscreen_pixmap (a_c_struct: POINTER; a_offscreen_pixmap: POINTER) is
			-- (from C_GTK_PROGRESS_STRUCT)
		do
		end

	frozen set_gtk_progress_struct_show_text (a_c_struct: POINTER; a_show_text: INTEGER) is
			-- (from C_GTK_PROGRESS_STRUCT)
		do
		end

	frozen set_gtk_progress_struct_x_align (a_c_struct: POINTER; a_x_align: REAL) is
			-- (from C_GTK_PROGRESS_STRUCT)
		do
		end

	frozen set_gtk_progress_struct_y_align (a_c_struct: POINTER; a_y_align: REAL) is
			-- (from C_GTK_PROGRESS_STRUCT)
		do
		end

	frozen set_gtk_radio_button_struct_group (a_c_struct: POINTER; a_group: POINTER) is
			-- (from C_GTK_RADIO_BUTTON_STRUCT)
		do
		end

	frozen set_gtk_radio_menu_item_struct_group (a_c_struct: POINTER; a_group: POINTER) is
			-- (from C_GTK_RADIO_MENU_ITEM_STRUCT)
		do
		end

	frozen set_gtk_range_struct_adjustment (a_c_struct: POINTER; a_adjustment: POINTER) is
			-- (from C_GTK_RANGE_STRUCT)
		do
		end

	frozen set_gtk_scale_struct_draw_value (a_c_struct: POINTER; a_draw_value: INTEGER) is
			-- (from C_GTK_SCALE_STRUCT)
		do
		end

	frozen set_gtk_scale_struct_value_pos (a_c_struct: POINTER; a_value_pos: INTEGER) is
			-- (from C_GTK_SCALE_STRUCT)
		do
		end

	frozen set_gtk_scrolled_window_struct_hscrollbar (a_c_struct: POINTER; a_hscrollbar: POINTER) is
			-- (from C_GTK_SCROLLED_window_STRUCT)
		do
		end

	frozen set_gtk_scrolled_window_struct_hscrollbar_policy (a_c_struct: POINTER; a_hscrollbar_policy: INTEGER) is
			-- (from C_GTK_SCROLLED_window_STRUCT)
		do
		end

	frozen set_gtk_scrolled_window_struct_hscrollbar_visible (a_c_struct: POINTER; a_hscrollbar_visible: INTEGER) is
			-- (from C_GTK_SCROLLED_window_STRUCT)
		do
		end

	frozen set_gtk_scrolled_window_struct_vscrollbar (a_c_struct: POINTER; a_vscrollbar: POINTER) is
			-- (from C_GTK_SCROLLED_window_STRUCT)
		do
		end

	frozen set_gtk_scrolled_window_struct_vscrollbar_policy (a_c_struct: POINTER; a_vscrollbar_policy: INTEGER) is
			-- (from C_GTK_SCROLLED_window_STRUCT)
		do
		end

	frozen set_gtk_scrolled_window_struct_vscrollbar_visible (a_c_struct: POINTER; a_vscrollbar_visible: INTEGER) is
			-- (from C_GTK_SCROLLED_window_STRUCT)
		do
		end

	frozen set_gtk_scrolled_window_struct_window_placement (a_c_struct: POINTER; a_window_placement: INTEGER) is
			-- (from C_GTK_SCROLLED_window_STRUCT)
		do
		end

	frozen set_gtk_spin_button_struct_adjustment (a_c_struct: POINTER; a_adjustment: POINTER) is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen set_gtk_spin_button_struct_button (a_c_struct: POINTER; a_button: INTEGER) is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen set_gtk_spin_button_struct_climb_rate (a_c_struct: POINTER; a_climb_rate: REAL) is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen set_gtk_spin_button_struct_need_timer (a_c_struct: POINTER; a_need_timer: INTEGER) is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen set_gtk_spin_button_struct_numeric (a_c_struct: POINTER; a_numeric: INTEGER) is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen set_gtk_spin_button_struct_panel (a_c_struct: POINTER; a_panel: POINTER) is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen set_gtk_spin_button_struct_snap_to_ticks (a_c_struct: POINTER; a_snap_to_ticks: INTEGER) is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen set_gtk_spin_button_struct_timer (a_c_struct: POINTER; a_timer: INTEGER) is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen set_gtk_spin_button_struct_timer_calls (a_c_struct: POINTER; a_timer_calls: INTEGER) is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen set_gtk_spin_button_struct_timer_step (a_c_struct: POINTER; a_timer_step: REAL) is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen set_gtk_spin_button_struct_update_policy (a_c_struct: POINTER; a_update_policy: INTEGER) is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen set_gtk_spin_button_struct_wrap (a_c_struct: POINTER; a_wrap: INTEGER) is
			-- (from C_GTK_SPIN_BUTTON_STRUCT)
		do
		end

	frozen set_gtk_style_struct_attach_count (a_c_struct: POINTER; a_attach_count: INTEGER) is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen set_gtk_style_struct_black_gc (a_c_struct: POINTER; a_black_gc: POINTER) is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen set_gtk_style_struct_colormap (a_c_struct: POINTER; a_colormap: POINTER) is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen set_gtk_style_struct_depth (a_c_struct: POINTER; a_depth: INTEGER) is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen set_gtk_style_struct_rc_style (a_c_struct: POINTER; a_rc_style: POINTER) is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen set_gtk_style_struct_styles (a_c_struct: POINTER; a_styles: POINTER) is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen set_gtk_style_struct_white_gc (a_c_struct: POINTER; a_white_gc: POINTER) is
			-- (from C_GTK_STYLE_STRUCT)
		do
		end

	frozen set_gtk_table_struct_children (a_c_struct: POINTER; a_children: POINTER) is
			-- (from C_GTK_TABLE_STRUCT)
		do
		end

	frozen set_gtk_table_struct_cols (a_c_struct: POINTER; a_cols: POINTER) is
			-- (from C_GTK_TABLE_STRUCT)
		do
		end

	frozen set_gtk_table_struct_homogeneous (a_c_struct: POINTER; a_homogeneous: INTEGER) is
			-- (from C_GTK_TABLE_STRUCT)
		do
		end

	frozen set_gtk_table_struct_rows (a_c_struct: POINTER; a_rows: POINTER) is
			-- (from C_GTK_TABLE_STRUCT)
		do
		end

	frozen set_gtk_toggle_button_struct_active (a_c_struct: POINTER; a_active: INTEGER) is
			-- (from C_GTK_TOGGLE_BUTTON_STRUCT)
		do
		end

	frozen set_gtk_toggle_button_struct_draw_indicator (a_c_struct: POINTER; a_draw_indicator: INTEGER) is
			-- (from C_GTK_TOGGLE_BUTTON_STRUCT)
		do
		end

	frozen set_gtk_tooltips_data_struct_tip_private (a_c_struct: POINTER; a_tip_private: POINTER) is
			-- (from C_GTK_TOOLTIPS_DATA_STRUCT)
		do
		end

	frozen set_gtk_tooltips_data_struct_tip_text (a_c_struct: POINTER; a_tip_text: POINTER) is
			-- (from C_GTK_TOOLTIPS_DATA_STRUCT)
		do
		end

	frozen set_gtk_tooltips_data_struct_tooltips (a_c_struct: POINTER; a_tooltips: POINTER) is
			-- (from C_GTK_TOOLTIPS_DATA_STRUCT)
		do
		end

	frozen set_gtk_tooltips_data_struct_widget (a_c_struct: POINTER; a_widget: POINTER) is
			-- (from C_GTK_TOOLTIPS_DATA_STRUCT)
		do
		end

	frozen set_gtk_tooltips_struct_active_tips_data (a_c_struct: POINTER; a_active_tips_data: POINTER) is
			-- (from C_GTK_TOOLTIPS_STRUCT)
		do
		end

	frozen set_gtk_tooltips_struct_delay (a_c_struct: POINTER; a_delay: INTEGER) is
			-- (from C_GTK_TOOLTIPS_STRUCT)
		do
		end

	frozen set_gtk_tooltips_struct_enabled (a_c_struct: POINTER; a_enabled: INTEGER) is
			-- (from C_GTK_TOOLTIPS_STRUCT)
		do
		end

	frozen set_gtk_tooltips_struct_timer_tag (a_c_struct: POINTER; a_timer_tag: INTEGER) is
			-- (from C_GTK_TOOLTIPS_STRUCT)
		do
		end

	frozen set_gtk_tooltips_struct_tip_window (a_c_struct: POINTER; a_tip_window: POINTER) is
			-- (from C_GTK_TOOLTIPS_STRUCT)
		do
		end

	frozen set_gtk_tooltips_struct_tips_data_list (a_c_struct: POINTER; a_tips_data_list: POINTER) is
			-- (from C_GTK_TOOLTIPS_STRUCT)
		do
		end

	frozen set_gtk_viewport_struct_bin_window (a_c_struct: POINTER; a_bin_window: POINTER) is
			-- (from C_GTK_VIEWPORT_STRUCT)
		do
		end

	frozen set_gtk_viewport_struct_hadjustment (a_c_struct: POINTER; a_hadjustment: POINTER) is
			-- (from C_GTK_VIEWPORT_STRUCT)
		do
		end

	frozen set_gtk_viewport_struct_shadow_type (a_c_struct: POINTER; a_shadow_type: INTEGER) is
			-- (from C_GTK_VIEWPORT_STRUCT)
		do
		end

	frozen set_gtk_viewport_struct_vadjustment (a_c_struct: POINTER; a_vadjustment: POINTER) is
			-- (from C_GTK_VIEWPORT_STRUCT)
		do
		end

	frozen set_gtk_viewport_struct_view_window (a_c_struct: POINTER; a_view_window: POINTER) is
			-- (from C_GTK_VIEWPORT_STRUCT)
		do
		end

	frozen set_gtk_widget_struct_name (a_c_struct: POINTER; a_name: POINTER) is
			-- (from C_GTK_WIDGET_STRUCT)
		do
		end

	frozen set_gtk_widget_struct_parent (a_c_struct: POINTER; a_parent: POINTER) is
			-- (from C_GTK_WIDGET_STRUCT)
		do
		end

	frozen set_gtk_widget_struct_saved_state (a_c_struct: POINTER; a_saved_state: INTEGER) is
			-- (from C_GTK_WIDGET_STRUCT)
		do
		end

	frozen set_gtk_widget_struct_state (a_c_struct: POINTER; a_state: INTEGER) is
			-- (from C_GTK_WIDGET_STRUCT)
		do
		end

	frozen set_gtk_widget_struct_style (a_c_struct: POINTER; a_style: POINTER) is
			-- (from C_GTK_WIDGET_STRUCT)
		do
		end

	frozen set_gtk_window_struct_allow_grow (a_c_struct: POINTER; a_allow_grow: INTEGER) is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen set_gtk_window_struct_allow_shrink (a_c_struct: POINTER; a_allow_shrink: INTEGER) is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen set_gtk_window_struct_default_widget (a_c_struct: POINTER; a_default_widget: POINTER) is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen set_gtk_window_struct_focus_widget (a_c_struct: POINTER; a_focus_widget: POINTER) is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen set_gtk_window_struct_modal (a_c_struct: POINTER; a_modal: INTEGER) is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen set_gtk_window_struct_position (a_c_struct: POINTER; a_position: INTEGER) is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen set_gtk_window_struct_title (a_c_struct: POINTER; a_title: POINTER) is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen set_gtk_window_struct_transient_parent (a_c_struct: POINTER; a_transient_parent: POINTER) is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen set_gtk_window_struct_type (a_c_struct: POINTER; a_type: INTEGER) is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen set_gtk_window_struct_wmclass_class (a_c_struct: POINTER; a_wmclass_class: POINTER) is
			-- (from C_GTK_window_STRUCT)
		do
		end

	frozen set_gtk_window_struct_wmclass_name (a_c_struct: POINTER; a_wmclass_name: POINTER) is
			-- (from C_GTK_window_STRUCT)
		do
		end

feature -- Externals

	frozen gdk_display: POINTER is
			-- Display * Result
			-- (from EV_C_GTK)
		do
		end

feature -- Memory allocation

	frozen c_gdk_rectangle_struct_allocate: POINTER is
			-- New GdkColor struct allocaded by calloc.
		do
		end

	frozen c_gdk_color_struct_allocate: POINTER is
			-- New GdkColor struct allocaded by calloc.
		do
		end

	frozen c_gdk_gcvalues_struct_allocate: POINTER is
			-- New GdkGCValues struct allocaded by calloc.
		do
		end

	frozen c_gdk_geometry_struct_allocate: POINTER is
			-- New GdkGeometry struct allocaded by calloc.
		do
		end

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class EV_GTK_EXTERNALS

