# Only one single output remains unspent from block 123,321. What address was it sent to?

block=123321

# -----------------------------------
# Get the blockhash of provided block
# -----------------------------------
blockhash=$(bitcoin-cli -datadir=$HOME/.bitcoin getblockhash $block)

# ------------
# List all txs
# ------------
txs=$(bitcoin-cli -datadir=$HOME/.bitcoin getblock $blockhash | jq -r ".tx[]")

# ---------------------------------------------------
# Now loop through all txs to:
# - decode tx
# - get all vout index
# - check if the vout index was spent
# - if not spent, print the address and exit
# ---------------------------------------------------
for tx in $txs; do
  rawtx=$(bitcoin-cli -datadir=$HOME/.bitcoin getrawtransaction "$tx")
  vouts=$(bitcoin-cli -datadir=$HOME/.bitcoin decoderawtransaction "$rawtx" | jq -c ".vout[] | { n: .n }")

  for vout in $vouts; do
    # Extract value and address from the vout
    vout_index=$(echo "$vout" | jq -c ".n")
    spent=$(bitcoin-cli -datadir=$HOME/.bitcoin gettxout "$tx" "$vout_index" 2>/dev/null)
    if [[ "$spent" != "" ]]; then
      echo "$spent" | jq -r ".scriptPubKey.address"
      exit 0
    fi
  done
done

exit 1
