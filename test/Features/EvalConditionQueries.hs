{-# LANGUAGE OverloadedStrings #-}

module Features.EvalConditionQueries ( main ) where

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
main = testGroup "Apply: Condition Queries" [
        simpleConditionTrue,
        simpleConditionFalse,
        simpleConditionInvalid,
        uniOpNotConditionTrue,
        uniOpNotConditionFalse,
        uniOpNotConditionInvalid,
        uniOpEmptyConditionTrue,
        uniOpEmptyConditionFalse,
        uniOpEmptyConditionInvalid,
        uniOpNotEmptyConditionTrue,
        uniOpNotEmptyConditionFalse,
        uniOpNotEmptyConditionInvalid
    ]

simpleConditionTrue :: TestTree
simpleConditionTrue = testCase "Simple Condition True"
    $ encodeToLazyText((".one.two(half)" :: Query)>? (decode "{\"one\":{\"two\":{\"three\":{},\"half\": true}},\"five\":[\"A\", \"B\", \"C\"]}" :: Maybe Value))
    @?= fromString "{\"half\":true,\"three\":{}}"

simpleConditionFalse :: TestTree
simpleConditionFalse = testCase "Simple Condition False"
    $ encodeToLazyText((".one.two(complete)" :: Query)>? (decode "{\"one\":{\"two\":{\"three\":{},\"half\": true, \"complete\": false}},\"five\":[\"A\", \"B\", \"C\"]}" :: Maybe Value))
    @?= fromString "null"

simpleConditionInvalid :: TestTree
simpleConditionInvalid = testCase "Simple Condition Invalid"
    $ encodeToLazyText((".one.two(three)" :: Query)>? (decode "{\"one\":{\"two\":{\"three\":{},\"half\": true}},\"five\":[\"A\", \"B\", \"C\"]}" :: Maybe Value))
    @?= fromString "null"

uniOpNotConditionTrue :: TestTree
uniOpNotConditionTrue = testCase "Not Condition True"
    $ encodeToLazyText((".one.two(complete not)" :: Query)>? (decode "{\"one\":{\"two\":{\"three\":[],\"half\": true,\"complete\":false}},\"five\":[\"A\", \"B\", \"C\"]}" :: Maybe Value))
    @?= fromString "{\"half\":true,\"three\":[],\"complete\":false}"

uniOpNotConditionFalse :: TestTree
uniOpNotConditionFalse = testCase "Not Condition False"
    $ encodeToLazyText((".one.two(half not)" :: Query)>? (decode "{\"one\":{\"two\":{\"three\":[],\"half\":true,\"complete\":false}},\"five\":[\"A\", \"B\", \"C\"]}" :: Maybe Value))
    @?= fromString "null"

uniOpNotConditionInvalid :: TestTree
uniOpNotConditionInvalid = testCase "Not Condition Invalid"
    $ encodeToLazyText((".one.two(three not)" :: Query)>? (decode "{\"one\":{\"two\":{\"three\":[],\"half\": true}},\"five\":[\"A\", \"B\", \"C\"]}" :: Maybe Value))
    @?= fromString "null"

uniOpEmptyConditionTrue :: TestTree
uniOpEmptyConditionTrue = testCase "Empty Condition True"
    $ encodeToLazyText((".one.two(three empty)" :: Query)>? (decode "{\"one\":{\"two\":{\"three\":[],\"half\": true,\"complete\":false}},\"five\":[\"A\", \"B\", \"C\"]}" :: Maybe Value))
    @?= fromString "{\"half\":true,\"three\":[],\"complete\":false}"

uniOpEmptyConditionFalse :: TestTree
uniOpEmptyConditionFalse = testCase "Empty Condition False"
    $ encodeToLazyText((".(five empty)" :: Query)>? (decode "{\"one\":{\"two\":{\"three\":[],\"half\":true,\"complete\":false}},\"five\":[\"A\", \"B\", \"C\"]}" :: Maybe Value))
    @?= fromString "null"

uniOpEmptyConditionInvalid :: TestTree
uniOpEmptyConditionInvalid = testCase "Empty Condition Invalid"
    $ encodeToLazyText((".one.two(half empty)" :: Query)>? (decode "{\"one\":{\"two\":{\"three\":[],\"half\": true}},\"five\":[\"A\", \"B\", \"C\"]}" :: Maybe Value))
    @?= fromString "null"

uniOpNotEmptyConditionTrue :: TestTree
uniOpNotEmptyConditionTrue = testCase "NotEmpty Condition True"
    $ encodeToLazyText((".(five notEmpty)" :: Query)>? (decode "{\"one\":{\"two\":{\"three\":[],\"half\": true,\"complete\":false}},\"five\":[\"A\", \"B\", \"C\"]}" :: Maybe Value))
    @?= fromString "{\"five\":[\"A\",\"B\",\"C\"],\"one\":{\"two\":{\"half\":true,\"three\":[],\"complete\":false}}}"

uniOpNotEmptyConditionFalse :: TestTree
uniOpNotEmptyConditionFalse = testCase "NotEmpty Condition False"
    $ encodeToLazyText((".one.two(three notEmpty)" :: Query)>? (decode "{\"one\":{\"two\":{\"three\":[],\"half\":true,\"complete\":false}},\"five\":[\"A\", \"B\", \"C\"]}" :: Maybe Value))
    @?= fromString "null"

uniOpNotEmptyConditionInvalid :: TestTree
uniOpNotEmptyConditionInvalid = testCase "NotEmpty Condition Invalid"
    $ encodeToLazyText((".one.two(half notEmpty)" :: Query)>? (decode "{\"one\":{\"two\":{\"three\":[],\"half\": true}},\"five\":[\"A\", \"B\", \"C\"]}" :: Maybe Value))
    @?= fromString "null"



