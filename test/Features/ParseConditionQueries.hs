{-# LANGUAGE OverloadedStrings #-}

module Features.ParseConditionQueries ( main ) where

import Test.Tasty
import Test.Tasty.HUnit
import Types (Query(..), S(..), BooleanExpr (SimpleExpr, UniExpr), UniOperation (Empty, NotEmpty))
import Extensions.StringQuery ()
import Data.Either (isLeft)

main :: TestTree
main = testGroup "Parser: Condition Queries" [
        acceptKeyString,
        rejectEmptyKey,
        acceptEmptyString,
        acceptNotEmptyString
    ]

acceptKeyString :: TestTree
acceptKeyString = testCase "Accept Key"
    $ (".(saraza)" :: Query)@?= Query (Right [Move Nothing,Condition (SimpleExpr "saraza") ])

rejectEmptyKey :: TestTree
rejectEmptyKey = testCase "Reject Empty Key"
    $ isLeft (unQuery (".()" :: Query))@? "\"key\" was parsed to the right"

acceptEmptyString :: TestTree
acceptEmptyString = testCase "Accept empty condition"
    $ (".(saraza empty)" :: Query)@?= Query (Right [Move Nothing,Condition (UniExpr Empty "saraza") ])

acceptNotEmptyString :: TestTree
acceptNotEmptyString = testCase "Accept notEmpty condition"
    $ (".(saraza notEmpty)" :: Query)@?= Query (Right [Move Nothing,Condition (UniExpr NotEmpty "saraza") ])