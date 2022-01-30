{-# LANGUAGE OverloadedStrings #-}

module Features.ApplyMoveQueries ( main ) where

import Test.Tasty
import Test.Tasty.HUnit
import Types (Query(..), S(..))
import Extensions.StringQuery ()
import Data.Either (isLeft)

main :: TestTree
main = testGroup "Apply: Move Queries" []
