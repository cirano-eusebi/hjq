module Types (
    S(..),
    Query(..),
    ExprQuery(..)
) where

import Text.Parsec
import Data.Aeson.Types (Value)

data S = Move (Maybe String)
    | Index Int 
    deriving (Show, Eq)

newtype Query = Query { unQuery :: Either ParseError [S] }
    deriving (Show, Eq)

newtype ExprQuery = ExprQuery (Either ParseError [Maybe Value -> Maybe Value])
