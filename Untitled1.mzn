% Paramètres
int: n_week; % Nombre de semaines
int: n_day; % Nombre de jours par semaine
int: n_period; % Nombre total de périodes
int: n_tasks; % Nombre de tâches
int: n_employee; % Nombre d'employés
int: n_turbine; % Nombre d'éoliennes
int: n_skills; % Nombre de compétences

array[1..n_period] of var 0..1: np = [if i mod 3 == 0 then 1 else 0 endif | i in 1..n_period]; % binary = 1 if period is night
array[1..n_turbine, 1..n_period] of float: productivite; % Productivité par éolienne et période
array[1..n_tasks] of int: on_turbine; % Éolienne associée à chaque tâche
array[1..n_tasks] of int: length; % Durée (en périodes) de chaque tâche

% Compétences
array[1..n_employee, 1..n_skills] of int: skills; % Compétences des techniciens
array[1..n_tasks] of int: skill_req; % Compétence requise pour chaque tâche

% Variables de décision
array[1..n_tasks, 1..n_period, 1..n_employee] of var 0..1: x; % x[i, t, k] = 1 si tâche i en cours à un temps t avec employé k
array[1..n_turbine, 1..n_period] of var 0..1: y; % y[e,t] = 1 si l'éolienne e est disponible à t

% Fonction objectif : maximiser la production totale
var float: total_production = sum(t in 1..n_period, e in 1..n_turbine)(
    productivite[e, t] * y[e, t]
);

solve maximize total_production;

% Contraintes
constraint
  % Liaison entre y et x
  forall(e in 1..n_turbine, t in 1..n_period)(
    y[e, t] = 1 - sum(i in 1..n_tasks, k in 1..n_employee where on_turbine[i] == e)(x[i, t, k])
  );

% Respect de la durée de la tâche avec les nuits qui ne comptent pas
constraint
  forall(i in 1..n_tasks)(
    sum(t in 1..n_period, k in 1..n_employee)(x[i, t, k] * (1 - np[t])) = length[i]
  );

% Marquer une tâche comme en cours pendant la nuit si elle est active avant et après
constraint
  forall(i in 1..n_tasks, t in 2..n_period - 1, k in 1..n_employee)(
    (np[t] = 1) * (x[i, t - 1, k] + x[i, t + 1, k] - 1) <= x[i, t, k]
  );

% Un technicien par tâche à un instant donné
constraint
  forall(t in 1..n_period, k in 1..n_employee)(
    sum(i in 1..n_tasks)(x[i, t, k]) <= 1
  );

% Un seul employé par tâche sur toute sa durée
constraint
  forall(i in 1..n_tasks)(
    sum(k in 1..n_employee)(
      bool2int(sum(t in 1..n_period)(x[i, t, k]) > 0)
    ) <= 1
  );

% Pas de chevauchement des tâches sur une éolienne
constraint
  forall(t in 1..n_period, e in 1..n_turbine)(
    sum(i in 1..n_tasks where on_turbine[i] == e, k in 1..n_employee)(x[i, t, k]) <= 1
  );

% Continuité des tâches pour un employé
constraint
  forall(i in 1..n_tasks)(
    forall(k in 1..n_employee)(
      sum(t in 2..n_period)(x[i, t, k] - x[i, t - 1, k]) <= 1
    )
  );

% Vérifier que l'employé a les compétences requises pour la tâche
constraint
  forall(i in 1..n_tasks, k in 1..n_employee)(
    sum(t in 1..n_period)(x[i, t, k]) > 0 -> skills[k, skill_req[i]] = 1
  );

% Résultats
output [
    "Total production: ", show(total_production), "\n",
    "Task assignments turbine:\n",
    show2d(y), "\n"
];
