#set page(
    numbering: "1",
)

#counter(page).update(1)

#set par(first-line-indent: 2em)

#set enum(indent: 2em)
#set list(indent: 2em)
#set figure(gap: 0.8cm)

#import "@preview/indenta:0.0.3": fix-indent
#show: fix-indent()
