### Emacs: -*- coding: utf-8; fill-column: 62; comment-column: 27; -*-
##
## Copyright (C) 2017 Vincent Goulet
##
## Ce fichier fait partie du projet «Passerelle d'introduction
## à la programmation en R»
## http://github.com/vigou3/act-passerelle-introduction-r
##
## Cette création est mise à disposition selon le contrat
## Attribution-Partage dans les mêmes conditions 4.0
## International de Creative Commons.
## http://creativecommons.org/licenses/by-sa/4.0/


## Ce fichier contient les solutions des exercices que l'on retrouve
## dans les diapositives de la formation.

## Exercice 1
x <- c(2, NA, 5, 3, NA, 7)
x[!is.na(x)]

## Exercice 2
product <- function(x, y)
    exp(log(x) + log(y))

## Exercice 3
x <- array(sample(1:100, 24, replace = TRUE), c(3, 2, 4))
w <- array(sample(1:10, 24, replace = TRUE), c(3, 2, 4))
apply(x * w, 2, sum)/apply(w, 2, sum)

## Exercice 4
unlist(lapply(0:10, seq, from = 0))

## Exercice 5
n <- 1:10
i <- seq(0.05, 0.1, by = 0.01)
(1 - outer((1 + i), -n, "^"))/i

## Exercice 6
(P <- rep(1:4, 1:4))
(i <- rep(c(0.05, 0.08), 5))
sum(P / cumprod(1 + i))
