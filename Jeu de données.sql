-- Création des données dans les tables Filière, Service, Logiciel, Module, VersionLog, Métier, 
-- Activité, ActivitéProduction, MétierActivité, ActivitéAnnexe, Employé, Equipe, HistoriqueEmployé


insert jo.Filière(IdFilière,Libellé)
values ('BIOA','Biologie animale')
,('BIOV','Biologie végétale')
,('BIOH','Biologie humaine')
go

insert jo.Service(CodeService,Libellé)
values ('MKT','Marketing')
,('DEV','Developpement')
,('TEST','Test')
,('SL','Support logiciel')
go

insert jo.Logiciel(CodeLogiciel,Nom,IdFilière)
values('GENO', 'Genomica', 'BIOA')
go

insert jo.Module(CodeModule,Libellé,CodeLogiciel,SurModule)
values('SEQUENCAGE','Séquençage','GENO',null)
,('MARQUAGE','Marquage','GENO','SEQUENCAGE')
,('SEPARATION','Séparation','GENO','SEQUENCAGE')
,('ANALYSE','Analyse','GENO','SEQUENCAGE')
,('POLYMORPHISME','Polymorphysme génétique','GENO',null)
,('VAR_ALLELE','Variations alléliques','GENO',null)
,('UTIL_DROITS','Utilisateurs et droits','GENO',null)
,('PARAMETRES','Paramétrages','GENO',null)
go

insert jo.VersionLog(DateOuverture,DateSortiePrévu,DateSortieRéel,CodeLogiciel,Millésime,Numéro)
values ('2016-01-02','2016-12-08','2017-01-08','GENO','2017','1.00')
,('2016-12-28','2017-12-08',null,'GENO','2018','2.00')
go

insert jo.Métier(CodeMétier,Libellé)
values ('ANA','Analyste')
,('CDP','Chef de projet')
,('DEV','Développeur')
,('DES','Designer')
,('TES','Testeur')
go

--insertion des activités qui correspondent à des activités de production

insert jo.Activité(CodeActivité,Libellé)
values('DBE','Définition des besoins')
,('ARF','Architecture fonctionnelle')
,('ANF','Analyse fonctionnelle')
,('DES','Designe')
,('INF','Infographie')
,('ART','Architecture technique')
,('ANT','Analyse technique')
,('DEV','Developpement')
,('RPT','Rédaction de plan de test')
,('TES','Test')
,('GDP','Gestion de projet')
go

insert jo.ActivitéProduction(CodeActivité)
values('DBE')
,('ARF')
,('ANF')
,('DES')
,('INF')
,('ART')
,('ANT')
,('DEV')
,('RPT')
,('TES')
,('GDP')
go

insert jo.MétierActivité(CodeMétier,CodeActivité)
values('ANA','DBE')
,('ANA','ARF')
,('ANA','ANF')
,('CDP','ARF')
,('CDP','ANF')
,('CDP','ART')
,('CDP','TES')
,('CDP','GDP')
,('DEV','ANF')
,('DEV','ART')
,('DEV','ANT')
,('DEV','DEV')
,('DEV','TES')
,('DES','ANF')
,('DES','DES')
,('DES','INF')
,('TES','RPT')
,('TES','TES')
go

--insertion des activités qui correspondent à des activités annexes

insert jo.Activité(CodeActivité,Libellé)
values('FOR','Formation reçue')
,('FOD','Formation dispensée')
,('APE','Appui des personnes de l''équipe')
,('APA','Appui des personnes d''autres services')
,('TDP','Travail de délégué du personnel')
,('DAE','Déplacement à des évènements')
go

insert jo.ActivitéAnnexe(CodeActivité)
values('FOR')
,('FOD')
,('APE')
,('APA')
,('TDP')
,('DAE')
go

insert jo.Employé(Login,Prénom,Nom,CodeMétier, TauxProductivité)
values('GLECLERK','Geneviève','LECLERQ','ANA',100)
,('AFERRAND','Angèle','FERRAND','ANA',100)
,('BNORMAND','Balthazar','NORMAND','CDP',100)
,('RFISHER','Raymond','FISHER','DEV',100)
,('LBUTLER','Lucien','BUTLER','DEV',100)
,('RBEAUMONT','Roseline','BEAUMONT','DEV',100)
,('MWEBER','Marguerite','WEBER','DES',100)
,('HKLEIN','Hilaire','KLEIN','TES',100)
,('NPALMER','Nino','PALMER','TES',100)
go

insert jo.Equipe(IdEquipe,IdFilière,CodeService)
values(1,'BIOA','DEV')
,(2,'BIOA','TEST')
go

insert jo.HistoriqueEmployé(Login,IdEquipe,DateDébut,DateFin,Manager)
values('NPALMER',1,'2015-01-01',null,0)
,('HKLEIN',1,'2015-01-01',null,1)
,('MWEBER',1,'2015-01-01',null,0)
,('RBEAUMONT',2,'2015-01-01',null,1)
,('LBUTLER',2,'2015-01-01',null,0)
go
