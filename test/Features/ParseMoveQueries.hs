{-# LANGUAGE OverloadedStrings #-}

module Features.ParseMoveQueries ( main ) where

import Test.Tasty
import Test.Tasty.HUnit
import Types (Query(..), S(..))
import Extensions.StringQuery ()
import Data.Either (isLeft)

main :: TestTree
main = testGroup "Parser: Move Queries" [
        acceptEmptyString,
        simpleDotDoesntMove,
        rejectMovementWithoutDot,
        allowNestedKeys,
        allowSequencedKeys,
        rejectMovementWithoutDotSequenced
    ]

acceptEmptyString :: TestTree
acceptEmptyString = testCase "Accept Empty String" $ ("" :: Query)@?= Query (Right [])

simpleDotDoesntMove :: TestTree
simpleDotDoesntMove = testCase "Simple Dot Doesn't Move" $ ("." :: Query)@?= Query (Right [Move Nothing])

dotKeyMovesToKey :: TestTree
dotKeyMovesToKey = testCase "Dot Key Moves To Key" $ (".key" :: Query)@?= Query (Right [Move $ Just "key"])

rejectMovementWithoutDot :: TestTree
rejectMovementWithoutDot = testCase "Reject Movement Without Dot" $ isLeft (unQuery ("key" :: Query))@? "\"key\" was parsed to the right"

allowNestedKeys :: TestTree
allowNestedKeys = testCase "Allow Nested Keys" $ (".key1.key2" :: Query)@?= Query (Right [Move $ Just "key1", Move $ Just "key2"])

allowSequencedKeys :: TestTree
allowSequencedKeys = testCase "Allow Sequenced Keys" $ (".key1|.key2" :: Query)@?= Query (Right [Move $ Just "key1", Move $ Just "key2"])

rejectMovementWithoutDotSequenced :: TestTree
rejectMovementWithoutDotSequenced = testCase "Reject Movement Without Dot Sequenced" $ isLeft (unQuery (".key1|key2" :: Query))@? "\".key1|key2\" was parsed to the right"
