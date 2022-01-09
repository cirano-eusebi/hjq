module Apply where

import Types (ExprQuery(..))
import Data.Aeson ( Value )

a :: ExprQuery -> Maybe Value -> Maybe Value
a (ExprQuery (Left _)) = const Nothing
a (ExprQuery (Right xs)) = \v -> foldr ($) v (reverse xs)

(>?) :: ExprQuery -> Maybe Value -> Maybe Value
(>?) = a

(<?) :: Maybe Value -> ExprQuery -> Maybe Value
(<?) = flip a