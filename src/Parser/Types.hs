module Parser.Types where

data S = Move (Maybe String)
    | Index Int 
    deriving (Show, Eq)