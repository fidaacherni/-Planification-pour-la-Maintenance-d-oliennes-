📌 Contexte

Ce projet s’inscrit dans le cadre de la recherche opérationnelle appliquée à l’ingénierie et vise à optimiser la planification de la maintenance d’un parc éolien. L’enjeu est de programmer efficacement les arrêts nécessaires pour l’entretien et les réparations des éoliennes tout en minimisant la perte de production énergétique.

Le défi repose sur :

- Une disponibilité limitée des techniciens.
- Une contrainte d’incompatibilité entre plusieurs interventions sur une même éolienne.
- Une maximisation de la production énergétique, en prenant en compte les prévisions météorologiques pour identifier les périodes d’arrêt les moins impactantes.

🎯 Objectif

Optimiser la planification des tâches de maintenance en répartissant les interventions sur N semaines avec K techniciens, de manière à maximiser la production totale d’énergie.

🔍 Détails de la Planification

- Chaque semaine est divisée en 5 jours de travail.
- Chaque jour comprend 3 périodes : matin, après-midi et une période de repos (nuit ou fin de semaine).
- Chaque tâche :
  
   - Se déroule sur une éolienne spécifique.
   - Dure un nombre défini de périodes.
   - Nécessite un technicien.
   - Ne peut être interrompue une fois commencée.
   - Bloque la production de l’éolienne pendant son exécution.

Contraintes clés :

- Un technicien ne peut travailler que sur une seule tâche à la fois.
- Une éolienne ne peut pas être utilisée pour plusieurs tâches simultanément.
- Les interventions doivent être planifiées aux moments stratégiques pour éviter un impact économique trop important.

🏗 Méthodologie

Le projet est basé sur deux approches d’optimisation :
- Programmation Linéaire en Nombres Entiers (PLNE)
- Formalisation mathématique des contraintes et de la fonction objectif.
- Utilisation du solveur HiGHS 1.6.0 pour résoudre les instances du problème.
- Programmation par Contraintes (PC)
- Modélisation avec des contraintes globales pour éviter l’explosion combinatoire.
- Implémentation en MiniZinc pour tester plusieurs scénarios.

🏗 Résolution et Analyse

🔹 Trois instances de test ont été étudiées :
- Cas 1 : Modèle simplifié pour valider l’algorithme.
- Cas 2 : Planification de tâches de routine sur une semaine avec plusieurs techniciens.
- Cas 3 : Planification de tâches longues et complexes sur plusieurs semaines, nécessitant les techniciens les plus qualifiés.

✅ Résultats obtenus 

PLNE et PC ont donné des solutions similaires mais avec des différences en termes de rapidité et de complexité computationnelle.

Temps d’exécution :

- Cas 1 : 0.25 secondes.
- Cas 2 : 10 secondes.
- Cas 3 : 35 secondes.
  
Optimisation efficace : Maximisation de la production énergétique malgré les contraintes techniques et humaines.

📊 Améliorations et Scénarios Avancés

Le modèle a été complexifié pour intégrer :

- Limitation des heures de travail hebdomadaires des techniciens (34 heures max).
- Optimisation du nombre de techniciens pour réduire les coûts sans impacter la production.
- Qualifications des techniciens : Affectation des tâches selon leurs compétences spécifiques.
- Intégration des prévisions météorologiques pour éviter les arrêts non prévus et optimiser la planification.
- Fenêtre temporelle stricte pour certaines tâches critiques (obligations réglementaires, disponibilité des pièces).

🚀 Conclusion

Ce projet illustre comment l’optimisation mathématique et l’intelligence artificielle peuvent améliorer la gestion d’infrastructures critiques comme les parcs éoliens. En combinant Programmation Linéaire et Programmation par Contraintes, nous avons pu concevoir un modèle robuste qui maximise la production énergétique tout en minimisant l’impact des arrêts de maintenance.

