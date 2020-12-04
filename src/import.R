#' ---
#' title: "Importation des données"
#' author: "Joffrey JOUMAA"
#' date: "`r format(Sys.Date(), format = '%d %B %Y')`"
#' ---
#'  
#' Ce script vise à importer les données nécessaire pour réaliser un nuage de mot :
#' 
#'* un tableau avec les mots et leurs fréquences
#'* un patron si l'on souhaite donner une forme au nuage de mot
#'
#+ library
# chargement
library(data.table)

# import
dataset = setDT(read.csv("data/mots.csv"))

# duplicate
x_rep = 30
x_seq = x_rep * 100
dataset = do.call("rbind", replicate(x_rep, dataset, simplify = FALSE))

# logarithm
# data_inter = data.table(freq = (1/log(c(1:101)))[-1],
#                         pt = seq(1, x_seq, by = x_rep))

# linear
data_inter = data.table(freq = seq(1, 0, length.out = 100),
                        pt = seq(1, x_seq, by = x_rep))

resultat=approx(data_inter$pt, 
                data_inter$freq, 
                xout = seq(1, x_seq, by = 1), 
                method="linear", 
                ties="ordered")$y
dataset[, freq := resultat[1:nrow(dataset)]]

# export
saveRDS(dataset, "output/mots.rds")
