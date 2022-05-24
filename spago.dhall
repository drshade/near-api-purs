{ name = "near-api-purs"
, dependencies =
  [ "aff"
  , "affjax"
  , "affjax-node"
  , "argonaut-codecs"
  , "argonaut-core"
  , "argonaut-traversals"
  , "console"
  , "debug"
  , "effect"
  , "either"
  , "foldable-traversable"
  , "foreign-object"
  , "integers"
  , "lists"
  , "maybe"
  , "prelude"
  , "profunctor-lenses"
  , "record"
  , "transformers"
  , "tuples"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
