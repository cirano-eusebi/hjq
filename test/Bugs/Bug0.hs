module Bugs.Bug0 (main) where

import Test.Tasty
import Test.Tasty.HUnit

main :: TestTree
main = testGroup "Setup Bug Tests" [
        testCase "BaseBug" (assertBool "ErrorMessage" True)
    ]