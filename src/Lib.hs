{-# LANGUAGE OverloadedStrings #-}

module Lib
    where

import Parser ( r )

someFunc :: IO ()
someFunc = print "start" >> print (r ".") <* print "end"
