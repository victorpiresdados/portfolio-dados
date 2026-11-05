/*
    MODELO CONECTADO PARA POWER BI - SQL SERVER

    Importe somente estas 7 views no Power BI e crie os relacionamentos
    descritos no final do arquivo. Todos os campos calculados ficam no SQL.
*/

CREATE OR ALTER VIEW dbo.vw_DimPaciente
AS
SELECT
    p.IdPaciente,
    p.Nome AS NomePaciente,
    p.DataNascimento,
    p.Sexo,
    p.Cidade,
    p.Estado,
    p.DataCadastro
FROM dbo.Pacientes AS p;
GO

CREATE OR ALTER VIEW dbo.vw_DimMedico
AS
SELECT
    m.IdMedico,
    m.Nome AS NomeMedico,
    m.Especialidade,
    m.CRM
FROM dbo.Medicos AS m;
GO

CREATE OR ALTER VIEW dbo.vw_DimConvenio
AS
SELECT
    c.IdConvenio,
    c.NomeConvenio,
    c.TipoPlano,
    c.PercentualCobertura
FROM dbo.Convenios AS c;
GO

CREATE OR ALTER VIEW dbo.vw_DimData
AS
SELECT DISTINCT
    c.DataConsulta AS Data,
    YEAR(c.DataConsulta) AS Ano,
    MONTH(c.DataConsulta) AS NumeroMes,
    CHOOSE(
        MONTH(c.DataConsulta),
        N'Janeiro', N'Fevereiro', N'Março', N'Abril',
        N'Maio', N'Junho', N'Julho', N'Agosto',
        N'Setembro', N'Outubro', N'Novembro', N'Dezembro'
    ) AS Mes,
    CONCAT(
        YEAR(c.DataConsulta),
        '-',
        RIGHT(CONCAT('0', MONTH(c.DataConsulta)), 2)
    ) AS AnoMes,
    DATEPART(QUARTER, c.DataConsulta) AS Trimestre
FROM dbo.Consultas AS c;
GO

CREATE OR ALTER VIEW dbo.vw_FatoConsultas
AS
SELECT
    c.IdConsulta,
    c.IdPaciente,
    c.IdMedico,
    c.IdConvenio,
    c.DataConsulta,
    c.HoraConsulta,
    c.StatusConsulta,
    c.ValorConsulta,

    CAST(1 AS int) AS QtdConsulta,

    CASE
        WHEN c.StatusConsulta = N'Realizada' THEN 1
        ELSE 0
    END AS QtdRealizada,

    CASE
        WHEN c.StatusConsulta = N'Cancelada' THEN 1
        ELSE 0
    END AS QtdCancelada,

    CASE
        WHEN c.StatusConsulta = N'Não Compareceu' THEN 1
        ELSE 0
    END AS QtdNaoCompareceu,

    CASE
        WHEN c.StatusConsulta = N'Realizada' THEN c.ValorConsulta
        ELSE CAST(0 AS decimal(10,2))
    END AS ReceitaRealizada,

    CASE
        WHEN c.StatusConsulta IN (N'Cancelada', N'Não Compareceu')
            THEN c.ValorConsulta
        ELSE CAST(0 AS decimal(10,2))
    END AS PerdaPotencial,

    CASE
        WHEN c.HoraConsulta < CAST('12:00:00' AS time) THEN N'Manhã'
        WHEN c.HoraConsulta < CAST('18:00:00' AS time) THEN N'Tarde'
        ELSE N'Noite'
    END AS Turno,

    CASE
        WHEN c.ValorConsulta <= 250.00 THEN N'Até R$ 250'
        WHEN c.ValorConsulta <= 400.00 THEN N'De R$ 250,01 a R$ 400'
        ELSE N'Acima de R$ 400'
    END AS FaixaValor
FROM dbo.Consultas AS c;
GO

CREATE OR ALTER VIEW dbo.vw_FatoExames
AS
SELECT
    e.IdExame,
    e.IdConsulta,
    e.NomeExame,
    e.ValorExame,
    e.Resultado,
    CAST(1 AS int) AS QtdExame,
    CASE
        WHEN e.Resultado = N'Em Análise' THEN 1
        ELSE 0
    END AS QtdEmAnalise
FROM dbo.Exames AS e;
GO

CREATE OR ALTER VIEW dbo.vw_FatoPagamentos
AS
SELECT
    p.IdPagamento,
    p.IdConsulta,
    p.FormaPagamento,
    p.ValorPago,
    p.DataPagamento,
    CAST(1 AS int) AS QtdPagamento,
    CASE
        WHEN p.DataPagamento IS NULL THEN 1
        ELSE 0
    END AS QtdSemData
FROM dbo.Pagamentos AS p;
GO

/*
    RELACIONAMENTOS NO POWER BI (cardinalidade 1:*):

    vw_DimPaciente[IdPaciente]  1 -> * vw_FatoConsultas[IdPaciente]
    vw_DimMedico[IdMedico]      1 -> * vw_FatoConsultas[IdMedico]
    vw_DimConvenio[IdConvenio]  1 -> * vw_FatoConsultas[IdConvenio]
    vw_DimData[Data]             1 -> * vw_FatoConsultas[DataConsulta]
    vw_FatoConsultas[IdConsulta] 1 -> * vw_FatoExames[IdConsulta]
    vw_FatoConsultas[IdConsulta] 1 -> * vw_FatoPagamentos[IdConsulta]

    Direcao de filtro:
    - Dimensoes -> FatoConsultas: unica.
    - FatoConsultas -> Exames/Pagamentos: unica.

    Para os visuais, use Soma nos campos Qtd*, ReceitaRealizada,
    PerdaPotencial, ValorExame e ValorPago. Nenhuma medida DAX e necessaria.
*/
