module Test.Simple where

import Prelude

import Data.Either (Either(..))
import Data.List (toUnfoldable)
import Data.String (joinWith)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class.Console (log)
import NearApi.Rpc.AccessKeys (view_access_key_list)
import NearApi.Rpc.AccountsContracts (view_account)
import NearApi.Rpc.Client (ClientError, runNearApi)
import NearApi.Rpc.NetworkConfig (testnet)
import NearApi.Rpc.Types.Common (BlockId_Or_Finality(..), Finality(..))

wrapError :: forall a. Aff (Either ClientError a) -> Aff Unit
wrapError r = do
    er <- r
    case er of
        Left err -> log $ "Error -> " <> show err
        Right  _ -> log "Completed"

main :: Effect Unit
main = 
    let account_id = "tomwells.testnet"

    in launchAff_ $ wrapError $ runNearApi do
        log $ account_id <> " access keys:"
        vakl <- view_access_key_list (Finality Final) { account_id : account_id } testnet
        log $ joinWith "\n" $ toUnfoldable $ (\k -> k.public_key) <$> vakl.keys
        
        account <- view_account (Finality Final) 
                { account_id: account_id 
                } testnet
        -- log $ show account
        log $ account_id <> " balance: " <> show account.amount
        log $ "      as at block number " <> show account.block_height
        log $ "                    hash " <> account.block_hash
