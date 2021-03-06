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

###
### DONNÉES ET OPÉRATEURS DE BASE
###

## Nombres. Tous les nombres réels sont stockés en double
## précision dans R, entiers comme nombres fractionnaires.
486                        # nombre réel entier
0.3324                     # nombre réel fractionnaire
2e-3                       # notation scientifique
1 + 2i                     # nombre complexe

## Tout objet en R comporte au minimum un mode et une
## longueur.
mode(486)                  # pas de distinction entre entier...
mode(0.3324)               # nombre réel
length(486)                # vecteur de longueur 1
mode(1 + 2i)               # nombre complexe

## Valeurs booléennes. 'TRUE' et 'FALSE' sont des noms
## réservés pour identifier les valeurs booléennes
## correspondantes.
TRUE                       # vrai
FALSE                      # faux
mode(TRUE)                 # mode "logical"
! FALSE                    # négation logique
TRUE & FALSE               # ET logique
TRUE | FALSE               # OU logique

## Il est possible d'effecteur des opérations arithmétiques
## avec les valeurs booléennes. 'TRUE' vaut alors 1 et
## 'FALSE', 0.
2 + TRUE                   # == 2 + 1
3 + FALSE                  # == 3 + 0
sum(c(TRUE, TRUE, FALSE))  # nombre de 'TRUE' dans le vecteur

## Donnée manquante. 'NA' est un nom réservé pour représenter
## une donnée manquante.
c(65, NA, 72, 88)          # traité comme une valeur
NA + 2                     # tout calcul avec 'NA' donne NA
is.na(c(65, NA))           # tester si les données sont 'NA'

## Valeurs infinies et indéterminée. 'Inf', '-Inf' et 'NaN'
## sont des noms réservés.
1/0                        # +infini
-1/0                       # -infini
0/0                        # indétermination
x <- c(65, Inf, NaN, 88)   # s'utilisent comme des valeurs
is.finite(x)               # quels sont les nombres réels?
is.nan(x)                  # lesquels sont indéterminés?

## Valeur "néant". 'NULL' est un nom réservé pour représenter
## le "néant", "rien".
mode(NULL)                 # le mode de 'NULL' est NULL
length(NULL)               # longueur nulle
c(NULL, NULL)              # du néant ne résulte que le néant

## Chaines de caractères. On crée une chaine de caractère en
## l'entourant de guillemets doubles " ".
"foobar"                   # *une* chaine de 6 caractères
length("foobar")           # longueur de 1
c("foo", "bar")            # *deux* chaines de 3 caractères
length(c("foo", "bar"))    # longueur de 2

## On crée des nouveaux objets en leur affectant une valeur
## avec l'opérateur '<-'. *Ne pas* utiliser '=' pour
## l'affectation.
x <- 5                     # affecter 5 à l'objet 'x'
x                          # voir le contenu
(x <- 5)                   # affecter et afficher
y <- x                     # affecter la valeur de 'x' à 'y'
x <- y <- 5                # idem, en une seule expression
y                          # 5
x <- 0                     # changer la valeur de 'x'...
y                          # ... ne change pas celle de 'y'

###
### VECTEURS
###

## La fonction de base pour créer des vecteurs est 'c'. Il
## peut s'avérer utile de nommer les éléments d'un vecteur.
x <- c(a = -1, b = 2, c = 8, d = 10) # création d'un vecteur
names(x)                             # extraire les noms
names(x) <- letters[1:length(x)]     # changer les noms

## Les fonctions 'numeric', 'logical', 'complex' et
## 'character' servent à créer des vecteurs initialisés avec
## des valeurs par défaut.
numeric(5)                 # vecteur initialisé avec des 0
logical(5)                 # initialisé avec FALSE
complex(5)                 # initialisé avec 0 + 0i
character(5)               # initialisé avec chaines vides

## L'indiçage sert principalement à deux choses: extraire des
## éléments d'un vecteur avec la construction 'x[i]' ou les
## remplacer avec la construction 'x[i] <- y'.
##
## Il existe cinq façons d'indicer un vecteur dans R.
##
## 1. avec des entiers positifs (extraction par position);
## 2. avec des entiers négatifs (suppression par position);
## 3. avec un vecteur booléen (extraction par critère);
## 4. avec des chaines de caractères (extraction par nom);
## 5. avec un vecteur vide (extraction de tous les éléments).
## 5. avec un vecteur vide (extraction de tous les éléments).
x[1]                       # extraction par position
x[-2]                      # élimination d'un élément
x[x > 5]                   # extraction par vecteur booléen
x["c"]                     # extraction par nom
x[]                        # tous les éléments (peu utile ici)

## L'unité de base de l'arithmétique en R est le vecteur. Cela
## rend très simple et intuitif de faire des opérations
## mathématiques courantes. Là où plusieurs langages de
## programmation exigent des boucles, R fait le calcul
## directement. En effet, les règles de l'arithmétique en R
## sont globalement les mêmes qu'en algèbre vectorielle et
## matricielle.
5 * c(2, 3, 8, 10)         # multiplication par une constante
c(2, 6, 8) + c(1, 4, 9)    # addition de deux vecteurs
c(0, 3, -1, 4)^2           # élévation à une puissance

## Dans les règles de l'arithmétique vectorielle, les
## longueurs des vecteurs doivent toujours concorder.
##
## R permet plus de flexibilité en recyclant les vecteurs les
## plus courts dans une opération.
##
## Il n'y a donc à peu près jamais d'erreurs de longueur en R!
## C'est une arme à deux tranchants: le recyclage des vecteurs
## facilite le codage, mais peut aussi résulter en des
## réponses complètement erronées sans que le système ne
## détecte d'erreur.
8 + 1:10                   # 8 est recyclé 10 fois
c(2, 5) * 1:10             # c(2, 5) est recyclé 5 fois
c(-2, 3, -1, 4)^(1:4)      # quatre puissances différentes

###
### FONCTIONS
###

## Les fonctions sont des objets comme les autres.
##
## - le contenu d'une fonction (son code source) est toujours
##   accessible;
## - une fonction peut accepter en argument une autre
##   fonction;
## - une fonction peut retourner une fonction comme résultat;
## - l'utilisateur peut définir de nouvelles fonctions.
seq                        # contenu est le code source
mode(seq)                  # mode est "function"
rep(seq(5), 3)             # fonction argument d'une fonction
lapply(1:5, seq)           # idem
mode(ecdf(rpois(100, 1)))  # résultat est une fonction
ecdf(rpois(100, 1))(5)     # évaluation en un point
c(seq, rep)                # vecteur de fonctions!

### Règles d'appel d'une fonction

## L'interprète R reconnait un appel de fonction au fait que
## le nom de l'objet est suivi de parenthèses ( ).
##
## Une fonction peut n'avoir aucun argument ou plusieurs. Il
## n'y a pas de limite pratique au nombre d'arguments.
##
## Les arguments d'une fonction peuvent être spécifiés selon
## l'ordre établi dans la définition de la fonction.
##
## Cependant, il est beaucoup plus prudent et *fortement
## recommandé* de spécifier les arguments par leur nom avec
## une construction de la forme 'nom = valeur', surtout après
## les deux ou trois premiers arguments.
##
## L'ordre des arguments est important; il est donc nécessaire
## de les nommer s'ils ne sont pas appelés dans l'ordre.
##
## Certains arguments ont une valeur par défaut qui sera
## utilisée si l'argument n'est pas spécifié dans l'appel de
## la fonction.
##
## Examinons les arguments de la fonction 'matrix', qui sert à
## créer une matrice à partir d'un vecteur de valeurs.
args(matrix)

## La fonction compte cinq arguments et chacun a une valeur
## par défaut (ce n'est pas toujours le cas). Quel sera le
## résultat de l'appel ci-dessous?
matrix()

## Les invocations de la fonction 'matrix' ci-dessous sont
## toutes équivalentes.
##
## Portez attention si les arguments sont spécifiés par nom ou
## par position.
matrix(1:12, 3, 4)
matrix(1:12, ncol = 4, nrow = 3)
matrix(nrow = 3, ncol = 4, data = 1:12)
matrix(nrow = 3, ncol = 4, byrow = FALSE, 1:12)
matrix(nrow = 3, ncol = 4, 1:12, FALSE)

### Définition de fonctions

## On définit une nouvelle fonction avec la syntaxe suivante:
##
##   <nom> <- function(<arguments>) <corps>
##
## où
##
## - 'nom' est le nom de la fonction;
## - 'arguments' est la liste des arguments, séparés par des
##    virgules;
## - 'corps' est le corps de la fonction, soit une expression
##   ou un groupe d'expressions réunies par des accolades { }.
##
## Une fonction retourne toujours la valeur de la *dernière*
## expression de celle-ci.
##
## Voici un exemple trivial.
square <- function(x) x * x

## Appel de cette fonction.
square(10)

### Portée des variables

## La portée (domaine où un objet existe et comporte une
## valeur) des arguments d'une fonction et de tout objet
## défini à l'intérieur de celle-ci se limite à la fonction.
##
## Ceci signifie que l'interprète R fait bien la distinction
## entre un objet dans l'espace de travail et un objet utilisé
## dans une fonction (fort heureusement!).
x <- 5                     # objet dans l'espace de travail
square(10)                 # dans 'square' x vaut 10
x                          # valeur inchangée
square(x)                  # passer valeur de 'x' à 'square'
square(x = x)              # colle... signification?

## Le concept de portée va plus loin dans R.
##
## Tout appel de fonction crée un *environnement* dans lequel
## sont définis les objets.
##
## Un environnement hérite des objets définis dans
## l'environnement qui le contient.
##
## Par conséquent, si un objet n'existe pas dans un
## environnement, R va chercher dans les environnements
## parents pour en trouver la définition.
##
## En pratique, cela signifie qu'il n'est pas toujours
## nécessaire de passer des objets en argument. Il suffit de
## compter sur le concept de portée lexicale ("lexical scope").
##
## Supposons que l'on veut écrire une fonction pour calculer
##
##   f(x, y) = x (1 + xy)^2 + y (1 - y) + (1 + xy)(1 - y)
##
## Deux termes sont répétés dans cette expression. On a donc
##
##   a = 1 + xy
##   b = 1 - y
##
## et f(x, y) = x a^2 + y b + a b.
##
## Voici une manière élégante de procéder qui repose sur la
## portée lexicale.
f <- function(x, y)
{
    g <- function(a, b)
        x * a^2 + y * b + a * b
    g(1 + x * y, 1 - y)
}
f(2, 3)
f(2, 4)

### Pense vectoriel, Paula

## Veiller à concevoir, autant que faire se peut, des
## fonctions pouvant accepter en argument l'unité de base en
## R: le vecteur!
##
## C'est parfois, voire souvent, implicite. Les fonctions
## 'square' et 'f' ci-dessus sont toutes deux automatiquement
## vectorielles.
square(c(7, 2, 4, 9))
f(2, c(3, 4))

### Valeur par défaut d'un argument

## La fonction suivante calcule la distance entre deux points
## dans l'espace euclidien à 'n' dimensions, par défaut par
## rapport à l'origine.
##
## Remarquez comment nous spécifions une valeur par défaut,
## l'origine, pour l'argument 'y'.
##
## (Note: la fonction 'sum'... somme tous les éléments d'un
## vecteur.)
dist <- function(x, y = 0) sum((x - y)^2)

## Quelques calculs de distances.
dist(c(1, 1))                # (1, 1) par rapport à l'origine
dist(c(1, 1, 1), c(3, 1, 2)) # entre (1, 1, 1) et (3, 1, 2)

### Fonction anonyme

## Comme le nom du concept l'indique, une fonction anonyme est
## une fonction qui n'a pas de nom. C'est parfois utile pour
## des fonctions courtes utilisées dans une autre fonction.
##
## Reprenons l'exemple précédent en généralisant les
## expressions des termes 'a' et 'b'. La fonction 'f'
## pourrait maintenant prendre en arguments 'x', 'y' et des
## fonctions pour calculer 'a' et 'b'.
##
## On peut ensuite directement passer des fonctions anonymes
## en argument.
f <- function(x, y, fa, fb)
{
    g <- function(a, b)
        x * a^2 + y * b + a * b
    g(fa(x, y), fb(x, y))
}
f(2, 3,
  function(x, y) 1 + x * y,
  function(x, y) 1 - y)

### Argument '...'

## Il existe dans R un argument formel nommé '...' que l'on
## peut utiliser dans n'importe quelle fonction. Il a pour
## effet de rendre variable le nombre d'arguments d'une
## fonction.
##
## Le contenu de '...' peut être traité de deux grandes
## façons:
##
## 1. en le capturant dans une liste avec 'list(...)';
## 2. en le passant tel quel à une autre fonction qui, elle,
##    saura traiter les arguments qui lui sont ainsi passés.
##
## Voici un exemple illustrant la seconde approche. La
## fonction 'curve' prend une expression R en argument et en
## trace le graphique sur un intervalle donné.
curve(x^2, from = 0, to = 2)

## Nous voulons que les graphiques de 'curve' (et seulement
## ceux-là) soient toujours en orange.
curve(x^2, from = 0, to = 2, col = "orange")

## Au lieu de complètement redéfinir 'curve', nous pouvons
## simplement définir une petite fonction qui, grâce à '...',
## accepte d'office tous les arguments de 'curve'.
ocurve <- function(...) curve(..., col = "orange")
ocurve(x^2, from = 0, to = 2)
