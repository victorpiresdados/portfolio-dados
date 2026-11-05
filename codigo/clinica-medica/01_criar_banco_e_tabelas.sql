IF DB_ID('ClinicaMedica') IS NULL
BEGIN
    CREATE DATABASE ClinicaMedica;
END
GO

USE ClinicaMedica;
GO

IF OBJECT_ID('dbo.Pagamentos', 'U') IS NOT NULL DROP TABLE dbo.Pagamentos;
IF OBJECT_ID('dbo.Exames', 'U') IS NOT NULL DROP TABLE dbo.Exames;
IF OBJECT_ID('dbo.Consultas', 'U') IS NOT NULL DROP TABLE dbo.Consultas;
IF OBJECT_ID('dbo.Convenios', 'U') IS NOT NULL DROP TABLE dbo.Convenios;
IF OBJECT_ID('dbo.Medicos', 'U') IS NOT NULL DROP TABLE dbo.Medicos;
IF OBJECT_ID('dbo.Pacientes', 'U') IS NOT NULL DROP TABLE dbo.Pacientes;
GO

CREATE TABLE dbo.Pacientes (
    IdPaciente INT IDENTITY(1,1) PRIMARY KEY,
    Nome NVARCHAR(100) NOT NULL,
    CPF CHAR(11) UNIQUE NOT NULL,
    DataNascimento DATE NOT NULL,
    Sexo CHAR(1),
    Telefone VARCHAR(20),
    Email VARCHAR(100),
    Cidade NVARCHAR(50),
    Estado CHAR(2),
    DataCadastro DATE DEFAULT GETDATE()
);
GO

CREATE TABLE dbo.Medicos (
    IdMedico INT IDENTITY(1,1) PRIMARY KEY,
    Nome NVARCHAR(100) NOT NULL,
    Especialidade NVARCHAR(80) NOT NULL,
    CRM VARCHAR(20) UNIQUE NOT NULL,
    Telefone VARCHAR(20),
    Email VARCHAR(100)
);
GO

CREATE TABLE dbo.Convenios (
    IdConvenio INT IDENTITY(1,1) PRIMARY KEY,
    NomeConvenio NVARCHAR(80) NOT NULL,
    TipoPlano NVARCHAR(50),
    PercentualCobertura DECIMAL(5,2)
);
GO

CREATE TABLE dbo.Consultas (
    IdConsulta INT IDENTITY(1,1) PRIMARY KEY,
    IdPaciente INT NOT NULL,
    IdMedico INT NOT NULL,
    IdConvenio INT NULL,
    DataConsulta DATE NOT NULL,
    HoraConsulta TIME NOT NULL,
    ValorConsulta DECIMAL(10,2) NOT NULL,
    StatusConsulta NVARCHAR(20) NOT NULL,
    CONSTRAINT FK_Consulta_Paciente FOREIGN KEY (IdPaciente) REFERENCES dbo.Pacientes(IdPaciente),
    CONSTRAINT FK_Consulta_Medico FOREIGN KEY (IdMedico) REFERENCES dbo.Medicos(IdMedico),
    CONSTRAINT FK_Consulta_Convenio FOREIGN KEY (IdConvenio) REFERENCES dbo.Convenios(IdConvenio)
);
GO

CREATE TABLE dbo.Exames (
    IdExame INT IDENTITY(1,1) PRIMARY KEY,
    IdConsulta INT NOT NULL,
    NomeExame NVARCHAR(100) NOT NULL,
    ValorExame DECIMAL(10,2),
    Resultado NVARCHAR(30),
    CONSTRAINT FK_Exame_Consulta FOREIGN KEY (IdConsulta) REFERENCES dbo.Consultas(IdConsulta)
);
GO

CREATE TABLE dbo.Pagamentos (
    IdPagamento INT IDENTITY(1,1) PRIMARY KEY,
    IdConsulta INT NOT NULL,
    FormaPagamento NVARCHAR(30),
    ValorPago DECIMAL(10,2),
    DataPagamento DATE,
    CONSTRAINT FK_Pagamento_Consulta FOREIGN KEY (IdConsulta) REFERENCES dbo.Consultas(IdConsulta)
);
GO
