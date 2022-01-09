module Features (features) where

import Test.Tasty ( TestTree )

import qualified Features.Feature0
import qualified Features.Feature1

features :: [TestTree]
features = [ Features.Feature0.main, Features.Feature1.main ]