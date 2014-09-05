#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "const-c.inc"

static SV * extract_cv(pTHX_ SV * sv){
    HV * st;
    GV * gvp;
    SV * cv = (SV*) sv_2cv(sv, &st, &gvp, 0);

    if (!cv)
        croak("expected a CODE reference for watcher handler");

    return cv;
}

static int watcher_handler(pTHX_ SV * sv, MAGIC * mg){
    dSP;
    SV * handler = mg->mg_obj;

    PUSHMARK(SP);
    XPUSHs(sv);
    PUTBACK;

    call_sv(handler, G_VOID | G_DISCARD);

    return 0;
}

static MGVTBL modified_vtbl = {
    0, watcher_handler, 0, 0, 0
};

MODULE = Scalar::Watcher		PACKAGE = Scalar::Watcher		

INCLUDE: const-xs.inc

SV *
when_modified(SV * target, SV * handler)
    PROTOTYPE: $&
    CODE:
        CV * handler_cv;
        SvUPGRADE(target, SVt_PVMG);
        sv_magicext(target, extract_cv(aTHX_ handler), PERL_MAGIC_ext, &modified_vtbl, NULL, 0);
