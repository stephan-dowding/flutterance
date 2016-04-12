# Flutterance

[![Build Status](https://snap-ci.com/stephan-dowding/flutterance/branch/master/build_image)](https://snap-ci.com/stephan-dowding/flutterance/branch/master)

A syntax to make [Alexa](https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit) utterances less painful to define.

## Getting started
```
npm install -g flutterance
```

## convert a file
```
flutterance input.txt output.txt
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
