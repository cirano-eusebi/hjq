{-# LANGUAGE OverloadedStrings #-}

module Features.EvalIndexQueries ( main ) where

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
main = testGroup "Apply: Index Queries" [
        indexMovesOnce,
        doubleKeyAndIndex
    ]

indexMovesOnce :: TestTree
indexMovesOnce = testCase "Index Moves Once"
    $ encodeToLazyText((".five[1]" :: Query)>? (decode "{\"one\":{\"two\":{\"three\":{}}},\"five\":[\"A\", \"B\", \"C\"]}" :: Maybe Value))
    @?= fromString "\"B\""

doubleKeyAndIndex :: TestTree
doubleKeyAndIndex = testCase "Double Key"
    $ encodeToLazyText((".one.five[0]" :: Query)>? (decode "{\"one\":{\"five\":[\"A\", \"B\", \"C\"]}}" :: Maybe Value))
    @?= fromString "\"A\""
