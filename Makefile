EOS_DOCKER_IMAGE_TAG = wax-1.8.4-1.0.0
EOS_DOCKER_IMAGE=waxteam/production:$(EOS_DOCKER_IMAGE_TAG)

check_eosio_config:
ifndef PUB_KEY
	$(error PUB_KEY is required)
endif

ifndef PRIV_KEY
	$(error PRIV_KEY is required)
endif

check_producer_config: check_eosio_config
ifndef PRODUCER_NAME
	$(error PRODUCER_NAME is required)
endif
ifndef PEER
	$(error PEER is required)
endif
ifndef INITIAL_KEY
	$(error INITIAL_KEY is required)
endif

create_eosio_node: check_eosio_config
	cd ansible && ansible-playbook \
	-e "eos_docker_image=$(EOS_DOCKER_IMAGE)" \
	-e "producer_name=eosio" \
	-e "initial_key=$(PUB_KEY)" \
	-e "pub_key=$(PUB_KEY)" \
	-e "priv_key=$(PRIV_KEY)" \
	-e "peers=127.0.0.1" \
	main.yml -i inv

deploy_eosio_node: create_eosio_node
	cd ansible && ansible-playbook \
	-e "initial_key=$(PUB_KEY)" \
	-e "priv_key=$(PRIV_KEY)" \
	deploy_contracts_and_accounts.yml -i inv

create_producer_node: check_producer_config
	cd ansible && ansible-playbook \
	-e "eos_docker_image=$(EOS_DOCKER_IMAGE)" \
	-e "producer_name=$(PRODUCER_NAME)" \
	-e "initial_key=$(INITIAL_KEY)" \
	-e "pub_key=$(PUB_KEY)" \
	-e "priv_key=$(PRIV_KEY)" \
	-e "peers=$(PEER)" \
	main.yml -i inv

get_latest_system_contracts:
	./ansible/roles/eos-node/scripts/get_wax-system-contracts.sh master