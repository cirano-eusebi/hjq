module Extensions.StringQuery where

import Data.String (IsString(..))
import Types (Query(..), ExprQuery(..))
import Builder (b)
import Parser (p)

instance IsString Query where
    fromString = p

instance IsString ExprQuery where
    fromString = b . p
