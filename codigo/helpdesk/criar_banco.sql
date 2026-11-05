CREATE DATABASE HelpdeskDashboard;
GO
USE HelpdeskDashboard;
GO

CREATE TABLE Analistas (
    id_analista INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    equipe VARCHAR(10) NOT NULL
);
GO

CREATE TABLE Tickets (
    id_ticket INT PRIMARY KEY,
    id_analista INT NOT NULL,
    categoria VARCHAR(20) NOT NULL,
    prioridade VARCHAR(20) NOT NULL,
    canal VARCHAR(20) NOT NULL,
    data_abertura DATETIME NOT NULL,
    data_fechamento DATETIME NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_analista) REFERENCES Analistas(id_analista)
);
GO
