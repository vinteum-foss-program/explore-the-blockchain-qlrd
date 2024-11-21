# (true / false) Verify the signature by this address over this message:
#   address: `1E9YwDtYf9R29ekNAfbV7MvB4LNv7v3fGa`
#   message: `1E9YwDtYf9R29ekNAfbV7MvB4LNv7v3fGa`
#   signature: `hCsBcgB+Wcm8kOGMH8IpNeg0H4gjCrlqwDf/GlSXphZGBYxm0QkKEPhh9DTJRp2IDNUhVr0FhP9qCqo2W0recNM=`

# -----------
# The address
# -----------
address=1E9YwDtYf9R29ekNAfbV7MvB4LNv7v3fGa

# -----------
# The message
# -----------
message=1E9YwDtYf9R29ekNAfbV7MvB4LNv7v3fGa

# -----------------------------------------------------------------
# Put the signature between "" to avoid errors with some characters
# -----------------------------------------------------------------
signature="hCsBcgB+Wcm8kOGMH8IpNeg0H4gjCrlqwDf/GlSXphZGBYxm0QkKEPhh9DTJRp2IDNUhVr0FhP9qCqo2W0recNM="

# -----------------------------------
# The result should be 'false', like
# classroom.yml says on the step.
#
# Locally, with this script, the cli
# will use a 127.0.0.1 connection.
# To force it to the  proposed bitcoin.conf
# placed on submission/setup.sh, add
# -datadir option (so its behaviour
# will be the same on github-actions).
# -----------------------------------
echo $(bitcoin-cli -datadir=$HOME/.bitcoin verifymessage $address $signature $message)
