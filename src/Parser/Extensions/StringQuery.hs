module Parser.Extensions.StringQuery where

import Data.String (IsString(..))
import Types (Query(..))
import Parser (r)

instance IsString Query where
    fromString = r