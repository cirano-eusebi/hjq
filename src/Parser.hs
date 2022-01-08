module Parser where

import Text.Parsec
import Text.Parsec.String (Parser)
import Parser.Types
import Parser.Operations

parseS :: Parser S
parseS = string "." >> (
        Index <$> try (brackets digits) <|>
        Move <$> try (optionMaybe (many1 alphaNum))
    )

r :: String -> Either ParseError [S]
r = parse (extract parseS "|") "" 
