module Extensions.StringQuery where

import Data.String (IsString(..))
import Types (Query(..))
import Parser (p)

instance IsString Query where
    fromString = p
