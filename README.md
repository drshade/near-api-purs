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

# Test webhook