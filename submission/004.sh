# Using descriptors, compute the taproot address at index 100 derived from this extended public key:
#   `xpub6cx5tvq6nacsljdra1a6wjqto1sgeuzrfqsx5ysetvbmwhccra4kfgfqat2o1kwl3esb1psyr3cudfrzyflhjunnwuabkftk2njhutzdms2`
# Variables
xpub="xpub6Cx5tvq6nACSLJdra1A6WjqTo1SgeUZRFqsX5ysEtVBMwhCCRa4kfgFqaT2o1kwL3esB1PsYr3CUdfRZYfLHJunNWUABKftK2NjHUtzDms2"
index=100  # nth index

# ---------------------------------------
# Step 1: Create the Taproot descriptor
# 
# Many examples on internet suggests to use
# tr($xpub/0/*), but for this exercise, this generate
# derivation path 86h/0h/0h/0/100
# and not 86h/0h/0h/100 (the desired index)
# so, to ensure the correct descriptor range
# set as tr($xpub/*) to indicates that the last index is the range.
#
# see more at: https://bitcoin.stackexchange.com/questions/87538/bitcoin-cli-deriveaddresses-always-returns-an-error#comment-100449
# ---------------------------------------
descriptor="tr($xpub/*)"

# --------------------------------
# Step 2: Get the descriptor info
# 
# To get the correct address, is necessary
# computes its checksum
#---------------------------------
descriptor=$(bitcoin-cli -datadir=$HOME/.bitcoin getdescriptorinfo "$descriptor" | jq -r ".descriptor")

# --------------------------
# Derive the Taproot address
#
# Now with the checksummed descriptor,
# get the address at index 100 derived
# from the provided xpub
# --------------------------
bitcoin-cli -datadir=$HOME/.bitcoin deriveaddresses "$descriptor" "[$index,$index]" | jq -r '.[0]'
