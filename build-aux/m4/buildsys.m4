dnl
dnl Copyright (c) 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2016, 2017,
dnl               2018, 2020, 2021, 2022, 2023, 2024
dnl   Jonathan Schleifer <js@nil.im>
dnl
dnl https://fl.nil.im/buildsys
dnl
dnl Permission to use, copy, modify, and/or distribute this software for any
dnl purpose with or without fee is hereby granted, provided that the above
dnl copyright notice and this permission notice appear in all copies.
dnl
dnl THE SOFTWARE IS PROVIDED "AS IS" AND ISC DISCLAIMS ALL WARRANTIES WITH
dnl REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
dnl AND FITNESS.  IN NO EVENT SHALL ISC BE LIABLE FOR ANY SPECIAL, DIRECT,
dnl INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
dnl LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
dnl OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
dnl PERFORMANCE OF THIS SOFTWARE.
dnl

AC_DEFUN([BUILDSYS_INIT], [
	AC_REQUIRE([AC_CANONICAL_BUILD])
	AC_REQUIRE([AC_CANONICAL_HOST])

	AC_ARG_ENABLE(rpath,
		AS_HELP_STRING([--disable-rpath], [do not use rpath]))

	AC_ARG_ENABLE(silent-rules,
		AS_HELP_STRING([--disable-silent-rules],
			[print executed commands during build]))

	case "$build_os" in
	darwin*)
		case "$host_os" in
		darwin*)
			AC_SUBST(BUILD_AND_HOST_ARE_DARWIN, yes)
			;;
		esac
		;;
	esac

	AC_PROG_INSTALL
	case "$INSTALL" in
	./build-aux/install-sh*)
		INSTALL="$PWD/$INSTALL"
		;;
	esac

	AC_CONFIG_COMMANDS_PRE([
		AS_IF([test x"$GCC" = x"yes"],
			[AC_SUBST(DEP_CFLAGS, '-MD -MF $${out%.o}.dep')])
		AS_IF([test x"$GXX" = x"yes"],
			[AC_SUBST(DEP_CXXFLAGS, '-MD -MF $${out%.o}.dep')])
		AS_IF([test x"$GOBJC" = x"yes"],
			[AC_SUBST(DEP_OBJCFLAGS, '-MD -MF $${out%.o}.dep')])
		AS_IF([test x"$GOBJCXX" = x"yes"],
			[AC_SUBST(DEP_OBJCXXFLAGS, '-MD -MF $${out%.o}.dep')])

		AC_SUBST(AMIGA_LIB_CFLAGS)
		AC_SUBST(AMIGA_LIB_LDFLAGS)

		case "$build_os" in
		morphos*)
			dnl Don't use tput on MorphOS: The colored output is
			dnl quite unreadable and in some MorphOS versions the
			dnl output from tput is not 8-bit safe, with awk (for
			dnl AC_SUBST) failing as a result.
			;;
		*)
			AC_PATH_PROG(TPUT, tput)
			;;
		esac

		AS_IF([test x"$TPUT" != x""], [
			if x=$($TPUT el 2>/dev/null); then
				AC_SUBST(TERM_EL, "$x")
			else
				AC_SUBST(TERM_EL, "$($TPUT ce 2>/dev/null)")
			fi

			if x=$($TPUT sgr0 2>/dev/null); then
				AC_SUBST(TERM_SGR0, "$x")
			else
				AC_SUBST(TERM_SGR0, "$($TPUT me 2>/dev/null)")
			fi

			if x=$($TPUT bold 2>/dev/null); then
				AC_SUBST(TERM_BOLD, "$x")
			else
				AC_SUBST(TERM_BOLD, "$($TPUT md 2>/dev/null)")
			fi

			if x=$($TPUT setaf 1 2>/dev/null); then
				AC_SUBST(TERM_SETAF1, "$x")
				AC_SUBST(TERM_SETAF2,
					"$($TPUT setaf 2 2>/dev/null)")
				AC_SUBST(TERM_SETAF3,
					"$($TPUT setaf 3 2>/dev/null)")
				AC_SUBST(TERM_SETAF4,
					"$($TPUT setaf 4 2>/dev/null)")
				AC_SUBST(TERM_SETAF6,
					"$($TPUT setaf 6 2>/dev/null)")
				AC_SUBST(TERM_SETAF9,
					"$($TPUT setaf 9 2>/dev/null)")
				AC_SUBST(TERM_SETAF10,
					"$($TPUT setaf 10 2>/dev/null)")
				AC_SUBST(TERM_SETAF11,
					"$($TPUT setaf 11 2>/dev/null)")
				AC_SUBST(TERM_SETAF12,
					"$($TPUT setaf 12 2>/dev/null)")
				AC_SUBST(TERM_SETAF14,
					"$($TPUT setaf 14 2>/dev/null)")
			dnl OpenBSD seems to want 3 parameters for terminals
			dnl ending in -256color, but the additional two
			dnl parameters don't seem to do anything, so we set
			dnl them to 0.
			elif x=$($TPUT setaf 1 0 0 2>/dev/null); then
				AC_SUBST(TERM_SETAF1, "$x")
				AC_SUBST(TERM_SETAF2,
					"$($TPUT setaf 2 0 0 2>/dev/null)")
				AC_SUBST(TERM_SETAF3,
					"$($TPUT setaf 3 0 0 2>/dev/null)")
				AC_SUBST(TERM_SETAF4,
					"$($TPUT setaf 4 0 0 2>/dev/null)")
				AC_SUBST(TERM_SETAF6,
					"$($TPUT setaf 6 0 0 2>/dev/null)")
				AC_SUBST(TERM_SETAF9,
					"$($TPUT setaf 9 0 0 2>/dev/null)")
				AC_SUBST(TERM_SETAF10,
					"$($TPUT setaf 10 0 0 2>/dev/null)")
				AC_SUBST(TERM_SETAF11,
					"$($TPUT setaf 11 0 0 2>/dev/null)")
				AC_SUBST(TERM_SETAF12,
					"$($TPUT setaf 12 0 0 2>/dev/null)")
				AC_SUBST(TERM_SETAF14,
					"$($TPUT setaf 14 0 0 2>/dev/null)")
			else
				AC_SUBST(TERM_SETAF1,
					"$($TPUT AF 1 2>/dev/null)")
				AC_SUBST(TERM_SETAF2,
					"$($TPUT AF 2 2>/dev/null)")
				AC_SUBST(TERM_SETAF3,
					"$($TPUT AF 3 2>/dev/null)")
				AC_SUBST(TERM_SETAF4,
					"$($TPUT AF 4 2>/dev/null)")
				AC_SUBST(TERM_SETAF6,
					"$($TPUT AF 6 2>/dev/null)")
				AC_SUBST(TERM_SETAF9,
					"$($TPUT AF 9 2>/dev/null)")
				AC_SUBST(TERM_SETAF10,
					"$($TPUT AF 10 2>/dev/null)")
				AC_SUBST(TERM_SETAF11,
					"$($TPUT AF 11 2>/dev/null)")
				AC_SUBST(TERM_SETAF12,
					"$($TPUT AF 12 2>/dev/null)")
				AC_SUBST(TERM_SETAF14,
					"$($TPUT AF 14 2>/dev/null)")
			fi
		])

		AS_IF([test x"$enable_silent_rules" != x"no"], [
			AC_SUBST(SILENT, '.SILENT:')
			AC_SUBST(MAKEFLAGS_SILENT, '-s')
		])
	])
])

AC_DEFUN([BUILDSYS_CHECK_IOS], [
	case "$host_os" in
	darwin*)
		AC_MSG_CHECKING(whether host is iOS)
		AC_EGREP_CPP(yes, [
			#include <TargetConditionals.h>

			#if (defined(TARGET_OS_IPHONE) && TARGET_OS_IPHONE) || \
			    (defined(TARGET_OS_SIMULATOR) && \
			    TARGET_OS_SIMULATOR)
			yes
			#endif
		], [
			host_is_ios="yes"
			AC_SUBST(HOST_IS_IOS, yes)
		], [
			host_is_ios="no"
		])
		AC_MSG_RESULT($host_is_ios)
		AC_CHECK_TOOL(CODESIGN, codesign)
		;;
	esac
])

AC_DEFUN([BUILDSYS_PROG_IMPLIB], [
	AC_REQUIRE([AC_CANONICAL_HOST])
	AC_MSG_CHECKING(whether we need an implib)
	case "$host_os" in
	cygwin* | mingw*)
		AC_MSG_RESULT(yes)
		PROG_IMPLIB_NEEDED='yes'
		PROG_IMPLIB_LDFLAGS='-Wl,--export-all-symbols,--out-implib,lib${PROG}.a'
		;;
	*)
		AC_MSG_RESULT(no)
		PROG_IMPLIB_NEEDED='no'
		PROG_IMPLIB_LDFLAGS=''
		;;
	esac

	AC_SUBST(PROG_IMPLIB_NEEDED)
	AC_SUBST(PROG_IMPLIB_LDFLAGS)
])

AC_DEFUN([BUILDSYS_SHARED_LIB], [
	AC_REQUIRE([AC_CANONICAL_HOST])
	AC_REQUIRE([BUILDSYS_CHECK_IOS])
	AC_MSG_CHECKING(for shared library type)

	case "$host" in
	*-*-darwin*)
		AC_MSG_RESULT(Darwin)
		LIB_CFLAGS='-fPIC -DPIC'
		LIB_LDFLAGS='-dynamiclib -current_version ${LIB_MAJOR}.${LIB_MINOR} -compatibility_version ${LIB_MAJOR}'
		LIB_LDFLAGS_INSTALL_NAME='-Wl,-install_name,${libdir}/$${out%.dylib}.${LIB_MAJOR}.dylib'
		LIB_PREFIX='lib'
		LIB_SUFFIX='.dylib'
		AS_IF([test x"$enable_rpath" != x"no"], [
			LDFLAGS_RPATH='-Wl,-rpath,${libdir}'
		])
		INSTALL_LIB='&& ${INSTALL} -m 755 $$i ${DESTDIR}${libdir}/$${i%.dylib}.${LIB_MAJOR}.${LIB_MINOR}.dylib && ${LN_S} -f $${i%.dylib}.${LIB_MAJOR}.${LIB_MINOR}.dylib ${DESTDIR}${libdir}/$${i%.dylib}.${LIB_MAJOR}.dylib && ${LN_S} -f $${i%.dylib}.${LIB_MAJOR}.${LIB_MINOR}.dylib ${DESTDIR}${libdir}/$$i'
		UNINSTALL_LIB='&& rm -f ${DESTDIR}${libdir}/$$i ${DESTDIR}${libdir}/$${i%.dylib}.${LIB_MAJOR}.dylib ${DESTDIR}${libdir}/$${i%.dylib}.${LIB_MAJOR}.${LIB_MINOR}.dylib'
		CLEAN_LIB=''
		;;
	*-*-mingw* | *-*-cygwin*)
		AC_MSG_RESULT(MinGW / Cygwin)
		LIB_CFLAGS=''
		LIB_LDFLAGS='-shared -Wl,--export-all-symbols'
		LIB_LDFLAGS_INSTALL_NAME=''
		LIB_PREFIX=''
		LIB_SUFFIX='${LIB_MAJOR}.dll'
		LINK_LIB='&& rm -f lib$${out%${LIB_SUFFIX}}.dll.a && ${LN_S} $$out lib$${out%${LIB_SUFFIX}}.dll.a'
		INSTALL_LIB='&& ${MKDIR_P} ${DESTDIR}${bindir} && ${INSTALL} -m 755 $$i ${DESTDIR}${bindir}/$$i && ${INSTALL} -m 755 lib$${i%${LIB_SUFFIX}}.dll.a ${DESTDIR}${libdir}/lib$${i%${LIB_SUFFIX}}.dll.a'
		UNINSTALL_LIB='&& rm -f ${DESTDIR}${bindir}/$$i ${DESTDIR}${libdir}/lib$${i%${LIB_SUFFIX}}.dll.a'
		CLEAN_LIB='${SHARED_LIB}.a ${SHARED_LIB_NOINST}.a'
		;;
	*-*-openbsd* | *-*-mirbsd*)
		AC_MSG_RESULT(OpenBSD)
		LIB_CFLAGS='-fPIC -DPIC'
		LIB_LDFLAGS='-shared'
		LIB_LDFLAGS_INSTALL_NAME=''
		LIB_PREFIX='lib'
		LIB_SUFFIX='.so.${LIB_MAJOR}.${LIB_MINOR}'
		AS_IF([test x"$enable_rpath" != x"no"], [
			LDFLAGS_RPATH='-Wl,-rpath,${libdir}'
		])
		INSTALL_LIB='&& ${INSTALL} -m 755 $$i ${DESTDIR}${libdir}/$$i'
		UNINSTALL_LIB='&& rm -f ${DESTDIR}${libdir}/$$i'
		CLEAN_LIB=''
		;;
	*-*-solaris*)
		AC_MSG_RESULT(Solaris)
		LIB_CFLAGS='-fPIC -DPIC'
		LIB_LDFLAGS='-shared -Wl,-soname=$$out.${LIB_MAJOR}.${LIB_MINOR}'
		LIB_LDFLAGS_INSTALL_NAME=''
		LIB_PREFIX='lib'
		LIB_SUFFIX='.so'
		AS_IF([test x"$enable_rpath" != x"no"], [
			LDFLAGS_RPATH='-Wl,-rpath,${libdir}'
		])
		INSTALL_LIB='&& ${INSTALL} -m 755 $$i ${DESTDIR}${libdir}/$$i.${LIB_MAJOR}.${LIB_MINOR} && rm -f ${DESTDIR}${libdir}/$$i && ${LN_S} $$i.${LIB_MAJOR}.${LIB_MINOR} ${DESTDIR}${libdir}/$$i'
		UNINSTALL_LIB='&& rm -f ${DESTDIR}${libdir}/$$i ${DESTDIR}${libdir}/$$i.${LIB_MAJOR}.${LIB_MINOR}'
		CLEAN_LIB=''
		;;
	*-*-android*)
		AC_MSG_RESULT(Android)
		LIB_CFLAGS='-fPIC -DPIC'
		LIB_LDFLAGS='-shared -Wl,-soname=$$out.${LIB_MAJOR}'
		LIB_LDFLAGS_INSTALL_NAME=''
		LIB_PREFIX='lib'
		LIB_SUFFIX='.so'
		INSTALL_LIB='&& ${INSTALL} -m 755 $$i ${DESTDIR}${libdir}/$$i.${LIB_MAJOR}.${LIB_MINOR}.${LIB_PATCH} && ${LN_S} -f $$i.${LIB_MAJOR}.${LIB_MINOR}.${LIB_PATCH} ${DESTDIR}${libdir}/$$i.${LIB_MAJOR} && ${LN_S} -f $$i.${LIB_MAJOR}.${LIB_MINOR}.${LIB_PATCH} ${DESTDIR}${libdir}/$$i'
		UNINSTALL_LIB='&& rm -f ${DESTDIR}${libdir}/$$i ${DESTDIR}${libdir}/$$i.${LIB_MAJOR} ${DESTDIR}${libdir}/$$i.${LIB_MAJOR}.${LIB_MINOR}.${LIB_PATCH}'
		CLEAN_LIB=''
		;;
	hppa*-*-hpux*)
		AC_MSG_RESULT([HP-UX (PA-RISC)])
		LIB_CFLAGS='-fPIC -DPIC'
		LIB_LDFLAGS='-shared -Wl,+h,$$out'
		LIB_LDFLAGS_INSTALL_NAME=''
		LIB_PREFIX='lib'
		LIB_SUFFIX='.${LIB_MAJOR}'
		LINK_LIB='&& rm -f $${out%%.*}.sl && ${LN_S} $$out $${out%%.*}.sl'
		AS_IF([test x"$enable_rpath" != x"no"], [
			LDFLAGS_RPATH='-Wl,+b,${libdir}'
		])
		INSTALL_LIB='&& ${INSTALL} -m 755 $$i ${DESTDIR}${libdir}/$$i && ${LN_S} -f $$i ${DESTDIR}${libdir}/$${i%%.*}.sl'
		UNINSTALL_LIB='&& rm -f ${DESTDIR}${libdir}/$$i ${DESTDIR}${libdir}/$${i%%.*}.sl'
		CLEAN_LIB=''
		;;
	ia64*-*-hpux*)
		AC_MSG_RESULT([HP-UX (Itanium)])
		LIB_CFLAGS='-fPIC -DPIC'
		LIB_LDFLAGS='-shared -Wl,+h,$$out'
		LIB_LDFLAGS_INSTALL_NAME=''
		LIB_PREFIX='lib'
		LIB_SUFFIX='.${LIB_MAJOR}'
		LINK_LIB='&& rm -f $${out%%.*}.so && ${LN_S} $$out $${out%%.*}.so'
		AS_IF([test x"$enable_rpath" != x"no"], [
			LDFLAGS_RPATH='-Wl,+b,${libdir}'
		])
		INSTALL_LIB='&& ${INSTALL} -m 755 $$i ${DESTDIR}${libdir}/$$i && ${LN_S} -f $$i ${DESTDIR}${libdir}/$${i%%.*}.so'
		UNINSTALL_LIB='&& rm -f ${DESTDIR}${libdir}/$$i ${DESTDIR}${libdir}/$${i%%.*}.so'
		CLEAN_LIB=''
		;;
	*)
		AC_MSG_RESULT(ELF)
		LIB_CFLAGS='-fPIC -DPIC'
		LIB_LDFLAGS='-shared -Wl,-soname=$$out.${LIB_MAJOR}'
		LIB_LDFLAGS_INSTALL_NAME=''
		LIB_PREFIX='lib'
		LIB_SUFFIX='.so'
		AS_IF([test x"$enable_rpath" != x"no"], [
			LDFLAGS_RPATH='-Wl,-rpath,${libdir}'
		])
		INSTALL_LIB='&& ${INSTALL} -m 755 $$i ${DESTDIR}${libdir}/$$i.${LIB_MAJOR}.${LIB_MINOR}.${LIB_PATCH} && ${LN_S} -f $$i.${LIB_MAJOR}.${LIB_MINOR}.${LIB_PATCH} ${DESTDIR}${libdir}/$$i.${LIB_MAJOR} && ${LN_S} -f $$i.${LIB_MAJOR}.${LIB_MINOR}.${LIB_PATCH} ${DESTDIR}${libdir}/$$i'
		UNINSTALL_LIB='&& rm -f ${DESTDIR}${libdir}/$$i ${DESTDIR}${libdir}/$$i.${LIB_MAJOR} ${DESTDIR}${libdir}/$$i.${LIB_MAJOR}.${LIB_MINOR}.${LIB_PATCH}'
		CLEAN_LIB=''
		;;
	esac

	AC_SUBST(LIB_CFLAGS)
	AC_SUBST(LIB_LDFLAGS)
	AC_SUBST(LIB_LDFLAGS_INSTALL_NAME)
	AC_SUBST(LIB_PREFIX)
	AC_SUBST(LIB_SUFFIX)
	AC_SUBST(LINK_LIB)
	AC_SUBST(LDFLAGS_RPATH)
	AC_SUBST(INSTALL_LIB)
	AC_SUBST(UNINSTALL_LIB)
	AC_SUBST(CLEAN_LIB)
])

AC_DEFUN([BUILDSYS_FRAMEWORK], [
	AC_REQUIRE([AC_CANONICAL_HOST])
	AC_REQUIRE([BUILDSYS_CHECK_IOS])
	AC_REQUIRE([BUILDSYS_SHARED_LIB])

	case "$host_os" in
	darwin*)
		FRAMEWORK_LDFLAGS='-dynamiclib -current_version ${LIB_MAJOR}.${LIB_MINOR} -compatibility_version ${LIB_MAJOR}'
		AS_IF([test x"$host_is_ios" = x"yes"], [
			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,@executable_path/Frameworks/$$out/$${out%.framework}'
		], [
			FRAMEWORK_LDFLAGS_INSTALL_NAME='-Wl,-install_name,@executable_path/../Frameworks/$$out/$${out%.framework}'
		])

		AC_SUBST(FRAMEWORK_LDFLAGS)
		AC_SUBST(FRAMEWORK_LDFLAGS_INSTALL_NAME)
		AC_SUBST(FRAMEWORK_LIBS)

		$1
		;;
	*)
		$2
		;;
	esac
])

AC_DEFUN([BUILDSYS_PLUGIN], [
	AC_REQUIRE([AC_CANONICAL_HOST])
	AC_REQUIRE([BUILDSYS_CHECK_IOS])
	AC_MSG_CHECKING(for plugin type)

	case "$host" in
	*-*-darwin*)
		AC_MSG_RESULT(Darwin)
		PLUGIN_CFLAGS='-fPIC -DPIC'
		PLUGIN_LDFLAGS='-bundle'
		PLUGIN_SUFFIX='.dylib'
		;;
	*-*-mingw* | *-*-cygwin*)
		AC_MSG_RESULT(MinGW / Cygwin)
		PLUGIN_CFLAGS=''
		PLUGIN_LDFLAGS='-shared -Wl,--export-all-symbols'
		PLUGIN_SUFFIX='.dll'
		;;
	hppa*-*-hpux*)
		AC_MSG_RESULT([HP-UX (PA-RISC)])
		PLUGIN_CFLAGS='-fPIC -DPIC'
		PLUGIN_LDFLAGS='-shared'
		PLUGIN_SUFFIX='.sl'
		;;
	*)
		AC_MSG_RESULT(ELF)
		PLUGIN_CFLAGS='-fPIC -DPIC'
		PLUGIN_LDFLAGS='-shared'
		PLUGIN_SUFFIX='.so'
		;;
	esac

	AC_SUBST(PLUGIN_CFLAGS)
	AC_SUBST(PLUGIN_LDFLAGS)
	AC_SUBST(PLUGIN_SUFFIX)
])

AC_DEFUN([BUILDSYS_BUNDLE], [
	AC_REQUIRE([AC_CANONICAL_HOST])
	AC_REQUIRE([BUILDSYS_CHECK_IOS])
	AC_REQUIRE([BUILDSYS_PLUGIN])

	case "$host_os" in
	darwin*)
		AS_IF([test x"$host_is_ios" = x"yes"], [
			LINK_BUNDLE='${MKDIR_P} $$out && ${INSTALL} -m 644 Info.plist $$out/Info.plist && ${LD} -o $$out/$${out%.bundle} ${PLUGIN_OBJS} ${PLUGIN_OBJS_EXTRA} ${PLUGIN_LDFLAGS} ${LDFLAGS} ${LIBS}'
		], [
			LINK_BUNDLE='${MKDIR_P} $$out/Contents/MacOS && ${INSTALL} -m 644 Info.plist $$out/Contents/Info.plist && ${LD} -o $$out/Contents/MacOS/$${out%.bundle} ${PLUGIN_OBJS} ${PLUGIN_OBJS_EXTRA} ${PLUGIN_LDFLAGS} ${LDFLAGS} ${LIBS}'
		])

		AC_SUBST(LINK_BUNDLE)

		$1
		;;
	*)
		$2
		;;
	esac
])
