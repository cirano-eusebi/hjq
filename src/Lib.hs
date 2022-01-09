{-# LANGUAGE OverloadedStrings #-}
module Lib
    where

import Types (Query)
import Parser.Extensions.StringQuery ()

someFunc :: IO ()
someFunc = print ("." :: Query)
