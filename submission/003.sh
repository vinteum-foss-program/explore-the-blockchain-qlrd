# How many new outputs were created by block 123,456?

# ------------------------
# First get the block hash
# ------------------------
block=123456
blockhash=$(bitcoin-cli -datadir=$HOME/.bitcoin getblockhash $block)

# ----------------------------------------------
# Now get the list of transactions in that block
# join the txids with a space separator
# ----------------------------------------------
txids=$(bitcoin-cli -datadir=$HOME/.bitcoin getblock "$blockhash" | jq -r ".tx[]")

# ------------------------------------------
# For each transaction, get the total amount
# of outputs (vout field) and sum it 
# ------------------------------------------
total_block_outputs=0;

# start the loop
for txid in $txids; do

  # First get the raw transaction from txid
  rawtx=$(bitcoin-cli -datadir=$HOME/.bitcoin getrawtransaction $txid)

  # now decode the transaction and count the .vout field
  # the .vout field lenght will be summed to total_block_outputs
  vouts=$(bitcoin-cli -datadir=$HOME/.bitcoin decoderawtransaction $rawtx | jq -r ".vout | length")

  # now increment
  ((total_block_outputs=total_block_outputs+vouts))
done

# Ouput the total blocks
echo $total_block_outputs
