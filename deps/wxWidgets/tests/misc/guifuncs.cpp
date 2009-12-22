///////////////////////////////////////////////////////////////////////////////
// Name:        tests/misc/misctests.cpp
// Purpose:     test miscellaneous GUI functions
// Author:      Vadim Zeitlin
// Created:     2008-09-22
// RCS-ID:      $Id: guifuncs.cpp 61788 2009-08-30 17:25:42Z VZ $
// Copyright:   (c) 2008 Vadim Zeitlin
///////////////////////////////////////////////////////////////////////////////

// ----------------------------------------------------------------------------
// headers
// ----------------------------------------------------------------------------

#include "testprec.h"

#ifdef __BORLANDC__
    #pragma hdrstop
#endif

#ifndef WX_PRECOMP
    #include "wx/gdicmn.h"
#endif // !PCH

#include "wx/defs.h"
#include "wx/clipbrd.h"
#include "wx/dataobj.h"

// ----------------------------------------------------------------------------
// test class
// ----------------------------------------------------------------------------

class MiscGUIFuncsTestCase : public CppUnit::TestCase
{
public:
    MiscGUIFuncsTestCase() { }

private:
    CPPUNIT_TEST_SUITE( MiscGUIFuncsTestCase );
        CPPUNIT_TEST( DisplaySize );
        CPPUNIT_TEST( URLDataObject );
    CPPUNIT_TEST_SUITE_END();

    void DisplaySize();
    void URLDataObject();

    DECLARE_NO_COPY_CLASS(MiscGUIFuncsTestCase)
};

// register in the unnamed registry so that these tests are run by default
CPPUNIT_TEST_SUITE_REGISTRATION( MiscGUIFuncsTestCase );

// also include in it's own registry so that these tests can be run alone
CPPUNIT_TEST_SUITE_NAMED_REGISTRATION( MiscGUIFuncsTestCase, "MiscGUIFuncsTestCase" );

void MiscGUIFuncsTestCase::DisplaySize()
{
    // test that different (almost) overloads return the same results
    int w, h;
    wxDisplaySize(&w, &h);
    wxSize sz = wxGetDisplaySize();

    CPPUNIT_ASSERT_EQUAL( w, sz.x );
    CPPUNIT_ASSERT_EQUAL( h, sz.y );

    // test that passing NULL works as expected, e.g. doesn't crash
    wxDisplaySize(NULL, NULL);
    wxDisplaySize(&w, NULL);
    wxDisplaySize(NULL, &h);

    CPPUNIT_ASSERT_EQUAL( w, sz.x );
    CPPUNIT_ASSERT_EQUAL( h, sz.y );

    // test that display PPI is something reasonable
    sz = wxGetDisplayPPI();
    CPPUNIT_ASSERT( sz.x < 1000 && sz.y < 1000 );
}

void MiscGUIFuncsTestCase::URLDataObject()
{
    // this tests for buffer overflow, see #11102
    const char * const
        url = "http://something.long.to.overwrite.plenty.memory.example.com";
    wxURLDataObject * const dobj = new wxURLDataObject(url);
    CPPUNIT_ASSERT_EQUAL( url, dobj->GetURL() );

    wxClipboardLocker lockClip;
    CPPUNIT_ASSERT( wxTheClipboard->SetData(dobj) );
    wxTheClipboard->Flush();
}

