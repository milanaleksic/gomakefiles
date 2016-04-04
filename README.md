# gomakefiles

Various partial Makefiles to stabilize different Go projects of mine to use same

## Tips & Tricks

### metalinter blocking pushes

Modify `.git/hooks/pre-push`

    #!/bin/bash
    make metalinter_strict

### metalinter additional properties

Use `EXTRA_ARGS_METALINTER` property to add extra metalinter properties, for example in constrained environments
(say, your build machine is a Raspberry Pi for example), you probably need to put in your app's Makefile: 

    EXTRA_ARGS_METALINTER := --concurrency=1

otherwise it will probably be too much for the server.
