AC_INIT([bing-wallpaper-setter],[0.1])
AM_INIT_AUTOMAKE

AC_PROG_CC
AM_PROG_VALAC

VALA_CHECK_MODULES(LibXml2, [libxml-2.0],,[AC_ERROR([libxml2 not found!])])
VALA_CHECK_MODULES(Gtk3, [gtk+-3.0],,[AC_ERROR([Gtk+ 3.0 not found!])])

AC_OUTPUT([Makefile])
