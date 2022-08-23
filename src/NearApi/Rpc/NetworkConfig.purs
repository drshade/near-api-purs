module NearApi.Rpc.NetworkConfig where

type NetworkConfig =
    { networkId ∷ String
    , nodeUrl ∷ String
    , walletUrl ∷ String
    , helperUrl ∷ String
    , explorerUrl ∷ String
    }

mainnet ∷ NetworkConfig
mainnet =
    { networkId: "mainnet"
    , nodeUrl: "https://rpc.mainnet.near.org"
    , walletUrl: "https://wallet.mainnet.near.org"
    , helperUrl: "https://helper.mainnet.near.org"
    , explorerUrl: "https://explorer.mainnet.near.org"
    }

testnet ∷ NetworkConfig
testnet =
    { networkId: "testnet"
    , nodeUrl: "https://rpc.testnet.near.org"
    , walletUrl: "https://wallet.testnet.near.org"
    , helperUrl: "https://helper.testnet.near.org"
    , explorerUrl: "https://explorer.testnet.near.org"
    }

betanet ∷ NetworkConfig
betanet =
    { networkId: "betanet"
    , nodeUrl: "https://rpc.betanet.near.org"
    , walletUrl: "https://wallet.betanet.near.org"
    , helperUrl: "https://helper.betanet.near.org"
    , explorerUrl: "https://explorer.betanet.near.org"
    }

-- mainnetArchival :: NetworkConfig
-- mainnetArchival = { nodeUrl : "https://archival-rpc.mainnet.near.org" }

-- testnetArchival :: NetworkConfig
-- testnetArchival = { nodeUrl : "https://archival-rpc.testnet.near.org" }
