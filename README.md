# `here`
[![Build Status](https://travis-ci.org/yamadapc/here.svg?branch=master)](https://travis-ci.org/yamadapc/here)

`here` is a package that adds support for multi-line string literals (a.k.a. "here docs") and string interpolation to Haskell via GHC's `QuasiQuotes` extension.

It includes six quasiquoters:

- `here`: Strips leading and trailing whitespace. This allows you to add a line break after the opening quote bracket, which looks nicer.
- `hereLit`: Quotes the here doc literally, with no whitespace stripping
- `hereFile`: Quotes a file's contents as a here doc
- `i`: Like `hereLit`, but with the ability to interpolate the values of antiquoted Haskell expressions (bracketed by `${` and `}`)
- `iTrim`: Like `i`, but trimming leading and trailing whitespace as with `here`
- `template`: Applies string interpolation to a file, as a simple template engine

## Example

````haskell
{-# LANGUAGE QuasiQuotes #-}

import Data.Char
import Data.String.Here

main = do let foo = "foo"
          putStrLn [i|"foo", when capitalized, is ${map toUpper foo}!|]
          putStrLn [here|
Hello world,

I am a multiline here doc!
|]
````

### Output

    "foo", when capitalized, is FOO!
    Hello world,

    I am a multiline here doc!
