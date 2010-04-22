{-# LANGUAGE OverloadedStrings #-}
module Text.Blaze.Html.Strict.Attributes
    ( id
    ) where

import Prelude hiding (id)

import Data.Text (Text)

import Text.Blaze

id :: Text -> Attribute
id = attribute "id"
