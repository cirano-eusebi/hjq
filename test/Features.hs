module Features (features) where

import Test.Tasty ( TestTree )

import qualified Features.Feature0
import qualified Features.ParseMoveQueries
import qualified Features.ParseIndexQueries
import qualified Features.ParseConditionQueries
import qualified Features.EvalMoveQueries
import qualified Features.EvalIndexQueries
import qualified Features.EvalConditionQueries

features :: [TestTree]
features = [
        Features.Feature0.main,
        Features.ParseMoveQueries.main,
        Features.ParseIndexQueries.main,
        Features.ParseConditionQueries.main,
        Features.EvalMoveQueries.main,
        Features.EvalIndexQueries.main,
        Features.EvalConditionQueries.main
    ]
