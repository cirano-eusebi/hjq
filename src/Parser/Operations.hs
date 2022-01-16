module Parser.Operations where

import Text.Parsec
import Text.Parsec.String (Parser)

brackets :: Parser a -> Parser a
brackets = between (string "[") (string "]")

parenthesis :: Parser a -> Parser a
parenthesis = between (string "(") (string ")")

digits :: Parser Int
digits = read <$> many1 digit

extract :: Parser a -> String -> Parser[a]
extract p sequenceDelim = (:) <$> try p <*> extract p sequenceDelim
        <|> do string sequenceDelim >> extract p sequenceDelim
        <|> do eof >> return []
