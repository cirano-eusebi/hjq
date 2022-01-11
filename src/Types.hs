module Types (
    S(..),
    Query(..),
    ExprQuery(..),
    BooleanExpr(..)
) where

import Text.Parsec
import Data.Aeson.Types (Value)

data S = Move (Maybe String)
    | Index Int 
    | Condition BooleanExpr
    deriving (Show, Eq)

newtype Query = Query { unQuery :: Either ParseError [S] }
    deriving (Show, Eq)

newtype ExprQuery = ExprQuery (Either ParseError [Maybe Value -> Maybe Value])

data BooleanExpr = SimpleExpr String
    | ComplexExpr String SimpleOperation String
    | UniExpr SimpleOperation String
    deriving (Show, Eq)

data SimpleOperation = Eq | Lt | Gt | Not
    deriving (Show, Eq)