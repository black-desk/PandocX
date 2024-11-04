#set page(
    numbering: "1",
)

#counter(page).update(1)

#set par(first-line-indent: 2em)

#set enum(indent: 1em)
#set list(marker:([*•*], [‣], [–]), indent: 1em)
#show list: set par(first-line-indent: 0em)
#show quote: set pad(x: 3em)

#set figure(gap: 0.8cm)

#import "@preview/indenta:0.0.3": fix-indent
#show: fix-indent()
