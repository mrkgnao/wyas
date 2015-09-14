import Text.ParserCombinators.Parsec hiding (spaces)
import System.Environment
import Control.Monad

-- Datatypes

data Val
  = Atom String
  | List [Val]
  | DList [Val]
          Val
  | Number Integer
  | String String
  | Bool Bool
  deriving (Show,Eq)


-- Parsing

symbol :: Parser Char
symbol = oneOf "!#$%&|+-*/:<=>?@^_~"

spaces :: Parser ()
spaces =
  skipMany1 space

parseString :: Parser Val
parseString =
  do char '"'
     x <- many (noneOf "\"")
     char '"'
     return $ String x

parseAtom :: Parser Val
parseAtom =
  do first <- letter <|> symbol
     rest <- many (letter <|> digit <|> symbol)
     let atom = first : rest
     return $
       case atom of
         "#t" -> Bool True
         "#f" -> Bool False
         _ -> Atom atom

parseNumber :: Parser Val
parseNumber = liftM (Number . read) $ many1 digit

parseExpr :: Parser Val
parseExpr =
  parseAtom <|> parseString <|> parseNumber <|> parseQuoted <|>
  do char '('
     x <- (try parseList <|> parseDList)
     char ')'
     return x

parseList :: Parser Val
parseList = liftM List $ sepBy parseExpr spaces

parseDList :: Parser Val
parseDList = do
  head <- endBy parseExpr spaces
  tail <- char '.' >> spaces >> parseExpr
  return $ DList head tail

parseQuoted :: Parser Val
parseQuoted = do
  char '\''
  x <- parseExpr
  return $ List [Atom "quote", x]

-- Interface

readExpr :: String -> String
readExpr input =
  case parse parseExpr "Stutter parser" input of
    Left err -> "No match: " ++ show err
    Right val -> "Found value: "

main :: IO ()
main = getArgs >>= putStrLn . readExpr . head
