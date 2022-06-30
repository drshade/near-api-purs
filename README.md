# near-api-purs

PureScript NEAR API 

** 100% work in progress - not ready for using **

# Milestones

## Summary

| #    | Description                    | Status      |
| ---  | ---                            | ---         |
| 1    | Proof of concept               | Complete    |
| 2    | Complete list of RPC methods   | In Progress |
| 3    | Typechecked Contracts          | In Progress |
| 4    | Documentation                  | Not Started |
| 5    | Package Publish                | Not Started |
| Next | Features Beyond Core NEAR API) | Not Started |

## Details

### Milestone 1 - Proof of Concept

- [x] Feability of interacting with the NEAR API directly
- [x] Idiomatic approach using monadic `ExceptT (Either e r)` does it feel good to use?

### Milestone 2 - Complete list of RPC methods

- [x] Wrapper mechanism (easy to add existing and more in time)
- [x] Complete all calls
- [ ] Test case approach & framework
- [ ] Implement key stores

### Milestone 3 - Typechecked Contracts

- [ ] Figure out best approach for type safe contract calls
    - First prize: Inspired by work in `purescript-routing` and `parsec` packages which would match method names to constructors based on type level definitions
    - Second prize: Code generation during compilation step (but unlikely as no equivalent to TemplateHaskell in PureScript AFAIK)
    - Third prize: Dynamic method calls using static strings e.g. `contract.call VIEW_METHOD "method_name"` - but maybe a nicer way to wrap this up for better DX
- [ ] Of course typechecking won't be able to really verify types of deployed Near Contract - and therefore must fail gracefully / give good runtime messages

### Milestone 4 - Documentation

- [ ] Pursuit documentation generated and reviewed
- [ ] Hosting documentation on github (or linked to future Pursuit pages)

### Milestone 5 - Package Publish

- [ ] Finalize LICENSE (feedback from PureScript / Near)
- [ ] Finalize README
- [ ] Figure out the process for publishing to purescript package set
    - Current recipe is documented here https://github.com/purescript-contrib/governance/blob/main/pursuit-preregistry.md
- [ ] Review repo / cleanup example & demo code
- [ ] Publish
- [ ] PureScript Community announcement (discord / slack / reddit)
- [ ] Near community announcement (discord)
- [ ] Get on radar of Near API team (future changes, API design feedback, etc)

### Milestone Next - Better features!

- [ ] A higher-level API - would we like one? Maybe something with "wallet" type functionality?
- [ ] zk-snarks implementation
    - Probably a seperate project (and includes the rust smart-contract side too)
    - Native implementation of snarksjs? wrap it? 
    - Circom compiler integration? Seems very messy. Does Near have an opinion?


# Installation:
```zsh
spago install near-api-purs
```

# Overview

This library is centred around the following type:
```PureScript
type NearApi a = ExceptT ClientError Aff a
```

And therefore:
```PureScript
runNearApi :: forall a. NearApi a -> Aff (Either ClientError a)
runNearApi = runExceptT
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

