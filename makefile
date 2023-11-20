.PHONY: update anvil deploy

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

update:; forge update

anvil:;  anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

deploy:; forge script script/DeployStuff.s.sol:DeployStuff --broadcast --rpc-url http://localhost:8545  --private-key $(DEFAULT_ANVIL_KEY)   -vvvv 

interact:; forge script script/InteractWithStuff.s.sol:InteractWithStuff --broadcast --rpc-url http://localhost:8545  --private-key $(DEFAULT_ANVIL_KEY)   -vvvv 