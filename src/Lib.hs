{-# LANGUAGE OverloadedStrings #-}
module Lib
    where

import Parser.Types (Query)
import Parser.Extensions.StringQuery ()

someFunc :: IO ()
someFunc = print ("." :: Query)
