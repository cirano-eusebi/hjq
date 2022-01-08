module Features.Feature0 ( main ) where

import Test.Tasty
import Test.Tasty.HUnit

main :: TestTree
main = testGroup "Setup Unit Tests" [
        testCase "BaseUnitTest" (assertBool "ErrorMessage" True)
    ]
