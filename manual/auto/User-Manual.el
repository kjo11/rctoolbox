(TeX-add-style-hook
 "User-Manual"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("mcode" "autolinebreaks" "useliterate")))
   (TeX-run-style-hooks
    "graphicx"
    "amsmath"
    "amsfonts"
    "amssymb"
    "color"
    "psfrag"
    "mcode"
    "multirow")
   (LaTeX-add-labels
    "linparcon"
    "fig:GPhC"
    "eq:opGPhC"
    "eq:quadratic criterion"
    "eq:Kuwh"
    "fig:LS"
    "eq:opLS"
    "fig:Hinf"
    "eq:rbstper"
    "eq:nomper"
    "eq:rbststab"
    "eq:W3W4"
    "gamma_optim"
    "eq:L-LD"
    "eq:Gersh"
    "eq:GS"
    "eq:GSPID")
   (LaTeX-add-bibliographies
    "/Users/akarimi/Documents/Karimi/papers/bibfiles/linear")))

