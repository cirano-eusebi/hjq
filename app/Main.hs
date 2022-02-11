module Main where

import System.Environment ( getArgs )
import Data.Maybe ( isNothing )
import Data.Aeson ( decode, Value )
import Data.Aeson.Text ( encodeToLazyText )
import qualified Data.Text.Lazy as TL
import qualified Data.ByteString.Lazy.UTF8 as BLU
import Types ( Query(..) )
import Parser ( p )
import Eval ( eval, (>?), (<?) )
import GHC.IO.Handle (hFlush)
import GHC.IO.Handle.FD (stdout)
import Control.Monad (unless)

readQuery :: IO String
readQuery = putStr "hjq> "
     >> hFlush stdout
     >> getLine

repl :: (String -> String) -> IO ()
repl f = do
    input <- readQuery
    unless (input == ":q")
        $ putStrLn (f input) >> repl f

evalInput :: Maybe Value -> String -> String
evalInput j q = case p q of
    Query(Left e) -> show e
    Query(Right _) -> TL.unpack $ encodeToLazyText $ j <? p q

main :: IO ()
main = do
    args <- getArgs
    let json = (decode (BLU.fromString $ head args) :: Maybe Value)
    if isNothing json then putStrLn "Invalid Json, please review the input and try again." else repl (evalInput json)
