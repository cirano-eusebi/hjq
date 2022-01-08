module Features (features) where

import Test.Tasty ( TestTree )

import qualified Features.Feature0

features :: [TestTree]
features = [ Features.Feature0.main ]