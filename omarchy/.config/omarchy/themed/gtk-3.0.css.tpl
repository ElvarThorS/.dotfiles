/* Auto-generated from Omarchy theme colors */

@define-color theme_bg_color {{ background }};
@define-color theme_fg_color {{ foreground }};
@define-color theme_base_color {{ background }};
@define-color theme_text_color {{ foreground }};
@define-color theme_selected_bg_color {{ selection_background }};
@define-color theme_selected_fg_color {{ selection_foreground }};
@define-color theme_accent {{ accent }};
@define-color theme_border alpha({{ foreground }}, 0.12);

* {
  text-shadow: none;
}

window,
dialog,
messagedialog,
.background,
.view,
.content-view,
scrolledwindow viewport {
  background-color: @theme_bg_color;
  color: @theme_fg_color;
}

headerbar,
.titlebar {
  background-color: alpha(@theme_bg_color, 0.98);
  color: @theme_fg_color;
  border-bottom: 1px solid @theme_border;
}

sidebar,
.sidebar,
.navigation-sidebar {
  background-color: alpha(@theme_bg_color, 0.96);
  color: @theme_fg_color;
  border-right: 1px solid @theme_border;
}

sidebar row:selected,
.sidebar row:selected,
.navigation-sidebar row:selected {
  background-color: alpha(@theme_accent, 0.28);
  color: @theme_fg_color;
}
