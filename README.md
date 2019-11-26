# wax-boot-testnet

The scripts contained in this repository allow you to:
  - Create a single node testnet ready to use containing all WAX related configuration and accounts.
  - Attach a node to a testnet.

## Prerequisites
  - ansible 2.8.5:
    ```
    sudo pip install 'ansible==2.8.5'
    ```

## How to build the testnet from scratch?

  - Get the latest version of the system contracts:
    ```
    # make get_latest_system_contracts
    ```
  - Change default keys for the WAX accounts located in (Optional / Recommended for public testnets) :
    ```
    ansible/roles/eos-node/files/wax_accounts.csv
    ```
  - Deploying main node:
    ```
    # PUB_KEY="<EOSIO_PUB_KEY>" PRIV_KEY="<EOSIO_PRIVATE_KEY>" make deploy_eosio_node
    ```
    NOTE: The same EOSIO_PUB_KEY and EOSIO_PRIVATE_KEY will be used for creating the `admin.wax` account.

  - Accessing node logs:
    ```
    $ journalctl -fu eos
    ```
  
  - Accessing cleos inside the docker container (example for getting chain info):
    ```
    # docker exec nodeos cleos get info
    ```
    
## Adding a node to the testnet (optional)

  - Adding a new producer node
    ```
    $ PRODUCER_NAME=<NEW_PRODUCER_NAME> INITIAL_KEY=<EOSIO_PUB_KEY> PUB_KEY=<NEW_PRODUCER_PUB_KEY> PRIV_KEY=<NEW_PRODUCER_PRIV_KEY> PEER=<EOSIO_NODE_IP> make create_producer_node
    ```
    After running this, the node will be ready to produce blocks. You just have to create the NEW_PRODUCER_NAME account and vote it in.