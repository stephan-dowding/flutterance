# Flutterance

[![Build Status](https://snap-ci.com/stephan-dowding/flutterance/branch/master/build_image)](https://snap-ci.com/stephan-dowding/flutterance/branch/master)

A syntax to make [Alexa](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit) utterances less painful to define.

## Getting started
```
npm install -g flutterance
```

## convert a file
```
const flutterance = require("flutterance");

flutterance.processPhrases(input.txt, output.txt);
```

## syntax

Use `[aaa|bbb]` to indicate choices of either or.
```
[aaa|bbb]
```
Will be expanded to
```
aaa
bbb
```

These can be nested, thus:
```
[Hello|Hi|Good [Morning|Afternoon|Evening]] Alexa
```
Will get expanded to:
```
Hello Alexa
Hi Alexa
Good Morning Alexa
Good Afternoon Alexa
Good Evening Alexa
```

It is also possible to make the words optional by suffixing with a `?`
```
[Wow]? This is [really|very]? good
```
Will get expanded to:
```
This is good
This is really good
This is very good
Wow This is good
Wow This is really good
Wow This is very good
```

To inlcude combinations of many words, use `+` or `*`.  These work regex style where they will give you one-or-more or zero-or-more words from the list. It will not, however, add any spaces or allow the words to appear out of order.
```
Hello[ John| Edward| Smith]+
My[ big| yellow| metal]* box
```
Will expand to:
```
Hello John
Hello Edward
Hello Smith
Hello Edward Smith
Hello John Edward
Hello John Smith
Hello John Edward Smith
My box
My big box
My yellow box
My metal box
My yellow metal box
My big yellow box
My big metal box
My big yellow metal box
```

If the words can be applied in any order, you can use the `~` operator in combination with `*` or `+` and flutterance will produce all sentences with any order of the options. (Technically you could combine `~` with `?` or just on it's own, but it won't make much difference!!)
```
My[ big| yellow| metal]~* box
```
Will expand to:
```
My box
My big box
My yellow box
My metal box
My big yellow box
My big metal box
My yellow big box
My yellow metal box
My metal big box
My metal yellow box
My big yellow metal box
My big metal yellow box
My yellow big metal box
My yellow metal big box
My metal big yellow box
My metal yellow big box
```

If you need the words to expand from the left or right, you can use the `>` and `<` in combination with `*` or `+` to accomplish this.
```
I have a [really |very |nice]<* house
I want [some| hot |pepperoni]>* pizzas
```
expands to:
```
I have a house
I have a nice house
I have a very nice house
I have a really very nice house
I want pizzas
I want some pizzas
I want some hot pizzas
I want some hot pepperoni pizzas
```

If you need more control over how many elements get chosen you can use the `(n)` or `(n,m)` syntax in place of `*`, `+` or `?`.
Here `n` and `m` are integers or you can use `*` to represent the max length.
`(n)` will give expansions of exactly `n` options.
`(n,m)` will give expansions of between `n` and `m` options (inclusive).
Naturally these can be combined with `~`, `<` or `>` if desired.
```
... [red |green |blue ](2) ...
```
expands to:
```
... green blue ...
... red green ...
... red blue ...
```
and
```
... [one |two |three |four ](2,*) ...
```
expands to:
```
... three four ...
... two three ...
... two four ...
... one two ...
... one three ...
... one four ...
... two three four ...
... one three four ...
... one two three ...
... one two four ...
... one two three four ...
```
