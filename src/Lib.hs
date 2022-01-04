{-# LANGUAGE OverloadedStrings #-}

module Lib
    where

import Text.Parsec
import Text.Parsec.String (Parser)
import Data.Char
import Data.Maybe

someFunc :: IO ()
someFunc = print "start" >> print (r ".") <* print "end"

brackets :: Parser a -> Parser a
brackets = between (string "[") (string "]")
digits :: Parser Int
digits = read <$> many1 digit

extract :: Parser a -> Parser[a]
extract p = do (:) <$> try p <*> extract p
        <|> do string "|" >> extract p
        <|> do eof >> return []

r :: String -> Either ParseError [S]
r = parse (extract parseS) ""

data S = Move (Maybe String)
    | Index Int
    deriving (Show, Eq)

parseS :: Parser S
parseS = string "." >> (
        Index <$> try (brackets digits) <|>
        Move <$> try (optionMaybe (many1 alphaNum))
    )

-- example with multiple args
-- for imputs like "F0" "F1a","F2(b)", "F3-c"
-- parsed as Right F(0,Nothing), F(1, Just "a"), F(2, Just "b"), F(3, Just "c")
-- newtype F = F (Int, Maybe String) deriving Show

-- parseF :: Parser F
-- parseF = curry F <$> firstPart <*> secondPart
--     where
--         firstPart :: Parser Int
--         firstPart = string "." >> digits

--         secondPart :: Parser (Maybe String)
--         secondPart = optionMaybe $ choice
--             [ many1 letter
--             , brackets (many1 letter)
--             , string "-" >> many1 alphaNum
--             ]