{ programs, ... }: {
  programs.terminator = {
    enable = true;
    config = {
      global_config = {
        geometry_hinting = true;
        title_hide_sizetext = true;
        title_transmit_fg_color = "#282a36";
        title_transmit_bg_color = "#50fa7b";
        title_receive_fg_color = "#282a36";
        title_receive_bg_color = "#ff79c6";
        title_inactive_fg_color = "#f8f8f2";
        title_inactive_bg_color = "#44475a";
        inactive_color_offset = 0.61;
      };
      keybindings = {
        new_window = "<Ctrl><Shift>n";
        go_up = "<Ctrl><Shift>k";
        go_down = "<Ctrl><Shift>j";
        go_left = "<Ctrl><Shift>h";
        go_right = "<Ctrl><Shift>l";
        split_horiz = "<Ctrl>underscore";
        split_vert = "<Ctrl>bar";
        next_tab = "<Ctrl>Tab";
        prev_tab = "<Ctrl><Shift>Tab";
      };
      profiles = {
        default = {
          use_system_font = false;
          font = "JetBrainsMonoNL Nerd Font Mono 10";

          scrollbar_position = "hidden";

          background_color = "#282a36";
          foreground_color = "#f8f8f2";
          background_image = "None";
          palette =
            "#262626:#e356a7:#42e66c:#e4f34a:#9b6bdf:#e64747:#75d7ec:#efa554:#7a7a7a:#ff79c6:#50fa7b:#f1fa8c:#bd93f9:#ff5555:#8be9fd:#ffb86c";
        };
      };
    };
  };
}
