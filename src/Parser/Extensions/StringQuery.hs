module Parser.Extensions.StringQuery where

import Data.String (IsString(..))
import Parser.Types (Query(..))
import Parser (r)

instance IsString Query where
    fromString s = Query $ r s