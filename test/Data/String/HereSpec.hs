{-# LANGUAGE QuasiQuotes #-}
module Data.String.HereSpec where

import           Data.String.Here
import           Data.String.Here.Internal
import           Test.Hspec

spec :: Spec
spec = do
    describe "trim" $ do
        it "trims leading whitespace" $
            trim "    something" `shouldBe` "something"

        it "trims leading tabs" $
            trim "    \t  something" `shouldBe` "something"

        it "trims leading tabs [2]" $
            trim "\t    \t  something" `shouldBe` "something"

        it "trims leading newlines" $
            trim "\t \n\n   \t  something" `shouldBe` "something"

        it "trims trailing newlines" $
            trim "\t \n\n   \t  something \n\n" `shouldBe` "something"

        it "trims trailing whitespace" $
            trim "something   " `shouldBe` "something"

    describe "here" $ do
        it "allows raw string literals" $
            "something here" `shouldBe` [here|
something here
                                             |]

        it "trims leading/trailing whitespace" $
            "something here" `shouldBe` [here|


something here



                                             |]

        it "trims leading/trailing whitespace per lines" $
            "something here" `shouldBe` [here|


              something here



                                             |]

        it "doesn't require escape sequences" $
            init (unlines [ "something here\\n"
                          , ""
                          , "\\tthere"
                          ]) `shouldBe` [here|


something here\n

\tthere

                                             |]

        it "doesn't capture variables escape sequences" $ do
            let there = 10 :: Integer
            let x = "10" :: String
            let inp = [here|stuff here ${there} ${x}|]
            inp `shouldBe` "stuff here ${there} ${x}"

    describe "i" $ do
        it "allows interpolated values" $ do
            let there = 10 :: Integer
            let x = "10" :: String
            let inp = [i|stuff here ${there} ${x}|]
            inp `shouldBe` "stuff here 10 10"

        it "doesn't trim whitepace" $ do
            let there = 10 :: Integer
            let x = "10" :: String
            let inp = [i|


stuff here ${there} ${x}

|]
            inp `shouldNotBe` "stuff here 10 10"


        it "doesn't trim per-line whitepace" $ do
            let there = 10 :: Integer
            let x = "10" :: String
            let inp = [i|

    stuff here ${there} ${x}

|]
            lines inp `shouldNotContain` ["stuff here 10 10"]
            lines inp `shouldContain` ["    stuff here 10 10"]

    describe "iTrim" $ do
        it "allows interpolated values" $ do
            let there = 10 :: Integer
            let x = "10" :: String
            let inp = [iTrim|stuff here ${there} ${x}|]
            inp `shouldBe` "stuff here 10 10"

        it "doesn't trim whitepace" $ do
            let there = 10 :: Integer
            let x = "10" :: String
            let inp = [iTrim|


stuff here ${there} ${x}

|]
            inp `shouldBe` "stuff here 10 10"


        it "doesn't trim per-line whitepace" $ do
            let there = 10 :: Integer
            let x = "10" :: String
            let inp = [iTrim|

    stuff here ${there} ${x}

|]
            lines inp `shouldContain` ["stuff here 10 10"]
            lines inp `shouldNotContain` ["    stuff here 10 10"]
