module Builder (
    b
) where

import Types ( Query(..), S(..), ExprQuery(..) )
import Data.Aeson ( Value )
import Data.Aeson.Lens ( key, nth )
import Control.Lens ( (^?) )
import Data.Text (pack)

buildS :: S -> Maybe Value -> Maybe Value
buildS (Move Nothing) = id
buildS (Move (Just k)) = \(Just v) -> v ^? key (pack k)
buildS (Index n) = \(Just v) -> v ^? nth n

b :: Query -> ExprQuery
b (Query(Left e)) = ExprQuery(Left e)
b (Query(Right xs)) = ExprQuery(Right (map buildS xs))
