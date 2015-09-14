((haskell-mode
  . ((haskell-indent-spaces . 2)
     (hindent-style . "chris-done")
     (haskell-process-type . stack-ghci)
     (haskell-process-path-ghci . "stack")
     (haskell-process-args-stack-ghci . ("--ghc-options=-ferror-spans" "--with-ghc=ghci-ng"))))
 (haskell-cabal-mode
  . ((haskell-process-type . stack-ghci)
     (haskell-process-path-ghci . "stack")
     (haskell-process-args-ghci . ("ghci"))
     (haskell-process-args-stack-ghci . ("--ghc-options=-ferror-spans" "--with-ghc=ghci-ng")))))
