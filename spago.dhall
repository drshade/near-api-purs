{ name = "near-api-purs"
, dependencies =
  [ "aff"
  , "affjax"
  , "affjax-node"
  , "argonaut-codecs"
  , "argonaut-core"
  , "bigints"
  , "console"
  , "debug"
  , "effect"
  , "either"
  , "foldable-traversable"
  , "foreign-object"
  , "integers"
  , "lists"
  , "maybe"
  , "numbers"
  , "prelude"
  , "record"
  , "transformers"
  , "tuples"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
