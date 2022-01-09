module Types (
    S(..),
    Query(..)
) where

import Text.Parsec

data S = Move (Maybe String)
    | Index Int 
    deriving (Show, Eq)

newtype Query = Query { unQuery :: Either ParseError [S] }
    deriving (Show, Eq)