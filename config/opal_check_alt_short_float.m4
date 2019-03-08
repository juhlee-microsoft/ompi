dnl -*- shell-script -*-
dnl
dnl Copyright (c) 2018      FUJITSU LIMITED.  All rights reserved.
dnl $COPYRIGHT$
dnl
dnl Additional copyrights may follow
dnl
dnl $HEADER$
dnl

# Check whether the user wants to use an alternate type of C 'short float'.

# OPAL_CHECK_ALT_SHORT_FLOAT
# ------------------------------------------------------------
AC_DEFUN([OPAL_CHECK_ALT_SHORT_FLOAT], [
    AC_CHECK_TYPES(_Float16)
    AC_MSG_CHECKING([if want alternate C type of short float])
    AC_ARG_ENABLE(alt-short-float,
        AC_HELP_STRING([--enable-alt-short-float=TYPE],
                       [Use an alternate C type TYPE of 'short float' if 'short float' is not available on the C compiler. 'short float' is a new C type proposed for the next C language standard in ISO/IEC JTC 1/SC 22 WG 14 (C WG). (default: "_Float16" if available, disabled otherwise)]))
    if test "$enable_alt_short_float" = "yes"; then
        AC_MSG_ERROR([--enable-alt-short-float must have an argument.])
    elif test "$enable_alt_short_float" = "no"; then
        :
    elif test "$enable_alt_short_float" != ""; then
        opal_short_float_type="$enable_alt_short_float"
        opal_short_float_complex_type="$enable_alt_short_float [[2]]"
    elif test "$ac_cv_type_short_float" = "yes" && \
         test "$ac_cv_type_short_float__Complex" = "yes"; then
        opal_short_float_type="short float"
        opal_short_float_complex_type="short float _Complex"
    elif test "$ac_cv_type__Float16" = "yes"; then
        opal_short_float_type="_Float16"
        opal_short_float_complex_type="_Float16 [[2]]"
    fi
    if test "$opal_short_float_type" != ""; then
        AC_MSG_RESULT([yes ($opal_short_float_type)])
        AC_CHECK_TYPES($opal_short_float_type, [opal_enable_short_float=1], [opal_enable_short_float=0])
        if test "$opal_enable_short_float" = 1; then
            AC_DEFINE_UNQUOTED(opal_short_float_t, [[$opal_short_float_type]],
                               [User-selected alternate C type of short float])
            AC_DEFINE_UNQUOTED(opal_short_float_complex_t, [[$opal_short_float_complex_type]],
                               [User-selected alternate C type of short float _Complex])
            AC_CHECK_TYPES(opal_short_float_t)
            AC_CHECK_TYPES(opal_short_float_complex_t)
            AC_CHECK_SIZEOF(opal_short_float_t)
            AC_CHECK_SIZEOF(opal_short_float_complex_t)
            OPAL_C_GET_ALIGNMENT(opal_short_float_t, OPAL_ALIGNMENT_OPAL_SHORT_FLOAT_T)
        elif test "$enable_alt_short_float" != ""; then
            AC_MSG_ERROR([Alternate C type of short float $opal_short_float_type requested but not available.  Aborting])
        fi
    else
        AC_MSG_RESULT([no])
    fi
])
