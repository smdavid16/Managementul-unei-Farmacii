const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json());

// --- Conexiunea la baza de date ---
const db = mysql.createConnection({
    host: '10.240.97.91',
    user: 'david',         
    password: 'admin',
    database: 'farmacie'
});

db.connect((err) => {
    if (err) {
        console.error('Nu merge conexiunea:', err.message);
    } else {
        console.log('Conectat!');
    }
});


// a) Listare continut
app.get('/api/list', (req, res) => {
    const table = req.query.table;
    const sortCol = req.query.sort || 'id';
    const sortOrder = req.query.order || 'ASC';

    // Security check for table, column, AND sort order
    if (!/^[a-zA-Z0-9_]+$/.test(table) || 
        !/^[a-zA-Z0-9_]+$/.test(sortCol) || 
        !/^(ASC|DESC|asc|desc)$/.test(sortOrder)) {
        return res.status(400).send("Invalid parameters");
    }

    const sql = `SELECT * FROM ${table} ORDER BY ${sortCol} ${sortOrder}`; 
    
    db.query(sql, (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).send(err.message);
        }
        res.json(result);
    });
});

// b) Update si Delete 
app.delete('/api/delete/:table/:idCol/:idVal', (req, res) => {
    const { table, idCol, idVal } = req.params;
    // tabelele permise
    const allowedTables = ['angajat', 'client', 'furnizor', 'echipament', 'produs', 
                           'medicament', 'supliment_alimentar', 'cosmetic', 'stoc', 
                           'reteta', 'tranzactie', 'detalii_tranzactie', 'v_responsabili_echipamente'];

    if (!allowedTables.includes(table)) {
        return res.status(400).send("Tabel invalid");
    }

    // Schelet comanda delete
    const sql = `DELETE FROM ${table} WHERE ${idCol} = ?`;

    db.query(sql, [idVal], (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).send(err.message);
        }
        res.send("Deleted");
    });
});

// c) Cerere complexa
app.get('/api/complex-query-1', (req, res) => {
    // TRE SA SCHIMB ASTA
    const sql = "SELECT 1 as test"; 
    db.query(sql, (err, result) => {
        if (err) return res.status(500).send(err.message);
        res.json(result);
    });
});

// BRESA DE SECURITATE: comenzi sql efective
app.post('/api/run-sql', (req, res) => {
    const { query } = req.body;
    
    if (!query) return res.status(400).json({ error: "Cererea nu poate fi goala" });

    db.query(query, (err, result) => {
        if (err) {
            // Returnez erorarea ca json ca sa poata html sa o afiseze
            return res.status(400).json({ error: err.message });
        }
        // Returnez rezultat ca sa fie afisat de html
        res.json(result);
    });
});

app.put('/api/update', (req, res) => {
    const { table, pkCol, pkVal, colName, value } = req.body;

    const allowedTables = ['angajat', 'client', 'furnizor', 'echipament', 'produs', 
                           'medicament', 'supliment_alimentar', 'cosmetic', 'stoc', 
                           'reteta', 'tranzactie', 'detalii_tranzactie', 'v_responsabili_echipamente'];

    if (!allowedTables.includes(table)) {
        return res.status(400).json({ error: "Invalid table name" });
    }

    if (!/^[a-zA-Z0-9_]+$/.test(colName)) {
        return res.status(400).json({ error: "Coloana invalida" });
    }

    const sql = `UPDATE ${table} SET ${colName} = ? WHERE ${pkCol} = ?`;

    db.query(sql, [value, pkVal], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ success: true });
    });
});

app.listen(3000, () => {
    console.log('Server functioneaza pe portul 3000');
});