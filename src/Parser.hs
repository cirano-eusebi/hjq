module Parser (
    p
) where

import Parser.Operations
import Text.Parsec
import Text.Parsec.String (Parser(..))
import Types

parseS :: Parser S
parseS =
    Index <$> try (brackets digits) <|>
    (try $ string "." >> Move <$> try (optionMaybe (many1 alphaNum))) <|>
    Condition <$> try (parenthesis parseExpression)

parseExpression :: Parser BooleanExpr
parseExpression = try parseComplexExpression <|>
    try parseUniExpression <|>
    SimpleExpr <$> try (many1 alphaNum)

parseComplexExpression :: Parser BooleanExpr
parseComplexExpression = do
    first <- many1 alphaNum
    spaces
    second <- parseBiOp
    spaces
    third <- many1 alphaNum
    return $ ComplexExpr first second third

parseUniExpression :: Parser BooleanExpr
parseUniExpression = do
    first <- many1 alphaNum
    spaces
    second <- parseUniOp
    return $ UniExpr second first

parseBiOp :: Parser BiOperation
parseBiOp = (try $ string "eq" >> parserReturn Eq) <|>
    (try $ string "gt" >> parserReturn Gt) <|>
    (try $ string "lt" >> parserReturn Lt) <|>
    (try $ string "gte" >> parserReturn Gte) <|>
    (try $ string "lte" >> parserReturn Lte)

parseUniOp :: Parser UniOperation
parseUniOp = (try $ string "not" >> parserReturn Not) <|>
    (try $ string "empty" >> parserReturn Types.Empty) <|>
    (try $ string "notEmpty" >> parserReturn NotEmpty)

-- parseOperation :: Parser SimpleOperation
-- parseOperation = SimpleOperation 

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
