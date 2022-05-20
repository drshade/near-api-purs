module Test.Main2 where

import Prelude

import Data.List ((:), List(Nil))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class.Console (log)
import NearApi.Rpc.AccessKeys (single_access_key_changes, view_access_key, view_access_key_list)
import NearApi.Rpc.Network (network_info, status)
import NearApi.Rpc.NetworkConfig (testnet)

main :: Effect Unit
main =
    launchAff_ do
        vak <- view_access_key "tomwells.testnet" "ed25519:6szh72LjabzfaDnwLMcjs2bJpm1C7XkYubNEBDXy1cZ3" testnet
        log $ show vak

        vakl <- view_access_key_list "tomwells.testnet" testnet
        log $ show vakl

        changes <- single_access_key_changes ({ account_id : "tomwells.testnet", public_key : "ed25519:6szh72LjabzfaDnwLMcjs2bJpm1C7XkYubNEBDXy1cZ3" } : Nil) testnet
        log $ show changes

        status <- status testnet
        log $ show status

        info <- network_info testnet
        log $ show info