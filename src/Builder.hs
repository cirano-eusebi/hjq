module Builder (
    b
) where

import Control.Lens ( (^?), preview )
import Data.Aeson ( Value(..) )
import Data.Aeson.Lens ( key, nth, _Bool, _Object)
import Data.Maybe ( fromMaybe )
import Data.Text (pack)
import Data.Scientific ( Scientific(..), scientific )
import Text.Read ( readMaybe )
import Types

buildS :: S -> Maybe Value -> Maybe Value
buildS (Move Nothing) = id
buildS (Move (Just k)) = \(Just v) -> v ^? key (pack k)
-- buildS (Move (Just k)) = \(Just v) -> preview (key (pack k)) v
buildS (Index n) = \(Just v) -> v ^? nth n
buildS (Condition (SimpleExpr keyString)) = \(Just v) -> case v ^? key (pack keyString) of
    Just (Bool True) -> Just v
    _ -> Nothing
buildS (Condition (ComplexExpr keyString op literal)) = buildComplexExpr op keyString literal
buildS (Condition (UniExpr op keyString)) = buildUniExpr op keyString

buildComplexExpr :: BiOperation -> String -> String -> Maybe Value -> Maybe Value
buildComplexExpr Eq keyString literal = \(Just v) -> case v ^? key (pack keyString) of
    Just (Number n) -> if Just n == (readMaybe literal :: Maybe Scientific) then Just v else Nothing
    Just (String s) -> if s == pack literal then Just v else Nothing
    _ -> Nothing
buildComplexExpr Lt keyString literal = \(Just v) -> case v ^? key (pack keyString) of
    Just (Number n) -> if n < fromMaybe (scientific (-1) 1000) (readMaybe literal :: Maybe Scientific) then Just v else Nothing
    Just (String s) -> if s < pack literal then Just v else Nothing
    _ -> Nothing
buildComplexExpr Lte keyString literal = \(Just v) -> case v ^? key (pack keyString) of
    Just (Number n) -> if n <= fromMaybe (scientific (-1) 1000) (readMaybe literal :: Maybe Scientific) then Just v else Nothing
    Just (String s) -> if s <= pack literal then Just v else Nothing
    _ -> Nothing
buildComplexExpr Gt keyString literal = \(Just v) -> case v ^? key (pack keyString) of
    Just (Number n) -> if n > fromMaybe (scientific 1 1000) (readMaybe literal :: Maybe Scientific) then Just v else Nothing
    Just (String s) -> if s > pack literal then Just v else Nothing
    _ -> Nothing
buildComplexExpr Gte keyString literal = \(Just v) -> case v ^? key (pack keyString) of
    Just (Number n) -> if n >= fromMaybe (scientific 1 1000) (readMaybe literal :: Maybe Scientific) then Just v else Nothing
    Just (String s) -> if s >= pack literal then Just v else Nothing
    _ -> Nothing

buildUniExpr :: UniOperation -> String -> Maybe Value -> Maybe Value
buildUniExpr Not keyString = \(Just v) -> case v ^? key (pack keyString) of
    Just (Bool False) -> Just v
    _ -> Nothing
buildUniExpr Empty keyString = \(Just v) -> case v ^? key (pack keyString) of
    Just (Array vector) -> if null vector then Just v else Nothing
    _ -> Nothing
buildUniExpr NotEmpty keyString = \(Just v) -> case v ^? key (pack keyString) of
    Just (Array vector) -> if not $ null vector then Just v else Nothing
    _ -> Nothing

b :: Query -> ExprQuery
b (Query(Left e)) = ExprQuery(Left e)
b (Query(Right xs)) = ExprQuery(Right (map buildS xs))
