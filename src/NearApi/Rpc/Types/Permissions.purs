module NearApi.Rpc.Types.Permissions where

import Prelude

import Data.Argonaut.Core (Json, toObject, toString)
import Data.Argonaut.Decode (JsonDecodeError(..), decodeJson)
import Data.Argonaut.Decode.Class (class DecodeJson)
import Data.Either (Either(..), hush)
import Data.Foldable (foldr)
import Data.Generic.Rep (class Generic)
import Data.List (List(Nil), catMaybes, (:))
import Data.Maybe (Maybe(..))
import Data.Show.Generic (genericShow)
import Data.Tuple (Tuple(..))
import Foreign.Object (toUnfoldable)
import NearApi.Rpc.Types.Common (AmountInYocto)

data Permission
    = FullAccessPermission
    | PartialAccessPermission (List IndividualPermission)

derive instance genericPermission ∷ Generic Permission _
instance showPermission ∷ Show Permission where
    show = genericShow

data IndividualPermission = FunctionCall
    { allowance ∷ AmountInYocto
    , method_names ∷ Array String
    , receiver_id ∷ String
    }

-- Could be others?

derive instance genericIndividualPermission ∷ Generic IndividualPermission _
instance showIndividualPermission ∷ Show IndividualPermission where
    show = genericShow

instance decodeJsonPermission ∷ DecodeJson Permission where
    decodeJson ∷ Json → Either JsonDecodeError Permission
    decodeJson blob =
        -- Could be "FullAccess"
        if toString blob == Just "FullAccess" then
            Right $ FullAccessPermission
        else
            -- Probably an object, e.g.:
            -- { "FunctionCall" : ... }
            case toObject blob of
                Nothing → Left $ UnexpectedValue blob
                Just obj →
                    let
                        permissionList ∷ List (Tuple String Json)
                        permissionList = toUnfoldable obj

                        parse ∷ String → Json → Maybe IndividualPermission
                        parse "FunctionCall" json = hush $ FunctionCall <$> decodeJson json
                        parse _ _ = Nothing
                    -- Run parse() on all keys of the permission object and then collect up all the
                    -- individual permissions into the list
                    in
                        Right $ PartialAccessPermission $ catMaybes $ foldr (\(Tuple k v) acc → parse k v : acc) Nil $ permissionList
