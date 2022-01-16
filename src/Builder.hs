module Builder (
    b
) where

import Types ( Query(..), S(..), ExprQuery(..), BooleanExpr(..))
import Data.Aeson ( Value )
import Data.Aeson.Lens ( key, nth, _Bool)
import Control.Lens ( (^?), preview )
import Data.Text (pack)

buildS :: S -> Maybe Value -> Maybe Value
buildS (Move Nothing) = id
buildS (Move (Just k)) = \(Just v) -> v ^? key (pack k)
-- buildS (Move (Just k)) = \(Just v) -> preview (key (pack k)) v
buildS (Index n) = \(Just v) -> v ^? nth n
buildS (Condition (SimpleExpr s)) = \(Just v) -> case v ^? key (pack s) . _Bool of
    Just True -> Just v
    _ -> Nothing
buildS (Condition (ComplexExpr s1 op s2)) = id
buildS (Condition (UniExpr s1 op)) = id

b :: Query -> ExprQuery
b (Query(Left e)) = ExprQuery(Left e)
b (Query(Right xs)) = ExprQuery(Right (map buildS xs))
