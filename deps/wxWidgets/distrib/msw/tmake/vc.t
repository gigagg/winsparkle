#!#############################################################################
#! File:    vc.t
#! Purpose: tmake template file from which makefile.vc is generated by running
#!          tmake -t vc wxwin.pro -o makefile.vc
#! Author:  Vadim Zeitlin
#! Created: 14.07.99
#! Version: $Id: vc.t 24417 2003-11-06 15:21:40Z JS $
#!#############################################################################
#${
    #! include the code which parses filelist.txt file and initializes
    #! %wxCommon, %wxGeneric and %wxMSW hashes.
    IncludeTemplate("filelist.t");

    #! now transform these hashes into $project tags
    foreach $file (sort keys %wxGeneric) {
        next if $wxGeneric{$file} =~ /\bU\b/;

        my $tag = "";
        if ( $wxGeneric{$file} =~ /\b(PS|G|16|U)\b/ ) {
            $tag = "WXNONESSENTIALOBJS";
        }
        else {
            $tag = "WXGENERICOBJS";
        }

        $file =~ s/cp?p?$/obj/;
        $project{$tag} .= "\$(GENDIR)\\\$D\\" . $file . " "
    }

    foreach $file (sort keys %wxCommon) {
        next if $wxCommon{$file} =~ /\b(16|U)\b/;

        $file =~ s/cp?p?$/obj/;
        $project{"WXCOMMONOBJS"} .= "\$(COMMDIR)\\\$D\\" . $file . " "
    }

    foreach $file (sort keys %wxMSW) {
        next if $wxMSW{$file} =~ /\b16\b/;

        #! OLE files live in a subdir
        if( $wxMSW{$file} =~ /\bO\b/ ) {
            $project{"WXMSWOBJS"} .= '$(OLEDIR)';
        } else {
            $project{"WXMSWOBJS"} .= '$(MSWDIR)';
        }
        $file =~ s/cp?p?$/obj/;
        $project{"WXMSWOBJS"} .= '\\$D\\' . $file . " ";
    }

    foreach $file (sort keys %wxHTML) {
        next if $wxHTML{$file} =~ /\b16\b/;

        $file =~ s/cp?p?$/obj/;
        $project{"WXHTMLOBJS"} .= "\$(HTMLDIR)\\\$D\\" . $file . " "
    }

#$}
# This file was automatically generated by tmake
# DO NOT CHANGE THIS FILE, YOUR CHANGES WILL BE LOST! CHANGE VC.T!

# File:     makefile.vc
# Author:   Julian Smart
# Created:  1997
# Updated:
# Copyright: (c) 1997, Julian Smart
#
# "%W% %G%"
#
# Makefile : Builds wxWindows library wx.lib for VC++ (32-bit)
# Arguments:
#
# FINAL=1 argument to nmake to build version with no debugging info.
# dll builds a library (wxdll.lib) suitable for creating DLLs
#
!include <..\makevc.env>

THISDIR=$(WXWIN)\src\msw

!if "$(WXMAKINGDLL)" == "1"
LIBTARGET=$(WXDIR)\lib\$(WXLIBNAME).dll
!else
LIBTARGET=$(WXLIB)
!endif

# This one overrides the others, to be consistent with the settings in setup.h
MINIMAL_WXWINDOWS_SETUP=0

PERIPH_LIBS=
PERIPH_TARGET=
PERIPH_CLEAN_TARGET=

# Set to 0 if not using GLCanvas (only affects DLL build)
USE_GLCANVAS=1

# Set to 1 if you are using MSVC 5
USE_MSVC_5=0

# These are absolute paths, so that the compiler
# generates correct __FILE__ symbols for debugging.
# Otherwise you don't be able to double-click on a memory
# error to load that file.
GENDIR=$(WXDIR)\src\generic
COMMDIR=$(WXDIR)\src\common
OLEDIR=ole
MSWDIR=$(WXDIR)\src\msw
DOCDIR = $(WXDIR)\docs
HTMLDIR = $(WXDIR)\src\html
JPEGDIR = $(WXDIR)\src\jpeg
TIFFDIR = $(WXDIR)\src\tiff
REGEXDIR = $(WXDIR)\src\regex


{$(GENDIR)}.cpp{$(GENDIR)\$D}.obj:
	cl @<<
$(CPPFLAGS) /Fo$@ /c /Tp $<
<<

{$(COMMDIR)}.cpp{$(COMMDIR)\$D}.obj:
	cl @<<
$(CPPFLAGS) /Fo$@ /c /Tp $<
<<

{$(COMMDIR)}.c{$(COMMDIR)\$D}.obj:
	cl @<<
$(CPPFLAGS2) /Fo$@ /c /Tc $<
<<

{$(MSWDIR)}.cpp{$(MSWDIR)\$D}.obj:
	cl @<<
$(CPPFLAGS) /Fo$@ /c /Tp $<
<<

{$(MSWDIR)}.c{$(MSWDIR)\$D}.obj:
	cl @<<
$(CPPFLAGS2) /Fo$@ /c /Tc $<
<<

{$(OLEDIR)}.cpp{$(OLEDIR)\$D}.obj:
	cl @<<
$(CPPFLAGS) /Fo$@ /c /Tp $<
<<

{$(HTMLDIR)}.cpp{$(HTMLDIR)\$D}.obj:
	cl @<<
$(CPPFLAGS) /Fo$@ /c /Tp $<
<<

GENERICOBJS= #$ ExpandList("WXGENERICOBJS");

# These are generic things that don't need to be compiled on MSW,
# but sometimes it's useful to do so for testing purposes.
NONESSENTIALOBJS= #$ ExpandList("WXNONESSENTIALOBJS");

COMMONOBJS = \
		#$ ExpandList("WXCOMMONOBJS");

MSWOBJS = #$ ExpandList("WXMSWOBJS");

HTMLOBJS = #$ ExpandList("WXHTMLOBJS");


# Add $(NONESSENTIALOBJS) if wanting generic dialogs, PostScript etc.
# Add $(HTMLOBJS) if wanting wxHTML classes
OBJECTS = $(COMMONOBJS) $(GENERICOBJS) $(MSWOBJS) $(HTMLOBJS)

ARCHINCDIR=$(WXDIR)\lib\$(_WXINC_BUILD)$(_WXINC_DLLSUFFIX)$(_WXINC_SUFFIX)$(LIBEXT)
SETUP_H=$(ARCHINCDIR)\wx\setup.h

# Normal, static library
all:    dirs $(SETUP_H) $(DUMMYOBJ) $(OBJECTS) $(PERIPH_TARGET) png zlib jpeg tiff regex $(LIBTARGET)

$(ARCHINCDIR)\wx:
    mkdir $(ARCHINCDIR)
    mkdir $(ARCHINCDIR)\wx

$(WXDIR)\include\wx\msw\setup.h:
    cd $(WXDIR)\include\wx\msw
    if not exist setup.h copy setup0.h setup.h
    cd $(WXDIR)\src\msw

$(SETUP_H): $(WXDIR)\include\wx\msw\setup.h
    copy $(WXDIR)\include\wx\msw\setup.h $@

dirs: $(MSWDIR)\$D $(COMMDIR)\$D $(GENDIR)\$D $(OLEDIR)\$D $(HTMLDIR)\$D $(JPEGDIR)\$D $(TIFFDIR)\$D $(REGEXDIR)\$D $(ARCHINCDIR)\wx $(WXDIR)\$D

$D:
    mkdir $D

$(COMMDIR)\$D:
    mkdir $(COMMDIR)\$D

$(MSWDIR)\$D:
    mkdir $(MSWDIR)\$D

$(GENDIR)\$D:
    mkdir $(GENDIR)\$D

$(OLEDIR)\$D:
    mkdir $(OLEDIR)\$D

$(HTMLDIR)\$D:
    mkdir $(HTMLDIR)\$D

$(JPEGDIR)\$D:
    mkdir $(JPEGDIR)\$D

$(TIFFDIR)\$D:
    mkdir $(TIFFDIR)\$D

$(REGEXDIR)\$D:
    mkdir $(REGEXDIR)\$D

$(WXDIR)\$D:
    mkdir $(WXDIR)\$D


# wxWindows library as DLL
dll:
        nmake -f makefile.vc all FINAL=$(FINAL) DLL=1 WXMAKINGDLL=1 NEW_WXLIBNAME=$(NEW_WXLIBNAME) UNICODE=$(UNICODE) MSLU=$(MSLU)

cleandll:
        nmake -f makefile.vc clean FINAL=$(FINAL) DLL=1 WXMAKINGDLL=1 NEW_WXLIBNAME=$(NEW_WXLIBNAME) UNICODE=$(UNICODE) MSLU=$(MSLU)

# wxWindows + app as DLL. Only affects main.cpp.
dllapp:
        nmake -f makefile.vc all FINAL=$(FINAL) DLL=1 UNICODE=$(UNICODE) MSLU=$(MSLU)

# wxWindows + app as DLL, for Netscape plugin - remove DllMain.
dllnp:
        nmake -f makefile.vc all NOMAIN=1 FINAL=$(FINAL) DLL=1 UNICODE=$(UNICODE) MSLU=$(MSLU)

# Use this to make dummy.obj and generate a PCH.
# You might use the dll target, then the pch target, in order to
# generate a DLL, then a PCH/dummy.obj for compiling your applications with.
#
# Explanation: Normally, when compiling a static version of wx.lib, your dummy.obj/PCH
# are associated with wx.lib. When using a DLL version of wxWindows, however,
# the DLL is compiled without a PCH, so you only need it for compiling the app.
# In fact headers are compiled differently depending on whether a DLL is being made
# or an app is calling the DLL exported functionality (WXDLLEXPORT is different
# in each case) so you couldn't use the same PCH.
pch:
        nmake -f makefile.vc pch1 WXUSINGDLL=1 FINAL=$(FINAL) NEW_WXLIBNAME=$(NEW_WXLIBNAME)

pch1:   dirs $(DUMMYOBJ)
    echo $(DUMMYOBJ)

!if "$(WXMAKINGDLL)" != "1"

### Static library

$(WXDIR)\lib\$(WXLIBNAME).lib:      $(DUMMYOBJ) $(OBJECTS) $(PERIPH_LIBS)
	-erase $(LIBTARGET)
	$(implib) @<<
-out:$@
-machine:$(CPU)
$(OBJECTS) $(DUMMYOBJ) $(PERIPH_LIBS)
<<

!else

### Update the import library

$(WXDIR)\lib\$(WXLIBNAME).lib: $(DUMMYOBJ) $(OBJECTS)
    $(implib) @<<
    -machine:$(CPU)
    -def:wx.def
    $(DUMMYOBJ) $(OBJECTS)
    -out:$(WXDIR)\lib\$(WXLIBNAME).lib
<<

!if "$(USE_GLCANVAS)" == "1"
GL_LIBS=opengl32.lib glu32.lib
# GL_LIBS_DELAY=/delayload:opengl32.dll
!endif

!if "$(USE_MSVC_5)" == "1"
# we are too big
INCREMENTAL=/INCREMENTAL:NO
DELAY_LOAD=
!else
INCREMENTAL=
DELAY_LOAD=delayimp.lib \
	/delayload:ws2_32.dll /delayload:advapi32.dll /delayload:user32.dll \
        /delayload:gdi32.dll \
	/delayload:comdlg32.dll /delayload:shell32.dll /delayload:comctl32.dll \
        /delayload:ole32.dll \
	/delayload:oleaut32.dll /delayload:rpcrt4.dll $(GL_LIBS_DELAY)
!endif

# Update the dynamic link library
$(WXDIR)\lib\$(WXLIBNAME).dll: $(DUMMYOBJ) $(OBJECTS)
    $(link) @<<
    $(LINKFLAGS) $(INCREMENTAL)
    -out:$(WXDIR)\lib\$(WXLIBNAME).dll
    $(DUMMYOBJ) $(OBJECTS) $(MSLU_LIBS) $(guilibsdll) shell32.lib comctl32.lib ole32.lib oleaut32.lib uuid.lib rpcrt4.lib odbc32.lib advapi32.lib winmm.lib $(GL_LIBS) $(WXDIR)\lib\png$(LIBEXT).lib $(WXDIR)\lib\zlib$(LIBEXT).lib $(WXDIR)\lib\jpeg$(LIBEXT).lib $(WXDIR)\lib\tiff$(LIBEXT).lib $(WXDIR)\lib\regex$(LIBEXT).lib $(DELAY_LOAD)
<<

!endif

# /delayload:winmm.dll # Removed because it can cause a crash for some people

########################################################
# Windows-specific objects

$(DUMMYOBJ): $(DUMMY).$(SRCSUFF) $(WXDIR)\include\wx\wx.h $(SETUP_H)
        cl $(CPPFLAGS) $(MAKEPRECOMP) /Fo$(DUMMYOBJ) /c /Tp $(DUMMY).cpp

# Compile certain files with no optimization (some files cause a
# compiler crash for buggy versions of VC++, e.g. 4.0).
# Don't forget to put FINAL=1 on the command line.
noopt:
	cl @<<
$(CPPFLAGS2) /Od /Fo$(COMMDIR)\$D\datetime.obj /c /Tp $(COMMDIR)\datetime.cpp
<<
	cl @<<
$(CPPFLAGS2) /Od /Fo$(COMMDIR)\$D\encconv.obj /c /Tp $(COMMDIR)\encconv.cpp
<<
	cl @<<
$(CPPFLAGS2) /Od /Fo$(COMMDIR)\$D\fileconf.obj /c /Tp $(COMMDIR)\fileconf.cpp
<<
	cl @<<
$(CPPFLAGS2) /Od /Fo$(COMMDIR)\$D\hash.obj /c /Tp $(COMMDIR)\hash.cpp
<<
	cl @<<
$(CPPFLAGS2) /Od /Fo$(COMMDIR)\$D\textfile.obj /c /Tp $(COMMDIR)\textfile.cpp
<<
	cl @<<
$(CPPFLAGS2) /Od /Fo$(GENDIR)\$D\choicdgg.obj /c /Tp $(GENDIR)\choicdgg.cpp
<<
	cl @<<
$(CPPFLAGS2) /Od /Fo$(GENDIR)\$D\grid.obj /c /Tp $(GENDIR)\grid.cpp
<<
	cl @<<
$(CPPFLAGS2) /Od /Fo$(GENDIR)\$D\gridsel.obj /c /Tp $(GENDIR)\gridsel.cpp
<<
	cl @<<
$(CPPFLAGS2) /Od /Fo$(GENDIR)\$D\logg.obj /c /Tp $(GENDIR)\logg.cpp
<<
	cl @<<
$(CPPFLAGS2) /Od /Fo$(MSWDIR)\$D\clipbrd.obj /c /Tp $(MSWDIR)\clipbrd.cpp
<<
	cl @<<
$(CPPFLAGS2) /Od /Fo$(MSWDIR)\$D\control.obj /c /Tp $(MSWDIR)\control.cpp
<<
	cl @<<
$(CPPFLAGS2) /Od /Fo$(MSWDIR)\$D\listbox.obj /c /Tp $(MSWDIR)\listbox.cpp
<<
	cl @<<
$(CPPFLAGS2) /Od /Fo$(MSWDIR)\$D\mdi.obj /c /Tp $(MSWDIR)\mdi.cpp
<<
	cl @<<
$(CPPFLAGS2) /Od /Fo$(MSWDIR)\$D\menu.obj /c /Tp $(MSWDIR)\menu.cpp
<<
	cl @<<
$(CPPFLAGS2) /Od /Fo$(MSWDIR)\$D\notebook.obj /c /Tp $(MSWDIR)\notebook.cpp
<<
	cl @<<
$(CPPFLAGS2) /Od /Fo$(MSWDIR)\$D\tbar95.obj /c /Tp $(MSWDIR)\tbar95.cpp
<<
	cl @<<
$(CPPFLAGS2) /Od /Fo$(MSWDIR)\$D\treectrl.obj /c /Tp $(MSWDIR)\treectrl.cpp
<<
	cl @<<
$(CPPFLAGS2) /Od /Fo$(HTMLDIR)\$D\helpfrm.obj /c /Tp $(HTMLDIR)\helpfrm.cpp
<<

$(COMMDIR)\$D\y_tab.obj:     $(COMMDIR)\y_tab.c $(COMMDIR)\lex_yy.c
        cl @<<
$(CPPFLAGS2) /c $(COMMDIR)\y_tab.c -DUSE_DEFINE -DYY_USE_PROTOS /Fo$@
<<

$(COMMDIR)\y_tab.c:     $(COMMDIR)\dosyacc.c
        copy "$(COMMDIR)"\dosyacc.c "$(COMMDIR)"\y_tab.c

$(COMMDIR)\lex_yy.c:    $(COMMDIR)\doslex.c
    copy "$(COMMDIR)"\doslex.c "$(COMMDIR)"\lex_yy.c

$(OBJECTS):	$(SETUP_H)

$(COMMDIR)\$D\unzip.obj:     $(COMMDIR)\unzip.c
        cl @<<
$(CPPFLAGS2) /c $(COMMDIR)\unzip.c /Fo$@
<<

# Peripheral components

png:
    cd $(WXDIR)\src\png
    nmake -f makefile.vc FINAL=$(FINAL) DLL=$(DLL) WXMAKINGDLL=$(WXMAKINGDLL) CRTFLAG=$(CRTFLAG) UNICODE=0
    cd $(WXDIR)\src\msw

clean_png:
    cd $(WXDIR)\src\png
    nmake -f makefile.vc clean
    cd $(WXDIR)\src\msw

zlib:
    cd $(WXDIR)\src\zlib
    nmake -f makefile.vc FINAL=$(FINAL) DLL=$(DLL) WXMAKINGDLL=$(WXMAKINGDLL) CRTFLAG=$(CRTFLAG) UNICODE=0
    cd $(WXDIR)\src\msw

clean_zlib:
    cd $(WXDIR)\src\zlib
    nmake -f makefile.vc clean
    cd $(WXDIR)\src\msw

jpeg:
    cd $(WXDIR)\src\jpeg
    nmake -f makefile.vc FINAL=$(FINAL) DLL=$(DLL) WXMAKINGDLL=$(WXMAKINGDLL)  CRTFLAG=$(CRTFLAG) UNICODE=0 all
    cd $(WXDIR)\src\msw

clean_jpeg:
    cd $(WXDIR)\src\jpeg
    nmake -f makefile.vc clean
    cd $(WXDIR)\src\msw

tiff:
    cd $(WXDIR)\src\tiff
    nmake -f makefile.vc FINAL=$(FINAL) DLL=$(DLL) WXMAKINGDLL=$(WXMAKINGDLL)  CRTFLAG=$(CRTFLAG) UNICODE=0 all
    cd $(WXDIR)\src\msw

clean_tiff:
    cd $(WXDIR)\src\tiff
    nmake -f makefile.vc clean
    cd $(WXDIR)\src\msw

regex:
    cd $(WXDIR)\src\regex
    nmake -f makefile.vc FINAL=$(FINAL) DLL=$(DLL) WXMAKINGDLL=$(WXMAKINGDLL) CRTFLAG=$(CRTFLAG) UNICODE=0 all
    cd $(WXDIR)\src\msw

clean_regex:
    cd $(WXDIR)\src\regex
    nmake -f makefile.vc clean
    cd $(WXDIR)\src\msw

rcparser:
    cd $(WXDIR)\utils\rcparser\src
    nmake -f makefile.vc FINAL=$(FINAL)
    cd $(WXDIR)\src\msw

cleanall: clean clean_png clean_zlib clean_jpeg clean_tiff clean_regex
        -erase ..\..\lib\$(WXLIBNAME).dll
        -erase ..\..\lib\$(WXLIBNAME).lib
        -erase ..\..\lib\$(WXLIBNAME).exp
        -erase ..\..\lib\$(WXLIBNAME).pdb
        -erase ..\..\lib\$(WXLIBNAME).ilk


clean: $(PERIPH_CLEAN_TARGET)
        -erase $(LIBTARGET)
        -erase $(WXDIR)\lib\$(WXLIBNAME).pdb
        -erase *.pdb
        -erase *.sbr
        -erase $(WXLIBNAME).pch
	-erase $(WXDIR)\$D\$(PCH)
	-erase $(WXDIR)\$D\*.pdb
	-erase $(WXDIR)\$D\*.obj
        -erase $(GENDIR)\$D\*.obj
        -erase $(GENDIR)\$D\*.pdb
        -erase $(GENDIR)\$D\*.sbr
        -erase $(COMMDIR)\$D\*.obj
        -erase $(COMMDIR)\$D\*.pdb
        -erase $(COMMDIR)\$D\*.sbr
        -erase $(COMMDIR)\y_tab.c
        -erase $(COMMDIR)\lex_yy.c
        -erase $(MSWDIR)\$D\*.obj
        -erase $(MSWDIR)\$D\*.sbr
        -erase $(MSWDIR)\$D\*.pdb
        -erase $(MSWDIR)\$D\*.pch
        -erase $(OLEDIR)\$D\*.obj
        -erase $(OLEDIR)\$D\*.sbr
        -erase $(OLEDIR)\$D\*.pdb
        -erase $(HTMLDIR)\$D\*.obj
        -erase $(HTMLDIR)\$D\*.sbr
        -erase $(HTMLDIR)\$D\*.pdb
        -erase $(JPEGDIR)\$D\*.obj
        -erase $(JPEGDIR)\$D\*.sbr
        -erase $(JPEGDIR)\$D\*.idb
        -erase $(JPEGDIR)\$D\*.pdb
        -erase $(TIFFDIR)\$D\*.obj
        -erase $(TIFFDIR)\$D\*.sbr
        -erase $(TIFFDIR)\$D\*.pdb
        -erase $(TIFFDIR)\$D\*.idb
        -rmdir $(D)
        -rmdir $(GENDIR)\$(D)
        -rmdir $(COMMDIR)\$(D)
        -rmdir $(MSWDIR)\$(D)
        -rmdir $(OLEDIR)\$(D)
        -rmdir $(HTMLDIR)\$(D)
        -rmdir $(JPEGDIR)\$(D)
        -rmdir $(TIFFDIR)\$(D)
	-rmdir $(WXDIR)\$D

# Making documents
docs:   allhlp allhtml allpdfrtf allhtb allhtmlhelp
alldocs: docs
hlp:    wxhlp
wxhlp:  $(DOCDIR)/winhelp/wx.hlp
rtf:    $(DOCDIR)/winhelp/wx.rtf
pdfrtf:    $(DOCDIR)/pdf/wx.rtf
html:	wxhtml
htb:	$(DOCDIR)\htb\wx.htb
wxhtml:	$(DOCDIR)\html\wx\wx.htm
htmlhelp: $(DOCDIR)\htmlhelp\wx.chm
ps:     wxps
wxps:	$(WXDIR)\docs\ps\wx.ps

allhlp: wxhlp

#        cd $(WXDIR)\utils\dialoged\src
#        nmake -f makefile.vc hlp
#        cd $(WXDIR)\utils\tex2rtf\src
#        nmake -f makefile.vc hlp
#        cd $(WXDIR)\contrib\src\fl
#        nmake -f makefile.vc hlp
#        cd $(THISDIR)

allhtml: wxhtml

#        cd $(WXDIR)\utils\dialoged\src
#        nmake -f makefile.vc html
#        cd $(WXDIR)\utils\tex2rtf\src
#        nmake -f makefile.vc html
#        cd $(WXDIR)\contrib\src\fl
#        cd $(THISDIR)

allhtmlhelp: htmlhelp
 
#       cd $(WXDIR)\utils\dialoged\src
#        nmake -f makefile.vc htmlhelp
#        cd $(WXDIR)\utils\tex2rtf\src
#        nmake -f makefile.vc htmlhelp
#        cd $(WXDIR)\contrib\src\fl
#        nmake -f makefile.vc htmlhelp
#        cd $(THISDIR)

allhtb: htb

#        cd $(WXDIR)\utils\dialoged\src
#        nmake -f makefile.vc htb
#        cd $(WXDIR)\utils\tex2rtf\src
#        nmake -f makefile.vc htb
#        cd $(WXDIR)\contrib\src\fl
#        nmake -f makefile.vc htb
#        cd $(THISDIR)

allps: wxps referencps
        cd $(WXDIR)\utils\dialoged\src
        nmake -f makefile.vc ps
        cd $(WXDIR)\utils\tex2rtf\src
        nmake -f makefile.vc ps
        cd $(WXDIR)\contrib\src\fl
        nmake -f makefile.vc ps
        cd $(THISDIR)

allpdfrtf: pdfrtf
#        cd $(WXDIR)\utils\dialoged\src
#        nmake -f makefile.vc pdfrtf
#        cd $(WXDIR)\utils\tex2rtf\src
#        nmake -f makefile.vc pdfrtf
#        cd $(WXDIR)\contrib\src\fl
#        nmake -f makefile.vc pdfrtf
#        cd $(THISDIR)

$(DOCDIR)/winhelp/wx.hlp:         $(DOCDIR)/latex/wx/wx.rtf $(DOCDIR)/latex/wx/wx.hpj
        cd $(DOCDIR)/latex/wx
        -erase wx.ph
        hc wx
        -erase $(DOCDIR)\winhelp\wx.hlp
        -erase $(DOCDIR)\winhelp\wx.cnt
        move wx.hlp $(DOCDIR)\winhelp\wx.hlp
        move wx.cnt $(DOCDIR)\winhelp\wx.cnt
        cd $(THISDIR)

$(DOCDIR)/latex/wx/wx.rtf:         $(DOCDIR)/latex/wx/classes.tex $(DOCDIR)/latex/wx/body.tex $(DOCDIR)/latex/wx/topics.tex $(DOCDIR)/latex/wx/manual.tex
        cd $(DOCDIR)\latex\wx
        -start $(WAITFLAG) tex2rtf $(DOCDIR)/latex/wx/manual.tex $(DOCDIR)/latex/wx/wx.rtf -twice -winhelp
        cd $(THISDIR)

$(DOCDIR)/pdf/wx.rtf:         $(DOCDIR)/latex/wx/classes.tex $(DOCDIR)/latex/wx/body.tex $(DOCDIR)/latex/wx/topics.tex $(DOCDIR)/latex/wx/manual.tex
        cd $(DOCDIR)\latex\wx
        -copy *.wmf $(DOCDIR)\pdf
        -copy *.bmp $(DOCDIR)\pdf
        -start $(WAITFLAG) tex2rtf $(DOCDIR)/latex/wx/manual.tex $(DOCDIR)/pdf/wx.rtf -twice -rtf
        cd $(THISDIR)

# This target does two sets of HTML: one using a style sheet, for
# the purposes of the CHM file, and one without.
$(DOCDIR)\html\wx\wx.htm:         $(DOCDIR)\latex\wx\classes.tex $(DOCDIR)\latex\wx\body.tex $(DOCDIR)/latex/wx/topics.tex $(DOCDIR)\latex\wx\manual.tex
        cd $(DOCDIR)\latex\wx
        -mkdir $(DOCDIR)\html\wx
        copy *.gif $(DOCDIR)\html\wx
        -start $(WAITFLAG) tex2rtf $(DOCDIR)\latex\wx\manual.tex $(DOCDIR)\html\wx\wx.htm -twice -html
        -mkdir $(DOCDIR)\mshtml
        -mkdir $(DOCDIR)\mshtml\wx
        copy *.gif $(DOCDIR)\mshtml\wx
        -start $(WAITFLAG) tex2rtf $(DOCDIR)\latex\wx\manual.tex $(DOCDIR)\mshtml\wx\wx.htm -twice -html -macros $(DOCDIR)\latex\wx\tex2rtf_css.ini
        -erase $(DOCDIR)\html\wx\*.con
        -erase $(DOCDIR)\html\wx\*.ref
        -erase $(DOCDIR)\latex\wx\*.con
        -erase $(DOCDIR)\latex\wx\*.ref
         cd $(THISDIR)

$(DOCDIR)\htmlhelp\wx.chm : $(DOCDIR)\html\wx\wx.htm $(DOCDIR)\mshtml\wx\wx.htm $(DOCDIR)\mshtml\wx\wx.hhp
	cd $(DOCDIR)\mshtml\wx
    copy $(DOCDIR)\latex\wx\wx.css .
	-hhc wx.hhp
    -mkdir ..\..\htmlhelp
    -erase $(DOCDIR)\htmlhelp\wx.chm
    move wx.chm ..\..\htmlhelp
	cd $(THISDIR)

$(WXDIR)\docs\latex\wx\manual.dvi:	$(DOCDIR)/latex/wx/body.tex $(DOCDIR)/latex/wx/manual.tex
	cd $(WXDIR)\docs\latex\wx
        -latex manual
        -latex manual
        -makeindx manual
        -bibtex manual
        -latex manual
        -latex manual
        cd $(THISDIR)

$(WXDIR)\docs\ps\wx.ps:	$(WXDIR)\docs\latex\wx\manual.dvi
	cd $(WXDIR)\docs\latex\wx
        -dvips32 -o wx.ps manual
        move wx.ps $(WXDIR)\docs\ps\wx.ps
        cd $(THISDIR)

$(WXDIR)\docs\latex\wx\referenc.dvi:	$(DOCDIR)/latex/wx/classes.tex $(DOCDIR)/latex/wx/topics.tex $(DOCDIR)/latex/wx/referenc.tex
	cd $(WXDIR)\docs\latex\wx
        -latex referenc
        -latex referenc
        -makeindx referenc
        -bibtex referenc
        -latex referenc
        -latex referenc
        cd $(THISDIR)

$(WXDIR)\docs\ps\referenc.ps:	$(WXDIR)\docs\latex\wx\referenc.dvi
	cd $(WXDIR)\docs\latex\wx
        -dvips32 -o referenc.ps referenc
        move referenc.ps $(WXDIR)\docs\ps\referenc.ps
        cd $(THISDIR)

# An htb file is a zip file containing the .htm, .gif, .hhp, .hhc and .hhk
# files, renamed to htb.
# This can then be used with e.g. helpview.
# Optionally, a cached version of the .hhp file can be generated with hhp2cached.
$(DOCDIR)\htb\wx.htb: $(DOCDIR)\html\wx\wx.htm
	cd $(WXDIR)\docs\html\wx
    -erase wx.zip wx.htb
    zip wx.zip *.htm *.gif *.hhp *.hhc *.hhk
    -mkdir $(DOCDIR)\htb
    move wx.zip $(DOCDIR)\htb\wx.htb
    cd $(THISDIR)

# In order to force document reprocessing
touchmanual:
    -touch $(WXDIR)\docs\latex\wx\manual.tex

updatedocs: touchmanual alldocs

cleandocs:
    -erase $(DOCDIR)\winhelp\wx.hlp
    -erase $(DOCDIR)\winhelp\wx.cnt
    -erase $(DOCDIR)\html\wx\*.htm
    -erase $(DOCDIR)\pdf\wx.rtf
    -erase $(DOCDIR)\latex\wx\wx.rtf
    -erase $(DOCDIR)\latex\wx\WX.PH
    -erase $(DOCDIR)\htmlhelp\wx.chm
    -erase $(DOCDIR)\htb\wx.htb

# Start Word, running the GeneratePDF macro. MakeManual.dot should be in the
# Office StartUp folder, and PDFMaker should be installed.
updatepdf:  # touchmanual pdfrtf
    start $(WAITFLAG) "winword d:\wx2\wxWindows\docs\latex\pdf\wx.rtf /mGeneratePDF"


MFTYPE=vc
makefile.$(MFTYPE) : $(WXWIN)\distrib\msw\tmake\filelist.txt $(WXWIN)\distrib\msw\tmake\$(MFTYPE).t
	cd $(WXWIN)\distrib\msw\tmake
	tmake -t $(MFTYPE) wxwin.pro -o makefile.$(MFTYPE)
	copy makefile.$(MFTYPE) $(WXWIN)\src\msw

