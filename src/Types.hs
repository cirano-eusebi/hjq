module Types where

import Text.Parsec
import Data.Aeson.Types (Value)

data S = Move (Maybe String)
    | Index Int
    | Condition BooleanExpr
    deriving (Show, Eq)

newtype Query = Query { unQuery :: Either ParseError [S] }
    deriving (Show, Eq)

data BooleanExpr = SimpleExpr String
    | ComplexExpr String BiOperation String
    | UniExpr UniOperation String
    deriving (Show, Eq)

data BiOperation = Eq | Lt | Gt | Lte | Gte
    deriving (Show, Eq)

data UniOperation = Not | Empty | NotEmpty
    deriving (Show, Eq)
