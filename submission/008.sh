# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`

txid=e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163

# Decode transaction
rawtx=$(bitcoin-cli -datadir=$HOME/.bitcoin getrawtransaction "$txid")

# Get the transaction
tx=$(bitcoin-cli -datadir=$HOME/.bitcoin decoderawtransaction "$rawtx")

# Analysing the output, it appear to be a P2PWSH
# 
# Remembering the structure of a P2WSH,
# ["<signature1>", "<signature2>", "<redeem_script>"]
# It's worth to try to get the last element to parse the redeem script
redeem_script=$(echo "$tx" | jq -r '.vin[0].txinwitness[-1]')

# Decode the P2WPSH's redeem script
decoded_redeem_script=$(bitcoin-cli -datadir=$HOME/.bitcoin decodescript "$redeem_script")

# get the contract, separate them and strip to remove any space
asm=$(echo "$decoded_redeem_script" | jq -r ".asm")
echo "$asm" | cut -d " " -f2 | xargs
