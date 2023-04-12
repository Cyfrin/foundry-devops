#!/bin/bash

contractName=$1
chainId=$2

if [ -z "$3" ]; then
  path="../../../broadcast"
else
  path="$3"
fi

if [ -z "$contractName" ] || [ -z "$chainId" ] ; then
  echo "Usage: $0 <contractName> <chainId> [path]"
  exit 1
fi


latestTimestamp=0
latestContractAddress=""

files=$(find $path -name "run-latest.json" -type f)

for file in $files; do
  if [[ $file == *"/$chainId/"* ]]; then
    timestamp=$(jq '.timestamp' "$file")
    currentTransactionType=$(jq -r '.transactions[0].transactionType' "$file")
    currentContractName=$(jq -r '.transactions[0].contractName' "$file")

    if [ "$currentTransactionType" == "CREATE" ] && [ "$currentContractName" == "$contractName" ] && [ $timestamp -gt $latestTimestamp ]; then
      latestTimestamp=$timestamp
      latestContractAddress=$(jq -r '.transactions[0].contractAddress' "$file")
    fi
  fi
done

if [ $latestTimestamp -ne 0 ]; then
  echo "$latestContractAddress"
else
  echo "0x0000000000000000000000000000000000000000"
fi
