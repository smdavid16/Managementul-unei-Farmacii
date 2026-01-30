# Pharmacy Management System (Managementul unei Farmacii)

[cite_start]**Student:** Soisun Mina-David [cite: 1085]  
[cite_start]**Coordinator:** Vasile Silviu Laurențiu [cite: 1083]  
[cite_start]**Institution:** University of Bucharest, Faculty of Mathematics and Computer Science [cite: 1077-1078]  
[cite_start]**Course:** Databases (Baze de Date) [cite: 1081]

## 📖 Project Overview

This project is a complete database management system designed for a pharmacy. [cite_start]It models real-world pharmaceutical operations, including product categorization (OTC vs. prescription drugs), inventory tracking, employee management, and equipment maintenance[cite: 1107, 1108].

[cite_start]The application features a web-based graphical interface that allows users to perform CRUD operations, execute complex SQL queries, and visualize data through dynamic views.

### 🚀 Motivation
[cite_start]The project was designed to differentiate from standard store management systems by introducing specific pharmaceutical concepts such as **Prescription (Rețetă)** handling and **Equipment Maintenance (Echipamente)** tracking[cite: 1101, 1102].

---

## 🛠️ Tech Stack

* [cite_start]**Database Engine:** MySQL (managed via MySQL Workbench) [cite: 1104]
* [cite_start]**Backend:** Node.js (JavaScript) 
* [cite_start]**Frontend:** HTML/CSS (Web Interface) 
* [cite_start]**Infrastructure:** Docker 

---

## ✨ Features

### 1. Database Model
The database is normalized and includes the following key entities:
* [cite_start]**Products:** Categorized into **Medicines** (Medicament), **Supplements** (Supliment Alimentar), and **Cosmetics** (Cosmetic)[cite: 1112].
* [cite_start]**Personnel:** Manages **Employees** (Angajat) and their specific roles (Pharmacist, Chemist, Accountant, etc.)[cite: 1162].
* [cite_start]**Sales & Loyalty:** Tracks **Transactions** (Tranzactie) linked to **Clients** via loyalty cards and **Prescriptions** (Reteta) where applicable[cite: 1113, 1115].
* [cite_start]**Inventory & Logistics:** Manages **Stocks** (Stoc) and **Suppliers** (Furnizor)[cite: 1111].
* [cite_start]**Equipment:** Tracks pharmacy equipment and assigned responsible employees[cite: 1114].

### 2. Application Functionalities
* **Interactive UI:**
    * [cite_start]List content from all tables with sorting capabilities (click header to sort asc/desc)[cite: 5, 163].
    * [cite_start]**Edit/Delete** options for every record with confirmation modals[cite: 165, 238].
    * [cite_start]**Cascade Delete:** Deleting an employee automatically removes their assigned equipment records to maintain integrity[cite: 763].
* **Complex Reporting:**
    * [cite_start]SQL View visualization for "Sales per Product" and "Equipment Responsibilities"[cite: 937, 1028].
    * [cite_start]Custom filtering (e.g., showing only Pharmacists selling prescription-only drugs)[cite: 712].

---

## 🗄️ Database Schema

The system uses a relational schema with strict integrity constraints.

### Core Tables
| Table Name | Description | Key Constraints |
| :--- | :--- | :--- |
| **PRODUS** | Base table for all items | [cite_start]Price > 0 [cite: 1405] |
| **MEDICAMENT** | Extends Produs | [cite_start]`necesita_reteta` (y/n) [cite: 1413] |
| **ANGAJAT** | Employee data | [cite_start]CNP validation, Role checks [cite: 1366] |
| **ECHIPAMENT** | Equipment inventory | [cite_start]FK to Angajat (On Delete Cascade) [cite: 1377] |
| **TRANZACTIE** | Sales records | [cite_start]Links to Angajat, Client, Reteta [cite: 1438] |

[cite_start]*(Full schema details available in documentation)*[cite: 1341].

---

## 💻 SQL Implementation Examples

### 1. Complex Join & Filtering
*Extracting information from 3+ tables with multiple conditions:*
```sql
SELECT concat(a.nume, ' ', a.prenume) as nume, 
       t.data_tranzactie, 
       p.nume_produs, 
       m.concentratie, 
       p.pret_unit_vanzare
FROM angajat a 
JOIN tranzactie t USING (cnp_angajat)
JOIN detalii_tranzactie dt USING (id_tranzactie)
JOIN produs p USING (id_produs)
JOIN medicament m USING (id_produs)
WHERE a.functie = 'farmacist' AND m.necesita_reteta = 'y';
