module Eval (
    eval, (>?), (<?)
) where

import Control.Lens ( (^?), preview )
import Data.Aeson ( Value(..) )
import Data.Aeson.Lens ( key, nth, _Bool, _Object)
import Data.Maybe ( fromMaybe )
import Data.Text (pack)
import Data.Scientific ( Scientific(..), scientific )
import Text.Read ( readMaybe )
import Types

bindMaybe :: Maybe a -> (a -> Maybe b) -> Maybe b
bindMaybe Nothing _ = Nothing
bindMaybe (Just x) f = f x

buildS :: S -> Maybe Value -> Maybe Value
buildS (Move Nothing) = id
buildS (Move (Just k)) = \mv -> bindMaybe mv (\v -> v ^? key (pack k))
-- buildS (Move (Just k)) = \(Just v) -> preview (key (pack k)) v
buildS (Index n) = \mv -> bindMaybe mv (\v -> v ^? nth n)
buildS (Condition (SimpleExpr keyString)) = \mv -> bindMaybe mv (\v -> case v ^? key (pack keyString) of
    Just (Bool True) -> Just v
    _ -> Nothing)
buildS (Condition (ComplexExpr keyString op literal)) = buildComplexExpr op keyString literal
buildS (Condition (UniExpr op keyString)) = buildUniExpr op keyString

buildComplexExpr :: BiOperation -> String -> String -> Maybe Value -> Maybe Value
buildComplexExpr Eq keyString literal = \mv -> bindMaybe mv (\v -> case v ^? key (pack keyString) of
    Just (Number n) -> if Just n == (readMaybe literal :: Maybe Scientific) then Just v else Nothing
    Just (String s) -> if s == pack literal then Just v else Nothing
    _ -> Nothing)
buildComplexExpr Lt keyString literal = \mv -> bindMaybe mv (\v -> case v ^? key (pack keyString) of
    Just (Number n) -> if n < fromMaybe (scientific (-1) 1000) (readMaybe literal :: Maybe Scientific) then Just v else Nothing
    Just (String s) -> if s < pack literal then Just v else Nothing
    _ -> Nothing)
buildComplexExpr Lte keyString literal = \mv -> bindMaybe mv (\v -> case v ^? key (pack keyString) of
    Just (Number n) -> if n <= fromMaybe (scientific (-1) 1000) (readMaybe literal :: Maybe Scientific) then Just v else Nothing
    Just (String s) -> if s <= pack literal then Just v else Nothing
    _ -> Nothing)
buildComplexExpr Gt keyString literal = \mv -> bindMaybe mv (\v -> case v ^? key (pack keyString) of
    Just (Number n) -> if n > fromMaybe (scientific 1 1000) (readMaybe literal :: Maybe Scientific) then Just v else Nothing
    Just (String s) -> if s > pack literal then Just v else Nothing
    _ -> Nothing)
buildComplexExpr Gte keyString literal = \mv -> bindMaybe mv (\v -> case v ^? key (pack keyString) of
    Just (Number n) -> if n >= fromMaybe (scientific 1 1000) (readMaybe literal :: Maybe Scientific) then Just v else Nothing
    Just (String s) -> if s >= pack literal then Just v else Nothing
    _ -> Nothing)

buildUniExpr :: UniOperation -> String -> Maybe Value -> Maybe Value
buildUniExpr Not keyString = \mv -> bindMaybe mv (\v -> case v ^? key (pack keyString) of
    Just (Bool False) -> Just v
    _ -> Nothing)
buildUniExpr Empty keyString = \mv -> bindMaybe mv (\v -> case v ^? key (pack keyString) of
    Just (Array vector) -> if null vector then Just v else Nothing
    _ -> Nothing)
buildUniExpr NotEmpty keyString = \mv -> bindMaybe mv (\v -> case v ^? key (pack keyString) of
    Just (Array vector) -> if not $ null vector then Just v else Nothing
    _ -> Nothing)

eval :: Query -> (Maybe Value -> Maybe Value)
eval (Query(Left e)) = const Nothing
eval (Query(Right xs)) = foldr (\s f -> f . buildS s) id xs

(>?) :: Query -> (Maybe Value -> Maybe Value)
(>?) = eval

(<?) :: Maybe Value -> Query -> Maybe Value
(<?) = flip eval
