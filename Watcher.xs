#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "const-c.inc"

MODULE = Scalar::Watcher		PACKAGE = Scalar::Watcher		

INCLUDE: const-xs.inc

SV *
when_modified(SV * target, SV * handler)
    PROTOTYPE: $&
    CODE:

SV *
when_freed(SV * target, SV * handler)
    PROTOTYPE: $&
    CODE:
