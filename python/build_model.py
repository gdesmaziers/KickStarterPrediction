#Librairie permettant la manipulation de matrices
import numpy as numpy
#Librairie permettant la manipulation de donnees, notamment en DataFrames (donnees en 2 dimensions lignes et colonnes)
import pandas as pandas
#Librairie Machine Learning
import sklearn
#Algorithme DecisionTreeClassifier
from sklearn.tree import DecisionTreeClassifier
#Librairie CoreML
import coremltools

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

#Initialisation de l'algorithme
classifier = DecisionTreeClassifier()
#Entrainement du modele a partir des donnees
classifier.fit(X, y)

#Conversion du modele au format CoreML
coreml_model = coremltools.converters.sklearn.convert(classifier, ['goal', 'backersCount', 'duration'], ['prediction', 'precision'])
coreml_model.author = 'Octo Technology'
coreml_model.license = 'Unknown'
coreml_model.short_description = 'KickStarter success prediction using DecisionTreeClassifier'
coreml_model.input_description['goal'] = 'Goal of the project.'
coreml_model.input_description['backersCount'] = 'Contributors count for the project.'
coreml_model.input_description['duration'] = 'Duration of the project.'
coreml_model.output_description['prediction'] = 'Prediction of the success for the project'
#Sauvegarde du fichier mlmodel
coreml_model.save('KickStarterMLModel.mlmodel')
