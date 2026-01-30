# Pharmacy Management System (Managementul unei Farmacii)

**Student:** Soisun Mina-David  
**Coordinator:** Vasile Silviu Laurențiu  
**Institution:** University of Bucharest, Faculty of Mathematics and Computer Science  
**Course:** Databases (Baze de Date)

## 📖 Project Overview

This project is a comprehensive database management system designed for a pharmacy. It models real-world pharmaceutical operations, including product categorization (OTC vs. prescription drugs), inventory tracking, employee management, and equipment maintenance cycles.

The application features a web-based graphical interface that allows users to perform CRUD operations, execute complex SQL queries, and visualize data through dynamic views.

### 🚀 Motivation
The project differs from standard retail management systems by integrating specific pharmaceutical concepts:
* **Prescription Handling:** Validating transactions that require medical prescriptions.
* **Equipment Maintenance:** Tracking technical revision dates for pharmacy equipment (e.g., scales, microscopes).
* **Specialized Product Hierarchy:** Managing distinct attributes for Medicines, Supplements, and Cosmetics.

---

## 🛠️ Tech Stack

* **Database Engine:** MySQL (managed via MySQL Workbench)
* **Backend:** Node.js (JavaScript)
* **Frontend:** HTML/CSS (Web Interface)
* **Infrastructure:** Docker

---

## ✨ Features

### 1. Database Model & Integrity
The database is fully normalized and enforces strict data integrity:
* **Product Hierarchy:** Products are categorized into **Medicines** (Medicament), **Supplements** (Supliment Alimentar), and **Cosmetics** (Cosmetic).
* **Constraints:** Uses Primary Keys, Foreign Keys, `CHECK` constraints (e.g., prices must be positive), and `UNIQUE` constraints.
* **Cascade Actions:** Implements `ON DELETE CASCADE` to maintain consistency (e.g., deleting an employee automatically removes equipment assigned to them).

### 2. Application Functionalities
* **Interactive UI:**
    * List content from all tables with column-based sorting (ascending/descending).
    * **Edit/Delete** options for every record with confirmation modals.
* **Complex Reporting:**
    * SQL View visualization for "Sales per Product" and "Equipment Responsibilities".
    * Custom filtering logic (e.g., identifying pharmacists selling prescription-only drugs).

---

## 🗄️ Database Schema

The system uses a relational schema. Below are the core tables and their roles:

| Table Name | Description | Key Constraints |
| :--- | :--- | :--- |
| **PRODUS** | Base table for all items | Price > 0 |
| **MEDICAMENT** | Extends Produs | `necesita_reteta` (y/n), `substanta_activa` |
| **ANGAJAT** | Employee data | CNP validation, Role checks |
| **ECHIPAMENT** | Equipment inventory | FK to Angajat (On Delete Cascade) |
| **TRANZACTIE** | Sales records | Links to Angajat, Client, Reteta |
| **CLIENT** | Loyalty program data | Unique Card Series |
| **STOC** | Inventory batches | Expiration dates, Supplier links |

---

## 💻 SQL Implementation Examples

### 1. Complex Join & Filtering
*Extracting information from 4 tables to find Pharmacists who sold prescription-required medicines:*
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
