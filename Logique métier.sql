---------------------------------------
--La création d’une tâche de production 
---------------------------------------


  -- 1. Création de la procédure
if exists (select * from sys.all_objects where name='usp_CreationTacheProduction')
	drop procedure usp_CreationTacheProduction
go
create procedure usp_CreationTacheProduction @Libellé nvarchar(50),@Description nvarchar(200),@Employé_Login nvarchar(15)
	,@Module_codeModule nvarchar(15),@VersionLog_Numéro nvarchar(15),@DuréePrévuInitiale decimal(4,1),
	@DuréePrévuRéestimée decimal(4,1),@ActivitéProduction_CodeActivité nvarchar(15)
as
begin 
	insert jo.Tache(Libellé,Description,Login) values (@Libellé,@Description,@Employé_Login)
	insert jo.TacheProduction(IdTache,CodeModule,Version_Numéro,DuréePrévuInitiale,DuréePrévuRéestimé,CodeActivité)
	values((select top(1) IdTache from jo.Tache order by IdTache desc),@Module_codeModule,@VersionLog_Numéro,@DuréePrévuInitiale,@DuréePrévuRéestimée,@ActivitéProduction_CodeActivité)
end
go


  -- 2. Création d'un jeu de données
exec usp_CreationTacheProduction 'AT','saisie des utilisateurs et droits', 'AFERRAND','UTIL_DROITS','1.00','16','12','TES'
exec usp_CreationTacheProduction 'ST','saisie des tâches', 'HKLEIN','PARAMETRES','2.00','1','0.5','DBE'
exec usp_CreationTacheProduction 'ST','saisie des tâches', 'RBEAUMONT','PARAMETRES','1.00','2','1.5','DBE'
go

--------------------------------
--La création d’une tâche annexe
--------------------------------


  -- 1) Création de la procédure
if exists (select * from sys.all_objects where name='usp_CréationTacheAnnexe')
	drop procedure usp_CréationTacheAnnexe
go
create procedure usp_CréationTacheAnnexe @description nvarchar(200)=null, @Login nvarchar(15), @libellé nvarchar(50), 
@activité nvarchar(15)
as
begin

insert jo.Tache(Description,Login,Libellé)
values(@description,@Login,@libellé)
insert jo.TacheAnnexe(CodeActivité,IdTache)
values(@activité,(select top 1 IdTache from jo.Tache order by IdTache desc))

end
go


  -- 2) Création d'un jeu de données
exec usp_CréationTacheAnnexe @Login='RBEAUMONT',@libellé='Echange technique',@activité='FOD'
exec usp_CréationTacheAnnexe @Login='LBUTLER',@libellé='Formation',@activité='FOD'
exec usp_CréationTacheAnnexe @Login='LBUTLER',@libellé='Appui technique',@activité='APE'

--------------------------------------------------------------------------------------------------------------------------------
--La saisie de temps sur une tâche. Si le temps total saisi pour une journée dépasse 8h, une erreur explicite doit être renvoyée
--------------------------------------------------------------------------------------------------------------------------------

 -- 1) Création des messages d'erreurs
 
 if exists (select * from sys.messages where mesage_id='50001')
 begin
	exec sp_addmessage @msgnum = 50001, @severity = 12,
		@msgText = 'The total time worked per day must be less than 8 hours', @lang='us_english'

	exec sp_addmessage @msgnum = 50001, @severity = 12,
		@msgText = 'Le total de temps travaillé par jour doit être inférieur à 8h',
		   @lang='french'     
	go
end

 -- 2) Création de la procédure de saisie des temps de tache
if exists (select * from sys.all_objects where name='usp_SaisieTempsTache')
	drop procedure usp_SaisieTempsTache
go

create procedure usp_SaisieTempsTache @IdTache int, @TempsPassé decimal(4,1), @date date=null
as
begin
	IF @date is null
		SET @date = getdate()
	declare @login nvarchar(15)=(select Login from jo.Tache where IdTache=@IdTache)
		
	if (isnull((select SUM(h.TempsPassé) from jo.HistoriqueTache h where @login=h.Login),0)+@TempsPassé)<=8
		insert jo.HistoriqueTache (IdTache,Login,DATE,TempsPassé,TauxProductivité)
		values(@IdTache,@Login,@date,@TempsPassé,(select e.TauxProductivité from jo.Employé e where e.Login=@Login))
	else
		raiserror(50001,12,1)
	
end
go


  -- 3) Création d'un jeu de données
exec usp_SaisieTempsTache @IdTache=5, @TempsPassé=2
exec usp_SaisieTempsTache @IdTache=6, @TempsPassé=6
exec usp_SaisieTempsTache @IdTache=3, @TempsPassé=6.5


  -- 4) Exécution qui provoque un message d'erreur
--exec usp_SaisieTempsTache @IdTache=3, @TempsPassé=6.5


---------------------------------------------------------------------------------------------------------------------
-- création des vues pour remplissage des listes déroulantes de l'écran de saisies  des temps des taches de production
--------------------------------------------------------------------------------------------------------------------

-- 1) vue des Taches pour temps production

if exists (select * from sys.all_objects where name='vwTacheProduction')
	drop view vwTacheProduction
go

create view vwTacheProduction
as
(
select (CAST (t.idTache as nvarchar) + ' - '+ t.Libellé + ' ' + t.Description)  as LibelléTache,a.Libellé 
as LibelléActivité,m.Libellé as LibelléModule,l.Nom,v.Numéro,tp.DuréePrévuInitiale  
 from jo.Tache as t
inner join jo.TacheProduction as tp on t.IdTache=tp.IdTache
inner join jo.ActivitéProduction as ap on tp.CodeActivité=ap.CodeActivité
inner join jo.Activité as a on ap.CodeActivité=a.CodeActivité
inner join jo.Module as m on tp.CodeModule=m.CodeModule
inner join jo.Logiciel as l on m.CodeLogiciel = l.CodeLogiciel
inner join jo.VersionLog as v on l.CodeLogiciel= v.CodeLogiciel
)
go 


-- 2) vue des Taches pour les temps annexes

if exists (select * from sys.all_objects where name='vwTacheAnnexe')
	drop view vwTacheAnnexe
go

create view vwTacheAnnexe
as
(
select (CAST (t.idTache as nvarchar) + ' - '+ t.Libellé + ' ' + t.Description)  as LibelléTache, a.Libellé 
as LibelléActivité
from jo.Tache as t
inner join jo.TacheAnnexe as ta on t.IdTache=ta.IdTache
inner join jo.ActivitéAnnexe as aa	on ta.CodeActivité=aa.CodeActivité
inner join jo.Activité as a on aa.CodeActivité=a.CodeActivité
)
go 

-----------------------------------------------------------------------------------------------------------------------------
--	Permettre au manager de vérifier si les personnes de son équipe ont bien saisi tous leurs temps, c’est à dire 8h par jour
-----------------------------------------------------------------------------------------------------------------------------


if exists (select * from sys.all_objects where name='usp_ControleTempsManager')
	drop procedure usp_ControleTempsManager
go

create procedure usp_ControleTempsManager @LoginManager nvarchar(15)
as 
begin
	declare @tab as table (
	LoginEmp nvarchar(15),
	TempsPassé decimal(4,1)) 
	declare @req as nvarchar(400)=''
		
	insert into @tab select he.Login, sum(isnull(ht.TempsPassé,0)) as som from jo.HistoriqueEmployé he
	left outer join jo.HistoriqueTache ht on ht.Login=he.Login
	where he.IdEquipe = (select IdEquipe from jo.HistoriqueEmployé where Login=@LoginManager)
	group by he.Login
	having sum(isnull(ht.TempsPassé,0))!=8
	
	if (select COUNT(*) from @tab)=0
		select @req= 'Tous les employés de l''équipe ont réalisé les 8h quotidiennes'
	else
		select @req=@req+LoginEmp+ ' n''a travaillé que ' + cast (TempsPassé as nvarchar) +' heures '+char(13)from @tab
	
	print (@req)

end
go

exec usp_ControleTempsManager 'LBUTLER'




-------------------------------------------------------------------------------------------------
-- procedure pour la suppression de toute les données qui sont liées à une version d'un logiciel
-------------------------------------------------------------------------------------------------
go
if exists (select * from sys.all_objects where name='usp_SuppressionVersion')
	drop procedure usp_SuppressionVersion
go
create procedure usp_SuppressionVersion @version nvarchar(15), @logiciel nvarchar(15)
as
begin
--1) suppression des releases de la version du logiciel 

delete jo.ReleaseVers from jo.ReleaseVers as r 
inner join jo.VersionLog as v on r.Version_Numéro=v.Numéro  
where r.Version_Numéro=@version and v.CodeLogiciel=@logiciel

--2) suppression des historiques des Taches 

delete jo.HistoriqueTache from jo.HistoriqueTache as ht
inner join jo.Tache as t on ht.IdTache=t.IdTache
inner join jo.TacheProduction as tp on t.IdTache=tp.IdTache
inner join jo.VersionLog as v on tp.Version_Numéro=v.Numéro  
where v.Numéro=@version and v.CodeLogiciel= @logiciel

--3) creation d'une table pour mémoriser les 'IDtache' de production relatif à la version
-- qui servira ensuite à supprimer les enregistrements de la table Tache.

declare @TacheProdVersion table
(
Id int primary key
)
insert @TacheProdVersion(Id)( select tp.IdTache from  jo.TacheProduction as tp 
inner join jo.VersionLog as v on tp.Version_Numéro=v.Numéro 
where v.Numéro=@version and v.CodeLogiciel= @logiciel)

--4) suppression des taches de production relatif à la version du logiciel

delete jo.TacheProduction from  jo.TacheProduction as tp 
inner join jo.VersionLog as v on tp.Version_Numéro=v.Numéro  
where v.Numéro=@version and v.CodeLogiciel= @logiciel

--5) suppression des enregistrements de la table tache relatif à la version du logiciel

delete jo.Tache from  jo.Tache as t 
inner join @TacheProdVersion as tpv on t.IdTache=tpv.Id

--6) pour terminer, suppression de la version
delete v from jo.VersionLog as v
where v.Numéro=@version and v.CodeLogiciel=@logiciel

end

go
----------------------------------------------------------------------------------------------------------------------
--7) appel de la procédure de suppression
begin tran
exec usp_SuppressionVersion '1.00','GENO'

rollback
----------------------------------------------------------------------------------------------------------------------

