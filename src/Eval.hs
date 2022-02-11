module Eval (
    eval, (>?), (<?)
) where

import Control.Lens ( (^?) )
import Control.Lens.Type
import Data.Aeson ( Value(..) )
import Data.Aeson.Lens ( key, nth )
import Data.Maybe ( fromMaybe )
import Data.Text ( pack )
import Data.Scientific ( Scientific(..), scientific )
import Text.Read ( readMaybe )
import Types

buildS :: S -> Maybe Value -> Maybe Value
buildS (Move Nothing) = id
buildS (Move (Just k)) = (=<<) (^? key (pack k))
buildS (Index n) = (=<<) (^? nth n)
buildS (Condition (SimpleExpr keyString)) = (=<<) (\v -> case v ^? key (pack keyString) of
    Just (Bool True) -> Just v
    _ -> Nothing)
buildS (Condition (ComplexExpr keyString op literal)) = buildComplexExpr op keyString literal
buildS (Condition (UniExpr op keyString)) = buildUniExpr op keyString

buildComplexExpr :: BiOperation -> String -> String -> Maybe Value -> Maybe Value
buildComplexExpr Eq keyString literal = (=<<) (\v -> case v ^? key (pack keyString) of
    Just (Number n) -> if Just n == (readMaybe literal :: Maybe Scientific) then Just v else Nothing
    Just (String s) -> if s == pack literal then Just v else Nothing
    _ -> Nothing)
buildComplexExpr Lt keyString literal = (=<<) (\v -> case v ^? key (pack keyString) of
    Just (Number n) -> if n < fromMaybe (scientific (-1) 1000) (readMaybe literal :: Maybe Scientific) then Just v else Nothing
    Just (String s) -> if s < pack literal then Just v else Nothing
    _ -> Nothing)
buildComplexExpr Lte keyString literal = (=<<) (\v -> case v ^? key (pack keyString) of
    Just (Number n) -> if n <= fromMaybe (scientific (-1) 1000) (readMaybe literal :: Maybe Scientific) then Just v else Nothing
    Just (String s) -> if s <= pack literal then Just v else Nothing
    _ -> Nothing)
buildComplexExpr Gt keyString literal = (=<<) (\v -> case v ^? key (pack keyString) of
    Just (Number n) -> if n > fromMaybe (scientific 1 1000) (readMaybe literal :: Maybe Scientific) then Just v else Nothing
    Just (String s) -> if s > pack literal then Just v else Nothing
    _ -> Nothing)
buildComplexExpr Gte keyString literal = (=<<) (\v -> case v ^? key (pack keyString) of
    Just (Number n) -> if n >= fromMaybe (scientific 1 1000) (readMaybe literal :: Maybe Scientific) then Just v else Nothing
    Just (String s) -> if s >= pack literal then Just v else Nothing
    _ -> Nothing)

buildUniExpr :: UniOperation -> String -> Maybe Value -> Maybe Value
buildUniExpr Not keyString = (=<<) (\v -> case v ^? key (pack keyString) of
    Just (Bool False) -> Just v
    _ -> Nothing)
buildUniExpr Empty keyString = (=<<) (\v -> case v ^? key (pack keyString) of
    Just (Array vector) -> if null vector then Just v else Nothing
    _ -> Nothing)
buildUniExpr NotEmpty keyString = (=<<) (\v -> case v ^? key (pack keyString) of
    Just (Array vector) -> if not $ null vector then Just v else Nothing
    _ -> Nothing)

eval :: Query -> (Maybe Value -> Maybe Value)
eval (Query(Left e)) = const Nothing
eval (Query(Right xs)) = foldr (\s f -> f . buildS s) id xs

(>?) :: Query -> (Maybe Value -> Maybe Value)
(>?) = eval

(<?) :: Maybe Value -> Query -> Maybe Value
(<?) = flip eval
