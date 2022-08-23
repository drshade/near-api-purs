module Test.Contracts where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import NearApi.Rpc.Client (NearApi)

hello ∷ String → String → NearApi String
hello contractname who =
    pure "hello"

main ∷ Effect Unit
main = log "contracts"