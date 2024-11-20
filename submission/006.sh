# Which tx in block 257,343 spends the coinbase output of block 256,128?

#-------------------------------------------------
# Setup coinbase info
# 
# We want to get the coinbase txid and its vout.n
# we will use both to link with the spent tx
# ------------------------------------------------
coinbase_block=256128
coinbase_blockhash=$(bitcoin-cli -datadir=$HOME/.bitcoin getblockhash $coinbase_block)
coinbase_txid=$(bitcoin-cli -datadir=$HOME/.bitcoin getblock $coinbase_blockhash | jq -r ".tx[0]")
coinbase_rawtx=$(bitcoin-cli -datadir=$HOME/.bitcoin getrawtransaction $coinbase_txid)
coinbase_vout=$(bitcoin-cli -datadir=$HOME/.bitcoin decoderawtransaction "$coinbase_rawtx" | jq -c ".vout[0].n")

#-------------------------------------------------
# Setup spent info
# 
# We want:
# - to loop through all transactions in the spent block
# - iterate over each vin entry and check if it matches the coinbase tx output
# - if match, return the linked transaction
# ------------------------------------------------
spent_block=257343
spent_blockhash=$(bitcoin-cli -datadir=$HOME/.bitcoin getblockhash $spent_block)
spent_txs=$(bitcoin-cli -datadir=$HOME/.bitcoin getblock $spent_blockhash | jq -r ".tx[]")

# Loop through transactions in the spent block
for spent_txid in $spent_txs; do
  spent_rawtx=$(bitcoin-cli -datadir=$HOME/.bitcoin getrawtransaction "$spent_txid")
  spent_vins=$(bitcoin-cli -datadir=$HOME/.bitcoin decoderawtransaction "$spent_rawtx" | jq -c '.vin[] | { txid: .txid, vout: .vout}')

  for vin in $spent_vins; do
    vin_txid=$(echo "$vin" | jq -r '.txid')
    vin_vout=$(echo "$vin" | jq -r '.vout')

    if [[ $vin_txid == $coinbase_txid && $vin_vout == $coinbase_vout ]]; then
      # We found the linked coinbase tx and its vout
      echo $spent_txid
      exit 0
    fi
  done
done

exit 1
