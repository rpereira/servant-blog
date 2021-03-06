{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE FlexibleInstances          #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}

module Models.Article where

import Data.Text            (Text)
import Data.Time            (UTCTime)
import Database.Persist.TH  (mkMigrate, mkPersist, persistLowerCase, share,
                             sqlSettings)

import Models.User
import Types                (Slug)

share [mkPersist sqlSettings, mkMigrate "migrateArticle"] [persistLowerCase|
Article json sql=articles
    slug        Slug
    title       Text
    description Text
    body        Text
    createdAt   UTCTime default=now()
    updatedAt   UTCTime Maybe default=NULL
    userId      UserId

    UniqueSlug slug
|]
