--Destruction des tables et des contraintes de clefs étrangères si elles existent


if exists (select * from sys.all_objects where name='ActivitéAnnexe_Activité_FK')
ALTER TABLE jo.ActivitéAnnexe
DROP CONSTRAINT ActivitéAnnexe_Activité_FK
GO

if exists (select * from sys.all_objects where name='ActivitéMétier_Activité_FK')
ALTER TABLE jo.ActivitéProduction
DROP CONSTRAINT ActivitéMétier_Activité_FK
GO

if exists (select * from sys.all_objects where name='TacheAnnexe_ActivitéAnnexe_FK')
ALTER TABLE jo.TacheAnnexe
DROP CONSTRAINT TacheAnnexe_ActivitéAnnexe_FK
GO

if exists (select * from sys.all_objects where name='FK_ASS_13')
ALTER TABLE jo.MétierActivité
DROP CONSTRAINT FK_ASS_13
GO

if exists (select * from sys.all_objects where name='TacheProduction_ActivitéProduction_FK')
ALTER TABLE jo.TacheProduction
DROP CONSTRAINT TacheProduction_ActivitéProduction_FK
GO

if exists (select * from sys.all_objects where name='HistoriqueEmployé_Employé_FK')
ALTER TABLE jo.HistoriqueEmployé
DROP CONSTRAINT HistoriqueEmployé_Employé_FK
GO

if exists (select * from sys.all_objects where name='HistoriqueTache_Employé_FK')
ALTER TABLE jo.HistoriqueTache
DROP CONSTRAINT HistoriqueTache_Employé_FK
GO

if exists (select * from sys.all_objects where name='Tache_Employé_FK')
ALTER TABLE jo.Tache
DROP CONSTRAINT Tache_Employé_FK
GO

if exists (select * from sys.all_objects where name='HistoriqueEmployé_Equipe_FK')
ALTER TABLE jo.HistoriqueEmployé
DROP CONSTRAINT HistoriqueEmployé_Equipe_FK
GO

if exists (select * from sys.all_objects where name='Equipe_Filière_FK')
ALTER TABLE jo.Equipe
DROP CONSTRAINT Equipe_Filière_FK
GO

if exists (select * from sys.all_objects where name='Logiciel_Filière_FK')
ALTER TABLE jo.Logiciel
DROP CONSTRAINT Logiciel_Filière_FK
GO

if exists (select * from sys.all_objects where name='Module_Logiciel_FK')
ALTER TABLE jo.Module
DROP CONSTRAINT Module_Logiciel_FK
GO

if exists (select * from sys.all_objects where name='Version_Logiciel_FK')
ALTER TABLE jo.VersionLog
DROP CONSTRAINT Version_Logiciel_FK
GO

if exists (select * from sys.all_objects where name='Module_Module_FK')
ALTER TABLE jo.Module
DROP CONSTRAINT Module_Module_FK
GO

if exists (select * from sys.all_objects where name='TacheProduction_Module_FK')
ALTER TABLE jo.TacheProduction
DROP CONSTRAINT TacheProduction_Module_FK
GO

if exists (select * from sys.all_objects where name='Employé_Métier_FK')
ALTER TABLE jo.Employé
DROP CONSTRAINT Employé_Métier_FK
GO

if exists (select * from sys.all_objects where name='FK_ASS_12')
ALTER TABLE jo.MétierActivité
DROP CONSTRAINT FK_ASS_12
GO

if exists (select * from sys.all_objects where name='Equipe_Service_FK')
ALTER TABLE jo.Equipe
DROP CONSTRAINT Equipe_Service_FK
GO

if exists (select * from sys.all_objects where name='HistoriqueTache_Tache_FK')
ALTER TABLE jo.HistoriqueTache
DROP CONSTRAINT HistoriqueTache_Tache_FK
GO

if exists (select * from sys.all_objects where name='TacheAnnexe_Tache_FK')
ALTER TABLE jo.TacheAnnexe
DROP CONSTRAINT TacheAnnexe_Tache_FK
GO

if exists (select * from sys.all_objects where name='TacheProduction_Tache_FK')
ALTER TABLE jo.TacheProduction
DROP CONSTRAINT TacheProduction_Tache_FK
GO

if exists (select * from sys.all_objects where name='Release_Version_FK')
ALTER TABLE jo.ReleaseVers
DROP CONSTRAINT Release_Version_FK
GO

if exists (select * from sys.all_objects where name='TacheProduction_Version_FK')
ALTER TABLE jo.TacheProduction
DROP CONSTRAINT TacheProduction_Version_FK
GO

if exists (select * from sys.all_objects where name='VersionLog')
DROP TABLE jo.VersionLog
GO

if exists (select * from sys.all_objects where name='Tache')
DROP TABLE jo.Tache
GO

if exists (select * from sys.all_objects where name='Métier')
DROP TABLE jo.Métier
GO

if exists (select * from sys.all_objects where name='Module')
DROP TABLE jo.Module
GO

if exists (select * from sys.all_objects where name='MétierActivité')
DROP TABLE jo.MétierActivité
GO

if exists (select * from sys.all_objects where name='Logiciel')
DROP TABLE jo.Logiciel
GO

if exists (select * from sys.all_objects where name='Filière')
DROP TABLE jo.Filière
GO

if exists (select * from sys.all_objects where name='Equipe')
DROP TABLE jo.Equipe
GO

if exists (select * from sys.all_objects where name='ActivitéAnnexe')
DROP TABLE jo.ActivitéAnnexe
GO

if exists (select * from sys.all_objects where name='ActivitéProduction')
DROP TABLE jo.ActivitéProduction
GO

if exists (select * from sys.all_objects where name='Employé')
DROP TABLE jo.Employé
GO

if exists (select * from sys.all_objects where name='HistoriqueEmployé')
DROP TABLE jo.HistoriqueEmployé
GO

if exists (select * from sys.all_objects where name='HistoriqueTache')
DROP TABLE jo.HistoriqueTache
GO

if exists (select * from sys.all_objects where name='ReleaseVers')
DROP TABLE jo.ReleaseVers
GO

if exists (select * from sys.all_objects where name='TacheAnnexe')
DROP TABLE jo.TacheAnnexe
GO

if exists (select * from sys.all_objects where name='Service')
DROP TABLE jo.Service
GO

if exists (select * from sys.all_objects where name='TacheProduction')
DROP TABLE jo.TacheProduction
GO

if exists (select * from sys.all_objects where name='Activité')
DROP TABLE jo.Activité
GO


-- Création des tables et des contraintes de clefs primaires

CREATE TABLE jo.Activité
  (
    CodeActivité NVARCHAR (15) NOT NULL ,
    Libellé NVARCHAR (50) NOT NULL
  )
GO
ALTER TABLE jo.Activité ADD CONSTRAINT Activité_PK PRIMARY KEY CLUSTERED (CodeActivité)
GO

CREATE TABLE jo.ActivitéAnnexe
  (
    CodeActivité NVARCHAR (15) NOT NULL
  )
GO
ALTER TABLE jo.ActivitéAnnexe ADD CONSTRAINT ActivitéAnnexe_PK PRIMARY KEY CLUSTERED (CodeActivité)
GO

CREATE TABLE jo.ActivitéProduction
  (
    CodeActivité NVARCHAR (15) NOT NULL
  )
GO
ALTER TABLE jo.ActivitéProduction ADD CONSTRAINT ActivitéMétier_PK PRIMARY KEY CLUSTERED (CodeActivité)
GO

CREATE TABLE jo.Employé
  (
    Login NVARCHAR (15) NOT NULL ,
    CodeMétier NVARCHAR (15) NOT NULL ,
    TauxProductivité DECIMAL (5,2) NOT NULL ,
    Nom NVARCHAR (15) NOT NULL ,
    Prénom NVARCHAR (15) NOT NULL
  )
GO
ALTER TABLE jo.Employé ADD CONSTRAINT Employé_PK PRIMARY KEY CLUSTERED (Login)
GO

CREATE TABLE jo.Equipe
  (
    IdEquipe INTEGER NOT NULL ,
    IdFilière NVARCHAR (4) NOT NULL ,
    CodeService NVARCHAR (15) NOT NULL
  )
GO
ALTER TABLE jo.Equipe ADD CONSTRAINT Equipe_PK PRIMARY KEY CLUSTERED (IdEquipe)
GO

CREATE TABLE jo.Filière
  (
    IdFilière NVARCHAR (4) NOT NULL ,
    Libellé NVARCHAR (50) NOT NULL
  )
GO
ALTER TABLE jo.Filière ADD CONSTRAINT Filière_PK PRIMARY KEY CLUSTERED (IdFilière)
GO

CREATE TABLE jo.HistoriqueEmployé
  (
    DateDébut DATE NOT NULL ,
    Manager BIT NOT NULL ,
    IdEquipe INTEGER NOT NULL ,
    Login NVARCHAR (15) NOT NULL ,
    DateFin DATE
  )
GO
ALTER TABLE jo.HistoriqueEmployé ADD CONSTRAINT HistoriqueEmployé_PK PRIMARY KEY CLUSTERED (DateDébut, Login, IdEquipe)
GO

CREATE TABLE jo.HistoriqueTache
  (
    IdTache INTEGER NOT NULL ,
    Login NVARCHAR (15) NOT NULL ,
                     DATE DATE NOT NULL ,
    TempsPassé       DECIMAL (4,1) NOT NULL ,
    TauxProductivité DECIMAL (5,2) NOT NULL
  )
GO
ALTER TABLE jo.HistoriqueTache ADD CONSTRAINT HistoriqueTache_PK PRIMARY KEY CLUSTERED (IdTache, Login, DATE)
GO

CREATE TABLE jo.Logiciel
  (
    CodeLogiciel NVARCHAR (15) NOT NULL ,
    IdFilière NVARCHAR (4) NOT NULL ,
    Nom NVARCHAR (50) NOT NULL
  )
GO
ALTER TABLE jo.Logiciel ADD CONSTRAINT Logiciel_PK PRIMARY KEY CLUSTERED (CodeLogiciel)
GO

CREATE TABLE jo.Module
  (
    CodeModule NVARCHAR (15) NOT NULL ,
    Libellé NVARCHAR (50) NOT NULL ,
    CodeLogiciel NVARCHAR (15) NOT NULL ,
    SurModule NVARCHAR (15)
  )
GO
ALTER TABLE jo.Module ADD CONSTRAINT Module_PK PRIMARY KEY CLUSTERED (CodeModule)
GO

CREATE TABLE jo.Métier
  (
    CodeMétier NVARCHAR (15) NOT NULL ,
    Libellé NVARCHAR (50) NOT NULL
  )
GO
ALTER TABLE jo.Métier ADD CONSTRAINT Métier_PK PRIMARY KEY CLUSTERED (CodeMétier)
GO

CREATE TABLE jo.MétierActivité
  (
    CodeMétier NVARCHAR (15) NOT NULL ,
    CodeActivité NVARCHAR (15) NOT NULL
  )
GO
ALTER TABLE jo.MétierActivité ADD CONSTRAINT Relation_21_PK PRIMARY KEY CLUSTERED (CodeMétier, CodeActivité)
GO

CREATE TABLE jo.ReleaseVers
  (
    Version_Numéro NVARCHAR (15) NOT NULL ,
    IdRelease     INTEGER NOT NULL IDENTITY NOT FOR REPLICATION ,
    Date_création DATE NOT NULL
  )
GO
ALTER TABLE jo.ReleaseVers ADD CHECK ( IdRelease BETWEEN 1 AND 999 )
GO
ALTER TABLE jo.ReleaseVers ADD CONSTRAINT Release_PK PRIMARY KEY CLUSTERED (IdRelease)
GO

CREATE TABLE jo.Service
  (
    CodeService NVARCHAR (15) NOT NULL ,
    Libellé NVARCHAR (50) NOT NULL
  )
GO
ALTER TABLE jo.Service ADD CONSTRAINT Service_PK PRIMARY KEY CLUSTERED (CodeService)
GO

CREATE TABLE jo.Tache
  (
    IdTache INTEGER NOT NULL IDENTITY NOT FOR REPLICATION ,
    Libellé NVARCHAR (50) NOT NULL ,
    Description NVARCHAR (200) ,
    Login NVARCHAR (15) NOT NULL
  )
GO
ALTER TABLE jo.Tache ADD CONSTRAINT Tache_PK PRIMARY KEY CLUSTERED (IdTache)
GO

CREATE TABLE jo.TacheAnnexe
  (
    IdTache INTEGER NOT NULL ,
    CodeActivité NVARCHAR (15) NOT NULL
  )
GO
ALTER TABLE jo.TacheAnnexe ADD CONSTRAINT TacheAnnexe_PK PRIMARY KEY CLUSTERED (IdTache)
GO

CREATE TABLE jo.TacheProduction
  (
    IdTache INTEGER NOT NULL ,
    CodeModule NVARCHAR (15) NOT NULL ,
    Version_Numéro NVARCHAR (15) NOT NULL ,
    DuréePrévuInitiale DECIMAL (4,1) NOT NULL ,
    DuréePrévuRéestimé DECIMAL (4,1) NOT NULL ,
    CodeActivité NVARCHAR (15) NOT NULL
  )
GO
ALTER TABLE jo.TacheProduction ADD CONSTRAINT TacheProduction_PK PRIMARY KEY CLUSTERED (IdTache)
GO

CREATE TABLE jo.VersionLog
  (
    CodeLogiciel NVARCHAR (15) NOT NULL ,
    Numéro NVARCHAR (15) NOT NULL ,
    Millésime NVARCHAR (15) NOT NULL ,
    DateOuverture   DATE NOT NULL ,
    DateSortiePrévu DATE NOT NULL ,
    DateSortieRéel  DATE
  )
GO
ALTER TABLE jo.VersionLog ADD CONSTRAINT Version_PK PRIMARY KEY CLUSTERED (Numéro)
GO

-- Création des contraintes de clefs étrangères


ALTER TABLE jo.ActivitéAnnexe ADD CONSTRAINT ActivitéAnnexe_Activité_FK 
FOREIGN KEY (CodeActivité) REFERENCES jo.Activité (CodeActivité)
GO

ALTER TABLE jo.ActivitéProduction ADD CONSTRAINT ActivitéMétier_Activité_FK 
FOREIGN KEY (CodeActivité) REFERENCES jo.Activité (CodeActivité)
GO

ALTER TABLE jo.Employé ADD CONSTRAINT Employé_Métier_FK 
FOREIGN KEY (CodeMétier) REFERENCES jo.Métier (CodeMétier)
GO

ALTER TABLE jo.Equipe ADD CONSTRAINT Equipe_Filière_FK 
FOREIGN KEY (IdFilière) REFERENCES jo.Filière (IdFilière)
GO

ALTER TABLE jo.Equipe ADD CONSTRAINT Equipe_Service_FK 
FOREIGN KEY (CodeService) REFERENCES jo.Service (CodeService)
GO

ALTER TABLE jo.MétierActivité ADD CONSTRAINT FK_ASS_12 
FOREIGN KEY (CodeMétier) REFERENCES jo.Métier (CodeMétier)
GO

ALTER TABLE jo.MétierActivité ADD CONSTRAINT FK_ASS_13 
FOREIGN KEY (CodeActivité) REFERENCES jo.ActivitéProduction (CodeActivité)
GO

ALTER TABLE jo.HistoriqueEmployé ADD CONSTRAINT HistoriqueEmployé_Employé_FK 
FOREIGN KEY (Login) REFERENCES jo.Employé (Login)
GO

ALTER TABLE jo.HistoriqueEmployé ADD CONSTRAINT HistoriqueEmployé_Equipe_FK 
FOREIGN KEY (IdEquipe) REFERENCES jo.Equipe (IdEquipe)
GO

ALTER TABLE jo.HistoriqueTache ADD CONSTRAINT HistoriqueTache_Employé_FK 
FOREIGN KEY (Login) REFERENCES jo.Employé (Login)
GO

ALTER TABLE jo.HistoriqueTache ADD CONSTRAINT HistoriqueTache_Tache_FK 
FOREIGN KEY (IdTache) REFERENCES jo.Tache (IdTache)
GO

ALTER TABLE jo.Logiciel ADD CONSTRAINT Logiciel_Filière_FK 
FOREIGN KEY (IdFilière) REFERENCES jo.Filière (IdFilière)
GO

ALTER TABLE jo.Module ADD CONSTRAINT Module_Logiciel_FK 
FOREIGN KEY (CodeLogiciel) REFERENCES jo.Logiciel (CodeLogiciel)
GO

ALTER TABLE jo.Module ADD CONSTRAINT Module_Module_FK 
FOREIGN KEY (CodeModule) REFERENCES jo.Module (CodeModule)
GO

ALTER TABLE jo.ReleaseVers ADD CONSTRAINT Release_Version_FK 
FOREIGN KEY (Version_Numéro) REFERENCES jo.VersionLog (Numéro)
GO

ALTER TABLE jo.TacheAnnexe ADD CONSTRAINT TacheAnnexe_ActivitéAnnexe_FK 
FOREIGN KEY (CodeActivité) REFERENCES jo.ActivitéAnnexe (CodeActivité)
GO

ALTER TABLE jo.TacheAnnexe ADD CONSTRAINT TacheAnnexe_Tache_FK 
FOREIGN KEY (IdTache) REFERENCES jo.Tache (IdTache)
GO

ALTER TABLE jo.TacheProduction ADD CONSTRAINT TacheProduction_ActivitéProduction_FK 
FOREIGN KEY (CodeActivité) REFERENCES jo.ActivitéProduction (CodeActivité)
GO

ALTER TABLE jo.TacheProduction ADD CONSTRAINT TacheProduction_Module_FK 
FOREIGN KEY (CodeModule) REFERENCES jo.Module (CodeModule)
GO

ALTER TABLE jo.TacheProduction ADD CONSTRAINT TacheProduction_Tache_FK 
FOREIGN KEY (IdTache) REFERENCES jo.Tache (IdTache)
GO

ALTER TABLE jo.TacheProduction ADD CONSTRAINT TacheProduction_Version_FK 
FOREIGN KEY (Version_Numéro) REFERENCES jo.VersionLog (Numéro)
GO

ALTER TABLE jo.Tache ADD CONSTRAINT Tache_Employé_FK 
FOREIGN KEY (Login) REFERENCES jo.Employé (Login)
GO

ALTER TABLE jo.VersionLog ADD CONSTRAINT Version_Logiciel_FK 
FOREIGN KEY (CodeLogiciel) REFERENCES jo.Logiciel (CodeLogiciel)
GO


