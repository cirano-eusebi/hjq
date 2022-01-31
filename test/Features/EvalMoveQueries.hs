{-# LANGUAGE OverloadedStrings #-}

module Features.EvalMoveQueries ( main ) where

import Test.Tasty
import Test.Tasty.HUnit
import Types
import Extensions.StringQuery ()
import Eval ( (>?) )
import Text.Format
import Data.String
import qualified Data.ByteString.Lazy.UTF8 as BLU
import Data.Maybe
import Data.Either (isLeft)
import Data.Aeson
import Data.Aeson.Text

main :: TestTree
main = testGroup "Apply: Move Queries" [
        emptyStringDoesntMove,
        singleKeyMovesOnce
    ]

emptyStringDoesntMove :: TestTree
emptyStringDoesntMove = testGroup "Empty string doesn't move" $
    Prelude.map (\j -> testCase (format "{0}" [show j]) $
        encodeToLazyText(("" :: Query)>? (decode (BLU.fromString j) :: Maybe Value ))
        @?= fromString j
    ) ["{}", "[]", "{\"a\":1}"]

singleKeyMovesOnce :: TestTree
singleKeyMovesOnce = testCase "Single key Moves Once"
    $ encodeToLazyText((".one" :: Query)>? (decode "{\"one\":{\"two\":{}}}" :: Maybe Value))
    @?= fromString "{\"two\":{}}"

doubleKeyMovesTwice :: TestTree
doubleKeyMovesTwice = testCase "Double key Moves twice"
    $ encodeToLazyText((".one.two" :: Query)>? (decode "{\"one\":{\"two\":{\"three\":{}}}}" :: Maybe Value))
    @?= fromString "{\"three\":{}}"
