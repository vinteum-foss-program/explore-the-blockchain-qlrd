# What is the hash of block 654,321?

# -----------------
# The question hash
# -----------------
block=654321

# -----------------------------------
# now extract hash from desired block
# Locally, with this script, the cli
# will use a 127.0.0.1 connection.
# To force it to the  proposed bitcoin.conf
# placed on submission/setup.sh, add
# -datadir option (so its behaviour
# will be the same on github-actions).
# -----------------------------------
echo $(bitcoin-cli -datadir=$HOME/.bitcoin getblockhash $block)
