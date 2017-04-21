

--- 2.1.A.	Clients pour lesquels on n’a pas de numéro de portable (id, nom) 
select  distinct c.CLI_ID,c.CLI_NOM from CLIENT as c
left outer join TELEPHONE as t on c.CLI_ID=t.CLI_ID
where c.CLI_ID not in ( select CLI_ID from TELEPHONE where TYP_CODE='GSM')
--- la requete renvoie 85 lignes



---2.1.B  B.	Clients pour lesquels on a au moins un N° de portable ou une adresse mail
select  distinct c.CLI_ID,c.CLI_NOM from CLIENT as c
left outer join TELEPHONE as t on c.CLI_ID=t.CLI_ID
where c.CLI_ID  in  ( select CLI_ID from TELEPHONE where TYP_CODE='GSM'
union
  select CLI_ID from EMAIL)
--- la requete renvoie 43 lignes


--2.1.C.	Mettre à jour les numéros de téléphone pour qu’ils soient au format « +33XXXXXXXXX » au lieu de « 0X-XX-XX-XX-XX » 
begin tran
update TELEPHONE set TEL_NUMERO= '+33'+ substring(replace(TEL_NUMERO,'-',''),2,9)
where TYP_CODE !='FAX'
rollback
--- renvoie 174 numéros de tél modifés


-- 2.1.D.	Clients qui ont payé avec au moins deux moyens de paiement différents au cours d’un même mois (id, nom)

select distinct f.CLI_ID,c.CLI_NOM from FACTURE as f
inner join CLIENT as c on f.CLI_ID=c.CLI_ID
group by  f.CLI_ID,c.CLI_NOM , year(f.FAC_PMDATE) ,MONTH(f.FAC_PMDATE)
having  count(f.PMCODE)>1
-- la requète nous retourne 28 lignes (noms).


--2.1 E Clients de la même ville qui se sont déjà retrouvés en même temps à l’hôtel 

select distinct a.CLI_ID, a.ADR_VILLE
from(
	select  ADR_VILLE, PLN_JOUR, COUNT(*) nb from(
		select distinct a.ADR_VILLE, cpc.PLN_JOUR,c.CLI_ID
		from CLIENT c
		inner join ADRESSE a on a.CLI_ID=c.CLI_ID
		inner join CHB_PLN_CLI cpc on cpc.CLI_ID=c.CLI_ID) x
	group by ADR_VILLE, PLN_JOUR
	having COUNT(*)>1) y
inner join CHB_PLN_CLI cpc on cpc.PLN_JOUR=y.PLN_JOUR
inner join ADRESSE a on a.CLI_ID=cpc.CLI_ID and a.ADR_VILLE=y.ADR_VILLE
order by 2,1
--32 lignes renvoyées


--2.2.A	Taux moyen d’occupation de l’hôtel par mois-année. Autrement dit, 
--		pour chaque mois-année valeur moyenne sur les chambres du ratio 
--		(nombre de jours d'occupation dans le mois / nombre de jours du mois)

declare @NbJourMois as table
(Nb int, NumMois int)

insert @NbJourMois values(31,1),(28,2),(31,3),(30,4),(31,5),(30,6),(31,7),(31,8),(30,9),(31,10),(30,11),(31,12)

select year(PLN_JOUR),month(PLN_JOUR), cast (count(chb_pln_cli_occupe) as float)/20/njm.Nb
from CHB_PLN_CLI
inner join @NbJourMois njm on njm.NumMois=month(PLN_JOUR)
where chb_pln_cli_occupe=1
group by year(PLN_JOUR),month(PLN_JOUR),njm.Nb
--36 lignes renvoyées


--2.2.B Taux moyen d’occupation de chaque étage par année

select year(PLN_JOUR),c.CHB_ETAGE, cast (count(chb_pln_cli_occupe) as float)/20/365
from CHB_PLN_CLI cpc
inner join CHAMBRE c on c.CHB_ID=cpc.CHB_ID
where chb_pln_cli_occupe=1
group by year(PLN_JOUR),c.CHB_ETAGE
--9 lignes renvoyées


--2.2.D Taux moyen de réservation de chaque étage par année

declare @NbJourMois as table
(Nb int, NumMois int)

insert @NbJourMois values(31,1),(28,2),(31,3),(30,4),(31,5),(30,6),(31,7),(31,8),(30,9),(31,10),(30,11),(31,12)

select year(PLN_JOUR),month(PLN_JOUR), cast (count(CHB_PLN_CLI_RESERVE) as float)/20/njm.Nb
from CHB_PLN_CLI cpc
inner join @NbJourMois njm on njm.NumMois=month(PLN_JOUR)
where CHB_PLN_CLI_RESERVE=1
group by year(PLN_JOUR),month(PLN_JOUR),njm.Nb
--36 lignes renvoyées


--2.2.E Clients qui ont passé au total au moins 7 jours à l’hôtel au cours d’un même mois 
--		(Id, Nom, mois où ils ont passé au moins 7 jours).

select c.CLI_ID, CLI_NOM, year(PLN_JOUR),month(PLN_JOUR)
from CLIENT c
inner join CHB_PLN_CLI cpc on cpc.CLI_ID=c.CLI_ID
where chb_pln_cli_occupe=1
group by c.CLI_ID, CLI_NOM, year(PLN_JOUR),month(PLN_JOUR)
having COUNT (*)>6
--417 lignes renvoyées


--2.2.H	Nombre quotidien moyen de clients présents dans l’hôtel pour chaque mois de l’année 2016, 
--		en tenant compte du nombre de personnes dans les chambres

declare @NbJourMois as table
(Nb int, NumMois int)

insert @NbJourMois values(31,1),(28,2),(31,3),(30,4),(31,5),(30,6),(31,7),(31,8),(30,9),(31,10),(30,11),(31,12)

select month(PLN_JOUR), cast (sum(CHB_PLN_CLI_NB_PERS) as float)/njm.Nb
from CHB_PLN_CLI
inner join @NbJourMois njm on njm.NumMois=month(PLN_JOUR)
where chb_pln_cli_occupe=1 and year(PLN_JOUR)=2016
group by month(PLN_JOUR),njm.Nb
--12 lignes renvoyées


--2.3 A Valeur absolue et pourcentage d’augmentation du tarif de chaque chambre sur l’ensemble de la période 

select tc1.CHB_ID ,abs(tc1.TRF_CHB_PRIX-tc2.TRF_CHB_PRIX), abs(tc1.TRF_CHB_PRIX-tc2.TRF_CHB_PRIX)/tc1.TRF_CHB_PRIX*100
from TRF_CHB tc1 
inner join TRF_CHB tc2 on tc1.CHB_ID=tc2.CHB_ID
where tc1.TRF_DATE_DEBUT=(select MIN (TRF_DATE_DEBUT) from TRF_CHB where tc1.CHB_ID=CHB_ID) and tc2.TRF_DATE_DEBUT=(select MAX(TRF_DATE_DEBUT) from TRF_CHB where tc1.CHB_ID=CHB_ID)
order by tc1.CHB_ID
--20 lignes renvoyées


--2.3 B Chiffre d'affaire de l’hôtel par trimestre de chaque année 

select datepart(year,f.FAC_PMDATE), datepart(q,f.FAC_PMDATE), sum(convert(money,(lf.LIF_MONTANT*lf.LIF_QTE*(1+lf.LIF_TAUX_TVA/100)-ISNULL(lf.LIF_REMISE_MONTANT,0))*(1-ISNULL(lf.LIF_REMISE_POURCENT,0)/100)))
from FACTURE f
inner join LIGNE_FACTURE lf on lf.FAC_ID=f.FAC_ID
group by datepart(year,f.FAC_PMDATE), datepart(q,f.FAC_PMDATE)
order by 1,2
--9 lignes renvoyées


--2.3 C Chiffre d'affaire de l’hôtel par mode de paiement et par an, avec les modes de paiement en colonne et les années en ligne 


select PMLIBELLE,[2015],[2016],[2017]
from (
	select datepart(year,f.FAC_PMDATE) as année, mp.PMLIBELLE, convert(money,(lf.LIF_MONTANT*lf.LIF_QTE*(1+lf.LIF_TAUX_TVA/100)-ISNULL(lf.LIF_REMISE_MONTANT,0))*(1-ISNULL(lf.LIF_REMISE_POURCENT,0)/100)) CA
	from LIGNE_FACTURE lf
	inner join FACTURE f on lf.FAC_ID=f.FAC_ID
	inner join MODE_PAIEMENT mp on mp.PMCODE=f.PMCODE
) as Source
pivot (
	sum(CA)
	for année in ([2015],[2016],[2017])
) as ProdParCat
--tableau 3*3 lignes


--2.3 D Délai moyen de paiement des factures par année et par mode de paiement, avec les modes de paiement en colonne et les années en ligne 

select PMLIBELLE,[2015],[2016],[2017]
from (
	select datepart(year,f.FAC_PMDATE) as année, mp.PMLIBELLE, DATEDIFF(day,f.FAC_DATE,f.FAC_PMDATE) delai
	from LIGNE_FACTURE lf
	inner join FACTURE f on lf.FAC_ID=f.FAC_ID
	inner join MODE_PAIEMENT mp on mp.PMCODE=f.PMCODE
) as Source
pivot (
	avg(delai)
	for année in ([2015],[2016],[2017])
) as ProdParCat
--tableau 3*3 lignes


--2.3 E Compter le nombre de clients dans chaque tranche de 5000 F de chiffre d’affaire total généré, en partant de 20000 F jusqu’à + de 45 000 F 


select Tranche, COUNT(*) from(
	select f.CLI_ID,
		case
			when sum(convert(money,(lf.LIF_MONTANT*lf.LIF_QTE*(1+lf.LIF_TAUX_TVA/100)-ISNULL(lf.LIF_REMISE_MONTANT,0))*(1-ISNULL(lf.LIF_REMISE_POURCENT,0)/100))) > 20000 and 
				sum(convert(money,(lf.LIF_MONTANT*lf.LIF_QTE*(1+lf.LIF_TAUX_TVA/100)-ISNULL(lf.LIF_REMISE_MONTANT,0))*(1-ISNULL(lf.LIF_REMISE_POURCENT,0)/100))) <25000 then '20000F - 25000F'
			when sum(convert(money,(lf.LIF_MONTANT*lf.LIF_QTE*(1+lf.LIF_TAUX_TVA/100)-ISNULL(lf.LIF_REMISE_MONTANT,0))*(1-ISNULL(lf.LIF_REMISE_POURCENT,0)/100))) < 30000 then '25000F - 30000F'
			when sum(convert(money,(lf.LIF_MONTANT*lf.LIF_QTE*(1+lf.LIF_TAUX_TVA/100)-ISNULL(lf.LIF_REMISE_MONTANT,0))*(1-ISNULL(lf.LIF_REMISE_POURCENT,0)/100))) < 35000 then '30000F - 35000F'
			when sum(convert(money,(lf.LIF_MONTANT*lf.LIF_QTE*(1+lf.LIF_TAUX_TVA/100)-ISNULL(lf.LIF_REMISE_MONTANT,0))*(1-ISNULL(lf.LIF_REMISE_POURCENT,0)/100))) < 40000 then '35000F - 40000F'
			when sum(convert(money,(lf.LIF_MONTANT*lf.LIF_QTE*(1+lf.LIF_TAUX_TVA/100)-ISNULL(lf.LIF_REMISE_MONTANT,0))*(1-ISNULL(lf.LIF_REMISE_POURCENT,0)/100))) < 45000 then '40000F - 45000F'
			else 'plus de 45000F'
		end as Tranche
	from LIGNE_FACTURE lf
	inner join FACTURE f on lf.FAC_ID=f.FAC_ID
	group by f.CLI_ID) CA
group by Tranche
--4 lignes renvoyées


--2.3 F A partir du 01/09/2017, augmenter les tarifs des chambres du rez-de-chaussée de 5%, celles du 1er étage de 4% et celles du 2d étage de 2% 

insert TARIF(TRF_DATE_DEBUT,TRF_PETIDEJEUNE,TRF_TAUX_TAXES)values('2017-09-01',20.6,50.00)
insert into TRF_CHB (CHB_ID, TRF_DATE_DEBUT,TRF_CHB_PRIX) 
select c.CHB_ID,'2017-09-01',case
	when CHB_ETAGE='RDC' then cast(tc.TRF_CHB_PRIX*1.05 as money)
	when CHB_ETAGE='1er' then cast(tc.TRF_CHB_PRIX*1.04 as money)
	else cast(tc.TRF_CHB_PRIX*1.02 as money)
	end 
from chambre c
inner join TRF_CHB tc on tc.CHB_ID=c.CHB_ID
where tc.TRF_DATE_DEBUT=(select MAX(TRF_DATE_DEBUT) from TRF_CHB)
--20 lignes renvoyées

