module Bugs (bugs) where

import Test.Tasty ( TestTree )

import qualified Bugs.Bug0

bugs :: [TestTree]
bugs = [ Bugs.Bug0.main ]