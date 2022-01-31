{-# LANGUAGE OverloadedStrings #-}
module Lib
    where

import Types (Query)
import Extensions.StringQuery ()

someFunc :: IO ()
someFunc = print ("." :: Query)
