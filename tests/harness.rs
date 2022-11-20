use fuels::{prelude::*, tx::ContractId};

// Load abi from json
abigen!(Acumen, "out/debug/acumen-abi.json");

async fn get_contract_instance() -> (Acumen, ContractId) {
    // Launch a local network and deploy the contract
    let mut wallets = launch_custom_provider_and_get_wallets(
        WalletsConfig::new(
            Some(1),             /* Single wallet */
            Some(1),             /* Single coin (UTXO) */
            Some(1_000_000_000), /* Amount per coin */
        ),
        None,
    )
    .await;
    let wallet = wallets.pop().unwrap();

    let id = Contract::deploy(
        "./out/debug/acumen.bin",
        &wallet,
        TxParameters::default(),
        StorageConfiguration::with_storage_path(Some(
            "./out/debug/acumen-storage_slots.json".to_string(),
        )),
    )
    .await
    .unwrap();

    let instance = MyContractBuilder::new(id.to_string(), wallet).build();

    (instance, id.into())
}

#[tokio::test]
async fn can_create_pool() {
      // Increment the counter
      let create = instance.create_pool(
       true,
        "testing00000001",
        10,
        false,
        31556926,
        1668975541,
        1669004341,
        70,
        10000,
        2000).call().await.unwrap();

      let result = instance.get_total_pools().call().await.unwrap();
      console.log(result)
      assert!(result.value > 0);
}
