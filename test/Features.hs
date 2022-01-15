module Features (features) where

import Test.Tasty ( TestTree )

import qualified Features.Feature0
import qualified Features.ParseMoveQueries
import qualified Features.ParseIndexQueries

features :: [TestTree]
features = [
        Features.Feature0.main,
        Features.ParseMoveQueries.main,
        Features.ParseIndexQueries.main
    ]
