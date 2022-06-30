module NearApi.Rpc.NetworkConfig where

type NetworkConfig = 
    { rpc :: String 
    }

mainnet :: NetworkConfig
mainnet = { rpc : "https://rpc.mainnet.near.org" }

testnet :: NetworkConfig
testnet = { rpc : "https://rpc.testnet.near.org" }

betanet :: NetworkConfig
betanet = { rpc : "https://rpc.betanet.near.org" }

mainnetArchival :: NetworkConfig
mainnetArchival = { rpc : "https://archival-rpc.mainnet.near.org" }

testnetArchival :: NetworkConfig
testnetArchival = { rpc : "https://archival-rpc.testnet.near.org" }
