# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`

# Decode transaction
txid=e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163
rawtx=$(bitcoin-cli -datadir=$HOME/.bitcoin getrawtransaction "$txid")

# Get the transaction
tx=$(bitcoin-cli -datadir=$HOME/.bitcoin decoderawtransaction "$rawtx")

# Get the previous transaction to find which pubkeys signed the transction
# and its scriptPubKey
prev_txid=$(echo "$tx" | jq -r ".vin[0].txid")
prev_vout=$(echo "$tx" | jq -r '.vin[0].vout')
prev_rawtx=$(bitcoin-cli -datadir=$HOME/.bitcoin getrawtransaction "$prev_txid")
prev_tx=$(bitcoin-cli -datadir=$HOME/.bitcoin decoderawtransaction "$prev_rawtx")
script_pubkey_hash=$(echo "$prev_tx" | jq -r ".vout[$prev_vout].scriptPubKey.asm" | cut -d ' ' -f 2)

# Extract and analyze the witness from the input of the current spending transaction
txinwitness=$(echo "$tx" | jq -r '.vin[0].txinwitness')
redeem_script=$(echo "$txinwitness" | jq -r '.[-1]')
decoded_redeem_script=$(bitcoin-cli -datadir=$HOME/.bitcoin decodescript "$redeem_script")

# get the contract and its pubkeys
asm=$(echo "$decoded_redeem_script" | jq -r ".asm")
pubkeys=($(echo "$asm" | grep -oE '02[0-9a-fA-F]{64}|03[0-9a-fA-F]{64}'))

# IF THE SHA256SUM OF THE REEDEM SCRIPT
# IS EQUAL TO THE HASH ON SCRIPT PUBKEY,
# THE ENTITY REPRESENTED BY THE FIRST PUBKEY SIGNED THE TRANSACTION
sha256_hash=$(echo "$redeem_script" | xxd -r -p | sha256sum | awk '{print $1}') 
if [[ "$sha256_hash" == $script_pubkey_hash ]]; then
  echo "${pubkeys[0]}"
else
  echo "${pubkeys[1]}"
fi
