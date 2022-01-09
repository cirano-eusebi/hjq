module Parser (
    r
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

r :: String -> Query
r = Query . parse (extract parseS "|") "Query Parser"