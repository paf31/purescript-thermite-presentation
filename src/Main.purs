module Main (main) where

import Prelude

import Control.Monad.Eff (Eff)

import Data.Maybe (fromJust)
import Data.Nullable (toMaybe)
import DOM (DOM) as DOM
import DOM.HTML (window) as DOM
import DOM.HTML.Types (htmlDocumentToParentNode) as DOM
import DOM.HTML.Window (document) as DOM
import DOM.Node.ParentNode (querySelector) as DOM
import Partial.Unsafe (unsafePartial)
import React as R
import React.DOM as RD
import React.DOM.Props as RP
import ReactDOM as RDOM
import Thermite as T

data SlidesState
  = S0
  | S1
  | S2
  | S3
  | S4
  | S5
  | S6 Int
  | S7 Int
  | S8
  | S9 Int Int
  | S10
  | S11
  | S12
  | S13
  | S14
  | S15
  | S16
  | S17
  | S18
  | S19
  | S20

initialState :: SlidesState
initialState = S0

data SlidesAction
  = First
  | Back
  | Next
  | Last
  | Increment
  | Increment2

first :: SlidesState -> SlidesState
first _ = S0

next :: SlidesState -> SlidesState
next S0       = S1
next S1       = S2
next S2       = S3
next S3       = S4
next S4       = S5
next S5       = S6 0
next (S6 _)   = S7 0
next (S7 _)   = S8
next S8       = S9 0 0
next (S9 _ _) = S10
next S10      = S11
next S11      = S12
next S12      = S13
next S13      = S14
next S14      = S15
next S15      = S16
next S16      = S17
next S17      = S18
next S18      = S19
next S19      = S20
next S20      = S0

back :: SlidesState -> SlidesState
back S0       = S20
back S1       = S0
back S2       = S1
back S3       = S2
back S4       = S3
back S5       = S4
back (S6 _)   = S5
back (S7 _)   = S6 0
back S8       = S7 0
back (S9 _ _) = S8
back S10      = S9 0 0
back S11      = S10
back S12      = S11
back S13      = S12
back S14      = S13
back S15      = S14
back S16      = S15
back S17      = S16
back S18      = S17
back S19      = S18
back S20      = S19

last :: SlidesState -> SlidesState
last _ = S20

navbar :: forall props eff. T.Spec eff SlidesState props SlidesAction
navbar = T.simpleSpec performAction render where
  render :: T.Render SlidesState props SlidesAction
  render dispatch _ _ _ =
    [ RD.nav' [ RD.a [ RP.href "#"
                     , RP.onClick \_ -> dispatch First
                     ]
                     [ RD.text "⇦" ]
              , RD.a [ RP.href "#"
                     , RP.onClick \_ -> dispatch Back
                     ]
                     [ RD.text "←" ]
              , RD.a [ RP.href "#"
                     , RP.onClick \_ -> dispatch Next
                     ]
                     [ RD.text "→" ]
              , RD.a [ RP.href "#"
                     , RP.onClick \_ -> dispatch Last
                     ]
                     [ RD.text "⇨" ]
              ]
    ]

  performAction :: T.PerformAction eff SlidesState props SlidesAction
  performAction action _ _ = void $ T.cotransform (move action) where
    move First s = first s
    move Back  s = back s
    move Next  s = next s
    move Last  s = last s
    move Increment (S6 count) = S6 (count + 1)
    move Increment (S7 count) = S7 (count + 1)
    move Increment (S9 c1 c2) = S9 (c1 + 1) c2
    move Increment2 (S9 c1 c2) = S9 c1 (c2 + 1)
    move _ s = s

slidesComponent :: forall props eff. T.Spec eff SlidesState props SlidesAction
slidesComponent = T.simpleSpec T.defaultPerformAction render where
  render :: T.Render SlidesState props SlidesAction
  render dispatch _ slide _ =
    [ RD.div'
        case slide of
          S0  -> [ RD.h1' [ RD.text "Front End Development with PureScript and Thermite" ]
                 , RD.h2' [ RD.text "Phil Freeman" ]
                 ]
          S1  -> [ RD.h1' [ RD.text "Intro" ]
                 , RD.p'  [ RD.text "Thermite is" ]
                 , RD.ul' [ RD.li' [ RD.text "A React-based UI library for PureScript" ]
                          , RD.li' [ RD.text "\"Opinionated\"" ]
                          , RD.li' [ RD.text "Inspired by Elm, react-blaze and OpticUI" ]
                          , RD.li' [ RD.text "Stable (i.e. version 1.*)" ]
                          ]
                 ]
          S2  -> [ RD.h1' [ RD.text "Problems for UI Libraries" ]
                 , RD.p'  [ RD.text "UI libraries have to solve the following problems:" ]
                 , RD.ul' [ RD.li' [ RD.text "Multiple components" ]
                          , RD.li' [ RD.text "3rd party components" ]
                          , RD.li' [ RD.text "Async code (AJAX etc.)" ]
                          ]
                 , RD.p'  [ RD.text "Thermite uses PureScript's advanced type system features to solve these problems:" ]
                 , RD.ul' [ RD.li' [ RD.text "Lenses" ]
                          , RD.li' [ RD.text "Coroutines" ]
                          ]
                 ]
          S3  -> [ RD.h1' [ RD.text "Components" ]
                 , RD.p'  [ RD.text "Thermite components are defined by:" ]
                 , RD.ul' [ RD.li' [ RD.text "A state type σ" ]
                          , RD.li' [ RD.text "An action type δ" ]
                          , RD.li' [ RD.text "A function which renders the current state" ]
                          , RD.li' [ RD.text "A function which updates the current state based on an action" ]
                          ]
                 , RD.p'  [ RD.text "See also: The Elm Architecture (TEA)" ]
                 ]
          S4  -> [ RD.h1' [ RD.text "Component Types" ]
                 , RD.pre' [ RD.code' [ RD.text """newtype Spec eff σ δ = Spec
  { performAction ∷ PerformAction eff σ δ
  , render        ∷ Render σ δ
  }

type PerformAction eff σ δ
  = δ
  → σ
  → CoTransformer (Maybe σ) (σ → σ) (Aff eff) Unit

type Render σ δ
  = (δ → EventHandler)
  → σ
  → Array ReactElement
  → Array ReactElement""" ] ]
                 ]
          S5  -> [ RD.h1' [ RD.text "Simple Components" ]
                 , RD.pre' [ RD.code' [ RD.text """simpleSpec
  ∷ ∀ eff σ δ
  . PerformAction eff σ δ
  → Render σ δ
  → Spec eff σ δ""" ] ]
                 ]
          S6 count ->
                 [ RD.h1' [ RD.text "Counter Component" ]
                 , RD.pre' [ RD.code' [ RD.text """type CounterState = Int
data CounterAction = Increment

counter = T.simpleSpec performAction render where
  render dispatch _ count _ =
    [ button [ onClick \_ → dispatch Increment ]
             [ text (show count) ]
    ]

  performAction Increment _ _ = void $ T.cotransform (_ + 1)""" ] ]
                 , RD.p' [ RD.button [ RP.onClick \_ -> dispatch Increment ]
                                     [ RD.text (show count) ]
                         ]
                 ]
          S7 count ->
                 [ RD.h1' [ RD.text "Composing Components" ]
                 , RD.p'  [ RD.text "Components form a Monoid which gives us one type of composition:" ]
                 , RD.pre' [ RD.code' [ RD.text "twoCounters = counter <> counter" ] ]
                 , RD.p' [ RD.button [ RP.className "buttonLeft"
                                     , RP.onClick \_ -> dispatch Increment ]
                                     [ RD.text (show count) ]
                         , RD.button [ RP.className "buttonRight"
                                     , RP.onClick \_ -> dispatch Increment ]
                                     [ RD.text (show count) ]
                         , RD.div [ RP.className "clearBoth" ] []
                         ]
                 , RD.p' [ RD.text "... but perhaps not the one you were thinking of" ]
                 , RD.p' [ RD.text "We need a way to break up the state" ]
                 ]
          S8  -> [ RD.h1'  [ RD.text "Focusing" ]
                 , RD.p'   [ RD.text "The state type for two independent counters is" ]
                 , RD.pre' [ RD.code' [ RD.text "Tuple CounterState CounterState" ] ]
                 , RD.p'   [ RD.text "And the action type is" ]
                 , RD.pre' [ RD.code' [ RD.text "Either CounterAction CounterAction" ] ]
                 , RD.p'   [ RD.text "We could write explicit functions to direct the actions to the right part of the state" ]
                 ]
          S9 c1 c2 ->
                 [ RD.h1'  [ RD.text "Focusing" ]
                 , RD.p'   [ RD.text "Instead, we use a Lens to focus on a smaller part of the state, and a Prism to match a subset of the actions." ]
                 , RD.pre' [ RD.code' [ RD.text """focus
  ∷ ∀ eff σ₁ σ₂ δ₁ δ₂
  . LensP σ₂ σ₁
  → PrismP δ₂ δ₁
  → Spec eff σ₁ δ₁
  → Spec eff σ₂ δ₂""" ] ]
                 , RD.p'   [ RD.text "Our component becomes:" ]
                 , RD.pre' [ RD.code' [ RD.text "focus _1 _Left counter <> focus _2 _Right counter" ] ]
                 , RD.p' [ RD.button [ RP.className "buttonLeft"
                                     , RP.onClick \_ -> dispatch Increment ]
                                     [ RD.text (show c1) ]
                         , RD.button [ RP.className "buttonRight"
                                     , RP.onClick \_ -> dispatch Increment2 ]
                                     [ RD.text (show c2) ]
                         , RD.div [ RP.className "clearBoth" ] []
                         ]
                 ]
          S10 -> [ RD.h1'  [ RD.text "Tab Components" ]
                 , RD.p'   [ RD.text "Lenses let us identify smaller parts of a product of types, which is a good model for independent components." ]
                 , RD.p'   [ RD.text "Prisms let us identify smaller parts of a sum of types, which is a good model for tabbed applications:" ]
                 , RD.pre' [ RD.code' [ RD.text """split
  ∷ ∀ eff σ₁ σ₂ δ
  . PrismP σ₁ σ₂
  → Spec eff σ₂ δ
  → Spec eff σ₁ δ""" ] ]
                 , RD.p'   [ RD.text "Note that" ]
                 , RD.ul' [ RD.li' [ RD.text "The action type δ does not change here" ]
                          , RD.li' [ RD.text "No information is shared between tabs" ]
                          ]
                 ]
          S11 -> [ RD.h1'  [ RD.text "List Components" ]
                 , RD.p'   [ RD.text "The last type of composition lets us define lists of subcomponents:" ]
                 , RD.pre' [ RD.code' [ RD.text """foreach
  ∷ ∀ eff σ δ
  . (Int -> Spec eff σ δ)
  → Spec eff (List σ) (Tuple Int δ)""" ] ]
                 , RD.p'   [ RD.text "In OpticUI, this is generalized to a Traversal." ]
                 , RD.p'   [ RD.text "Note that" ]
                 , RD.ul'  [ RD.li' [ RD.text "We have a whole list of states, one for each list element" ]
                           , RD.li' [ RD.text "The action type now includes the index of the component to update" ]
                           ]
                 ]
          S12 -> [ RD.h1' [ RD.text "Summary" ]
                 , RD.table' [ RD.thead' [ RD.th' [ RD.text "Component" ]
                                         , RD.th' [ RD.text "Function" ]
                                         , RD.th' [ RD.text "Optic" ]
                                         ]
                             , RD.tbody' [ RD.tr' [ RD.td' [ RD.text "Pair (same state)" ]
                                                  , RD.td' [ RD.pre' [ RD.code' [ RD.text "(<>)" ] ] ]
                                                  , RD.td' [ RD.text "" ]
                                                  ]
                                         , RD.tr' [ RD.td' [ RD.text "Pair (independent)" ]
                                                  , RD.td' [ RD.pre' [ RD.code' [ RD.text "focus" ] ] ]
                                                  , RD.td' [ RD.text "Lens" ]
                                                  ]
                                         , RD.tr' [ RD.td' [ RD.text "Tabs" ]
                                                  , RD.td' [ RD.pre' [ RD.code' [ RD.text "split" ] ] ]
                                                  , RD.td' [ RD.text "Prism" ]
                                                  ]
                                         , RD.tr' [ RD.td' [ RD.text "Lists" ]
                                                  , RD.td' [ RD.pre' [ RD.code' [ RD.text "foreach" ] ] ]
                                                  , RD.td' [ RD.text "Traversal" ]
                                                  ]
                                         ]
                             ]
                 ]
          S13 -> [ RD.h1' [ RD.text "Task List Example" ]
                 , RD.p'  [ RD.text "Putting it all together" ]
                 , RD.p'  [ RD.a [ RP.href "http://functorial.com/purescript-thermite-todomvc/"
                                 , RP.target "_blank"
                                 ]
                                 [ RD.text "Demo" ]
                          ]
                 , RD.p'  [ RD.a [ RP.href "https://github.com/paf31/purescript-thermite/blob/master/test"
                                 , RP.target "_blank"
                                 ]
                                 [ RD.text "Code" ]
                          ]
                 ]
          S14 -> [ RD.h1' [ RD.text "Async" ]
                 , RD.p'  [ RD.text "Or \"What's this cotransform thing about?\"" ]
                 ]
          S15 -> [ RD.h1' [ RD.text "Coroutines" ]
                 , RD.p'  [ RD.text "The purescript-coroutines library defines the Coroutine abstraction, which generalizes" ]
                 , RD.ul'  [ RD.li' [ RD.text "Data producers" ]
                           , RD.li' [ RD.text "Data consumers" ]
                           , RD.li' [ RD.text "Data transformers" ]
                           ]
                 , RD.p'  [ RD.text "over some base monad (usually Aff)" ]
                 , RD.p'  [ RD.text "This is a good model for various asynchronous processes:" ]
                 , RD.ul'  [ RD.li' [ RD.text "AJAX" ]
                           , RD.li' [ RD.text "Websockets" ]
                           , RD.li' [ RD.text "Node streams" ]
                           ]
                 ]
          S16 -> [ RD.h1' [ RD.text "Producers and Consumers" ]
                 , RD.p'  [ RD.text "Coroutines are free monad transformers" ]
                 , RD.pre' [ RD.code' [ RD.text """type Co f m = FreeT f m

data Emit o a = Emit o a
type Producer o = Co (Emit o)

newtype Await i a = Await (i -> a)
type Consumer i = Co (Await i)""" ] ]
                 ]
          S17 -> [ RD.h1' [ RD.text "Transformers" ]
                 , RD.p'  [ RD.text "Transformers take one input and return one output" ]
                 , RD.pre' [ RD.code' [ RD.text """newtype Transform i o a = Transform (i -> Tuple o a)
type Transformer i o = Co (Transform i o)

data CoTransform i o a = CoTransform o (i -> a)
type CoTransformer i o = Co (CoTransform i o)

cotransform
  ∷ ∀ m i o
  . Monad m
  ⇒ o
  → CoTransformer i o m i""" ] ]
                 ]
          S18 -> [ RD.h1'  [ RD.text "React as a Transformer" ]
                 , RD.p'   [ RD.text "React yields the current state and waits for state update (asynchronously!)" ]
                 , RD.pre' [ RD.code' [ RD.text "react :: CoTransformer (σ -> σ) (Maybe σ) (Aff eff) Unit" ] ]
                 , RD.p'   [ RD.text "We can fuse this with our update coroutine:" ]
                 , RD.pre' [ RD.code' [ RD.text "CoTransformer (Maybe σ) (σ → σ) (Aff eff) Unit" ] ]
                 ]
          S19 -> [ RD.h1' [ RD.text "Try Thermite" ]
                 , RD.p'  [ RD.text "Try Thermite in the browser and see results immediately:" ]
                 , RD.p'  [ RD.a [ RP.href "http://paf31.github.io/try-thermite/"
                                 , RP.target "_blank"
                                 ]
                                 [ RD.text "Try it now" ]
                          ]
                 ]
          S20 -> [ RD.h1' [ RD.text "Questions?" ] ]
    ]

main :: Eff (dom :: DOM.DOM) Unit
main = void do
  let component = T.createClass (navbar <> slidesComponent) initialState
  document <- DOM.window >>= DOM.document
  container <- unsafePartial (fromJust <<< toMaybe <$> DOM.querySelector "#container" (DOM.htmlDocumentToParentNode document))
  RDOM.render (R.createFactory component {}) container
