module Parser (
    p
) where

import Text.Parsec
import Text.Parsec.String (Parser)
import Parser.Operations
import Types

parseS :: Parser S
parseS = string "." >> (
        Index <$> try (brackets digits) <|>
        Move <$> try (optionMaybe (many1 alphaNum))
    )

p :: String -> Query
p = Query . parse (extract parseS "|") "Query Parser"

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
