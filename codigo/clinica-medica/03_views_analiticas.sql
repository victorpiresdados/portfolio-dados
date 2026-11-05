/*
    Views para consumo no Power BI
    Execute este arquivo no banco de dados da clinica no SQL Server.
    Cada lote e separado por GO porque CREATE OR ALTER VIEW deve iniciar o lote.

    Observacao: uma view nao garante ordenacao. Configure a classificacao
    dos visuais no Power BI usando as colunas numericas correspondentes.
*/

CREATE OR ALTER VIEW dbo.vw_01_Pacientes
AS
SELECT
    pc.Nome,
    pc.Sexo,
    pc.Cidade,
    pc.Estado
FROM dbo.Pacientes AS pc;
GO

CREATE OR ALTER VIEW dbo.vw_02_CidadesAtendidas
AS
SELECT DISTINCT
    pc.Cidade
FROM dbo.Pacientes AS pc;
GO

CREATE OR ALTER VIEW dbo.vw_03_MedicosPorEspecialidade
AS
SELECT
    md.Nome,
    md.Especialidade,
    md.CRM
FROM dbo.Medicos AS md;
GO

CREATE OR ALTER VIEW dbo.vw_04_TiposPlano
AS
SELECT
    cv.NomeConvenio,
    cv.TipoPlano,
    cv.PercentualCobertura
FROM dbo.Convenios AS cv;
GO

CREATE OR ALTER VIEW dbo.vw_05_FaturamentoDiario
AS
SELECT
    cs.DataConsulta,
    cs.StatusConsulta,
    COUNT(*) AS Qtd,
    SUM(cs.ValorConsulta) AS Valor_Total
FROM dbo.Consultas AS cs
WHERE cs.StatusConsulta = N'Realizada'
GROUP BY
    cs.StatusConsulta,
    cs.DataConsulta;
GO

CREATE OR ALTER VIEW dbo.vw_06_ConsultasValorElevado
AS
SELECT
    cs.IdConsulta,
    cs.ValorConsulta
FROM dbo.Consultas AS cs
WHERE cs.ValorConsulta > 500;
GO

CREATE OR ALTER VIEW dbo.vw_07_ConsultasPeriodo2025
AS
SELECT
    cs.IdConsulta,
    cs.DataConsulta
FROM dbo.Consultas AS cs
WHERE cs.DataConsulta >= '20250101'
  AND cs.DataConsulta <  '20260101';
GO

CREATE OR ALTER VIEW dbo.vw_08_ConsultasProblematicas
AS
SELECT
    cs.IdConsulta,
    cs.StatusConsulta
FROM dbo.Consultas AS cs
WHERE cs.StatusConsulta IN (N'Cancelada', N'Não Compareceu');
GO

CREATE OR ALTER VIEW dbo.vw_09_ExamesEmAnalise
AS
SELECT
    ex.IdExame,
    ex.NomeExame,
    ex.ValorExame,
    ex.Resultado
FROM dbo.Exames AS ex
WHERE ex.Resultado = N'Em Análise';
GO

CREATE OR ALTER VIEW dbo.vw_10_PagamentosSemData
AS
SELECT
    pg.IdPagamento,
    pg.DataPagamento
FROM dbo.Pagamentos AS pg
WHERE pg.DataPagamento IS NULL;
GO

CREATE OR ALTER VIEW dbo.vw_11_TotalPacientes
AS
SELECT
    COUNT_BIG(*) AS Qtd_Pacientes
FROM dbo.Pacientes;
GO

CREATE OR ALTER VIEW dbo.vw_12_TotalConsultas
AS
SELECT
    COUNT_BIG(*) AS Qtd_Consultas
FROM dbo.Consultas;
GO

CREATE OR ALTER VIEW dbo.vw_13_ConsultasPorStatus
AS
SELECT
    cs.StatusConsulta,
    COUNT_BIG(*) AS Qtd_Consultas
FROM dbo.Consultas AS cs
GROUP BY cs.StatusConsulta;
GO

CREATE OR ALTER VIEW dbo.vw_14_ValorMedioConsultas
AS
SELECT
    AVG(cs.ValorConsulta) AS ValorMedioConsulta
FROM dbo.Consultas AS cs;
GO

CREATE OR ALTER VIEW dbo.vw_15_ReceitaConsultasRealizadas
AS
SELECT
    SUM(cs.ValorConsulta) AS Valor_Total
FROM dbo.Consultas AS cs
WHERE cs.StatusConsulta = N'Realizada';
GO

CREATE OR ALTER VIEW dbo.vw_16_PerdaPotencialAgenda
AS
SELECT
    SUM(cs.ValorConsulta) AS Valor_Total
FROM dbo.Consultas AS cs
WHERE cs.StatusConsulta IN (N'Cancelada', N'Não Compareceu');
GO

CREATE OR ALTER VIEW dbo.vw_17_EstatisticasValorConsultas
AS
SELECT
    MIN(cs.ValorConsulta) AS Valor_Min,
    MAX(cs.ValorConsulta) AS Valor_Max,
    AVG(cs.ValorConsulta) AS Valor_Medio
FROM dbo.Consultas AS cs;
GO

CREATE OR ALTER VIEW dbo.vw_18_PacientesPorCidade
AS
SELECT
    pc.Cidade,
    COUNT_BIG(*) AS Qtd
FROM dbo.Pacientes AS pc
GROUP BY pc.Cidade;
GO

CREATE OR ALTER VIEW dbo.vw_19_MedicosQuantidadePorEspecialidade
AS
SELECT
    md.Especialidade,
    COUNT_BIG(*) AS Qtd
FROM dbo.Medicos AS md
GROUP BY md.Especialidade;
GO

CREATE OR ALTER VIEW dbo.vw_20_ExamesMaisSolicitados
AS
SELECT
    ex.NomeExame,
    COUNT_BIG(*) AS Qtd
FROM dbo.Exames AS ex
GROUP BY ex.NomeExame;
GO

CREATE OR ALTER VIEW dbo.vw_21_Top5ReceitaPorExame
AS
SELECT TOP (5)
    ex.NomeExame,
    SUM(ex.ValorExame) AS Valor_Total
FROM dbo.Exames AS ex
GROUP BY ex.NomeExame
ORDER BY SUM(ex.ValorExame) DESC;
GO

CREATE OR ALTER VIEW dbo.vw_22_PagamentosPorForma
AS
SELECT
    pg.FormaPagamento,
    COUNT_BIG(*) AS Qtd,
    SUM(pg.ValorPago) AS Valor_Pago
FROM dbo.Pagamentos AS pg
WHERE pg.FormaPagamento IS NOT NULL
GROUP BY pg.FormaPagamento;
GO

CREATE OR ALTER VIEW dbo.vw_23_CidadesMais100Pacientes
AS
SELECT
    pc.Cidade,
    COUNT_BIG(*) AS Qtd
FROM dbo.Pacientes AS pc
GROUP BY pc.Cidade
HAVING COUNT_BIG(*) > 100;
GO

CREATE OR ALTER VIEW dbo.vw_24_ConsultasPorAno
AS
SELECT
    YEAR(cs.DataConsulta) AS Ano,
    COUNT_BIG(*) AS Qtd
FROM dbo.Consultas AS cs
GROUP BY YEAR(cs.DataConsulta);
GO

CREATE OR ALTER VIEW dbo.vw_25_ConsultasPorMes2025
AS
SELECT
    MONTH(cs.DataConsulta) AS Mes,
    COUNT_BIG(*) AS Qtd
FROM dbo.Consultas AS cs
WHERE cs.DataConsulta >= '20250101'
  AND cs.DataConsulta <  '20260101'
GROUP BY MONTH(cs.DataConsulta);
GO

CREATE OR ALTER VIEW dbo.vw_26_ReceitaMensalConsultas
AS
SELECT
    YEAR(cs.DataConsulta) AS Ano,
    MONTH(cs.DataConsulta) AS Mes,
    SUM(cs.ValorConsulta) AS Receita
FROM dbo.Consultas AS cs
WHERE cs.StatusConsulta = N'Realizada'
GROUP BY
    YEAR(cs.DataConsulta),
    MONTH(cs.DataConsulta);
GO

CREATE OR ALTER VIEW dbo.vw_27_ConsultasPorTurno
AS
SELECT
    CASE
        WHEN cs.HoraConsulta < CAST('12:00:00' AS time) THEN N'Manhã'
        WHEN cs.HoraConsulta < CAST('18:00:00' AS time) THEN N'Tarde'
        ELSE N'Noite'
    END AS Turno,
    COUNT_BIG(*) AS Qtd
FROM dbo.Consultas AS cs
GROUP BY
    CASE
        WHEN cs.HoraConsulta < CAST('12:00:00' AS time) THEN N'Manhã'
        WHEN cs.HoraConsulta < CAST('18:00:00' AS time) THEN N'Tarde'
        ELSE N'Noite'
    END;
GO

CREATE OR ALTER VIEW dbo.vw_28_ConsultasPorFaixaValor
AS
SELECT
    CASE
        WHEN cs.ValorConsulta <= 250.00 THEN N'Até R$ 250'
        WHEN cs.ValorConsulta <= 400.00 THEN N'De R$ 250,01 a R$ 400'
        ELSE N'Acima de R$ 400'
    END AS Faixa_Consulta,
    COUNT_BIG(*) AS Qtd_Consultas
FROM dbo.Consultas AS cs
GROUP BY
    CASE
        WHEN cs.ValorConsulta <= 250.00 THEN N'Até R$ 250'
        WHEN cs.ValorConsulta <= 400.00 THEN N'De R$ 250,01 a R$ 400'
        ELSE N'Acima de R$ 400'
    END;
GO
