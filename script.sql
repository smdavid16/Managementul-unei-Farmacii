
drop table if exists detalii_tranzactie;
drop table if exists tranzactie;
drop table if exists stoc;
drop table if exists reteta;
drop table if exists medicament;
drop table if exists supliment_alimentar;
drop table if exists cosmetic;
drop table if exists produs;
drop table if exists echipament;
drop table if exists furnizor;
drop table if exists client;
drop table if exists angajat;


-- 1. tabelul angajat
create table angajat (
    cnp_angajat bigint primary key, 
    nume varchar(25) not null,
    prenume varchar(25) not null,
    functie varchar(50),
    data_angajarii date not null,
    telefon varchar(13) not null,
    
    constraint ang_functie_ck check (functie in ('asistent farmacist', 'farmacist', 'contabil', 'chimist', 'curatenie')),
    constraint ang_cnp_ck check(length(cnp_angajat)=13 and substr(cnp_angajat,1,1) in ('1','2','5','6'))
);

-- 2. tabelul echipament
create table echipament(
    id_echipament int primary key,
    cnp_angajat_responsabil bigint,
    nume_echipament varchar(25) not null,
    serie varchar(15),
    data_revizie date,

    constraint ech_serie_uk unique (serie),
    constraint fk_ang_echip foreign key (cnp_angajat_responsabil) references angajat(cnp_angajat) on delete cascade on update cascade
);

-- 3. tabelul client
create table client(
    cnp_client bigint primary key,
    nume varchar(25) not null,
    prenume varchar(25) not null,
    telefon varchar(13) not null,
    data_inscriere date,
    serie_card bigint not null,

    constraint cl_cnp_ck check(length(cnp_client)=13 and substr(cnp_client,1,1) in ('1','2','5','6')),
    constraint cl_serie_uk unique (serie_card)
);

-- 4. tabel furnizor
create table furnizor(
    id_furnizor int primary key,
    nume varchar(50) not null,
    adresa varchar(100),
    telefon varchar(13) not null,
    persoana_contact varchar(50) not null
);

-- 5. tabel produs
create table produs(
    id_produs int primary key,
    nume_produs varchar(50) not null,
    pret_unit_achizitie decimal(5,2) not null check (pret_unit_achizitie > 0),
    pret_unit_vanzare decimal(5,2) not null check (pret_unit_vanzare > 0)
);

-- 6. tabel medicament
create table medicament(
    id_produs int primary key,
    substanta_activa varchar(50) not null,
    concentratie varchar(20),
    forma_farmaceutica varchar(30),
    necesita_reteta char(1) default 'n' check (necesita_reteta in ('y', 'n')),

    constraint fk_med_prod foreign key (id_produs) references produs(id_produs) on delete cascade on update cascade
);

-- 7. tabel supliment alimentar
create table supliment_alimentar(
    id_produs int primary key,
    beneficiu_principal varchar(50) not null,
    forma_prezentare varchar(30),
    public_tinta varchar(50),

    constraint fk_sup_prod foreign key (id_produs) references produs(id_produs) on delete cascade on update cascade,
    constraint ck_beneficiu check (beneficiu_principal in ('Imunitate', 'Digestie', 'Articulatii', 'Energie', 'General'))
);

-- 8. tabel cosmetic
create table cosmetic(
    id_produs int primary key,
    functie_principala varchar(40),
    cantitate varchar(20),
    
    constraint fk_cosm_prod foreign key (id_produs) references produs(id_produs) on delete cascade on update cascade
);

-- 9. tabel reteta
create table reteta(
    id_reteta int primary key,
    medic_prescriptor varchar(50) not null,
    data_prescriere date not null
);

-- 10. tabel tranzactie
create table tranzactie(
    id_tranzactie int primary key,
    data_tranzactie date not null,
    cnp_angajat bigint not null,
    cnp_client bigint,
    id_reteta int,

    constraint fk_tr_ang foreign key (cnp_angajat) references angajat(cnp_angajat) on delete cascade on update cascade,
    constraint fk_tr_cl foreign key (cnp_client) references client(cnp_client) on delete cascade on update cascade,
    constraint fk_tr_ret foreign key (id_reteta) references reteta(id_reteta) on delete cascade on update cascade
);

-- 11. tabel detalii_tranzactie
create table detalii_tranzactie (
    id_detaliu_tranzactie int primary key,
    id_tranzactie int not null,
    id_produs int not null,
    cantitate_vanduta int check (cantitate_vanduta > 0),

    constraint fk_det_tr foreign key (id_tranzactie) references tranzactie(id_tranzactie) on delete cascade on update cascade,
    constraint fk_det_prod foreign key (id_produs) references produs(id_produs) on delete cascade on update cascade
);

-- 12. tabel stoc
create table stoc(
    nr_lot int primary key,
    id_produs int not null,
    id_furnizor int not null,
    cantitate_curenta int not null check (cantitate_curenta >= 0),
    data_expirare date not null,

    constraint fk_stoc_prod foreign key (id_produs) references produs(id_produs) on delete cascade on update cascade,
    constraint fk_stoc_furn foreign key (id_furnizor) references furnizor(id_furnizor) on delete cascade on update cascade
);


-- 1. angajat
insert into angajat values (1800101111111, 'Popescu', 'Ion', 'farmacist', str_to_date('01-01-2020','%d-%m-%Y'), '0722111111');
insert into angajat values (1850505222222, 'Ionescu', 'Maria', 'asistent farmacist', str_to_date('15-03-2021','%d-%m-%Y'), '0722222222');
insert into angajat values (1901010333333, 'Georgescu', 'Vlad', 'contabil', str_to_date('20-05-2019','%d-%m-%Y'), '0722333333');
insert into angajat values (2951212444444, 'Dumitrescu', 'Ana', 'farmacist', str_to_date('01-08-2022','%d-%m-%Y'), '0722444444');
insert into angajat values (1880808555555, 'Radu', 'Mihai', 'chimist', str_to_date('10-02-2023','%d-%m-%Y'), '0722555555');
insert into angajat values (2990101666666, 'Stan', 'Elena', 'curatenie', str_to_date('01-01-2024','%d-%m-%Y'), '0722666666');
insert into angajat values (1750505777777, 'Matei', 'Alexandru', 'farmacist', str_to_date('15-11-2018','%d-%m-%Y'), '0722777777');
insert into angajat values (2800303888888, 'Nistor', 'Cristina', 'asistent farmacist', str_to_date('20-09-2020','%d-%m-%Y'), '0722888888');
insert into angajat values (1920404999999, 'Florea', 'George', 'farmacist', str_to_date('05-05-2021','%d-%m-%Y'), '0722999999');
insert into angajat values (2850606000000, 'Dima', 'Simona', 'asistent farmacist', str_to_date('12-12-2022','%d-%m-%Y'), '0722000000');

-- 2. client
insert into client values (1700101111111, 'Avram', 'Dan', '0744111111', str_to_date('01-01-2023','%d-%m-%Y'), 18824);
insert into client values (2800202222222, 'Barbu', 'Alina', '0744222222', str_to_date('15-02-2023','%d-%m-%Y'), 29546);
insert into client values (1900303333333, 'Costea', 'Paul', '0744333333', str_to_date('20-03-2023','%d-%m-%Y'), 46536);
insert into client values (2950404444444, 'Diaconu', 'Ioana', '0744444444', str_to_date('10-04-2023','%d-%m-%Y'), 67415);
insert into client values (1850505555555, 'Enache', 'Sorin', '0744555555', str_to_date('05-05-2023','%d-%m-%Y'), 52998);
insert into client values (2880606666666, 'Filip', 'Carmen', '0744666666', str_to_date('12-06-2023','%d-%m-%Y'), 66473);
insert into client values (1780707777777, 'Grigore', 'Victor', '0744777777', str_to_date('25-07-2023','%d-%m-%Y'), 91398);
insert into client values (2920808888888, 'Hristea', 'Monica', '0744888888', str_to_date('30-08-2023','%d-%m-%Y'), 12206);
insert into client values (1960909999999, 'Iacob', 'Rares', '0744999999', str_to_date('15-09-2023','%d-%m-%Y'), 91478);
insert into client values (2991010000000, 'Luca', 'Diana', '0744000000', str_to_date('01-10-2023','%d-%m-%Y'), 4341);
insert into client values (1880808999111, 'Vasile', 'Bogat', '0799888777', str_to_date('01-11-2023','%d-%m-%Y'), 99101);
insert into client values (2900909888222, 'Ana', 'Cumparatoarea', '0766555444', str_to_date('05-11-2023','%d-%m-%Y'), 99102);

-- 3. furnizor
insert into furnizor values (10, 'Farmaceutica SA', 'Bucuresti', '0212000001', 'Ion Director');
insert into furnizor values (20, 'BioHealth SRL', 'Cluj', '0264000002', 'Maria Manager');
insert into furnizor values (30, 'MediPlus', 'Timisoara', '0256000003', 'Andrei Vanzari');
insert into furnizor values (40, 'PharmaLine', 'Iasi', '0232000004', 'Elena Contact');
insert into furnizor values (50, 'Sanatate Totala', 'Constanta', '0241000005', 'George Agent');
insert into furnizor values (60, 'Natural Plant', 'Brasov', '0268000006', 'Ana Logistic');
insert into furnizor values (70, 'EuroPharm', 'Oradea', '0259000007', 'Mihai Depozit');
insert into furnizor values (80, 'Global Med', 'Craiova', '0251000008', 'Cristina Sef');
insert into furnizor values (90, 'VitaCare', 'Galati', '0236000009', 'Dan Distributie');
insert into furnizor values (100, 'DermoPro', 'Sibiu', '0269000010', 'Simona Relatii');

-- 4. reteta
insert into reteta values (1001, 'Dr. Ionescu', str_to_date('01-11-2023','%d-%m-%Y'));
insert into reteta values (1002, 'Dr. Popa', str_to_date('02-11-2023','%d-%m-%Y'));
insert into reteta values (1003, 'Dr. Stan', str_to_date('03-11-2023','%d-%m-%Y'));
insert into reteta values (1004, 'Dr. Marin', str_to_date('04-11-2023','%d-%m-%Y'));
insert into reteta values (1005, 'Dr. Dumitru', str_to_date('05-11-2023','%d-%m-%Y'));
insert into reteta values (1006, 'Dr. Vasilescu', str_to_date('06-11-2023','%d-%m-%Y'));
insert into reteta values (1007, 'Dr. Gheorghe', str_to_date('07-11-2023','%d-%m-%Y'));
insert into reteta values (1008, 'Dr. Lazar', str_to_date('08-11-2023','%d-%m-%Y'));
insert into reteta values (1009, 'Dr. Munteanu', str_to_date('09-11-2023','%d-%m-%Y'));
insert into reteta values (1010, 'Dr. Urs', str_to_date('10-11-2023','%d-%m-%Y'));

-- 5. echipament
insert into echipament values (1, 1800101111111, 'Casa Marcat 1', 'SN001', str_to_date('01-01-2023','%d-%m-%Y'));
insert into echipament values (2, 1850505222222, 'Casa Marcat 2', 'SN002', str_to_date('01-01-2023','%d-%m-%Y'));
insert into echipament values (3, 1901010333333, 'Laptop Contabilitate', 'SN003', str_to_date('01-06-2023','%d-%m-%Y'));
insert into echipament values (4, 1880808555555, 'Microscop', 'SN004', str_to_date('15-02-2023','%d-%m-%Y'));
insert into echipament values (5, 2990101666666, 'Aspirator Industrial', 'SN005', str_to_date('10-01-2024','%d-%m-%Y'));
insert into echipament values (6, 1750505777777, 'Monitor Prescriptii', 'SN006', str_to_date('20-03-2023','%d-%m-%Y'));
insert into echipament values (7, 2800303888888, 'Scanner Coduri', 'SN007', str_to_date('05-04-2023','%d-%m-%Y'));
insert into echipament values (8, 1920404999999, 'Imprimanta Retete', 'SN008', str_to_date('12-05-2023','%d-%m-%Y'));
insert into echipament values (9, 2850606000000, ' cantar precizie', 'SN009', str_to_date('30-06-2023','%d-%m-%Y'));
insert into echipament values (10, 2951212444444, 'Frigider Medicamente', 'SN010', str_to_date('01-07-2023','%d-%m-%Y'));

-- 6. produs
insert into produs values (101, 'Paracetamol', 5.00, 10.00);
insert into produs values (102, 'Ibuprofen', 8.00, 15.00);
insert into produs values (103, 'Aspirina', 6.00, 12.00);
insert into produs values (104, 'Amoxicilina', 15.00, 30.00);
insert into produs values (105, 'Algocalmin', 7.00, 14.00);
insert into produs values (106, 'Nurofen', 12.00, 24.00);
insert into produs values (107, 'Augmentin', 20.00, 45.00);
insert into produs values (108, 'Coldrex', 18.00, 35.00);
insert into produs values (109, 'Fervex', 16.00, 32.00);
insert into produs values (110, 'No-Spa', 14.00, 28.00);
insert into produs values (111, 'Sirop Tuse', 15.00, 30.00);
insert into produs values (201, 'Vitamina C', 10.00, 20.00);
insert into produs values (202, 'Magneziu', 15.00, 30.00);
insert into produs values (203, 'Calciu', 12.00, 25.00);
insert into produs values (204, 'Omega 3', 30.00, 60.00);
insert into produs values (205, 'Probiotice', 25.00, 50.00);
insert into produs values (206, 'Zinc', 18.00, 36.00);
insert into produs values (207, 'Vitamina D3', 22.00, 44.00);
insert into produs values (208, 'Fier', 20.00, 40.00);
insert into produs values (209, 'Multivitamine', 35.00, 70.00);
insert into produs values (210, 'Colagen', 50.00, 100.00);
insert into produs values (301, 'Crema Fata', 40.00, 80.00);
insert into produs values (302, 'Lotiune Corp', 30.00, 60.00);
insert into produs values (303, 'Sampon', 25.00, 50.00);
insert into produs values (304, 'Balsam', 25.00, 50.00);
insert into produs values (305, 'Apa Micelara', 20.00, 40.00);
insert into produs values (306, 'Ser Fata', 55.00, 110.00);
insert into produs values (307, 'Gel Curatare', 35.00, 70.00);
insert into produs values (308, 'Crema maini', 15.00, 30.00);
insert into produs values (309, 'Protectie Solara', 45.00, 90.00);
insert into produs values (310, 'Deodorant', 12.00, 24.00);
insert into produs values (311, 'Crema Premium', 60.00, 120.00);


-- 7. medicament
insert into medicament values (101, 'Paracetamol', '500mg', 'Comprimate', 'n');
insert into medicament values (102, 'Ibuprofen', '400mg', 'Drajeuri', 'n');
insert into medicament values (103, 'Acid Acetilsalicilic', '500mg', 'Comprimate', 'n');
insert into medicament values (104, 'Amoxicilina', '500mg', 'Capsule', 'y');
insert into medicament values (105, 'Metamizol', '500mg', 'Comprimate', 'y');
insert into medicament values (106, 'Ibuprofen', '200mg', 'Sirop', 'n');
insert into medicament values (107, 'Amoxicilina', '875mg', 'Comprimate', 'y');
insert into medicament values (108, 'Paracetamol', '500mg', 'Plicuri', 'n');
insert into medicament values (109, 'Paracetamol', '500mg', 'Plicuri', 'n');
insert into medicament values (110, 'Drotaverina', '40mg', 'Comprimate', 'n');
insert into medicament values (111, 'Codeina', '100ml', 'Sirop', 'n');


-- 8. supliment_alimentar
insert into supliment_alimentar values (201, 'Imunitate', 'Comprimate', 'General');
insert into supliment_alimentar values (202, 'Energie', 'Efervescente', 'Adulti');
insert into supliment_alimentar values (203, 'Articulatii', 'Comprimate', 'Batrani');
insert into supliment_alimentar values (204, 'General', 'Capsule', 'Adulti');
insert into supliment_alimentar values (205, 'Digestie', 'Plicuri', 'General');
insert into supliment_alimentar values (206, 'Imunitate', 'Capsule', 'Copii');
insert into supliment_alimentar values (207, 'Imunitate', 'Picaturi', 'Copii');
insert into supliment_alimentar values (208, 'Energie', 'Sirop', 'Copii');
insert into supliment_alimentar values (209, 'General', 'Jeleuri', 'Copii');
insert into supliment_alimentar values (210, 'Articulatii', 'Pudra', 'Sportivi');

-- 9. cosmetic
insert into cosmetic values (301, 'Hidratare', '50ml');
insert into cosmetic values (302, 'Hidratare', '250ml');
insert into cosmetic values (303, 'Curatare', '400ml');
insert into cosmetic values (304, 'Ingrijire', '200ml');
insert into cosmetic values (305, 'Demachiere', '500ml');
insert into cosmetic values (306, 'Anti-Age', '30ml');
insert into cosmetic values (307, 'Anti-Acnee', '150ml');
insert into cosmetic values (308, 'Reparare', '75ml');
insert into cosmetic values (309, 'Protectie UV', '50ml');
insert into cosmetic values (310, 'Antiperspirant', '150ml');
insert into cosmetic values (311, 'Hidratare', '50ml');

-- 10. stoc
insert into stoc values (5001, 101, 10, 100, str_to_date('01-01-2025','%d-%m-%Y'));
insert into stoc values (5002, 104, 20, 50, str_to_date('01-06-2024','%d-%m-%Y'));
insert into stoc values (5003, 201, 30, 200, str_to_date('15-12-2024','%d-%m-%Y'));
insert into stoc values (5004, 301, 100, 20, str_to_date('20-11-2025','%d-%m-%Y'));
insert into stoc values (5005, 107, 20, 30, str_to_date('01-03-2024','%d-%m-%Y'));
insert into stoc values (5006, 204, 40, 60, str_to_date('10-10-2024','%d-%m-%Y'));
insert into stoc values (5007, 305, 100, 45, str_to_date('01-01-2026','%d-%m-%Y'));
insert into stoc values (5008, 110, 10, 150, str_to_date('14-02-2025','%d-%m-%Y'));
insert into stoc values (5009, 210, 50, 10, str_to_date('01-09-2024','%d-%m-%Y'));
insert into stoc values (5010, 310, 90, 80, str_to_date('01-05-2025','%d-%m-%Y'));

-- 11. tranzactie
insert into tranzactie values (9001, str_to_date('01-12-2023','%d-%m-%Y'), 1800101111111, 1700101111111, null);
insert into tranzactie values (9002, str_to_date('02-12-2023','%d-%m-%Y'), 1800101111111, 2800202222222, null);
insert into tranzactie values (9003, str_to_date('03-12-2023','%d-%m-%Y'), 2951212444444, 1900303333333, null);
insert into tranzactie values (9004, str_to_date('04-12-2023','%d-%m-%Y'), 2951212444444, 2950404444444, null);
insert into tranzactie values (9005, str_to_date('05-12-2023','%d-%m-%Y'), 1920404999999, 1850505555555, 1001);
insert into tranzactie values (9006, str_to_date('06-12-2023','%d-%m-%Y'), 1920404999999, 2880606666666, 1002);
insert into tranzactie values (9007, str_to_date('07-12-2023','%d-%m-%Y'), 1750505777777, 1780707777777, 1003);
insert into tranzactie values (9008, str_to_date('08-12-2023','%d-%m-%Y'), 1750505777777, 2920808888888, 1004);
insert into tranzactie values (9009, str_to_date('09-12-2023','%d-%m-%Y'), 1800101111111, 1960909999999, 1005);
insert into tranzactie values (9010, str_to_date('10-12-2023','%d-%m-%Y'), 1800101111111, 2991010000000, 1006);
insert into tranzactie values (9011, str_to_date('11-12-2023','%d-%m-%Y'), 1750505777777, 1880808999111, null);
insert into tranzactie values (9012, str_to_date('16-12-2023','%d-%m-%Y'), 2850606000000, 2900909888222, null);

-- 12. detalii_tranzactie

insert into detalii_tranzactie values (1, 9001, 101, 2);
insert into detalii_tranzactie values (2, 9002, 102, 1);
insert into detalii_tranzactie values (3, 9003, 201, 3);
insert into detalii_tranzactie values (4, 9004, 303, 1);
insert into detalii_tranzactie values (5, 9005, 104, 2);
insert into detalii_tranzactie values (6, 9006, 107, 1);
insert into detalii_tranzactie values (7, 9007, 105, 5);
insert into detalii_tranzactie values (8, 9008, 107, 2);
insert into detalii_tranzactie values (9, 9009, 101, 1);
insert into detalii_tranzactie values (10, 9009, 201, 1);
insert into detalii_tranzactie values (11, 9011, 111, 1);
insert into detalii_tranzactie values (12, 9012, 311, 3);

commit;

