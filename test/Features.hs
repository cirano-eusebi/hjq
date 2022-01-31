module Features (features) where

import Test.Tasty ( TestTree )

import qualified Features.Feature0
import qualified Features.ParseMoveQueries
import qualified Features.ParseIndexQueries
import qualified Features.EvalMoveQueries

features :: [TestTree]
features = [
        Features.Feature0.main,
        Features.ParseMoveQueries.main,
        Features.ParseIndexQueries.main,
        Features.EvalMoveQueries.main
    ]
