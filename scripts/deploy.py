from brownie import accounts, network, config, TreasureHunt
LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["hardhat",
                                 "development", "ganache", "mainnet-fork"]

DECIMALS = 8
INITIAL_VALUE = 200000000000


def deploy_thunt():
    account = get_account()
    treasure = TreasureHunt.deploy(
        config["networks"]["rinkeby"]["vrf_coordinator"],
        config["networks"]["rinkeby"]["link_token"],
        config["networks"]["rinkeby"]["fee"],
        config["networks"]["rinkeby"]["key_hash"],
        config["token_URI"],
        {"from": account},
        publish_source=config["networks"][network.show_active()].get(
            "verify", False),
    )


def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])


def main():
    deploy_thunt()
