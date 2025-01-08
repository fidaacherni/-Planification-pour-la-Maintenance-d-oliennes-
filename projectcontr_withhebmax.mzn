include "globals.mzn";

% Paramètres
int: n_week; % Nombre de semaines
int: n_day; % Nombre de jours par semaine
int: n_period; % Nombre total de périodes
int: n_tasks; % Nombre de tâches
int: n_employee; % Nombre d'employés
int: n_turbine; % Nombre d'éoliennes


array[1..n_period] of var 0..1: np = [ if i mod 3 == 0 then 1 else 0 endif | i in 1..n_period ]; % binary = 1 if period is night
% Create the matrix that link period with week
array[1..n_period] of var 1..n_week: period_to_week = 
    [ (p - 1) div (3 * 5) + 1 | p in 1..n_period ];



array[1..n_turbine, 1..n_period] of float: productivite; % Productivité par éolienne et période
array[1..n_tasks] of int: on_turbine; % Éolienne associée à chaque tâche
array[1..n_tasks] of int: length; % Durée (en périodes) de chaque tâche

% Variables de décision
array[1..n_tasks] of var 1..n_period: start;
array[1..n_tasks] of var 1..n_employee: tech;
array[1..n_employee, 1..n_period] of var 0..n_tasks: tech_avail;


array[1..n_tasks] of var 1..n_period: end;

array[1..n_turbine, 1..n_period] of var 0..1: y; % y[e,t] = 1 si l'éolienne e est disponible à t


% Fonction objectif : maximiser la production totale
var float: total_production = sum(t in 1..n_period, e in 1..n_turbine) (
    productivite[e, t] * y[e,t]
);

solve maximize total_production;

% Contraintes

% 1. Contrainte pour définir le min de fin de chaque tâche
constraint forall(i in 1..n_tasks) (
    end[i] >= start[i] + length[i] - 1
);
% 2. Contrainte pour s'assurer que les périodes de nuit ne comptent pas dans la durée de la tâche, definit la vrai fin de tâche
constraint forall(i in 1..n_tasks) (
    sum(t in start[i]..end[i]) (1 - np[t]) = length[i]
);

% 3. Contrainte pour lier les variables y aux tâches
constraint forall(e in 1..n_turbine, t in 1..n_period) (
    y[e,t] = 1 - sum(i in 1..n_tasks where on_turbine[i] = e) (
        bool2int(start[i] <= t /\ t <= end[i])));
        
% 4. Contrainte pour s'assurer que les tâches sur la même éolienne ne se chevauchent pas
constraint forall(e in 1..n_turbine) (
  disjunctive([start[i] | i in 1..n_tasks where on_turbine[i]=e],[length[i] | i in 1..n_tasks where on_turbine[i] = e])
);
% 5. Disponibilité des techniciens
constraint forall(k in 1..n_employee, t in 1..n_period) (tech_avail[k, t] = sum(i in 1..n_tasks where tech[i] = k /\ start[i] <= t/\ t <= start[i] + length[i] - 1) (1));
constraint forall(k in 1..n_employee, t in 1..n_period) (tech_avail[k, t] <= 1 );
constraint cumulative(start, length, [1 | i in 1..n_tasks], n_employee);

constraint
    forall(k in 1..n_employee, w in 1..n_week) (
        sum(t in 1..n_period where period_to_week[t] = w) (
            bool2int(tech_avail[k,t] > 0) * (1 - np[t]) * 4
        ) <= 34
    );


% Résultats
output [
    "Total production: ", show(total_production), "\n",
    %"Task assignments:\n",
    %show([x[i, t, k] | i in 1..n_tasks, t in 1..n_period, k in 1..n_employee]), "\n",
    "Task assignments turbine:\n",
    show2d(y), "\n",
		%"Task assignments employe:\n",
    %show2d(tech_avail), "\n",
];


