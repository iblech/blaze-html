module Html.Strict where

import Prelude (String, (.), ($))
import Data.Monoid (mappend, mconcat)

import Data.Text (Text)

import Internal.EncodedHtml
import Internal.Escaping
import Internal.UnicodeSequence

htmlContent :: Encoded s => Unescaped s -> s
htmlContent = replaceUnencodable htmlCharReference . escapeHtmlContent

string :: Encoded s => String -> s
string = htmlContent . unicodeString

text :: Encoded s => Text -> s
text = htmlContent . unicodeText

head :: Html h => h -> h
head inner = nodeElement (unicodeString "head") (encodingTag `mappend` inner)

body :: Html h => h -> h
body = nodeElement (unicodeString "body")

-- | c.f. HTML 4.01 Standard, Section 6.2
script :: Html h => h -> h
script = 
    nodeElement (unicodeString "script") . replaceUnencodable jsCharReference

-- | c.f. HTML 4.01 Standard, Section 6.2
style :: Html h => h -> h
style = 
    nodeElement (unicodeString "style") . replaceUnencodable cssCharReference

jsString :: (Encoded s) => Unescaped s -> s
jsString s = mconcat 
    [ unicodeChar '\''
    , replaceUnencodable jsCharReference $ escapeSingleQuotedJSString s
    , unicodeChar '\'' ]

-- | The html combinator for HTML 4.01 strict. 
--
-- This conforms to the first milestone of BlazeHtml to achieve a complete set
-- of combinators for creating encoding independent HTML 4.01 strict documents
-- with the guarantee that all created documents are well-formed and parsed
-- back into "the same" structure by a HTML 4.01 strict capable user agent.
html :: Html h => h -> h
html = unicodeString "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"\
                     \ \"http://www.w3.org/TR/html4/strict.dtd\">\n"
       `mappend` nodeElement (unicodeString "html")

table :: Html h => h -> h
table = nodeElement (unicodeString "table")

tr :: Html h => h -> h
tr = nodeElement (unicodeString "table")

td :: Html h => h -> h
td = nodeElement (unicodeString "table")

urlFragment :: UnicodeSequence s => Unescaped s -> s
urlFragment = escapeURL

cssFragment :: UnicodeSequence s => Unescaped s -> s
cssFragment = escapeCSS