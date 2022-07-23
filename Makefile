-include .env

install:
	forge install Openzeppelin/openzeppelin-contracts foundry-rs/forge-std Openzeppelin/openzeppelin-contracts-upgradeable --no-commit

deploy-event:
	forge create Event --private-key ${PRIVATE_KEY} --verify --rpc-url ${RINKEBY_RPC_URL} --etherscan-api-key ${ETHERSCAN_KEY}

# event blueprint is the address from the previously deployed event
deploy-factory:
	forge create EventFactoryNonUpgradeable --private-key ${PRIVATE_KEY} --verify --rpc-url ${RINKEBY_RPC_URL} --constructor-args ${OWNER} --etherscan-api-key ${ETHERSCAN_KEY}

# using --legacy because of a bug in deploying to polygon mainnet
# (https://github.com/foundry-rs/foundry/issues/1703)
deploy-no-verify:
	forge create EventFactory --private-key ${PRIVATE_KEY} --rpc-url ${RPC_URL} --legacy

script:
	forge script scripts/Upgrade.s.sol:EventBeacon --rpc-url ${RINKEBY_RPC_URL}  --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${ETHERSCAN_KEY} -vvvv

# run anvil in another terminal
script-local:
	forge script scripts/Upgrade.s.sol:EventBeacon --fork-url http://localhost:8545 --private-key ${PRIVATE_KEY_LOCAL} --broadcast

clean:
	remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

tests:
	forge test -vvvv
