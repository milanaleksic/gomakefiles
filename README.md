# Makefiles to be used with Go apps

Various partial Makefiles to stabilize different Go projects of mine to use same

### Example Makefile

After creating a submodule under a `gomakefiles` directory in the Go project 
you can create a `Makefile` that utilizes these partial markdown scripts,
and an example of the "public project" setup you can see in 
https://github.com/milanaleksic/notesforlife/blob/master/Makefile

## Tips & Tricks

Various tips and tricks of usage of tasks defined here

### metalinter blocking pushes

Modify `.git/hooks/pre-push`

    #!/bin/bash
    make metalinter_strict

### metalinter additional properties

Use `EXTRA_ARGS_METALINTER` property to add extra metalinter properties, for example in constrained environments
(say, your build machine is a Raspberry Pi for example), you probably need to put in your app's Makefile: 

    EXTRA_ARGS_METALINTER := --concurrency=1

otherwise it will probably be too much for the server.
