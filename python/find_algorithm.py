#Librairie permettant la manipulation de matrices
import numpy
#Librairie permettant la manipulation de donnees, notamment en DataFrames (donnees en 2 dimensions lignes et colonnes)
import pandas
#Librairie permettant la realisation de graphiques
import matplotlib.pyplot as pyplot
#Librairie Machine Learning
import sklearn
#Librairie permettant la validation d'algorithme
from sklearn import model_selection
#Algorithme LogisticRegression
from sklearn.linear_model import LogisticRegression
#Algorithme GaussianNB
from sklearn.naive_bayes import GaussianNB
#Algorithme DecisionTreeClassifier
from sklearn.tree import DecisionTreeClassifier
#Algorithme KNeighborsClassifier
from sklearn.neighbors import KNeighborsClassifier
#Algorithme LinearDiscriminantAnalysis
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis

#Lecture des donnees depuis le dataset CSV
dataframe = pandas.read_csv('../data/kickstarter.csv')
#On calcule la duree du projet KickStarter pour chaque ligne
dataframe['duration'] = dataframe['deadline'] - dataframe['launched_at']
#On supprime les colonnes inutiles
dataframe = dataframe.drop(['project_id', 'name', 'desc', 'keywords', 'country','currency', 'disable_communication', 'deadline', 'launched_at', 'state_changed_at','created_at'], axis=1)

#Creation d'une matrice de features
X = numpy.array(dataframe.drop(['final_status'],1))
#Creation d'une matrice de libelle final
y = numpy.array(dataframe['final_status'])

#On teste 5 algorithmes
models = []
models.append(('LR', LogisticRegression()))
models.append(('LDA', LinearDiscriminantAnalysis()))
models.append(('KNC', KNeighborsClassifier()))
models.append(('DTC', DecisionTreeClassifier()))
models.append(('NB', GaussianNB()))

results = []
names = []
for name, model in models:
    #Selection des indices pour la cross validation
    kfold = model_selection.KFold(n_splits=10, random_state=7)
    #Calcul des scores
    cross_val_results = model_selection.cross_val_score(model, X, y, cv=kfold, scoring='accuracy')
    results.append(cross_val_results)
    names.append(name)

figure = pyplot.figure()
figure.suptitle('Algorithms Comparison')
axe = figure.add_subplot(111)
pyplot.boxplot(results)
axe.set_xticklabels(names)
pyplot.savefig('algorithms.png')
