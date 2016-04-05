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
