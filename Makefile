-include .env

install:
	forge install Openzeppelin/openzeppelin-contracts foundry-rs/forge-std --no-commit

deploy:
	forge create EventFactory --private-key ${PRIVATE_KEY} --verify --rpc-url ${RINKEBY_RPC_URL} --etherscan-api-key ${ETHERSCAN_KEY}

script:
	forge script scripts/EventFactory.s.sol:EventFactory --rpc-url ${RINKEBY_RPC_URL}  --private-key ${PRIVATE_KEY} --broadcast --verify --etherscan-api-key ${ETHERSCAN_KEY} -vvvv

# run anvil in another terminal
script-local:
	forge script scripts/EventFactory.s.sol:EventFactoryScript --fork-url http://localhost:8545 --private-key ${PRIVATE_KEY_LOCAL} --broadcast

clean:
	remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

tests:
	forge test -vvvv