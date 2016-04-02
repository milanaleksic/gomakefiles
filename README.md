# gomakefiles

Various partial Makefiles to stabilize different Go projects of mine to use same

## Tips & Tricks

### metalinter blocking pushes

Modify .git/hooks/pre-push

    #!/bin/bash
    make metalinter


