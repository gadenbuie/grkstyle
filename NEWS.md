# grkstyle 0.2.1

* Added `grk_reindent_auto_pkg()` function, which I messed when adding the auto
  re-indentation functions.

# grkstyle 0.2.0

* `grk_style_*()` text, file, directory and package styling functions will now
  follow the tabs or spaces settings from the RStudio project file. You can
  choose this setting in the Code Editing panel of the Project Options settings.
  
* Added `grk_reindent_auto_*()` to automatically re-indent text, file,
  directory or package code according to the RStudio project file setting (or
  the `grkstyle.use_tabs` global R option).

# grkstyle 0.1.1

* Added `grk_reindent_tabs_*()` and `grk_reindent_spaces_*()` helper functions
  that re-indent text, files, directories or packages using tabs or spaces. The
  output uses the option in the function name: `grk_reindent_tabs_pkg()` will
  re-indent package code using a single tab for indentation.

# grkstyle 0.1.0

* Tabs are now preferred by default over spaces (#7).
