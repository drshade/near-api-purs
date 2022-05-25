# near-sdk-purs
PureScript NEAR API 

# 100% work in progress - not ready for using

# Installation:
```zsh
spago install near-api-purs
```

# Overview

This library is centred around the following type:
```PureScript
type Web3 = ExceptT Web3Error Aff a
```

And therefore:
```PureScript
runWeb3 :: forall a. Web3 a -> Aff (Either Web3Error a)
```

# Examples:
```PureScript
main :: Effect Unit
main = do
    accountId <- runWeb3 do
        near <- NearApi.connect mainnet
        wallet <- NearApi.wallet near
        accountId <- NearApi.accountId wallet
        pure accountId

    case accountId of
        Left err  -> log $ "An error occurred: " <> show err
        Right id  -> log $ "Your account id: " <> show id
```

# Supported API Calls

A table tracking the implementation of all the NEAR Protocol RPC calls
(listed at https://docs.near.org/docs/api/rpc).


| Name | JSON-RPC Method | Discriminator | Status | Ref |
| --- | --- | --- | --- | --- |
| View access key | query | "request_type": "view_access_key" | https://docs.near.org/docs/api/rpc/access-keys#view-access-key | Done |
| View access key list | query | "request_type": "view_access_key_list" | https://docs.near.org/docs/api/rpc/access-keys#view-access-key-list | Done |
| View access key changes (single) | EXPERIMENTAL_changes | "changes_type": "single_access_key_changes" | https://docs.near.org/docs/api/rpc/access-keys#view-access-key-changes-single | Done |
| View access key changes (all) | EXPERIMENTAL_changes |  "changes_type": "all_access_key_changes" | https://docs.near.org/docs/api/rpc/access-keys#view-access-key-changes-all | Done |
| View account | query | "request_type": "view_account" | https://docs.near.org/docs/api/rpc/contracts#view-account | Done |
| View account changes | EXPERIMENTAL_changes | "changes_type": "account_changes" | https://docs.near.org/docs/api/rpc/contracts#view-account-changes | Done |
| View contract code | query | "request_type": "view_code" | https://docs.near.org/docs/api/rpc/contracts#view-contract-code | Done |
| View contract state | query | "request_type": "view_state" | https://docs.near.org/docs/api/rpc/contracts#view-contract-state | Done |
| View contract state changes | EXPERIMENTAL_changes | "changes_type": "data_changes" | https://docs.near.org/docs/api/rpc/contracts#view-contract-state-changes | Done |
| View contract code changes | EXPERIMENTAL_changes | "changes_type": "contract_code_changes" | https://docs.near.org/docs/api/rpc/contracts#view-contract-code-changes | Done |
| Call a contract function | query | "request_type": "call_function" | https://docs.near.org/docs/api/rpc/contracts#call-a-contract-function | Done |
| Block | block | N/A | https://docs.near.org/docs/api/rpc/block-chunk#block-details | Done |
| Changes in Block | EXPERIMENTAL_changes_in_block | N/A | https://docs.near.org/docs/api/rpc/block-chunk#changes-in-block | Done |
| Chunk | chunk | N/A | https://docs.near.org/docs/api/rpc/block-chunk#chunk-details | Done |
| Gas Price | gas_price | N/A | https://docs.near.org/docs/api/rpc/gas#gas-price | Done |
| Genesis Config | EXPERIMENTAL_genesis_config | N/A | https://docs.near.org/docs/api/rpc/protocol#genesis-config | Done |
| Protocol Config | EXPERIMENTAL_protocol_config | N/A | https://docs.near.org/docs/api/rpc/protocol#protocol-config | Done |
| Node Status | status | N/A | https://docs.near.org/docs/api/rpc/network#node-status | Done |
| Network Info | network_info | N/A | https://docs.near.org/docs/api/rpc/network#network-info | Done |
| Validation Status | validators | N/A | https://docs.near.org/docs/api/rpc/network#validation-status | Done |
| Send transaction (async) | broadcast_tx_async | N/A | https://docs.near.org/docs/api/rpc/transactions#send-transaction-async | Done |
| Send transaction (await) | broadcast_tx_commit | N/A | https://docs.near.org/docs/api/rpc/transactions#send-transaction-await | Done |
| Transaction Status | tx | N/A | https://docs.near.org/docs/api/rpc/transactions#transaction-status | Done |
| Transaction Status with Receipts | EXPERIMENTAL_tx_status | N/A | https://docs.near.org/docs/api/rpc/transactions#transaction-status-with-receipts | Done |
| Receipt by ID | EXPERIMENTAL_receipt | N/A | https://docs.near.org/docs/api/rpc/transactions#receipt-by-id | Done |
| Patch State | sandbox_patch_state | N/A | https://docs.near.org/docs/api/rpc/sandbox#patch-state | Do need it? |

