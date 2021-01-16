dnl
dnl  This is an example configure.ac that demonstrates how to use the buildsys.
dnl  You should not just copy it, but edit it to fit your needs!
dnl
dnl  To generate the configure script, call:
dnl    aclocal -I m4
dnl    autoconf
dnl

dnl Specify name, version and contact e-mail of the package.
AC_INIT(name, version, e-mail)
dnl Specifies where your sources are.
AC_CONFIG_SRCDIR(src)
AC_CONFIG_AUX_DIR(build-aux)
AC_CONFIG_MACRO_DIR(build-aux/m4)

for i in configure.ac build-aux/m4/*; do
	AS_IF([test $i -nt configure], [
		AC_MSG_ERROR([$i is newer than configure! Run ./autogen.sh!])
	])
done

BUILDSYS_INIT

dnl If your package uses C, you want a C compiler and a C preprocessor
AC_PROG_CC
AC_PROG_CPP

dnl The buildsys might require ln -s to install libraries.
dnl Uncomment if you are compiling a library.
dnl AC_PROG_LN_S

dnl If you want to build static libraries (for example build part of your
dnl project as a static library and link it to the final program later so you
dnl can easier split your program into multiple directories), you need to
dnl uncomment the following line. This is also needed if you build .a files in
dnl subdirectories that you then link into a shared library or application in 
dnl the end.
dnl AC_PATH_TOOL(AR, ar)

dnl If you want to build a shared library, you need to call BUILDSYS_SHARED_LIB.
dnl It will automatically set the required LIB_* and PLUGIN_* variables.
dnl See m4/buildsys.m4 for more details.
dnl Uncomment the following line if you want to build a shared library.
dnl BUILDSYS_SHARED_LIB

dnl If your program uses plugins and should run on win32 as well, you need to
dnl uncomment the following line
dnl BUILDSYS_PROG_IMPLIB

dnl If you don't need any extra variables
AC_CONFIG_FILES(buildsys.mk)
dnl If you need any extra variables, they go to extra.mk.
dnl If you use extra variables, comment the line above and uncomment the line
dnl below.
dnl AC_CONFIG_FILES([buildsys.mk extra.mk])

dnl Write out configure script
AC_OUTPUT
