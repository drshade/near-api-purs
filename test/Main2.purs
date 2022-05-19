module Test.Main2 where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class.Console (log)
import NearApi.Rpc.Client (view_access_keys, view_access_keys')
import NearApi.Rpc.Network (testnet)

main :: Effect Unit
main =
    launchAff_ do
        vak <- view_access_keys' testnet
        log $ show vak