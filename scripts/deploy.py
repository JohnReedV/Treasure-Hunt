from brownie import accounts, network, config, TreasureHunt
LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["hardhat",
                                 "development", "ganache", "mainnet-fork"]

DECIMALS = 8
INITIAL_VALUE = 200000000000


def deploy_thunt():
    account = get_account()
    treasure = TreasureHunt.deploy(
        config["token_URI"],
        {"from": account})


def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])


def main():
    deploy_thunt()
