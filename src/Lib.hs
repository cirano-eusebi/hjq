{-# LANGUAGE OverloadedStrings #-}
module Lib
    where

import Types (Query, ExprQuery)
import Extensions.StringQuery ()

someFunc :: IO ()
someFunc = print ("." :: Query)
