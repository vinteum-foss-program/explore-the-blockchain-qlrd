# Create a 1-of-4 P2SH multisig address from the public keys in the four inputs of this tx:
#   `37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517`

# ---------
# The txid
# ---------
txid=37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517

# ---------------------------------------
# First get the raw transaction from txid
# ---------------------------------------
rawtx=$(bitcoin-cli -datadir=$HOME/.bitcoin getrawtransaction $txid)

# -------------------------------------------------------
# now decode the transaction and get the .txinwitness
# from each the .vin fields
# paste command will do the work of concatenate each pubkey
# with a comma (see man paste)
# the - at the end is to specify the standard input
# -------------------------------------------------------
pubkeys=$(bitcoin-cli -datadir=$HOME/.bitcoin decoderawtransaction $rawtx | jq -r ".vin[].txinwitness[1]" | paste -sd, -)

# --------------------------------------------
descriptor="sh(multi(1,$pubkeys))"

# ----------------------------------------
# Compute the checksum for the descriptor
# (like previous submission)
# ----------------------------------------
descriptor=$(bitcoin-cli -datadir=$HOME/.bitcoin getdescriptorinfo "$descriptor" | jq -r ".descriptor")

# ------------------------------------
# Compute a 1-4 P2SH multisig address at 0th index
# -----------------------------------
bitcoin-cli -datadir=$HOME/.bitcoin deriveaddresses "$descriptor" | jq -r ".[0]"

