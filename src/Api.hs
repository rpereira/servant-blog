{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Api ( app ) where

import Control.Monad.Except
import Control.Monad.Reader       (ReaderT, runReaderT)
import Control.Monad.Reader.Class
import Network.Wai                (Application)
import Servant

import Config                     (App (..), Config (..))

import Api.Article
import Api.Comment
import Api.Favorite
import Api.Profile
import Api.Registration
import Api.Tag

type API = RegistrationAPI
      :<|> ProfileAPI
      :<|> ArticleAPI
      :<|> TagAPI
      :<|> CommentAPI
      :<|> FavoriteAPI

-- | Combinate all endpoints to be served.
server :: ServerT API App
server = registrationServer
    :<|> profileServer
    :<|> articleServer
    :<|> tagServer
    :<|> commentServer
    :<|> favoriteServer

appApi :: Proxy API
appApi = Proxy

-- | Converts 'App' monad into the @ExceptT ServantErr IO@ monad that Servant's
-- 'enter' function needs in order to run the application.  The ':~>' type is a
-- natural transformation, or, in non-category theory terms, a function that
-- converts two type constructors without looking at the values in the types.
convertApp :: Config -> App :~> ExceptT ServantErr IO
convertApp cfg = Nat (flip runReaderT cfg . runApp)

-- | Tell Servant how to run the 'App' monad with the 'server' function.
appToServer :: Config -> Server API
appToServer cfg = enter (convertApp cfg) server

app :: Config -> Application
app cfg = serve appApi (appToServer cfg)
