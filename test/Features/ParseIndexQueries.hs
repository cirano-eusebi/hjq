{-# LANGUAGE OverloadedStrings #-}

module Features.ParseIndexQueries ( main ) where

import Text.Format
import Test.Tasty
import Test.Tasty.HUnit
import Types (Query(..), S(..))
import Extensions.StringQuery ()
import qualified Parser(p)
import Data.Either (isLeft)

main :: TestTree
main = testGroup "Parser: Index Queries" [
        rejectEmptyBrackets,
        allowIntegers,
        rejectBracketsWithStrings
    ]

rejectEmptyBrackets :: TestTree
rejectEmptyBrackets = testCase "Reject empty brackets" $
    isLeft(unQuery(".[]" :: Query))@? "\".[]\" was parsed to the right"

allowIntegers :: TestTree
allowIntegers = testGroup "Accept brackets with ints" $
    map (\n -> testCase (format "\".[{0}]\"" [show n]) $
        Parser.p (format ".[{0}]" [show n])@?=
        Query (Right [Index n])
    ) [0, 5, 10, 999]

rejectBracketsWithStrings :: TestTree
rejectBracketsWithStrings = testGroup "Reject brackets with strings" $
        map (\n -> testCase (format "\".[{0}]\"" [show n]) $
            isLeft(unQuery (Parser.p (format ".[{0}]" [show n])))@?
            format "\"[{0}]\" was parsed to the right" [show n]
    ) ["", "0", "14"]
