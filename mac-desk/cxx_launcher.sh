#!/bin/sh
# Appends the override last so it wins over the target's -Werror=non-virtual-dtor (the Slang prelude).
exec "$@" -Wno-error=non-virtual-dtor
