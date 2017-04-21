

--Requete 1.2.5 Déterminer dans quel service, filière et équipe travaille une personne, et qui est son manager (9 lignes renvoyées)

select e.Nom, e.Prénom, s.Libellé as 'Nom service', f.Libellé as 'Nom filière', eq.IdEquipe as 'Num équipe', ma.Nom as 'Nom manager', ma.Prénom as 'Prénom manager'
from jo.Employé e 
left outer join jo.HistoriqueEmployé he on he.Login=e.Login
left outer join jo.Equipe eq on eq.IdEquipe=he.IdEquipe
left outer join jo.Filière f on f.IdFilière=eq.IdFilière
left outer join jo.Service s on s.CodeService=eq.CodeService
left outer join (select Nom, Prénom, IdEquipe from jo.HistoriqueEmployé he2 inner join jo.Employé e2 on e2.Login= he2.Login where he2.Manager=1) ma on ma.IdEquipe=eq.IdEquipe


--Requete 1.2.5 Déterminer sur une période donnée, la répartition du temps d’une personne sur ses différentes activités

select e.Nom, e.Prénom, ht.IdTache, SUM(ht.TempsPassé) as 'Temps passé'
from jo.Employé e
inner join jo.HistoriqueTache ht on ht.Login=e.Login
group by e.Nom, e.Prénom, ht.IdTache


--Requete 1.2.5 Comparer les temps prévus et réalisés sur une version d’un logiciel, pour une personne ou une équipe

--Par personne
select t.Login, tp.Version_Numéro, tp.DuréePrévuInitiale, sum(ht.TempsPassé) as 'Temps passé'
from jo.TacheProduction tp
inner join jo.Tache t on t.IdTache = tp.IdTache
inner join jo.HistoriqueTache ht on ht.IdTache=t.IdTache
group by tp.Version_Numéro, t.Login, tp.DuréePrévuInitiale

--Par équipe
select tp.Version_Numéro, he.IdEquipe, tp.DuréePrévuInitiale, sum(ht.TempsPassé) as 'Temps passé'
from jo.TacheProduction tp
inner join jo.Tache t on t.IdTache = tp.IdTache
inner join jo.HistoriqueTache ht on ht.IdTache=t.IdTache
inner join jo.HistoriqueEmployé he on he.Login =ht.Login
group by tp.Version_Numéro, he.IdEquipe, tp.DuréePrévuInitiale


--Requete 1.2.5 Déterminer la durée de travail réalisée par chaque équipe pour produire une version

select tp.Version_Numéro, he.IdEquipe, sum(ht.TempsPassé) as 'Temps passé'
from jo.TacheProduction tp
inner join jo.Tache t on t.IdTache = tp.IdTache
inner join jo.HistoriqueTache ht on ht.IdTache=t.IdTache
inner join jo.HistoriqueEmployé he on he.Login =ht.Login
inner join jo.VersionLog v on v.Numéro=tp.Version_Numéro
where v.DateSortieRéel !=null
group by tp.Version_Numéro, he.IdEquipe


--Requete 1.2.5 Déterminer le temps total passé par une filière sur la production de chaque module d’un logiciel depuis sa première version

select l.IdFilière, m.CodeModule, l.Nom, tp.Version_Numéro, sum(ht.TempsPassé) as 'Temps passé'
from jo.HistoriqueTache ht
inner join jo.TacheProduction tp on tp.IdTache=ht.IdTache
inner join jo.Module m on m.CodeModule=tp.CodeModule
inner join jo.Logiciel l on l.CodeLogiciel=m.CodeLogiciel
group by l.IdFilière, m.CodeModule, l.Nom, tp.Version_Numéro