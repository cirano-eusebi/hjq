module Parser.Operations where

import Text.Parsec
import Text.Parsec.String (Parser)

brackets :: Parser a -> Parser a
brackets = between (string "[") (string "]")
digits :: Parser Int
digits = read <$> many1 digit

extract :: Parser a -> String -> Parser[a]
extract p sequenceDelim = do (:) <$> try p <*> extract p sequenceDelim
        <|> do string sequenceDelim >> extract p sequenceDelim
        <|> do eof >> return []

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