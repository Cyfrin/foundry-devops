#!/bin/bash

# Get the script's own directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Move up two levels to get the project root directory
PROJECT_ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

contractName=$1
chainId=$2

if [ -z "$3" ]; then
  path="./broadcast"
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
    
    transactions_length=$(jq '.transactions | length' "$file")

    for ((i=0; i<$transactions_length; i++)); do
      currentTransactionType=$(jq -r ".transactions[$i].transactionType" "$file")
      currentContractName=$(jq -r ".transactions[$i].contractName" "$file")

      if [ "$currentTransactionType" == "CREATE" ] && [ "$currentContractName" == "$contractName" ] && [ $timestamp -gt $latestTimestamp ]; then
        latestTimestamp=$timestamp
        latestContractAddress=$(jq -r ".transactions[$i].contractAddress" "$file")
      fi
    done
  fi
done

if [ $latestTimestamp -ne 0 ]; then
  echo "$latestContractAddress"
else
  echo "0x0000000000000000000000000000000000000000"
fi
