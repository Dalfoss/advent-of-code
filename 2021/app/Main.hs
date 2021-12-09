module Main where

main :: IO ()
main = do
  d1_0 <- readFile "./inputs/input-1_0"
  d2_0 <- readFile "./inputs/input-2_0"
  let puzzle1Input = map read $ lines d1_0
  let puzzle2Input = lines d2_0
  putStrLn $ "Day 1, part 1: " <> (show $ puzzle1_0 puzzle1Input)
  putStrLn $ "Day 1, part 2: " <> (show $ puzzle1_1 puzzle1Input)
  putStrLn $ "Day 2, part 1: " <> (show $ puzzle2_0 puzzle2Input)
  putStrLn $ "Day 2, part 2: " <> (show $ puzzle2_1 puzzle2Input)

---- Day 1 ---------------------------------------------------------------------
puzzle1_0 :: [Int] -> Int
puzzle1_0 xs = go (head xs) (tail xs) 0 where
  go element list counter = case list of
    [] -> counter
    (x:xs) -> if x > element
                then go x xs (counter+1)
              else go x xs counter

puzzle1_0_1 :: [Int] -> Int
puzzle1_0_1 xs = length . filter (\bool -> bool == True) $ zipWith (<) (xs) (tail xs)

movingSum :: Int -> [Int] -> [Int]
movingSum window lst = reverse $ drop (window - 1) $ go window lst [] where
  go w l res = case l of
    [] -> res
    (_:_) -> go w (tail l) $ (sum . take w $ l) : res

puzzle1_1 :: [Int] -> Int
puzzle1_1 lst = (puzzle1_0 . movingSum 3) lst
--------------------------------------------------------------------------------

---- Day 2 ---------------------------------------------------------------------
data Direction = Up
  | Down
  | Forward
  deriving Show

data Position = Position {
    x :: Int
  , y :: Int
  , aim :: Int
} deriving Show

parseCommand :: String -> (Direction, Int)
parseCommand command =
  case words command of
    ["up", mag]->  (Up, read mag)
    ["down", mag] ->  (Down, read mag)
    ["forward", mag] -> (Forward, read mag)

move0 :: Position -> String -> Position
move0 pos command =
  case parseCommand command of
    (Up, mag) -> pos{y=(y pos) - mag}
    (Down, mag) -> pos{y=(y pos) + mag}
    (Forward, mag) -> pos{x=(x pos) + mag}

move1 :: Position -> String -> Position
move1 pos command =
  case parseCommand command of
    (Up, mag) -> pos{aim=(aim pos) - mag}
    (Down, mag) -> pos{aim=(aim pos) + mag}
    (Forward, mag) -> pos{x=(x pos + mag), y=(y pos) + (aim pos * mag)}

puzzle2 :: (Position -> String -> Position) -> [String] -> Int
puzzle2 foldFunc commands = x endPos * y endPos where
  endPos = foldl foldFunc Position{x=0, y=0, aim=0} commands

puzzle2_0 :: [String] -> Int
puzzle2_0 = puzzle2 move0

puzzle2_1 :: [String] -> Int
puzzle2_1 = puzzle2 move1

-------------------------------------------------------------------------------
